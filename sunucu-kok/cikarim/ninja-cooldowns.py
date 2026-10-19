"""Update only skill descriptions in existing native databases; retain all art/stats."""
from pathlib import Path
import copy,importlib.util,json,struct,zlib,sys
BASE=Path(__file__).resolve().parent
sys.path.insert(0,str(BASE/'naruto-sage'))
spec=importlib.util.spec_from_file_location('native',BASE/'naruto-sage/build.py');native=importlib.util.module_from_spec(spec);spec.loader.exec_module(native)
REPLACEMENTS={
 'Cooldown 2 rounds. Chase Repulse or Knockdown.':'No cooldown. Chase Repulse or Knockdown.',
 'Cooldown 2 rounds. At an eligible round start,':'No cooldown. At the beginning of every round,',
 'Cooldown 2 rounds, shared across base/Rage. Rage Spear retains two uses within an eligible round.':'No cooldown. Per-round Chase limits still apply.',
 'at eligible round start (2-round cooldown)':'at the beginning of every round (no cooldown)',
 'at round start (2-round cooldown)':'at the beginning of every round (no cooldown)',
}
def text(s):
 for a,b in REPLACEMENTS.items():s=s.replace(a,b)
 return s
def main():
 no_cd=set();ids={'BaseHero':set(),'HeroTalent':{13220920,13220930,13220940},'SkillConfig':set()}
 for name in ['obito-rage','pain-tendo','hashirama-final']:
  cfg=json.loads((BASE.parent/'sunucu'/f'{name}.json').read_text());ids['BaseHero'].add(cfg['heroId'])
  def walk(v):
   if isinstance(v,dict):
    if 'id' in v:
     ids['SkillConfig'].add(v['id'])
     if not v.get('prompt'):no_cd.add(v['id'])
    for item in v.values():walk(item)
   elif isinstance(v,list):
    for item in v:walk(item)
  walk(cfg)
 rows={'BaseHero':[],'HeroTalent':[],'RoleModel':[],'SkillConfig':[]};files={}
 for kind,selected in ids.items():
  path=native.DATA/(kind+'.json');data=json.loads(path.read_text(encoding='utf-8'));changed=False
  for row in data:
   ident=int(row['id'],16)
   if ident not in selected:continue
   before=copy.deepcopy(row)
   for field in ['desc','talentDesc']:
    if field in row:row[field]=text(row[field])
   if kind=='SkillConfig' and ident in no_cd and 'No cooldown.' not in row['desc']:
    row['desc']+=' No cooldown. Per-round limits and trigger conditions still apply.'
   rows[kind].append(row)
   changed|=row!=before
  if changed:files[path]=(json.dumps(data,ensure_ascii=False,indent=2)+'\n').encode()
 for path in native.PUBLIC.glob('*/Resources/Bin/**/*'):
  if not path.is_file() or path.suffix not in ['.bin','.binPackage']:continue
  b=path.read_bytes()
  if path.suffix=='.bin':
   if path.stem.upper() not in ['01000005','0100001F','0100003F']:continue
   raw=zlib.decompress(b);new=native.patch(raw,rows)
   if new!=raw:files[path]=zlib.compress(new)
  else:
   pos=6;parts=[b[:6]];changed=False
   for _ in range(struct.unpack_from('<H',b,4)[0]):
    n=struct.unpack_from('<I',b,pos)[0];pos+=4;c=b[pos:pos+n];pos+=n
    raw=zlib.decompress(c);new=native.patch(raw,rows)
    if new!=raw:c=zlib.compress(new);changed=True
    parts.extend([native.u32(len(c)),c])
   if changed:files[path]=b''.join(parts)+b[pos:]
 for path,content in files.items():path.write_bytes(content)
 # Keep the original installers consistent, without rebuilding any textures.
 for directory in ['obito-rage','pain-tendo']:
  path=BASE/directory/'build.py';s=path.read_text();path.write_text(text(s))
 print('PASS native descriptions:',len(no_cd),'non-Mystery skills;',len(files),'databases updated; all unrelated native records preserved')
if __name__=='__main__':main()
