'use strict';
// Yakalanan char paketini (0x01180102) BasicProperties'e gore parse edip kalan yapiyi cikarir.
const fs = require('fs'); const path = require('path');
const ZAMAN = path.join(__dirname, 'zaman', 'p');
// char paketi dosyasini bul
const f = fs.readdirSync(ZAMAN).find(x => x.includes('s2c') && x.includes('01180102'));
if (!f) { console.log('char paketi bulunamadi'); process.exit(1); }
const b = fs.readFileSync(path.join(ZAMAN, f));
console.log('char payload:', b.length, 'bayt');

let p = 0;
const u32 = () => { const v = b.readUInt32BE(p); p += 4; return v; };
const u16 = () => { const v = b.readUInt16BE(p); p += 2; return v; };
const u8 = () => { const v = b[p]; p += 1; return v; };
const utf = () => { const n = u16(); const s = b.subarray(p, p + n).toString('utf8'); p += n; return s; };
const hexAt = (off, n) => [...b.subarray(off, off + n)].map(x => x.toString(16).padStart(2, '0')).join(' ');

// BasicProperties
const bp = {};
bp.agentOp = u32(); bp.server = u32(); bp.agentUser = utf();
bp.roleHi = u32(); bp.roleLo = u32(); bp.nick = utf();
bp.country = u32(); bp.militaryRank = u32(); bp.prestige = u32();
bp.silverHi = u32(); bp.silverLo = u32(); bp.gold = u32(); bp.gift = u32(); bp.military = u32();
bp.vipLevel = u32(); bp.vipExp = u32();
bp.backpackCap = u16(); bp.backpackExpand = u8();
bp.townID = u32(); bp.starMapIndex = u32(); bp.generalsSoul = u32();
bp.blueSoul = u32(); bp.purpleSoul = u32(); bp.goldSoul = u32(); bp.orangeSoul = u32();
console.log('BasicProperties bitti @', p, JSON.stringify(bp, null, 1));
console.log('kalan:', b.length - p, 'bayt');
console.log('kalanin ilk 64 bayti:\n', hexAt(p, 64));
// kalanda okunur string var mi (bolum ipuclari)
let strs = [];
for (let i = p; i < b.length - 2; i++) {
  const n = b.readUInt16BE(i);
  if (n > 2 && n < 40 && i + 2 + n <= b.length) {
    const s = b.subarray(i + 2, i + 2 + n).toString('utf8');
    if (/^[\x20-\x7e]+$/.test(s)) strs.push({ off: i, s });
  }
}
console.log('kalanda olasi stringler:', JSON.stringify(strs.slice(0, 10)));
