"""Shared native table serializer and compact animation packing."""
from pathlib import Path
from PIL import Image
import hashlib,importlib.util,io,struct,sys,zlib
BASE=Path(__file__).resolve().parent
sys.path.insert(0,str(BASE.parent/'naruto-sage'))
spec=importlib.util.spec_from_file_location('native_animation',BASE.parent/'naruto-sage/build.py')
native=importlib.util.module_from_spec(spec);spec.loader.exec_module(native)
def packed_sequence(index,frames,loop,duration,pivots):
    """Pack rows below Flash's 4096px bitmap limit, retaining per-frame anchors."""
    positions=[];unique={};x=y=row=0
    for im in frames:
        key=(im.size,hashlib.sha256(im.tobytes()).digest())
        if key in unique:
            positions.append(unique[key]);continue
        if x+im.width>4096:x=0;y+=row;row=0
        unique[key]=(x,y);positions.append((x,y));x+=im.width;row=max(row,im.height)
    height=y+row;width=max(x+im.width for (x,y),im in zip(positions,frames))
    assert height*2<=4096,(width,height)
    atlas=Image.new('RGB',(width,height*2));rects=[]
    seq=struct.pack('<IBH',index,2 if loop else 1,len(frames))
    for im,(x,y),(px,py) in zip(frames,positions,pivots):
        atlas.paste(im.convert('RGB'),(x,y));atlas.paste(im.getchannel('A').convert('RGB'),(x,y+height))
        rects.append(struct.pack('>hhhh',x,y,im.width,im.height))
        seq+=struct.pack('<hhhhhhH',0,0,im.width,im.height,px,py,duration)
    buf=io.BytesIO();atlas.save(buf,format='PNG');png=buf.getvalue()
    pak=zlib.compress(struct.pack('>BHHBBBH',127,width,height,100,100,0,len(frames))+b''.join(rects)+struct.pack('>I',len(png))+png)
    return seq,pak

native.texture_sequence=packed_sequence
