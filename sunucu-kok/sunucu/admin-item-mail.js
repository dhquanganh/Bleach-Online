'use strict';
const crypto=require('node:crypto');
function enqueue(state,itemId,amount,requestId=crypto.randomUUID()){
 const env=require('./envanter'),article=env.article(itemId);
 if(!article||!Number.isInteger(amount)||amount<1||amount>require('./admin-item-limits').maxAdd(article))throw Error('Vật phẩm hoặc số lượng không hợp lệ.');
 const box=state.posta||={gelen:[],giden:[],seq:1};
 const existing=box.gelen.find(m=>m.adminGrantId===requestId);if(existing)return existing;
 box.seq=Math.max(Number(box.seq)||1,...box.gelen.map(m=>Number(m.lo)+1));
 const mail={hi:0,lo:box.seq++,ad:'Admin',konu:'Quà vật phẩm từ Admin',metin:'Nhấn nhận đính kèm để nhận vật phẩm vào túi.',zaman:Math.floor(Date.now()/1000),okundu:0,ek:[[itemId,amount]],adminGrantId:requestId};
 box.gelen.push(mail);return mail;
}
function claim(ctx,ids){
 const next=structuredClone(ctx.durum),mails=(next.posta?.gelen||[]).filter(m=>m.adminGrantId&&m.ek?.length&&ids.some(([hi,lo])=>m.hi===hi&&m.lo===lo));
 if(!mails.length)return {updates:[]};
 require('./ekipman');const env=require('./envanter');
 for(const mail of mails){for(const [code,amount] of mail.ek){const before=env.mevcut(next,code);env.ekle(next,[{code,amount}]);if(env.mevcut(next,code)!==before+amount)return {error:4,updates:[]};}mail.ek=[];mail.okundu=1;}
 ctx.kaydet(next);Object.assign(ctx.durum,next);
 return {updates:[{id:0x01180f00,payload:env.loadBagPaketi(next)}]};
}
module.exports={enqueue,claim};
