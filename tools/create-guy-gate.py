from pathlib import Path
import json,xml.etree.ElementTree as E,importlib.util,sys
R=Path(__file__).resolve().parents[1];B=R/'sunucu-kok/cikarim/guy-gate';B.mkdir(exist_ok=True)
S=R/'asset/Guy_Gate_of_Death_Full';rows={int(e.get('id')):e for e in E.parse(S/'config_reference/config/skill/skillConfig.xml').getroot()}
sys.path.insert(0,str(R/'sunucu-kok/cikarim/naruto-sage'));sp=importlib.util.spec_from_file_location('n',R/'sunucu-kok/cikarim/naruto-sage/build.py');n=importlib.util.module_from_spec(sp);sp.loader.exec_module(n)
def desc(t):return n.plain_description(t).replace('Ninjutsu','Physical ATK').replace("Guy's Attack","Guy's Physical ATK").replace("lineup's Attack","lineup's Physical ATK").replace('up to 12 units','all units').replace("based on Guy's max HP",'based on Guy\'s Physical ATK')
C=dict(heroId=11121007,name='Guy [Gate of Death]',assess='SSS',quality=7,tags=[28,52,1,57],guardRounds=2,defenseBonus=2,reviveHpRatio=.5,evadeChance=.6,hpCostRatio=.1,splashChance=.5,splashRatio=.2,balanceNote='All direct, splash and Night Guy damage use buffed Physical ATK against Physical DEF. HP costs remain max-HP costs. Mystery hits all enemies as requested. No independent summoned unit is defined by this kit. Source gives no damage coefficients, splash probability or evasion percentage; the configured coefficients, 50% splash chance and 60% evasion chance are balance values.')
specs=[('mystery',21001947,'mystery',1.5,6),('standard',21001943,'standard',.95,3),('standard2',21001941,'standard2',.95,3),('night',21001948,'night',3,10),('steam',21001945,'steam',0,0),('revive',21001946,'revive',0,0)]
for i,(key,src,kind,mult,combo) in enumerate(specs,1):
 e=rows[src];m=dict(id=13122400+i,sourceId=src,name=e.get('name'),description=desc(e.findtext('desc')),guyMove=kind,multiplier=mult,combo=combo,target='all' if key=='mystery' else 1,attackStat='atk',damageType='physical',cooldown=0,unavoidable=True)
 if mult:m['pureTaijutsu']=True
 if not mult:m['support']=True
 if key=='mystery':m.update(prompt=True,consumesPrimary=False,cooldown=1,battlefieldCooldown=1,chakraCost=0,causes='knockdown')
 if key.startswith('standard'):m.update(causes='repulse',ignoreDefense=.2)
 if key=='night':m.update(deathSkill=True,additional=True)
 if key=='steam':m['trigger']=True
 C[key]=m
C['splash']={**C['standard'],'id':13122407,'name':'Compressed Air Cannon - Splash','description':'Has a chance to cause 20% Physical ATK splash damage to enemies one grid from units hit.','guyMove':'splash','multiplier':.95*.2,'combo':1,'additional':True,'causes':None,'ignoreDefense':.2}
C['skillKeys']=['mystery','standard','standard2','night','steam','revive','splash'];C['chases']=[]
C['passives']=[{'name':rows[i].get('name'),'description':desc(rows[i].findtext('desc'))} for i in [21001944,21001945,21001946]]
C['passives'][0]['description']+=' Exception: with Naruto Uzumaki [The Final Battle] in his starting lineup, Guy can revive once with 50% max HP after Night Guy. Revival does not reset this allowance.'
C['passives'].append({'name':'Youth\'s Last Shield','description':'During rounds 1 and 2, Guy intercepts all incoming damage aimed at his allies and gains 200% Physical DEF. Damage is mitigated using Guy\'s Physical DEF. If multiple Guys are present, only one intercepts each hit. With Naruto Uzumaki [The Final Battle] in the starting lineup, Guy can revive once with 50% max HP, overriding his own Night Guy revival prohibition. Enemy effects that forbid revival still prevent this rescue.'})
C['revive']['name']="Naruto's Lifeline"
C['revive']['description']='With Naruto Final Battle in the starting lineup, Guy revives once with 50% max HP. This rescue does not reset on revival and cannot bypass an enemy no-revival effect.'
C['night']['description']+=' After execution, Guy is defeated. Naruto Final Battle allows the single revival described in Youth\'s Last Shield.'
C['passives'].append({'name':'Evening Elephant Statuses','description':'Evening Elephant - Restraint: Level 2 Debuff; cannot execute Standard Attacks until round end. Evening Elephant - Immobility: Level 2 Debuff; cannot execute most actions until round end. Guy receives his own Elephant status even while immune to external Debuffs. Level 2 Super Armor prevents Low Float, High Float, Repulse and Knockdown and lower-level Suppress Super Armor. If Night Guy is disabled, fatal damage leaves Guy at 1 HP until he is defeated at round end. The Naruto rescue is an external revival and is still limited to one use. HP costs stop at 1 HP and do not count as attack damage.'})
(R/'sunucu-kok/sunucu/guy-gate.json').write_text(json.dumps(C,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
