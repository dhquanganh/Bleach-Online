'use strict';
// Native TraitorAttack (Ryoka), module 0x3400. All-day, personal 30-minute runs.
const {Y,cv,simdi,satir}=require('./paket'),env=require('./envanter'),codec=require('./kodek');
const OP={ENTER:0x0118020c,REVIVE:0x01183400,MONSTERS:0x01183401,FIGHT:0x01183402,RANK:0x01183403,REBORN:0x01183404,DEATH:0x01183405,ROUND:0x01183406,SCORE:0x01183407,COUNT:0x01183408,END:0x011834ff};
const config={duration:1800,waveCooldown:10,fightCooldown:3,maxWave:100};
const clone=d=>JSON.parse(JSON.stringify(d));
function monsters(wave){return Array.from({length:5},(_,i)=>{const id=12500001+wave*100+i,row=satir('Enemy',id);if(!row)throw Error('Missing Ryoka '+id);return {id,hp:row.hp,maxHp:row.hp};});}
function create(now){return {active:true,end:now+config.duration,wave:1,ready:now+1,nextFight:0,deadUntil:0,revives:0,damage:0,kills:0,battles:0,scores:[0,0,0],monsters:monsters(1)};}
function monsterPacket(s){const w=new Y().u16(s.monsters.length);for(const m of s.monsters)w.u32(m.id).u32(m.hp);return w.done();}
function rankPacket(d,s){const w=new Y().i64(s.damage).i64(s.damage).u16(s.damage?1:0);if(s.damage)w.utf(d.nick||'Shinigami').i64(s.damage);return w.done();}
function scorePacket(s){return new Y().u32(s.scores[0]).u32(s.scores[1]).u32(s.scores[2]).done();}
function entry(d,s,now){return new Y().u32(0).u32(Math.max(0,s.ready-now)).u32(s.end-now).u32(s.wave).u32(s.revives).raw(monsterPacket(s)).raw(rankPacket(d,s)).raw(scorePacket(s)).u32(1).u32(Math.max(0,s.deadUntil-now)).u32(s.nextFight).done();}
function fail(error){return {error,ack:new Y().u32(error).done()};}
// Save the battle state and currency together; roll back currency if state persistence fails.
function commit(ctx,next,rewards=[],goldCost=0){
 const fs=require('fs'),file=require('./runtime-path')('veri.json'),raw=fs.readFileSync(file),v=JSON.parse(raw),fields=[];
 if((Number(v.altin)||0)+(Number(v.kupon)||0)<goldCost)throw Error('Insufficient gold/coupons');
 if(goldCost){const gold=Math.min(Number(v.altin)||0,goldCost);v.altin=(Number(v.altin)||0)-gold;v.kupon=(Number(v.kupon)||0)-(goldCost-gold);fields.push({index:3,v:v.altin},{index:1,v:v.kupon});}
 for(const a of rewards){
  if(a.type===1)continue;
  if(a.type===2){require('./seviye').expEkle(next,a.amount,v);fields.push({index:11,v:a.amount});continue;}
  const key=a.type===6?'generalsSoul':a.code===2?'kupon':'gumus',index=a.type===6?4:a.code===2?1:0;
  const before=Number(v[key])||0,after=before+a.amount;if(after>2000000000)throw Error('Currency full');v[key]=after;
  fields.push(index===0?{index,v:Number(v.gumusHigh)||0,a:after}:{index,v:after});
 }
 fs.writeFileSync(file,JSON.stringify(v,null,2));
 try{ctx.kaydet(next);}catch(e){fs.writeFileSync(file,raw);throw e;}
 Object.assign(ctx.durum,next);return fields.length?require('./harita').baseInfoUpdate(fields):null;
}
function kur(y,options={}){
 const now=options.now||simdi,simulate=options.simulate||((id,hp,d)=>require('./savas').ryokaBattle(id,hp,d)),save=options.commit||commit,H={};
 H['0x0181020c']=ctx=>{
  if(ctx.payload.length)return new Y().u32(4).done();
  const next=clone(ctx.durum),time=now();let s=next.ryokaAttack;
  if(!s||!s.active||time>=s.end)s=next.ryokaAttack=create(time);
  s.present=true;
  try{ctx.kaydet(next);}catch(e){return new Y().u32(1).done();}Object.assign(ctx.durum,next);
  return entry(next,s,time);
 };
 H['0x01813400']=ctx=>{
  if(ctx.payload.length)return new Y().u32(4).done();
  const next=clone(ctx.durum),s=next.ryokaAttack,time=now();
  if(!s||!s.active||!s.present||time>=s.end||s.deadUntil<=time)return new Y().u32(1).done();
  const costs=cv(60240016,[1]),cost=costs[Math.min(s.revives,costs.length-1)]*Math.ceil((s.deadUntil-time)/10);
  s.deadUntil=0;s.revives++;
  let money;try{money=save(ctx,next,[],cost);}catch(e){return new Y().u32(16).done();}
  if(money)y.ekSonra(0x01180105,money,'RYOKA-revive-cost');
  y.ekSonra(OP.REBORN,new Y().u32(next.roleIdHi||0).u32(next.roleIdLo||1).done(),'RYOKA-reborn');
  return new Y().u32(0).done();
 };
 function fight(ctx){
  if(ctx.payload.length!==4)return fail(4);
  const next=clone(ctx.durum),s=next.ryokaAttack,time=now();
  if(!s||!s.active||!s.present||time>=s.end||time<s.ready||time<s.nextFight||time<s.deadUntil)return fail(1);
  const m=s.monsters.find(m=>m.id===ctx.payload.readUInt32BE());if(!m||m.hp<=0)return fail(4);
  const battle=simulate(m.id,m.hp,next);
  if(!battle||!Buffer.isBuffer(battle.payload)||!Number.isSafeInteger(battle.damage)||battle.damage<0)throw Error('Invalid Ryoka report');
  const damage=Math.min(m.hp,battle.damage);m.hp-=damage;s.damage=Math.min(Number.MAX_SAFE_INTEGER,s.damage+damage);s.battles++;
  s.nextFight=time+config.fightCooldown;s.deadUntil=battle.won?0:time+Number(cv(60240007,59));
  const rewards=damage?[{type:0,code:0,amount:Math.max(1,Math.min(50000,Math.floor(damage/100)))},{type:2,code:0,amount:Math.max(1,Math.min(20000,Math.floor(damage/250)))},{type:6,code:0,amount:Math.max(1,Math.min(1000,Math.floor(damage/5000)))}]:[];
  if(m.hp===0){s.kills++;s.scores[Math.max(0,Math.min(2,(Number(next.country)||1)-1))]++;rewards.push({type:1,code:s.wave%5===0?14800022:14800020,amount:1});}
  for(const a of rewards.filter(a=>a.type===1)){const owned=env.mevcut(next,a.code);if(owned+a.amount>env.MAX_ADET)return fail(1);env.ekle(next,[a]);if(env.mevcut(next,a.code)!==owned+a.amount)return fail(1);}
  const updates=[{id:OP.MONSTERS,payload:monsterPacket(s)},{id:OP.RANK,payload:rankPacket(next,s)},{id:OP.SCORE,payload:scorePacket(s)}];
  if(s.deadUntil>time)updates.push({id:OP.DEATH,payload:new Y().u32(s.deadUntil).done()});
  if(s.monsters.every(m=>m.hp===0)){
   if(s.wave===config.maxWave){s.active=false;updates.push({id:OP.END,payload:Buffer.alloc(0)});}
   else{s.wave++;s.ready=time+config.waveCooldown;s.monsters=monsters(s.wave);updates.push({id:OP.MONSTERS,payload:monsterPacket(s)},{id:OP.ROUND,payload:new Y().u32(s.wave).done()});}
  }
  if(y.olay){y.olay.say(next,'dailyActivityRyoka',1);y.olay.say(next,'ryokaKills',m.hp===0?1:0);}
  let money;try{money=save(ctx,next,rewards);}catch(e){return fail(1);}
  if(money)updates.push({id:0x01180105,payload:money});
  updates.push({id:0x01180f00,payload:env.loadBagPaketi(next)});
  return {ack:new Y().u32(0).u32(s.nextFight).done(),report:battle.payload,result:codec.encodeSingleResult(!!battle.won,rewards),updates};
 }
 return {handlers:H,fight};
}
module.exports={OP,config,create,monsters,monsterPacket,rankPacket,scorePacket,entry,commit,kur};
