from pathlib import Path
import json
R=Path(__file__).resolve().parents[1];B=R/'sunucu-kok/cikarim/madara-infinite';T=B.parent/'minato-new-year'
def base(name):return (T/name).read_text(encoding='utf-8').replace('minato-new-year','madara-infinite').replace('Minato_New_Year_Full','Madara_Infinite_Tsukuyomi_Full').replace('11004471','11011761').replace('11121003','11121005').replace('131221','131222').replace('13623101','13623201').replace('14131003','14131005').replace('14141003','14141005').replace('Minato [New Year]','Madara [Infinite Tsukuyomi]').replace('Minato','Infinite').replace('minatoNewYear','madaraInfinite')
keys="['mystery','standard','standard2','standard3','standard4','susanoo','chase','limboChase','counter','barrier','evade','revive']"
s=base('prepare-assets.py');start=s.index('    mapping=');end=s.index("    data=",start)
s=s[:start]+'''    mapping={'idle':'C_idle','run':'C_run1_2','hit':'D_stand_behit1','dead':'C_dead','entry':'C_entry',
             'limbo':'A_4hit','standard':'A_1hit','standard2':'A_2hit','standard3':'A_3hit','mystery':'SP_skill1','susanoo':'SP_skill2',
             'chase':'SP_skill4','limboChase':'SP_skill5','counter':'SP_skill5','barrier':'SP_skill3','evade':'SP_skill6','revive':'SP_skill7'}
    C=json.loads((B.parents[1]/'sunucu/madara-infinite.json').read_text())
    moves={C[k]['id']:C[k]['infiniteMove'] for k in '''+keys+'''}
'''+s[end:]
s=s.replace("['standard','standard-2','standard-3']","['limbo','standard','standard2','standard3']").replace("['mystery','enhanced-mystery','counter','summon','prowess','evade','entry','dead']","['mystery','susanoo','chase','limboChase','counter','barrier','evade','revive','entry','dead']")
s=s.replace("glob('BofengshuimenXinchun*.swf')","glob('yuehziyan*.swf')")
(B/'prepare-assets.py').write_text(s)
s=base('build.py').replace("['mystery','standard','standard2','standard3','enhancedMystery','counter','cloneCounter','summon','prowess','evade']",keys)
s=s.replace("if name=='summon':node['friendhp']={str(hits[0]):100}","if name=='revive':node['friendhp']={str(hits[0]):100}").replace("elif name not in ['prowess','evade']:","elif name not in ['mystery','barrier','evade']:")
s=s.replace("[H,C['summonId']]","[H]").replace("13221003 if hero==H else 13221004","13221005").replace("C['passives']+[C['prowess']]","C['passives']")
s=s.replace("'Flying Raijin Jutsu / Prowess / Konoha Yellow Flash'","'Ten-Tails Jinchuriki / Divine Absorption'")
s=s.replace("  icon_ids[C['counter']['id']]=21004475","")
s=s.replace("assets/skill/40/21004473.png","assets/skill/40/21011773.png")
s=s.replace("print('PASS Kakuzu/Water Clone native tables and lossless textures:'","print('PASS Infinite Tsukuyomi native tables and lossless textures:'")
(B/'build.py').write_text(s)
s=base('build-items.py').replace('Minato','Madara').replace('Infinite [New Year]','Madara [Infinite Tsukuyomi]')
(B/'build-items.py').write_text(s)
