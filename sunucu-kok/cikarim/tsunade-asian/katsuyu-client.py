"""Add actor-scoped Small Katsuyu entry/death playback and native healing VFX."""
from pathlib import Path
import importlib.util,json,re,shutil,hashlib
B=Path(__file__).resolve().parent
def module(name,path):
 s=importlib.util.spec_from_file_location(name,path);m=importlib.util.module_from_spec(s);s.loader.exec_module(m);return m
c=module('client',B/'build-client.py');release=module('release',B/'release.py');VERSION='2026102421'
def patch(before):
 data=json.loads((B/'katsuyu/animation.json').read_text())
 runtime=(B/'katsuyu.as.txt').read_text().replace('__DEAD_FRAMES__',str(len(data['clips']['dead']['frames']))).replace('__ENTRY_FRAMES__',str(len(data['clips']['entry']['frames'])))
 assert 'PlaySmallKatsuyuPose' not in before,'Already installed; inspect current client before rebuilding'
 after=before.replace('      private function RestoreTsunadeAfterRevival(',runtime+'\n      private function RestoreTsunadeAfterRevival(',1)
 def append(s,name,code):
  method=c.m.extract(s,name);i=method.rfind('}');return s.replace(method,method[:i]+code+'\n      '+method[i:],1)
 after=append(after,'RestoreTsunadeAfterRevival','         if(FId==11120993)PlaySmallKatsuyuPose(false);')
 after=c.inject(after,'ActivePlay','         if(FId==11120993){if(Type==TYPE_ACTIVE_DIE){PlaySmallKatsuyuPose(true,Callback,Time);return;}if(Type==TYPE_ACTIVE_ATTACK || Type==TYPE_ACTIVE_SKILL)ClearSmallKatsuyuPose();}')
 after=c.inject(after,'PrepareBattleRole','         if(FId==11120993){ClearSmallKatsuyuPose();FSmallKatsuyuSpawned=false;}')
 after=c.inject(after,'Reset','         if(FId==11120993){ClearSmallKatsuyuPose();FSmallKatsuyuSpawned=false;}')
 after=c.inject(after,'AddTextEffectByCMD','         if(param1.CMD==TTargetInfo.CMD_FLOAT && uint(param1.ResultInfo.BuffId)==19001707)TEffectControl.ShowPublicEffect(FEffectSprite,13622609,0,0,null);')
 return after
def main():
 W=B/'katsuyu/client';W.mkdir(parents=True,exist_ok=True)
 canonical=c.h.PUBLIC/'2026090619/TApplication.swf';old=canonical.read_bytes();source=c.h.swap(old);(W/'source.swf').write_bytes(source)
 rel=c.b.ROLE;cls=str(rel.with_suffix('')).replace('\\','.').replace('/','.')
 c.ff('-selectclass',cls,'-export','script',W/'original',W/'source.swf');before=(W/'original/scripts'/rel).read_text(encoding='utf-8');after=patch(before)
 target=W/'patched'/rel;target.parent.mkdir(parents=True,exist_ok=True);target.write_text(after,encoding='utf-8')
 c.ff('-onerror','abort','-importScript',W/'source.swf',W/'compiled.swf',W/'patched')
 compiled=(W/'compiled.swf').read_bytes();assert [t for t in c.h.tags(source) if t[0]!=82]==[t for t in c.h.tags(compiled) if t[0]!=82]
 c.ff('-selectclass',cls,'-export','script',W/'verify',W/'compiled.swf');verified=(W/'verify/scripts'/rel).read_text(encoding='utf-8')
 allowed={'RestoreTsunadeAfterRevival','UpdateAnimationFrame','ActivePlay','PrepareBattleRole','Reset','AddTextEffectByCMD'};checked=0
 for name in re.findall(r'      (?:override )?(?:public|private|protected) (?:static )?function (\w+)\(',before):
  if name not in allowed:assert c.m.extract(before,name)==c.m.extract(verified,name),name;checked+=1
 assert canonical.read_bytes()==old
 backup=W/'backups';backup.mkdir(exist_ok=True)
 manifest=canonical.parent/'version.swf';pointer=c.h.PUBLIC/'client-release.json'
 for p in [canonical,manifest,pointer]:
  assert not (backup/p.name).exists(),'Backup exists; inspect before rebuilding'
  shutil.copy2(p,backup/p.name)
 rows=release.rows(manifest.read_bytes())
 for row in rows:
  if row[0]==b'TApplication.swf':row[1]=VERSION.encode()
 dest=c.h.PUBLIC/VERSION;dest.mkdir(exist_ok=True);canonical.write_bytes(c.h.swap(compiled));manifest.write_bytes(release.encode(rows))
 for name in ['index.swf','version.swf','TApplication.swf']:shutil.copy2(canonical.parent/name,dest/name)
 pointer.write_text(json.dumps({'version':VERSION})+'\n')
 (W/'result.json').write_text(json.dumps({'version':VERSION,'unchangedMethods':checked,'sha256':hashlib.sha256(canonical.read_bytes()).hexdigest(),'actorScoped':11120993,'healingEffect':13622609},indent=2)+'\n')
 print('PASS native Katsuyu entry/death/heal client;',checked,'other methods preserved')
if __name__=='__main__':main()
