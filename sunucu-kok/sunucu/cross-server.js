"use strict";
const {Y,O,cv,satir,json,simdi}=require('./paket'),cfg=require('./cross-server-config.json'),bots=require('./cross-server-bots'),env=require('./envanter'),levels=require('./seviye'),codec=require('./kodek'),crypto=require('crypto');
const OP={BASE:0x01183d07,LIST:0x01183d05,RECORD:0x01183d0e,SEASON:0x01183d0d},day=t=>Math.floor((t+25200)/86400),clone=d=>JSON.parse(JSON.stringify(d));
function state(d,now=simdi()){let k=d.crossServer;if(!k)k=d.crossServer={season:Math.floor(day(now)/cfg.seasonDays),score:0,tier:0,history:[]};
 const season=Math.floor(day(now)/cfg.seasonDays);if(k.season!==season){k.season=season;k.score=0;k.tier=0;k.history=[];}
 if(k.day!==day(now)){k.yesterdayScore=k.score;k.yesterdayRank=rank(k);k.day=day(now);k.times=Number(cv(60350016,5));k.bought=0;k.refresh=0;k.paid=[];k.boxes=0;k.killed={};k.normal=[];k.super=[];k.round=0;}
 k.history=k.history||[];k.normal=k.normal||[];k.super=k.super||[];k.killed=k.killed||{};return k;}
function rank(k){return 1+bots.all().filter(b=>b.score>=k.score).length;}
function playerLevel(){return levels.anaDurum(levels.veriOku()).lv;}
function ownPower(d){try{const s=require('./statlar'),p=require('./ekipman').statPaketi(d,levels.anaId(),playerLevel());return p.readUInt32BE(4+2+26*4);}catch(e){return 1;}}
function select(k){const rng=bots.all().map(b=>b.id);let seed=(cfg.botSeed+k.day+k.round*997)>>>0;for(let i=rng.length-1;i>0;i--){seed=(Math.imul(seed,1664525)+1013904223)>>>0;const j=seed%(i+1);[rng[i],rng[j]]=[rng[j],rng[i]];}k.normal=rng.slice(0,18);k.super=rng.slice(18,30);}
function base(d,k){return new Y().u32(k.yesterdayRank||0).u32(rank(k)).u32(ownPower(d)).u32(k.tier||0).u32(k.yesterdayScore||0).u32(k.score).u32(k.times).u32(k.lastFight||0).u32(1).u32((k.paid||[]).length).u8(k.refresh).u32(Math.max(0,Number(cv(60350017,50))-k.bought)).u32(1).u8(k.boxes).done();}
function season(k){const start=k.season*cfg.seasonDays*86400-25200;return new Y().u32(1).u32(start).u32(start+cfg.seasonDays*86400).u32(start+cfg.seasonDays*86400).u32(1).done();}
function difficulty(k,id){const at=k.normal.indexOf(id);if(at>=0){let offset=0;const counts=cv(60350012,[6,5,4,2,1]);for(let group=0;group<counts.length;group++){offset+=counts[group];if(at<offset)return group;}}return 5;}
function opponent(k,id){return bots.team(id,playerLevel(),difficulty(k,id));}
function lists(d,k){if(!k.normal.length)select(k);const w=new Y();for(const ids of [k.normal,k.super]){w.u16(ids.length);for(const id of ids){const b=opponent(k,id);w.u32(id).utf(b.name).utf(b.server).u32(b.heroes[0]).u16(b.heroes.length-1);for(const hero of b.heroes.slice(1))w.u32(hero);w.u32(b.level).u32(b.quality).u32(Math.min(0xffffffff,Math.round(ownPower(d)*b.power*b.crossStatScale))).u32(0).u32(0).u32(b.score).i8(k.killed[id]?1:2);}}return w.done();}
function records(k){const w=new Y().u16(k.history.length);for(const r of k.history)w.utf(r.name).u32(r.time).utf(r.id).u32(r.won?1:0);return w.done();}
function normalAllowed(k,id){let offset=0;for(const count of cv(60350012,[6,5,4,2,1])){const group=k.normal.slice(offset,offset+count);if(group.includes(id))return k.normal.slice(0,offset).every(x=>k.killed[x]);offset+=count;}return false;}
function rewards(index,tier){const row=satir('GSPVP_Reward',5001+(tier||0)*5+index);return json(row&&row.f2,[]);}
function preview(d,aw){for(const a of aw.filter(a=>a.type===1)){const before=env.mevcut(d,a.code);env.ekle(d,[a]);if(env.mevcut(d,a.code)!==before+a.amount||before+a.amount>env.MAX_ADET)throw Error('Reward capacity');}}
function kur(y,opt={}){const now=opt.now||simdi,H={},fail=n=>new Y().u32(n).done();
 function push(d,k){y.ekSonra(OP.BASE,base(d,k),'CROSS-base');}
 function commit(ctx,next,costs=[],aw=[]){const charged=costs.length?y.paraHarca(costs):null;if(costs.length&&!charged)return false;try{ctx.kaydet(next);}catch(e){if(charged)y.paraIcinOdul(costs);return false;}Object.assign(ctx.durum,next);if(charged)y.ekSonra(0x01180105,charged,'CROSS-cost');if(aw.some(a=>a.type!==1)){const p=y.paraIcinOdul(aw.filter(a=>a.type!==1));if(p)y.ekSonra(0x01180105,p,'CROSS-reward');}if(aw.some(a=>a.type===1))y.ekSonra(0x01180f00,env.loadBagPaketi(next),'CROSS-bag');push(next,state(next,now()));return true;}
 H['0x01810213']=ctx=>{if(ctx.payload.length>1||(ctx.payload.length===1&&ctx.payload[0]!==1))return fail(4);const next=clone(ctx.durum),k=state(next,now());if(!k.normal.length)select(k);if(!commit(ctx,next))return fail(2);y.ekSonra(OP.SEASON,season(k),'CROSS-season');return fail(ctx.payload.length===1?1:0);};
 H['0x01813d01']=ctx=>{const next=clone(ctx.durum);state(next,now());return commit(ctx,next)?fail(0):fail(1);};
 H['0x01813d07']=ctx=>base(ctx.durum,state(ctx.durum,now()));H['0x01813d09']=()=>Buffer.from([1]);H['0x01813d0d']=ctx=>season(state(ctx.durum,now()));
 H['0x01813d05']=ctx=>{const next=clone(ctx.durum),k=state(next,now());const packet=lists(next,k);try{ctx.kaydet(next);}catch(e){return new Y().u16(0).u16(0).done();}Object.assign(ctx.durum,next);return packet;};
 H['0x01813d0a']=ctx=>{if(ctx.payload.length)return fail(4);const next=clone(ctx.durum),k=state(next,now());if(k.refresh>=3)return fail(1);k.refresh++;k.super=bots.all().filter(b=>!k.normal.includes(b.id)&&!k.super.includes(b.id)).sort((a,b)=>((a.id+k.refresh*199)%cfg.botCount)-((b.id+k.refresh*199)%cfg.botCount)).slice(0,12).map(b=>b.id);if(!commit(ctx,next,[{type:0,code:1,amount:Number(cv(60350014,200))}]))return fail(16);y.ekSonra(OP.LIST,lists(next,k),'CROSS-refresh');return fail(0);};
 H['0x01813d0c']=ctx=>{if(ctx.payload.length)return fail(4);const next=clone(ctx.durum),k=state(next,now());if(k.bought>=Number(cv(60350017,50)))return fail(1);k.bought++;k.times++;return commit(ctx,next,[{type:0,code:1,amount:Number(cv(60350011,10))}])?fail(0):fail(16);};
 H['0x01813d04']=ctx=>{const k=state(ctx.durum,now()),rows=bots.all().map(b=>({name:b.name,server:b.server,level:Math.max(1,Math.min(159,playerLevel()+b.levelOffset)),score:b.score,tier:Math.min(6,Math.floor(b.score/1500))}));rows.push({name:ctx.durum.nick||'Player',server:'Local',level:playerLevel(),score:k.score,tier:k.tier});rows.sort((a,b)=>b.score-a.score);const w=new Y().u16(rows.length);rows.forEach((r,i)=>w.u32(i+1).utf(r.name).utf(r.server).u32(r.level).u32(r.score).u32(r.tier));return w.done();};
 H['0x01813d0e']=ctx=>records(state(ctx.durum,now()));H['0x01813d0b']=ctx=>{const k=state(ctx.durum,now()),w=new Y().u16((k.paid||[]).length);for(const p of k.paid||[])w.utf(ctx.durum.nick||'Player').u32(p.quality).u32(p.id);return w.done();};
 H['0x01813d03']=ctx=>{if(ctx.payload.length!==4)return fail(4);const id=ctx.payload.readUInt32BE(0),row=satir('GSPVP_DailyAward',id);if(!row)return fail(4);const next=clone(ctx.durum),k=state(next,now());if((k.paid||[]).some(p=>p.id===id))return fail(1);const aw=json(row.f4,[]);try{preview(next,aw);}catch(e){return fail(1);}k.paid=k.paid||[];k.paid.push({id,quality:Number(row.quality)});return commit(ctx,next,[{type:0,code:Number(row.costType)===1?0:1,amount:Number(row.cost)}],aw)?fail(0):fail(13);};
 H['0x01813d11']=ctx=>{if(ctx.payload.length!==4)return fail(4);const box=ctx.payload.readUInt32BE(0),next=clone(ctx.durum),k=state(next,now()),counts=cv(60350012,[6,5,4,2,1]);if(box<1||box>5||(k.boxes&(1<<(box-1))))return fail(1);let offset=0;for(let i=0;i<box-1;i++)offset+=counts[i];const members=k.normal.slice(offset,offset+counts[box-1]);if(members.length!==counts[box-1]||members.some(id=>!k.killed[id]))return fail(1);const aw=rewards(box-1,k.tier);try{preview(next,aw);}catch(e){return fail(1);}k.boxes|=1<<(box-1);const reset=k.boxes===31;if(reset){k.round++;k.boxes=0;k.killed={};k.tier=Math.max(0,...cv(60350018,[]).filter(r=>k.score>=r.score).map(r=>Number(r.layer)||0));select(k);}if(!commit(ctx,next,[],aw))return fail(1);if(reset)y.ekSonra(OP.LIST,lists(next,k),'CROSS-next-round');return new Y().u32(0).u32(box).done();};
 function fight(ctx){if(ctx.payload.length!==5)return {error:4};const mode=ctx.payload[0],id=ctx.payload.readUInt32BE(1),next=clone(ctx.durum),k=state(next,now());if(mode>1||(!mode&&!normalAllowed(k,id))||!(mode?k.super.slice((k.refresh-1)*4,k.refresh*4):k.normal).includes(id)||k.killed[id]||k.times<=0||now()<(k.nextFight||0)||(mode&&k.refresh===0))return {error:1};
 const team=opponent(k,id),report=opt.simulate?opt.simulate(team,next):require('./savas').kadroRapor(0,team,null,{playerState:next,forceWin:false,requireEnemyDefeated:true,battleDataVersion:4});if(!report||!Buffer.isBuffer(report.payload))throw Error('Cross battle unavailable');
 const aw=report.won?[{type:1,code:14100282,amount:2}]:[];try{preview(next,aw);}catch(e){return {error:1};}k.times--;k.lastFight=now();k.nextFight=now()+cfg.cooldownSeconds;k.score+=report.won?cfg.winScore:cfg.lossScore;if(report.won)k.killed[id]=true;
 const row={id:crypto.randomUUID(),name:team.name,time:now(),won:!!report.won,report:report.payload.toString('base64')};k.history.unshift(row);k.history=k.history.slice(0,cfg.historyLimit);if(!commit(ctx,next,[],aw))return {error:1};y.ekSonra(OP.RECORD,records(k),'CROSS-records');
 return {ack:new Y().u32(0).u8(mode).u32(id).done(),report:report.payload,result:codec.encodeSingleResult(report.won,aw)};}
 function replay(ctx){if(ctx.payload.length<2||ctx.payload.readUInt16BE(0)+2!==ctx.payload.length)return {error:4};const k=state(ctx.durum,now()),id=new O(ctx.payload).utf(),r=k.history.find(r=>r.id===id);if(!r)return {error:4};return {ack:new Y().u32(0).u8(2).u32(0).done(),report:Buffer.from(r.report,'base64'),result:codec.encodeSingleResult(r.won,[])};}
 function exchange(ctx,row,qty){
  if(ctx.payload.length!==6||!Number.isInteger(qty)||qty<1||qty>32767||ctx.payload.readUInt32BE(0)!==Number(row._id)||ctx.payload.readUInt16BE(4)!==qty||![12,13].includes(Number(row.model)))return fail(4);
  const price=json(row.honour,{}),item=Number(row.itemID),amount=Number(row.amount)*qty;
  if(price.type!==1||![14100282,14100283,14100733].includes(Number(price.code))||!Number.isSafeInteger(price.amount)||price.amount<=0||!Number.isSafeInteger(amount)||amount<=0)return fail(4);
  if(playerLevel()<Number(row.level||0))return fail(1);
  const next=clone(ctx.durum);state(next,now());
  next.magaza=next.magaza||{};next.magaza.alim=next.magaza.alim||{};
  const count=Number(next.magaza.alim[row._id])||0,limits=[Number(row.times)||0,Number(row.totalTimes)||0].filter(n=>n>0);
  if(limits.some(n=>count+qty>n))return fail(1);
  let recruit=null,knife=null,aw=[];
  if(satir('BaseHero',item)){
   if(qty!==1||amount!==1||Number(satir('BaseHero',item).isMain)===1)return fail(4);
   recruit=require('./meyhane').itemRecruitPaketi(item,next,playerLevel());if(!recruit)return fail(1);
  }else if(satir('KnifeExpand',item)){
   if(qty!==1||amount!==1||count>0)return fail(1);
   const z=require('./zanpakuto'),owned=z.state(next),base=z.baseOf(item);if(!base||owned[base._id])return fail(1);
   owned[base._id]={id:item,exp:0};knife=true;
  }else{aw=[{type:1,code:item,amount}];try{preview(next,aw);}catch(e){return fail(1);}}
  const cost=price.amount*qty;if(!Number.isSafeInteger(cost)||!env.dus(next,price.code,cost))return fail(18);
  next.magaza.alim[row._id]=count+qty;
  if(!commit(ctx,next))return fail(1);
  (y.ekOnce||y.ekSonra)(0x01180f00,env.loadBagPaketi(next),'CROSS-exchange-bag');
  if(recruit)(y.ekOnce||y.ekSonra)(0x01180c02,recruit,'CROSS-recruit');
  if(knife)(y.ekOnce||y.ekSonra)(0x01184101,require('./zanpakuto').info(next),'CROSS-knife');
  return fail(0);
 }

 return {handlers:H,fight,replay,exchange};}
module.exports={difficulty,opponent,state,base,lists,records,rank,season,OP,kur,config:cfg};
