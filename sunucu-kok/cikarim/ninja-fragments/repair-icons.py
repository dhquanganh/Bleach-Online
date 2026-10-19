"""Repair only three public item pictures and native icons; leave ownership/offers unchanged."""
from pathlib import Path
from PIL import Image,ImageOps
import argparse,json,shutil,struct,zlib
import build
FEATURES=[(14130920,'Obito','Extracted_Obito_Rage/battle/role/head_45_45/11006051.png'),
          (14130930,'Pain','Pain_Tendo_Six_Paths_Rinnegan/assets/battle/role/head_45_45/11006531.png'),
          (14130940,'Hashirama','Hashirama_Senju_Final_Battle/assets/battle/role/head_45_45/11003341.png')]
BASE=Path(__file__).resolve().parent
def main():
 p=argparse.ArgumentParser();p.add_argument('--apply',action='store_true');args=p.parse_args()
 path=build.native.DATA/'Article.json';rows=json.loads(path.read_text(encoding='utf-8'));items={item for item,_,_ in FEATURES}
 replacements={}
 for row in rows:
  item=int(row['id'],16)
  if item in items:row['picture']=build.icon_id(item);replacements[item]=build.serialize(2,row)
 assert len(replacements)==3
 assert not any(int(row['id'],16) not in items and int(row.get('picture',0)) in build.ICON_IDS.values() for row in rows),'Icon ID collision'
 changes={path:(json.dumps(rows,ensure_ascii=False,indent=2)+'\n').encode()}
 def patch(raw):
  if struct.unpack_from('<I',raw)[0]!=0x1000002:return raw
  records=build.records(raw,2);assert all(item in dict(records) for item in items)
  return raw[:8]+b''.join(replacements.get(item,data) for item,data in records)
 for path in build.native.PUBLIC.glob('*/Resources/Bin/**/*'):
  if not path.is_file():continue
  data=path.read_bytes()
  if path.suffix=='.bin':
   raw=zlib.decompress(data);fixed=patch(raw)
   if raw!=fixed:changes[path]=zlib.compress(fixed)
  elif path.suffix=='.binPackage':
   pos=6;parts=[data[:6]];changed=False
   for _ in range(struct.unpack_from('<H',data,4)[0]):
    size=struct.unpack_from('<I',data,pos)[0];pos+=4;packed=data[pos:pos+size];pos+=size
    raw=zlib.decompress(packed);fixed=patch(raw)
    if raw!=fixed:packed=zlib.compress(fixed);changed=True
    parts.extend([build.u32(len(packed)),packed])
   if changed:changes[path]=b''.join(parts)+data[pos:]
 preview=Image.new('RGBA',(144,48),(32,39,44,255))
 for index,(item,_,source) in enumerate(FEATURES):
  image=ImageOps.fit(Image.open(build.ROOT.parent/'asset'/source).convert('RGBA'),(40,40),Image.Resampling.LANCZOS)
  preview.alpha_composite(image,(index*48+4,4))
  for version in ['2017112917','2026090619']:
   for ident in [item,build.icon_id(item)]:
    changes[build.native.PUBLIC/version/'Resources/Textures/Inventory'/f'{ident:08X}.TexClient']=build.inventory_texture(ident,image)
 preview.save(BASE/'icons-repaired.png')
 if args.apply:
  for path,data in changes.items():
   if path.exists() and path.read_bytes()==data:continue
   backup=BASE/'backups/icon-repair'/path.relative_to(build.ROOT)
   if path.exists() and not backup.exists():backup.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(path,backup)
   path.parent.mkdir(parents=True,exist_ok=True);path.write_bytes(data)
 print('PASS three unique static Modify Fragment icons;',len(changes),'resource/Article files; applied',args.apply)
if __name__=='__main__':main()
