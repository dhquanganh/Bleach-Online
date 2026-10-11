'use strict';
const assert=require('assert/strict'),engine=require('../battlefield-engine');
let time=1000;
const options={now:()=>time,config:{prepareSeconds:1,spawnProtectionSeconds:0,matchSeconds:300},simulateBots:()=>({won:true}),simulatePlayer:()=>({won:true})};
let arena=engine.create(options);
arena.join({key:'local',name:'Local',server:'Test',level:40,power:50000});
const view=()=>arena.view('local',time);
const command=(action,extra={})=>arena.command('local',{action,...extra,token:view().me.token,sequence:(view().me.sequence||0)+1},()=>({won:true}));
const onLane=(a)=>{const l=arena.cfg.lanes[a.lane],dx=l.end.x-l.start.x,dy=l.end.y-l.start.y;assert(Math.abs((a.x-l.start.x)*dy-(a.y-l.start.y)*dx)<0.0001,'Actor drifted off its straight route');};
time++;arena.tick();
for(const team of [0,1]) {const counts=[0,0,0];for(const a of view().actors.filter(a=>a.team===team))counts[a.lane]++;assert(Math.max(...counts)-Math.min(...counts)<=1,'Unbalanced lane population');}
command('auto',{enabled:true});
for(let i=0;i<70;i++){time++;arena.heartbeat('local');arena.tick();for(const a of view().actors)onLane(a);}
assert(view().duels.length>0,'Straight routes never encounter each other');
for(const d of view().duels){const a=view().actors.find(a=>a.id===d.attacker),b=view().actors.find(a=>a.id===d.defender);assert.equal(a.lane,b.lane);assert.equal(d.lane,a.lane);}
assert.equal(view().resources.reduce((a,b)=>a+b),1000);
// Even overlapping screen/world positions cannot bypass the same-lane rule.
const world=arena.exportWorld(),a=world.match.actors[view().me.id],b=Object.values(world.match.actors).find(b=>b.team!==a.team);
Object.assign(a,{lane:0,x:500,y:300,hp:1000,deadUntil:0,nextDuel:0,busyUntil:0,protectedUntil:0,auto:false,goal:null});
Object.assign(b,{lane:1,x:500,y:300,hp:1000,deadUntil:0,nextDuel:0,busyUntil:0,protectedUntil:0});
arena=engine.create({...options,world});
assert.throws(()=>command('attack',{target:b.id}),/cùng tuyến/);
// Mid-route clicks cannot cause a diagonal lane change.
assert.throws(()=>command('move',{x:510,y:300}),/đổi tuyến giữa đường/);
// A destination on the current route moves only along that line.
const lane=arena.cfg.lanes[0];command('move',{x:lane.end.x,y:lane.end.y});
time++;arena.heartbeat('local');arena.tick();onLane(view().me);
// Selecting a lane at the own base is allowed; spawn/death keep that lane.
const w=arena.exportWorld(),me=w.match.actors[view().me.id];Object.assign(me,{x:lane.start.x,y:lane.start.y,team:0,hp:1000,goal:null,auto:false});
arena=engine.create({...options,world:w});const next=arena.cfg.lanes[2];command('move',{x:next.start.x,y:next.start.y});assert.equal(view().me.lane,2);onLane(view().me);
// Upgrade an active free-roaming match without losing scores or wallet ledgers.
const old=arena.exportWorld();delete old.match.routeVersion;const score=old.match.actors[view().me.id].score;
arena=engine.create({...options,world:old});assert.equal(view().me.score,score);for(const actor of view().actors)onLane(actor);
// A hidden recovering opponent no longer blocks visible runners.
const blocked=arena.exportWorld(),local=blocked.match.actors[view().me.id];
for(const actor of Object.values(blocked.match.actors))actor.active=false;
const opponent=Object.values(blocked.match.actors).find(actor=>actor.bot);
const position=(p)=>({x:lane.start.x+(lane.end.x-lane.start.x)*p,y:lane.start.y+(lane.end.y-lane.start.y)*p});
Object.assign(local,{...position(0.4),active:true,lane:0,team:0,hp:1000,deadUntil:0,busyUntil:0,nextDuel:0,auto:false,goal:null});
Object.assign(opponent,{...position(0.6),active:true,lane:0,team:1,hp:1000,deadUntil:0,busyUntil:0,nextDuel:time+60,auto:false,goal:null});
arena=engine.create({...options,world:blocked});command('move',{x:lane.end.x,y:lane.end.y});
for(let i=0;i<5;i++){time++;arena.heartbeat('local');arena.tick();onLane(view().me);}
assert(view().me.x>view().actors.find(actor=>actor.id===opponent.id).x,'Hidden cooldown actor blocked the lane');
assert.equal(view().actors.find(actor=>actor.id===opponent.id).mapVisible,false);
// Reaching the endpoint starts an invisible cooldown, then a new run from base.
for(let i=0;i<10&&!view().me.routeRestUntil;i++){time++;arena.heartbeat('local');arena.tick();}
assert(view().me.routeRestUntil>time);assert.equal(view().actors.find(actor=>actor.id===local.id).mapVisible,false);
assert.throws(()=>command('move',{x:lane.start.x,y:lane.start.y}),/hồi phục/);
const resume=view().me.routeRestUntil;
while(time<resume){time++;arena.heartbeat('local');arena.tick();}
assert.equal(view().me.routeRestUntil,0);assert.equal(view().actors.find(actor=>actor.id===local.id).mapVisible,true);
assert(engine.distance(view().me,lane.start)<arena.cfg.attackRange);onLane(view().me);
// Repeated spawn/protection/cooldown cycles must not stall the arena scheduler.
let cycleTime=9000;const cycle=engine.create({now:()=>cycleTime,config:{prepareSeconds:1,matchSeconds:600,duelCooldownSeconds:12,respawnSeconds:5},simulateBots:()=>({won:true}),simulatePlayer:()=>({won:true})});
cycle.join({key:'cycle',name:'Cycle',server:'Test',level:40,power:50000});
for(let i=0;i<220;i++){cycleTime++;cycle.heartbeat('cycle');cycle.tick();}
assert.equal(cycle.exportWorld().match.lastTick,cycleTime);assert(cycle.view('cycle').duels.length>0);
console.log('Battlefield lanes: straight paths, balanced assignment, same-lane encounters, cross-lane rejection, base-only selection and migration passed');
