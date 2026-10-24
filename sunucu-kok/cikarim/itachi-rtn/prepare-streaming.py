"""Lossless Flash ARGB streams: replace PNG filtering at playback with zlib + setPixels."""
from pathlib import Path
from PIL import Image
import hashlib,json,struct,zlib
import numpy as np
BASE=Path(__file__).resolve().parent
PUBLIC=BASE.parents[1]/'kaynak/login.gogames.me'
def main():
 m=json.loads((BASE/'vfx.json').read_text());records={};total=0
 for name,meta in m['atlases'].items():
  png=PUBLIC/meta['url'].lstrip('/');out=png.with_suffix('.argb')
  with Image.open(png) as source:
   rgba=source.convert('RGBA');w,h=rgba.size
   pixels=np.array(rgba,dtype=np.uint16);alpha=pixels[:,:,3:4]
   # Flash 22's PNG decoder truncates premultiplication with /256 (opaque is
   # special-cased). setPixels rounds differently. Encode its exact inverse
   # so the resulting native BitmapData, including faint edges, is identical.
   premul=(pixels[:,:,:3]*alpha)//256
   adjusted=np.where(alpha==255,pixels[:,:,:3],(premul*255+alpha//2)//np.maximum(alpha,1))
   argb=np.concatenate((alpha,adjusted),axis=2).astype(np.uint8).tobytes()
  raw=struct.pack('>II',w,h)+argb;packed=zlib.compress(raw,9)
  assert zlib.decompress(packed)==raw
  if not out.exists() or out.read_bytes()!=packed:out.write_bytes(packed)
  records[name]={'width':w,'height':h,'sourcePngSha256':hashlib.sha256(png.read_bytes()).hexdigest(),'pixelSha256':hashlib.sha256(argb).hexdigest(),'fileSha256':hashlib.sha256(packed).hexdigest(),'bytes':len(packed)};total+=len(packed)
 (BASE/'streaming.json').write_text(json.dumps(records,indent=2)+'\n')
 print('PASS lossless ARGB round trip:',len(records),'atlases;',total,'compressed bytes')
if __name__=='__main__':main()
