'use strict';
// Naruto rules are opt-in per unit. Bleach's Punch/rage rules stay independent.
const { ACTIVE, ST } = require('./kodek');
const skills = require('./hero-skills');
const config = require('./naruto-sage.json');
const jiraiya = require('./jiraiya-combat');
const kabuto = require('./kabuto-combat');
const obito = require('./obito-combat');
const pain = require('./pain-combat');
const hash = require('./hashirama-combat');
const mecha = require('./mecha-combat');
const STATE = Object.freeze({ LOW_FLOAT:'lowFloat', HIGH_FLOAT:'highFloat', KNOCKDOWN:'knockdown', REPULSE:'repulse', IMMOBILE:'immobile' });
const displacement = new Set([STATE.LOW_FLOAT, STATE.HIGH_FLOAT, STATE.KNOCKDOWN, STATE.REPULSE]);
const displayStates=[null,STATE.LOW_FLOAT,STATE.HIGH_FLOAT,STATE.KNOCKDOWN,STATE.REPULSE,STATE.IMMOBILE];
function comboRecord(frame,target,state,count,isChase=false,obitoSource=false) {
  frame.targets.push({cmd:9,targetCamp:target.camp,targetPos:target.pos,reportTargetStatus:ST.HIT>>>0,
    result:{buffId:(obitoSource?(isChase?19000700:19000600):(isChase?19000200:19000100))+Math.max(0,displayStates.indexOf(state)),buffTurn:count}});
}
const profile = unit => unit.naruto || (unit.id === config.heroId ? config : unit.id === jiraiya.config.heroId ? jiraiya.config : mecha.profile(unit) || hash.profile(unit) || pain.profile(unit) || obito.profile(unit) || kabuto.profile(unit));
const order = unit => Number(unit.moveOrder) || Number(unit.pos);
function disabled(unit) {
  return unit.hp <= 0 || unit.immobileUntil >= unit.battleRound || ['stun','freeze','fossilize','void'].some(field => skills.status(unit,field));
}
function canChase(unit) { return !disabled(unit) && kabuto.canChase(unit) && !skills.status(unit,'chaos') && !unit.paralyzed && !skills.status(unit,'paralysis'); }
function setState(target, state, round) {
  if (!state || target.hp <= 0) return null;
  if (state === STATE.IMMOBILE) {
    if (skills.status(target,'immuneControl')) return null;
    target.immobileUntil = round;
    return state;
  }
  if (displacement.has(state) && !(pain.isPain(target)&&target.painFinal) && !kabuto.armor(target) && !skills.status(target,'invincible') && !skills.status(target,'immuneControl')) return state;
  return null;
}
function create(teams, options = {}) {
  const context = { teams, round:0, chakra:[0,0], trace:[], used:new Map(), primaryActions:new Map(), skillReady:new Map(), random:options.random || Math.random };
  context.enabled = teams.flat().some(unit => profile(unit));
  pain.initialize(context);
  for(const unit of teams.flat())if(obito.isObito(unit))delete unit.obitoKamuiRound;
  hash.initialize(context);
  mecha.initialize(context);
  return context;
}
function startRound(ctx, round) {
  ctx.round = round;
  ctx.used.clear();
  ctx.chakraLimit=[100,100];
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
function primaryAvailable(ctx, unit) { return ctx.primaryActions.get(unit) !== ctx.round; }
function ready(ctx, unit, key) { return ctx.round >= (ctx.skillReady.get(unit)?.get(key) || 1); }
function spendCooldown(ctx, unit, key, move) {
  if(!ctx.skillReady.has(unit)) ctx.skillReady.set(unit,new Map());
  ctx.skillReady.get(unit).set(key,ctx.round+Math.max(1,move.cooldown || 1));
}
function useStandard(ctx, unit, allies) {
  const move=mecha.selectStandard(ctx,unit,kabuto.selectStandard(ctx,unit,standard(unit,allies)));
  if(!move || !hash.canStandard(unit) || pain.active(unit,'painHorrorUntil') || disabled(unit)) return null;
  if(unit.hashStandardLossRound===ctx.round && unit.hashStandardLoss>0){
    if(mecha.isMecha(unit)){
      while(unit.hashStandardLoss>0 && mecha.available(ctx,unit)){mecha.spendStandard(unit);unit.hashStandardLoss--;}
    }else if(hash.isHash(unit)){
      while(unit.hashStandardLoss>0 && hash.available(ctx,unit)){hash.spendStandard(unit);unit.hashStandardLoss--;}
    }else if(obito.isObito(unit)){
      while(unit.hashStandardLoss>0 && obito.available(ctx,unit)){unit.obitoStandards=(unit.obitoStandards||0)+1;unit.hashStandardLoss--;}
    }else{unit.hashStandardLoss--;ctx.primaryActions.set(unit,ctx.round);return null;}
  }
  if(mecha.isMecha(unit)?!mecha.available(ctx,unit):hash.isHash(unit)?!hash.available(ctx,unit):obito.isObito(unit)?!obito.available(ctx,unit):!primaryAvailable(ctx,unit)||!ready(ctx,unit,'standard'))return null;
  // Summon/Barrage share a slot: losing a clone must not bypass the cooldown.
  if(move.cooldown!==0)spendCooldown(ctx,unit,'standard',move);
  ctx.primaryActions.set(unit,ctx.round);
  if(mecha.isMecha(unit))mecha.spendStandard(unit);
  if(hash.isHash(unit))hash.spendStandard(unit);
  if(obito.isObito(unit))unit.obitoStandards=(unit.obitoStandards||0)+1;
  return move;
}
function canMystery(ctx, unit) {
  const p=profile(unit), m=p && p.mystery;
  return !!(m && hash.canMystery(ctx,unit) && pain.canMystery(ctx,unit,m) && kabuto.canMystery(ctx,unit) && (m.consumesPrimary===false || primaryAvailable(ctx,unit)) && !disabled(unit) && !skills.status(unit,'silence') && !skills.status(unit,'chaos') && !jiraiya.blocksMystery(ctx,unit,m) && ctx.round > m.battlefieldCooldown &&
    pain.mysteryReady(ctx,unit) && ctx.chakra[unit.camp] >= pain.mysteryCost(ctx,unit,m));
}
function useMystery(ctx,unit,beforeSpend=null) {
  if (!canMystery(ctx,unit)) return null;
  const m={...profile(unit).mystery};
  if(mecha.isMecha(unit)&&!mecha.beast(unit)&&unit.hp>unit.maxHp*.6)Object.assign(m,mecha.config.highHpMystery);
  if(beforeSpend)beforeSpend();
  ctx.chakra[unit.camp]-=pain.mysteryCost(ctx,unit,m);
  pain.spendMystery(ctx,unit,m);
  hash.spendMystery(ctx,unit);
  unit.mysteryReadyRound=ctx.round+(pain.isPain(unit)?Math.max(0,m.cooldown):Math.max(1,m.cooldown));
  if(m.consumesPrimary!==false)ctx.primaryActions.set(unit,ctx.round);
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
  comboRecord(opener,target,state,count,false,obito.isObito(attacker));
  ctx.trace.push({round:ctx.round,kind:'open',actor:attacker.id,target:target.id,count,state});
  const candidates=ctx.teams[attacker.camp].flatMap(unit => ((profile(unit)||{}).chases||[]).map((chase,index)=>({unit,chase,index})))
    .sort((a,b)=>order(a.unit)-order(b.unit)||a.index-b.index);
  // Every successful chase consumes a finite per-round budget, including cycles.
  const canGrant=ctx.teams[attacker.camp].some(u=>(profile(u)||{}).chases?.some(c=>c.grantChase));
  const budget=candidates.reduce((sum,{unit,chase})=>sum+(chase.maxPerRound || 1)+(canGrant?1:0)+(obito.isObito(unit)&&!unit.obitoRage?1:0),0);
  for(let step=0; step<budget && target.hp>0; step++) {
    const eligible=({unit,chase,index}) => {
      chase=(profile(unit)||{}).chases[index];
      if(!chase)return false;
      const uses=(ctx.used.get(unit)||[])[index]||0;
      const bonus=chase.cooldown || pain.isPain(unit) || obito.isObito(unit) ? 0 : ((ctx.chaseBonus||[])[unit.camp]||0);
      return canChase(unit) && (obito.isObito(unit)?obito.chaseReady(ctx,unit,chase):ready(ctx,unit,chase.id)) && uses<(chase.maxPerRound||1)+bonus &&
        (!chase.requires || chase.requires===state) && (!chase.requiresAny || chase.requiresAny.includes(state)) && (!chase.minCombo || count>=chase.minCombo);
    };
    // Finish displacement links before independent 10/20-hit chases.
    const candidate=candidates.find(c=>(c.chase.requires || c.chase.requiresAny) && eligible(c)) || candidates.find(c=>!c.chase.requires && !c.chase.requiresAny && c.chase.minCombo && eligible(c));
    if(!candidate) break;
    const {unit,index}=candidate;
    const chase=(profile(unit)||{}).chases[index];
    const uses=ctx.used.get(unit)||[];uses[index]=(uses[index]||0)+1;ctx.used.set(unit,uses);
    if(chase.cooldown){if(obito.isObito(unit))obito.spendChase(ctx,unit,chase);else spendCooldown(ctx,unit,chase.id,chase);}
    const frame=strike(unit,target,chase);
    events.push(...(frame.beforeFrames||[]),frame,...(frame.reactions||[]));
    const hit=hitTarget(frame,target);
    if(hit) {
      count+=chase.combo || 1;
      if(chase.requires || chase.requiresAny || chase.causes) state=setState(target,chase.causes,ctx.round);
      comboRecord(frame,target,state,count,true,obito.isObito(unit));
    } else { state=null; break; }
    ctx.trace.push({round:ctx.round,kind:'chase',actor:unit.id,skill:chase.id,target:target.id,count,state});
  }
  return events;
}
function attackSpec(spec, chase=false) {
  return {...spec, naruto:true, activeType:chase?ACTIVE.NORMAL_EX:spec.prompt?ACTIVE.SKILL:ACTIVE.NORMAL};
}
module.exports={STATE,config,profile,create,startRound,disabled,canChase,canMystery,useMystery,standard,useStandard,hasClone,prepareClones,summon,resolve,attackSpec,setState};
