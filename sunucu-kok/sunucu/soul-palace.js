'use strict';
const {Y,cv,gun,json,satir,tablo}=require('./paket'),config=require('./soul-palace-config'),zlib=require('node:zlib');
const fail=n=>new Y().u32(n).done();
function rewards(f,rng=Math.random){const out=[...f.rewards];for(const pool of f.randomRewards||[])if(rng()<=pool.rate)out.push(...pool.value);return out.slice(0,16);}
function state(d,c=config.read()){
 const k=d.kule||={kat:0,integral:0,chest:0};if(!k.progress||typeof k.progress!=='object'||Array.isArray(k.progress))k.progress={};
 if(!Object.keys(k.progress).length&&Number(k.kat)>0)k.progress[k.lockedTowerId||c.towers[0].id]=Number(k.kat);
 if(!Array.isArray(k.cleared)){k.cleared=[];for(const t of c.towers)for(const f of t.floors.slice(0,Math.max(0,Number(k.progress[t.id])||0)))k.cleared.push(f.id);}
 if(k.day!==gun()){k.day=gun();k.pve=0;k.pveBuy=0;k.akey=false;k.dailyTower=0;}
 if(!Array.isArray(k.claimed))k.claimed=[];k.pve=Math.max(0,Math.min(255,Number(k.pve)||0));k.pveBuy=Math.max(0,Math.min(255,Number(k.pveBuy)||0));return k;
}
function describe(d,c=config.read(),level=require('./seviye').anaDurum(require('./seviye').veriOku()).lv){
 const k=state(d,c);return {revision:c.revision,locked:k.dailyTower||0,towers:c.towers.map((t,i)=>({id:t.id,name:t.name,openLevel:t.openLevel,unlocked:level>=t.openLevel,tag:i+1,floors:t.floors.map(f=>({id:f.id,name:f.name,clear:k.cleared.includes(f.id),model:f.units[0].id,level:f.units[0].level}))}))};
}
function packet(d,c=config.read()){
 const k=state(d,c),compressed=zlib.deflateSync(Buffer.from(JSON.stringify(describe(d,c))));
 // Keep the native prefix for older clients; new clients rebuild the entire catalog from the extension.
 const original=tablo('City').liste.filter(t=>t.type===4),w=new Y().u32(0).u8(k.pve).u8(0).u8(k.pveBuy).u8(0).bool(k.akey).u16(original.length);
 for(const t of original)w.u32(t._id).u8(0);
 return w.u16(0).u16(0).u32(compressed.length).raw(compressed).done();
}
function units(f){const battle=require('./savas');return f.units.map(row=>{
 const enemy=satir('Enemy',row.id);const unit=enemy?battle.dusmanBirim({...enemy,id:row.id.toString(16)},row.pos):battle.heroBirim(row.id,row.pos,row.level,null,null,0,true);
 if(!unit)throw Error('Invalid palace combat unit '+row.id);
 return {...unit,camp:1,pos:row.pos,level:row.level,hp:row.hp,maxHp:row.hp,atk:row.atk,def:row.def,speed:row.speed};
});}
function challenge(ctx,y,opt={}){
 const p=ctx.payload;if(!Buffer.isBuffer(p)||p.length!==10||p[0]!==1||p[1]!==0)return {error:fail(4)};
 const c=config.read(),d=structuredClone(ctx.durum),k=state(d,c),tower=c.towers.find(t=>t.id===p.readUInt32BE(2)),floor=tower?.floors.find(f=>f.id===p.readUInt32BE(6));
 const lv=opt.level??require('./seviye').anaDurum(require('./seviye').veriOku()).lv;
 if(!tower||!floor||lv<tower.openLevel||k.dailyTower&&k.dailyTower!==tower.id)return {error:fail(4)};
 const index=tower.floors.indexOf(floor);if(k.cleared.includes(floor.id)||index>0&&!k.cleared.includes(tower.floors[index-1].id))return {error:fail(4)};
 if(k.pve>=Number(cv(60340001,25))+k.pveBuy)return {error:fail(1)};
 const r=opt.simulate?opt.simulate(floor,d):require('./savas').kadroRapor(0,null,{birimler:units(floor),ad:floor.name},{playerState:d,scaleEnemy:false,forceWin:false,reportLossWhenDefeated:true,requireEnemyDefeated:true,battleDataVersion:4,strictSkillTargets:true});
 if(!r||!Buffer.isBuffer(r.payload)||typeof r.won!=='boolean')return {error:fail(1)};
 k.pve++;k.dailyTower=tower.id;k.lockedTowerId=tower.id;
 if(r.won&&!k.cleared.includes(floor.id)){k.cleared.push(floor.id);if(y.olay)y.olay.say(d,'trialWin',1);}
 k.progress[tower.id]=tower.floors.filter(f=>k.cleared.includes(f.id)).length;k.kat=k.progress[tower.id];k.integral=k.cleared.length;
 try{ctx.kaydet(d);}catch(e){return {error:fail(1)};}
 Object.assign(ctx.durum,d);const awarded=r.won?rewards(floor,opt.random):[];if(awarded.length){y.odulVer(ctx.durum,awarded);ctx.kaydet(ctx.durum);}
 return {ack:new Y().u32(0).raw(p).done(),report:r.payload,result:require('./kodek').encodeSingleResult(r.won,awarded),state:packet(ctx.durum,c),won:r.won};
}
function kur(y){
 const handlers={};
 handlers['0x01810211']=ctx=>{if(ctx.payload.length)return fail(4);const p=packet(ctx.durum);ctx.kaydet(ctx.durum);return {id:0x01180212,payload:p};};
 handlers['0x01810a02']=ctx=>{
  if(ctx.payload.length!==1||ctx.payload[0]!==1)return fail(4);const d=structuredClone(ctx.durum),k=state(d),prices=cv(60340002,[100]);if(k.pveBuy>=prices.length)return fail(1);
  const costs=[{type:0,code:1,amount:prices[k.pveBuy]}],charged=y.paraHarca(costs);if(!charged)return fail(16);k.pveBuy++;
  try{ctx.kaydet(d);}catch(e){y.paraIcinOdul(costs);return fail(1);}Object.assign(ctx.durum,d);y.ekSonra(0x01180105,charged,'PALACE-cost');return new Y().u32(0).u8(1).u8(k.pve).u8(k.pveBuy).done();
 };
 // PvP salary is unavailable without real occupiers; no free reward from repeated requests.
 handlers['0x01810a05']=()=>fail(1);
 handlers['0x01810a04']=ctx=>{
  if(ctx.payload.length)return fail(4);const c=config.read(),d=structuredClone(ctx.durum),k=state(d,c);
  const t=c.towers.find(t=>t.id===(k.dailyTower||k.lockedTowerId));if(k.akey||!t)return fail(1);
  const awarded=t.floors.filter(f=>k.cleared.includes(f.id)).flatMap(f=>rewards(f)).filter(r=>r.type===1);if(!awarded.length)return fail(1);
  const costs=[{type:0,code:1,amount:Number(cv(60340004,100))}],charged=y.paraHarca(costs);if(!charged)return fail(16);
  k.akey=true;k.dailyTower=t.id;try{ctx.kaydet(d);}catch(e){y.paraIcinOdul(costs);return fail(1);}Object.assign(ctx.durum,d);
  y.ekSonra(0x01180105,charged,'PALACE-sweep-cost');y.odulVer(ctx.durum,awarded);ctx.kaydet(ctx.durum);return new Y().u32(0).odul(awarded).done();
 };
 handlers['0x01810a06']=ctx=>{const k=state(ctx.durum);return {id:0x01180a07,payload:new Y().u32(0).u16(k.cleared.length).u32(k.chest||0).done()};};
 handlers['0x01810a07']=ctx=>{
  if(ctx.payload.length!==4)return {id:0x01180a08,payload:fail(4)};const id=ctx.payload.readUInt32BE(0),row=satir('TemplePliesNumber',id),d=structuredClone(ctx.durum),k=state(d);
  if(!row||k.cleared.length<row.numberPlies||k.claimed.includes(id)||k.chest>=id)return {id:0x01180a08,payload:fail(1)};
  const rewards=json(satir('Award',row.awardID)?.fixed,{}).fixed||[];if(!rewards.length)return {id:0x01180a08,payload:fail(4)};
  k.claimed.push(id);k.chest=id;try{ctx.kaydet(d);}catch(e){return {id:0x01180a08,payload:fail(1)};}Object.assign(ctx.durum,d);y.odulVer(ctx.durum,rewards);ctx.kaydet(ctx.durum);return {id:0x01180a08,payload:new Y().u32(0).u32(id).done()};
 };return {handlers};
}
module.exports={state,describe,packet,units,challenge,kur,rewards};
