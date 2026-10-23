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
    const itemsRoute=route+'/items';
    assert.equal((await request('/auth/admin/items?q=Mecha',cookies[1])).status,403);
    const found=(await get('/auth/admin/items?q=14130950',cookies[0])).items;
    assert.ok(found.some(x=>x.id===14130950&&/Mecha/i.test(x.name)));
    const icon=await request('/auth/admin/items/14130950/icon',cookies[0]);assert.equal(icon.status,200);assert.match(icon.headers.get('content-type'),/^image\//);
    assert.equal(found.find(x=>x.id===14130950).maxAdd,999);
    assert.equal((await get('/auth/admin/items?q=14100701',cookies[0])).items.find(x=>x.id===14100701).maxAdd,99999);
    for(const [itemId,amount] of [[0,1],[14130950,0],[14130950,1000],[14130950,1.5],[14100701,100000],[14100701,1.5],[14100161,1000]])
      assert.equal((await request(itemsRoute,cookies[0],'POST',{revision:target.revision,itemId,amount})).status,400);
    assert.equal((await request(itemsRoute,cookies[1],'POST',{revision:target.revision,itemId:14130950,amount:80})).status,403);
    assert.equal((await request(itemsRoute,cookies[0],'POST',{revision:'stale',itemId:14130950,amount:80})).status,409);
    response=await request(itemsRoute,cookies[0],'POST',{revision:target.revision,itemId:14130950,amount:80});
    assert.equal(response.status,200,await response.clone().text());let gift=await response.json();target=gift.account;assert.equal(gift.item.delivery,'mail');assert.ok(gift.item.mailId);
    response=await request(itemsRoute,cookies[0],'POST',{revision:target.revision,itemId:14130950,amount:20});
    assert.equal(response.status,200,await response.clone().text());gift=await response.json();target=gift.account;assert.equal(gift.item.delivery,'mail');
    response=await request(itemsRoute,cookies[0],'POST',{revision:target.revision,itemId:14100701,amount:99999});
    assert.equal(response.status,200,await response.clone().text());gift=await response.json();target=gift.account;assert.equal(gift.item.amount,99999);assert.equal(gift.item.delivery,'mail');
    let inventoryState=JSON.parse((await app.db.collection('players').findOne({_id:ids[1]})).files['oyuncu.json']);
    assert.equal(require('./sunucu/envanter').mevcut(inventoryState,14130950),0);
    const equipment=JSON.parse(fs.readFileSync(path.join(ROOT,'sunucu-kok/cikarim/veri-json/Article.json'),'utf8')).find(a=>[2,4,6].includes(Number(a.majorType)));
    response=await request(itemsRoute,cookies[0],'POST',{revision:target.revision,itemId:parseInt(equipment.id,16),amount:2});
    assert.equal(response.status,200,await response.clone().text());gift=await response.json();target=gift.account;
    inventoryState=JSON.parse((await app.db.collection('players').findOne({_id:ids[1]})).files['oyuncu.json']);
    assert.ok(inventoryState.posta.gelen.some(m=>m.ek.some(([id,n])=>id===parseInt(equipment.id,16)&&n===2)));
    
    const profile=await get('/yerel/oturum.json',cookies[1]);
    target=await get(route,cookies[0]);assert.equal(target.online,true);
    response=await request(itemsRoute,cookies[0],'POST',{revision:target.revision,itemId:14130950,amount:7});
    assert.equal(response.status,200,await response.clone().text());gift=await response.json();target=gift.account;
    assert.equal(gift.disconnected,false);assert.equal(target.online,true);assert.equal(gift.item.delivery,'mail');
    assert.equal((await get('/yerel/oturum.json',cookies[1])).gatewayPort,profile.gatewayPort,'Sending a mail keeps the current worker and game session');
    const onlineState=JSON.parse((await app.db.collection('players').findOne({_id:ids[1]})).files['oyuncu.json']);
    assert(onlineState.posta.gelen.some(m=>m.lo===gift.item.mailId.lo&&m.ek.some(([id,n])=>id===14130950&&n===7)));
    response=await request(route,cookies[0],'PATCH',{revision:target.revision,values:{altin:777777}});assert.equal(response.status,200,await response.clone().text());assert.equal((await response.json()).disconnected,true);
    const relog=await get('/yerel/oturum.json',cookies[1]);assert.notEqual(relog.gatewayPort,profile.gatewayPort);
    const cached=JSON.parse(fs.readFileSync(path.join(ROOT,'.accounts',ids[1].toHexString(),'veri.json')));assert.equal(cached.altin,777777);assert.ok(cached.herolar.includes(11120920));
    const other=await get('/auth/admin/accounts/'+ids[2].toHexString(),cookies[0]);assert.notEqual(other.values.altin,777777);assert.ok(!other.heroes.some(h=>h.id===11120920));
    const saved=await app.db.collection('players').findOne({_id:ids[1]});assert.ok(saved.adminChanges.length>=3);
    assert.ok(saved.adminChanges.some(x=>x.action==='add-item'&&x.itemId===14130950&&x.amount===80));
    const otherFiles=(await app.db.collection('players').findOne({_id:ids[2]})).files;
    assert.equal(require('./sunucu/envanter').mevcut(JSON.parse(otherFiles['oyuncu.json']),14130950),0);
    const saturated=JSON.parse(otherFiles['oyuncu.json']);saturated.envanter={esyalar:[{code:14130950,amount:65530}],dusulen:{}};
    await app.db.collection('players').updateOne({_id:ids[2]},{$set:{files:{...otherFiles,'oyuncu.json':JSON.stringify(saturated)}}});
    const otherRoute='/auth/admin/accounts/'+ids[2].toHexString(),full=await get(otherRoute,cookies[0]);
    assert.equal((await request(otherRoute+'/items',cookies[0],'POST',{revision:full.revision,itemId:14130950,amount:10})).status,200);
    assert.notEqual((await get(otherRoute,cookies[0])).revision,full.revision,'Full bags can receive a pending mail');
    delete saturated.karakter;
    await app.db.collection('players').updateOne({_id:ids[2]},{$set:{files:{...otherFiles,'oyuncu.json':JSON.stringify(saturated)}}});
    const uncreated=await get(otherRoute,cookies[0]);
    assert.equal((await request(otherRoute+'/items',cookies[0],'POST',{revision:uncreated.revision,itemId:14130950,amount:1})).status,400);
  }finally{
    await app.close();await new Promise(r=>server.close(r));const {client,db}=await connect();
    for(const id of ids){await db.collection('sessions').deleteMany({accountId:id});await db.collection('players').deleteOne({_id:id});await db.collection('accounts').deleteOne({_id:id});for(const dir of [path.join(ROOT,'.accounts',id.toHexString()),path.join(ROOT,'.accounts','arena-cache',id.toHexString())])fs.rmSync(dir,{recursive:true,force:true})}
    await client.close();
  }
});
