'use strict';
const C=require('./guild'),{Y,cv,tablo,satir,json}=require('./paket'),env=require('./envanter'),crypto=require('node:crypto');
const {deny,exact,utf,cap}=C,ok=()=>new Y().u32(0).done();
function log(x,action,target='',amount=0){x.g.log.unshift({ozne:x.profile.name,fiil:action,nesne:target,zaman:x.now,adet:amount});x.g.log=x.g.log.slice(0,50);x.g.revision++;x.mark();}
function target(g,p,offset=0){const hi=p.readUInt32BE(offset),lo=p.readUInt32BE(offset+4);return Object.entries(g.members).find(([key,m])=>m.profile.hi===hi&&m.profile.lo===lo);}
function listApplications(g){const w=new Y().u32(0),rows=Object.values(g.applications);w.i16(rows.length);for(const p of rows)w.u32(p.hi).u32(p.lo).utf(p.name).i16(p.level).u32(p.rank).u32(p.power);return w.done();}
function handlers(service){
 const H={},wrap=(id,n,fn,noError)=>H[id]=ctx=>service.run(ctx,x=>{if(n!==null)exact(ctx.payload,n);return fn(x,ctx.payload);},noError);
 wrap('0x01812500',0,x=>{const w=new Y(),guilds=Object.values(x.r.guilds);w.i16(guilds.length);for(const g of guilds)w.u32(g.id).utf(g.name).i16(g.level).i16(Object.keys(g.members).length).utf(Object.values(g.members).find(m=>m.role===2)?.profile.name||'').i8(g.family);return w.done();},()=>new Y().i16(0).done());
 wrap('0x01812507',0,x=>C.info(x.g,x.m),()=>new Y().u32(0).done());
 wrap('0x01812506',0,x=>C.memberList(x.g,x.now));
 wrap('0x01812517',0,x=>require('./lonca').aktiviteDurumPaketi());
 wrap('0x01812501',null,(x,p)=>{
  if(x.m)deny();const name=utf(p,12);if(x.profile.level<Number(cv(60200008,20)))deny(80);if(Object.values(x.r.guilds).some(g=>g.name.toLocaleLowerCase()===name.toLocaleLowerCase()))deny(4);
  x.charge({gumus:Number(cv(60200004,100000))});const id=x.r.nextId++,g=C.guild(id,name,x.profile.family),m=C.member(x.profile);m.role=2;g.leader=x.key;g.members[x.key]=m;x.r.guilds[id]=g;x.r.membership[x.key]=id;x.g=g;x.m=m;log(x,3,name);if(x.y?.olay)x.y.olay.say(x.d,'guildJoin',1);return ok();
 });
 wrap('0x01812502',4,(x,p)=>{if(x.m)deny();const id=p.readUInt32BE(),g=x.r.guilds[id];if(!g||Object.keys(g.members).length>=C.base(g.level).orgMaxNumber||g.family&&x.profile.family&&g.family!==x.profile.family)deny();g.applications[x.key]=x.profile;x.mark();return new Y().u32(0).u32(id).done();});
 wrap('0x01812504',0,x=>{x.requireMember();if(x.m.role<1)deny();return listApplications(x.g);});
 wrap('0x01812511',null,(x,p)=>{
  x.requireMember();if(x.m.role<1||p.length<2)deny();const n=p.readUInt16BE();if(n>100||p.length!==2+n*9)deny(4);const choices=[],seen=new Set();
  for(let i=0;i<n;i++){const at=2+9*i,hi=p.readUInt32BE(at),lo=p.readUInt32BE(at+4),accept=p[at+8];if(accept>1)deny(4);const found=Object.entries(x.g.applications).find(([k,v])=>v.hi===hi&&v.lo===lo);if(!found||seen.has(found[0]))deny(4);seen.add(found[0]);if(accept&&x.r.membership[found[0]])deny();choices.push({key:found[0],p:found[1],accept});}
  if(Object.keys(x.g.members).length+choices.filter(c=>c.accept).length>Number(C.base(x.g.level).orgMaxNumber))deny();
  for(const c of choices){delete x.g.applications[c.key];if(c.accept){x.g.members[c.key]=C.member(c.p);x.r.membership[c.key]=x.g.id;x.r.migrated[c.key]=true;for(const g of Object.values(x.r.guilds))delete g.applications[c.key];}}
  log(x,3,'Member applications');return listApplications(x.g);
 });
 wrap('0x01812509',8,(x,p)=>{x.requireLeader();const t=target(x.g,p);if(!t||t[0]===x.key)deny();x.m.role=0;t[1].role=2;x.g.leader=t[0];log(x,1,t[1].profile.name);return ok();});
 wrap('0x01812521',8,(x,p)=>{x.requireMember();const t=target(x.g,p);if(!t||t[0]===x.key||x.m.role<1||t[1].role>=x.m.role)deny();delete x.r.membership[t[0]];delete x.g.members[t[0]];log(x,0,t[1].profile.name);return ok();});
 wrap('0x01812515',0,x=>{x.requireMember();if(x.m.role===2&&Object.keys(x.g.members).length>1)deny();const g=x.g;delete x.r.membership[x.key];delete g.members[x.key];if(!Object.keys(g.members).length)delete x.r.guilds[g.id];else log(x,0,x.profile.name);x.g=null;x.m=null;x.mark();return new Y().u32(0).u32(0).done();});
 wrap('0x01812516',0,x=>{x.requireLeader();for(const key of Object.keys(x.g.members))delete x.r.membership[key];delete x.r.guilds[x.g.id];x.g=null;x.m=null;x.mark();return ok();});
 wrap('0x01812518',null,(x,p)=>{x.requireMember();if(x.m.role<1)deny();const text=p.length===2&&p.readUInt16BE()===0?'':utf(p,180);x.g.notice=text;log(x,4,text);return new Y().u32(0).utf(text).done();});
 wrap('0x01812519',0,x=>{x.requireMember();const w=new Y().u32(0).i16(x.g.log.length);for(const r of x.g.log)w.utf(r.ozne).u32(r.fiil).utf(r.nesne).u32(r.zaman).u16(Math.min(65535,r.adet));return w.done();});
 wrap('0x01812508',0,x=>{x.requireMember();return new Y().u32(0).i16(3).u32(1).u32(x.g.level).u32(2).u32(x.g.camp[2]||1).u32(4).u32(x.g.camp[4]||1).done();});
 wrap('0x01812503',4,(x,p)=>{x.requireLeader();const type=p.readUInt32BE();if(![1,2,4].includes(type))deny(4);const old=type===1?x.g.level:Number(x.g.camp[type])||1,next=old+1,row=C.base(next);if(!row||next>51||type!==1&&next>x.g.level)deny();const cost=Number(row[{1:'campUpgradeMoney',2:'muyeguardUpgradeMoney',4:'muyebattleUpgradeMoney'}[type]]);if(!(cost>0)||x.g.money<cost)deny(13);x.g.money-=cost;if(type===1)x.g.level=next;x.g.camp[type]=next;log(x,1,'Building '+type);return new Y().u32(0).u32(next).u32(type).u32(x.g.money).done();});
 wrap('0x01812505',4,(x,p)=>{x.requireMember();const type=p.readUInt32BE(),field={1:'atkConsume',2:'physDefConsume',3:'magDefConsume',4:'lifeConsume',5:'speedConsume'}[type],level=Number(x.m.tech[type])||0;if(!field||level>=Math.min(50,x.g.level))deny();const cost=Number(C.addition(level+1)?.[field]);if(!(cost>0)||x.m.exploit<cost)deny();x.m.exploit-=cost;x.m.tech[type]=level+1;log(x,1,'Technology '+type);x.refreshStats();return new Y().u32(0).u32(type).u32(level+1).u32(x.m.exploit).done();});
 wrap('0x01812514',8,(x,p)=>{
  x.requireMember();const gold=p.readUInt32BE(),silver=p.readUInt32BE(4)*1000;if((!gold&&!silver)||gold>MAX_SAFE()||silver>MAX_SAFE())deny(4);
  const limit=Number(tablo('OrganizationDevotion').liste.find(r=>r.playerLevel===(x.profile.rebirthLevel||x.profile.level))?.devotionSivMax)||0;if((x.m.daily.silver||0)+silver>limit)deny(80);
  x.charge({altin:gold,gumus:silver});const s=cv(60200001,[1000,10,10,10]),g=cv(60200002,[1,10,10,10]),units=silver/Number(s[0]),goldUnits=gold/Number(g[0]);
  x.g.money=cap(x.g.money+units*s[1]+goldUnits*g[1]);const contribution=units*s[2]+goldUnits*g[2];x.m.contribution=cap(x.m.contribution+contribution);x.m.daily.contribution=cap(x.m.daily.contribution+contribution);x.m.exploit=cap(x.m.exploit+units*s[3]+goldUnits*g[3]);x.m.daily.silver=(x.m.daily.silver||0)+silver;
  const activity=Math.min(10,Math.max(0,Number(C.base(x.g.level).dayMaxActivity)-(x.m.daily.active||0)));x.m.daily.active=(x.m.daily.active||0)+activity;x.g.groupActive=Math.min(Number(C.base(x.g.level).guildMaxActivity),x.g.groupActive+activity);
  if(x.y?.olay){if(silver){x.y.olay.say(x.d,'guildDonateSilver',1);x.y.olay.say(x.d,'guildDonateSilverAmount',silver);}if(gold)x.y.olay.say(x.d,'guildDonateGold',1);}log(x,5,gold?'Gold':'Silver',gold||silver);return new Y().u32(0).u32(x.m.contribution).u32(x.m.exploit).u32(x.g.money).done();
 });
 wrap('0x01812512',0,x=>{x.requireMember();const w=new Y().u32(0).i16(x.g.depot.length);for(const r of x.g.depot)w.u32(r.kod).u32(r.article).u32(r.adet);return w.done();});
 wrap('0x01812513',null,(x,p)=>{
  x.requireLeader();if(p.length<10)deny(4);const n=p.readUInt16BE();if(!n||n>100||p.length!==10+n*12)deny(4);const recipient=target(x.g,p,2+n*12);if(!recipient)deny();const selected=[],seen=new Set();
  for(let i=0;i<n;i++){const at=2+i*12,id=p.readUInt32BE(at),code=p.readUInt32BE(at+4),amount=p.readUInt32BE(at+8),stock=x.g.depot.find(r=>r.kod===id&&r.article===code);if(!stock||!amount||amount>65535||stock.adet<amount||seen.has(id))deny();seen.add(id);selected.push({stock,code,amount});}
  for(const row of selected){row.stock.adet-=row.amount;const copy=x.g.copies[row.stock.city];if(copy){copy.history||=[];copy.history.push({profile:recipient[1].profile,code:row.code,amount:row.amount,time:x.now});copy.history=copy.history.slice(-100);delete copy.applications?.[recipient[0]];}}x.g.depot=x.g.depot.filter(r=>r.adet>0);x.r.inbox||={};(x.r.inbox[recipient[0]]||=[]).push({id:crypto.randomUUID(),sender:x.g.name,items:selected.map(({code,amount})=>({code,amount}))});log(x,2,recipient[1].profile.name);return ok();
 });
 // Legacy war information has no match without a real scheduled opponent.
 wrap('0x01812510',0,x=>new Y().u16(0).u16(0).done());
 wrap('0x01812522',0,x=>require('./lonca').cityDefend());
 wrap('0x01812700',8,x=>{deny();});wrap('0x0181020a',0,x=>{deny();});
 return H;
}
function MAX_SAFE(){return 2000000000;}
module.exports={handlers,log,target};
