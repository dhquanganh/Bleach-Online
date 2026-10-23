'use strict';
const assert=require('node:assert/strict');
const fs=require('node:fs'),os=require('node:os'),path=require('node:path');
const dir=fs.mkdtempSync(path.join(os.tmpdir(),'bleach-tenso-'));
process.env.BLEACH_ACCOUNT_DIR=dir;
const root=path.resolve(__dirname,'..');
for(const name of ['veri.json','oyuncu.json'])fs.copyFileSync(path.join(root,name),path.join(dir,name));
const t=require('../tenso'),battle=require('../savas'),codec=require('../kodek'),p=require('../paket'),levels=require('../seviye');
const originalReport=battle.kadroRapor;
try{
  let v={level:159,vipLevel:0},canPay=true,saves=0,won=true;
  const packets=[],charges=[],grants=[];
  const H=t.kur({seviye:levels,tensoAccount:()=>v,
    ekSonra:(id,payload)=>packets.push({id,payload}),
    paraHarca:list=>{if(!canPay)return null;charges.push(list);return Buffer.from([1]);},
    odulVer:(d,list)=>grants.push(list)});
  const d={},ctx=id=>({durum:d,payload:new p.Y().u32(id).done(),kaydet:()=>saves++});
  const init=H['0x01818400'](ctx(0));assert.equal(init.readInt32BE(0),0);assert.equal(init.readInt16BE(4),6);
  for(let i=0;i<6;i++)assert(t.armies(t.rows()[i]).some(a=>a._id===init.readInt32BE(6+i*4)));
  const row=t.rows()[0],id=row._id;
  assert(H['0x01818401'](ctx(id)).readInt16BE(12)>0,'preview contains real enemy skills');
  v.level=1;
  for(const op of ['01','02','03'])assert.equal(H['0x018184'+op] (ctx(id)).readInt32BE(0),4);
  v.level=159;
  for(const payload of [Buffer.alloc(0),Buffer.alloc(3),Buffer.alloc(5),new p.Y().u32(1).done()])
    assert.equal(H['0x01818403']({...ctx(id),payload}).readInt32BE(0),4);
  const first=t.army(d,row)._id;
  canPay=false;assert.equal(H['0x01818402'](ctx(id)).readInt32BE(0),16);assert.equal(t.army(d,row)._id,first);
  canPay=true;packets.length=0;
  const refreshed=H['0x01818402'](ctx(id));assert.equal(refreshed.id,0x01188400);assert.notEqual(t.army(d,row)._id,first);
  assert.equal(packets.at(-1).id,0x01188402);assert.equal(t.state(d).yenile[id],1);
  assert.equal(charges.at(-1)[0].code,1);
  // Result handling must use the selected army and real win/loss, never the stale map stage.
  battle.kadroRapor=(stage,enemy,override,options)=>{
    assert.equal(stage,0);assert.equal(options.scaleEnemy,false);assert.equal(options.playerState,d);
    assert.deepEqual(override.birimler.map(u=>u.id),battle.stageArmyDusmanlari([t.army(d,row)._id]).map(u=>u.id));
    return {won,payload:Buffer.alloc(0)};
  };
  canPay=false;const used=t.state(d).kul;
  assert.equal(H['0x01818403'](ctx(id)).readInt32BE(0),16);assert.equal(t.state(d).kul,used);
  canPay=true;won=false;packets.length=0;
  assert.equal(H['0x01818403'](ctx(id)).readInt32BE(0),0);assert.deepEqual(grants.at(-1),[]);assert.equal(t.state(d).kul,1);
  assert.equal(packets.at(-1).id,0x01188404);assert.equal(packets.at(-1).payload.readInt32BE(0),1);
  won=true;assert.equal(H['0x01818403'](ctx(id)).readInt32BE(0),0);
  assert.equal(grants.at(-1)[0].type,2);assert.equal(grants.at(-1)[0].amount,t.experience(row,159,0));
  assert.equal(charges.at(-1)[0].amount,row.needSilver);
  assert.equal(p.cv(61400004),10);
  for(let attempt=3;attempt<=10;attempt++){
    assert.equal(H['0x01818403'](ctx(id)).readInt32BE(0),0);
    assert.equal(t.state(d).kul,attempt);
  }
  const count=charges.length;
  assert.equal(H['0x01818403'](ctx(id)).readInt32BE(0),1);assert.equal(H['0x01818402'](ctx(id)).readInt32BE(0),1);assert.equal(charges.length,count);
  assert.equal(battle.isFight(0x01818403),false,'generic replay route must not intercept Tensō');
  const reload=JSON.parse(JSON.stringify(d));assert.equal(t.state(reload).kul,10);assert.equal(t.army(reload,row)._id,t.army(d,row)._id);
  reload.gunlukSayac.gun='2000-01-01';assert.equal(t.state(reload).kul,0);assert(Object.values(t.state(reload).yenile).every(n=>n===0));
  for(const r of t.rows()){
    const a=t.armies(r)[0];
    for(const roll of [0,0.6,0.8,0.95]){
      const rewards=t.rewards(r,a,99,0,()=>roll);
      assert(!rewards.some(x=>x.type===0&&x.code===2),'Coupons must be replaced');
      const gems=rewards.filter(x=>x.type===1&&x.code===14900001);
      assert.equal(gems.length,1,'every victory must grant Primogems, including the former empty tier');
      assert(gems.every(x=>x.amount>=r.rewardTxt-10&&x.amount<=r.rewardTxt));
      assert.equal(p.satir('Article',gems[0].code).name,'Nguyên thạch');
    }
  }
  battle.kadroRapor=originalReport;
  const player=JSON.parse(fs.readFileSync(path.join(dir,'oyuncu.json')));
  const a=t.armies(row)[0];
  const report=battle.kadroRapor(0,null,{ad:a.name,birimler:battle.stageArmyDusmanlari([a._id])},{playerState:player,scaleEnemy:false,reportLossWhenDefeated:true,requireEnemyDefeated:true});
  assert(report&&typeof report.won==='boolean');
  const decoded=codec.decodeBattleReport(report.payload);assert.equal(decoded._consumed,decoded._total);assert.equal(decoded.player2.roles.length,5);
  // Exercise the production grant/save path in an isolated account directory.
  const account=JSON.parse(fs.readFileSync(path.join(dir,'veri.json')));
  account.level=99;account.deneyim=0;account.gumus=10000000;
  fs.writeFileSync(path.join(dir,'veri.json'),JSON.stringify(account));
  delete player.gunlukSayac;
  const handlers=require('../handlers');
  battle.kadroRapor=()=>({won:true,payload:report.payload});
  const inventory=require('../envanter'),beforeGems=inventory.mevcut(player,14900001),random=Math.random;
  let response;
  try{
    Math.random=()=>0;
    response=handlers.byReq['0x01818403']({payload:new p.Y().u32(id).done(),durum:player,kaydet:state=>fs.writeFileSync(path.join(dir,'oyuncu.json'),JSON.stringify(state))});
  }finally{Math.random=random;}
  assert.equal(response.readInt32BE(0),0);
  const savedAccount=JSON.parse(fs.readFileSync(path.join(dir,'veri.json'))),savedPlayer=JSON.parse(fs.readFileSync(path.join(dir,'oyuncu.json')));
  assert.equal(savedAccount.gumus,10000000-row.needSilver);
  assert.equal(savedAccount.kupon,account.kupon,'Coupon balance must not change');
  assert.equal(inventory.mevcut(savedPlayer,14900001)-beforeGems,5,'Primogem item must persist in inventory');
  assert(savedAccount.level>99||savedAccount.deneyim>0,'EXP must persist through the actual reward handler');
  assert.equal(t.state(savedPlayer).kul,1);
  const queued=handlers.ekAl().sonra;assert(queued.some(p=>p.id===codec.OP.RESULT));assert(queued.some(p=>p.id===0x01180105));
  const result=queued.find(p=>p.id===codec.OP.RESULT).payload,reader=new p.O(result);
  assert.equal(reader.i32(),0);assert.equal(reader.u8(),1);
  const displayed=[];for(let n=reader.u16();n>0;n--)displayed.push({type:reader.u16(),code:reader.u32(),amount:reader.u32()});
  assert(displayed.some(item=>item.type===1&&item.code===14900001&&item.amount===5),'victory popup receives an inventory item with its real quantity');
  assert(!displayed.some(item=>item.type===0&&item.code===2),'victory popup must not receive Coupon currency');
  assert.equal(reader.kalan(),0);
  assert(saves>0);
  console.log('PASS: Tensō packets, gates, costs, refresh, victory/defeat, daily reset, exclusive rewards and real combat report. Player files unchanged.');
}finally{battle.kadroRapor=originalReport;fs.rmSync(dir,{recursive:true,force:true});}
