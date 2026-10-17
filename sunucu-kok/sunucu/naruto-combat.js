'use strict';
// Naruto rules are opt-in per unit. Bleach's Punch/rage rules stay independent.
const { ACTIVE, ST } = require('./kodek');
const skills = require('./hero-skills');
const config = require('./naruto-sage.json');
const jiraiya = require('./jiraiya-combat');
const STATE = Object.freeze({ LOW_FLOAT:'lowFloat', HIGH_FLOAT:'highFloat', KNOCKDOWN:'knockdown', REPULSE:'repulse', IMMOBILE:'immobile' });
const displacement = new Set([STATE.LOW_FLOAT, STATE.HIGH_FLOAT, STATE.KNOCKDOWN, STATE.REPULSE]);
const displayStates=[null,STATE.LOW_FLOAT,STATE.HIGH_FLOAT,STATE.KNOCKDOWN,STATE.REPULSE,STATE.IMMOBILE];
function comboRecord(frame,target,state,count,isChase=false) {
  frame.targets.push({cmd:9,targetCamp:target.camp,targetPos:target.pos,reportTargetStatus:ST.HIT>>>0,
    result:{buffId:(isChase?19000200:19000100)+Math.max(0,displayStates.indexOf(state)),buffTurn:count}});
}
const profile = unit => unit.naruto || (unit.id === config.heroId ? config : unit.id === jiraiya.config.heroId ? jiraiya.config : null);
const order = unit => Number(unit.moveOrder) || Number(unit.pos);
function disabled(unit) {
  return unit.hp <= 0 || unit.immobileUntil >= unit.battleRound || ['stun','freeze','fossilize','void'].some(field => skills.status(unit,field));
}
function canChase(unit) { return !disabled(unit) && !skills.status(unit,'chaos') && !unit.paralyzed && !skills.status(unit,'paralysis'); }
function setState(target, state, round) {
  if (!state || target.hp <= 0) return null;
  if (state === STATE.IMMOBILE) {
    if (skills.status(target,'immuneControl')) return null;
    target.immobileUntil = round;
    return state;
  }
  if (displacement.has(state) && !target.superArmor && !skills.status(target,'invincible')) return state;
  return null;
}
function create(teams, options = {}) {
  const context = { teams, round:0, chakra:[0,0], trace:[], used:new Map(), random:options.random || Math.random };
  context.enabled = teams.flat().some(unit => profile(unit));
  return context;
}
function startRound(ctx, round) {
  ctx.round = round;
  ctx.used.clear();
  for (let camp=0; camp<2; camp++) {
    // Naruto Online: a fresh team pool of 20,40,60,80,100 across rounds.
    ctx.chakra[camp] = Math.min(100, round * 20);
    for (const unit of ctx.teams[camp]) {
      unit.battleRound = round;
      const p = profile(unit);
      if (p && unit.hp > 0) ctx.chakra[camp] = Math.min(100, ctx.chakra[camp] + (p.chakraPerRound || 0));
    }
  }
}
function hasClone(unit, allies) { return allies.some(other => other.cloneOwner === unit && other.hp > 0 && !disabled(other)); }
function prepareClones(teams) {
  for (const team of teams) for (const owner of [...team]) {
    const p=profile(owner);
    if (!p || !p.cloneId || owner.hp<=0) continue;
    const pos=Array.from({length:15},(_,i)=>i+1).find(pos=>!team.some(unit=>unit.pos===pos));
    if (!pos) continue;
    const hp=Math.max(1,Math.round(owner.maxHp*p.cloneHpRatio));
    team.push({id:p.cloneId,pos,camp:owner.camp,hp,maxHp:hp,cloneOwner:owner,level:owner.level,quality:owner.quality,
      isim:'Sage Shadow Clone',atk:owner.atk,magicAtk:owner.magicAtk,def:owner.def,resistance:owner.resistance,
      speed:0,anger:0,normal:p.barrage.id,skill:0,skillId:p.barrage.id,hitRate:1,partnerSkills:[],weaponSkills:[]});
  }
}
function summon(unit, allies) {
  const clone=allies.find(other=>other.cloneOwner===unit && other.hp<=0);
  if(!clone) return [];
  clone.hp=clone.maxHp;
  return [skills.hpRecord(clone,-clone.hp,false)];
}
function standard(unit, allies) {
  const p=profile(unit);
  if (!p) return null;
  return p.barrage && hasClone(unit,allies) ? p.barrage : p.standard;
}
function canMystery(ctx, unit) {
  const p=profile(unit), m=p && p.mystery;
  return !!(m && !disabled(unit) && !skills.status(unit,'silence') && !skills.status(unit,'chaos') && !jiraiya.blocksMystery(ctx,unit,m) && ctx.round > m.battlefieldCooldown &&
    ctx.round >= (unit.mysteryReadyRound || 1) && ctx.chakra[unit.camp] >= m.chakraCost);
}
function useMystery(ctx,unit) {
  if (!canMystery(ctx,unit)) return null;
  const m=profile(unit).mystery;
  ctx.chakra[unit.camp]-=m.chakraCost;
  unit.mysteryReadyRound=ctx.round+Math.max(1,m.cooldown-(unit.jiraiyaCooldownReduction||0));
  return m;
}
function hitTarget(frame, target) {
  return frame.targets.some(row => row.targetCamp===target.camp && row.targetPos===target.pos &&
    (row.reportTargetStatus & ST.HIT) && row.result.hurtHp >= 0 && row.cmd===1);
}
// Resolve synchronously before the next normal turn. State belongs to this chain,
// not the round; high-combo counts hits, not the number of participating ninjas.
function resolve(ctx, attacker, target, opener, spec, strike) {
  const events=[];
  if (!spec || !hitTarget(opener,target) || target.hp<=0) return events;
  let count=spec.combo || 1;
  let state=setState(target,spec.stateChance==null||ctx.random()<spec.stateChance?spec.causes:null,ctx.round);
  comboRecord(opener,target,state,count);
  ctx.trace.push({round:ctx.round,kind:'open',actor:attacker.id,target:target.id,count,state});
  const candidates=ctx.teams[attacker.camp].flatMap(unit => ((profile(unit)||{}).chases||[]).map((chase,index)=>({unit,chase,index})))
    .sort((a,b)=>order(a.unit)-order(b.unit)||a.index-b.index);
  // Every successful chase consumes a finite per-round budget, including cycles.
  const canGrant=ctx.teams[attacker.camp].some(u=>(profile(u)||{}).chases?.some(c=>c.grantChase));
  const budget=candidates.reduce((sum,{chase})=>sum+(chase.maxPerRound || 1)+(canGrant?1:0),0);
  for(let step=0; step<budget && target.hp>0; step++) {
    const eligible=({unit,chase,index}) => {
      const uses=(ctx.used.get(unit)||[])[index]||0;
      return canChase(unit) && uses<(chase.maxPerRound||1)+((ctx.chaseBonus||[])[unit.camp]||0) &&
        (!chase.requires || chase.requires===state) && (!chase.minCombo || count>=chase.minCombo);
    };
    // Finish displacement links before independent 10/20-hit chases.
    const candidate=candidates.find(c=>c.chase.requires && eligible(c)) || candidates.find(c=>!c.chase.requires && c.chase.minCombo && eligible(c));
    if(!candidate) break;
    const {unit,chase,index}=candidate;
    const uses=ctx.used.get(unit)||[];uses[index]=(uses[index]||0)+1;ctx.used.set(unit,uses);
    const frame=strike(unit,target,chase);
    events.push(frame,...(frame.reactions||[]));
    const hit=hitTarget(frame,target);
    if(hit) {
      count+=chase.combo || 1;
      if(chase.requires || chase.causes) state=setState(target,chase.causes,ctx.round);
      comboRecord(frame,target,state,count,true);
    } else { state=null; break; }
    ctx.trace.push({round:ctx.round,kind:'chase',actor:unit.id,skill:chase.id,target:target.id,count,state});
  }
  return events;
}
function attackSpec(spec, chase=false) {
  return {...spec, naruto:true, activeType:chase?ACTIVE.NORMAL_EX:spec.prompt?ACTIVE.SKILL:ACTIVE.NORMAL};
}
module.exports={STATE,config,profile,create,startRound,disabled,canChase,canMystery,useMystery,standard,hasClone,prepareClones,summon,resolve,attackSpec,setState};
