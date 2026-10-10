'use strict';
const {tablo}=require('./paket');
const engine=require('./hero-skills');
const definitions=new Map();
for(const row of tablo('WeaponSkillConfig').liste){
  const numbers=[...String(row.desc).matchAll(/(\d+(?:\.\d+)?)/g)].map(match=>Number(match[1]));
  const group=Math.floor((row._id-13700000)/1000);
  definitions.set(row._id,{id:row._id,group,value:numbers[0],extra:numbers[1],description:row.desc});
}
function equipped(state,heroId){
  const gear=state.ekipman||{},slots=(gear.takili||{})[heroId]||{};
  return [...new Set(Object.values(slots).map(id=>Number(((gear.esyalar||{})[id]||{}).ws)).filter(id=>definitions.has(id)))];
}
function start(caster,records){
  for(const id of caster.weaponSkills||[]){const rule=definitions.get(id);if(!rule)continue;
    const fields={1:'def',7:'damageBonus',8:'damageReduction',9:'controlResist',10:'furyResist',11:'ignoreDefense',12:'silenceResist',13:'critDamage'};
    if(fields[rule.group])engine.apply({sourceId:id,effects:[{kind:'buff',scope:'s',field:fields[rule.group],value:rule.value/100,turns:99}]},caster,[caster],[],[],records);
    else if(rule.group===2)engine.changeFury(caster,rule.value,records);
  }
}
function damageMultiplier(caster,target){
  let bonus=0;
  for(const id of caster.weaponSkills||[]){const rule=definitions.get(id);if(rule&&rule.group===0&&target.hp/target.maxHp<rule.value/100)bonus+=rule.extra/100;}
  return 1+bonus;
}
function after(caster,allies,enemies,targets,damage,records,random=Math.random){
  if(caster.hp<=0)return;
  for(const id of caster.weaponSkills||[]){const rule=definitions.get(id);if(!rule)continue;
    if(rule.group===3)engine.restore(caster,caster,caster.maxHp*rule.value/100,records);
    if(rule.group===4)engine.restore(caster,caster,damage*rule.value/100,records);
    if(rule.group===5)for(const target of targets){const requested=Math.floor(target.anger*rule.value/100),before=target.anger;
      engine.changeFury(target,-requested,records,false,random);engine.changeFury(caster,before-target.anger,records,false,random);}
    if(rule.group===6)for(const target of targets)engine.changeFury(target,-rule.value,records,false,random);
    if(rule.group===14||rule.group===15)engine.apply({sourceId:id,effects:[{kind:'buff',scope:'t',field:rule.group===14?'stun':'silence',value:1,turns:1,chance:rule.value/100}]},caster,allies,enemies,targets,records,random);
  }
}
module.exports={definitions,equipped,start,damageMultiplier,after};
