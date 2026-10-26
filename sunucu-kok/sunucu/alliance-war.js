'use strict';
const {tablo,satir,json,cv,Y}=require('./paket');
const clone=x=>JSON.parse(JSON.stringify(x));
function atomic(file,data){const fs=require('fs'),tmp=file+'.alliance.tmp';fs.writeFileSync(tmp,JSON.stringify(data,null,2));fs.renameSync(tmp,file);}
function recover(){const fs=require('fs'),runtime=require('./runtime-path'),file=runtime('veri.json');if(!fs.existsSync(file))return;const v=JSON.parse(fs.readFileSync(file,'utf8'));if(!v.allianceShopPending)return;atomic(runtime('oyuncu.json'),v.allianceShopPending);delete v.allianceShopPending;atomic(file,v);}
function purchase(d,row,qty,level,save){
 const fs=require('fs'),runtime=require('./runtime-path'),env=require('./envanter');
 const hero=Number(row.majorType)===2;
 if(!validateShop(d,row,qty,level)||!(hero?satir('BaseHero',row.itemID)&&satir('RoleModel',row.itemID):satir('Article',row.itemID)))throw Error('Điều kiện mua không hợp lệ.');
 const v=JSON.parse(fs.readFileSync(runtime('veri.json'),'utf8')),cost=Number(row.gold)*qty,gold=Number(v.altin)||0,coupon=Number(v.kupon)||0;
 if(!Number.isSafeInteger(cost)||cost<0||cost>gold+coupon)throw Error('Không đủ vàng hoặc coupon.');
 const next=clone(d),amount=Number(row.amount)*qty,before=env.mevcut(next,row.itemID);
 let added=[];
 if(hero){
  if(qty!==1||require('./reincarnation').owned(next,row.itemID,v))throw Error('Bạn đã có tướng này.');
  v.herolar=Array.isArray(v.herolar)?v.herolar:[];v.herolar.push(Number(row.itemID));next.meyhane||={};next.meyhane.alinan||={};next.meyhane.alinan[row.itemID]=1;require('./seviye').heroKayit(next,Number(row.itemID),level);
 }else{
  if(!Number.isSafeInteger(amount)||amount<=0||before+amount>env.MAX_ADET)throw Error('Túi đã đầy vật phẩm.');
  added=env.ekle(next,[{type:1,code:Number(row.itemID),amount}]);if(env.mevcut(next,row.itemID)!==before+amount)throw Error('Không thể thêm vật phẩm.');
 }
 const goldSpent=Math.min(gold,cost);v.altin=gold-goldSpent;v.kupon=coupon-(cost-goldSpent);require('./ultimate-bp-spending').earn(v,goldSpent);
 if(cost>0){const day=require('./paket').gun(),ledger=v.dailyTaskSpending?.day===day?v.dailyTaskSpending:{day,count:0};ledger.count++;v.dailyTaskSpending=ledger;}
 next.altin=v.altin;next.kupon=v.kupon;state(next).shopCount+=qty;next.magaza||={};next.magaza.onur||={};next.magaza.alim||={};next.magaza.onur[row._id]=(Number(next.magaza.onur[row._id])||0)+qty;next.magaza.alim[row._id]=(Number(next.magaza.alim[row._id])||0)+qty;
 require('./olay').say(next,'mallBuy',qty);v.allianceShopPending=next;atomic(runtime('veri.json'),v);
 try{save(next);delete v.allianceShopPending;atomic(runtime('veri.json'),v);}catch(error){recover();}
 Object.assign(d,next);return {added,hero:hero?Number(row.itemID):0,gold:v.altin,coupon:v.kupon,count:next.magaza.onur[row._id]};
}
function clock(now=Date.now()){
 const t=new Date(now+7*3600000),day=t.toISOString().slice(0,10),minute=t.getUTCHours()*60+t.getUTCMinutes();
 const midnight=Date.parse(day+'T00:00:00Z')-7*3600000;
 const refill=minute>=1110?midnight+1110*60000:minute>=750?midnight+750*60000:midnight-86400000+1110*60000;
 return {day,minute,slot:String(refill),refill};
}
function state(d,now=Date.now()){
 const c=clock(now),k=d.allianceWar||={};
 if(!k.pveSlot){k.pveSlot=c.slot;k.pveLeft=10;}
 else if(Number(k.pveSlot)<c.refill){const previous=Number(k.pveSlot);let additions=0;for(let day=c.refill-2*86400000;day<=c.refill;day+=86400000){const base=Date.parse(clock(day).day+'T00:00:00Z')-7*3600000;for(const minutes of [750,1110])if(base+minutes*60000>previous&&base+minutes*60000<=c.refill)additions++;}k.pveLeft=Math.min(10,(Number(k.pveLeft)||0)+5*additions);k.pveSlot=c.slot;}
 if(!k.pvpDay||k.pvpDay<c.day){k.pvpDay=c.day;k.pvpLeft=10;}
 if(!k.shopDay||k.shopDay<c.day){k.shopDay=c.day;k.shopCount=0;}
 k.passed||=[];k.receipts||={};k.history||=[];
 return k;
}
function pvpOpen(now=Date.now()){const m=clock(now).minute;return (m>=825&&m<885)||(m>=1260&&m<1320);}
function honor(d){return Math.max(0,Number(d.etkinlikSavas?.onur)||0);}
function battleReward(mode,model,won,remaining,randomInt=require('crypto').randomInt){
 if(!['pve','pvp'].includes(mode)||typeof won!=='boolean'||!Number.isInteger(remaining)||remaining<0)throw Error('Điều kiện thưởng Alliance không hợp lệ.');
 if(!remaining||(mode==='pve'&&!won))return {reward:false,honor:0,items:[]};
 const map=mode==='pve'?satir('LeagueMapPve',model):null;
 const pool=mode==='pve'?json(map?.f8,[]):[14860010];
 const amount=mode==='pve'?Number(json(map?.f11,[])[0]):won?30:10;
 if(!Array.isArray(pool)||!pool.length||pool.some(id=>!Number.isInteger(id)||!satir('Article',id))||!Number.isSafeInteger(amount)||amount<0||amount>0xffffffff)throw Error('Cấu hình phần thưởng Alliance không hợp lệ.');
 const index=randomInt(pool.length);if(!Number.isInteger(index)||index<0||index>=pool.length)throw Error('Không chọn được phần thưởng Alliance.');
 return {reward:true,honor:amount,items:[{id:pool[index],amount:1}]};
}
function shopLimit(d){const h=honor(d),tiers=json(cv(60310018,[]),[]);return Number(tiers.find(t=>h<=Number(t[0]))?.[1])||100;}
function validateShop(d,row,qty,level,now=Date.now()){
 const k=state(d,now),bought=Number(d.magaza?.onur?.[row._id])||0;
 return row.model===11&&Number.isInteger(qty)&&qty>0&&qty<=100&&level>=Number(row.level)&&honor(d)>=Number(row.f20)&&k.shopCount+qty<=shopLimit(d)&&(!Number(row.totalTimes)||bought+qty<=Number(row.totalTimes))&&(Number(row.majorType)===2?qty===1&&bought===0:Number(row.gold)>0);
}
function models(){return tablo('LeagueMapPve').liste.filter(r=>satir('LeaguePointPath',r._id)).map(r=>({id:r._id,name:r.name,hard:r._id%100===2,level:Number(r.openLevel),recommended:Number(r.recommendLevel),rewards:json(r.f8,[]).filter(id=>satir('Article',id)).map(item)}));}
function item(id){const r=satir('Article',id);return {id,name:r?.name||String(id),picture:Number(r?.picture)||id,icon:require('../item-atlas.cjs')(Number(r?.picture)||id)};}
function allowed(d,model,level){const r=satir('LeagueMapPve',model);return !!r&&level>=Number(r.openLevel)&&(model%100!==2||state(d).passed.includes(model-1));}
function hall(d,now=Date.now()){const k=state(d,now),w=new Y().u16(k.pvpLeft).u16(k.pveLeft).u32(honor(d));const ids=models().filter(m=>!m.hard||k.passed.includes(m.id-1));w.u16(ids.length);for(const m of ids)w.u32(m.id);return w.done();}
function view(d,level,gold,now=Date.now()){
 const k=state(d,now);return {level,gold,honor:honor(d),pveLeft:k.pveLeft,pvpLeft:k.pvpLeft,pvpOpen:pvpOpen(now),timezone:'Asia/Bangkok',shopLeft:Math.max(0,shopLimit(d)-k.shopCount),
 models:models().map(m=>({...m,unlocked:allowed(d,m.id,level)})),history:k.history.slice(-12).reverse(),
 shop:tablo('Mall').liste.filter(r=>r.model===11&&r.isDisplay&&(satir('Article',r.itemID)||satir('BaseHero',r.itemID))).map(r=>({...(r.majorType===2?{id:Number(r.itemID),name:r.name,hero:true}:item(Number(r.itemID))),rowId:r._id,price:Number(r.gold),amount:Number(r.amount),level:Number(r.level),honor:Number(r.f20),remaining:r.majorType===2?((Number(d.magaza?.onur?.[r._id])||Number(d.meyhane?.alinan?.[r.itemID]))?0:1):Number(r.totalTimes)?Math.max(0,Number(r.totalTimes)-(Number(d.magaza?.onur?.[r._id])||0)):null}))};
}
function settle(d,result,now=Date.now()){
 if(result&&d.allianceWar?.receipts?.[result.id])return false;
 if(!result||typeof result.id!=='string'||!result.id||!['pve','pvp'].includes(result.mode)||typeof result.won!=='boolean'||typeof result.reward!=='boolean'||!Number.isSafeInteger(result.honor)||result.honor<0||result.honor>0xffffffff||!Array.isArray(result.items)||result.items.some(i=>!i||!Number.isInteger(i.id)||!satir('Article',i.id)||!Number.isSafeInteger(i.amount)||i.amount<1||i.amount>0xffffffff))throw Error('Invalid Alliance result');
 if((!result.reward&&(result.honor||result.items.length))||(result.reward&&result.mode==='pve'&&!result.won)||(result.reward&&result.remaining!==undefined&&(!Number.isInteger(result.remaining)||result.remaining<1)))throw Error('Invalid Alliance reward eligibility');
 const k=state(d,result.at||now);
 if(result.reward){
  // A native status packet may already have advanced the refill window while
  // another worker simulated this fight. Rebuild from the reserved snapshot.
  if(Number.isInteger(result.remaining)){
   if(result.mode==='pve'){k.pveSlot=result.window;k.pveLeft=result.remaining;}
   else{k.pvpDay=result.window;k.pvpLeft=result.remaining;}
  }
  // Consume only the window in which this fight started, never a newly refilled window.
  if(result.mode==='pve'&&k.pveSlot===result.window)k.pveLeft=Math.max(0,k.pveLeft-1);
  if(result.mode==='pvp'&&k.pvpDay===result.window)k.pvpLeft=Math.max(0,k.pvpLeft-1);
  d.etkinlikSavas||={};d.etkinlikSavas.onur=honor(d)+result.honor;
  if(result.items.length){
   const box=d.posta||={gelen:[],giden:[],seq:1};box.seq=Math.max(Number(box.seq)||1,...box.gelen.map(m=>(Number(m.lo)||0)+1));
   box.gelen.push({hi:0,lo:box.seq++,ad:'Alliance War',konu:result.won?'Thắng trận Alliance':'Thưởng tham gia Alliance',metin:'Phần thưởng trận '+result.id+'. Nhận vật phẩm đính kèm tại đây.',zaman:Math.floor(now/1000),okundu:0,ek:result.items.map(i=>[i.id,i.amount]),adminGrantId:result.id});
  }
 }
 if(result.mode==='pve'&&result.won&&!k.passed.includes(result.model))k.passed.push(result.model);
 require('./olay').say(d,result.mode==='pve'?'allianceCampaign':'allianceBattle',1);
 k.history.push(result);k.history=k.history.slice(-30);k.receipts[result.id]=true;state(d,now);return true;
}
function simulate(request,d){
 const combat=require('./savas'),left=request.left.map(p=>({...p,units:clone(p.units)}));
 const right=request.mode==='pve'?json(satir('LeaguePointPath',request.model)?.mapID,{}).army?.map(id=>({armyId:id,name:satir('EnemyArmy',id)?.name||String(id),units:combat.stageArmyDusmanlari([id])})):request.right.map(p=>({...p,units:clone(p.units)}));
 if(!left.length||!right?.length||right.some(p=>!p.units.length))throw Error('Không có đội hình chiến đấu hợp lệ.');
 const battles=[];
 // Finish the actual armies, not an arbitrary round counter. Every duel
 // eliminates at least one squad (both on a draw), so the relay is bounded.
 for(let round=1;left.length&&right.length;round++){
  const pairs=Math.min(left.length,right.length),survivorsA=[],survivorsB=[];
  for(let i=0;i<pairs;i++){
   const p=left[i],q=right[i],units=clone(p.units).map(u=>({...u,camp:0})),enemies=clone(q.units).map(u=>({...u,camp:1}));
   const report=combat.kadroRapor(0,null,{ad:q.name,birimler:enemies},{playerState:d,playerUnits:units,scaleEnemy:false,forceWin:false,requireEnemyDefeated:true,strictSkillTargets:true,battleDataVersion:4,pvp:request.mode==='pvp'});
   if(!report)throw Error('Không tạo được trận chiến.');
   const carry=(base,after)=>base.map(u=>{const current=after.find(v=>v.id===u.id&&v.pos===u.pos);return current&&current.hp>0?{...u,hp:Math.max(1,Math.round(u.maxHp*current.hp/current.maxHp))}:null;}).filter(Boolean);
   const carriedA=carry(p.units,units),carriedB=carry(q.units,enemies),aliveA=carriedA.length>0,aliveB=carriedB.length>0;
   battles.push({round,left:p.name,right:q.name,enemyId:q.armyId||0,leftHp:carriedA.reduce((n,u)=>n+u.hp,0),rightHp:carriedB.reduce((n,u)=>n+u.hp,0),won:aliveA&&!aliveB,draw:aliveA===aliveB,turns:require('./kodek').decodeBattleReport(report.payload).turns.length,report:report.payload.toString('base64')});
   if(aliveA&&!aliveB)survivorsA.push({...p,units:carriedA});
   if(aliveB&&!aliveA)survivorsB.push({...q,units:carriedB});
  }
  left.splice(0,pairs,...survivorsA);right.splice(0,pairs,...survivorsB);
 }
 return {won:left.length>0&&right.length===0,rightWon:right.length>0&&left.length===0,battles};
}
module.exports={clock,state,pvpOpen,honor,battleReward,shopLimit,validateShop,models,allowed,hall,view,settle,simulate,purchase,recover};
