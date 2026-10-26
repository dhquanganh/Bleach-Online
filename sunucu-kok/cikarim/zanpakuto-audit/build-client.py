"""Repair Zanpakuto controls in the current native client."""
from pathlib import Path
import importlib.util,subprocess,json,hashlib,shutil
B=Path(__file__).resolve().parent
def module(name,file):
 s=importlib.util.spec_from_file_location(name,file);m=importlib.util.module_from_spec(s);s.loader.exec_module(m);return m
h=module('h',B.parent/'naruto-sage/verify-client.py');r=module('r',B.parent/'tsunade-asian/release.py')
jar='C:/Users/quang/.copilot/session-state/b6dea4ff-70b7-44ac-b9f5-1136aca3d0d5/files/ffdec/app/ffdec.jar'
def ff(*args):subprocess.run(['java','-Xmx2g','-jar',jar,*map(str,args)],check=True,stdout=subprocess.DEVNULL)
work=B/'build';work.mkdir(exist_ok=True);canonical=h.PUBLIC/'2026090619'
old=(canonical/'TApplication.swf').read_bytes()
source=(B/'source.swf').read_bytes();assert h.swap(old)==source,'Current client changed'
(work/'source.swf').write_bytes(source)
rels=[Path(x) for x in ['Processors\\Game\\Lobby\\KnifeOfKillSoul\\TProcessorKnifeOfKillSoul.as', 'Processors\\Game\\Lobby\\KnifeOfKillSoul\\TProcessorKnifeStrengthenBox.as', 'Processors\\Game\\Lobby\\KnifeOfKillSoul\\TProcessorWindowTrain.as']]
ff('-onerror','abort','-importScript',work/'source.swf',work/'compiled.swf',B/'patched/scripts')
raw=(work/'compiled.swf').read_bytes();assert [x for x in h.tags(source) if x[0]!=82]==[x for x in h.tags(raw) if x[0]!=82]
ff('-selectclass',','.join(str(rel.with_suffix('')).replace('\\','.').replace('/','.') for rel in rels),'-export','script',B/'verify',work/'compiled.swf')
for rel in rels:assert (B/'verify/scripts'/rel).exists()
verified=(B/'verify/scripts'/rels[0]).read_text(encoding='utf-8')
assert 'if(this.FUpdateHeroPower != null)' in verified
assert (canonical/'TApplication.swf').read_bytes()==old,'Client changed while compiling'
version='2026102605';out=h.PUBLIC/version;out.mkdir(exist_ok=True);protected=h.swap(raw)
manifest=r.rows((canonical/'version.swf').read_bytes());assert sum(row[0]==b'TApplication.swf' for row in manifest)==1
for row in manifest:
 if row[0]==b'TApplication.swf':row[1]=version.encode()
data=r.encode(manifest)
for directory in [canonical,out]:
 (directory/'TApplication.swf').write_bytes(protected);(directory/'version.swf').write_bytes(data)
shutil.copy2(canonical/'index.swf',out/'index.swf')
(h.PUBLIC/'client-release.json').write_text(json.dumps({'version':version})+'\n')
(B/'release.json').write_text(json.dumps({'version':version,'sha256':hashlib.sha256(protected).hexdigest(),'classes':[str(rel) for rel in rels]},indent=2))
print('PASS native Zanpakuto UI',version)
