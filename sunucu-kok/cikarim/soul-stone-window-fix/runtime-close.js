'use strict';
const {app,BrowserWindow}=require('electron'),fs=require('fs'),path=require('path'),http=require('http');
const root=path.resolve(__dirname,'../../..'),out=path.join(__dirname,'validation/native-close');for(const dir of [path.dirname(out),out])if(!fs.existsSync(dir))fs.mkdirSync(dir);
const errors=[];let win,done=false,closed=0;
fs.writeFileSync(path.join(out,'runtime.log'),'');
app.commandLine.appendSwitch('ppapi-flash-path',path.join(root,'oyun/runtime/flashplayer/pepflashplayer.dll'));
app.commandLine.appendSwitch('ppapi-flash-version','22.0.0.209');
app.commandLine.appendSwitch('no-user-gesture-required');
const server=http.createServer((req,res)=>{
 fs.appendFileSync(path.join(out,'runtime.log'),'HTTP '+req.url+'\n');
 if(req.url==='/'){res.setHeader('Content-Type','text/html');return res.end('<body style="margin:0;background:#263238"><script>function soulProbe(s){console.log(s)}</script><object type="application/x-shockwave-flash" data="/probe.swf" width="1250" height="650"><param name="allowScriptAccess" value="always"></object>');}
 const file=req.url==='/probe.swf'?path.join(__dirname,'close-probe.swf'):req.url==='/jade.swf'?path.join(root,'sunucu-kok/kaynak/login.gogames.me/public/2017112917/Resources/Swf/Lobby/20000000.swf'):null;
 if(!file){res.statusCode=404;return res.end();}res.setHeader('Content-Type','application/x-shockwave-flash');res.end(fs.readFileSync(file));
});
function capture(name,then){win.webContents.capturePage(img=>{fs.writeFileSync(path.join(out,name+'.png'),img.toPNG());if(then)then();});}
function finish(){if(done)return;done=true;fs.writeFileSync(path.join(out,'result.json'),JSON.stringify({componentProbe:true,fullGame:false,closed,cases:4,errors},null,2));capture('final',()=>{server.close();app.quit();});}
app.on('ready',()=>server.listen(7475,'127.0.0.1',()=>{
 win=new BrowserWindow({width:1250,height:650,useContentSize:true,show:false,webPreferences:{plugins:true,nodeIntegration:false,webSecurity:false}});
 win.webContents.on('console-message',(e,l,msg)=>{
  fs.appendFileSync(path.join(out,'runtime.log'),msg+'\n');if(msg.indexOf('ERROR ')===0)errors.push(msg);
  const ready=/^READY (\d+) (\d+) (\d+)$/.exec(msg);
  if(ready)capture('open-'+ready[1],()=>{win.webContents.sendInputEvent({type:'mouseMove',x:+ready[2],y:+ready[3]});win.webContents.sendInputEvent({type:'mouseDown',button:'left',x:+ready[2],y:+ready[3],clickCount:1});win.webContents.sendInputEvent({type:'mouseUp',button:'left',x:+ready[2],y:+ready[3],clickCount:1});});
  if(/^CLOSED /.test(msg)){closed++;capture('closed-'+msg.split(' ')[1]);}
  if(/^DONE /.test(msg)){if(closed!==4)errors.push('ERROR expected four closes');setTimeout(finish,300);}
 });win.loadURL('http://127.0.0.1:7475/');setTimeout(()=>{if(!done){errors.push('ERROR native close timeout');finish();}},25000);
}));
