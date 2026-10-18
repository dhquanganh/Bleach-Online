"""Remove retired recruitment/fragment offers from native client tables; keep replay assets."""
from pathlib import Path
import importlib.util,json,struct,sys,zlib,shutil
from datetime import datetime
ROOT=Path(__file__).resolve().parents[2]
sys.path.insert(0,str(ROOT/'sunucu-kok/cikarim/naruto-sage'))
spec=importlib.util.spec_from_file_location('fragments',ROOT/'sunucu-kok/cikarim/ninja-fragments/build.py')
helper=importlib.util.module_from_spec(spec);spec.loader.exec_module(helper)
PUBLIC=ROOT/'sunucu-kok/kaynak/login.gogames.me/public'
REMOVED={0xCC:{11120901,11120902,11120903,11120910,11120911,11120912,11120913,11120914},0xCB:{41120901,41120903,41120910}}
backup=ROOT/'.tools/retired-native'/datetime.now().strftime('%Y%m%d-%H%M%S')
def patch(raw):
    kind=struct.unpack_from('<I',raw)[0]-0x1000000
    if kind not in REMOVED:return raw
    rows=helper.records(raw,kind);kept=[(i,b) for i,b in rows if i not in REMOVED[kind]]
    if len(rows)==len(kept):return raw
    return raw[:4]+struct.pack('<I',len(kept))+b''.join(b for _,b in kept)
changed=0
for file in PUBLIC.glob('*/Resources/Bin/**/*'):
    if not file.is_file() or file.suffix not in ('.bin','.binPackage'):continue
    old=file.read_bytes()
    if file.suffix=='.bin':
        if file.stem.upper() not in ('010000CC','010000CB'):continue
        raw=zlib.decompress(old);newraw=patch(raw)
        if raw==newraw:continue
        new=zlib.compress(newraw)
    else:
        p=6;parts=[old[:6]];modified=False
        for _ in range(struct.unpack_from('<H',old,4)[0]):
            n=struct.unpack_from('<I',old,p)[0];p+=4;chunk=old[p:p+n];p+=n
            raw=zlib.decompress(chunk);updated=patch(raw)
            if updated!=raw:chunk=zlib.compress(updated);modified=True
            parts.extend([struct.pack('<I',len(chunk)),chunk])
        if not modified:continue
        new=b''.join(parts)+old[p:]
    saved=backup/file.relative_to(PUBLIC);saved.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(file,saved);file.write_bytes(new);changed+=1
print('Removed retired Modify Lab / Mystic Shop entries from native resource files:',changed)
