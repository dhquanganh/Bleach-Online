"""Decode the supplied Naruto MME bitmap timelines without synthesizing poses."""
from pathlib import Path
from PIL import Image
import io, json, math, struct, zlib
import xml.etree.ElementTree as ET

BASE = Path(__file__).resolve().parent


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

def render(config, images, name, size=(768,600), pivot=(384,450), scale=0.62, skip_layers=()):
    action = next(a for a in config.findall('action') if a.get('name') == name)
    assets = {a.get('id'):a for a in config.findall('asset')}
    count = max(int(f.get('index'))+int(f.get('length')) for f in action.iter('frame'))
    result = []
    for index in range(count):
        parts=[]
        for layer_index,layer in reversed(list(enumerate(action.findall('layer')))):
            if layer_index in skip_layers: continue
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
