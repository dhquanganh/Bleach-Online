from pathlib import Path
import json,xml.etree.ElementTree as E,importlib.util,sys
R=Path(__file__).resolve().parents[1];B=R/'sunucu-kok/cikarim/naruto-final';B.mkdir(exist_ok=True)
S=R/'asset/Naruto_The_Final_Battle_Full';rows={int(e.get('id')):e for e in E.parse(S/'config_reference/config/skill/skillConfig.xml').getroot()}
sys.path.insert(0,str(R/'sunucu-kok/cikarim/naruto-sage'))
sp=importlib.util.spec_from_file_location('n',R/'sunucu-kok/cikarim/naruto-sage/build.py');n=importlib.util.module_from_spec(sp);sp.loader.exec_module(n)
def desc(text):return n.plain_description(text).replace('[','').replace(']','').replace('Attack and Ninjutsu','Physical ATK').replace('Ninjutsu','Physical ATK').replace('up to 12 units','all units').replace('up to 7 units','all units').replace('up to 6 units','all units')
C=dict(heroId=11121006,name='Naruto Uzumaki [The Final Battle]',assess='SSS',quality=7,tags=[27,52,1,13,14,47,57,58],balanceNote='All damaging moves, indirect damage and counters use buffed Physical ATK against Physical DEF. All Ninjutsu growth is Physical ATK growth. Area attacks hit all enemies as requested. Kurama and the nine beasts are original visual skill actors, not independently targetable summons. Source descriptions do not specify numeric damage coefficients; chosen values are explicit below.',maxFriendshipStacks=6,maxMysteriesPerRound=10,maxExtraStandardsPerRound=15)
names=['Shukaku','Matatabi','Isobu','Son Goku','Kokuo','Saiken','Chomei','Gyuki','Kurama'];sources=[21016216,*range(21016221,21016229)]
keys=[]
for j,(beast,src) in enumerate(zip(names,sources),1):
 key='bond'+str(j);keys.append(key);e=rows[src]
 C[key]=dict(id=13122300+j,sourceId=src,name='Tailed Beast Bond',description=desc(e.findtext('desc')),nfMove=key,resonance=beast,multiplier=0,combo=0,target=1,support=True,prompt=True,consumesPrimary=False,cooldown=0,battlefieldCooldown=0,chakraCost=0)
specs=[('standard',21016212,'claw',.95,20),('tail',21016213,'tail',.95,20),('bomb',21016211,'bomb',1,30),('finalMystery',21016219,'final',1.5,40),('harem',21016229,'harem',0,0),('chase',21016214,'chase',.85,15),('additional',21016215,'additional',.9,30),('recovery',21316217,'recovery',0,0),('restoration',21416217,'restoration',0,0)]
for j,(key,src,kind,mult,combo) in enumerate(specs,10):
 keys.append(key);e=rows[src];m=dict(id=13122300+j,sourceId=src,name=e.get('name'),description=desc(e.findtext('desc')),nfMove=kind,multiplier=mult,combo=combo,target='all' if kind in ['claw','tail','bomb','final','additional'] else 1,attackStat='atk',damageType='physical',cooldown=0)
 if not mult:m['support']=True
 if key in ['finalMystery','harem']:m.update(prompt=True,consumesPrimary=False,cooldown=2,battlefieldCooldown=0,chakraCost=40,unavoidable=True)
 if key=='chase':m.update(chase=True,requiresAny=['lowFloat','knockdown'],causes='repulse',maxPerRound=1,unavoidable=True)
 if key in ['bomb','finalMystery']:m.update(ignoreShield=True,causes='knockdown')
 if key in ['standard','tail']:m['causes']='knockdown'
 if key=='bomb':m['critBonus']=.3
 if key=='additional':m.update(trigger=True,unavoidable=True,additional=True)
 if key in ['recovery','restoration']:m['trigger']=True
 C[key]=m
C['standard']['description']=desc(rows[21016213].findtext('desc'))
C['restoration']['healRatio']=.1
C['recovery']['healRatio']=.1
C['recovery']['description']+=' Recovers 10% of Naruto\'s max HP.'
C['restoration']['description']+=' Recovers 10% of Naruto\'s max HP.'
C['mystery']=C['bond1'];C['chases']=[C['chase']];C['skillKeys']=keys
keyrows={e.findtext('keys'):e.findtext('desc') for e in E.parse(S/'config_reference/config/skill/SkillKeyDescCFG.xml').getroot()}
C['passives']=[dict(name=rows[x].get('name'),description=desc(rows[x].findtext('desc'))) for x in [21216215,21016217]]
for name in ['Power of Six Paths',*names,'Six Paths - Super Massive Rasen-Shuriken','Kurama - Tailed Beast Bomb']:
 text=keyrows.get(name)
 if text:C['passives'].append(dict(name=name,description=desc(text)))
assert any(p['name']=='Power of Six Paths' for p in C['passives'])
for p in C['passives']:
 if p['name']=='Power of Six Paths':p['description']+=' Six Paths - Recovery and Six Paths - Restoration each recover 10% of Naruto\'s max HP.'
C['kuramaCloak']={'name':'Kurama Chakra Cloak','attackBonus':.5,'defenseBonus':.5,'speedBonus':.1,'lifesteal':.5,'description':'At the beginning of battle, Naruto grants Kurama Chakra to his entire lineup, increasing Physical ATK and Physical DEF by 50%, increasing Speed by 10% and granting 50% Life Steal for the battle. Life Steal restores HP based on actual damage dealt. This buff does not stack with another Naruto Final Battle.'}
C['passives'].append({'name':C['kuramaCloak']['name'],'description':C['kuramaCloak']['description']})
(R/'sunucu-kok/sunucu/naruto-final.json').write_text(json.dumps(C,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
