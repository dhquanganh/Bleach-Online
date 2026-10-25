'use strict';
const {test,after}=require('node:test'),assert=require('node:assert/strict'),fs=require('fs'),os=require('os'),path=require('path');
const dir=fs.mkdtempSync(path.join(os.tmpdir(),'bleach-titles-'));process.env.BLEACH_ACCOUNT_DIR=dir;const realNow=Date.now;let time=1700000000;Date.now=()=>time*1000;
const file=n=>path.join(dir,n),read=n=>JSON.parse(fs.readFileSync(file(n),'utf8')),save=d=>fs.writeFileSync(file('oyuncu.json'),JSON.stringify(d));
const titles=require('./sunucu/titles'),ach=require('./sunucu/title-achievements'),env=require('./sunucu/envanter'),{Y,O,satir,tablo}=require('./sunucu/paket');
function fixture(){time=1700000000;fs.writeFileSync(file('veri.json'),JSON.stringify({level:99,rutbe:40100001,herolar:[11110030],tumKarakterler:false,altin:100000}));const d={karakter:{anaId:11100005,nick:'Test'},kadro:{11100005:8,11110030:1,11110031:11},seviye:{herolar:{11110030:{lv:99,exp:0},11110031:{lv:99,exp:0}}}};save(d);return d;}
const use=(item,n=1)=>new Y().i16(1).u32(env.instanceOf(item)).u32(item).i16(n).u32(0).done();
after(()=>{Date.now=realNow;fs.rmSync(dir,{recursive:true,force:true});});
test('title token grants real ownership, 30-day expiry, equip/list packets and persists; reuse extends duration without stacking stats',()=>{
 const d=fixture(),item=14400001;env.ekle(d,[{type:1,code:item,amount:2}]);const useTitle=()=>require('./sunucu/canta').kullan(d,use(item),{});let r=useTitle();assert.equal(r.hata,0);assert.ok(titles.active(d,6003056));assert.equal(d.unvan.owned[6003056].expiresAt,time+2592000);assert.deepEqual(titles.equipped(d),[6003056]);assert.ok(r.once.some(p=>p.id===0x01185203));assert.ok(r.once.some(p=>p.id===0x01180104));const before=titles.bonuses(d,11100005);assert.equal(useTitle().hata,0);assert.equal(d.unvan.owned[6003056].expiresAt,time+2*2592000);assert.deepEqual(titles.bonuses(d,11100005),before);save(d);assert.deepEqual(titles.info(read('oyuncu.json')),titles.info(d));
});
test('forged, malformed and expired equip requests fail; group replacement, unequip and failed-save rollback are authoritative',()=>{
 const d=fixture(),sent=[],H=titles.handlers((id,payload)=>sent.push({id,payload})),ctx=(id,saveFn=save)=>({payload:new Y().u32(id).done(),durum:d,kaydet:saveFn});assert.notEqual(H['0x01815204'](ctx(6003056)).readUInt32BE(),0);
 titles.grant(d,6003056);titles.grant(d,6003057);assert.deepEqual(titles.equipped(d),[6003057]);const before=JSON.stringify(d);assert.notEqual(H['0x01815204'](ctx(6003056,()=>{throw Error('disk');})).readUInt32BE(),0);assert.equal(JSON.stringify(d),before);assert.equal(sent.length,0);assert.equal(H['0x01815204'](ctx(6003056)).readUInt32BE(),0);assert.deepEqual(titles.equipped(d),[6003056]);assert.equal(H['0x01815205'](ctx(6003056)).payload.readUInt32BE(),0);assert.deepEqual(titles.equipped(d),[]);time+=2592001;assert.notEqual(H['0x01815204'](ctx(6003057)).readUInt32BE(),0);assert.notEqual(H['0x01815204']({...ctx(6003057),payload:Buffer.alloc(3)}).readUInt32BE(),0);
});
test('expiry immediately removes combat buffs, prunes equipped title, emits stats and reports expired ownership instead of deleting it',()=>{
 const d=fixture();titles.grant(d,6003056);const sent=[],H=titles.handlers((id,payload)=>sent.push({id,payload}));time+=2592000;assert.deepEqual(titles.bonuses(d,11100005),[]);const packet=H['0x01815203']({durum:d,kaydet:save,payload:Buffer.alloc(0)}),o=new O(packet);assert.equal(o.u16(),0);assert.equal(o.u16(),1);assert.equal(o.u32(),6003056);assert.equal(o.i8(),1);assert.equal(o.u32(),1700000000+2592000);assert.equal(o.kalan(),0);assert.ok(sent.some(p=>p.id===0x01185204));assert.ok(sent.some(p=>p.id===0x01180104));assert.deepEqual(read('oyuncu.json').unvan.takili,[]);
});
test('scope and flat/rate attributes match both PvE/PvP stat blocks; expired and unequipped titles add nothing',()=>{
 const d=fixture(),gear=require('./sunucu/ekipman'),hero=11100005;const base=gear.statPaketi(d,hero,99);titles.grant(d,6003056);const boosted=gear.statPaketi(d,hero,99);function value(packet,index,block=0,float=false){let p=4;for(let i=0;i<block;i++)p+=2+packet.readUInt16BE(p)*4;return packet[float?'readFloatBE':'readUInt32BE'](p+2+index*4);}
 for(const b of [0,1]){for(const i of [4,6,7])assert.equal(value(boosted,i,b)-value(base,i,b),2200);assert.ok(Math.abs(value(boosted,18,b,true)-value(base,18,b,true)-.05)<1e-6);}
 const scoped=tablo('AchievementTitle').liste.find(r=>r.formationType===2&&r.notOrProp===1);titles.grant(d,scoped._id);assert.ok(titles.bonuses(d,11110030).length);assert.deepEqual(titles.bonuses(d,hero),[]);assert.deepEqual(titles.bonuses(d,11110031),[]);titles.state(d).takili=[];assert.ok(gear.statPaketi(d,hero,99).equals(base));
});
test('legacy saves migrate only equipped/claimed titles and never unlock the captured sample title list',()=>{
 const d=fixture();d.unvan={takili:[6003056,1,6003056]};titles.prune(d);assert.deepEqual(titles.equipped(d),[6003056]);assert.deepEqual(Object.keys(d.unvan.owned),['6003056']);assert.ok(d.unvan.owned[6003056].expiresAt>time);const clean=fixture();assert.equal(new O(titles.info(clean)).u16(),0);assert.deepEqual(titles.state(clean).owned,{});
});
test('item handler commits before success notifications; failed title save preserves token and ownership',()=>{
 const d=fixture(),h=require('./sunucu/handlers');env.ekle(d,[{type:1,code:14400001,amount:1}]);const before=JSON.stringify(d);h.ekAl();h.byReq['0x01810f01']({payload:use(14400001),durum:d,kaydet:()=>{throw Error('disk');}});assert.equal(JSON.stringify(d),before);const queued=h.ekAl().sonra;assert.equal(queued.length,1);assert.equal(queued[0].id,0x01180f08);assert.notEqual(queued[0].payload.readUInt32BE(),0);
});
test('achievement claim checks server progress, grants configured title/rewards once and recovers interrupted writes',()=>{
 const d=fixture(),a=tablo('Achievement').liste.find(a=>a.f8&&JSON.parse(a.conditonString).every(c=>c.type===12)),sent=[];assert.ok(a);const ctx={durum:d,payload:new Y().u32(a._id).done(),kaydet:save};let v=read('veri.json');v.level=1;fs.writeFileSync(file('veri.json'),JSON.stringify(v));assert.notEqual(ach.claim(ctx,(...p)=>sent.push(p)).readUInt32BE(),0);assert.equal(d.basari?.[a._id],undefined);v.level=159;fs.writeFileSync(file('veri.json'),JSON.stringify(v));assert.equal(ach.claim({...ctx,kaydet:()=>{throw Error('disk');}},(...p)=>sent.push(p)).readUInt32BE(),0);assert.ok(titles.active(d,a.f8));assert.equal(read('oyuncu.json').basari[a._id],1);ach.recover();assert.notEqual(ach.claim(ctx,()=>{}).readUInt32BE(),0);assert.equal(read('veri.json').titlePending,undefined);
});
test('permanent grants reject duplicates; timed tokens reject bulk use and renew expired ownership',()=>{
 const d=fixture(),permanent=tablo('AchievementTitle').liste.find(a=>a.timeLimitNot===0);assert.ok(permanent);assert.equal(titles.grant(d,permanent._id,'achievement'),true);assert.equal(titles.grant(d,permanent._id,'achievement'),false);
 env.ekle(d,[{type:1,code:14400001,amount:2}]);const items=require('./sunucu/canta'),before=env.mevcut(d,14400001);assert.notEqual(items.kullan(d,use(14400001,2),{}).hata,0);assert.equal(env.mevcut(d,14400001),before);titles.grant(d,6003056);time+=2592001;assert.equal(titles.active(d,6003056),false);assert.equal(items.kullan(d,use(14400001),{}).hata,0);assert.equal(d.unvan.owned[6003056].expiresAt,time+2592000);
});

test('gold-spending achievement progress spans Crystal resets, excludes refunds, and instance progress is confined to the matching campaign',()=>{
 const d=fixture(),v=read('veri.json'),spending=require('./sunucu/ultimate-bp-spending');spending.earn(v,123);assert.equal(ach.progress(d,{_id:9,conditonString:'[{"type":36}]',f6:'[1000]'},v)[0].value,123);require('./sunucu/ultimate-bp-ranking').reset(d,v,'round-one');assert.equal(v.achievementGoldSpent,123);spending.earn(v,20);spending.refund(v,20);assert.equal(v.achievementGoldSpent,123);
 const campaign=tablo('Single').liste.find(c=>Number(c.startId)>0&&Number(c.endId)>=Number(c.startId));assert.ok(campaign);d.instanceProgress={'1:999':Number(campaign.startId)+1};const a={_id:9,conditonString:JSON.stringify([{type:2,value1:Number(campaign.startId)}]),f6:'[1]'};assert.equal(ach.progress(d,a,v)[0].value,0);d.instanceProgress['1:'+campaign._id]=Number(campaign.startId)+1;assert.equal(ach.progress(d,a,v)[0].value,1);
});
test('public achievement inspection uses exact role IDs and returns an error for unknown players',()=>{
 const d=fixture(),profile=require('./sunucu/player-profile');const packet=new Y().u32(0).utf('Remote').raw(ach.info(d,read('veri.json'))).done();profile.update([{id0:11,id1:22,profile:{id0:11,id1:22,payload:'AA==',achievementPayload:packet.toString('base64')}}]);assert.ok(profile.achievement({payload:new Y().u32(11).u32(22).done(),durum:d}).equals(packet));assert.notEqual(profile.achievement({payload:new Y().u32(11).u32(23).done(),durum:d}).readUInt32BE(),0);
});

test('offline Arena snapshot cache expires with the title even when save files have not changed',()=>{
 const d=fixture();titles.grant(d,6003056);const files={'oyuncu.json':JSON.stringify(d),'veri.json':JSON.stringify(read('veri.json'))},cacheKey=require('./arena-roster.cjs').cacheKey;const before=cacheKey(files,time);assert.equal(cacheKey(files,time+100),before);assert.notEqual(cacheKey(files,time+2592000),before);
});
