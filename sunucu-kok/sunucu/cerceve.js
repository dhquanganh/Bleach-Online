'use strict';
// Bleach oyun protokolü çerçeveleme (plaintext — cipher yok).
// Tel biçimi:  [uint32 BE length][uint32 BE packetID][payload...]
//   length = 4(id) + payload.length   (yani length alanının kendisi HARİÇ)
// Kaynak: TTransceiver.PacketTransmit / ReceivingPerform_* (IsCipher=false dalı)

const SIZE_LEN = 4;
const SIZE_ID = 4;

// Bir akış tamponundan tam paketleri ayıkla. Kalanı (yarım paket) döndürür.
// dönüş: { packets: [{id, payload:Buffer}], rest:Buffer }
// NOT: tel uzunluk alanı KENDİNİ de sayar -> total = SIZE_LEN + SIZE_ID + payload
function parseStream(buf) {
  const packets = [];
  let off = 0;
  while (buf.length - off >= SIZE_LEN) {
    const total = buf.readUInt32BE(off);           // tüm paket (uzunluk alanı dahil)
    if (total < SIZE_LEN + SIZE_ID) { off += 1; continue; } // bozuk
    if (buf.length - off < total) break;           // paket tamam değil
    const id = buf.readUInt32BE(off + SIZE_LEN);
    const payload = buf.subarray(off + SIZE_LEN + SIZE_ID, off + total);
    packets.push({ id, payload: Buffer.from(payload) });
    off += total;
  }
  return { packets, rest: Buffer.from(buf.subarray(off)) };
}

// Bir paketi tele yaz.  total = SIZE_LEN + SIZE_ID + payload
function frame(id, payload) {
  payload = payload || Buffer.alloc(0);
  const out = Buffer.alloc(SIZE_LEN + SIZE_ID + payload.length);
  out.writeUInt32BE(SIZE_LEN + SIZE_ID + payload.length, 0);
  out.writeUInt32BE(id >>> 0, 4);
  payload.copy(out, 8);
  return out;
}

// Opcode çözümleme yardımcıları
const CAT = {
  CS_AS: 0x01610000, CS_GM: 0x01611000, CS_CS: 0x01612000,
  SC_AS: 0x01160000, SC_GM: 0x01161000, SC_CS: 0x01162000,
  CS_CENTER: 0x01710000, SC_CENTER: 0x01170000,
  CS_LOBBY: 0x01810000, SC_LOBBY: 0x01180000,
};
function idName(id) {
  for (const [k, base] of Object.entries(CAT)) {
    if ((id & 0xffff0000) === (base & 0xffff0000) && (id & 0x0000f000) === (base & 0x0000f000)) {
      // yaklaşık kategori
    }
  }
  return '0x' + (id >>> 0).toString(16).padStart(8, '0');
}

module.exports = { parseStream, frame, idName, CAT, SIZE_LEN, SIZE_ID };
