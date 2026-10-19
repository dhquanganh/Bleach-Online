"""Translate the client's reward descriptions into checked structured server data."""
import json,re
from pathlib import Path
ROOT=Path(__file__).resolve().parents[3]
rows=json.loads((ROOT/'sunucu-kok/cikarim/veri-json/RankReward.json').read_text(encoding='utf-8'))
numbers={'十':10,'十二':12,'十四':14,'十六':16,'十八':18}
bands=[]
for level in range(1,160):
 rewards=[]
 for quality in range(1,8):
  row=next(r for r in rows if int(r['id'],16)==(level-1)*7+quality)
  english=re.search(r'(\d+) (Blue|Purple|Golden) Equipment Material Chest',row['tips'])
  chinese=re.search(r'(十[二四六八]?)个(紫色|金色)装备材料宝箱',row['tips'])
  if english:amount=int(english[1]);code={'Blue':14800020,'Purple':14800021,'Golden':14800022}[english[2]]
  else:
   assert chinese,row
   amount=numbers[chinese[1]];code={'紫色':14800021,'金色':14800022}[chinese[2]]
  rewards.append([code,amount])
 if bands and bands[-1]['rewards']==rewards:bands[-1]['to']=level
 else:bands.append({'from':level,'to':level,'rewards':rewards})
dest=ROOT/'sunucu-kok/sunucu/arena-materials.json'
dest.write_text(json.dumps(bands,indent=2)+'\n',encoding='utf-8')
print('Verified all 1113 client reward descriptions;',len(bands),'level bands generated.')
