'use strict';
const { test } = require('node:test');
const assert = require('node:assert/strict');
const http = require('node:http');
const net = require('node:net');
const fs = require('node:fs');
const path = require('node:path');
const { ObjectId } = require('mongodb');
const { startAuth } = require('./auth-service.cjs');
const { passwordHash, newFiles, ROOT } = require('./accounts.cjs');
const { frame, parseStream } = require('./sunucu/cerceve');
test('Real offline account roster, authenticated matching and native Arena packet layout', { timeout: 120000 }, async () => {
  const port = 17426, base = `http://127.0.0.1:${port}`, app = await startAuth(port);
  const ids = [new ObjectId(), new ObjectId()], suffix = Date.now().toString(36);
  const server = http.createServer(async (req,res) => {
    try { if (!await app.handle(req,res,new URL(req.url,base).pathname)) { res.writeHead(404);res.end(); } }
    catch(e) { res.writeHead(500);res.end(e.message); }
  });
  let socket;
  await new Promise(resolve => server.listen(port,'127.0.0.1',resolve));
  try {
    for (const [index,id] of ids.entries()) {
      const username = `arena_${suffix}_${index}`, files = newFiles(username,id.toHexString());
      const account = JSON.parse(files['oyuncu.json']);
      account.karakter = { nick: username, profession: 1, gender: 0, anaId: 11100004 };
      account.kadro = { '11100004': 6 };
      files['oyuncu.json'] = JSON.stringify(account);
      await app.db.collection('accounts').insertOne({ _id:id, username, role:'player', passwordHash:await passwordHash('testing123') });
      await app.db.collection('players').insertOne({ _id:id, files });
    }
    const login = await fetch(base+'/auth/login',{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({username:`arena_${suffix}_0`,password:'testing123'})});
    assert.equal(login.status,200);
    const cookie = login.headers.get('set-cookie').split(';')[0];
    const profileResponse = await fetch(base+'/yerel/oturum.json',{headers:{Cookie:cookie}});
    assert.equal(profileResponse.status,200,await profileResponse.clone().text());
    const profile = await profileResponse.json(), control = `http://127.0.0.1:${Number(profile.gatewayPort)+2}`;
    assert.equal((await fetch(control+'/arena-matching/opponents')).status,401);
    const roster = await (await fetch(control+'/arena-matching/opponents',{headers:{Cookie:cookie}})).json();
    const opponent = roster.opponents.find(row => row.name === `arena_${suffix}_1`);
    assert.ok(opponent,'Offline real account appears');
    assert.ok(!roster.opponents.some(row => row.name === `arena_${suffix}_0`),'Self excluded');
    assert.ok(roster.opponents.every(row => !row.name.startsWith('Bot ')));
    assert.ok(!('units' in opponent));
    socket = net.connect(Number(profile.gatewayPort),'127.0.0.1');
    let pending=Buffer.alloc(0), received=[];
    socket.on('data',chunk => { const decoded=parseStream(Buffer.concat([pending,chunk]));pending=decoded.rest;received.push(...decoded.packets); });
    await new Promise((resolve,reject) => { socket.once('connect',resolve);socket.once('error',reject); });
    const token=Buffer.from(profile.token), auth=Buffer.alloc(2+token.length);auth.writeUInt16BE(token.length);token.copy(auth,2);socket.write(frame(0x01810001,auth));
    async function waitFor(id) {
      for(let i=0;i<100;i++) { const found=received.find(p=>p.id===id);if(found)return found;await new Promise(r=>setTimeout(r,50)); }
      throw Error('Missing packet '+id.toString(16));
    }
    await waitFor(0x01180102);received=[];
    socket.write(frame(0x01811904,Buffer.alloc(9)));
    assert.notEqual((await waitFor(0x01181904)).payload.readUInt32BE(0),0,'Unknown targets rejected');
    assert.ok(!received.some(p=>p.id===0x01181907));received=[];
    const payload=Buffer.alloc(9);payload.writeUInt32BE(opponent.id0);payload.writeUInt32BE(opponent.id1,4);
    socket.write(frame(0x01811904,payload));
    const battle=await waitFor(0x01181904);await waitFor(0x01181907);
    function verifyBattle(packet) {
      assert.equal(packet.payload.readUInt32BE(0),0);
      assert.equal(packet.payload.readUInt32BE(4),0,'Embedded single result');
      assert.equal(packet.payload.readUInt16BE(9),0,'No invented rewards');
      const report=require('./sunucu/kodek').decodeBattleReport(packet.payload.subarray(11));
      assert.equal(report.player2.roles[0].roleId,11100004);
    }
    verifyBattle(battle);received=[];
    const match=await fetch(control+'/arena-matching/match',{method:'POST',headers:{Cookie:cookie,'Content-Type':'application/json'},body:JSON.stringify({id0:opponent.id0,id1:opponent.id1})});
    assert.equal(match.status,200,await match.clone().text());assert.equal((await match.json()).started,true);
    verifyBattle(await waitFor(0x01181904));await waitFor(0x01181907);
  } finally {
    if(socket)socket.destroy();
    await app.close();await new Promise(resolve=>server.close(resolve));
    const {client,db}=await require('./accounts.cjs').connect();
    for(const id of ids) {
      await db.collection('sessions').deleteMany({accountId:id});await db.collection('players').deleteOne({_id:id});await db.collection('accounts').deleteOne({_id:id});
      for(const dir of [path.join(ROOT,'.accounts',id.toHexString()),path.join(ROOT,'.accounts','arena-cache',id.toHexString())]) fs.rmSync(dir,{recursive:true,force:true});
    }
    await client.close();
  }
});
