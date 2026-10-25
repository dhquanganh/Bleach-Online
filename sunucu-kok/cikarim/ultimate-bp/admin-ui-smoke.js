process.on('uncaughtException',function(e){require('fs').writeFileSync(__dirname+'/admin-ui-error.txt',e.stack);process.exit(3);});
// Isolated admin UI test in the bundled Electron. No player or MongoDB writes.
const {app,BrowserWindow}=require('electron'),http=require('http'),fs=require('fs'),path=require('path');
const root=path.resolve(__dirname,'../..'),fixture=JSON.parse(fs.readFileSync(path.join(__dirname,'admin-fixture.json'),'utf8'));var saved=0;var items={};fixture.config.rewards.forEach(function(r){r.items.forEach(function(a){items[a.type+':'+a.code]=a;});});
const server=http.createServer(function(req,res){
 res.setHeader('Content-Type','application/json');var url=req.url;
 if(url==='/'){res.setHeader('Content-Type','text/html; charset=utf-8');return res.end(fs.readFileSync(path.join(root,'admin-accounts.html')));}
 if(url==='/auth/admin/ultimate-bp'&&req.method==='PATCH'){var body='';req.on('data',function(c){body+=c});return req.on('end',function(){var data=JSON.parse(body);saved++;data.rewards.forEach(function(r){r.items=r.items.map(function(a){return Object.assign({},items[a.type+':'+a.code]||{name:'Spirit Stone'},a);});});fixture.config=Object.assign({},data,{revision:data.revision+1,heroName:'Tsunade Asian'});res.end(JSON.stringify(fixture.config));});}
 if(url==='/auth/admin/ultimate-bp')return res.end(JSON.stringify(fixture.config));
 if(url==='/auth/admin/heroes')return res.end(JSON.stringify({heroes:fixture.heroes}));
 if(url.indexOf('/auth/admin/items?')===0)return res.end(JSON.stringify({items:[{id:14900001,name:'Spirit Stone'}]}));
 if(url.indexOf('/icon')>0){res.setHeader('Content-Type','image/png');return res.end(fs.readFileSync(fs.existsSync(path.join(__dirname,'icon-'+url.split('/')[4]+'.png'))?path.join(__dirname,'icon-'+url.split('/')[4]+'.png'):path.join(root,'cikarim/myoboku/stone-atlas.png')));}
 if(url==='/auth/admin/accounts')return res.end('{"accounts":[]}');
 res.statusCode=400;res.end('{"error":"Isolated test"}');
});
app.disableHardwareAcceleration();
app.on('ready',function(){fs.writeFileSync(path.join(__dirname,'admin-ui-stage.txt'),'ready');server.listen(7459,'127.0.0.1',function(){var w=new BrowserWindow({width:1200,height:1000,show:false,webPreferences:{nodeIntegration:false}});fs.writeFileSync(path.join(__dirname,'admin-ui-stage.txt'),'window');var errors=[];w.webContents.on('console-message',function(e,level,message){if(level>=2){errors.push(message);fs.writeFileSync(path.join(__dirname,'admin-ui-console.txt'),errors.join('\n'));}});w.loadURL('http://127.0.0.1:7459/');setTimeout(function(){w.webContents.executeJavaScript(`(function(){return new Promise(function(resolve){
 var rows=document.getElementById('bpRows');if(rows.children.length!==5)throw Error('Missing current milestones');
 var initial={rows:rows.children.length,icons:rows.querySelectorAll('img').length,current:document.getElementById('bpCurrent').textContent};
 document.getElementById('bpHeroSearch').value='Tsunade';document.getElementById('bpHeroSearch').dispatchEvent(new Event('input'));document.getElementById('bpHero').value='11120992';
 document.getElementById('bpPrice').value='1234';document.getElementById('bpItemSearch').value='stone';document.getElementById('bpItemSearch').dispatchEvent(new Event('input'));
 setTimeout(function(){var first=rows.children[0];first.lastElementChild.click();var list=first.children[2];if(list.children.length!==4)throw Error('Add reward failed');list.children[3].querySelector('input').value='77';
 document.getElementById('bpForm').dispatchEvent(new Event('submit',{cancelable:true}));setTimeout(function(){initial.status=document.getElementById('bpStatus').textContent;initial.currentAfter=document.getElementById('bpCurrent').textContent;resolve(initial);},500);},500);
 });}())`,function(result){var ok=saved===1&&fixture.config.heroId===11120992&&fixture.config.price===1234&&fixture.config.rewards[0].items[3].amount===77&&result.icons>0;fs.writeFileSync(path.join(__dirname,'admin-ui-result.json'),JSON.stringify({ok:ok,saves:saved,result:result,errors:errors},null,2));w.webContents.capturePage(function(img){fs.writeFileSync(path.join(__dirname,'admin-preview.png'),img.toPNG());server.close();app.exit(ok?0:1);});});},1500);});});
setTimeout(function(){app.exit(2)},15000);

