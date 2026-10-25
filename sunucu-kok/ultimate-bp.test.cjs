'use strict';
const {test,after}=require('node:test'),assert=require('node:assert/strict'),fs=require('fs'),os=require('os'),path=require('path');
const dir=fs.mkdtempSync(path.join(os.tmpdir(),'ultimate-bp-'));process.env.BLEACH_ACCOUNT_DIR=dir;process.env.BLEACH_ULTIMATE_BP_CONFIG=path.join(dir,'config.json');
const file=n=>path.join(dir,n),read=n=>JSON.parse(fs.readFileSync(file(n),'utf8')),save=d=>fs.writeFileSync(file('oyuncu.json'),JSON.stringify(d));
const config=require('./sunucu/ultimate-bp-config'),service=require('./sunucu/ultimate-bp'),env=require('./sunucu/envanter'),spend=require('./sunucu/ultimate-bp-spending'),{Y,O}=require('./sunucu/paket');
function reset(pieces=0){config.publish(config.defaults());fs.writeFileSync(file('veri.json'),JSON.stringify({altin:1000000,herolar:[],tumKarakterler:false,ultimateBP:{pieces,remainder:0,spent:pieces*10}}));save({});}
function action(index,rev=config.read().revision,saveFn=save){const d=read('oyuncu.json');return service.operate(95,index,[rev],d,saveFn);}
after(()=>fs.rmSync(dir,{recursive:true,force:true}));
test('all real gold debits earn 1 per 10, preserve remainder across reload; no coupons, failed or invalid charges',()=>{
 reset();const h=require('./sunucu/handlers');assert.ok(h.paraHarca([{type:0,code:1,amount:9}]));assert.deepEqual(read('veri.json').ultimateBP,{pieces:0,remainder:9,spent:9});assert.ok(h.paraHarca([{type:0,code:1,amount:2}]));assert.equal(read('veri.json').ultimateBP.pieces,1);assert.equal(read('veri.json').ultimateBP.remainder,1);
 const v=read('veri.json');v.kupon=100;fs.writeFileSync(file('veri.json'),JSON.stringify(v));h.paraHarca([{type:0,code:2,amount:30}]);assert.equal(read('veri.json').ultimateBP.pieces,1);
 const before=fs.readFileSync(file('veri.json'),'utf8');for(const a of [[{type:0,code:1,amount:1000001}],[{type:0,code:1,amount:-10}],[{type:0,code:1,amount:0.5}],[{type:0,code:1,amount:600000},{type:0,code:1,amount:600000}]]){assert.equal(h.paraHarca(a),null);assert.equal(fs.readFileSync(file('veri.json'),'utf8'),before);}
 h.paraIcinOdul([{type:0,code:1,amount:100}]);assert.equal(read('veri.json').ultimateBP.pieces,1);
 h.paraHarca([{type:0,code:1,amount:99}]);assert.equal(read('veri.json').ultimateBP.pieces,11);h.paraIcinOdul([{type:0,code:1,amount:99}],null,{refund:true});assert.equal(read('veri.json').ultimateBP.pieces,1);assert.equal(read('veri.json').ultimateBP.remainder,1);h.paraHarca([{type:0,code:1,amount:100}],{rollback:true});assert.equal(read('veri.json').ultimateBP.pieces,1);
});
test('all gift milestones require real pieces, grant current rewards once per cycle, persist and never consume pieces',()=>{
 reset(499);assert.notEqual(action(2).hata,0);assert.deepEqual(read('oyuncu.json'),{});
 reset(5000);for(let i=0;i<5;i++){const r=action(i+2);assert.equal(r.hata,0);assert.deepEqual(r.oduller,config.read().rewards[i].items);assert.notEqual(action(i+2).hata,0);}
 assert.deepEqual(read('oyuncu.json').ultimateBP.claims,[1,1,1,1,1]);assert.equal(read('veri.json').ultimateBP.pieces,5000);assert.equal(env.mevcut(read('oyuncu.json'),14100074),env.mevcut({},14100074)+50);assert.equal(read('veri.json').purpleSoul,5);
 let v=read('veri.json');v.ultimateBP.pieces=5500;fs.writeFileSync(file('veri.json'),JSON.stringify(v));assert.equal(action(2).hata,0);assert.equal(env.mevcut(read('oyuncu.json'),14100074),env.mevcut({},14100074)+100);
});
test('hero uses live configured ID/price; rejects insufficient, duplicate, forged indices and stale config',()=>{
 reset(59999);assert.notEqual(action(0).hata,0);reset(60000);assert.equal(action(0).hata,0);assert.ok(read('veri.json').herolar.includes(11150037));assert.equal(read('oyuncu.json').seviye.herolar[11150037].lv,1);assert.notEqual(action(0).hata,0);assert.equal(read('veri.json').ultimateBP.pieces,60000);
 const c=config.read();c.heroId=11120992;c.price=7;c.revision++;config.publish(c);assert.notEqual(action(0,1).hata,0);assert.equal(action(0,2).hero,11120992);for(const i of [1,7,8,96,999])assert.notEqual(action(i,2).hata,0);
});
test('full stacks do not consume claims; interrupted save replays exactly once',()=>{
 reset(500);const d={};env.ekle(d,[{type:1,code:14100074,amount:env.MAX_ADET}]);save(d);assert.notEqual(action(2).hata,0);assert.equal(read('oyuncu.json').ultimateBP,undefined);
 reset(500);assert.equal(action(2,1,()=>{throw Error('disk failure');}).hata,0);service.recover();service.recover();assert.equal(env.mevcut(read('oyuncu.json'),14100074),env.mevcut({},14100074)+50);assert.equal(read('oyuncu.json').ultimateBP.claims[0],1);assert.equal(read('veri.json').ultimateBPPending,undefined);
});
test('native handler parses valid protocol, sends live config, hero/bag/currency updates; malformed requests never claim',()=>{
 reset(60000);const h=require('./sunucu/handlers');h.ekAl();let d=read('oyuncu.json');const init=h.byReq['0x01812302']({payload:new Y().u32(95).done(),durum:d,kaydet:save});const o=new O(init);assert.equal(o.u32(),95);assert.equal(o.u16(),3);assert.equal(o.u32(),2);assert.equal(o.u32(),1);assert.equal(o.u32(),9);const n=o.u16();assert.ok(n>20);assert.equal(o.u32(),60000);assert.equal(o.u32(),0);assert.equal(o.u32(),service.MAGIC);
 for(const payload of [new Y().u32(95).u32(0).done(),new Y().u32(95).u32(0).i16(2).i32(1).done()])assert.notEqual(h.byReq['0x01812303']({payload,durum:d,kaydet:save}).readUInt32BE(),0);
 const r=h.byReq['0x01812303']({payload:new Y().u32(95).u32(0).i16(1).i32(1).done(),durum:d,kaydet:save});assert.equal(r.readUInt32BE(),0);assert.ok(read('veri.json').herolar.includes(11150037));assert.ok(h.ekAl());
});
test('admin permissions, current names/icons, strict config validation, MongoDB persistence and stale-edit conflict',async()=>{
 reset(500);let document;const db={collection(){return {async findOne(){return structuredClone(document);},async updateOne(q,u,options){if(options?.upsert){document||={_id:q._id,...structuredClone(u.$setOnInsert)};return {matchedCount:1};}if(document.data.revision!==q['data.revision'])return {matchedCount:0};Object.assign(document,structuredClone(u.$set));return {matchedCount:1};}};}};
 const handle=require('./admin-accounts.cjs').createAdmin({db,serial:async(k,f)=>f(),body:async req=>req.data});async function call(method,data,role='admin'){let r;await handle({method,data},{},'/auth/admin/ultimate-bp',{account:{role}},(status,value)=>r={status,value});return r;}
 assert.equal((await call('GET',null,'player')).status,403);const current=(await call('GET')).value;assert.match(current.heroName,/Genry/i);assert.match(current.rewards[0].items[0].icon,/icon/);assert.equal(current.rewards[0].items[0].name,'Epic EXP Scroll');
 const edited=structuredClone(current);edited.price=100;edited.heroId=11120992;edited.rewards[0].items=[{type:1,code:14900001,amount:123}];for(const bad of [null,{...edited,price:-1},{...edited,heroId:1},{...edited,rewards:[]},{...edited,cycleStep:1}])assert.equal((await call('PATCH',bad)).status,400);
 const result=await call('PATCH',edited);assert.equal(result.status,200);assert.equal(document.data.heroId,11120992);assert.equal((await call('PATCH',edited)).status,409);fs.unlinkSync(file('config.json'));assert.equal((await call('GET')).value.price,100);
 assert.equal(action(2,2).hata,0);assert.equal(env.mevcut(read('oyuncu.json'),14900001),123);
});
