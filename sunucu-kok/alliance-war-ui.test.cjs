'use strict';
const {test}=require('node:test'),assert=require('node:assert/strict'),http=require('node:http'),fs=require('node:fs'),path=require('node:path');
test('launcher Alliance overlay renders current rewards and shop icons, submits rooms, handles errors and closes cleanly',{timeout:30000},async t=>{
 let chromium;try{({chromium}=require(process.env.BLEACH_PLAYWRIGHT_PATH||'playwright'));}catch(error){t.skip('Set BLEACH_PLAYWRIGHT_PATH to the installed playwright package');return;}
 const initial=require('./sunucu/alliance-war').view({etkinlikSavas:{onur:20000}},80,100000),data={...initial,name:'RealPlayer',accountId:'one',room:null,rooms:[],pvpOpen:true},calls=[];
 const server=http.createServer(async(req,res)=>{
  if(req.url==='/'){res.setHeader('Content-Type','text/html; charset=utf-8');return res.end('<style>html,body{margin:0;overflow:hidden;background:#0b1019}</style><div id="sahne" style="width:1250px;height:650px;position:relative"></div><script src="/alliance.js"></script>');}
  if(req.url==='/alliance.js'){res.setHeader('Content-Type','application/javascript; charset=utf-8');return res.end(fs.readFileSync(path.join(__dirname,'gorsel/alliance-war.js')));}
  if(req.url.startsWith('/auth/alliance-war/')){const action=req.url.split('/').pop();let body='';for await(const c of req)body+=c;const value=JSON.parse(body||'{}');calls.push({action,value});res.setHeader('Content-Type','application/json');
   if(action==='view')return res.end(JSON.stringify(data));
   if(action==='create'){data.room={id:'room1',mode:value.mode,model:value.model,owner:'one',members:[{id:'one',name:'RealPlayer',level:80,ready:false}]};return res.end('{"ok":true}');}
   if(action==='leave'){data.room=null;return res.end('{"ok":true}');}
   if(action==='buy'){res.statusCode=400;return res.end(JSON.stringify({error:'Đã hết lượt mua.'}));}
   return res.end('{"ok":true}');
  }
  res.statusCode=404;res.end();
 });
 await new Promise(resolve=>server.listen(0,'127.0.0.1',resolve));let browser,debugPage;
 try{
  browser=await chromium.launch({executablePath:process.env.BLEACH_CHROME_PATH||'C:/Program Files/Google/Chrome/Application/chrome.exe',headless:true});const page=await browser.newPage({viewport:{width:1280,height:720}}),errors=[];debugPage=page;page.setDefaultTimeout(5000);page.on('pageerror',e=>errors.push(e.message));await page.goto('http://127.0.0.1:'+server.address().port);await page.evaluate(()=>window.openAllianceWar());await page.getByText('Danh sách đội',{exact:true}).waitFor();assert.match(await page.locator('.aw-stats').innerText(),/RealPlayer.*Honor/);
  await page.evaluate(()=>window.openAllianceWar('campaign'));await page.getByRole('heading',{name:'Alliance Campaign',exact:true}).waitFor();
  const stage=await page.locator('#sahne').boundingBox(),panel=await page.locator('#alliance-war').boundingBox();assert.deepEqual(panel,stage,'Campaign must occupy the game stage');
  await page.locator('select[name=model]').selectOption('16100201');await page.locator('input[name=password]').fill('secret');await page.getByRole('button',{name:'Tạo đội',exact:true}).click();await page.getByText('Đội của bạn',{exact:true}).waitFor();assert.deepEqual(calls.find(c=>c.action==='create').value,{mode:'pve',model:16100201,password:'secret'});
  await page.getByRole('button',{name:'Rời đội',exact:true}).click();await page.getByText('Danh sách đội',{exact:true}).waitFor();
  await page.locator('[data-tab="shop"]').click();await page.getByRole('heading',{name:'Honor Shop',exact:true}).waitFor();assert.ok(await page.locator('.aw-shop article').count()>20);assert.ok(await page.locator('.aw-item-icon').count()>20);await page.locator('button[data-row="11107001"]').click();await page.getByText('Đã hết lượt mua.',{exact:true}).waitFor();assert.equal(await page.locator('button[data-row="11107001"]').isEnabled(),true);
  if(process.env.BLEACH_ALLIANCE_SCREENSHOT)await page.screenshot({path:process.env.BLEACH_ALLIANCE_SCREENSHOT});
  await page.getByRole('button',{name:'Trở về game',exact:true}).click();assert.equal(await page.locator('#alliance-war').isVisible(),false);
  await page.evaluate(()=>window.allianceWarBattleStarted('native-test-scene'));assert.equal(await page.locator('#alliance-war').isVisible(),false);
  await page.evaluate(()=>window.allianceWarBattleEnded());await page.getByRole('heading',{name:'Lịch sử chiến đấu',exact:true}).waitFor();assert.equal(await page.locator('#alliance-war').isVisible(),true);assert.deepEqual(errors,[]);
 }catch(error){if(debugPage){console.error('UI calls:',calls.map(c=>c.action));console.error('UI text:',await debugPage.locator('body').innerText());if(process.env.BLEACH_ALLIANCE_SCREENSHOT)await debugPage.screenshot({path:process.env.BLEACH_ALLIANCE_SCREENSHOT});}throw error;}finally{await browser?.close();await new Promise(resolve=>server.close(resolve));}
});
test('bundled legacy Electron opens Campaign over the Flash stage with visible, clickable controls',{timeout:25000},async t=>{
 const electron=path.resolve(__dirname,'../oyun/electron.exe');if(!fs.existsSync(electron)){t.skip('Bundled Electron is Windows-only');return;}
 const os=require('node:os'),{spawn}=require('node:child_process'),dir=fs.mkdtempSync(path.join(os.tmpdir(),'alliance-legacy-'));
 const data={...require('./sunucu/alliance-war').view({etkinlikSavas:{onur:20000}},80,100000),name:'LegacyPlayer',accountId:'legacy',room:null,rooms:[]};
 const server=http.createServer((req,res)=>{
  if(req.url==='/alliance.js'){res.setHeader('Content-Type','application/javascript; charset=utf-8');return res.end(fs.readFileSync(path.join(__dirname,'gorsel/alliance-war.js')));}
  if(req.url==='/auth/alliance-war/view'){res.setHeader('Content-Type','application/json; charset=utf-8');return res.end(JSON.stringify(data));}
  res.setHeader('Content-Type','text/html; charset=utf-8');res.end('<style>html,body{margin:0;overflow:hidden;background:#0b1019}</style><div id="sahne" style="position:relative;width:1250px;height:650px"><div id="flashContent" style="width:1250px;height:650px;background:#ff00ff"></div></div><script>window.legacyErrors=[];window.onerror=function(message){legacyErrors.push(message);};</script><script src="/alliance.js"></script>');
 });
 await new Promise(resolve=>server.listen(0,'127.0.0.1',resolve));let child;
 const helper=path.join(dir,'app.js'),url='http://127.0.0.1:'+server.address().port;
 fs.writeFileSync(helper,`var electron=require('electron'),app=electron.app,win;app.setPath('userData',${JSON.stringify(path.join(dir,'profile'))});app.disableHardwareAcceleration();app.on('ready',function(){win=new electron.BrowserWindow({show:false,width:1280,height:720,webPreferences:{nodeIntegration:false,webSecurity:false}});win.webContents.on('did-finish-load',function(){win.webContents.executeJavaScript("window.openAllianceWar('campaign');");setTimeout(function(){win.webContents.executeJavaScript(${JSON.stringify("(function(){var p=document.getElementById('alliance-war'),s=document.getElementById('sahne'),r=p.getBoundingClientRect(),b=s.getBoundingClientRect(),button=p.querySelector('button[type=submit]'),h=p.querySelector('main h2');return {chrome:navigator.userAgent,insetSupported:CSS.supports('inset','0'),background:getComputedStyle(p).backgroundColor,cardBackground:getComputedStyle(p.querySelector('article')).backgroundColor,errors:window.legacyErrors,heading:h&&h.textContent,hidden:p.hidden,rect:{x:r.left,y:r.top,width:r.width,height:r.height},stage:{x:b.left,y:b.top,width:b.width,height:b.height},buttonVisible:!!button&&button.getBoundingClientRect().height>0,hitInside:p.contains(document.elementFromPoint(r.left+60,r.top+210))};})()")},false,function(result){console.log('ALLIANCE_LEGACY_RESULT '+JSON.stringify(result));${process.env.BLEACH_ALLIANCE_LEGACY_SCREENSHOT?'win.capturePage(function(image){require(\'fs\').writeFileSync('+JSON.stringify(process.env.BLEACH_ALLIANCE_LEGACY_SCREENSHOT)+',image.toPNG());app.quit();});':'app.quit();'}});},1000);});win.loadURL(${JSON.stringify(url)});});setTimeout(function(){app.exit(2);},18000);`);
 try{
  const output=await new Promise((resolve,reject)=>{let stdout='',stderr='';const legacyEnv={...process.env};delete legacyEnv.ELECTRON_RUN_AS_NODE;child=spawn(electron,[helper],{env:legacyEnv,windowsHide:true,stdio:['ignore','pipe','pipe']});child.stdout.on('data',c=>{stdout+=c;});child.stderr.on('data',c=>{stderr+=c;});child.on('error',reject);child.on('exit',code=>{const match=stdout.match(/ALLIANCE_LEGACY_RESULT (.+)/);if(!match)return reject(Error('Legacy Electron returned '+code+': '+stdout+' '+stderr.slice(-2000)));resolve(JSON.parse(match[1]));});});
  assert.equal(output.background,'rgb(11, 16, 25)','Overlay must have an opaque background in Chromium 59');assert.equal(output.cardBackground,'rgb(17, 25, 35)');assert.deepEqual(output.errors,[]);assert.equal(output.heading,'Alliance Campaign');assert.equal(output.hidden,false);assert.equal(output.buttonVisible,true);assert.equal(output.hitInside,true);assert.deepEqual(output.rect,output.stage);t.diagnostic(output.chrome+'; inset supported: '+output.insetSupported);
 }finally{if(child&&child.exitCode===null)child.kill();await new Promise(resolve=>server.close(resolve));assert.ok(path.resolve(dir).startsWith(path.resolve(os.tmpdir())+path.sep));fs.rmSync(dir,{recursive:true,force:true});}
});
