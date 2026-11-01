'use strict';
const fs=require('node:fs'),path=require('node:path');
const COIN=14900002,KEY='konoha-tree.json';
const file=()=>process.env.BLEACH_KONOHA_TREE_CONFIG||path.resolve(__dirname,'../../.accounts/konoha-tree.json');
function fail(status,message){throw Object.assign(Error(message),{status});}
const defaults=()=>({revision:1,seasonId:'konoha-tree-2026-11',enabled:true,startsAt:'2026-10-31T00:00:00+07:00',endsAt:'2026-11-04T22:59:59+07:00',offers:[{id:'primogem',itemId:14900001,amount:1,price:10,dailyLimit:100,enabled:true}]});
function validate(value){
 if(!value||!Number.isInteger(value.revision)||value.revision<1||value.revision>=2147483647)fail(400,'Phiên bản cấu hình không hợp lệ.');
 if(typeof value.seasonId!=='string'||!/^[a-zA-Z0-9_-]{1,64}$/.test(value.seasonId)||Object.prototype.hasOwnProperty.call(Object.prototype,value.seasonId))fail(400,'Mã đợt sự kiện không hợp lệ.');
 if(typeof value.enabled!=='boolean'||typeof value.startsAt!=='string'||typeof value.endsAt!=='string'||!Number.isFinite(Date.parse(value.startsAt))||!Number.isFinite(Date.parse(value.endsAt))||Date.parse(value.endsAt)<=Date.parse(value.startsAt)||Date.parse(value.startsAt)<0||Date.parse(value.endsAt)>4294967295000)fail(400,'Thời gian sự kiện không hợp lệ.');
 if(!Array.isArray(value.offers)||value.offers.length>200)fail(400,'Tối đa 200 quà đổi.');
 const seen=new Set(),env=require('./envanter');
 const offers=value.offers.map(row=>{
  if(!row||typeof row.id!=='string'||!/^[a-zA-Z0-9_-]{1,64}$/.test(row.id)||Object.prototype.hasOwnProperty.call(Object.prototype,row.id)||seen.has(row.id))fail(400,'Mỗi quà cần mã riêng, không trùng.');seen.add(row.id);
  const item=env.article(row.itemId);if(!Number.isInteger(row.itemId)||!item||row.itemId===COIN)fail(400,'Vật phẩm thưởng không hợp lệ.');
  const raw=require('./paket').satir('Article',row.itemId),max=Math.min(env.MAX_ADET,require('./admin-item-limits').maxAdd(raw));
  if(!Number.isInteger(row.amount)||row.amount<1||row.amount>max||!Number.isInteger(row.price)||row.price<1||row.price>env.MAX_ADET||!Number.isInteger(row.dailyLimit)||row.dailyLimit<1||row.dailyLimit>100000||typeof row.enabled!=='boolean')fail(400,'Kiểm tra số lượng, giá coin và giới hạn đổi.');
  return {id:row.id,itemId:row.itemId,amount:row.amount,price:row.price,dailyLimit:row.dailyLimit,enabled:row.enabled};
 });return {revision:value.revision,seasonId:value.seasonId,enabled:value.enabled,startsAt:new Date(value.startsAt).toISOString(),endsAt:new Date(value.endsAt).toISOString(),offers};
}
function read(){try{return validate(JSON.parse(fs.readFileSync(file(),'utf8')));}catch(e){if(e.code==='ENOENT')return validate(defaults());throw e;}}
function publish(data){fs.mkdirSync(path.dirname(file()),{recursive:true});const tmp=file()+'.'+process.pid+'.tmp';fs.writeFileSync(tmp,JSON.stringify(data,null,2));fs.renameSync(tmp,file());return data;}
async function readDatabase(db){const c=db.collection('game_config');await c.updateOne({_id:KEY},{$setOnInsert:{data:read(),updatedAt:new Date()}},{upsert:true});return publish(validate((await c.findOne({_id:KEY})).data));}
async function writeDatabase(db,value){const checked=validate(value),data={...checked,revision:checked.revision+1};const result=await db.collection('game_config').updateOne({_id:KEY,'data.revision':checked.revision},{$set:{data,updatedAt:new Date()}});if(!result.matchedCount)fail(409,'Cấu hình đã thay đổi. Hãy tải lại trước khi lưu.');return publish(data);}
function itemView(id){const r=require('./paket').satir('Article',id);return {itemId:id,name:r?.name||String(id),picture:Number(r?.picture)||id,iconFrame:require('../item-atlas.cjs')(Number(r?.picture)||id)};}
function adminView(data=read()){return {...data,coinId:COIN,offers:data.offers.map(r=>({...r,...itemView(r.itemId)}))};}
module.exports={COIN,KEY,file,defaults,validate,read,publish,readDatabase,writeDatabase,itemView,adminView,fail};
