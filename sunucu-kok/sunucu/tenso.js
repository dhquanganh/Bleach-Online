'use strict';
const {Y,tablo,satir,json,cv,gunluk}=require('./paket');
const rows=()=>tablo('ExpDuplicate').liste.slice().sort((a,b)=>a._id-b._id);
function armies(row){
  const index=rows().findIndex(r=>r._id===row._id);
  return tablo('EnemyArmy').liste.filter(a=>a._id>=21100001+index*100&&a._id<=21100005+index*100);
}
function state(d){
  const daily=gunluk(d);
  const e=daily.expd||(daily.expd={});
  e.kul=Math.max(0,Math.floor(Number(e.kul)||0));
  e.yenile=e.yenile||{};e.armies=e.armies||{};
  for(const row of rows()){
    e.yenile[row._id]=Math.max(0,Math.floor(Number(e.yenile[row._id])||0));
    if(!armies(row).some(a=>a._id===e.armies[row._id]))e.armies[row._id]=armies(row)[0]?._id;
  }
  return e;
}
function army(d,row){return satir('EnemyArmy',state(d).armies[row._id]);}
function skills(a){
  const out=new Set();
  for(const lane of ['front','middle','back'])for(const id of json(a[lane],{})[lane]||[]){
    const enemy=satir('Enemy',id);
    for(const effect of json(enemy?.attrPower,[])||[])for(const skill of effect.skill||[])if(satir('SkillConfig',skill))out.add(skill);
  }
  return [...out];
}
function experience(row,level,vip=0){
  const need=Number(satir('HeroExp',level)?.f0)||0;
  return Math.floor((Math.pow(level,1.25)+0.625*need*(Number(cv(61400001,0.05))+vip*Number(cv(61400002,0.01))+row.diffArg)/level+1500*level)/1000)*1000;
}
function rewards(row,a,level,vip,rng=Math.random){
  const out=[{type:2,code:0,amount:experience(row,level,vip)}];
  const award=satir('Award',a.awardId);
  out.push(...(json(award?.fixed,{}).fixed||[]));
  // Condition the original cumulative distribution on a nonempty drop.
  // Tensō victories always grant gems; the old 50% empty Coupon tier is excluded.
  let previous=0;
  const tiers=(json(award?.f1,{}).rewards||[]).map(t=>{
    const weight=Math.max(0,Number(t.rate)-previous);previous=Number(t.rate);
    return {...t,weight};
  }).filter(t=>t.weight>0&&(t.value||[]).some(r=>r.type===0&&r.code===2&&r.amount>0));
  let roll=Math.max(0,Math.min(0.999999999,rng()))*tiers.reduce((sum,t)=>sum+t.weight,0);
  const tier=tiers.find(t=>{roll-=t.weight;return roll<0;})||tiers.at(-1);
  if(tier)out.push(...tier.value);
  return out.map(reward=>reward.type===0&&reward.code===2
    ? {type:1,code:14900001,amount:reward.amount} : reward);
}
function init(d){const e=state(d),r=rows(),w=new Y().i32(e.kul).i16(r.length);for(const row of r)w.i32(e.armies[row._id]);return w.done();}
function detail(d,row){const e=state(d),s=skills(army(d,row)),w=new Y().i32(0).i32(row._id).i32(e.yenile[row._id]||0).i16(s.length);for(const id of s)w.i32(id);return w.done();}
function kur({ekSonra,odulVer,paraHarca,seviye,tensoAccount}){
  const error=n=>new Y().i32(n).done();
  const account=tensoAccount||(()=>JSON.parse(require('fs').readFileSync(require('./runtime-path')('veri.json'),'utf8')));
  const validate=(payload,v,d)=>{
    if(!Buffer.isBuffer(payload)||payload.length!==4)return null;
    const row=satir('ExpDuplicate',payload.readUInt32BE(0));
    const rebirth=require('./reincarnation').record(d,seviye.anaId());
    return row&&Math.max(seviye.anaDurum(v).lv,rebirth.history)>=row.lvLimit?row:null;
  };
  const H={};
  H['0x01818400']=({durum,kaydet})=>{const p=init(durum);kaydet(durum);return p;};
  H['0x01818401']=({payload,durum,kaydet})=>{const row=validate(payload,account(),durum);if(!row)return error(4);const p=detail(durum,row);kaydet(durum);return p;};
  H['0x01818402']=({payload,durum,kaydet})=>{
    const row=validate(payload,account(),durum);if(!row)return error(4);
    const e=state(durum);if(e.kul>=Number(cv(61400004,10)))return error(1);
    const n=e.yenile[row._id]||0,prices=cv(61400003,[1]);
    const choices=armies(row).filter(a=>a._id!==e.armies[row._id]);if(!choices.length)return error(4);
    const cost=Number(prices[Math.min(n,prices.length-1)]);if(!Number.isFinite(cost)||cost<0)return error(4);
    const money=cost?paraHarca([{type:0,code:1,amount:cost}]):null;if(cost&&!money)return error(16);
    e.armies[row._id]=choices[Math.floor(Math.random()*choices.length)]._id;e.yenile[row._id]=n+1;
    kaydet(durum);if(money)ekSonra(0x01180105,money,'TENSO-cost');
    // Apply the army before its skills: InitRet clears cached skills on army changes.
    ekSonra(0x01188402,detail(durum,row),'TENSO-skills');
    return {id:0x01188400,payload:init(durum)};
  };
  H['0x01818403']=({payload,durum,kaydet})=>{
    const v=account(),row=validate(payload,v,durum);if(!row)return error(4);
    const e=state(durum);if(e.kul>=Number(cv(61400004,10)))return error(1);
    const a=army(durum,row),battle=require('./savas'),codec=require('./kodek');
    const units=battle.stageArmyDusmanlari([a._id]);if(!units.length)return error(4);
    // Generate before charging; never substitute a replay or a synthetic win.
    let report;
    try{report=battle.kadroRapor(0,null,{ad:a.name,birimler:units},{playerState:durum,scaleEnemy:false,reportLossWhenDefeated:true,requireEnemyDefeated:true});}
    catch(error){console.error('[TENSO] battle rejected:',error.message);return new Y().i32(1).done();}
    if(!report)return error(1);
    const money=paraHarca([{type:0,code:0,amount:row.needSilver}]);if(!money)return error(16);
    e.kul++;
    const award=report.won?rewards(row,a,seviye.anaDurum(v).lv,Number(v.vipLevel)||0):[];
    ekSonra(0x01180105,money,'TENSO-cost');
    ekSonra(codec.OP.REPORT,report.payload,'TENSO-report');
    ekSonra(codec.OP.RESULT,codec.encodeSingleResult(report.won,award),'TENSO-result');
    odulVer(durum,award);kaydet(durum);
    ekSonra(0x01188404,new Y().i32(e.kul).done(),'TENSO-count');
    return error(0);
  };
  return H;
}
module.exports={kur,state,rows,armies,army,skills,experience,rewards,init,detail};
