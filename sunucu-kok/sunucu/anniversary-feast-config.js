'use strict';
const fs=require('fs'),path=require('path');
const file=()=>process.env.BLEACH_FEAST_CONFIG||path.join(__dirname,'anniversary-feast.json');
function read(){try{return JSON.parse(fs.readFileSync(file(),'utf8'));}catch(e){if(e.code!=='ENOENT')throw e;return {heroId:11150045,price:40000,revision:1};}}
function write(value,expected){const old=read();if(old.revision!==expected){const e=Error('Hot Sale đã thay đổi. Tải lại cấu hình trước khi lưu.');e.status=409;throw e;}const next={heroId:value.heroId,price:value.price,revision:old.revision+1};const tmp=file()+'.tmp';fs.writeFileSync(tmp,JSON.stringify(next,null,2));fs.renameSync(tmp,file());return next;}
// MongoDB is authoritative in account mode. The atomic file is a synchronous
// projection for game workers, whose native packet handlers are synchronous.
const KEY='anniversary-feast.json';
const view=value=>({heroId:value.heroId,price:value.price,revision:value.revision});
function publish(value){
 const next=view(value),tmp=file()+'.'+process.pid+'.tmp';
 fs.writeFileSync(tmp,JSON.stringify(next,null,2));fs.renameSync(tmp,file());return next;
}
async function readDatabase(db){
 const collection=db.collection('game_config');
 let doc=await collection.findOne({_id:KEY});
 if(!doc){
  await collection.updateOne({_id:KEY},{$setOnInsert:{data:read(),updatedAt:new Date()}},{upsert:true});
  doc=await collection.findOne({_id:KEY});
 }
 return publish(doc.data);
}
async function writeDatabase(db,value,expected){
 const next={heroId:value.heroId,price:value.price,revision:expected+1};
 const result=await db.collection('game_config').updateOne({_id:KEY,'data.revision':expected},{$set:{data:next,updatedAt:new Date()}});
 if(!result.matchedCount){const e=Error('Hot Sale đã thay đổi. Tải lại cấu hình trước khi lưu.');e.status=409;throw e;}
 return publish(next);
}
module.exports={read,write,readDatabase,writeDatabase};
