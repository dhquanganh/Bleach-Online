from pathlib import Path
import json,struct,zlib,shutil,io
from datetime import datetime
from PIL import Image
BASE=Path(__file__).resolve().parent
ROOT=BASE.parents[1]
PUBLIC=ROOT/'kaynak/login.gogames.me/public'
CONFIG=json.loads((ROOT/'sunucu/mystic-shop-config.json').read_text(encoding='utf-8'))
ID=CONFIG['currencyID']
def u32(n):return struct.pack('<I',n)
def utf(t):
 b=t.encode('utf-8');return struct.pack('<H',len(b))+b
def recordArticle(a):
 return u32(ID)+utf(a['name'])+b''.join(u32(a[k]) for k in ['majorType','minorType','level','quality','cardType','sort','overlayNumber','bindMode','obtain'])+utf(a['functionDesc'])+u32(a['picture'])+utf(a['costPrice'])+b''.join(u32(a[k]) for k in ['sellPrice','itemFunction','functionValue','f16'])
def recordOffer(o):
 price=json.dumps(o['price'],separators=(',',':'))
 return u32(o['id'])+u32(1)+u32(o['itemID'])+utf(price)+utf(price)+u32(o['number'])+u32(o['totalTimes'])
def articleIDs(b):
 p=8;ids=[];records=[]
 for _ in range(struct.unpack_from('<I',b,4)[0]):
  start=p;ids.append(struct.unpack_from('<I',b,p)[0]);p+=4
  n=struct.unpack_from('<H',b,p)[0];p+=2+n+36
  n=struct.unpack_from('<H',b,p)[0];p+=2+n+4
  n=struct.unpack_from('<H',b,p)[0];p+=2+n+16
  records.append((ids[-1],b[start:p]))
 assert p==len(b);return records
def marketIDs(b):
 p=8;ids=[];records=[]
 for _ in range(struct.unpack_from('<I',b,4)[0]):
  start=p;ids.append(struct.unpack_from('<I',b,p)[0]);p+=12
  for i in range(2):n=struct.unpack_from('<H',b,p)[0];p+=2+n
  p+=8
  records.append((ids[-1],b[start:p]))
 assert p==len(b);return records
item=next(x for x in json.loads((ROOT/'cikarim/veri-json/Article.json').read_text(encoding='utf-8')) if int(x['id'],16)==ID)
backup=BASE/'backups'/datetime.now().strftime('%Y%m%d-%H%M%S-resources')
changes=0;articleCount=0;marketCount=0
for f in PUBLIC.glob('*/Resources/Bin/*/*.binPackage'):
 b=f.read_bytes();p=6;parts=[b[:6]];changed=False
 for _ in range(struct.unpack_from('<H',b,4)[0]):
  n=struct.unpack_from('<I',b,p)[0];p+=4;c=b[p:p+n];p+=n
  raw=zlib.decompress(c);db=struct.unpack_from('<I',raw)[0];extra=[]
  records=None;replacements={}
  if db==0x1000002:
   records=articleIDs(raw);replacements={ID:recordArticle(item)};articleCount+=1
  if db==0x10000cb:
   records=marketIDs(raw);replacements={o['id']:recordOffer(o) for o in CONFIG['offers']};marketCount+=1
  if records is not None:
   ownIDs={ident for ident,record in records}
   updated=[replacements.get(ident,record) for ident,record in records]
   updated.extend(record for ident,record in replacements.items() if ident not in ownIDs)
   new=raw[:4]+u32(len(updated))+b''.join(updated)
   # Existing records outside this feature must be byte-for-byte unchanged.
   parser=articleIDs if db==0x1000002 else marketIDs
   check=dict(parser(new))
   assert all(check[ident]==record for ident,record in records if ident not in replacements)
   assert all(check[ident]==record for ident,record in replacements.items())
   if new!=raw:c=zlib.compress(new);changed=True
  parts.extend([u32(len(c)),c])
 parts.append(b[p:])
 if changed:
  target=backup/f.relative_to(PUBLIC);target.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(f,target);f.write_bytes(b''.join(parts));changes+=1
assert articleCount and marketCount
# Native icon atlas: upper RGB surface, lower red-channel alpha, as decoded by TPakDecoder.
img=Image.open(ROOT/'gorsel/nguyen-thach.png').convert('RGBA').resize((40,40),Image.Resampling.LANCZOS)
atlas=Image.new('RGB',(40,80));atlas.paste(img.convert('RGB'),(0,0));atlas.paste(img.getchannel('A').convert('RGB'),(0,40))
buf=io.BytesIO();atlas.save(buf,format='PNG');png=buf.getvalue()
# Inner PAK is big-endian; outer texture stream and animation are little-endian.
pak=struct.pack('>BHHBBBHhhhhI',1,40,40,100,100,0,1,0,0,40,40,len(png))+png
pak=zlib.compress(pak)
sequence=struct.pack('<IBHhhhhhhH',0,0,1,0,0,40,40,0,0,70)
texture=u32(ID)+u32(len(sequence))+sequence+struct.pack('<H',1)+u32(len(pak))+pak+struct.pack('<H',1)
for version in ['2017112917','2026090619']:
 target=PUBLIC/version/'Resources/Textures/Inventory'/f'{ID:08X}.TexClient';target.parent.mkdir(parents=True,exist_ok=True);target.write_bytes(texture)
print('Verified native resources:',changes,'packages updated;',articleCount,'Article blocks;',marketCount,'BlackMarket blocks; native icon',len(texture),'bytes.')
