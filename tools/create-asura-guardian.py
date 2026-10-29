from pathlib import Path
import json,xml.etree.ElementTree as E,re
R=Path.cwd();B=R/'sunucu-kok/cikarim/asura-guardian';B.mkdir(exist_ok=True);T=B.parent/'guy-gate';S=R/'asset/Asura_Guardian_of_the_Land_Full'
rows={int(e.get('id')):e for e in E.parse(S/'config_reference/config/skill/skillConfig.xml').getroot()}
def plain(t):return re.sub('<[^>]+>','',t or '').replace('Ninjutsu','Physical ATK').replace('his Attack','his Physical ATK').replace('up to 9 units','all units').replace('up to 7 units','all units')
C=dict(heroId=11121008,name='Asura Otsutsuki [Guardian of the Land]',quality=7,assess='SSS',anyPosition=True,tags=[27,52,13,14,49,56,58],immunityRounds=2,revivalDelayRounds=2,reviveHpRatio=.4,allyReviveCooldown=1,balanceNote='All attack damage scales with buffed Physical ATK against Physical DEF. All area damage hits all living enemies. Pure Physical ATK protection replaces Pure Ninjutsu protection. Heal and HP percentages retain separate formulas. No independent summoned unit is defined by this kit; Wood Dragons and Kurama are original skill effects. Unspecified coefficients, 50% line chance, 70% Repulse chance and 30% defense penetration are local balance values.')
entries=[('mystery',21014018,'mystery',1.8,20),('standard',21014011,'standard',1,6),('standard2',21014012,'standard2',1,8),('standard3',21014013,'standard3',1,12),('chase',21014014,'chase',1.2,10),('modified',21014014,'modified',1.4,10),('protection',21014019,'protection',0,0),('dragon',21014015,'dragon',0,0),('barrier',21014016,'barrier',0,0),('revive',21014016,'revive',0,0)]
for i,(k,src,kind,mult,combo) in enumerate(entries,1):
 e=rows[src];m=dict(id=13122500+i,sourceId=src,name=e.get('name'),description=plain(e.findtext('desc')),asuraMove=kind,multiplier=mult,combo=combo,target='all',attackStat='atk',damageType='physical',cooldown=0,unavoidable=True)
 if not mult:m['support']=True
 if k in ['mystery','protection']:m.update(prompt=True,consumesPrimary=False,cooldown=2,battlefieldCooldown=0 if k=='mystery' else 1,chakraCost=20 if k=='mystery' else 40)
 if k=='mystery':m['causes']='knockdown'
 if k.startswith('standard'):m.update(causes='repulse',stateChance=.7)
 if k in ['chase','modified']:m.update(minCombo=20,maxPerRound=1,fixedPerRound=True,chase=True,ignoreDefense=.3,causes='highFloat' if k=='chase' else None)
 if k in ['dragon','barrier','revive']:m['trigger']=True
 C[k]=m
C['chase']['name']='Wood Style - Wood Dragon - Ascension';C['chase']['description']='Triggered with at least 20 Combo, deals damage to all enemies, causes High Float, absorbs all enemy Chakra and reduces Asura\'s Mystery Cooldown by 1. Ignores 30% Physical DEF. Below 60% HP, changes to Modified Wood Dragon - Ascension.'
C['barrier'].update(name='Divine Tree',description='Barrier: allied ninjas gain 30% Water and Earth Resistance and are immune to Ignition, Acupuncture, Discouragement, Tension and Fear. Lasts until the end of the round.')
C['revive'].update(name='Ninshu Successor - Revival',description='Asura revives 2 rounds after defeat with 40% max HP and executes Dragon Protection. A complete lineup defeat ends the battle. While Asura is alive, he revives a random defeated allied ninja with 100% max HP, at most once per round; cannot bypass no-revival effects.')
C['protection']['description']='All allied ninjas recover 20 shared Chakra, Chakra Limit is restored to 100, and cannot be defeated by their first 5 pure Physical ATK attacks received this round. Cooldown 2; Battlefield Cooldown 1; Chakra Cost 40. Selected instead of Destruction when targeting an ally.'
C['skillKeys']=[x[0] for x in entries];C['chases']=[C['chase']]
C['passives']=[dict(name=rows[i].get('name'),description=plain(rows[i].findtext('desc'))) for i in [21014016,21014017]]
C['passives'][0]['description']+=' Dragon Protection heals all allied ninjas for 25% of Asura\'s base Physical ATK, cleanses all Debuffs and adds 25% healing received to Asura. Explosive Mode increases Asura\'s Physical ATK by 8% and Physical DEF by 5% each time he causes damage, until round end. Divine Tree lasts through the round.'
C['passives'].append(dict(name='Guardian of Life',description='During rounds 1 and 2 Asura is immune to 100% of all incoming damage. Throughout battle, while alive, revives one random defeated allied ninja at 100% max HP, cooldown 1 round. No summoned auxiliaries, self-revival or no-revival targets are eligible. A fully defeated lineup ends the battle immediately.'))
(R/'sunucu-kok/sunucu/asura-guardian.json').write_text(json.dumps(C,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
def base(name):
 s=(T/name).read_text(encoding='utf-8')
 for a,b in [('guy-gate','asura-guardian'),('Guy_Gate_of_Death_Full','Asura_Guardian_of_the_Land_Full'),('Guy [Gate of Death]','Asura [Guardian of the Land]'),('GuyGate','Asura'),('guyGate','asura'),('11001941','11014011'),('11121007','11121008'),('13221007','13221008'),('131224','131225'),('13623401','13623501'),('14131007','14131008'),('14141007','14141008'),("['guyMove']","['asuraMove']")]:s=s.replace(a,b)
 return s
for name in ['build.py','build-client.py','build-items.py','prepare-assets.py','release.py']:(B/name).write_text(base(name),encoding='utf-8')
p=B/'prepare-assets.py';s=p.read_text();a=s.index('    mapping=');z=s.index('    C=json',a);s=s[:a]+"    mapping={'idle':'C_idle','run':'C_run1_2','hit':'D_stand_behit1','dead':'C_dead','entry':'C_entry','mystery':'SP_skill5','standard':'A_1hit','standard2':'A_2hit','standard3':'A_3hit','chase':'SP_skill2','modified':'SP_skill3','protection':'SP_skill1','dragon':'SP_skill6','barrier':'SP_skill4','revive':'SP_skill7'}\n"+s[z:];s=s.replace("['standard','standard2']","['standard','standard2','standard3']").replace("['mystery','night','steam','revive','splash','entry','dead']","['mystery','chase','modified','protection','dragon','barrier','revive','entry','dead']").replace("glob('Kaisimen*.swf')","glob('Axiuluo*.swf')").replace("+['DASHEWAN_tongyongfuhuo']",'');p.write_text(s)
p=B/'build.py';s=p.read_text().replace("elif name not in ['steam']:","elif name not in ['protection','dragon','barrier']:").replace("'Eight Inner Gates / Night Guy / Youth Last Shield'","'Ninshu Successor / Power of Friendship / Guardian of Life'").replace('21001943','21014011');p.write_text(s)
p=B/'build-client.py';s=p.read_text().replace('param1<=13122507','param1<=13122510').replace('param1<=13122503','param1<=13122504').replace('FSkillId==13122503?1:0','FSkillId>=13122502&&FSkillId<=13122504?FSkillId-13122502:0').replace("['standard','standard2']","['standard','standard2','standard3']").replace('[28,52,1,57]','[27,52,13,14,49,56,58]');p.write_text(s)
p=B/'release.py';s=p.read_text().replace("VERSION='2026102816'","VERSION='2026102902'").replace("active=='2026102815'","active=='2026102901'").replace("probe['cases']==18","probe['cases']==20").replace('range(13122501,13122508)','range(13122501,13122511)');p.write_text(s)
print('Created Asura configuration and build scaffold')
