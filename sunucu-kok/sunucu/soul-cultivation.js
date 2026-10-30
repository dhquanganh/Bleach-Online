'use strict';
const {Y,tablo,satir,json,cv}=require('./paket'),env=require('./envanter');
const fail=n=>new Y().u32(n).done(),cap=()=>Number(cv(61600002,10000)),quota=()=>Number(cv(61600007,100));
function state(d,now=Math.floor(Date.now()/1000),random=Math.random){
 const today=new Date((now+7*3600)*1000).toISOString().slice(0,10),r=d.ruhTopla||={};if(r.day!==today){r.day=today;r.vip=0;r.used=0;r.free=0;}
 r.enerji=Math.max(0,Math.min(cap(),Number(r.enerji)||0));r.vip=Math.max(0,Math.min(cv(61600006,[]).length,Math.floor(Number(r.vip))||0));r.used=Math.max(0,Math.floor(Number(r.used))||0);r.free=Math.max(0,Math.floor(Number(r.free))||0);r.alinan||={};
 if(!Array.isArray(r.t)||r.t.length!==3)r.t=[0,0,0];r.t=r.t.map(t=>Math.max(0,Number(t)||0));
 const pool=tablo('SoulCollectionRnd').liste.filter(x=>x.type===4&&satir('Article',env.odulTemplate(json(x.reward,{}).type,json(x.reward,{}).code)));
 if(!Array.isArray(r.preview)||r.preview.length!==4||r.preview.some(id=>!pool.some(p=>p._id===id))){const copy=pool.slice();r.preview=[];while(copy.length&&r.preview.length<4)r.preview.push(copy.splice(Math.min(copy.length-1,Math.floor(random()*copy.length)),1)[0]._id);}
 return r;
}
function maximum(r){return quota()*(1+r.vip);}
function init(d,now,random){const r=state(d,now,random),w=new Y().u32(0).u32(r.used).u32(maximum(r)).u32(r.vip).u32(r.enerji).u32(r.free);for(const t of r.t)w.u32(t);w.u16(r.preview.length);for(const id of r.preview)w.u32(id);const claims=Object.entries(r.alinan).filter(([id])=>satir('SoulCollectionShop',id));w.u16(claims.length);for(const [id,t]of claims)w.u32(Number(id)).u32(t);return w.done();}
function kur(y,opt={}){
 let lastError=1;
 const now=opt.now||(()=>Math.floor(Date.now()/1000)),random=opt.random||Math.random,H={};
 function commit(ctx,d,rewards=[],costs=[]){
  lastError=1;
  const expected=new Map();for(const reward of rewards){const code=env.odulTemplate(reward.type,reward.code);if(!code||!satir('Article',code)||!Number.isSafeInteger(reward.amount)||reward.amount<=0)return false;expected.set(code,(expected.get(code)??env.mevcut(d,code))+reward.amount);}
  if([...expected.values()].some(n=>n>env.MAX_ADET))return false;env.ekle(d,rewards);if([...expected].some(([code,n])=>env.mevcut(d,code)!==n))return false;
  const charge=costs.length?y.paraHarca(costs):null;if(costs.length&&!charge){lastError=costs[0].code===0?13:16;return false;}
  try{ctx.kaydet(d);}catch(e){if(charge)y.paraIcinOdul(costs,null,{refund:true});return false;}
  Object.assign(ctx.durum,d);if(charge)y.ekSonra(0x01180105,charge,'CULTIVATION-cost');if(rewards.length)y.ekSonra(0x01180f00,env.loadBagPaketi(d),'CULTIVATION-bag');return true;
 }
 H['0x01818800']=ctx=>{if(ctx.payload.length)return fail(4);const d=structuredClone(ctx.durum);const packet=init(d,now(),random);return commit(ctx,d)?packet:fail(1);};
 H['0x01818801']=ctx=>{
  if(ctx.payload.length!==4)return fail(4);const flag=ctx.payload.readUInt32BE();if(flag>4)return fail(4);
  const d=structuredClone(ctx.durum),r=state(d,now(),random),count=[1,10,1,10,1][flag],timer=[0,-1,1,2,-1][flag];if(r.used+count>maximum(r))return fail(1);
  const base=satir('SoulCollectionBase',flag<=1?10000001:flag<=3?10000002:10000003),cost={...json(base?.lotteryConsume,{})};if(![0,1].includes(cost.code)||cost.type!==0||!cost.amount)return fail(4);
  cost.amount=Math.round(cost.amount*(count===10?10*Number(cv(61600001,.8)):1));
  const free=timer>=0&&r.t[timer]<=now()&&(flag!==0||r.free<Number(cv(61600005,5)));
  if(free){cost.amount=0;r.t[timer]=now()+3600;if(flag===0)r.free++;}
  const pool=tablo('SoulCollectionRnd').liste.filter(x=>x.type===flag&&(flag!==4||r.preview.includes(x._id))&&satir('Article',env.odulTemplate(json(x.reward,{}).type,json(x.reward,{}).code)));if(!pool.length)return fail(4);
  const picked=Array.from({length:count},()=>pool[Math.min(pool.length-1,Math.floor(random()*pool.length))]),rewards=picked.map(p=>json(p.reward,{}));
  if(count===10)rewards.push({type:1,code:14100690,amount:2});
  r.used+=count;r.enerji=Math.min(cap(),r.enerji+100*count);
  if(!commit(ctx,d,rewards,cost.amount?[cost]:[]))return fail(lastError);
  const w=new Y().u32(0).u32(flag).u32(r.used).u32(maximum(r)).u32(timer>=0?r.t[timer]:0).u32(r.enerji).u32(r.free).u16(picked.length);for(const row of picked)w.u32(row._id);return w.done();
 };
 H['0x01818802']=ctx=>{
  if(ctx.payload.length!==4)return fail(4);const id=ctx.payload.readUInt32BE(),row=satir('SoulCollectionShop',id);if(!row)return fail(4);const d=structuredClone(ctx.durum),r=state(d,now(),random);if(r.enerji<cap()||row.frequency===1&&r.alinan[id])return fail(1);
  r.enerji=0;const stamp=now();if(row.frequency===1)r.alinan[id]=stamp;
  return commit(ctx,d,[json(row.exchangeReward,{})])?new Y().u32(0).u32(id).u32(stamp).u32(r.enerji).done():fail(1);
 };
 H['0x01818803']=ctx=>{
  if(ctx.payload.length)return fail(4);const d=structuredClone(ctx.durum),r=state(d,now(),random),prices=cv(61600006,[]);const account=opt.account?opt.account():require('./seviye').veriOku(),vipLimit=Number(satir('VipConfig',Number(account.vipLevel)||0)?.lotteryRecruitNum)||0;if(r.vip>=Math.min(prices.length,vipLimit))return fail(1);const cost=prices[r.vip];r.vip++;
  return commit(ctx,d,[],[{type:0,code:1,amount:cost}])?new Y().u32(0).u32(r.vip).u32(r.used).u32(maximum(r)).done():fail(lastError);
 };return H;
}
module.exports={kur,state,init,maximum};
