"use strict";
const fs=require('fs'),path=require('path'),{satir}=require('./paket'),blocked=require('./tower-gold-exclusions.json');
const publicRoot=path.resolve(__dirname,'../kaynak/login.gogames.me/public');
const files=new Set();
for(const version of fs.readdirSync(publicRoot).filter(v=>/^\d+$/.test(v))){
 const dir=path.join(publicRoot,version,'Resources/Textures/Model');if(!fs.existsSync(dir))continue;
 for(const f of fs.readdirSync(dir))if(/\.TexClient$/i.test(f)&&fs.statSync(path.join(dir,f)).size>0)files.add(f.toUpperCase());
}
function reason(heroId){
 if(!require('./retired-heroes').allowed(heroId))return 'Removed character';
 if(blocked[String(heroId)])return blocked[String(heroId)];
 const role=satir('RoleModel',heroId);if(!role)return 'Missing RoleModel';
 const model=Number(role.model);if(!model)return 'Missing model identifier';
 const missing=[10,11,12,13,14].filter(seq=>!files.has(((model*256+seq)>>>0).toString(16).toUpperCase().padStart(8,'0')+'.TEXCLIENT'));
 return missing.length?'Missing local animation sequences: '+missing.join(','):null;
}
module.exports={reason,allowed:id=>!reason(id)};
