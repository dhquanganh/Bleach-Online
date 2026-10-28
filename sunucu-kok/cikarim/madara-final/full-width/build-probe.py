from pathlib import Path
import importlib.util,re
B=Path(__file__).resolve().parent
s=importlib.util.spec_from_file_location('m',B/'build.py');m=importlib.util.module_from_spec(s);s.loader.exec_module(m);c=m.c
source=(B.parent/'probe-source/TApplication.as').read_text()
old=c.m.extract(source,'PlayMadaraNative')
method=c.m.extract((B/'patched'/c.b.ROLE).read_text(encoding='utf-8'),'PlayMadaraNative').replace(':TRole',':ProbeRole').replace('private function','public function')
source=source.replace(old,method,1)
source=re.sub(r'var bounds:Array=\[[^\]]+\]', 'var bounds:Array=[0,8000,16000]',source,count=1)
source=source.replace('slot<28','slot<2').replace('slot>=28','slot>=2').replace('var side:int=slot<14?0:1;var index:int=slot%14;','var side:int=slot;var index:int=0;')
dest=B/'probe-source/TApplication.as';dest.parent.mkdir(exist_ok=True);dest.write_text(source)
c.ff('-onerror','abort','-importScript',B/'source.swf',B/'raster-probe.swf',dest.parent)
raw=bytearray((B/'raster-probe.swf').read_bytes());raw[3]=21;(B/'raster-probe.swf').write_bytes(raw)
js=(B.parent/'runtime-raster.js').read_text().replace("path.resolve(base,'../../..')","path.resolve(base,'../../../..')").replace('7500','7504').replace('7501','7505').replace('420000','90000')
(B/'runtime-raster.js').write_text(js);(B/'validation/native').mkdir(parents=True,exist_ok=True)
print('PASS focused cut-in probe compiled')
