'use strict';
const config=require('./nagato-frog.json'),{CMD,ST}=require('./kodek');
const isNagato=u=>u?.id===config.heroId;
const profile=u=>isNagato(u)?config:null;
const frog=u=>isNagato(u)||u?.frogSquad===true||u?.naruto?.frogSquad===true;
function initialize(ctx){for(const u of ctx.teams.flat()){delete u.nagatoGrowth;delete u.nagatoLeadRound;}}
function beforeAction(ctx,u){
  if(!isNagato(u)||u.hp<=0||u.nagatoLeadRound===ctx.round)return;
  u.nagatoLeadRound=ctx.round;
  u.mysteryReadyRound=Math.max(ctx.round,(u.mysteryReadyRound||1)-1);
}
function prepareMove(ctx,u,target,move){
  if(!isNagato(u)||!move)return move;
  if(move.nagatoStandard){const roll=ctx.random(),combo=roll<config.standardComboChance;return {...move,id:combo?13121407:roll<.65?13121406:13121402,combo:combo?4:1,causes:combo?'lowFloat':null};}
  if(move.nagatoMystery&&target?.shield>0)return {...move,target:'all',causes:null,nagatoStrip:true};
  return move;
}
function afterHit(ctx,u,selected,hit,move,frame){
  if(!isNagato(u)||!move.nagatoStrip)return;
  const skills=require('./hero-skills');
  for(const t of hit){skills.remove(t,false,frame.targets);skills.removeField(t,'reflect',frame.targets);if(t.shield>0){t.shield=0;frame.targets.push({cmd:CMD.SHIELD,targetCamp:t.camp,targetPos:t.pos,reportTargetStatus:ST.HIT>>>0,result:{buffId:0,buffTurn:0}});}}
}
function onChase(ctx,u){
  if(!frog(u))return;
  // The aura belongs to the lineup and persists after its owner is defeated.
  const owners=ctx.teams[u.camp].filter(isNagato).length;
  u.nagatoGrowth=(u.nagatoGrowth||0)+owners;
}
function factor(u,field){return field==='atk'?1+config.cooperationGrowth*(u.nagatoGrowth||0):1;}
module.exports={config,isNagato,profile,frog,initialize,beforeAction,prepareMove,afterHit,onChase,factor};
