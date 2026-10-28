from pathlib import Path
import json
R=Path(__file__).resolve().parents[1];B=R/'sunucu-kok/cikarim/madara-infinite';T=B.parent/'minato-new-year'
s=(T/'build-probe.py').read_text().replace('Minato','Infinite').replace('minato-new-year','madara-infinite').replace('minatoNewYear','madaraInfinite').replace('11121003','11121005').replace('11121004','11121005').replace('7510','7512').replace('7511','7513')
s=s.replace("a['clips']['clone-counter']=a['clips']['counter'];",'')
start=s.index("names=[");end=s.index('\nfor _ in range(2):',start)
names=['mystery','limbo','standard','standard2','standard3','susanoo','chase','limboChase','counter','barrier','evade','revive','entry','dead']
ids=[13122201,13122202,13122203,13122204,13122205,13122206,13122207,13122208,13122209,13122210,13122211,13122212,0,0]
s=s[:start]+'names='+repr(names)+';ids='+repr(ids)+';bounds=[0]'+s[end:]
s=s.replace('00A9B16B',f'{11121005:08X}').replace('A9B16B0B',f'{11121005:X}0B').replace('A9B16B0C',f'{11121005:X}0C')
s=s.replace('["standard","standard-2","standard-3"]','["limbo","standard","standard2","standard3"]').replace('["mystery","enhanced-mystery","counter","summon","prowess","evade","entry","dead"]','["mystery","susanoo","chase","limboChase","counter","barrier","evade","revive","entry","dead"]')
s=s.replace('loaded<12','loaded<15').replace('slot<24','slot<28').replace('slot>=24','slot>=28').replace('slot<12','slot<14').replace('slot%12','slot%14')
s=s.replace('renderRole(caster,index>=8?"clone-idle":"idle",','renderRole(caster,"idle",')
s=s.replace('131221','131222')
s=s.replace("replace('7486','7510').replace('7487','7511')", "replace('7486','7512').replace('7487','7513')")
(B/'build-probe.py').write_text(s)
