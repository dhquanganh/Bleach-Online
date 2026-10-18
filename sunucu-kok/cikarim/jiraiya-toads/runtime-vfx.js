'use strict';
// Isolated Flash graphics probe: exact VFX methods + installed sprites, no account/backend.
const {app,BrowserWindow}=require('electron'),fs=require('fs'),path=require('path'),http=require('http');
const base=__dirname,root=path.resolve(base,'../../..'),out=path.join(base,process.env.JIRAIYA_VFX_OUT||'validation/video-reference');
if(!fs.existsSync(out))fs.mkdirSync(out);
const logFile=path.join(out,'native-component.log');fs.writeFileSync(logFile,'');
const log=t=>fs.appendFileSync(logFile,t+'\n');
app.commandLine.appendSwitch('ppapi-flash-path',path.join(root,'oyun/runtime/flashplayer/pepflashplayer.dll'));
app.commandLine.appendSwitch('ppapi-flash-version','22.0.0.209');app.commandLine.appendSwitch('no-user-gesture-required');
let win,current='boot',impacts=0,done=false;
const capture=name=>{if(win)win.webContents.capturePage(img=>fs.writeFileSync(path.join(out,name+'.png'),img.toPNG()));};
const server=http.createServer((req,res)=>{
 let file;
 if(req.method==='POST'&&/^\/snapshot\?name=[a-z0-9-]+$/i.test(req.url)){let chunks=[];req.on('data',c=>chunks.push(c));req.on('end',()=>{const name=req.url.split('=')[1];fs.writeFileSync(path.join(out,name+'.jpg'),Buffer.from(Buffer.concat(chunks).toString(),'hex'));log('SNAPSHOT '+name);res.end('OK');});return;}
 if(req.url==='/'){res.setHeader('Content-Type','text/html');return res.end('<html><body style="margin:0;background:#000"><script>function vfxProbe(t){console.log(t)}function vfxSnapshot(name,hex){var x=new XMLHttpRequest();x.open("POST","/snapshot?name="+name);x.send(hex);}</script><object type="application/x-shockwave-flash" data="/probe.swf" width="1250" height="650"><param name="allowScriptAccess" value="always"></object></body></html>');}
 if(req.url==='/probe.swf')file=path.join(base,'vfx-probe.swf');
 else if(req.url==='/public/jiraiya-vfx/toad-esophagus-v1.jpg')file=path.join(base,'assets/toad-esophagus-v1.jpg');
 else if(/^\/public\/2026090619\/Resources\/Textures\/Model\/[A-F0-9]+\.TexClient$/.test(req.url))file=path.join(root,'sunucu-kok/kaynak/login.gogames.me',req.url);
 if(!file||!fs.existsSync(file)){log('HTTP 404 '+req.url);res.statusCode=404;return res.end();}
 res.setHeader('Content-Type',file.endsWith('.swf')?'application/x-shockwave-flash':file.endsWith('.jpg')?'image/jpeg':'application/octet-stream');res.end(fs.readFileSync(file));
});
app.on('ready',()=>server.listen(7446,'127.0.0.1',()=>{
 win=new BrowserWindow({width:1250,height:650,useContentSize:true,show:false,webPreferences:{plugins:true,nodeIntegration:false,webSecurity:false}});
 win.webContents.on('console-message',(e,l,msg)=>{
  log(msg);
  if(msg.indexOf('CASE ')==0){current=msg.replace(/[^a-z0-9]+/gi,'-');}
  if(msg.indexOf('VFX ')===0&&msg.indexOf('impact=true')>=0){impacts++;}
  if(msg.indexOf('DONE ')===0){done=true;setTimeout(()=>{capture('final');fs.writeFileSync(path.join(out,'runtime-result.json'),JSON.stringify({componentProbe:true,combatReplay:false,impacts,completed:done},null,2));setTimeout(()=>{server.close();app.quit();},400);},600);}
 });
 win.loadURL('http://127.0.0.1:7446/');
 setTimeout(()=>{if(!done){log('ERROR timeout');capture('timeout');server.close();app.quit();}},90000);
}));
