from pathlib import Path
import importlib.util
B=Path(__file__).resolve().parent
s=importlib.util.spec_from_file_location('client',B/'build-client.py');b=importlib.util.module_from_spec(s);s.loader.exec_module(b)
b.ff('-onerror','abort','-importScript',B/'source.swf',B/'raster-probe.swf',B/'probe-source')
raw=bytearray((B/'raster-probe.swf').read_bytes());raw[3]=21;(B/'raster-probe.swf').write_bytes(raw)
print('PASS native Tsunade VFX and resurrection probe compiled')
