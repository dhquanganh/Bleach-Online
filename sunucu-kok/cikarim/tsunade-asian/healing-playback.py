"""Fix allied HP application in native animation metadata, not the heal formula."""
from pathlib import Path
import importlib.util,json,shutil,struct,zlib
B=Path(__file__).resolve().parent
def module(name,path):
 s=importlib.util.spec_from_file_location(name,path);m=importlib.util.module_from_spec(s);s.loader.exec_module(m);return m
builder=module('builder',B/'build.py');release=module('release',B/'release.py')
TIMINGS={13121602:16,13121603:84,13121604:17,13121605:48,13121606:84,13121609:10}
def fixed_effects(hero):
 effects=json.loads(hero['attackEffect'])
 for skill,frame in TIMINGS.items():
  if str(skill) not in effects:continue
  effect=effects[str(skill)];effect.pop('appendEffect',None);effect.pop('anmyhp',None);effect['friendhp']={str(frame):100}
 return json.dumps(effects,separators=(',',':'))
def main():
 native=builder.native;P=native.PUBLIC;base=native.DATA/'BaseHero.json';rows=json.loads(base.read_text(encoding='utf-8'));selected=[]
 for h in rows:
  if int(h['id'],16) in [11120992,11120993]:h['attackEffect']=fixed_effects(h);selected.append(h)
 records={'BaseHero':selected,'HeroTalent':[],'SkillConfig':[],'RoleModel':[]};changes={base:(json.dumps(rows,ensure_ascii=False,indent=2)+'\n').encode()}
 paths=set()
 for version in ['2017112917','2026090619']:
  paths.update((P/version/'Resources/Bin').rglob('*.bin'));paths.update((P/version/'Resources/Bin').rglob('*.binPackage'))
 for key,version in release.rows((P/'2026090619/version.swf').read_bytes()):
  key=key.decode()
  if key.startswith('Resources/Bin/') and '/.svn/' not in key and key.endswith(('.bin','.binPackage')):paths.add(P/version.decode()/key)
 for path in paths:
  if not path.is_file():continue
  raw=path.read_bytes()
  if path.suffix=='.bin':
   content=zlib.decompress(raw);updated=native.patch(content,records)
   if updated!=content:changes[path]=zlib.compress(updated)
  else:
   pos=6;parts=[raw[:6]];changed=False
   for _ in range(struct.unpack_from('<H',raw,4)[0]):
    n=struct.unpack_from('<I',raw,pos)[0];pos+=4;chunk=raw[pos:pos+n];pos+=n;content=zlib.decompress(chunk);updated=native.patch(content,records)
    if updated!=content:chunk=zlib.compress(updated);changed=True
    parts.extend([struct.pack('<I',len(chunk)),chunk])
   if changed:changes[path]=b''.join(parts)+raw[pos:]
 for path,content in changes.items():
  saved=B/'healing-visibility/backups'/path.relative_to(B.parents[1]);saved.parent.mkdir(parents=True,exist_ok=True)
  if not saved.exists():shutil.copy2(path,saved)
  path.write_bytes(content)
 print('PASS allied HP playback:',len(changes),'data files;',len(TIMINGS),'support animation mappings')
if __name__=='__main__':main()
