from pathlib import Path
import importlib.util
B=Path(__file__).resolve().parent;s=importlib.util.spec_from_file_location('b',B/'build-client.py');m=importlib.util.module_from_spec(s);s.loader.exec_module(m);c=m.c
c.ff('-onerror','abort','-importScript',B/'compiled.swf',B/'raster-probe.swf',B/'probe-source');raw=bytearray((B/'raster-probe.swf').read_bytes());raw[3]=21;(B/'raster-probe.swf').write_bytes(raw)
