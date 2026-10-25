'use strict';
const {test}=require('node:test'),assert=require('node:assert/strict'),fs=require('node:fs'),os=require('node:os'),path=require('node:path'),{spawnSync}=require('node:child_process');
const {createAdmin}=require('./admin-accounts.cjs');
test('Hot Sale admin API: authorization, validation, stale writes and cross-process configuration',async()=>{
 const dir=fs.mkdtempSync(path.join(os.tmpdir(),'bleach-feast-')),file=path.join(dir,'config.json'),previous=process.env.BLEACH_FEAST_CONFIG;process.env.BLEACH_FEAST_CONFIG=file;
 let document;
 const db={collection(name){assert.equal(name,'game_config');return {
  async findOne(query){assert.equal(query._id,'anniversary-feast.json');return document&&structuredClone(document);},
  async updateOne(query,update,options){
   if(options?.upsert){document ||= {_id:query._id,...structuredClone(update.$setOnInsert)};return {matchedCount:1};}
   if(!document||document.data.revision!==query['data.revision'])return {matchedCount:0};
   Object.assign(document,structuredClone(update.$set));return {matchedCount:1};
  }
 };}};
 const handle=createAdmin({db,body:async req=>req.data,serial:async(key,fn)=>fn()});
 async function call(method,data,role='admin'){let out;await handle({method,data},{},'/auth/admin/anniversary-feast',{account:{role}},(status,value)=>out={status,value});return out;}
 try{
  assert.equal((await call('GET',null,'player')).status,403);
  const initial=(await call('GET')).value;assert.equal(initial.heroId,11150045);
  for(const data of [{heroId:1,price:100,revision:1},{heroId:11120950,price:-1,revision:1},{heroId:11120950,price:1.5,revision:1}])assert.equal((await call('PATCH',data)).status,400);
  const saved=await call('PATCH',{heroId:11120950,price:12345,revision:initial.revision});assert.equal(saved.status,200);assert.equal(saved.value.revision,2);assert.deepEqual(document.data,saved.value);
  assert.equal((await call('PATCH',{heroId:11150045,price:1,revision:1})).status,409);
  const worker=spawnSync(process.execPath,['-e',"process.stdout.write(JSON.stringify(require('./sunucu/anniversary-feast-config').read()))"],{cwd:__dirname,encoding:'utf8'});assert.equal(worker.status,0,worker.stderr);assert.deepEqual(JSON.parse(worker.stdout),saved.value);
  // A missing or edited worker projection cannot replace the saved MongoDB reward.
  fs.writeFileSync(file,JSON.stringify({heroId:11150045,price:1,revision:999}));
  assert.equal((await call('GET')).value.heroId,11120950);
  fs.unlinkSync(file);
  assert.deepEqual(await require('./sunucu/anniversary-feast-config').readDatabase(db),saved.value);
  assert.deepEqual(JSON.parse(fs.readFileSync(file,'utf8')),saved.value);
 }finally{if(previous===undefined)delete process.env.BLEACH_FEAST_CONFIG;else process.env.BLEACH_FEAST_CONFIG=previous;if(fs.existsSync(file))fs.unlinkSync(file);fs.rmdirSync(dir);}
});
