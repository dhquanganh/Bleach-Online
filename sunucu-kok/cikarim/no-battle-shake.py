"""Disable camera shake without rolling back combat data, VFX or callbacks."""
from pathlib import Path
import argparse,importlib.util,re,struct,subprocess,zlib,shutil
BASE=Path(__file__).resolve().parent
spec=importlib.util.spec_from_file_location('b',BASE/'hashirama-final/build-client.py');b=importlib.util.module_from_spec(spec);spec.loader.exec_module(b)
h=b.h;ROLE=b.ROLE;EFFECT=Path('Processors/Game/Battle/Effect/TEffectControl.as');VERSION=b'2026101974'
def method(s,n):
 start=re.search(r'      (?:override )?(?:public|private) (?:static )?function '+n+r'\(',s).start();return s[start:b.method_end(s,start)]
def stub(s,n,body=''):
 old=method(s,n);return s.replace(old,old[:old.index('{')+1]+'\n'+body+'\n      }',1)
def main():
 p=argparse.ArgumentParser();p.add_argument('--ffdec',required=True);a=p.parse_args()
 work=BASE/'battle-shake/disabled';work.mkdir(parents=True,exist_ok=True)
 canonical=h.PUBLIC/'2026090619/TApplication.swf';old=canonical.read_bytes();decoded=h.swap(old)
 source=work/'source.swf';source.write_bytes(decoded)
 def ff(*args):subprocess.run(['java','-Xmx2g','-jar',a.ffdec,*map(str,args)],check=True)
 classes=['Processors.Game.Battle.Character.TRole','Processors.Game.Battle.Effect.TEffectControl','Processors.Game.Battle.TBattleHandle','Processors.Game.Lobby.Inspector.TProcessorInspector']
 ff('-selectclass',','.join(classes),'-export','script',work/'original',source)
 role=(work/'original/scripts'/ROLE).read_text();effect=(work/'original/scripts'/EFFECT).read_text()
 updated=stub(stub(role,'StartSkillBattleShake'),'ShakeJiraiyaBattle')
 active=method(updated,'ActivePlay');changed=re.sub(r'\n         if\(\(Type == TYPE_ACTIVE_ATTACK \|\| Type == TYPE_ACTIVE_SKILL\) && FSkillId > 0\)\s*\{\s*StartSkillBattleShake\(\);\s*\}', '',active)
 updated=updated.replace(active,changed,1)
 effect_updated=stub(effect,'PlayShake','''         if(param3==null)return;
         var duration:int=0;var margin:int=param2;
         while(margin!=0){duration+=100;margin=int(-margin/1.2);}
         if(duration==0)param3();
         else setTimeout(param3,duration/Math.max(.1,TBattleHandle.PlaybackRate));''')
 for rel,text in [(ROLE,updated),(EFFECT,effect_updated)]:
  path=work/'patched'/rel;path.parent.mkdir(parents=True,exist_ok=True);path.write_text(text)
 output=work/'compiled.swf';ff('-onerror','abort','-importScript',source,output,work/'patched');rebuilt=output.read_bytes()
 assert [t for t in h.tags(decoded)if t[0]!=82]==[t for t in h.tags(rebuilt)if t[0]!=82]
 ff('-selectclass',','.join(classes),'-export','script',work/'verify',output)
 for rel,original,allowed in [(ROLE,role,{'ActivePlay','StartSkillBattleShake','ShakeJiraiyaBattle'}),(EFFECT,effect,{'PlayShake'})]:
  verified=(work/'verify/scripts'/rel).read_text()
  for name in re.findall(r'      (?:override )?(?:public|private) (?:static )?function (\w+)\(',original):
   if name not in allowed:assert method(original,name)==method(verified,name),name
 for cls in classes[2:]:
  rel=Path(cls.replace('.','/')+'.as');assert (work/'original/scripts'/rel).read_bytes()==(work/'verify/scripts'/rel).read_bytes()
 verified=(work/'verify/scripts'/ROLE).read_text()
 for name in ['StartSkillBattleShake','ShakeJiraiyaBattle']:
  assert method(verified,name).split('{',1)[1].strip()=='}'
 assert 'StartSkillBattleShake();' not in method(verified,'ActivePlay')
 assert 'param3();' in method((work/'verify/scripts'/EFFECT).read_text(),'PlayShake')
 assert canonical.read_bytes()==old
 version=canonical.parent/'version.swf';raw=zlib.decompress(version.read_bytes());pos=2;parts=[raw[:2]];found=0
 for _ in range(struct.unpack_from('<H',raw)[0]):
  n=struct.unpack_from('<H',raw,pos)[0];pos+=2;k=raw[pos:pos+n];pos+=n;n=struct.unpack_from('<H',raw,pos)[0];pos+=2;v=raw[pos:pos+n];pos+=n
  if k==b'TApplication.swf':v=VERSION;found+=1
  parts.extend([struct.pack('<H',len(k)),k,struct.pack('<H',len(v)),v])
 assert found==1 and pos==len(raw)
 backup=work/'backups';backup.mkdir(exist_ok=True)
 for file in [canonical,version]:
  if not (backup/file.name).exists():shutil.copy2(file,backup/file.name)
 protected=h.swap(rebuilt);dest=h.PUBLIC/VERSION.decode()/'TApplication.swf';dest.parent.mkdir(exist_ok=True)
 dest.write_bytes(protected);canonical.write_bytes(protected);version.write_bytes(zlib.compress(b''.join(parts)))
 print('PASS',VERSION.decode(),': cast and impact shakes disabled; callbacks, HP logic, VFX, speed and UI preserved')
if __name__=='__main__':main()
