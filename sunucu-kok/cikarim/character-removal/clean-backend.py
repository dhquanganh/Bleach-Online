"""Remove both retired character kits while retaining shared combat behavior."""
from pathlib import Path
import re
ROOT=Path(__file__).resolve().parents[2]
SERVER=ROOT/'sunucu'

def edit(name, transform):
    path=SERVER/name;s=path.read_text(encoding='utf-8');path.write_text(transform(s),encoding='utf-8')

def battle(s):
    s=s.replace("const kabutoCombat = require('./kabuto-router');\n",'')
    start=s.index('  const runSummons = ');end=s.index('  const drainReactiveMysteries = ',start);s=s[:start]+s[end:]
    s=s.replace('kabutoCombat.armor(victim)',"heroSkills.armor(victim)")
    s=s.replace('kabutoCombat.cursed(u) || kabutoCombat.isKabuto(u) || ','')
    s=s.replace(' || kabutoCombat.isKabuto(u)','').replace(' || kabutoCombat.cursed(u)','')
    s=s.replace(' && !kabutoCombat.cursed(u)','')
    s=s.replace(' && kabutoCombat.canMystery(u.kabutoContext||{round:u.battleRound||0},u)','')
    s=s.replace(' && kabutoCombat.canMystery(chaseContext,u)','')
    s=s.replace('&&kabutoCombat.canStandard(chaseContext,u)','')
    s=s.replace('&&!kabutoCombat.pendingRevival(chaseContext,1)','').replace('&&!kabutoCombat.pendingRevival(chaseContext,0)','')
    s=s.replace(' || kabutoCombat.profile(u)','')
    s=s.replace('kabutoCombat.targets(attackSpec,hedef,opponents) || ','')
    s=s.replace('()=>actives.push(...kabutoCombat.beforeAction(chaseContext,u))','()=>{}')
    s=s.replace('const beforeFrames=isChase?kabutoCombat.beforeAction(chaseContext,actor):[];','const beforeFrames=[];')
    s='\n'.join(line for line in s.split('\n') if not any(x in line for x in ['kabutoCombat.','result.kabutoProtected','if(protection)reflected=','if(protection){u.hp+=','runSummons(summons,actives)']))
    return s
edit('savas.js',battle)

def naruto(s):
    s=s.replace("const kabuto = require('./kabuto-router');\n",'')
    s=s.replace(' || kabuto.profile(unit)',' || null').replace(' && kabuto.canChase(unit)','').replace('!kabuto.armor(target)','!skills.armor(target)')
    s=s.replace('kabuto.selectStandard(ctx,unit,standard(unit,allies))','standard(unit,allies)')
    return s.replace(' && kabuto.canMystery(ctx,unit)','')
edit('naruto-combat.js',naruto)

def skills(s):
    s=s.replace('const kabutoSuppressed=', 'const immunitySuppressed=').replace('(unit.kabutoSuppressedUntil>=unit.battleRound||unit.suppressedUntil>=unit.battleRound)','(unit.suppressedUntil>=unit.battleRound)').replace('kabutoSuppressed','immunitySuppressed')
    s=s.replace("(field==='def'?result*Math.max(0,1-0.12*(unit.kabutoDefenseStacks||0)):result)",'result')
    s=re.sub(r",?'kabuto(?:SuppressedUntil|BlindUntil|CurseUntil|ArmorSuppressedUntil|DefenseStacks)'",'',s)
    s=s.replace("buff.kabutoWarDot?require('./kabuto-war-combat').dotDamage(unit,buff):",'')
    s='\n'.join(line for line in s.split('\n') if not any(x in line for x in ["require('./kabuto-router')",'if(protection)damage=','if(protection){']))
    s+='\n// Shared armor suppression belongs to the combat engine.\nmodule.exports.armor=unit=>!!((unit.superArmor||require(\'./mecha-combat\').beast(unit))&&(!(unit.armorSuppressedUntil>=unit.battleRound)||require(\'./mecha-combat\').advanced(unit)));\n'
    return s
edit('hero-skills.js',skills)

def reincarnation(s):
    s='\n'.join(line for line in s.split('\n') if "require('./kabuto-router')" not in line and 'if(protection)damage=' not in line)
    s=s.replace('let recovered=0;if(protection){recovered=protection.recovered;target.hp+=recovered;}else if(heal)', 'let recovered=0;if(heal)')
    return s.replace(',kabutoProtected:!!protection','')
edit('reincarnation.js',reincarnation)

for name in ['mecha-combat.js','itachi-combat.js']:
    edit(name,lambda s:s.replace('kabutoArmorSuppressedUntil','armorSuppressedUntil').replace(",'kabutoSuppressedUntil'",'').replace(",'kabutoBlindUntil'",'').replace(",'kabutoCurseUntil'",'').replace("||active(t,'kabutoSuppressedUntil')",''))
# Keep armor cleansing in the common cleanup path after removing obsolete states.
edit('hero-skills.js',lambda s:s.replace("'suppressedUntil','immobileUntil'","'suppressedUntil','immobileUntil','armorSuppressedUntil'"))
print('PASS backend character hooks removed; shared armor behavior retained')
