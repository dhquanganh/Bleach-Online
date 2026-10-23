'use strict';
const assert=require('node:assert/strict'),fs=require('node:fs'),os=require('node:os'),path=require('node:path');
const dir=fs.mkdtempSync(path.join(os.tmpdir(),'void-boss-')),file=path.join(dir,'config.json'),previous=process.env.BLEACH_VOID_CONFIG;process.env.BLEACH_VOID_CONFIG=file;
const config=require('../void-region-config'),event=require('../savas-etkinlik'),battle=require('../savas'),codec=require('../kodek');
try{
 const main=require('../seviye').anaId();
 const base=structuredClone(require('../oyuncu.json'));base.kadro={[main]:15,11120920:4,11120950:10};delete base.bosDunya;
 const formation=event.voidForm(base,main);assert(formation.some(x=>x.heroId===main&&x.battlePos===15));assert(formation.some(x=>x.battlePos===4));assert(formation.some(x=>x.battlePos===10));assert.equal(new Set(formation.map(x=>x.battlePos)).size,formation.length);
 for(const enemyId of [12296031,config.catalog().find(e=>e.id!==12296031).id]){
  config.write({enemyId},config.read().revision);
  const d=structuredClone(base),state=event.voidState(d);state.submit=1;state.form=formation;
  for(let front=0;front<4;front++){const probe=structuredClone(d);assert.equal(event.voidFightEnter(probe,Buffer.from([front]),main).readUInt32BE(0),0);assert.equal(probe.bosDunya.players[0].team,front);assert(event.voidCancelFight(probe,probe.roleIdHi,probe.roleIdLo));}
  const ret=event.voidFightEnter(d,Buffer.from([0]),main);assert.equal(ret.readUInt32BE(0),0);assert.equal(event.voidFightEnter(d,Buffer.from([0]),main).readUInt32BE(0),1);
  const frames=battle.voidFightFrames(d),report=codec.decodeBattleReport(frames[0].payload);assert.equal(report._consumed,report._total);assert.equal(report.player2.roles.length,1);assert.equal(report.player2.roles[0].roleId,enemyId);
  for(const hero of formation){const actual=report.player1.roles.find(x=>x.roleId===hero.heroId);assert(actual);assert.equal(actual.pos,hero.battlePos);}
  const before=state.hp,done=event.voidFinishFight(d,d.roleIdHi,d.roleIdLo,battle.sonOyuncuHasari());assert(done);assert.equal(state.hp,before-Number(done.readBigInt64BE(8)));assert.equal(state.players.length,0);assert.equal(event.voidFinishFight(d,d.roleIdHi,d.roleIdLo,100),null);
  const metadata=config.view(),trailer=Buffer.from(JSON.stringify(metadata));assert(event.voidStatusPacket(d).subarray(-trailer.length).equals(trailer));
  const selected=config.catalog().find(e=>e.id!==enemyId);config.write({enemyId:selected.id},metadata.revision);const reset=event.voidState(d);assert.equal(reset.hurt,0);assert.equal(reset.hp,selected.hp);assert.equal(reset.enemyId,selected.id);assert.equal(reset.players.length,0);assert.deepEqual(reset.form,formation);
 }
 const ninjas=config.catalog().filter(b=>b.source==='naruto');assert.equal(ninjas.length,7);
 for(const ninja of ninjas){
  config.write({enemyId:ninja.id,stats:{hp:100000,atk:1000,def:50,speed:200,level:100}},config.read().revision);
  assert.equal(config.enemy().source,'naruto');assert.equal(config.view().roleId,ninja.id);
  const state=structuredClone(base);const frames=battle.voidFightFrames(state),report=codec.decodeBattleReport(frames[0].payload);
  assert.equal(report._consumed,report._total);assert.equal(report.player2.roles[0].roleId,ninja.id);
 }
 const custom={hp:5000000000,atk:12345,def:4321,speed:900,level:90};
 config.write({enemyId:12296031,stats:custom},config.read().revision);
 assert.equal(event.voidState(structuredClone(base)).hp,custom.hp);
 // Execute the production entry builder and capture its unit at the report boundary.
 const source=fs.readFileSync(require.resolve('../savas'),'utf8');
 const fn=source.slice(source.indexOf('function voidFightFrames('),source.indexOf('function fightPetFrames('));
 let captured;
 const run=require('node:vm').runInNewContext('('+fn+')',{require:name=>{assert.equal(name,'./void-region-config');return config},dusmanBirim:(e,pos)=>({hp:e.hp,maxHp:e.hp,pos,atk:5,def:0,speed:0}),kadroRapor:(id,x,army)=>{captured=army.birimler[0];return {payload:Buffer.alloc(0),won:false}},kodek:codec});
 run(null);assert.equal(captured.hp,1000000000);for(const key of ['atk','def','speed','level'])assert.equal(captured[key],custom[key]);
 config.write({enemyId:12296031,stats:{}},config.read().revision);assert.equal(config.view().hp,config.catalog().find(b=>b.id===12296031).hp);
 console.log('PASS Void: four-front admission/dedup, all formation lanes, dynamic boss in native report and map metadata, actual damage, boss revision reset and no double settlement. No account writes.');
}finally{if(previous===undefined)delete process.env.BLEACH_VOID_CONFIG;else process.env.BLEACH_VOID_CONFIG=previous;if(fs.existsSync(file))fs.unlinkSync(file);fs.rmdirSync(dir);}
