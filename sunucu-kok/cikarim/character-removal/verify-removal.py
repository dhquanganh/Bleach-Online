"""Verify published removal, data boundaries and absence of dedicated files."""
from pathlib import Path
import hashlib,importlib.util,json,struct,sys,zlib
BASE=Path(__file__).resolve().parent;ROOT=BASE.parents[1];PUBLIC=ROOT/'kaynak/login.gogames.me/public'
sys.path.insert(0,str(BASE.parent/'naruto-sage'))
def load(name,path):
 s=importlib.util.spec_from_file_location(name,path);m=importlib.util.module_from_spec(s);s.loader.exec_module(m);return m
n=load('native',BASE.parent/'naruto-sage/build.py');f=load('inventory',BASE.parent/'shared-animation/inventory-tables.py')
own=set(range(11120910,11120915))|set(range(11120980,11120985))|set(range(13120931,13120943))|set(range(13121401,13121413))|set(range(13220910,13220915))|set(range(13220980,13220985))|{14130910,14130980,41120910,41120980,13621931,13622401}
def check(raw):
 kind=struct.unpack_from('<I',raw)[0]-0x1000000;name={5:'BaseHero',0x1f:'HeroTalent',0x38:'RoleModel',0x3f:'SkillConfig'}.get(kind)
 rows=n.records(raw,name) if name else f.records(raw,kind) if kind in (2,0xCC,0xCB) else []
 assert not any(i in own for i,b in rows)
 return len(rows)
release=json.loads((BASE/'release.json').read_text());version=release['version'];checked=0
assert json.loads((PUBLIC/'client-release.json').read_text())['version']==version=='2026102310'
for row in release['files']:
 p=PUBLIC/version/row['path'];assert hashlib.sha256(p.read_bytes()).hexdigest()==row['sha256']
 if p.suffix=='.bin':checked+=check(zlib.decompress(p.read_bytes()))
 elif p.suffix=='.binPackage':
  data=p.read_bytes();pos=6
  for _ in range(struct.unpack_from('<H',data,4)[0]):
   count=struct.unpack_from('<I',data,pos)[0];pos+=4;checked+=check(zlib.decompress(data[pos:pos+count]));pos+=count
deleted=json.loads((BASE/'deleted-paths.json').read_text(encoding='utf-8-sig'))
assert all(not Path(p).exists() for p in deleted)
info=json.loads((BASE/'client-verification.json').read_text())
apps=list(PUBLIC.glob('*/TApplication.swf'));assert all(hashlib.sha256(p.read_bytes()).hexdigest()==info['sha256'] for p in apps)
for p in (BASE/'verify/scripts').rglob('*.as'):assert 'kabuto' not in p.read_text(encoding='utf-8').lower()
for name in ['mecha-naruto','itachi-rtn','obito-rage','pain-tendo','hashirama-final','sasuke-shinden']:
 load('builder_'+name.replace('-','_'),BASE.parent/name/'build.py')
report={'version':version,'deletedTargetsVerified':len(deleted),'publishedClientsWithoutRemovedRenderer':len(apps),'remainingNativeRowsVerified':checked,'sharedBuildersImport':True,'otherRoleMethodsPreserved':info['classes']['Processors/Game/Battle/Character/TRole.as']['preservedMethods']}
(BASE/'verified.json').write_text(json.dumps(report,indent=2))
print('PASS',json.dumps(report))
