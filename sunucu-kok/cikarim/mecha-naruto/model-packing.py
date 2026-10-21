"""Lossless native atlas packing for the large Kurama attack sequences."""
import hashlib,io,struct,zlib
from PIL import Image

def packed_sequence(index, frames, loop, duration, pivots):
    # MaxRects packing retains every source pixel and fits Flash bitmap limits.
    keys = [(im.size, hashlib.sha256(im.tobytes()).digest()) for im in frames]
    unique = dict(zip(keys, frames)); positions = {}; free = [(0,0,4096,2048)]
    for key, im in sorted(unique.items(), key=lambda pair: (-max(pair[1].size), -pair[1].width*pair[1].height)):
        candidates = [r for r in free if r[2]>=im.width and r[3]>=im.height]
        assert candidates, ('Atlas capacity exceeded',index,im.size,sum(v.width*v.height for v in unique.values()))
        x,y,_,_ = min(candidates, key=lambda r: (min(r[2]-im.width,r[3]-im.height),max(r[2]-im.width,r[3]-im.height)))
        positions[key] = (x,y); right=x+im.width; bottom=y+im.height; split=[]
        for fx,fy,fw,fh in free:
            if x>=fx+fw or right<=fx or y>=fy+fh or bottom<=fy: split.append((fx,fy,fw,fh)); continue
            if x>fx: split.append((fx,fy,x-fx,fh))
            if right<fx+fw: split.append((right,fy,fx+fw-right,fh))
            if y>fy: split.append((fx,fy,fw,y-fy))
            if bottom<fy+fh: split.append((fx,bottom,fw,fy+fh-bottom))
        split=list(dict.fromkeys(split))
        free=[r for r in split if not any(r!=q and r[0]>=q[0] and r[1]>=q[1] and r[0]+r[2]<=q[0]+q[2] and r[1]+r[3]<=q[1]+q[3] for q in split)]
    height=max(positions[k][1]+im.height for k,im in unique.items())
    width = max(positions[k][0]+im.width for k,im in unique.items())
    assert width <= 4096 and height*2 <= 4096, (width, height)
    atlas = Image.new('RGB', (width, height*2))
    for key, im in unique.items():
        x,y = positions[key]; atlas.paste(im.convert('RGB'), (x,y)); atlas.paste(im.getchannel('A').convert('RGB'), (x,y+height))
    seq = struct.pack('<IBH', index, 2 if loop else 1, len(frames)); rects = []
    for key,im,(px,py) in zip(keys,frames,pivots):
        x,y = positions[key]; rects.append(struct.pack('>hhhh',x,y,im.width,im.height))
        seq += struct.pack('<hhhhhhH',0,0,im.width,im.height,px,py,duration)
    image = io.BytesIO(); atlas.save(image, format='PNG'); png = image.getvalue()
    pak = zlib.compress(struct.pack('>BHHBBBH',127,width,height,100,100,0,len(frames))+b''.join(rects)+struct.pack('>I',len(png))+png)
    return seq,pak

