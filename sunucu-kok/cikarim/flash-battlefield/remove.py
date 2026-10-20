"""Remove the custom Battlefield event from the current native client."""
from pathlib import Path
import importlib.util,re,struct,subprocess,zlib,sys
BASE=Path(__file__).resolve().parent
spec=importlib.util.spec_from_file_location('b',BASE.parent/'hashirama-final/build-client.py');b=importlib.util.module_from_spec(spec);spec.loader.exec_module(b)
h=b.h;WORK=BASE/'removed';WORK.mkdir(exist_ok=True)
JAR='E:/Vua Hai Tac Vibe/tools/ffdec/ffdec.jar'
DAILY=Path('Processors/Game/Lobby/DailyActivity/TProcessorDailyActivity.as')
def ff(*args):subprocess.run(['java','-Xmx2g','-jar',JAR,*map(str,args)],check=True)
def main():
 canonical=h.PUBLIC/'2026090619/TApplication.swf';old=canonical.read_bytes();decoded=h.swap(old)
 (WORK/'source.swf').write_bytes(decoded)
 classes='Processors.Game.Lobby.DailyActivity.TProcessorDailyActivity,Processors.Game.Lobby.TProcessorLobby,Processors.Game.TProcessorGameRoot'
 ff('-selectclass',classes,'-export','script',WORK/'original',WORK/'source.swf')
 if '--export-only' in sys.argv:return
 text=(WORK/'original/scripts'/DAILY).read_text(encoding='utf-8')
 # Remove all custom methods and storage while preserving other Daily Activity edits.
 baseline=(BASE/'original/scripts'/DAILY).read_text(encoding='utf-8')
 names=set(re.findall(r'function (?:get |set )?(\w+)\(',baseline))
 for match in reversed(list(re.finditer(r'      (?:override )?(?:public|protected|private) (?:static )?function (?:get |set )?(\w+)\(',text))):
  if match[1] not in names:text=text[:match.start()]+text[b.method_end(text,match.start()):]
 text=re.sub(r'^[ \t]*(?:public|protected|private) var (?:FField\w*|OnField\w*):[^;]+;[^\n]*\n','',text,flags=re.M)
 text=re.sub(r'^.*this\.InitField\(\);\s*','',text,flags=re.M)
 text=re.sub(r'^.*FPacketRoutines\.Register\(1841075[2-6],.*\n','',text,flags=re.M)
 # Retire all added tab branches, pollers and hide handlers as whole balanced blocks.
 while True:
  match=re.search(r'(?m)^         if\([^\n]*(?:FField\w*|FSelectTabIndex == 7)[^\n]*\)\s*\n         \{',text)
  if not match:break
  brace=text.index('{',match.start());depth=1;i=brace+1
  while depth:
   depth+=(text[i]=='{')-(text[i]=='}');i+=1
  text=text[:match.start()]+text[i:]
 assert not re.search(r'\b(?:FField\w*|FieldSend|InitField|DrawField)\b',text),'Remaining event reference: '+str([line for line in text.splitlines() if re.search(r'\b(?:FField\w*|FieldSend|InitField|DrawField)\b',line)])
 target=WORK/'patched'/DAILY;target.parent.mkdir(parents=True,exist_ok=True);target.write_text(text,encoding='utf-8')
 ff('-onerror','abort','-importScript',WORK/'source.swf',WORK/'daily.swf',WORK/'patched')
 subprocess.run(['C:/Program Files/Java/jdk-23/bin/javac.exe','-cp',JAR,'-d',str(WORK),str(BASE/'RemoveRoutes.java')],check=True)
 subprocess.run(['java','-Xmx2g','-cp',str(WORK)+';'+JAR,'RemoveRoutes',str(WORK/'daily.swf'),str(WORK/'compiled.swf')],check=True)
 ff('-selectclass',classes,'-export','script',WORK/'verify',WORK/'compiled.swf')
 for rel in [DAILY,Path('Processors/Game/Lobby/TProcessorLobby.as'),Path('Processors/Game/TProcessorGameRoot.as')]:
  verified=(WORK/'verify/scripts'/rel).read_text(encoding='utf-8')
  assert not re.search(r'\b(?:FField\w*|OnField\w*|FieldBattleActive|FieldBattleReturn|InitField)\b',verified),str(rel)
  assert '18410752' not in verified
 rebuilt=(WORK/'compiled.swf').read_bytes();assert [t for t in h.tags(decoded)if t[0]!=82]==[t for t in h.tags(rebuilt)if t[0]!=82]
 version=canonical.parent/'version.swf';raw=zlib.decompress(version.read_bytes());pos=2;parts=[raw[:2]]
 for _ in range(struct.unpack_from('<H',raw)[0]):
  n=struct.unpack_from('<H',raw,pos)[0];pos+=2;k=raw[pos:pos+n];pos+=n;n=struct.unpack_from('<H',raw,pos)[0];pos+=2;v=raw[pos:pos+n];pos+=n
  if k==b'TApplication.swf':v=b'2026101983'
  parts.extend([struct.pack('<H',len(k)),k,struct.pack('<H',len(v)),v])
 assert pos==len(raw) and canonical.read_bytes()==old
 (WORK/'backup-client.swf').write_bytes(old);(WORK/'backup-version.swf').write_bytes(version.read_bytes())
 final=h.swap(rebuilt);dest=h.PUBLIC/'2026101983/TApplication.swf';dest.parent.mkdir(exist_ok=True);dest.write_bytes(final)
 canonical.write_bytes(final);version.write_bytes(zlib.compress(b''.join(parts)))
 print('PASS Battlefield removed; all unrelated native UI assets preserved; client 2026101983')
if __name__=='__main__':main()
