"""Restore Naruto final cinematic colors and cover the battle viewport."""
from pathlib import Path
import importlib.util,json,re,shutil
B=Path(__file__).resolve().parent;PARENT=B.parent
s=importlib.util.spec_from_file_location('build',PARENT/'build-client.py');m=importlib.util.module_from_spec(s);s.loader.exec_module(m);c=m.c
def main():
 active=json.loads((c.h.PUBLIC/'client-release.json').read_text())['version'];assert active=='2026102809'
 (B/'source.swf').write_bytes(c.h.swap((c.h.PUBLIC/active/'TApplication.swf').read_bytes()))
 role=c.b.ROLE;cls=str(role.with_suffix('')).replace('\\','.').replace('/','.')
 c.ff('-selectclass',cls,'-export','script',B/'original',B/'source.swf')
 before=(B/'original/scripts'/role).read_text(encoding='utf-8');old=c.m.extract(before,'PlayNarutoFinalNative')
 method=c.m.extract((PARENT/'native.as.txt').read_text(),'PlayNarutoFinalNative');assert 'skill == 13122313' not in old
 dest=B/'patched'/role;dest.parent.mkdir(parents=True,exist_ok=True);dest.write_text(before.replace(old,method,1),encoding='utf-8')
 c.ff('-onerror','abort','-importScript',B/'source.swf',B/'compiled.swf',B/'patched')
 c.ff('-selectclass',cls,'-export','script',B/'verify',B/'compiled.swf')
 after=(B/'verify/scripts'/role).read_text(encoding='utf-8');count=0
 for name in re.findall(r'      (?:override )?(?:public|private|protected) (?:static )?function (\w+)\(',before):
  if name!='PlayNarutoFinalNative':assert c.m.extract(before,name)==c.m.extract(after,name),name;count+=1
 assert '13122313' in c.m.extract(after,'PlayNarutoFinalNative')
 (B/'validation.json').write_text(json.dumps({'unchangedMethods':count,'changedMethod':'PlayNarutoFinalNative'},indent=2)+'\n')
 shutil.copy2(dest,PARENT/'patched'/role)
 print('PASS Naruto final fullscreen compositor;',count,'unrelated methods unchanged')
if __name__=='__main__':main()
