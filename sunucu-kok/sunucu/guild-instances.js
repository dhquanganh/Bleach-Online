'use strict';
const {Y,tablo,satir,json,cv}=require('./paket'),C=require('./guild'),{deny,exact,cap}=C,codec=require('./kodek');
const cities=type=>tablo('City').liste.filter(c=>c.type===type).sort((a,b)=>a._id-b._id);
function city(id,type){const c=satir('City',id);if(!c||c.type!==type)deny(4);return c;}
function point(c,index){if(!Number.isInteger(index)||index<0||c.start+index>c.last)deny(4);const p=satir('OrgPointInfo',c.start+index);if(!p)deny(4);return p;}
function single(x,c){return x.m.single[c._id]||=( {nokta:0,savas:{},sifirlama:{}} );}
function daily(x,c){return x.m.daily.single[c._id]||={fights:{},resets:{}};}
function unlocked(x){let n=-1;for(const c of cities(6)){if(x.profile.level<c.openLevel)break;n++;if((single(x,c).nokta||0)<c.last-c.start+1)break;}return n;}
function requireSingle(x,c,index){x.requireMember();if(cities(6).findIndex(r=>r._id===c._id)>unlocked(x))deny();const s=single(x,c);if(index>s.nokta)deny();return s;}
function singlePacket(x,c){const s=single(x,c),d=daily(x,c),keys=Object.keys(d.fights).map(Number).filter(i=>i>=0&&i<=c.last-c.start);const w=new Y().u32(0).i32(s.nokta||0).i16(keys.length);for(const i of keys)w.i32(i).i32(d.fights[i]||0).i32(d.resets[i]||0);return w.done();}
function units(p){const out=[],battle=require('./savas');for(const aid of json(p.army,{}).army||[]){const army=satir('EnemyArmy',aid);if(!army)deny();for(const [field,start]of [['front',1],['middle',6],['back',11]]){for(const [i,id]of (json(army[field],{})[field]||[]).entries()){const e=satir('Enemy',id);if(!e||start+i>15||out.some(u=>u.pos===start+i))deny();out.push(battle.dusmanBirim({...e,id:id.toString(16)},start+i));}}}if(!out.length||out.length>9)deny();return out;}
function rewards(id,random=Math.random){const row=satir('Award',id);if(!row)return [];const out=[...(json(row.fixed,{}).fixed||[])];for(const group of json(row.f1,{}).rewards||[])if(random()<=Number(group.rate))out.push(...group.value);return out;}
function group(x,c){const g=x.g.copies[c._id];if(!g)deny();return g;}
function fightKey(x,c){return c._id+':'+(group(x,c).generation||1);}
function groupPacket(x,c){const g=group(x,c),w=new Y().u32(0).i32(g.point);if(g.point>c.last-c.start)return w.i32(0).i16(0).done();const p=point(c,g.point),team=units(p),total=team.reduce((n,u)=>n+u.maxHp,0),remaining=team.reduce((n,u)=>n+u.maxHp*(g.rates?.[u.pos]??100)/100,0);w.i32(Math.ceil(remaining/total*100)).i16(team.length);for(const u of team)w.i32(u.pos).i32(Math.max(0,Math.ceil(g.rates?.[u.pos]??100)));return w.done();}
function rollFight(x,c,p,groupState,opt){
 const team=units(p);if(groupState)for(const u of team)u.hp=Math.max(0,Math.round(u.maxHp*(groupState.rates?.[u.pos]??100)/100));
 const result=opt.simulate?opt.simulate({city:c,point:p,units:team,playerState:x.d}):require('./savas').kadroRapor(0,null,{ad:p.name,birimler:team.map(u=>({...u}))},{playerState:x.d,scaleEnemy:false,forceWin:false,requireEnemyDefeated:true,reportLossWhenDefeated:true,battleDataVersion:4,strictSkillTargets:true,remainingPositions:true});
 if(!result||!Buffer.isBuffer(result.payload)||typeof result.won!=='boolean')deny();return {result,team};
}
function active(x,n){const earned=Math.min(n,Math.max(0,Number(C.base(x.g.level).dayMaxActivity)-(x.m.daily.active||0)));x.m.daily.active=(x.m.daily.active||0)+earned;x.g.groupActive=Math.min(Number(C.base(x.g.level).guildMaxActivity),x.g.groupActive+earned*Number(cv(60800004,1)));}
function rank(copy){return Object.entries(copy.damage||{}).sort((a,b)=>b[1].amount-a[1].amount||a[0].localeCompare(b[0]));}
function spoils(x,c){const stock=x.g.depot.filter(r=>r.city===c._id),copy=group(x,c),apps=copy.applications||={},mine=apps[x.key],ranking=rank(copy),w=new Y().u32(0).i16(stock.length);
 for(const row of stock){const requests=Object.values(apps).filter(a=>a.code===row.article);w.i16(1).i32(row.article).i32(row.adet).i32(mine?.code===row.article?1:0).i32(mine?.code===row.article?ranking.findIndex(([k])=>k===x.key)+1:0).i32(requests.length);}
 w.i32(mine?1:0);if(mine)w.i32(1).i32(mine.code).i32(ranking.findIndex(([k])=>k===x.key)+1);return w.done();}
function handlers(service,opt={}){
 const H={},wrap=(id,n,fn)=>H[id]=ctx=>service.run(ctx,x=>{if(n!==null)exact(ctx.payload,n);x.requireMember();return fn(x,ctx.payload);});
 wrap('0x01812523',0,x=>new Y().u32(0).i32(unlocked(x)).done());
 wrap('0x01812524',4,(x,p)=>{const c=city(p.readUInt32BE(),6);requireSingle(x,c,0);return singlePacket(x,c);});
 wrap('0x01817800',8,(x,p)=>{
  const c=city(p.readUInt32BE(),6),index=p.readUInt32BE(4),s=requireSingle(x,c,index),entry=point(c,index),d=daily(x,c);if((d.fights[index]||0)>=entry.remainingNumber)deny();x.charge({askeriEmir:Number(entry.actionEexertion)||0});
  const {result}=rollFight(x,c,entry,null,opt);d.fights[index]=(d.fights[index]||0)+1;const awarded=result.won?rewards(entry.showRateAward,opt.random):[];x.award(awarded);active(x,Number(cv(60800002,2)));
  if(result.won){s.nokta=Math.max(s.nokta,index+1);x.m.groupMoney=cap(x.m.groupMoney+Number(cv(60810002,[])[index]?.amount||0));if(s.nokta>=c.last-c.start+1)x.g.unlockedGroups=Math.max(x.g.unlockedGroups,cities(6).findIndex(r=>r._id===c._id)+1);if(x.y.olay)x.y.olay.say(x.d,'guildInstanceWin',1);}
  x.mark();x.packets.push({id:codec.OP.REPORT,payload:result.payload},{id:codec.OP.RESULT,payload:codec.encodeSingleResult(result.won,awarded)});return new Y().u32(0).done();
 });
 wrap('0x01817801',8,(x,p)=>{const c=city(p.readUInt32BE(),6),index=p.readUInt32BE(4);requireSingle(x,c,index);point(c,index);const d=daily(x,c),n=d.resets[index]||0,prices=cv(60800003,[]);if(!(d.fights[index]>0)||n>=prices.length)deny();x.charge({altin:Number(prices[n])});d.fights[index]=0;d.resets[index]=n+1;return new Y().u32(0).i32(n+1).done();});
 wrap('0x01817802',12,(x,p)=>{const c=city(p.readUInt32BE(),6),index=p.readUInt32BE(4),count=p.readUInt32BE(8),s=requireSingle(x,c,index),entry=point(c,index),d=daily(x,c);if(!count||count>entry.remainingNumber||index>=s.nokta||(d.fights[index]||0)+count>entry.remainingNumber)deny();x.charge({askeriEmir:Number(entry.actionEexertion)*count});let awarded=[];for(let i=0;i<count;i++)awarded.push(...rewards(entry.showRateAward,opt.random));x.award(awarded);d.fights[index]=(d.fights[index]||0)+count;active(x,count*Number(cv(60800002,2)));x.m.groupMoney=cap(x.m.groupMoney+count*Number(cv(60810002,[])[index]?.amount||0));x.mark();return new Y().u32(0).i32(d.fights[index]).odul(awarded).done();});
 wrap('0x01812526',0,x=>{const list=cities(7),w=new Y().u32(0).i32((x.g.unlockedGroups||0)-1);let n=0;while(n<list.length&&x.g.copies[list[n]._id])n++;w.i16(n);for(const c of list.slice(0,n))w.i32(x.m.daily.groupFights[fightKey(x,c)]||0).i32(x.g.copies[c._id].opened);return w.done();});
 function open(x,p,reset){const c=city(p.readUInt32BE(),7),index=p.readUInt32BE(4),list=cities(7);x.requireLeader();if(list[index]?._id!==c._id||index>=(x.g.unlockedGroups||0))deny();const previous=x.g.copies[c._id];if(reset?(!previous||previous.point<=c.last-c.start):!!previous)deny();if(index>0&&!x.g.copies[list[index-1]._id])deny();const cost=Number(cv(reset?60800010:60800009,[])[index]);if(!(cost>0)||x.g.groupActive<cost)deny();x.g.groupActive-=cost;x.g.copies[c._id]={point:0,rates:{},opened:x.now,generation:(previous?.generation||0)+1,damage:{},applications:{}};x.mark();return new Y().u32(0).i32(index).i32(x.now).done();}
 wrap('0x01812527',8,(x,p)=>open(x,p,false));wrap('0x01812529',8,(x,p)=>open(x,p,true));
 wrap('0x01812528',4,(x,p)=>groupPacket(x,city(p.readUInt32BE(),7)));
 wrap('0x01817803',8,(x,p)=>{
  const c=city(p.readUInt32BE(),7),index=p.readUInt32BE(4),copy=group(x,c),entry=point(c,index);if(index!==copy.point||(x.m.daily.groupFights[fightKey(x,c)]||0)>=Number(cv(60800005,5)))deny();
  const {result,team}=rollFight(x,c,entry,copy,opt);if(!Array.isArray(result.remainingHp))deny();let damage=0;const rates={};
  for(const u of team){const remaining=result.remainingHp.find(r=>r.camp===1&&(r.pos!==undefined?r.pos===u.pos:r.id===u.id));if(!remaining||!Number.isFinite(remaining.rate)||remaining.rate<0||remaining.rate>1)deny();rates[u.pos]=remaining.rate*100;damage+=Math.max(0,u.hp-u.maxHp*remaining.rate);}
  const won=team.every(u=>rates[u.pos]<=0);if(result.won!==won&&result.won)deny();x.m.daily.groupFights[fightKey(x,c)]=(x.m.daily.groupFights[fightKey(x,c)]||0)+1;copy.rates=rates;
  copy.damage[x.key]||={amount:0,profile:x.profile};copy.damage[x.key].amount+=Math.round(damage);if(damage>0)x.m.groupMoney=cap(x.m.groupMoney+Number(cv(60810002,[])[index]?.amount||0));
  if(won){const loot=rewards(entry.guildRateAward,opt.random);for(const a of loot){const code=require('./envanter').odulTemplate(a.type,a.code);if(!satir('Article',code)||a.amount<=0)deny();const existing=x.g.depot.find(r=>r.city===c._id&&r.article===code);if(existing)existing.adet+=a.amount;else{x.g.depotSeq=(x.g.depotSeq||0)+1;x.g.depot.push({kod:x.g.depotSeq,article:code,adet:a.amount,city:c._id});}}copy.point++;copy.rates={};}
  active(x,Number(cv(60800002,2)));x.mark();x.packets.push({id:codec.OP.REPORT,payload:result.payload},{id:codec.OP.RESULT,payload:codec.encodeSingleResult(won,[])},{id:0x01187804,payload:groupPacket(x,c)});return new Y().u32(0).done();
 });
 H['0x01817804']=ctx=>{if(ctx.payload.length!==4)return false;return false;};
 wrap('0x01817900',4,(x,p)=>{const c=city(p.readUInt32BE(),7),rows=group(x,c).history||[],w=new Y().u32(0).i16(rows.length);for(const r of rows)w.u32(r.profile.hi).u32(r.profile.lo).utf(r.profile.name).i16(1).i32(r.code).i32(r.amount).i32(r.time);return w.done();});
 wrap('0x01817901',4,(x,p)=>spoils(x,city(p.readUInt32BE(),7)));
 wrap('0x01817902',4,(x,p)=>{const c=city(p.readUInt32BE(),7),copy=group(x,c),ranking=rank(copy),w=new Y().u32(0).i16(ranking.length);ranking.forEach(([key,r],i)=>w.u32(r.profile.hi).u32(r.profile.lo).utf(r.profile.name).i64(r.amount).i32(i+1));return w.done();});
 wrap('0x01817903',14,(x,p)=>{const c=city(p.readUInt32BE(),7),type=p.readUInt16BE(4),code=p.readUInt32BE(6),count=p.readUInt32BE(10),copy=group(x,c),stock=x.g.depot.find(r=>r.city===c._id&&r.article===code);if(type!==1||!stock||!count||count>stock.adet||!copy.damage[x.key]?.amount||copy.applications[x.key])deny();copy.applications[x.key]={code,count,at:x.now};x.mark();return spoils(x,c);});
 wrap('0x01817904',14,(x,p)=>{const c=city(p.readUInt32BE(),7),copy=group(x,c),code=p.readUInt32BE(6);if(p.readUInt16BE(4)!==1||!p.readUInt32BE(10))deny(4);const ranking=rank(copy),rows=Object.entries(copy.applications||{}).filter(([key,a])=>a.code===code),w=new Y().u32(0).i16(rows.length);for(const [key,a]of rows){const profile=copy.damage[key]?.profile||x.g.members[key]?.profile;if(!profile)deny();w.u32(profile.hi).u32(profile.lo).utf(profile.name).i32(ranking.findIndex(([k])=>k===key)+1);}return w.done();});
 return H;
}
module.exports={handlers,cities,units,rewards,singlePacket,groupPacket};
