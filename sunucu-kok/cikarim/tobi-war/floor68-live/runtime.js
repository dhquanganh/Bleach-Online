'use strict';
// Full native client against a copied account and an isolated local gateway.
const {app,BrowserWindow}=require('electron'),fs=require('fs'),path=require('path'),http=require('http'),spawn=require('child_process').spawn;
const base=__dirname,root=path.resolve(base,'../../../..'),pub=path.join(root,'sunucu-kok/kaynak/login.gogames.me/public');
let win,gateway,server,finished=false,sawPlay=false,lastAction=0;
const versions=fs.readdirSync(pub).filter(v=>/^\d+$/.test(v)),resolved={};
const log=m=>fs.appendFileSync(path.join(base,'runtime.log'),m+'\n');fs.writeFileSync(path.join(base,'runtime.log'),'');
app.setPath('userData',path.join(base,'electron-data'));
app.commandLine.appendSwitch('ppapi-flash-path',path.join(root,'oyun/runtime/flashplayer/pepflashplayer.dll'));
app.commandLine.appendSwitch('ppapi-flash-version','22.0.0.209');
function fileFor(url){
 const p=decodeURIComponent(url.split('?')[0]);
 if(p==='/game.swf')return path.join(base,'probe.swf');
 if(p==='/wrapper.swf')return path.join(root,'sunucu-kok/cikarim/flash-boss/runtime-probe/probe.swf');
 if(p.indexOf('/public/')===0){if(resolved[p])return resolved[p];const rel=p.replace(/^\/public\/\d+\//,'');for(const f of [path.join(pub,p.slice(8)),path.join(pub,'2026090619',rel),path.join(pub,'2017112917',rel)].concat(versions.map(v=>path.join(pub,v,rel))))if(fs.existsSync(f)&&fs.statSync(f).isFile())return resolved[p]=f;}
 const f=path.join(root,'sunucu-kok',p);return fs.existsSync(f)&&fs.statSync(f).isFile()?f:null;
}
function finish(reason){if(finished)return;finished=true;log('FINISH '+reason);win.webContents.capturePage(img=>{fs.writeFileSync(path.join(base,'final.png'),img.toPNG());if(gateway)gateway.kill();server.close();app.quit();});}
app.on('ready',()=>{
 const out=fs.openSync(path.join(base,'gateway.log'),'w');
 gateway=spawn(path.join(root,'node/node.exe'),['-r',path.join(base,'capture.cjs'),path.join(root,'sunucu-kok/sunucu/oyun-sunucu.js')],{env:Object.assign({},process.env,{BLEACH_PORT:'10065',BLEACH_POLICY_PORT:'1843',BLEACH_ACCOUNT_DIR:path.join(base,'state'),BLEACH_GAME_TOKEN:'floor68-isolated-probe'}),stdio:['ignore',out,out],windowsHide:true});
 const version=JSON.parse(fs.readFileSync(path.join(base,'source-version.json'),'utf8')).version;
 server=http.createServer((req,res)=>{
  if(req.url==='/'){const vars='target=/game.swf&cdnRoot=http://127.0.0.1:7498/public/&version='+version+'&gatewayIP=127.0.0.1&gatewayPort=10065&token=floor68-isolated-probe&agent=54&server=974&isCombin=0&username=floor68-isolated-probe&flag=1&isAdult=1&time=1793020000&isNew=1&lang=en&payurl=&fightreporturl=&support=&officeurl=';res.end('<body style="margin:0"><script>function bossProbe(t){console.log(t)}</script><object id="probe" type="application/x-shockwave-flash" data="/wrapper.swf" width="1250" height="650"><param name="allowScriptAccess" value="always"><param name="flashvars" value="'+vars.replace(/&/g,'&amp;')+'"></object>');return;}
  const f=fileFor(req.url);if(!f){log('MISSING '+req.url);res.statusCode=404;res.end();return;}res.end(fs.readFileSync(f));
 });
 server.listen(7498,'127.0.0.1',()=>{
  win=new BrowserWindow({width:1250,height:650,useContentSize:true,show:false,webPreferences:{plugins:true,nodeIntegration:false,webSecurity:false}});
  win.webContents.on('console-message',(e,l,msg)=>{log(msg);if(/^(CMD |PLAY |NEXT )/.test(msg)){lastAction=Date.now();if(msg.indexOf('PLAY ')===0)sawPlay=true;}if(msg==='BATTLE_END'&&sawPlay)setTimeout(()=>finish('battle completed'),1500);});
  win.loadURL('http://127.0.0.1:7498/');
  function call(name){win.webContents.executeJavaScript('(function(){var p=document.getElementById("probe");if(p&&typeof p.'+name+'==="function"){p.'+name+'();console.log("CALL '+name+'");}else console.log("NOT_READY '+name+'");})()');}
  setTimeout(()=>call('goldProbeEnter'),15000);setTimeout(()=>call('goldProbeFight'),22000);
  setTimeout(()=>{win.webContents.sendInputEvent({type:'mouseDown',x:748,y:635,button:'left',clickCount:1});win.webContents.sendInputEvent({type:'mouseUp',x:748,y:635,button:'left',clickCount:1});},35000);
  let n=0;setInterval(()=>{if(finished)return;win.webContents.capturePage(img=>fs.writeFileSync(path.join(base,'latest.png'),img.toPNG()));if(sawPlay&&Date.now()-lastAction>18000)finish('stalled after last action');const control=path.join(base,'control.json');if(fs.existsSync(control)){const c=JSON.parse(fs.readFileSync(control));fs.unlinkSync(control);if(c.call)call(c.call);if(c.quit)finish('requested');}n++;},2000);
  setTimeout(()=>finish('timeout'),300000);
 });
});
