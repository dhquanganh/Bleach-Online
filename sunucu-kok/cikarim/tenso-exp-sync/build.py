from pathlib import Path
import importlib.util,re,json,hashlib
B=Path(__file__).resolve().parent;s=importlib.util.spec_from_file_location('shared',B.parent/'tsunade-asian/build-client.py');c=importlib.util.module_from_spec(s);s.loader.exec_module(c);c.JAR=str(B.parents[2]/'tools/ffdec/ffdec.jar')
rel=Path('Logics/Streamization/ExpDuplicate/TUnstreamizerExpDuplicate.as')
def main():
 active=json.loads((c.h.PUBLIC/'client-release.json').read_text())['version'];assert active=='2026102906';(B/'source.swf').write_bytes(c.h.swap((c.h.PUBLIC/active/'TApplication.swf').read_bytes()))
 cls=str(rel.with_suffix('')).replace('\\','.').replace('/','.');c.ff('-selectclass',cls,'-export','script',B/'original',B/'source.swf')
 before=(B/'original/scripts'/rel).read_text(encoding='utf-8');old=c.m.extract(before,'GetExp');assert 'return Math.floor(_loc6_);' in old;new=old.replace('return Math.floor(_loc6_);','return Math.floor(_loc6_) * 3;')
 target=B/'patched'/rel;target.parent.mkdir(parents=True,exist_ok=True);target.write_text(before.replace(old,new,1),encoding='utf-8')
 c.ff('-onerror','abort','-importScript',B/'source.swf',B/'compiled.swf',B/'patched');c.ff('-selectclass',cls,'-export','script',B/'verify',B/'compiled.swf')
 after=(B/'verify/scripts'/rel).read_text(encoding='utf-8');count=0
 for name in re.findall(r'      (?:override )?(?:public|private|protected) (?:static )?function (\w+)\(',before):
  if name!='GetExp':assert c.m.extract(before,name)==c.m.extract(after,name),name;count+=1
 assert '* 3' in c.m.extract(after,'GetExp');assert [t for t in c.h.tags((B/'source.swf').read_bytes()) if t[0]!=82]==[t for t in c.h.tags((B/'compiled.swf').read_bytes()) if t[0]!=82]
 (B/'client-validation.json').write_text(json.dumps({'unchangedMethods':count,'onlyChangedMethod':'GetExp','unchangedAssets':True},indent=2));print('PASS Tens? preview EXP x3; other methods unchanged')
if __name__=='__main__':main()
