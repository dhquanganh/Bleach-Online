'use strict';
const {Y,tablo,satir,json,cv}=require('./paket');
const env=require('./envanter'),levels=require('./seviye');
const clone=d=>JSON.parse(JSON.stringify(d)),error=n=>new Y().u32(n).done();
const expansions=tablo('KnifeExpand').liste;
const bases=expansions.filter(r=>Number(r.level)===1&&satir('Knife',r.relationID)&&satir('Article',satir('Knife',r.relationID).handBookID));
const baseByRelation=new Map(bases.map(r=>[Number(r.relationID),r]));
function baseOf(id){const row=satir('KnifeExpand',id);return baseByRelation.get(Number(row?row.relationID:id));}
function state(d){
 const saved=d.zanpakuto||{},owned={};
 function accept(key,value){const base=baseOf(key);if(!base)return;const raw=value&&typeof value==='object'?value:{id:Number(key),exp:Number(value)||0};const row=satir('KnifeExpand',Number(raw.id));const id=row&&Number(row.relationID)===Number(base.relationID)?row._id:base._id;const old=owned[base._id];if(!old||Number(satir('KnifeExpand',old.id).level)<Number(satir('KnifeExpand',id).level))owned[base._id]={...raw,id,exp:Math.max(0,Math.floor(Number(raw.exp)||0))};}
 for(const [key,value]of Object.entries(saved))accept(Number(key),value);
 for(const id of d.bicak?.acik||[])if(baseOf(id)&&!owned[baseOf(id)._id])accept(id,{id:Number(id),exp:0});
 for(const [key,entry]of Object.entries(owned)){
  const old=d.bicak?.guc?.[entry.id]||d.bicak?.guc?.[key]||d.bicak?.guc?.[satir('KnifeExpand',entry.id).relationID];
  entry.strength=Array.from({length:3},(_,i)=>Math.max(1,Math.min(100,Math.floor(Number(entry.strength?.[i])||((Number(old?.[i])||0)+1)))));
  entry.strengthExp=Array.from({length:3},(_,i)=>Math.max(0,Math.floor(Number(entry.strengthExp?.[i])||0)));
 }
 d.zanpakuto=owned;d.bicak=d.bicak||{acik:[],sekil:0,guc:{}};
 const selected=baseOf(d.bicak.sekil);d.bicak.sekil=selected&&owned[selected._id]?owned[selected._id].id:0;
 return owned;
}
function selected(d){const owned=state(d),base=baseOf(d.bicak.sekil);return base?owned[base._id]||null:null;}
function info(d){const owned=state(d),rows=Object.values(owned),w=new Y().u16(rows.length);for(const row of rows)w.u32(row.id).u32(row.exp);w.u16(rows.length);for(const row of rows){w.i32(0).i32(row.id);for(const lv of row.strength)w.i32(lv);for(const xp of row.strengthExp)w.i32(xp);}return w.done();}
function phase(d,heroId){const out=[];for(const entry of Object.values(state(d))){const base=baseOf(entry.id),knife=satir('Knife',base.relationID),nodes=cv(61100001,[10,50,100]),stage=nodes.filter(n=>Math.min(...entry.strength)>=n).length-1;if(stage<0)continue;const row=satir('KnifeStrengthen',json(knife.activeEffects,[])[stage]);const heroes=json(row?.heros,[]),attrs=json(row?.attribute,[]);for(let i=0;i<heroes.length;i++)if(Number(heroes[i])===Number(heroId)&&attrs[i])out.push(attrs[i]);}return out;}
function bonuses(d,heroId,account=levels.veriOku(),pvp=false){
 const flat=new Map(),percent=new Map(),add=(m,t,v)=>m.set(Number(t),(m.get(Number(t))||0)+Number(v));
 const owned=state(d),active=selected(d),pos=Number(d.kadro?.[heroId])||(Number(d.karakter?.anaId)===Number(heroId)?6:0);
 if(active&&pos>0){const r=satir('KnifeExpand',active.id),effects=json(pos<=5?r.goldExp:pos<=10?r.needExp:r.f10,[]);for(const a of effects){if(Number(a.type)===101||Number(a.type)===11)add(percent,a.type,a.value);else add(flat,a.type,a.value);}}
 if(pvp&&Number(account.level)>=Number(cv(61100003,45))){
  for(const entry of Object.values(owned)){const knife=satir('Knife',satir('KnifeExpand',entry.id).relationID),types=json(knife.attributeType,[]),values=json(knife.baseValue,[]),growth=json(knife.growthValue,[]);for(let i=0;i<types.length;i++)add(flat,types[i],Number(values[i])+entry.strength[i]*Number(growth[i]));}
  for(const a of phase(d,heroId))if(Number(a.type)<200){if(Number(a.oper)===2)add(percent,a.type,a.value);else if(Number(a.oper)===1)add(flat,a.type,a.value);}
 }
 return {flat,percent};
}
function charPatch(buf,d,basicEnd){const out=Buffer.from(buf);try{let p=basicEnd(out),n=out.readUInt16BE(p);p+=2;for(let i=0;i<n;i++)p=require('./herolar').girisSonu(out,p);if(!Number.isInteger(p)||p+2>out.length)return buf;p+=2+out.readUInt16BE(p);if(p+8>out.length)return buf;const soul=Number(d.knifeSoul?.id);out.writeUInt32BE(satir('KnifeSoul',soul)?soul:18100001,p);out.writeUInt32BE(selected(d)?.id||0,p+4);return out;}catch{return buf;}}
function kur(y){
 function refresh(d){const account=levels.veriOku(),ids=new Set([levels.anaId(),...Object.keys(d.kadro||{}),...Object.keys(d.seviye?.herolar||{})].map(Number));for(const id of ids){if(!satir('BaseHero',id))continue;const lv=id===levels.anaId()?levels.anaDurum(account).lv:levels.heroDurum(d,id,account).lv;const p=require('./ekipman').statPaketi(d,id,lv);if(p)y.ekOnce(0x01180104,p,'ZANPAKUTO-stat');}}
 function commit(ctx,next,cost=[],counters){
  const account=levels.veriOku(),paid=cost.length?y.paraHarca(cost):null;if(cost.length&&!paid)return false;
  try{if(counters&&y.olay)y.olay.say(next,...counters);ctx.kaydet(next);}catch(e){if(cost.length)levels.veriYaz(account);return false;}
  Object.assign(ctx.durum,next);if(paid)y.ekOnce(0x01180105,paid,'ZANPAKUTO-cost');y.ekOnce(0x01180f00,env.loadBagPaketi(next),'ZANPAKUTO-bag');try{refresh(next);}catch(e){console.error('[Zanpakuto stats]',e.message);}return true;
 }
 const H={};
 H['0x01814101']=ctx=>info(ctx.durum);
 H['0x01814102']=ctx=>{
  if(ctx.payload?.length!==4)return error(4);const id=ctx.payload.readUInt32BE(0),base=baseOf(id);if(!base||id!==base._id)return error(4);
  const next=clone(ctx.durum),owned=state(next),row=satir('Knife',base.relationID),soul=satir('KnifeSoul',Number(next.knifeSoul?.id)||18100001);if(owned[base._id]||Number(soul?.level)<Number(base.quality))return error(1);
  if(!env.dus(next,Number(row.handBookID),1))return error(18);owned[base._id]={id:base._id,exp:0,strength:[1,1,1],strengthExp:[0,0,0]};
  if(!commit(ctx,next))return error(1);return new Y().u32(0).u32(base._id).done();
 };
 H['0x01814103']=ctx=>{
  if(ctx.payload?.length!==9)return error(4);const kind=ctx.payload[0],count=ctx.payload.readUInt32BE(1),id=ctx.payload.readUInt32BE(5);if(![1,2].includes(kind)||![1,50].includes(count))return error(4);
  const next=clone(ctx.durum),owned=state(next),base=baseOf(id),entry=base&&owned[base._id];if(!entry||entry.id!==id)return error(4);const row=satir('KnifeExpand',id),soul=satir('KnifeSoul',Number(next.knifeSoul?.id)||18100001);const nextStage=expansions.find(r=>Number(r.relationID)===Number(row.relationID)&&Number(r.level)===Number(row.level)+1);if(!nextStage||Number(soul?.level)<Number(nextStage.quality))return error(1);
  const amount=kind===2?10*count:Number(row.normalExp)*count,balance=levels.veriOku();if((Number(kind===2?balance.altin:balance.generalsSoul)||0)<amount)return error(kind===2?0x38:0x69);const cost=[{type:kind===2?0:6,code:kind===2?1:0,amount}];
  entry.exp+=Number(kind===2?row.f12:row.f11)*count;
  for(let i=0;i<4;i++){const cur=satir('KnifeExpand',entry.id),up=expansions.find(r=>Number(r.relationID)===Number(cur.relationID)&&Number(r.level)===Number(cur.level)+1),need=Number(cur.f13);if(!up||entry.exp<need||!(need>0))break;entry.exp-=need;entry.id=up._id;}
  if(Number(satir('KnifeExpand',entry.id).level)===4)entry.exp=0;if(next.bicak.sekil===id)next.bicak.sekil=entry.id;
  if(!commit(ctx,next,cost,[kind===2?'zanpakutoGodspeed':'zanpakutoTrain',count]))return error(1);
  return new Y().u32(0).u32(entry.id).u32(entry.exp).done();
 };
 H['0x01814104']=ctx=>{
  if(ctx.payload?.length!==5)return error(4);const op=ctx.payload[0],id=ctx.payload.readUInt32BE(1);if(![0,1].includes(op))return error(4);const next=clone(ctx.durum),owned=state(next),base=baseOf(id),entry=base&&owned[base._id];if(!entry||entry.id!==id)return error(4);if(op===0&&next.bicak.sekil!==id)return error(4);next.bicak.sekil=op===1?id:0;
  if(!commit(ctx,next))return error(1);return new Y().u32(0).u8(op).u32(id).done();
 };
 H['0x01814105']=ctx=>{
  if(ctx.payload?.length!==12)return error(4);const id=ctx.payload.readUInt32BE(0),index=ctx.payload.readInt32BE(4),requested=ctx.payload.readInt32BE(8),next=clone(ctx.durum),owned=state(next),base=baseOf(id),entry=base&&owned[base._id];if(!entry||entry.id!==id||index<0||index>2||Number(levels.veriOku().level)<Number(cv(61100003,45)))return error(4);
  const row=satir('KnifeExpand',id),lv=entry.strength[index],cost=satir('KnifeStrengExp',Number(row.knifeSoulAdded)*1000+lv),up=satir('KnifeStrengExp',Number(row.knifeSoulAdded)*1000+lv+1);if(!cost||!up||requested!==Number(cost.exp)||cv(61100001,[10,50,100]).includes(lv)&&entry.strength.some(n=>n<lv))return error(4);
  if(!env.dus(next,Number(cv(61100002,14100592)),Number(cost.exp)))return error(18);entry.strength[index]++;entry.strengthExp[index]=0;if(!commit(ctx,next))return error(1);
  return new Y().u32(0).i32(entry.id).i32(index).i32(entry.strength[index]).i32(0).done();
 };
 return H;
}
module.exports={bases,baseOf,state,selected,info,phase,bonuses,charPatch,kur};
