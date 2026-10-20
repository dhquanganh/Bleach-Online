'use strict';
const A='a'.repeat(24),B='b'.repeat(24),C='c'.repeat(24);
const identity=id=>({id0:7,id1:id===A?11:12,name:id===A?'Real A':'Real B'});
function database(){
 const docs=new Map();let fail=false;
 function match(d,q){return Object.entries(q).every(([k,v])=>{
  if(k==='rewards.accountId')return d.rewards.some(r=>r.accountId===v);
  if(v&&typeof v==='object'&&'$lt' in v)return d[k]<v.$lt;
  return d[k]===v;
 });}
 const collection={async createIndex(){},async findOne(q){return structuredClone([...docs.values()].find(d=>match(d,q))||null);},
  find(q){let descending=false;return {sort(){descending=true;return this;},async toArray(){const rows=[...docs.values()].filter(d=>match(d,q));if(descending)rows.sort((a,b)=>b._id-a._id);return structuredClone(rows);}};},
  async updateOne(q,u,opt={}){
   const old=docs.get(q._id);
   if(!old){if(!opt.upsert)return {matchedCount:0};docs.set(q._id,{_id:q._id,...structuredClone(u.$setOnInsert)});return {matchedCount:0,upsertedCount:1};}
   if(!match(old,q))return {matchedCount:0};
   if(u.$set){if(fail){fail=false;throw Error('database write failed');}for(const [k,v]of Object.entries(u.$set)){if(k.startsWith('entries.'))old.entries[k.slice(8)]=structuredClone(v);else old[k]=structuredClone(v);}}
   return {matchedCount:1};
  }};
 return {docs,failNext(){fail=true;},collection(){return collection;}};
}

module.exports={database,A,B,identity};
