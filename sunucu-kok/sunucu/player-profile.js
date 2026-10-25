'use strict';
// Only public character data is distributed between account workers.
const {Y,tablo}=require('./paket');
const levels=require('./seviye'),equipment=require('./ekipman'),heroes=require('./herolar');
const profiles=new Map(),achievements=new Map();
const key=(hi,lo)=>`${hi>>>0}:${lo>>>0}`;

function snapshot(state,account=levels.veriOku()) {
  const d=structuredClone(state),main=Number(d.karakter?.anaId);
  if(!main||!tablo('BaseHero').byId.has(main))return null;
  const owned=new Set([main,...(Array.isArray(account.herolar)?account.herolar:[]),...require('./meyhane').alinanlar(d),...Object.keys(d.kadro||{}).filter(id=>Number(d.kadro[id])>0)].map(Number));
  if(account.tumKarakterler===true||account.tumKarakterler==='true')for(const hero of heroes.gecerliHerolar())owned.add(hero.id);
  const parts=[];
  for(const id of owned){
    const row=tablo('BaseHero').byId.get(id);
    if(!row||!require('./retired-heroes').allowed(id)||(id!==main&&Number(row.isMain)===1)||row.isSummon)continue;
    const level=levels.heroSeviye(d,id,account),stats=equipment.statPaketi(d,id,level);
    if(!stats)throw Error('Cannot compute public character attributes');
    const skill=id===main?require('./beceri').ana(d):Number(row.active)||0;
    const hero=heroes.heroGirisi({id,profession:Number(row.profession)||0,skill},level,stats.subarray(4));
    hero[17]=Math.max(0,Math.min(15,Number(d.kadro?.[id])||(id===main?6:0)));
    parts.push(hero);
  }
  if(!parts.length||parts[0].readUInt32BE(0)!==main)return null;
  // Reuse the login serializer for saved equipment, rebirth, awakening and equipped jade.
  const list=equipment.charYama(new Y().u16(parts.length).raw(Buffer.concat(parts)).done(),d,()=>0);
  const row=tablo('BaseHero').byId.get(main);
  const name=String(d.karakter.nick||d.nick||account.nick||'');
  const knife=Number(d.bicak?.sekil)||0;
  const starRows=parts.map(part=>part.readUInt32BE(0)).filter(id=>id!==main).map(id=>[id,require('./hero-stars').count(d,id)]);
  const packet=new Y().u32(0).utf(name).raw(list).u32(Number(row.quality)||1).u32(knife).u16(starRows.length);
  for(const [id,stars] of starRows)packet.u32(id).u8(stars);
  return {id0:d.roleIdHi>>>0,id1:d.roleIdLo>>>0,payload:packet.done().toString('base64'),achievementPayload:new Y().u32(0).utf(name).raw(require('./title-achievements').info(d,account)).done().toString('base64')};
}

function update(rows){
  profiles.clear();achievements.clear();
  for(const row of Array.isArray(rows)?rows:[]){
    const profile=row?.profile;
    if(profile&&profile.id0===row.id0&&profile.id1===row.id1&&typeof profile.payload==='string')profiles.set(key(row.id0,row.id1),profile.payload);
    if(profile&&profile.id0===row.id0&&profile.id1===row.id1&&typeof profile.achievementPayload==='string')achievements.set(key(row.id0,row.id1),profile.achievementPayload);
  }
}
function inspect({payload,durum}){
  if(!Buffer.isBuffer(payload)||payload.length!==8)return new Y().u32(1).done();
  const hi=payload.readUInt32BE(0),lo=payload.readUInt32BE(4);
  if(hi===(durum.roleIdHi>>>0)&&lo===(durum.roleIdLo>>>0)){
    const profile=snapshot(durum);return profile?Buffer.from(profile.payload,'base64'):new Y().u32(1).done();
  }
  const profile=profiles.get(key(hi,lo));
  return profile?Buffer.from(profile,'base64'):new Y().u32(1).done();
}
module.exports={snapshot,update,inspect};

module.exports.achievement=function({payload,durum}){
 const {Y}=require('./paket');if(payload?.length!==8)return new Y().u32(4).done();
 const hi=payload.readUInt32BE(0),lo=payload.readUInt32BE(4);
 if(hi===(durum.roleIdHi>>>0)&&lo===(durum.roleIdLo>>>0))return new Y().u32(0).utf(durum.karakter?.nick||durum.nick||'').raw(require('./title-achievements').info(durum)).done();
 const data=achievements.get(key(hi,lo));return data?Buffer.from(data,'base64'):new Y().u32(4).done();
};
