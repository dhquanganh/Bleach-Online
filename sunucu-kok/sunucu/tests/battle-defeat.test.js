'use strict';
const assert=require('node:assert/strict');
const battle=require('../savas'),codec=require('../kodek'),k=require('../kakuzu-edo-combat');

const unit=(id,pos,camp)=>({id,pos,camp,hp:10000,maxHp:10000,atk:100,magicAtk:100,def:100,resistance:100,speed:100,hitRate:1,critRate:0,anger:0,level:99,normal:13100114,skill:0,skillId:13100114,partnerSkills:[],weaponSkills:[]});
for(const camp of [0,1])for(const delayed of [true,false])for(const required of [true,false]){
  const victim=unit(delayed?k.config.heroId:11100001,1,camp),killer=unit(12101003,1,1-camp);
  victim.hp=10;victim.speed=1;
  killer.hp=killer.maxHp=1e9;killer.atk=1e9;killer.def=1e6;killer.speed=10000;
  const team=[victim];
  if(!delayed)team.push({...unit(11120998,2,camp),auxiliary:true,hp:1e9,maxHp:1e9});
    const result=battle.kadroRapor(0,null,{ad:'Wiped lineup regression',birimler:camp?team:[killer]},{
      playerUnits:camp?[killer]:team,playerState:{},scaleEnemy:false,forceWin:false,requireEnemyDefeated:required,random:()=>.5
    });
    const report=codec.decodeBattleReport(result.payload);
    assert.equal(report._consumed,report._total);
    assert.equal(result.won,camp===1,'a living summon cannot turn a wiped lineup into a win');
    assert.deepEqual(report.turns.map(t=>t.curTurn),[1],'do not advance to delayed revival or keep attacking summons alone');
    const events=report.turns.flatMap(t=>t.actives);
    assert(!events.some(e=>e.skillEffectId===k.config.reincarnation.id),'scheduled resurrection cannot reopen a finished battle');
    const finalHit=events.findIndex(e=>e.targets.some(t=>t.targetCamp===camp&&t.targetPos===1&&(t.reportTargetStatus&codec.ST.DIED)));
    assert(finalHit>=0,'fixture must actually kill the final lineup hero');
    assert(!events.slice(finalHit+1).some(e=>e.targets.some(t=>t.targetCamp===camp&&t.result.hurtHp>0)),'no more hits after the defeat');
    assert(result.remainingHp.some(r=>r.camp===camp&&r.id===11120998&&r.rate>0),'fixture leaves a living auxiliary to reproduce the bug');
}

// Cross uses the same terminal rule after rebuilding both teams from level-159
// base stats. Replay the report to ensure no later round targets a wiped team.
for(const camp of [0,1]){
  const own=[{id:k.config.heroId,pos:1}];
  const enemies=[11120940,11120920,11120940].map((id,i)=>({id,pos:1+i*5}));
  const result=battle.kadroRapor(0,{name:'Cross wiped lineup',level:159,units:camp?own:enemies},null,{
    playerUnits:camp?enemies:own,playerState:{},crossServerBaseOnly:true,scaleEnemy:false,forceWin:false,random:()=>.5
  });
  const report=codec.decodeBattleReport(result.payload);
  const player=camp?report.player2:report.player1;
  const hero=player.roles.find(r=>r.roleId===k.config.heroId);
  const events=report.turns.flatMap(t=>t.actives.map(e=>({...e,round:t.curTurn})));
  const death=events.findIndex(e=>e.targets.some(t=>t.targetCamp===camp&&t.targetPos===hero.pos&&(t.reportTargetStatus&codec.ST.DIED)));
  assert(death>=0,'Cross fixture must wipe the lineup');
  assert.equal(result.won,camp===1);
  assert.equal(report.turns.at(-1).curTurn,events[death].round,'Cross ends in the actual defeat round');
  assert(!events.slice(death+1).some(e=>e.targets.some(t=>t.targetCamp===camp&&t.result.hurtHp>0)));
}
console.log('PASS team defeat: both camps, delayed Kakuzu revival, surviving summons, default/PvE/Cross results and no subsequent attacks.');
