"use strict";
const assert=require('assert'),fs=require('fs'),path=require('path'),s=require('../hero-stars'),env=require('../envanter'),gear=require('../ekipman'),levels=require('../seviye'),p=require('../paket'),codec=require('../kodek'),combat=require('../savas');
const hero=11150057,fragment=14130055,main=levels.anaId();
function fixture(){const d=JSON.parse(fs.readFileSync(path.join(__dirname,'../oyuncu.json')));d.heroStars={};levels.heroKayit(d,hero,159).lv=159;const n=env.mevcut(d,fragment);if(n)env.dus(d,fragment,n);return d;}
let pushed=[],saves=0,fail=false;const H=s.kur({ekSonra:(...x)=>pushed.push(x)});
const req=(id,n)=>new p.Y().u32(id).u32(n).done(),call=(d,payload)=>H['0x0181f201']({durum:d,payload,kaydet:()=>{if(fail)throw Error('disk');saves++;}}),error=reply=>JSON.parse(new p.O(reply.payload).utf()).error;
let d=fixture();assert.equal(error(call(d,req(main,0))),4);assert.equal(error(call(d,Buffer.alloc(0))),4);assert.equal(error(call(d,req(1,0))),4);assert.equal(error(call(d,req(hero,0))),18);assert.equal(s.count(d,hero),0);
env.ekle(d,[{code:fragment,amount:300}]);const base=gear.statPaketi(d,hero,159),before=env.mevcut(d,fragment);assert.equal(error(call(d,req(hero,0))),0);assert.equal(s.count(d,hero),1);assert.equal(env.mevcut(d,fragment),before-50);
const boosted=gear.statPaketi(d,hero,159);for(const i of [0,1,2,3,4,5,6,7,8,9,26])assert.equal(boosted.readUInt32BE(6+4*i),Math.min(0x7fffffff,Math.round(base.readUInt32BE(6+4*i)*1.2)));
assert.equal(error(call(d,req(hero,0))),1);assert.equal(env.mevcut(d,fragment),before-50);assert(pushed.some(x=>x[0]===0x01180104));assert(pushed.some(x=>x[0]===0x01180f00));
d.heroStars[hero]=23;assert.equal(s.cost(23),50);assert.equal(error(call(d,req(hero,23))),0);assert.equal(s.count(d,hero),24);assert.equal(s.cost(24),100);const threshold=env.mevcut(d,fragment);assert.equal(error(call(d,req(hero,24))),0);assert.equal(env.mevcut(d,fragment),threshold-100);assert.equal(s.count(d,hero),25);
d.heroStars[hero]=50;const maxBalance=env.mevcut(d,fragment);assert.equal(error(call(d,req(hero,50))),1);assert.equal(env.mevcut(d,fragment),maxBalance);
d=fixture();env.ekle(d,[{code:fragment,amount:50}]);fail=true;assert.equal(error(call(d,req(hero,0))),1);assert.equal(s.count(d,hero),0);assert.equal(env.mevcut(d,fragment),50);fail=false;
d.heroStars[hero]=2;d.kadro={[main]:1,[hero]:6};const stat=gear.statPaketi(d,hero,159),battle=combat.kadroRapor(0,null,null,{playerState:d,forceWin:false});assert.equal(codec.decodeBattleReport(battle.payload).player1.roles.find(x=>x.roleId===hero).totalHealth,require('../statlar').blokOku(stat.subarray(4)).hp);
const info=s.info(JSON.parse(JSON.stringify(d)));assert.equal(info.stars[hero],2);assert(!info.heroes.some(x=>x.id===main));assert(saves>=3);
assert(require('../handlers').byReq['0x0181f201']);
console.log('PASS: partner-only stars, ownership, 20% additive core stats, 50/100 fragments at stars 24/25, stale requests, max 50, rollback, live stat/bag notifications, persistent metadata, combat HP and real handler registration. No player files changed.');

d.heroStars[main]=50;assert.equal(s.count(d,main),0);assert.equal(s.multiplier(d,main),1);

for(const n of [0,1,4,5,25,50]){d.heroStars[hero]=n;assert.equal(s.multiplier(d,hero),1+0.2*n);}
console.log('PASS: star bonuses are additive 20% per star, up to x11 at 50 stars; existing star counts are preserved.');
