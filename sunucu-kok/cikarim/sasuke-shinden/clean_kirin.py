"""Separate native white screen flashes from world-space Kirin artwork."""
import math, zlib, xml.etree.ElementTree as ET
import numpy as np

def prepare(xml, cleaned, ff, exported):
 tree=ET.parse(xml);root=tree.getroot();tags=list(root.find('tags'));white=set()
 for tag in tags:
  if tag.get('type')!='DefineBitsLossless2Tag' or tag.get('bitmapFormat')!='5':continue
  w=int(tag.get('bitmapWidth'));h=int(tag.get('bitmapHeight'))
  if min(w,h)<16:continue
  raw=zlib.decompress(bytes.fromhex(tag.get('zlibBitmapData')))
  pixels=np.frombuffer(raw,dtype=np.uint8).reshape(-1,4)
  if float(np.mean((pixels>240).all(axis=1)))<.999:continue
  white.add(tag.get('characterID'))
  tag.set('zlibBitmapData',zlib.compress(bytes(w*h*4)).hex())
 assert white,'No native white screen-flash bitmap found'
 ancestors=set(white)
 for _ in range(6):
  previous=len(ancestors)
  for tag in tags:
   ident=tag.get('shapeId') or tag.get('spriteId')
   if not ident or ident in ancestors or ident in exported:continue
   if any(child.get('characterId') in ancestors or child.get('bitmapId') in ancestors for child in tag.iter()):ancestors.add(ident)
  if len(ancestors)==previous:break
 flash=[]
 for tag in tags:
  if tag.get('spriteId') not in exported:continue
  frames=[];depths={}
  for item in tag.find('subTags'):
   kind=item.get('type','');depth=item.get('depth')
   if kind=='ShowFrameTag':
    frames.append(max([v[1] for v in depths.values() if v[0] in ancestors]+[0]));continue
   if kind.startswith('Remove'):depths.pop(depth,None);continue
   if not kind.startswith('Place'):continue
   ident,alpha=depths.get(depth,('',1))
   ident=item.get('characterId',ident)
   color=item.find('colorTransform')
   if color is not None:alpha=max(0,min(1,int(color.get('alphaMultTerm','256'))/256+int(color.get('alphaAddTerm','0'))/255))
   depths[depth]=(ident,alpha)
  if any(frames):
   assert not flash,'Unexpected multiple screen-flash timelines'
   flash=frames
 assert flash and max(flash)>.9,'Screen-flash timeline not found'
 # Keep the native cue, spread abrupt one-frame changes and avoid a blinding
 # full-white battlefield. Geometry is a single stage-sized vector at runtime.
 sampled=[flash[min(len(flash)-1,round(i*24/25))] for i in range(math.ceil(len(flash)*25/24))]
 softened=[round(.12*sum(sampled[max(0,i-2):min(len(sampled),i+3)])/len(sampled[max(0,i-2):min(len(sampled),i+3)]),5) for i in range(len(sampled))]
 if not cleaned.exists():
  clean_xml=cleaned.with_suffix('.xml');tree.write(clean_xml,encoding='utf-8',xml_declaration=True)
  ff('-xml2swf',clean_xml,cleaned)
 return softened,sorted(white)
