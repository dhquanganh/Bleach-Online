'use strict';
// Registered-player Tournament of Throne, shared across account workers.
const {Y,O,cv,json,satir}=require('./paket');
const env=require('./envanter'),levels=require('./seviye'),codec=require('./kodek');
const clone=x=>JSON.parse(JSON.stringify(x)),fail=n=>new Y().u32(n).done();
const OFFSET=7*3600,ROUND_SECONDS=300,DISPLAY_SECONDS=1800,PAIRING_SECONDS=60;
function nextStart(now){
  const days=cv(61900003,[1,3,5]),time=cv(61900005,{hour:21,minute:5});
  const day=Math.floor((now+OFFSET)/86400);
  for(let i=0;i<8;i++){
    const date=new Date((day+i)*86400000),stamp=(day+i)*86400-OFFSET+time.hour*3600+time.minute*60;
    if(days.includes(date.getUTCDay())&&stamp>now)return stamp;
  }
  throw Error('Invalid tournament schedule');
}
function groupFor(d,v){
  const r=require('./reincarnation').record(d,levels.anaId());
  if(r.n>0)return 4;
  const lv=levels.anaDurum(v).lv;
  const i=cv(61900006,[[60,100],[101,120],[121,159]]).findIndex(([min,max])=>lv>=min&&lv<=max);
  return i<0?0:i+1;
}
function power(units){return Math.max(1,Math.min(0xffffffff,Math.round(units.reduce((sum,u)=>sum+u.maxHp/5+u.atk*2+u.def+u.speed,0))));}
function award(group,rank){
  const id=cv(61900008+group,[])[rank-1],row=satir('Award',id);
  return (json(row?.fixed,{}).fixed||[]).map(r=>({...r}));
}
function createGroup(season,group,paired=false){
  const entries=Object.values(season.registrations).filter(e=>e.group===group)
    .sort((a,b)=>(a.order??a.player.pos??0)-(b.order??b.player.pos??0)||a.player.key.localeCompare(b.player.key));
  const players=Array(8).fill(null);
  entries.forEach((entry,i)=>{players[i]={...clone(entry.player),pos:i};});
  const delay=season.registrationPhase===2?PAIRING_SECONDS:0;
  const matches=paired?Array.from({length:7},(_,i)=>({id:group*1000+i,a:i<4&&players[i*2]?i*2:null,b:i<4&&players[i*2+1]?i*2+1:null,ret:-1,done:false,time:season.start+delay+(i<4?0:i<6?ROUND_SECONDS:ROUND_SECONDS*2)})):[];
  return {players,matches,pairedAt:paired?season.start:null};
}
function winner(m){return m.ret===1?m.a:m.ret===0?m.b:null;}
function ownRank(k){
  if(!k.submission)return 0;
  const board=k.groups[k.submission.group];if(!board?.matches?.[6]||board.matches[6].ret===-1||winner(board.matches[6])===null)return 0;
  const own=board.players.findIndex(p=>p && (p.key===k.entryKey || !k.entryKey && p.own));if(own<0)return 0;
  if(winner(board.matches[6])===own)return 1;
  if([board.matches[6].a,board.matches[6].b].includes(own))return 2;
  if(board.matches.slice(4,6).some(m=>[m.a,m.b].includes(own)))return 3;
  return 4;
}
function synchronize(d,now,simulate,registry,entryKey){
  let s=d.kingChallenge;
  if(!s || s.version!==2){
    const old=s;
    const active=Object.values(registry.seasons).filter(season=>season.start<=now&&now<season.start+DISPLAY_SECONDS).sort((a,b)=>b.start-a.start)[0];
    s=d.kingChallenge={version:2,group:old?.group||1,current:{start:active?.start||nextStart(now),groups:{},bets:[],claimed:false,entryKey},archive:old?[...(old.archive||[]),...(old.current&&ownRank(old.current)?[old.current]:[])]:[],refunds:(old?.current?.bets||[]).filter(b=>!b.claimed).map(b=>b.cost).filter(Boolean)};
  }
  s.refunds=s.refunds||[];
  const seasonFor=k=>registry.seasons[k.start]||(registry.seasons[k.start]={start:k.start,registrations:{},groups:{},locked:{},registrationPhase:2,sequence:0});
  function resolve(k,group){
    const season=seasonFor(k);
    // Registration shows a list only. No opponents or bracket exist before the cutoff.
    if(now<k.start){const preview=createGroup(season,group,false);k.groups[group]=preview;return preview;}
    if(!season.groups[group] || season.groups[group].matches.length!==7)season.groups[group]=createGroup(season,group,true);
    const b=season.groups[group];
    for(let i=0;i<7;i++){
      const m=b.matches[i];
      if(m.done || now<k.start)continue;
      if(i>=4){
        const prior=i===4?[0,1]:i===5?[2,3]:[4,5];
        if(prior.some(index=>!b.matches[index].done))continue;
        m.a=winner(b.matches[prior[0]]);m.b=winner(b.matches[prior[1]]);
      }
      const a=b.players[m.a],opponent=b.players[m.b];
      if(!a&&!opponent){m.done=true;m.ret=2;continue;}
      // A bye advances immediately, even through later rounds to the final.
      if(!a||!opponent){m.done=true;m.bye=true;m.ret=a?1:0;continue;}
      if(now<m.time)continue;
      const result=simulate(a,opponent,d);
      if(!result||!Buffer.isBuffer(result.payload)||typeof result.won!=='boolean')throw Error('Tournament simulation failed');
      m.ret=result.won?1:0;m.done=true;m.report=result.payload.toString('base64');
    }
    k.groups[group]=clone(b);
    return k.groups[group];
  }
  let k=s.current;k.entryKey=entryKey;
  const currentSeason=seasonFor(k);
  // Upgrade only open registrations; never rewrite a tournament already in progress.
  if(now<k.start && currentSeason.registrationPhase!==2){currentSeason.sequence=Math.max(0,...Object.values(currentSeason.registrations).map(e=>Number(e.order)||Number(e.player.pos)||0));currentSeason.registrationPhase=2;currentSeason.groups={};currentSeason.locked={};}
  if(currentSeason.registrationPhase===2){
    const legacy=k.bets.filter(b=>!b.placedAt);
    s.refunds.push(...legacy.filter(b=>!b.claimed).map(b=>b.cost));
    k.bets=k.bets.filter(b=>b.placedAt);
  }
  const registered=currentSeason.registrations[entryKey];
  if(registered)k.submission=clone(registered);else delete k.submission;
  if(now>=k.start+DISPLAY_SECONDS){
    const relevant=new Set([k.submission?.group,...k.bets.map(b=>Math.floor(b.match/1000))].filter(Boolean));
    for(const group of relevant)resolve(k,group);
    s.archive.push(k);
    const recent=s.archive.slice(-3);
    s.archive=s.archive.filter(e=>recent.includes(e)||!e.claimed&&e.submission||e.bets.some(b=>eligibleBet(e,b)));
    s.current=k={start:nextStart(now),groups:{},bets:[],claimed:false,entryKey};
    const next=seasonFor(k).registrations[entryKey];if(next)k.submission=clone(next);
  }
  return {s,k,season:seasonFor(k),resolve:group=>resolve(k,group)};
}
function defaultSimulate(a,b,d){
  return require('./savas').kadroRapor(0,null,{ad:b.name,birimler:clone(b.units).map(u=>({...u,camp:1,hp:u.maxHp}))},{playerState:d,playerUnits:clone(a.units).map(u=>({...u,camp:0,hp:u.maxHp})),scaleEnemy:false,forceWin:false,requireEnemyDefeated:true,battleDataVersion:4});
}
function playerPacket(board){const w=new Y().u32(0).u16(board.players.filter(Boolean).length);for(const p of board.players.filter(Boolean))w.u32(p.low).u32(p.high).u32(p.model).u32(p.power).i32(p.pos).i32(p.agent).i32(p.serverId).utf(p.name).utf(p.server);return w.done();}
function fightPacket(k,board){const w=new Y().u32(0).u16(board.matches.length);for(const m of board.matches){const a=board.players[m.a],b=board.players[m.b];w.i32(m.id).u32(a?.low||0).u32(a?.high||0).u32(b?.low||0).u32(b?.high||0).i8(m.ret===2?-1:m.ret).utf(m.report?`${k.start}:${m.id}`:'');}return w.u32(board.matches[0]?.time||k.start+PAIRING_SECONDS).done();}
function betWinner(k,bet){const b=k.groups[Math.floor(bet.match/1000)],m=b?.matches.find(m=>m.id===bet.match);return m&&m.ret!==-1?b.players[winner(m)]:null;}
function betsPacket(k,prefix=true){const w=new Y();if(prefix)w.u32(0);w.u16(k.bets.length);for(const bet of k.bets){const board=k.groups[Math.floor(bet.match/1000)],m=board.matches.find(m=>m.id===bet.match),chosen=board.players[bet.side===0?m.a:m.b],win=betWinner(k,bet);w.u32(bet.match).u32(chosen.low).u32(chosen.high).u32(win?.low||0).u32(win?.high||0).i8(bet.claimed?1:0).utf(board.players[m.a]?.name||'').utf(board.players[m.b]?.name||'').utf(chosen.name);}return w.done();}
function eligibleBet(k,b){const win=betWinner(k,b),board=k.groups[Math.floor(b.match/1000)],m=board.matches.find(m=>m.id===b.match),chosen=board.players[b.side===0?m.a:m.b];return !b.claimed&&win&&win.low===chosen.low&&win.high===chosen.high;}
function basePacket(s,now){
  const k=s.current,rank=ownRank(k),pendingEntry=[...s.archive,k].find(e=>e.submission&&ownRank(e)>0&&!e.claimed),pending=!!pendingEntry;
  const w=new Y().u32(0).u32(now<k.start?0:1).u32(now<k.start?k.start:nextStart(now)).raw(betsPacket(k,false));
  return w.u8((rank?k.submission?.group:pendingEntry?.submission?.group)||k.submission?.group||0).bool(!!k.submission).u8(rank||pendingEntry&&ownRank(pendingEntry)||0).i8(pending?0:k.claimed?1:2).done();
}
function kur(y,opt={}){
  const now=opt.now||(()=>Math.floor(Date.now()/1000)),account=opt.account||(()=>levels.veriOku()),simulate=opt.simulate||defaultSimulate;
  const store=opt.store||require('./king-challenge-store').createStore();
  const key=d=>opt.accountKey?opt.accountKey(d):(process.env.BLEACH_ACCOUNT_ID||`${Number(d.roleIdHi)||1}:${Number(d.roleIdLo)||1}`);
  let transaction=null;
  const emit=(...args)=>transaction?transaction.after.push(()=>y.ekSonra(...args)):y.ekSonra(...args);
  const H={};
  function save(ctx,d,costs=[],aw=[]){
    try{
      const totals=new Map();for(const r of aw)if(r.type===1){if(!satir('Article',r.code)||r.amount<=0)return false;totals.set(r.code,(totals.get(r.code)||0)+r.amount);}
      for(const [code,amount]of totals){const before=env.mevcut(d,code);env.ekle(d,[{type:1,code,amount}]);if(env.mevcut(d,code)!==before+amount)return false;}
      const charged=costs.length?y.paraHarca(costs):null;if(costs.length&&!charged)return false;
      const refunds=d.kingChallenge.refunds||[];d.kingChallenge.refunds=[];
      try{ctx.kaydet(d);}catch(error){if(charged)y.paraIcinOdul(costs);return false;}
      transaction.commit=true;transaction.saved=true;if(charged)transaction.refund.push(...costs);
      if(refunds.length)transaction.after.push(()=>{const packet=y.paraIcinOdul(refunds,d);if(packet)y.ekSonra(0x01180105,packet,'KING-migration-refund');});
      Object.assign(ctx.durum,d);
      if(charged)emit(0x01180105,charged,'KING-cost');
      if(aw.some(r=>r.type!==1))transaction.after.push(()=>{const packet=y.paraIcinOdul(aw.filter(r=>r.type!==1),d);if(packet)y.ekSonra(0x01180105,packet,'KING-money');});
      if(aw.some(r=>r.type===1))emit(0x01180f00,env.loadBagPaketi(d),'KING-bag');
      return true;
    }catch(error){console.error('[KING]',error.message);return false;}
  }
  const withState=(ctx,fn)=>{
    const original=clone(ctx.durum),tx={commit:false,saved:false,after:[],refund:[]};transaction=tx;
    try{
      const result=store.transact(registry=>{
        const d=clone(ctx.durum),x=synchronize(d,now(),simulate,registry,key(d));
        return {result:fn(d,x),commit:tx.commit};
      });
      transaction=null;for(const effect of tx.after)effect();return result;
    }catch(error){
      transaction=null;
      if(tx.saved){try{ctx.kaydet(original);for(const key of Object.keys(ctx.durum))delete ctx.durum[key];Object.assign(ctx.durum,original);}catch(e){console.error('[KING] rollback:',e.message);}}
      if(tx.refund.length)y.paraIcinOdul(tx.refund);
      console.error('[KING]',error.message);return fail(1);
    }finally{transaction=null;}
  };
  const getGroup=payload=>{if(payload.length!==4)return 0;const g=payload.readUInt32BE(0);return g>=1&&g<=4?g:g>=1000&&g<=4000&&g%1000===0?g/1000:0;};
  const push=(ctx,d,x,group=x.s.group)=>{
    const b=x.resolve(group);emit(0x01188a01,playerPacket(b),'KING-players');emit(0x01188a03,fightPacket(x.k,b),'KING-bracket');emit(0x01188a00,basePacket(x.s,now()),'KING-state');
  };
  H['0x01818a01']=ctx=>withState(ctx,(d,x)=>{const g=getGroup(ctx.payload);if(!g)return fail(4);x.s.group=g;const b=x.resolve(g);if(!save(ctx,d))return fail(1);return playerPacket(b);});
  H['0x01818a03']=ctx=>withState(ctx,(d,x)=>{const g=getGroup(ctx.payload);if(!g)return fail(4);const b=x.resolve(g);if(!save(ctx,d))return fail(1);return fightPacket(x.k,b);});
  H['0x01818a02']=ctx=>withState(ctx,(d,x)=>{const g=getGroup(ctx.payload);if(!g)return fail(4);const b=x.resolve(g),players=b.players.filter(Boolean).sort((a,b)=>b.power-a.power);if(!save(ctx,d))return fail(1);const w=new Y().u32(0).u16(players.length);players.forEach((p,i)=>w.u32(p.low).u32(p.high).i32(p.agent).i32(p.serverId).utf(p.server).utf(p.name).u32(i+1).u32(p.power));return w.done();});
  H['0x01818a00']=ctx=>withState(ctx,(d,x)=>{if(ctx.payload.length)return fail(4);for(const g of new Set([x.k.submission?.group,...x.k.bets.map(b=>Math.floor(b.match/1000))].filter(Boolean)))x.resolve(g);if(!save(ctx,d))return fail(1);return basePacket(x.s,now());});
  H['0x01818a07']=ctx=>withState(ctx,(d,x)=>{
    if(ctx.payload.length)return fail(4);
    const reject=message=>new Y().u32(1).utf(message).done();
    if(now()>=x.k.start)return reject('?? ch?t ??ng k? cho gi?i n?y.');
    const v=account(),group=groupFor(d,v);if(!group)return reject('C?n c?p 60 tr? l?n ho?c ?? chuy?n sinh ?? ??ng k?.');
    const units=opt.snapshot?opt.snapshot(d):require('./savas').playerTeam({playerState:d});
    if(!units.length||units.length>7||new Set(units.map(u=>u.pos)).size!==units.length||units.some(u=>!satir('BaseHero',u.id)||!require('./retired-heroes').allowed(u.id)||u.pos<1||u.pos>15||!Number.isFinite(u.maxHp)||u.maxHp<=0))return fail(4);
    const player={own:true,low:Number(d.roleIdLo)||1,high:Number(d.roleIdHi)||1,model:levels.anaId(),name:d.nick||'Player',server:'Local Player',agent:Number(d.agent)||0,serverId:Number(d.server)||1,power:power(units),units:clone(units)};
    const key=x.k.entryKey,existing=x.season.registrations[key];
    if(x.season.locked[key])return reject('?? c? c??c cho c?p ??u c?a b?n; kh?ng th? ??i ??i h?nh.');
    const entries=Object.values(x.season.registrations).filter(e=>e.group===group&&e.player.key!==key);
    if(entries.length>=8)return reject('Nh?m n?y ?? ?? 8 ng??i ??ng k?.');
    const occupied=new Set(entries.map(e=>e.player.pos));
    const pos=existing?.group===group?existing.player.pos:Array.from({length:8},(_,i)=>i).find(i=>!occupied.has(i));
    player.key=key;player.pos=pos;delete player.own;
    const entry={group,player,time:now(),order:existing?.order??existing?.player.pos??++x.season.sequence};
    if(existing)delete x.season.groups[existing.group];
    x.season.registrations[key]=clone(entry);delete x.season.groups[group];
    x.k.submission=entry;delete x.k.groups[group];
    if(!save(ctx,d))return fail(1);push(ctx,d,x);return fail(0);
  });
  H['0x01818a05']=ctx=>withState(ctx,(d,x)=>{
    if(ctx.payload.length!==8)return fail(4);const id=ctx.payload.readUInt32BE(0),side=ctx.payload.readUInt32BE(4),g=Math.floor(id/1000);if(side>1||g<1||g>4||id%1000>6)return fail(4);
    if(now()<x.k.start)return fail(1);
    const board=x.resolve(g),m=board.matches[id%1000];if(!m||now()>=m.time||m.ret!==-1||!board.players[m.a]||!board.players[m.b]||x.k.bets.some(b=>b.match===id))return fail(1);
    if(!groupFor(d,account()))return fail(4);
    const cost=json(cv(61900007,{type:0,code:2,amount:50}),{});if(cost.type!==0||![0,1,2].includes(cost.code)||!(cost.amount>0))return fail(4);
    x.k.bets.push({match:id,side,claimed:false,cost,placedAt:now()});
    x.season.locked[board.players[m.a].key]=true;x.season.locked[board.players[m.b].key]=true;
    return save(ctx,d,[cost])?betsPacket(x.k):fail(16);
  });
  H['0x01818a06']=ctx=>withState(ctx,(d,x)=>{
    if(ctx.payload.length!==8)return fail(4);const mode=ctx.payload.readUInt32BE(0),id=ctx.payload.readUInt32BE(4);if(mode>1||mode===0&&id!==0)return fail(4);
    for(const g of new Set(x.k.bets.map(b=>Math.floor(b.match/1000))))x.resolve(g);
    let selected=[];for(const k of mode===0?[...x.s.archive,x.k]:[x.k])for(const b of k.bets)if((!mode||b.match===id)&&eligibleBet(k,b))selected.push(b);
    if(!selected.length)return fail(1);
    // A winning wager returns the stake plus the configured profit, in the same currency.
    const totals=new Map();for(const b of selected){b.claimed=true;const key=`${b.cost.type}:${b.cost.code}`;const r=totals.get(key)||{type:b.cost.type,code:b.cost.code,amount:0};r.amount+=b.cost.amount+Number(cv(61900008,50));totals.set(key,r);}
    return save(ctx,d,[],[...totals.values()])?betsPacket(x.k):fail(1);
  });
  H['0x01818a04']=ctx=>withState(ctx,(d,x)=>{
    if(ctx.payload.length)return fail(4);if(x.k.submission)x.resolve(x.k.submission.group);
    const rewards=[];for(const k of [...x.s.archive,x.k]){const rank=ownRank(k);if(!k.submission||!rank||k.claimed)continue;const aw=award(k.submission.group,rank);if(!aw.length)return fail(4);k.claimed=true;rewards.push(...aw);}
    if(!rewards.length||!save(ctx,d,[],rewards))return fail(1);
    emit(0x01188a00,basePacket(x.s,now()),'KING-claim');
    return new Y().u32(0).i8(1).odul(rewards).done();
  });
  H['0x01818a08']=ctx=>withState(ctx,(d,x)=>{if(ctx.payload.length)return fail(4);const group=x.s.group,b=x.resolve(group),p=!b.matches[6]||b.matches[6].ret===-1?null:b.players[winner(b.matches[6])];if(!save(ctx,d)||!p)return fail(1);return new Y().u32(0).u32(p.model).utf(p.name).done();});
  H['0x01818a09']=ctx=>withState(ctx,(d,x)=>{
    const r=new O(ctx.payload),token=r.utf();if(r.kalan()||ctx.payload.length<2)return fail(4);
    const m=/^(\d+):(\d+)$/.exec(token);if(!m)return fail(4);const start=Number(m[1]),id=Number(m[2]),k=[...x.s.archive,x.k].find(k=>k.start===start),g=Math.floor(id/1000);if(!k||g<1||g>4||id%1000>6)return fail(4);
    if(k===x.k)x.resolve(g);const fight=k.groups[g]?.matches.find(f=>f.id===id);if(!fight?.report)return fail(1);
    if(!save(ctx,d))return fail(1);
    emit(codec.OP.REPORT,Buffer.from(fight.report,'base64'),'KING-replay');emit(codec.OP.RESULT,codec.encodeSingleResult(fight.ret===1,[]),'KING-replay-result');return fail(0);
  });
  const replay=H['0x01818a09'];
  H['0x01818a09']=ctx=>({id:0x01188a09,payload:replay(ctx)});
  return H;
}
module.exports={kur,nextStart,groupFor,award,ownRank,synchronize,playerPacket,fightPacket,basePacket,betsPacket,defaultSimulate,ROUND_SECONDS,DISPLAY_SECONDS,PAIRING_SECONDS};
