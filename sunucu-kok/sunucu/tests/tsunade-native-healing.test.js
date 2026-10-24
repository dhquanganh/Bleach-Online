'use strict';
const assert=require('node:assert/strict'),fs=require('fs'),path=require('path');
const base=path.resolve(__dirname,'../../cikarim'),rows=JSON.parse(fs.readFileSync(path.join(base,'veri-json/BaseHero.json'),'utf8'));
const main=JSON.parse(fs.readFileSync(path.join(base,'tsunade-asian/animation.json'),'utf8')),slug=JSON.parse(fs.readFileSync(path.join(base,'tsunade-asian/katsuyu/animation.json'),'utf8'));
let checked=0;
for(const id of [11120992,11120993]){
 const hero=rows.find(h=>parseInt(h.id,16)===id),effects=JSON.parse(hero.attackEffect);
 for(const skill of id===11120992?[13121602,13121603,13121604,13121605,13121606]:[13121609]){
  const effect=effects[skill],frames=id===11120993?slug.clips.standard.frames.length:main.clips[main.moves[skill]].assets.length;
  assert(effect.friendhp,`${skill}: allied HP event missing`);assert.equal(Object.values(effect.friendhp).reduce((a,b)=>a+b,0),100);
  for(const frame of Object.keys(effect.friendhp))assert(Number(frame)>=0&&Number(frame)<frames,`${skill}: heal frame outside animation`);
  assert(!effect.anmyhp&&!effect.appendEffect,`${skill}: heal must not use damage dispatch`);checked++;
 }
}
const acid=JSON.parse(rows.find(h=>parseInt(h.id,16)===11120992).attackEffect)[13121601];assert.equal(Object.keys(acid.appendEffect).length,4);
console.log(`PASS ${checked} native allied-health mappings, valid timing, exactly 100% HP application and unchanged four-hit Acid Shot.`);
