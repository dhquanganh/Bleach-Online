'use strict';
const assert=require('assert/strict'),engine=require('../battlefield-engine'),field=require('../battlefield'),{Y}=require('../paket');
let time=50000;
const config={combatMode:'formation',botOnlyOpponents:false,botCount:0,prepareSeconds:1,spawnProtectionSeconds:1,matchSeconds:100,intermissionSeconds:1};
const options={config,now:()=>time};let arena=engine.create(options);
const player=key=>({key,name:key,server:'Test',level:40,power:50000});
arena.join(player('a'));arena.join(player('b'));time+=2;arena.tick();
const fixture=fn=>{const world=arena.exportWorld();fn(world.match);arena=engine.create({...options,world});};
fixture(m=>Object.values(m.actors).forEach(a=>Object.assign(a,{x:500,y:300,protectedUntil:0})));
const view=key=>arena.view(key,time);
const input=(key,action,target)=>({action,target,token:view(key).me.token,sequence:(view(key).me.sequence||0)+1});
assert.equal(view('a').npcs.length,0);assert.equal(view('a').nodes.length,6);
assert.equal(view('a').nodes.filter(n=>n.owner===view('a').me.team).length,3);
assert.deepEqual(view('a').resources,[500,500]);
assert.throws(()=>arena.command('a',input('a','capture',1)),/xuất phát/);
const request=input('a','attack',view('b').me.id),report={won:true,payload:Buffer.from([1])};
assert.throws(()=>arena.command('a',request),/authoritative simulator/);
const before=arena.exportWorld();assert.throws(()=>arena.command('a',request,()=>{throw Error('simulation failure');}));assert.deepEqual(arena.exportWorld(),before);
const resolved=arena.command('a',{...request,won:false,damage:99999,score:99999},()=>({won:true,report}));
assert(Buffer.isBuffer(resolved.report.payload));assert.equal(view('a').me.score,50);assert.equal(view('b').me.hp,0);
assert.equal(view('a').resources[view('a').me.team],501);assert.equal(view('a').resources[view('b').me.team],499);
assert.equal(view('a').resources.reduce((a,b)=>a+b),1000);
assert.equal(view('a').career.honorEarned,1);assert.equal(view('a').me.streak,1);
assert.equal(view('a').ranking.find(a=>a.id===view('a').me.id).accumulated,5);
assert.throws(()=>arena.command('a',request,()=>({won:true,report})),/hết hạn/);
assert.throws(()=>arena.command('a',input('a','attack',view('b').me.id),()=>({won:true,report})),/hồi phục/);
assert.deepEqual(arena.replay('a',1,view('a').me.token),report);assert.deepEqual(arena.exportWorld(),arena.exportWorld());
const ledger=arena.exportWorld();arena.replay('a',1,view('a').me.token);assert.deepEqual(arena.exportWorld(),ledger,'Viewing reports cannot grant points or honor');
const oldResources=view('a').resources.slice();time+=4;arena.tick();arena.command('a',input('a','item'));
assert.deepEqual(view('a').resources,oldResources,'Strategy must preserve the 1000-resource total');
assert.equal(view('a').me.strategyAtk,2);assert.equal(view('a').me.strategyDef,2);assert.equal(view('a').me.score,150);
time+=11;arena.tick();assert.equal(view('b').me.hp,1000);assert(time<view('b').me.nextDuel,'Respawn does not bypass the participation freeze');
time+=10;arena.tick();
fixture(m=>Object.values(m.actors).forEach(a=>Object.assign(a,{x:500,y:300,protectedUntil:0})));
arena.command('a',input('a','attack',view('b').me.id),()=>({won:false,report:{won:false,payload:Buffer.from([2])}}));
assert.equal(view('a').me.streak,0);assert.equal(view('b').me.streak,1);assert.deepEqual(view('a').resources,[500,500]);
assert.equal(view('a').career.honorEarned,1);assert.equal(view('b').career.honorEarned,1);
const d={agentUserId:'a'},adapter=field.create({arena,now:()=>time});
const ctx=payload=>({durum:d,payload:payload||Buffer.alloc(0),kaydet:()=>{}});
assert.equal(adapter.handle(field.OP.INFO,ctx()).data.points,1);assert.equal(adapter.handle(field.OP.INFO,ctx()).data.points,1);
const replay=adapter.handle(field.OP.FIGHT,ctx(new Y().u32(0x80000000+2).utf(view('a').me.token).done()));
assert(replay.data.hasReport);assert.equal(replay.report.won,false);assert.equal(d.battlefield.points,1);
// Real native reports for bot duels must be complete v4 packets, not fabricated outcomes.
const actual=field.simulateBotDuel({id:1,botId:1,name:'Bot 1',team:0,level:40,power:50000},{id:2,botId:2,name:'Bot 2',team:1,level:40,power:50000},{nick:'Test',kadro:{}});
const decoded=require('../kodek').decodeBattleReport(actual.report.payload);
assert.equal(decoded.version,4);assert.equal(decoded._consumed,decoded._total);assert.equal(typeof actual.won,'boolean');
// The native block animation always receives two actor references. Even a pure
// block needs two result slots; the padding slot must not apply damage twice.
const battle=require('../savas');
const fighter=(camp,pos)=>({id:11110001,camp,pos,level:40,hp:1000,maxHp:1000,atk:100,def:0,anger:0,normal:13100113,skill:0,hitRate:1,dodgeRate:0,critRate:0,blockRate:0,antiknockRate:0,damageBonus:0,damageReduction:0,recoverRate:0});
for(const counter of [0,1]){
  const attacker=fighter(0,6),defender={...fighter(1,6),blockRate:1,antiknockRate:counter};
  const attack=battle.vurus(attacker,defender,false,[defender],()=>0,false,[attacker]);
  const reaction=attack.reactions.find(a=>a.activeType===3);assert(reaction);
  assert.equal(reaction.targets.length,2,'Block result vector must match native two-slot playback');
  assert(reaction.targets.every(t=>t.targetCamp===attacker.camp&&t.targetPos===attacker.pos));
  assert.equal(reaction.targets.reduce((n,t)=>n+(t.result.hurtHp||0),0),1000-attacker.hp,'Counter padding cannot create extra damage');
}
let clock=70000;const ai=engine.create({now:()=>clock,config:{prepareSeconds:1,spawnProtectionSeconds:1,matchSeconds:100},simulateBots:(a,b)=>({won:a.power>=b.power,report:{won:a.power>=b.power,payload:Buffer.from([3])}})});
ai.join(player('local'));for(let i=0;i<40;i++){clock++;ai.heartbeat('local');ai.tick();}
assert.equal(ai.view('local').actors.length,20);assert.equal(ai.view('local').resources.reduce((a,b)=>a+b),1000);assert(ai.view('local').duels.length>0);
assert(ai.view('local').duels.some(d=>d.available));
assert(!ai.view('local').events.some(e=>'damage' in e),'Formation mode never performs realtime HP hits on the map');
let autoTime=90000;let playerCalls=0;
const autoOptions={now:()=>autoTime,config:{prepareSeconds:1,spawnProtectionSeconds:0,matchSeconds:100},simulateBots:()=>({won:true,report:{won:true,payload:Buffer.from([4])}}),simulatePlayer:()=>{playerCalls++;return {won:true,report:{won:true,payload:Buffer.from([5])}};}};
let automatic=engine.create(autoOptions);automatic.join(player('auto'));autoTime+=2;automatic.tick();
const autoWorld=automatic.exportWorld(),human=autoWorld.match.actors[automatic.view('auto').me.id];
human.auto=true;human.x=500;human.y=300;human.protectedUntil=0;
for(const a of Object.values(autoWorld.match.actors))if(a.bot)Object.assign(a,{x:a.team===human.team?50:500,y:a.team===human.team?50:300,hp:1000,deadUntil:0,nextDuel:0,busyUntil:0,protectedUntil:0});
automatic=engine.create({...autoOptions,world:autoWorld});autoTime++;automatic.heartbeat('auto');automatic.tick();
assert.equal(playerCalls,1,'Auto participation runs the actual human simulator on the server without client fight requests');
assert.equal(automatic.view('auto').career.honorEarned,1);assert.equal(automatic.view('auto').me.score,50);
assert(automatic.view('auto').duels.some(d=>d.attacker===human.id&&d.available));
// Old active rounds settle once before the rules change, preserving reward watermarks.
const old=engine.create({now:()=>clock,config:{combatMode:'realtime',prepareSeconds:90}});old.join(player('migrate'));
const migrated=engine.create({now:()=>clock,world:old.exportWorld()});assert.equal(migrated.view('migrate').reason,'rules-update');
const earned=migrated.view('migrate').career.honorEarned;
const again=engine.create({now:()=>clock,world:migrated.exportWorld()});assert.equal(again.view('migrate').career.honorEarned,earned);
console.log('Video formation battlefield: native reports, bot duels, 1000-resource conservation, freeze/respawn, strategy, honor reconciliation, replay and rules migration passed');
