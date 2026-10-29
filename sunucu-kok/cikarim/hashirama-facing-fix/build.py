from pathlib import Path
import importlib.util,json,re
B=Path(__file__).resolve().parent
s=importlib.util.spec_from_file_location('shared',B.parent/'tsunade-asian/build-client.py');c=importlib.util.module_from_spec(s);s.loader.exec_module(c)
c.JAR=str(B.parents[2]/'tools/ffdec/ffdec.jar')
def main():
 active=json.loads((c.h.PUBLIC/'client-release.json').read_text())['version']
 (B/'source.swf').write_bytes(c.h.swap((c.h.PUBLIC/active/'TApplication.swf').read_bytes()))
 role=c.b.ROLE;cls=str(role.with_suffix('')).replace('\\','.').replace('/','.')
 c.ff('-selectclass',cls,'-export','script',B/'original',B/'source.swf')
 before=(B/'original/scripts'/role).read_text(encoding='utf-8')
 old=c.m.extract(before,'HashiramaNativeLayer');new=c.m.extract((B.parent/'hashirama-native-lite/native.as.txt').read_text(),'HashiramaNativeLayer')
 assert old!=new
 dest=B/'patched'/role;dest.parent.mkdir(parents=True,exist_ok=True);dest.write_text(before.replace(old,new,1),encoding='utf-8')
 c.ff('-onerror','abort','-importScript',B/'source.swf',B/'compiled.swf',B/'patched')
 c.ff('-selectclass',cls,'-export','script',B/'verify',B/'compiled.swf')
 after=(B/'verify/scripts'/role).read_text(encoding='utf-8');count=0
 for name in re.findall(r'      (?:override )?(?:public|private|protected) (?:static )?function (\w+)\(',before):
  if name!='HashiramaNativeLayer':assert c.m.extract(before,name)==c.m.extract(after,name),name;count+=1
 (B/'validation.json').write_text(json.dumps({'sourceVersion':active,'unchangedMethods':count},indent=2))
 print('PASS',count,'unrelated methods unchanged')
if __name__=='__main__':main()
