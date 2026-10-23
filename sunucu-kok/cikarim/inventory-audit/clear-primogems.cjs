'use strict';
const fs=require('node:fs'),path=require('node:path'),assert=require('node:assert/strict'),{MongoClient}=require('mongodb');
const root=path.resolve(__dirname,'../../..'),inventory=require('../../sunucu/envanter');
const username='dqa0604',itemId=14900001;
for(const line of fs.readFileSync(path.join(root,'.env'),'utf8').split(/\r?\n/)){const m=line.match(/^([A-Z_]+)=(.*)$/);if(m&&!process.env[m[1]])process.env[m[1]]=m[2].trim();}
if(process.env.MONGODB_DNS_SERVERS)require('node:dns').setServers(process.env.MONGODB_DNS_SERVERS.split(','));
function cleared(text){
 const state=JSON.parse(text),before=inventory.mevcut(state,itemId),otherBefore=inventory.liste(state).filter(x=>Number(x.code)!==itemId);
 const stock=state.envanter;
 stock.esyalar=stock.esyalar.filter(x=>Number(x.code)!==itemId);
 delete stock.dusulen[String(itemId)];
 const base=inventory.mevcut({envanter:{esyalar:[],dusulen:{}}},itemId);
 if(base)stock.dusulen[String(itemId)]=base;
 assert.equal(inventory.mevcut(state,itemId),0);
 assert.deepEqual(inventory.liste(state).filter(x=>Number(x.code)!==itemId),otherBefore);
 return {before,text:JSON.stringify(state,null,2)};
}
(async()=>{
 const deadline=setTimeout(()=>{console.error('Database connection deadline exceeded; no inventory changes committed');process.exit(2);},25000);
 const client=new MongoClient(process.env.MONGODB_URI,{serverSelectionTimeoutMS:6000,connectTimeoutMS:5000});
 try{
  await client.connect();const db=client.db(process.env.MONGODB_DB||'bleach_online');
  const account=await db.collection('accounts').findOne({username},{projection:{_id:1,username:1}});assert(account&&account.username===username,'Account not found');
  const player=await db.collection('players').findOne({_id:account._id});assert(player?.files?.['oyuncu.json'],'Missing player inventory');
  const remote=cleared(player.files['oyuncu.json']);
  const dir=path.join(root,'.accounts',account._id.toHexString()),localFile=path.join(dir,'oyuncu.json'),pendingFile=path.join(dir,'pending.json');
  const localOriginal=fs.existsSync(localFile)?fs.readFileSync(localFile,'utf8'):null;
  const local=localOriginal?cleared(localOriginal):null;
  const pendingOriginal=fs.existsSync(pendingFile)?fs.readFileSync(pendingFile,'utf8'):null;
  const backup=path.join(__dirname,'backups','clear-primogems-'+Date.now());fs.mkdirSync(backup,{recursive:true});
  fs.writeFileSync(path.join(backup,'database.json'),JSON.stringify(player));
  if(localOriginal)fs.writeFileSync(path.join(backup,'oyuncu.json'),localOriginal);
  if(pendingOriginal)fs.writeFileSync(path.join(backup,'pending.json'),pendingOriginal);
  const files={...player.files,'oyuncu.json':remote.text};
  const update=await db.collection('players').updateOne({_id:account._id,files:player.files},{$set:{files,updatedAt:new Date()},$push:{adminChanges:{$each:[{at:new Date(),action:'clear-item',itemId,amount:remote.before,remaining:0}],$slice:-100}}});
  assert.equal(update.matchedCount,1,'Concurrent account update; reload before retry');
  if(local){assert.equal(fs.readFileSync(localFile,'utf8'),localOriginal,'Local inventory changed concurrently');fs.writeFileSync(localFile,local.text);}
  if(pendingOriginal){
   assert.equal(fs.readFileSync(pendingFile,'utf8'),pendingOriginal,'Pending state changed concurrently');
   const pending=JSON.parse(pendingOriginal);
   if(pending.files?.['oyuncu.json'])pending.files['oyuncu.json']=cleared(pending.files['oyuncu.json']).text;
   fs.writeFileSync(pendingFile,JSON.stringify(pending));
  }
  const verified=await db.collection('players').findOne({_id:account._id},{projection:{files:1}});
  assert.equal(inventory.mevcut(JSON.parse(verified.files['oyuncu.json']),itemId),0);
  if(local)assert.equal(inventory.mevcut(JSON.parse(fs.readFileSync(localFile,'utf8')),itemId),0);
  console.log(JSON.stringify({account:username,itemId,databaseRemoved:remote.before,localRemoved:local?.before??null,remaining:0,otherInventoryUnchanged:true}));
 }finally{clearTimeout(deadline);await client.close();}
})().catch(e=>{console.error(e.name+': '+e.message);process.exitCode=1;});
