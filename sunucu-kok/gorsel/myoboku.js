(function () {
  'use strict';
  var host = document.createElement('div');
  host.id = 'myoboku';
  host.hidden = true;
  host.style.display = 'none';
  host.innerHTML = '<section class="my-panel" role="dialog" aria-modal="true" aria-labelledby="my-title">' +
    '<h1 id="my-title" class="my-visually-hidden">MYOBOKU TRIAL</h1>' +
    '<button class="my-close" aria-label="Đóng">×</button><button class="my-help" aria-label="Hướng dẫn">?</button>' +
    '<div class="my-body"><div class="my-meta"><span>✦ Sự kiện đang mở</span><span>Lượt quay: <b>Không giới hạn</b></span></div>' +
    '<div class="my-wheel"><div class="my-ring"></div><div class="my-prizes"></div><div class="my-pointer"></div><button class="my-start" aria-label="Quay 1 lần, tốn 10.000 vàng">START</button><div class="my-cost"><span class="my-coin"></span>10.000 vàng / lượt</div></div>' +
    '<div class="my-bottom"><span class="my-gold"></span><label><input type="checkbox" class="my-skip"> Bỏ qua hiệu ứng</label></div>' +
    '<p class="my-message" role="status" aria-live="polite">Mỗi lượt quay nhận một phần thưởng.</p></div>' +
    '<nav aria-hidden="true"><div class="my-tab-trial"></div><div class="my-tab-wheel selected"></div></nav></section>' +
    '<div class="my-reward" hidden><section class="my-reward-card" role="alertdialog" aria-modal="true" aria-labelledby="my-reward-title">' +
    '<h2 id="my-reward-title">Nhận thưởng thành công</h2><div class="my-reward-icon"><img alt=""></div>' +
    '<strong class="my-reward-name"></strong><b class="my-reward-amount"></b><p>Phần thưởng đã được thêm vào túi.</p>' +
    '<button class="my-reward-ok">Xác nhận</button></section></div>';
  document.getElementById('sahne').appendChild(host);
  // Older running servers may still send CSS as application/octet-stream.
  // Read it as text, and reveal the dialog only after its styles are installed.
  var stylesReady;
  function loadStyles() {
    if (stylesReady) return stylesReady;
    stylesReady = new Promise(function (resolve, reject) {
      var request = new XMLHttpRequest();
      request.open('GET', '/gorsel/myoboku.css?v=2026102504');
      request.timeout = 10000;
      request.onload = function () {
        if (request.status !== 200 || request.responseText.indexOf('#myoboku{') < 0) return reject(Error('Không tải được giao diện Myoboku. Hãy mở lại sự kiện.'));
        var style = document.createElement('style'); style.textContent = request.responseText; document.head.appendChild(style);
        Promise.all(['panel','wheel','pointer','start','help','tab','tab-selected','tab-trial','tab-wheel','game-item-slot','game-notice','game-notice-button','game-notice-button-hover'].map(function (name) {
          return new Promise(function (ready, failed) { var image = new Image(); image.onload = ready; image.onerror = function () { failed(Error('Không tải được asset Myoboku: ' + name)); }; image.src = '/gorsel/myoboku-native/' + name + '.png'; });
        })).then(resolve, reject);
      };
      request.onerror = request.ontimeout = function () { reject(Error('Không tải được giao diện Myoboku. Hãy mở lại sự kiện.')); };
      request.send();
    }).catch(function (error) { stylesReady = null; throw error; });
    return stylesReady;
  }
  var panel = host.querySelector('.my-panel'), start = host.querySelector('.my-start'), message = host.querySelector('.my-message');
  var config, busy = false, active = -1, timer;
  var rewardPopup = host.querySelector('.my-reward'), rewardOk = host.querySelector('.my-reward-ok');
  var iconCache = {};
  function itemIcon(reward) {
    var key = String(reward.picture);
    if (iconCache[key]) return iconCache[key];
    iconCache[key] = new Promise(function (resolve, reject) {
      var atlas = new Image(); atlas.crossOrigin = 'use-credentials';
      atlas.onload = function () {
        try {
          var frame = reward.icon || {x:0,y:0,width:Math.min(atlas.naturalWidth,40),height:atlas.naturalHeight/2,atlasHeight:atlas.naturalHeight/2};
          var canvas = document.createElement('canvas'); canvas.width = frame.width; canvas.height = frame.height;
          var context = canvas.getContext('2d');
          context.drawImage(atlas,frame.x,frame.y,frame.width,frame.height,0,0,frame.width,frame.height);
          var color = context.getImageData(0,0,frame.width,frame.height);
          context.clearRect(0,0,frame.width,frame.height);
          context.drawImage(atlas,frame.x,frame.y+frame.atlasHeight,frame.width,frame.height,0,0,frame.width,frame.height);
          var alpha = context.getImageData(0,0,frame.width,frame.height);
          for (var i=0;i<color.data.length;i+=4) color.data[i+3] = alpha.data[i];
          context.putImageData(color,0,0);resolve(canvas.toDataURL('image/png'));
        } catch (error) { reject(error); }
      };
      atlas.onerror = function () { reject(Error('Không tải được icon vật phẩm.')); };
      atlas.src = 'http://127.0.0.1:' + ((window.oturum && window.oturum.adminPort) || 7421) + '/api/item-ikon/' + reward.picture;
    }).catch(function (error) { delete iconCache[key]; throw error; });
    return iconCache[key];
  }
  function showReward(reward) {
    host.querySelector('.my-reward-name').textContent = reward.name;
    host.querySelector('.my-reward-amount').textContent = '× ' + reward.amount.toLocaleString('vi-VN');
    var image = host.querySelector('.my-reward-icon img'); image.style.visibility = 'hidden';
    image.onload = function () { image.style.visibility = 'visible'; };
    itemIcon(reward).then(function (url) { image.src = url; }).catch(function () { image.style.visibility = 'hidden'; });
    rewardPopup.hidden = false; rewardOk.focus();
  }
  rewardOk.onclick = function () { rewardPopup.hidden = true; start.focus(); };
  var control = 'http://127.0.0.1:' + (((window.oturum && Number(window.oturum.gatewayPort)) || 10025) + 2);
  function api(path, method) {
    return fetch(control + '/myoboku' + path, {method: method || 'GET'}).then(function (r) {
      return r.json().then(function (d) { if (!r.ok) throw Error(d.error || 'Không thể kết nối sự kiện.'); return d; });
    });
  }
  function balance(d) { host.querySelector('.my-gold').textContent = 'Vàng hiện có: ' + d.gold.toLocaleString('vi-VN'); }
  function highlight(index) {
    var cells = host.querySelectorAll('.my-prize');
    if (cells[active]) cells[active].classList.remove('active');
    active = index; if (cells[index]) cells[index].classList.add('active');
  }
  function render(d) {
    config = d; balance(d);
    var price = Number(d.cost).toLocaleString('vi-VN');
    host.querySelector('.my-cost').lastChild.textContent = price + ' v\u00e0ng / l\u01b0\u1ee3t';
    start.setAttribute('aria-label', 'Quay 1 l\u1ea7n, t\u1ed1n ' + price + ' v\u00e0ng');
    var prizes = host.querySelector('.my-prizes'); prizes.textContent = '';
    d.rewards.forEach(function (r, i) {
      var cell = document.createElement('div'); cell.className = 'my-prize';
      var angle = (i * 45 - 112.5) * Math.PI / 180;
      cell.style.left = (202.5 + Math.cos(angle) * 167) + 'px'; cell.style.top = (200.5 + Math.sin(angle) * 167) + 'px';
      var gem = document.createElement('span'); gem.className = 'my-gem'; gem.textContent = '✧';
      var amount = document.createElement('b'); amount.textContent = r.amount;
      cell.title = r.name + ' × ' + r.amount + ' · ' + (100 * r.weight / d.rewards.reduce(function (n, x) { return n + x.weight; }, 0)).toFixed(2) + '%';
      cell.setAttribute('aria-label', cell.title); cell.appendChild(gem); cell.appendChild(amount); prizes.appendChild(cell);
      var icon = document.createElement('img'); icon.className = 'my-item-icon'; icon.alt = '';
      icon.style.display = 'none';
      icon.onload = function () { gem.style.display = 'none'; icon.style.display = 'block'; };
      icon.onerror = function () { icon.style.display = 'none'; gem.style.display = 'block'; };
      itemIcon(r).then(function (url) { icon.src = url; }).catch(function () { icon.style.display = 'none'; gem.style.display = 'block'; });
      cell.insertBefore(icon, amount);
    }); active = -1;
  }
  function close() { if (busy) return; rewardPopup.hidden = true; host.hidden = true; host.style.display = 'none'; }
  window.openMyoboku = function () {
    return loadStyles().then(function () {
      host.hidden = false; host.style.display = 'flex'; if (busy) return; start.disabled = true; message.textContent = 'Đang tải phần thưởng…';
      return api('').then(function (d) { render(d); message.textContent = 'Mỗi lượt 10.000 vàng · Phần thưởng chuyển thẳng vào túi.'; start.disabled = false; start.focus(); }).catch(function (e) { message.textContent = e.message; });
    }).catch(function (e) { if (typeof window.mesaj === 'function') window.mesaj(e.message, 5000); else console.error(e.message); });
  };
  host.querySelector('.my-close').onclick = close;
  host.querySelector('.my-help').onclick = function () { message.textContent = 'Mỗi lượt tốn 10.000 vàng, không giới hạn lượt. Rê chuột lên ô để xem thưởng và tỉ lệ. Thưởng được lưu ngay vào túi.'; };
  document.addEventListener('keydown', function (e) { if (!host.hidden && e.key === 'Escape') { if (!rewardPopup.hidden) rewardOk.click(); else close(); } });
  start.onclick = function () {
    if (busy || !config || !rewardPopup.hidden) return; busy = true; start.disabled = true; message.textContent = 'Đang quay…';
    api('/spin', 'POST').then(function (result) {
      balance(result);
      var skip = host.querySelector('.my-skip').checked, step = 0, steps = 32 + result.index + 1;
      function finish() {
        highlight(result.index); message.textContent = 'Nhận được ' + result.reward.name + ' × ' + result.reward.amount + ' — đã thêm vào túi!'; busy = false; start.disabled = false;
        showReward(result.reward);
      }
      if (skip) return finish();
      function tick() { highlight(step % 8); step++; if (step >= steps) return finish(); timer = setTimeout(tick, 35 + Math.pow(step / steps, 4) * 210); }
      tick();
    }).catch(function (e) { message.textContent = e.message; busy = false; start.disabled = false; });
  };
}());
