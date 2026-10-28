from pathlib import Path
import json
R=Path(__file__).resolve().parents[1];B=R/'sunucu-kok/cikarim/guy-gate';T=B.parent/'madara-infinite'
def base(name):return (T/name).read_text(encoding='utf-8').replace('madara-infinite','guy-gate').replace('Madara_Infinite_Tsukuyomi_Full','Guy_Gate_of_Death_Full').replace('11011761','11001941').replace('11121005','11121007').replace('13221005','13221007').replace('131222','131224').replace('13623201','13623401').replace('14131005','14131007').replace('14141005','14141007')
s=base('prepare-assets.py');start=s.index('    mapping=');end=s.index('    data=',start)
s=s[:start]+'''    mapping={'idle':'C_idle','run':'C_run1_2','hit':'D_stand_behit1','dead':'C_dead','entry':'C_entry_1','mystery':'SP_skill1','standard':'A_2hit','standard2':'A_1hit','night':'SP_skill2','steam':'SP_skill5','revive':'SP_skillX','splash':'C_idle'}
    C=json.loads((B.parents[1]/'sunucu/guy-gate.json').read_text());moves={C[k]['id']:C[k]['guyMove'] for k in C['skillKeys']}
'''+s[end:]
s=s.replace("rendered,node=p.mme.render(root,images,action,scale=1);ids=[]", "rendered,node=p.mme.render(root,images,action,scale=1);rendered=rendered[:1] if name=='splash' else rendered;ids=[]")
start=s.index("    data['models']=");end=s.index("    (B/'animation.json')",start)
s=s[:start]+"    data['models']={'11121007':{'':'idle','0a':'idle','0b':['standard','standard2'],'0c':['mystery','night','steam','revive','splash','entry','dead'],'0d':'hit','0e':'idle','0f':'run'}}\n"+s[end:]
s=s.replace("glob('yuehziyan*.swf')","glob('Kaisimen*.swf')")
(B/'prepare-assets.py').write_text(s)
s=base('build.py').replace("['mystery','standard','standard2','standard3','standard4','susanoo','chase','limboChase','counter','barrier','evade','revive']","C['skillKeys']")
s=s.replace("elif name not in ['mystery','barrier','evade']:","elif name not in ['steam']:")
s=s.replace("'Ten-Tails Jinchuriki / Divine Absorption'","'Eight Inner Gates / Night Guy / Youth Last Shield'")
s=s.replace('assets/skill/40/21011773.png','assets/skill/40/21001943.png')
s=s.replace("move['sourceId']].get('iconId')", "move['sourceId']].get('iconId')")
s=s.replace("print('PASS Infinite Tsukuyomi native tables and lossless textures:'","print('PASS Guy Gate native tables and lossless textures:'")
(B/'build.py').write_text(s)
s=base('build-items.py').replace('Madara [Infinite Tsukuyomi]','Guy [Gate of Death]');(B/'build-items.py').write_text(s)
s=base('build-client.py').replace('Infinite','GuyGate').replace('madaraGuyGate','guyGate')
s=s.replace('param1>=13122401 && param1<=13122412 && !(param1>=13122402 && param1<=13122405)', 'param1>=13122401 && param1<=13122407 && !(param1>=13122402 && param1<=13122403)')
s=s.replace('FSkillId>=13122402&&FSkillId<=13122405?FSkillId-13122402:0','FSkillId==13122403?1:0')
start=s.index(' dispatch=');end=s.index('\n active=active.replace',start)
s=s[:start]+" dispatch={str(i):a['models']['11121007']['0c'].index(name) for i,name in a['moves'].items() if name not in ['standard','standard2']}"+s[end:]
s=s.replace("data['heroes']['11121007']=[26,52,1,13,14,31,46,48,58]", "data['heroes']['11121007']=[28,52,1,57]")
(B/'build-client.py').write_text(s)
