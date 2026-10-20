'use strict';
const config=require('./kabuto-gnw.json'),skills=require('./hero-skills'),{CMD,ST}=require('./kodek');
const guests=['deidara','dan','pakura'];
const isKabuto=u=>u.id===config.heroId;
const isMu=u=>u.id===config.mu.heroId;
const isGuest=u=>guests.some(name=>u.id===config[name].heroId);
const profile=u=>isKabuto(u)?config:isMu(u)?config.mu:guests.map(k=>config[k]).find(p=>p.heroId===u.id)||null;
const alive=units=>units.filter(u=>u.hp>0&&!isGuest(u));
const suppressed=u=>u.kabutoSuppressedUntil>=u.battleRound||u.suppressedUntil>=u.battleRound;
const immune=u=>!suppressed(u)&&skills.status(u,'immuneDebuffs');
const cursed=u=>u.kabutoCurseUntil>=u.battleRound;
const blind=u=>u.kabutoBlindUntil>=u.battleRound;
const edo=u=>!!(u.edoTensei||(profile(u)||{}).edoTensei);
const armor=u=>!!((u.superArmor||require('./mecha-combat').beast(u))&&(!(u.kabutoArmorSuppressedUntil>=u.battleRound)||require('./mecha-combat').advanced(u)));
const activeBarrier=ctx=>ctx.barrier&&ctx.barrier.kind==='lightweight'&&ctx.round<=ctx.barrier.until;
const canStandard=(ctx,u)=>!blind(u)&&(!activeBarrier(ctx)||isKabuto(u)||edo(u));
const canMystery=(ctx,u)=>!cursed(u)&&u.kabutoInterruptedRound!==ctx.round;
const canChase=u=>!cursed(u);
const canRevive=(ctx,u)=>!u.noRevive&&!u.kabutoReviveBlocked&&ctx.round>=(u.kabutoRevivalReadyRound||1);
function label(records,u,index,count=0){records.push({cmd:CMD.FLOAT,targetCamp:u.camp,targetPos:u.pos,reportTargetStatus:ST.HIT>>>0,result:{buffId:19000400+index,buffTurn:count}});}
function visual(u,move,records=[]){return {activeCamp:u.camp,activePos:u.pos,skillEffectId:move.id,activeType:1,targets:[{cmd:CMD.NONE,targetCamp:u.camp,targetPos:u.pos,reportTargetStatus:0,result:{}},...records]};}
function passive(u,records){return {activeCamp:u.camp,activePos:u.pos,skillEffectId:0,activeType:4,targets:records};}
function resetSummon(ctx,u,records){
  skills.remove(u,true,records);skills.remove(u,false,records);skills.removeField(u,'reflect',records);
  u.skillBuffs=[];delete u.noRevive;
  if(u.shield){u.shield=0;records.push({cmd:CMD.SHIELD,targetCamp:u.camp,targetPos:u.pos,reportTargetStatus:ST.HIT>>>0,result:{buffId:0,buffTurn:0}});}
  ctx.used.delete(u);
}
function prepare(teams,ctx){
  for(const team of teams)for(const owner of [...team]){
    if(!isKabuto(owner)||owner.hp<=0)continue;
    owner.immuneDebuffs=true;owner.senjutsu=true;
    for(const kind of ['mu',...guests]){
      const pos=Array.from({length:15},(_,i)=>i+1).find(pos=>!team.some(u=>u.pos===pos));
      if(!pos)continue;
      const p=config[kind],maxHp=kind==='mu'?owner.maxHp:1;
      team.push({id:p.heroId,isim:p.name,pos,camp:owner.camp,hp:0,maxHp,kabutoOwner:owner,summonKind:kind,
        edoTensei:true,auxiliary:kind!=='mu',level:owner.level,quality:7,profession:3,
        atk:owner.atk,magicAtk:owner.magicAtk,def:owner.def,resistance:owner.resistance,speed:Math.max(1,(owner.speed||100)-1),
        normal:p.standard.id,skill:0,skillId:p.standard.id,anger:0,hitRate:1,partnerSkills:[],weaponSkills:[]});
    }
  }
  for(const u of teams.flat()){u.kabutoContext=ctx;if(isKabuto(u))u.immuneDebuffs=true;}
}
function summonMu(ctx,owner,actives){
  const mu=ctx.teams[owner.camp].find(u=>isMu(u)&&u.kabutoOwner===owner);
  if(!mu)return;
  const before=mu.hp;mu.hp=mu.maxHp=owner.maxHp;delete mu.noRevive;delete mu.kabutoReviveRound;
  const records=[];resetSummon(ctx,mu,records);label(records,owner,1);
  records.push({cmd:CMD.NONE,targetCamp:mu.camp,targetPos:mu.pos,reportTargetStatus:0,result:{}});
  actives.push(visual(owner,config.summon,records));
  if(mu.hp!==before)actives.push(passive(owner,[skills.hpRecord(mu,before-mu.hp,false)]));
  if(ctx.round>=(mu.kabutoBarrierReadyRound||1)){
    mu.kabutoBarrierReadyRound=ctx.round+config.mu.barrier.cooldown;
    ctx.barrier={kind:'lightweight',owner:owner.camp,source:mu.id,until:ctx.round+1,saves:{}};
    ctx.kabutoBarrierExpired=false;
    const barrier=[];label(barrier,mu,2,2);actives.push(visual(mu,config.mu.barrier,barrier));
  }
}
function roundStart(ctx,actives){
  const requests=[];
  if(ctx.barrier&&ctx.barrier.kind==='lightweight'&&ctx.round>ctx.barrier.until){
    ctx.kabutoBarrierExpired=true;
    ctx.barrier=null;
  }
  for(const u of ctx.teams.flat()){
    if(!isKabuto(u))continue;
    u.kabutoHealUses=0;
    if(u.hp<=0&&u.kabutoReviveRound<=ctx.round&&canRevive(ctx,u)){
      u.hp=Math.max(1,Math.round(u.maxHp*config.revival.hpRatio));delete u.kabutoReviveRound;
      u.kabutoRevivalReadyRound=ctx.round+config.revival.cooldown;
      u.mysteryReadyRound=Math.max(ctx.round,u.mysteryReadyRound||1);
      actives.push(passive(u,[skills.hpRecord(u,-u.hp,false)]));
      const records=[];label(records,u,4,25);actives.push(visual(u,config.revival,records));
      summonMu(ctx,u,actives);
    }else if(ctx.round===1&&u.hp>0&&!u.kabutoStarted){u.kabutoStarted=true;summonMu(ctx,u,actives);}
  }
  for(const mu of ctx.teams.flat())if(isMu(mu)&&mu.hp>0)requests.push({mu,kind:ctx.round%2===0?'dan':'pakura'});
  return requests;
}
function beforeAction(ctx,u){
  if(!isKabuto(u)||u.hp<=0||ctx.round<(u.kabutoHealReadyRound||1)||(u.kabutoHealUses||0)>=config.healing.maxPerRound)return [];
  u.kabutoHealReadyRound=ctx.round+config.healing.cooldown;
  u.kabutoHealUses=(u.kabutoHealUses||0)+1;
  const records=[];skills.restore(u,u,u.maxHp*config.healing.hpRatio,records);
  ctx.chakraLimit=ctx.chakraLimit||[100,100];ctx.chakraLimit[u.camp]=100;
  ctx.chakra[u.camp]=Math.min(100,ctx.chakra[u.camp]+config.healing.chakra);
  label(records,u,5,40);
  return [visual(u,config.healing),passive(u,records)];
}
function selectStandard(ctx,u,move){
  if(!move||!canStandard(ctx,u)||isGuest(u))return null;
  if(cursed(u)&&move.target!=='single'&&move.target!==1&&move.target!=null)return null;
  if(move.kabutoStandard){
    const aoe=!cursed(u)&&ctx.random()<move.lineupChance;
    return {...move,target:aoe?'line':1,combo:aoe?6:1,causes:aoe?move.causes:null};
  }
  return move;
}
function targets(move,selected,opponents){
  if(move.target==='line')return [selected,...opponents.filter(v=>v!==selected&&v.hp>0&&Math.floor((v.pos-1)/5)===Math.floor((selected.pos-1)/5))];
  return null;
}
function hasPoison(u){return (u.skillBuffs||[]).some(b=>['poison','strongPoison'].includes(b.field)&&b.remaining>0);}
function prepareMove(ctx,u,target,move){
  if(move&&move.kabutoMystery&&hasPoison(target))return {...move,unavoidable:true,strongPoison:true};
  return move;
}
function dot(ctx,u,v,field,spec,records){
  if(v.hp<=0||immune(v)||skills.status(v,'invincible'))return;
  v.skillBuffs=v.skillBuffs||[];
  const old=v.skillBuffs.find(b=>b.source===u.id&&b.field===field);
  const data={kind:'dot',field,source:u.id,sourceSkill:config.mystery.id,amount:skills.value(u,'magicAtk')*spec.multiplier,
    remaining:spec.turns+1,level:2,buffId:field==='ignite'?13500022:13500020};
  if(old)Object.assign(old,data);else v.skillBuffs.push(data);
  label(records,v,field==='strongPoison'?7:field==='ignite'?8:6,spec.turns);
}
function suppress(ctx,v,turns,records){
  v.kabutoSuppressedUntil=Math.max(v.kabutoSuppressedUntil||0,ctx.round+turns-1);label(records,v,9,turns);
}
function afterHit(ctx,u,selected,victims,move,frame){
  const records=frame.targets;
  if(move.kabutoMystery){
    for(const v of victims){dot(ctx,u,v,'poison',config.poison,records);if(move.strongPoison)dot(ctx,u,v,'strongPoison',config.strongPoison,records);}
    if(victims.includes(selected)&&selected.hp>0){selected.kabutoInterruptedRound=ctx.round;label(records,selected,10);}
  }
  if(move.kabutoStandard){
    for(const v of victims)if(v.hp>0){
      if(!immune(v)){v.kabutoDefenseStacks=(v.kabutoDefenseStacks||0)+1;label(records,v,11,v.kabutoDefenseStacks*12);}
      if(move.target==='line'){v.kabutoArmorSuppressedUntil=ctx.round;label(records,v,12);}
      if(edo(v)&&!immune(v)){v.kabutoCurseUntil=ctx.round+1;label(records,v,13,2);}
    }
    const living=victims.filter(v=>v.hp>0);
    if(living.length)frame.comboTarget=living[Math.min(living.length-1,Math.floor(ctx.random()*living.length))];
  }
  if(move.kabutoChase)for(const v of victims)if(v.hp>0){
    suppress(ctx,v,1,records);v.kabutoBlindUntil=ctx.round;label(records,v,14,1);
  }
  if(move.deidara)for(const v of victims){
    if(v.hp>0){v.kabutoArmorSuppressedUntil=ctx.round;label(records,v,12);}
    else {v.noRevive=true;delete v.kabutoReviveRound;label(records,v,15);}
  }
  if(move.dan){
    for(const v of victims)if(v.hp>0)suppress(ctx,v,3,records);
    const drained=ctx.chakra[1-u.camp];ctx.chakra[1-u.camp]=0;ctx.chakra[u.camp]=Math.min(100,ctx.chakra[u.camp]+drained);
    label(records,u,16,drained);
  }
  if(move.pakura)for(const v of victims)dot(ctx,u,v,'ignite',config.ignition,records);
}
function afterAction(ctx,u,move){
  if(!move||!move.muStandard||u.hp<=0||u.kabutoDeidaraRound===ctx.round)return [];
  u.kabutoDeidaraRound=ctx.round;return [{mu:u,kind:'deidara'}];
}
function guest(ctx,mu,kind){return ctx.teams[mu.camp].find(u=>u.kabutoOwner===mu.kabutoOwner&&u.summonKind===kind);}
function useGuest(ctx,mu,kind){
  mu.kabutoGuestReady=mu.kabutoGuestReady||{};
  if(ctx.round<(mu.kabutoGuestReady[kind]||1))return false;
  mu.kabutoGuestReady[kind]=ctx.round+config.mu.summon.cooldown;
  return true;
}
function noteDeaths(ctx){
  for(const u of ctx.teams.flat()){
    if(!isKabuto(u))continue;
    if(u.hp>0){delete u.kabutoReviveBlocked;continue;}
    if(u.noRevive||u.kabutoReviveBlocked)continue;
    if(ctx.round<(u.kabutoRevivalReadyRound||1)){
      // A death during cooldown is final for this life, not a delayed resurrection.
      u.kabutoReviveBlocked=true;delete u.kabutoReviveRound;
    }else if(u.kabutoReviveRound==null)u.kabutoReviveRound=ctx.round+1;
  }
}
function pendingRevival(ctx,camp){return ctx.teams[camp].some(u=>isKabuto(u)&&u.hp<=0&&canRevive(ctx,u)&&u.kabutoReviveRound!=null);}
function protectFatal(u,amount){
  const ctx=u.kabutoContext;
  if(!ctx||!activeBarrier(ctx)||ctx.barrier.owner!==u.camp||u.hp<=0||amount<u.hp||isGuest(u))return null;
  const used=ctx.barrier.saves[ctx.round]||0;
  if(used>=config.mu.barrier.fatalProtections)return null;
  ctx.barrier.saves[ctx.round]=used+1;
  const damage=Math.max(0,u.hp-1),hp=Math.max(1,Math.round(u.maxHp*config.mu.barrier.recoverRatio));
  return {damage,recovered:hp-1};
}
module.exports={config,isKabuto,isMu,isGuest,profile,alive,suppressed,immune,cursed,blind,edo,armor,activeBarrier,canStandard,canMystery,canChase,
  label,visual,passive,resetSummon,prepare,summonMu,roundStart,beforeAction,selectStandard,targets,hasPoison,prepareMove,afterHit,afterAction,guest,useGuest,noteDeaths,pendingRevival,protectFatal};
