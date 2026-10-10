'use strict';
const assert=require('assert');
const {tablo,satir}=require('../paket');
const battle=require('../savas'),engine=require('../hero-skills'),partner=require('../partner-skills'),codec=require('../kodek');
const unit=(id,camp,pos=1)=>({id,camp,pos,hp:1000,maxHp:10000,atk:100,def:0,anger:100,normal:13100113,skill:13100059,skillId:13100059,level:100,speed:100,
  hitRate:1,dodgeRate:0,critRate:0,blockRate:0,damageBonus:0,damageReduction:0,recoverRate:0});
const caster=(id,camp=0)=>{
  const u=battle.heroBirim(id,11,100,null,{hp:10000,atk:100,def:0,anger:100,speed:100,hitRate:1,critRate:0,damageBonus:0,damageReduction:0,recoverRate:0},1);
  assert(u);u.camp=camp;return u;
};
const records=act=>[act,...act.reactions].flatMap(a=>a.targets);
const rows=[1,2,3,6,7,8,11,12,13];
const healerCases=[
 [11110003,[1,2,3],100], [11110006,[1,2,3],120], [11110025,[1,2,3,6,7,8],110],
 [11150003,rows,80], [11150019,rows,20],
];
for(const camp of [0,1])for(const [id,positions,amount]of healerCases){
  const u=caster(id,camp),allies=rows.filter(pos=>pos!==11).map(pos=>unit(11110001+pos,camp,pos));allies.push(u);u.hp=1000;
  const enemy=unit(12101003,1-camp),dead=unit(11110004,camp,4);dead.hp=0;allies.push(dead);
  const before=new Map(allies.map(x=>[x.pos,x.hp]));
  const act=battle.vurus(u,enemy,false,[enemy],()=>.5,false,allies);
  for(const ally of allies)assert.equal(ally.hp,before.get(ally.pos)+(positions.includes(ally.pos)?amount:0),`${id} heal slot ${ally.pos}`);
  if(id!==11150019)assert.equal(enemy.hp,1000,'pure healing must not damage enemy');
  assert.equal(dead.hp,0,'healing must not resurrect');
  assert(records(act).filter(r=>r.result.hurtHp<0).every(r=>r.targetCamp===camp));
}
let u=caster(11110006),front=unit(11110001,0),enemy=unit(12101003,1);
front.hp=9995;let act=battle.vurus(u,enemy,false,[enemy],()=>.5,false,[u,front]);
assert.equal(front.hp,10000);assert.equal(records(act).find(r=>r.targetPos===1&&r.targetCamp===0&&r.result.hurtHp<0).result.hurtHp,-5);
front.hp=1000;front.recoverRate=-.75;u.anger=100;act=battle.vurus(u,enemy,false,[enemy],()=>.5,false,[u,front]);assert.equal(front.hp,1030);
front.skillBuffs=[{field:'noHeal',remaining:2,value:1}];u.anger=100;act=battle.vurus(u,enemy,false,[enemy],()=>.5,false,[u,front]);assert.equal(front.hp,1030);
// No living vanguard: do not heal another row or attack an enemy instead.
u.anger=100;front.hp=0;const middle=unit(11110002,0,6);act=battle.vurus(u,enemy,false,[enemy],()=>.5,false,[u,front,middle]);assert.equal(middle.hp,1000);assert.equal(enemy.hp,1000);
// Mixed skill healing must be in a native passive record: its attacking animation has no friendhp.
u=caster(11150019);front=unit(11110001,0);enemy=unit(12101003,1);
act=battle.vurus(u,enemy,false,[enemy],()=>.5,false,[u,front]);assert(act.reactions.some(r=>r.activeType===4&&r.targets.some(t=>t.result.hurtHp<0)));
// Exact attack multipliers/formation selection independent of their healing effects.
for(const [skill,slots,multiplier]of [[13100069,[6,7,8],1.35],[13100083,[11,12,13],.55],[13100093,[1,2,3,6,7,8],1.46],[13100193,rows,1.2]]){
  const hero=tablo('BaseHero').liste.find(h=>Number(h.active)===skill);u=caster(hero._id);const enemies=rows.map(pos=>unit(12101003+pos,1,pos));
  act=battle.vurus(u,enemies[0],false,enemies,()=>.5,false,[u]);
  for(const target of enemies)assert.equal(target.hp,1000-(slots.includes(target.pos)?Math.round(100*multiplier):0));
}
// Fury restoration happens after paying skill cost, including healer skills.
u=caster(11110025);enemy=unit(12101003,1);act=battle.vurus(u,enemy,false,[enemy],()=>.5,false,[u]);assert.equal(u.anger,100);
// An actual unlocked Orihime passive reduces her attacker's ATK; locked skills do not.
const ori=11110006,changes=JSON.parse(satir('HeroChangeAttr',ori).chipID);
const unlockIndex=changes.findIndex(id=>JSON.parse(satir('PartnerChange',id).effect).some(effect=>effect.addValue===13900136));assert(unlockIndex>=0);
assert.deepEqual(partner.unlocked({},ori),[]);
const state={degisim:{hero:{[ori]:unlockIndex+1}}};assert(partner.unlocked(state,ori).includes(13900136));
u=unit(12101003,1);u.skill=0;u.anger=0;front=caster(ori);front.partnerSkills=partner.unlocked(state,ori);
act=battle.vurus(u,front,false,[front],()=>.5,false,[u]);assert.equal(engine.value(u,'atk'),75);assert(act.reactions.some(r=>r.activeType===4));
// Buffs really alter damage, expire, refresh without stacking, and cleanse by polarity.
u=unit(11110001,0);let output=[];
engine.apply({effects:[{kind:'buff',scope:'s',field:'atk',value:.5,turns:1}]},u,[u],[],[],output);
assert.equal(engine.value(u,'atk'),150);engine.endRound([u]);assert.equal(engine.value(u,'atk'),150);engine.endRound([u]);assert.equal(engine.value(u,'atk'),100);
// Three rounds of continuous recovery; no extra tick after expiration.
u=unit(11110001,0);output=[];
engine.apply({effects:[{kind:'heal',scope:'s',value:.2,turns:3}]},u,[u],[],[],output);engine.endRound([u]);
for(let i=0;i<3;i++){engine.startRound([u]);engine.endRound([u]);}assert.equal(u.hp,1060);engine.startRound([u]);assert.equal(u.hp,1060);
// Death healing scales per living target's max HP and cannot bring the caster back.
u=unit(11110001,0);u.hp=0;u.partnerSkills=[13900206];front=unit(11110002,0);output=[];
partner.trigger('death',u,[u,front],[],[],output,()=>.5);assert.equal(front.hp,6000);assert.equal(u.hp,0);
let checked=0;
for(const hero of tablo('BaseHero').liste){
  u=caster(hero._id);const allies=rows.filter(pos=>pos!==11).map(pos=>unit(11110001+pos,0,pos));allies.push(u);u.hp=1000;
  const enemies=rows.map(pos=>unit(12101003+pos,1,pos));
  const before=allies.concat(enemies).map(x=>({unit:x,hp:x.hp,anger:x.anger}));
  act=battle.vurus(u,enemies[0],false,enemies,()=>.5,false,allies);
  assert(engine.get(hero.active),`${hero.name}: missing skill`);
  const all=records(act);
  for(const prior of before){const matching=all.filter(r=>r.cmd===codec.CMD.ATTACK&&r.targetCamp===prior.unit.camp&&r.targetPos===prior.unit.pos);
    assert.equal(prior.hp-matching.reduce((sum,r)=>sum+(r.result.hurtHp||0),0),prior.unit.hp,`${hero.name}: report HP diverges`);
    assert.equal(prior.anger-matching.reduce((sum,r)=>sum+(r.result.hurtAnger||0),0),prior.unit.anger,`${hero.name}: report fury diverges`);
    assert(prior.unit.hp>=0&&prior.unit.hp<=prior.unit.maxHp);assert(prior.unit.anger>=0&&prior.unit.anger<=100);
  }
  const encoded=codec.encodeBattleReport({version:3,player1:{roles:[]},player2:{roles:[]},turns:[{curTurn:1,actives:[act,...act.reactions]}]});
  const decoded=codec.decodeBattleReport(encoded);assert.equal(decoded._consumed,decoded._total);checked++;
}
assert([...partner.catalog.keys()].every(id=>partner.definitions.has(id)));
// Healing uses Kido ATK, not the maximum of physical/Kido ATK.
u=caster(ori);u.magicAtk=80;front=unit(11110001,0);enemy=unit(12101003,1);
battle.vurus(u,enemy,false,[enemy],()=>.5,false,[u,front]);assert.equal(front.hp,1096);
// Invincibility survives an instant-kill reincarnation proc and blocks hostile debuffs.
u=unit(11110001,0);u.rebirth={n:5,ae:8};enemy=unit(12101003,1);enemy.skillBuffs=[{field:'invincible',value:1,remaining:2}];
act=battle.vurus(u,enemy,false,[enemy],()=>0,false,[u]);assert.equal(enemy.hp,1000);
engine.apply({effects:[{kind:'buff',scope:'e',field:'stun',value:1,turns:2}]},u,[u],[enemy],[enemy],[],()=>0);assert(!engine.status(enemy,'stun'));
// Gear skills use real equipped instance records; draining fury cannot create extra fury.
const weapons=require('../weapon-skills');
assert.equal(weapons.definitions.size,80);
assert.deepEqual(weapons.equipped({ekipman:{takili:{[ori]:{1:5001}},esyalar:{5001:{ws:13704005}}}},ori),[13704005]);
u=unit(11110001,0);u.hp=1000;u.weaponSkills=[13703001,13704001,13705001];u.anger=0;enemy=unit(12101003,1);enemy.anger=100;
output=[];weapons.after(u,[u],[enemy],[enemy],100,output,()=>.5);assert.equal(u.hp,1101);assert.equal(u.anger,1);assert.equal(enemy.anger,99);
// Complete simulator/report round trip with wounded allies, healing and passive/weapon events.
const player=[caster(ori),unit(11110001,0),unit(11110002,0,6)];player[0].hp=500;
player[0].partnerSkills=[13900136];player[0].weaponSkills=[13703001];
const opposing=[unit(12101003,1)];opposing[0].hp=opposing[0].maxHp=10000;opposing[0].atk=20;opposing[0].skill=0;
const result=battle.kadroRapor(0,null,{birimler:opposing,ad:'Skill regression'},{playerUnits:player,scaleEnemy:false,forceWin:false,requireEnemyDefeated:true,playerState:{}});
const report=codec.decodeBattleReport(result.payload);assert.equal(report._consumed,report._total);
const health=new Map(),rage=new Map();
for(const [camp,team]of [[0,report.player1],[1,report.player2]])for(const role of team.roles){health.set(`${camp}:${role.pos}`,role.curHealth);rage.set(`${camp}:${role.pos}`,role.curAnger);}
for(const turn of report.turns)for(const active of turn.actives)for(const record of active.targets){
  if(record.cmd!==codec.CMD.ATTACK)continue;
  const key=`${record.targetCamp}:${record.targetPos}`;
  health.set(key,health.get(key)-(record.result.hurtHp||0));rage.set(key,rage.get(key)-(record.result.hurtAnger||0));
}
for(const final of player.concat(opposing)){assert.equal(health.get(`${final.camp}:${final.pos}`),final.hp);assert.equal(rage.get(`${final.camp}:${final.pos}`),final.anger);}
// Aura and active bonuses from the same hero have separate refresh identities.
u=unit(11110001,0);output=[];
for(const [id,value]of [[13900189,.2],[13100068,.2],[13100068,.2]])engine.apply({sourceId:id,effects:[{kind:'buff',scope:'s',field:'atk',value,turns:2}]},u,[u],[],[],output);
assert.equal(engine.value(u,'atk'),140);
// Native fallback animations must not swallow a pure heal.
u=caster(ori);u.skillHealsVisually=false;front=unit(11110001,0);enemy=unit(12101003,1);
act=battle.vurus(u,enemy,false,[enemy],()=>.5,false,[u,front]);assert.equal(front.hp,1120);assert(act.reactions.some(r=>r.targets.some(t=>t.result.hurtHp===-120)));
// One passive can have both immunity and after-attack healing events.
u=unit(11110001,0);u.partnerSkills=[13900219];output=[];
partner.trigger('start',u,[u],[],[],output,()=>0);assert(engine.status(u,'immuneHealBlock'));
partner.trigger('attack',u,[u],[],[],output,()=>0);assert.equal(u.hp,1015);
// Main hero's upgraded Soul Skill is used in actual reports.
const mainId=require('../seviye').anaId(),base=Number(satir('BaseHero',mainId).active),upgrade=Number(satir('SoulSkill',base).nextSkillId);
const selected=battle.kadroRapor(0,null,{birimler:[unit(12101003,1)],ad:'Selected skill'},{scaleEnemy:false,forceWin:false,playerState:{beceri:{ana:upgrade,acik:{[base]:upgrade}}}});
assert(codec.decodeBattleReport(selected.payload).player1.roles.some(role=>role.roleId===mainId&&role.skillId===upgrade));
for(const row of tablo('SoulSkill').liste){const plan=engine.get(row._id);assert(plan,`Missing upgraded Soul Skill ${row._id}`);assert(Number.isFinite(plan.multiplier)&&plan.multiplier>0);}
u=unit(mainId,0);u.skill=13100034;u.anger=100;enemy=unit(12101003,1);enemy.def=100;
battle.vurus(u,enemy,false,[enemy],()=>.5,false,[u]);assert.equal(engine.value(enemy,'def'),70);
console.log(`PASS ${checked} hero skills and ${partner.catalog.size} PartnerChange event definitions; heals in both camps, rows, limits, recovery debuffs, exact damage multipliers, fury, passive unlocks, duration, regen, death heals and report HP/fury conservation.`);
