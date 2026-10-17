"""Slice generated VFX atlases for the native Flash texture packer, preserving alpha."""
from pathlib import Path
from PIL import Image
import json
BASE=Path(__file__).resolve().parent
ROOT=BASE.parents[1]
CONFIG=json.loads((BASE/'vfx.json').read_text())
def frames(effect):
    atlas=Image.open(ROOT/CONFIG['atlases'][effect['atlas']]).convert('RGBA')
    result=[]
    for index in effect['frames']:
        col,row=index%4,index//4
        bounds=tuple(round(v) for v in (col*atlas.width/4,row*atlas.height/4,(col+1)*atlas.width/4,(row+1)*atlas.height/4))
        im=atlas.crop(bounds)
        # Fixed registration rectangle for every frame; do not trim to the glow.
        im=im.resize(tuple(effect['size']),Image.Resampling.LANCZOS)
        result.append(im)
    return result
def pivots(effect):
    w,h=effect['size'];centers=effect.get('centers') or [effect['center']]*len(effect['frames'])
    assert len(centers)==len(effect['frames'])
    return [(round(w/2-x),round(h/2-y)) for x,y in centers]
