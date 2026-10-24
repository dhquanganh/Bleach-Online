"""Add Gaara movement without restoring an earlier client or altering other heroes."""
from pathlib import Path
import importlib.util,re,shutil
from presentation import refine
B=Path(__file__).resolve().parent
s=importlib.util.spec_from_file_location('builder',B/'build-client.py');builder=importlib.util.module_from_spec(s);s.loader.exec_module(builder)
h=builder.h;m=builder.m;ROLE=builder.b.ROLE
def main():
 canonical=h.PUBLIC/'2026090619/TApplication.swf';old=canonical.read_bytes();raw=h.swap(old);work=B/'movement';work.mkdir(exist_ok=True);source=work/'source.swf';source.write_bytes(raw)
 name=str(ROLE.with_suffix('')).replace('\\','.').replace('/','.')
 builder.ff('-selectclass',name,'-export','script',work/'original',source)
 before=(work/'original/scripts'/ROLE).read_text(encoding='utf8');assert 'function GaaraStrikeOffset(' not in before
 role=refine(before,m.extract);dest=work/'patched'/ROLE;dest.parent.mkdir(parents=True,exist_ok=True);dest.write_text(role,encoding='utf8');output=work/'compiled.swf'
 builder.ff('-onerror','abort','-importScript',source,output,work/'patched');rebuilt=output.read_bytes();assert [t for t in h.tags(raw) if t[0]!=82]==[t for t in h.tags(rebuilt) if t[0]!=82]
 builder.ff('-selectclass',name,'-export','script',work/'verify',output)
 after=(work/'verify/scripts'/ROLE).read_text(encoding='utf8');changed={'ShowGaaraVfx','PlayGaaraEffect','PlayGaaraVfxAsset','UpdateActive'}
 expected=m.extract(before,'UpdateActive').replace('            this.FitGaaraPose();','            this.GaaraStrikePose(_loc4_);\n            this.FitGaaraPose();',1);assert m.extract(after,'UpdateActive')==expected
 for method in re.findall(r'      (?:override )?(?:public|private|protected) (?:static )?function (\w+)\(',before):
  if method not in changed:assert m.extract(before,method)==m.extract(after,method),method
 assert canonical.read_bytes()==old;(work/'before.swf').write_bytes(old);canonical.write_bytes(h.swap(rebuilt));shutil.copy2(work/'verify/scripts'/ROLE,B/'verify/scripts'/ROLE)
 print('PASS isolated Gaara sand surfing motion and attached effects; unrelated methods and SWF tags unchanged')
if __name__=='__main__':main()
