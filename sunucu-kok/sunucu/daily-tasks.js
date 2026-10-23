'use strict';
// Daily Tasks: server-owned progress, atomic inventory claims and per-day limits.
const {Y,tablo,satir,json,cv,gun,gunluk}=require('./paket');
const env=require('./envanter'),events=require('./olay');
const clone=x=>JSON.parse(JSON.stringify(x));
const KEYS={11:'instancePass',12:'arenaFight',13:'autoJanken',14:'fortifyEquip',15:'refineEquip',16:'trialWin',17:'cultivate'};
function choose(ids,n){const pool=[...ids],out=[];while(out.length<n&&pool.length)out.push(pool.splice(Math.floor(Math.random()*pool.length),1)[0]);return out;}
function state(d){
 const day=gunluk(d);let g=day.gorev;
 if(!g)g=day.gorev={fresh:0,point:0,cur:0,prog:0,finish:0,tasks:choose(tablo('DailyTask').ids,5),mask:0};
 if(g.schema!==2){g.schema=2;g.double=0;g.targets=choose(Object.keys(KEYS).map(Number),3).map(type=>({type,done:0}));g.targetAwarded=false;g.baseline=null;g.prog=0;g.finish=Math.min(10,Math.max(0,Number(g.finish)||0));g.point=Math.min(195,Math.max(0,Number(g.point)||0));g.mask=(Number(g.mask)||0)&1023;}
 if(!g.tasks.includes(g.cur))g.cur=0;
 return g;
}
function counter(d,row,account){if(row.eventType===18){const a=account().dailyTaskSpending;return a?.day===gun()?Number(a.count)||0:0;}return events.oku(d,KEYS[row.eventType]);}
function progress(d,account){const g=state(d),r=satir('DailyTask',g.cur);if(!r){g.prog=0;return g;}const n=counter(d,r,account);if(g.baseline===null||g.baseline===undefined)g.baseline=n;g.prog=Math.min(r.complete,Math.max(0,n-g.baseline));return g;}
function info(d,account){const g=progress(d,account),w=new Y().u32(0).u16(g.fresh).i8(g.double).u16(g.point).u16(g.mask).u32(g.cur).i8(g.prog).i8(g.finish).u16(g.tasks.length);for(const id of g.tasks)w.u32(id);w.u16(g.targets.length);for(const t of g.targets)w.i8(t.type).i8(t.done);return w.done();}
function kur(y){
 const account=y.dailyTaskAccount||(()=>JSON.parse(require('fs').readFileSync(require('./runtime-path')('veri.json'),'utf8')));
 const level=()=>y.seviye.anaDurum(account()).lv;
 const fail=n=>new Y().u32(n).done();
 const refresh=d=>y.ekSonra(0x01182000,info(d,account),'DAILY-state');
 // Stage every inventory mutation before charging or persisting; never consume a claim on overflow.
 function commit(ctx,d,rewards=[],cost=[]){
  const items=rewards.filter(r=>r.type===1),money=rewards.filter(r=>r.type!==1);
  const before=items.map(r=>env.mevcut(d,r.code));env.ekle(d,items);
  if(items.some((r,i)=>env.mevcut(d,r.code)-before[i]!==r.amount))return false;
  // The client confirms Gold + Coupon; spend Coupons first, then Gold.
  cost=cost.flatMap(r=>{if(r.type!==0||r.code!==2)return [r];const n=Math.min(Math.max(0,Number(account().kupon)||0),r.amount);return [...(n?[{...r,amount:n}]:[]),...(n<r.amount?[{...r,code:1,amount:r.amount-n}]:[])];});
  const packet=cost.length?y.paraHarca(cost):null;if(cost.length&&!packet)return false;
  try{ctx.kaydet(d);}catch(e){if(packet)y.paraIcinOdul(cost);return false;}
  for(const k of Object.keys(ctx.durum))delete ctx.durum[k];Object.assign(ctx.durum,d);
  if(packet)y.ekSonra(0x01180105,packet,'DAILY-cost');
  if(money.length)y.odulVer(ctx.durum,money);
  if(items.length)y.ekSonra(0x01180f00,env.loadBagPaketi(ctx.durum),'DAILY-items');
  return true;
 }
 const H={};
 H['0x01812000']=ctx=>{const d=clone(ctx.durum),packet=info(d,account);return commit(ctx,d)?packet:fail(1);};
 H['0x01812001']=ctx=>{
  if(!Buffer.isBuffer(ctx.payload)||ctx.payload.length!==5)return fail(4);
  const id=ctx.payload.readUInt32BE(0),type=ctx.payload[4],d=clone(ctx.durum),g=progress(d,account),r=satir('DailyTask',id);let cost=[],rewards=[];
  if(!r||!g.tasks.includes(id)||![1,2,3,4].includes(type))return fail(4);
  if(type===1){if(g.finish>=10||g.cur)return fail(1);g.cur=id;g.prog=0;g.baseline=counter(d,r,account);}
  else {
   if(g.cur!==id)return fail(1);
   if(type===2){g.cur=0;g.prog=0;g.baseline=null;}
   else {
    if(g.finish>=10||type===3&&g.prog<r.complete)return fail(1);
    if(type===4){const instant=json(r.instant,[]);cost=[{type:0,code:instant[0]===2?2:1,amount:instant[1]}];if(!Number.isSafeInteger(instant[1])||instant[1]<=0)return fail(4);}
    rewards=json(r.rewards,[]).map(a=>({...a,amount:a.amount*(g.double?2:1)}));
    g.finish++;g.point+=r.point;g.cur=0;g.prog=0;g.baseline=null;
    if(r.eventType===18)g.double=1;
    for(const target of g.targets)if(target.type===r.eventType)target.done=1;
    if(!g.targetAwarded&&g.targets.every(t=>t.done)){g.targetAwarded=true;g.point+=45;}
    // A completed slot receives a new task, so all ten daily completions are possible.
    g.tasks[g.tasks.indexOf(id)]=choose(tablo('DailyTask').ids.filter(t=>!g.tasks.includes(t)),1)[0];
    events.say(d,'dailyTask',1);events.say(d,'dailyPoints',g.point-state(clone(ctx.durum)).point);
   }
  }
  if(!commit(ctx,d,rewards,cost))return fail(cost.length?16:1);
  refresh(ctx.durum);return new Y().u32(0).u32(type>=3?id:g.cur).i8(type).done();
 };
 H['0x01812002']=ctx=>{if(ctx.payload?.length)return fail(4);const d=clone(ctx.durum),g=state(d);if(g.finish>=10)return fail(1);const price=cv(60160003,[0,2,10]);const cost=g.fresh?[{type:0,code:price[1],amount:price[2]}]:[];g.fresh++;g.tasks=choose(tablo('DailyTask').ids,5);g.cur=0;g.prog=0;g.baseline=null;if(!commit(ctx,d,[],cost))return fail(16);refresh(ctx.durum);const w=new Y().u32(0).u16(g.fresh).u16(g.tasks.length);for(const id of g.tasks)w.u32(id);return w.done();};
 H['0x01812003']=ctx=>{
  if(!Buffer.isBuffer(ctx.payload)||ctx.payload.length!==4)return fail(4);
  const d=clone(ctx.durum),g=state(d),id=ctx.payload.readUInt32BE(0),r=satir('DailyAward',id);
  const eligible=tablo('DailyAward').liste.filter(r=>r.level1<=level()),tier=Math.max(...eligible.map(r=>r.level1));
  const rows=eligible.filter(r=>r.level1===tier).sort((a,b)=>a.mark-b.mark),idx=rows.findIndex(a=>a._id===id);
  const claimed=g.mask===0?0:g.mask.toString(2).length;
  if(!r||idx!==claimed||g.point<r.mark||claimed>=10)return fail(1);
  const rewards=json(r.rewards,[]).map(a=>({...a,amount:a.amount*(g.double&&r.mark!==150?2:1)}));
  g.mask|=1<<idx;if(!commit(ctx,d,rewards))return fail(1);
  return new Y().u32(0).u16(g.mask).done();
 };
 return H;
}
// Existing authoritative event producers drive live progress while this window is open.
events.abone((d,key)=>{const g=gunluk(d).gorev;if(!g?.cur||KEYS[satir('DailyTask',g.cur)?.eventType]!==key)return [];const r=satir('DailyTask',g.cur);if(g.baseline==null)g.baseline=events.oku(d,key);g.prog=Math.min(r.complete,Math.max(0,events.oku(d,key)-g.baseline));return [{id:0x01182005,payload:new Y().i8(g.prog).done(),kaynak:'DAILY-progress'}];});
module.exports={kur,state,progress,info,KEYS};
