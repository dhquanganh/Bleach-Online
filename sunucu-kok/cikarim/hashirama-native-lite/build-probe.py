"""Compile production Hashirama native VFX in the isolated Flash preview."""
from pathlib import Path
import importlib.util,argparse,re,json
B=Path(__file__).resolve().parent
s=importlib.util.spec_from_file_location('client',B/'build-client.py')
m=importlib.util.module_from_spec(s);s.loader.exec_module(m);c=m.c

def main():
    parser=argparse.ArgumentParser();parser.add_argument('--focus',choices=['forest','cinematic','stress']);args=parser.parse_args()
    source=(B.parent/'hashirama-final/probe-source/TApplication.as').read_text(encoding='utf-8')
    production=(B/'patched'/c.b.ROLE).read_text(encoding='utf-8')
    source=source.replace(' import flash.geom.*;',' import flash.geom.*;\n import flash.system.*;',1)
    source=source.replace('ProbeRole.PreloadHashiramaVfx();','ProbeRole.PreloadHashiramaNative();',1)
    source=source.replace('public var FHashiramaActiveVfx:Array=[];','public var FHashiramaActiveVfx:Array=[];\n public static var FHashiramaNative:Object={};',1)
    for name in ['HashiramaVfxManifest','PreloadHashiramaNative','LoadHashiramaNative','HashiramaNativeLayer','PlayHashiramaVfxAsset','ShowHashiramaVfx']:
        new=c.m.extract(production,name).replace('private static function','public static function').replace('private function','public function').replace('TRole','ProbeRole').replace('TBattleHandle.PlaybackTime','getTimer()')
        new=new.replace('trace("FOREST_DEBUG "+symbol+" frame="+frame+" total="+clip.totalFrames+" bounds="+clip.getBounds(clip));','report("FOREST_DEBUG "+symbol+" frame="+frame+" total="+clip.totalFrames+" bounds="+clip.getBounds(clip));')
        if name in ['PreloadHashiramaNative','LoadHashiramaNative','HashiramaNativeLayer']:
            source=source.replace('      public static function PreloadHashiramaVfx()',new+'\n      public static function PreloadHashiramaVfx()',1)
        else:
            old=c.m.extract(source,name)
            source=source.replace(old,new,1)
    if args.focus:
        animation=json.loads((B.parent/'hashirama-final/animation.json').read_text())
        name={'forest':'forest','cinematic':'rumbling','stress':'severe'}[args.focus]
        ident={'forest':13121009,'cinematic':13121002,'stress':13121004}[args.focus]
        names=[name,name];ids=[ident,ident];bounds=[0]
        for _ in range(4):bounds.append(bounds[-1]+len(animation['clips'][name]['assets'])*40+1000)
        source=re.sub(r'private var skills:Array=\[[^\]]+\];','private var skills:Array='+json.dumps(ids)+';',source,count=1)
        source=re.sub(r'private var clipNames:Array=\[[^\]]+\];','private var clipNames:Array='+json.dumps(names)+';',source,count=1)
        source=re.sub(r'var slots:Array=\[[^\]]+\];','var slots:Array='+json.dumps(bounds)+';',source,count=1)
        source=source.replace('slot<24','slot<4').replace('slot>=24','slot>=4').replace('slot<12?0:1','slot<2?0:1').replace('slot%12','slot%2')
        if args.focus=='forest':
            source=source.replace('var hit:int=metadata[name].hitFrames', 'if(frame>=50&&!captured["FOREST-MID-"+side]){captured["FOREST-MID-"+side]=true;saveFrame("FOREST-MID-"+side);}\n   var hit:int=metadata[name].hitFrames',1)
    dest=B/'probe-source/TApplication.as';dest.parent.mkdir(parents=True,exist_ok=True);dest.write_text(source,encoding='utf-8')
    c.ff('-onerror','abort','-importScript',B/'source.swf',B/'raster-probe.swf',dest.parent)
    raw=bytearray((B/'raster-probe.swf').read_bytes());raw[3]=21;(B/'raster-probe.swf').write_bytes(raw)
    (B/'validation/native').mkdir(parents=True,exist_ok=True)
    print('PASS',4 if args.focus else 24,'native Hashirama component cases compiled',args.focus or 'full')
if __name__=='__main__':main()
