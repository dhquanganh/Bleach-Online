'use strict';
const {app,BrowserWindow}=require('electron');
const fs=require('fs'),path=require('path'),http=require('http');
const base=__dirname,root=path.resolve(base,'../../..'),out=path.join(base,'validation');
if(!fs.existsSync(out))fs.mkdirSync(out,{recursive:true});
fs.writeFileSync(path.join(out,'runtime.log'),'');
app.commandLine.appendSwitch('ppapi-flash-path',path.join(root,'oyun/runtime/flashplayer/pepflashplayer.dll'));
app.commandLine.appendSwitch('ppapi-flash-version','22.0.0.209');
let win,done=false,errors=[],checks=0;
const server=http.createServer((req,res)=>{
 if(req.url==='/battle-ui.swf')return res.end(fs.readFileSync(path.join(base,'ui-81000000.swf')));
 if(req.url==='/probe.swf')return res.end(fs.readFileSync(path.join(base,'probe.swf')));
 res.setHeader('Content-Type','text/html');res.end('<body style="margin:0"><script>function speedProbe(t){console.log(t)}</script><object type="application/x-shockwave-flash" data="/probe.swf" width="1250" height="650"><param name="allowScriptAccess" value="always"></object>');
});
function finish(){
 fs.writeFileSync(path.join(out,'result.json'),JSON.stringify({completed:done,checks,errors},null,2));
 win.webContents.capturePage(image=>{fs.writeFileSync(path.join(out,'final.png'),image.toPNG());server.close();app.quit();});
}
app.on('ready',()=>server.listen(7459,'127.0.0.1',()=>{
 win=new BrowserWindow({width:1250,height:650,useContentSize:true,show:false,webPreferences:{plugins:true,nodeIntegration:false,webSecurity:false}});
 win.webContents.on('console-message',(event,level,message)=>{
  fs.appendFileSync(path.join(out,'runtime.log'),message+'\n');
  if(message.indexOf('ERROR')>=0)errors.push(message);
  if(message.indexOf('PASS ')===0)checks++;
  if(message.indexOf('STATE ')===0){const name=message.split(' ')[1];setTimeout(()=>win.webContents.capturePage(image=>fs.writeFileSync(path.join(out,name+'.png'),image.toPNG())),80);}
  if(message==='DONE'&&!done){done=true;setTimeout(finish,100);}
 });
 win.loadURL('http://127.0.0.1:7459/');
 setTimeout(()=>{if(!done){errors.push('ERROR timeout');finish();}},20000);
}));
