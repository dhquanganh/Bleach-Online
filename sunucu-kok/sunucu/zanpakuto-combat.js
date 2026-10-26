'use strict';
const {tablo,satir,json}=require('./paket'),engine=require('./hero-skills');
const B=(scope,field,value,turns)=>({kind:'buff',scope,field,value,turns});
const F=(scope,value)=>({kind:'fury',scope,value});
const H=(scope,value,turns=0)=>({kind:'heal',scope,value,turns,basis:'targetMaxHp'});
const C=(scope,field,turns)=>B(scope,field,1,turns);
const clear=(scope,negative=true)=>({kind:'clear',scope,negative});
const rules=new Map();
for(const row of tablo('KnifeExpand').liste){
 const text=String(satir('SkillConfig',row.skillID)?.desc||'').replace(/\s+/g,' '),p=[...text.matchAll(/(\d+(?:\.\d+)?)%/g)].map(m=>Number(m[1])/100),duration=Number(text.match(/for (\d+) rounds?/i)?.[1])||2;
 const group=Number(row.relationID)-1000000,level=Number(row.level);let target='all',effects=[];
 switch(group){
  case 1:target='front';effects=[B('ef','speed',-p[1],duration),B('ef','blockRate',-p[2],duration)];break;
  case 2:target='front';effects=[{kind:'dot',scope:'t',field:'ignite',value:.03,turns:duration}];break;
  case 3:target='back';break;
  case 4:target='middle';effects=[B('em','damageBonus',-p[1],duration)];break;
  case 5:target='back';{const points=Number(text.match(/Fury by (\d+)/i)?.[1])||1;effects=[F('eb',-points),F('b',points)];}break;
  case 6:target='front';effects=[B('f','hitRate',p[1],duration),B('f','dodgeRate',p[2],duration)];break;
  case 7:target='middle';effects=[B('em','damageBonus',-p[1],duration),B('m','damageBonus',p[2],duration)];break;
  case 8:target='front';effects=[B('m','damageBonus',p[1],duration)];break;
  case 9:effects=[{kind:'dot',scope:'t',field:'poison',value:.03,turns:duration}];break;
  case 10:target='front';effects=[B('a','damageBonus',p[1],duration)];break;
  case 11:target='middleback';effects=[B('m','damageBonus',p[1],duration),B('m','speed',p[2],duration)];break;
  case 12:target='middleback';effects=[B('b','damageBonus',p[1],duration),B('b','speed',p[2],duration)];break;
  case 13:target='middleback';effects=[B('a','speed',p[1],duration)];break;
  case 14:effects=[B('f','hitRate',p[1],duration),B('f','damageBonus',p[2],duration)];break;
  case 15:effects=[B('f','speed',p[1],duration),B('f','hitRate',p[2],duration),B('f','def',p[3],duration),B('f','resistance',p[3],duration)];break;
  case 16:effects=[B('a','damageBonus',p[1],duration),B('a','speed',p[2],duration)];break;
  case 17:target='frontmiddle';effects=[B('a','atk',p[1],duration),B('a','magicAtk',p[1],duration)];break;
  case 18:target='front';effects=[B('f','atk',p[1],duration),B('f','magicAtk',p[1],duration)];break;
  case 19:effects=[{kind:'shield',scope:'f',value:p[1]},B('mb','critRate',p[2],1),B('mb','critDamage',p[3],1)];break;
  case 20:effects=[{kind:'dot',scope:'e',field:'ignite',value:p[1],turns:3},{kind:'dot',scope:'e',field:'mutilate',value:p[2],turns:3},B('m','atk',p[3],3),B('m','magicAtk',p[3],3),B('a','def',p[4],2),B('a','resistance',p[4],2)];break;
  case 21:effects=[H('a',p[1],3),B('e','speed',-p[2],3),B('e','def',-p[3],3),B('e','resistance',-p[3],3)];break;
  case 22:effects=[clear('a'),...(level>=3?[clear('e',false)]:[]),C('er1','chaos',3),B('m','atk',p[1],2),B('m','magicAtk',p[1],2),B('m','critDamage',p[2],2),B('b','damageReduction',p[3],2)];break;
  case 23:effects=[clear('a'),{...B('m','punchRate',p[1],99),unclearable:true},{...B('mb','helpRate',p[2],99),unclearable:true},F('m',50)];break;
  case 24:effects=[H('f',p[1]),{...C('m','invincible',2),unclearable:true},B('b','def',p[2],2),B('b','resistance',p[2],2)];break;
 }
 if(!p.length||p.some(n=>!Number.isFinite(n))||effects.some(e=>e.value!==undefined&&!Number.isFinite(e.value)))throw Error('Invalid Zanpakuto skill '+row.skillID);
 rules.set(row._id,{row,target,effects,multiplier:p[0],turns:json(row.effects,[]),attackStat:'atk',damageType:'physical'});
}
function round(teams,turn,strike,random=Math.random){
 const frames=[];
 for(const [camp,allies]of teams.entries()){
  const owner=allies.find(u=>u.zanpakutoId),rule=rules.get(Number(owner?.zanpakutoId)),living=allies.filter(u=>u.hp>0&&!u.auxiliary);
  if(!rule||!rule.turns.includes(turn)||!living.length)continue;
  const enemies=teams[1-camp],targets=engine.select(enemies,rule.target,random,true);if(!targets.length)continue;
  const attack=living.reduce((n,u)=>n+Math.max(0,engine.value(u,'atk')),0),caster={id:-Number(rule.row.relationID),camp,pos:100,hp:1e9,maxHp:1e9,atk:attack,magicAtk:0,def:0,speed:0,anger:0,normal:rule.row.skillID,level:owner.level||1,skillBuffs:[],verdi:0,zanpakutoActor:true};
  const spec={id:rule.row.skillID,activeType:2,attackStat:'atk',damageType:'physical',multiplier:rule.multiplier,zanpakutoTargets:targets};
  const frame=strike(caster,targets[0],enemies,allies,spec),records=[];frames.push(...(frame.beforeFrames||[]),frame,...(frame.reactions||[]));
  const hit=targets.filter(t=>t.hp>0&&frame.targets.some(r=>r.targetCamp===t.camp&&r.targetPos===t.pos&&r.cmd===1&&(r.reportTargetStatus&33554432)));
  engine.apply({sourceId:rule.row.skillID,effects:rule.effects},caster,allies,enemies,hit,records,random);
  // Buffs cast at round opening expire after exactly their displayed rounds.
  for(const unit of allies.concat(enemies))for(const buff of unit.skillBuffs||[])if(buff.source===caster.id&&buff.kind==='buff'&&buff.sourceSkill===rule.row.skillID)buff.remaining=buff.turns;
  owner.verdi=(owner.verdi||0)+frame.targets.filter(r=>r.targetCamp!==camp).reduce((n,r)=>n+Math.max(0,Number(r.result?.hurtHp)||0),0);
  if(records.length)frames.push(...engine.eventFrames(living[0],records));
 }
 return frames;
}
module.exports={rules,round};
