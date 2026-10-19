"""Install only HD cinematic methods/manifest into the current live client."""
from pathlib import Path
import argparse,importlib.util,json,re,shutil,struct,subprocess,zlib
BASE=Path(__file__).resolve().parent
spec=importlib.util.spec_from_file_location('build',BASE/'build-client.py');build=importlib.util.module_from_spec(spec);spec.loader.exec_module(build)
h=build.h;ROLE=build.ROLE;VERSION=b'2026101967'
EXTRAS=['Processors.Game.Battle.TBattleHandle','Processors.Game.Lobby.Inspector.TProcessorInspector']

def extract(source,name):
 start=re.search(r'      private (?:static )?function '+name+r'\(',source).start()
 return source[start:build.method_end(source,start)]
def replace(source,name,value):return source.replace(extract(source,name),value,1)

def main():
 p=argparse.ArgumentParser();p.add_argument('--ffdec',required=True);p.add_argument('--install',action='store_true');args=p.parse_args()
 work=BASE/'cinematic-build';work.mkdir(exist_ok=True)
 canonical=h.PUBLIC/'2026090619/TApplication.swf';old=canonical.read_bytes();decoded=h.swap(old)
 source=work/'source.swf';source.write_bytes(decoded)
 def ff(*a):subprocess.run(['java','-Xmx2g','-jar',args.ffdec,*map(str,a)],check=True)
 classes=','.join(['Processors.Game.Battle.Character.TRole']+EXTRAS)
 ff('-selectclass',classes,'-export','script',work/'original',source)
 before=(work/'original/scripts'/ROLE).read_text();role=before
 role=replace(role,'ShowHashiramaVfx',extract((BASE/'runtime.as.txt').read_text(),'ShowHashiramaVfx'))
 play=extract(role,'PlayHashiramaVfxAsset')
 if 'clip.frameAtlases' not in play:
  assert 'var frames:Array = FHashiramaFxCache[clip.atlas] as Array;' in play
  play=play.replace('            var frame:int = int(elapsed / 40);\n','')
  play=play.replace('            var frames:Array = FHashiramaFxCache[clip.atlas] as Array;',
  '''            var frame:int = int(elapsed / 40);
            var frameAtlas:String=clip.frameAtlases!=null?String(clip.frameAtlases[frame]):String(clip.atlas);
            LoadHashiramaVfxAtlas(frameAtlas,manifest.atlases[frameAtlas]);
            var frames:Array = FHashiramaFxCache[frameAtlas] as Array;''')
 role=replace(role,'PlayHashiramaVfxAsset',play)
 manifest='      private static function HashiramaVfxManifest() : Object\n      {return JSON.parse('+json.dumps(json.dumps(build.effect_manifest(),separators=(',',':')))+');}'
 role=replace(role,'HashiramaVfxManifest',manifest)
 dest=work/'patched'/ROLE;dest.parent.mkdir(parents=True,exist_ok=True);dest.write_text(role)
 output=work/'compiled.swf';ff('-onerror','abort','-importScript',source,output,work/'patched');rebuilt=output.read_bytes()
 assert [t for t in h.tags(decoded) if t[0]!=82]==[t for t in h.tags(rebuilt) if t[0]!=82]
 ff('-selectclass',classes,'-export','script',work/'verify',output)
 verified=(work/'verify/scripts'/ROLE).read_text()
 for name in EXTRAS:
  path=Path(name.replace('.','/')+'.as')
  assert (work/'original/scripts'/path).read_text()==(work/'verify/scripts'/path).read_text(),name
 for name in re.findall(r'      private (?:static )?function (\w+)\(',before):
  if name not in ['ShowHashiramaVfx','PlayHashiramaVfxAsset','HashiramaVfxManifest']:
   assert extract(before,name)==extract(verified,name),'Unexpected method change: '+name
 for token in ['FCombatVfxSerial','PlaybackTime','clip.frameAtlases','Hashirama-thousand-hands-cinematic','RestorePainAfterRevival','PainFlightPose']:
  assert token in verified,token
 if args.install:
  assert canonical.read_bytes()==old,'Live client changed during compile'
  file=canonical.parent/'version.swf';raw=zlib.decompress(file.read_bytes());pos=2;parts=[raw[:2]];found=0
  for _ in range(struct.unpack_from('<H',raw)[0]):
   n=struct.unpack_from('<H',raw,pos)[0];pos+=2;k=raw[pos:pos+n];pos+=n;n=struct.unpack_from('<H',raw,pos)[0];pos+=2;v=raw[pos:pos+n];pos+=n
   if k==b'TApplication.swf':v=VERSION;found+=1
   parts.extend([struct.pack('<H',len(k)),k,struct.pack('<H',len(v)),v])
  assert found==1 and pos==len(raw)
  backups=BASE/'backups';backups.mkdir(exist_ok=True)
  for original in [canonical,file]:
   backup=backups/('cinematic-'+VERSION.decode()+'-'+original.name)
   if not backup.exists():shutil.copy2(original,backup)
  protected=h.swap(rebuilt);dest=h.PUBLIC/VERSION.decode()/'TApplication.swf';dest.parent.mkdir(exist_ok=True)
  dest.write_bytes(protected);canonical.write_bytes(protected);file.write_bytes(zlib.compress(b''.join(parts)))
  (BASE/'patched'/ROLE).write_text(verified)
  (BASE.parent/'pain-tendo/patched'/ROLE).write_text(verified)
 print('PASS HD cinematic client',VERSION.decode(),'installed',args.install,'; all other role methods, Inspector, x2 speed and UI tags preserved')
if __name__=='__main__':main()
