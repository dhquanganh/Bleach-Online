'use strict';
const {test}=require('node:test'),assert=require('node:assert/strict'),http=require('node:http'),fs=require('node:fs'),path=require('node:path');
const {ObjectId}=require('mongodb');
const {startAuth}=require('./auth-service.cjs');
const {passwordHash,newFiles,ROOT,connect}=require('./accounts.cjs');
test('Admin edits any account, safely stops active workers, adds valid heroes, and persists changes', {timeout:120000}, async()=>{
  const port=17430,base=`http://127.0.0.1:${port}`,app=await startAuth(port),ids=[new ObjectId(),new ObjectId(),new ObjectId()];
  const suffix=Date.now().toString(36),names=ids.map((_,i)=>`manage_${suffix}_${i}`);
  const server=http.createServer(async(req,res)=>{try{if(!await app.handle(req,res,new URL(req.url,base).pathname)){res.writeHead(404);res.end()}}catch(e){res.writeHead(500);res.end(e.message)}});
  await new Promise(r=>server.listen(port,'127.0.0.1',r));
  async function request(route,cookie,method='GET',data){const response=await fetch(base+route,{method,redirect:'manual',headers:{'Content-Type':'application/json',...(cookie?{Cookie:cookie}:{})},body:data?JSON.stringify(data):undefined});return response}
  async function get(route,cookie){const response=await request(route,cookie);assert.equal(response.status,200,await response.clone().text());return response.json()}
  try{
    const hash=await passwordHash('testing123');
    for(const [index,id] of ids.entries()){
      const files=newFiles(names[index],id.toHexString());
      const state=JSON.parse(files['oyuncu.json']);state.karakter={nick:names[index],anaId:11100004,profession:1,gender:0};state.kadro={'11100004':6};files['oyuncu.json']=JSON.stringify(state);
      await app.db.collection('accounts').insertOne({_id:id,username:names[index],passwordHash:hash,role:index===0?'admin':'player'});
      await app.db.collection('players').insertOne({_id:id,files});
    }
    const cookies=[];
    for(const name of names){const r=await request('/auth/login',null,'POST',{username:name,password:'testing123'});assert.equal(r.status,200);cookies.push(r.headers.get('set-cookie').split(';')[0])}
    assert.equal((await request('/auth/admin/accounts')).status,401);
    assert.equal((await request('/auth/admin/accounts',cookies[1])).status,403);
    assert.equal((await request('/admin',cookies[0])).status,200);
    assert.equal((await request('/admin/legacy',cookies[1])).status,403);
    const rows=await get('/auth/admin/accounts',cookies[0]);assert.ok(ids.every(id=>rows.accounts.some(a=>a.id===id.toHexString())));assert.ok(rows.accounts.every(a=>!('passwordHash' in a)));
    const route='/auth/admin/accounts/'+ids[1].toHexString();
    let target=await get(route,cookies[0]);
    const offlineDir=path.join(ROOT,'.accounts',ids[1].toHexString());fs.mkdirSync(offlineDir,{recursive:true});
    const offline=await app.db.collection('players').findOne({_id:ids[1]});
    const unsynced={...offline.files},currency=JSON.parse(unsynced['veri.json']);currency.altin=123456;unsynced['veri.json']=JSON.stringify(currency);
    fs.writeFileSync(path.join(offlineDir,'pending.json'),JSON.stringify({files:unsynced}));
    target=await get(route,cookies[0]);assert.equal(target.values.altin,123456,'Offline journal is preserved before editing');
    assert.equal((await request(route,cookies[1],'PATCH',{revision:target.revision,values:{altin:44}})).status,403);
    assert.equal((await request(route,cookies[0],'PATCH',{revision:target.revision,values:{altin:-1}})).status,400);
    assert.equal((await request(route,cookies[0],'PATCH',{revision:target.revision,values:{role:'admin'}})).status,400);
    let response=await request(route,cookies[0],'PATCH',{revision:target.revision,values:{altin:654321,level:45,vipLevel:8},nick:'Admin Gift'});
    assert.equal(response.status,200,await response.clone().text());target=(await response.json()).account;assert.equal(target.values.altin,654321);assert.equal(target.nick,'Admin Gift');
    assert.equal((await request(route,cookies[0],'PATCH',{revision:'stale',values:{altin:1}})).status,409);
    const catalog=(await get('/auth/admin/heroes',cookies[0])).heroes;assert.ok(catalog.some(h=>h.id===11120920));assert.ok(!catalog.some(h=>[11120901,11120903,11120910].includes(h.id)));
    assert.equal((await request(route+'/heroes',cookies[0],'POST',{revision:target.revision,heroId:11120901,level:20})).status,400);
    response=await request(route+'/heroes',cookies[0],'POST',{revision:target.revision,heroId:11120920,level:39});assert.equal(response.status,200,await response.clone().text());target=(await response.json()).account;assert.ok(target.heroes.some(h=>h.id===11120920&&h.level===39));
    assert.equal((await request(route+'/heroes',cookies[0],'POST',{revision:target.revision,heroId:11120920,level:39})).status,409);
    const profile=await get('/yerel/oturum.json',cookies[1]);
    target=await get(route,cookies[0]);assert.equal(target.online,true);
    response=await request(route,cookies[0],'PATCH',{revision:target.revision,values:{altin:777777}});assert.equal(response.status,200,await response.clone().text());assert.equal((await response.json()).disconnected,true);
    const relog=await get('/yerel/oturum.json',cookies[1]);assert.notEqual(relog.gatewayPort,profile.gatewayPort);
    const cached=JSON.parse(fs.readFileSync(path.join(ROOT,'.accounts',ids[1].toHexString(),'veri.json')));assert.equal(cached.altin,777777);assert.ok(cached.herolar.includes(11120920));
    const other=await get('/auth/admin/accounts/'+ids[2].toHexString(),cookies[0]);assert.notEqual(other.values.altin,777777);assert.ok(!other.heroes.some(h=>h.id===11120920));
    const saved=await app.db.collection('players').findOne({_id:ids[1]});assert.ok(saved.adminChanges.length>=3);
  }finally{
    await app.close();await new Promise(r=>server.close(r));const {client,db}=await connect();
    for(const id of ids){await db.collection('sessions').deleteMany({accountId:id});await db.collection('players').deleteOne({_id:id});await db.collection('accounts').deleteOne({_id:id});for(const dir of [path.join(ROOT,'.accounts',id.toHexString()),path.join(ROOT,'.accounts','arena-cache',id.toHexString())])fs.rmSync(dir,{recursive:true,force:true})}
    await client.close();
  }
});
