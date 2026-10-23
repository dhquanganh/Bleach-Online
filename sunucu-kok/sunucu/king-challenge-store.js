'use strict';
const fs=require('node:fs'),path=require('node:path');
// Shared by all account workers; no account credentials are stored here.
function createStore(file=process.env.BLEACH_KING_CHALLENGE_FILE||path.resolve(__dirname,'../../.accounts/king-challenge.json')){
  const lock=file+'.lock';
  return {transact(action){
    fs.mkdirSync(path.dirname(file),{recursive:true});
    try{fs.writeFileSync(lock,JSON.stringify({pid:process.pid}),{flag:'wx'});}
    catch(error){
      if(error.code!=='EEXIST')throw error;
      let stale=false;
      try{const pid=JSON.parse(fs.readFileSync(lock,'utf8')).pid;try{process.kill(pid,0);}catch(e){stale=e.code==='ESRCH';}}catch(e){stale=Date.now()-fs.statSync(lock).mtimeMs>60000;}
      if(!stale)throw Error('Tournament registry busy; retry');
      fs.unlinkSync(lock);fs.writeFileSync(lock,JSON.stringify({pid:process.pid}),{flag:'wx'});
    }
    const temporary=file+'.'+process.pid+'.tmp';
    try{
      const registry=fs.existsSync(file)?JSON.parse(fs.readFileSync(file,'utf8')):{version:1,seasons:{}};
      if(registry.version!==1||!registry.seasons)throw Error('Invalid tournament registry');
      const {result,commit}=action(registry);
      if(commit){fs.writeFileSync(temporary,JSON.stringify(registry));fs.renameSync(temporary,file);}
      return result;
    }finally{
      if(fs.existsSync(temporary))fs.unlinkSync(temporary);
      fs.unlinkSync(lock);
    }
  }};
}
module.exports={createStore};
