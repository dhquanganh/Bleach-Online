"""Place impact artwork from visible source pixels, not the surrounding smoke."""
from pathlib import Path
from PIL import Image
import numpy as np

def configure(manifest, animation, public):
 profiles={
  'ZuozhuZZZZ_qilin':('ZuozhuZZZZ_qilin-821',95,1800,8,True),
  'ZuozhuZZZZ_qilin_yan':('ZuozhuZZZZ_qilin_yan-1066',95,1800,8,True),
  'ZuozhuZZZZ_haolonghuo':('ZuozhuZZZZ_haolonghuo-31',28,1280,85,False),
  'ZuozhuZZZZ_haolonghuoyan':('ZuozhuZZZZ_haolonghuoyan-31',28,1280,85,False),
  'ZuozhuZZZZ_qianniaodao3':('ZuozhuZZZZ_qianniaodao3-684',10,1600,85,False),
 }
 result={}
 for effect,(key,tick,width,height,ground) in profiles.items():
  clip=manifest['clips'][key];rect=clip['frameRects'][tick]
  with Image.open(public/manifest['atlases'][clip['frameAtlases'][tick]]['url'].lstrip('/')) as atlas:
   x,y,w,h,dx,dy=rect;frame=atlas.crop((x,y,x+w,y+h)).convert('RGBA')
  pixels=np.asarray(frame,dtype=np.float64)/255
  weights=pixels[:,:,3]*np.max(pixels[:,:,:3],axis=2)**8
  if ground:weights[:int(h*.55),:]=0
  yy,xx=np.indices(weights.shape);mass=weights.sum();assert mass>0,key
  ax=dx+float((xx*weights).sum()/mass)
  ay=dy+float((yy*weights).sum()/mass)
  result[effect]={'coreWidth':clip['width']/clip['renderScale'],'sharpScale':clip['renderScale'],
   'displayWidth':width,'heightAboveGround':height,
   'anchorX':(ax-clip['pivot'][0]*clip['width'])/clip['renderScale'],
   'anchorY':(ay-clip['pivot'][1]*clip['height'])/clip['renderScale']}
 # All three native Susanoo layers use the actor's source foot origin.
 clip=manifest['clips']['ZuozhuZZZZ_xuzuobati-106']
 result['ZuozhuZZZZ_xuzuobati']={'coreWidth':clip['width']/clip['renderScale'],
  'displayWidth':180,'heightAboveGround':0,'anchorX':0,'anchorY':0}
 for key,clip in manifest['clips'].items():
  if not key.startswith('ZuozhuZZZZ_xuzuobati-'):continue
  count=len(animation['clips']['susanoo']['assets'])
  # The supplied 11-frame aura is a loop, not the complete 41-frame action.
  for field in ['timeline','frameAtlases','frameRects']:
   original=clip[field];clip[field]=[original[i%len(original)] for i in range(count)]
 manifest['presentation']=result
 return result
