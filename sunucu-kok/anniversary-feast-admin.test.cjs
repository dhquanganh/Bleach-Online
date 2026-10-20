'use strict';
const {test}=require('node:test'),assert=require('node:assert/strict'),fs=require('node:fs'),os=require('node:os'),path=require('node:path'),{spawnSync}=require('node:child_process');
const {createAdmin}=require('./admin-accounts.cjs');
test('Hot Sale admin API: authorization, validation, stale writes and cross-process configuration',async()=>{
 const dir=fs.mkdtempSync(path.join(os.tmpdir(),'bleach-feast-')),file=path.join(dir,'config.json'),previous=process.env.BLEACH_FEAST_CONFIG;process.env.BLEACH_FEAST_CONFIG=file;
 const handle=createAdmin({body:async req=>req.data,serial:async(key,fn)=>fn()});
 async function call(method,data,role='admin'){let out;await handle({method,data},{},'/auth/admin/anniversary-feast',{account:{role}},(status,value)=>out={status,value});return out;}
 try{
  assert.equal((await call('GET',null,'player')).status,403);
  const initial=(await call('GET')).value;assert.equal(initial.heroId,11150045);
  for(const data of [{heroId:1,price:100,revision:1},{heroId:11120950,price:-1,revision:1},{heroId:11120950,price:1.5,revision:1}])assert.equal((await call('PATCH',data)).status,400);
  const saved=await call('PATCH',{heroId:11120950,price:12345,revision:initial.revision});assert.equal(saved.status,200);assert.equal(saved.value.revision,2);
  assert.equal((await call('PATCH',{heroId:11150045,price:1,revision:1})).status,409);
  const worker=spawnSync(process.execPath,['-e',"process.stdout.write(JSON.stringify(require('./sunucu/anniversary-feast-config').read()))"],{cwd:__dirname,encoding:'utf8'});assert.equal(worker.status,0,worker.stderr);assert.deepEqual(JSON.parse(worker.stdout),saved.value);
  assert.equal((await call('GET')).value.heroId,11120950);
 }finally{if(previous===undefined)delete process.env.BLEACH_FEAST_CONFIG;else process.env.BLEACH_FEAST_CONFIG=previous;if(fs.existsSync(file))fs.unlinkSync(file);fs.rmdirSync(dir);}
});
