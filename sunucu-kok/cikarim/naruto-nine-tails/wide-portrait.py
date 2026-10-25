"""Full-width native Naruto portrait; move custom events clear of the gift icon."""
from pathlib import Path
import importlib.util,json,re,shutil,hashlib
B=Path(__file__).resolve().parent;W=B/'wide-portrait';VERSION='2026102506';LOBBY=Path('Processors/Game/Lobby/TProcessorLobby.as')
s=importlib.util.spec_from_file_location('b',B/'build-client.py');m=importlib.util.module_from_spec(s);s.loader.exec_module(m);c=m.c
s=importlib.util.spec_from_file_location('r',B.parent/'tsunade-asian/release.py');r=importlib.util.module_from_spec(s);s.loader.exec_module(r)
def compile_client():
 changed={c.b.ROLE:{'PlayNineTailsNativeRasengan'},LOBBY:{'IllusionUpdate'}}
 for rel in changed:
  before=(W/'original/scripts'/rel).read_text(encoding='utf-8')
  if rel==c.b.ROLE:
   runtime=(B/'native-rasengan.as.txt').read_text();after=before.replace(c.m.extract(before,'PlayNineTailsNativeRasengan'),c.m.extract(runtime,'PlayNineTailsNativeRasengan'),1)
  else:
   method=c.m.extract(before,'IllusionUpdate');new=method.replace('this.FMyobokuIcon.x = anchor.x;','this.FMyobokuIcon.x = anchor.x - 72;').replace('this.FIllusionIcon.x = anchor.x + 68;','this.FIllusionIcon.x = anchor.x - 4;');assert new!=method;after=before.replace(method,new,1)
  target=W/'patched'/rel;target.parent.mkdir(parents=True,exist_ok=True);target.write_text(after,encoding='utf-8')
 c.ff('-onerror','abort','-importScript',W/'source.swf',W/'compiled.swf',W/'patched')
 a=(W/'source.swf').read_bytes();b=(W/'compiled.swf').read_bytes();assert [t for t in c.h.tags(a) if t[0]!=82]==[t for t in c.h.tags(b) if t[0]!=82]
 c.ff('-selectclass','Processors.Game.Battle.Character.TRole,Processors.Game.Lobby.TProcessorLobby','-export','script',W/'verify',W/'compiled.swf')
 counts={}
 for rel,allowed in changed.items():
  before=(W/'original/scripts'/rel).read_text(encoding='utf-8');after=(W/'verify/scripts'/rel).read_text(encoding='utf-8');count=0
  for name in re.findall(r'      (?:override )?(?:public|private|protected) (?:static )?function (\w+)\(',before):
   if name not in allowed:assert c.m.extract(before,name)==c.m.extract(after,name),name;count+=1
  counts[rel.stem]=count
 (W/'result.json').write_text(json.dumps({'unchangedMethods':counts,'iconShift':-72,'portrait':'full-stage-width','sha256':hashlib.sha256(b).hexdigest()},indent=2)+'\n');print('PASS full-width portrait and icon spacing compiled',counts)
def publish():
 probe=B/'validation/native/result.json';result=json.loads(probe.read_text());assert result['completed'] and result['cases']==10 and not result['errors'] and result['remainingLayers']==0
 assert probe.stat().st_mtime>(W/'compiled.swf').stat().st_mtime,'Run final probe first'
 p=c.h.PUBLIC;current=json.loads((p/'client-release.json').read_text())['version'];active=p/current;old=(active/'TApplication.swf').read_bytes();assert old==(p/'2026090619/TApplication.swf').read_bytes();assert c.h.swap(old)==(W/'source.swf').read_bytes()
 backup=W/'backups';backup.mkdir()
 for path in [p/'2026090619/TApplication.swf',p/'2026090619/version.swf',p/'client-release.json']:shutil.copy2(path,backup/path.name)
 rows=r.rows((active/'version.swf').read_bytes())
 for row in rows:
  if row[0]==b'TApplication.swf':row[1]=VERSION.encode()
 dest=p/VERSION;dest.mkdir();raw=c.h.swap((W/'compiled.swf').read_bytes());manifest=r.encode(rows)
 for folder in [dest,p/'2026090619']:(folder/'TApplication.swf').write_bytes(raw);(folder/'version.swf').write_bytes(manifest)
 shutil.copy2(active/'index.swf',dest/'index.swf');(p/'client-release.json').write_text(json.dumps({'version':VERSION})+'\n');print('PASS publication',VERSION)
if __name__=='__main__':
 import sys
 if '--publish' in sys.argv:publish()
 else:compile_client()
