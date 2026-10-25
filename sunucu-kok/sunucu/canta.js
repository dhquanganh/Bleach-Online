'use strict';
// CANTA ISLEMLERI — esya KULLANMA (UseAppliance) ve SATMA (SellItem), kalici envanterle.
//
// ============================ PROTOKOL (AS3'ten birebir) ============================
// CS 0x01810f01 UseAppliance = [i16 n=1][u32 instance][u32 idTemplate][i16 adet][u32 heroId]
//   (TProcessorBackpack.ProcessorUseAppliance heroId=0; TWindowInventory/TProcessorPartner hero id yazar)
// SC 0x01180f08 UseApplianceRet = [u32 hata][u32 idTemplate][i16 n] + n x (i16 type, u32 idTemplate, u32 adet)
//   n = kullanimdan ELDE EDILEN kalemler (hediye paketi). n=0 ise client kullanilan esyayi Article'dan
//   kurup minorType'a gore metin basar (90 ExperienceReel -> "Exp", 80 SilverCard -> "Coin").
//   !!! Cevap opcode'u swap DEGIL: istek Base+1, cevap Base+8 (0x01180f08). Swap 0x01180f01 = SendThings.
//   Etkinin kendisi AYRI paketlerle gelir: exp -> CharBaseInfoUpdate index 12 (ExperienceTarget),
//   gumus -> index 0, kazanilan esya -> InventoryNtf; kullanilan esyanin dusumu -> InventoryNtf/ReduceThings.
// CS 0x01810f03 SellItem = [i16 n] + n x (u32 instance, u32 idTemplate, i16 adet)
// SC 0x01180f05 SellItemRet = [u32 hata][u32 silverHigh][u32 silverLow]  (toplam kazanilan gumus)
//   !!! Cevap Base+5 (swap 0x01180f03 = InventoryExpire olurdu). Gumus ayrica index 0 ile hesaba islenir.
//
// Article.minorType (CONST_INVENTORY.CATEGORYSECOND_*): 90 ExperienceReel (itemFunction = exp miktari),
//   80 SilverCard (itemFunction = gumus), 98 LevelPacks / 96-97 materyal-paket / 72 vb: icerik
//   oduller.json'da template id ile cozulebiliyorsa verilir; cozulemeyen esya HARCANMAZ, hata doner.
const seviye = require('./seviye');
const envanter = require('./envanter');
const { satir, tablo } = require('./paket');

const OP_USE_RET = 0x01180f08, OP_SELL_RET = 0x01180f05, OP_BASEINFO = 0x01180105;
const HATA_ESYA = 0x15;          // ErrorCode 21 "Not enough items"
const HATA_KULLANILAMAZ = 1;     // ErrorCode 1 "Failure": kullanim etkisi cozulemeyen esya (esya harcanmaz)
const MT_SILVER = 80, MT_EXP = 90;
const EQUIPMENT_CHEST_LEVEL = { 0x00d72767: 100, 0x00d728ef: 130, 0x00d728f0: 140 };

class W {
  constructor() { this.p = []; }
  u32(v) { const b = Buffer.alloc(4); b.writeUInt32BE(v >>> 0); this.p.push(b); return this; }
  i16(v) { const b = Buffer.alloc(2); b.writeInt16BE(v | 0); this.p.push(b); return this; }
  done() { return Buffer.concat(this.p); }
}
const hataRet = (op, h, tpl) => ({ ret: new W().u32(h).u32(tpl >>> 0).i16(0).done(), retId: op, once: [], hata: h });

/**
 * CS 0x01810f01. ctx = { para(awards) -> Buffer|null, odulBul(tpl) -> [{type,code,amount}]|null }
 * Donus: { retId, ret, once: [{id,payload,kaynak}], hata }
 */
function kullan(durum, payload, ctx) {
  ctx = ctx || {};
  if (!Buffer.isBuffer(payload) || payload.length !== 16 || payload.readInt16BE(0) !== 1) return hataRet(OP_USE_RET, 1, 0);
  const instance=payload.readUInt32BE(2),tpl=payload.readUInt32BE(6),count=payload.readInt16BE(10),target=payload.readUInt32BE(12);
  const art=envanter.article(tpl),items=require('./usable-items'),plan=items.resolve(tpl),account=seviye.veriOku();
  if(!art||!plan||count<0||count===0&&plan.kind!=='bag-expand')return hataRet(OP_USE_RET,1,tpl);
  if(![1,12].includes(art.majorType)||plan.kind==='route')return hataRet(OP_USE_RET,1,tpl);
  const main=seviye.anaId(),history=require('./reincarnation').record(durum,main).history;
  if(Math.max(seviye.anaDurum(account).lv,history)<art.level)return hataRet(OP_USE_RET,1,tpl);
  const bagItem=envanter.liste(durum).find(x=>x.code===tpl&&x.instance===instance);
  if(plan.kind!=='bag-expand'&&(!bagItem||bagItem.amount<count))return hataRet(OP_USE_RET,HATA_ESYA,tpl);
  const working=JSON.parse(JSON.stringify(durum)),once=[],obtained=[];
  const push=(id,payload,name)=>{if(payload)once.push({id,payload,kaynak:name});};
  const hero=target||main;
  if(['exp','fruit'].includes(plan.kind)){
    if(!require('./reincarnation').owned(working,hero,account))return hataRet(OP_USE_RET,1,tpl);
    if(seviye.heroSeviye(working,hero,account)<art.level)return hataRet(OP_USE_RET,1,tpl);
    if(plan.kind==='exp'&&(/can.?t.*main|cannot.*main/i.test(art.description)&&hero===main||seviye.heroSeviye(working,hero,account)>=seviye.MAX_LV))return hataRet(OP_USE_RET,1,tpl);
  }
  let consume=count,goldCost=0;
  if(plan.kind==='bag-expand'){
    const current=working.backpack||items.initialBag(),costs=require('./paket').cv(60108001,[]),capacity=Number(current.capacity)+Number(require('./paket').cv(60108003,10));
    if(current.count>=costs.length||capacity>envanter.MAX_GIRIS)return hataRet(OP_USE_RET,1,tpl);
    consume=Math.min(envanter.mevcut(working,tpl),Number(costs[current.count]));
    goldCost=(Number(costs[current.count])-consume)*Number(require('./paket').cv(60108004,10));
    if(goldCost>0&&(!ctx.harca||Number(account.altin||0)<goldCost))return hataRet(OP_USE_RET,16,tpl);
    working.backpack={capacity,count:Number(current.count)+1};
  }
  if(consume&&!envanter.dus(working,tpl,consume,instance))return hataRet(OP_USE_RET,HATA_ESYA,tpl);
  let rewards=[];
  if(['fixed','choice','set'].includes(plan.kind))rewards=items.roll(plan,count,Number((satir('BaseHero',hero)||{}).profession)||0,ctx.random||Math.random);
  if(plan.kind==='silver')rewards=[{type:0,code:0,amount:plan.value*count}];
  const currencies=new Set(['0:0','0:1','0:2','2:0','3:0','5:0','6:0','7:3','7:4','7:5','7:6']);
  const money=rewards.filter(x=>currencies.has(x.type+':'+x.code)),goods=rewards.filter(x=>!currencies.has(x.type+':'+x.code));
  const expected=new Map();
  for(const x of goods){const code=envanter.odulTemplate(x.type,x.code);if(!code||!envanter.article(code)||!Number.isSafeInteger(x.amount)||x.amount<=0)return hataRet(OP_USE_RET,1,tpl);expected.set(code,(expected.get(code)||envanter.mevcut(working,code))+x.amount);}
  const added=envanter.ekle(working,goods);
  for(const [code,amount]of expected)if(envanter.mevcut(working,code)!==amount)return hataRet(OP_USE_RET,1,tpl);
  require('./ekipman');
  const previousSize=envanter.liste(durum).length+require('./ekipman').cantaKayitlari(durum).length;
  if(goods.length&&(envanter.liste(working).length+require('./ekipman').cantaKayitlari(working).length>Math.max(previousSize,Math.min(envanter.MAX_GIRIS,(working.backpack||items.initialBag()).capacity))||envanter.loadBagPaketi(working).length>65527))return hataRet(OP_USE_RET,1,tpl);
  const fields={'0:0':'gumus','0:1':'altin','0:2':'kupon','3:0':'askeriEmir','5:0':'prestij','6:0':'generalsSoul','7:3':'blueSoul','7:4':'purpleSoul','7:5':'goldSoulV','7:6':'orangeSoul'};
  for(const x of money){const field=fields[x.type+':'+x.code];if(field&&(Number(account[field])||0)+x.amount>2000000000)return hataRet(OP_USE_RET,1,tpl);}
  if(money.length){if(!ctx.para)return hataRet(OP_USE_RET,1,tpl);const p=ctx.para(money,working);if(!p)return hataRet(OP_USE_RET,1,tpl);push(OP_BASEINFO,p,'KULLAN-money');}
  if(goldCost){const p=ctx.harca([{type:0,code:1,amount:goldCost}]);if(!p)return hataRet(OP_USE_RET,16,tpl);push(OP_BASEINFO,p,'KULLAN-expand-gold');}
  if(plan.kind==='hero'){
    if(count!==1||!ctx.nhanNhanVat)return hataRet(OP_USE_RET,1,tpl);
    const p=ctx.nhanNhanVat(plan.hero,working);if(!p)return hataRet(OP_USE_RET,1,tpl);push(0x01180c02,p,'KULLAN-hero');
  }
  if(plan.kind==='title'){
    if(count!==1||!satir('AchievementTitle',plan.title))return hataRet(OP_USE_RET,1,tpl);
    const titles=require('./titles');if(!titles.grant(working,plan.title))return hataRet(OP_USE_RET,1,tpl);
    push(0x01185203,titles.info(working),'KULLAN-title-owned');push(0x01185204,titles.change(working),'KULLAN-title');titles.stats(working,push);
  }
  if(plan.kind==='exp'){
    if(!(plan.value>0))return hataRet(OP_USE_RET,1,tpl);
    const r=seviye.heroExpEkle(working,hero,plan.value*count);
    push(OP_BASEINFO,seviye.expHedefPaketi(hero,r.exp),'KULLAN-exp');
  }
  if(plan.kind==='fruit'){
    working.fruits=working.fruits||{};const values=working.fruits[String(hero)]=working.fruits[String(hero)]||[0,0,0,0];values[plan.attribute]+=plan.value*count;
    push(0x01180104,require('./ekipman').statPaketi(working,hero,seviye.heroSeviye(working,hero)),'KULLAN-fruit');
  }
  if(plan.kind==='merits'){if(!working.lonca||!working.lonca.id)return hataRet(OP_USE_RET,1,tpl);working.lonca.exploit=(Number(working.lonca.exploit)||0)+count;push(0x01182507,require('./lonca').bilgiPaketi(working),'KULLAN-merits');}
  if(plan.kind==='partner-expand')working.heroAddSlotNum=(Number(working.heroAddSlotNum)||0)+plan.value*count;
  if(plan.kind==='topup-card'){
    const v=seviye.veriOku();v.vipExp=Math.min(2000000000,(Number(v.vipExp)||0)+plan.value*count);
    const vip=tablo('VipConfig').liste.filter(x=>Number(x.chargeCount)<=v.vipExp).sort((a,b)=>b._id-a._id)[0];
    v.vipLevel=Math.max(Number(v.vipLevel)||0,vip?vip._id:0);seviye.veriYaz(v);
    working.cardTopup=(Number(working.cardTopup)||0)+plan.value*count;
    push(OP_BASEINFO,require('./harita').baseInfoUpdate([{index:14,v:v.vipLevel},{index:17,v:v.vipExp}]),'KULLAN-topup-card');
  }
  if(plan.kind==='vip-trial'){
    if(count!==1)return hataRet(OP_USE_RET,1,tpl);
    const v=seviye.veriOku();if((Number(v.vipLevel)||0)>=plan.level)return hataRet(OP_USE_RET,1,tpl);
    working.vipTrial={previous:Number(v.vipLevel)||0,level:plan.level,expires:Math.floor(Date.now()/1000)+plan.hours*3600};v.vipLevel=plan.level;seviye.veriYaz(v);
    push(OP_BASEINFO,require('./harita').baseInfoUpdate([{index:14,v:plan.level}]),'KULLAN-vip-trial');
  }
  push(envanter.OP_NTF,envanter.kazancPaketi(working,added),'KULLAN-loot');
  if(consume){const p=envanter.guncellemePaketi(working,tpl,plan.kind==='bag-expand'?envanter.instanceOf(tpl):instance);push(p.id,p.payload,'KULLAN-consumed');}
  push(items.OP_STATE,items.statePacket(working,{lastItem:tpl,lastQuantity:count}),'KULLAN-state');
  for(const x of rewards)obtained.push({type:x.type,code:x.code,amount:x.amount});
  const w=new W().u32(0).u32(tpl).i16(obtained.length);for(const x of obtained)w.i16(x.type).u32(x.code).u32(x.amount);
  Object.assign(durum,working);
  return {retId:OP_USE_RET,ret:w.done(),once,hata:0,tpl,adet:count,ad:art.ad};
}

/** CS 0x01810f03. ctx = { para(awards) -> Buffer|null } */
function sat(durum, payload, ctx) {
  ctx = ctx || {};
  const w = new W();
  if (!payload || payload.length < 2) return { retId: OP_SELL_RET, ret: w.u32(HATA_ESYA).u32(0).u32(0).done(), once: [], hata: HATA_ESYA };
  const n = payload.readInt16BE(0);
  const kalemler = [];
  for (let i = 0; i < n && 2 + 10 * i + 10 <= payload.length; i++) {
    const o = 2 + 10 * i;
    kalemler.push({ instance: payload.readUInt32BE(o), tpl: payload.readUInt32BE(o + 4), adet: Math.max(1, payload.readInt16BE(o + 8)) });
  }
  // once hepsini dogrula (yarim satis olmasin)
  let toplam = 0;
  const istenen = new Map();
  for (const k of kalemler) {
    const art = envanter.article(k.tpl);
    if (!art) return { retId: OP_SELL_RET, ret: w.u32(HATA_ESYA).u32(0).u32(0).done(), once: [], hata: HATA_ESYA };
    istenen.set(k.tpl, (istenen.get(k.tpl) || 0) + k.adet);
    toplam += art.sellPrice * k.adet;
  }
  for (const [tpl, adet] of istenen) if (envanter.mevcut(durum, tpl) < adet) return { retId: OP_SELL_RET, ret: w.u32(HATA_ESYA).u32(0).u32(0).done(), once: [], hata: HATA_ESYA };
  const once = [];
  for (const k of kalemler) {
    envanter.dus(durum, k.tpl, k.adet, k.instance);
    const g = envanter.guncellemePaketi(durum, k.tpl, k.instance);
    if (g) once.push({ id: g.id, payload: g.payload, kaynak: 'SAT-dusum' });
  }
  if (toplam > 0 && ctx.para) { const p = ctx.para([{ type: 0, code: 0, amount: toplam }]); if (p) once.push({ id: OP_BASEINFO, payload: p, kaynak: 'SAT-gumus' }); }
  w.u32(0).u32(Math.floor(toplam / 4294967296) >>> 0).u32(toplam >>> 0);
  return { retId: OP_SELL_RET, ret: w.done(), once, hata: 0, toplam, adet: kalemler.length };
}

module.exports = { kullan, sat, OP_USE_RET, OP_SELL_RET, HATA_ESYA, HATA_KULLANILAMAZ };
