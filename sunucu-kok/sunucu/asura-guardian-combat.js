'use strict';
const config=require('./asura-guardian.json'),skills=require('./hero-skills'),pain=require('./pain-combat');
const isAsura=u=>u?.id===config.heroId;
const active=(u,k)=>Number.isFinite(u?.[k])&&u[k]>=(u.battleRound||1);
const living=(ctx,camp)=>ctx.teams[camp].filter(v=>v.hp>0&&!v.auxiliary);
function profile(u){return isAsura(u)?{...config,mystery:u.asuraTargetAlly?config.protection:config.mystery,chases:[u.hp<u.maxHp*.6?config.modified:config.chase]}:null;}
function initialize(ctx){ctx.asuraQueue=[];ctx.asuraBarriers=[];for(const u of ctx.teams.flat()){
 for(const k of Object.keys(u))if(k.startsWith('asura')&&k!=='asuraTargetAlly')delete u[k];
 Object.defineProperty(u,'asuraContext',{value:ctx,writable:true,configurable:true,enumerable:false});
 if(isAsura(u)){u.asuraAttack=0;u.asuraEvadeCrit=0;u.asuraHealBonus=0;u.asuraAllyReviveReady=1;u.asuraBaseAtk=u.atk;}
}}
function reset(ctx,u){if(u.asuraRound!==ctx.round){u.asuraRound=ctx.round;u.asuraMysteryHeals=0;u.asuraChaseBuffs=0;u.asuraEvadeBuffs=0;}}
function factor(u,f){if(!isAsura(u))return 1;if(f==='atk')return (1+.12*(u.asuraAttack||0))*(1+(active(u,'asuraExplosiveUntil')?.08*(u.asuraDamageStacks||0):0));if(f==='def'&&active(u,'asuraExplosiveUntil'))return 1+.05*(u.asuraDamageStacks||0);return 1;}
function critical(u){return (u.asuraTeamCrit||0)+(isAsura(u)?.06*(u.asuraEvadeCrit||0):0);}
function immune(u){return isAsura(u)&&(u.battleRound||1)<=config.immunityRounds||active(u,'asuraBanishedUntil');}
function barrier(u){return !!u?.asuraContext?.asuraBarriers?.some(b=>b.camp===u.camp&&b.until>=(u.battleRound||1));}
function blocksKey(u,key){return barrier(u)&&/ignition|acupuncture|discourage|tension|fear|horror/i.test(key);}
function immuneStatus(u,field){return barrier(u)&&['ignite','ignition','acupuncture','silence','discouragement','tension','fear'].includes(field);}
function dragon(ctx,u){const records=[];for(const v of ctx.teams[u.camp])if(v.hp>0){require('./tsunade-combat').cleanseAll(v,records);skills.restore(u,v,u.asuraBaseAtk*.25,records);}u.asuraHealBonus=.25;return {...pain.visual(u,config.dragon),targets:records};}
function battleStart(ctx){return ctx.teams.flat().filter(u=>isAsura(u)&&u.hp>0).map(u=>{for(const field of ['invincible','advancedImmunity'])require('./buff-notices').touch(u,field);return dragon(ctx,u);});}
function noteDeaths(ctx){for(const u of ctx.teams.flat())if(isAsura(u)&&u.hp<=0&&!u.noRevive&&!u.itachiUnrevivable&&!u.asuraReviveRound)u.asuraReviveRound=ctx.round+config.revivalDelayRounds;}
function restoreUnit(ctx,u,amount){u.hp=Math.max(1,Math.round(u.maxHp*amount));u.asuraReviveRound=0;require('./tsunade-combat').cleanseAll(u,[]);delete u.guyPendingDeath;delete u.asuraBanishedUntil;ctx.primaryActions.set(u,ctx.round);return skills.hpRecord(u,-u.hp,false);}
function revivals(ctx){const out=[];for(const u of ctx.teams.flat())if(isAsura(u)&&u.hp>0&&ctx.round>=u.asuraAllyReviveReady){
 const candidates=ctx.teams[u.camp].filter(v=>v!==u&&!v.auxiliary&&v.hp<=0&&!v.noRevive&&!v.itachiUnrevivable);
 if(!candidates.length)continue;const target=candidates[Math.min(candidates.length-1,Math.floor(ctx.random()*candidates.length))];u.asuraAllyReviveReady=ctx.round+config.allyReviveCooldown;
 out.push({unit:target,records:[restoreUnit(ctx,target,1),banishRecord(target,false)],animation:config.revive});
 }return out;}
function roundStart(ctx){const out=[];ctx.asuraBarriers=ctx.asuraBarriers.filter(b=>b.until>=ctx.round);for(const u of ctx.teams.flat()){
 if(active(u,'asuraCooldownLockUntil'))u.mysteryReadyRound=Math.max(u.mysteryReadyRound||0,ctx.round+2);
 if(!isAsura(u))continue;reset(ctx,u);u.asuraDamageStacks=0;
 if(u.hp<=0&&u.asuraReviveRound&&ctx.round>=u.asuraReviveRound&&living(ctx,u.camp).length&&!u.noRevive&&!u.itachiUnrevivable){const r=restoreUnit(ctx,u,.4);u.asuraReviveRound=0;out.push(pain.passive(u,[r,banishRecord(u,false)]),pain.visual(u,config.revive),dragon(ctx,u));}
 }return out;}
function targets(ctx,u,move,selected,enemies){if(!move?.asuraMove)return null;const alive=enemies.filter(v=>v.hp>0&&!active(v,'asuraBanishedUntil'));if(move.asuraMove.startsWith('standard')){
 const target=alive.slice().sort((a,b)=>a.hp-b.hp||a.pos-b.pos)[0];if(!target)return [];return ctx.random()<.5?alive.filter(v=>(v.pos-1)%5===(target.pos-1)%5):[target];}
 if(move.asuraMove==='modified')return [selected||alive[0]].filter(v=>v?.hp>0);
 return alive;}
function selectStandard(ctx,u,move){return isAsura(u)?[config.standard,config.standard2,config.standard3][Math.min(2,Math.floor(ctx.random()*3))]:move;}
function beforeMove(ctx,u,move,selected){if(!move?.asuraMove)return move;if(move.prompt&&selected?.camp===u.camp)return {...config.protection};return move;}
function observe(ctx,actor,move){if(!move)return;for(const u of ctx.teams[actor.camp])if(isAsura(u)&&u.hp>0){reset(ctx,u);if(move.prompt&&u.asuraMysteryHeals<8){u.asuraMysteryHeals++;const r=[];skills.restore(u,u,u.maxHp*.06,r);if(r.length)ctx.asuraQueue.push({frame:pain.passive(u,r)});}if(move.chase&&u.asuraChaseBuffs<8){u.asuraChaseBuffs++;u.asuraAttack++;}}}
function evaded(ctx,u){if(!ctx)return;for(const owner of ctx.teams[u.camp])if(isAsura(owner)&&owner.hp>0){reset(ctx,owner);if(owner.asuraEvadeBuffs<8){owner.asuraEvadeBuffs++;owner.asuraEvadeCrit++;}}}
function onDamage(ctx,source,result){if(isAsura(source)&&active(source,'asuraExplosiveUntil')&&result.damage>0)source.asuraDamageStacks=(source.asuraDamageStacks||0)+1;}
function pureProtection(u,move){if(!active(u,'asuraProtectionUntil')||!(move?.pureTaijutsu||move?.damageType==='physical'))return false;u.asuraPureHits=(u.asuraPureHits||0)+1;return u.asuraPureHits<=5;}
function afterHit(ctx,u,selected,hit,move,frame){observe(ctx,u,move);if(!move?.asuraMove)return;const kind=move.asuraMove;
 if(move.prompt){u.asuraExplosiveUntil=ctx.round;u.asuraDamageStacks=0;ctx.asuraBarriers.push({camp:u.camp,until:ctx.round});for(const v of ctx.teams[u.camp]){v.asuraTeamCrit=(v.asuraTeamCrit||0)+.2;for(const key of Object.keys(v))if(blocksKey(v,key)&&key.endsWith('Until'))delete v[key];for(const field of ['ignite','ignition','acupuncture','silence','discouragement','tension','fear'])skills.removeField(v,field,frame.targets);}ctx.asuraQueue.push({unit:u,move:config.barrier});}
 if(kind==='mystery'){for(const v of hit)if(v.hp>0)v.armorSuppressedUntil=ctx.round+1;if(selected?.hp>0){selected.asuraCooldownLockUntil=ctx.round+1;selected.mysteryReadyRound=ctx.round+2;}}
 if(kind.startsWith('standard'))for(const v of hit)if(v.hp<=0)v.noRevive=true;
 if(['chase','modified'].includes(kind)){const amount=ctx.chakra[1-u.camp];ctx.chakra[1-u.camp]=0;ctx.chakra[u.camp]=Math.min(ctx.chakraLimit[u.camp],ctx.chakra[u.camp]+amount);
 if(kind==='modified'){if(selected?.hp>0){selected.asuraBanishedUntil=ctx.round;frame.reactions.push(pain.passive(selected,[banishRecord(selected,true)]));}u.mysteryReadyRound=ctx.round;u.asuraZeroCooldownUntil=ctx.round;}else u.mysteryReadyRound=Math.max(ctx.round,(u.mysteryReadyRound||ctx.round)-1);
 }
 if(kind==='protection'){ctx.chakraLimit[u.camp]=100;ctx.chakra[u.camp]=Math.min(100,ctx.chakra[u.camp]+20);for(const v of ctx.teams[u.camp]){v.asuraProtectionUntil=ctx.round;v.asuraPureHits=0;}}
}
function banishRecord(u,hidden){return {cmd:9,targetCamp:u.camp,targetPos:u.pos,reportTargetStatus:33554432,result:{buffId:19002101,buffTurn:hidden?1:0}};}
function endRound(ctx){const out=[];for(const u of ctx.teams.flat())if(active(u,'asuraBanishedUntil')){delete u.asuraBanishedUntil;out.push(pain.passive(u,[banishRecord(u,false)]));}return out;}
function triggers(ctx){return ctx.asuraQueue.splice(0);}
module.exports={config,isAsura,active,profile,initialize,reset,factor,critical,immune,barrier,blocksKey,immuneStatus,dragon,battleStart,noteDeaths,revivals,roundStart,targets,selectStandard,beforeMove,observe,evaded,onDamage,pureProtection,afterHit,endRound,triggers};
