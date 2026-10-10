'use strict';
// Surgical BaseHero repair. Preserve all unrelated database blocks/record bytes.
const fs=require('fs'),path=require('path'),zlib=require('zlib');
const root=path.resolve(__dirname,'../..'),file=path.join(root,'cikarim/veri-json/BaseHero.json');
const heroes=JSON.parse(fs.readFileSync(file,'utf8')),enemies=JSON.parse(fs.readFileSync(path.join(root,'cikarim/veri-json/Enemy.json'),'utf8'));
const pool=new Map();
for(const h of [...heroes,...enemies]) {
 let e;try{e=JSON.parse(h.attackEffect||h.effects||'{}');}catch{continue;}
 for(const [id,value]of Object.entries(e))if(!pool.has(id))pool.set(id,value);
}
const replacements=new Map(),repairs=[];
for(const h of heroes){
 const e=JSON.parse(h.attackEffect||'{}'),normal=String(h.normalAttack),active=String(h.active),missing=[];
 if(!e[normal]){if(!pool.has(normal))throw Error(`No normal animation for ${h.name}`);e[normal]=pool.get(normal);missing.push('normal: shared animation for the same skill ID');}
 if(!e[active]){e[active]=pool.get(active)||JSON.parse(JSON.stringify(e[normal]));missing.push(pool.has(active)?'active: shared animation for the same skill ID':'active: normal-animation fallback; original animation absent');}
 if(missing.length){const id=parseInt(h.id,16);h.attackEffect=JSON.stringify(e);replacements.set(id,h.attackEffect);repairs.push({id,name:h.name,normal:h.normalAttack,active:h.active,repairs:missing});}
}
function patch(raw){
 // Identify BaseHero by actual IDs as well as record count; never guess a DB ID.
 if(raw.length<12||raw.readUInt32LE(4)!==heroes.length||raw.readUInt32LE(8)!==parseInt(heroes[0].id,16))return null;
 let p=8,changed=0;const parts=[raw.subarray(0,8)];
 const utf=()=>{const start=p,n=raw.readUInt16LE(p);p+=2+n;if(p>raw.length)throw Error('Invalid BaseHero UTF');return start;};
 for(let i=0;i<heroes.length;i++){
  const start=p,id=raw.readUInt32LE(p);if(id!==parseInt(heroes[i].id,16))throw Error('BaseHero record order mismatch');p+=8;
  utf();utf();utf();p+=44+20+24+52+4;
  const effectStart=utf(),effectEnd=p;p+=16;utf();p+=4;utf();utf();
  const replacement=replacements.get(id);
  if(replacement){const text=Buffer.from(replacement),head=Buffer.alloc(2);if(text.length>65535)throw Error('Animation UTF too long');head.writeUInt16LE(text.length);parts.push(raw.subarray(start,effectStart),head,text,raw.subarray(effectEnd,p));changed++;}
  else parts.push(raw.subarray(start,p));
 }
 if(p!==raw.length)throw Error(`BaseHero schema mismatch ${p}/${raw.length}`);
 return changed?{raw:Buffer.concat(parts),changed}:null;
}
const changes=[];
function walk(dir){for(const e of fs.readdirSync(dir,{withFileTypes:true})){const f=path.join(dir,e.name);if(e.isDirectory())walk(f);else if(e.name==='01000005.bin'){
 const bytes=fs.readFileSync(f),result=patch(zlib.inflateSync(bytes));
 if(result)changes.push({file:f,bytes:zlib.deflateSync(result.raw),original:bytes,changed:result.changed});
}else if(e.name.endsWith('.binPackage')){
 const bytes=fs.readFileSync(f);let p=6,changed=0;const parts=[bytes.subarray(0,6)];
 for(let i=0;i<bytes.readUInt16LE(4);i++){const n=bytes.readUInt32LE(p);p+=4;const compressed=bytes.subarray(p,p+n);p+=n;const result=patch(zlib.inflateSync(compressed));const next=result?zlib.deflateSync(result.raw):compressed;const size=Buffer.alloc(4);size.writeUInt32LE(next.length);parts.push(size,next);if(result)changed+=result.changed;}
 parts.push(bytes.subarray(p));
 if(changed)changes.push({file:f,bytes:Buffer.concat(parts),original:bytes,changed});
}}}
walk(path.join(root,'kaynak/login.gogames.me/public'));
if(replacements.size&&!changes.length)throw Error('No frontend BaseHero package found; backend was not changed');
const manifest={repairs,frontendPackages:changes.map(c=>({file:path.relative(root,c.file),records:c.changed}))};
if(process.argv.includes('--apply') && replacements.size){
 const backup=path.join(__dirname,'backups',new Date().toISOString().replace(/[:.]/g,'-'));fs.mkdirSync(backup,{recursive:true});
 fs.copyFileSync(file,path.join(backup,'BaseHero.json'));
 for(const c of changes){const dest=path.join(backup,path.relative(root,c.file));fs.mkdirSync(path.dirname(dest),{recursive:true});fs.writeFileSync(dest,c.original);fs.writeFileSync(c.file,c.bytes);}
 fs.writeFileSync(file,JSON.stringify(heroes,null,2)+'\n');
 fs.writeFileSync(path.join(__dirname,'animation-repairs.json'),JSON.stringify(manifest,null,2)+'\n');
}
console.log(JSON.stringify({apply:process.argv.includes('--apply'),heroes:repairs.length,packages:changes.length,repairs},null,2));
module.exports={patch};
