'use strict';
const assert=require('node:assert/strict');
const n=require('../naruto-combat'),h=require('../hashirama-combat'),p=require('../pain-combat'),o=require('../obito-combat');
const battle=require('../savas'),codec=require('../kodek');
const unit=(id,pos,camp=0)=>({id,pos,camp,hp:100000,maxHp:100000,atk:1000,magicAtk:1,def:100,resistance:100,speed:100,hitRate:1,critRate:0,anger:0,level:99,normal:13100114,skill:0,skillId:13100114,partnerSkills:[],weaponSkills:[]});
function start(ctx,round){n.startRound(ctx,round);h.roundStart(ctx);p.roundStart(ctx);o.roundStart(ctx);ctx.chakra=[100,100];}
for(const camp of [0,1]){
  // A standard is independent of a prompt Mystery, including points gained by that standard.
  for(const hero of [h.config,p.config,o.config]){
    const u=unit(hero.heroId,6,camp),enemy=unit(12101003,1,1-camp),teams=[[],[]];
    teams[camp]=[u];teams[1-camp]=[enemy];const ctx=n.create(teams);start(ctx,1);
    assert(n.useStandard(ctx,u,teams[camp]));
    if(p.isPain(u))p.points(u,1);
    const chakra=ctx.chakra[camp];ctx.chakra[camp]=0;
    if(hero.mystery.chakraCost)assert.equal(n.useMystery(ctx,u),null);
    ctx.chakra[camp]=chakra;assert.equal(n.useMystery(ctx,u).id,hero.mystery.id);
    assert.equal(n.useMystery(ctx,u),null,'Reactive casts must retain recovery');
  }
  // Base -> four damage events -> Burst cast in the same round. Each form only once.
  {
    const u=unit(h.config.heroId,6,camp),enemy=unit(12101003,1,1-camp),teams=[[],[]];
    teams[camp]=[u];teams[1-camp]=[enemy];const ctx=n.create(teams);start(ctx,1);
    assert.equal(n.useMystery(ctx,u).id,h.config.mystery.id);
    for(let i=0;i<4;i++)h.onDamage(ctx,enemy,u,{damage:100},null,[],[]);
    assert(h.burst(u));assert.equal(n.useMystery(ctx,u).id,h.config.burstMystery.id);
    // Even unlimited passive reductions cannot produce repeated cinematics in a round.
    u.mysteryReadyRound=1;assert.equal(n.useMystery(ctx,u),null);
    delete u.hashBurstUntil;assert.equal(n.useMystery(ctx,u),null);
  }
  // Final Pain can receive the points for his second cast later in the round.
  {
    const u=unit(p.config.heroId,6,camp),enemy=unit(12101003,1,1-camp),teams=[[],[]];
    teams[camp]=[u];teams[1-camp]=[enemy];const ctx=n.create(teams);start(ctx,1);
    u.painFinal=true;p.points(u,2);assert.equal(n.useMystery(ctx,u).id,p.config.finalMystery.id);
    assert.equal(n.useMystery(ctx,u),null);p.points(u,2);
    assert.equal(n.useMystery(ctx,u).id,p.config.finalMystery.id);p.points(u,5);
    assert.equal(n.useMystery(ctx,u),null,'Final Pain still has only two casts per round');
  }
  // Inspect actual encoded AI output, rather than manually invoking the unlocked skill.
  for(const [id,atk] of [[h.config.heroId,1000],[p.config.heroId,5500],[o.config.heroId,1000]]){
    const own=unit(id,6,camp);own.maxHp=own.hp=id===h.config.heroId?1000000:100000;
    const enemy=Array.from({length:id===h.config.heroId?15:5},(_,i)=>({...unit(12101003,i+1,1-camp),atk}));
    const result=battle.kadroRapor(0,null,{ad:'Reactive Mystery regression',birimler:camp?[own]:enemy},{playerUnits:camp?enemy:[own],playerState:{},forceWin:false,scaleEnemy:false,random:()=>.5});
    const report=codec.decodeBattleReport(result.payload);assert.equal(report._consumed,report._total);
    const actions=report.turns.flatMap(t=>t.actives).filter(a=>a.activeCamp===camp&&a.activePos===6);
    if(id===h.config.heroId){
      assert(actions.some(a=>a.skillEffectId===h.config.burstMystery.id),'AI must use the giant Buddha Mystery');
      for(const t of report.turns){
        const casts=t.actives.filter(a=>a.activeCamp===camp&&a.activePos===6&&[h.config.mystery.id,h.config.burstMystery.id].includes(a.skillEffectId));
        assert.equal(new Set(casts.map(a=>a.skillEffectId)).size,casts.length);assert(casts.length<=2);
      }
    }else if(id===p.config.heroId){
      assert(report.turns.some(t=>{
        const acts=t.actives.filter(a=>a.activeCamp===camp&&a.activePos===6).map(a=>a.skillEffectId);
        return acts.indexOf(p.config.standard.id)>=0&&acts.indexOf(p.config.extremeMystery.id)>acts.indexOf(p.config.standard.id);
      }),'AI must cast Extreme after a standard/HP change in the same round');
    }else{
      for(const move of [o.config.transformation,o.config.rageMystery,o.config.rageStandard])assert(actions.some(a=>a.skillEffectId===move.id));
      let last=-Infinity;
      for(const t of report.turns)for(const a of t.actives)if(a.activeCamp===camp&&a.activePos===6&&a.skillEffectId===o.config.rageMystery.id){assert(t.curTurn-last>=o.config.rageMystery.cooldown);last=t.curTurn;}
    }
  }
}
console.log('PASS reactive Mysteries: both camps, post-standard prompts, real Hashirama Burst and Pain Extreme scheduling, delayed Final points, Obito Rage, preserved costs/recovery and bounded casts.');
