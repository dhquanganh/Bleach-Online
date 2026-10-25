'use strict';
const fs=require('fs'),path=require('path');
const file=()=>process.env.BLEACH_MYOBOKU_CONFIG||path.join(__dirname,'myoboku.json');
const KEY='myoboku.json',COST=10000;
const defaults=()=>({revision:1,rewards:[10,20,30,50,80,100,150,200].map(amount=>({itemId:14900001,amount,weight:1}))});
function read(){try{return JSON.parse(fs.readFileSync(file(),'utf8'));}catch(e){if(e.code!=='ENOENT')throw e;return defaults();}}
function publish(data){const tmp=file()+'.'+process.pid+'.tmp';fs.writeFileSync(tmp,JSON.stringify(data,null,2));fs.renameSync(tmp,file());return data;}
function validate(data){
 const fail=message=>{const e=Error(message);e.status=400;throw e;};
 if(!data||!Number.isInteger(data.revision)||data.revision<1||data.revision>2147483646||!Array.isArray(data.rewards)||data.rewards.length!==8)fail('Cần đúng 8 ô thưởng và phiên bản hợp lệ.');
 const env=require('./envanter');
 const items=JSON.parse(fs.readFileSync(path.join(__dirname,'../cikarim/veri-json/Article.json'),'utf8'));
 const rewards=data.rewards.map(r=>{
  if(!r||!Number.isInteger(r.itemId)||!items.some(a=>(parseInt(a.id,16)>>>0)===r.itemId))fail('Vật phẩm không hợp lệ.');
  const item=items.find(a=>(parseInt(a.id,16)>>>0)===r.itemId);
  const max=Math.min(env.MAX_ADET,require('./admin-item-limits').maxAdd(item));
  if(!Number.isInteger(r.amount)||r.amount<1||r.amount>max)fail('Số lượng thưởng phải từ 1 đến '+max+'.');
  if(!Number.isInteger(r.weight)||r.weight<1||r.weight>1000000)fail('Trọng số phải từ 1 đến 1000000.');
  return {itemId:r.itemId,amount:r.amount,weight:r.weight};
 });return {revision:data.revision,rewards};
}
async function readDatabase(db){const c=db.collection('game_config');await c.updateOne({_id:KEY},{$setOnInsert:{data:read(),updatedAt:new Date()}},{upsert:true});return publish((await c.findOne({_id:KEY})).data);}
async function writeDatabase(db,value){const valid=validate(value),data={...valid,revision:valid.revision+1};const result=await db.collection('game_config').updateOne({_id:KEY,'data.revision':valid.revision},{$set:{data,updatedAt:new Date()}});if(!result.matchedCount){const e=Error('Cấu hình đã đổi. Hãy tải lại.');e.status=409;throw e;}return publish(data);}
let catalog;
function viewReward(r){catalog=catalog||JSON.parse(fs.readFileSync(path.join(__dirname,'../cikarim/veri-json/Article.json'),'utf8'));const item=catalog.find(a=>(parseInt(a.id,16)>>>0)===r.itemId),picture=Number(item?.picture)||r.itemId;return {...r,name:item?.name||String(r.itemId),picture,icon:require('../item-atlas.cjs')(picture)};}
function view(){const data=read();return {...data,cost:COST,unlimited:true,rewards:data.rewards.map(viewReward)};}
module.exports={read,publish,readDatabase,writeDatabase,validate,view,viewReward,COST};
