'use strict';
// Resolve every directly usable Article. Local defaults are recorded separately and editable.
const fs=require('fs'),path=require('path');
const {tablo,satir,cv,Y}=require('./paket');
const env=require('./envanter');
const OP_STATE=0x01180f7f;
const CONFIG=path.join(__dirname,'item-use-config.json');
let config;function options(){if(!config){try{config=JSON.parse(fs.readFileSync(CONFIG,'utf8'));}catch(e){config={items:{},fallbackQuantity:1};}}return config;}
const norm=s=>String(s||'').normalize('NFKD').replace(/[\u0300-\u036f]/g,'').toLowerCase().replace(/[^\p{L}\p{N}]/gu,'').replace(/hogyouku/g,'hogyoku').replace(/ulti amte|ultiamte/g,'ultimate');
const text=a=>String(a.functionDesc||'').replace(/<[^>]*>/g,' ').replace(/&nbsp;/g,' ').replace(/\s+/g,' ').trim();
const award=(code,amount=1)=>({type:1,code,amount});
const cash={silver:{type:0,code:0},coin:{type:0,code:0},gold:{type:0,code:1},coupon:{type:0,code:2},exp:{type:2,code:0},experience:{type:2,code:0},vitality:{type:3,code:0},prestige:{type:5,code:0},soul:{type:6,code:0},bluereishi:{type:7,code:3},purplereishi:{type:7,code:4},goldensoul:{type:7,code:5},goldenreishi:{type:7,code:5},redreishi:{type:7,code:6}};
const names=new Map();for(const a of tablo('Article').liste){const key=norm(a.name);if(!names.has(key))names.set(key,a._id);}
function byName(name){const key=norm(name);if(cash[key])return {...cash[key],amount:1};let id=names.get(key);if(!id)id=names.get(key.replace(/silverpack/g,'silvercard').replace(/^lv(\d+)silver$/,'lv$1silvercard').replace(/frozensoul/g,'frozenspirit').replace(/hollowspirit/g,'hollowsoul'));return id?award(id):null;}
function fixed(a){
 const desc=text(a);if(!/[*\u00d7]/.test(desc)||!/contains|\u5305\u542b/i.test(desc)&&/random|chance|\u968f\u673a/i.test(desc))return null;
 const results=[];let m;const re=/([^*\u00d7]+?)[*\u00d7]\s*(\d+(?:,\d{3})*)/g;
 while((m=re.exec(desc))){let name=m[1].replace(/^.*(?:contains|\u5305\u542b)\s*[:\uff1a]\s*/i,'').replace(/^[,\uff0c;\uff1b\s]+/,'').trim();const item=byName(name);if(!item)return null;item.amount=Number(m[2].replace(/,/g,''));if(!item.amount||item.code===a._id&&item.type===1)return null;results.push(item);}
 return results.length?{kind:'fixed',rewards:results,source:'description'}:null;
}
function equipment(a){
 const desc=text(a),combined=a.name+' '+desc;
 if(!/chest|box|\u7bb1/i.test(a.name))return null;
 let category=/accessor|ornament|\u9970/i.test(combined)?6:/h[o\u014d]gu|hogu/i.test(combined)?4:/equipment|equip|set|\u88c5\u5907|\u5957/i.test(combined)?2:0;
 if(!category)return null;
 const match=/\b(?:level|lv\.?|tier)\s*(\d+)/i.exec(desc)||/\b(?:lv\.?|tier)\s*(\d+)/i.exec(a.name);
 const lv=match?Number(match[1]):Math.max(1,Number(a.level)||1);
 let pool=tablo('Article').liste.filter(x=>x.majorType===category&&Number(x.level)===lv&&satir('BaseEquip',x._id));
 if(category!==4){const best=Math.max(0,...pool.map(x=>x.quality));pool=pool.filter(x=>x.quality===best);}
 if(/\bset\b|\u5957/i.test(a.name)){
  const prefix=norm(a.name.replace(/^Lv\.?\s*\d+\s*/i,'').replace(/(?:accessory\s*)?set\s*chest.*$/i,'').trim());
  let family=pool.filter(x=>norm(x.name).startsWith(prefix));
  if(!family.length)family=pool.filter(x=>norm(x.name).startsWith(prefix.replace(/soul/g,'spirit')));
  if(family.length){const slots={};for(const x of family)(slots[x.minorType]??=[]).push(x._id);return {kind:'set',slots,source:'equipment-table'};}
 }
 return pool.length?{kind:'choice',choices:pool.map(x=>award(x._id)),source:'equipment-table'}:null;
}
function gem(a){const m=/(?:lv\.?|level|tier)\s*(\d+)\s*(?:spirit|soul|gem|stone)/i.exec(a.name+' '+text(a));if(!m)return null;const pool=tablo('Article').liste.filter(x=>x.majorType===3&&Number(x.level)===Number(m[1])&&satir('BaseStone',x._id));return pool.length?{kind:'choice',choices:pool.map(x=>award(x._id)),source:'stone-table'}:null;}
function material(a){const desc=text(a),m=/lv\.?\s*(\d+)\s*(blue|purple|gold|golden|orange|red)/i.exec(desc+' '+a.name);if(!m)return null;const quality={blue:3,purple:4,gold:5,golden:5,orange:5,red:7}[m[2].toLowerCase()];const pool=tablo('Article').liste.filter(x=>x.majorType===5&&x.level===Number(m[1])&&x.quality===quality);return pool.length?{kind:'choice',choices:pool.map(x=>award(x._id)),source:'material-table'}:null;}
function fallback(a){
 const desc=text(a),combined=norm(a.name+' '+desc),quantity=Math.max(1,Number(options().fallbackQuantity)||1);
 const candidates=tablo('Article').liste.filter(x=>x._id!==a._id&&x.majorType===1&&/fragment|chip|\u788e\u7247/i.test(x.name));
 if(/fragment|chip|\u788e\u7247/i.test(a.name+' '+desc)){
  const ranked=candidates.map(x=>({x,score:(norm(x.name).match(/[a-z]{4,}/g)||[]).reduce((n,word)=>n+(combined.includes(word)?word.length:0),0)})).sort((a,b)=>b.score-a.score);
  if(ranked.length&&ranked[0].score>8)return {kind:'fixed',rewards:[award(ranked[0].x._id,quantity)],source:'local-default'};
 }
 const pool=tablo('Article').liste.filter(x=>x.majorType===5&&x.quality===Math.min(5,Math.max(3,a.quality||3)));
 return {kind:'choice',choices:(pool.length?pool:tablo('Article').liste.filter(x=>x.majorType===5)).map(x=>award(x._id,quantity)),source:'local-default'};
}
function resolve(id){
 const a=satir('Article',id);if(!a)return null;
 const override=options().items[String(id)];if(override)return override;
 const fx=Number(a.functionValue)||0;
 if(a._id===14100029)return {kind:'merits',value:1,source:'description'};
 if(fx===5)return fixed(a)||equipment(a)||gem(a)||material(a)||fallback(a);
 if(fx===1)return {kind:'exp',value:Number(a.f16),source:'article'};
 if(fx===3)return {kind:'silver',value:Number(a.f16),source:'article'};
 if(fx===9)return {kind:'hero',hero:Number(a.f16),source:'article'};
 if(fx===11)return {kind:'title',title:Number(a.f16),source:'article'};
 if(fx===12)return {kind:'partner-expand',value:Number(a.f16)||1,source:'article'};
 if(fx===13)return {kind:'topup-card',value:Number(a.f16),source:'article'};
 if(fx===6)return {kind:'bag-expand',source:'config'};
 if(fx===55){const m=/add\s+(Strength|Agility|Wisdom|Stamina)\s*(\d+)/i.exec(text(a));if(m)return {kind:'fruit',attribute:{strength:0,agility:2,wisdom:1,stamina:3}[m[1].toLowerCase()],value:Number(m[2]),source:'description'};}
 if(a.minorType===95&&/VIP.*Card/i.test(a.name))return {kind:'vip-trial',level:4,hours:24,source:'local-default'};
 if(fx===0&&a.majorType===1&&a.minorType===90)return material(a)||fallback(a);
 const currency=cash[norm(a.name)];if(fx===0&&a.minorType===100&&currency)return {kind:'fixed',rewards:[{...currency,amount:1}],source:'currency-conversion'};
 return {kind:'route',source:'feature-handler'};
}
function roll(recipe,count,profession=0,random=Math.random){
 const result=[];const choose=list=>list[Math.min(list.length-1,Math.floor(random()*list.length))];
 for(let i=0;i<count;i++){
  if(recipe.kind==='fixed')result.push(...recipe.rewards.map(x=>({...x})));
  if(recipe.kind==='choice')result.push({...choose(recipe.choices)});
  if(recipe.kind==='set')for(const ids of Object.values(recipe.slots)){
   const suitable=ids.filter(id=>{const x=satir('BaseEquip',id);const classes=String(x.dressProfession||'0').split('_').map(Number);return classes.includes(0)||classes.includes(profession);});result.push(award(choose(suitable.length?suitable:ids)));
  }
 }
 const sums=new Map();for(const x of result){const key=x.type+':'+x.code;const old=sums.get(key);if(old)old.amount+=x.amount;else sums.set(key,x);}return [...sums.values()];
}
let initial;function initialBag(){if(!initial){try{const b=fs.readFileSync(path.join(__dirname,'zaman',JSON.parse(fs.readFileSync(path.join(__dirname,'zaman/timeline.json'))).find(x=>x.dir==='s2c'&&/01180102/i.test(x.id)).file));let p=8;const skip=()=>{p+=2+b.readUInt16BE(p);};skip();p+=8;skip();p+=40;initial={capacity:Math.max(250,b.readUInt16BE(p)),count:b[p+2]};}catch(e){initial={capacity:100,count:0};}}return initial;}
function statePacket(d,usage=null){const bag=d.backpack||initialBag();return new Y().utf(JSON.stringify({capacity:bag.capacity,bagExpandCount:bag.count,heroAddSlotNum:Number(d.heroAddSlotNum)||0,...(usage||{})})).done();}
function audit(){return tablo('Article').liste.filter(a=>[1,12].includes(a.majorType)&&(String(a.costPrice)[0]==='1'||a.minorType===70)).map(a=>({id:a._id,name:a.name,minor:a.minorType,functionType:a.functionValue,...resolve(a._id)}));}
module.exports={resolve,roll,audit,options,CONFIG,OP_STATE,statePacket,initialBag};
