"""Restore only the lost native Myoboku entry on the current client."""
from pathlib import Path
import importlib.util,json,re,shutil,hashlib
B=Path(__file__).resolve().parent;W=B/'recover';VERSION='2026102505'
s=importlib.util.spec_from_file_location('c',B.parent/'tsunade-asian/build-client.py');c=importlib.util.module_from_spec(s);s.loader.exec_module(c)
s=importlib.util.spec_from_file_location('r',B.parent/'tsunade-asian/release.py');r=importlib.util.module_from_spec(s);s.loader.exec_module(r)
REL=Path('Processors/Game/Lobby/TProcessorLobby.as');CLASS='Processors.Game.Lobby.TProcessorLobby'
def main():
 p=c.h.PUBLIC;canonical=p/'2026090619';current=json.loads((p/'client-release.json').read_text())['version'];old=(p/current/'TApplication.swf').read_bytes()
 assert (canonical/'TApplication.swf').read_bytes()==old
 assert c.h.swap(old)==(W/'source.swf').read_bytes(),'Current client changed'
 before=(W/'original/scripts'/REL).read_text(encoding='utf-8');source=(B/'left-verify/scripts'/REL).read_text(encoding='utf-8')
 allowed={'IllusionConstruct','IllusionUpdate'};count=0
 for name in re.findall(r'      (?:override )?(?:public|private|protected) (?:static )?function (\w+)\(',before):
  if name not in allowed:assert c.m.extract(before,name)==c.m.extract(source,name),name;count+=1
 target=W/'patched'/REL;target.parent.mkdir(parents=True,exist_ok=True);target.write_text(source,encoding='utf-8')
 c.ff('-onerror','abort','-importScript',W/'source.swf',W/'compiled.swf',W/'patched')
 raw=(W/'compiled.swf').read_bytes();assert [t for t in c.h.tags(c.h.swap(old)) if t[0]!=82]==[t for t in c.h.tags(raw) if t[0]!=82]
 c.ff('-selectclass',CLASS+',Processors.Game.Battle.Character.TRole','-export','script',W/'verify',W/'compiled.swf')
 lobby=(W/'verify/scripts'/REL).read_text(encoding='utf-8');assert 'ExternalInterface.call("openMyoboku")' in lobby
 assert 'this.FMyobokuIcon.x = anchor.x;' in lobby and 'this.FIllusionIcon.x = anchor.x + 68;' in lobby
 for name in re.findall(r'      (?:override )?(?:public|private|protected) (?:static )?function (\w+)\(',before):
  if name not in allowed:assert c.m.extract(before,name)==c.m.extract(lobby,name),name
 role=(W/'verify/scripts'/c.b.ROLE).read_text(encoding='utf-8');assert 'PlayNineTailsNativeRasengan' in role and 'NineTailsRasenganTravel' in role
 backup=W/'backups';backup.mkdir()
 for path in [canonical/'TApplication.swf',canonical/'version.swf',p/'client-release.json']:shutil.copy2(path,backup/path.name)
 rows=r.rows((p/current/'version.swf').read_bytes())
 for row in rows:
  if row[0]==b'TApplication.swf':row[1]=VERSION.encode()
 dest=p/VERSION;dest.mkdir();protected=c.h.swap(raw);manifest=r.encode(rows)
 (canonical/'TApplication.swf').write_bytes(protected);(canonical/'version.swf').write_bytes(manifest)
 (dest/'TApplication.swf').write_bytes(protected);(dest/'version.swf').write_bytes(manifest);shutil.copy2(p/current/'index.swf',dest/'index.swf')
 (p/'client-release.json').write_text(json.dumps({'version':VERSION})+'\n')
 (W/'result.json').write_text(json.dumps({'version':VERSION,'previous':current,'preservedLobbyMethods':count,'narutoNativePreserved':True,'sha256':hashlib.sha256(protected).hexdigest()},indent=2)+'\n')
 print('PASS Myoboku native entry restored, Naruto fixes preserved;',count,'other lobby methods unchanged;',VERSION)
if __name__=='__main__':main()
