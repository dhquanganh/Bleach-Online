"""Regression for duplicate idle bodies in the original MME model timeline."""
from pathlib import Path
from PIL import Image,ImageDraw
import importlib.util,json
BASE=Path(__file__).resolve().parent
spec=importlib.util.spec_from_file_location('prepare',BASE/'prepare-assets.py');prepare=importlib.util.module_from_spec(spec);spec.loader.exec_module(prepare)
original,images=prepare.mme.decode(prepare.SOURCE/'battle/role/left/11006051.swf')
clean=prepare.single_actor_config(original)
metadata=json.loads((BASE/'animation.json').read_text())
samples=[('standard',22),('rage-standard',33),('roots',60)]
sheet=Image.new('RGB',(1000,750),'#263746');draw=ImageDraw.Draw(sheet);checked=0
for name,index in prepare.IDLE_BACKDROPS.items():
    before=next(a for a in original.findall('action') if a.get('name')==name)
    after=next(a for a in clean.findall('action') if a.get('name')==name)
    assert len(before.findall('layer'))==len(after.findall('layer'))+1
    assert [(f.get('index'),f.get('event')) for f in before.iter('frame') if f.get('event')]==[(f.get('index'),f.get('event')) for f in after.iter('frame') if f.get('event')]
    if name in ['A_1hit','A_2hit']:
        count=max(int(f.get('index'))+int(f.get('length')) for f in after.iter('frame'))
        for t in range(count):
            bodies=sum(len(f.findall('element')) for l in after.findall('layer') for f in l.findall('frame') if int(f.get('index'))<=t<int(f.get('index'))+int(f.get('length')))
            assert bodies<=1,(name,t,bodies)
            checked+=1
for row,(clip,t) in enumerate(samples):
    action=prepare.MAPPING[clip]
    before,_=prepare.mme.render(original,images,action,scale=.85)
    after,_=prepare.mme.render(clean,images,action,scale=.85)
    native_index=next(i for i in range(len(metadata['clips'][clip]['assets'])) if round(i*24/25)==t)
    asset=metadata['clips'][clip]['assets'][native_index]
    installed=Image.open(BASE/'frames'/f'{asset:03}.png').convert('RGBA')
    assert installed.size==after[t].size and installed.tobytes()==after[t].tobytes()
    assert metadata['framePivots'][str(asset)]==after[t].info['pivot']
    assert before[t].size!=after[t].size or before[t].tobytes()!=after[t].tobytes()
    for col,im in enumerate([before[t],after[t]]):
        px,py=im.info['pivot'];sheet.paste(im,(col*500+100-px,row*250+210-py),im)
        draw.text((col*500+12,row*250+12),('BEFORE' if col==0 else 'FIXED')+' / '+clip+' / frame '+str(t),fill='white')
sheet.save(BASE/'validation/dedup-before-after.png')
(BASE/'validation/dedup.json').write_text(json.dumps({'removedIdleBackdrops':prepare.IDLE_BACKDROPS,'singleBodyFramesChecked':checked,'hitEventsPreserved':True,'correctedSourceSamples':len(samples)},indent=2))
print('PASS duplicate idle backdrops removed;',checked,'single-body frames; hit events, corrected pixels and pivots verified')
