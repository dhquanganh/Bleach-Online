from pathlib import Path
R=Path(__file__).resolve().parents[1]/'sunucu-kok/sunucu'
def patch(file,pairs):
 p=R/file;s=p.read_text(encoding='utf-8')
 for a,b in pairs:
  assert a in s,(file,a);s=s.replace(a,b,1)
 p.write_text(s,encoding='utf-8')
patch('naruto-combat.js',[
 ("const minato =", "const infinite = require('./madara-infinite-combat');\nconst minato ="),
 ('minato.profile(unit) ||','infinite.profile(unit) || minato.profile(unit) ||'),
 ("return unit.hp <= 0 ||", "return unit.hp <= 0 || infinite.active(unit,'infiniteSlumberUntil') ||"),
 ("return !sasuke.active(unit,'sasukeParalysisUntil')", "return !infinite.active(unit,'infiniteParalysisUntil') && !sasuke.active(unit,'sasukeParalysisUntil')"),
 ('  minato.initialize(context);','  minato.initialize(context);\n  infinite.initialize(context);'),
 ('  ctx.round = round;','  ctx.infiniteChakraLock=[];\n  ctx.round = round;'),
 ('const move=minato.selectStandard(', 'const move0=minato.selectStandard('),
 ("  if(!move || sasuke.active", "  const move=infinite.selectStandard(ctx,unit,move0);\n  if(!move || sasuke.active"),
 ("obito.isObito(unit)?!obito.available(ctx,unit):!primaryAvailable(ctx,unit)||!ready(ctx,unit,'standard')", "obito.isObito(unit)?!obito.available(ctx,unit):infinite.isMadara(unit)?!(primaryAvailable(ctx,unit)||infinite.available(ctx,unit)):!primaryAvailable(ctx,unit)||!ready(ctx,unit,'standard')"),
 ('  if(mecha.isMecha(unit))mecha.spendStandard(unit);','  infinite.spendStandard(ctx,unit);\n  if(mecha.isMecha(unit))mecha.spendStandard(unit);'),
 ('m && minato.canMystery(ctx,unit)', 'm && infinite.canMystery(ctx,unit) && minato.canMystery(ctx,unit)'),
 ('  minato.mysteryExecuted(ctx,unit);','  minato.mysteryExecuted(ctx,unit);\n  infinite.mysteryExecuted(ctx,unit);'),
 ("  const frame=strike(unit,target,chase);", "  const frame=strike(unit,target,chase);"),
])
patch('hero-skills.js',[
 ("  const sasuke=require('./sasuke-combat');", "  const infinite=require('./madara-infinite-combat');\n  if(infinite.immune(unit,field))return field==='paralysis'?false:true;\n  if(field==='immuneDebuffs'&&infinite.isMadara(unit))return true;\n  const sasuke=require('./sasuke-combat');"),
 ("  result*=require('./minato-new-year-combat').factor(unit,field);", "  result*=require('./minato-new-year-combat').factor(unit,field);\n  result*=require('./madara-infinite-combat').factor(unit,field);"),
 ("*require('./gaara-combat').healFactor(target);", "*require('./gaara-combat').healFactor(target)*require('./madara-infinite-combat').healing(target);"),
])
patch('savas.js',[
 ("const minatoCombat =", "const infiniteCombat = require('./madara-infinite-combat');\nconst minatoCombat ="),
 ('minatoCombat.targets(u.minatoContext', 'infiniteCombat.targets(u.infiniteContext||{random},u,attackSpec,hedef,opponents)||minatoCombat.targets(u.minatoContext'),
 ('(minatoCombat.evade(', '(infiniteCombat.evade(victim.infiniteContext||{random},victim)||minatoCombat.evade('),
 ('if(victim.minatoContext)minatoCombat.evaded', 'if(victim.infiniteContext)infiniteCombat.evaded(victim.infiniteContext,victim);\n      if(victim.minatoContext)minatoCombat.evaded'),
 ('    kakuzuCombat.noteDeaths(chaseContext);','    kakuzuCombat.noteDeaths(chaseContext);\n    infiniteCombat.noteDeaths(chaseContext);'),
 ('      move=minatoCombat.prepareMove(', '      move=infiniteCombat.prepareMove(chaseContext,actor,move);\n      move=minatoCombat.prepareMove('),
 ('        minatoCombat.afterHit(', '        infiniteCombat.afterHit(chaseContext,actor,victim,hit,move,frame);\n        minatoCombat.afterHit('),
 ('      actor.verdi=', '      infiniteCombat.action(chaseContext,actor);\n      actor.verdi='),
 ('    for(const request of minatoCombat.triggers(chaseContext)){', '''    for(const request of infiniteCombat.triggers(chaseContext)){
      const enemies=chaseContext.teams[1-request.unit.camp],victim=enemies.find(v=>v.hp>0&&!v.auxiliary);
      if(victim&&performDepth<24)perform(request.unit,victim,enemies,chaseContext.teams[request.unit.camp],actives,request.move);
    }
    for(const request of minatoCombat.triggers(chaseContext)){'''),
 ('    const kakuzuRound=kakuzuCombat.roundStart(chaseContext);','    const infiniteRound=infiniteCombat.roundStart(chaseContext);\n    const kakuzuRound=kakuzuCombat.roundStart(chaseContext);'),
 ('    actives.push(...kakuzuRound);','    actives.push(...infiniteRound,...kakuzuRound);'),
 ('obitoCombat.isObito(u)&&obitoCombat.available(chaseContext,u))', '(obitoCombat.isObito(u)&&obitoCombat.available(chaseContext,u))||infiniteCombat.available(chaseContext,u))'),
])
patch('admin.js',[("h.id !== 11121003", "h.id !== 11121003 && h.id !== 11121005")])
# Cleansing must remove finite negative timers, including the new Level 2 debuffs.
p=R/'tsunade-combat.js';s=p.read_text();s=s.replace("'minatoMarkUntil'", "'infiniteRestrainedUntil','infiniteSlumberUntil','infiniteParalysisUntil','minatoMarkUntil'",1);p.write_text(s)
