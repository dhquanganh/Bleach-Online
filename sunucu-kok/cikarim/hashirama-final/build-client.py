"""Patch the current live client, retaining Pain/Obito/Tower and all later fixes."""
from pathlib import Path
import argparse,importlib.util,json,re,shutil,struct,subprocess,zlib
from PIL import Image
BASE=Path(__file__).resolve().parent
spec=importlib.util.spec_from_file_location('h',BASE.parent/'naruto-sage/verify-client.py');h=importlib.util.module_from_spec(spec);spec.loader.exec_module(h)
ROLE=Path('Processors/Game/Battle/Character/TRole.as');ACTIVE=Path('Processors/Game/Battle/Character/TActive.as');STAGE=Path('Processors/Game/Battle/TBattleStage.as');FORMATION=Path('Processors/Game/Lobby/TacticalDeployment/Components/THeroDeployment.as')
VERSION=b'2026101961'
def rep(s,a,b):assert a in s,a;return s.replace(a,b)
def method_end(s,start):
 end=s.index('{',start)+1;depth=1
 while depth:depth+=(s[end]=='{')-(s[end]=='}');end+=1
 return end
def effect_manifest():
 manifest=json.loads((BASE/'vfx.json').read_text())
 manifest['effectAnchors']={}
 hits={'Zhujianzhongyanmingshenfenglong':51,'Zhujianzhongyandingshanghuafo':93,'Zhujianzhongyanbangpaizhishu':20,'Zhujianzhongyanshujiejiangdan':35,'Zhujianzhongyanhuashujiejianglin':40}
 for effect,hit in hits.items():
  if effect not in manifest['effects']:continue
  boxes=[];focal=None
  for name in manifest['effects'][effect]:
   clip=manifest['clips'][name];tick=min(hit,len(clip['timeline'])-1);atlas=manifest['atlases'][clip.get('frameAtlases',[clip['atlas']]*len(clip['timeline']))[tick]]
   sheet=Image.open(h.PUBLIC.parent/atlas['url'].lstrip('/'))
   i=clip['timeline'][min(hit,len(clip['timeline'])-1)];x=i%atlas['columns']*clip['width'];y=i//atlas['columns']*clip['height']
   box=sheet.crop((x,y,x+clip['width'],y+clip['height'])).getbbox()
   if effect=='Zhujianzhongyanmingshenfenglong':
    frame=sheet.crop((x,y,x+clip['width'],y+clip['height'])).convert('RGBA')
    red=[(i%frame.width,i//frame.width) for i,(r,g,b,a) in enumerate(frame.getdata()) if a>64 and r>45 and r>g*1.35 and r>b*1.15]
    if red:
     focal=[(min(t[0] for t in red)-clip['pivot'][0]*clip['width'])/clip['renderScale'],(max(t[0] for t in red)-clip['pivot'][0]*clip['width'])/clip['renderScale']]
   if box:boxes.append([(box[j]-clip['pivot'][j%2]*[clip['width'],clip['height']][j%2])/clip['renderScale'] for j in range(4)])
  assert boxes,effect
  manifest['effectAnchors'][effect]=[(sum(focal)/2 if focal else (min(b[0] for b in boxes)+max(b[2] for b in boxes))/2),max(b[3] for b in boxes)]
 for name,clip in manifest['clips'].items():
  if 'texie' in name:clip['pivot']=[.5,.5]

 # Anchor the crater at its ground contact plane, not falling debris/alpha bottom.
 ground=manifest['clips']['Zhujianzhongyanbangpaizhishu-54']
 manifest['effectAnchors']['Zhujianzhongyanbangpaizhishu']=[
  (.53-ground['pivot'][0])*ground['width']/ground['renderScale'],
  (.68-ground['pivot'][1])*ground['height']/ground['renderScale']]
 return manifest

def main():
 p=argparse.ArgumentParser();p.add_argument('--ffdec',required=True);p.add_argument('--install',action='store_true');args=p.parse_args()
 canonical=h.PUBLIC/'2026090619/TApplication.swf';old=canonical.read_bytes();decoded=h.swap(old)
 previous=BASE/'compiled.swf';backup=BASE/'backups/TApplication.swf'
 if previous.exists() and backup.exists() and old==h.swap(previous.read_bytes()):decoded=h.swap(backup.read_bytes())
 source=BASE/'source.swf';source.write_bytes(decoded)
 def ff(*a):subprocess.run(['java','-Xmx2g','-jar',args.ffdec,*map(str,a)],check=True)
 classes=','.join(str(x.with_suffix('')).replace('\\','.').replace('/','.') for x in [ROLE,ACTIVE,STAGE,FORMATION])
 ff('-selectclass',classes,'-export','script',BASE/'original',source)
 role=(BASE/'original/scripts'/ROLE).read_text(encoding='utf-8');assert 'function UpdateHashiramaVfx(' not in role,'Already installed; use installed source for incremental changes'
 role=rep(role,'      private var FPainVfxStarted:Boolean','      private var FCombatVfxSerial:uint=0;\n      private var FHashiramaVfxStarted:Boolean=false;\n      private static var FHashiramaFxCache:Object={};\n      private static var FHashiramaFxLoading:Object={};\n      private var FPainVfxStarted:Boolean')
 role=rep(role,'         FSkilling = IsSkill(FSkillId);','         FSkilling = IsSkill(FSkillId);\n         ++FCombatVfxSerial;\n         if(FId==11120940)FHashiramaVfxStarted=false;')
 role=rep(role,'         this.UpdatePainVfx();','         this.UpdatePainVfx();\n         this.UpdateHashiramaVfx();')
 role=rep(role,'         if(FCurrentRebirthSequence != null)','         if(!this.FHasFrozen) this.HashiramaStrikePose(_loc4_);\n         if(FCurrentRebirthSequence != null)')
 start=role.index('      public function PrepareBattleRole(');body=role.index('{',start)+1
 role=role[:body]+'\n         if(FId==11120940){FHashiramaVfxStarted=false;PreloadHashiramaVfx();}\n'+role[body:]
 runtime=(BASE/'native-runtime.as.txt').read_text()+'\n'+(BASE/'runtime.as.txt').read_text()
 start=runtime.index('      private static function HashiramaVfxManifest(');end=method_end(runtime,start)
 manifest=effect_manifest()

 runtime=runtime[:start]+'      private static function HashiramaVfxManifest() : Object\n      {return JSON.parse('+json.dumps(json.dumps(manifest,separators=(',',':')))+');}\n'+runtime[end:]
 role=rep(role,'      override public function UpdateActive()',runtime+'\n      override public function UpdateActive()')
 start=role.index('      public function AddTextEffectByCMD(');body=role.index('{',start)+1
 labels='''
         var hashMarker:uint=uint(param1.ResultInfo.BuffId);
         if(param1.CMD==TTargetInfo.CMD_FLOAT && hashMarker>=19000901 && hashMarker<=19000917)
         {
            var hashValue:int=int(param1.ResultInfo.BuffTurn);
            var hashNames:Array=["","TECHNIQUE POINTS","EXCITED MODE","DEEP FOREST / EXPLOSIVE 2 ROUNDS","MYSTERY DAMAGE","DEITY GATE SEAL II","WEAKNESS II","IRREMOVABLE ENFEEBLE","ROOT BINDING II","INTERRUPTION","SENJUTSU GROWTH","LIFE STEAL / HEAL","CHAKRA ABSORBED","STANDARD ATTEMPTS -1","EXTRA STANDARD","SUPPRESS IMMUNITY","EVASION CAP 20%","DEEP FOREST ENDED"];
            var hashMessage:String=hashNames[hashMarker-19000900];
            if(hashMarker==19000901)hashMessage="TP "+(hashValue/10)+" / 2";
            if(hashMarker==19000904)hashMessage+=" +"+hashValue+"%";
            if(hashMarker==19000910)hashMessage+=" +3%";
            if(hashMarker==19000911)hashMessage+=" +"+hashValue+" HP";
            if(hashMarker==19000912)hashMessage+=" +"+hashValue;
            ShowHashiramaStatusText(hashMessage,hashMarker>=19000905 && hashMarker<=19000909?0xFFAD82:0xB7F18A);return;
         }
'''
 role=role[:body]+labels+role[body:]
 # Reapply the current Pain animation fixes when rebuilding from the original backup.
 pain=(BASE.parent/'pain-tendo/runtime.as.txt').read_text()
 for name,text in [('ShowPainVfx',pain),('PainStrikePose',pain),('PlayPainVfxAsset',(BASE.parent/'pain-tendo/rod-raster.as.txt').read_text())]:
  start=role.index('      private function '+name+'(');end=method_end(role,start)
  begin=text.index('      private function '+name+'(');finish=method_end(text,begin)
  role=role[:start]+text[begin:finish]+role[end:]
 role=rep(role,'               this.PainStrikePose(_loc4_);','')
 role=rep(role,'         if(FCurrentRebirthSequence != null)','         if(!this.FHasFrozen) this.PainStrikePose(_loc4_);\n         if(FCurrentRebirthSequence != null)')
 active=(BASE/'original/scripts'/ACTIVE).read_text(encoding='utf-8')
 start=active.index('      public function IsSkill(');body=active.index('{',start)+1
 active=active[:body]+'\n         if(this.FId==11120940 && param1>=13121001 && param1<=13121010)return param1!=13121006 && param1!=13121007;\n'+active[body:]
 token='         this.FCurSequence = this.FTextureAttack.GetAnimationSequenceByIndex(_loc1_);'
 active=rep(active,token,'         if(this.FId==11120940 && this.FTextureAttack.Count>=2)_loc1_=uint(this.FSkillId==13121007?1:0);\n'+token)
 start=active.index('      protected function PlaySkill(');body=active.index('{',start)+1
 active=active[:body]+'''
         if(this.FId==11120940 && (this.FSkillId==13121006 || this.FSkillId==13121007))
         {this.FCallBackDict[TYPE_ACTIVE_ATTACK]=this.FCallBackDict[TYPE_ACTIVE_SKILL];this.FTimeDict[TYPE_ACTIVE_ATTACK]=this.FTimeDict[TYPE_ACTIVE_SKILL];this.PlayAttack();return;}
'''+active[body:]
 token='         this.FCurSequence = this.FTextureSkill.GetAnimationSequenceByIndex(_loc1_);'
 active=rep(active,token,'''         if(this.FId==11120940 && this.FTextureSkill.Count>=8)
         {_loc1_=uint(this.FSkillId==13121002?1:this.FSkillId==13121003?2:this.FSkillId==13121004?3:this.FSkillId==13121005?4:this.FSkillId==13121008?5:this.FSkillId==13121009?6:this.FSkillId==13121010?7:0);}
'''+token)
 stage=(BASE/'original/scripts'/STAGE).read_text(encoding='utf-8')
 token='battleRasterHost.getChildAt(battleRasterIndex).name == "hashiramaSkillVfx"'
 stage=rep(stage,token,'('+token+' || battleRasterHost.getChildAt(battleRasterIndex).name=="hashiramaSkillVfx" || battleRasterHost.getChildAt(battleRasterIndex).name.indexOf("hashiramaStatus_")==0)')
 formation=(BASE/'original/scripts'/FORMATION).read_text(encoding='utf-8')
 # Keep formation capacity, ownership and position validation; relax only the row restriction.
 formation=rep(formation,'this.FSelectHero.StandPositionWithProfession != int(_loc2_ / INDEX_STAMP) + 1','this.FSelectHero.Identifier != 11120940 && this.FSelectHero.StandPositionWithProfession != int(_loc2_ / INDEX_STAMP) + 1')
 for x in ['_loc2_','_loc1_','this.FMouseInIndex']:
  oldcond='this.FSelectHero.StandPositionWithProfession == int('+x+' / INDEX_STAMP) + 1'
  formation=rep(formation,oldcond,'(this.FSelectHero.Identifier==11120940 || '+oldcond+')')
 formation=rep(formation,'if(int(_loc2_ / INDEX_STAMP) + 1 != param1)','if((this.FSelectHero==null || this.FSelectHero.Identifier!=11120940) && int(_loc2_ / INDEX_STAMP) + 1 != param1)')
 formation=rep(formation,'if(int(_loc2_ / INDEX_STAMP) + 1 == param1)','if((this.FSelectHero!=null && this.FSelectHero.Identifier==11120940) || int(_loc2_ / INDEX_STAMP) + 1 == param1)')
 for rel,value in [(ROLE,role),(ACTIVE,active),(STAGE,stage),(FORMATION,formation)]:
  f=BASE/'patched'/rel;f.parent.mkdir(parents=True,exist_ok=True);f.write_text(value,encoding='utf-8')
 output=BASE/'compiled.swf';ff('-onerror','abort','-importScript',source,output,BASE/'patched');rebuilt=output.read_bytes()
 assert [t for t in h.tags(decoded) if t[0]!=82]==[t for t in h.tags(rebuilt) if t[0]!=82]
 ff('-selectclass',classes+',Processors.Game.Lobby.SkyTower.TProcessorSkyTower','-export','script',BASE/'verify',output)
 verified=(BASE/'verify/scripts'/ROLE).read_text(encoding='utf-8')
 for token in ['UpdateHashiramaVfx','HashiramaStrikePose','ShowHashiramaStatusText','PainFlightPose','RestorePainAfterRevival','ShowPainLaserImpact','UpdateObitoVfx']:assert token in verified,token
 tower=(BASE/'verify/scripts/Processors/Game/Lobby/SkyTower/TProcessorSkyTower.as').read_text();assert 'GoldPrimogem' in tower and 'current.atk' in tower
 if args.install:
  assert canonical.read_bytes()==old,'Client changed during compilation'
  manifestFile=canonical.parent/'version.swf';raw=zlib.decompress(manifestFile.read_bytes());pos=2;parts=[raw[:2]];found=0
  for _ in range(struct.unpack_from('<H',raw)[0]):
   n=struct.unpack_from('<H',raw,pos)[0];pos+=2;k=raw[pos:pos+n];pos+=n;n=struct.unpack_from('<H',raw,pos)[0];pos+=2;v=raw[pos:pos+n];pos+=n
   if k==b'TApplication.swf':v=VERSION;found+=1
   parts.extend([struct.pack('<H',len(k)),k,struct.pack('<H',len(v)),v])
  assert found==1 and pos==len(raw)
  for original in [canonical,manifestFile]:
   backup=BASE/'backups'/original.name;backup.parent.mkdir(exist_ok=True)
   if not backup.exists():shutil.copy2(original,backup)
  protected=h.swap(rebuilt);dest=h.PUBLIC/VERSION.decode()/'TApplication.swf';dest.parent.mkdir(exist_ok=True);dest.write_bytes(protected);canonical.write_bytes(protected);manifestFile.write_bytes(zlib.compress(b''.join(parts)))
 print('PASS deterministic Hashirama animations, original giant VFX, all formation rows, status text; preserved live features; version',VERSION.decode(),'installed',args.install)
if __name__=='__main__':main()
