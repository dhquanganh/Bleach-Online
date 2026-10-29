from pathlib import Path
import importlib.util,json,re,shutil
B=Path(__file__).resolve().parent
s=importlib.util.spec_from_file_location('shared',B.parent/'tsunade-asian/build-client.py');c=importlib.util.module_from_spec(s);s.loader.exec_module(c);c.JAR=str(B.parents[2]/'tools/ffdec/ffdec.jar')
paths=[Path('Processors/Game/Lobby/HerosNew/TWindowAttribute.as'),Path('Processors/Game/Lobby/Common/Players/TProcessorWindowPlayerAssets.as')]
def main():
 active=json.loads((c.h.PUBLIC/'client-release.json').read_text())['version'];assert active=='2026102902'
 (B/'source.swf').write_bytes(c.h.swap((c.h.PUBLIC/active/'TApplication.swf').read_bytes()))
 classes=','.join(str(p.with_suffix('')).replace('\\','.').replace('/','.') for p in paths);c.ff('-selectclass',classes,'-export','script',B/'original',B/'source.swf')
 for rel in paths:
  before=(B/'original/scripts'/rel).read_text(encoding='utf-8');old=c.m.extract(before,'InitCharacterTags');match=re.search(r'JSON.parse\(("(?:\\.|[^"\\])*")\)',old);assert match
  data=json.loads(json.loads(match[1]));data['heroes']['11121008']=[27,52,13,14,49,56,58];data['tags']['56']={'name':'Otsutsuki Clan','icon':'/public/character-tags/56.png'}
  new=old[:match.start(1)]+json.dumps(json.dumps(data,separators=(',',':')))+old[match.end(1):]
  target=B/'patched'/rel;target.parent.mkdir(parents=True,exist_ok=True);target.write_text(before.replace(old,new,1),encoding='utf-8')
 (B/'tags.json').write_text(json.dumps(data,indent=2)+'\n')
 c.ff('-onerror','abort','-importScript',B/'source.swf',B/'compiled.swf',B/'patched');c.ff('-selectclass',classes,'-export','script',B/'verify',B/'compiled.swf')
 for rel in paths:
  before=(B/'original/scripts'/rel).read_text(encoding='utf-8');after=(B/'verify/scripts'/rel).read_text(encoding='utf-8')
  for name in re.findall(r'      (?:override )?(?:public|private|protected) (?:static )?function (\w+)\(',before):
   if name!='InitCharacterTags':assert c.m.extract(before,name)==c.m.extract(after,name),name
 assert [t for t in c.h.tags((B/'source.swf').read_bytes()) if t[0]!=82]==[t for t in c.h.tags((B/'compiled.swf').read_bytes()) if t[0]!=82]
 print('PASS Asura tag views; other methods and SWF resources unchanged')
if __name__=='__main__':main()
