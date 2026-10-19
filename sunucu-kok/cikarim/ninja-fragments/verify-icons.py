"""Validate native Article picture links, manual timing, exact portrait pixels and Flash decoding."""
from pathlib import Path
from PIL import Image,ImageOps
import json,struct,zlib
import build,verify
from importlib.util import spec_from_file_location,module_from_spec
BASE=Path(__file__).resolve().parent
spec=spec_from_file_location('repair',BASE/'repair-icons.py');repair=module_from_spec(spec);spec.loader.exec_module(repair)
targets={item for item,_,_ in repair.FEATURES}
rows={int(row['id'],16):row for row in json.loads((build.native.DATA/'Article.json').read_text(encoding='utf-8'))}
count=0
for path in build.native.PUBLIC.glob('*/Resources/Bin/**/*'):
 if not path.is_file():continue
 raw=path.read_bytes();blocks=[]
 if path.suffix=='.bin':blocks=[zlib.decompress(raw)]
 elif path.suffix=='.binPackage':
  pos=6
  for _ in range(struct.unpack_from('<H',raw,4)[0]):
   size=struct.unpack_from('<I',raw,pos)[0];pos+=4;blocks.append(zlib.decompress(raw[pos:pos+size]));pos+=size
 for block in blocks:
  if struct.unpack_from('<I',block)[0]!=0x1000002:continue
  records=dict(build.records(block,2))
  for item in targets:assert records[item]==build.serialize(2,rows[item]);count+=1
assert count>0
for item,name,source in repair.FEATURES:
 assert rows[item]['picture']==build.icon_id(item)
 original=ImageOps.fit(Image.open(build.ROOT.parent/'asset'/source).convert('RGBA'),(40,40),Image.Resampling.LANCZOS)
 for version in ['2017112917','2026090619']:
  for ident in [item,build.icon_id(item)]:
   path=build.native.PUBLIC/version/'Resources/Textures/Inventory'/f'{ident:08X}.TexClient'
   data=path.read_bytes();assert struct.unpack_from('<I',data)[0]==ident
   assert data[12]==0,'Static icons cannot expire after 70ms'
   image=verify.decode(path);assert image.size==(40,40) and image.tobytes()==original.tobytes(),(name,version)
result=json.loads((BASE/'icon-validation/result.json').read_text())
assert result['completed'] and result['checks']==12 and result['nativeSampleTicks']==60 and not result['errors'],result
print('PASS',count,'native Article links; twelve exact RGBA portrait textures; static timing and sixty native Flash frame samples; no decoder errors')
