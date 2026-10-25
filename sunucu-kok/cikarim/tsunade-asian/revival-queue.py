"""Keep zero-HP Katsuyu placeholders addressable by native replay commands."""
from pathlib import Path
import importlib.util,json,re,shutil,hashlib
B=Path(__file__).resolve().parent;W=B/'revival-queue';VERSION='2026102426'
def module(name,path):
 s=importlib.util.spec_from_file_location(name,path);m=importlib.util.module_from_spec(s);s.loader.exec_module(m);return m
c=module('client',B/'build-client.py');release=module('release',B/'release.py')
STAGE=Path('Processors/Game/Battle/TBattleStage.as');ROLE=c.b.ROLE
def patch_stage(before):
 method=c.m.extract(before,'SetBattle');patched=method
 for param in ['param1','param2']:
  old=f'if({param}.RoleBattleInfos[_loc3_].CurHealth > 0)'
  assert old in patched
  patched=patched.replace(old,old[:-1]+f' || {param}.RoleBattleInfos[_loc3_].RoleId == 11120993)',1)
 return before.replace(method,patched,1)
def patch_role(before):
 method=c.m.extract(before,'PrepareBattleRole')
 old='FSmallKatsuyuSpawned = false;';assert old in method
 patched=method.replace(old,old+'\n            if(CurHealth<=0){FIsDie=true;visible=false;FHpBar.visible=false;FShaderBmp.visible=false;FBuffSprite.visible=false;}',1)
 after=before.replace(method,patched,1)
 method=c.m.extract(after,'ActivePlay')
 start=method.index('         if(FId == 11120993)');end=method.index('         Index = 0;',start)
 # FFDec hoists aliases into locals. Read parameters before their assignments.
 branch='''         if(FId==11120993){
            if(param1==TYPE_ACTIVE_DIE){PlaySmallKatsuyuPose(true,param5,param6);return;}
            if(param1==TYPE_ACTIVE_ATTACK || param1==TYPE_ACTIVE_SKILL)ClearSmallKatsuyuPose();
         }
'''
 return after.replace(method,method[:start]+branch+method[end:],1)
def main():
 canonical=c.h.PUBLIC/'2026090619/TApplication.swf';old=canonical.read_bytes()
 assert (W/'source.swf').read_bytes()==c.h.swap(old),'Source is stale'
 originals={}
 for rel,patch in [(STAGE,patch_stage),(ROLE,patch_role)]:
  before=(W/'original/scripts'/rel).read_text(encoding='utf-8');originals[rel]=before
  dest=W/'patched'/rel;dest.parent.mkdir(parents=True,exist_ok=True);dest.write_text(patch(before),encoding='utf-8')
 c.ff('-onerror','abort','-importScript',W/'source.swf',W/'compiled.swf',W/'patched')
 compiled=(W/'compiled.swf').read_bytes()
 assert [t for t in c.h.tags(c.h.swap(old)) if t[0]!=82]==[t for t in c.h.tags(compiled) if t[0]!=82]
 classes=','.join(str(rel.with_suffix('')).replace('\\','.').replace('/','.') for rel in [STAGE,ROLE])
 c.ff('-selectclass',classes,'-export','script',W/'verify',W/'compiled.swf')
 counts={}
 for rel,allowed in [(STAGE,{'SetBattle'}),(ROLE,{'PrepareBattleRole','ActivePlay'})]:
  verified=(W/'verify/scripts'/rel).read_text(encoding='utf-8');count=0
  for name in re.findall(r'      (?:override )?(?:public|private|protected) (?:static )?function (\w+)\(',originals[rel]):
   if name not in allowed:assert c.m.extract(originals[rel],name)==c.m.extract(verified,name),name;count+=1
  counts[rel.stem]=count
 assert canonical.read_bytes()==old
 manifest=canonical.parent/'version.swf';pointer=c.h.PUBLIC/'client-release.json';backup=W/'backups';backup.mkdir()
 for path in [canonical,manifest,pointer]:shutil.copy2(path,backup/path.name)
 rows=release.rows(manifest.read_bytes())
 for row in rows:
  if row[0]==b'TApplication.swf':row[1]=VERSION.encode()
 protected=c.h.swap(compiled);dest=c.h.PUBLIC/VERSION;dest.mkdir()
 canonical.write_bytes(protected);manifest.write_bytes(release.encode(rows))
 for name in ['TApplication.swf','version.swf','index.swf']:shutil.copy2(canonical.parent/name,dest/name)
 pointer.write_text(json.dumps({'version':VERSION})+'\n')
 (W/'result.json').write_text(json.dumps({'version':VERSION,'unchangedMethods':counts,'sha256':hashlib.sha256(protected).hexdigest(),'zeroHpActor':11120993},indent=2)+'\n')
 print('PASS native revival queue client',VERSION,counts)
if __name__=='__main__':main()
