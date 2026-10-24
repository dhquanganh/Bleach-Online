'use strict';
const config=require('./jiraiya-toads.json');
const skills=require('./hero-skills');
const {CMD,ST}=require('./kodek');
const isJiraiya=u=>u.id===config.heroId;
const eligibleSage=u=>isJiraiya(u)||u.id===11120901||!!(u.naruto&&u.naruto.senjutsu)||u.senjutsu;
function label(records,u,index,count=0){records.push({cmd:CMD.FLOAT,targetCamp:u.camp,targetPos:u.pos,reportTargetStatus:ST.HIT>>>0,result:{buffId:19000300+index,buffTurn:count}});}
function visual(u,move,records=[]){return {activeCamp:u.camp,activePos:u.pos,skillEffectId:move.id,activeType:1,
  targets:[{cmd:CMD.NONE,targetCamp:u.camp,targetPos:u.pos,reportTargetStatus:0,result:{}},...records]};}
function activeBarrier(ctx){return ctx.barrier&&ctx.barrier.kind!=='lightweight'&&ctx.round<=ctx.barrier.until;}
function blocksMystery(ctx,u,m){return activeBarrier(ctx)&&!!(m&&m.barrier||u.createsBarrier||u.destroysBarrier);}
function roundStart(ctx){
  ctx.chaseBonus=[0,0];ctx.chakraLimit=ctx.chakraLimit||[100,100];
  const frames=[];
  if(ctx.barrier&&ctx.barrier.kind!=='lightweight'&&ctx.round>ctx.barrier.until){ctx.barrier=null;ctx.barrierExpired=true;}
  for(const team of ctx.teams)for(const u of team){
    if(!isJiraiya(u)||u.hp<=0)continue;
    ctx.chakraLimit[u.camp]=100;
    const records=[];
    for(const ally of team){
      if(ally.hp<=0)continue;
      ally.jiraiyaInitiative=Math.min(.1,(ally.jiraiyaInitiative||0)+.02);
      ally.skillBuffs=(ally.skillBuffs||[]).filter(b=>b.sourceSkill!==config.power.id||b.field!=='speed');
      ally.skillBuffs.push({source:u.id,sourceSkill:config.power.id,field:'speed',kind:'buff',value:ally.jiraiyaInitiative,remaining:100});
    }
    const sages=[u,...team.filter(a=>a!==u&&a.hp>0&&eligibleSage(a)).sort((a,b)=>a.pos-b.pos)].slice(0,3);
    for(const sage of sages){
      skills.remove(sage,true,records);
      for(const field of ['immobileUntil','extremeChaosUntil','suppressedUntil','jiraiyaResistanceStacks'])delete sage[field];
      sage.paralyzed=false;
      require('./tsunade-combat').gainChakra(ctx,u,20);
    }
    label(records,u,4,Math.round(u.jiraiyaInitiative*100));
    frames.push(visual(u,config.power,records));
  }
  if(ctx.barrierExpired&&frames.length){label(frames[0].targets,ctx.teams.flat().find(u=>u.hp>0),9);ctx.barrierExpired=false;}
  return frames;
}
function afterHit(ctx,u,victims,move,records){
  if(move.resistanceDown)for(const v of victims){
    if(v.hp<=0||skills.status(v,'immuneDebuffs'))continue;
    v.jiraiyaResistanceStacks=(v.jiraiyaResistanceStacks||0)+1;
    label(records,v,6,v.jiraiyaResistanceStacks*10);
  }
  if(move.extremeChaos)for(const v of victims){
    if(v.hp<=0 || v.toadChantProtectedUntil>=ctx.round)continue;
    v.suppressedUntil=ctx.round;
    v.extremeChaosUntil=ctx.round;
    v.toadChantProtectedUntil=ctx.round+1;
    label(records,v,2);label(records,v,3);
  }
  if(move.grantChase&&!ctx.chaseBonus[u.camp]){
    ctx.chaseBonus[u.camp]=1;label(records,u,8,1);
  }
}
function mysteryUsed(ctx,u,move){
  if(!ctx.mysteryCounts)ctx.mysteryCounts=[0,0];
  ctx.mysteryCounts[u.camp]++;
  if(isJiraiya(u)&&move.barrier){
    ctx.barrier={owner:u.camp,source:u.id,until:ctx.round+1};
    return config.additional;
  }
  return null;
}
function noteDeaths(ctx){
  if(!ctx.mysteryCounts)ctx.mysteryCounts=[0,0];
  for(const u of ctx.teams.flat())if(isJiraiya(u)){
    if(u.hp<=0&&u.jiraiyaDeathCount==null)u.jiraiyaDeathCount=ctx.mysteryCounts[u.camp];
    if(u.hp>0)delete u.jiraiyaDeathCount;
  }
}
function revivals(ctx){
  const revived=[];
  for(const u of ctx.teams.flat())if(isJiraiya(u)&&!u.noRevive&&u.hp<=0&&u.jiraiyaDeathCount!=null&&
      ctx.mysteryCounts[u.camp]-u.jiraiyaDeathCount>=3){
    u.hp=Math.max(1,Math.round(u.maxHp*.3));
    // Revival preserves all cooldowns and cannot grant another action this round.
    u.mysteryReadyRound=Math.max(ctx.round+1,u.mysteryReadyRound||1);
    ctx.primaryActions.set(u,ctx.round);
    delete u.jiraiyaDeathCount;
    revived.push({unit:u,record:skills.hpRecord(u,-u.hp,false)});
  }
  return revived;
}
module.exports={config,isJiraiya,eligibleSage,label,visual,activeBarrier,blocksMystery,roundStart,afterHit,mysteryUsed,noteDeaths,revivals};
