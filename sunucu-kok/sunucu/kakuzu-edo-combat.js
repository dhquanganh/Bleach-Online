'use strict';
const config=require('./kakuzu-edo.json');
const skills=require('./hero-skills');
const pain=require('./pain-combat');
const {CMD,ST}=require('./kodek');
const isKakuzu=u=>u?.id===config.heroId;
const isClone=u=>u?.id===config.summonId;
const profile=u=>isKakuzu(u)?config:isClone(u)?{heroId:u.id,standard:config.cloneStandard,chases:[]}:null;
const alive=u=>u&&u.hp>0;
const canRevive=u=>u&&!u.noRevive&&!u.itachiUnrevivable;
function prepareSummons(teams){
  for(const team of teams)for(const owner of [...team].filter(isKakuzu)){
    if(team.some(u=>u.kakuzuOwner===owner))continue;
    const pos=Array.from({length:15},(_,i)=>i+1).find(p=>!team.some(u=>u.pos===p));
    if(!pos)continue;
    team.push({id:config.summonId,isim:'Water Clone',pos,camp:owner.camp,hp:0,maxHp:Math.max(1,Math.round(owner.maxHp*config.cloneHpRatio)),level:owner.level,quality:7,profession:1,atk:owner.atk,magicAtk:owner.magicAtk,def:owner.def,resistance:owner.resistance,speed:owner.speed,normal:config.cloneStandard.id,skill:0,skillId:config.cloneStandard.id,anger:0,verdi:0,hitRate:1,kakuzuOwner:owner,auxiliary:true,partnerSkills:[],weaponSkills:[]});
  }
}
function initialize(ctx){ctx.kakuzuQueue=[];for(const u of ctx.teams.flat()){
  Object.defineProperty(u,'kakuzuContext',{value:ctx,writable:true,configurable:true,enumerable:false});
  if(isKakuzu(u)){u.kakuzuAttackStacks=0;u.kakuzuReviveRound=0;}
}}
function clone(ctx,u){return ctx.teams[u.camp].find(v=>v.kakuzuOwner===u&&alive(v));}
function visual(u,move,records){return {...pain.visual(u,move),targets:records||[]};}
function summon(ctx,u){
  const c=ctx.teams[u.camp].find(v=>v.kakuzuOwner===u);
  if(!c||c.hp>0)return [];
  c.maxHp=Math.max(1,Math.round(u.maxHp*config.cloneHpRatio));c.hp=c.maxHp;
  return [visual(u,config.cloneCall,[skills.hpRecord(c,-c.hp,false)])];
}
function battleStart(ctx){const out=[];for(const u of ctx.teams.flat().filter(isKakuzu))if(u.hp>0)out.push(...summon(ctx,u));return out;}
function roundStart(ctx){const out=[];for(const u of ctx.teams.flat().filter(isKakuzu)){
  if(u.hp>0||!canRevive(u)){u.kakuzuReviveRound=0;continue;}
  if(!u.kakuzuReviveRound||u.kakuzuReviveRound>ctx.round)continue;
  u.hp=Math.max(1,Math.round(u.maxHp*.25));u.kakuzuReviveRound=0;u.mysteryReadyRound=ctx.round;u.kakuzuAttackStacks=0;
  require('./tsunade-combat').cleanseAll(u,[]);
  // A dead actor cannot execute an active animation. Restore HP through the
  // passive report first so the client clears its death state before casting.
  out.push(pain.passive(u,[skills.hpRecord(u,-u.hp,false)]),pain.visual(u,config.reincarnation));
  out.push(...summon(ctx,u));
}for(const u of ctx.teams.flat())if(u.kakuzuParalysisUntil&&u.kakuzuParalysisUntil<ctx.round){u.paralyzed=false;delete u.kakuzuParalysisUntil;}return out;}
function noteDeaths(ctx){for(const u of ctx.teams.flat().filter(isKakuzu)){if(u.hp>0||!canRevive(u)){u.kakuzuReviveRound=0;continue;}if(!u.kakuzuReviveRound)u.kakuzuReviveRound=ctx.round+config.reincarnationDelayRounds;}}
function selectStandard(ctx,u,move){return isClone(u)?config.cloneStandard:move;}
function targets(move,selected,enemies,ctx){if(!move?.kakuzuAdditional&&!move?.kakuzuStandard&&!move?.kakuzuCloneStandard)return null;
  const units=enemies.filter(alive);if(!units.length)return [];
  const pivot=units[Math.min(units.length-1,Math.floor(ctx.random()*units.length))];
  if(move.kakuzuStandard||move.kakuzuCloneStandard)return [pivot];
  const row=Math.floor((pivot.pos-1)/5);return units.filter(v=>Math.floor((v.pos-1)/5)===row);
}
function beforeDamage(ctx,target,move,damage){return isKakuzu(target)&&move?.prompt&&clone(ctx,target)?Math.min(damage,Math.max(0,target.hp-1)):damage;}
function evade(ctx,target,move,chase=false){return isKakuzu(target)&&(chase||move?.chase)&&ctx.random()<.6;}
function factor(u,field){if(field==='atk'&&isKakuzu(u))return 1+.4*(u.kakuzuAttackStacks||0);if(field==='speed')return (u.kakuzuInitiativeUntil>=u.battleRound?1.03:1)*(u.kakuzuDiscouragementUntil>=u.battleRound?.97:1);return 1;}
function prepareMove(ctx,u,move,selected){if(!isKakuzu(u)||!move?.kakuzuMystery)return move;
  const records=[];
  for(const target of ctx.teams[1-u.camp].filter(alive))if(target.shield>0){target.shield=0;records.push({cmd:CMD.SHIELD,targetCamp:target.camp,targetPos:target.pos,reportTargetStatus:ST.HIT>>>0,result:{buffId:0,buffTurn:0}});}
  return {...move,kakuzuBefore:records.length?[pain.passive(u,records)]:[],critBonus:selected?.hp>0&&selected.hp/selected.maxHp<.15?.3:0};
}
function afterHit(ctx,u,selected,hit,move,frame){
  if(!isKakuzu(u)&&!isClone(u))return;
  if(move.kakuzuStandard||move.kakuzuCloneStandard){for(const v of hit)if(v.hp>0)v.armorSuppressedUntil=ctx.round;if(isKakuzu(u)&&clone(ctx,u))ctx.kakuzuQueue.push({unit:u,move:[config.pressure,config.darkness,config.migraine][Math.floor(ctx.random()*3)]});}
  if(move.kakuzuMystery){
    if(u.painHorrorUntil>=ctx.round)delete u.painHorrorUntil;
    if(u.sasukeFearUntil>=ctx.round)delete u.sasukeFearUntil;
    if(hit.some(v=>v.hp<=0)){const records=[];skills.restore(u,u,u.maxHp*.2,records);if(records.length)frame.reactions.push(pain.passive(u,records));u.kakuzuAttackStacks=(u.kakuzuAttackStacks||0)+1;}
  }
  if(move.kakuzuAdditional){
    if(move.kakuzuAdditional==='wind'){
      for(const v of ctx.teams[u.camp])v.kakuzuInitiativeUntil=ctx.round+1;
      for(const v of hit)if(v.hp>0&&!skills.status(v,'immuneDebuffs'))v.kakuzuDiscouragementUntil=ctx.round+1;
    }
    if(move.kakuzuAdditional==='lightning'){
      for(const v of hit)if(v.hp>0&&!skills.status(v,'immuneDebuffs')){v.paralyzed=true;v.kakuzuParalysisUntil=ctx.round;}
      u.mysteryReadyRound=Math.max(ctx.round,(u.mysteryReadyRound||ctx.round)-1);
    }
    if(move.kakuzuAdditional==='fire'){
      for(const v of hit)if(v.hp>0&&!skills.status(v,'immuneDebuffs'))v.suppressedUntil=ctx.round;
      delete u.sasukeIgnitionUntil;
      u.skillBuffs=(u.skillBuffs||[]).filter(b=>!b.mechaIgnition&&!b.itachiIgnition&&!b.ntcIgnition&&b.field!=='noHeal');
    }
  }
}
function triggers(ctx){return ctx.kakuzuQueue.splice(0).filter(r=>r.unit.hp>0);}
function endRound(ctx){const out=[];for(const team of ctx.teams){
  // Reattachment belongs to the Water Clone; control does not disable it.
  for(const u of team.filter(v=>alive(v)&&isClone(v)&&alive(v.kakuzuOwner))){
    const dead=team.filter(v=>v.hp<=0&&!v.auxiliary&&!isKakuzu(v)&&canRevive(v));
    if(!dead.length)continue;
    const v=dead[Math.min(dead.length-1,Math.floor(ctx.random()*dead.length))];
    v.kakuzuReviveRound=0;
    v.hp=Math.max(1,Math.round(v.maxHp*.3));
    require('./minato-new-year-combat').triggerExecuted(ctx,u);
    out.push(visual(u,config.reattachment,[skills.hpRecord(v,-v.hp,false)]));
  }
}return out;}
module.exports={config,isKakuzu,isClone,profile,prepareSummons,initialize,clone,battleStart,roundStart,noteDeaths,selectStandard,targets,beforeDamage,evade,factor,prepareMove,afterHit,triggers,endRound};
