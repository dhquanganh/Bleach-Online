"""Native camera annotation must preserve every bitmap and drawing command."""
from pathlib import Path
import hashlib,json,xml.etree.ElementTree as ET
BASE=Path(__file__).resolve().parent
PUBLIC=BASE.parents[1]/'kaynak/login.gogames.me'
def main():
 manifest=json.loads((BASE/'cinematics.json').read_text())
 for effect,meta in manifest.items():
  old=ET.parse(BASE/'native-export'/effect/'source.xml').getroot()
  new=ET.parse(BASE/'cinematic-native'/effect/'camera.xml').getroot()
  pairs=list(zip(old.iter(),new.iter()));assert sum(1 for _ in old.iter())==sum(1 for _ in new.iter())
  changed=0
  for a,b in pairs:
   assert a.tag==b.tag and a.text==b.text
   if a.attrib==b.attrib:continue
   assert a.get('type') in ['PlaceObject2Tag','PlaceObject3Tag']
   assert b.get('placeFlagHasName')=='true' and b.get('name')==meta['plateName']
   assert {k:v for k,v in a.attrib.items() if k not in ['name','placeFlagHasName']}=={k:v for k,v in b.attrib.items() if k not in ['name','placeFlagHasName']}
   changed+=1
  assert changed==1 and meta['bitmapWidth']>=1572 and meta['bitmapHeight']>=846
  assert meta['frames']==79 and meta['frameRate']==24
  assert hashlib.sha256((PUBLIC/meta['url'].lstrip('/')).read_bytes()).hexdigest()==meta['sha256']
 print('PASS two native cinematics: unchanged full-resolution art/timeline; only one camera instance name added per SWF')
if __name__=='__main__':main()
