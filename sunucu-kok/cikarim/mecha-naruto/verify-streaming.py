"""Check packaged pixels against source/stream hashes and native Flash evidence."""
from pathlib import Path
import hashlib,json,struct,zlib

B=Path(__file__).resolve().parent
m=json.loads((B/'vfx.json').read_text())
streams=json.loads((B/'streaming.json').read_text())
assert set(m['atlases'])==set(streams)
root=B.parents[1]/'kaynak/login.gogames.me'
for name,meta in m['atlases'].items():
    png=root/meta['url'].lstrip('/')
    record=streams[name]
    assert hashlib.sha256(png.read_bytes()).hexdigest()==record['sourcePngSha256'],name
    packed=png.with_suffix('.argb').read_bytes()
    assert hashlib.sha256(packed).hexdigest()==record['fileSha256'],name
    raw=zlib.decompress(packed)
    w,h=struct.unpack_from('>II',raw)
    assert (w,h)==(record['width'],record['height']) and len(raw)==8+w*h*4,name
    assert hashlib.sha256(raw[8:]).hexdigest()==record['pixelSha256'],name
pixel=json.loads((B/'validation/pixels/result.json').read_text())
assert pixel['completed'] and pixel['cases']==len(streams) and not pixel['errors'],pixel
print('PASS',len(streams),'source/ARGB checksums, headers and native Flash pixel-identical comparisons')
