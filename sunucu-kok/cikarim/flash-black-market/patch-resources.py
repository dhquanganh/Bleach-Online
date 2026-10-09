from pathlib import Path
import struct,zlib,json,shutil
from datetime import datetime
root=Path(__file__).resolve().parents[2]/'kaynak/login.gogames.me/public/2026090619/Resources/Bin'
backup=Path(__file__).resolve().parent/'backups'/datetime.now().strftime('%Y%m%d-%H%M%S-resources')
offers={o['id']:o for o in json.loads((Path(__file__).resolve().parents[2]/'sunucu/black-market-config.json').read_text())['offers']}
def utf(s):
 b=s.encode();return struct.pack('<H',len(b))+b
def market(raw):
 p=8;parts=[raw[:8]];found=False
 for _ in range(struct.unpack_from('<I',raw,4)[0]):
  start=p;ident,model,item=struct.unpack_from('<Iii',raw,p);p+=12
  strings=[]
  for i in range(2):
   n=struct.unpack_from('<H',raw,p)[0];p+=2;strings.append(raw[p:p+n]);p+=n
  qty,limit=struct.unpack_from('<ii',raw,p);p+=8
  if ident in offers:
   o=offers[ident];price=json.dumps(o['price'],separators=(',',':'))
   parts.append(struct.pack('<Iii',ident,model,o['itemID'])+utf(price)+utf(price)+struct.pack('<ii',o['number'],o['totalTimes']));found=True
  else:parts.append(raw[start:p])
 assert p==len(raw)
 return b''.join(parts),found
count=0
for f in root.glob('*/*.binPackage'):
 original=f.read_bytes();p=6;parts=[original[:6]];changed=False
 for _ in range(struct.unpack_from('<H',original,4)[0]):
  n=struct.unpack_from('<I',original,p)[0];p+=4;compressed=original[p:p+n];p+=n
  try:raw=zlib.decompress(compressed)
  except zlib.error:raw=b''
  if len(raw)>=8 and struct.unpack_from('<I',raw)[0]==0x10000cb:
   updated,found=market(raw)
   if found:
    # Independent field check of the actual resource record.
    pos=updated.index(struct.pack('<I',20000001),8)
    assert struct.unpack_from('<i',updated,pos+8)[0]==14100005
    compressed=zlib.compress(updated);changed=True
  parts.extend([struct.pack('<I',len(compressed)),compressed])
 parts.append(original[p:])
 if changed:
  target=backup/f.relative_to(root);target.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(f,target)
  f.write_bytes(b''.join(parts));count+=1
print('Patched and backed up',count,'Black Market resource packages (all language variants).')
assert count>0
