'use strict';
const {app,BrowserWindow}=require('electron'),fs=require('fs'),path=require('path');
const root=path.resolve(__dirname,'../../..'),out=path.join(__dirname,'validation');
fs.writeFileSync(path.join(out,'partner-runtime.log'),'');
const log=t=>fs.appendFileSync(path.join(out,'partner-runtime.log'),t+'\n');
app.commandLine.appendSwitch('ppapi-flash-path',path.join(root,'oyun/runtime/flashplayer/pepflashplayer.dll'));
app.commandLine.appendSwitch('ppapi-flash-version','22.0.0.209');
app.commandLine.appendSwitch('no-user-gesture-required');
app.on('ready',()=>{
 const win=new BrowserWindow({width:1250,height:650,useContentSize:true,show:false,webPreferences:{plugins:true,nodeIntegration:false,webSecurity:false,partition:'partner-isolated-validation'}});
 win.webContents.on('console-message',(e,l,m)=>log(m));
 win.loadURL('http://127.0.0.1:7438/gorsel/partner-probe.html');
 const timer=setInterval(()=>{
  const control=path.join(out,'partner-control.json');
  if(fs.existsSync(control)){
   const commands=JSON.parse(fs.readFileSync(control,'utf8'));fs.unlinkSync(control);
   for(const c of commands){
    if(c.quit){clearInterval(timer);app.quit();return;}
    if(c.reload)win.webContents.reload();
    if(c.x!=null){win.webContents.sendInputEvent({type:'mouseDown',x:c.x,y:c.y,button:'left',clickCount:1});win.webContents.sendInputEvent({type:'mouseUp',x:c.x,y:c.y,button:'left',clickCount:1});log('CLICK '+c.x+','+c.y);}
   }
  }
  win.webContents.capturePage(image=>fs.writeFileSync(path.join(out,'partner-latest.png'),image.toPNG()));
 },1500);
 setTimeout(()=>{clearInterval(timer);app.quit();},360000);
});
