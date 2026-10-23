'use strict';
const fs = require('node:fs');
const path = require('node:path');
const crypto = require('node:crypto');
const { ObjectId } = require('mongodb');
const { ROOT, FILES } = require('./accounts.cjs');
const revision = files => crypto.createHash('sha256').update(JSON.stringify(files)).digest('hex');
const limits = {
  altin: [0, 2147483647], gumus: [0, 2147483647], gumusHigh: [0, 2147483647],
  kupon: [0, 2147483647], askeriEmir: [0, 2147483647], level: [1, 159],
  deneyim: [0, 2147483647], prestij: [0, 2147483647], vipLevel: [0, 15], vipExp: [0, 2147483647],
  generalsSoul: [0, 2147483647], blueSoul: [0, 2147483647], purpleSoul: [0, 2147483647],
  goldSoulV: [0, 2147483647], orangeSoul: [0, 2147483647],
};
let catalog;
let itemCatalog;
function items() {
  if (!itemCatalog) itemCatalog=JSON.parse(fs.readFileSync(path.join(__dirname,'cikarim/veri-json/Article.json'),'utf8'))
    .map(a=>({id:parseInt(a.id,16)>>>0,name:a.name||'(không tên)',quality:Number(a.quality)||0,picture:Number(a.picture)||0,maxAdd:require('./sunucu/admin-item-limits').maxAdd(a)})).filter(a=>a.id);
  return itemCatalog;
}
function heroes() {
  if (!catalog) {
    const allowed = new Set(require('./sunucu/herolar').gecerliHerolar().map(h => h.id));
    catalog = JSON.parse(fs.readFileSync(path.join(__dirname,'cikarim/veri-json/BaseHero.json')))
      .map(h => ({ id: parseInt(h.id,16) >>> 0, name: h.name, quality: Number(h.quality) || 0 }))
      .filter(h => allowed.has(h.id)).sort((a,b) => b.quality-a.quality || a.name.localeCompare(b.name));
  }
  return catalog;
}
function fail(status, message) { const error = Error(message); error.status = status; throw error; }
function integer(value, min, max, label) {
  if (!Number.isInteger(value) || value < min || value > max) fail(400, `${label}: nhập số nguyên từ ${min} đến ${max}.`);
  return value;
}
function createAdmin({ db, runtimes, serial, save, stop, body, snapshot }) {
  async function read(id) {
    const rt = runtimes.get(id.toHexString());
    if (rt) await save(rt);
    else {
      // Preserve unsynced changes left by an interrupted game before an admin edit.
      const dir=path.join(ROOT,'.accounts',id.toHexString()),syncFile=path.join(dir,'synced-hash'),journal=path.join(dir,'pending.json');
      if(fs.existsSync(syncFile)) {
        const files=snapshot(dir);
        if(revision(files)!==fs.readFileSync(syncFile,'utf8'))fs.writeFileSync(journal,JSON.stringify({files}));
      }
      if(fs.existsSync(journal)) {
        const files=require('./sunucu/retired-heroes').cleanFiles(JSON.parse(fs.readFileSync(journal,'utf8')).files);
        await db.collection('players').updateOne({_id:id},{$set:{files,updatedAt:new Date()}});
        fs.rmSync(journal);
      }
    }
    const account = await db.collection('accounts').findOne({ _id: id }, { projection: { username:1,role:1 } });
    const player = await db.collection('players').findOne({ _id: id });
    if (!account || !player) fail(404, 'Không tìm thấy tài khoản hoặc dữ liệu nhân vật.');
    return { account, player };
  }
  function view(account, player) {
    const currency = JSON.parse(player.files['veri.json'] || '{}');
    const state = JSON.parse(player.files['oyuncu.json'] || '{}');
    return { id: account._id.toHexString(), username: account.username, role: account.role,
      nick: state.karakter?.nick || state.nick || '', hasCharacter: !!state.karakter?.anaId,
      values: Object.fromEntries(Object.entries(limits).map(([key,[min]]) => [key, Number(currency[key]) || min])),
      heroes: ((currency.tumKarakterler === true || currency.tumKarakterler === 'true') ? heroes().map(h=>h.id) : (currency.herolar || [])).map(id => ({ id, level: state.seviye?.herolar?.[id]?.lv || currency.level || 1, name: heroes().find(h=>h.id===id)?.name || String(id) })),
      revision: revision(player.files), online: runtimes.has(account._id.toHexString()) };
  }
  return async function handle(req,res,pathname,user,json) {
    if (user.account.role !== 'admin') { json(403,{error:'Cần tài khoản admin.'}); return; }
    try {
      if(pathname==='/auth/admin/void-region'){
        const config=require('./sunucu/void-region-config');
        if(req.method==='GET'){const q=(new URL(req.url||pathname,'http://localhost').searchParams.get('q')||'').trim().toLowerCase(),current=config.view();json(200,{config:current,bosses:config.catalog().filter(e=>e.id===current.enemyId||e.name.toLowerCase().includes(q)||String(e.id).includes(q)).sort((a,b)=>(b.id===current.enemyId)-(a.id===current.enemyId)||(b.source==='naruto')-(a.source==='naruto')||a.name.localeCompare(b.name)).slice(0,80)});return;}
        if(req.method!=='PATCH')fail(405,'Phương thức không hợp lệ.');
        const data=await body(req);if(!data||typeof data!=='object'||Array.isArray(data))fail(400,'Dữ liệu boss không hợp lệ.');
        integer(data.enemyId,1,2147483647,'Boss');integer(data.revision,1,2147483646,'Phiên bản');
        await serial('void-region',async()=>json(200,config.write(data,data.revision)));return;
      }
      if(pathname==='/auth/admin/anniversary-feast'){
        const config=require('./sunucu/anniversary-feast-config');
        if(req.method==='GET'){json(200,config.read());return;}
        if(req.method!=='PATCH')fail(405,'Phương thức không hợp lệ.');
        const data=await body(req);
        if(!data||!heroes().some(h=>h.id===data.heroId))fail(400,'Chọn tướng hợp lệ trong danh sách.');
        integer(data.price,1,2147483647,'Giá điểm');integer(data.revision,1,2147483646,'Phiên bản');
        await serial('anniversary-feast',async()=>{const result=config.write(data,data.revision);json(200,result);});return;
      }
      if (pathname === '/auth/admin/heroes' && req.method === 'GET') { json(200,{heroes:heroes()});return; }
      if (pathname === '/auth/admin/items' && req.method === 'GET') {
        const q=(new URL(req.url,'http://localhost').searchParams.get('q')||'').trim().toLowerCase();
        json(200,{items:q.length<2?[]:items().filter(a=>a.name.toLowerCase().includes(q)||String(a.id).includes(q)||a.id.toString(16).includes(q)).slice(0,60)});return;
      }
      const iconMatch=/^\/auth\/admin\/items\/(\d+)\/icon$/.exec(pathname);
      if (iconMatch && req.method==='GET') {
        const item=items().find(a=>a.id===Number(iconMatch[1]));
        const image=item&&require('./admin-item-icon.cjs')(item.picture||item.id);
        if(!image)fail(404,'Không có icon vật phẩm.');
        res.writeHead(200,{'Content-Type':image.type,'Cache-Control':'private, max-age=3600'});res.end(image.data);return;
      }
      if (pathname === '/auth/admin/accounts' && req.method === 'GET') {
        const accounts = await db.collection('accounts').find({}, {projection:{username:1,role:1}}).sort({username:1}).toArray();
        json(200,{accounts:accounts.map(a=>({id:a._id.toHexString(),username:a.username,role:a.role,online:runtimes.has(a._id.toHexString())}))});return;
      }
      const match = /^\/auth\/admin\/accounts\/([a-f0-9]{24})(\/heroes|\/items)?$/.exec(pathname);
      if (!match) fail(404,'Không tìm thấy chức năng quản trị.');
      const id = new ObjectId(match[1]);
      if (req.method === 'GET' && !match[2]) {
        await serial(match[1],async()=>{ const {account,player}=await read(id);json(200,view(account,player)); });return;
      }
      if (!((req.method === 'PATCH' && !match[2]) || (req.method === 'POST' && match[2]))) fail(405,'Phương thức không hợp lệ.');
      const data = await body(req);
      if (!data || typeof data !== 'object' || Array.isArray(data)) fail(400,'Dữ liệu chỉnh sửa không hợp lệ.');
      await serial(match[1],async()=>{
        const {account,player}=await read(id);
        if (typeof data.revision !== 'string' || data.revision !== revision(player.files)) fail(409,'Dữ liệu đã thay đổi. Tải lại tài khoản trước khi lưu.');
        const files = {...player.files}, currency = JSON.parse(files['veri.json'] || '{}'), state = JSON.parse(files['oyuncu.json'] || '{}');
        let grant;
        if (match[2] === '/items') {
          if (!state.karakter?.anaId) fail(400,'Tài khoản cần tạo nhân vật trong game trước khi thêm item.');
          const item=items().find(a=>a.id===data.itemId);
          if (!item) fail(400,'Item không hợp lệ.');
          const amount=integer(data.amount,1,item.maxAdd,'Số lượng');
          const requestId=crypto.createHash('sha256').update(match[1]+data.revision+':'+item.id+':'+amount).digest('hex');
          grant={id:item.id,name:item.name,amount,delivery:'mail'};
          const rt=runtimes.get(match[1]);
          if(rt){
            const delivered=await new Promise((resolve,reject)=>{
              const done=(error,result)=>{clearTimeout(timer);rt.child.off('message',onMessage);rt.child.off('exit',onExit);error?reject(error):resolve(result);};
              const onMessage=m=>{if(m?.type==='admin-item-mail-ack'&&m.requestId===requestId)done(m.error?Error(m.error):null,m.result);};
              const onExit=()=>done(Error('Phiên game đã đóng trước khi xác nhận thư.'));
              const timer=setTimeout(()=>done(Error('Chưa nhận được xác nhận gửi thư từ game.')),10000);
              rt.child.on('message',onMessage);rt.child.once('exit',onExit);
              rt.child.send({type:'admin-item-mail',itemId:item.id,amount,requestId},error=>{if(error)done(error);});
            });
            if(rt.saving)await rt.saving;
            await save(rt);
            await db.collection('players').updateOne({_id:id},{$push:{adminChanges:{$each:[{actor:user.account._id,at:new Date(),action:'add-item',itemId:item.id,amount,delivery:'mail',requestId}],$slice:-100}}});
            const latest=await db.collection('players').findOne({_id:id});
            json(200,{ok:true,disconnected:false,item:{...grant,...delivered},account:view(account,latest)});return;
          }
          const mail=require('./sunucu/admin-item-mail').enqueue(state,item.id,amount,requestId);
          grant.mailId={hi:mail.hi,lo:mail.lo};
        } else if (match[2] === '/heroes') {
          if (!state.karakter?.anaId) fail(400,'Tài khoản cần tạo nhân vật trong game trước khi thêm hero.');
          const hero = heroes().find(h=>h.id===data.heroId);
          if (!hero) fail(400,'Hero không hợp lệ hoặc đã bị xóa khỏi game.');
          const level = integer(data.level,1,159,'Cấp hero');
          if (currency.tumKarakterler === true || currency.tumKarakterler === 'true' || (currency.herolar || []).includes(hero.id)) fail(409,'Tài khoản đã sở hữu hero này.');
          currency.herolar = [...new Set([...(currency.herolar || []),hero.id])];
          state.seviye = state.seviye || {}; state.seviye.herolar = state.seviye.herolar || {};
          state.seviye.herolar[hero.id] = { lv:level, exp:0 };
        } else {
          if (!data.values || typeof data.values !== 'object' || Array.isArray(data.values)) fail(400,'Dữ liệu chỉnh sửa không hợp lệ.');
          for (const [key,value] of Object.entries(data.values)) {
            if (!Object.hasOwn(limits,key)) fail(400,'Trường chỉnh sửa không hợp lệ: '+key);
            currency[key] = integer(value,...limits[key],key);
          }
          if (data.nick !== undefined) {
            if (typeof data.nick !== 'string' || !data.nick.trim() || [...data.nick.trim()].length > 24 || /[\x00-\x1f<>]/.test(data.nick)) fail(400,'Tên nhân vật phải có 1–24 ký tự hợp lệ.');
            if (!state.karakter?.anaId) fail(400,'Tài khoản chưa tạo nhân vật.');
            state.nick = currency.nick = state.karakter.nick = data.nick.trim();
          }
        }
        files['veri.json']=JSON.stringify(currency,null,2);files['oyuncu.json']=JSON.stringify(state,null,2);
        const disconnected=runtimes.has(match[1]);
        await stop(match[1]);
        const latest = await db.collection('players').findOne({_id:id});
        if (!latest || revision(latest.files) !== data.revision) fail(409,'Game vừa cập nhật dữ liệu. Tải lại tài khoản trước khi lưu.');
        const result = await db.collection('players').updateOne({_id:id,files:latest.files},{$set:{files,updatedAt:new Date()},$push:{adminChanges:{$each:[{actor:user.account._id,at:new Date(),action:grant?'add-item':match[2]?'add-hero':'edit',heroId:match[2]==='/heroes'?data.heroId:null,...(grant?{itemId:grant.id,amount:grant.amount}:{}),fields:match[2]?[]:Object.keys(data.values)}],$slice:-100}}});
        if (!result.matchedCount) fail(409,'Dữ liệu vừa thay đổi. Tải lại tài khoản trước khi lưu.');
        const dir=path.join(ROOT,'.accounts',match[1]);fs.mkdirSync(dir,{recursive:true});
        for(const name of FILES){const file=path.join(dir,name);if(files[name]!==undefined)fs.writeFileSync(file,files[name]);else fs.rmSync(file,{force:true});}
        fs.writeFileSync(path.join(dir,'synced-hash'),revision(snapshot(dir)));
        fs.rmSync(path.join(dir,'pending.json'),{force:true});
        json(200,{ok:true,disconnected,...(grant?{item:grant}:{}),account:view(account,{...player,files})});
      });
    } catch(e) { if(e instanceof SyntaxError) { json(400,{error:'Dữ liệu JSON không hợp lệ.'});return; } if(!e.status) console.error('[admin accounts]',e.name);json(e.status || 503,{error:e.status?e.message:'Không thể lưu dữ liệu. Vui lòng thử lại.'}); }
  };
}
module.exports = { createAdmin };
