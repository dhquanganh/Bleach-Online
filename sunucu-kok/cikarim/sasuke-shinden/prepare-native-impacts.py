"""Ship cleaned native Kirin impacts instead of large per-frame raster streams."""
from pathlib import Path
import json,hashlib,shutil,xml.etree.ElementTree as ET
BASE=Path(__file__).resolve().parent
PUBLIC=BASE.parents[1]/'kaynak/login.gogames.me/public'
dest=PUBLIC/'sasuke-vfx/cinematic-v1';dest.mkdir(parents=True,exist_ok=True)
manifest=json.loads((BASE/'cinematics.json').read_text())
for effect in ['ZuozhuZZZZ_qilin','ZuozhuZZZZ_qilin_yan']:
 source=BASE/'native-export'/(effect+'-clean-v6')
 root=ET.parse(source/'source.xml').getroot()
 symbol=next(t for t in root.find('tags') if t.get('type')=='SymbolClassTag')
 names=[e.text for e in symbol.find('names')]
 assert set(names)=={'shang','xia'}
 output=dest/(effect+'.swf');shutil.copy2(source/'clean.swf',output)
 manifest[effect]={'url':'/public/sasuke-vfx/cinematic-v1/'+output.name,
  'impact':True,'symbols':['xia','shang'],'frames':125,'frameRate':24,
  'sha256':hashlib.sha256(output.read_bytes()).hexdigest()}
(BASE/'cinematics.json').write_text(json.dumps(manifest,indent=2)+'\n')
print('PASS two cleaned native Kirin impact SWFs')
