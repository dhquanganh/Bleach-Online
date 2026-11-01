'use strict';
const fs=require('node:fs'),zlib=require('node:zlib'),runtime=require('./runtime-path'),config=require('./palace-chest-config'),env=require('./envanter'),{Y,gun}=require('./paket');
const journal=()=>runtime('palace-chest-pending.json');
function atomic(file,value){const tmp=file+'.palace-chest.tmp';fs.writeFileSync(tmp,Buffer.isBuffer(value)?value:JSON.stringify(value,null,2));fs.renameSync(tmp,file);}
function recover(){if(!fs.existsSync(journal()))return;const p=JSON.parse(fs.readFileSync(journal(),'utf8'));if(!p.account||!p.player)throw Error('Invalid palace chest journal');atomic(runtime('veri.json'),p.account);atomic(runtime('oyuncu.json'),p.player);fs.unlinkSync(journal());}
function state(d){const k=require('./soul-palace').state(d),today=gun();
 if(!d.palaceChest)d.palaceChest={day:today,id:Number(k.chest)||0};
 if(d.palaceChest.day!==today)d.palaceChest={day:today,id:0};
 k.chest=d.palaceChest.id||0;return {k,daily:d.palaceChest};
}
function info(d){const {k,daily}=state(d),c=config.read(),data=zlib.deflateSync(Buffer.from(JSON.stringify(c)));
 return new Y().u32(0).u16(Math.min(65535,k.cleared.length)).u32(daily.id).u32(data.length).raw(data).done();}
function commit(d,next,account,save){
 const vf=runtime('veri.json'),pf=runtime('oyuncu.json'),oldV=fs.readFileSync(vf),oldP=fs.existsSync(pf)?fs.readFileSync(pf):null;
 try{atomic(journal(),{account,player:next});atomic(vf,account);save(next);fs.unlinkSync(journal());}
 catch(e){atomic(vf,oldV);if(oldP)atomic(pf,oldP);else if(fs.existsSync(pf))fs.unlinkSync(pf);if(fs.existsSync(journal()))fs.unlinkSync(journal());throw e;}
 for(const key of Object.keys(d))delete d[key];Object.assign(d,next);
}
function claim(ctx,y){const fail=n=>({id:0x01180a08,payload:new Y().u32(n).done()});
 if(!Buffer.isBuffer(ctx.payload)||ctx.payload.length!==4)return fail(4);
 const id=ctx.payload.readUInt32BE(),next=structuredClone(ctx.durum),{k,daily}=state(next),row=config.read().chests.find(r=>r.id===id);
 if(!row||!row.rewards.length||daily.id||k.cleared.length<row.points)return fail(1);
 try{
  require('./ekipman');const account=JSON.parse(fs.readFileSync(runtime('veri.json'),'utf8')),items=row.rewards.filter(r=>r.type===1),money=row.rewards.filter(r=>r.type!==1);
  const before=items.map(r=>env.mevcut(next,r.code));
  if(items.some((r,i)=>before[i]+r.amount>env.MAX_ADET))return fail(1);
  if(env.liste(next).length+require('./ekipman').cantaKayitlari(next).length+before.filter(n=>n===0).length>env.MAX_GIRIS)return fail(1);
  env.ekle(next,items);if(items.some((r,i)=>env.mevcut(next,r.code)!==before[i]+r.amount))return fail(1);
  if(env.liste(next).length+require('./ekipman').cantaKayitlari(next).length>env.MAX_GIRIS)return fail(1);
  const updates=[];
  for(const r of money){const meta=config.MONEY[r.type+':'+r.code];
   if(meta.field==='gumus'){
    const silver=(BigInt(account.gumusHigh||0)<<32n)+BigInt(account.gumus||0)+BigInt(r.amount);if(silver>0xffffffffffffffffn)return fail(1);
    account.gumus=next.gumus=Number(silver&0xffffffffn);account.gumusHigh=next.gumusHigh=Number(silver>>32n);updates.push({index:0,v:account.gumusHigh,a:account.gumus});
   }else{const old=meta.field==='prestij'?require('./military-rank').prestige(next,account):Number(account[meta.field])||0,value=old+r.amount;if(value>2000000000)return fail(1);account[meta.field]=value;next[meta.field==='prestij'?'prestige':meta.field]=value;updates.push({index:meta.index,v:value});}
  }
  daily.id=id;daily.rewards=row.rewards;daily.revision=config.read().revision;k.chest=id;k.claimed=[id];commit(ctx.durum,next,account,ctx.kaydet);
  if(items.length)y.ekSonra(0x01180f00,env.loadBagPaketi(next),'PALACE-chest-items');
  if(updates.length)y.ekSonra(0x01180105,require('./harita').baseInfoUpdate(updates),'PALACE-chest-currencies');
  return {id:0x01180a08,payload:new Y().u32(0).u32(id).done()};
 }catch(e){console.error('[Palace chest]',e.message);return fail(1);}
}
module.exports={info,state,claim,recover};
