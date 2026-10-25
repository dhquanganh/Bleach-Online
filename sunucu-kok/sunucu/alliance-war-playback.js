'use strict';
const {Y,satir,tablo,json}=require('./paket'),codec=require('./kodek');
const OP={HEAD:0x01186300,WAVE:0x01186301,RESULT:0x01186302,FINISH:0x01816303};
function flip(report){const r=codec.decodeBattleReport(Buffer.from(report,'base64'));[r.player1,r.player2]=[r.player2,r.player1];for(const t of r.turns)for(const a of t.actives){a.activeCamp=1-a.activeCamp;for(const x of a.targets)x.targetCamp=1-x.targetCamp;}return codec.encodeBattleReport(r);}
function playback(event,accountId,index){
 const player=event.players.find(p=>p.accountId===accountId);if(!player)throw Error('Bạn không tham gia trận này.');
 const source=event.battles||event.players[0].battles;
 const battles=source.map((b,i)=>({...b,index:i,report:event.reports[i]})).filter(b=>index===undefined||b.index===index);
 if(!battles.length||battles.some(b=>!b.report))throw Error('Không có dữ liệu hoạt ảnh của trận này.');
 const armies=json(satir('LeaguePointPath',player.model)?.mapID,{}).army||[];
 for(const b of battles)if(player.mode==='pve'&&!b.enemyId)b.enemyId=armies.find(id=>satir('EnemyArmy',id)?.name===b.right);
 if(player.mode==='pve'&&battles.some(b=>!b.enemyId))throw Error('Không tìm thấy đội địch của chiến dịch.');
 return {id:event._id+(index===undefined?'':':'+index),eventId:event._id,mode:player.mode,model:player.mode==='pve'?player.model:tablo('LeagueMapPvp').ids[0],side:player.side||0,won:index===undefined?player.won:(player.side?!battles[0].won&&!battles[0].draw:battles[0].won),battles,players:event.players.filter(p=>(p.side||0)===(player.side||0)).map(p=>({...p,honor:index===undefined?p.honor:0,items:index===undefined?p.items:[]}))};
}
function frames(data){
 const packets=[{id:OP.HEAD,payload:new Y().u8(data.mode==='pve'?14:15).u32(data.model).utf(data.id).done()}],waves=new Map();
 for(const battle of data.battles){const wave=waves.get(battle.round)||[];wave.push(battle);waves.set(battle.round,wave);}
 for(const wave of waves.values()){
  if(wave.length>3)throw Error('Một lượt Alliance có tối đa 3 cặp đấu.');
  const w=new Y().u16(wave.length);
  for(const b of wave){
   const bytes=data.side?flip(b.report):Buffer.from(b.report,'base64'),report=codec.decodeBattleReport(bytes);
   const sum=g=>g.roles.reduce((n,u)=>n+Math.max(0,u.curHealth),0);
   const won=data.side?!b.won&&!b.draw:b.won;
   // f64 HP keeps native bars correct for characters above the old signed-int cap.
   w.u8(won?0:1).u32(b.enemyId||0).f64(data.side?(b.rightHp??sum(report.player1)):(b.leftHp??sum(report.player1))).f64(data.side?(b.leftHp??sum(report.player2)):(b.rightHp??sum(report.player2))).utf(data.eventId+':'+b.index).raw(bytes);
  }
  packets.push({id:OP.WAVE,payload:w.done()});
 }
 const result=new Y().u8(data.won?0:1);
 if(data.mode==='pvp'||data.won){result.u16(data.players.length);for(const p of data.players){result.utf(p.name||'Shinigami').u32(p.heroId||11100005).u32(data.battles.filter(b=>b.left===p.name&&b.won).length).u8(0).u8(0).odul([]).odul([{type:0,code:99,amount:p.honor||0},...(p.items||[]).map(i=>({type:1,code:i.id,amount:i.amount}))].filter(i=>i.amount>0));}}
 packets.push({id:OP.RESULT,payload:result.done()});return packets;
}
module.exports={OP,playback,frames,flip};
