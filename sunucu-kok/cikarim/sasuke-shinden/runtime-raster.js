'use strict';
// Isolated Flash component preview; no account, save or battle backend access.
const {app,BrowserWindow}=require('electron');
const fs=require('fs'),path=require('path'),http=require('http');
const base=__dirname,root=path.resolve(base,'../../..');
const revival=false;
const statusProbe=false;
const pixelProbe=process.env.SASUKE_PIXEL_PROBE==='1';
const probePort=pixelProbe?7473:7472;
const idleProbe=process.env.SASUKE_IDLE_PROBE==='1';
const recoveryProbe=process.env.SASUKE_RECOVERY_PROBE==='1';
const out=path.join(base,recoveryProbe?'validation/recovery-native':idleProbe?'validation/idle-native':pixelProbe?'validation/pixels':process.env.SASUKE_STREAM_PROBE==='1'?'validation/streaming':process.env.SASUKE_FOREST_PROBE==='1'?'validation/forest':process.env.SASUKE_STRESS_PROBE==='1'?'validation/stress':process.env.SASUKE_CINEMATIC_PROBE==='1'?'validation/cinematic-x'+(process.env.SASUKE_PROBE_RATE||'2'):process.env.SASUKE_KIRIN_BASELINE==='1'?'validation/kirin-before-x'+(process.env.SASUKE_PROBE_RATE||'2'):process.env.SASUKE_KIRIN_PROBE==='1'?'validation/kirin-fire-x'+(process.env.SASUKE_PROBE_RATE||'2'):process.env.SASUKE_PRESENTATION_PROBE==='1'?'validation/presentation-x'+(process.env.SASUKE_PROBE_RATE||'2'):process.env.SASUKE_COMPACT_PROBE==='1'?'validation/compact-x'+(process.env.SASUKE_PROBE_RATE||'2'):'validation/native');
if(!fs.existsSync(path.dirname(out)))fs.mkdirSync(path.dirname(out));if(!fs.existsSync(out))fs.mkdirSync(out);
const logFile=path.join(out,'runtime.log');fs.writeFileSync(logFile,'');
fs.writeFileSync(path.join(out,'result.json'),JSON.stringify({completed:false}));
const log=t=>fs.appendFileSync(logFile,t+'\n');
app.commandLine.appendSwitch('ppapi-flash-path',path.join(root,'oyun/runtime/flashplayer/pepflashplayer.dll'));
app.commandLine.appendSwitch('ppapi-flash-version','22.0.0.209');
app.commandLine.appendSwitch('no-user-gesture-required');
let win,done=false,cases=0,assets=0,powerLayers=0,atlases=0,missingFrames=0,restores=0,stableRestores=0,deathHolds=0,remainingLayers=null,errors=[];
const server=http.createServer((req,res)=>{
 if(req.method==='POST'&&/^\/snapshot\?name=[a-z0-9-]+$/i.test(req.url)){
  let chunks=[];req.on('data',c=>chunks.push(c));req.on('end',()=>{
   const name=req.url.split('=')[1];fs.writeFileSync(path.join(out,name+'.jpg'),Buffer.from(Buffer.concat(chunks).toString(),'hex'));
   log('SNAPSHOT '+name);res.end('OK');
  });return;
 }
 if(req.url==='/'){
  res.setHeader('Content-Type','text/html');
  return res.end('<html><body style="margin:0;background:#000"><script>function vfxProbe(t){console.log(t)}function vfxSnapshot(name,hex){var x=new XMLHttpRequest();x.open("POST","/snapshot?name="+name);x.send(hex);}</script><object type="application/x-shockwave-flash" data="/probe.swf" width="1250" height="650"><param name="allowScriptAccess" value="always"><param name="flashvars" value="speed='+(process.env.SASUKE_PROBE_RATE==='1'?'1':'2')+'"></object></body></html>');
 }
 let file;
 if(req.url==='/probe.swf')file=path.join(base,recoveryProbe?'recovery-probe.swf':idleProbe?'idle-probe.swf':pixelProbe?'pixel-probe.swf':statusProbe?'status-probe.swf':revival?'revival-probe.swf':'raster-probe.swf');
 else if(/^\/public\/sasuke-vfx\/cinematic-v1\/[a-z0-9_-]+\.swf$/i.test(req.url))file=path.join(root,'sunucu-kok/kaynak/login.gogames.me',req.url);
 else if(/^\/public\/sasuke-vfx\/(v3|extracted|large-v2|compact-v3|compact-v4|detail-v4|compact-v6|compact-v7|detail-v6)\/[a-z0-9_-]+\.(png|argb)$/i.test(req.url))file=path.join(root,'sunucu-kok/kaynak/login.gogames.me',req.url);
 else if(/^\/public\/2026090619\/Resources\/Textures\/Model\/[A-F0-9]+\.TexClient$/.test(req.url))file=path.join(root,'sunucu-kok/kaynak/login.gogames.me',req.url);
 if(!file||!fs.existsSync(file)){const msg='ERROR HTTP 404 '+req.url;log(msg);errors.push(msg);res.statusCode=404;return res.end();}
 res.setHeader('Content-Type',file.endsWith('.swf')?'application/x-shockwave-flash':file.endsWith('.png')?'image/png':'application/octet-stream');
 res.end(fs.readFileSync(file));
});
function finish(){
 if(missingFrames>0)errors.push('ERROR missing streamed frames: '+missingFrames);
 const result={componentProbe:true,combatReplay:false,completed:done,cases,restores,stableRestores,deathHolds,assetPlays:assets,powerLayers,atlasesLoaded:atlases,missingFrames,remainingLayers,errors};
 fs.writeFileSync(path.join(out,'result.json'),JSON.stringify(result,null,2));
 win.webContents.capturePage(img=>{
  fs.writeFileSync(path.join(out,'final.png'),img.toPNG());
  server.close();app.quit();
 });
}
app.on('ready',()=>server.listen(probePort,'127.0.0.1',()=>{
 win=new BrowserWindow({width:1250,height:650,useContentSize:true,show:false,webPreferences:{plugins:true,nodeIntegration:false,webSecurity:false}});
 win.webContents.on('console-message',(e,l,msg)=>{
  log(msg);
  if(msg.indexOf('CASE ')===0)cases++;
  if(msg.indexOf('VFX_ASSET ')===0)assets++;
  if(msg.indexOf('POWER_FX ')===0)powerLayers++;
  if(msg.indexOf('ATLAS ')===0)atlases++;
  if(msg.indexOf('MISSING_FRAME ')===0)missingFrames++;
  if(msg.indexOf('RESTORE_OK ')===0)restores++;
  if(msg.indexOf('RESTORE_STABLE ')===0)stableRestores++;
  if(msg.indexOf('DEATH_HOLD_OK ')===0)deathHolds++;
  if(msg.indexOf('ERROR')>=0)errors.push(msg);
  if(msg.indexOf('DONE ')===0&&!done){const match=msg.match(/remaining=(\d+)/);remainingLayers=match?Number(match[1]):null;done=true;setTimeout(finish,600);}
 });
 win.loadURL('http://127.0.0.1:'+probePort+'/');
 setTimeout(()=>{if(!done){errors.push('ERROR timeout');log('ERROR timeout');finish();}},300000);
}));
