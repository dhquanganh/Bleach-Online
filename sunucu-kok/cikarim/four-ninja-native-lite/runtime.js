'use strict';
const {app,BrowserWindow}=require('electron');
const fs=require('fs'),path=require('path'),http=require('http');
const character=process.argv[2];
const index=['sasuke','mecha','itachi','gaara'].indexOf(character);
if(index<0)throw new Error('Specify sasuke, mecha, itachi or gaara');
const speed=process.env.NINJA_SPEED==='2'?2:1;
const root=path.resolve(__dirname,'../../..'),base=path.join(__dirname,'probes',character);
function mkdir(dir){if(fs.existsSync(dir))return;mkdir(path.dirname(dir));fs.mkdirSync(dir);}
const out=path.join(base,'validation','x'+speed);mkdir(out);
const logFile=path.join(out,'runtime.log');fs.writeFileSync(logFile,'');
const log=text=>fs.appendFileSync(logFile,text+'\n');
let win,done=false,finished=false,cases=0,nativeLayers=0,cancellations=0,remainingLayers=null,errors=[],requests=[];
fs.writeFileSync(path.join(out,'result.json'),JSON.stringify({completed:false}));
app.commandLine.appendSwitch('ppapi-flash-path',path.join(root,'oyun/runtime/flashplayer/pepflashplayer.dll'));
app.commandLine.appendSwitch('ppapi-flash-version','22.0.0.209');
app.commandLine.appendSwitch('no-user-gesture-required');
const server=http.createServer((req,res)=>{
 if(req.method==='POST'&&/^\/snapshot\?name=[a-z0-9-]+$/i.test(req.url)){
  let chunks=[];req.on('data',c=>chunks.push(c));req.on('end',()=>{const name=req.url.split('=')[1];fs.writeFileSync(path.join(out,name+'.jpg'),Buffer.from(Buffer.concat(chunks).toString(),'hex'));log('SNAPSHOT '+name);res.end('OK');});return;
 }
 if(req.url==='/'){
  res.setHeader('Content-Type','text/html');
  return res.end('<html><body style="margin:0;background:#000"><script>function vfxProbe(t){console.log(t)}function vfxSnapshot(n,h){var x=new XMLHttpRequest();x.open("POST","/snapshot?name="+n);x.send(h);}</script><object type="application/x-shockwave-flash" data="/probe.swf" width="1250" height="650"><param name="allowScriptAccess" value="always"><param name="FlashVars" value="speed='+speed+'"></object></body></html>');
 }
 let file;
 if(req.url==='/probe.swf')file=path.join(base,'probe.swf');
 else if(/^\/public\/ninja-native-lite\/v1\/[a-z]+\/[a-z0-9_]+\.swf$/i.test(req.url)||/^\/public\/sasuke-vfx\/cinematic-v1\/[a-z0-9_]+\.swf$/i.test(req.url)||/^\/public\/2026090619\/Resources\/Textures\/Model\/[A-F0-9]+\.TexClient$/.test(req.url))file=path.join(root,'sunucu-kok/kaynak/login.gogames.me',req.url);
 if(!file||!fs.existsSync(file)){const message='ERROR HTTP 404 '+req.url;errors.push(message);log(message);res.statusCode=404;return res.end();}
 requests.push(req.url);res.setHeader('Content-Type',file.endsWith('.swf')?'application/x-shockwave-flash':'application/octet-stream');res.end(fs.readFileSync(file));
});
function finish(){
 if(finished)return;finished=true;
 const result={componentProbe:true,combatReplay:false,character,speed,completed:done,cases,nativeLayers,cancellations,remainingLayers,errors,requests:Array.from(new Set(requests))};
 fs.writeFileSync(path.join(out,'result.json'),JSON.stringify(result,null,2));
 win.webContents.capturePage(image=>{fs.writeFileSync(path.join(out,'final.png'),image.toPNG());server.close();app.quit();});
}
app.on('ready',()=>server.listen(7601+index+(speed===2?10:0),'127.0.0.1',()=>{
 win=new BrowserWindow({width:1250,height:650,useContentSize:true,show:false,webPreferences:{plugins:true,nodeIntegration:false,webSecurity:false}});
 win.webContents.on('console-message',(event,level,message)=>{
  log(message);if(message.indexOf('CASE ')===0)cases++;if(message.indexOf('NATIVE_LAYER ')===0)nativeLayers++;if(message.indexOf('CANCEL_OK ')===0)cancellations++;
  if(message.indexOf('ERROR')>=0)errors.push(message);
  if(message.indexOf('DONE ')===0&&!done){const match=message.match(/remaining=(\d+)/);remainingLayers=match?Number(match[1]):null;done=true;setTimeout(finish,500);}
 });
 win.loadURL('http://127.0.0.1:'+(7601+index+(speed===2?10:0))+'/');
 setTimeout(()=>{if(!done){errors.push('ERROR timeout');finish();}},480000);
}));
