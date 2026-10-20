"""Anchor the inspected partner-star badge to the inner character panel."""
from pathlib import Path
import importlib.util,re,struct,subprocess,zlib
BASE=Path(__file__).resolve().parent
spec=importlib.util.spec_from_file_location('b',BASE.parent/'hashirama-final/build-client.py');b=importlib.util.module_from_spec(spec);spec.loader.exec_module(b)
h=b.h;VERSION=b'2026101981';REL=Path('Processors/Game/Lobby/Common/Players/TProcessorWindowPlayerAssets.as')
def method(text,name):
 start=re.search(r'      (?:override )?(?:public|protected|private) (?:static )?function '+name+r'\(',text).start();return text[start:b.method_end(text,start)]
def normalized(text):
 text=text.replace('= NaN;','= Number(NaN);')
 text=re.sub(r'(_loc\d+_) = \1 \+ \((.*)\);',r'\1 += \2;',text)
 text=re.sub(r'(_loc\d+_) = \1 \+ (.*);',r'\1 += \2;',text)
 text=re.sub(r'Number\(([^;\n]+)\)\.toFixed',r'(\1).toFixed',text)
 return text
def main():
 jar='E:/Vua Hai Tac Vibe/tools/ffdec/ffdec.jar';work=BASE/'profile-star-anchor';work.mkdir(exist_ok=True)
 canonical=h.PUBLIC/'2026090619/TApplication.swf';protected=canonical.read_bytes();source=h.swap(protected);(work/'source.swf').write_bytes(source)
 cls=str(REL.with_suffix('')).replace('\\','/').replace('/','.')
 def ff(*args):subprocess.run(['java','-Xmx2g','-jar',jar,*map(str,args)],check=True)
 ff('-selectclass',cls,'-export','script',work/'original',work/'source.swf')
 original=(work/'original/scripts'/REL).read_text(encoding='utf-8');patched=original
 old=method(patched,'Resources_UIDispatch');assert 'this.addChild(this.FProfileStarMarker);' in old
 old=old.replace('this.addChild(this.FProfileStarMarker);','_loc3_.addChild(this.FProfileStarMarker);',1)
 start=re.search(r'      protected function Resources_UIDispatch\(',patched).start();patched=patched[:start]+old+patched[b.method_end(patched,start):]
 old=method(patched,'RenderHeroChange');assert 'this.setChildIndex(this.FProfileStarMarker,this.numChildren - 1);' in old
 old=old.replace('this.setChildIndex(this.FProfileStarMarker,this.numChildren - 1);','this.FProfileStarMarker.parent.setChildIndex(this.FProfileStarMarker,this.FProfileStarMarker.parent.numChildren - 1);',1)
 start=re.search(r'      protected function RenderHeroChange\(',patched).start();patched=patched[:start]+old+patched[b.method_end(patched,start):]
 target=work/'patched'/REL;target.parent.mkdir(parents=True,exist_ok=True);target.write_text(patched,encoding='utf-8')
 ff('-onerror','abort','-importScript',work/'source.swf',work/'compiled.swf',work/'patched')
 rebuilt=(work/'compiled.swf').read_bytes();assert [t for t in h.tags(source)if t[0]!=82]==[t for t in h.tags(rebuilt)if t[0]!=82]
 ff('-selectclass',cls,'-export','script',work/'verify',work/'compiled.swf');verified=(work/'verify/scripts'/REL).read_text(encoding='utf-8')
 for name in re.findall(r'      (?:override )?(?:public|protected|private) (?:static )?function (\w+)\(',original):
  if name not in {'Resources_UIDispatch','RenderHeroChange'}:assert normalized(method(original,name))==normalized(method(verified,name)),name
 assert '_loc3_.addChild(this.FProfileStarMarker)' in verified
 assert 'this.FProfileStarMarker.parent.setChildIndex' in verified
 assert 'this.FProfileStarMarker.x = 10' in verified and 'this.FProfileStarMarker.y = 218' in verified
 version=canonical.parent/'version.swf';raw=zlib.decompress(version.read_bytes());pos=2;parts=[raw[:2]];found=0
 for _ in range(struct.unpack_from('<H',raw)[0]):
  n=struct.unpack_from('<H',raw,pos)[0];pos+=2;k=raw[pos:pos+n];pos+=n;n=struct.unpack_from('<H',raw,pos)[0];pos+=2;v=raw[pos:pos+n];pos+=n
  if k==b'TApplication.swf':v=VERSION;found+=1
  parts.extend([struct.pack('<H',len(k)),k,struct.pack('<H',len(v)),v])
 assert found==1 and pos==len(raw) and canonical.read_bytes()==protected
 (work/'original-protected.swf').write_bytes(protected);(work/'original-version.swf').write_bytes(version.read_bytes())
 final=h.swap(rebuilt);dest=h.PUBLIC/VERSION.decode()/'TApplication.swf';dest.parent.mkdir(exist_ok=True)
 dest.write_bytes(final);canonical.write_bytes(final);version.write_bytes(zlib.compress(b''.join(parts)))
 print('PASS Inspector star badge anchored to inner character panel',VERSION.decode())
if __name__=='__main__':main()
