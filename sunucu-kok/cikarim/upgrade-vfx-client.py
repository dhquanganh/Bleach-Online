"""Incrementally install sharp, viewport-sized, streaming VFX for both ninjas."""
from pathlib import Path
import argparse,importlib.util,json,re,shutil,struct,subprocess,zlib
BASE=Path(__file__).resolve().parent
spec=importlib.util.spec_from_file_location('build',BASE/'hashirama-final/build-client.py');build=importlib.util.module_from_spec(spec);spec.loader.exec_module(build)
h=build.h;ROLE=build.ROLE;VERSION=b'2026101970'
EXTRAS=['Processors.Game.Battle.TBattleHandle','Processors.Game.Lobby.Inspector.TProcessorInspector']
def extract(s,n):
 start=re.search(r'      private (?:static )?function '+n+r'\(',s).start();return s[start:build.method_end(s,start)]
def replace(s,n,v):return s.replace(extract(s,n),v,1)
def manifest(char):
 if char=='Hashirama':return build.effect_manifest()
 b=BASE/'pain-tendo';m=json.loads((b/'vfx.json').read_text())
 for key,c in m['clips'].items():
  effect,ident=key.rsplit('-',1);folder=next((b/'native-export'/effect).glob('DefineSprite_'+ident+'_*'));c['action']=folder.name.split('_',2)[2]
  if c['action']=='texie':c['pivot']=[.5,.5]
  elif key.startswith(('PEpugong1','PEzhuida','PEaoyi1')):c['pivot'][0]=.5
  if key in ['Peienchaoshenshenluotianzheng_aoyi-115','Peienchaoshenshenluotianzheng_aoyi-686','PEaoyi2-414']:c['additive']=True
  if key=='PEaoyi2-12':c['screen']=True;c['pivot']=[.5,.5]
  if key=='PEaoyi2-414':c['pivot']=[.25,.60]
 return m
def patch(s,char):
 folder=BASE/('pain-tendo' if char=='Pain' else 'hashirama-final');old=extract(s,'Preload'+char+'Vfx')
 warm=['DASHEWAN_tongyongfuhuo','PEaoyi1','PEaoyi2'] if char=='Pain' else ['Zhujianzhongyanhuashujiejianglin','Zhujianzhongyanmingshenfenglong','Zhujianzhongyanmingshenfenglong_texie']
 warmcode='''      private static function PreloadCHARVfx() : void
      {
         var manifest:Object=CHARVfxManifest();
         for each(var effect:String in WARM)
         for each(var name:String in manifest.effects[effect])
         {var clip:Object=manifest.clips[name];LoadCHARVfxAtlas(String(clip.atlas),manifest.atlases[clip.atlas]);}
      }'''.replace('CHAR',char).replace('WARM',json.dumps(warm))
 s=s.replace(old,warmcode,1)
 load=extract(s,'Load'+char+'VfxAtlas')
 load=load.replace('         if(F'+char+'FxCache[name] != null', '         F'+char+'FxLoading["_age_"+name]=getTimer();\n         if(F'+char+'FxCache[name] != null',1)
 load=load.replace('            F'+char+'FxCache[name] = frames;','            F'+char+'FxCache[name] = frames;Trim'+char+'VfxCache(name);')
 s=replace(s,'Load'+char+'VfxAtlas',load)
 trim=(BASE/'vfx-cache.as.txt').read_text().replace('CHAR',char)
 s=s.replace(warmcode,warmcode+'\n'+trim)
 play=extract(s,'Play'+char+'VfxAsset')
 play=play.replace('if(layer.parent != null)','if(layer.parent != null && (event == null || event.type != Event.REMOVED_FROM_STAGE))')
 play=play.replace('         layer.name = "'+char.lower()+'SkillVfx";', '         layer.name = "'+char.lower()+'SkillVfx";\n         F'+char+'ActiveVfx.push(layer);')
 if char=='Pain':
  play=play.replace('if(rodSkill == 13120975 && (caster.FCombatVfxSerial != rodSerial || caster.FSkillId != rodSkill))','if(caster.FCombatVfxSerial != rodSerial || caster.FSkillId != rodSkill)')
  play=play.replace('rodSkill == 13120975 ? (Math.max(0,caster.FFrameIndex) - rodFrame) * 40 - delay : TBattleHandle.PlaybackTime - started','(Math.max(0,caster.FFrameIndex) - rodFrame) * 40 - delay')
  play=play.replace('            var frame:int = int(elapsed / 40);\n','')
  play=play.replace('            var frames:Array = FPainFxCache[clip.atlas] as Array;', '''            var frame:int=int(elapsed/40);
            var frameAtlas:String=clip.frameAtlases!=null?String(clip.frameAtlases[frame]):String(clip.atlas);
            LoadPainVfxAtlas(frameAtlas,manifest.atlases[frameAtlas]);
            var frames:Array=FPainFxCache[frameAtlas] as Array;''')
 # Preload the next different page before crossing its boundary, without loading
 # every HD frame into Flash's 32-bit process at battle entrance.
 marker='            if(frames == null)'
 prefetch='''            if(clip.frameAtlases!=null)for(var ahead:int=frame+1;ahead<clip.frameAtlases.length;ahead++)
            {var nextAtlas:String=String(clip.frameAtlases[ahead]);if(nextAtlas!=frameAtlas){LoadCHARVfxAtlas(nextAtlas,manifest.atlases[nextAtlas]);break;}}
'''.replace('CHAR',char)
 assert marker in play;play=play.replace(marker,prefetch+marker,1)
 s=replace(s,'Play'+char+'VfxAsset',play)
 show=extract((folder/'runtime.as.txt').read_text(),'Show'+char+'Vfx')
 clear='\n         for each(var prior:Sprite in F'+char+'ActiveVfx)if(prior.parent!=null)prior.parent.removeChild(prior);\n         F'+char+'ActiveVfx=[];'
 show=show.replace('      {','      {'+clear,1)
 s=replace(s,'Show'+char+'Vfx',show)
 impactName='ShowPainLaserImpact' if char=='Pain' else 'ShowHashiramaImpact'
 impact=extract(s,impactName)
 impact=impact.replace('if(layer.parent != null)','if(layer.parent != null && (event == null || event.type != Event.REMOVED_FROM_STAGE))')
 impact=impact.replace('         layer.name = "'+char.lower()+'SkillVfx";', '         layer.name = "'+char.lower()+'SkillVfx";\n         F'+char+'ActiveVfx.push(layer);')
 s=replace(s,impactName,impact)
 m=manifest(char);value='      private static function '+char+'VfxManifest() : Object\n      {return JSON.parse('+json.dumps(json.dumps(m,separators=(',',':')))+');}'
 s=replace(s,char+'VfxManifest',value)
 return s
def main():
 p=argparse.ArgumentParser();p.add_argument('--ffdec',required=True);p.add_argument('--install',action='store_true');a=p.parse_args();work=BASE/'hashirama-final/quality-build';work.mkdir(exist_ok=True)
 canonical=h.PUBLIC/'2026090619/TApplication.swf';old=canonical.read_bytes();decoded=h.swap(old)
 if (work/'compiled.swf').exists() and old==h.swap((work/'compiled.swf').read_bytes()):decoded=h.swap((work/'backups/TApplication.swf').read_bytes())
 source=work/'source.swf';source.write_bytes(decoded)
 def ff(*v):subprocess.run(['java','-Xmx2g','-jar',a.ffdec,*map(str,v)],check=True)
 classes=','.join(['Processors.Game.Battle.Character.TRole']+EXTRAS);ff('-selectclass',classes,'-export','script',work/'original',source)
 before=(work/'original/scripts'/ROLE).read_text();role=before.replace('      private var FPainVfxStarted:Boolean','      private var FPainActiveVfx:Array=[];\n      private var FHashiramaActiveVfx:Array=[];\n      private var FPainVfxStarted:Boolean',1);role=patch(patch(role,'Pain'),'Hashirama')
 dest=work/'patched'/ROLE;dest.parent.mkdir(parents=True,exist_ok=True);dest.write_text(role)
 output=work/'compiled.swf';ff('-onerror','abort','-importScript',source,output,work/'patched');rebuilt=output.read_bytes()
 assert [t for t in h.tags(decoded)if t[0]!=82]==[t for t in h.tags(rebuilt)if t[0]!=82]
 ff('-selectclass',classes,'-export','script',work/'verify',output);verified=(work/'verify/scripts'/ROLE).read_text()
 for cls in EXTRAS:
  rel=Path(cls.replace('.','/')+'.as');assert (work/'original/scripts'/rel).read_text()==(work/'verify/scripts'/rel).read_text(),cls
 changed={char+n for char in ['Pain','Hashirama']for n in ['VfxManifest']}|{'ShowPainLaserImpact','ShowHashiramaImpact'}
 changed|={prefix+char+'Vfx'+suffix for prefix,suffix in [('Show',''),('Play','Asset'),('Preload',''),('Load','Atlas')]for char in ['Pain','Hashirama']}
 for name in re.findall(r'      private (?:static )?function (\w+)\(',before):
  if name not in changed:assert extract(before,name)==extract(verified,name),name
 if a.install:
  assert canonical.read_bytes()==old
  version=canonical.parent/'version.swf';raw=zlib.decompress(version.read_bytes());pos=2;parts=[raw[:2]];found=0
  for _ in range(struct.unpack_from('<H',raw)[0]):
   n=struct.unpack_from('<H',raw,pos)[0];pos+=2;k=raw[pos:pos+n];pos+=n;n=struct.unpack_from('<H',raw,pos)[0];pos+=2;v=raw[pos:pos+n];pos+=n
   if k==b'TApplication.swf':v=VERSION;found+=1
   parts.extend([struct.pack('<H',len(k)),k,struct.pack('<H',len(v)),v])
  assert found==1 and pos==len(raw)
  backup=work/'backups';backup.mkdir(exist_ok=True)
  for original in [canonical,version]:
   target=backup/original.name
   if not target.exists():shutil.copy2(original,target)
  protected=h.swap(rebuilt);dest=h.PUBLIC/VERSION.decode()/'TApplication.swf';dest.parent.mkdir(exist_ok=True);dest.write_bytes(protected);canonical.write_bytes(protected);version.write_bytes(zlib.compress(b''.join(parts)))
  for folder in ['pain-tendo','hashirama-final']:(BASE/folder/'patched'/ROLE).write_text(verified)
 print('PASS sharp streaming VFX',VERSION.decode(),'installed',a.install,'; unrelated role methods, native UI, Inspector and battle speed unchanged')
if __name__=='__main__':main()
