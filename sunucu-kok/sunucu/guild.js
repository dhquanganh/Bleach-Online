'use strict';
const fs=require('node:fs'),crypto=require('node:crypto'),{Y,O,cv,tablo,satir,json}=require('./paket'),G=require('./guild-store'),env=require('./envanter');
const copy=structuredClone,MAX=2000000000,cap=n=>Math.max(0,Math.min(MAX,Math.floor(Number(n)||0))),error=n=>new Y().u32(n).done();
function deny(code=1){throw Object.assign(Error('Guild request rejected'),{guildCode:code});}
function exact(p,n){if(!Buffer.isBuffer(p)||p.length!==n)deny(4);}
function utf(p,max){if(!Buffer.isBuffer(p)||p.length<2||p.readUInt16BE()!==p.length-2)deny(4);const s=p.toString('utf8',2).trim();if(!s||s.length>max||/[\x00-\x1f]/.test(s))deny(4);return s;}
function day(now){return new Date((now+25200)*1000).toISOString().slice(0,10);}
function atomic(file,value){const tmp=file+'.guild.tmp';fs.writeFileSync(tmp,JSON.stringify(value,null,2));fs.renameSync(tmp,file);}
function member(profile,legacy={}){return {profile,role:0,contribution:cap(legacy.katkim),exploit:cap(legacy.exploit),tech:copy(legacy.tech||{1:0,2:0,3:0,4:0,5:0}),groupMoney:cap(legacy.groupMoney),single:copy(legacy.kopya?.tek||{}),daily:{},personalVersion:0,mail:[]};}
function guild(id,name,family,legacy={}){return {id,name,family,level:Math.max(1,Math.min(51,Number(legacy.seviye)||1)),money:cap(legacy.para),notice:legacy.duyuru||'',camp:copy(legacy.kamp||{1:1,2:1,4:1}),members:{},applications:{},depotSeq:Math.max(0,...(legacy.depo||[]).map(r=>Number(r.kod)||0)),depot:copy(legacy.depo||[]),log:[],copies:{},groupActive:cap(legacy.groupActive),unlockedGroups:0,revision:1};}
function rollover(m,now){if(m.daily?.day!==day(now))m.daily={day:day(now),silver:0,contribution:0,active:0,groupFights:{},single:{},shop:{}};m.daily.groupFights||={};m.daily.single||={};m.daily.shop||={};}
function project(d,g,m){
 if(!g||!m){delete d.lonca;return;}
 const leader=Object.values(g.members).find(m=>m.role===2);
 d.lonca={id:g.id,ad:g.name,family:g.family,seviye:g.level,para:g.money,duyuru:g.notice,kamp:copy(g.camp),tech:copy(m.tech),katkim:m.contribution,exploit:m.exploit,groupMoney:m.groupMoney,bugunKatki:m.daily.contribution||0,myActive:m.daily.active||0,groupActive:g.groupActive,gunlukGumus:m.daily.silver||0,kopya:{tek:copy(m.single),grup:{acik:{}}},depo:copy(g.depot),log:copy(g.log),guildProjection:true,personalVersion:m.personalVersion,projectedExploit:m.exploit,leader:leader?.profile.name||'',power:m.role};
}
function info(g,m){if(!g||!m)return new Y().u32(0).done();const leader=Object.values(g.members).find(x=>x.role===2),w=new Y().u32(g.id).utf(g.name).i16(g.family).u32(g.money).utf(leader?.profile.name||'').u32(g.level).u32(m.contribution).u32(Object.keys(g.members).length).u32(m.exploit).utf(g.notice).i8(m.role).i32(m.daily.active||0).i32(g.groupActive).i16(5);for(let i=1;i<=5;i++)w.u32(i).u32(m.tech[i]||0);return w.done();}
function memberList(g,now=Math.floor(Date.now()/1000)){const w=new Y().u32(0),members=g?Object.values(g.members):[];w.i16(members.length);for(const m of members){const p=m.profile;w.u32(p.hi).u32(p.lo).utf(p.name).u32(p.rank).u32(p.level).u32(m.role).u32(m.daily.contribution||0).u32(m.contribution).u32(now-p.seen<90?0:p.seen).u32(p.power||0).u32(m.daily.active||0);}return w.done();}
function base(level){return tablo('OrganizationBase').liste.find(r=>Number(r.orgLevel)===level);}
function addition(level){return tablo('OrganizationAddition').liste.find(r=>Number(r.orgLevel)===level);}
function profile(d,v,now){let power=0;try{const units=require('./savas').playerTeam({playerState:d});power=cap(units.reduce((n,u)=>n+u.maxHp/5+u.atk*2+u.def+u.speed,0));}catch(e){}return {hi:Number(d.roleIdHi)||0,lo:Number(d.roleIdLo)||1,name:d.karakter?.nick||d.nick||'Player',level:Math.max(Number(v.level)||1,require('./reincarnation').record(d,d.karakter?.anaId||require('./seviye').anaId()).history||0),rebirthLevel:Number(v.level)||1,rank:require('./military-rank').id(d),family:Number(d.country)||0,power,seen:now};}
function create(y,opt={}){
 const store=opt.store||G.createStore(),runtime=opt.runtime||require('./runtime-path'),key=opt.key||G.key,now=opt.now||(()=>Math.floor(Date.now()/1000));
 function recover(d){
  const actor=key(d||{}),pending=store.transact(reg=>({result:copy(G.root(reg).pending[actor]||null),commit:false}));if(!pending)return false;
  const currencyFile=runtime('veri.json'),playerFile=runtime('oyuncu.json'),v=JSON.parse(fs.readFileSync(currencyFile,'utf8')),player=fs.existsSync(playerFile)?JSON.parse(fs.readFileSync(playerFile,'utf8')):{};
  if(v.guildCurrencyReceipt!==pending.id)atomic(currencyFile,{...pending.v,guildCurrencyReceipt:pending.id});
  if(player.guildReceipt!==pending.id)atomic(playerFile,{...pending.d,guildReceipt:pending.id});
  store.transact(reg=>{const r=G.root(reg);if(r.pending[actor]?.id===pending.id)delete r.pending[actor];return {commit:true,result:null};});
  if(d){const restored=JSON.parse(fs.readFileSync(playerFile,'utf8'));for(const k of Object.keys(d))delete d[k];Object.assign(d,restored);}return true;
 }
 function run(ctx,fn,onError=error){
  let result,packets=[],changed=false,statsChanged=false;
  try{
   recover(ctx.durum);const actor=key(ctx.durum),stamp=now();
   result=store.transact(reg=>{
    const r=G.root(reg),d=copy(ctx.durum),v=JSON.parse(fs.readFileSync(runtime('veri.json'),'utf8')),p=opt.profile?opt.profile(d,v,stamp):profile(d,v,stamp);
    let g=r.guilds[r.membership[actor]],m=g?.members[actor];
    if(!r.migrated[actor]){
     r.migrated[actor]=true;
     if(!m&&d.lonca?.id&&!d.lonca.guildProjection){const legacy=d.lonca;g=Object.values(r.guilds).find(x=>x.name===legacy.ad&&x.family===(legacy.family||p.family));if(!g){const id=r.nextId++;g=r.guilds[id]=guild(id,legacy.ad||'Guild',legacy.family||p.family,legacy);g.leader=actor;}
      m=g.members[actor]=member(p,legacy);
      const groupCities=tablo('City').liste.filter(c=>c.type===7).sort((a,b)=>a._id-b._id);for(let i=0;i<groupCities.length;i++){const old=legacy.kopya?.grup?.acik?.[i];if(!old)break;const city=groupCities[i];g.copies[city._id]||={point:0,rates:{},opened:cap(old.zaman)||stamp,generation:1,damage:{},applications:{}};g.unlockedGroups=Math.max(g.unlockedGroups||0,i+1);}
      m.role=g.leader===actor?2:0;r.membership[actor]=g.id;changed=true;
     }
    }
    if(g)for(const member of Object.values(g.members))rollover(member,stamp);
    if(m){rollover(m,stamp);if(d.lonca?.guildProjection&&d.lonca.personalVersion===m.personalVersion&&cap(d.lonca.exploit)>cap(d.lonca.projectedExploit))m.exploit=cap(m.exploit+cap(d.lonca.exploit)-cap(d.lonca.projectedExploit));m.profile=p;}
    const x={r,d,v,g,m,y,key:actor,profile:p,now:stamp,packets,requireMember(){if(!this.g||!this.m)deny();},requireLeader(){this.requireMember();if(this.m.role!==2)deny();},mark(){changed=true;},charge(costs){for(const [field,n]of Object.entries(costs))if(!Number.isSafeInteger(n)||n<0||cap(v[field])<n)deny(field==='altin'?16:13);for(const [field,n]of Object.entries(costs)){v[field]=cap(v[field])-n;if(field==='altin'&&n)require('./ultimate-bp-spending').earn(v,n);}this.moneyChanged=true;},award(rewards){const totals=new Map();for(const a of rewards){const fields={'0:0':'gumus','0:1':'altin','0:2':'kupon','3:0':'askeriEmir','5:0':'prestij','6:0':'generalsSoul','7:3':'blueSoul','7:4':'purpleSoul','7:5':'goldSoulV','7:6':'orangeSoul'};if(fields[a.type+':'+a.code]){const f=fields[a.type+':'+a.code];v[f]=cap(cap(v[f])+a.amount);this.moneyChanged=true;continue;}const code=env.odulTemplate(a.type,a.code);if(!env.article(code)||!Number.isSafeInteger(a.amount)||a.amount<=0)deny();totals.set(code,(totals.get(code)||0)+a.amount);}const before=new Map([...totals].map(([id])=>[id,env.mevcut(d,id)]));if([...totals].some(([id,n])=>before.get(id)+n>env.MAX_ADET))deny();env.ekle(d,[...totals].map(([code,amount])=>({type:1,code,amount})));if([...totals].some(([id,n])=>env.mevcut(d,id)!==before.get(id)+n))deny();if(totals.size)this.bagChanged=true;},refreshStats(){statsChanged=true;}};
    if(g&&m)for(const c of tablo('City').liste.filter(c=>c.type===6))if((m.single[c._id]?.nokta||0)>=c.last-c.start+1)g.unlockedGroups=Math.max(g.unlockedGroups||0,tablo('City').liste.filter(c=>c.type===6).sort((a,b)=>a._id-b._id).findIndex(r=>r._id===c._id)+1);
    const previousTech=JSON.stringify(d.lonca?.tech||{}),previousGuild=d.lonca?.id;const response=fn(x);g=x.g;m=x.m;if(previousGuild!==g?.id||previousTech!==JSON.stringify(m?.tech||{}))statsChanged=true;
    if(m){rollover(m,stamp);m.personalVersion++;}
    for(const parcel of [...(r.inbox?.[actor]||[]),...(m?.mail||[])]){
      const box=d.posta||={gelen:[],giden:[],seq:1};if(!box.gelen.some(mail=>mail.guildGrantId===parcel.id)){box.seq=Math.max(Number(box.seq)||1,...box.gelen.map(mail=>Number(mail.lo)+1));const mail={hi:0,lo:box.seq++,ad:parcel.sender||g?.name||'Guild',konu:'Guild rewards',metin:'Guild instance distribution.',zaman:stamp,okundu:0,ek:parcel.items.map(a=>[a.code,a.amount]),guildGrantId:parcel.id};box.gelen.push(mail);packets.push({id:0x01181605,payload:require('./boss-reward-mail').notification(mail)});}
    }
    if(m)m.mail=[];if(r.inbox)delete r.inbox[actor];
    project(d,g,m);if(x.bagChanged)packets.push({id:0x01180f00,payload:env.loadBagPaketi(d)});
    if(x.moneyChanged){const values=[['gumus',0],['kupon',1],['askeriEmir',2],['altin',3],['generalsSoul',4],['prestij',5],['blueSoul',7],['purpleSoul',8],['goldSoulV',9],['orangeSoul',10]];packets.push({id:0x01180105,payload:require('./harita').baseInfoUpdate(values.filter(([k])=>v[k]!==undefined).map(([k,index])=>index===0?{index,v:Number(v.gumusHigh)||0,a:v[k]}:{index,v:v[k]}))});}
    r.pending[actor]={id:crypto.randomUUID(),d,v};return {commit:true,result:response};
   });
   recover(ctx.durum);try{if(statsChanged){const d=ctx.durum,v=JSON.parse(fs.readFileSync(runtime('veri.json'),'utf8'));for(const id of require('./seviye').kadroIds(d)){const packet=require('./ekipman').statPaketi(d,id,require('./seviye').heroDurum(d,id,v).lv);if(packet)packets.push({id:0x01180104,payload:packet});}}}catch(e){console.error('[Guild stats notification]',e.message);}for(const p of packets)try{y.ekSonra(p.id,p.payload,'GUILD-live');}catch(e){console.error('[Guild notification]',e.message);}if(changed&&process.connected)try{process.send({type:'guild-changed'},()=>{});}catch(e){console.error('[Guild sync]',e.message);}return result;
  }catch(e){if(!e.guildCode)console.error('[Guild]',e.message);return onError(e.guildCode||1);}
 }
 return {run,recover,runtime,store,key,now};
}
function bonuses(d){let tech=d.lonca?.tech||{};try{const r=G.read(),g=r.guilds[r.membership[G.key(d)]],m=g?.members[G.key(d)];if(m)tech=m.tech;else if(d.lonca?.guildProjection)return [];}catch(e){}const map={1:[[6,'atkAddition'],[8,'atkAddition']],2:[[7,'physDefAddition']],3:[[9,'magDefAddition']],4:[[4,'lifeAddition']],5:[[5,'speedAddition']]};return Object.entries(map).flatMap(([id,rows])=>rows.map(([index,field])=>({index,value:Number(addition(Math.min(50,Number(tech[id])||0))?.[field])||0})));}
function kur(y,opt={}){const service=create(y,opt);return {...require('./guild-operations').handlers(service),...require('./guild-instances').handlers(service,opt)};}
function recover(){const runtime=require('./runtime-path');if(fs.existsSync(runtime('oyuncu.json')))create({ekSonra(){}}).recover(JSON.parse(fs.readFileSync(runtime('oyuncu.json'),'utf8')));}
module.exports={kur,recover,create,member,guild,project,info,memberList,base,addition,bonuses,deny,exact,utf,cap,day,error};
