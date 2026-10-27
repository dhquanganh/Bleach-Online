'use strict';
// Base values only. Equipment, quality and character skills retain their own bonuses.
const policy=require('./hero-base-balance.json');
function row(hero){
  const index=policy.ranks.indexOf(hero.assess);
  if(index<0)return hero;
  const t=index/(policy.ranks.length-1);
  const range=values=>values[0]+(values[1]-values[0])*t;
  const life=Math.round(range(policy.hp.level1)/policy.hpPerLife);
  const primary=Math.round(range(policy.attack.level1)/policy.attackPerPrimary);
  const growth=(end,start,factor)=>(range(end)/factor-start)/(policy.maxLevel-1);
  const primaryGrow=growth(policy.attack.level159,primary,policy.attackPerPrimary);
  return {...hero,power:primary,agile:primary,intelligence:primary,life,
    powerGrow:primaryGrow,agileGrow:primaryGrow,intelligenceGrow:primaryGrow,
    lifeGrow:growth(policy.hp.level159,life,policy.hpPerLife)};
}
function stats(growth){
  return {hp:Math.round(growth.life*policy.hpPerLife),atk:Math.round(growth.combat*policy.attackPerPrimary),
    def:Math.round(growth.combat*policy.defensePerPrimary),
    magicAtk:Math.round(growth.intelligence*policy.attackPerPrimary),resistance:Math.round(growth.intelligence*policy.defensePerPrimary)};
}
module.exports={row,stats,policy};
