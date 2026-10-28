from pathlib import Path
R=Path(__file__).resolve().parents[1]/'sunucu-kok/sunucu'
def patch(file,pairs):
 p=R/file;s=p.read_text(encoding='utf-8')
 for a,b in pairs:assert a in s,(file,a);s=s.replace(a,b,1)
 p.write_text(s,encoding='utf-8')
patch('naruto-combat.js',[
 ("const infinite =", "const finalNaruto = require('./naruto-final-combat');\nconst infinite ="),
 ('infinite.profile(unit) ||','finalNaruto.profile(unit) || infinite.profile(unit) ||'),
 ('  infinite.initialize(context);','  infinite.initialize(context);\n  finalNaruto.initialize(context);'),
 ('const move=infinite.selectStandard(ctx,unit,move0);','const move=finalNaruto.selectStandard(ctx,unit,infinite.selectStandard(ctx,unit,move0));'),
 ('    if(mecha.isMecha(unit)){','    if(finalNaruto.isNaruto(unit)){finalNaruto.loseStandards(ctx,unit,unit.hashStandardLoss);unit.hashStandardLoss=0;}else if(mecha.isMecha(unit)){'),
 ('infinite.isMadara(unit)?!(primaryAvailable(ctx,unit)||infinite.available(ctx,unit)):', 'finalNaruto.isNaruto(unit)?!finalNaruto.available(ctx,unit):infinite.isMadara(unit)?!(primaryAvailable(ctx,unit)||infinite.available(ctx,unit)):'),
 ('  infinite.spendStandard(ctx,unit);','  infinite.spendStandard(ctx,unit);\n  finalNaruto.spendStandard(ctx,unit);'),
 ('m && infinite.canMystery(ctx,unit)', 'm && finalNaruto.canMystery(ctx,unit) && infinite.canMystery(ctx,unit)'),
 ('  if(m.consumesPrimary!==false)ctx.primaryActions.set(unit,ctx.round);','  finalNaruto.mysterySpent(ctx,unit,m);\n  if(m.consumesPrimary!==false)ctx.primaryActions.set(unit,ctx.round);'),
])
patch('hero-skills.js',[
 ("  const infinite=require('./madara-infinite-combat');", "  const finalNaruto=require('./naruto-final-combat');\n  if(field==='immuneDebuffs'&&finalNaruto.isNaruto(unit))return true;\n  if(field==='disarm'&&finalNaruto.active(unit,'nfBlindUntil'))return true;\n  if(field==='immuneDebuffs'&&finalNaruto.active(unit,'nfInkUntil'))return false;\n  const infinite=require('./madara-infinite-combat');"),
 ("const immunitySuppressed=!infinite.isMadara(unit)", "const immunitySuppressed=!finalNaruto.isNaruto(unit)&&!infinite.isMadara(unit)"),
 ("  result*=require('./madara-infinite-combat').factor(unit,field);", "  result*=require('./madara-infinite-combat').factor(unit,field);\n  result*=require('./naruto-final-combat').factor(unit,field);"),
])
patch('savas.js',[
 ("const infiniteCombat =", "const finalNarutoCombat = require('./naruto-final-combat');\nconst infiniteCombat ="),
 ('infiniteCombat.targets(u.infiniteContext', 'finalNarutoCombat.targets(u.nfContext||{random},u,attackSpec,hedef,opponents)||infiniteCombat.targets(u.infiniteContext'),
 ('  mechaCombat.beforeAttack(u,attackSpec,targets);', '  if(u.nfContext)finalNarutoCombat.onAttacked(u.nfContext,u,victims,attackSpec);\n  mechaCombat.beforeAttack(u,attackSpec,targets);'),
 ('    const guaranteed=attackSpec?.unavoidable', '    const guaranteed=(!skillAt&&!extra&&finalNarutoCombat.standardGuaranteed(u))||attackSpec?.unavoidable'),
 ('    dmg=Math.round(dmg*minatoScale);','    dmg=Math.round(dmg*minatoScale*finalNarutoCombat.outgoing(u,attackSpec||{prompt:skillAt,trigger:extra}));'),
 ('    kakuzuCombat.noteDeaths(chaseContext);','    finalNarutoCombat.noteDeaths(chaseContext);\n    kakuzuCombat.noteDeaths(chaseContext);'),
 ('    if(battleOver())return null;','    if(battleOver()||finalNarutoCombat.blocksAdditional(u,spec))return null;'),
 ('      move=infiniteCombat.prepareMove(', '      move=finalNarutoCombat.prepareMove(chaseContext,actor,move,victim);\n      move=infiniteCombat.prepareMove('),
 ('        infiniteCombat.afterHit(', '        finalNarutoCombat.afterHit(chaseContext,actor,victim,hit,move,frame);\n        infiniteCombat.afterHit('),
 ('      if(!move&&frame.activeType===kodek.ACTIVE.SKILL)minatoCombat.afterHit(chaseContext,actor,victim,[],{prompt:true},frame);', '      if(!move&&frame.activeType===kodek.ACTIVE.SKILL){minatoCombat.afterHit(chaseContext,actor,victim,[],{prompt:true},frame);finalNarutoCombat.observe(chaseContext,actor,{prompt:true});}'),
 ('    for(const request of infiniteCombat.triggers(chaseContext)){', '''    for(const request of finalNarutoCombat.triggers(chaseContext)){
      const enemies=chaseContext.teams[1-request.unit.camp],victim=enemies.find(v=>v.hp>0&&!v.auxiliary);
      const move=request.standardAction?narutoCombat.useStandard(chaseContext,request.unit,chaseContext.teams[request.unit.camp]):request.move;
      if(move&&victim&&performDepth<24)perform(request.unit,victim,enemies,chaseContext.teams[request.unit.camp],actives,move);
    }
    for(const request of infiniteCombat.triggers(chaseContext)){'''),
 ('if(!hashCombat.isHash(u)&&!painCombat.isPain(u)', 'if(!finalNarutoCombat.isNaruto(u)&&!hashCombat.isHash(u)&&!painCombat.isPain(u)'),
 ('    minatoCombat.roundStart(chaseContext);','    minatoCombat.roundStart(chaseContext);\n    finalNarutoCombat.roundStart(chaseContext);'),
 ('const canSkill = hashCombat.canMystery(chaseContext,u)', 'const canSkill = !finalNarutoCombat.blocksMystery(u) && hashCombat.canMystery(chaseContext,u)'),
 ('||infiniteCombat.available(chaseContext,u))','||infiniteCombat.available(chaseContext,u)||finalNarutoCombat.isNaruto(u)&&finalNarutoCombat.available(chaseContext,u))'),
 ('    actives.push(...tsunadeCombat.endRound(chaseContext));','    actives.push(...finalNarutoCombat.endRound(chaseContext));\n    actives.push(...tsunadeCombat.endRound(chaseContext));'),
])
patch('admin.js',[("h.id !== 11121005", "h.id !== 11121005 && h.id !== 11121006")])
patch('tsunade-combat.js',[("const negativeTimers=[", "const negativeTimers=['nfMagnetUntil','nfHaremUntil','nfSlowReflexUntil','nfBlindUntil','nfInkUntil','kakuzuDiscouragementUntil',"),
 ("if(!isTsunade(u)||u.hp>0||", "if(require('./naruto-final-combat').blocksDeath(u)||!isTsunade(u)||u.hp>0||")])
patch('tobi-war-combat.js',[("if(!isTobi(u)||u.hp>0||", "if(require('./naruto-final-combat').blocksDeath(u)||!isTobi(u)||u.hp>0||")])
patch('pain-combat.js',[("if(!isPain(u)||u.hp>0||", "if(require('./naruto-final-combat').blocksDeath(u)||!isPain(u)||u.hp>0||")])
patch('kakuzu-edo-combat.js',[("const canRevive=u=>u&&!u.noRevive", "const canRevive=u=>u&&!require('./naruto-final-combat').blocksDeath(u)&&!u.noRevive")])
patch('jiraiya-combat.js',[("if(isJiraiya(u)&&!u.noRevive", "if(isJiraiya(u)&&!require('./naruto-final-combat').blocksDeath(u)&&!u.noRevive")])
patch('minato-new-year-combat.js',[("function triggerExecuted(ctx,u){if(!ctx?.teams||!u)return;", "function triggerExecuted(ctx,u){if(!ctx?.teams||!u)return;require('./naruto-final-combat').observe(ctx,u,{trigger:true});")])
