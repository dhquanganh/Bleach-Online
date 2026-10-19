'use strict';
const assert=require('node:assert/strict'),fs=require('node:fs'),os=require('node:os'),path=require('node:path');
const temp=fs.mkdtempSync(path.join(os.tmpdir(),'tower-gold-scaling-'));
process.env.BLEACH_ACCOUNT_DIR=temp;
fs.writeFileSync(path.join(temp,'veri.json'),JSON.stringify({altin:0,gumus:0}));
fs.writeFileSync(path.join(temp,'oyuncu.json'),'{}');
const tower=require('../tower-gold'),battle=require('../savas'),codec=require('../kodek'),inventory=require('../envanter'),{O}=require('../paket');
const handlers=require('../handlers');
function decodeAwards(payload){
  assert.equal(payload.readInt32BE(),0);const count=payload.readInt16BE(5),awards=[];
  for(let i=0;i<count;i++){const pos=7+10*i;awards.push({type:payload.readInt16BE(pos),code:payload.readInt32BE(pos+2),amount:payload.readInt32BE(pos+6)});}
  assert.equal(payload.length,7+count*10);return awards;
}
try{
  let previousAttack=0,previousGap=0;
  for(let floor=1;floor<=1000;floor++){
    const team=tower.lineup(floor),expected=Math.min(1000000000,Math.round(35*tower.attackMultiplier(floor)));
    assert(team.every(unit=>unit.atk===expected&&unit.magicAtk===expected));
    assert(team.every(unit=>unit.maxHp===Math.round(600*tower.statMultiplier(floor))));
    if(floor>1){const gap=expected-previousAttack;assert(gap>previousGap,'ATK gaps must widen every floor before saturation');previousGap=gap;}
    previousAttack=expected;
  }
  assert.equal(tower.lineup(1)[0].atk,35);
  assert(tower.lineup(100)[0].atk>10*Math.round(35*tower.statMultiplier(100)));
  for(const floor of [10000,1000000,Number.MAX_SAFE_INTEGER])assert(tower.lineup(floor).every(unit=>Number.isFinite(unit.atk)&&unit.atk<=1000000000));
  for(const floor of [1,98,99])assert(!tower.rewards(floor).some(r=>r.code===tower.PRIMOGEM));
  for(const floor of [100,101,150,500,1000,65535,65536,1000000]){
    assert.deepEqual(tower.rewards(floor).find(r=>r.code===tower.PRIMOGEM),{type:1,code:14900001,amount:Math.min(floor,inventory.MAX_ADET)});
  }
  for(const floor of [0,-1,1.5,NaN,Infinity,'100'])assert.throws(()=>tower.rewards(floor),/Invalid floor/);
  const state={towerGold:{floor:99,records:{}}};
  const preview=JSON.parse(new O(tower.packet(state)).utf()).preview;
  assert.deepEqual(preview.map(r=>r.floor),[99,100,101,102,103]);
  for(const row of preview){assert.equal(row.atk,tower.lineup(row.floor)[0].atk);assert.deepEqual(row.rewards,tower.rewards(row.floor));}
  assert(!preview[0].rewards.some(r=>r.code===tower.PRIMOGEM));
  assert.equal(preview[1].rewards.find(r=>r.code===tower.PRIMOGEM).amount,100);

  // Use a valid native battle payload, then control the outcome to test award scheduling.
  const actor=battle.heroBirim(11100004,6,1,null,null,0,true);
  Object.assign(actor,{hp:100000,maxHp:100000,atk:10000,magicAtk:10000,speed:1000});
  const native=battle.kadroRapor(0,null,{ad:'Tower scaling fixture',birimler:tower.lineup(1)},{playerState:{},playerUnits:[actor],forceWin:false,scaleEnemy:false,random:()=>.5});
  const original=battle.kadroRapor;let won=true;
  battle.kadroRapor=(id,enemy,spec,options)=>{
    assert.equal(options.forceWin,false);assert.equal(options.requireEnemyDefeated,true);assert.equal(options.scaleEnemy,false);
    assert(spec.birimler.every(u=>u.atk===Math.round(35*tower.attackMultiplier(u.level))));
    return {...native,won};
  };
  try{
    for(const floor of [99,100,101]){
      const d={nick:'Test',towerGold:{floor,records:{}}};
      const result=tower.fight(d,floor),shown=decodeAwards(result.frames[1].payload),awards=tower.complete(d,result);
      assert.deepEqual(shown,awards);assert.deepEqual(awards,tower.rewards(floor));
      const before=inventory.mevcut(d,tower.PRIMOGEM);
      handlers.odulVer(d,awards);
      fs.writeFileSync(path.join(temp,'oyuncu.json'),JSON.stringify(d));
      const reloaded=JSON.parse(fs.readFileSync(path.join(temp,'oyuncu.json')));
      assert.equal(inventory.mevcut(reloaded,tower.PRIMOGEM)-before,floor>=100?floor:0);
      assert.equal(reloaded.towerGold.floor,floor+1);
      assert.equal(tower.complete(reloaded,result).length,0,'Repeat completion cannot grant again');
      const replay=tower.fight(reloaded,floor,'first');assert(replay.replay);assert.equal(decodeAwards(replay.frames[1].payload).length,0);assert.equal(tower.complete(reloaded,replay).length,0);
      if(floor>=100){
        const updates=handlers.ekAl().sonra.filter(p=>p.id===inventory.OP_NTF);
        assert(updates.some(p=>{const b=p.payload;for(let i=0;i<b.readUInt16BE(1);i++){const at=3+i*30;if(b.readUInt32BE(at+1)===tower.PRIMOGEM)return b.readUInt16BE(at+9)===inventory.mevcut(reloaded,tower.PRIMOGEM);}return false;}),'Native inventory notification must contain the real new balance');
      }else handlers.ekAl();
    }
    won=false;const d={towerGold:{floor:100,records:{}}},loss=tower.fight(d,100);
    assert.equal(decodeAwards(loss.frames[1].payload).length,0);assert.deepEqual(tower.complete(d,loss),[]);assert.equal(d.towerGold.floor,100);
    won=true;
    const capped={towerGold:{floor:100,records:{}},envanter:{esyalar:[{code:tower.PRIMOGEM,amount:inventory.MAX_ADET-50}],dusulen:{}}};
    const capBattle=tower.fight(capped,100),before=structuredClone(capped);
    assert.throws(()=>tower.complete(capped,capBattle),/đầy/);assert.deepEqual(capped,before,'Full stacks cannot consume a floor or lose rewards');
    const full={towerGold:{floor:100,records:{}},envanter:{esyalar:Array.from({length:2048},(_,i)=>({code:14000000+i,amount:1})),dusulen:{}}};
    const fullBattle=tower.fight(full,100);assert.throws(()=>tower.complete(full,fullBattle),/đầy/);assert.equal(full.towerGold.floor,100);
  }finally{battle.kadroRapor=original;}
  console.log('PASS Tower Gold: cubic ATK gaps, matching magic attack, safe limits, floor 99/100/101 boundary, server previews, native reward/inventory packets, real item delivery/reload, no loss/replay/duplicate rewards. All writes isolated to a temporary account.');
}finally{
  assert(path.resolve(temp).startsWith(path.resolve(os.tmpdir())+path.sep));fs.rmSync(temp,{recursive:true,force:true});
}
