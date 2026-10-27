'use strict';
const assert=require('node:assert/strict');
const battle=require('../savas'),codec=require('../kodek'),k=require('../kakuzu-edo-combat');

// Use the actual Cross normalization and encoded report, not fabricated HP
// changes: this matchup kills and revives Kakuzu and an ordinary ally repeatedly.
for(const camp of [0,1]){
  // Hashirama remains alive through the four-round delay. A wiped lineup must
  // not be kept in the match just to satisfy this resurrection fixture.
  const rescued=[11120997,11100001,11120940].map((id,i)=>({id,pos:1+i*5}));
  const opponents=[11120997,11120920,11120940].map((id,i)=>({id,pos:1+i*5}));
  const report=codec.decodeBattleReport(battle.kadroRapor(0,{name:'Cross revival regression',level:159,units:camp?rescued:opponents},null,{
    playerUnits:camp?opponents:rescued,playerState:{},crossServerBaseOnly:true,scaleEnemy:false,forceWin:false,random:()=>.5
  }).payload);
  assert.equal(report._consumed,report._total);
  const actors=new Map();
  [report.player1,report.player2].forEach((side,c)=>side.roles.forEach(r=>actors.set(`${c}:${r.pos}`,{...r,hp:r.curHealth})));
  const events=report.turns.flatMap(t=>t.actives.map(e=>({...e,round:t.curTurn})));
  let self=0,allies=0;
  for(let i=0;i<events.length;i++){
    const event=events[i],caster=actors.get(`${event.activeCamp}:${event.activePos}`);
    assert(caster,'every actor remains registered after death');
    if(event.skillEffectId===k.config.reincarnation.id){
      const previous=events[i-1];
      assert.equal(previous.activeType,4,'HP event must bypass the client dead-caster ActivePlay guard');
      assert.equal(previous.skillEffectId,0);
      assert(previous.targets.some(t=>t.targetCamp===event.activeCamp&&t.targetPos===event.activePos&&t.result.hurtHp===-Math.round(caster.totalHealth*.25)));
      assert(caster.hp>0,'Kakuzu is visible/alive before his revive animation can execute');
      assert(Number.isInteger(caster.lastDeathRound),'revival must follow an actual defeat');
      assert.equal(event.round-caster.lastDeathRound,4,'Kakuzu must wait four complete round transitions after defeat');
      assert(!event.targets.some(t=>t.result.hurtHp<0),'revive animation cannot apply the HP twice');
      self++;
    }
    if(event.skillEffectId===k.config.reattachment.id){
      assert.equal(caster.roleId,k.config.summonId,'only the Water Clone owns Reattachment');
      assert(caster.hp>0,'dead clone cannot cast');
      const owner=actors.get(`${event.activeCamp}:1`);
      assert.equal(owner.roleId,k.config.heroId);assert(owner.hp>0,'clone cannot revive allies while Kakuzu is dead');
      for(const target of event.targets){
        const ally=actors.get(`${target.targetCamp}:${target.targetPos}`);
        assert(ally);assert.equal(ally.hp,0,'Reattachment selects a defeated ally');
        assert.equal(target.result.hurtHp,-Math.round(ally.totalHealth*.3));
        if(ally.roleId===11100001)allies++;
      }
    }
    for(const target of event.targets){
      const actor=actors.get(`${target.targetCamp}:${target.targetPos}`);assert(actor);
      if(target.cmd===codec.CMD.ATTACK||target.cmd===codec.CMD.ATTACKEX||target.cmd===codec.CMD.HURTBUFF){
        const previousHp=actor.hp;
        actor.hp=Math.max(0,Math.min(actor.totalHealth,actor.hp-(target.result.hurtHp||0)));
        if(target.reportTargetStatus&codec.ST.DIED)actor.hp=0;
        if(previousHp>0&&actor.hp<=0)actor.lastDeathRound=event.round;
      }
    }
  }
  assert(self>1,'fixture must exercise repeated self reincarnation');
  assert(allies>0,'fixture must rescue the ordinary hero previously left invisible');
  assert(report.turns.length>3,'battle continues after revivals');
}
console.log('PASS Cross both camps: four-round self revival, living-owner ally rescue, HP-before-animation and addressable actors.');
