from pathlib import Path
import json
R=Path(__file__).resolve().parents[1]
for name in ['madara-final','madara-infinite']:
 p=R/'sunucu-kok/sunucu'/f'{name}.json';data=json.loads(p.read_text(encoding='utf-8'))
 def update(v):
  if isinstance(v,dict):
   for k,x in v.items():
    if k=='description':
     import re
     x=re.sub(r"Attack</font> and <font color=\"#4dc831\">Ninjutsu",'Physical ATK',x)
     x=x.replace('Ninjutsu','Physical ATK')
     if v.get('name')=='Uchiha Reflection':x=x.replace('recovers 30% HP','recovers 50% HP')
     v[k]=x
    else:update(x)
  elif isinstance(v,list):
   for x in v:update(x)
 update(data)
 if name=='madara-final':data['reflection']['healRatio']=.5
 p.write_text(json.dumps(data,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
