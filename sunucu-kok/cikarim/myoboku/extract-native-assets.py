"""Decode Naruto's SWF wrapper and extract the original, verified Myoboku art.

The decoder follows entry.swf's util.decryptSWF. Original source bytes remain
untouched. PNGs are exported from SWF characters without repainting/resampling.
"""
from pathlib import Path
import hashlib,json,shutil,subprocess

BASE=Path(__file__).resolve().parent
ROOT=BASE.parents[2]
SOURCE=ROOT/'asset/Myoboku_Trial_UI_Assets'
OUT=ROOT/'sunucu-kok/gorsel/myoboku-native'

def decode(raw):
    if raw[:8]!=b'ZWS\0\xff\xff\xff\xff': return raw
    nibbles=raw[8:19:2]
    return bytes((nibbles[i]&15)|((nibbles[i+1]&15)<<4) for i in range(0,6,2))+raw[9:19:2]+bytes(v^(255 if i&1 else 0) for i,v in enumerate(raw[19:147]))+raw[147:]

def main():
    OUT.mkdir(exist_ok=True)
    libraries={}
    for name in ['YuanDanJiUI','TurntableUI','TurntableUI_Old','miao_backActivity']:
        source=SOURCE/'flash/operatingActivity'/(name+'.swf')
        target=BASE/'native'/(name+'.swf');target.parent.mkdir(exist_ok=True)
        target.write_bytes(decode(source.read_bytes()))
        export=BASE/'native'/('verified-'+name)
        subprocess.run(['java','-Xmx2g','-jar',str(ROOT/'.tools/ffdec/ffdec-cli.jar'),'-export','image',str(export),str(target)],check=True,stdout=subprocess.DEVNULL)
        libraries[name]=export
    mapping={
        'panel':('YuanDanJiUI','38'), 'wheel':('YuanDanJiUI','122'),
        'pointer':('YuanDanJiUI','133'), 'start':('YuanDanJiUI','170'),
        'start-hover':('YuanDanJiUI','172'), 'start-disabled':('YuanDanJiUI','174'),
        'help':('YuanDanJiUI','29'), 'help-hover':('YuanDanJiUI','31'),
        'tab':('YuanDanJiUI','275'), 'tab-selected':('YuanDanJiUI','278'),
        'tab-login':('YuanDanJiUI','274'), 'tab-trial':('YuanDanJiUI','281'),
        'tab-wheel':('YuanDanJiUI','288'), 'currency':('YuanDanJiUI','121'),
        'button':('YuanDanJiUI','107'), 'button-hover':('YuanDanJiUI','111'),
        'reward-flare':('YuanDanJiUI','188'), 'reward-frame':('miao_backActivity','24'),
        'item-frame':('TurntableUI','32'), 'item-selected':('TurntableUI_Old','129'),
    }
    manifest=[]
    for name,(library,character) in mapping.items():
        source=libraries[library]/(character+'.png');target=OUT/(name+'.png');shutil.copy2(source,target)
        manifest.append({'file':target.name,'source':library+'.swf','characterId':int(character),'sha256':hashlib.sha256(target.read_bytes()).hexdigest()})
    (OUT/'manifest.json').write_text(json.dumps(manifest,indent=2)+'\n')
    print('Verified original SWF art:',len(manifest),'images')

if __name__=='__main__':main()
