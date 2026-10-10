"use strict";
const {tablo}=require('./paket'),models=require('./tower-gold-models'),cfg=require('./cross-server-config.json');
const fs=require('fs'),path=require('path'),heads=new Set(),publicRoot=path.resolve(__dirname,'../kaynak/login.gogames.me/public');
for(const version of fs.readdirSync(publicRoot)){const dir=path.join(publicRoot,version,'Resources/Textures/HeadIcon');if(fs.existsSync(dir))for(const file of fs.readdirSync(dir))heads.add(file.toUpperCase());}
const hasPortrait=id=>{const role=tablo('RoleModel').byId.get(id);return role&&heads.has(Number(role.roleHead).toString(16).toUpperCase().padStart(8,'0')+'.TEXCLIENT');};
const pool=tablo('BaseHero').liste.filter(h=>Number(h.isMain)!==1&&models.allowed(h._id)&&hasPortrait(h._id)).filter(h=>{try{const e=JSON.parse(h.attackEffect);return e[h.normalAttack]&&e[h.active]&&tablo('SkillConfig').byId.has(Number(h.active));}catch(e){return false;}});
if(pool.length<cfg.teamSize)throw Error('Not enough playable Cross Server bot heroes');
let cached;
function random(seed){return ()=>{seed=(Math.imul(seed,1664525)+1013904223)>>>0;return seed/4294967296;};}
function all(){if(cached)return cached;const seen=new Set();cached=[];
 for(let id=1;id<=cfg.botCount;id++){const rng=random(cfg.botSeed+id*7919);let squad,key;
  do{const a=pool.slice();for(let i=a.length-1;i>0;i--){const j=Math.floor(rng()*(i+1));[a[i],a[j]]=[a[j],a[i]];}squad=a.slice(0,cfg.teamSize);key=squad.map(h=>h._id).join(',');}while(seen.has(key));seen.add(key);
  const positions=[1,2,6,7,11].slice();for(let i=positions.length-1;i>0;i--){const j=Math.floor(rng()*(i+1));[positions[i],positions[j]]=[positions[j],positions[i]];}
  cached.push({id,name:'Bot '+String(squad[0].name).trim()+' #'+String(id).padStart(4,'0'),server:'Local '+(1+id%20),heroes:squad.map(h=>h._id),positions,levelOffset:Math.floor(rng()*25)-12,power:0.65+rng()*0.85,score:Math.floor(rng()*10000),quality:Number(squad[0].quality)||3});
 }return cached;}
function get(id){return all()[Number(id)-1]||null;}
function team(id,level,row=0){const b=get(id);if(!b)return null;
 const difficulty=Math.max(0,Math.min(6,Math.floor(Number(row)||0))),baseLevel=Math.max(1,Math.min(159,level+b.levelOffset));
 return {...b,baseLevel,level:Math.round(Math.max(1,Math.min(159,level))*cfg.enemyLevelMultiplier*(1+difficulty*cfg.rowLevelStep)),crossAttackScale:cfg.enemyAttackMultiplier,crossStatScale:cfg.enemyStatMultiplier*(1+difficulty*cfg.rowStatStep),difficulty};
}
module.exports={all,get,team,poolSize:pool.length};
