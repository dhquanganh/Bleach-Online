from pathlib import Path
import json,struct,zlib,shutil
from datetime import datetime
ROOT=Path(__file__).resolve().parents[2]
DATA=ROOT/'cikarim/veri-json/GSPVP_Reward.json'
PUBLIC=ROOT/'kaynak/login.gogames.me/public'
u32=lambda n:struct.pack('<I',n)
def utf(s):
 b=s.encode('utf-8');return struct.pack('<H',len(b))+b
rows=json.loads(DATA.read_text(encoding='utf-8'));updates={}
for row in rows:
 ident=int(row['id'],16)
 if 5001<=ident<=5035:
  rank=(ident-5001)%5
  rewards=[r for r in json.loads(row['f2']) if r.get('code') not in [14100283,14900001]]
  rewards += [{'type':1,'code':14100283,'amount':[10,20,30,40,50][rank]},{'type':1,'code':14900001,'amount':[5,10,15,20,25][rank]}]
  row['f2']=json.dumps(rewards,separators=(',',':'))
  updates[ident]=row['f2']
backup=Path(__file__).resolve().parent/'backups'/datetime.now().strftime('%Y%m%d-%H%M%S-rewards')
backup.mkdir(parents=True,exist_ok=True);shutil.copy2(DATA,backup/DATA.name)
DATA.write_text(json.dumps(rows,ensure_ascii=False,indent=2),encoding='utf-8')
changed=0
for f in PUBLIC.glob('*/Resources/Bin/*/*.binPackage'):
 b=f.read_bytes();pos=6;parts=[b[:6]];dirty=False
 for _ in range(struct.unpack_from('<H',b,4)[0]):
  n=struct.unpack_from('<I',b,pos)[0];pos+=4;c=b[pos:pos+n];pos+=n;r=zlib.decompress(c)
  if struct.unpack_from('<I',r)[0]==0x10000b3:
   p=8;records=[]
   for _ in range(struct.unpack_from('<I',r,4)[0]):
    start=p;ident=struct.unpack_from('<I',r,p)[0];p+=12
    n=struct.unpack_from('<H',r,p)[0];p+=2+n
    records.append(r[start:start+12]+utf(updates[ident]) if ident in updates else r[start:p])
   assert p==len(r)
   new=r[:8]+b''.join(records)
   if new!=r:c=zlib.compress(new);dirty=True
   p=8
   for record in records:
    ident=struct.unpack_from('<I',record)[0]
    if ident in updates:assert record[14:].decode('utf-8')==updates[ident]
  parts.extend([u32(len(c)),c])
 parts.append(b[pos:])
 if dirty:
  dest=backup/f.relative_to(PUBLIC);dest.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(f,dest);f.write_bytes(b''.join(parts));changed+=1
assert changed>0
print('Updated 35 Cross reward rows and',changed,'native Flash resource packages; backups:',backup)
