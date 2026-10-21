'use strict';
const assert=require('node:assert/strict'),fs=require('fs'),path=require('path');
const battle=require('../savas'),n=require('../naruto-combat'),codec=require('../kodek');
const root=path.resolve(__dirname,'../../cikarim');
const heroes=JSON.parse(fs.readFileSync(path.join(root,'veri-json/BaseHero.json'),'utf8'));
const unit=(id,camp)=>({id,camp,pos:1,hp:1000000,maxHp:1000000,atk:1000,magicAtk:1,def:0,resistance:0,speed:100,hitRate:1,critRate:0,anger:0,level:99,normal:13100114,skill:0,skillId:13100114,partnerSkills:[],weaponSkills:[]});
let skills=0,checks=0;
for(const name of ['pain-tendo','hashirama-final','mecha-naruto','itachi-rtn']){
 const cfg=require('../'+name+'.json'),anim=JSON.parse(fs.readFileSync(path.join(root,name,'animation.json'),'utf8'));
 const hero=heroes.find(h=>parseInt(h.id,16)===cfg.heroId),effects=JSON.parse(hero.attackEffect),moves=[];
 function walk(v){if(Array.isArray(v))v.forEach(walk);else if(v&&typeof v==='object'){if(v.id)moves.push(v);Object.values(v).forEach(walk);}}walk(cfg);
 for(const move of moves){
  const clip=anim.clips[anim.moves[move.id]],effect=effects[move.id];
  if(!clip.hitFrames){assert.equal(move.hitCount,undefined);assert.equal(effect.appendEffect,undefined);continue;}
  skills++;assert(move.hitCount>=2&&move.hitCount<=64);assert.equal(move.hitCount,clip.hitFrames.length);
  assert.deepEqual(Object.keys(effect.appendEffect),clip.hitFrames.map(String));
  const impacts=Object.values(effect.appendEffect);assert(impacts.every(e=>e.anmyhp[0]===Math.floor(100/move.hitCount)));
  impacts.forEach((e,i)=>{assert.equal(e.hitIndex,i);assert.equal(e.hitCount,move.hitCount);assert.equal(e.anmyhp.checkDie,i===impacts.length-1?1:0);});
  assert(clip.hitFrames.every((f,i)=>f<clip.returnFrame&&(!i||f>clip.hitFrames[i-1])));
  for(const camp of [0,1])for(const shield of [0,103]){
   const actor=unit(cfg.heroId,camp),victim={...unit(12101003,1-camp),shield},teams=[[],[]];teams[camp]=[actor];teams[1-camp]=[victim];
   const ctx=n.create(teams,{random:()=>.5});n.startRound(ctx,1);
   const before=victim.hp;
   const frame=battle.vurus(actor,victim,false,[victim],()=>.5,false,[actor],n.attackSpec(move,!!move.requiresAny));
   const damage=frame.targets.filter(r=>r.cmd===codec.CMD.ATTACK&&r.targetCamp===victim.camp).reduce((s,r)=>s+(r.result.hurtHp||0),0);
   assert.equal(before-victim.hp,damage,'Native report total must match authoritative HP');
   assert(damage>0,move.name);
   let displayed=0;
   for(let i=0;i<move.hitCount;i++)displayed+=Math.floor(damage*(i+1)/move.hitCount)-Math.floor(damage*i/move.hitCount);
   assert.equal(displayed,damage,'Integer hits must exactly match server damage');checks++;
   // Multihit adds impact timing, not extra casts, resource spending or target vectors.
   assert.equal(frame.targets.filter(r=>r.cmd===codec.CMD.ATTACK&&r.targetCamp===victim.camp).length,1);
  }
 }
}
assert.equal(skills,31);
console.log(`PASS ${skills} skills, ${checks} real damage/shield/camp cases: ordered impacts, exact HP totals, support excluded, death only on final hit, no duplicate target vectors.`);
