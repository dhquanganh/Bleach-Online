"""Incrementally install Pain playback, original VFX, TP display and status text."""
from pathlib import Path
import argparse,importlib.util,json,shutil,struct,subprocess,zlib
BASE=Path(__file__).resolve().parent
spec=importlib.util.spec_from_file_location('h',BASE.parent/'naruto-sage/verify-client.py');h=importlib.util.module_from_spec(spec);spec.loader.exec_module(h)
ROLE=Path('Processors/Game/Battle/Character/TRole.as');ACTIVE=Path('Processors/Game/Battle/Character/TActive.as');STAGE=Path('Processors/Game/Battle/TBattleStage.as')
def main():
 parser=argparse.ArgumentParser();parser.add_argument('--ffdec',required=True);parser.add_argument('--install',action='store_true');args=parser.parse_args()
 canonical=h.PUBLIC/'2026090619/TApplication.swf';old=canonical.read_bytes();decoded=h.swap(old)
 previous=BASE/'compiled.swf';backup=BASE/'backups/TApplication.swf'
 if previous.exists() and backup.exists() and old==h.swap(previous.read_bytes()):decoded=h.swap(backup.read_bytes())
 source=BASE/'source.swf';source.write_bytes(decoded)
 def ff(*a):subprocess.run(['java','-Xmx2g','-jar',args.ffdec,*map(str,a)],check=True)
 ff('-selectclass','Processors.Game.Battle.Character.TRole,Processors.Game.Battle.Character.TActive,Processors.Game.Battle.TBattleStage','-export','script',BASE/'original',source)
 role=(BASE/'original/scripts'/ROLE).read_text(encoding='utf-8');assert 'function UpdatePainVfx(' not in role,'Pain is already installed'
 def rep(s,a,b):assert a in s,a;return s.replace(a,b)
 role=rep(role,'      private var FObitoVfxStarted:Boolean','      private var FPainVfxStarted:Boolean=false;\n      private static var FPainFxCache:Object={};\n      private static var FPainFxLoading:Object={};\n      private var FPainTechnique:TextField;\n      private var FObitoVfxStarted:Boolean')
 role=rep(role,'         FSkilling = IsSkill(FSkillId);','         FSkilling = IsSkill(FSkillId);\n         if(FId == 11120930) FPainVfxStarted=false;')
 role=rep(role,'         this.UpdateObitoVfx();','         this.UpdateObitoVfx();\n         this.UpdatePainVfx();')
 start=role.index('      public function ChangeHP(');body=role.index('{',start)+1
 role=role[:body]+'''
         if(param1 < 0 && FId == 11120930 && (CurHealth <= 0 || FIsDie || FWaitDie)) {
            CurHealth -= param1;
            if(CurHealth > 0) RestorePainAfterRevival();
            return;
         }
'''+role[body:]
 start=role.index('      public function PrepareBattleRole()');body=role.index('      {',start)+len('      {')
 role=role[:body]+'''\n         if(FPainTechnique != null) FPainTechnique.visible=FId==11120930;
         if(FId == 11120930)
         {
            PreloadPainVfx();FPainFinal=false;
            if(FPainTechnique == null){FPainTechnique=new TextField();FPainTechnique.mouseEnabled=false;FPainTechnique.selectable=false;addChild(FPainTechnique);}
            FPainTechnique.defaultTextFormat=new TextFormat("Arial",13,0xDBBBFF,true,null,null,null,null,"center");
            FPainTechnique.width=150;FPainTechnique.height=25;FPainTechnique.y=-195;FPainTechnique.scaleX=scaleX<0?-1:1;FPainTechnique.x=scaleX<0?75:-75;
            FPainTechnique.filters=[new GlowFilter(0x100020,1,4,4,4)];FPainTechnique.text="TP 0 / 5";
         }
'''+role[body:]
 runtime=(BASE.parent/'shared-animation/raster-vfx.as.txt').read_text(encoding='utf-8');runtime=runtime.replace('RasterTemplate','Pain').replace('rasterTemplate','pain')
 runtime=runtime.replace('var image:Bitmap = new Bitmap();image.smoothing = true;layer.addChild(image);','var image:Bitmap = new Bitmap();image.smoothing = true;if(clip.additive)image.blendMode="add";layer.addChild(image);')
 runtime=runtime.replace('behind:Boolean = false) : void','behind:Boolean = false, angle:Number = 0) : void')
 runtime=runtime.replace('layer.x=point.x;layer.y=point.y;layer.scaleX=mirrored ? -1 : 1;','layer.x=point.x;layer.y=point.y;layer.scaleX=mirrored ? -1 : 1;layer.rotation=angle;')
 manifest=json.loads((BASE/'vfx.json').read_text())
 for key,clip in manifest['clips'].items():
  folders=list((BASE/'native-export'/key.rsplit('-',1)[0]).glob('DefineSprite_'+key.rsplit('-',1)[1]+'_*'));assert len(folders)==1,key
  clip['action']=folders[0].name.split('_',2)[2]
  if clip['action']=='texie':clip['pivot']=[.5,.5]
  elif key.startswith(('PEpugong1','PEzhuida','PEaoyi1')):clip['pivot'][0]=.5
  if key in ['Peienchaoshenshenluotianzheng_aoyi-115','Peienchaoshenshenluotianzheng_aoyi-686','PEaoyi2-414']:clip['additive']=True
  if key=='PEaoyi2-12':clip['screen']=True;clip['pivot']=[.5,.5]
  if key=='PEaoyi2-414':clip['pivot']=[.25,.60]
 runtime=runtime.replace('__RASTER_VFX_MANIFEST__',json.dumps(json.dumps(manifest,separators=(',',':'))))
 runtime+=(BASE/'runtime.as.txt').read_text(encoding='utf-8')
 runtime+=(BASE/'revival-visual.as.txt').read_text(encoding='utf-8')
 runtime+=(BASE.parent/'obito-rage/status-text.as.txt').read_text(encoding='utf-8').replace('Obito','Pain').replace('obito','pain')
 role=rep(role,'      override public function UpdateActive()',runtime+'\n      override public function UpdateActive()')
 role=rep(role,'               this.ObitoStandardPose(_loc4_);','               this.ObitoStandardPose(_loc4_);\n               this.PainStrikePose(_loc4_);')
 role=rep(role,'         if(FCurrentRebirthSequence != null)','         if(!this.FHasFrozen) this.PainFlightPose(_loc4_);\n         if(FCurrentRebirthSequence != null)')
 final_return=json.loads((BASE/'animation.json').read_text())['clips']['extreme']['returnFrame']
 role=rep(role,'            _loc5_ = _loc4_.Surface;',f'''            if(FId == 11120930 && FPainFinal && FSkillId == 13120973 && FFrameIndex == {final_return} && FTextureFightIdle.Count > 1)
               _loc4_=FTextureFightIdle.GetAnimationSequenceByIndex(1).GetAnimationFrameByIndex(0);
            _loc5_ = _loc4_.Surface;''')
 start=role.index('      public function AddTextEffectByCMD(');body=role.index('      {',start)+len('      {')
 labels='''
         var painMarker:uint=uint(param1.ResultInfo.BuffId);
         if(param1.CMD == TTargetInfo.CMD_FLOAT && painMarker >= 19000801 && painMarker <= 19000814)
         {
            var painNames:Array=["TECHNIQUE POINTS","HORROR II / FEAR","CHAKRA DISRUPTION II","PAIN II","MYSTERY CHAKRA COST","INTERRUPTION","INITIATIVE","ATTACK GROWTH","LIFE STEAL","CHAKRA LIMIT","CHAKRA REMOVED","IMMUNE TO INTERRUPTION / RINNEGAN MYSTERIES UNAVOIDABLE","FINAL FORM / REVIVE 100%","FINAL REVIVE 40% / SUPER PUSH"];
            var painMessage:String=painNames[painMarker-19000801];
            var painValue:int=int(param1.ResultInfo.BuffTurn);
            if(painMarker == 19000801){painMessage="TP "+(painValue/10)+" / 5";if(FPainTechnique != null)FPainTechnique.text=(FPainFinal?"FINAL / ":"")+painMessage;}
            if(painMarker == 19000805 || painMarker == 19000810 || painMarker == 19000811) painMessage+=" "+painValue;
            if(painMarker == 19000807 || painMarker == 19000808) painMessage+=" +"+painValue+"%";
            if(painMarker == 19000809) painMessage+=" +"+painValue+" HP";
            if(painMarker == 19000813){FPainFinal=true;if(FPainTechnique != null)FPainTechnique.text="FINAL / "+FPainTechnique.text;}
            ShowPainStatusText(painMessage,painMarker >= 19000802 && painMarker <= 19000806?0xFFAA99:0xD1B6FF);
            return;
         }
'''
 role=role[:body]+labels+role[body:]
 active=(BASE/'original/scripts'/ACTIVE).read_text(encoding='utf-8')
 active=rep(active,'      protected var FId:uint;','      protected var FId:uint;\n      protected var FPainFinal:Boolean=false;')
 active=rep(active,'         this.FId = param2;','         this.FId = param2;\n         this.FPainFinal=false;')
 active=rep(active,'         this.FCurSequence = this.FTextureFightIdle.GetAnimationSequenceByIndex(_loc1_);','''         if(this.FId == 11120930) _loc1_=uint(this.FPainFinal && this.FTextureFightIdle.Count > 1 ? 1 : 0);
         this.FCurSequence = this.FTextureFightIdle.GetAnimationSequenceByIndex(_loc1_);''')
 start=active.index('      public function IsSkill(');body=active.index('      {',start)+len('      {');active=active[:body]+'\n         if(this.FId == 11120930 && param1 >= 13120971 && param1 <= 13120979) return param1 != 13120974;'+active[body:]
 token='         this.FCurSequence = this.FTextureSkill.GetAnimationSequenceByIndex(_loc1_);'
 active=rep(active,token,'''         if(this.FId == 11120930 && this.FTextureSkill.Count >= 7)
         {
            _loc1_=uint(this.FSkillId==13120972 || this.FSkillId==13120973?1:this.FSkillId==13120975?2:this.FSkillId==13120976?3:this.FSkillId==13120977?4:this.FSkillId==13120978?5:this.FSkillId==13120979?6:0);
         }
'''+token)
 stage=(BASE/'original/scripts'/STAGE).read_text(encoding='utf-8')
 token='battleRasterHost.getChildAt(battleRasterIndex).name == "hashiramaSkillVfx"'
 stage=rep(stage,token,'('+token+' || battleRasterHost.getChildAt(battleRasterIndex).name == "painSkillVfx" || battleRasterHost.getChildAt(battleRasterIndex).name.indexOf("painStatus_") == 0)')
 for rel,value in [(ROLE,role),(ACTIVE,active),(STAGE,stage)]:
  f=BASE/'patched'/rel;f.parent.mkdir(parents=True,exist_ok=True);f.write_text(value,encoding='utf-8')
 output=BASE/'compiled.swf';ff('-onerror','abort','-importScript',source,output,BASE/'patched');rebuilt=output.read_bytes()
 assert [t for t in h.tags(decoded) if t[0]!=82]==[t for t in h.tags(rebuilt) if t[0]!=82]
 ff('-selectclass','Processors.Game.Battle.Character.TRole,Processors.Game.Battle.Character.TActive','-export','script',BASE/'verify',output)
 verified=(BASE/'verify/scripts'/ROLE).read_text(encoding='utf-8');assert all(x in verified for x in ['UpdatePainVfx','ShowPainStatusText','UpdateObitoVfx','PEaoyi1','CHAKRA DISRUPTION II'])
 if args.install:
  assert canonical.read_bytes()==old,'Live client changed while compiling'
  manifest=h.PUBLIC/'2026090619/version.swf';raw=zlib.decompress(manifest.read_bytes());p=2;parts=[raw[:2]];version=b'2026101952'
  for _ in range(struct.unpack_from('<H',raw)[0]):
   n=struct.unpack_from('<H',raw,p)[0];p+=2;k=raw[p:p+n];p+=n;n=struct.unpack_from('<H',raw,p)[0];p+=2;v=raw[p:p+n];p+=n
   if k==b'TApplication.swf':v=version
   parts.extend([struct.pack('<H',len(k)),k,struct.pack('<H',len(v)),v])
  (BASE/'backups').mkdir(exist_ok=True)
  for f in [canonical,manifest]:
   backup=BASE/'backups'/f.name
   if not backup.exists():shutil.copy2(f,backup)
  dest=h.PUBLIC/version.decode()/'TApplication.swf';dest.parent.mkdir(exist_ok=True);dest.write_bytes(h.swap(rebuilt));canonical.write_bytes(h.swap(rebuilt));manifest.write_bytes(zlib.compress(b''.join(parts)))
 print('PASS Pain original VFX, deterministic animations, TP/status UI, cleanup; preserved existing client patches; installed',args.install)
if __name__=='__main__':main()
