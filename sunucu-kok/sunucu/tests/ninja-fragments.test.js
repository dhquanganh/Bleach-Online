'use strict';
const assert=require('assert'),fs=require('fs'),path=require('path');
const env=require('../envanter'),reb=require('../reincarnation'),stars=require('../hero-stars'),shop=require('../mystic-shop'),levels=require('../seviye'),{Y,O}=require('../paket');
for(const [hero,fragment] of [[11120901,14130901],[11120903,14130903],[11120910,14130910],[11120920,14130920]]){
 assert.strictEqual(reb.fragmentId(hero),fragment);
 assert(env.article(fragment));assert(!env.article(fragment).usable);
 const account={herolar:[hero]};let d=JSON.parse(fs.readFileSync(path.join(__dirname,'../oyuncu.json')));
 d.heroStars={};d.meyhane={alinan:{[hero]:1}};levels.heroKayit(d,hero,159).lv=159;
 for(const code of [shop.config.currencyID,fragment]){const amount=env.mevcut(d,code);if(amount)env.dus(d,code,amount);}
 const offer=shop.offers(d,account).find(o=>o.heroID===hero);assert(offer);assert.strictEqual(offer.itemID,fragment);
 assert.strictEqual(offer.price.amount,100);
 const H=shop.kur({ekSonra:()=>{}},{account:()=>account});env.ekle(d,[{code:shop.config.currencyID,amount:100}]);
 const buy=H['0x01817a02']({durum:d,payload:new Y().u32(1).u32(offer.id).done(),kaydet:()=>{}});
 assert.strictEqual(buy.readUInt32BE(0),0);assert.strictEqual(env.mevcut(d,fragment),1);assert.strictEqual(env.mevcut(d,shop.config.currencyID),0);
 env.ekle(d,[{code:fragment,amount:49}]);
 const S=stars.kur({ekSonra:()=>{}});
 const up=S['0x0181f201']({durum:d,payload:new Y().u32(hero).u32(0).done(),kaydet:()=>{}});
 assert.strictEqual(JSON.parse(new O(up.payload).utf()).error,0);
 assert.strictEqual(stars.count(d,hero),1);assert.strictEqual(env.mevcut(d,fragment),0);
}
assert.notStrictEqual(reb.fragmentId(11120901),reb.fragmentId(11120903));
assert.strictEqual(reb.fragmentId(11120910),14130910);
console.log('PASS 4 ninja Modify Fragments: correct partner mapping, owned Mystic offer, exact 100-gem exchange, native inventory and 50-fragment star upgrade; no player files changed.');
