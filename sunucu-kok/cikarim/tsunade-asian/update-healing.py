"""Update healing descriptions without rebuilding actor textures or changing stats."""
from pathlib import Path
import importlib.util,json,shutil,struct,zlib
B=Path(__file__).resolve().parent
sp=importlib.util.spec_from_file_location('builder',B/'build.py');b=importlib.util.module_from_spec(sp);sp.loader.exec_module(b)
def main():
 rows={'RoleModel':[]};changes={};backup=B/'healing-def-backups'
 for kind in ['BaseHero','HeroTalent','SkillConfig']:
  p=b.native.DATA/(kind+'.json');old=json.loads(p.read_text(encoding='utf-8'));new=[];replacements=[]
  for record in old:
   ident=int(record['id'],16)
   selected=kind=='BaseHero' and ident in [11120992,11120993] or kind=='HeroTalent' and ident==13220992 or kind=='SkillConfig' and 13121601<=ident<=13121609
   if selected:
    record=dict(record)
    for key in ['desc','talentDesc']:
     if key in record:record[key]=record[key].replace('base Ninjutsu','Physical DEF')
    if kind=='SkillConfig' and ident==13121609:record['desc']=b.DESC['13121609']
    replacements.append(record)
   new.append(record)
  rows[kind]=replacements
  if new!=old:changes[p]=(json.dumps(new,ensure_ascii=False,indent=2)+'\n').encode()
 for p in b.native.PUBLIC.glob('*/Resources/Bin/**/*'):
  if not p.is_file() or p.suffix not in ['.bin','.binPackage']:continue
  data=p.read_bytes()
  if p.suffix=='.bin':
   raw=zlib.decompress(data);updated=b.native.patch(raw,rows)
   if raw!=updated:changes[p]=zlib.compress(updated)
  else:
   pos=6;parts=[data[:6]];changed=False
   for _ in range(struct.unpack_from('<H',data,4)[0]):
    n=struct.unpack_from('<I',data,pos)[0];pos+=4;c=data[pos:pos+n];pos+=n;raw=zlib.decompress(c);updated=b.native.patch(raw,rows)
    if raw!=updated:c=zlib.compress(updated);changed=True
    parts.extend([struct.pack('<I',len(c)),c])
   if changed:changes[p]=b''.join(parts)+data[pos:]
 for p,data in changes.items():
  relative=p.relative_to(b.ROOT);saved=backup/relative;saved.parent.mkdir(parents=True,exist_ok=True)
  if not saved.exists():shutil.copy2(p,saved)
  p.write_bytes(data)
 print('PASS Physical DEF healing descriptions;',len(changes),'native data files; actor textures unchanged')
if __name__=='__main__':main()
