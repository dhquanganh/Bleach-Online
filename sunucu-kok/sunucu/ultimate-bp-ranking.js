'use strict';
const ID='ultimate-bp-ranking:1',MINIMUM=5000;
const TIERS=[1,2,3,10,20,50];
function tiers(){const env=require('./envanter');return TIERS.map((through,i)=>({through,items:require('./etkinlik').odulCoz(21405161+i).map(a=>({itemId:env.odulTemplate(a.type,a.code),amount:a.amount}))}));}
function rank(entries){return entries.filter(r=>r.pieces>=MINIMUM).sort((a,b)=>b.pieces-a.pieces||a.accountId.localeCompare(b.accountId)).map((r,i)=>({...r,rank:i+1}));}
function enqueue(d,payout){
 const receipts=d.ultimateBPRankMailIds||={};if(receipts[payout.id])return {created:false,mailId:receipts[payout.id]};
 const box=d.posta||={gelen:[],giden:[],seq:1};box.seq=Math.max(Number(box.seq)||1,...box.gelen.map(m=>(Number(m.lo)||0)+1));
 const mail={hi:0,lo:box.seq++,ad:'Ultimate BP',konu:'Thưởng Ultimate BP — Hạng '+payout.rank,metin:'BXH đã được admin chốt. Bạn đạt hạng '+payout.rank+' với '+payout.pieces+' Crystal Pieces. Nhấn nhận đính kèm để lấy phần thưởng.',zaman:payout.at,okundu:0,ek:payout.items.map(a=>[a.itemId,a.amount]),adminGrantId:payout.id};
 box.gelen.push(mail);receipts[payout.id]={hi:mail.hi,lo:mail.lo};return {created:true,mail,mailId:receipts[payout.id]};
}
function reset(d,v,id){
 if(v.ultimateBP?.resetId===id)return false;
 v.ultimateBP={pieces:0,remainder:0,spent:0,resetId:id};
 if(d.ultimateBP)d.ultimateBP.claims=[0,0,0,0,0];
 return true;
}
let projection={rows:[],minimum:MINIMUM};
function update(value){if(value&&Array.isArray(value.rows))projection=value;}
function rows(){return projection.rows;}
function write(w){const list=rows().slice(0,65535);w.u16(list.length);for(const row of list)w.u32(row.id0).u32(row.id1).u32(row.rank).utf(JSON.stringify([{name:row.name,serverID:row.serverId||1,value:row.pieces}]));return w;}
module.exports={ID,MINIMUM,TIERS,tiers,rank,enqueue,reset,update,rows,write};
