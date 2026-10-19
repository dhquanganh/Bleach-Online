"""Patch physical-damage descriptions without rebuilding textures or client code."""
from pathlib import Path
import importlib.util,json,struct,zlib,sys
BASE=Path(__file__).resolve().parent
sys.path.insert(0,str(BASE/'naruto-sage'))
spec=importlib.util.spec_from_file_location('native',BASE/'naruto-sage/build.py');native=importlib.util.module_from_spec(spec);spec.loader.exec_module(native)
NOTE='Deals physical damage, scales with Physical ATK and is mitigated by Physical DEF.'
def main():
 heroes=set();damaging=set()
 for name in ['obito-rage','pain-tendo','hashirama-final']:
  cfg=json.loads((BASE.parent/'sunucu'/(name+'.json')).read_text());heroes.add(cfg['heroId'])
  def walk(v):
   if isinstance(v,dict):
    if v.get('id') and v.get('multiplier',0)>0:
     assert v['attackStat']=='atk' and v['damageType']=='physical';damaging.add(v['id'])
    for child in v.values():walk(child)
   elif isinstance(v,list):
    for child in v:walk(child)
  walk(cfg)
 rows={k:[] for k in ['BaseHero','HeroTalent','RoleModel','SkillConfig']};changes={}
 for kind,ids,field in [('BaseHero',heroes,'desc'),('HeroTalent',{13220920,13220930,13220940},'talentDesc'),('SkillConfig',damaging,'desc')]:
  path=native.DATA/(kind+'.json');data=json.loads(path.read_text(encoding='utf-8'))
  for row in data:
   if int(row['id'],16) not in ids:continue
   row[field]=row[field].replace('Damage scales with Physical ATK.',NOTE)
   if NOTE not in row[field]:row[field]+=' '+NOTE
   rows[kind].append(row)
  changes[path]=(json.dumps(data,ensure_ascii=False,indent=2)+'\n').encode()
 for path in native.PUBLIC.glob('*/Resources/Bin/**/*'):
  if not path.is_file() or path.suffix not in ['.bin','.binPackage']:continue
  b=path.read_bytes()
  if path.suffix=='.bin':
   if path.stem.upper() not in ['01000005','0100001F','0100003F']:continue
   raw=zlib.decompress(b);new=native.patch(raw,rows)
   if new!=raw:changes[path]=zlib.compress(new)
  else:
   pos=6;parts=[b[:6]];changed=False
   for _ in range(struct.unpack_from('<H',b,4)[0]):
    n=struct.unpack_from('<I',b,pos)[0];pos+=4;c=b[pos:pos+n];pos+=n;raw=zlib.decompress(c);new=native.patch(raw,rows)
    if new!=raw:c=zlib.compress(new);changed=True
    parts.extend([native.u32(len(c)),c])
   if changed:changes[path]=b''.join(parts)+b[pos:]
 count=0
 for path,content in changes.items():
  if path.read_bytes()!=content:path.write_bytes(content);count+=1
 print('PASS',len(damaging),'physical skills;',count,'databases updated; unrelated rows, textures, shake and multihit preserved')
if __name__=='__main__':main()
