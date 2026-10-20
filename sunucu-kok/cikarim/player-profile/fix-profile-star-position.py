"""Separate Modify Lab partner stars from the original ChangeSchedule star row."""
from pathlib import Path
import importlib.util,re,struct,subprocess,zlib
BASE=Path(__file__).resolve().parent
spec=importlib.util.spec_from_file_location('b',BASE.parent/'hashirama-final/build-client.py');b=importlib.util.module_from_spec(spec);spec.loader.exec_module(b)
h=b.h;VERSION=b'2026101979';REL=Path('Processors/Game/Lobby/Common/Players/TProcessorWindowPlayerAssets.as')
def method(text,name):
 start=re.search(r'      (?:override )?(?:public|protected|private) (?:static )?function '+name+r'\(',text).start();return text[start:b.method_end(text,start)]
def normalized(text):
 text=text.replace('= NaN;','= Number(NaN);')
 text=re.sub(r'(_loc\d+_) = \1 \+ \((.*)\);',r'\1 += \2;',text)
 text=re.sub(r'(_loc\d+_) = \1 \+ (.*);',r'\1 += \2;',text)
 text=re.sub(r'Number\(([^;\n]+)\)\.toFixed',r'(\1).toFixed',text)
 return text
def main():
 jar='E:/Vua Hai Tac Vibe/tools/ffdec/ffdec.jar';work=BASE/'profile-star-position';work.mkdir(exist_ok=True)
 canonical=h.PUBLIC/'2026090619/TApplication.swf';protected=canonical.read_bytes();source=h.swap(protected);(work/'source.swf').write_bytes(source)
 cls=str(REL.with_suffix('')).replace('\\','/').replace('/','.')
 def ff(*args):subprocess.run(['java','-Xmx2g','-jar',jar,*map(str,args)],check=True)
 ff('-selectclass',cls,'-export','script',work/'original',work/'source.swf')
 original=(work/'original/scripts'/REL).read_text(encoding='utf-8');patched=original
 field='      protected var FProfileStarBadge:TextField;'
 assert field in patched;patched=patched.replace(field,'      protected var FProfileStarMarker:Sprite;\n      \n      protected var FProfileStarIcon:Bitmap;\n      \n'+field,1)
 old=method(patched,'Resources_UIDispatch')
 remove='''         this.FProfileStarBadge = new TextField();
         this.FProfileStarBadge.defaultTextFormat = new TextFormat("Arial",15,16765275,true);
         this.FProfileStarBadge.x = 112;
         this.FProfileStarBadge.y = -4;
         this.FProfileStarBadge.width = 48;
         this.FProfileStarBadge.height = 24;
         this.FProfileStarBadge.mouseEnabled = false;
         this.FHeroChangeStar.addChild(this.FProfileStarBadge);
'''
 assert remove in old;old=old.replace(remove,'',1)
 needle='''            _loc1_++;
         }
         this.FChangeLevelNames ='''
 add='''            _loc1_++;
         }
         this.FProfileStarMarker = new Sprite();
         this.FProfileStarMarker.x = 10;
         this.FProfileStarMarker.y = 185;
         this.FProfileStarMarker.mouseEnabled = false;
         this.FProfileStarMarker.mouseChildren = false;
         _loc3_.addChild(this.FProfileStarMarker);
         _loc6_ = new BitmapData(18,18,true,0);
         _loc6_.draw(this.FHeroChangeLightStars[0]);
         this.FProfileStarIcon = new Bitmap(_loc6_);
         this.FProfileStarMarker.addChild(this.FProfileStarIcon);
         this.FProfileStarBadge = new TextField();
         this.FProfileStarBadge.defaultTextFormat = new TextFormat("Arial",15,16765275,true);
         this.FProfileStarBadge.x = 22;
         this.FProfileStarBadge.y = -2;
         this.FProfileStarBadge.width = 52;
         this.FProfileStarBadge.height = 24;
         this.FProfileStarBadge.mouseEnabled = false;
         this.FProfileStarMarker.addChild(this.FProfileStarBadge);
         this.FChangeLevelNames ='''
 assert needle in old;old=old.replace(needle,add,1)
 start=re.search(r'      protected function Resources_UIDispatch\(',patched).start();patched=patched[:start]+old+patched[b.method_end(patched,start):]
 old=method(patched,'RenderHeroChange')
 old=old.replace('            this.FHeroChangeStar.visible = false;','            this.FHeroChangeStar.visible = false;\n            this.FProfileStarMarker.visible = false;',1)
 old=old.replace('         this.FProfileStarBadge.visible = true;','         this.FProfileStarMarker.visible = true;',1)
 old=old.replace('this.FHeroChangeLightStars[_loc1_].visible = _loc1_ < Math.min(MaxStarNum,_loc5_);','this.FHeroChangeLightStars[_loc1_].visible = _loc1_ < _loc4_.ChangeSchedule;',1)
 start=re.search(r'      protected function RenderHeroChange\(',patched).start();patched=patched[:start]+old+patched[b.method_end(patched,start):]
 target=work/'patched'/REL;target.parent.mkdir(parents=True,exist_ok=True);target.write_text(patched,encoding='utf-8')
 ff('-onerror','abort','-importScript',work/'source.swf',work/'compiled.swf',work/'patched')
 rebuilt=(work/'compiled.swf').read_bytes();assert [t for t in h.tags(source)if t[0]!=82]==[t for t in h.tags(rebuilt)if t[0]!=82]
 ff('-selectclass',cls,'-export','script',work/'verify',work/'compiled.swf');verified=(work/'verify/scripts'/REL).read_text(encoding='utf-8')
 for name in re.findall(r'      (?:override )?(?:public|protected|private) (?:static )?function (\w+)\(',original):
  if name not in {'Resources_UIDispatch','RenderHeroChange'}:assert normalized(method(original,name))==normalized(method(verified,name)),name
 assert 'this.FProfileStarMarker.y = 185' in verified
 assert 'this.FProfileStarBadge.text = "x " + _loc5_' in verified
 assert 'this.FHeroChangeLightStars[_loc1_].visible = _loc1_ < _loc4_.ChangeSchedule' in verified
 version=canonical.parent/'version.swf';raw=zlib.decompress(version.read_bytes());pos=2;parts=[raw[:2]];found=0
 for _ in range(struct.unpack_from('<H',raw)[0]):
  n=struct.unpack_from('<H',raw,pos)[0];pos+=2;k=raw[pos:pos+n];pos+=n;n=struct.unpack_from('<H',raw,pos)[0];pos+=2;v=raw[pos:pos+n];pos+=n
  if k==b'TApplication.swf':v=VERSION;found+=1
  parts.extend([struct.pack('<H',len(k)),k,struct.pack('<H',len(v)),v])
 assert found==1 and pos==len(raw) and canonical.read_bytes()==protected
 (work/'original-protected.swf').write_bytes(protected);(work/'original-version.swf').write_bytes(version.read_bytes())
 final=h.swap(rebuilt);dest=h.PUBLIC/VERSION.decode()/'TApplication.swf';dest.parent.mkdir(exist_ok=True)
 dest.write_bytes(final);canonical.write_bytes(final);version.write_bytes(zlib.compress(b''.join(parts)))
 print('PASS separate bottom Modify Lab stars',VERSION.decode(),'; original top ChangeSchedule stars restored')
if __name__=='__main__':main()
