'use strict';
const path=require('path'),{Y}=require('./paket');
const config=require('./infinite-illusion-config.json');
const OP={INFO_REQ:0x01817e00,FIGHT_REQ:0x01817e01,INFO:0x01187e00,FIGHT:0x01187e01};
const day=now=>Math.floor((now+25200)/86400);
const key=d=>`${Number(d.roleIdHi)>>>0}:${Number(d.roleIdLo)>>>0}`;
const clone=d=>JSON.parse(JSON.stringify(d));
const reward=rank=>config.rewards.find(r=>rank<=r.through)||config.rewards[config.rewards.length-1];
function ranks(s){return Object.values(s.entries).filter(r=>r.damage>0).sort((a,b)=>b.damage-a.damage||a.at-b.at||a.id.localeCompare(b.id));}
function record(s,row){
 const previous=s.entries[row.id];
 if(!Number.isFinite(row.damage)||row.damage<0)throw Error('Invalid boss damage');
 row.damage=Math.min(config.bossHp,Math.floor(row.damage));
 if(!previous||row.damage>previous.damage)s.entries[row.id]=row;
}
function state(d,now){
 let s=d.infiniteIllusion;
 if(!s)s=d.infiniteIllusion={day:day(now),entries:{},nextBot:now+config.botIntervalSeconds,nextFight:0,battles:0,payouts:[]};
 if(s.day!==day(now)){
  const rows=ranks(s),player=rows.findIndex(r=>r.id===key(d));
  if(player>=0){const r=reward(player+1);s.payouts.push({id:`${s.day}:${key(d)}`,day:s.day,rank:player+1,gold:r.gold,stones:r.stones,itemsDelivered:false,goldDelivered:false});}
  s.previous={day:s.day,rows:rows.slice(0,100)};
  s.day=day(now);s.entries={};s.battles=0;s.nextBot=now+config.botIntervalSeconds;
 }
 return s;
}
function info(d,now){
 const s=state(d,now),rows=ranks(s),mine=rows.findIndex(r=>r.id===key(d));
 const decorate=(r,i)=>({...r,rank:i+1,reward:reward(i+1)});
 return {day:s.day,now,resetAt:(s.day+1)*86400-25200,boss:{id:config.bossHeroId,name:'Muken Aizen',hp:config.bossHp,atk:config.bossAttack,def:config.bossDefense},rows:rows.slice(0,100).map(decorate),mine:mine<0?null:decorate(rows[mine],mine),battles:s.battles,nextFight:s.nextFight,lastDamage:s.lastDamage||0,payouts:s.payouts.slice(-7),rewards:config.rewards};
}
const packet=(d,now)=>new Y().utf(JSON.stringify(info(d,now))).done();
function service(options={}){
 const now=options.now||(()=>Math.floor(Date.now()/1000));
 const simulate=options.simulate||((d,b)=>require('./savas').illusionBattle(d,b));
 const bots=options.bots||(()=>require('./cross-server-bots').all());
 const random=options.random||Math.random;
 const currencyFile=options.currencyFile||require('./runtime-path')('veri.json');
 function persist(ctx,next){ctx.kaydet(next);Object.assign(ctx.durum,next);}
 function credit(ctx){
  return require('./boss-reward-mail').enqueue(ctx,now(),currencyFile);
 }
 function tick(ctx,withBot=true){
  const time=now(),next=clone(ctx.durum),s=state(next,time);
  const present=new Set(Object.keys(s.entries).filter(id=>id.startsWith('bot:')));
  if(withBot&&(present.size<config.botInitialCount||time>=s.nextBot)){
   const pool=bots(),unused=pool.filter(bot=>!present.has(`bot:${bot.id}`));
   const count=Math.min(pool.length,Math.max(0,Math.min(config.botInitialCount,pool.length)-present.size))||(time>=s.nextBot?1:0);
   for(let i=0;i<count;i++){
    const bot=unused.length?unused.splice(Math.min(unused.length-1,Math.floor(random()*unused.length)),1)[0]:pool[Math.floor(random()*pool.length)];
    if(!bot)break;
    const battle=simulate(next,bot);record(s,{id:`bot:${bot.id}`,name:bot.name,bot:true,level:Math.max(1,Math.min(159,100+bot.levelOffset)),heroes:bot.heroes,damage:battle.damage,at:time});
   }
   if(count)s.nextBot=time+config.botIntervalSeconds;
  }
  if(JSON.stringify(next)!==JSON.stringify(ctx.durum))persist(ctx,next);
  return credit(ctx);
 }
 function fight(ctx){
  if(!Buffer.isBuffer(ctx.payload)||ctx.payload.length!==1||ctx.payload[0]>1)return {error:4};
  const rewarded=tick(ctx,false);
  const time=now(),next=clone(ctx.durum),s=state(next,time);
  if(time<s.nextFight)return {error:1,rewarded};
  const battle=simulate(next,null);
  if(!battle||!Buffer.isBuffer(battle.payload)||!Number.isFinite(battle.damage))throw Error('Invalid boss battle');
  record(s,{id:key(next),name:next.nick||'Shinigami',bot:false,damage:battle.damage,at:time});
  s.nextFight=time+config.fightCooldownSeconds;s.battles++;s.lastDamage=Math.min(config.bossHp,Math.max(0,Math.floor(battle.damage)));
  persist(ctx,next);
  return {report:battle.payload,won:!!battle.won,sweep:ctx.payload[0]===1,info:packet(next,time),rewarded};
 }
 return {tick,credit,fight,packet:(d)=>packet(d,now())};
}
module.exports={OP,config,day,key,reward,ranks,record,state,info,packet,service};
