'use strict';
const {app,BrowserWindow}=require('electron'),fs=require('fs'),path=require('path'),http=require('http');
const root=path.resolve(__dirname,'../../..');let win,finished=false;
app.commandLine.appendSwitch('ppapi-flash-path',path.join(root,'oyun/runtime/flashplayer/pepflashplayer.dll'));
app.commandLine.appendSwitch('ppapi-flash-version','22.0.0.209');
function finish(result){
 if(finished)return;finished=true;
 fs.writeFileSync(path.join(__dirname,'native-result.json'),JSON.stringify(result,null,2));
 win.webContents.capturePage(img=>{fs.writeFileSync(path.join(__dirname,'foreground.png'),img.toPNG());server.close();app.quit();});
}
const server=http.createServer((req,res)=>{
 res.setHeader('Cache-Control','no-store');
 if(req.url.startsWith('/probe.swf')){res.setHeader('Content-Type','application/x-shockwave-flash');return res.end(fs.readFileSync(path.join(__dirname,'probe.swf')));}
 res.setHeader('Content-Type','text/html');res.end('<body style="margin:0"><script>function probe(s){console.log(s)}</script><object type="application/x-shockwave-flash" data="/probe.swf" width="1250" height="650"><param name="allowScriptAccess" value="always"></object>');
});
app.on('ready',()=>server.listen(7471,'127.0.0.1',()=>{
 win=new BrowserWindow({width:1250,height:650,useContentSize:true,show:false,webPreferences:{plugins:true,nodeIntegration:false,webSecurity:false}});
 win.webContents.on('console-message',(event,level,message)=>{
  if(message.startsWith('PASS ')){const result=JSON.parse(message.slice(5));setTimeout(()=>finish(Object.assign({completed:true},result,{componentProbe:true,fullGameplay:false,errors:[]})),400);}
  else if(message.indexOf('ERROR')>=0)finish({completed:false,errors:[message]});
 });
 win.loadURL('http://127.0.0.1:7471');setTimeout(()=>finish({completed:false,errors:['Native Flash timeout']}),30000);
}));
