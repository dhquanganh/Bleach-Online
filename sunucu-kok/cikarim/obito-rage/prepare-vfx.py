"""Rasterize original SWF effect timelines and cache compact transparent atlases."""
from pathlib import Path
from PIL import Image, ImageDraw
import argparse, hashlib, importlib.util, json, math, subprocess
import xml.etree.ElementTree as ET

BASE=Path(__file__).resolve().parent
ROOT=BASE.parents[1]
SOURCE=ROOT.parent/'asset/Extracted_Obito_Rage'
PUBLIC=ROOT/'kaynak/login.gogames.me/public/obito-vfx/extracted'

def main():
    parser=argparse.ArgumentParser();parser.add_argument('--ffdec',default=str(ROOT.parent/'.tools/ffdec/ffdec.jar'));args=parser.parse_args()
    cache=BASE/'native-export';cache.mkdir(exist_ok=True);PUBLIC.mkdir(parents=True,exist_ok=True)
    manifest={'version':4,'frameRate':25,'frameMs':40,'atlases':{},'clips':{}}
    preview=BASE/'validation/extracted';preview.mkdir(parents=True,exist_ok=True)
    for path in sorted((SOURCE/'battle/effect').glob('*.swf')):
        name=path.stem.removeprefix('Dourenjiedazhan_');out=cache/name;out.mkdir(exist_ok=True)
        def ffdec(*params):
            subprocess.run(['java','-Xmx2g','-jar',args.ffdec,*map(str,params)],check=True,stdout=subprocess.DEVNULL)
        xml=out/'source.xml'
        if not xml.exists():ffdec('-swf2xml',path,xml)
        root=ET.parse(xml).getroot()
        symbols=next(e for e in root.find('tags') if e.get('type')=='SymbolClassTag')
        ids=[int(e.text) for e in symbols.find('tags') if e.text!='0']
        bounds_file=out/'bounds.json'
        if not bounds_file.exists():
            result=subprocess.check_output(['java','-cp',args.ffdec,str(BASE/'SwfBounds.java'),str(path),*map(str,ids)],text=True)
            rectangles={}
            for line in result.splitlines():
                values=list(map(int,line.split(',')));rectangles[str(values[0])]=values[1:]
            bounds_file.write_text(json.dumps(rectangles))
        rectangles=json.loads(bounds_file.read_text())
        if not (out/'complete.json').exists():
            ffdec('-zoom','0.35','-ignorebackground','-selectid',','.join(map(str,ids)),'-export','sprite',out,path)
            (out/'complete.json').write_text(json.dumps(ids))
        layers=[]
        for folder in sorted(out.glob('DefineSprite_*')):
            paths=sorted(folder.glob('*.png'),key=lambda p:int(p.stem))
            if not paths:continue
            bounds=None
            for p in paths:
                box=Image.open(p).getbbox()
                if box:bounds=box if bounds is None else (min(bounds[0],box[0]),min(bounds[1],box[1]),max(bounds[2],box[2]),max(bounds[3],box[3]))
            if bounds is None:continue
            # Identical crop for every frame prevents swimming/jittering pivots.
            width,height=bounds[2]-bounds[0],bounds[3]-bounds[1]
            ratio=min(1,512/width,360/height)
            width,height=max(1,round(width*ratio)),max(1,round(height*ratio))
            while math.ceil(len(paths)/max(1,4096//width))*height>4096:
                width=max(1,round(width*.95));height=max(1,round(height*.95))
            columns=max(1,4096//width);rows=math.ceil(len(paths)/columns)
            sheet=Image.new('RGBA',(columns*width,rows*height));unique={};timeline=[];frames=[]
            # Time resampling only: preserve every original frame and alpha edge.
            for t in range(math.ceil(len(paths)*25/24)):
                index=min(len(paths)-1,round(t*24/25));im=Image.open(paths[index]).convert('RGBA').crop(bounds).resize((width,height),Image.Resampling.LANCZOS)
                key=hashlib.sha256(im.tobytes()).digest()
                if key not in unique:
                    n=len(unique);unique[key]=n;sheet.alpha_composite(im,((n%columns)*width,(n//columns)*height))
                timeline.append(unique[key]);frames.append(im)
            rows=math.ceil(len(unique)/columns);sheet=sheet.crop((0,0,columns*width,rows*height))
            key=name+'-'+folder.name.split('_')[1];filename=key+'.png';sheet.save(PUBLIC/filename)
            manifest['atlases'][key]={'url':'/public/obito-vfx/extracted/'+filename,'columns':columns,'rows':rows,'frameCount':len(unique)}
            rect=rectangles[folder.name.split('_')[1]]
            pivot=[(-rect[0]/20*.35-bounds[0])/(bounds[2]-bounds[0]),(-rect[1]/20*.35-bounds[1])/(bounds[3]-bounds[1])]
            manifest['clips'][key]={'atlas':key,'timeline':timeline,'pivot':pivot,
                                    'renderScale':.35*width/(bounds[2]-bounds[0]),
                                    'width':width,'height':height,'source':str(path.relative_to(SOURCE)),
                                    'sourceFrames':len(paths),'uniqueFrames':len(unique)}
            layers.append(key)
            gifs=[]
            for im in frames:
                background=Image.new('RGBA',im.size,'#263746');background.alpha_composite(im);background.thumbnail((640,480));gifs.append(background.convert('RGB'))
            gifs[0].save(preview/(key+'.gif'),save_all=True,append_images=gifs[1:],duration=40,loop=0)
        manifest.setdefault('effects',{})[name]=layers
        print('PASS original effect',name,layers,flush=True)
    (BASE/'vfx.json').write_text(json.dumps(manifest,indent=2))
    # Keep every provided asset available, with exact provenance and checksums.
    import shutil
    files=[]
    for item in json.loads((SOURCE/'manifest.json').read_text()):
        source=SOURCE/item['file'];target=PUBLIC/'original'/item['file'];target.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(source,target)
        digest=hashlib.sha256(source.read_bytes()).hexdigest();assert digest==item['sha256']
        files.append({'file':item['file'],'sha256':digest})
    (preview/'source-assets.json').write_text(json.dumps(files,indent=2))
    print('PASS all',len(files),'source assets checked and installed')

if __name__=='__main__':main()
