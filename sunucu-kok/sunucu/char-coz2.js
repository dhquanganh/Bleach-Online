'use strict';
const fs = require('fs'); const path = require('path');
const ZAMAN = path.join(__dirname, 'zaman', 'p');
const f = fs.readdirSync(ZAMAN).find(x => x.includes('s2c') && x.includes('01180102'));
const b = fs.readFileSync(path.join(ZAMAN, f));
let p = 0;
const u32 = () => { const v = b.readUInt32BE(p); p += 4; return v; };
const s16 = () => { const v = b.readInt16BE(p); p += 2; return v; };
const u16 = () => { const v = b.readUInt16BE(p); p += 2; return v; };
const s8 = () => { const v = b.readInt8(p); p += 1; return v; };
const u8 = () => { const v = b[p]; p += 1; return v; };
const utf = () => { const n = u16(); const s = b.subarray(p, p + n).toString('utf8'); p += n; return s; };

// BasicProperties
u32(); u32(); utf(); u32(); u32(); utf(); u32(); u32(); u32(); u32(); u32(); u32(); u32(); u32(); u32(); u32(); u16(); u8(); u32(); u32(); u32(); u32(); u32(); u32(); u32();
const bpEnd = p;

function parseEquipRef() {
  u8(); // category
  // base inventory CommonProperties (15)
  u32(); u32(); u16(); u8(); u32();
  // equipment properties
  u8(); u8(); // upgradingLevel, holeAddQty
  const appendCount = u16(); p += appendCount * 10;
  u32(); u32(); // weaponSkillID, flushSpiritLevel
  const gifted = u16(); p += gifted * 5;
  // mounted equip -> no special processing
}
function parseHero() {
  const s = p;
  u32(); u32(); u32(); u32(); u8(); u8(); u32();
  const adv = s16(); for (let i = 0; i < adv; i++) { u8(); u32(); u32(); }
  for (let i = 0; i < 8; i++) u32();
  s8(); s8(); s8(); u32(); s8(); u16();
  u32(); u8(); // skill
  const ba = u16(); p += ba * 4;
  const pv = u16(); p += pv * 4;
  u16(); p += 16; u16(); p += 16; // growrate
  const eqOff = p; // eqCount offset (minimal giris burada biter)
  const eq = u16(); for (let i = 0; i < eq; i++) parseEquipRef();
  const cj = u16(); p += cj * 17;
  return { s, e: p, ba, pv, eq, cj, adv, eqCountRel: eqOff - s };
}

const heroCount = u16();
const heroStart = p;
const heroes = [];
for (let i = 0; i < heroCount; i++) heroes.push(parseHero());
const afterHeros = p;
console.log('bpEnd', bpEnd, 'heroCount', heroCount, 'hero0', JSON.stringify(heroes[0]), 'afterHeros', afterHeros, 'kalan', b.length - p);
// tail: KnifeSoul(8) + FreshGuide(utf) + ...
const ksId = u32(); const ksCh = u32();
const fg = utf();
console.log('KnifeSoul', ksId.toString(16), ksCh.toString(16), 'FreshGuide="' + fg + '"', 'sonKalan', b.length - p);
console.log('sonKalan hex:', [...b.subarray(p)].map(x => x.toString(16).padStart(2, '0')).join(' '));
fs.writeFileSync(path.join(__dirname, 'char-yapi.json'), JSON.stringify({ bpEnd, heroCount, heroCountOffset: bpEnd, heroStart, heroEntry: [heroes[0].s, heroes[0].e], heroLen: heroes[0].e - heroes[0].s, afterHeros, total: b.length }, null, 2));
