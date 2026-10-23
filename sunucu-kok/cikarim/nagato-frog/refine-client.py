"""Incrementally update only Nagato presentation on the current installed client."""
from pathlib import Path
import importlib.util,json,re,shutil,sys
from presentation import refine
B=Path(__file__).resolve().parent
s=importlib.util.spec_from_file_location('builder',B/'build-client.py');builder=importlib.util.module_from_spec(s);s.loader.exec_module(builder)
h=builder.h;m=builder.m;ROLE=builder.b.ROLE
def main():
 canonical=h.PUBLIC/'2026090619/TApplication.swf';old=canonical.read_bytes();raw=h.swap(old);work=B/'video-refinement';work.mkdir(exist_ok=True)
 source=work/'source.swf';source.write_bytes(raw);name=str(ROLE.with_suffix('')).replace('\\','.').replace('/','.')
 builder.ff('-selectclass',name,'-export','script',work/'original',source)
 before=(work/'original/scripts'/ROLE).read_text(encoding='utf8');assert 'function NagatoStrikeOffset(' not in before
 role=refine(before,m.extract)
 anim=json.loads((B/'animation.json').read_text());timings={ident:{'end':anim['clips'][clip]['returnFrame'],'distance':300 if int(ident)==13121401 else 240 if int(ident)==13121403 else 360} for ident,clip in anim['moves'].items()}
 fn=m.extract(role,'NagatoVfxManifest');marker='manifest.firstAtlases = {};';assert marker in fn
 replacement=fn.replace(marker,marker+'\n         manifest.poseTiming=JSON.parse('+json.dumps(json.dumps(timings,separators=(',',':')))+');',1);role=role.replace(fn,replacement)
 dest=work/'patched'/ROLE;dest.parent.mkdir(parents=True,exist_ok=True);dest.write_text(role,encoding='utf8')
 output=work/'compiled.swf';builder.ff('-onerror','abort','-importScript',source,output,work/'patched');rebuilt=output.read_bytes()
 assert [t for t in h.tags(raw) if t[0]!=82]==[t for t in h.tags(rebuilt) if t[0]!=82]
 builder.ff('-selectclass',name,'-export','script',work/'verify',output)
 finish()
def finish():
 canonical=h.PUBLIC/'2026090619/TApplication.swf';old=canonical.read_bytes();work=B/'video-refinement';raw=(work/'source.swf').read_bytes();rebuilt=(work/'compiled.swf').read_bytes()
 assert h.swap(old)==raw,'Current client changed during refinement'
 assert [t for t in h.tags(raw) if t[0]!=82]==[t for t in h.tags(rebuilt) if t[0]!=82]
 before=(work/'original/scripts'/ROLE).read_text(encoding='utf8')
 after=(work/'verify/scripts'/ROLE).read_text(encoding='utf8');changed={'ShowNagatoVfx','PlayNagatoEffect','PlayNagatoVfxAsset','NagatoVfxManifest','UpdateActive'}
 expected=m.extract(before,'UpdateActive').replace('            this.FitNagatoPose();','            this.NagatoStrikePose(_loc4_);\n            this.FitNagatoPose();',1)
 assert m.extract(after,'UpdateActive')==expected
 for method in re.findall(r'      (?:override )?(?:public|private|protected) (?:static )?function (\w+)\(',before):
  if method not in changed:assert m.extract(before,method)==m.extract(after,method),method
 assert canonical.read_bytes()==old
 backup=work/'before.swf';assert not backup.exists();backup.write_bytes(old);canonical.write_bytes(h.swap(rebuilt))
 # Keep standard verification tools pointed at the current actor implementation.
 shutil.copy2(work/'verify/scripts'/ROLE,B/'verify/scripts'/ROLE)
 print('PASS incremental Nagato source-distance motion and hand-anchored Gale Palm; unrelated methods unchanged')
if __name__=='__main__':finish() if '--finish' in sys.argv else main()
