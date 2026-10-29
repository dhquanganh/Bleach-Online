from pathlib import Path
import importlib.util,json,re,hashlib
B=Path(__file__).resolve().parent;s=importlib.util.spec_from_file_location('capture',B/'capture.py');m=importlib.util.module_from_spec(s);s.loader.exec_module(m);c=m.c
c.ff('-onerror','abort','-importScript',B/'source.swf',B/'compiled.swf',B/'patched')
allowed=json.loads((B/'changed-methods.json').read_text());classes=','.join(str(Path(p).with_suffix('')).replace('\\','.').replace('/','.') for p in allowed);c.ff('-selectclass',classes,'-export','script',B/'verify',B/'compiled.swf')
counts={}
for rel,names in allowed.items():
 before=(B/'original/scripts'/rel).read_text(encoding='utf-8');after=(B/'verify/scripts'/rel).read_text(encoding='utf-8');count=0
 for name in re.findall(r'      (?:override )?(?:public|private|protected) (?:static )?function (\w+)\(',before):
  if name not in names:assert c.m.extract(before,name)==c.m.extract(after,name),rel+':'+name;count+=1
 counts[rel]=count
assert [t for t in c.h.tags((B/'source.swf').read_bytes()) if t[0]!=82]==[t for t in c.h.tags((B/'compiled.swf').read_bytes()) if t[0]!=82]
(B/'client-validation.json').write_text(json.dumps({'unchangedMethods':counts,'unchangedAssets':True,'sha256':hashlib.sha256((B/'compiled.swf').read_bytes()).hexdigest()},indent=2))
print('PASS tournament client compiled;',sum(counts.values()),'other methods unchanged')
