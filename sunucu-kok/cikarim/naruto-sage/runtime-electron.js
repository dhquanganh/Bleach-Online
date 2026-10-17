'use strict';
// Self-contained native resource probe: no game backend or player account.
const {app,BrowserWindow}=require('electron'),fs=require('fs'),path=require('path'),http=require('http');
const root=path.resolve(__dirname,'../../..');
const out=path.join(__dirname,'validation');if(!fs.existsSync(out))fs.mkdirSync(out);
fs.writeFileSync(path.join(out,'native.log'),'');
app.commandLine.appendSwitch('ppapi-flash-path',path.join(root,'oyun/runtime/flashplayer/pepflashplayer.dll'));
app.commandLine.appendSwitch('ppapi-flash-version','22.0.0.209');
app.commandLine.appendSwitch('no-user-gesture-required');
const server=http.createServer((req,res)=>{
  if(req.url==='/') {res.setHeader('Content-Type','text/html');return res.end('<html><body style="margin:0"><script>function narutoProbe(t){console.log(t);}</script><object type="application/x-shockwave-flash" data="/native-probe.swf" width="1000" height="730"><param name="allowScriptAccess" value="always"></object></body></html>');}
  let target=null;
  if(req.url==='/native-probe.swf')target=path.join(__dirname,'native-probe.swf');
  else if(/^\/public\/2026090619\/Resources\/Textures\/Model\/[A-F0-9]+\.TexClient$/.test(req.url))target=path.join(root,'sunucu-kok/kaynak/login.gogames.me',req.url);
  if(!target||!fs.existsSync(target)){res.statusCode=404;return res.end();}
  res.setHeader('Content-Type',target.endsWith('.swf')?'application/x-shockwave-flash':'application/octet-stream');res.end(fs.readFileSync(target));
});
app.on('ready',()=>server.listen(7439,'127.0.0.1',()=>{
  const win=new BrowserWindow({width:1000,height:730,useContentSize:true,show:false,webPreferences:{plugins:true,nodeIntegration:false,webSecurity:false}});
  win.webContents.on('console-message',(event,level,message)=>fs.appendFileSync(path.join(out,'native.log'),message+'\n'));
  win.loadURL('http://127.0.0.1:7439/');
  setTimeout(()=>win.webContents.capturePage(image=>fs.writeFileSync(path.join(out,'native-assets.png'),image.toPNG())),12000);
  setTimeout(()=>{server.close();app.quit();},15000);
}));
