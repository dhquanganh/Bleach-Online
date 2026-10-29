'use strict';
// Reincarnation protocol and rules, sourced from the live Flash classes and ConfigValue.
const {Y,cv,tablo,satir,gunluk}=require('./paket');
const levels=require('./seviye');
const inventory=require('./envanter');
const MAX=()=>Number(cv(61700016,5));
const error=n=>new Y().u32(n).done();
function record(d,id){
  const raw=d && d.yenidenDogus && d.yenidenDogus.hero && d.yenidenDogus.hero[String(id)] || {};
  const n=Math.max(0,Math.min(MAX(),Math.floor(Number(raw.n)||0)));
  return {n,pp:n?Math.max(1,Math.min(5,Number(raw.pp)||1)):0,ae:n?Math.max(1,Math.min(10,Number(raw.ae)||1)):0,history:Math.max(0,Number(raw.history)||0)};
}
function statMultiplier(d,id){return 1+record(d,id).n;}
function fragmentId(id){
 if(id===levels.anaId())return 0;
 const row=satir('HeroChangeAttr',id),code=Number(row&&row.chipValue)||0;
 return code&&satir('Article',code)?code:0;
}
function store(d,id,r){d.yenidenDogus=d.yenidenDogus||{};d.yenidenDogus.hero=d.yenidenDogus.hero||{};d.yenidenDogus.hero[String(id)]=r;}
function owned(d,id,v){
  if(!satir('BaseHero',id))return false;
  return id===levels.anaId() || v.tumKarakterler===true || v.tumKarakterler==='true' ||
    (v.herolar||[]).map(Number).includes(id) || !!(d.meyhane && d.meyhane.alinan && d.meyhane.alinan[String(id)]) ||
    !!(d.seviye && d.seviye.herolar && d.seviye.herolar[String(id)]) || Number((d.kadro||{})[String(id)])>0;
}
const allExp=lv=>{const row=satir('HeroExp',lv);return row?BigInt(row.f1||0)*4294967296n+BigInt(row.f2||0):0n;};
function afterLevel(lv,exp,n){
  const costs=cv(61700002,[]);
  if(n<0||n>=MAX()||costs[n]===undefined)return null;
  const remaining=allExp(lv-1)+BigInt(Math.floor(exp))-BigInt(costs[n]);
  if(remaining<0n)return null;
  for(const row of tablo('HeroExp').liste.slice().sort((a,b)=>a._id-b._id)){
    if(allExp(row._id)>remaining)return {lv:row._id,exp:Number(remaining-allExp(row._id-1))};
  }
  return {lv:levels.MAX_LV,exp:Math.min(levels.need(levels.MAX_LV)-1,Number(remaining-allExp(levels.MAX_LV-1)))};
}
function attackPool(n){return cv(61700015,[]).slice(0,Math.min(n,cv(61700015,[]).length)).flat().map(Number);}
function pick(list){return list[Math.min(list.length-1,Math.floor(Math.random()*list.length))];}
function bonuses(r){const rate=r.n>0?0.1+r.n*0.06:0;return {damage:r.pp && r.pp!==4?rate:0,reduction:r.pp===4?rate:0};}
function restriction(a,b){
  if(b.pp===6)return 0.7;
  if(!b.n)return 1;
  if(!a.n)return 0.7;
  if(b.pp<=3&&a.pp<=3&&b.pp%3+1===a.pp)return 0.7;
  if(b.pp>=4&&(a.pp<=3||a.pp!==b.pp))return 0.7;
  return 1;
}
const CHANCE={1:.10,2:.03,3:.015,4:.02,5:.02,6:.01,7:.04,8:.01,10:.02};
function proc(unit,effect,rng=Math.random){const r=unit.rebirth||{};return r.n>0&&r.ae===effect&&rng()<Math.min(1,r.n*(CHANCE[effect]||0));}
function hit(attacker,target,amount,rng=Math.random,ignoreDefensiveSkills=false,nonfatal=false,ignoreShield=false){
  const before=target.hp;
  if(require('./asura-guardian-combat').immune(target))return {damage:0,recovered:0,absorbed:0,before};
  const clearShield=proc(attacker,1,rng),clearBuffs=proc(attacker,7,rng);
  if(clearShield)target.shield=0;
  let damage=Math.max(0,Math.round(amount*restriction(attacker.rebirth||{},target.rebirth||{})));
  const instantKill=proc(attacker,8,rng);
  if(instantKill)damage=target.hp;
  if(!ignoreDefensiveSkills&&proc(target,3,rng))damage=0;
  let absorbed=0;
  if(!ignoreDefensiveSkills&&!ignoreShield&&target.shield>0&&!instantKill){absorbed=Math.min(target.shield,damage);target.shield-=absorbed;damage-=absorbed;}
  const blockedHeal=require('./guy-gate-combat').isGuy(target)||(target.skillBuffs||[]).some(b=>b.field==='noHeal'&&b.remaining>0)&&!(target.skillBuffs||[]).some(b=>b.field==='immuneHealBlock'&&b.remaining>0);
  const heal=!ignoreDefensiveSkills&&!blockedHeal&&proc(target,6,rng);
  if(attacker.maxHitDamage)damage=Math.min(damage,attacker.maxHitDamage);
  damage=Math.min(Math.max(0,target.hp-(heal||nonfatal?1:0)),damage);
  target.hp-=damage;
  let recovered=0;if(heal){
    if(target.gaaraContext)require('./gaara-combat').onDamage(target.gaaraContext,attacker,target,{damage,absorbed},false,[]);
    recovered=Math.round((target.maxHp-target.hp)*require('./gaara-combat').healFactor(target));target.hp+=recovered;
  }
  if(clearBuffs)target.activeBuffs={};
  return {damage,recovered,clearShield,clearBuffs,absorbed,before};
}
function reward(paid=false){const configured=cv(61700009,{amount:10});return [{type:1,code:Number(cv(61700018,14100701)),amount:paid?100:(Number(configured.amount)||10)}];}
function kur(y){
  const H={};
  const materials=(d,costs)=>costs.every(c=>inventory.mevcut(d,inventory.odulTemplate(c.type,c.code))>=c.amount);
  const consume=(d,costs)=>{for(const c of costs){const tpl=inventory.odulTemplate(c.type,c.code);if(!inventory.dus(d,tpl,c.amount))throw Error('Reincarnation item balance changed');const p=inventory.guncellemePaketi(d,tpl);y.ekOnce(p.id,p.payload,'REBIRTH-cost');}};
  const stats=(d,id,lv)=>{const p=require('./ekipman').statPaketi(d,id,lv);if(p)y.ekSonra(0x01180104,p,'REBIRTH-stats');};
  H['0x01818503']=({durum})=>new Y().u8(((gunluk(durum).reb||{}).book)?1:0).done();
  H['0x01818500']=({payload,durum,kaydet})=>{
    if(!Buffer.isBuffer(payload)||payload.length!==4)return error(4);
    const id=payload.readUInt32BE(0),v=levels.veriOku();if(!owned(durum,id,v))return error(4);
    const r=record(durum,id),current=levels.heroDurum(durum,id,v);
    if(r.n>=MAX()||current.lv<Number(cv(61700001,[])[r.n]))return error(1);
    if(id!==levels.anaId()&&record(durum,levels.anaId()).n<1)return error(1);
    const next=afterLevel(current.lv,current.exp,r.n);if(!next)return error(1);
    const costs=[{type:1,code:Number(cv(61700003,14100698)),amount:Number(cv(61700011,[])[r.n])}];
    if(id!==levels.anaId()){
      const fragment=fragmentId(id);if(!fragment)return error(4);
      costs.push({type:1,code:fragment,amount:100});
    }
    if(!costs[0].amount||!materials(durum,costs))return error(18);
    consume(durum,costs);
    r.history=Math.max(r.history,current.lv);r.n++;
    if(r.n===1){r.pp=pick([1,2,3]);r.ae=pick(attackPool(1));}
    store(durum,id,r);
    if(id===levels.anaId()){v.level=next.lv;v.deneyim=next.exp;levels.veriYaz(v);}else{const state=levels.heroKayit(durum,id,current.lv);state.lv=next.lv;state.exp=next.exp;}
    levels.bekleyenTemizle(durum,[id]);kaydet(durum);stats(durum,id,next.lv);
    // Optional authoritative tail, consumed by the rebuilt Flash client.
    return new Y().u32(0).u32(id).u32(r.pp).u32(r.ae).u8(r.n).u32(next.lv).u32(0).u32(next.exp).u32(r.history).done();
  };
  H['0x01818501']=({payload,durum,kaydet})=>{
    if(!Buffer.isBuffer(payload)||payload.length!==7)return error(4);
    const id=payload.readUInt32BE(0),attr=payload[4],superPower=payload[5],effect=payload[6],v=levels.veriOku();
    if(!owned(durum,id,v)||[attr,superPower,effect].some(x=>x>1)||(!attr&&!effect)||(superPower&&!attr))return error(4);
    const r=record(durum,id);if(!r.n)return error(1);
    const costs=[];if(attr)costs.push(cv(61700004,{}));if(effect)costs.push(cv(61700005,{}));
    if(costs.some(c=>!c.amount||!inventory.odulTemplate(c.type,c.code))||!materials(durum,costs))return error(18);
    const gold=superPower?Number(cv(61700006,200)):0;
    if(gold>0){if((Number(v.altin)||0)<gold)return error(16);const p=y.paraHarca([{type:0,code:1,amount:gold}]);if(!p)return error(16);y.ekOnce(0x01180105,p,'REBIRTH-gold');}
    consume(durum,costs);
    if(attr)r.pp=pick(superPower?[4,5]:[1,2,3]);if(effect)r.ae=pick(attackPool(r.n));
    store(durum,id,r);kaydet(durum);stats(durum,id,levels.heroSeviye(durum,id));
    return new Y().u32(0).u32(id).u32(r.pp).u32(r.ae).u8(attr).u8(effect).done();
  };
  H['0x01818502']=({payload,durum,kaydet})=>{
    if(!Buffer.isBuffer(payload)||payload.length!==1||payload[0]>1)return error(4);
    if(!record(durum,levels.anaId()).n)return error(1);
    const g=gunluk(durum);g.reb=g.reb||{book:0};const paid=payload[0];
    if((!paid&&g.reb.book)||(paid&&!g.reb.book))return error(1);
    const awards=reward(!!paid),preview=JSON.parse(JSON.stringify(durum)),added=[];
    for(const a of awards){const before=inventory.mevcut(preview,a.code);added.push(...inventory.ekle(preview,[a]));if(inventory.mevcut(preview,a.code)!==before+a.amount)return error(1);}
    const gold=paid?Number(cv(61700010,120)):0;
    let charge=null;
    if(paid){charge=y.paraHarca([{type:0,code:1,amount:gold}]);if(!charge)return error(16);}
    gunluk(preview).reb.book=1;
    try{kaydet(preview);}catch(e){
      if(paid){const refund=y.paraIcinOdul([{type:0,code:1,amount:gold}],durum,{refund:true});if(refund)y.ekOnce(0x01180105,refund,'REBIRTH-book-refund');}
      return error(1);
    }
    Object.assign(durum,preview);
    if(charge)y.ekOnce(0x01180105,charge,'REBIRTH-book-gold');
    const notice=inventory.kazancPaketi(durum,added);if(notice)y.ekSonra(inventory.OP_NTF,notice,'REBIRTH-book-items');
    // Stock clients may ignore new stacks in InventoryNtf; reload the native bag after the receipt.
    y.ekSonra(0x01180f00,inventory.loadBagPaketi(durum),'REBIRTH-book-bag-sync');
    return new Y().u32(0).u8(paid).done();
  };
  return H;
}
module.exports={statMultiplier,fragmentId,record,owned,afterLevel,attackPool,bonuses,restriction,proc,hit,reward,kur};
