"""Audit flash separation, native art preservation and fire rendering resolution."""
from pathlib import Path
import json,zlib,xml.etree.ElementTree as ET

BASE=Path(__file__).resolve().parent
def main():
 manifest=json.loads((BASE/'vfx.json').read_text())
 for effect in ['ZuozhuZZZZ_qilin','ZuozhuZZZZ_qilin_yan']:
  folder=BASE/'native-export'/(effect+'-clean-v6')
  original=ET.parse(folder/'source.xml').getroot()
  cleaned=ET.parse(folder/'clean.xml').getroot()
  old=list(original.find('tags'));new=list(cleaned.find('tags'))
  assert len(old)==len(new);changed=[]
  for a,b in zip(old,new):
   if ET.tostring(a)==ET.tostring(b):continue
   assert a.get('type')=='DefineBitsLossless2Tag'
   assert {k:v for k,v in a.attrib.items() if k!='zlibBitmapData'}=={k:v for k,v in b.attrib.items() if k!='zlibBitmapData'}
   assert not any(zlib.decompress(bytes.fromhex(b.get('zlibBitmapData'))))
   changed.append(a.get('characterID'))
  assert len(changed)==1,changed
  flash=manifest['screenFlashes'][effect]
  assert len(flash)==131 and 0<max(flash)<=.12
  assert max(abs(a-b) for a,b in zip(flash,flash[1:]))<=.02401
  assert not any(flash[:60]),'flash must not cover the opening pose'
 profiles=json.loads((BASE/'presentation.json').read_text())
 for effect in ['ZuozhuZZZZ_haolonghuo','ZuozhuZZZZ_haolonghuoyan']:
  profile=profiles[effect];clip=manifest['clips'][effect+'-31']
  fit=min(profile['displayWidth']/profile['coreWidth'],profile['sharpScale']*1.4)
  displayed=profile['coreWidth']*fit
  assert displayed>=1250 and displayed/clip['width']<=1.4
  assert clip['width']>=1150
 print('PASS Kirin: only the native white flash bitmap changes; cue <=12%, smooth frame clock; both fire cores >=1250px with <=1.4x raster magnification')
if __name__=='__main__':main()
