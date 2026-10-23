'use strict';
const {test}=require('node:test'),assert=require('node:assert/strict'),fs=require('node:fs'),os=require('node:os'),path=require('node:path'),{spawnSync}=require('node:child_process');
const {createAdmin}=require('./admin-accounts.cjs');
test('Void boss admin config: validation, permissions, revision and running-worker visibility',async()=>{
 const dir=fs.mkdtempSync(path.join(os.tmpdir(),'bleach-void-')),file=path.join(dir,'void.json'),previous=process.env.BLEACH_VOID_CONFIG;process.env.BLEACH_VOID_CONFIG=file;
 const handle=createAdmin({body:async req=>req.data,serial:async(key,fn)=>fn()});
 async function call(method,data,role='admin'){let out;await handle({method,data,url:'/auth/admin/void-region'},{},'/auth/admin/void-region',{account:{role}},(status,value)=>out={status,value});return out;}
 try{
  assert.equal((await call('GET',null,'player')).status,403);
  const initial=(await call('GET')).value;assert.equal(initial.config.enemyId,12296031);assert(initial.bosses.some(e=>e.id===initial.config.enemyId));
  assert.equal(initial.bosses.filter(b=>b.source==='naruto').length,7);
  for(const enemyId of [1,-1,1.5,'12296031'])assert.equal((await call('PATCH',{enemyId,revision:1})).status,400);
  const config=require('./sunucu/void-region-config'),selected=config.catalog().find(e=>e.id!==initial.config.enemyId);
  const saved=await call('PATCH',{enemyId:selected.id,revision:1});assert.equal(saved.status,200);assert.equal(saved.value.enemyId,selected.id);assert.equal(saved.value.revision,2);
  assert.equal((await call('PATCH',{enemyId:12296031,revision:1})).status,409);
  for(const stats of [null,[],{atk:-1},{atk:1.5},{hp:199},{level:1001},{speed:1000000001},{magic:1},{def:'10'}])assert.equal((await call('PATCH',{enemyId:selected.id,revision:2,stats})).status,400);
  const custom={hp:5000000000,atk:12345,def:4321,speed:900,level:90};
  const updated=await call('PATCH',{enemyId:selected.id,revision:2,stats:custom});assert.equal(updated.status,200);assert.deepEqual(updated.value.effectiveStats,custom);assert.equal(config.enemy().hp,custom.hp);
  saved.value=updated.value;
  const worker=spawnSync(process.execPath,['-e',"process.stdout.write(JSON.stringify(require('./sunucu/void-region-config').view()))"],{cwd:__dirname,encoding:'utf8'});assert.equal(worker.status,0,worker.stderr);assert.deepEqual(JSON.parse(worker.stdout),saved.value);
 }finally{if(previous===undefined)delete process.env.BLEACH_VOID_CONFIG;else process.env.BLEACH_VOID_CONFIG=previous;if(fs.existsSync(file))fs.unlinkSync(file);fs.rmdirSync(dir);}
});
