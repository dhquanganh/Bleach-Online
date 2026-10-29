'use strict';
const fs=require('node:fs'),path=require('node:path'),{tablo,satir,json}=require('./paket');
const file=()=>process.env.BLEACH_PALACE_FILE||path.resolve(__dirname,'../../.accounts/soul-palace.json');
let seed;
function defaults(){
 if(seed)return structuredClone(seed);
 const battle=require('./savas');let n=0;
 seed={revision:1,towers:tablo('City').liste.filter(c=>c.type===4).map(c=>({id:c._id,name:c.name,openLevel:Math.min(159,c.openLevel),floors:tablo('TemplePoint').liste.filter(p=>p._id>=c.start&&p._id<=c.last).map(p=>{
  const units=battle.stageDusmanlari(p._id)?.birimler||[],scale=2*(1+n++*.01);
  const awards=(json(p.battleScene,{}).army||[]).map(id=>satir('Award',satir('EnemyArmy',id)?.awardId));
  return {id:p._id,name:p.name,scene:30000,units:units.map(u=>({id:u.id,pos:u.pos,level:Math.min(159,u.level),hp:Math.round(u.maxHp*scale),atk:Math.round(u.atk*scale),def:Math.round(u.def*scale),speed:u.speed})),rewards:awards.flatMap(a=>json(a?.fixed,{}).fixed||[]),randomRewards:awards.flatMap(a=>json(a?.f1,{}).rewards||[])};
 })}))};return structuredClone(seed);
}
function read(){const f=file();return fs.existsSync(f)?JSON.parse(fs.readFileSync(f,'utf8')).seasons.config:defaults();}
function fail(message,status=400){throw Object.assign(Error(message),{status});}
function integer(n,min,max,label){if(!Number.isInteger(n)||n<min||n>max)fail(label+': số nguyên từ '+min+' đến '+max);return n;}
function text(v,label){if(typeof v!=='string'||!v.trim()||v.length>100)fail(label+': nhập từ 1 đến 100 ký tự.');return v.trim();}
function reward(r){if(!r||!((r.type===1&&satir('Article',r.code))||(r.type===0&&[0,1,2].includes(r.code))||(r.type===2&&r.code===0)))fail('Loại hoặc mã phần thưởng không hợp lệ.');return {type:r.type,code:r.code,amount:integer(r.amount,1,r.type===1?65535:1000000000,'Số lượng thưởng')};}
function validate(data){
 if(!data||!Array.isArray(data.towers)||!data.towers.length||data.towers.length>100)fail('Cần từ 1 đến 100 tầng lớn.');
 const ids=new Set(),floors=new Set(),allowed=new Set(require('./herolar').gecerliHerolar().map(h=>h.id));
 const towers=data.towers.map(t=>{
  integer(t.id,15900001,15900999,'ID tầng lớn');if(ids.has(t.id))fail('ID tầng lớn bị trùng.');ids.add(t.id);
  if(!Array.isArray(t.floors)||!t.floors.length||t.floors.length>255)fail('Mỗi tầng lớn cần 1–255 tầng con.');
  return {id:t.id,name:text(t.name,'Tên tầng lớn'),openLevel:integer(t.openLevel,1,159,'Cấp mở khóa'),floors:t.floors.map(f=>{
   integer(f.id,15910001,15949999,'ID tầng con');if(floors.has(f.id))fail('ID tầng con bị trùng.');floors.add(f.id);if(floors.size>2000)fail('Tối đa 2000 tầng con trong một cấu hình.');
   if(!Array.isArray(f.units)||!f.units.length||f.units.length>9)fail('Đội hình cần 1–9 nhân vật.');const positions=new Set();
   const units=f.units.map(u=>{if(!satir('Enemy',u.id)&&!allowed.has(u.id))fail('Nhân vật không hợp lệ: '+u.id);integer(u.pos,1,15,'Vị trí');if(positions.has(u.pos))fail('Vị trí đội hình bị trùng.');positions.add(u.pos);return {id:u.id,pos:u.pos,level:integer(u.level,1,159,'Cấp'),hp:integer(u.hp,1,1000000000,'HP'),atk:integer(u.atk,0,100000000,'ATK'),def:integer(u.def,0,100000000,'DEF'),speed:integer(u.speed,0,1000000,'Tốc độ')};});
   if(!Array.isArray(f.rewards)||f.rewards.length>16)fail('Phần thưởng không hợp lệ.');
   const rewards=f.rewards.map(reward),pools=f.randomRewards||[];if(!Array.isArray(pools)||pools.length>20)fail('Bảng thưởng ngẫu nhiên không hợp lệ.');
   const randomRewards=pools.map(p=>{if(!Number.isFinite(p.rate)||p.rate<0||p.rate>1||!Array.isArray(p.value)||p.value.length>16)fail('Tỷ lệ thưởng phải từ 0 đến 1.');return {rate:p.rate,value:p.value.map(reward)};});
   return {id:f.id,name:text(f.name,'Tên tầng con'),scene:integer(f.scene,1,99999999,'Bối cảnh'),units,rewards,randomRewards};
  })};
 });
 return towers;
}
function write(data,actor){
 const towers=validate(data);return require('./king-challenge-store').createStore(file()).transact(r=>{
  const old=r.seasons.config||defaults();if(data.revision!==old.revision)fail('Dữ liệu đã thay đổi. Tải lại trước khi lưu.',409);
  const value={revision:old.revision+1,towers,updatedAt:Date.now(),updatedBy:actor};r.seasons.config=value;return {commit:true,result:value};
 });
}
function catalog(){const allowed=new Set(require('./herolar').gecerliHerolar().map(h=>h.id));return [...tablo('BaseHero').liste.filter(h=>allowed.has(h._id)),...tablo('Enemy').liste].map(h=>({id:h._id,name:h.name||String(h._id),kind:allowed.has(h._id)?'hero':'enemy'}));}
module.exports={read,write,validate,defaults,catalog};
