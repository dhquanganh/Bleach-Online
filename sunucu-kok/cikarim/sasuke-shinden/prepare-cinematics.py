"""Keep the native cinematic artwork; name its authored camera plane for fitting."""
from pathlib import Path
import argparse,hashlib,json,subprocess,xml.etree.ElementTree as ET

BASE=Path(__file__).resolve().parent
PUBLIC=BASE.parents[1]/'kaynak/login.gogames.me/public'
def main():
 parser=argparse.ArgumentParser();parser.add_argument('--ffdec',required=True);args=parser.parse_args()
 dest=PUBLIC/'sasuke-vfx/cinematic-v1';dest.mkdir(parents=True,exist_ok=True)
 manifest={}
 for effect in ['ZuozhuZZZZ_qilin_texie','ZuozhuZZZZ_qilin_yantexie']:
  source=BASE/'native-export'/effect/'source.xml';tree=ET.parse(source);tags=list(tree.getroot().find('tags'))
  symbol=next(t for t in tags if t.get('type')=='SymbolClassTag')
  rootid=symbol.find('tags')[0].text;classname=symbol.find('names')[0].text
  bitmaps=[t for t in tags if t.get('type')=='DefineBitsLossless2Tag']
  plate=max(bitmaps,key=lambda t:int(t.get('bitmapWidth'))*int(t.get('bitmapHeight')))
  # The largest bitmap is the moving dragon head, not the camera plane.
  # Use the authored static black backdrop so its animation cannot move the camera.
  background=next(t for t in tags if t.get('shapeId')=='1')
  assert all(c.get('red')=='0' and c.get('green')=='0' and c.get('blue')=='0' for c in background.iter('color'))
  ancestry={background.get('shapeId')}
  for _ in range(6):
   previous=len(ancestry)
   for tag in tags:
    ident=tag.get('shapeId') or tag.get('spriteId')
    if not ident or ident==rootid or ident in ancestry:continue
    if any(c.get('characterId') in ancestry or c.get('bitmapId') in ancestry for c in tag.iter()):ancestry.add(ident)
   if len(ancestry)==previous:break
  movie=next(t for t in tags if t.get('spriteId')==rootid);frame=1;first=None;named=0
  for tag in movie.find('subTags'):
   if tag.get('type')=='ShowFrameTag':frame+=1
   if tag.get('characterId') in ancestry:
    tag.set('placeFlagHasName','true');tag.set('name','sasukeCinematicPlate');named+=1
    if first is None:first=frame
  assert named==1 and first is not None
  path=BASE/'cinematic-native'/effect;path.mkdir(parents=True,exist_ok=True)
  xml=path/'camera.xml';tree.write(xml,encoding='utf-8',xml_declaration=True)
  output=dest/(effect+'.swf')
  subprocess.run(['java','-Xmx1g','-jar',args.ffdec,'-xml2swf',str(xml),str(output)],check=True,stdout=subprocess.DEVNULL)
  manifest[effect]={'url':'/public/sasuke-vfx/cinematic-v1/'+output.name,'symbol':classname,
   'plateName':'sasukeCinematicPlate','referenceFrame':first,'frames':int(movie.get('frameCount')),
   'frameRate':24,'bitmapWidth':int(plate.get('bitmapWidth')),'bitmapHeight':int(plate.get('bitmapHeight')),
   'sha256':hashlib.sha256(output.read_bytes()).hexdigest()}
 (BASE/'cinematics.json').write_text(json.dumps(manifest,indent=2)+'\n')
 print('PASS native full-resolution cinematics:',json.dumps(manifest))
if __name__=='__main__':main()
