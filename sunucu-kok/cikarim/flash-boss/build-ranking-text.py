"""Update the native leaderboard label without recompiling game logic."""
from pathlib import Path
import importlib.util,subprocess,struct,zlib
BASE=Path(__file__).resolve().parent
spec=importlib.util.spec_from_file_location('b',BASE.parent/'hashirama-final/build-client.py');b=importlib.util.module_from_spec(spec);spec.loader.exec_module(b)
h=b.h
work=BASE/'real-ranking';work.mkdir(exist_ok=True)
canonical=h.PUBLIC/'2026090619/TApplication.swf';original=canonical.read_bytes();source=h.swap(original)
(work/'source.swf').write_bytes(source)
jar='E:/Vua Hai Tac Vibe/tools/ffdec/ffdec.jar'
subprocess.run(['C:/Program Files/Java/jdk-23/bin/javac.exe','-encoding','UTF-8','-cp',jar,'-d',str(work),str(BASE/'PatchRankingText.java')],check=True)
subprocess.run(['java','-Xmx2g','-cp',str(work)+';'+jar,'PatchRankingText',str(work/'source.swf'),str(work/'compiled.swf')],check=True)
rebuilt=(work/'compiled.swf').read_bytes()
assert [t for t in h.tags(source)if t[0]!=82]==[t for t in h.tags(rebuilt)if t[0]!=82]
version=canonical.parent/'version.swf';oldmap=version.read_bytes();raw=zlib.decompress(oldmap);pos=2;parts=[raw[:2]];found=0
for _ in range(struct.unpack_from('<H',raw)[0]):
 n=struct.unpack_from('<H',raw,pos)[0];pos+=2;k=raw[pos:pos+n];pos+=n;n=struct.unpack_from('<H',raw,pos)[0];pos+=2;v=raw[pos:pos+n];pos+=n
 if k==b'TApplication.swf':v=b'2026101976';found+=1
 parts.extend([struct.pack('<H',len(k)),k,struct.pack('<H',len(v)),v])
assert found==1 and pos==len(raw) and canonical.read_bytes()==original
(work/'original-protected.swf').write_bytes(original);(work/'original-version.swf').write_bytes(oldmap)
protected=h.swap(rebuilt);dest=h.PUBLIC/'2026101976/TApplication.swf';dest.parent.mkdir(exist_ok=True)
dest.write_bytes(protected);canonical.write_bytes(protected);version.write_bytes(zlib.compress(b''.join(parts)))
print('PASS native client 2026101976; unrelated UI assets unchanged')
