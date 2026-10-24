"""Patch only Tsunade's Acid Shot portrait on the current shared client."""
from pathlib import Path
import importlib.util,json,re,shutil,hashlib
B=Path(__file__).resolve().parent
def module(name,path):
 s=importlib.util.spec_from_file_location(name,path);m=importlib.util.module_from_spec(s);s.loader.exec_module(m);return m
c=module('client',B/'build-client.py');release=module('release',B/'release.py')
VERSION='2026102420'
def patch(before):
 method=c.m.extract(before,'PlayTsunadeEffect')
 assert 'ShowTsunadeCutscene' not in before,'Fullscreen cutscene already installed'
 i=method.index('{')+1
 after=before.replace(method,method[:i]+'\n         if(effect=="gangshou_aoyi1_niansuantexie"){ShowTsunadeCutscene(effect,host,delay);return;}'+method[i:],1)
 return after.replace('      private function PlayTsunadeEffect(', (B/'fullscreen.as.txt').read_text()+'\n      private function PlayTsunadeEffect(',1)
def main(work_name='fullscreen',update=False):
 W=B/work_name;W.mkdir(parents=True,exist_ok=True)
 canonical=c.h.PUBLIC/'2026090619/TApplication.swf';old=canonical.read_bytes();decoded=c.h.swap(old)
 (W/'source.swf').write_bytes(decoded)
 rel=c.b.ROLE;cls=str(rel.with_suffix('')).replace('\\','.').replace('/','.')
 c.ff('-selectclass',cls,'-export','script',W/'original',W/'source.swf')
 before=(W/'original/scripts'/rel).read_text(encoding='utf-8')
 after=before.replace(c.m.extract(before,'ShowTsunadeCutscene'),(B/'fullscreen.as.txt').read_text().rstrip(),1) if update else patch(before)
 target=W/'patched'/rel;target.parent.mkdir(parents=True,exist_ok=True);target.write_text(after,encoding='utf-8')
 c.ff('-onerror','abort','-importScript',W/'source.swf',W/'compiled.swf',W/'patched')
 rebuilt=(W/'compiled.swf').read_bytes()
 assert [t for t in c.h.tags(decoded) if t[0]!=82]==[t for t in c.h.tags(rebuilt) if t[0]!=82]
 c.ff('-selectclass',cls,'-export','script',W/'verify',W/'compiled.swf')
 verified=(W/'verify/scripts'/rel).read_text(encoding='utf-8');checked=0
 for name in re.findall(r'      (?:override )?(?:public|private|protected) (?:static )?function (\w+)\(',before):
  if name!=('ShowTsunadeCutscene' if update else 'PlayTsunadeEffect'):assert c.m.extract(before,name)==c.m.extract(verified,name),name;checked+=1
 assert canonical.read_bytes()==old
 backup=W/'backups';backup.mkdir(exist_ok=True)
 manifest=canonical.parent/'version.swf';pointer=c.h.PUBLIC/'client-release.json'
 for src in [canonical,manifest,pointer]:
  assert not (backup/src.name).exists(),'Existing backup; inspect before rebuilding'
  shutil.copy2(src,backup/src.name)
 rows=release.rows(manifest.read_bytes())
 for row in rows:
  if row[0]==b'TApplication.swf':row[1]=VERSION.encode()
 data=release.encode(rows);protected=c.h.swap(rebuilt);dest=c.h.PUBLIC/VERSION;dest.mkdir(exist_ok=True)
 canonical.write_bytes(protected);manifest.write_bytes(data)
 for name in ['TApplication.swf','version.swf','index.swf']:shutil.copy2(canonical.parent/name,dest/name)
 pointer.write_text(json.dumps({'version':VERSION})+'\n')
 (W/'result.json').write_text(json.dumps({'version':VERSION,'unchangedMethods':checked,'sha256':hashlib.sha256(protected).hexdigest(),'fullscreenEffect':'gangshou_aoyi1_niansuantexie','uniformScale':True,'combatChanged':False},indent=2)+'\n')
 print('PASS Acid Shot fullscreen;',checked,'other methods unchanged; release',VERSION)
if __name__=='__main__':main()
