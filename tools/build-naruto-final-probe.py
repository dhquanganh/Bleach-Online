from pathlib import Path
import json
R=Path(__file__).resolve().parents[1];B=R/'sunucu-kok/cikarim/naruto-final';T=B.parent/'madara-infinite'
C=json.loads((R/'sunucu-kok/sunucu/naruto-final.json').read_text());A=json.loads((B/'animation.json').read_text())
s=(T/'build-probe.py').read_text().replace('Infinite','NarutoFinal').replace('madaraInfinite','narutoFinal').replace('madara-infinite','naruto-final').replace('11121005','11121006').replace('131222','131223')
start=s.index('names=[');end=s.index('\nfor _ in range(2):',start)
names=[C[k]['nfMove'] for k in C['skillKeys']]+['entry','dead'];ids=[C[k]['id'] for k in C['skillKeys']]+[0,0]
s=s[:start]+'names='+repr(names)+';ids='+repr(ids)+';bounds=[0]'+s[end:]
start=s.index('boot=boot[:start]+');end=s.index('source=source.replace(extract(source,\'boot\'),boot,1)',start)
s=s[:start]+'''boot=boot[:start]+\'\'\'   loadTexture("00A9B16E",["idle"]);
   loadTexture("A9B16E0B",["claw","tail","bomb"]);
   loadTexture("A9B16E0C",'''+json.dumps(A['models']['11121006']['0c'])+''');
\'\'\'+boot[end:];'''+s[end:]
s=s.replace('loaded<15','loaded<21').replace('slot<28','slot<40').replace('slot>=28','slot>=40').replace('slot<14','slot<20').replace('slot%14','slot%20')
s=s.replace('NarutoFinal / Yellow Flash Clone','Naruto Final Battle').replace('NarutoFinal/Yellow Flash Clone','Naruto Final Battle')
s=s.replace("js=js.replace('300000','300000')","js=js.replace('300000','300000')")
s=s.replace("replace('7486','7512').replace('7487','7513')","replace('7486','7516').replace('7487','7517')")
(B/'build-probe.py').write_text(s)
