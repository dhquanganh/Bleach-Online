"""Add a native asset-backed Crow decoy without changing combat or other actors."""
from pathlib import Path
import importlib.util,json,re,shutil,struct,zlib,hashlib
B=Path(__file__).resolve().parent
s=importlib.util.spec_from_file_location('client',B.parent/'itachi-rtn/build-client.py');client=importlib.util.module_from_spec(s);s.loader.exec_module(client)
ROLE=Path('Processors/Game/Battle/Character/TRole.as');STAGE=Path('Processors/Game/Battle/TBattleStage.as');VERSION='2026102108'
def main():
 canonical=client.h.PUBLIC/'2026090619/TApplication.swf';old=canonical.read_bytes();source=client.h.swap(old)
 if (B/'compiled.swf').exists() and old==client.h.swap((B/'compiled.swf').read_bytes()):source=client.h.swap((B/'backups/TApplication.swf').read_bytes())
 (B/'source.swf').write_bytes(source)
 classes='Processors.Game.Battle.Character.TRole,Processors.Game.Battle.TBattleStage'
 client.ff('-selectclass',classes,'-export','script',B/'original',B/'source.swf')
 role=(B/'original/scripts'/ROLE).read_text(encoding='utf-8');stage=(B/'original/scripts'/STAGE).read_text(encoding='utf-8')
 assert 'ShowItachiCrowClone' not in role and 'DamageFloatHost' in stage
 after=role.replace('      private var FItachiVfxStarted:', '      private var FItachiCrowClone:Sprite;\n      private var FItachiCrowCloneTick:Function;\n      private var FItachiCrowCloneRemoved:Function;\n\n      private var FItachiVfxStarted:',1)
 after=after.replace('      private function ShowItachiVfx(', (B/'clone.as.txt').read_text()+'\n\n      private function ShowItachiVfx(',1)
 after=client.inject(after,'ShowItachiVfx','         if(skill==13121207)ShowItachiCrowClone();')
 after=client.inject(after,'Reset','         ClearItachiCrowClone();')
 after=client.inject(after,'PrepareBattleRole','         ClearItachiCrowClone();')
 token='                  this.FChain.UpdateRemainNum(CommandObj.turnNumber);';assert stage.count(token)==1
 stage_after=stage.replace(token,'                  for each(var crowRole:TRole in this.FPlayerRoleMgr)if(crowRole!=null)crowRole.ClearItachiCrowClone();\n'+token)
 for rel,text in [(ROLE,after),(STAGE,stage_after)]:
  dest=B/'patched'/rel;dest.parent.mkdir(parents=True,exist_ok=True);dest.write_text(text,encoding='utf-8')
 client.ff('-onerror','abort','-importScript',B/'source.swf',B/'compiled.swf',B/'patched')
 rebuilt=(B/'compiled.swf').read_bytes();assert [t for t in client.h.tags(source) if t[0]!=82]==[t for t in client.h.tags(rebuilt) if t[0]!=82]
 client.ff('-selectclass',classes,'-export','script',B/'verify',B/'compiled.swf')
 checked=0
 for rel,before,allowed in [(ROLE,role,{'ShowItachiVfx','Reset','PrepareBattleRole'}),(STAGE,stage,{'NextCommand'})]:
  actual=(B/'verify/scripts'/rel).read_text(encoding='utf-8')
  for name in re.findall(r'      (?:override )?(?:public|private|protected) (?:static )?function (\w+)\(',before):
   if name not in allowed:assert client.m.extract(before,name)==client.m.extract(actual,name),name;checked+=1
 manifest=canonical.parent/'version.swf';raw=zlib.decompress(manifest.read_bytes());pos=2;parts=[raw[:2]];found=0
 for _ in range(struct.unpack_from('<H',raw)[0]):
  n=struct.unpack_from('<H',raw,pos)[0];pos+=2;k=raw[pos:pos+n];pos+=n;n=struct.unpack_from('<H',raw,pos)[0];pos+=2;v=raw[pos:pos+n];pos+=n
  if k==b'TApplication.swf':v=VERSION.encode();found+=1
  parts.extend([struct.pack('<H',len(k)),k,struct.pack('<H',len(v)),v])
 assert pos==len(raw) and found==1 and canonical.read_bytes()==old
 backup=B/'backups';backup.mkdir(exist_ok=True)
 for f in [canonical,manifest]:
  if not (backup/f.name).exists():shutil.copy2(f,backup/f.name)
 protected=client.h.swap(rebuilt);dest=client.h.PUBLIC/VERSION/'TApplication.swf';dest.parent.mkdir(exist_ok=True);dest.write_bytes(protected);canonical.write_bytes(protected);manifest.write_bytes(zlib.compress(b''.join(parts)))
 (B/'result.json').write_text(json.dumps({'version':VERSION,'sha256':hashlib.sha256(protected).hexdigest(),'unchangedMethods':checked,'combatChanged':False,'texturesChanged':False,'clonePerItachi':1,'clearOnRoundDeathReset':True},indent=2));print('PASS Crow decoy; preserved damage foreground, consecutive hits and other character methods; client',VERSION)
if __name__=='__main__':main()
