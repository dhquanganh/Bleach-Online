'use strict';
const fs=require('fs'),{MongoClient}=require('mongodb');
for(const line of fs.readFileSync('.env','utf8').split(/\r?\n/)){const m=line.match(/^([A-Z_]+)=(.*)$/);if(m&&!process.env[m[1]])process.env[m[1]]=m[2].trim();}
if(process.env.MONGODB_DNS_SERVERS)require('dns').setServers(process.env.MONGODB_DNS_SERVERS.split(','));
(async()=>{const c=new MongoClient(process.env.MONGODB_URI,{serverSelectionTimeoutMS:8000});
try{await c.connect();const db=c.db(process.env.MONGODB_DB||'bleach_online');
const a=await db.collection('accounts').findOne({username:'dqa0604'},{projection:{_id:1,username:1}});console.log(JSON.stringify(a));
if(a){const p=await db.collection('players').findOne({_id:a._id},{projection:{files:1,updatedAt:1}});fs.writeFileSync(__dirname+'/dqa0604-db.json',JSON.stringify(p));console.log('READ_ONLY_SNAPSHOT_SAVED');}}
catch(e){console.log('DB_READ_FAILED '+e.name);}finally{await c.close();}})();
