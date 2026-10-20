'use strict';
const {Y}=require('./paket'),config=require('./infinite-illusion-config.json');
const OP={INFO_REQ:0x01817e00,FIGHT_REQ:0x01817e01,INFO:0x01187e00,FIGHT:0x01187e01};
const day=now=>Math.floor((now+25200)/86400),key=d=>`${Number(d.roleIdHi)>>>0}:${Number(d.roleIdLo)>>>0}`;
const clone=d=>JSON.parse(JSON.stringify(d));
const reward=rank=>config.rewards.find(r=>rank<=r.through)||config.rewards.at(-1);
const ranks=s=>Object.values(s.entries||{}).filter(r=>!r.bot&&!String(r.id).startsWith('bot:')&&r.damage>0).sort((a,b)=>b.damage-a.damage||a.at-b.at||a.id.localeCompare(b.id));
function record(s,row){if(row.bot||String(row.id).startsWith('bot:'))return;if(!Number.isFinite(row.damage)||row.damage<0)throw Error('Invalid boss damage');row.damage=Math.min(config.bossHp,Math.floor(row.damage));const old=s.entries[row.id];if(!old||row.damage>old.damage)s.entries[row.id]=row;}
function state(d,now){
 let s=d.infiniteIllusion;
 if(!s)s=d.infiniteIllusion={day:day(now),schema:2,entries:{},nextFight:0,battles:0,lastDamage:0,payouts:[]};
 if(s.schema!==2||s.day!==day(now)){s.schema=2;s.day=day(now);s.entries={};s.battles=0;s.nextFight=0;s.lastDamage=0;}
 delete s.nextBot;s.payouts=s.payouts||[];return s;
}
function info(d,now){const s=state(d,now);return {day:s.day,now,resetAt:(s.day+1)*86400-25200,boss:{id:config.bossHeroId,name:'Muken Aizen',hp:config.bossHp,atk:config.bossAttack,def:config.bossDefense},rows:[],mine:null,battles:s.battles,nextFight:s.nextFight,lastDamage:s.lastDamage||0,payouts:s.payouts.slice(-7),rewards:config.rewards,realPlayersOnly:true};}
const packet=(d,now)=>new Y().utf(JSON.stringify(info(d,now))).done();
let refreshNotice=null;
function notify(){if(refreshNotice)refreshNotice();}
function setNotify(fn){refreshNotice=fn;}
function service(options={}){
 const now=options.now||(()=>Math.floor(Date.now()/1000));
 const simulate=options.simulate||(d=>require('./savas').illusionBattle(d,null));
 const request=options.request||require('./illusion-rpc').createClient();
 const currencyFile=options.currencyFile||require('./runtime-path')('veri.json');
 let cached=null,queue=Promise.resolve();
 const serial=fn=>{const p=queue.catch(()=>{}).then(fn);queue=p;return p;};
 const fresh=ctx=>ctx.reload?ctx.reload():ctx.durum;
 function persist(ctx,next){ctx.kaydet(next);Object.assign(ctx.durum,next);}
 function apply(ctx,view){
  if(!view||!Number.isInteger(view.day)||!Array.isArray(view.rows))throw Error('Invalid global boss ranking');
  const next=clone(fresh(ctx)),s=state(next,now());
  s.day=view.day;s.battles=view.battles||0;s.nextFight=view.nextFight||0;s.lastDamage=view.lastDamage||0;s.entries={};
  const known=new Set(s.payouts.map(p=>p.id));
  for(const p of view.payouts||[])if(!known.has(p.id)){
   if(!/^aizen:\d+:[a-f0-9]{24}$/.test(p.id)||![p.gold,p.stones,p.rank,p.day].every(Number.isFinite))throw Error('Invalid boss reward outbox');
   s.payouts.push({...p,itemsDelivered:false,goldDelivered:false});known.add(p.id);
  }
  if(JSON.stringify(next)!==JSON.stringify(fresh(ctx)))persist(ctx,next);else Object.assign(ctx.durum,next);
  cached={...view,rows:view.rows.filter(r=>!r.bot&&!String(r.id).startsWith('bot:')),payouts:s.payouts.slice(-7)};
  return require('./boss-reward-mail').enqueue(ctx,now(),currencyFile);
 }
 function current(d){return cached&&cached.day===day(now())?{...cached,now:now()}:info(d,now());}
 function tick(ctx){return serial(async()=>apply(ctx,await request('info')));}
 function credit(ctx){return require('./boss-reward-mail').enqueue(ctx,now(),currencyFile);}
 function fight(ctx){return serial(async()=>{
  if(!Buffer.isBuffer(ctx.payload)||ctx.payload.length!==1||ctx.payload[0]>1)return {error:4};
  const rewarded=apply(ctx,await request('info'));
  if(now()<cached.nextFight)return {error:1,rewarded};
  const battle=simulate(clone(fresh(ctx)),null);
  if(!battle||!Buffer.isBuffer(battle.payload)||!Number.isFinite(battle.damage)||battle.damage<0)throw Error('Invalid boss battle');
  const view=await request('fight',{damage:battle.damage});
  const newly=apply(ctx,view),mails=[...(rewarded||[]),...(newly||[])];
  if(view.error)return {error:view.error,rewarded:mails.length?mails:false};
  return {report:battle.payload,won:!!battle.won,sweep:ctx.payload[0]===1,info:new Y().utf(JSON.stringify(current(ctx.durum))).done(),rewarded:mails.length?mails:false};
 });}
 return {tick,credit,fight,packet:d=>new Y().utf(JSON.stringify(current(d))).done()};
}
module.exports={OP,config,day,key,reward,ranks,record,state,info,packet,service,notify,setNotify};
