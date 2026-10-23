'use strict';
const fs=require('fs'),path=require('path'),{MongoClient}=require('mongodb');
const valid=new Set(require('../veri-json/Article.json').map(r=>parseInt(r.id,16)));
for(const line of fs.readFileSync('.env','utf8').split(/\r?\n/)){const m=line.match(/^([A-Z_]+)=(.*)$/);if(m&&!process.env[m[1]])process.env[m[1]]=m[2].trim();}
if(process.env.MONGODB_DNS_SERVERS)require('dns').setServers(process.env.MONGODB_DNS_SERVERS.split(','));
function clean(text){const d=JSON.parse(text),removed=(d.envanter?.esyalar||[]).filter(x=>!valid.has(Number(x.code)));if(removed.length)d.envanter.esyalar=d.envanter.esyalar.filter(x=>valid.has(Number(x.code)));return {removed,text:removed.length?JSON.stringify(d,null,2):text};}
(async()=>{const client=new MongoClient(process.env.MONGODB_URI,{serverSelectionTimeoutMS:8000});try{
 await client.connect();const db=client.db(process.env.MONGODB_DB||'bleach_online');
 const a=await db.collection('accounts').findOne({username:'dqa0604'},{projection:{_id:1}});if(!a)throw Error('Account not found');
 const p=await db.collection('players').findOne({_id:a._id});if(!p?.files?.['oyuncu.json'])throw Error('Missing inventory');
 const result=clean(p.files['oyuncu.json']),dir=path.resolve('.accounts',a._id.toHexString());
 const backup=path.join(__dirname,'backups',String(Date.now()));fs.mkdirSync(backup,{recursive:true});fs.writeFileSync(path.join(backup,'database.json'),JSON.stringify(p));
 if(result.removed.length){const files={...p.files,'oyuncu.json':result.text};const update=await db.collection('players').updateOne({_id:a._id,files:p.files},{$set:{files,updatedAt:new Date()},$push:{adminChanges:{at:new Date(),action:'remove-invalid-inventory',items:result.removed}}});if(update.matchedCount!==1)throw Error('Concurrent update; stopped without overwriting');}
 for(const name of ['oyuncu.json','pending.json']){const f=path.join(dir,name);if(!fs.existsSync(f))continue;const original=fs.readFileSync(f,'utf8');fs.writeFileSync(path.join(backup,name),original);if(name==='oyuncu.json'){const x=clean(original);if(x.removed.length)fs.writeFileSync(f,x.text);}else{const journal=JSON.parse(original);if(journal.files?.['oyuncu.json']){const x=clean(journal.files['oyuncu.json']);if(x.removed.length){journal.files['oyuncu.json']=x.text;fs.writeFileSync(f,JSON.stringify(journal));}}}}
 const check=await db.collection('players').findOne({_id:a._id},{projection:{files:1}});if(clean(check.files['oyuncu.json']).removed.length)throw Error('Verification failed');
 console.log(JSON.stringify({account:'dqa0604',removed:result.removed,remaining:JSON.parse(check.files['oyuncu.json']).envanter.esyalar.length,backup}));
}finally{await client.close();}})().catch(e=>{console.error(e.name+': '+e.message);process.exitCode=1;});
