"""Incremental full-width cut-in fix against the current active client."""
from pathlib import Path
import importlib.util,json,re,shutil
B=Path(__file__).resolve().parent;PARENT=B.parent
s=importlib.util.spec_from_file_location('build',PARENT/'build-client.py');m=importlib.util.module_from_spec(s);s.loader.exec_module(m);c=m.c

def main():
 active=json.loads((c.h.PUBLIC/'client-release.json').read_text())['version'];assert active=='2026102801'
 source=c.h.swap((c.h.PUBLIC/active/'TApplication.swf').read_bytes());(B/'source.swf').write_bytes(source)
 role=c.b.ROLE;cls=str(role.with_suffix('')).replace('\\','.').replace('/','.')
 c.ff('-selectclass',cls,'-export','script',B/'original',B/'source.swf')
 before=(B/'original/scripts'/role).read_text(encoding='utf-8')
 method=c.m.extract((PARENT/'native.as.txt').read_text(),'PlayMadaraNative')
 old=c.m.extract(before,'PlayMadaraNative');assert 'Math.min(host.stage.stageWidth / bounds.width' in old
 patched=before.replace(old,method,1);dest=B/'patched'/role;dest.parent.mkdir(parents=True,exist_ok=True);dest.write_text(patched,encoding='utf-8')
 c.ff('-onerror','abort','-importScript',B/'source.swf',B/'compiled.swf',B/'patched')
 c.ff('-selectclass',cls,'-export','script',B/'verify',B/'compiled.swf')
 after=(B/'verify/scripts'/role).read_text(encoding='utf-8');count=0
 for name in re.findall(r'      (?:override )?(?:public|private|protected) (?:static )?function (\w+)\(',before):
  if name!='PlayMadaraNative':assert c.m.extract(before,name)==c.m.extract(after,name),name;count+=1
 assert 'host.stage.stageWidth * 1.5 / bounds.width' in c.m.extract(after,'PlayMadaraNative')
 (B/'validation.json').write_text(json.dumps({'unchangedMethods':count,'changedMethod':'PlayMadaraNative'},indent=2)+'\n')
 # The existing component probe extracts the exact same runtime method.
 shutil.copy2(dest,PARENT/'patched'/role)
 print('PASS full-width Madara cut-in;',count,'other methods unchanged')
if __name__=='__main__':main()
