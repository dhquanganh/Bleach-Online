// Native Flash smoke-test shell. Runs against an isolated copied backend, never the live profile.
'use strict';
const {app,BrowserWindow}=require('electron'),fs=require('fs'),path=require('path');
const root=path.resolve(__dirname,'../../..'),out=path.join(__dirname,'validation');
if(!fs.existsSync(out))fs.mkdirSync(out);
const log=text=>fs.appendFileSync(path.join(out,'runtime.log'),text+'\n');
app.commandLine.appendSwitch('ppapi-flash-path',path.join(root,'oyun/runtime/flashplayer/pepflashplayer.dll'));
app.commandLine.appendSwitch('ppapi-flash-version','22.0.0.209');
app.commandLine.appendSwitch('no-user-gesture-required');
let win,sequence=0;
app.on('ready',()=>{
  win=new BrowserWindow({width:1250,height:650,useContentSize:true,show:false,webPreferences:{plugins:true,nodeIntegration:false,webSecurity:false,partition:'battlefield-validation'}});
  win.webContents.on('console-message',(e,level,message)=>log(message));
  win.loadURL('http://127.0.0.1:7428/gorsel/field-probe.html');
  const timer=setInterval(()=>{
    const control=path.join(out,'control.json');
    if(fs.existsSync(control)){
      const commands=JSON.parse(fs.readFileSync(control,'utf8'));fs.unlinkSync(control);
      for(const c of commands){
        setTimeout(()=>{
          if(c.quit){clearInterval(timer);app.quit();return;}
          if(c.reload)win.webContents.reload();
          if(c.capture&&/^[a-z0-9-]+\.png$/.test(c.capture))win.webContents.capturePage(image=>fs.writeFileSync(path.join(out,c.capture),image.toPNG()));
          if(c.x!=null){log('CLICK '+c.x+','+c.y);win.webContents.sendInputEvent({type:'mouseDown',x:c.x,y:c.y,button:'left',clickCount:1});win.webContents.sendInputEvent({type:'mouseUp',x:c.x,y:c.y,button:'left',clickCount:1});}
        },c.delay||0);
      }
    }
    sequence++;win.webContents.capturePage(image=>{fs.writeFileSync(path.join(out,'latest.png'),image.toPNG());});
  },2000);
  setTimeout(()=>{clearInterval(timer);app.quit();},600000);
});
app.on('window-all-closed',()=>app.quit());
