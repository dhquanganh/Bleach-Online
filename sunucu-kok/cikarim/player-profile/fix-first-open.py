"""Repair first Inspector click without rolling back current combat/client fixes."""
from pathlib import Path
import argparse,importlib.util,re,subprocess,struct,zlib,shutil
BASE=Path(__file__).resolve().parent
spec=importlib.util.spec_from_file_location('b',BASE.parent/'hashirama-final/build-client.py');b=importlib.util.module_from_spec(spec);spec.loader.exec_module(b)
h=b.h;INSPECTOR=Path('Processors/Game/Lobby/Inspector/TProcessorInspector.as');WINDOW=Path('Processors/Game/Lobby/Common/Players/TProcessorWindowPlayerAssets.as');VERSION=b'2026101975'
def method(s,n):
 start=re.search(r'      (?:override )?(?:public|protected|private) (?:static )?function '+n+r'\(',s).start();return s[start:b.method_end(s,start)]
def normalized_expr(s):
 # FFDec rewrites these equivalent expressions when recompiling this older UI.
 s=s.replace('= NaN;','= Number(NaN);')
 s=re.sub(r'(_loc\d+_) = \1 \+ \((.*)\);',r'\1 += \2;',s)
 s=re.sub(r'(_loc\d+_) = \1 \+ (.*);',r'\1 += \2;',s)
 s=re.sub(r'Number\(([^;\n]+)\)\.toFixed',r'(\1).toFixed',s)
 s=re.sub(r'String\((.*\.toFixed\(\d+\))\)',r'\1',s)
 return s
def main():
 p=argparse.ArgumentParser();p.add_argument('--ffdec',required=True);p.add_argument('--reuse',action='store_true');a=p.parse_args();work=BASE/'first-open';work.mkdir(exist_ok=True)
 canonical=h.PUBLIC/'2026090619/TApplication.swf';old=canonical.read_bytes();decoded=h.swap(old)
 source=work/'source.swf'
 if a.reuse:assert source.read_bytes()==decoded,'Live client differs from verified input'
 else:source.write_bytes(decoded)
 def ff(*args):subprocess.run(['java','-Xmx2g','-jar',a.ffdec,*map(str,args)],check=True)
 extras=[b.ROLE,Path('Processors/Game/Battle/TBattleHandle.as'),Path('Processors/Game/Battle/Effect/TEffectControl.as')]
 classes=','.join(str(r.with_suffix('')).replace('\\','.').replace('/','.') for r in [INSPECTOR,WINDOW]+extras)
 if not a.reuse:ff('-selectclass',classes,'-export','script',work/'original',source)
 originals={rel:(work/'original/scripts'/rel).read_text() for rel in [INSPECTOR,WINDOW]}
 inspector=originals[INSPECTOR];oldmethod=method(inspector,'RequestShowHero');updated=oldmethod
 for window in ['FProcessorWindowPlayerAssets','FProcessorWindowInventoryInfor']:
  call='         this.'+window+'.Hide();';assert call in updated
  updated=updated.replace(call,'         if(this.'+window+'.Visible)this.'+window+'.Hide();',1)
 inspector=inspector.replace(oldmethod,updated,1)
 window=originals[WINDOW];oldmethod=method(window,'Reset');pos=oldmethod.index('{')+1
 updated=oldmethod[:pos]+'\n         if(this.FHeros==null)return;'+oldmethod[pos:]
 window=window.replace(oldmethod,updated,1)
 for rel,text in [(INSPECTOR,inspector),(WINDOW,window)]:
  target=work/'patched'/rel;target.parent.mkdir(parents=True,exist_ok=True);target.write_text(text)
 output=work/'compiled.swf'
 if not a.reuse:ff('-onerror','abort','-importScript',source,output,work/'patched')
 rebuilt=output.read_bytes()
 assert [t for t in h.tags(decoded)if t[0]!=82]==[t for t in h.tags(rebuilt)if t[0]!=82]
 if not a.reuse:ff('-selectclass',classes,'-export','script',work/'verify',output)
 for rel,allowed in [(INSPECTOR,{'RequestShowHero'}),(WINDOW,{'Reset'})]:
  verified=(work/'verify/scripts'/rel).read_text()
  for name in re.findall(r'      (?:override )?(?:public|protected|private) (?:static )?function (\w+)\(',originals[rel]):
   if name not in allowed:assert normalized_expr(method(originals[rel],name))==normalized_expr(method(verified,name)),name
 for rel in extras:assert (work/'original/scripts'/rel).read_bytes()==(work/'verify/scripts'/rel).read_bytes(),rel
 assert canonical.read_bytes()==old
 version=canonical.parent/'version.swf';raw=zlib.decompress(version.read_bytes());pos=2;parts=[raw[:2]];found=0
 for _ in range(struct.unpack_from('<H',raw)[0]):
  n=struct.unpack_from('<H',raw,pos)[0];pos+=2;k=raw[pos:pos+n];pos+=n;n=struct.unpack_from('<H',raw,pos)[0];pos+=2;v=raw[pos:pos+n];pos+=n
  if k==b'TApplication.swf':v=VERSION;found+=1
  parts.extend([struct.pack('<H',len(k)),k,struct.pack('<H',len(v)),v])
 assert found==1 and pos==len(raw)
 backup=work/'backups';backup.mkdir(exist_ok=True)
 for f in [canonical,version]:
  if not (backup/f.name).exists():shutil.copy2(f,backup/f.name)
 protected=h.swap(rebuilt);dest=h.PUBLIC/VERSION.decode()/'TApplication.swf';dest.parent.mkdir(exist_ok=True)
 dest.write_bytes(protected);canonical.write_bytes(protected);version.write_bytes(zlib.compress(b''.join(parts)))
 print('PASS Inspector first-open fix',VERSION.decode(),'; only request/reset changed; combat, no-shake, UI and all other Inspector methods unchanged')
if __name__=='__main__':main()
