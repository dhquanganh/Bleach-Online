'use strict';
const {app,BrowserWindow}=require('electron'),fs=require('fs'),path=require('path'),http=require('http');
const mode=process.env.PROFILE_PROBE_BASELINE==='1'?'baseline':'fixed',port=mode==='baseline'?7462:7463;
const root=path.resolve(__dirname,'../../..'),work=path.join(__dirname,'first-open/probe'),out=path.join(work,mode+'-result.json');
app.commandLine.appendSwitch('ppapi-flash-path',path.join(root,'oyun/runtime/flashplayer/pepflashplayer.dll'));
app.commandLine.appendSwitch('ppapi-flash-version','22.0.0.209');
let done=false,win;
function finish(result){if(done)return;done=true;fs.writeFileSync(out,JSON.stringify(result,null,2));server.close();app.quit();}
const server=http.createServer((req,res)=>{
 if(req.url==='/probe.swf'){res.setHeader('Content-Type','application/x-shockwave-flash');return res.end(fs.readFileSync(path.join(work,mode+'.swf')));}
 res.setHeader('Content-Type','text/html');res.end('<script>function probe(s){console.log(s)}</script><object type="application/x-shockwave-flash" data="/probe.swf" width="1000" height="100"><param name="allowScriptAccess" value="always"></object>');
});
app.on('ready',()=>server.listen(port,'127.0.0.1',()=>{
 win=new BrowserWindow({show:false,webPreferences:{plugins:true,nodeIntegration:false,webSecurity:false}});
 win.webContents.on('console-message',(event,level,message)=>{
  fs.appendFileSync(path.join(work,mode+'-console.log'),message+'\n');
  if(/^PASS /.test(message))finish({completed:true,message,errors:[]});
  else if(/ERROR/.test(message))finish({completed:false,errors:[message]});
 });
 win.loadURL('http://127.0.0.1:'+port);setTimeout(()=>finish({completed:false,errors:['Native Inspector probe timeout']}),30000);
}));
