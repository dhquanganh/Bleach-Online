'use strict';
const {test}=require('node:test'),assert=require('node:assert/strict'),http=require('node:http'),path=require('node:path'),fs=require('node:fs'),{spawn}=require('node:child_process');
const root=path.resolve(__dirname,'..'),base=path.join(__dirname,'cikarim/myoboku');
function request(url){return new Promise((resolve,reject)=>http.get(url,res=>{let body='';res.on('data',c=>body+=c);res.on('end',()=>resolve({status:res.statusCode,type:res.headers['content-type'],body}));}).on('error',reject));}
async function stop(child){if(child.exitCode!==null)return;await new Promise(resolve=>{child.once('exit',resolve);child.kill();});}
test('real server MIME and Electron dialog layout, including old-server CSS headers', {timeout:60000},async()=>{
 const server=spawn(process.execPath,[path.join(__dirname,'serve.mjs'),'--port','7440'],{cwd:root,stdio:['ignore','pipe','pipe'],windowsHide:true});
 try{
  await new Promise((resolve,reject)=>{server.stdout.on('data',c=>{if(c.toString().includes('http://127.0.0.1:7440/'))resolve();});server.once('error',reject);server.once('exit',code=>reject(Error('Asset server exited: '+code)));});
  const css=await request('http://127.0.0.1:7440/gorsel/myoboku.css');assert.equal(css.status,200);assert.match(css.type,/^text\/css/);assert.match(css.body,/#myoboku\{/);
  fs.writeFileSync(path.join(base,'fixture.json'),JSON.stringify(require('./sunucu/myoboku-config').view()));
  const nativeIcon=require('./admin-item-icon.cjs')(14900001);assert.ok(nativeIcon);fs.writeFileSync(path.join(base,'stone-atlas.png'),nativeIcon.data);
  for(const legacy of [false,true]){
   const env={...process.env};delete env.ELECTRON_RUN_AS_NODE;if(legacy)env.MYOBOKU_BAD_MIME='1';else delete env.MYOBOKU_BAD_MIME;
   await new Promise((resolve,reject)=>{const child=spawn(path.join(root,'oyun/electron.exe'),[path.join(base,'ui-smoke.js')],{cwd:root,env,stdio:'ignore',windowsHide:true});child.once('error',reject);child.once('exit',code=>code===0?resolve():reject(Error('Electron exited: '+code)));});
   const result=JSON.parse(fs.readFileSync(path.join(base,'ui-smoke-result.json'),'utf8'));
   assert.equal(result.busy,true);assert.equal(result.win,true);assert.equal(result.error,true);assert.equal(result.close,true);assert.equal(result.calls,3);
   for(const key of ['popupShown','popupBlocksSpin','acknowledged','noEarlyReward','animatedReward'])assert.equal(result[key],true,key);
   assert.deepEqual(result.layout,{hiddenDuringLoad:true,panelWidth:738,wheelWidth:405,position:'absolute',iconFallbackHidden:true,slots:8,iconWidth:40,iconHeight:40,transparent:true});
   assert.ok(Math.abs(result.scaled.panelWidth-738*.64)<1);assert.ok(Math.abs(result.scaled.wheelWidth-405*.64)<1);
   assert.equal(result.scaled.popupVisible,true);assert.equal(result.scaled.popupFits,true);
  }
 }finally{await stop(server);}
});
