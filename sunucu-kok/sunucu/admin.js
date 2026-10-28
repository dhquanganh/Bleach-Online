'use strict';
// KAPSAMLI Admin Tool — Bleach ozel sunucu. Port 7421.
// veri.json'u duzenler; oyun-sunucu char paketine enjekte eder. Canli sunucu durumu + hero/item listesi.
const http = require('http');
const fs = require('fs');
const path = require('path');

const PORT = Number(process.env.BLEACH_ADMIN_PORT) || 7421;
const ROOT = path.join(__dirname, '..');
const VERI = require('./runtime-path')('veri.json');
const VARSAYILAN_DOSYA = path.join(__dirname, 'veri-varsayilan.json');
const OYUNCU = require('./runtime-path')('oyuncu.json');
const VJSON = path.join(__dirname, '..', 'cikarim', 'veri-json');

function oku() { try { return JSON.parse(fs.readFileSync(VERI, 'utf8')); } catch { return {}; } }
function yaz(o) { fs.writeFileSync(VERI, JSON.stringify(o, null, 2)); }
function jread(f, d) { try { return JSON.parse(fs.readFileSync(path.join(VJSON, f), 'utf8')); } catch { return d; } }

const CURR = [
  ['altin', 'Vàng', 999999999],
  ['gumus', 'Bạc (32 bit thấp)', 999999999],
  ['gumusHigh', 'Bạc (32 bit cao)', 0],
  ['kupon', 'Phiếu quà tặng', 999999999],
  ['askeriEmir', 'Lệnh quân sự', 999999],
];
const VIP = [['vipLevel', 'Cấp VIP', 15], ['vipExp', 'Điểm VIP', 999999]];
const KARAKTER = [['level', 'Cấp độ', 99], ['deneyim', 'Kinh nghiệm', 999999], ['prestij', 'Uy tín', 9999]];
const SOULS = [
  ['generalsSoul', 'Linh hồn tướng', 999999],
  ['blueSoul', 'Linh hồn xanh', 999999],
  ['purpleSoul', 'Linh hồn tím', 999999],
  ['goldSoulV', 'Linh hồn vàng', 999999],
  ['orangeSoul', 'Linh hồn cam', 999999],
];

function page() {
  const v = oku();
  const heroes = jread('heroes.json', []);
  const items = jread('items.json', []);
  const skills = jread('skills.json', []);
  const field = (k, ad, ph) => `<div class="row"><label>${ad}</label><input name="${k}" type="number" value="${v[k] ?? 0}"></div>`;
  const currRows = CURR.map(([k, a]) => field(k, a)).join('');
  const vipRows = VIP.map(([k, a]) => field(k, a)).join('');
  const karakterRows = KARAKTER.map(([k, a]) => field(k, a)).join('');
  const soulRows = SOULS.map(([k, a]) => field(k, a)).join('');
  const tumK = v.tumKarakterler === true || v.tumKarakterler === 'true';
  return `<!doctype html><html lang="vi"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>Bleach - Quản trị</title>
<style>
 :root{--bg:#0e1016;--card:#171a22;--line:#242833;--txt:#e7ebf0;--dim:#8b95a6;--acc:#ff5a3c;--ok:#39d98a}
 *{box-sizing:border-box} body{margin:0;background:var(--bg);color:var(--txt);font:14px/1.5 system-ui,sans-serif}
 header{padding:16px 22px;background:linear-gradient(90deg,#1a1d26,#141620);border-bottom:2px solid var(--acc);display:flex;justify-content:space-between;align-items:center}
 header h1{margin:0;font-size:18px} header .st{font-size:12px;color:var(--dim)}
 .grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(300px,1fr));gap:16px;padding:18px;max-width:1200px;margin:auto}
 .card{background:var(--card);border:1px solid var(--line);border-radius:12px;padding:16px}
 .card h2{margin:0 0 10px;font-size:15px;color:var(--acc)} .card .sub{color:var(--dim);font-size:12px;margin:-6px 0 10px}
 .row{display:flex;justify-content:space-between;align-items:center;padding:6px 0;border-bottom:1px solid var(--line)}
 .row:last-child{border:0} label{color:#c3ccd8;font-size:13px}
 input[type=number],input[type=text]{background:#0f1219;border:1px solid #2c313d;color:#fff;padding:7px 9px;border-radius:6px;width:170px;text-align:right}
 input[type=search],select{background:#0f1219;border:1px solid #2c313d;color:#fff;padding:8px 10px;border-radius:6px}
 .item-add{display:grid;gap:10px}.item-add label{display:block;margin-bottom:5px}.item-add input[type=search],.item-add select{width:100%;text-align:left}.item-add select{min-height:120px}
 button{background:var(--acc);border:0;color:#fff;padding:9px 14px;border-radius:8px;cursor:pointer;font-size:13px}
 button.sec{background:#2a2f3a} .btns{display:flex;gap:8px;flex-wrap:wrap;margin-top:12px}
 .save{width:100%;margin-top:12px;padding:12px;font-size:15px}
 .msg{color:var(--ok);margin-top:8px;min-height:18px;font-size:13px}
 .stat{display:flex;gap:18px;flex-wrap:wrap} .stat div{font-size:13px} .stat b{color:#fff}
 .list{max-height:260px;overflow:auto;border:1px solid var(--line);border-radius:8px}
 .list table{width:100%;border-collapse:collapse;font-size:12px} .list th{position:sticky;top:0;background:#1b1f29;text-align:left;padding:6px 8px;color:var(--dim)}
 .list td{padding:5px 8px;border-top:1px solid var(--line)} .pill{display:inline-block;padding:2px 7px;border-radius:20px;font-size:11px;background:#242a36;color:#9fb0c4}
 .soon{opacity:.55} .soon input{pointer-events:none}
 .tag{font-size:10px;background:#3a2018;color:#ff8a6b;padding:1px 6px;border-radius:10px;margin-left:6px}
 a{color:#6fb3ff}
</style></head><body>
<header><h1>⚔️ Bleach - Bảng quản trị máy chủ riêng</h1><div class="st" id="durum">Đang tải trạng thái…</div></header>
<div class="grid">

 <div class="card"><h2>💰 Tiền tệ</h2><div class="sub">Áp dụng vào dữ liệu nhân vật khi đăng nhập lại.</div>
   <form data-f>${currRows}
     <div class="btns"><button type="button" onclick="maxCurr(this)" class="sec">Đặt tất cả tối đa</button><button type="button" onclick="zero(this)" class="sec">Đặt về 0</button></div>
     <button class="save">Lưu</button><div class="msg"></div></form></div>

 <div class="card"><h2>👑 VIP</h2><div class="sub">Cấp VIP và điểm VIP.</div>
   <form data-f>${vipRows}
     <div class="btns"><button type="button" onclick="setv(this,'vipLevel',15)" class="sec">VIP cấp 15</button></div>
     <button class="save">Lưu</button><div class="msg"></div></form></div>

 <div class="card"><h2>🎭 Nhân vật</h2><div class="sub">Cấp độ, kinh nghiệm và uy tín.</div>
   <form data-f>${karakterRows}
     <div class="row"><label>Mở khóa tất cả nhân vật</label><input name="tumKarakterler" type="checkbox" ${tumK ? 'checked' : ''}></div>
     <div class="btns"><button type="button" onclick="setv(this,'level',99)" class="sec">Cấp độ 99</button><button type="button" onclick="setv(this,'level',1)" class="sec">Cấp độ 1</button></div>
     <button class="save">Lưu</button><div class="msg"></div></form></div>

 <div class="card"><h2>🔮 Linh hồn</h2><div class="sub">Các loại linh hồn dùng trong trò chơi.</div>
   <form data-f>${soulRows}
     <div class="btns"><button type="button" onclick="maxSoul(this)" class="sec">Đặt tất cả tối đa</button><button type="button" onclick="zero(this)" class="sec">Đặt về 0</button></div>
     <button class="save">Lưu</button><div class="msg"></div></form></div>

 <div class="card"><h2>⚡ Thiết lập nhanh</h2><div class="sub">Áp dụng cấu hình có sẵn chỉ với một lần nhấn.</div>
   <div class="btns">
     <button type="button" onclick="onayla('/preset-max','Đặt tất cả về tối đa? (VIP 15, tiền tệ, linh hồn và nhân vật)')">💎 Tối đa mọi thứ</button>
     <button type="button" class="sec" onclick="onayla('/preset-baslangic','Khôi phục trạng thái bắt đầu? (Cấp 1, 500.000 bạc, chưa tạo nhân vật)')">🌱 Bắt đầu mới</button>
   </div>
   <p class="sub">Sau khi áp dụng, hãy khởi động lại trò chơi.</p><div class="msg" id="presetMsg"></div></div>

 <div class="card" style="border-color:#5a2418"><h2>♻️ Khôi phục / xóa dữ liệu</h2>
   <div class="sub">Xóa túi đồ, tiến độ và tiền; sau đó khôi phục dữ liệu mặc định.</div>
   <div class="btns"><button type="button" style="background:#c0392b" onclick="onayla('/sifirla','XÓA TOÀN BỘ DỮ LIỆU? Túi đồ, tiến độ và tiền sẽ được đặt lại mặc định. Không thể hoàn tác.')">🗑️ Xóa dữ liệu và khôi phục mặc định</button></div>
   <p class="sub">Hãy khởi động lại trò chơi sau khi đặt lại.</p><div class="msg" id="sifirMsg"></div></div>

 <div class="card" style="grid-column:1/-1"><h2>📊 Trạng thái máy chủ</h2>
   <div class="stat" id="stat"><div>Đang kết nối…</div></div></div>

 <div class="card"><h2>🦸 Anh hùng <span class="pill">${heroes.length}</span></h2>
   <div class="sub">Danh sách dữ liệu anh hùng trong trò chơi.</div>
   <div class="list"><table><thead><tr><th>ID</th><th>Tên</th><th>Phẩm chất</th><th>Sức mạnh</th></tr></thead><tbody>
   ${heroes.slice(0, 200).map(h => `<tr><td>${h.id}</td><td>${h.name}</td><td>${h.quality}</td><td>${h.power}</td></tr>`).join('')}
   </tbody></table></div></div>

 <div class="card"><h2>🎒 Vật phẩm <span class="pill">${items.length}</span></h2>
   <div class="sub">Danh sách dữ liệu vật phẩm trong trò chơi.</div>
   <div class="list"><table><thead><tr><th>ID</th><th>Tên</th><th>Phẩm chất</th><th>Giá bán</th></tr></thead><tbody>
   ${items.slice(0, 200).map(it => `<tr><td>${it.id}</td><td>${it.name}</td><td>${it.quality}</td><td>${it.sellPrice}</td></tr>`).join('')}
   </tbody></table></div></div>

 <div class="card"><h2>➕ Thêm vật phẩm vào túi</h2>
   <div class="sub">Tìm theo tên hoặc ID. Vật phẩm được lưu vào dữ liệu người chơi; hãy đăng nhập lại để thấy thay đổi.</div>
   <form class="item-add" id="addItemForm">
     <div><label for="itemSearch">Tìm vật phẩm</label><input id="itemSearch" type="search" placeholder="Nhập ít nhất 2 ký tự…" autocomplete="off"></div>
     <div><label for="itemChoice">Kết quả tìm kiếm</label><select id="itemChoice" size="5" required aria-label="Chọn vật phẩm"></select></div>
     <div class="row"><label for="itemAmount">Số lượng (1–999; sách EXP: 1–99999)</label><input id="itemAmount" type="number" min="1" max="999" step="1" value="1" required></div>
     <button class="save" type="submit">Thêm vào túi</button>
     <div class="msg" id="addItemMsg" aria-live="polite"></div>
   </form>
 </div>

 <div class="card"><h2>✨ Kỹ năng <span class="pill">${skills.length}</span></h2>
   <div class="sub">Danh sách dữ liệu kỹ năng trong trò chơi.</div>
   <div class="list"><table><thead><tr><th>ID kỹ năng</th><th>Tên</th></tr></thead><tbody>
   ${skills.slice(0, 200).map(s => `<tr><td>${s.skillId}</td><td>${s.name}</td></tr>`).join('')}
   </tbody></table></div></div>

</div>
<script>
 async function refreshStat(){
   try{const d=await (await fetch('/durum')).json();
     document.getElementById('durum').textContent = d.oyunSunucu? '🟢 Máy chủ trò chơi đang chạy':'🔴 Máy chủ trò chơi đã tắt';
     document.getElementById('stat').innerHTML =
       '<div>Máy chủ trò chơi: <b>'+(d.oyunSunucu?'đang chạy':'đã tắt')+'</b></div>'+
       '<div>Máy chủ tệp (7420): <b>'+(d.dosya?'đang chạy':'đã tắt')+'</b></div>'+
       '<div>Vàng: <b>'+d.altin+'</b></div><div>Cấp VIP: <b>'+d.vipLevel+'</b></div>'+
       '<div>Kết cấu đã trích xuất: <b>'+d.doku+'</b></div><div>Ảnh PNG/JPG: <b>'+d.png+'</b></div>';
   }catch(e){}
 }
 document.querySelectorAll('form[data-f]').forEach(f=>{
   f.onsubmit=async e=>{e.preventDefault();const d={};
     f.querySelectorAll('input').forEach(i=>{ if(i.type==='checkbox') d[i.name]=i.checked; else if(i.type==='number') d[i.name]=Number(i.value); else d[i.name]=i.value; });
     await fetch('/kaydet',{method:'POST',headers:{'content-type':'application/json'},body:JSON.stringify(d)});
    f.querySelector('.msg').textContent='✓ Đã lưu. Đăng nhập lại để áp dụng.'; setTimeout(()=>f.querySelector('.msg').textContent='',3000); refreshStat();};
 });
 function maxCurr(b){const f=b.closest('form');f.querySelector('[name=altin]').value=999999999;f.querySelector('[name=gumus]').value=999999999;f.querySelector('[name=kupon]').value=999999999;f.querySelector('[name=askeriEmir]').value=999999;}
 function maxSoul(b){b.closest('form').querySelectorAll('input[type=number]').forEach(i=>i.value=999999);}
 function zero(b){b.closest('form').querySelectorAll('input[type=number]').forEach(i=>i.value=0);}
 function setv(b,k,val){b.closest('form').querySelector('[name='+k+']').value=val;}
 async function onayla(url,soru){ if(!confirm(soru)) return; const r=await fetch(url,{method:'POST'}); const el=document.getElementById(url==='/sifirla'?'sifirMsg':'presetMsg'); el.textContent = r.ok?'✓ Đã áp dụng. Hãy khởi động lại trò chơi.':'✗ Đã xảy ra lỗi'; setTimeout(()=>location.reload(),1200); }
 const itemSearch=document.getElementById('itemSearch'),itemChoice=document.getElementById('itemChoice'),itemMsg=document.getElementById('addItemMsg');let itemSearchTimer;
 itemSearch.addEventListener('input',()=>{clearTimeout(itemSearchTimer);const q=itemSearch.value.trim();itemChoice.replaceChildren();if(q.length<2){itemMsg.textContent='Nhập ít nhất 2 ký tự để tìm.';return;}itemMsg.textContent='Đang tìm…';itemSearchTimer=setTimeout(async()=>{try{const r=await fetch('/api/admin/items?q='+encodeURIComponent(q));if(!r.ok)throw new Error();const list=await r.json();list.forEach(x=>{const option=new Option(x.label,x.id);option.dataset.maxAdd=x.maxAdd;itemChoice.add(option);});updateItemAmount();itemMsg.textContent=list.length?'Chọn vật phẩm trong danh sách.':'Không tìm thấy vật phẩm.';}catch(e){itemMsg.textContent='✗ Không tải được danh sách vật phẩm.';}},180);});
 function updateItemAmount(){const option=itemChoice.selectedOptions[0],max=option&&option.dataset.maxAdd==='99999'?99999:999;document.getElementById('itemAmount').max=String(max);document.querySelector('label[for=itemAmount]').textContent='S? l??ng (1?'+max+')';}
 itemChoice.addEventListener('change',updateItemAmount);
 document.getElementById('addItemForm').addEventListener('submit',async e=>{e.preventDefault();const button=e.currentTarget.querySelector('button[type=submit]');button.disabled=true;itemMsg.textContent='Đang thêm…';try{const r=await fetch('/api/admin/item-add',{method:'POST',headers:{'content-type':'application/json'},body:JSON.stringify({id:itemChoice.value,amount:document.getElementById('itemAmount').value})});const d=await r.json();if(!r.ok||!d.ok)throw new Error(d.hata||'Không thể thêm vật phẩm');itemMsg.textContent='\u0110\u00e3 g\u1eedi th\u01b0: '+d.name+' x '+d.amount+'. M\u1edf th\u01b0 trong game v\u00e0 nh\u1eadn \u0111\u00ednh k\u00e8m; kh\u00f4ng c\u1ea7n F5.';}catch(err){itemMsg.textContent='✗ '+err.message;}finally{button.disabled=false;}});
 refreshStat(); setInterval(refreshStat,4000);
</script></body></html>`;
}

function durum() {
  const v = oku();
  const net = require('net');
  const check = (port) => new Promise(res => { const s = net.connect(port, '127.0.0.1'); s.setTimeout(400); s.on('connect', () => { s.destroy(); res(true); }); s.on('error', () => res(false)); s.on('timeout', () => { s.destroy(); res(false); }); });
  return Promise.all([check(Number(process.env.BLEACH_PORT) || 10025), check(7420)]).then(([oyun, dosya]) => {
    let doku = 0, png = 0;
    try { doku = walkCount(path.join(ROOT, 'kaynak'), '.texclient'); } catch { }
    try { png = walkCount(path.join(ROOT, 'cikarim', 'png'), '.png') + walkCount(path.join(ROOT, 'cikarim', 'png'), '.jpg'); } catch { }
    return { oyunSunucu: oyun, dosya, altin: v.altin, vipLevel: v.vipLevel, doku, png };
  });
}
function walkCount(dir, ext) { let n = 0; for (const e of fs.readdirSync(dir, { withFileTypes: true })) { const p = path.join(dir, e.name); if (e.isDirectory()) n += walkCount(p, ext); else if (e.name.toLowerCase().endsWith(ext)) n++; } return n; }

// ---- KARAKTER SHOP: oyundaki TUM gecerli karakterler; eklenen hesaba yazilir (kalici) ----
const herolarMod = require('./herolar');
function heroListesi() {
  const ad = new Map(jread('BaseHero.json', []).map(h => [parseInt(h.id, 16) >>> 0, h]));
  return herolarMod.gecerliHerolar().filter(h => h.id !== 11120940).map(h => {
    const b = ad.get(h.id) || {};
    return { id: h.id, name: b.name || ('#' + h.id), quality: Number(b.quality) || 0, assess: b.assess || '', profession: Number(b.profession) || 0 };
  }).sort((a, b) => (b.quality - a.quality) || String(a.name).localeCompare(String(b.name)));
}
function shopPage() {
  return `<!doctype html><html lang="vi"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>Cửa hàng nhân vật</title>
<style>
 :root{--bg:#0e1016;--card:#171a22;--line:#242833;--txt:#e7ebf0;--dim:#8b95a6;--acc:#ff5a3c;--ok:#39d98a}
 *{box-sizing:border-box}body{margin:0;height:100vh;height:100dvh;overflow:hidden;display:flex;flex-direction:column;background:var(--bg);color:var(--txt);font:14px/1.5 system-ui,sans-serif}
 header{padding:12px 20px;background:linear-gradient(90deg,#1a1d26,#141620);border-bottom:2px solid var(--acc);display:flex;gap:14px;align-items:center;flex-wrap:wrap;flex:none}
 header h1{margin:0;font-size:17px} a{color:#6fb3ff}
 .tabs{display:flex;gap:4px;padding:8px 20px 0;background:#131620;border-bottom:1px solid var(--line);flex:none}
 .tab{background:transparent;border:0;border-bottom:2px solid transparent;color:var(--dim);padding:8px 12px;cursor:pointer;font-size:13px}
 .tab.active{color:#fff;border-bottom-color:var(--acc)}
 .bar{padding:10px 20px;display:flex;gap:8px;flex-wrap:wrap;align-items:center;background:#131620;border-bottom:1px solid var(--line);flex:none}
 button{background:var(--acc);border:0;color:#fff;padding:9px 14px;border-radius:8px;cursor:pointer;font-size:13px}
 button.sec{background:#2a2f3a} input[type=search]{background:#0f1219;border:1px solid #2c313d;color:#fff;padding:8px 10px;border-radius:6px;min-width:min(220px,100%);flex:1;max-width:420px}
 .msg{color:var(--ok);font-size:13px;margin-left:auto}
 .wrap{padding:12px 20px;max-width:1240px;width:100%;margin:0 auto;flex:1;min-height:0;overflow:auto}
 table{width:100%;min-width:560px;border-collapse:collapse;font-size:13px;background:var(--card);border:1px solid var(--line);border-radius:8px;overflow:hidden}
 th{position:sticky;top:0;z-index:1;background:#1b1f29;text-align:left;padding:9px 10px;color:var(--dim);font-weight:600}
 td{padding:7px 10px;border-top:1px solid var(--line)}
 tr.sahip{background:#16241c} .q{display:inline-block;min-width:22px;text-align:center;padding:1px 6px;border-radius:10px;background:#242a36;font-size:11px}
 .sw{cursor:pointer;user-select:none}
</style></head><body>
<header><h1>🦸 Cửa hàng nhân vật</h1><a href="/">← Bảng quản trị</a><span id="say" style="color:var(--dim)"></span></header>
<nav class="tabs" role="tablist" aria-label="Lọc nhân vật">
 <button class="tab active" type="button" role="tab" aria-selected="true" data-filter="all">Tất cả</button>
 <button class="tab" type="button" role="tab" aria-selected="false" data-filter="owned">Đã sở hữu</button>
 <button class="tab" type="button" role="tab" aria-selected="false" data-filter="unowned">Chưa sở hữu</button>
</nav>
<div class="bar">
 <input type="search" id="ara" placeholder="Tìm theo tên hoặc ID…" oninput="ciz()">
 <button class="sec" type="button" onclick="hepsi(true)">Chọn tất cả</button>
 <button class="sec" type="button" onclick="hepsi(false)">Bỏ chọn tất cả</button>
 <button type="button" onclick="kaydet()">Lưu thay đổi</button>
 <span class="msg" id="msg"></span>
</div>
<main class="wrap"><table><thead><tr><th style="width:70px">Có</th><th>Tên nhân vật</th><th style="width:110px">ID</th><th style="width:100px">Phẩm chất</th><th style="width:80px">Đánh giá</th></tr></thead><tbody id="tb"></tbody></table></main>
<script>
let HEPSI=[],SAHIP=new Set(),FILTRE='all';
async function yukle(){try{const r=await fetch('/hero-liste');if(!r.ok)throw new Error('Lỗi tải dữ liệu');const d=await r.json();HEPSI=d.hepsi;SAHIP=new Set(d.sahip.map(Number));ciz();}catch(e){document.getElementById('tb').innerHTML='<tr><td colspan="5">Không tải được danh sách nhân vật. Hãy kiểm tra máy chủ quản trị.</td></tr>';}}
function ciz(){const q=(document.getElementById('ara').value||'').toLowerCase();
 const l=HEPSI.filter(h=>{const owned=SAHIP.has(Number(h.id));if(FILTRE==='owned'&&!owned)return false;if(FILTRE==='unowned'&&owned)return false;return !q||String(h.name).toLowerCase().includes(q)||String(h.id).includes(q);});
 document.getElementById('tb').innerHTML=l.map(h=>{const s=SAHIP.has(h.id);
  return '<tr class="'+(s?'sahip':'')+'"><td><input type="checkbox" class="sw" '+(s?'checked':'')+' onchange="sec('+h.id+',this.checked)"></td><td>'+h.name+'</td><td>'+h.id+'</td><td><span class="q">'+h.quality+'</span></td><td>'+(h.assess||'-')+'</td></tr>';}).join('');
 document.getElementById('say').textContent='Đang hiển thị '+l.length+' / '+HEPSI.length+' · '+SAHIP.size+' nhân vật được cấp';}
function sec(id,v){v?SAHIP.add(id):SAHIP.delete(id);ciz();}
function hepsi(v){SAHIP=v?new Set(HEPSI.map(h=>h.id)):new Set();ciz();}
async function kaydet(){const m=document.getElementById('msg');try{const r=await fetch('/hero-kaydet',{method:'POST',headers:{'content-type':'application/json'},body:JSON.stringify({herolar:[...SAHIP]})});if(!r.ok)throw new Error('Lưu thất bại');m.textContent='✓ Đã lưu. Khởi động lại trò chơi để cập nhật.';}catch(e){m.textContent='✗ Không lưu được. Hãy kiểm tra máy chủ quản trị.';}setTimeout(()=>m.textContent='',4000);}
document.querySelectorAll('[data-filter]').forEach(b=>b.addEventListener('click',()=>{FILTRE=b.dataset.filter;document.querySelectorAll('[data-filter]').forEach(x=>{const active=x===b;x.classList.toggle('active',active);x.setAttribute('aria-selected',active?'true':'false');});ciz();}));
yukle();
</script></body></html>`;
}

// ================== OYUN-ICI KARAKTER MAGAZASI API (launcher.html'deki katman kullanir) ==================
// Fiyat: kaliteye gore altin (ozel sunucu ekonomisi; degistirmek icin bu tablo).
const FIYAT_KALITE = { 0: 20000, 1: 20000, 2: 20000, 3: 50000, 4: 100000, 5: 200000, 6: 400000, 7: 800000 };
const FIYAT_UST = 1500000;
const HOT_HERO_ID = 11140008;
const HOT_HERO_PRICE = 500000;
const PROF_AD = { 1: 'Çeviklik', 2: 'Savunma', 3: 'Zeka', 4: 'Güç', 5: 'Büyücü' };
function fiyat(q) { return FIYAT_KALITE[q] !== undefined ? FIYAT_KALITE[q] : FIYAT_UST; }
function karakterFiyati(hero) { return hero.id === HOT_HERO_ID ? HOT_HERO_PRICE : fiyat(hero.quality); }
function oyuncuOku() { try { return JSON.parse(fs.readFileSync(OYUNCU, 'utf8')); } catch { return {}; } }
function sahipKumesi(v) {
  const s = new Set((Array.isArray(v.herolar) ? v.herolar : []).map(Number).filter(Boolean));
  try { for (const k of Object.keys((oyuncuOku().meyhane || {}).alinan || {})) s.add(Number(k)); } catch { }
  return s;
}
function magazaListesi() {
  const v = oku();
  const sahip = sahipKumesi(v);
  const hepsi = v.tumKarakterler === true || v.tumKarakterler === 'true';
  return {
    altin: Number(v.altin) || 0, level: Number(v.level) || 1, nick: v.nick || '', tumKarakterler: hepsi,
    liste: overlayHeroListesi().map(h => ({ ...h, meslek: PROF_AD[h.profession] || '', hot: h.id === HOT_HERO_ID, fiyat: karakterFiyati(h), sahip: hepsi || sahip.has(h.id) })),
  };
}
// Custom Naruto heroes/summons use the reserved 111209xx IDs.
// Restrict the sale catalog without removing ownership or admin recruitment.
function overlayHeroListesi() { return heroListesi().filter(h => (h.id < 11120900 || h.id > 11120999) && h.id !== 11121001 && h.id !== 11121003 && h.id !== 11121005 && h.id !== 11121006 && h.id !== 11121007); }
const GIA_THIET_BI = { 1: 100, 2: 200, 3: 400, 4: 800, 5: 1600, 6: 3200, 7: 6400 };
const LOAI_THIET_BI = { 2: 'Thiết bị', 4: 'Bảo vật', 6: 'Trang sức' };
function giaThietBi(quality, level) {
  const giaCoSo = GIA_THIET_BI[Number(quality)] || 1000;
  return giaCoSo * Math.max(1, Math.floor(Number(level) || 1));
}
function danhSachThietBi() {
  const durumMod = require('./durum');
  const ekipmanMod = require('./ekipman');
  const articles = jread('Article.json', []);
  const durum = durumMod.yukle();
  const e = ekipmanMod.depo(durum);
  const sahip = new Map();
  for (const [inst, x] of Object.entries(e.esyalar)) {
    const id = Number(x.tpl) >>> 0;
    const durumItem = sahip.get(id) || { count: 0, equipped: 0, instance: 0 };
    durumItem.count++;
    if (ekipmanMod.takiliMi(e, inst)) durumItem.equipped++;
    else if (!durumItem.instance) durumItem.instance = Number(inst) >>> 0;
    sahip.set(id, durumItem);
  }
  const liste = articles.filter(a => ekipmanMod.EKIPMAN_KAT.has(Number(a.majorType))).map(a => {
    const id = parseInt(a.id, 16) >>> 0;
    const durumItem = sahip.get(id) || { count: 0, equipped: 0, instance: 0 };
    const quality = Number(a.quality) || 1;
    const price = giaThietBi(quality, a.level);
    return {
      instance: durumItem.instance, id, picture: Number(a.picture) || id, name: a.name || ('#' + id), quality,
      level: Number(a.level) || 1, category: Number(a.majorType), type: LOAI_THIET_BI[Number(a.majorType)] || 'Thiết bị', price, buyPrice: price * 2,
      ownedCount: durumItem.count, equippedCount: durumItem.equipped
    };
  }).sort((a, b) => (a.level - b.level) || (b.quality - a.quality) || a.name.localeCompare(b.name));
  return { altin: Number(durum.altin) || 0, toplamSahip: [...sahip.values()].reduce((n, x) => n + x.count, 0), liste };
}
// HeadIcon .TexClient -> gomulu JPEG/PNG (renk katmani). Format: zlib "surface"ler icinde JPEG/PNG (tex-cikar.js).
const zlib = require('zlib');
const IKON_ONBELLEK = new Map();
function ikonBul(id, klasor) {
  klasor = klasor || 'HeadIcon';
  const hex = (Number(id) >>> 0).toString(16).toUpperCase().padStart(8, '0');
  const anahtar = klasor + ':' + hex;
  if (IKON_ONBELLEK.has(anahtar)) return IKON_ONBELLEK.get(anahtar);
  let sonuc = null;
  try {
    const base = path.join(ROOT, 'kaynak', 'login.gogames.me', 'public');
    const surumler = fs.readdirSync(base).sort().reverse();
    for (const s of surumler) {
      const f = path.join(base, s, 'Resources', 'Textures', klasor, hex + '.TexClient');
      if (!fs.existsSync(f)) continue;
      const buf = fs.readFileSync(f);
      const yuzeyler = [];
      for (let i = 0; i + 1 < buf.length; i++) if (buf[i] === 0x78 && (buf[i + 1] === 0x9c || buf[i + 1] === 0xda || buf[i + 1] === 0x01)) { try { const d = zlib.inflateSync(buf.subarray(i)); if (d.length > 16) yuzeyler.push(d); } catch { } }
      for (const y of yuzeyler.length ? yuzeyler : [buf]) {
        for (let i = 0; i + 4 < y.length; i++) {
          if (y[i] === 0xff && y[i + 1] === 0xd8 && y[i + 2] === 0xff) { let j = i + 2; for (; j + 1 < y.length; j++) if (y[j] === 0xff && y[j + 1] === 0xd9) break; if (j + 1 < y.length) { sonuc = { tip: 'image/jpeg', veri: Buffer.from(y.subarray(i, j + 2)) }; break; } }
          if (y[i] === 0x89 && y[i + 1] === 0x50 && y[i + 2] === 0x4e && y[i + 3] === 0x47) { const end = y.indexOf(Buffer.from([0x49, 0x45, 0x4e, 0x44, 0xae, 0x42, 0x60, 0x82]), i); if (end > i) { sonuc = { tip: 'image/png', veri: Buffer.from(y.subarray(i, end + 8)) }; break; } }
        }
        if (sonuc) break;
      }
      if (sonuc) break;
    }
  } catch { }
  IKON_ONBELLEK.set(anahtar, sonuc);
  return sonuc;
}
function apiIsle(req, res) {
  const u = new URL(req.url, 'http://x');
  const cors = { 'Access-Control-Allow-Origin': req.headers.origin || process.env.BLEACH_WEB_ORIGIN || 'http://127.0.0.1:7420', 'Access-Control-Allow-Credentials': 'true', 'Access-Control-Allow-Methods': 'GET,POST,OPTIONS', 'Access-Control-Allow-Headers': 'content-type', 'Cache-Control': 'no-store' };
  const json = (code, o) => { res.writeHead(code, { ...cors, 'content-type': 'application/json; charset=utf-8' }); res.end(JSON.stringify(o)); };
  if (req.method === 'OPTIONS') { res.writeHead(204, cors); return res.end(); }
  if (u.pathname === '/api/hesap') { const v = oku(); return json(200, { altin: Number(v.altin) || 0, gumus: Number(v.gumus) || 0, kupon: Number(v.kupon) || 0, level: Number(v.level) || 1, nick: v.nick || '', vipLevel: Number(v.vipLevel) || 0, sahip: [...sahipKumesi(v)] }); }
  if (u.pathname === '/api/admin/items' && req.method === 'GET') {
    const q = (u.searchParams.get('q') || '').trim().toLowerCase();
    if (q.length < 2) return json(200, []);
    const items = jread('Article.json', []).filter(a => {
      const idHex = String(a.id || '');
      const id = parseInt(idHex, 16) >>> 0;
      return String(a.name || '').toLowerCase().includes(q) || idHex.toLowerCase().includes(q) || String(id).includes(q);
    }).slice(0, 60).map(a => {
      const id = parseInt(a.id, 16) >>> 0;
      return { id, maxAdd:require('./admin-item-limits').maxAdd(a), label: `${a.name || '(không tên)'} · ID ${id} · phẩm chất ${Number(a.quality) || 0}` };
    });
    return json(200, items);
  }
  if (u.pathname === '/api/admin/item-add' && req.method === 'POST') {
    let b = ''; req.on('data', c => b += c);
    req.on('end', async () => {
      try {
        const input = JSON.parse(b || '{}');
        const id = Number(input.id), amount = Number(input.amount);
        const maxAmount=require('./admin-item-limits').maxAdd(require('./envanter').article(id));
        if (!Number.isSafeInteger(id) || id <= 0 || id > 0xffffffff || !Number.isInteger(amount) || amount < 1 || amount > maxAmount) {
          return json(400, { ok: false, hata: `Số lượng: nhập số nguyên từ 1 đến ${maxAmount}.` });
        }
        require('./ekipman');
        const envanter = require('./envanter');
        const article = envanter.article(id);
        if (!article) return json(400, { ok: false, hata: 'Không tìm thấy vật phẩm trong Article' });
        const delivered=require('./oyun-sunucu').sendAdminItemMail(id,amount);
        return json(200, { ok: true, id, name: article.ad || `#${id}`, amount, delivery:'mail', ...delivered });
      } catch (e) { return json(400, { ok: false, hata: 'Yêu cầu không hợp lệ' }); }
    });
    return true;
  }
  if (u.pathname === '/api/karakterler') return json(200, magazaListesi());
  if (u.pathname === '/api/thiet-bi') return json(200, danhSachThietBi());
  if (u.pathname === '/api/thiet-bi/ban' && req.method === 'POST') {
    let b = ''; req.on('data', c => b += c);
    req.on('end', () => {
      try {
        const instance = Number(JSON.parse(b || '{}').instance) >>> 0;
        const durumMod = require('./durum');
        const ekipmanMod = require('./ekipman');
        const durum = durumMod.yukle();
        const e = ekipmanMod.depo(durum);
        const item = e.esyalar[String(instance)];
        if (!instance || !item || ekipmanMod.takiliMi(e, instance)) return json(400, { ok: false, hata: 'Không tìm thấy thiết bị có thể bán' });
        const article = jread('Article.json', []).find(a => (parseInt(a.id, 16) >>> 0) === (Number(item.tpl) >>> 0));
        if (!article || !ekipmanMod.EKIPMAN_KAT.has(Number(article.majorType))) return json(400, { ok: false, hata: 'Vật phẩm này không thể bán tại đây' });
        const price = giaThietBi(article.quality, article.level);
        const v = oku();
        const currentGold = Number(v.altin) || 0;
        if (currentGold >= 999999999) return json(400, { ok: false, hata: 'Vàng đã đạt giới hạn' });
        const received = Math.min(price, 999999999 - currentGold);
        delete e.esyalar[String(instance)];
        v.altin = currentGold + received;
        yaz(v);
        durum.altin = v.altin;
        durumMod.kaydet(durum);
        console.log(`[magaza] equipment sold: ${article.name} (${item.tpl}) +${received} gold -> ${v.altin}`);
        return json(200, { ok: true, altin: v.altin, received, name: article.name, quality: Number(article.quality) || 1 });
      } catch (e) { return json(400, { ok: false, hata: 'Yêu cầu không hợp lệ' }); }
    });
    return true;
  }
  if (u.pathname === '/api/thiet-bi/mua' && req.method === 'POST') {
    let b = ''; req.on('data', c => b += c);
    req.on('end', () => {
      try {
        const id = Number(JSON.parse(b || '{}').id) >>> 0;
        const article = jread('Article.json', []).find(a => (parseInt(a.id, 16) >>> 0) === id);
        const ekipmanMod = require('./ekipman');
        if (!id || !article || !ekipmanMod.EKIPMAN_KAT.has(Number(article.majorType))) return json(400, { ok: false, hata: 'Không tìm thấy thiết bị' });
        const durumMod = require('./durum');
        const durum = durumMod.yukle();
        const e = ekipmanMod.depo(durum);
        if (Object.values(e.esyalar).some(x => (Number(x.tpl) >>> 0) === id)) return json(400, { ok: false, hata: 'Bạn đã sở hữu thiết bị này' });
        const price = giaThietBi(article.quality, article.level) * 2;
        const v = oku();
        const currentGold = Number(v.altin) || 0;
        if (currentGold < price) return json(400, { ok: false, hata: 'Không đủ vàng (cần ' + price.toLocaleString('vi-VN') + ')' });
        const instance = ekipmanMod.yeniEsya(e, id);
        if (!instance) return json(400, { ok: false, hata: 'Không thể thêm thiết bị vào túi' });
        require('./ultimate-bp-spending').earn(v,price);
        v.altin = currentGold - price;
        yaz(v);
        durum.altin = v.altin;
        durumMod.kaydet(durum);
        console.log(`[magaza] equipment bought: ${article.name} (${id}) -${price} gold -> ${v.altin}`);
        return json(200, { ok: true, altin: v.altin, price, name: article.name, quality: Number(article.quality) || 1, level: Number(article.level) || 1 });
      } catch (e) { return json(400, { ok: false, hata: 'Yêu cầu không hợp lệ' }); }
    });
    return true;
  }
  if (u.pathname.startsWith('/api/ikon/')) {
    const ik = ikonBul(u.pathname.slice('/api/ikon/'.length));
    if (!ik) { res.writeHead(404, cors); return res.end(); }
    res.writeHead(200, { ...cors, 'content-type': ik.tip, 'Cache-Control': 'public, max-age=86400' }); return res.end(ik.veri);
  }
  if (u.pathname.startsWith('/api/item-ikon/')) {
    const ik = ikonBul(u.pathname.slice('/api/item-ikon/'.length), 'Inventory');
    if (!ik) { res.writeHead(404, cors); return res.end(); }
    res.writeHead(200, { ...cors, 'content-type': ik.tip, 'Cache-Control': 'public, max-age=86400' }); return res.end(ik.veri);
  }
  if (u.pathname === '/api/satin-al' && req.method === 'POST') {
    let b = ''; req.on('data', c => b += c);
    req.on('end', () => {
      try {
        const id = Number(JSON.parse(b || '{}').id) >>> 0;
        const v = oku();
        const h = overlayHeroListesi().find(x => x.id === id);
        if (!h) return json(400, { ok: false, hata: 'Không tìm thấy nhân vật' });
        if (sahipKumesi(v).has(id) || v.tumKarakterler === true || v.tumKarakterler === 'true') return json(400, { ok: false, hata: 'Tài khoản đã có nhân vật này' });
        const f = karakterFiyati(h);
        if ((Number(v.altin) || 0) < f) return json(400, { ok: false, hata: 'Không đủ vàng (cần ' + f.toLocaleString('vi-VN') + ')' });
        require('./ultimate-bp-spending').earn(v,f);
        v.altin = (Number(v.altin) || 0) - f;
        v.herolar = [...new Set([...(Array.isArray(v.herolar) ? v.herolar : []).map(Number), id])];
        yaz(v);
        console.log(`[magaza] satin alindi: ${h.name} (${id}) -${f} altin -> ${v.altin}`);
        return json(200, { ok: true, altin: v.altin, id, name: h.name, fiyat: f });
      } catch (e) { return json(400, { ok: false, hata: 'Yêu cầu không hợp lệ' }); }
    });
    return true;
  }
  return false;
}

http.createServer((req, res) => {
  const pathname = new URL(req.url, 'http://localhost').pathname;
  const shop = ['/shop', '/api/hesap', '/api/karakterler', '/api/thiet-bi', '/api/thiet-bi/ban', '/api/thiet-bi/mua', '/api/satin-al'].includes(pathname) || pathname.startsWith('/api/ikon/') || pathname.startsWith('/api/item-ikon/');
  if (!require('./account-guard').guard(req, res, !shop)) return;
  if (req.url.startsWith('/api/')) { const r = apiIsle(req, res); if (r !== false) return; res.writeHead(404); return res.end('yok'); }
  if (req.url === '/') { res.writeHead(200, { 'content-type': 'text/html; charset=utf-8' }); return res.end(page()); }
  if (req.url === '/shop') { res.writeHead(200, { 'content-type': 'text/html; charset=utf-8', 'cache-control': 'no-store' }); return res.end(shopPage()); }
  // Oyun icindeki "Top-up" / "Go now" dugmeleri (payurl) buraya acilir: sahte yukleme -> oyun-sunucu 10027
  if (req.url.startsWith('/topup')) {
    res.writeHead(200, { 'content-type': 'text/html; charset=utf-8' });
    return res.end(`<!doctype html><html lang="vi"><head><meta charset="utf-8"><title>Bleach - Nạp vàng</title>
<style>body{font:15px system-ui;background:#0d0b09;color:#e8d9b5;margin:0;padding:24px}h1{color:#ffe3a3}button{background:linear-gradient(180deg,#b8892f,#7a5516);border:0;color:#fff5d6;border-radius:6px;padding:10px 14px;margin:4px;cursor:pointer;font-weight:600}#d{color:#ffd166;margin:12px 0}#m{color:#9fe3b5;min-height:24px}</style></head>
  <body><h1>👑 Nạp vàng / điểm VIP</h1><div id="d">Đang tải…</div><div id="t"></div><div><input id="o" type="number" min="1" placeholder="Số lượng tùy chỉnh"> <button onclick="y(document.getElementById('o').value)">Nạp</button></div><div id="m"></div>
  <p style="color:#a08a5a;font-size:12px">Thanh toán mô phỏng: cộng vàng và điểm VIP, đồng thời tính vào sự kiện nạp hằng ngày. Có hiệu lực ngay khi trò chơi đang chạy.</p>
<script>var K='http://127.0.0.1:${(Number(process.env.BLEACH_PORT) || 10025) + 2}';var rawFetch=window.fetch;window.fetch=function(u,o){o=o||{};o.credentials='include';return rawFetch.call(window,u,o)};var T=[100,500,1000,2000,5000,10000,30000,50000,100000,200000];function p(n){return Number(n||0).toLocaleString('tr-TR')}
  function yaz(d){document.getElementById('d').innerHTML=d?'Vàng: <b>'+p(d.altin)+'</b> &nbsp; VIP <b>'+d.vipLevel+'</b> (điểm '+p(d.vipExp)+') &nbsp; Hôm nay: <b>'+p(d.bugun)+'</b>':'Máy chủ trò chơi đang tắt'}
function r(){fetch(K+'/hesap').then(function(x){return x.json()}).then(yaz).catch(function(){yaz(null)})}
  function y(n){n=Math.floor(Number(n)||0);if(!(n>0))return;fetch(K+'/topup',{method:'POST',headers:{'content-type':'application/json'},body:JSON.stringify({altin:n})}).then(function(x){return x.json()}).then(function(d){document.getElementById('m').textContent=d.ok?'✓ Đã nạp '+p(n)+' vàng, VIP '+d.vipLevel:'✗ '+(d.hata||'Không thể thực hiện');yaz(d)}).catch(function(){document.getElementById('m').textContent='✗ Không kết nối được với máy chủ trò chơi'})}
  document.getElementById('t').innerHTML=T.map(function(n){return '<button onclick="y('+n+')">'+p(n)+' vàng</button>'}).join('');r();</script></body></html>`);
  }
  if (req.url === '/hero-liste') {
    const v = oku();
    res.writeHead(200, { 'content-type': 'application/json' });
    return res.end(JSON.stringify({ sahip: Array.isArray(v.herolar) ? v.herolar : [], hepsi: heroListesi() }));
  }
  if (req.url === '/hero-kaydet' && req.method === 'POST') {
    let b = ''; req.on('data', c => b += c);
    req.on('end', () => {
      try {
        const g = JSON.parse(b); const v = oku();
        v.herolar = (g.herolar || []).map(Number).filter(Boolean);
        v.tumKarakterler = false;                  // artik shop listesi gecerli
        yaz(v); res.writeHead(200); res.end('{"ok":true}');
        console.log(`karakter shop: ${v.herolar.length} karakter hesapta`);
      } catch { res.writeHead(400); res.end('hata'); }
    });
    return;
  }
  if (req.url === '/durum') { durum().then(d => { res.writeHead(200, { 'content-type': 'application/json' }); res.end(JSON.stringify(d)); }).catch(() => { res.writeHead(500); res.end('{}'); }); return; }
  if (req.url === '/kaydet' && req.method === 'POST') {
    let b = ''; req.on('data', c => b += c);
    req.on('end', () => {
      try {
        const changes = JSON.parse(b);
        const v = oku();
        Object.assign(v, changes);
        yaz(v);
        if (Object.prototype.hasOwnProperty.call(changes, 'generalsSoul')) {
          const durumMod = require('./durum');
          const durum = durumMod.yukle();
          durum.generalsSoul = Math.max(0, Math.floor(Number(changes.generalsSoul) || 0));
          durumMod.kaydet(durum);
        }
        res.writeHead(200); res.end('{"ok":true}'); console.log('veri guncellendi');
      } catch { res.writeHead(400); res.end('hata'); }
    });
    return;
  }

  // --- Onayar: her sey MAX ---
  if (req.url === '/preset-max' && req.method === 'POST') {
    try {
      const v = oku();
      Object.assign(v, {
        altin: 999999999, gumus: 999999999, gumusHigh: 0, kupon: 999999999, askeriEmir: 999999,
        vipLevel: 15, vipExp: 999999, level: 99, deneyim: 999999, prestij: 9999,
        generalsSoul: 999999, blueSoul: 999999, purpleSoul: 999999, goldSoulV: 999999, orangeSoul: 999999,
        tumKarakterler: true,
      });
      yaz(v); res.writeHead(200); res.end('{"ok":true}'); console.log('[admin] PRESET: her sey MAX');
    } catch { res.writeHead(500); res.end('hata'); }
    return;
  }
  // --- Onayar: temiz baslangic (varsayilan) ---
  if (req.url === '/preset-baslangic' && req.method === 'POST') {
    try {
      const def = JSON.parse(fs.readFileSync(VARSAYILAN_DOSYA, 'utf8'));
      yaz(def); res.writeHead(200); res.end('{"ok":true}'); console.log('[admin] PRESET: temiz baslangic');
    } catch { res.writeHead(500); res.end('hata'); }
    return;
  }
  // --- SIFIRLA: kaydi sil, varsayilana don ---
  if (req.url === '/sifirla' && req.method === 'POST') {
    try {
      const def = JSON.parse(fs.readFileSync(VARSAYILAN_DOSYA, 'utf8'));
      yaz(def);                                                 // veri.json -> varsayilan
      try { fs.unlinkSync(OYUNCU); } catch { }                    // kalici oyuncu durumu sil
      try { const db = require('./db'); db.ac().exec("DELETE FROM durum WHERE bolum='oyuncu'"); } catch { }
      res.writeHead(200); res.end('{"ok":true}'); console.log('[admin] SIFIRLANDI: kayit silindi, varsayilana donuldu');
    } catch { res.writeHead(500); res.end('hata'); }
    return;
  }
  res.writeHead(404); res.end('yok');
}).listen(PORT, '127.0.0.1', () => console.log(`[admin] http://127.0.0.1:${PORT}`));
