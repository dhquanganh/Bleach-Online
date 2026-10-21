"""Update only the current Reincarnation window's fragment requirement."""
from pathlib import Path
import importlib.util,json,re,shutil,struct,zlib
B=Path(__file__).resolve().parent
s=importlib.util.spec_from_file_location('c',B.parent/'itachi-rtn/build-client.py');c=importlib.util.module_from_spec(s);s.loader.exec_module(c)
CLASS='Processors.Game.Lobby.Rebirth.TProcessorWindowHeroRebirth';REL=Path(CLASS.replace('.','/')+'.as');VERSION='2026102109'
def main():
 canonical=c.h.PUBLIC/'2026090619/TApplication.swf';old=canonical.read_bytes();source=c.h.swap(old);(B/'source.swf').write_bytes(source)
 c.ff('-selectclass',CLASS,'-export','script',B/'original',B/'source.swf')
 before=(B/'original/scripts'/REL).read_text(encoding='utf-8');after=before
 for oldtext,newtext,count in [('Reincarnation requires 50 fragments','Reincarnation requires 100 fragments',2),('this.FragmentOwned() >= 50','this.FragmentOwned() >= 100',1),('this.FFragmentLine.text = "50 "','this.FFragmentLine.text = "100 "',1),('GetInventoryByIDAmount(id,50,inv)','GetInventoryByIDAmount(id,100,inv)',1)]:
  assert after.count(oldtext)==count,(oldtext,after.count(oldtext));after=after.replace(oldtext,newtext)
 dest=B/'patched'/REL;dest.parent.mkdir(parents=True,exist_ok=True);dest.write_text(after,encoding='utf-8')
 c.ff('-onerror','abort','-importScript',B/'source.swf',B/'compiled.swf',B/'patched')
 rebuilt=(B/'compiled.swf').read_bytes();assert [t for t in c.h.tags(source) if t[0]!=82]==[t for t in c.h.tags(rebuilt) if t[0]!=82]
 c.ff('-selectclass',CLASS,'-export','script',B/'verify',B/'compiled.swf')
 verified=(B/'verify/scripts'/REL).read_text(encoding='utf-8');allowed={'HasFragments','UpdateFragmentRequirement'};checked=0
 # Only methods containing one of the five replaced requirement expressions may differ.
 for name in re.findall(r'      (?:override )?(?:public|private|protected) (?:static )?function (\w+)\(',before):
  oldmethod=c.m.extract(before,name);expected=c.m.extract(after,name);actual=c.m.extract(verified,name)
  if oldmethod==expected:assert oldmethod==actual,name;checked+=1
 assert 'this.FragmentOwned() >= 100' in verified and 'GetInventoryByIDAmount(id,100,inv)' in verified
 manifest=canonical.parent/'version.swf';raw=zlib.decompress(manifest.read_bytes());pos=2;parts=[raw[:2]];found=0
 for _ in range(struct.unpack_from('<H',raw)[0]):
  n=struct.unpack_from('<H',raw,pos)[0];pos+=2;k=raw[pos:pos+n];pos+=n;n=struct.unpack_from('<H',raw,pos)[0];pos+=2;v=raw[pos:pos+n];pos+=n
  if k==b'TApplication.swf':v=VERSION.encode();found+=1
  parts.extend([struct.pack('<H',len(k)),k,struct.pack('<H',len(v)),v])
 assert pos==len(raw) and found==1 and canonical.read_bytes()==old
 backup=B/'backups';backup.mkdir(exist_ok=True)
 for path in [canonical,manifest]:
  if not (backup/path.name).exists():shutil.copy2(path,backup/path.name)
 protected=c.h.swap(rebuilt);dest=c.h.PUBLIC/VERSION/'TApplication.swf';dest.parent.mkdir(exist_ok=True);dest.write_bytes(protected);canonical.write_bytes(protected);manifest.write_bytes(zlib.compress(b''.join(parts)))
 (B/'result.json').write_text(json.dumps({'version':VERSION,'fragmentCost':100,'unchangedWindowMethods':checked,'changedClass':CLASS,'texturesChanged':False},indent=2));print('PASS client',VERSION,'Reincarnation UI requires/displays 100 partner fragments')
if __name__=='__main__':main()
