"""Rebuild the Naruto client patch from a native baseline with JPEXS."""
from pathlib import Path
import argparse, subprocess
import importlib.util
BASE=Path(__file__).resolve().parent
spec=importlib.util.spec_from_file_location('verify_client',BASE/'verify-client.py')
helper=importlib.util.module_from_spec(spec);spec.loader.exec_module(helper)
def main():
    parser=argparse.ArgumentParser();parser.add_argument('--ffdec',required=True);parser.add_argument('--baseline',type=Path);parser.add_argument('--install',action='store_true');opts=parser.parse_args()
    baseline=opts.baseline or helper.PUBLIC/'2026090619/TApplication.swf'
    decoded=BASE/'client-decoded.swf';decoded.write_bytes(helper.swap(baseline.read_bytes()))
    def ffdec(*args):subprocess.run(['java','-Xmx2g','-jar',opts.ffdec,*map(str,args)],check=True)
    ffdec('-selectclass','Processors.Game.Battle.Character.TRole','-export','script',BASE/'original',decoded)
    name=Path('Processors/Game/Battle/Character/TRole.as');text=(BASE/'original/scripts'/name).read_text(encoding='utf-8')
    if '19000100' in text and '11120902' in text:
        print('Naruto clone revival and combo labels are already installed.');return
    text=text.replace('   import flash.display.*;','   import flash.display.*;\n   import flash.text.TextField;\n   import flash.text.TextFormat;')
    anchor='''         if(param1 < 0)
         {
            CurHealth -= param1;
         }'''
    assert text.count(anchor)==1
    text=text.replace(anchor,'''         if(param1 < 0)
         {
'''+(BASE/'clone-revive.as.txt').read_text(encoding='utf-8')+'''            CurHealth -= param1;
         }''')
    anchor='''      public function AddTextEffectByCMD(param1:TTargetInfo) : void
      {
'''
    assert text.count(anchor)==1
    text=text.replace(anchor,anchor+(BASE/'combo-label.as.txt').read_text(encoding='utf-8'))
    target=BASE/'patched'/name;target.parent.mkdir(parents=True,exist_ok=True);target.write_text(text,encoding='utf-8')
    ffdec('-onerror','abort','-importScript',decoded,BASE/'client-compiled.swf',BASE/'patched')
    args=['python',str(BASE/'verify-client.py'),'--ffdec',opts.ffdec]
    if opts.install:args.append('--install')
    subprocess.run(args,check=True)
if __name__=='__main__':main()
