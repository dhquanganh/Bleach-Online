from pathlib import Path
import json
R=Path(__file__).resolve().parents[1];B=R/'sunucu-kok/cikarim/naruto-final';T=B.parent/'madara-infinite'
def base(name):return (T/name).read_text(encoding='utf-8').replace('madara-infinite','naruto-final').replace('Madara_Infinite_Tsukuyomi_Full','Naruto_The_Final_Battle_Full').replace('11011761','11016211').replace('11121005','11121006').replace('13221005','13221006').replace('131222','131223').replace('13623201','13623301').replace('14131005','14131006').replace('14141005','14141006')
s=base('prepare-assets.py');start=s.index('    mapping=');end=s.index("    data=",start)
s=s[:start]+'''    C=json.loads((B.parents[1]/'sunucu/naruto-final.json').read_text())
    mapping={'idle':'C_idle','run':'C_run1_2','hit':'D_stand_behit1','dead':'C_dead','entry':'C_entry'}
    mapping.update({('bond'+str(i)):('SP_skill5_'+str(i)) for i in range(1,10)})
    mapping.update(claw='A_2hit',tail='A_3hit',bomb='A_1hit',final='SP_skill2',harem='SP_skill3',chase='SP_skill4',additional='SP_skill6',recovery='SP_skill7',restoration='SP_skill7')
    moves={C[k]['id']:C[k]['nfMove'] for k in C['skillKeys']}
'''+s[end:]
start=s.index("    data['models']=");end=s.index("    (B/'animation.json')",start)
s=s[:start]+"    data['models']={'11121006':{'':'idle','0a':'idle','0b':['claw','tail','bomb'],'0c':[C[k]['nfMove'] for k in C['skillKeys'] if C[k]['nfMove'] not in ['claw','tail','bomb']]+['entry','dead'],'0d':'hit','0e':'idle','0f':'run'}}\n"+s[end:]
s=s.replace("glob('yuehziyan*.swf')","glob('MIngrenZyzz*.swf')").replace("+['DASHEWAN_tongyongfuhuo']",'')
(B/'prepare-assets.py').write_text(s)
s=base('build.py').replace("['mystery','standard','standard2','standard3','standard4','susanoo','chase','limboChase','counter','barrier','evade','revive']","C['skillKeys']")
s=s.replace("  if name=='revive':node['friendhp']={str(hits[0]):100}\n  elif name not in ['mystery','barrier','evade']:","  if not next(m for m in skills if str(m['id'])==str(ident)).get('support'):")
s=s.replace("'Ten-Tails Jinchuriki / Divine Absorption'","'Power of Six Paths / Power of Friendship'")
s=s.replace("print('PASS Infinite Tsukuyomi native tables and lossless textures:'","print('PASS Naruto Final native tables and lossless textures:'")
s=s.replace('assets/skill/40/21011773.png','assets/skill/40/21016213.png')
(B/'build.py').write_text(s)
s=base('build-items.py').replace('Madara [Infinite Tsukuyomi]','Naruto [The Final Battle]')
(B/'build-items.py').write_text(s)
s=base('build-client.py').replace('Infinite','NarutoFinal').replace('infinite','narutoFinal').replace('madaraInfinite','narutoFinal')
# The replacement above changes paths with the same word; preserve the folder.
s=s.replace('madara-narutoFinal','naruto-final')
s=s.replace('PreloadNarutoFinalNative','PreloadNarutoFinalNative')
s=s.replace("'UpdateNarutoFinalVfx' not in before","'UpdateNarutoFinalVfx' not in before")
s=s.replace("if(FId==11121006)return param1>=13122301 && param1<=13122312 && !(param1>=13122302 && param1<=13122305);", "if(FId==11121006)return param1>=13122301 && param1<=13122318 && !(param1>=13122310 && param1<=13122312);")
s=s.replace('FSkillId>=13122302&&FSkillId<=13122305?FSkillId-13122302:0','FSkillId>=13122310&&FSkillId<=13122312?FSkillId-13122310:0')
start=s.index(' dispatch=');end=s.index('\n active=active.replace',start)
s=s[:start]+" dispatch={str(i):a['models']['11121006']['0c'].index(name) for i,name in a['moves'].items() if name not in ['claw','tail','bomb']}"+s[end:]
# Do not replace the existing Infinite Tsukuyomi dispatch; append to Minato hook.
s=s.replace("this.UpdateNarutoFinalVfx();','         this.UpdateNarutoFinalVfx();", "this.UpdateMinatoVfx();','         this.UpdateMinatoVfx();") if False else s
# Original template already appends its runtime after Minato; keep that hook.
s=s.replace('data[\'heroes\'][\'11121006\']=[26,52,1,13,14,31,46,48,58]',"data['heroes']['11121006']=[27,52,1,13,14,47,57,58]")
(B/'build-client.py').write_text(s)
