"""Render the installed game's MC_Information and its Confirm button unchanged.

Only the placeholder text fields are omitted; live reward text is HTML above
the original rendered art. Source game SWF is never changed.
"""
from pathlib import Path
import subprocess,xml.etree.ElementTree as ET,shutil,json,hashlib
from PIL import Image
BASE=Path(__file__).resolve().parent
ROOT=BASE.parents[2]
SOURCE=ROOT/'sunucu-kok/kaynak/login.gogames.me/public/2017112917/Resources/Swf/Common/00000000.swf'
WORK=BASE/'game-ui'
OUT=ROOT/'sunucu-kok/gorsel/myoboku-native'
def ff(*args):
    subprocess.run(['java','-Xmx2g','-jar',str(ROOT/'.tools/ffdec/ffdec-cli.jar'),*map(str,args)],check=True,stdout=subprocess.DEVNULL)
def main():
    WORK.mkdir(exist_ok=True)
    xml=WORK/'notice.xml';ff('-swf2xml',SOURCE,xml)
    tree=ET.parse(xml)
    for item in tree.getroot().iter('item'):
        if item.get('type')=='DefineSpriteTag' and item.get('spriteId') in ['346','320']:
            tags=item.find('subTags')
            for tag in list(tags):
                if tag.get('name') in ['TF_Text','TF_BtnOkCaption']:tags.remove(tag)
    tree.write(xml,encoding='utf-8',xml_declaration=True)
    swf=WORK/'notice.swf';ff('-xml2swf',xml,swf)
    ff('-zoom','1.5','-selectid','346,320','-export','sprite',WORK/'notice-render',swf)
    ff('-selectid','138','-export','image',WORK/'notice-images',SOURCE)
    mapping={
      'game-notice':WORK/'notice-render/DefineSprite_346_MC_Information/1.png',
      'game-notice-button':WORK/'notice-render/DefineSprite_320/1.png',
      'game-notice-button-hover':WORK/'notice-render/DefineSprite_320/2.png',
      'game-item-slot':WORK/'notice-images/138.jpg',
    }
    manifest=[]
    for name,p in mapping.items():
        if not p.exists() and name.startswith('game-notice-button'):
            p=next((WORK/'notice-render').glob('DefineSprite_320*'))/p.name
        dest=OUT/(name+'.png')
        if p.suffix=='.jpg':Image.open(p).save(dest)
        else:shutil.copy2(p,dest)
        manifest.append({'file':dest.name,'source':str(SOURCE.relative_to(ROOT)),'sourceSha256':hashlib.sha256(SOURCE.read_bytes()).hexdigest(),'symbol':'MC_Information' if name=='game-notice' else 'Btn_Ok' if name.startswith('game-notice-button') else '138','sha256':hashlib.sha256(dest.read_bytes()).hexdigest()})
    (OUT/'game-notice-manifest.json').write_text(json.dumps(manifest,indent=2)+'\n')
    print('PASS: original game notification and slot art')
if __name__=='__main__':main()
