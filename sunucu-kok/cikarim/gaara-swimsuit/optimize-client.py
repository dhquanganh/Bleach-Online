from pathlib import Path
import importlib.util,json,re,shutil
B=Path(__file__).resolve().parent
s=importlib.util.spec_from_file_location("builder",B/"build-client.py");builder=importlib.util.module_from_spec(s);s.loader.exec_module(builder)
h=builder.h;m=builder.m;ROLE=builder.b.ROLE
def client():
 from playback import optimize
 canonical=h.PUBLIC/'2026090619/TApplication.swf';old=canonical.read_bytes();raw=h.swap(old);work=B/'optimized-client';work.mkdir(parents=True,exist_ok=True);source=work/'source.swf';source.write_bytes(raw)
 name=str(ROLE.with_suffix('')).replace('\\','.').replace('/','.')
 builder.ff('-selectclass',name,'-export','script',work/'original',source);before=(work/'original/scripts'/ROLE).read_text(encoding='utf8');role=before
 fn=m.extract(role,'GaaraVfxManifest');pattern=r'JSON.parse\(("(?:\\.|[^"\\])*")\)';match=re.search(pattern,fn);assert match
 olddata=json.loads(json.loads(match[1]));data=json.loads((B/'vfx.json').read_text());data.update({k:v for k,v in olddata.items() if k not in data})
 replacement=fn[:match.start()]+ 'JSON.parse('+json.dumps(json.dumps(data,separators=(',',':')))+')'+fn[match.end():];role=role.replace(fn,replacement)
 role=optimize(role)
 dest=work/'patched'/ROLE;dest.parent.mkdir(parents=True,exist_ok=True);dest.write_text(role,encoding='utf8');output=work/'compiled.swf'
 builder.ff('-onerror','abort','-importScript',source,output,work/'patched');rebuilt=output.read_bytes();assert [t for t in h.tags(raw) if t[0]!=82]==[t for t in h.tags(rebuilt) if t[0]!=82]
 builder.ff('-selectclass',name,'-export','script',work/'verify',output);after=(work/'verify/scripts'/ROLE).read_text(encoding='utf8')
 for method in re.findall(r'      (?:override )?(?:public|private|protected) (?:static )?function (\w+)\(',before):
  if method not in {'GaaraVfxManifest','PlayGaaraVfxAsset','PumpGaaraVfxQueue'}:assert m.extract(before,method)==m.extract(after,method),method
 assert canonical.read_bytes()==old;(work/'before.swf').write_bytes(old);canonical.write_bytes(h.swap(rebuilt));shutil.copy2(work/'verify/scripts'/ROLE,B/'verify/scripts'/ROLE)
 print('PASS Gaara zero-copy playback; only 3 Gaara methods updated')
if __name__=='__main__':client()
