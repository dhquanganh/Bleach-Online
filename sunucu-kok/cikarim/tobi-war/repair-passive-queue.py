"""Fix the reproduced floor-68 null target vector at Tobi's pre-Mystery dispel."""
from pathlib import Path
import importlib.util,json,re,hashlib,shutil
B=Path(__file__).resolve().parent;W=B/'repair-passive-queue';VERSION='2026102609'
s=importlib.util.spec_from_file_location('client',B/'build-client.py');m=importlib.util.module_from_spec(s);s.loader.exec_module(m);c=m.c
s=importlib.util.spec_from_file_location('release',B/'release.py');r=importlib.util.module_from_spec(s);s.loader.exec_module(r)
def compile_client():
 pub=c.h.PUBLIC;active=json.loads((pub/'client-release.json').read_text())['version'];assert active=='2026102608'
 old=(pub/active/'TApplication.swf').read_bytes();assert old==(pub/'2026090619/TApplication.swf').read_bytes()
 W.mkdir(exist_ok=True);source=W/'source.swf';source.write_bytes(c.h.swap(old));rel=c.b.ROLE
 cls=str(rel.with_suffix('')).replace('\\','.').replace('/','.')
 c.ff('-selectclass',cls,'-export','script',W/'original',source)
 before=(W/'original/scripts'/rel).read_text(encoding='utf-8')
 method=c.m.extract(before,'CommandPlay');needle='            _loc6_ = param3.length;';assert needle in method
 fixed=method.replace(needle,'''            // Buff-only events have no CMD_ATTACK group in TBattleStage.
            // Complete their visual no-op; the queued buff commands still run.
            if(param3 == null)
            {
               this.OnNextCommand(param4);
               return;
            }
'''+needle,1)
 dest=W/'patched'/rel;dest.parent.mkdir(parents=True,exist_ok=True);dest.write_text(before.replace(method,fixed,1),encoding='utf-8')
 c.ff('-onerror','abort','-importScript',source,W/'compiled.swf',W/'patched')
 raw=(W/'compiled.swf').read_bytes();assert [t for t in c.h.tags(source.read_bytes()) if t[0]!=82]==[t for t in c.h.tags(raw) if t[0]!=82]
 c.ff('-selectclass',cls,'-export','script',W/'verify',W/'compiled.swf')
 after=(W/'verify/scripts'/rel).read_text(encoding='utf-8');count=0
 for name in re.findall(r'      (?:override )?(?:public|private|protected) (?:static )?function (\w+)\(',before):
  if name!='CommandPlay':assert c.m.extract(before,name)==c.m.extract(after,name),name;count+=1
 assert 'if(param3 == null)' in c.m.extract(after,'CommandPlay')
 (W/'validation.json').write_text(json.dumps({'sourceVersion':active,'unchangedMethods':count,'changedMethod':'TRole.CommandPlay','sha256':hashlib.sha256(raw).hexdigest()},indent=2)+'\n')
 print('PASS zero-skill buff-only queue guard;',count,'other methods unchanged')
def publish():
 evidence=json.loads((W/'replay-validation.json').read_text());assert evidence['baselineNullError'] and evidence['fixedCompleted'] and not evidence['fixedNullErrors']
 pub=c.h.PUBLIC;active=json.loads((pub/'client-release.json').read_text())['version'];assert active=='2026102608'
 canonical=pub/'2026090619';old=(pub/active/'TApplication.swf').read_bytes();assert old==(canonical/'TApplication.swf').read_bytes() and c.h.swap(old)==(W/'source.swf').read_bytes()
 manifest=(pub/active/'version.swf').read_bytes();assert manifest==(canonical/'version.swf').read_bytes()
 dest=pub/VERSION;assert not dest.exists();backup=W/'backup';backup.mkdir(exist_ok=True)
 for path in [canonical/'TApplication.swf',canonical/'version.swf',pub/'client-release.json']:shutil.copy2(path,backup/path.name)
 rows=r.rows(manifest)
 for row in rows:
  if row[0]==b'TApplication.swf':row[1]=VERSION.encode()
 binary=c.h.swap((W/'compiled.swf').read_bytes());newmanifest=r.encode(rows);dest.mkdir()
 for target in [dest,canonical]:(target/'TApplication.swf').write_bytes(binary);(target/'version.swf').write_bytes(newmanifest)
 shutil.copy2(pub/active/'index.swf',dest/'index.swf');(pub/'client-release.json').write_text(json.dumps({'version':VERSION})+'\n')
 assert (canonical/'TApplication.swf').read_bytes()==(dest/'TApplication.swf').read_bytes()
 (W/'result.json').write_text(json.dumps({'version':VERSION,'fix':'Buff-only skill ID 0 with null attack-target vector completes before queued dispels','clientSha256':hashlib.sha256(binary).hexdigest()},indent=2)+'\n')
 print('PASS published',VERSION)
if __name__=='__main__':
 import sys
 publish() if '--publish' in sys.argv else compile_client()
