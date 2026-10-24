"use strict";
const assert=require("assert"),bots=require("../cross-server-bots");
// Displayed combat levels above the native hero cap must increase actual ATK/DEF.
const combatBase={maxHp:10000,hp:10000,atk:1000,def:500,speed:100};
const scaledAt=level=>{
 const unit={...combatBase};
 bots.scaleCombatStats(unit,{baseLevel:153,level,crossStatScale:2,crossAttackScale:2});
 return unit;
};
const low=scaledAt(153),double=scaledAt(306),quadruple=scaledAt(612);
assert.equal(double.atk,low.atk*4);assert.equal(double.def,low.def*4);
assert.equal(quadruple.atk,double.atk*4);assert.equal(quadruple.def,double.def*4);
assert.equal(double.maxHp,low.maxHp*4);assert.equal(quadruple.maxHp,double.maxHp*4);assert.equal(double.speed,low.speed);
let previous;
for(let row=0;row<=5;row++){
 const team=bots.team(5,153,row),unit={...combatBase};bots.scaleCombatStats(unit,team);
 if(previous){assert(unit.atk>previous.atk);assert(unit.def>previous.def);assert(unit.maxHp>previous.maxHp);}
 previous=unit;
}
const capped={...combatBase,atk:1000000000,def:1000000000};
bots.scaleCombatStats(capped,bots.team(5,159,5));
assert.equal(capped.atk,1000000000);assert.equal(capped.def,1000000000);
const squad=[100,1000,10000,100000,1000000].map(maxHp=>({...combatBase,maxHp}));
const budget=squad.reduce((sum,u)=>sum+u.maxHp,0),team={baseLevel:153,level:306,crossStatScale:2,crossAttackScale:2};
bots.scaleSquadStats(squad,team);
for(const unit of squad){assert.equal(unit.maxHp,Math.round(budget/5)*8);assert.equal(unit.hp,unit.maxHp);}
bots.scaleSquadStats([],team);
const huge=[{...combatBase,maxHp:1000000000}];bots.scaleSquadStats(huge,team);assert.equal(huge[0].maxHp,1000000000);
console.log('PASS Cross combat scaling: doubling level quadruples HP/ATK/DEF; all rows grow; squad HP is equal and fully healed; speed unchanged; stat caps respected.');
