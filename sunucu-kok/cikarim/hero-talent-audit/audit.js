'use strict';
const fs=require('fs'),path=require('path'),zlib=require('zlib'),assert=require('assert'),crypto=require('crypto');
const root=path.resolve(__dirname,'../..'),data=path.join(root,'cikarim/veri-json');
const t=require('../../sunucu/hero-talents');
const load=name=>JSON.parse(fs.readFileSync(path.join(data,name+'.json'),'utf8'));
const roles=new Set(load('RoleModel').map(r=>parseInt(r.id,16))),skills=new Set(load('SkillConfig').map(r=>parseInt(r.id,16)));
const binaryFile=path.join(root,'kaynak/login.gogames.me/public/2026090619/Resources/Bin/normal/01000005.bin');
const nativeTalents=new Map();
for(const name of fs.readdirSync(path.dirname(binaryFile)).filter(n=>n.endsWith('.binPackage'))){
 const b=fs.readFileSync(path.join(path.dirname(binaryFile),name));let p=6;
 for(let i=0;i<b.readUInt16LE(4);i++){
  const n=b.readUInt32LE(p);p+=4;const r=zlib.inflateSync(b.subarray(p,p+n));p+=n;
  if(r.readUInt32LE(0)!==0x100001f)continue;
  let q=8;const utf=()=>{const len=r.readUInt16LE(q);q+=2;const s=r.toString('utf8',q,q+len);q+=len;return s;};
  for(let j=0;j<r.readUInt32LE(4);j++){const id=r.readUInt32LE(q);q+=4;nativeTalents.set(id,{name:utf(),desc:utf()});}
  assert.equal(q,r.length);
 }
}
assert.equal(nativeTalents.size,t.talents.size,'frontend talent table differs');
for(const [id,row]of t.talents){assert.equal(nativeTalents.get(id).name,row.talentName);assert.equal(nativeTalents.get(id).desc,row.talentDesc);}
function readHeroes(file){
 const b=zlib.inflateSync(fs.readFileSync(file)),out=new Map();let p=8;
 assert.equal(b.readUInt32LE(0),0x1000005);
 const u32=()=>{const v=b.readUInt32LE(p);p+=4;return v;};
 const f32=()=>{const v=b.readFloatLE(p);p+=4;return v;};
 const utf=()=>{const n=b.readUInt16LE(p);p+=2;const s=b.toString('utf8',p,p+n);p+=n;return s;};
 for(let i=0;i<b.readUInt32LE(4);i++){
  const id=u32(),h={isMain:u32(),desc:utf(),name:utf(),assess:utf()};
  for(const key of ['sex','level','needLevel','profession','source','quality','power','agile','intelligence','life','speed'])h[key]=u32();
  for(const key of ['powerGrow','agileGrow','intelligenceGrow','lifeGrow','speedGrow'])h[key]=f32();
  for(const key of ['nearAttack','nearDefense','farAttack','farDefense','strategyAttack','strategyDefense'])h[key]=u32();
  for(const key of ['hitRate','dodgeRate','critRate','blockRate','punchRate','helpRate','hurtRate','avoidHurtRate','wreckRate','antiknockRate','attachRate','deFenceRate','recoverRate'])h[key]=f32();
  h.active=u32();h.attackEffect=utf();h.normalAttack=u32();h.talent=u32();h.sound=u32();h.weakness=u32();h.headStyle=utf();h.country=u32();h.heroSoul=utf();h.f48=utf();out.set(id,h);
 }
 assert.equal(p,b.length);return out;
}
const front=readHeroes(binaryFile),issues=[],entries=[];
for(const [id,h]of t.heroes){
 const native=front.get(id);assert(native,`${id}: missing frontend record`);
 for(const [key,value]of Object.entries(native)) {
  if(key==='attackEffect')assert.deepEqual(JSON.parse(value),JSON.parse(h[key]),`${id}: frontend animation differs`);
  else assert.deepEqual(value,h[key],`${id}: frontend ${key} differs`);
 }
 const errors=[];
 if(!roles.has(id))errors.push('missing RoleModel');
 if(!skills.has(h.normalAttack))errors.push('missing normal SkillConfig');
 if(!skills.has(h.active))errors.push('missing active SkillConfig');
 if(!t.talents.has(h.talent))errors.push('missing HeroTalent');
 const effects=JSON.parse(h.attackEffect);
 if(!effects[h.normalAttack]||!effects[h.active])errors.push('missing normal/active animation');
 if(errors.length)issues.push({id,errors});
 const talent=t.talents.get(h.talent),desc=talent.talentDesc;
 const unspecified=/certain|higher percent|large|massive|small chance/i.test(desc);
 entries.push({id,name:h.name,talentId:h.talent,talentName:talent.talentName,description:desc,
  explicitEffects:t.effect(id),baseRates:t.rates(id),usesExistingBaseGrowthForUnspecifiedEffects:unspecified,errors});
}
assert.equal(front.size,t.heroes.size);
const repairs=JSON.parse(fs.readFileSync(path.join(__dirname,'animation-repairs.json'),'utf8'));
for(const row of repairs.frontendPackages){const copy=readHeroes(path.join(root,row.file));assert.deepEqual(copy,front);}
const report={counts:{heroes:t.heroes.size,talents:t.talents.size,roleModels:roles.size,skills:skills.size,
 explicitTalentDefinitions:t.effects.size,heroesWithUnspecifiedTalentAmounts:entries.filter(e=>e.usesExistingBaseGrowthForUnspecifiedEffects).length,
 frontendCopiesVerified:repairs.frontendPackages.length,referenceErrors:issues.length},
 source:{baseHero:'cikarim/veri-json/BaseHero.json',frontend:'kaynak/login.gogames.me/public/2026090619/Resources/Bin/normal/01000005.bin',
 frontendSha256:crypto.createHash('sha256').update(fs.readFileSync(binaryFile)).digest('hex')},
 limitations:['Frontend HeroTalent has only name/description; there is no original server talent formula in this workspace.',
 'Unspecified percentages and small combo chances retain BaseHero base/growth/rates; no invented percentages are added.',
 'Aid splits a normal hit 50/50 with a living helper; block halves damage; crit multiplies damage by 1.5. These are explicit local combat rules, not verified original-server formulas.',
 'Eight missing active animations use normal-animation fallbacks. One active animation was recovered by exact skill ID.'],issues,heroes:entries};
if(process.argv.includes('--write'))fs.writeFileSync(path.join(__dirname,'report.json'),JSON.stringify(report,null,2)+'\n');
console.log(JSON.stringify(report.counts,null,2));
if(issues.length)process.exitCode=1;
module.exports={readHeroes};
