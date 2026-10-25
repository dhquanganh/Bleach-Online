"""Publish only the corrected Naruto client/textures with fresh resource URLs."""
from pathlib import Path
import importlib.util,json,shutil
B=Path(__file__).resolve().parent;W=B/'scale-alignment';VERSION='2026102503'
def main():
 s=importlib.util.spec_from_file_location('repair',B/'repair-alignment.py');m=importlib.util.module_from_spec(s);s.loader.exec_module(m);c=m.c
 probe=B/'validation/native/result.json';result=json.loads(probe.read_text());assert result['completed'] and result['cases']==10 and not result['errors'] and result['remainingLayers']==0
 assert probe.stat().st_mtime>(W/'compiled.swf').stat().st_mtime,'Run the final native probe after compiling'
 canonical=c.h.PUBLIC/'2026090619';old=(canonical/'TApplication.swf').read_bytes();assert c.h.swap(old)==(W/'source.swf').read_bytes(),'Current client changed'
 active=json.loads((c.h.PUBLIC/'client-release.json').read_text())['version'];assert old==(c.h.PUBLIC/active/'TApplication.swf').read_bytes(),'Canonical client differs from active release; use the active release source'
 backup=W/'publish-backups';backup.mkdir()
 for path in [canonical/'TApplication.swf',canonical/'version.swf',c.h.PUBLIC/'client-release.json']:shutil.copy2(path,backup/path.name)
 source=(B.parent/'tsunade-asian/release.py').read_text();source=source[:source.index("if __name__=='__main__':")]
 source=source.replace('ids=[11120992,11120993,14130992+0x200000]+list(range(13121601,13121610))+[13622601,13622609]','ids=[11120994,14130994+0x200000]+list(range(13121701,13121708))+[13622701,13622702]').replace('for i in [11120992,11120993]','for i in [11120994]')
 scope={'__file__':str(B.parent/'tsunade-asian/release.py'),'__name__':'publish_alignment'};exec(compile(source,'alignment-release','exec'),scope)
 scope.update(B=W,P=c.h.PUBLIC,VERSION=VERSION)
 (canonical/'TApplication.swf').write_bytes(c.h.swap((W/'compiled.swf').read_bytes()))
 scope['main']()
 print('PASS Naruto alignment publication',VERSION)
if __name__=='__main__':main()
