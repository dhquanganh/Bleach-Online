"""Opt-in rectangle decoding for Kabuto's type-127 compact PAK atlases."""
from pathlib import Path
import argparse, importlib.util, subprocess

BASE=Path(__file__).resolve().parent
CLASS=Path('Foundation/Decoder/Pak/TPakDecoder.as')

def patch(source):
    if 'FKabutoSourceRects' in source:return source
    source=source.replace('      protected var FSizes:', '      protected var FKabutoSourceRects:Array = [];\n\n      protected var FSizes:')
    source=source.replace('         this.FSizes.length = 0;', '         this.FSizes.length = 0;\n         this.FKabutoSourceRects.length = 0;')
    source=source.replace('            this.FSizes.push(_loc7_);', '            this.FSizes.push(_loc7_);\n            this.FKabutoSourceRects.push(new Rectangle(_loc2_,_loc3_,_loc4_,_loc5_));')
    source=source.replace('_loc7_ = new Rectangle(this.FDestinationX,0,_loc2_.X,_loc2_.Y);', '_loc7_ = this.FType == 127 ? this.FKabutoSourceRects[this.FTraversalIndex] : new Rectangle(this.FDestinationX,0,_loc2_.X,_loc2_.Y);')
    source=source.replace('new Rectangle(this.FDestinationX,_loc3_.height / 2,_loc2_.X,_loc2_.Y)', 'new Rectangle(_loc7_.x,_loc7_.y + _loc3_.height / 2,_loc2_.X,_loc2_.Y)')
    assert source.count('FKabutoSourceRects')==4
    return source

def prepare(ffdec,source,folder):
    subprocess.run(['java','-jar',str(ffdec),'-selectclass','Foundation.Decoder.Pak.TPakDecoder','-export','script',str(folder/'original'),str(source)],check=True,stdout=subprocess.DEVNULL)
    target=folder/'patched'/CLASS;target.parent.mkdir(parents=True,exist_ok=True)
    target.write_text(patch((folder/'original/scripts'/CLASS).read_text(encoding='utf-8')),encoding='utf-8')
    return target

def main():
    p=argparse.ArgumentParser();p.add_argument('--ffdec',required=True);args=p.parse_args()
    spec=importlib.util.spec_from_file_location('helper',BASE.parent/'naruto-sage/verify-client.py');helper=importlib.util.module_from_spec(spec);spec.loader.exec_module(helper)
    canonical=helper.PUBLIC/'2026090619/TApplication.swf';raw=canonical.read_bytes()
    source=BASE/'decoder-source.swf';source.write_bytes(helper.swap(raw))
    target=prepare(args.ffdec,source,BASE/'decoder')
    output=BASE/'decoder-compiled.swf'
    subprocess.run(['java','-Xmx2g','-jar',args.ffdec,'-onerror','abort','-importScript',str(source),str(output),str(target.parents[3])],check=True)
    assert [t for t in helper.tags(source.read_bytes()) if t[0]!=82]==[t for t in helper.tags(output.read_bytes()) if t[0]!=82]
    assert canonical.read_bytes()==raw
    protected=helper.swap(output.read_bytes());canonical.write_bytes(protected)
    (helper.PUBLIC/'2026101813/TApplication.swf').write_bytes(protected)
    print('PASS type-127 decoder installed; legacy sequential atlases retain their behavior')

if __name__=='__main__':main()
