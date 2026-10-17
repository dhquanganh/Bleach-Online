"""Clean and register cut Jiraiya atlas cells; preserve full source atlases."""
from pathlib import Path
from PIL import Image,ImageDraw
from scipy import ndimage
import numpy as np
import cv2
import json
BASE=Path(__file__).resolve().parent
ROOT=BASE.parents[1]
SOURCE=ROOT.parent/'asset/Browser Games - Naruto Online - Recruitable Characters - Jiraiya (Toads Chant)'
SCALE=0.70
FRAME_MS=40

def interpolate(first,second,t):
    """Bidirectional motion compensation on registered, premultiplied RGBA."""
    a=np.asarray(first,dtype=np.float32)/255
    b=np.asarray(second,dtype=np.float32)/255
    a[:,:,:3]*=a[:,:,3:4];b[:,:,:3]*=b[:,:,3:4]
    def gray(im):
        return np.uint8(np.clip((cv2.cvtColor(im[:,:,:3],cv2.COLOR_RGB2GRAY)*0.7+im[:,:,3]*0.3)*255,0,255))
    ga,gb=gray(a),gray(b)
    flow=cv2.DISOpticalFlow_create(cv2.DISOPTICAL_FLOW_PRESET_MEDIUM)
    forward=flow.calc(ga,gb,None);backward=flow.calc(gb,ga,None)
    y,x=np.mgrid[:a.shape[0],:a.shape[1]].astype(np.float32)
    left=cv2.remap(a,x-t*forward[:,:,0],y-t*forward[:,:,1],cv2.INTER_LINEAR,borderMode=cv2.BORDER_CONSTANT)
    right=cv2.remap(b,x-(1-t)*backward[:,:,0],y-(1-t)*backward[:,:,1],cv2.INTER_LINEAR,borderMode=cv2.BORDER_CONSTANT)
    result=left*(1-t)+right*t
    result[:,:,:3]/=np.maximum(result[:,:,3:4],1/255)
    return Image.fromarray(np.uint8(np.clip(result*255,0,255)))

def main():
    config=json.loads((SOURCE/'animations.json').read_text())
    dest=BASE/'frames';dest.mkdir(exist_ok=True)
    frames=[];anchors={};details=[]
    atlases={}
    for metadata in config['frames']:
        ident=metadata['id'];source=metadata['source']
        if source not in atlases:atlases[source]=Image.open(SOURCE/source).convert('RGBA')
        crop=atlases[source].crop(metadata['sourceBounds'])
        canvas=Image.new('RGBA',(384,336))
        canvas.alpha_composite(crop,((384-crop.width)//2,336-crop.height))
        im=canvas.resize((256,224),Image.Resampling.LANCZOS)
        rgba=np.array(im)
        mask=rgba[:,:,3]>12
        labels,count=ndimage.label(mask)
        sizes=np.bincount(labels.ravel());keep=sizes>=8;keep[0]=False
        rgba[:,:,3][~keep[labels]]=0
        # Shoe pixels are dark red, unlike pink barrier and blue/gold chakra.
        r,g,b,a=[rgba[:,:,n].astype(float) for n in range(4)]
        shoe=(a>220)&(r>45)&(r<160)&(r>g*1.5)&(g<85)&(b<95)
        shoe[:im.height//2]=False
        ys,xs=np.where(shoe)
        assert len(ys),f'No ground reference for frame {ident}'
        baseline=int(ys.max())+1
        footx=xs[ys>=baseline-7]
        px=round((int(footx.min())+int(footx.max()))/2)
        # Falling / prone poses stay centered in the revival space.
        if ident in [88,89]:px=128
        im=Image.fromarray(rgba);im.save(dest/f'{ident:03}.png')
        anchors[str(ident)]=[px,baseline]
        details.append({'id':ident,'sourceBounds':metadata['sourceBounds'],'pivot':[px,baseline],
            'alphaBounds':im.getchannel('A').getbbox()})
        frames.append(im)
    clips={name:{'assets':c['frames'],'duration':c['durationMs'],'loop':c['loop']} for name,c in config['clips'].items()}
    # Reject the idle drawings whose head/shoulder silhouette jumps sideways.
    clips['idle']['assets']=[0,1,2,1]
    anchors['1'][0]=133;anchors['2'][0]=132
    clips['run']['assets']=[9,10,11,12,11,10]
    # UI art retains its own original size; battle scaling never changes icons.
    frames[0].crop((40,25,235,224)).save(BASE/'portrait.png')
    for ident,im in enumerate(frames):
        px,py=anchors[str(ident)]
        small=im.resize((round(im.width*SCALE),round(im.height*SCALE)),Image.Resampling.LANCZOS)
        registered=Image.new('RGBA',(256,224))
        registered.alpha_composite(small,(128-round(px*SCALE),210-round(py*SCALE)))
        frames[ident]=registered;anchors[str(ident)]=[128,210]
        registered.save(dest/f'{ident:03}.png')
    # Return all casts to the exact same idle frame, not a regenerated pose.
    for name,c in clips.items():
        if not c['loop']:
            c['assets']=c['assets']+[0]
            c['returnFrame']=len(c['assets'])-1
    clips['giant-gallant-rasengan']['hitFrames']=[10]
    clips['toad-confrontation-chant']['hitFrames']=[8]
    clips['raging-lions-mane']['hitFrames']=[9]
    for name,c in clips.items():
        original=list(c['assets']);old_duration=c['duration']
        steps=8 if name=='idle' else max(3,round(old_duration*1.5/FRAME_MS))
        expanded=[]
        pairs=list(zip(original,original[1:]+original[:1])) if c['loop'] else list(zip(original,original[1:]))
        for first,second in pairs:
            expanded.append(first)
            for step in range(1,steps):
                ident=len(frames)
                im=interpolate(frames[first],frames[second],step/steps)
                frames.append(im);anchors[str(ident)]=[128,210]
                im.save(dest/f'{ident:03}.png');expanded.append(ident)
        if not c['loop']:expanded.append(original[-1]);c['returnFrame']=len(expanded)-1
        if 'hitFrames' in c:c['hitFrames']=[i*steps for i in c['hitFrames']]
        c.update(assets=expanded,duration=FRAME_MS,sourceAssets=original,sourceDuration=old_duration,
                 interpolationSteps=steps,previousLengthMs=len(original)*old_duration)
    data={'heroId':11120903,'battleScale':SCALE,'frameRate':1000/FRAME_MS,'anchors':anchors,'clips':clips,'sourceFrames':details,
        'modelTextures':{'':'idle','0a':'idle','0b':'giant-gallant-rasengan',
        '0c':['toad-mouth-barrier','toad-confrontation-chant','raging-lions-mane','senjutsu-power','tale-of-jiraiya-revival'],
        '0d':'hit','0e':'idle','0f':'run'}}
    (BASE/'animation.json').write_text(json.dumps(data,indent=2))
    preview=BASE/'validation';preview.mkdir(exist_ok=True)
    samples=[]
    for name,c in clips.items():
        animation=[]
        for ident in c['assets']:
            px,py=anchors[str(ident)]
            canvas=Image.new('RGBA',(420,280),'#253441')
            canvas.alpha_composite(frames[ident],(210-px,250-py))
            draw=ImageDraw.Draw(canvas);draw.line((0,250,420,250),fill='#597080');draw.text((8,8),name,fill='white')
            animation.append(canvas.convert('RGB'))
        animation[0].save(preview/f'{name}.gif',save_all=True,append_images=animation[1:],duration=c['duration'],loop=0)
        samples.append(animation[len(animation)//2])
    board=Image.new('RGB',(1260,840),'#253441')
    for i,im in enumerate(samples):board.paste(im,(i%3*420,i//3*280))
    board.save(preview/'registered-overview.png')
    print(f'Prepared {len(frames)} motion-interpolated frames, scale {SCALE}, {1000/FRAME_MS:g} FPS, anchored feet and identical idle recovery.')
if __name__=='__main__':main()
