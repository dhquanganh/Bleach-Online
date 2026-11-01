'use strict';
const fs=require('node:fs'),path=require('node:path'),{tablo,satir,json}=require('./paket'),env=require('./envanter');
const MONEY={
 '0:0':{field:'gumus',index:0,name:'Silver'},'0:1':{field:'altin',index:3,name:'Gold'},'0:2':{field:'kupon',index:1,name:'Coupons'},
 '3:0':{field:'askeriEmir',index:2,name:'Vitality'},'5:0':{field:'prestij',index:5,name:'Prestige'},'6:0':{field:'generalsSoul',index:4,name:'Souls'},
 '7:3':{field:'blueSoul',index:7,name:'Blue Reishi'},'7:4':{field:'purpleSoul',index:8,name:'Purple Reishi'},'7:5':{field:'goldSoulV',index:9,name:'Golden Reishi'},'7:6':{field:'orangeSoul',index:10,name:'Orange Reishi'}
};
const file=()=>process.env.BLEACH_PALACE_CHEST_FILE||path.resolve(__dirname,'../../.accounts/palace-chests.json');
const fail=(message,status=400)=>{throw Object.assign(Error(message),{status});};
function defaults(){return {revision:1,chests:tablo('TemplePliesNumber').liste.map(r=>({id:r._id,points:r.numberPlies,rewards:(json(satir('Award',r.awardID)?.fixed,{}).fixed||[]).map(a=>MONEY[a.type+':'+a.code]?a:{type:1,code:env.odulTemplate(a.type,a.code),amount:a.amount})}))};}
function validate(data){
 if(!data||!Number.isInteger(data.revision)||data.revision<1||data.revision>=2147483647||!Array.isArray(data.chests)||data.chests.length!==12)fail('Cần đủ 12 mốc thưởng và phiên bản hợp lệ.');
 const seen=new Set();
 return {revision:data.revision,chests:data.chests.map(row=>{
  const native=satir('TemplePliesNumber',row?.id);if(!native||seen.has(row.id))fail('Mốc thưởng không hợp lệ hoặc bị trùng.');seen.add(row.id);
  if(!Array.isArray(row.rewards)||row.rewards.length>32)fail('Mỗi mốc có tối đa 32 phần thưởng.');const keys=new Set();
  return {id:row.id,points:native.numberPlies,rewards:row.rewards.map(r=>{
   if(!r||!Number.isInteger(r.type)||!Number.isInteger(r.code)||!(r.type===1&&env.article(r.code)||MONEY[r.type+':'+r.code]))fail('Loại hoặc mã phần thưởng không hợp lệ.');
   const key=r.type+':'+r.code;if(keys.has(key))fail('Vật phẩm bị trùng trong mốc thưởng. Hãy sửa số lượng.');keys.add(key);
   const max=r.type===1?Math.min(env.MAX_ADET,require('./admin-item-limits').maxAdd(satir('Article',r.code))):1000000000;
   if(!Number.isInteger(r.amount)||r.amount<1||r.amount>max)fail('Số lượng thưởng phải là số nguyên từ 1 đến '+max+'.');
   return {type:r.type,code:r.code,amount:r.amount};
  })};
 }).sort((a,b)=>a.points-b.points)};
}
function read(){return validate(fs.existsSync(file())?JSON.parse(fs.readFileSync(file(),'utf8')).seasons.config:defaults());}
function write(data,actor){const checked=validate(data);return require('./king-challenge-store').createStore(file()).transact(reg=>{
 const old=reg.seasons.config||defaults();if(old.revision!==checked.revision)fail('Dữ liệu đã thay đổi. Hãy tải lại trước khi lưu.',409);
 const value={...checked,revision:old.revision+1,updatedBy:String(actor),updatedAt:Date.now()};reg.seasons.config=value;return {commit:true,result:value};
});}
function rewardView(r){const itemId=r.type===1?r.code:env.odulTemplate(r.type,r.code),item=satir('Article',itemId);return {...r,itemId,name:MONEY[r.type+':'+r.code]?.name||item?.name||String(r.code),picture:Number(item?.picture)||itemId,iconFrame:item?require('../item-atlas.cjs')(Number(item.picture)||itemId):null};}
function view(c=read()){return {...c,chests:c.chests.map(r=>({...r,rewards:r.rewards.map(rewardView)})),currencies:Object.entries(MONEY).map(([key,value])=>({key,name:value.name}))};}
module.exports={MONEY,file,defaults,read,write,validate,view,rewardView};
