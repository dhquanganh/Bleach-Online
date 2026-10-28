from pathlib import Path
import json
R=Path(__file__).resolve().parents[1];B=R/'sunucu-kok/cikarim/guy-gate';T=B.parent/'madara-infinite'
C=json.loads((R/'sunucu-kok/sunucu/guy-gate.json').read_text());A=json.loads((B/'animation.json').read_text())
s=(T/'build-probe.py').read_text().replace('Infinite','GuyGate').replace('madaraGuyGate','guyGate').replace('madara-infinite','guy-gate').replace('11121005','11121007').replace('131222','131224')
start=s.index('names=[');end=s.index('\nfor _ in range(2):',start);names=[C[k]['guyMove'] for k in C['skillKeys']]+['entry','dead'];ids=[C[k]['id'] for k in C['skillKeys']]+[0,0]
s=s[:start]+'names='+repr(names)+';ids='+repr(ids)+';bounds=[0]'+s[end:]
start=s.index('boot=boot[:start]+');end=s.index("source=source.replace(extract(source,'boot'),boot,1)",start)
s=s[:start]+'''boot=boot[:start]+\'\'\'   loadTexture("00A9B16F",["idle"]);
   loadTexture("A9B16F0B",["standard","standard2"]);
   loadTexture("A9B16F0C",'''+json.dumps(A['models']['11121007']['0c'])+''');
\'\'\'+boot[end:];'''+s[end:]
s=s.replace('loaded<15','loaded<10').replace('slot<28','slot<18').replace('slot>=28','slot>=18').replace('slot<14','slot<9').replace('slot%14','slot%9')
s=s.replace('GuyGate / Yellow Flash Clone','Guy Gate of Death').replace('GuyGate/Yellow Flash Clone','Guy Gate of Death').replace("replace('7486','7512').replace('7487','7513')", "replace('7486','7522').replace('7487','7523')")
(B/'build-probe.py').write_text(s)
s=(T/'release.py').read_text().replace("VERSION='2026102805'","VERSION='2026102816'").replace("active=='2026102804'","active=='2026102815'").replace("probe['cases']==28","probe['cases']==18").replace('11121005','11121007').replace('14131005','14131007').replace('14141005','14141007').replace('131222','131224').replace('13623201','13623401').replace('range(13122401,13122413)','range(13122401,13122408)').replace("['TRole']>=235","['TRole']>=252")
(B/'release.py').write_text(s)
