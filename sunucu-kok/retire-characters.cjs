'use strict';
const fs=require('node:fs'),path=require('node:path'),crypto=require('node:crypto');
const {connect,ROOT,GAME,FILES}=require('./accounts.cjs');
const policy=require('./sunucu/retired-heroes');
const backup=path.join(ROOT,'.tools','retired-heroes',new Date().toISOString().replace(/[:.]/g,'-'));
function backupWrite(file,content){if(fs.readFileSync(file,'utf8')===content)return;const relative=path.relative(ROOT,file);if(relative.startsWith('..'))throw Error('Unexpected path');const saved=path.join(backup,'local',relative);fs.mkdirSync(path.dirname(saved),{recursive:true});fs.copyFileSync(file,saved);fs.writeFileSync(file,content);}
function cleanFile(file){if(!fs.existsSync(file))return;const original=fs.readFileSync(file,'utf8'),value=JSON.parse(original),next=policy.clean(value);if(JSON.stringify(value)!==JSON.stringify(next))backupWrite(file,JSON.stringify(next,null,2));}
const hash=value=>crypto.createHash('sha256').update(JSON.stringify(value)).digest('hex');
function snapshot(dir){return Object.fromEntries(FILES.filter(f=>fs.existsSync(path.join(dir,f))).map(f=>[f,fs.readFileSync(path.join(dir,f),'utf8')]));}
async function main(){const {client,db}=await connect();let changed=0;
 try{
  for await(const player of db.collection('players').find({})){
   const files=policy.cleanFiles(player.files||{});if(JSON.stringify(files)===JSON.stringify(player.files))continue;
   fs.mkdirSync(path.join(backup,'mongo'),{recursive:true});fs.writeFileSync(path.join(backup,'mongo',player._id.toString()+'.json'),JSON.stringify({...player,_id:player._id.toString()},null,2));
   const result=await db.collection('players').updateOne({_id:player._id,files:player.files},{$set:{files,updatedAt:new Date()}});if(result.modifiedCount!==1)throw Error('Account changed during migration; rerun after closing the game');changed++;
  }
  for(const name of ['veri.json','oyuncu.json','veri-varsayilan.json'])cleanFile(path.join(GAME,name));
  const accounts=path.join(ROOT,'.accounts');if(fs.existsSync(accounts))for(const entry of fs.readdirSync(accounts,{withFileTypes:true})){if(!entry.isDirectory()||!/^[a-f0-9]{24}$/.test(entry.name))continue;
   const dir=path.join(accounts,entry.name),sync=path.join(dir,'synced-hash'),before=snapshot(dir),wasSynced=fs.existsSync(sync)&&fs.readFileSync(sync,'utf8')===hash(before);
   for(const name of ['veri.json','oyuncu.json'])cleanFile(path.join(dir,name));
   const pending=path.join(dir,'pending.json');if(fs.existsSync(pending)){const value=JSON.parse(fs.readFileSync(pending));value.files=policy.cleanFiles(value.files);backupWrite(pending,JSON.stringify(value));}
   if(wasSynced)backupWrite(sync,hash(snapshot(dir)));
  }
  const config=path.join(GAME,'mystic-shop-config.json'),value=JSON.parse(fs.readFileSync(config));value.offers=value.offers.filter(o=>policy.allowed(o.heroID));backupWrite(config,JSON.stringify(value,null,2));
  for(const name of ['HeroChangeAttr','BlackMarket']){
   const file=path.join(ROOT,'sunucu-kok','cikarim','veri-json',name+'.json'),original=JSON.parse(fs.readFileSync(file));const rows=policy.filterTable(name,original);if(rows.length!==original.length)backupWrite(file,JSON.stringify(rows,null,2));
  }
  for(const name of ['mystic-shop-config.json'])await db.collection('game_config').updateOne({_id:name},{$set:{data:JSON.parse(fs.readFileSync(path.join(GAME,name)))}});
  console.log('Removed character ownership from MongoDB accounts:',changed);console.log('Backup:',backup);
 }finally{await client.close();}}
main().catch(e=>{console.error(e.message);process.exitCode=1});
