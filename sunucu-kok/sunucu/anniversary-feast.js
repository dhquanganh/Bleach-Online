'use strict';
// CoolSummer's native indices are a state machine, not generic claim tiers.
const fs=require('fs'),path=require('path');
const row=JSON.parse(fs.readFileSync(path.join(__dirname,'../cikarim/veri-json/CoolSummer.json'),'utf8'))[0];
const repository=JSON.parse(row.repository),shop=JSON.parse(row.scoreShop);
const settings=require('./anniversary-feast-config');
const META=62000001;
function create({day=()=>require('./paket').gun(),random=()=>require('crypto').randomInt(0,16777216)/16777216,configuration=settings.read,resolve=id=>require('./etkinlik').odulCoz(id),active=id=>require('./etkinlik').acikMi(id),charge,grantHero,ownsHero=()=>false,canReceive=()=>true}={}){
 function pick(){const pool=repository.filter(x=>x.rate>0),total=pool.reduce((n,x)=>n+x.rate,0);let n=random()*total;return (pool.find(x=>(n-=x.rate)<0)||pool.at(-1)).awardId;}
 function board(locks=[]){const pairs=locks.map(x=>x[0]);while(pairs.length<8)pairs.push(pick());const cards=pairs.flatMap(x=>[x,x]);for(let i=cards.length-1;i>0;i--){const j=Math.floor(random()*(i+1));[cards[i],cards[j]]=[cards[j],cards[i]];}return cards;}
 function state(d,wire){d.anniversaryFeast||={};const s=d.anniversaryFeast[wire]||={score:0,shop:{},claimed:[],locks:[],used:0};if(s.day!==day()){s.day=day();s.used=0;s.cards=board(s.locks);s.states=Array(16).fill(0);s.locks=[];}return s;}
 const box=(idx,st=0,kosul=[])=>({idx,st,kosul,acq:0});
 function boxes(s,c,d,wire){const end=require('./etkinlik').pencere(wire)?.bitis||0;return [box(META,0,[c.heroId,c.price,c.revision,Math.floor(end/1000)]),box(18,0,s.cards),box(19,0,s.locks.flat()),box(16,s.used),box(20,s.score),...s.states.map((v,i)=>box(i,v)),...shop.map(x=>box(x.index,x.count&&s.shop[x.index]>=x.count?-1:0)),box(61,s.claimed.includes(c.heroId)||ownsHero(c.heroId,d)?-1:0)];}
 function init(wire,d){return boxes(state(d,wire),configuration(),d,wire);}
 function operate(wire,index,args,d){const c=configuration(),s=state(d,wire),bad=()=>({hata:80,oduller:[],bildir:boxes(s,c,d,wire)});if(!active(wire))return bad();const previous=new Map(boxes(s,c,d,wire).map(b=>[b.idx,JSON.stringify(b)])),next=structuredClone(s);let cost=0,rewards=[],hero=0;
  if(index>=0&&index<16||index===17){if(args.length)return bad();const slots=index===17?next.states.flatMap((v,i)=>v===0?[i]:[]):[index];if(!slots.length||slots.some(i=>next.states[i]!==0))return bad();const free=Math.min(Math.max(0,5-next.used),slots.length);next.used+=free;cost=(slots.length-free)*10;if(index===17)cost=Math.floor(cost*.9);for(const i of slots){next.states[i]=1;const j=next.states.findIndex((v,j)=>j!==i&&v===1&&next.cards[j]===next.cards[i]);if(j!==-1){next.states[i]=next.states[j]=-1;rewards.push(...resolve(next.cards[i]));}}}
  else if(index===18){if(args.length)return bad();cost=10;next.cards=board(next.locks);next.states=Array(16).fill(0);next.locks=[];}
  else if(index===19){if(next.locks.length||!args.length||args.length%2||args.length>6)return bad();const seen=new Set();for(let i=0;i<args.length;i+=2){const r=repository.find(x=>x.awardId===args[i]);if(!r||args[i+1]!==i/2||seen.has(r.awardId))return bad();seen.add(r.awardId);next.locks.push([r.awardId,i/2]);cost+=r.gold;}}
  else if(index===61){if(args.length!==1||args[0]!==c.revision||next.claimed.includes(c.heroId)||ownsHero(c.heroId,d)||next.score<c.price)return bad();next.score-=c.price;next.claimed.push(c.heroId);hero=c.heroId;}
  else {const offer=shop.find(x=>x.index===index);if(!offer||args.length||next.score<offer.score||offer.count&&next.shop[index]>=offer.count)return bad();rewards=resolve(offer.awardId);if(!rewards.length)return bad();next.score-=offer.score;next.shop[index]=(next.shop[index]||0)+1;}
  if(next.score+cost>2147483647)return bad();
  if(!canReceive(d,rewards)){const result=bad();result.bildir.push(box(62000002,7));return result;}
  if(cost&&!charge(cost,d))return {hata:16,oduller:[],bildir:boxes(s,c,d,wire)};
  if(hero)grantHero(hero,d);next.score+=cost;d.anniversaryFeast[wire]=next;
  const notice=hero?4:index===19?5:index===18?6:rewards.length?2:1;
  return {hata:0,oduller:rewards,bildir:[...boxes(next,c,d,wire).filter(b=>b.idx===META||(index===18&&b.idx===18)||JSON.stringify(b)!==previous.get(b.idx)),box(62000002,notice)]};
 }
 return {init,operate};
}
module.exports={create,META,repository,shop};
