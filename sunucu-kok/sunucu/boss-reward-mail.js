'use strict';
const fs=require('fs'),path=require('path'),{Y}=require('./paket'),env=require('./envanter'),cfg=require('./infinite-illusion-config.json');
const clone=d=>JSON.parse(JSON.stringify(d));
function save(ctx,next){ctx.kaydet(next);Object.assign(ctx.durum,next);}
function currency(file){return JSON.parse(fs.readFileSync(file,'utf8'));}
function atomic(file,data){const tmp=file+'.boss-mail-tmp';fs.writeFileSync(tmp,JSON.stringify(data,null,2));fs.renameSync(tmp,file);}
function enqueue(ctx,now,file=path.join(__dirname,'veri.json')){
 const next=clone(ctx.durum),s=next.infiniteIllusion;if(!s)return false;
 const pending=s.payouts.filter(p=>!p.mailSent&&(!p.itemsDelivered||!p.goldDelivered));if(!pending.length)return false;
 const ledger=currency(file).illusionCredits||{},created=[];
 const box=next.posta=next.posta||{gelen:[],giden:[],seq:1};
 for(const p of pending){
  // Recover the former direct-credit journal without granting those funds twice.
  if(ledger[p.id])p.goldDelivered=true;
  const ek=[];if(!p.goldDelivered&&p.gold>0)ek.push([3,p.gold]);if(!p.itemsDelivered&&p.stones>0)ek.push([cfg.stoneItemId,p.stones]);
  p.mailSent=true;if(!ek.length)continue;
  const existing=box.gelen.find(m=>m.bossPayoutId===p.id);
  if(existing){p.mailId={hi:existing.hi,lo:existing.lo};continue;}
  box.seq=Math.max(Number(box.seq)||1,...box.gelen.map(m=>(Number(m.lo)||0)+1));
  const date=Number.isFinite(p.day)?new Date(p.day*86400000).toISOString().slice(0,10):'hằng ngày';
  const mail={hi:0,lo:box.seq++,ad:'Ảo Cảnh Vô Hạn',konu:`Thưởng Boss ${date} — Hạng ${p.rank||'-'}`,metin:`Bạn đạt hạng ${p.rank||'-'} trong bảng xếp hạng sát thương Muken Aizen ngày ${date}. Nhấn nhận đính kèm để lấy phần thưởng.`,zaman:now,okundu:0,ek,bossPayoutId:p.id};
  box.gelen.push(mail);p.mailId={hi:mail.hi,lo:mail.lo};created.push(mail);
 }
 save(ctx,next);return created.length?created:false;
}
function notification(m){const w=new Y().u32(0).u32(m.hi).u32(m.lo).utf(m.ad).utf(m.konu).utf(m.metin).u32(m.zaman).i8(m.okundu?1:0).u32(0).u16(m.ek.length);for(const [id,amount] of m.ek)w.u32(id).u32(amount);return w.done();}
function claim(ctx,ids,file=path.join(__dirname,'veri.json')){
 const next=clone(ctx.durum),s=next.infiniteIllusion,box=next.posta;
 const mails=(box&&box.gelen||[]).filter(m=>m.bossPayoutId&&ids.some(([hi,lo])=>hi===m.hi&&lo===m.lo));
 if(!mails.length)return {handled:[],updates:[]};
 const handled=mails.map(m=>[m.hi,m.lo]);const v=currency(file);v.illusionCredits=v.illusionCredits||{};
 const parcels=mails.map(m=>({m,p:s&&s.payouts.find(p=>p.id===m.bossPayoutId)}));
 if(parcels.some(x=>!x.p))return {error:1};
 let stones=0,gold=0;
 for(const {p} of parcels){if(!p.itemsDelivered)stones+=p.stones;if(!p.goldDelivered&&!v.illusionCredits[p.id])gold+=p.gold;}
 if(env.mevcut(next,cfg.stoneItemId)+stones>env.MAX_ADET||Math.max(0,Number(v.altin)||0)+gold>2000000000)return {error:1};
 // Save item delivery first; the existing currency ledger recovers interrupted claims.
 if(stones){const before=env.mevcut(next,cfg.stoneItemId);env.ekle(next,[{type:1,code:cfg.stoneItemId,amount:stones}]);if(env.mevcut(next,cfg.stoneItemId)!==before+stones)return {error:1};}
 for(const {p} of parcels)p.itemsDelivered=true;
 save(ctx,next);
 for(const {p} of parcels){if(!p.goldDelivered&&!v.illusionCredits[p.id]){v.altin=Math.max(0,Number(v.altin)||0)+p.gold;v.illusionCredits[p.id]=true;}p.goldDelivered=true;}
 if(gold)atomic(file,v);
 for(const {p,m} of parcels){m.ek=[];m.okundu=1;p.mailClaimed=true;}
 next.altin=v.altin;save(ctx,next);
 return {handled,updates:[{id:0x01180f00,payload:env.loadBagPaketi(next)},{id:0x01180105,payload:require('./harita').baseInfoUpdate([{index:3,v:Number(v.altin)||0}])}]};
}
module.exports={enqueue,notification,claim};
