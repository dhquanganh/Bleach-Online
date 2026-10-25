// Run in the game's Electron 1.8 runtime; no live player or account is used.
const {app,BrowserWindow}=require('electron'),http=require('http'),fs=require('fs'),path=require('path');
const root=path.resolve(__dirname,'../..');
const fixture=JSON.parse(fs.readFileSync(path.join(__dirname,'fixture.json'),'utf8'));
fixture.gold=123456;
const launcher=fs.readFileSync(path.join(root,'launcher.html'),'utf8');
const launcherStyle=launcher.match(/<style>([\s\S]*?)<\/style>/)[1];
const html='<!doctype html><meta charset="utf-8"><style>'+launcherStyle+'</style><div id="sahne" style="width:1250px;height:650px;position:relative"></div><script>'+ 
 'window.oturum={gatewayPort:10025,adminPort:7439};window.calls=0;window.fail=false;window.fetch=function(url,opts){if(opts.method==="POST"){window.calls++;return new Promise(function(resolve){setTimeout(function(){resolve({ok:!window.fail,json:function(){return Promise.resolve(window.fail?{error:"Test insufficient gold"}:{index:5,reward:{name:"Nguy\u00ean th\u1ea1ch",amount:100,picture:14900001},gold:122456})}})},50)})}return Promise.resolve({ok:true,json:function(){return Promise.resolve('+JSON.stringify(fixture)+')}})};</script><script src="/gorsel/myoboku.js"></script><script>openMyoboku();window.hiddenDuringLoad=getComputedStyle(document.getElementById("myoboku")).display==="none";</script>';
const server=http.createServer((req,res)=>{
 if(req.url==='/'){res.setHeader('Content-Type','text/html; charset=utf-8');return res.end(html);}
 if(req.url.indexOf('/api/item-ikon/')===0){res.setHeader('Content-Type','image/png');return res.end(fs.readFileSync(path.join(__dirname,'stone-atlas.png')));}
 // Use the real asset server and preserve its MIME headers. The legacy mode
 // reproduces the exact header that caused the unstyled in-game dialog.
 http.get('http://127.0.0.1:7440'+req.url,function(upstream){
  var chunks=[];upstream.on('data',c=>chunks.push(c));upstream.on('end',()=>{
   var headers=Object.assign({},upstream.headers);
   var css=req.url.indexOf('/gorsel/myoboku.css')===0;
   if(css&&process.env.MYOBOKU_BAD_MIME)headers['content-type']='application/octet-stream';
   setTimeout(()=>{res.writeHead(upstream.statusCode,headers);res.end(Buffer.concat(chunks));},css?300:0);
  });
 }).on('error',()=>{res.statusCode=502;res.end();});
});
app.on('ready',()=>server.listen(7439,'127.0.0.1',()=>{
 const w=new BrowserWindow({width:1250,height:650,useContentSize:true,show:false,webPreferences:{nodeIntegration:false}});
 w.loadURL('http://127.0.0.1:7439/');
 setTimeout(()=>{
  const script=`(function(){return new Promise(function(resolve){
    var h=document.getElementById('myoboku'),s=h.querySelector('.my-start'),popup=h.querySelector('.my-reward'),ok=h.querySelector('.my-reward-ok');
    h.querySelector('.my-skip').checked=true;s.click();s.click();h.querySelector('.my-close').click();var busy=!h.hidden&&s.disabled;
    setTimeout(function(){
      var win=h.querySelectorAll('.my-prize')[5].classList.contains('active')&&!s.disabled&&window.calls===1;
      var popupShown=!popup.hidden&&h.querySelector('.my-reward-amount').textContent.indexOf('100')>=0;
      s.click();var popupBlocksSpin=window.calls===1;ok.click();var acknowledged=popup.hidden;
      window.fail=true;s.click();
      setTimeout(function(){
        var error=h.querySelector('.my-message').textContent==='Test insufficient gold'&&!s.disabled&&popup.hidden;
        window.fail=false;h.querySelector('.my-skip').checked=false;s.click();
        var noEarlyReward=popup.hidden;
        setTimeout(function(){
          var animatedReward=!popup.hidden&&h.querySelectorAll('.my-prize')[5].classList.contains('active');
          ok.click();h.querySelector('.my-close').click();
          resolve({busy:busy,win:win,popupShown:popupShown,popupBlocksSpin:popupBlocksSpin,acknowledged:acknowledged,error:error,noEarlyReward:noEarlyReward,animatedReward:animatedReward,close:h.hidden,calls:window.calls});
        },4500);
      },150);
    },150);
  });})()`;
  w.webContents.executeJavaScript(script,false,result=>{
   w.webContents.executeJavaScript('(function(){var h=document.getElementById("myoboku");h.hidden=false;h.style.display="flex";var p=h.querySelector(".my-panel"),cells=h.querySelectorAll(".my-prize"),icon=h.querySelector(".my-item-icon"),canvas=document.createElement("canvas");canvas.width=40;canvas.height=40;var context=canvas.getContext("2d");context.drawImage(icon,0,0);var pixels=context.getImageData(0,0,40,40).data,transparent=false,opaque=false;for(var i=3;i<pixels.length;i+=4){if(pixels[i]===0)transparent=true;if(pixels[i]===255)opaque=true;}return {hiddenDuringLoad:window.hiddenDuringLoad,panelWidth:p.offsetWidth,wheelWidth:h.querySelector(".my-wheel").offsetWidth,position:getComputedStyle(cells[0]).position,iconFallbackHidden:getComputedStyle(h.querySelector(".my-gem")).display==="none",slots:cells.length,iconWidth:icon.naturalWidth,iconHeight:icon.naturalHeight,transparent:transparent&&opaque};})()',false,layout=>{
    result.layout=layout;
    fs.writeFileSync(path.join(__dirname,'ui-smoke-result.json'),JSON.stringify(result,null,2));
    setTimeout(()=>w.webContents.capturePage(image=>{
     fs.writeFileSync(path.join(__dirname,'fixed-preview.png'),image.toPNG());
     w.webContents.executeJavaScript('document.querySelector(".my-skip").checked=true;document.querySelector(".my-start").click();',false,()=>{
      setTimeout(()=>w.webContents.capturePage(popupImage=>{
       fs.writeFileSync(path.join(__dirname,'reward-preview.png'),popupImage.toPNG());
       w.webContents.executeJavaScript('(function(){var h=document.getElementById("myoboku"),popup=h.querySelector(".my-reward-card").getBoundingClientRect(),popupVisible=!h.querySelector(".my-reward").hidden;h.querySelector(".my-reward-ok").click();var scene=document.getElementById("sahne");scene.style.transform="scale(.64)";var p=h.querySelector(".my-panel").getBoundingClientRect(),r=h.querySelector(".my-wheel").getBoundingClientRect();return {panelWidth:p.width,wheelWidth:r.width,popupVisible:popupVisible,popupFits:popup.left>0&&popup.top>0&&popup.right<1250&&popup.bottom<650};})()',false,scaled=>{
        result.scaled=scaled;fs.writeFileSync(path.join(__dirname,'ui-smoke-result.json'),JSON.stringify(result,null,2));server.close();app.quit();
       });
      }),350);
     });
    }),250);
   });
  });
 },1500);
}));
