'use strict';
const {app,BrowserWindow}=require('electron');
const fs=require('fs'),path=require('path'),http=require('http');
const base=__dirname,root=path.resolve(base,'../../..'),out=path.join(base,'icon-validation');
if(!fs.existsSync(out))fs.mkdirSync(out,{recursive:true});fs.writeFileSync(path.join(out,'runtime.log'),'');
app.commandLine.appendSwitch('ppapi-flash-path',path.join(root,'oyun/runtime/flashplayer/pepflashplayer.dll'));
app.commandLine.appendSwitch('ppapi-flash-version','22.0.0.209');
let win,done=false,checks=0,errors=[];
const server=http.createServer((req,res)=>{
 if(req.url==='/probe.swf')return res.end(fs.readFileSync(path.join(base,'icon-probe.swf')));
 const m=req.url.match(/^\/Inventory\/(2017112917|2026090619)\/([A-F0-9]{8})\.TexClient$/);
 if(m){const file=path.join(root,'sunucu-kok/kaynak/login.gogames.me/public',m[1],'Resources/Textures/Inventory',m[2]+'.TexClient');if(fs.existsSync(file))return res.end(fs.readFileSync(file));res.statusCode=404;return res.end();}
 res.setHeader('Content-Type','text/html');res.end('<body style="margin:0"><script>function iconProbe(t){console.log(t)}</script><object type="application/x-shockwave-flash" data="/probe.swf" width="1250" height="650"><param name="allowScriptAccess" value="always"></object>');
});
function finish(){fs.writeFileSync(path.join(out,'result.json'),JSON.stringify({completed:done,checks,nativeSampleTicks:checks*5,errors},null,2));win.webContents.capturePage(image=>{fs.writeFileSync(path.join(out,'preview.png'),image.toPNG());server.close();app.quit();});}
app.on('ready',()=>server.listen(7460,'127.0.0.1',()=>{
 win=new BrowserWindow({width:1250,height:650,useContentSize:true,show:false,webPreferences:{plugins:true,nodeIntegration:false,webSecurity:false}});
 win.webContents.on('console-message',(event,level,message)=>{fs.appendFileSync(path.join(out,'runtime.log'),message+'\n');if(message.indexOf('ERROR')>=0)errors.push(message);if(message.indexOf('PASS ')===0)checks++;if(message==='DONE'&&!done){done=true;setTimeout(finish,150);}});
 win.loadURL('http://127.0.0.1:7460/');setTimeout(()=>{if(!done){errors.push('ERROR timeout');finish();}},15000);
}));
