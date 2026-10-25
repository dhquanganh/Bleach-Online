'use strict';
const {test,after}=require('node:test'),assert=require('node:assert/strict'),fs=require('node:fs'),os=require('node:os'),path=require('node:path');
const dir=fs.mkdtempSync(path.join(os.tmpdir(),'bleach-myoboku-'));
process.env.BLEACH_ACCOUNT_DIR=dir;
process.env.BLEACH_MYOBOKU_CONFIG=path.join(dir,'config.json');
const config=require('./sunucu/myoboku-config'),service=require('./sunucu/myoboku'),inventory=require('./sunucu/envanter');
const file=name=>path.join(dir,name),read=name=>JSON.parse(fs.readFileSync(file(name),'utf8'));
const save=d=>fs.writeFileSync(file('oyuncu.json'),JSON.stringify(d));
function reset(gold=100000){fs.writeFileSync(file('veri.json'),JSON.stringify({altin:gold}));save({});config.publish({revision:1,rewards:[10,20,30,50,80,100,150,200].map(amount=>({itemId:14900001,amount,weight:1}))});}
after(()=>fs.rmSync(dir,{recursive:true,force:true}));
test('1000 gold per spin, all slots selectable, more than 8 daily spins, rewards survive reload',()=>{
 reset();let awarded=0;
 for(let n=0;n<24;n++){
  const result=service.spin({load:()=>read('oyuncu.json'),save,random:()=>n%8});
  assert.equal(result.index,n%8);assert.equal(result.gold,100000-(n+1)*1000);awarded+=result.reward.amount;
  assert.equal(inventory.mevcut(read('oyuncu.json'),14900001),awarded);
 }
 assert.equal(read('oyuncu.json').myoboku.spins,24);assert.equal(read('veri.json').myobokuPending,undefined);
});
test('insufficient gold and full item stack never charge or grant',()=>{
 reset(999);const before=fs.readFileSync(file('oyuncu.json'),'utf8');
 assert.throws(()=>service.spin({load:()=>read('oyuncu.json'),save}),{status:400});assert.equal(read('veri.json').altin,999);assert.equal(fs.readFileSync(file('oyuncu.json'),'utf8'),before);
 reset();const state={};inventory.ekle(state,[{type:1,code:14900001,amount:inventory.MAX_ADET}]);save(state);
 assert.throws(()=>service.spin({load:()=>read('oyuncu.json'),save,random:()=>0}),{status:400});assert.equal(read('veri.json').altin,100000);
});
test('interrupted player save is replayed once with matching debit and item grant',()=>{
 reset();const result=service.spin({load:()=>read('oyuncu.json'),save:()=>{throw Error('disk interruption');},random:()=>7});
 assert.equal(result.gold,99000);assert.equal(inventory.mevcut(read('oyuncu.json'),14900001),200);
 service.recover();service.recover();assert.equal(inventory.mevcut(read('oyuncu.json'),14900001),200);assert.equal(read('veri.json').altin,99000);
});
test('admin authorization, validation, database persistence, stale edits and projection recovery',async()=>{
 reset();let document;
 const db={collection(name){assert.equal(name,'game_config');return {
  async findOne(){return structuredClone(document);},
  async updateOne(query,update,options){
   if(options?.upsert){document||={_id:query._id,...structuredClone(update.$setOnInsert)};return {matchedCount:1};}
   if(document.data.revision!==query['data.revision'])return {matchedCount:0};
   Object.assign(document,structuredClone(update.$set));return {matchedCount:1};
  }
 };}};
 const handle=require('./admin-accounts.cjs').createAdmin({db,body:async req=>req.data,serial:async(key,fn)=>fn()});
 async function call(method,data,role='admin'){let result;await handle({method,data},{},'/auth/admin/myoboku',{account:{role}},(status,value)=>result={status,value});return result;}
 assert.equal((await call('GET',null,'player')).status,403);
 const initial=(await call('GET')).value;const edited=structuredClone(initial);edited.rewards[0].amount=777;edited.rewards[0].weight=5;
 for(const invalid of [null,{...edited,rewards:[]},{...edited,rewards:edited.rewards.map(r=>({...r,itemId:1}))},{...edited,rewards:edited.rewards.map(r=>({...r,weight:0}))},{...edited,rewards:edited.rewards.map(r=>({...r,amount:1000000}))}])assert.equal((await call('PATCH',invalid)).status,400);
 const result=await call('PATCH',edited);assert.equal(result.status,200);assert.equal(document.data.rewards[0].amount,777);assert.equal(config.read().rewards[0].weight,5);
 assert.equal((await call('PATCH',edited)).status,409);
 fs.unlinkSync(file('config.json'));assert.deepEqual((await call('GET')).value,result.value);
});
