"""Render the inspected account's partner-star counts and restore local counts on close."""
from pathlib import Path
import importlib.util,re,shutil,struct,subprocess,zlib
BASE=Path(__file__).resolve().parent
spec=importlib.util.spec_from_file_location('b',BASE.parent/'hashirama-final/build-client.py');b=importlib.util.module_from_spec(spec);spec.loader.exec_module(b)
h=b.h;VERSION=b'2026101977'
INSPECTOR=Path('Processors/Game/Lobby/Inspector/TProcessorInspector.as')
WINDOW=Path('Processors/Game/Lobby/Common/Players/TProcessorWindowPlayerAssets.as')
def method(text,name):
 start=re.search(r'      (?:override )?(?:public|protected|private) (?:static )?function '+name+r'\(',text).start()
 return text[start:b.method_end(text,start)]
def normalized(text):
 text=text.replace('= NaN;','= Number(NaN);')
 text=re.sub(r'(_loc\d+_) = \1 \+ \((.*)\);',r'\1 += \2;',text)
 text=re.sub(r'(_loc\d+_) = \1 \+ (.*);',r'\1 += \2;',text)
 text=re.sub(r'Number\(([^;\n]+)\)\.toFixed',r'(\1).toFixed',text)
 return text
def main():
 jar='E:/Vua Hai Tac Vibe/tools/ffdec/ffdec.jar';work=BASE/'profile-stars';work.mkdir(exist_ok=True)
 canonical=h.PUBLIC/'2026090619/TApplication.swf';protected=canonical.read_bytes();source=h.swap(protected);(work/'source.swf').write_bytes(source)
 classes=','.join(str(x.with_suffix('')).replace('\\','/').replace('/','.') for x in [INSPECTOR,WINDOW])
 def ff(*args):subprocess.run(['java','-Xmx2g','-jar',jar,*map(str,args)],check=True)
 ff('-selectclass',classes,'-export','script',work/'original',work/'source.swf')
 originals={rel:(work/'original/scripts'/rel).read_text(encoding='utf-8') for rel in [INSPECTOR,WINDOW]}
 inspector=originals[INSPECTOR];old=method(inspector,'PerformPacket_SC_CharInfoRet')
 updated=old.replace('         var _loc3_:String = null;','         var _loc3_:String = null;\n         var _loc4_:uint = 0;\n         var _loc5_:uint = 0;')
 needle='         this.FProcessorWindowPlayerAssets.KnifeOfKillSoulID = param1.Data.readUnsignedInt();'
 addition=needle+'\n         Processors.Game.Lobby.HeroChange.TProcessorWindowHeroChangeMainUI.StarCounts = {};\n         _loc4_ = param1.Data.readUnsignedShort();\n         _loc5_ = 0;\n         while(_loc5_ < _loc4_)\n         {\n            Processors.Game.Lobby.HeroChange.TProcessorWindowHeroChangeMainUI.StarCounts[String(param1.Data.readUnsignedInt())] = int(param1.Data.readUnsignedByte());\n            _loc5_++;\n         }'
 assert needle in updated;updated=updated.replace(needle,addition,1);inspector=inspector.replace(old,updated,1)
 window=originals[WINDOW];old=method(window,'ButtonCloseOnClick');brace=old.index('{')+1
 updated=old[:brace]+'\n         Processors.Game.Lobby.HeroChange.TProcessorWindowHeroChangeMainUI.RequestStarInfo();'+old[brace:]
 window=window.replace(old,updated,1)
 previous=work/'source.swf'
 for index,(rel,text) in enumerate([(INSPECTOR,inspector),(WINDOW,window)]):
  folder=work/f'patch-{index}';target=folder/rel;target.parent.mkdir(parents=True,exist_ok=True);target.write_text(text,encoding='utf-8')
  output=work/('compiled.swf' if index==1 else 'phase.swf');ff('-onerror','abort','-importScript',previous,output,folder);previous=output
 rebuilt=(work/'compiled.swf').read_bytes();assert [t for t in h.tags(source)if t[0]!=82]==[t for t in h.tags(rebuilt)if t[0]!=82]
 ff('-selectclass',classes,'-export','script',work/'verify',work/'compiled.swf')
 allowed={INSPECTOR:{'PerformPacket_SC_CharInfoRet'},WINDOW:{'ButtonCloseOnClick'}}
 for rel in [INSPECTOR,WINDOW]:
  verified=(work/'verify/scripts'/rel).read_text(encoding='utf-8')
  for name in re.findall(r'      (?:override )?(?:public|protected|private) (?:static )?function (\w+)\(',originals[rel]):
   if name not in allowed[rel]:assert normalized(method(originals[rel],name))==normalized(method(verified,name)),name
 check=(work/'verify/scripts'/INSPECTOR).read_text(encoding='utf-8');assert 'StarCounts[String(param1.Data.readUnsignedInt())]' in check
 version=canonical.parent/'version.swf';raw=zlib.decompress(version.read_bytes());pos=2;parts=[raw[:2]];found=0
 for _ in range(struct.unpack_from('<H',raw)[0]):
  n=struct.unpack_from('<H',raw,pos)[0];pos+=2;k=raw[pos:pos+n];pos+=n;n=struct.unpack_from('<H',raw,pos)[0];pos+=2;v=raw[pos:pos+n];pos+=n
  if k==b'TApplication.swf':v=VERSION;found+=1
  parts.extend([struct.pack('<H',len(k)),k,struct.pack('<H',len(v)),v])
 assert found==1 and pos==len(raw) and canonical.read_bytes()==protected
 (work/'original-protected.swf').write_bytes(protected);(work/'original-version.swf').write_bytes(version.read_bytes())
 final=h.swap(rebuilt);dest=h.PUBLIC/VERSION.decode()/'TApplication.swf';dest.parent.mkdir(exist_ok=True)
 dest.write_bytes(final);canonical.write_bytes(final);version.write_bytes(zlib.compress(b''.join(parts)))
 print('PASS profile partner stars',VERSION.decode(),'; profile map rendered and local star map refreshed on close')
if __name__=='__main__':main()
