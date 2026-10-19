'use strict';
const assert=require('node:assert/strict'),n=require('../naruto-combat'),h=require('../hashirama-combat'),p=require('../pain-combat'),o=require('../obito-combat'),{CMD,ST}=require('../kodek');
const unit=(id,camp=0)=>({id,camp,pos:1,hp:100000,maxHp:100000,atk:1000,def:0,resistance:0,speed:100,level:99});
const expectedMysteries=new Map([[13120951,2],[13120952,3],[13120971,2],[13120972,3],[13120973,2],[13121001,3],[13121002,2]]);
function check(v){
 if(Array.isArray(v))return v.forEach(check);
 if(!v||typeof v!=='object')return;
 if(v.id){if(v.prompt)assert.equal(v.cooldown,expectedMysteries.get(v.id));else assert.equal(v.cooldown,0,`Non-Mystery ${v.id} must have zero cooldown`);}
 Object.values(v).forEach(check);
}
[h.config,p.config,o.config].forEach(check);
for(const camp of [0,1]){
 for(const config of [h.config,p.config,o.config]){
  const u=unit(config.heroId,camp),enemy=unit(12101003,1-camp),teams=[[],[]];teams[camp]=[u];teams[1-camp]=[enemy];const ctx=n.create(teams);
  const hit=()=>({targets:[{cmd:CMD.ATTACK,targetCamp:enemy.camp,targetPos:enemy.pos,reportTargetStatus:ST.HIT,result:{hurtHp:1}}],reactions:[]});
  for(let round=1;round<=3;round++){
   n.startRound(ctx,round);h.roundStart(ctx);p.roundStart(ctx);o.roundStart(ctx);
   assert(n.useStandard(ctx,u,teams[camp]));assert.equal(ctx.skillReady.get(u)?.get('standard'),undefined,'Zero-cooldown standards must not write a cooldown deadline');
   const spec={combo:20,causes:p.isPain(u)?'repulse':'lowFloat'};
   const first=n.resolve(ctx,u,enemy,hit(),spec,hit);
   assert(first.length>0,'Chase must be available on every consecutive round');
   let extra=n.resolve(ctx,u,enemy,hit(),spec,hit);
   assert.equal(extra.length,0,'Base-form per-round Chase budget must still apply');
  }
 }
 // Automatic Rage Kamui and Laser activate every round, with no double firing.
 {
  const pain=unit(p.config.heroId,camp),obito={...unit(o.config.heroId,camp),pos:2,obitoRage:true},enemy=unit(12101003,1-camp),teams=[[],[]];teams[camp]=[pain,obito];teams[1-camp]=[enemy];let ctx=n.create(teams);
  for(let round=1;round<=3;round++){
   n.startRound(ctx,round);assert.equal(p.roundStart(ctx).length,1);
   p.afterHit(ctx,pain,enemy,[],p.config.laser,{targets:[],reactions:[]});assert.equal(p.roundStart(ctx).length,0);
   assert(o.roundStart(ctx).some(a=>a.skillEffectId===o.config.mystery.id));assert.equal(o.roundStart(ctx).length,0);
  }
  ctx=n.create(teams);n.startRound(ctx,1);
  assert.equal(p.roundStart(ctx).length,1);assert(o.roundStart(ctx).some(a=>a.skillEffectId===o.config.mystery.id),'A fresh battle must not retain an old trigger-round marker');
 }
 // Mystery cooldowns remain real even though non-Mystery skills have no gap.
 for(const config of [h.config,p.config,o.config]){
  const u=unit(config.heroId,camp),teams=[[],[]];teams[camp]=[u];const ctx=n.create(teams);n.startRound(ctx,1);h.roundStart(ctx);p.roundStart(ctx);ctx.chakra[camp]=100;p.points(u,5);
  assert.equal(n.useMystery(ctx,u).id,config.mystery.id);assert.equal(n.useMystery(ctx,u),null);
  n.startRound(ctx,2);h.roundStart(ctx);p.roundStart(ctx);assert(!n.canMystery(ctx,u));
 }
}
console.log('PASS zero non-Mystery cooldowns: all three heroes/both camps, consecutive-round Chases, bounded triggers, fresh battles and preserved seven Mystery cooldowns.');
