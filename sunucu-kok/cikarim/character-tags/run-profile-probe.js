'use strict';
const {app,BrowserWindow}=require('electron'),fs=require('fs'),path=require('path'),http=require('http');
const root=path.resolve(__dirname,'../../..'),work=path.join(__dirname,'2026102416');
const publicRoot=path.join(root,'sunucu-kok/kaynak/login.gogames.me/public');
app.commandLine.appendSwitch('ppapi-flash-path',path.join(root,'oyun/runtime/flashplayer/pepflashplayer.dll'));
app.commandLine.appendSwitch('ppapi-flash-version','22.0.0.209');
let done=false,win;
function finish(result){if(done)return;done=true;fs.writeFileSync(path.join(work,'probe-result.json'),JSON.stringify(result,null,2));server.close();app.quit();}
const server=http.createServer((req,res)=>{
 if(req.url==='/probe.swf'){res.setHeader('Content-Type','application/x-shockwave-flash');return res.end(fs.readFileSync(path.join(work,'probe.swf')));}
 if(/^\/public\/character-tags\/\d+\.png$/.test(req.url)){res.setHeader('Content-Type','image/png');return res.end(fs.readFileSync(path.join(publicRoot,'character-tags',path.basename(req.url))));}
 if(req.url!=='/'){res.statusCode=404;return res.end();}
 res.setHeader('Content-Type','text/html');res.end('<script>function probe(s){console.log(s)}</script><object type="application/x-shockwave-flash" data="/probe.swf" width="600" height="500"><param name="allowScriptAccess" value="always"></object>');
});
app.on('ready',()=>server.listen(7472,'127.0.0.1',()=>{
 win=new BrowserWindow({show:false,webPreferences:{plugins:true,nodeIntegration:false,webSecurity:false}});
 win.webContents.on('console-message',(event,level,message)=>{
  fs.appendFileSync(path.join(work,'probe-console.log'),message+'\n');
  if(/^PASS /.test(message))finish({completed:true,componentProbe:true,message,errors:[]});
  else if(/ERROR/.test(message))finish({completed:false,errors:[message]});
 });
 win.loadURL('http://127.0.0.1:7472/');setTimeout(()=>finish({completed:false,errors:['Native profile tag probe timeout']}),30000);
}));
