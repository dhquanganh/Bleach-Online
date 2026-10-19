'use strict';
const assert=require('node:assert/strict'),test=require('node:test'),fs=require('node:fs'),os=require('node:os'),path=require('node:path');
const {fork}=require('node:child_process');
const root=fs.mkdtempSync(path.join(os.tmpdir(),'bleach-profile-'));
process.env.BLEACH_ACCOUNT_DIR=path.join(root,'viewer');fs.mkdirSync(process.env.BLEACH_ACCOUNT_DIR);
const {Y,O,tablo}=require('../paket'),profiles=require('../player-profile'),heroes=require('../herolar'),gear=require('../ekipman'),stats=require('../statlar');
function decode(payload){
  const r=new O(payload);assert.equal(r.u32(),0);const name=r.utf(),count=r.u16(),list=[];
  for(let i=0;i<count;i++){
    const start=r.p,end=heroes.girisSonu(payload,start);assert(end>start,'Each hero must parse completely');
    const id=payload.readUInt32BE(start),[a,z]=stats.attrAralik(payload,start);
    const inventory=gear.kayitlariOku(payload,z);
    list.push({id,level:payload.readUInt32BE(start+4),exp:payload.readUInt32BE(start+12),pos:payload[start+17],stats:stats.blokOku(payload.subarray(a,z)),inventory:inventory.kayitlar});r.p=end;
  }
  const quality=r.u32(),knife=r.u32();assert.equal(r.p,payload.length,'No stale captured packet tail');
  return {name,list,quality,knife};
}
async function snapshot(dir){
  return new Promise((resolve,reject)=>{
    const child=fork(path.resolve(__dirname,'../../arena-snapshot.cjs'),[],{env:{...process.env,BLEACH_ACCOUNT_DIR:dir},stdio:['ignore','ignore','pipe','ipc']});
    let result,error='';const timer=setTimeout(()=>{child.kill();reject(Error('Snapshot timeout'));},20000);
    child.on('message',m=>{result=m;});child.stderr.on('data',d=>{error+=d;});
    child.on('error',reject);child.on('exit',code=>{clearTimeout(timer);code===0&&result?.profile?resolve(result):reject(Error(error||'Missing profile'));});
  });
}
test('Inspector resolves exact role IDs across isolated accounts, updates equipment/formation, and never replays a bot',async()=>{
  try{
    const article=tablo('Article').liste.find(a=>Number(a.majorType)===2&&Number(a.minorType)===3);
    assert(article);
    function fixture(name,main,partners,level,roleLo){
      const dir=path.join(root,name);fs.mkdirSync(dir);
      const d={roleIdHi:7,roleIdLo:roleLo,nick:name,karakter:{nick:name,anaId:main},militaryRank:40100001,prestige:0,
        kadro:{[main]:6,...Object.fromEntries(partners.map((id,i)=>[id,10+i]))},
        seviye:{herolar:Object.fromEntries(partners.map((id,i)=>[id,{lv:12+i,exp:15}]))},
        ekipman:{goc:1,esyalar:{1001:{tpl:article._id,kat:2,slot:3,lvl:7,hole:0,app:[],gems:[]}},takili:{[main]:{3:1001}}},bicak:{sekil:0}};
      const v={level,deneyim:123,nick:name,herolar:partners,tumKarakterler:false};
      fs.writeFileSync(path.join(dir,'oyuncu.json'),JSON.stringify(d));fs.writeFileSync(path.join(dir,'veri.json'),JSON.stringify(v));return {dir,d,v};
    }
    const a=fixture('Profile A',11100001,[11120940,11120920],70,11),b=fixture('Profile B',11100005,[11120930],22,12);
    const files=dir=>['oyuncu.json','veri.json'].map(f=>fs.readFileSync(path.join(dir,f),'utf8'));
    const originalA=files(a.dir),originalB=files(b.dir);
    const sa=await snapshot(a.dir),sb=await snapshot(b.dir);
    assert.deepEqual(files(a.dir),originalA,'Viewing must not write the defender save');assert.deepEqual(files(b.dir),originalB);
    const row=p=>({id0:p.id0,id1:p.id1,profile:p}),viewer={roleIdHi:99,roleIdLo:99};
    const query=(hi,lo)=>profiles.inspect({durum:viewer,payload:new Y().u32(hi).u32(lo).done()});
    profiles.update([row(sa.profile),row(sb.profile)]);
    const pa=decode(query(7,11)),pb=decode(query(7,12));
    assert.equal(pa.name,'Profile A');assert.equal(pb.name,'Profile B');
    assert.deepEqual(pa.list.map(h=>h.id),[11100001,11120940,11120920]);assert.deepEqual(pb.list.map(h=>h.id),[11100005,11120930]);
    assert.deepEqual(pa.list.map(h=>h.level),[70,12,13]);assert.deepEqual(pb.list.map(h=>h.level),[22,12]);
    assert.deepEqual(pa.list.map(h=>h.pos),[6,10,11]);assert.equal(pa.list[0].inventory[0].lvl,7);
    assert.notDeepEqual(pa.list[0].stats,pb.list[0].stats,'Use target physical attributes, not viewer/captured stats');
    assert.equal(query(8,11).readUInt32BE(),1,'High ID matters');assert.equal(query(7,999).readUInt32BE(),1);
    assert.equal(profiles.inspect({durum:viewer,payload:Buffer.alloc(7)}).readUInt32BE(),1);
    assert.deepEqual(decode(query(7,11)),pa,'A -> B -> A must not retain B');
    b.d.kadro[11120930]=15;b.d.ekipman.esyalar[1001].lvl=19;
    fs.writeFileSync(path.join(b.dir,'oyuncu.json'),JSON.stringify(b.d));const changed=await snapshot(b.dir);
    profiles.update([row(sa.profile),row(changed.profile)]);
    const newer=decode(query(7,12));assert.equal(newer.list[1].pos,15);assert.equal(newer.list[0].inventory[0].lvl,19);
    assert.equal(decode(query(7,11)).list[0].inventory[0].lvl,7,'Same equipment instance ID in B must not alter A');
    profiles.update([row(sa.profile)]);assert.equal(query(7,12).readUInt32BE(),1,'Deleted/stale accounts disappear');
    profiles.update([{id0:7,id1:13,profile:sa.profile}]);assert.equal(query(7,13).readUInt32BE(),1,'Reject mismatched snapshot identities');
    for(const file of ['oyuncu.json','veri.json'])fs.copyFileSync(path.join(a.dir,file),path.join(process.env.BLEACH_ACCOUNT_DIR,file));
    stats.anaIdAyarla(a.d.karakter.anaId);
    const ownState=structuredClone(a.d),ownBefore=structuredClone(ownState);
    ownState.ekipman.esyalar[1001].lvl=25;
    const self=decode(profiles.inspect({durum:ownState,payload:new Y().u32(7).u32(11).done()}));
    assert.equal(self.list[0].inventory[0].lvl,25,'Self lookup reads current state, not published cache');
    assert.deepEqual(ownState,{...ownBefore,ekipman:{...ownBefore.ekipman,esyalar:{1001:{...ownBefore.ekipman.esyalar[1001],lvl:25}}}},'Inspect must not mutate source state');
    // The request registry must consume this opcode instead of timeline replay.
    const handlers=require('../sosyal').kur({});assert.equal(handlers['0x0181a000']({durum:viewer,payload:Buffer.alloc(8)}).readUInt32BE(),1);
  }finally{fs.rmSync(root,{recursive:true,force:true});}
});
