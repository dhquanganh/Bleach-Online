"""Decode the supplied Naruto MME bitmap timelines without synthesizing poses."""
from pathlib import Path
from PIL import Image
import io, json, math, struct, zlib
import xml.etree.ElementTree as ET

BASE = Path(__file__).resolve().parent
SOURCE = BASE.parents[2] / 'asset/Extracted_Kabuto_Great_Ninja_War'

def decode(path):
    raw = path.read_bytes()
    data = raw[:8] + zlib.decompress(raw[8:]) if raw[:3] == b'CWS' else raw
    pos = 8 + (5 + 4*(data[8] >> 3) + 7)//8 + 4
    images, names, config = {}, {}, None
    while pos < len(data):
        header = struct.unpack_from('<H', data, pos)[0]; pos += 2
        kind, size = header >> 6, header & 63
        if size == 63:
            size = struct.unpack_from('<I', data, pos)[0]; pos += 4
        body = data[pos:pos+size]; pos += size
        if kind == 35:
            ident, length = struct.unpack_from('<HI', body)
            image = Image.open(io.BytesIO(body[6:6+length])).convert('RGBA')
            if body[6+length:]:
                image.putalpha(Image.frombytes('L', image.size, zlib.decompress(body[6+length:])))
            images[ident] = image
        elif kind == 76:
            q = 2
            for _ in range(struct.unpack_from('<H', body)[0]):
                ident = struct.unpack_from('<H', body, q)[0]; q += 2
                end = body.index(0, q); names[body[q:end].decode()] = ident; q = end+1
        elif kind == 87 and body[6:].lstrip().startswith(b'<actions'):
            config = ET.fromstring(body[6:])
    assert config is not None, path
    return config, {name:images[ident] for name,ident in names.items() if ident in images}

def render(config, images, name, size=(768,600), pivot=(384,450), scale=1.1):
    action = next(a for a in config.findall('action') if a.get('name') == name)
    assets = {a.get('id'):a for a in config.findall('asset')}
    count = max(int(f.get('index'))+int(f.get('length')) for f in action.iter('frame'))
    result = []
    for index in range(count):
        parts=[]
        for layer in reversed(action.findall('layer')):
            frame = next((f for f in layer.findall('frame') if int(f.get('index')) <= index < int(f.get('index'))+int(f.get('length'))), None)
            if frame is None: continue
            for element in frame.findall('element'):
                asset = assets[element.get('assetId')]; image = images[asset.get('className')]
                angle=math.radians(float(element.get('rotation',0)))
                sx=float(element.get('scaleX',1))*scale;sy=float(element.get('scaleY',1))*scale
                if not sx or not sy:continue
                c,s=math.cos(angle),math.sin(angle)
                tx=float(element.get('x',0))*scale;ty=float(element.get('y',0))*scale
                ax,ay=float(asset.get('x',0)),float(asset.get('y',0))
                corners=[(c*sx*(x+ax)-s*sy*(y+ay)+tx,s*sx*(x+ax)+c*sy*(y+ay)+ty) for x,y in [(0,0),(image.width,0),(0,image.height),(image.width,image.height)]]
                box=(math.floor(min(x for x,y in corners))-1,math.floor(min(y for x,y in corners))-1,math.ceil(max(x for x,y in corners))+1,math.ceil(max(y for x,y in corners))+1)
                w,h=box[2]-box[0],box[3]-box[1]
                matrix=(c/sx,s/sx,(c*(box[0]-tx)+s*(box[1]-ty))/sx-ax,-s/sy,c/sy,(-s*(box[0]-tx)+c*(box[1]-ty))/sy-ay)
                tile=image.transform((w,h),Image.Transform.AFFINE,matrix,Image.Resampling.BICUBIC)
                alpha=float(element.get('alpha',1))
                if alpha!=1:tile.putalpha(tile.getchannel('A').point(lambda v:round(v*alpha)))
                parts.append((tile,box))
        if parts:
            left=min(box[0] for im,box in parts);top=min(box[1] for im,box in parts)
            right=max(box[2] for im,box in parts);bottom=max(box[3] for im,box in parts)
            canvas=Image.new('RGBA',(right-left,bottom-top))
            for im,box in parts:canvas.alpha_composite(im,(box[0]-left,box[1]-top))
            bounds=canvas.getbbox()
            if bounds:
                canvas=canvas.crop(bounds);canvas.info['pivot']=[-left-bounds[0],-top-bounds[1]]
            else:canvas=Image.new('RGBA',(1,1));canvas.info['pivot']=[0,0]
        else:canvas=Image.new('RGBA',(1,1));canvas.info['pivot']=[0,0]
        result.append(canvas)
    return result, action

def main():
    data=json.loads((BASE/'animation.json').read_text())
    config,images=decode(SOURCE/'battle/role/left/11002061.swf')
    # Recover the existing guest frames losslessly from installed native resources.
    dest=BASE/'frames';dest.mkdir(exist_ok=True)
    if not list(dest.glob('*.png')):
        public=BASE.parents[1]/'kaynak/login.gogames.me/public/2026090619/Resources/Textures/Model'
        for hero,models in data['models'].items():
            for suffix,names in models.items():
                names=[names] if isinstance(names,str) else names
                b=(public/f'{int(f"{int(hero):X}"+suffix,16):08X}.TexClient').read_bytes()
                size=struct.unpack_from('<I',b,4)[0];q=8+size+2
                for name in names:
                    n=struct.unpack_from('<I',b,q)[0];q+=4;pak=zlib.decompress(b[q:q+n]);q+=n
                    _,w,h,_,_,_,count=struct.unpack_from('>BHHBBBH',pak)
                    offset=10+count*8;n=struct.unpack_from('>I',pak,offset)[0]
                    atlas=Image.open(io.BytesIO(pak[offset+4:offset+4+n])).convert('RGB')
                    for i,ident in enumerate(data['clips'][name]['assets']):
                        x,y,fw,fh=struct.unpack_from('>hhhh',pak,10+i*8)
                        im=atlas.crop((x,y,x+fw,y+fh)).convert('RGBA')
                        im.putalpha(atlas.crop((x,y+h,x+fw,y+h+fh)).getchannel('R'));im.save(dest/f'{ident:03}.png')
    mappings={'kabuto-idle':'C_idle','kabuto-run':'C_run1_2','kabuto-hit':'D_stand_behit1',
              'kabuto-die':'C_dead','white-snake-assault':'SP_skill1','bracken-dance':'A_1hit',
              'white-extreme-attack':'SP_skill2','self-healing':'SP_skill3',
              'white-snake-revival':'C_entry','impure-world-reincarnation':'SP_skill5'}
    next_id=max(i for name,c in data['clips'].items() if name not in mappings for i in c['assets'])+1
    pivots=data.setdefault('framePivots',{})
    previews=BASE/'validation/extracted';previews.mkdir(parents=True,exist_ok=True)
    for name,action_name in mappings.items():
        frames,action=render(config,images,action_name)
        # Resample time only to the engine's 40 ms tick; keep original bitmap poses.
        indices=[min(len(frames)-1,round(t*24/25)) for t in range(math.ceil(len(frames)*25/24))]
        ids=[]
        for index in indices:
            frames[index].save(dest/f'{next_id:03}.png')
            pivots[str(next_id)]=frames[index].info['pivot']
            ids.append(next_id);next_id+=1
        clip={'assets':ids,'keys':list(ids),'duration':40,'loop':name in ['kabuto-idle','kabuto-run'],
              'idle':ids[-1],'steps':1,'sourceAction':action_name,'sourceFrameRate':24}
        if not clip['loop']:clip['returnFrame']=len(ids)-1
        hits=[round(int(f.get('index'))*25/24) for f in action.iter('frame') if 'hit' in f.get('event','').split(',')]
        if hits:clip['hitFrames']=[hits[0]]
        if not clip['loop'] and name!='kabuto-die':
            clip['idle']=data['clips']['kabuto-idle']['assets'][0]
            clip['assets'].append(clip['idle']);clip['returnFrame']=len(clip['assets'])-1
        data['clips'][name]=clip
        gif=[]
        for i in indices:
            background=Image.new('RGBA',(1280,720),'#263746');px,py=frames[i].info['pivot'];background.alpha_composite(frames[i],(640-px,500-py));background.thumbnail((640,360));gif.append(background.convert('RGB'))
        gif[0].save(previews/(name+'.gif'),save_all=True,append_images=gif[1:],duration=40,loop=0)
    data.update(frameCount=next_id,source='asset/Extracted_Kabuto_Great_Ninja_War',sourceFrameRate=24)
    data['sourceFrames']=[frame for frame in data.get('sourceFrames',[]) if frame.get('id',0)>=32]
    if (BASE/'vfx.json').exists():
        vfx=json.loads((BASE/'vfx.json').read_text())
        if vfx.get('version')==4:
            for name,effects in {'white-snake-assault':['aoyi','aoyitexie'],'bracken-dance':['pugong','pugong1','pugong2'],
                                 'white-extreme-attack':['zhuida'],'self-healing':['tinengzhiyu'],
                                 'white-snake-revival':['reanimate'],'impure-world-reincarnation':['summon-mu']}.items():
                duration=max(len(vfx['clips'][k]['timeline']) for effect in effects for k in vfx['effects'][effect])
                clip=data['clips'][name]
                while len(clip['assets'])<=duration:clip['assets'].append(clip['idle'])
                clip['returnFrame']=len(clip['assets'])-1
    showcase,show_images=decode(SOURCE/'user/ninja/ninjaImg/11002061.swf')
    image=render(showcase,show_images,'C_idle',size=(768,768),pivot=(384,700),scale=1)[0][0]
    image.crop(image.getbbox()).save(previews/'showcase.png')
    (BASE/'animation.json').write_text(json.dumps(data,indent=2))
    print('PASS extracted Kabuto timelines:',len(mappings),'clips')

if __name__=='__main__':main()
