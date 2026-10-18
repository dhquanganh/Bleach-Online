'use strict';
const heroIds=new Set([11120901,11120902,11120903,11120910,11120911,11120912,11120913,11120914]);
const fragmentIds=new Set([14130901,14130903,14130910]);
const offerIds=new Set([41120901,41120903,41120910]);
const allowed=id=>!heroIds.has(Number(id));
function filterTable(name,rows){
  return rows.filter(row=>{
    const id=parseInt(String(row.id),16);
    if(['BaseHero','heroes','HeroChangeAttr','RoleModel'].includes(name))return allowed(id);
    if(name==='Tavern_Warrior')return allowed(row.awardId);
    if(name==='BlackMarket')return !offerIds.has(id);
    return true;
  });
}
// Retain old encoded battle reports and source art for historical playback.
// Remove ownership, formation and progression entries, including nested maps.
function clean(value){
  if(Array.isArray(value))return value.filter(v=>!((typeof v==='number'||typeof v==='string')&&heroIds.has(Number(v)))&&!(v&&typeof v==='object'&&['heroId','heroID','id','roleId'].some(k=>heroIds.has(Number(v[k]))))).map(clean);
  if(!value||typeof value!=='object')return value;
  const out={};for(const [key,v]of Object.entries(value)){
    if(heroIds.has(Number(key)))continue;
    if(['heroId','heroID','roleId'].includes(key)&&heroIds.has(Number(v)))out[key]=0;
    else out[key]=clean(v);
  }return out;
}
function cleanFiles(files){const out={...files};for(const name of ['veri.json','oyuncu.json'])if(typeof out[name]==='string'){
 const original=JSON.parse(out[name]),next=clean(original);if(JSON.stringify(original)!==JSON.stringify(next))out[name]=JSON.stringify(next,null,2);
}return out;}
module.exports={heroIds,fragmentIds,offerIds,allowed,filterTable,clean,cleanFiles};
