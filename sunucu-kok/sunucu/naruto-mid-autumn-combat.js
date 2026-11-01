'use strict';
const config=require('./naruto-mid-autumn.json'),skills=require('./hero-skills'),pain=require('./pain-combat');
const isNaruto=u=>u?.id===config.heroId,active=u=>(u?.festivalExcitedUntil||0)>=(u?.battleRound||1);
function profile(u){return isNaruto(u)?{...config,chases:[u.hp>u.maxHp*.6?config.modified:config.chase]}:null;}
function initialize(ctx){ctx.festivalQueue=[];ctx.festivalFrames=new WeakSet();for(const u of ctx.teams.flat()){delete u.festivalExcitedUntil;delete u.festivalBuffRound;if(isNaruto(u))u.festivalAttack=0;}}
function factor(u,f){return (isNaruto(u)&&f==='atk'?1+.04*(u.festivalAttack||0):1)*(active(u)?f==='atk'?1.6:['def','resistance'].includes(f)?.7:1:1);}
function roundStart(ctx){const out=[];for(const u of ctx.teams.flat())if(isNaruto(u)&&u.hp>0&&u.festivalBuffRound!==ctx.round){u.festivalBuffRound=ctx.round;const allies=ctx.teams[u.camp].filter(v=>v.hp>0&&!v.auxiliary&&!v.isSummon&&!v.cloneOwner&&!v.puppet),target=allies[Math.floor(ctx.random()*allies.length)];if(!target)continue;target.festivalExcitedUntil=ctx.round;const visual=pain.visual(u,config.shower);if(target!==u)visual.targets.push({cmd:0,targetCamp:target.camp,targetPos:target.pos,reportTargetStatus:0,result:{}});out.push(visual);require('./buff-notices').touch(target,'excited');require('./buff-notices').touch(target,'punchRate');for(const v of ctx.teams[u.camp])if(v.hp>0&&(v.auxiliary||v.isSummon||v.cloneOwner||v.puppet)){ctx.festivalQueue.push({unit:v,standardAction:true,granted:true});require('./buff-notices').touch(v,'extraStandard');}}return out;}
function punch(u){return active(u)?.7:0;}
function combo(ctx,u,move,count){return active(u)&&!move.prompt&&!move.trigger&&ctx.random()<.7?Math.max(5,count):count;}
function selectStandard(ctx,u,move){if(!isNaruto(u))return move;return [config.standard,config.standard2,config.standard3][Math.floor(ctx.random()*3)];}
function afterAction(ctx,u,move,frame){if(!ctx||!isNaruto(u)||!move||!['standard','standard2','standard3'].includes(move.festivalMove)||ctx.festivalFrames.has(frame))return;ctx.festivalFrames.add(frame);u.festivalAttack=(u.festivalAttack||0)+1;require('./buff-notices').touch(u,'atk');}
function targets(ctx,u,move,target,enemies){if(!move?.festivalMove||!isNaruto(u))return null;const alive=enemies.filter(v=>v.hp>0);if(move.festivalMove==='mystery')return alive;if(move.festivalMove.startsWith('standard')){const n=2+Math.floor(ctx.random()*3);return [target,...alive.filter(v=>v!==target)].filter(v=>v?.hp>0).slice(0,n);}return [target,...alive.filter(v=>v!==target)].filter(v=>v?.hp>0).slice(0,move.target||1);}
function triggers(ctx){return ctx.festivalQueue.splice(0);}
module.exports={config,isNaruto,active,profile,initialize,factor,roundStart,punch,combo,selectStandard,afterAction,targets,triggers};
