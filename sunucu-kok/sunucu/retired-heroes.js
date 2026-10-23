'use strict';
const heroIds=new Set([11120902,11120903,11120910,11120911,11120912,11120913,11120914,11120980,11120981,11120982,11120983,11120984]);
const fragmentIds=new Set([14130903,14130910,14130980]);
const offerIds=new Set([41120903,41120910,41120980]);
const allowed=id=>!heroIds.has(Number(id));
function filterTable(name,rows){
  return rows.filter(row=>{
    const id=parseInt(String(row.id),16);
    if(['BaseHero','heroes','HeroChangeAttr','RoleModel'].includes(name))return allowed(id);
    if(name==='Tavern_Warrior')return allowed(row.awardId);
    if(name==='BlackMarket')return !offerIds.has(id);
    if(name==='Article')return !fragmentIds.has(id);
    return true;
  });
}
// Remove ownership, formation and progression entries, including nested maps.
function clean(value){
  const removed=id=>heroIds.has(Number(id))||fragmentIds.has(Number(id))||offerIds.has(Number(id));
  if(Array.isArray(value))return value.filter(v=>{
    if(typeof v==='number'||typeof v==='string')return !removed(v);
    return !(v&&typeof v==='object'&&['heroId','heroID','id','roleId','template','templateId','itemID','itemId','code'].some(k=>removed(v[k])));
  }).map(clean);
  if(!value||typeof value!=='object')return value;
  const out={};for(const [key,v]of Object.entries(value)){
    if(removed(key))continue;
    if(['heroId','heroID','roleId'].includes(key)&&heroIds.has(Number(v)))out[key]=0;
    else out[key]=clean(v);
  }return out;
}
function cleanFiles(files){const out={...files};for(const name of ['veri.json','oyuncu.json'])if(typeof out[name]==='string'){
 const original=JSON.parse(out[name]),next=clean(original);if(JSON.stringify(original)!==JSON.stringify(next))out[name]=JSON.stringify(next,null,2);
}return out;}
module.exports={heroIds,fragmentIds,offerIds,allowed,filterTable,clean,cleanFiles};
