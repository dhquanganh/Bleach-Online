"""Update animation methods on the live client, without rolling back any other class."""
from pathlib import Path
import argparse,importlib.util,json,re,shutil,struct,subprocess,zlib
BASE=Path(__file__).resolve().parent
spec=importlib.util.spec_from_file_location('build',BASE/'build-client.py');build=importlib.util.module_from_spec(spec);spec.loader.exec_module(build)
h=build.h;ROLE=build.ROLE;VERSION=b'2026101960'
def extract(source,name):
 start=re.search(r'      private (?:static )?function '+name+r'\(',source).start()
 return source[start:build.method_end(source,start)]
def replace(source,name,value):
 old=extract(source,name);return source.replace(old,value,1)
def main():
 p=argparse.ArgumentParser();p.add_argument('--ffdec',required=True);p.add_argument('--install',action='store_true');args=p.parse_args()
 canonical=h.PUBLIC/'2026090619/TApplication.swf';old=canonical.read_bytes();decoded=h.swap(old);source=BASE/'animation-source.swf';source.write_bytes(decoded)
 def ff(*a):subprocess.run(['java','-Xmx2g','-jar',args.ffdec,*map(str,a)],check=True)
 ff('-selectclass','Processors.Game.Battle.Character.TRole','-export','script',BASE/'animation-original',source)
 role=(BASE/'animation-original/scripts'/ROLE).read_text()
 runtime=(BASE/'runtime.as.txt').read_text()
 for name in ['ShowHashiramaVfx','HashiramaStrikePose']:role=replace(role,name,extract(runtime,name))
 manifest='      private static function HashiramaVfxManifest() : Object\n      {return JSON.parse('+json.dumps(json.dumps(build.effect_manifest(),separators=(',',':')))+');}'
 role=replace(role,'HashiramaVfxManifest',manifest)
 dest=BASE/'animation-patched'/ROLE;dest.parent.mkdir(parents=True,exist_ok=True);dest.write_text(role)
 (BASE/'patched'/ROLE).write_text(role)
 # Pain's independent probes must exercise exactly the same production methods.
 (BASE.parent/'pain-tendo/patched'/ROLE).write_text(role)
 output=BASE/'animation-compiled.swf';ff('-onerror','abort','-importScript',source,output,BASE/'animation-patched');rebuilt=output.read_bytes()
 assert [t for t in h.tags(decoded) if t[0]!=82]==[t for t in h.tags(rebuilt) if t[0]!=82]
 classes='Processors.Game.Battle.Character.TRole,Processors.Game.Battle.Character.TActive,Processors.Game.Battle.TBattleStage,Processors.Game.Lobby.TacticalDeployment.Components.THeroDeployment,Processors.Game.Lobby.SkyTower.TProcessorSkyTower'
 ff('-selectclass',classes,'-export','script',BASE/'verify',output)
 verified=(BASE/'verify/scripts'/ROLE).read_text()
 for token in ['FCombatVfxSerial','castSerial','rodSerial','HashiramaStrikePose','PainFlightPose','RestorePainAfterRevival','ShowPainLaserImpact','UpdateObitoVfx']:assert token in verified,token
 assert 'GoldPrimogem' in (BASE/'verify/scripts/Processors/Game/Lobby/SkyTower/TProcessorSkyTower.as').read_text()
 if args.install:
  assert canonical.read_bytes()==old,'Client changed while compiling'
  file=canonical.parent/'version.swf';raw=zlib.decompress(file.read_bytes());pos=2;parts=[raw[:2]];found=0
  for _ in range(struct.unpack_from('<H',raw)[0]):
   n=struct.unpack_from('<H',raw,pos)[0];pos+=2;k=raw[pos:pos+n];pos+=n;n=struct.unpack_from('<H',raw,pos)[0];pos+=2;v=raw[pos:pos+n];pos+=n
   if k==b'TApplication.swf':v=VERSION;found+=1
   parts.extend([struct.pack('<H',len(k)),k,struct.pack('<H',len(v)),v])
  assert found==1 and pos==len(raw)
  for original in [canonical,file]:
   backup=BASE/'backups'/('animation-'+VERSION.decode()+'-'+original.name)
   if not backup.exists():shutil.copy2(original,backup)
  protected=h.swap(rebuilt);dest=h.PUBLIC/VERSION.decode()/'TApplication.swf';dest.parent.mkdir(exist_ok=True);dest.write_bytes(protected);canonical.write_bytes(protected);file.write_bytes(zlib.compress(b''.join(parts)))
  (BASE/'compiled.swf').write_bytes(rebuilt)
 print('PASS live client animation update',VERSION.decode(),'installed',args.install)
if __name__=='__main__':main()
