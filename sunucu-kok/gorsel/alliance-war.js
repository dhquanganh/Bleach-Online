(function () {
 'use strict';
 var host=document.createElement('section');host.id='alliance-war';host.hidden=true;
 host.setAttribute('role','dialog');host.setAttribute('aria-modal','true');host.setAttribute('aria-label','Alliance War');
 host.innerHTML='<header><h1>Alliance War</h1><button data-action="close" aria-label="Đóng">×</button></header><div class="aw-stats"></div><nav><button data-tab="battle">Alliance Battle</button><button data-tab="campaign">Alliance Campaign</button><button data-tab="shop">Honor Shop</button><button data-tab="history">Lịch sử trận</button></nav><p class="aw-notice" role="status" aria-live="polite"></p><main></main><footer>Giờ máy chủ: UTC+7 · Đội tối đa 3 người chơi thật. <button data-action="close">Trở về game</button></footer>';
 document.getElementById('sahne').appendChild(host);
 // The bundled Chromium 59 needs explicit edges; CSS inset is ignored there.
 var style=document.createElement('style');style.textContent=
 '\n' +
 '#alliance-war[hidden]{display:none!important}\n' +
 '#alliance-war{position:absolute;top:0;right:0;bottom:0;left:0;z-index:9000;display:flex;flex-direction:column;padding:22px 30px 16px;border:2px solid #a7874e;box-sizing:border-box;overflow:hidden;background-color:#0b1019;background-image:radial-gradient(ellipse at 0% 0%,rgba(102,37,23,.45),transparent 65%),radial-gradient(ellipse at 100% 0%,rgba(14,72,94,.4),transparent 65%);color:#e9edf3;font:14px Arial,sans-serif;isolation:isolate}\n' +
 '#alliance-war *{box-sizing:border-box}\n' +
 '#alliance-war header{display:flex;align-items:center;justify-content:space-between;flex-shrink:0;margin-bottom:12px}\n' +
 '#alliance-war h1{margin:0;color:#ffd27a;font:bold 32px Georgia,serif;text-shadow:0 2px 3px #000;letter-spacing:1px}\n' +
 '#alliance-war h2{margin:0 0 16px;color:#f6d48f;font-size:21px;line-height:1.3}\n' +
 '#alliance-war h3{margin:8px 0 12px;color:#80d4ef;font-size:16px}\n' +
 '#alliance-war button{border:1px solid #8d7449;border-radius:4px;background:linear-gradient(#4c3f2b,#292217);color:#fff3d6;min-height:36px;padding:8px 15px;font:600 13px Arial,sans-serif;cursor:pointer;white-space:nowrap}\n' +
 '#alliance-war button:hover{border-color:#e9bc69;background:linear-gradient(#665235,#3a2e1d)}\n' +
 '#alliance-war button:focus,#alliance-war select:focus,#alliance-war input:focus{outline:2px solid #7dcce6;outline-offset:2px}\n' +
 '#alliance-war button:disabled{opacity:.45;cursor:default}\n' +
 '#alliance-war header button{width:36px;padding:0;font-size:24px;line-height:32px}\n' +
 '#alliance-war .aw-stats{flex-shrink:0;padding:10px 14px;border:1px solid #354250;border-radius:4px;background-color:#111b28;color:#dfcfab;font-size:13px;line-height:21px;overflow-wrap:break-word}\n' +
 '#alliance-war nav{display:flex;flex-shrink:0;padding:14px 0 12px;border-bottom:1px solid #36414b}\n' +
 '#alliance-war nav button{margin-right:8px;background:#17212d;border-color:#405060;color:#b9c7d4}\n' +
 '#alliance-war nav .active{background:linear-gradient(#79491e,#4b2c15);border-color:#cea263;color:#ffe7ac}\n' +
 '#alliance-war .aw-notice{flex-shrink:0;min-height:18px;margin:10px 0 12px;color:#9cdaec;font-size:13px;line-height:18px}\n' +
 '#alliance-war .aw-notice:empty{min-height:0;margin:7px 0}\n' +
 '#alliance-war main::-webkit-scrollbar{width:9px}#alliance-war main::-webkit-scrollbar-track{background:#0b1019}#alliance-war main::-webkit-scrollbar-thumb{background:#415265;border:2px solid #0b1019;border-radius:5px}\n' +
 '#alliance-war main{flex:1;min-height:0;overflow:auto;padding-right:6px}\n' +
 '#alliance-war .aw-columns{display:grid;grid-template-columns:minmax(0,1fr) minmax(0,1fr);grid-gap:18px;align-items:start}\n' +
 '#alliance-war article{border:1px solid #3b4b59;border-radius:5px;background-color:#111923;padding:20px;margin:0 0 14px;min-width:0;box-shadow:0 3px 10px rgba(0,0,0,.2)}\n' +
 '#alliance-war .aw-columns>article:first-child{border-top:3px solid #b47a3d}\n' +
 '#alliance-war .aw-columns>article+article{border-top:3px solid #39839c}\n' +
 '#alliance-war p{margin:10px 0 16px;line-height:1.7;color:#c5cfdb}\n' +
 '#alliance-war label{display:block;margin:16px 0 10px;line-height:24px;color:#d5dee6}\n' +
 '#alliance-war input,#alliance-war select{padding:9px 11px;border:1px solid #536272;border-radius:4px;background-color:#0b111a;color:#f0f3f7;font:14px Arial,sans-serif;max-width:100%;min-height:36px}\n' +
 '#alliance-war select{width:100%;margin:8px 0 4px}\n' +
 '#alliance-war input[type=password]{width:170px;margin-left:8px}\n' +
 '#alliance-war .aw-actions{display:flex;flex-wrap:wrap;margin-top:18px}\n' +
 '#alliance-war .aw-actions>button{margin:0 8px 8px 0}\n' +
 '#alliance-war .aw-row{display:flex;align-items:center;justify-content:space-between;padding:12px 0;border-bottom:1px solid #2e3d4b;line-height:22px}\n' +
 '#alliance-war .aw-row>span:first-child{margin-right:12px}\n' +
 '#alliance-war .aw-room{padding:8px 12px;border-radius:3px;background:#192634;color:#a6d8e5}\n' +
 '#alliance-war .aw-shop{display:grid;grid-template-columns:repeat(3,minmax(0,1fr));grid-gap:14px}\n' +
 '#alliance-war .aw-shop article{margin:0}\n' +
 '#alliance-war .aw-shop strong{line-height:24px}\n' +
 '#alliance-war .aw-item-icon{display:inline-block;width:40px;height:40px;object-fit:contain;vertical-align:middle;border:1px solid #a9915e;border-radius:3px;margin-right:10px;background:#191c21}\n' +
 '#alliance-war .aw-loot{display:flex;flex-wrap:wrap;margin:12px 0}\n' +
 '#alliance-war .aw-loot span{border:1px solid #394958;border-radius:3px;padding:5px 9px;margin:0 8px 8px 0;background:#182331;line-height:40px}\n' +
 '#alliance-war .aw-muted{color:#94a4b5}\n' +
 '#alliance-war footer{display:flex;align-items:center;justify-content:space-between;flex-shrink:0;margin-top:12px;padding-top:12px;border-top:1px solid #36414b;color:#98a9ba;font-size:12px}\n' +
 '#alliance-war .aw-replay{white-space:pre-wrap;background:#070c12;border:1px solid #2d3b49;border-radius:4px;padding:15px;font:13px/1.6 monospace;max-height:280px;overflow:auto}\n';document.head.appendChild(style);
 var data=null,tab='battle',busy=false,poll=null,icons={},replay=null,selectedModel=0,nativePlaying=false,lastPlaybackId='',nativeBarDisplay='';
 function escape(value){return String(value==null?'':value).replace(/[&<>"']/g,function(c){return {'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[c];});}
 function number(n){return Number(n||0).toLocaleString('vi-VN');}
 function button(action,label,attrs){return '<button data-action="'+action+'" '+(attrs||'')+'>'+label+'</button>';}
 function notice(message){host.querySelector('.aw-notice').textContent=message;}
 function api(action,body){return fetch('/auth/alliance-war/'+action,{method:action==='view'?'GET':'POST',credentials:'same-origin',headers:{'Content-Type':'application/json'},body:action==='view'?undefined:JSON.stringify(body||{})}).then(function(r){return r.json().then(function(v){if(!r.ok)throw Error(v.error||'Không kết nối được máy chủ.');return v;});});}
 function icon(item){if(item.hero)return '<span class="aw-item-icon" style="text-align:center;line-height:40px;font-size:24px">★</span>';return '<img class="aw-item-icon" data-picture="'+item.picture+'" alt="" title="'+escape(item.name)+'">';}
 function loadIcons(){
  if(!data)return;var items=data.shop.concat.apply(data.shop,data.models.map(function(m){return m.rewards;}));
  host.querySelectorAll('[data-picture]').forEach(function(img){var id=img.dataset.picture,item=items.find(function(i){return String(i.picture)===id;});if(!item)return;
   if(!icons[id])icons[id]=new Promise(function(resolve){var atlas=new Image();atlas.crossOrigin='use-credentials';atlas.onload=function(){try{var f=item.icon||{x:0,y:0,width:40,height:40,atlasHeight:atlas.naturalHeight/2},canvas=document.createElement('canvas');canvas.width=f.width;canvas.height=f.height;var ctx=canvas.getContext('2d');ctx.drawImage(atlas,f.x,f.y,f.width,f.height,0,0,f.width,f.height);var color=ctx.getImageData(0,0,f.width,f.height);ctx.clearRect(0,0,f.width,f.height);ctx.drawImage(atlas,f.x,f.y+f.atlasHeight,f.width,f.height,0,0,f.width,f.height);var alpha=ctx.getImageData(0,0,f.width,f.height);for(var i=0;i<color.data.length;i+=4)color.data[i+3]=alpha.data[i];ctx.putImageData(color,0,0);resolve(canvas.toDataURL());}catch(e){resolve('');}};atlas.onerror=function(){resolve('');};atlas.src='http://127.0.0.1:'+((window.oturum&&window.oturum.adminPort)||7421)+'/api/item-ikon/'+id;});
   icons[id].then(function(src){if(src)img.src=src;else img.style.visibility='hidden';});
  });
 }
 function modelSelect(selected){selected=selected||selectedModel;return '<select name="model" aria-label="Chiến dịch">'+data.models.map(function(m){return '<option value="'+m.id+'" '+(m.id===selected?'selected ':'')+(!m.unlocked?'disabled':'')+'>'+escape(m.name)+' · '+(m.hard?'Khó':'Thường')+' · Cấp '+m.level+(!m.unlocked?' (Chưa mở)':'')+'</option>';}).join('')+'</select>';}
 function render(){
  if(!data)return;var r=data.room,mode=tab==='campaign'?'pve':'pvp',mine=r&&r.owner===data.accountId;
  host.querySelector('.aw-stats').textContent=data.name+' · Cấp '+data.level+'   |   Vàng: '+number(data.gold)+'   |   Coupon: '+number(data.coupon)+'   |   Honor: '+number(data.honor)+'   |   Lượt thưởng Battle: '+data.pvpLeft+' · Campaign: '+data.pveLeft;
  host.querySelectorAll('[data-tab]').forEach(function(b){b.classList.toggle('active',b.dataset.tab===tab);});
  var html='';
  if(tab==='shop'){
   html='<h2>Honor Shop</h2><p>Honor mở khóa vật phẩm và không bị tiêu hao. Giá mua bằng vàng. Còn '+data.shopLeft+' lượt mua hôm nay.</p><div class="aw-shop">'+data.shop.map(function(i){var allowed=data.level>=i.level&&data.honor>=i.honor&&data.gold+(data.coupon||0)>=i.price&&data.shopLeft>0&&i.remaining!==0;return '<article>'+icon(i)+'<strong>'+escape(i.name)+' ×'+i.amount+'</strong><p>'+number(i.price)+' vàng · Cấp '+i.level+'<br>Cần '+number(i.honor)+' Honor'+(i.remaining===null?'':' · Còn '+i.remaining+' lần')+'</p>'+button('buy','Mua', 'data-row="'+i.rowId+'" '+(!allowed?'disabled':''))+'</article>';}).join('')+'</div>';
  }else if(tab==='history'){
   html='<h2>Lịch sử chiến đấu</h2><p>Vật phẩm thưởng được gửi qua thư trong game. Honor và lượt thưởng cập nhật ngay khi kết thúc trận.</p>';
   if(!data.history.length)html+='<p class="aw-muted">Chưa có trận chiến nào.</p>';
   html+=data.history.map(function(h){return '<article><h3>'+(h.mode==='pve'?'Campaign':'Battle')+' · '+(h.won?'Chiến thắng':'Không thắng')+'</h3><span>'+new Date(h.at).toLocaleString('vi-VN')+' · '+(h.reward?'Nhận '+h.honor+' Honor'+h.items.map(function(i){return ' + vật phẩm #'+i.id+' ×'+i.amount;}).join(''):'Không dùng lượt thưởng')+'</span>'+h.battles.map(function(b,index){return '<div class="aw-row"><span>Vòng '+b.round+': '+escape(b.left)+' vs '+escape(b.right)+' · '+(b.draw?'Hòa / hết lượt':b.won?escape(b.left)+' thắng':escape(b.right)+' thắng')+' · '+b.turns+' lượt</span>'+button('report','Chi tiết','data-id="'+h.id+'" data-index="'+index+'"')+'</div>';}).join('')+'</article>';}).join('');
   if(replay)html='<article><h3>Diễn biến trận đấu</h3><div class="aw-replay">'+escape(replay)+'</div>'+button('back-history','Đóng diễn biến')+'</article>'+html;
  }else{
   html='<div class="aw-columns"><article><h2>'+(mode==='pve'?'Alliance Campaign':'Alliance Battle')+'</h2><p>'+(mode==='pve'?'Cần cấp 40. Vượt chiến dịch Thường để mở Khó. Đội có tối đa 4 vòng để đánh bại cả 6 đội địch. Thua không mất lượt thưởng.<br>Hồi 5 lượt lúc 12:30 và 18:30, tích tối đa 10 lượt.':'Cần cấp 40. Ghép với đội có cùng số thành viên, sử dụng đội hình và chỉ số thật.<br>Mở 13:45–14:45 và 21:00–22:00. Có 10 lượt thưởng mỗi ngày, hồi lúc 00:00. Thắng hoặc thua đều có thưởng khi còn lượt.')+'</p><p>Còn <strong>'+(mode==='pve'?data.pveLeft:data.pvpLeft)+'</strong> lượt thưởng'+(mode==='pvp'?' · '+(data.pvpOpen?'Đang mở':'Chưa đến giờ'):'')+'. Hết lượt vẫn có thể tham gia.</p>';
   if(!r){html+='<form data-form="create">'+(mode==='pve'?modelSelect(): '')+'<label>Mật khẩu đội (tùy chọn) <input type="password" name="password" maxlength="32" autocomplete="off"></label><div class="aw-actions"><button type="submit" '+(data.level<40?'disabled':'')+'>Tạo đội</button>'+(mode==='pvp'?button('auto','Auto-Battle',!data.pvpOpen||data.level<40?'disabled':''):'')+'</div></form>';}
   html+='</article><article><h2>'+(r?'Đội của bạn':'Danh sách đội')+'</h2>';
   if(r){html+='<p class="aw-room">'+(r.mode==='pve'?'Campaign':'Battle')+' · '+(r.queued?'Đang tìm đối thủ (tối đa 120 giây)…':'Chưa tìm trận')+'</p>'+r.members.map(function(m){return '<div class="aw-row"><span>'+escape(m.name)+' · Cấp '+m.level+' · '+(m.id===r.owner?'Đội trưởng':m.ready?'Sẵn sàng':'Chưa sẵn sàng')+'</span>'+(mine&&m.id!==data.accountId?button('kick','Mời ra','data-member="'+m.id+'" '+(r.queued?'disabled':'')):'')+'</div>';}).join('');
    if(mine&&r.mode==='pve'&&!r.queued)html+='<form data-form="model">'+modelSelect(r.model)+' <button type="submit">Đổi chiến dịch</button></form>';
    html+='<div class="aw-actions">'+(mine?button(r.queued?'cancel':'start',r.queued?'Hủy tìm trận':r.mode==='pve'?'Bắt đầu chiến dịch':'Tìm đối thủ'):button('ready',r.members.find(function(m){return m.id===data.accountId;}).ready?'Hủy sẵn sàng':'Sẵn sàng',r.queued?'disabled':''))+button('leave','Rời đội')+'</div>';
   }else{var rooms=data.rooms.filter(function(v){return v.mode===mode&&!v.queued&&v.members.length<3;});html+=rooms.length?rooms.map(function(v){return '<form data-form="join" data-room="'+v.id+'"><div class="aw-row"><span>'+escape(v.members[0].name)+' · '+v.members.length+'/3'+(v.locked?' · Có mật khẩu':'')+'</span><span>'+(v.locked?'<input type="password" name="password" placeholder="Mật khẩu" aria-label="Mật khẩu đội" maxlength="32">':'')+' <button type="submit">Tham gia</button></span></div></form>';}).join(''):'<p class="aw-muted">Chưa có đội phù hợp. Bạn có thể tạo đội mới.</p>';}
   html+='</article></div>';
   if(mode==='pve'){var m=data.models.find(function(v){return v.id===(r&&r.mode==='pve'?r.model:Number(host.querySelector('[name=model]')&&host.querySelector('[name=model]').value));})||data.models[0];if(m)html+='<article><h3>Phần thưởng có thể nhận · '+escape(m.name)+' ('+(m.hard?'Khó':'Thường')+')</h3><div class="aw-loot">'+m.rewards.map(function(i){return '<span>'+icon(i)+escape(i.name)+'</span>';}).join('')+'</div><p class="aw-muted">Thắng và còn lượt thưởng: nhận ngẫu nhiên 1 vật phẩm trong danh sách, kèm Honor.</p></article>';}
  }
  host.querySelector('main').innerHTML=html;loadIcons();
 }
 function refresh(){return api('view').then(function(v){data=v;if(v.playback&&v.playback.id!==lastPlaybackId)window.allianceWarBattleStarted(v.playback.id);if(!host.hidden)render();});}
 function perform(action,body){if(busy)return;busy=true;notice('Đang xử lý…');host.querySelectorAll('button').forEach(function(b){b.disabled=true;});return api(action,body).then(function(v){notice(v.waiting?'Đang tìm đối thủ thật. Bạn có thể hủy tìm trận.':v.battleId?'Trận chiến đã kết thúc. Xem kết quả trong Lịch sử trận.':'Đã cập nhật.');if(v.battleId)tab='history';return refresh();}).catch(function(e){notice(e.message);render();}).then(function(){busy=false;host.querySelectorAll('header button,nav button,footer button').forEach(function(b){b.disabled=false;});});}
 host.addEventListener('click',function(e){var b=e.target.closest('button');if(!b||b.disabled)return;if(b.dataset.tab){tab=b.dataset.tab;replay=null;render();return;}var a=b.dataset.action;if(!a)return;
  if(a==='close'){if(busy)return;host.hidden=true;clearTimeout(poll);if(!nativePlaying&&data&&data.room)api('leave').catch(function(){});return;}
  if(a==='report'){perform('play',{id:b.dataset.id,index:Number(b.dataset.index)});return;}
  if(a==='back-history'){replay=null;render();return;}
  var body={};if(a==='buy')body={rowId:Number(b.dataset.row),qty:1};if(a==='kick')body={member:b.dataset.member};if(a==='ready')body={ready:!data.room.members.find(function(m){return m.id===data.accountId;}).ready};if(a==='auto')body={mode:'pvp'};perform(a,body);
 });
 host.addEventListener('change',function(e){if(e.target.name==='model'){selectedModel=Number(e.target.value);render();}});
 host.addEventListener('submit',function(e){e.preventDefault();var f=e.target,values=new FormData(f),action=f.dataset.form,body={};if(action==='create')body={mode:tab==='campaign'?'pve':'pvp',model:Number(values.get('model')),password:values.get('password')||''};if(action==='model')body={model:Number(values.get('model'))};if(action==='join')body={roomId:f.dataset.room,password:values.get('password')||''};perform(action,body);});
 function tick(){poll=setTimeout(function(){if(host.hidden&&!nativePlaying)return;if(busy){tick();return;}var editing=host.contains(document.activeElement)&&/INPUT|SELECT/.test(document.activeElement.tagName);api('view').then(function(v){data=v;if(v.playback&&v.playback.id!==lastPlaybackId)window.allianceWarBattleStarted(v.playback.id);if(!editing&&!host.hidden)render();}).catch(function(e){notice(e.message);}).then(tick);},4000);}
 window.allianceWarBattleStarted=function(id){var bar=document.getElementById('ust');if(bar){if(!nativePlaying)nativeBarDisplay=bar.style.display;bar.style.display='none';}lastPlaybackId=String(id||'');nativePlaying=true;host.hidden=true;clearTimeout(poll);tick();};
 window.allianceWarBattleEnded=function(){var bar=document.getElementById('ust');if(bar)bar.style.display=nativeBarDisplay;nativePlaying=false;window.openAllianceWar('history');};
 window.playAllianceWarReport=function(address){var parts=String(address).split(':');return perform('play',{id:parts[0],index:Number(parts[1])});};
 window.openAllianceWar=function(target){if(['battle','campaign','shop','history'].indexOf(target)>=0)tab=target;else if(target==='auto')tab='battle';host.hidden=false;notice('Đang tải Alliance War…');clearTimeout(poll);refresh().then(function(){notice('');if(target==='auto'&&!data.room)return perform('auto',{mode:'pvp'});}).catch(function(e){notice(e.message);}).then(tick);};
})();
