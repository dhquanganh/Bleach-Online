'use strict';
// Server-authoritative arena. No client supplied power, damage, score or elapsed time.
const crypto = require('crypto');
const defaults = require('./battlefield-config.json');
const copy = x => JSON.parse(JSON.stringify(x));
const distance = (a,b) => Math.hypot(a.x-b.x,a.y-b.y);
const spawn = team => team === 0 ? {x:120,y:340} : {x:880,y:340};
function settings(overrides={}) {
  const c={...defaults,...overrides,points:{...defaults.points,...overrides.points},honor:{...defaults.honor,...overrides.honor}};
  for(const key of ['minLevel','matchSeconds','rounds','prepareSeconds','intermissionSeconds','initialResources','respawnSeconds','spawnProtectionSeconds','moveSpeed','attackRange','attackCooldown','skillCooldown','captureSeconds','captureRadius','captureCooldown','guardRespawnSeconds','accumulationDivisor','activityReward','itemCharges','botCount','maxPlayers','arenaWidth','arenaHeight']) {
    if(!Number.isFinite(c[key]) || c[key]<0) throw Error('Invalid battlefield setting: '+key);
  }
  if(c.rounds!==2 || c.matchSeconds<2 || c.accumulationDivisor<1 || c.moveSpeed<1 || c.attackCooldown<1 || c.captureSeconds<1 || c.maxPlayers<2 || c.botCount>=c.maxPlayers) throw Error('Invalid battlefield configuration');
  for(const key of ['minLevel','matchSeconds','botCount','maxPlayers','itemCharges','initialResources','accumulationDivisor'])if(!Number.isSafeInteger(c[key]))throw Error('Invalid integer battlefield setting: '+key);
  if(c.maxPlayers>120)throw Error('Invalid battlefield capacity: maximum 120 for Flash UTF snapshots');
  if(typeof c.botOnlyOpponents!=='boolean')throw Error('Invalid battlefield bot mode');
  if(!['formation','realtime'].includes(c.combatMode))throw Error('Invalid battlefield combat mode');
  for(const key of ['duelCooldownSeconds','duelDisplaySeconds','duelAccumulatedPoints','duelHonor','strategyStep','strategyAccumulatedPoints'])if(!Number.isSafeInteger(c[key])||c[key]<0)throw Error('Invalid battlefield duel setting: '+key);
  if(c.duelCooldownSeconds<1)throw Error('Invalid battlefield duel cooldown');
  if(!Array.isArray(c.lanes)||c.lanes.length!==3||c.lanes.some((l,i)=>l.id!==i||!l.start||!l.end||[l.start,l.end].some(p=>!Number.isFinite(p.x)||!Number.isFinite(p.y)||p.x<0||p.x>c.arenaWidth||p.y<0||p.y>c.arenaHeight)||distance(l.start,l.end)<c.attackRange*2))throw Error('Invalid battlefield lanes');
  for(const n of [...Object.values(c.points),...c.bossSpawnSeconds,...c.honor.top,c.honor.participation,c.honor.win]) if(!Number.isFinite(n)||n<0) throw Error('Invalid battlefield points/timing');
  for(const n of [...Object.values(c.points),...c.honor.top,c.honor.participation,c.honor.win,c.activityReward])if(!Number.isSafeInteger(n))throw Error('Invalid integer battlefield reward');
  return c;
}
function create(options={}) {
  const cfg=settings(options.config), clock=options.now||(()=>Math.floor(Date.now()/1000));
  let world=copy(options.world||{version:2,sequence:0,players:{},match:null});
  const persist=options.persist||(()=>{}),audit=options.audit||(()=>{});
  const reports=new Map();
  const point=(lane,progress)=>{const l=cfg.lanes[lane];return {x:l.start.x+(l.end.x-l.start.x)*progress,y:l.start.y+(l.end.y-l.start.y)*progress};};
  function project(lane,p){const l=cfg.lanes[lane],dx=l.end.x-l.start.x,dy=l.end.y-l.start.y;return Math.max(0,Math.min(1,((p.x-l.start.x)*dx+(p.y-l.start.y)*dy)/(dx*dx+dy*dy)));}
  const sameLane=(a,b)=>cfg.combatMode!=='formation'||a&&b&&a.lane===b.lane;
  if(world.version!==2) throw Error('Unsupported battlefield state version');
  function log(type,data) {audit({time:clock(),type,...data});}
  function transaction(fn) {
    const prior=world; world=copy(prior);
    try {const result=fn();persist(world);return result;} catch(e) {world=prior;throw e;}
  }
  function event(m,text,detail={}) {
    m.eventSequence=(m.eventSequence||0)+1;
    m.events.push({id:m.eventSequence,time:m.lastTick,text,...detail});m.events=m.events.slice(-15);
    log('event',{match:m.id,text,...detail});
  }
  function objectives(m) {
    if(cfg.combatMode==='formation') {
      m.nodes=[0,1].flatMap(team=>cfg.lanes.map(l=>({id:1+team*3+l.id,...point(l.id,team),lane:l.id,name:l.name,owner:team,spawn:true,capturer:null,progress:0,lockedUntil:0})));
    } else {
    m.nodes=[
      {id:1,name:'Cầu cảng Tây',x:240,y:210,owner:0},
      {id:2,name:'Nhà chính Công',x:240,y:490,owner:0},
      {id:3,name:'Cầu cảng Đông',x:760,y:210,owner:1},
      {id:4,name:'Nhà chính Thủ',x:760,y:490,owner:1},
      {id:5,name:'Kho trung tâm',x:500,y:350,owner:-1}
    ].map(n=>({...n,capturer:null,progress:0,lockedUntil:0}));
    }
    m.npcs=[{id:100001,name:'Lính canh Tây',x:390,y:220},{id:100002,name:'Lính canh Đông',x:610,y:480}]
      .map(n=>({...n,kind:'guard',team:-1,hp:120,maxHp:120,deadUntil:0,nextAttack:0}));
    if(!cfg.guardsEnabled)m.npcs=[];
    m.bossesSpawned=[];
  }
  function resetActor(a,t) {
    if(cfg.combatMode==='formation') {if(!Number.isInteger(a.lane)||a.lane<0||a.lane>2)a.lane=a.id%3;a.laneProgress=a.team===0?(a.id%4)*0.018:1-(a.id%4)*0.018;}
    const home=cfg.combatMode==='formation'?point(a.lane,a.laneProgress):spawn(a.team);
    Object.assign(a,home,{hp:a.maxHp,deadUntil:0,protectedUntil:t+cfg.spawnProtectionSeconds,nextAttack:0,nextSkill:0,goal:null,capturing:null,busyUntil:0,routeRestUntil:0});
  }
  function start(t) {
    world.sequence++;
    const m=world.match={id:world.sequence,phase:'prepare',round:1,lastTick:t,phaseEnd:t+cfg.prepareSeconds,roundStart:0,
      resources:[cfg.initialResources,cfg.initialResources],actors:{},nodes:[],npcs:[],events:[],duels:[],winner:null,reason:'',started:t,combatMode:cfg.combatMode,routeVersion:1};
    objectives(m);event(m,'Đăng ký mở cả ngày • Chuẩn bị hiệp 1');return m;
  }
  function members(m) {return Object.values(m.actors);}
  function ranking(m) {return members(m).filter(a=>a.participated).sort((a,b)=>b.score-a.score || a.deaths-b.deaths || a.joinedAt-b.joinedAt || a.id-b.id);}
  function addScore(m,a,kind) {
    const amount=cfg.points[kind];a.score+=amount;m.resources[a.team]+=amount;
    if(!Number.isSafeInteger(a.score)||!Number.isSafeInteger(m.resources[a.team])) throw Error('Battlefield score overflow');
    a.participated=true;log('score',{match:m.id,actor:a.id,kind,amount,total:a.score,resources:m.resources.slice()});
  }
  function finish(m,winner,reason) {
    if(m.phase==='finished')return;
    m.phase='finished';m.winner=winner;m.reason=reason;m.phaseEnd=m.lastTick;
    const ranks=ranking(m);let king=false;
    for(let i=0;i<ranks.length;i++) {
      const a=ranks[i];
      const week=Math.floor((m.lastTick+420*60+3*86400)/(7*86400));
      if(a.bot){
        if(!world.botCareers)world.botCareers={};
        const career=world.botCareers[a.id]||(world.botCareers[a.id]={id:a.id,name:a.name,server:a.server,bot:true});
        if(career.week!==week){career.week=week;career.weekScore=0;}
        career.weekScore+=a.score;continue;
      }
      const p=world.players[a.key];
      const honor=cfg.honor.participation+(winner===a.team?cfg.honor.win:0)+(cfg.honor.top[i]||0);
      p.honorEarned+=honor;p.activityEarned+=cfg.activityReward;
      if(p.week!==week){p.week=week;p.weekScore=0;}
      p.weekScore+=a.score;
      if(winner===a.team) {p.wins++;p.streak++;} else if(winner!==null) {p.losses++;p.streak=0;}
      a.reward={honor,activity:cfg.activityReward,rank:i+1};
    }
    // The best eligible member of the winning faction, including local AI, holds the title.
    for(const a of ranks) if(a.team===winner && !king) {a.title='Vua Chiến trường';king=true;if(!a.bot)world.players[a.key].title=a.title;}
    event(m,winner===null?'Kết thúc: hòa':('Phe '+(winner===0?'Công':'Thủ')+' chiến thắng'),{reason});
  }
  function join(profile,t) {
    if(profile.level<cfg.minLevel)throw Error('Nhân vật cần đạt cấp '+cfg.minLevel+'.');
    const key=String(profile.key);if(!key||key==='undefined')throw Error('Missing player identity');
    let p=world.players[key];
    if(!p) {const used=Object.values(world.players).map(x=>x.id);p=world.players[key]={id:Math.max(1000,...used)+1,honorEarned:0,activityEarned:0,wins:0,losses:0,streak:0,title:''};}
    p.name=String(profile.name).slice(0,40);p.server=String(profile.server).slice(0,16);
    let m=world.match;if(!m||m.phase==='finished')m=start(t);
    if(cfg.botOnlyOpponents&&members(m).some(a=>!a.bot&&a.key!==key))throw Error('Chiến trường bot chỉ dành cho nhân vật đang chơi.');
    let a=m.actors[p.id];
    if(a) {a.active=true;a.token=crypto.randomUUID();a.lastSeen=t;return a;}
    if(members(m).filter(a=>!a.bot).length>=cfg.maxPlayers-cfg.botCount)throw Error('Chiến trường đã đầy.');
    const power=Math.max(1,Number(profile.power)||1);
    const totals=[0,0],counts=[0,0];for(const actor of members(m).filter(a=>!a.bot)){totals[actor.team]+=actor.power;counts[actor.team]++;}
    const team=counts[0]===counts[1] && totals[0]===totals[1] ? crypto.randomInt(2) : counts[0]===counts[1] ? (totals[0]<=totals[1]?0:1) : (counts[0]<counts[1]?0:1);
    a=m.actors[p.id]={id:p.id,key,name:String(profile.name).slice(0,40),server:String(profile.server).slice(0,16),hero:profile.hero||0,power,
      team,level:profile.level,bot:false,active:true,joinedAt:t,lastSeen:t,score:0,kills:0,deaths:0,captures:0,charges:cfg.itemCharges,
      participated:true,auto:false,token:crypto.randomUUID(),maxHp:1000,attack:90};
    resetActor(a,t);a.protectedUntil=m.phase==='prepare'?m.phaseEnd+cfg.spawnProtectionSeconds:t+cfg.spawnProtectionSeconds;
    if(m.phase==='prepare') {if(cfg.botOnlyOpponents)bots(m,t);rebalance(m,t);}
    event(m,a.name+' đăng ký phe '+(a.team===0?'Công':'Thủ'));return a;
  }
  function rebalance(m,t) {
    // Largest power first; assign to the smaller total with a population constraint.
    const participants=members(m).filter(a=>cfg.botOnlyOpponents||!a.bot).sort((a,b)=>b.power-a.power || a.id-b.id);
    const total=[0,0],count=[0,0],first=participants.length?participants[0].team:0;
    const laneCounts=[[0,0,0],[0,0,0]],lanePower=[[0,0,0],[0,0,0]];
    for(const a of participants) {
      let side=total[0]===total[1]?first:(total[0]<total[1]?0:1);
      if(count[side]>=Math.ceil(participants.length/2))side=1-side;
      a.team=side;total[side]+=a.power;count[side]++;
      a.lane=[0,1,2].sort((x,y)=>laneCounts[side][x]-laneCounts[side][y]||lanePower[side][x]-lanePower[side][y]||x-y)[0];laneCounts[side][a.lane]++;lanePower[side][a.lane]+=a.power;
      resetActor(a,t);a.protectedUntil=m.phaseEnd+cfg.spawnProtectionSeconds;
    }
  }
  function bots(m,t) {
    const humans=members(m).filter(a=>!a.bot),power=humans.reduce((n,a)=>n+a.power,0)/Math.max(1,humans.length);
    const list=options.bots||[];
    for(let i=0;i<cfg.botCount;i++) {
      if(m.actors[i+1])continue;
      const b=list[i]||{},factor=cfg.botOnlyOpponents?Math.max(0.8,Math.min(1.2,Number(b.power)||0.85+(i%7)*0.05)):1;
      const a=m.actors[i+1]={id:i+1,key:'bot:'+i,botId:b.id||i+1,name:b.name||('Hải tặc '+(i+1)),server:'BOT',hero:b.hero||0,level:humans[0]?humans[0].level:cfg.minLevel,power:(power||100)*factor,
        team:i%2,bot:true,active:true,joinedAt:t,score:0,kills:0,deaths:0,captures:0,charges:cfg.itemCharges,
        participated:true,auto:true,maxHp:1000,attack:90,nextThink:0};resetActor(a,t);
    }
  }
  function alive(a,t) {return a && a.active!==false && a.hp>0 && !(a.deadUntil>t);}
  function ready(a,t) {return alive(a,t)&&t>=(a.busyUntil||0)&&t>=(a.nextDuel||0);}
  const mapVisible=(a,t)=>alive(a,t)&&(cfg.combatMode!=='formation'||ready(a,t));
  function duel(m,a,b,t,resolve) {
    if(!sameLane(a,b))throw Error('Chỉ được giao chiến với đối thủ cùng tuyến.');
    if(!ready(a,t)||!ready(b,t)||a.team===b.team||b.kind||distance(a,b)>cfg.attackRange+0.00001||(b.protectedUntil||0)>t||(a.protectedUntil||0)>t)throw Error('Chưa thể tham chiến: mục tiêu ngoài tầm, đang giao chiến hoặc hồi phục.');
    if(!a.bot&&typeof resolve!=='function')throw Error('Battlefield duel requires an authoritative simulator');
    const outcome=resolve?resolve(a,b):options.simulateBots?options.simulateBots(a,b):{won:crypto.randomInt(10000)<Math.round(10000*a.power/(a.power+b.power))};
    if(!outcome||typeof outcome.won!=='boolean')throw Error('Battlefield duel simulation failed');
    const winner=outcome.won?a:b,loser=outcome.won?b:a;
    for(const actor of [a,b]) {actor.goal=null;actor.capturing=null;actor.challengeFrom=0;actor.nextDuel=t+cfg.duelCooldownSeconds;actor.busyUntil=t+cfg.duelDisplaySeconds;actor.participated=true;}
    winner.kills++;winner.streak=(winner.streak||0)+1;loser.streak=0;loser.deaths++;loser.hp=0;loser.deadUntil=t+cfg.respawnSeconds;
    const resource=cfg.resourceTransfer?Math.min(m.resources[loser.team],cfg.points.player):cfg.points.player;
    m.resources[winner.team]+=resource;if(cfg.resourceTransfer)m.resources[loser.team]-=resource;
    winner.score+=cfg.duelAccumulatedPoints*cfg.accumulationDivisor;
    if(!winner.bot)world.players[winner.key].honorEarned+=cfg.duelHonor;
    const record={id:(m.duelSequence||0)+1,time:t,lane:a.lane,attacker:a.id,defender:b.id,winner:winner.id,attackerName:a.name,defenderName:b.name,resource,score:cfg.duelAccumulatedPoints};
    m.duelSequence=record.id;if(!m.duels)m.duels=[];m.duels.push(record);m.duels=m.duels.slice(-20);
    if(outcome.report){reports.set(m.id+':'+record.id,outcome.report);while(reports.size>20)reports.delete(reports.keys().next().value);}
    event(m,winner.name+' đánh bại '+loser.name,{duel:record.id,attacker:a.id,target:b.id,winner:winner.id});
    log('duel',{match:m.id,...record,resources:m.resources.slice()});
    if(m.resources[loser.team]===0)finish(m,winner.team,'resources');
    return outcome.report||null;
  }
  function useItem(m,a,t) {
    if(a.charges<1 || t<(a.nextItem||0))throw Error('Hết vật phẩm hoặc đang hồi phục.');
    a.charges--;a.nextItem=t+30;
    if(cfg.combatMode==='formation') {
      a.strategyAtk=(a.strategyAtk||0)+cfg.strategyStep;a.strategyDef=(a.strategyDef||0)+cfg.strategyStep;
      a.score+=cfg.strategyAccumulatedPoints*cfg.accumulationDivisor;event(m,a.name+' dùng chiến lược');
    } else {a.hp=Math.min(a.maxHp,a.hp+250);addScore(m,a,'item');event(m,a.name+' dùng cờ tiếp viện');}
  }
  function hit(m,a,b,t,skill=false) {
    if(!alive(b,t)||a.team===b.team || distance(a,b)>cfg.attackRange || (b.protectedUntil||0)>t)throw Error('Mục tiêu ngoài tầm, cùng phe hoặc đang được bảo vệ.');
    if(t<a.nextAttack || (skill&&t<a.nextSkill))throw Error('Kỹ năng đang hồi phục.');
    a.nextAttack=t+cfg.attackCooldown;if(skill)a.nextSkill=t+cfg.skillCooldown;
    a.goal=null;a.capturing=null;a.participated=true;
    // Power disparity is bounded to avoid one-hit farming. Persistent stats establish matchmaking strength.
    const ratio=b.power?Math.max(0.65,Math.min(1.5,Math.sqrt(a.power/b.power))):1;
    const damage=Math.round(a.attack*ratio*(skill?1.8:1));b.hp=Math.max(0,b.hp-damage);
    event(m,a.name+' đánh '+b.name,{attacker:a.id,target:b.id,damage,skill});
    if(b.hp===0) {
      const kind=b.kind||'player';addScore(m,a,kind);a.kills++;
      if(kind==='player'){b.deaths++;b.goal=null;b.capturing=null;b.deadUntil=t+cfg.respawnSeconds;}
      else b.deadUntil=kind==='boss'?Number.MAX_SAFE_INTEGER:t+cfg.guardRespawnSeconds;
      event(m,a.name+' hạ '+b.name,{killer:a.id,victim:b.id,kind});
    }
  }
  function command(key,input,t,resolve) {
    const m=world.match,p=world.players[String(key)],a=m&&p&&m.actors[p.id];
    if(!a||!a.active||!input.token||input.token!==a.token)throw Error('Phiên chiến trường hết hạn.');
    if(!Number.isInteger(input.sequence)||input.sequence!==(a.sequence||0)+1)throw Error('Lệnh bị lặp hoặc sai thứ tự.');
    if(input.action==='leave'){a.active=false;a.goal=null;a.capturing=null;}
    else if(input.action==='auto'){a.auto=!!input.enabled;}
    else {
      if(m.phase!=='combat'||!alive(a,t))throw Error('Đang chuẩn bị, nghỉ giữa hiệp hoặc chờ hồi sinh.');
      if(input.action==='move') {
        if(cfg.combatMode==='formation'&&!ready(a,t))throw Error('Đang hồi phục, chờ lượt chạy tiếp theo.');
        const {x,y}=input;if(!Number.isFinite(x)||!Number.isFinite(y)||x<0||y<0||x>cfg.arenaWidth||y>cfg.arenaHeight)throw Error('Vị trí di chuyển không hợp lệ.');
        // This is a destination, never an instantaneous client position.
        if(cfg.combatMode==='formation') {
          // Lanes can only be selected at a faction's own departure point.
          const lane=cfg.lanes.slice().sort((l,r)=>distance(point(l.id,project(l.id,{x,y})),{x,y})-distance(point(r.id,project(r.id,{x,y})),{x,y}))[0].id;
          if(lane!==a.lane){
            if(distance(a,point(a.lane,a.team))>cfg.attackRange||distance({x,y},point(lane,a.team))>cfg.attackRange)throw Error('Chọn tuyến tại căn cứ xuất phát; không thể đổi tuyến giữa đường.');
            a.lane=lane;a.laneProgress=a.team;Object.assign(a,point(lane,a.team));a.challengeFrom=0;
            log('lane-select',{match:m.id,actor:a.id,lane});
          }
          a.goal=point(a.lane,project(a.lane,{x,y}));
        }else a.goal={x,y};
        a.manualMove=true;a.capturing=null;a.participated=true;
      } else if(input.action==='attack'||input.action==='skill') {
        const b=m.actors[input.target]||m.npcs.find(n=>n.id===input.target);
        if(cfg.combatMode==='formation'){const report=duel(m,a,b,t,resolve);a.sequence=input.sequence;a.token=crypto.randomUUID();a.lastSeen=t;return {actor:a,report};}
        hit(m,a,b,t,input.action==='skill');
      } else if(input.action==='capture') {
        if(!cfg.captureEnabled)throw Error('Vòng căn cứ dùng để xuất phát và hồi sinh.');
        const n=m.nodes.find(n=>n.id===input.target);
        if(!n||n.owner===a.team||distance(a,n)>cfg.captureRadius||n.lockedUntil>t)throw Error('Không thể chiếm cứ điểm này.');
        a.goal=null;a.capturing=n.id;a.captureStarted=t;a.participated=true;
      } else if(input.action==='item') {
        useItem(m,a,t);
      } else throw Error('Lệnh chiến trường không hợp lệ.');
    }
    a.sequence=input.sequence;a.token=crypto.randomUUID();a.lastSeen=t;return a;
  }
  function move(a,m,t) {
    if(!a.goal)return;const d=distance(a,a.goal),step=Math.min(cfg.moveSpeed,d);
    if(cfg.combatMode==='formation') {
      const length=distance(cfg.lanes[a.lane].start,cfg.lanes[a.lane].end),from=project(a.lane,a),to=project(a.lane,a.goal),sign=Math.sign(to-from);
      let next=from+sign*Math.min(step/length,Math.abs(to-from));
      for(const b of members(m))if(b.team!==a.team&&sameLane(a,b)&&mapVisible(b,t)){
        const enemy=project(a.lane,b);if((enemy-from)*sign>=0){const limit=enemy-sign*(cfg.attackRange-1)/length;if(sign>0)next=Math.max(from,Math.min(next,limit));else if(sign<0)next=Math.min(from,Math.max(next,limit));}
      }
      a.laneProgress=next;Object.assign(a,point(a.lane,next));
      if(Math.abs(next-to)<0.00001){a.goal=null;a.manualMove=false;
        if(Math.abs(next-(1-a.team))<0.00001){a.routeRestUntil=t+cfg.duelCooldownSeconds;a.nextDuel=a.routeRestUntil;a.challengeFrom=0;log('route-finish',{match:m.id,actor:a.id,lane:a.lane,resumeAt:a.routeRestUntil});}
      }return;
    }
    if(d){a.x+=(a.goal.x-a.x)*step/d;a.y+=(a.goal.y-a.y)*step/d;}
    if(d<=cfg.moveSpeed){a.goal=null;a.manualMove=false;}
  }
  function think(m,a,t) {
    if(!a.auto)return;
    if(cfg.combatMode==='formation') {
      if(!a.bot&&a.manualMove&&a.goal)return;
      if(!ready(a,t))return;
      if((a.protectedUntil||0)>t)return;
      if(a.bot&&a.charges>0&&t>=(a.nextItem||0)&&t-m.roundStart>=(a.id%3+1)*60)useItem(m,a,t);
      const candidates=members(m).filter(b=>b.id!==a.id&&b.team!==a.team&&sameLane(a,b)&&ready(b,t)&&(b.protectedUntil||0)<=t);
      candidates.sort((b,c)=>distance(a,b)-distance(a,c)||b.id-c.id);
      const b=candidates[0];
      if(!b){a.goal=point(a.lane,1-a.team);return;}
      if(distance(a,b)<=cfg.attackRange+0.00001){
        a.goal=null;
        if(a.bot&&b.bot)duel(m,a,b,t);
        else if(!a.bot&&b.bot&&typeof options.simulatePlayer==='function')duel(m,a,b,t,options.simulatePlayer);
        else if(a.bot&&!b.bot&&!b.challengeFrom)b.challengeFrom=a.id;
        return;
      }
      a.goal=point(a.lane,1-a.team);return;
    }
    if(a.bot&&a.hp<450&&a.charges>0&&t>=(a.nextItem||0))useItem(m,a,t);
    const enemies=members(m).filter(b=>b.team!==a.team&&alive(b,t)&&b.protectedUntil<=t).concat(m.npcs.filter(b=>b.hp>0));
    const b=enemies.sort((x,y)=>distance(a,x)-distance(a,y))[0];
    if(b&&distance(a,b)<=cfg.attackRange){a.goal=null;if(t>=a.nextAttack)hit(m,a,b,t,t>=a.nextSkill);return;}
    const n=m.nodes.filter(n=>n.owner!==a.team&&n.lockedUntil<=t).sort((x,y)=>distance(a,x)-distance(a,y))[0];
    if(n){if(distance(a,n)<=cfg.captureRadius){a.goal=null;if(a.capturing!==n.id)a.captureStarted=t;a.capturing=n.id;}else {
      const angle=((a.id*137+n.id*47)%360)*Math.PI/180;
      a.goal={x:n.x+Math.cos(angle)*45,y:n.y+Math.sin(angle)*45};a.capturing=null;
    }}
    else if(b)a.goal={x:b.x,y:b.y};
  }
  function step(m,t) {
    m.lastTick=t;
    if(m.phase==='finished')return;
    if((m.phase==='prepare'||m.phase==='intermission')&&t>=m.phaseEnd) {
      if(m.phase==='prepare'){bots(m,t);rebalance(m,t);}
      const duration=Math.floor(cfg.matchSeconds/cfg.rounds)+(m.round<=cfg.matchSeconds%cfg.rounds?1:0);
      m.phase='combat';m.roundStart=t;m.phaseEnd=t+duration;
      for(const a of members(m)){resetActor(a,t);a.charges=cfg.itemCharges;a.strategyAtk=0;a.strategyDef=0;}
      event(m,'Bắt đầu hiệp '+m.round);
    }
    if(m.phase!=='combat')return;
    if(t>=m.phaseEnd) {
      if(m.round<cfg.rounds) {
        m.round++;m.phase='intermission';m.phaseEnd=t+cfg.intermissionSeconds;objectives(m);
        for(const a of members(m)){a.team=1-a.team;resetActor(a,t);}m.resources.reverse();
        event(m,'Đổi phe • Chuẩn bị hiệp '+m.round+' • Giữ điểm của đội');
      } else finish(m,m.resources[0]===m.resources[1]?null:(m.resources[0]>m.resources[1]?0:1),'time');
      return;
    }
    for(const at of cfg.bossSpawnSeconds) if(t-m.roundStart>=at&&!m.bossesSpawned.includes(at)) {
      m.bossesSpawned.push(at);m.npcs.push({id:200000+m.bossesSpawned.length,name:'Hải Vương '+m.bossesSpawned.length,kind:'boss',team:-1,x:500,y:m.bossesSpawned.length%2?170:530,hp:2200,maxHp:2200,deadUntil:0,nextAttack:0});event(m,'Hải Vương xuất hiện!');
    }
    for(const a of members(m).sort((a,b)=>t%2?b.id-a.id:a.id-b.id)) {
      if(a.challengeFrom){const challenger=m.actors[a.challengeFrom];if(!ready(challenger,t)||!sameLane(a,challenger)||challenger.team===a.team||distance(a,challenger)>cfg.attackRange+0.00001)a.challengeFrom=0;}
      if(!a.bot&&t-(a.lastSeen||a.joinedAt)>30){a.active=false;a.goal=null;a.capturing=null;}
      if(!a.active)continue;
      if(a.hp===0&&t>=a.deadUntil)resetActor(a,t);
      if(!alive(a,t))continue;
      if(cfg.combatMode==='formation'){
        if(a.routeRestUntil){if(t<a.routeRestUntil)continue;resetActor(a,t);log('route-resume',{match:m.id,actor:a.id,lane:a.lane});}
        if(!ready(a,t))continue;
      }
      if(t>=(a.busyUntil||0)){think(m,a,t);if(m.phase==='finished')return;move(a,m,t);}
    }
    for(const npc of m.npcs) {
      if(npc.hp===0&&t>=npc.deadUntil)npc.hp=npc.maxHp;
      if(npc.hp===0||t<npc.nextAttack)continue;
      const a=members(m).filter(a=>alive(a,t)&&a.protectedUntil<=t&&distance(a,npc)<cfg.attackRange).sort((a,b)=>distance(a,npc)-distance(b,npc))[0];
      if(a){npc.nextAttack=t+cfg.attackCooldown;a.hp=Math.max(0,a.hp-(npc.kind==='boss'?110:45));if(!a.hp){a.deaths++;a.goal=null;a.capturing=null;a.deadUntil=t+cfg.respawnSeconds;event(m,npc.name+' hạ '+a.name,{victim:a.id});}}
    }
    if(cfg.captureEnabled)for(const n of m.nodes) {
      const near=members(m).filter(a=>alive(a,t)&&distance(a,n)<=cfg.captureRadius),sides=new Set(near.map(a=>a.team));
      const claimants=near.filter(a=>a.capturing===n.id&&a.team!==n.owner);
      const a=claimants.sort((a,b)=>(a.captureStarted||t)-(b.captureStarted||t)||a.id-b.id)[0];
      if(!a||sides.size!==1||n.lockedUntil>t){n.progress=0;n.capturer=null;continue;}
      if(n.capturer!==a.team){n.capturer=a.team;n.progress=0;}n.progress++;
      if(n.progress>=cfg.captureSeconds){n.owner=a.team;n.progress=0;n.capturer=null;n.lockedUntil=t+cfg.captureCooldown;a.captures++;addScore(m,a,'capture');for(const b of claimants)b.capturing=null;event(m,a.name+' chiếm '+n.name,{node:n.id,owner:a.team});}
    }
    if(cfg.captureEnabled)for(let side=0;side<2;side++)if(!m.nodes.some(n=>(n.spawn||n.id<=4)&&n.owner===side)){finish(m,1-side,'bases');break;}
  }
  function tick(t=clock()) {
    const m=world.match;if(!m||m.phase==='finished'||t<=m.lastTick)return;
    transaction(()=>{const active=world.match;while(active.lastTick<t&&active.phase!=='finished')step(active,active.lastTick+1);});
  }
  function view(key,t=clock()) {
    const m=world.match,p=world.players[String(key)],a=m&&p&&m.actors[p.id];
    const week=Math.floor((t+420*60+3*86400)/(7*86400));
    return {version:2,serverTime:t,config:cfg,phase:m?m.phase:'registration',round:m?m.round:0,matchId:m?m.id:0,
      remaining:m?Math.max(0,m.phaseEnd-t):0,resources:m?m.resources:[cfg.initialResources,cfg.initialResources],
      joined:!!(a&&a.active&&m.phase!=='finished'),me:a?{...a,key:undefined}:null,
      actors:m?members(m).map(b=>({id:b.id,name:b.name,server:b.server,hero:b.hero,team:b.team,lane:b.lane,bot:b.bot,active:b.active,mapVisible:mapVisible(b,t),x:b.x,y:b.y,hp:b.hp,maxHp:b.maxHp,deadUntil:b.deadUntil,busyUntil:b.busyUntil||0,nextDuel:b.nextDuel||0,routeRestUntil:b.routeRestUntil||0,protectedUntil:b.protectedUntil||0,score:b.score,title:b.title||''})):[],
      duels:m?(m.duels||[]).slice(-8).map(d=>({...d,available:reports.has(m.id+':'+d.id)})):[],
      nodes:m?m.nodes:[],npcs:m?m.npcs:[],events:m?m.events.slice(-8):[],
      ranking:m?ranking(m).slice(0,10).map((b,i)=>({rank:i+1,id:b.id,name:b.name,server:b.server,team:b.team,score:b.score,accumulated:Math.floor(b.score/cfg.accumulationDivisor),bot:b.bot})):[],
      weeklyRanking:Object.values(world.players).concat(Object.values(world.botCareers||{})).filter(p=>p.week===week).sort((a,b)=>(b.weekScore||0)-(a.weekScore||0)||a.id-b.id).slice(0,10).map((p,i)=>({rank:i+1,id:p.id,name:p.name,server:p.server,bot:!!p.bot,score:p.weekScore||0,accumulated:Math.floor((p.weekScore||0)/cfg.accumulationDivisor)})),
      winner:m?m.winner:null,reason:m?m.reason:'',reward:a?a.reward:null,career:p?{...p,weeklyAccumulated:p.week===week?Math.floor((p.weekScore||0)/cfg.accumulationDivisor):0}:null};
  }
  function heartbeat(key) {
    const m=world.match,p=world.players[String(key)],a=m&&p&&m.actors[p.id];
    if(a&&a.active&&m.phase!=='finished')a.lastSeen=clock();
  }
  // Settle an old realtime match once before using the video rules. Keep the reward
  // ledger and wallet watermarks, rather than deleting or reinterpreting old scores.
  if(options.world&&cfg.combatMode==='formation'&&world.match&&world.match.phase!=='finished'&&world.match.combatMode!=='formation')transaction(()=>{
    const m=world.match;m.lastTick=clock();finish(m,m.resources[0]===m.resources[1]?null:m.resources[0]>m.resources[1]?0:1,'rules-update');
  });
  if(cfg.combatMode==='formation'&&world.match&&world.match.phase!=='finished'&&!world.match.routeVersion)transaction(()=>{
    const m=world.match;m.routeVersion=1;objectives(m);
    for(const a of members(m)){a.lane=a.id%3;a.laneProgress=project(a.lane,a);Object.assign(a,point(a.lane,a.laneProgress));a.goal=null;a.manualMove=false;a.challengeFrom=0;}
    event(m,'Áp dụng ba tuyến thẳng • Chỉ giao chiến cùng tuyến');
  });
  return {cfg,tick,view,heartbeat,join(profile){tick();return transaction(()=>join(profile,clock()));},
    command(key,input,resolve){tick();try{return transaction(()=>command(key,input,clock(),resolve));}catch(e){log('rejected',{key:String(key),action:input.action,reason:e.message});throw e;}},
    replay(key,id,token){const m=world.match,p=world.players[String(key)],a=m&&p&&m.actors[p.id];if(!a||token!==a.token)throw Error('Phiên chiến trường hết hạn.');const report=m.duels&&m.duels.some(d=>d.id===id)&&reports.get(m.id+':'+id);if(!report)throw Error('Chiến báo này đã hết hạn; chọn trận mới hơn.');return report;},
    exportWorld:()=>copy(world)};
}
module.exports={create,settings,distance};
