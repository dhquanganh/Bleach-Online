'use strict';
const assert=require('assert'),fs=require('fs'),os=require('os'),path=require('path');
const event=require('../infinite-illusion'),env=require('../envanter'),codec=require('../kodek');
const temp=fs.mkdtempSync(path.join(os.tmpdir(),'bleach-illusion-'));
try {
 const currencyFile=path.join(temp,'veri.json');fs.writeFileSync(currencyFile,JSON.stringify({altin:100}));
 let now=1791530000,damage=300,botCalls=0,failSave=false;
 const bot={id:42,name:'Bot',levelOffset:3,heroes:[11150031],positions:[6]};
 const service=event.service({now:()=>now,currencyFile,bots:()=>[bot],random:()=>0,
  simulate:(d,b)=>{if(b)botCalls++;return {payload:Buffer.from('report'),won:false,damage:b?500:damage};}});
 const d={roleIdHi:1,roleIdLo:2,nick:'Tester',kadro:{}};
 let durable;
 const ctx={durum:d,payload:Buffer.from([0]),kaydet:next=>{if(failSave)throw Error('disk');durable=JSON.parse(JSON.stringify(next));}};
 service.tick(ctx);const initial=now;
 assert.equal(botCalls,1);now+=299;service.tick(ctx);assert.equal(botCalls,1);
 now++;service.tick(ctx);assert.equal(botCalls,2);service.tick(ctx);assert.equal(botCalls,2);
 assert.equal(d.infiniteIllusion.entries['bot:42'].damage,500);
 let result=service.fight(ctx);assert(!result.error);assert.equal(d.infiniteIllusion.entries['1:2'].damage,300);
 assert(service.fight(ctx).error);now+=15;damage=100;service.fight(ctx);
 assert.equal(d.infiniteIllusion.entries['1:2'].damage,300);now+=15;damage=900;service.fight(ctx);
 assert.equal(event.info(d,now).mine.rank,1);assert.equal(d.infiniteIllusion.entries['1:2'].damage,900);
 const before=JSON.stringify(d);ctx.payload=Buffer.from([2]);assert.equal(service.fight(ctx).error,4);assert.equal(JSON.stringify(d),before);
 ctx.payload=Buffer.from([1]);now+=15;failSave=true;assert.throws(()=>service.fight(ctx),/disk/);assert.equal(JSON.stringify(d),before);failSave=false;
 const oldDay=d.infiniteIllusion.day;now=(oldDay+1)*86400-25200;
 service.tick(ctx,false);assert.equal(d.infiniteIllusion.day,oldDay+1);assert.deepEqual(d.infiniteIllusion.entries,{});
 const mail=require('../boss-reward-mail'),parcel=d.infiniteIllusion.payouts[0],letter=d.posta.gelen[0];
 assert.equal(env.mevcut(d,event.config.stoneItemId),0);assert.equal(JSON.parse(fs.readFileSync(currencyFile)).altin,100);
 assert.equal(parcel.rank,1);assert(parcel.mailSent);assert.deepEqual(letter.ek,[[3,8000],[event.config.stoneItemId,800]]);
 service.tick(ctx);assert.equal(d.posta.gelen.length,1);
 const claimed=mail.claim(ctx,[[letter.hi,letter.lo]],currencyFile);assert(!claimed.error);
 assert.equal(d.posta.gelen[0].ek.length,0);assert(d.infiniteIllusion.payouts[0].mailClaimed);
 assert.equal(env.mevcut(d,event.config.stoneItemId),800);assert.equal(JSON.parse(fs.readFileSync(currencyFile)).altin,8100);
 service.tick(ctx);assert.equal(env.mevcut(d,event.config.stoneItemId),800);assert.equal(JSON.parse(fs.readFileSync(currencyFile)).altin,8100);
 // Recover after currency persisted but the final payout-state save failed.
 d.infiniteIllusion.payouts[0].goldDelivered=false;mail.claim(ctx,[[letter.hi,letter.lo]],currencyFile);assert.equal(JSON.parse(fs.readFileSync(currencyFile)).altin,8100);
 // Ties stay in first-achieved order, and lower results never replace a best.
 const tied={entries:{}};event.record(tied,{id:'b',damage:700,at:20});event.record(tied,{id:'a',damage:700,at:10});event.record(tied,{id:'a',damage:600,at:30});assert.deepEqual(event.ranks(tied).map(r=>r.id),['a','b']);
 event.record(tied,{id:'cap',damage:20000000000,at:40});assert.equal(tied.entries.cap.damage,10000000000);
 assert.equal(event.day(86399-25200),0);assert.equal(event.day(86400-25200),1);
 for(let i=1;i<event.config.rewards.length;i++){assert(event.config.rewards[i].gold<=event.config.rewards[i-1].gold);assert(event.config.rewards[i].stones<=event.config.rewards[i-1].stones);}
 // Full bags retain undelivered stones without losing or duplicating the gold.
 const full={roleIdHi:3,roleIdLo:4};event.state(full,now);env.ekle(full,[{type:1,code:event.config.stoneItemId,amount:65535}]);
 full.infiniteIllusion.payouts.push({id:'full-bag',gold:1000,stones:100,itemsDelivered:false,goldDelivered:false});
 const fullCtx={durum:full,kaydet:()=>{}};service.credit(fullCtx);assert(!full.infiniteIllusion.payouts[0].itemsDelivered);assert(!full.infiniteIllusion.payouts[0].goldDelivered);
 const fullLetter=full.posta.gelen[0];assert(mail.claim(fullCtx,[[fullLetter.hi,fullLetter.lo]],currencyFile).error);assert.equal(fullLetter.ek.length,2);
 const gold=JSON.parse(fs.readFileSync(currencyFile)).altin;service.credit(fullCtx);assert.equal(JSON.parse(fs.readFileSync(currencyFile)).altin,gold);
 assert.equal(env.mevcut(full,event.config.stoneItemId),65535);
 // Wire uses exact 64-bit health and the bot's actual formation and level.
 const engine=require('../savas'),botTeam=require('../cross-server-bots').all()[0];
 engine.illusionBattle({kadro:{}},null);
 const lastStats=engine.sonIstatistik(),lastDamage=engine.sonOyuncuHasari();
 assert(Buffer.isBuffer(lastStats));
 for(let i=0;i<2;i++){
  const fight=engine.illusionBattle({kadro:{}},botTeam),report=codec.decodeBattleReport(fight.payload);
  assert.equal(report._consumed,report._total);assert.equal(report.version,4);
  assert.equal(report.player2.roles[0].roleId,event.config.bossHeroId);
  assert.equal(report.player2.roles[0].curHealth,10000000000);assert.equal(report.player2.roles[0].totalHealth,10000000000);
  assert.deepEqual(report.player1.roles.map(r=>r.roleId),botTeam.heroes);
  assert(report.player1.roles.every(r=>r.level===100+botTeam.levelOffset));
  assert(fight.damage>0&&fight.damage<=10000000000);assert.equal(fight.won,false);
  assert.strictEqual(engine.sonIstatistik(),lastStats);assert.equal(engine.sonOyuncuHasari(),lastDamage);
 }
 const attacker={maxHitDamage:0x7fffffff,rebirth:{n:100,ae:8}},target={hp:10000000000,maxHp:10000000000};
 const hit=require('../reincarnation').hit(attacker,target,9000000000,()=>0);
 assert.equal(hit.damage,0x7fffffff);assert.equal(target.hp,10000000000-0x7fffffff);
 console.log('PASS Infinite Illusion: exact fresh 10B HP, native battle report, bot cadence/formation/level, best-score ranking, cooldown, UTC+7 settlement, persistent rewards, crash recovery, full-bag retention, malformed requests and save rollback. No player data changed.');
} finally {fs.rmSync(temp,{recursive:true,force:true});}
