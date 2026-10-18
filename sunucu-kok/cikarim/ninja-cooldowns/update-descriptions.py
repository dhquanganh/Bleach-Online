"""Update only ninja skill/talent descriptions, preserving actor art and other DB rows."""
from pathlib import Path
import argparse,copy,hashlib,importlib.util,json,shutil,struct,sys,zlib
BASE=Path(__file__).resolve().parent
ROOT=BASE.parents[1]
sys.path.insert(0,str(BASE.parent/'naruto-sage'))
def load(name,path):
 spec=importlib.util.spec_from_file_location(name,path);module=importlib.util.module_from_spec(spec);spec.loader.exec_module(module);return module
native=load('ninja_native',BASE.parent/'naruto-sage/build.py')
jiraiya=load('jiraiya_native',BASE.parent/'jiraiya-toads/build.py')
def main():
 parser=argparse.ArgumentParser();parser.add_argument('--apply',action='store_true');opts=parser.parse_args()
 desired=[native.database_rows(),jiraiya.rows()]
 rows={};changes={}
 for kind,field in [('SkillConfig','desc'),('HeroTalent','talentDesc')]:
  path=native.DATA/(kind+'.json');old=json.loads(path.read_text(encoding='utf-8'))
  descriptions={r['id']:r[field] for kit in desired for r in kit[kind]}
  selected=[];updated=copy.deepcopy(old)
  for row in updated:
   if row['id'] in descriptions:row[field]=descriptions[row['id']];selected.append(row)
  assert len(selected)==len(descriptions),'Missing installed ninja description rows'
  rows[kind]=selected
  if updated!=old:changes[path]=(json.dumps(updated,ensure_ascii=False,indent=2)+'\n').encode()
 def patch(raw):
  if struct.unpack_from('<I',raw)[0] not in [0x100001f,0x100003f]:return raw
  return native.patch(raw,rows)
 for path in native.PUBLIC.glob('*/Resources/Bin/**/*'):
  if not path.is_file():continue
  original=path.read_bytes()
  if path.suffix=='.bin' and path.stem.upper() in ['0100001F','0100003F']:
   raw=zlib.decompress(original);updated=patch(raw)
   if updated!=raw:changes[path]=zlib.compress(updated)
  elif path.suffix=='.binPackage':
   pos=6;parts=[original[:6]];changed=False
   for _ in range(struct.unpack_from('<H',original,4)[0]):
    size=struct.unpack_from('<I',original,pos)[0];pos+=4;compressed=original[pos:pos+size];pos+=size
    raw=zlib.decompress(compressed);updated=patch(raw)
    if updated!=raw:compressed=zlib.compress(updated);changed=True
    parts.extend([native.u32(len(compressed)),compressed])
   if changed:changes[path]=b''.join(parts)+original[pos:]
 if opts.apply:
  for path,data in changes.items():
   backup=BASE/'backups'/path.relative_to(ROOT);backup.parent.mkdir(parents=True,exist_ok=True)
   if not backup.exists():shutil.copy2(path,backup)
   path.write_bytes(data)
  # Read back every installed replacement and verify the operation is idempotent.
  for path in native.PUBLIC.glob('*/Resources/Bin/**/*'):
   if not path.is_file():continue
   data=path.read_bytes()
   if path.suffix=='.bin' and path.stem.upper() in ['0100001F','0100003F']:
    raw=zlib.decompress(data);assert patch(raw)==raw
   elif path.suffix=='.binPackage':
    pos=6
    for _ in range(struct.unpack_from('<H',data,4)[0]):
     size=struct.unpack_from('<I',data,pos)[0];pos+=4;raw=zlib.decompress(data[pos:pos+size]);pos+=size
     assert patch(raw)==raw
 (BASE/'manifest.json').write_text(json.dumps({'applied':opts.apply,'files':[{'path':str(path.relative_to(ROOT)),'sha256':hashlib.sha256(data).hexdigest()} for path,data in changes.items()]},indent=2)+'\n')
 print('PASS ninja cooldown descriptions; unrelated native rows preserved; files:',len(changes),'installed:',opts.apply)
if __name__=='__main__':main()
