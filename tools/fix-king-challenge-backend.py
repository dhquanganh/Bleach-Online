from pathlib import Path
p=Path('sunucu-kok/sunucu/king-challenge.js');s=p.read_text()
s=s.replace('return {players,matches,pairedAt:paired?season.start:null};','return {group,players,matches,pairedAt:paired?season.start:null};')
s=s.replace('    const b=season.groups[group];','    const b=season.groups[group];b.group=group;',1)
s=s.replace("function defaultSimulate(a,b,d){\n  return require('./savas').kadroRapor(0,null,{ad:b.name,birimler:clone(b.units).map(u=>({...u,camp:1,hp:u.maxHp}))},{playerState:d,playerUnits:clone(a.units).map(u=>({...u,camp:0,hp:u.maxHp})),scaleEnemy:false,forceWin:false,requireEnemyDefeated:true,battleDataVersion:4});\n}","""function defaultSimulate(a,b,d){
  const snapshot=(units,camp)=>clone(units).map(u=>({...u,camp,hp:u.maxHp,partnerSkills:u.partnerSkills||[],weaponSkills:u.weaponSkills||[]}));
  // Both camps use the registered PvP snapshots; the spectator's account must not supply equipment or skills.
  return require('./savas').kadroRapor(0,{name:b.name,level:b.level||159,units:snapshot(b.units,1)},null,{playerState:{},playerUnits:snapshot(a.units,0),pvp:true,scaleEnemy:false,forceWin:false,requireEnemyDefeated:true,battleDataVersion:4});
}""")
s=s.replace("utf(p.server);return w.done();}","utf(p.server);return w.u32(board.group||0).done();}",1)
s=s.replace('w.u32(board.matches[0]?.time||k.start+PAIRING_SECONDS).done();','w.u32(board.matches[0]?.time||k.start+PAIRING_SECONDS).u32(board.group||0).done();')
a=s.index('function betWinner(');z=s.index('function basePacket(',a)
s=s[:a]+'''function betState(k,bet){const board=k.groups?.[Math.floor(bet.match/1000)],match=board?.matches?.find(m=>m.id===bet.match);if(!match||![0,1].includes(bet.side))return null;const chosen=board.players[bet.side===0?match.a:match.b];if(!chosen)return null;return {board,match,chosen,win:match.ret===-1?null:board.players[winner(match)]||null};}
function betWinner(k,bet){return betState(k,bet)?.win||null;}
function betsPacket(k,prefix=true){const w=new Y();if(prefix)w.u32(0);const bets=k.bets.map(bet=>({bet,state:betState(k,bet)})).filter(row=>row.state);w.u16(bets.length);for(const {bet,state:{board,match:m,chosen,win}} of bets)w.u32(bet.match).u32(chosen.low).u32(chosen.high).u32(win?.low||0).u32(win?.high||0).i8(bet.claimed?1:0).utf(board.players[m.a]?.name||'').utf(board.players[m.b]?.name||'').utf(chosen.name);return w.done();}
function eligibleBet(k,b){const state=betState(k,b);return !!(!b.claimed&&state?.win&&state.win.low===state.chosen.low&&state.win.high===state.chosen.high);}
'''+s[z:]
s=s.replace('.i8(pending?0:k.claimed?1:2).done();','.i8(pending?0:k.claimed?1:2).u8(k.submission?.group||0).done();')
s=s.replace("      transaction=null;for(const effect of tx.after)effect();return result;", "      transaction=null;\n      // Persistence has committed; a failed network notification cannot roll it back or refund a settled wager.\n      for(const effect of tx.after)try{effect();}catch(error){console.error('[KING] notification:',error.message);}\n      return result;")
s=s.replace('w.u32(i+1).u32(p.power));return w.done();','w.u32(i+1).u32(p.power));return w.u32(g).done();')
# Exact current rank handler tail uses a longer player tuple.
s=s.replace('.u32(i+1).u32(p.power));return w.done();','.u32(i+1).u32(p.power));return w.u32(g).done();')
s=s.replace("reject('?? ch?t ??ng k? cho gi?i n?y.')","reject('Đã chốt đăng ký cho giải này.')").replace("reject('C?n c?p 60 tr? l?n ho?c ?? chuy?n sinh ?? ??ng k?.')","reject('Cần cấp 60 trở lên hoặc đã chuyển sinh để đăng ký.')").replace("reject('?? c? c??c cho c?p ??u c?a b?n; kh?ng th? ??i ??i h?nh.')","reject('Đã có cược cho cặp đấu của bạn; không thể đổi đội hình.')").replace("reject('Nh?m n?y ?? ?? 8 ng??i ??ng k?.')","reject('Nhóm này đã đủ 8 người đăng ký.')")
s=s.replace('u.pos<1||u.pos>15||!Number.isFinite(u.maxHp)||u.maxHp<=0',"!Number.isInteger(u.pos)||u.pos<1||u.pos>15||!Number.isFinite(u.maxHp)||u.maxHp<=0||!['atk','def','speed'].every(field=>Number.isFinite(u[field])&&u[field]>=0)")
s=s.replace("name:d.nick||'Player'","name:d.karakter?.nick||d.nick||'Player'")
s=s.replace('    x.k.submission=entry;delete x.k.groups[group];','    x.s.group=group;x.k.submission=entry;delete x.k.groups[group];')
s=s.replace("    const r=new O(ctx.payload),token=r.utf();if(r.kalan()||ctx.payload.length<2)return fail(4);", "    if(ctx.payload.length<2||ctx.payload.readUInt16BE(0)!==ctx.payload.length-2)return fail(4);\n    const r=new O(ctx.payload),token=r.utf();if(r.kalan())return fail(4);")
# Make version-2 state and old season defaults safe without discarding earned rewards.
s=s.replace('  s.refunds=s.refunds||[];',"  s.refunds=Array.isArray(s.refunds)?s.refunds:[];s.archive=Array.isArray(s.archive)?s.archive:[];\n  s.group=[1,2,3,4].includes(s.group)?s.group:1;\n  if(!s.current||!Number.isFinite(s.current.start))s.current={start:nextStart(now),groups:{},bets:[],claimed:false,entryKey};\n  for(const k of [...s.archive,s.current]){k.groups=k.groups||{};k.bets=Array.isArray(k.bets)?k.bets:[];}")
s=s.replace('  const currentSeason=seasonFor(k);', '  const currentSeason=seasonFor(k);currentSeason.registrations||={};currentSeason.groups||={};currentSeason.locked||={};currentSeason.sequence=Number(currentSeason.sequence)||0;')
p.write_text(s,encoding='utf-8')
