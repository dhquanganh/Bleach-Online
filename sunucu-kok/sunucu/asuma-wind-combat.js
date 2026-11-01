'use strict';
const config=require('./asuma-wind.json');
const isAsuma=u=>u?.id===config.heroId,profile=u=>isAsuma(u)?{...config,chases:[config.chase]}:null;
function initialize(ctx){for(const u of ctx.teams.flat()){
 Object.defineProperty(u,'asumaWindContext',{value:ctx,writable:true,configurable:true,enumerable:false});if(isAsuma(u))delete u.asumaCourageUsed;
}}
function eligible(u){return u?.hp>0&&u.maxHp>0&&u.hp>=u.maxHp&&!u.auxiliary&&!u.isSummon&&!u.cloneOwner&&!u.puppet;}
function factor(u,field){return field==='atk'&&eligible(u)&&u.asumaWindContext?.teams[u.camp]?.some(v=>isAsuma(v)&&v.hp>0)?1.3:1;}
function roundStart(ctx){const out=[];if(ctx.round!==1)return out;
 for(const u of ctx.teams.flat())if(isAsuma(u)&&u.hp>0&&!u.asumaCourageUsed){u.asumaCourageUsed=true;ctx.chakra[u.camp]=Math.min(ctx.chakraLimit?.[u.camp]??100,ctx.chakra[u.camp]+20);out.push(require('./pain-combat').visual(u,config.courage));for(const ally of ctx.teams[u.camp])if(eligible(ally))require('./buff-notices').touch(ally,'atk');}
 return out;
}
function targets(ctx,u,move,target,enemies){if(!isAsuma(u)||!move?.asumaMove)return null;const alive=enemies.filter(v=>v.hp>0);
 if(move.asumaMove==='standard'){const front=Math.min(...alive.map(v=>Math.floor((v.pos-1)/5)));return alive.filter(v=>Math.floor((v.pos-1)/5)===front).sort((a,b)=>a.pos-b.pos).slice(0,3);}
 return [target,...alive.filter(v=>v!==target)].filter(v=>v?.hp>0).slice(0,move.target||1);
}
function afterHit(ctx,u,selected,hit,move,frame){if(!isAsuma(u)||move?.asumaMove!=='chase'||!hit.includes(selected)||selected.hp<=0)return;
 require('./hero-skills').apply({id:move.id,effects:[{kind:'buff',scope:'t',field:'disarm',value:1,turns:1}]},u,[u],[],[selected],frame.targets,ctx.random);
}
module.exports={config,isAsuma,profile,initialize,eligible,factor,roundStart,targets,afterHit};
