'use strict';
const fs=require('node:fs'),runtime=require('./runtime-path'),config=require('./konoha-tree-config'),env=require('./envanter');
const day=now=>new Date(now+25200000).toISOString().slice(0,10);
function view(d,now=Date.now(),settings=config.read()){
 const open=settings.enabled&&now>=Date.parse(settings.startsAt)&&now<=Date.parse(settings.endsAt),today=day(now),used=d.konohaTree?.[settings.seasonId]?.daily?.[today]||{};
 return {ok:true,revision:settings.revision,seasonId:settings.seasonId,startsAt:settings.startsAt,endsAt:settings.endsAt,serverTime:now,enabled:settings.enabled,open,coinId:config.COIN,balance:env.mevcut(d,config.COIN),offers:settings.offers.filter(r=>r.enabled).map(r=>({...r,...config.itemView(r.itemId),used:used[r.id]||0,remaining:Math.max(0,r.dailyLimit-(used[r.id]||0))}))};
}
function exchange(request,{load,now=Date.now,write=atomic}={}){
 if(!request||typeof request.requestId!=='string'||!/^[a-zA-Z0-9_-]{12,80}$/.test(request.requestId)||typeof request.offerId!=='string'||!Number.isInteger(request.revision)||typeof request.seasonId!=='string')config.fail(400,'Yêu cầu đổi quà không hợp lệ.');
 require('./ekipman');const d=load(),settings=config.read(),stamp=now(),fingerprint=request.seasonId+':'+request.offerId,previous=d.konohaTree?.[request.seasonId]?.receipts?.[request.requestId];
 if(previous){if(previous.fingerprint!==fingerprint)config.fail(409,'Mã giao dịch đã được sử dụng.');return {...view(d,stamp,settings),reward:previous.reward,replayed:true,state:d};}
 if(request.seasonId!==settings.seasonId||request.revision!==settings.revision)config.fail(409,'Danh sách đổi quà đã thay đổi. Hãy tải lại sự kiện.');
 if(!view(d,stamp,settings).open)config.fail(400,'Sự kiện chưa mở hoặc đã kết thúc.');
 const row=settings.offers.find(r=>r.id===request.offerId&&r.enabled);if(!row)config.fail(400,'Quà đổi không còn khả dụng.');
 const next=structuredClone(d);next.konohaTree||={};const season=next.konohaTree[settings.seasonId]||={daily:{},receipts:{}};season.daily||={};season.receipts||={};const used=season.daily[day(stamp)]||={};
 if(Object.keys(season.receipts).length>=4096)config.fail(429,'Đã đạt giới hạn giao dịch của đợt sự kiện.');
 if((used[row.id]||0)>=row.dailyLimit)config.fail(400,'Đã hết lượt đổi quà này trong ngày.');
 const before=env.mevcut(next,row.itemId);if(!before&&env.liste(next).length+require('./ekipman').cantaKayitlari(next).length>=env.MAX_GIRIS)config.fail(400,'Túi không còn chỗ cho phần thưởng.');if(before+row.amount>env.MAX_ADET)config.fail(400,'Túi đã đầy vật phẩm thưởng.');
 if(!env.dus(next,config.COIN,row.price))config.fail(400,'Không đủ Fortune Coin.');
 env.ekle(next,[{type:1,code:row.itemId,amount:row.amount}]);if(env.mevcut(next,row.itemId)!==before+row.amount)config.fail(400,'Không thể thêm quà vào túi.');
 if(env.liste(next).length+require('./ekipman').cantaKayitlari(next).length>env.MAX_GIRIS)config.fail(400,'Túi không còn chỗ cho phần thưởng.');
 used[row.id]=(used[row.id]||0)+1;const reward={...config.itemView(row.itemId),amount:row.amount};season.receipts[request.requestId]={fingerprint,reward,at:stamp};write(next);
 return {...view(next,stamp,settings),reward,replayed:false,state:next};
}
function atomic(d){const file=runtime('oyuncu.json'),tmp=file+'.konoha-tree.tmp';fs.writeFileSync(tmp,JSON.stringify(d,null,2));fs.renameSync(tmp,file);}
module.exports={view,exchange,atomic,day};
