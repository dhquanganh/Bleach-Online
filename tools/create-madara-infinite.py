from pathlib import Path
import json,xml.etree.ElementTree as ET
R=Path(__file__).resolve().parents[1];B=R/'sunucu-kok/cikarim/madara-infinite';B.mkdir(exist_ok=True)
S=R/'asset/Madara_Infinite_Tsukuyomi_Full'
rows={int(e.get('id')):e for e in ET.parse(S/'config_reference/config/skill/skillConfig.xml').getroot()}
C=dict(heroId=11121005,name='Madara Uchiha [Infinite Tsukuyomi]',assess='SSS',quality=7,tags=[26,52,1,13,14,31,46,48,58],evadeChance=.6,revivalDelayRounds=3,balanceNote='Every damaging move uses buffed Physical ATK against Physical DEF. Mystery attacks all enemies. Limbo shadows are original skill animation actors, not independent summon units. Damage coefficients are balance values because the reference does not specify them.')
specs=[('mystery',21011768,'mystery',0,0),('standard',21011773,'limbo',.95,30),('standard2',21011761,'standard',.95,20),('standard3',21011762,'standard2',.95,20),('standard4',21011763,'standard3',.95,25),('susanoo',21011769,'susanoo',1.5,30),('chase',21011764,'chase',.8,15),('limboChase',21011774,'limboChase',.85,20),('counter',21211774,'counter',.85,20),('barrier',21011765,'barrier',0,0),('evade',21011766,'evade',0,0),('revive',21011767,'revive',0,0)]
for i,(key,src,kind,mult,combo) in enumerate(specs,1):
 e=rows[src];m=dict(id=13122200+i,sourceId=src,name=e.get('name'),description=e.findtext('desc'),infiniteMove=kind,multiplier=mult,combo=combo,target='all' if key in ['mystery','susanoo','counter','chase','limboChase'] else 1,attackStat='atk',damageType='physical',cooldown=0)
 if not mult:m['support']=True
 if key in ['mystery','susanoo']:m.update(prompt=True,consumesPrimary=False,cooldown=int(e.get('cd')),battlefieldCooldown=0,chakraCost=int(e.get('mp')));m['description']=m['description'].replace('up to 12 units','all units')
 if key in ['mystery','standard','limboChase','counter']:m['unavoidable']=True
 if key in ['chase','limboChase']:m.update(chase=True,minCombo=30,maxPerRound=1,ignoreDefense=.2)
 if key=='chase':m['critBonus']=.3
 if key in ['counter','barrier']:m['trigger']=True
 if key in ['limboChase','counter']:m['ignoreDefense']=.2
 if key=='standard':m['causes']='repulse'
 if key in ['standard2','standard3','standard4']:m.update(causes='knockdown',stateChance=.5)
 if key=='susanoo':m['causes']='knockdown'
 C[key]=m
C['chases']=[C['chase']]
C['passives']=[dict(name=rows[x].get('name'),description=rows[x].findtext('desc')) for x in [21011765,21011767,21011766]]
C['passives'] += [dict(name='Divine - Deep Forest Emergence Barrier',description='Under this Barrier, ally units cannot suffer from Slumber and Paralysis, and opponent units cannot receive Explosive Mode.'),dict(name='Limbo - Border Jail',description=rows[21011771].findtext('desc')),dict(name='Limbo - Shadow Thunder Prison',description=rows[21011774].findtext('desc')),dict(name='Limbo - Complete Body - Susano\'o',description=C['susanoo']['description'])]
C['passives'].append(dict(name=C['counter']['name'],description=C['counter']['description']))
def sync(value):
 if isinstance(value,dict):
  for k,v in value.items():
   if k=='description':value[k]=v.replace('up to 7 units','all units').replace('up to 12 units','all units').replace('Attack</font> and <font color="#4dc831">Ninjutsu','Physical ATK').replace('Ninjutsu','Physical ATK')
   else:sync(v)
 elif isinstance(value,list):
  for v in value:sync(v)
sync(C)
(R/'sunucu-kok/sunucu/madara-infinite.json').write_text(json.dumps(C,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
