'use strict';
// Combat rules compiled from the shipped SkillConfig, not animation event timings.
// Percentages in attackEffect.friendhp/anmyhp divide an animation into frames;
// they are NOT combat multipliers (Orihime's 100 there is a 120% heal).
const { tablo } = require('./paket');
const { CMD, ST } = require('./kodek');
const plans = new Map();
const clean = text => String(text || '').replace(/<[^>]*>/g, '').replace(/\s+/g, ' ').trim();
function formation(text) {
  text = text.toLowerCase();
  if (/all|whole|team/.test(text)) return 'all';
  if (/assaulter|asaulter/.test(text) && /support/.test(text)) return 'middleback';
  if (/vanguard/.test(text) && /assaulter|asaulter/.test(text)) return 'frontmiddle';
  if (/support/.test(text)) return 'back';
  if (/assaulter|asaulter/.test(text)) return 'middle';
  return 'front';
}
for (const row of tablo('SkillConfig').liste) {
  const text = clean(row.desc);
  const first = text.split(/[,;.]/)[0];
  const percent = text.match(/(\d+(?:\.\d+)?)%/);
  const healOnly = /^(heal|restore|recover)\b/i.test(text);
  let target = formation(first);
  if (/least hp/i.test(first)) target = /2 enemies/i.test(first) ? 'low2' : 'low';
  if (/most atk|highest attack/i.test(first)) target = 'high';
  if (/randomly attack/i.test(first)) target = /3 enemies/i.test(first) ? 'random3' : 'random2';
  const plan = { id: row._id, name: row.name, text, healOnly, target,
    multiplier: percent ? Number(percent[1]) / 100 : 1, effects: [] };
  plans.set(row._id, plan);
}
const effects = new Map();
const add = (ids, ...rules) => { for (const id of ids) effects.set(13100000 + id, [...(effects.get(13100000 + id) || []), ...rules]); };
// Scope: s=self, a=all allies, f/m/b=ally rows, t=hit enemies,
// e=all enemies, ef/em/eb=enemy rows. Buff duration is in complete rounds.
const buff = (scope, field, value, turns, chance = 1) => ({ kind: 'buff', scope, field, value, turns, chance });
const fury = (scope, value, chance = 1) => ({ kind: 'fury', scope, value, chance });
const heal = (scope, value, turns = 0, basis = 'attack') => ({ kind: 'heal', scope, value, turns, basis });
const control = (scope, field, turns, chance = 1) => buff(scope, field, 1, turns, chance);
const dot = (scope, value, turns, field = 'poison', chance = 1) => ({ kind: 'dot', scope, value, turns, field, chance });
const clear = (scope, negative) => ({ kind: 'clear', scope, negative });
const shield = (scope, value) => ({ kind: 'shield', scope, value });
add([1,17,33,115], buff('s','hitRate',1,3));
add([2,18,34], buff('t','def',-.3,4));
add([3,19,35], control('t','stun',2));
add([4,20,36], control('m','immuneControl',3));
add([5,21,37]); // Descriptions omit the healing-reduction magnitude.
add([6,22,38,13,29,45]); // Pure attacks; target and coefficient come from SkillConfig.
add([7,23,39], buff('s','helpRate',1,2));
add([8,24,40], buff('s','punchRate',1,1));
add([9,25,41], buff('m','atk',.15,2));
add([50,116], buff('s','blockRate',.25,3));
add([52], buff('t','damageReduction',-.1,3));
add([53], heal('f',1)); add([59], heal('f',1.2));
add([57], buff('s','blockRate',.35,3)); add([58], buff('t','def',-.15,3));
add([67], buff('s','dodgeRate',.2,3)); add([68], buff('s','atk',.2,2));
add([70], fury('m',30), fury('s',100));
add([71], control('t','stun',3,'level'));
add([76], buff('s','blockRate',.35,3), buff('s','atk',.15,3));
add([77], buff('s','def',.3,3)); add([78], buff('s','atk',.18,3));
add([81,83,98,161], fury('t',-50), control('t','stun',3,'level'));
add([84], fury('s',100), fury('other',25));
add([85], fury('t',-50), fury('s',25));
add([89], buff('t','atk',-.5,1), fury('s',25));
add([93], fury('t',-5), fury('s',25));
add([95], fury('s',100), clear('b',true), control('b','immuneControl',2));
add([193], buff('t','speed',-.05,3)); add([86], buff('m','blockRate',.1,3));
add([88], buff('m','helpRate',.85,2));
add([94], heal('fm',1.1), fury('s',100));
add([100], dot('t',.25,3));
add([99], buff('t','def',-.25,2), fury('s',100));
add([96], buff('s','blockRate',.15,3), heal('s',.5));
add([159], buff('m','helpRate',.6,3), heal('s',.45));
add([160], buff('m','critRate',.1,3));
add([162], buff('s','critRate',.4,3), buff('s','def',-.45,3));
add([163], dot('t',.3,3), buff('s','critRate',.25,3));
add([164], buff('m','atk',.16,3), buff('t','def',-.16,3));
add([165], buff('a','def',.35,2));
add([166], {kind:'selfDamage',value:.6}, buff('s','critRate',.35,3));
add([167], buff('t','def',-.2,3), fury('s',50)); add([168], buff('s','critRate',.35,3));
add([194], buff('m','damageBonus',.08,3), buff('m','blockRate',.1,3));
add([195], buff('t','damageReduction',-.2,2), buff('t','atk',-.25,2), fury('s',100));
add([198], fury('m',30), fury('s',100), buff('m','damageBonus',.12,3));
add([199], buff('t','atk',-.25,3), buff('t','wreckRate',-.25,3), buff('s','blockRate',.25,3));
add([203], clear('m',true), control('m','immuneControl',2), buff('s','wreckRate',.25,3));
add([202], buff('t','blockRate',-.25,3), buff('t','def',-.1,3), fury('s',25));
add([204], buff('t','damageBonus',-.15,3), buff('m','atk',.25,3), fury('s',35));
add([205], control('emb','stun',2,'level'), fury('s',100), fury('other',25));
add([207], buff('b','helpRate',.65,3), heal('sb',.2,3));
add([210], fury('s',68), buff('t','wreckRate',-.3,2), fury('t',-10,.5));
add([208], buff('b','damageBonus',.1,2), fury('a',25));
add([209], fury('s',100), fury('m',30), buff('fm','blockRate',.3,2), buff('fm','damageBonus',.12,2));
add([169], buff('s','atk',.5,1), buff('s','wreckRate',.35,3));
add([170], buff('f','dodgeRate',.5,1), fury('s',68));
add([171], buff('s','blockRate',.75,3), buff('s','def',.15,3));
add([172], buff('m','atk',.2,2), fury('s',50));
add([173], fury('a',25), buff('s','critRate',.15,2), fury('s',100));
add([174], buff('t','def',-.1,3));
add([175], buff('t','speed',-.1,3), buff('s','punchRate',1,1));
add([176], buff('t','wreckRate',-.75,2), fury('s',20));
add([177], fury('t',-10,.5), control('t','stun',3,'level'));
add([178], buff('a','blockRate',.25,3), buff('a','atk',.1,3));
add([206], buff('s','blockRate',.15,3), buff('mb','helpRate',.45,3), heal('s',.55));
add([200], fury('s',100)); add([201], buff('s','atk',.1,3), fury('s',100));
add([211], control('s','invincible',2));
add([212], control('t','silence',2), fury('s',68));
add([228], control('t','void',2), buff('m','punchRate',.35,2), fury('s',100));
add([230], control('t','void',2), buff('m','punchRate',.35,2));
add([214], buff('s','atk',.2,2));
add([213], dot('t',.25,3,'ignite'), {...control('er3','noFury',2),group:'restrictions'}, {...control('er3','noHeal',2),group:'restrictions'});
add([245], heal('a',.8), buff('a','atk',.5,1), fury('s',100));
add([244], shield('a',.01), buff('s','def',.3,3));
add([229], fury('er3',-10), control('eb','silence',2), buff('b','punchRate',.35,2), fury('sf',25));
add([231], control('alow','invincible',2), fury('s',35), buff('b','wreckRate',.25,2));
add([232], control('ef','noFury',2), fury('ef',-25), buff('em','atk',-.25,2), control('eb','silence',2), fury('s',25));
add([233], buff('e','recoverRate',-1,3), control('ef','stun',3), dot('ef',.3,3,'mutilate'));
add([234], buff('s','critRate',1,1), buff('s','dodgeRate',.3,1), buff('s','wreckRate',.3,1), fury('s',100), heal('s',.05));
add([235], buff('s','critRate',.45,1), buff('a','critDamage',.5,1), fury('s',100));
add([236], control('e','disarm',1,.75), control('e','silence',1,.75), buff('m','punchRate',.3,1), fury('s',100));
add([237], dot('t',1,2,'ignite',.5), control('t','chaos',1), buff('b','speed',.2,2));
add([238], buff('e','damageBonus',-.25,2), buff('s','damageBonus',1,1), fury('er2',-100), fury('s',50));
add([239], buff('mb','atk',.5,1), control('a','invincible',1), fury('emb',-25));
add([241], dot('er1',.8,1,'mutilate'), fury('e',-10), heal('s',.15));
add([240], heal('a',.2), buff('mb','def',2,1));
add([242], control('e','noFury',1), buff('b','damageBonus',.2,1), buff('b','punchRate',.5,1), fury('b',40));
add([246], fury('efm',-50), control('eb','chaos',1), fury('s',75));
add([247], heal('s',.2), buff('s','damageBonus',.3,2), buff('s','damageReduction',.3,2), fury('s',35));
add([248], control('em','chaos',1), fury('eb',-30), buff('m','damageBonus',.2,1), fury('m',30));
add([250], buff('m','speed',.25,2), buff('m','atk',.25,2), fury('e',-10), shield('a',.05), heal('alow',1));
add([254], buff('m','damageBonus',.7,2), buff('m','punchRate',.5,1), buff('b','speed',.07,2), fury('s',50));
add([251], control('e','freeze',1,.3), fury('eb',-10), buff('s','damageBonus',.2,2));
add([252], buff('e','recoverRate',-.75,2), control('er2','disarm',2), fury('s',100));
add([253], control('em','stun',2), buff('emb','damageBonus',-.5,2));
add([255], buff('e','dodgeRate',-1.5,1), buff('m','damageBonus',.5,1));
add([256], {...control('er3','chaos',1),group:'chaos-dot'}, {...dot('er3',.25,3,'mutilate'),group:'chaos-dot'}, buff('a','speed',.15,1), heal('s',.1,0,'maxHp'));
add([258], buff('e','speed',-.2,1), fury('ar1',70), buff('s','damageReduction',.2,1), fury('s',70));
add([257], shield('a',.5), fury('e',-40), buff('s','speed',.3,2));
add([259], fury('ar1',100), control('ar1','invincible',1), buff('ar1','damageBonus',1,1), buff('er1','damageReduction',-1,1), fury('s',100));
add([260], buff('s','damageBonus',.3,2), buff('a','helpRate',.3,2), fury('s',50));
add([261], buff('mb','damageBonus',.3,2), buff('e','def',-.5,2), fury('s',50));
add([262], buff('s','speed',.2,2), buff('er2','blockRate',-.3,2), fury('s',50));
add([263], buff('e','def',-.3,2), control('e','silence',1,.75), fury('s',50));
add([264], control('e','freeze',1), buff('e','vulnerability',.4,1), fury('e',-50), control('er3','silence',1), fury('s',50));
add([265], dot('t',.5,3,'ignite'), fury('s',50));
add([266], buff('a','atk',.3,2), buff('a','def',.3,2), buff('e','speed',-.2,2), fury('s',50));
add([267], buff('t','atk',-.5,2), buff('t','critRate',-1,2), buff('t','hitRate',-.5,2), fury('s',50));
add([268], buff('e','dodgeRate',-.5,2), buff('e','blockRate',-.5,2));
add([269], control('er2','stun',1), buff('e','hitRate',-.3,2), fury('s',50));
add([270], fury('s',100), buff('s','speed',.4,2), buff('s','blockRate',.3,2), shield('m',.5), fury('s',50));
add([271], buff('m','critDamage',.5,2), fury('s',50));
add([273], dot('e',1,2), buff('e','damageReduction',-.4,2), fury('s',35));
add([274], buff('s','blockRate',.3,2), buff('s','damageReduction',.3,2), clear('e',false), fury('s',50));
add([275], buff('s','damageReduction',.7,1), control('e','silence',1), fury('s',35));
add([276], buff('m','atk',.5,2), fury('s',50));
add([277], control('efm','chaos',2), fury('s',50));
add([279], control('er3','stun',2), fury('s',50));
add([280], control('s','reflect',2), fury('a',50));
add([281], dot('e',1,2), control('e','chaos',2), fury('s',50));
add([282], buff('a','wreckRate',.5,2), control('e','disarm',2), fury('s',50));
add([283], fury('e',-50), fury('s',50));
add([284], control('em','void',2), control('eb','silence',2), fury('s',50));
add([287], buff('t','atk',-.6,2), dot('e',1.2,2,'ignite'));
add([288], buff('em','atk',-.5,1), dot('ef',1.6,2,'bleeding'), clear('e',false), fury('s',40));
add([289], buff('t','damageReduction',-.7,2), buff('t','blockRate',-.5,2), control('t','chaos',2), control('s','invincible',2), fury('s',50));
add([243], fury('s',100), fury('e',-10,.5), control('e','disarm',1,.5), heal('s',.05));
add([249], buff('b','punchRate',.5,1), buff('s','damageBonus',.15,2), fury('s',50));
add([215], buff('s','atk',.25,3), buff('s','critRate',.25,3));
add([216], control('t','noHeal',2), fury('s',100));
add([217], control('t','noHeal',3), buff('t','def',-.15,3), fury('s',100));
add([218], control('t','disarm',2), fury('s',10));
add([219], control('t','disarm',2), fury('t',-10), fury('s',25));
add([220], buff('t','hitRate',-.5,2), fury('fm',10));
add([221], buff('t','hitRate',-.65,2), buff('a','dodgeRate',.15,2), fury('fm',25));
add([222], dot('er1',.5,2,'ignite'));
add([223], dot('er3',.5,3,'ignite'), fury('s',38));
add([224], control('t','fossilize',1), buff('s','atk',.25,2), buff('s','critRate',.35,2));
add([225], control('t','fossilize',2), control('er1','silence',2), buff('s','atk',.35,2), buff('s','critRate',.55,2), fury('ar1',100));
add([226], control('em','void',1), control('eb','noFury',1), buff('ef','atk',1,1), control('ef','chaos',1));
add([227], control('em','void',2), control('eb','noFury',2), buff('ef','atk',1.5,1), control('ef','chaos',1));
for (const plan of plans.values()) {
  const row = tablo('SkillConfig').byId.get(plan.id);
  const base = Number(row.skillId) || plan.id;
  plan.effects = effects.get(base) || [];
}
const controls = new Set(['stun','silence','disarm','fossilize','void','chaos','freeze','noFury','noHeal']);
const multiplicative = new Set(['atk','def','speed']);
const buffIds = { atk:[13500009,13500010], def:[13500013,13500014], speed:[13500045,13500046],
  hitRate:[13500037,13500038], dodgeRate:[13500033,13500034], critRate:[13500035,13500036],
  blockRate:[13500029,13500030], punchRate:[13500039,13500040], helpRate:[13500041,13500042],
  wreckRate:[13500058,13500059], damageBonus:[13500054,13500055], damageReduction:[13500052,13500053],
  recoverRate:[13500043,13500044], critDamage:[13500080,13500080],
  immuneControl:[13500047,13500047], invincible:[13500066,13500066], reflect:[13500091,13500091],
  stun:[13500049,13500049], silence:[13500050,13500050], noFury:[13500060,13500060],
  noHeal:[13500062,13500062], disarm:[13500063,13500063], fossilize:[13500064,13500064],
  void:[13500065,13500065], chaos:[13500067,13500067], freeze:[13500089,13500089],
  vulnerability:[13500089,13500089] };
function get(id) { return plans.get(Number(id)); }
function alive(team) { return team.filter(unit => unit.hp > 0).slice().sort((a,b) => a.pos-b.pos); }
function randomPick(team, count, random) {
  const list = alive(team), out = [];
  while (list.length && out.length < count) out.push(list.splice(Math.min(list.length-1, Math.floor(Math.max(0,random())*list.length)),1)[0]);
  return out;
}
function select(team, scope, random = Math.random, fallback = false) {
  const list = alive(team);
  if (scope === 'all') return list;
  if (/^random/.test(scope)) return randomPick(list, Number(scope.slice(6)), random);
  if (scope === 'low' || scope === 'low2') return list.sort((a,b) => a.hp-b.hp || a.pos-b.pos).slice(0,scope==='low2'?2:1);
  if (scope === 'high') return list.sort((a,b) => b.atk-a.atk || a.pos-b.pos).slice(0,1);
  const rows = scope === 'frontmiddle' ? [0,1] : scope === 'middleback' ? [1,2] : [{front:0,middle:1,back:2}[scope]];
  const matches = list.filter(unit => rows.includes(Math.floor((unit.pos-1)/5)));
  return matches.length || !fallback ? matches : list.filter(unit => Math.floor((unit.pos-1)/5) === Math.floor((list[0].pos-1)/5));
}
function scoped(scope, caster, allies, enemies, targets, random) {
  if(scope==='s')return caster.hp>0?[caster]:[];
  if(scope==='t')return alive(targets);
  if(scope==='a')return alive(allies);
  if(scope==='other')return alive(allies).filter(unit=>unit!==caster);
  if(scope==='e')return alive(enemies);
  if(scope==='alow')return select(allies,'low',random);
  if(scope==='ehigh')return select(enemies,'high',random);
  if(scope==='elow')return select(enemies,'low',random);
  if(scope==='emale')return alive(enemies).filter(unit=>unit.sex===1);
  if(/^(e)?q[123]$/.test(scope))return alive(scope.startsWith('e')?enemies:allies).filter(unit=>unit.profession===Number(scope.slice(-1)));
  if(/^[ae]r\d$/.test(scope))return randomPick(scope[0]==='a'?allies:enemies,Number(scope[2]),random);
  const enemy=scope.startsWith('e'); if(enemy)scope=scope.slice(1);
  const selected=alive(enemy?enemies:allies).filter(unit=>scope.includes('f')&&unit.pos<=5||scope.includes('m')&&unit.pos>=6&&unit.pos<=10||scope.includes('b')&&unit.pos>=11);
  if(scope.includes('s')&&caster.hp>0&&!selected.includes(caster))selected.push(caster);
  return selected;
}
function status(unit, field) {
  if(field==='chaos'&&unit.extremeChaosUntil>=unit.battleRound)return true;
  if(unit.suppressedUntil>=unit.battleRound&&['immuneControl','immuneHealBlock','invincible','void'].includes(field))return false;
  return !!(unit.skillBuffs || []).find(buff=>buff.field===field&&buff.remaining>0);
}
function value(unit, field) {
  const changes=(unit.skillBuffs||[]).filter(buff=>buff.field===field&&buff.remaining>0&&(buff.threshold==null||unit.hp/unit.maxHp<buff.threshold)).reduce((sum,buff)=>sum+buff.value*(buff.step?Math.floor((1-unit.hp/unit.maxHp+1e-9)/buff.step):1),0);
  const base=Number(unit[field])||0;
  return multiplicative.has(field)?Math.max(0,base*(1+changes)):base+changes;
}
function hpRecord(unit, amount, targetEffect=true) {
  return {cmd:CMD.ATTACK,targetCamp:unit.camp,targetPos:unit.pos,
    reportTargetStatus:(ST.HIT|(targetEffect?ST.TARGET_EFFECT:0)|(unit.hp<=0?ST.DIED:0))>>>0,result:{hurtHp:amount,hurtAnger:0}};
}
function changeFury(unit, amount, records, unresistable=false, random=Math.random) {
  if(unit.hp<=0||!unresistable&&(amount>0&&status(unit,'noFury')||amount<0&&value(unit,'furyResist')>0&&random()<value(unit,'furyResist')))return;
  const before=unit.anger; unit.anger=Math.max(0,Math.min(100,before+amount));
  records.push({cmd:CMD.ATTACK,targetCamp:unit.camp,targetPos:unit.pos,reportTargetStatus:ST.HIT>>>0,result:{hurtHp:0,hurtAnger:before-unit.anger}});
}
function restore(caster, target, amount, records) {
  if(target.hp<=0)return 0;
  const rate=Math.max(0,1+value(target,'recoverRate'));
  const restored=status(target,'noHeal')&&!status(target,'immuneHealBlock')?0:Math.min(Math.max(0,target.maxHp-target.hp),Math.max(0,Math.round(amount*rate)));
  target.hp+=restored;
  records.push(hpRecord(target,-restored));
  return restored;
}
function healPower(caster) {
  const base=caster.profession!==3||caster.magicAtk==null?Number(caster.atk)||0:Number(caster.magicAtk)||0;
  return base*(caster.atk>0?value(caster,'atk')/caster.atk:1);
}
function putBuff(caster,target,rule,records,random=Math.random,sourceSkill=0) {
  if(controls.has(rule.field)&&(status(target,'immuneControl')||target.shield>0||value(target,'controlResist')>0&&random()<value(target,'controlResist')))return;
  if(rule.field==='silence'&&value(target,'silenceResist')>0&&random()<value(target,'silenceResist'))return;
  target.skillBuffs=target.skillBuffs||[];
  const existing=target.skillBuffs.find(buff=>buff.source===caster.id&&buff.field===rule.field&&buff.sourceSkill===sourceSkill);
  const data={...rule,source:caster.id,sourceSkill,remaining:rule.turns+1,value:rule.value+(rule.accumulate&&existing?existing.value:0)};
  if(existing)Object.assign(existing,data);else target.skillBuffs.push(data);
  const ids=buffIds[rule.field]; if(!ids)return;
  records.push({cmd:controls.has(rule.field)||['invincible','immuneControl','reflect'].includes(rule.field)?CMD.CONTROLBUFF:CMD.ATTRBUFF,
    targetCamp:target.camp,targetPos:target.pos,reportTargetStatus:ST.HIT>>>0,result:{buffId:ids[rule.value<0?1:0],buffTurn:rule.turns}});
}
function remove(target,negative,records) {
  if(negative){for(const field of ['jiraiyaResistanceStacks','extremeChaosUntil','suppressedUntil','immobileUntil'])delete target[field];target.paralyzed=false;}
  const removed=(target.skillBuffs||[]).filter(buff=>negative?controls.has(buff.field)||buff.kind==='dot'||buff.value<0:!controls.has(buff.field)&&buff.kind!=='dot'&&buff.value>0&&buff.field!=='reflect');
  target.skillBuffs=(target.skillBuffs||[]).filter(buff=>!removed.includes(buff));
  for(const buff of removed){const ids=buffIds[buff.field];const id=ids?ids[buff.value<0?1:0]:buff.buffId;
    if(id)records.push({cmd:controls.has(buff.field)?CMD.CONTROLBUFF:CMD.ATTRBUFF,targetCamp:target.camp,targetPos:target.pos,reportTargetStatus:ST.HIT>>>0,result:{buffId:id,buffTurn:0}});}
}
function removeField(target,field,records) {
  const removed=(target.skillBuffs||[]).filter(buff=>buff.field===field);
  target.skillBuffs=(target.skillBuffs||[]).filter(buff=>buff.field!==field);
  if(removed.length&&buffIds[field])records.push({cmd:CMD.CONTROLBUFF,targetCamp:target.camp,targetPos:target.pos,reportTargetStatus:ST.HIT>>>0,result:{buffId:buffIds[field][0],buffTurn:0}});
}
function apply(plan,caster,allies,enemies,hitTargets,records,random=Math.random) {
  if(!plan)return;
  const randomGroups=new Map();
  for(const rule of plan.effects){
    let targets=scoped(rule.scope||'s',caster,allies,enemies,hitTargets,random);
    // Paired random statuses from one skill belong to the same selected group.
    if(rule.group&&/^[ae]r\d$/.test(rule.scope)){
      if(randomGroups.has(rule.group))targets=randomGroups.get(rule.group);else randomGroups.set(rule.group,targets);
    }
    for(const target of targets){
      if(caster.camp!==target.camp&&status(target,'invincible')&&rule.kind!=='clear')continue;
      const chance=rule.chance==='level'?Math.max(.05,Math.min(.95,.5+((caster.level||1)-(target.level||1))*.02+value(caster,'controlRate'))):rule.chance==null?1:rule.chance;
      if(chance<1&&random()>=chance)continue;
      if(rule.kind==='fury')changeFury(target,rule.fraction?Math.round(target.anger*rule.value):rule.value,records,rule.unresistable,random);
      else if(rule.kind==='heal'){
        const amount=(rule.basis==='maxHp'?caster.maxHp:rule.basis==='targetMaxHp'?target.maxHp:healPower(caster))*rule.value;
        if(rule.turns){target.skillBuffs=target.skillBuffs||[];const prior=target.skillBuffs.find(b=>b.kind==='regen'&&b.source===caster.id);
          const data={kind:'regen',source:caster.id,amount,remaining:rule.turns+1,buffId:13500019};if(prior)Object.assign(prior,data);else target.skillBuffs.push(data);
          records.push({cmd:CMD.ATTRBUFF,targetCamp:target.camp,targetPos:target.pos,reportTargetStatus:ST.HIT>>>0,result:{buffId:13500019,buffTurn:rule.turns}});
        }else restore(caster,target,amount,records);
      }else if(rule.kind==='buff')putBuff(caster,target,rule,records,random,plan.sourceId||plan.id||0);
      else if(rule.kind==='clear')remove(target,rule.negative,records);
      else if(rule.kind==='shield'){
        remove(target,true,records);target.shield=Math.min(0xffffffff,Math.max(target.shield||0,Math.round(value(caster,'atk')*rule.value)));
        records.push({cmd:CMD.SHIELD,targetCamp:target.camp,targetPos:target.pos,reportTargetStatus:ST.HIT>>>0,result:{buffId:0,buffTurn:target.shield}});
      }else if(rule.kind==='dot'){
        target.skillBuffs=target.skillBuffs||[];const prior=target.skillBuffs.find(b=>b.field===rule.field&&b.source===caster.id);
        const id={poison:13500020,bleeding:13500021,ignite:13500022,mutilate:13500079}[rule.field];
        const data={...rule,source:caster.id,amount:(rule.basis==='targetMaxHp'?target.maxHp:value(caster,'atk'))*rule.value,remaining:rule.turns+1,buffId:id};if(prior)Object.assign(prior,data);else target.skillBuffs.push(data);
        records.push({cmd:CMD.ATTRBUFF,targetCamp:target.camp,targetPos:target.pos,reportTargetStatus:ST.HIT>>>0,result:{buffId:id,buffTurn:rule.turns}});
      }else if(rule.kind==='maxHp'){
        const ratio=target.hp/target.maxHp;target.maxHp=Math.min(0x7fffffff,Math.max(1,Math.round(target.maxHp*(1+rule.value))));target.hp=Math.max(target.hp>0?1:0,Math.round(target.maxHp*ratio));
      }else if(rule.kind==='damage'){
        if(status(target,'invincible'))continue;
        const damage=Math.min(target.hp,Math.max(0,Math.round(value(caster,'atk')*rule.value*(1-Math.max(0,Math.min(1,value(target,'damageReduction')))))));
        target.hp-=damage;records.push(hpRecord(target,damage));
      }else if(rule.kind==='selfDamage'){
        const damage=Math.min(caster.hp,Math.round(value(caster,'atk')*rule.value));caster.hp-=damage;records.push(hpRecord(caster,damage,false));
      }
    }
  }
}
function startRound(units) {
  const actives=[];
  for(const unit of units){
    if(unit.hp<=0)continue;
    const records=[];
    for(const buff of [...unit.skillBuffs||[]]){
      if(buff.kind==='regen')restore(unit,unit,buff.amount,records);
      else if(buff.kind==='dot'&&!status(unit,'invincible')){
        const damage=Math.min(unit.hp,Math.max(0,Math.round(buff.amount)));unit.hp-=damage;records.push(hpRecord(unit,damage,false));
      }
      if(unit.hp<=0)break;
    }
    if(records.length)actives.push(...eventFrames(unit,records));
  }
  return actives;
}
function endRound(units){
  const actives=[];
  for(const unit of units){const records=[];
    for(const buff of unit.skillBuffs||[]){buff.remaining--;if(buff.remaining<=0){const ids=buffIds[buff.field];const id=ids?ids[buff.value<0?1:0]:buff.buffId;
      if(id)records.push({cmd:controls.has(buff.field)?CMD.CONTROLBUFF:CMD.ATTRBUFF,targetCamp:unit.camp,targetPos:unit.pos,reportTargetStatus:ST.HIT>>>0,result:{buffId:id,buffTurn:0}});}}
    unit.skillBuffs=(unit.skillBuffs||[]).filter(buff=>buff.remaining>0);
    if(unit.hp>0&&records.length)actives.push(...eventFrames(unit,records));
  }return actives;
}
function eventFrames(unit,records) {
  if(!records.length)return [];
  // Flash groups Active_PassiveSkill records after a normal root command, and
  // applies their HP directly. A normal animation has no friendhp for regen.
  return [{activeCamp:unit.camp,activePos:unit.pos,skillEffectId:unit.normal,activeType:1,
    targets:[{cmd:CMD.NONE,targetCamp:unit.camp,targetPos:unit.pos,reportTargetStatus:ST.HIT>>>0,result:{}}]},
    {activeCamp:unit.camp,activePos:unit.pos,skillEffectId:0,activeType:4,targets:records}];
}
module.exports={get,plans,effects,select,scoped,status,value,apply,restore,healPower,changeFury,remove,removeField,startRound,endRound,hpRecord,eventFrames};
