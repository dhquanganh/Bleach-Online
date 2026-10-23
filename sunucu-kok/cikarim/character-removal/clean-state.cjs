'use strict';
const fs=require('node:fs'),path=require('node:path');
const root=path.resolve(__dirname,'../../..'),policy=require('../../sunucu/retired-heroes');
let files=0;
function visit(dir){for(const e of fs.readdirSync(dir,{withFileTypes:true})){
 const file=path.join(dir,e.name);
 if(e.isDirectory()){if(!['node_modules','.git','runtime','cache','ffdec-home','native-export'].includes(e.name))visit(file);}
 else if(['oyuncu.json','veri.json'].includes(e.name)){
  const old=JSON.parse(fs.readFileSync(file,'utf8')),next=policy.clean(old);
  if(JSON.stringify(old)!==JSON.stringify(next)){fs.writeFileSync(file,JSON.stringify(next,null,2)+'\n');files++;}
 }
}}
for(const dir of ['.accounts','sunucu-kok/sunucu','.battlefield-runtime-test','.boss-runtime-test','.partner-runtime-test'])if(fs.existsSync(path.join(root,dir)))visit(path.join(root,dir));
const dbPath=path.join(root,'sunucu-kok/sunucu/oyun.db');let databaseRows=0;
if(fs.existsSync(dbPath)){
 const {DatabaseSync}=require('node:sqlite'),db=new DatabaseSync(dbPath);
 const remove=new Set([...policy.heroIds,...policy.fragmentIds,...policy.offerIds,...Array.from({length:12},(_,i)=>13120931+i),...Array.from({length:12},(_,i)=>13121401+i),...Array.from({length:5},(_,i)=>13220910+i),...Array.from({length:5},(_,i)=>13220980+i),13621931,13622401]);
 db.exec('BEGIN IMMEDIATE');
 try{
  for(const id of remove)databaseRows+=Number(db.prepare('DELETE FROM veri WHERE sayi=?').run(id).changes);
  for(const row of db.prepare('SELECT rowid,json FROM veri WHERE lower(json) LIKE ?').all('%kabuto%'))databaseRows+=Number(db.prepare('DELETE FROM veri WHERE rowid=?').run(row.rowid).changes);
  for(const table of db.prepare("SELECT name FROM sqlite_master WHERE type='table'").all()){
   if(!/^[a-zA-Z_][a-zA-Z_0-9]*$/.test(table.name))continue;
   const columns=db.prepare('PRAGMA table_info('+table.name+')').all();
   if(table.name==='veri'||!columns.some(c=>c.name==='json'))continue;
   for(const row of db.prepare('SELECT rowid,json FROM '+table.name).all()){
    let before;try{before=JSON.parse(row.json);}catch{continue;}
    const next=policy.clean(before);
    if(JSON.stringify(before)!==JSON.stringify(next)){db.prepare('UPDATE '+table.name+' SET json=? WHERE rowid=?').run(JSON.stringify(next),row.rowid);databaseRows++;}
   }
  }
  db.exec('COMMIT');
 }catch(e){db.exec('ROLLBACK');throw e;}finally{db.close();}
}
console.log('PASS removed character ownership/fragments from '+files+' local state files; '+databaseRows+' database rows removed/cleaned');
