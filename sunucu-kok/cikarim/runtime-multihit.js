'use strict';
// Isolated native Flash numeric check; no server or account state.
const {app,BrowserWindow}=require('electron'),fs=require('fs'),path=require('path'),http=require('http');
const root=path.resolve(__dirname,'../..'),work=path.join(__dirname,'hashirama-final/multihit-build');
app.commandLine.appendSwitch('ppapi-flash-path',path.join(root,'oyun/runtime/flashplayer/pepflashplayer.dll'));
app.commandLine.appendSwitch('ppapi-flash-version','22.0.0.209');
let win,finished=false;
function finish(result){if(finished)return;finished=true;fs.writeFileSync(path.join(work,'native-result.json'),JSON.stringify(result,null,2));server.close();app.quit();}
const server=http.createServer((req,res)=>{
 if(req.url==='/probe.swf'){res.setHeader('Content-Type','application/x-shockwave-flash');return res.end(fs.readFileSync(path.join(work,'probe.swf')));}
 res.setHeader('Content-Type','text/html');res.end('<script>function probe(s){console.log(s)}</script><object type="application/x-shockwave-flash" data="/probe.swf" width="1000" height="100"><param name="allowScriptAccess" value="always"></object>');
});
app.on('ready',()=>server.listen(7459,'127.0.0.1',()=>{
 win=new BrowserWindow({show:false,webPreferences:{plugins:true,nodeIntegration:false,webSecurity:false}});
 win.webContents.on('console-message',(event,level,message)=>{
  if(/^PASS /.test(message))finish({completed:true,message,errors:[]});
  else if(/ERROR/.test(message))finish({completed:false,errors:[message]});
 });
 win.loadURL('http://127.0.0.1:7459');setTimeout(()=>finish({completed:false,errors:['Native Flash timeout']}),30000);
}));
