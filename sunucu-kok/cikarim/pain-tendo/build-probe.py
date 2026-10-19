"""Exercise installed textures and production VFX in isolated native Flash 22."""
from pathlib import Path
import argparse,json,re,subprocess
BASE=Path(__file__).resolve().parent
def main():
    p=argparse.ArgumentParser();p.add_argument('--ffdec',required=True);p.add_argument('--status-check',action='store_true');p.add_argument('--laser-check',action='store_true');p.add_argument('--flight-check',action='store_true');p.add_argument('--motion-check',action='store_true');p.add_argument('--revival-check',action='store_true');args=p.parse_args()
    animation=json.loads((BASE/'animation.json').read_text())
    production=(BASE/('status-patched' if args.status_check else 'patched')/'Processors/Game/Battle/Character/TRole.as').read_text(encoding='utf-8')
    pieces=[]
    for name in ['PainVfxManifest','PreloadPainVfx','LoadPainVfxAtlas','PlayPainVfxAsset','UpdatePainVfx','ShowPainVfx','ShowPainLaserImpact','ShowPainStatusText','PainStrikePose','PainFlightPose']:
        signature=re.search(r'      private (?:static )?function '+name+r'\(',production)
        if signature is None:continue
        start=signature.start();end=production.index('{',start)+1;depth=1
        while depth:
            depth+=(production[end]=='{')-(production[end]=='}');end+=1
        pieces.append(production[start:end])
    methods='\n'.join(pieces).replace('TRole','TApplication')
    methods=methods.replace('FPainFxCache[name] = frames;','FPainFxCache[name] = frames; report("ATLAS "+name);')
    methods=methods.replace('failed = function(event:Event):void {release();loader.unload();};','failed = function(event:Event):void {report("ERROR atlas "+name);release();loader.unload();};')
    # Static atlas loader cannot call instance report.
    methods=methods.replace('report("ATLAS "+name);','if(ExternalInterface.available)ExternalInterface.call("vfxProbe","ATLAS "+name);').replace('report("ERROR atlas "+name);','if(ExternalInterface.available)ExternalInterface.call("vfxProbe","ERROR atlas "+name);')
    methods=methods.replace('location=muzzle;paintHost=FBattleStage;', 'location=muzzle;paintHost=FBattleStage; report("LASER_PATH camp="+Camp+" muzzle="+muzzle.x+","+muzzle.y+" aim="+aim.x+","+aim.y+" length="+length);')
    methods=methods.replace('var caster:TApplication = this;','var caster:TApplication = this; report("VFX_ASSET "+name+" mirror="+mirrored);')
    if 'VFX_ASSET ' not in methods:
        methods=re.sub(r'\bcaster\s*=\s*this;', 'caster=this; report("VFX_ASSET "+name+" mirror="+mirrored);',methods)
    methods=methods.replace('h=Math.max(850,(bottom-top+160)*2.2);','h=Math.max(850,(bottom-top+160)*2.2); report("LASER_AOE count="+count+" width="+w+" height="+h);')
    methods=methods.replace('var host:DisplayObjectContainer=FBattleStage;','report("POWER_FX laser impact"); var host:DisplayObjectContainer=FBattleStage;')
    methods=methods.replace('var wood:Boolean =','report("POWER_FX "+skill+" phase="+(charge?"charge":"impact")+" delay="+delay);\n         var wood:Boolean =')
    source=(BASE.parent/'jiraiya-toads/vfx-probe.as.txt').read_text(encoding='utf-8-sig')
    source=source.replace('11120903','11120930').replace('Jiraiya','Pain').replace('FPainVfxHit','FUnusedVfxHit')
    source=source.replace('  private static var FPainShake:Object=null;','  private static var FPainFxCache:Object={};\n  private static var FPainFxLoading:Object={};')
    source=source.replace('stage.frameRate=30;','stage.frameRate=25;')
    ids=list(map(int,animation['moves']));names=list(animation['moves'].values())
    source=re.sub(r'private var skills:Array=\[.*?\];','private var skills:Array='+json.dumps(ids)+';',source)
    source=re.sub(r'private var clipNames:Array=\[.*?\];','private var clipNames:Array='+json.dumps(names)+';',source)
    source=source.replace('__METADATA__',json.dumps(animation['clips'],separators=(',',':')))
    source=source.replace('right=new TApplication(false);','right=new TApplication(false);PreloadPainVfx();')
    hero=11120930
    source=source.replace('00A9B107',f'{hero:08X}').replace('A9B1070B',f'{hero:X}0B').replace('A9B1070C',f'{hero:X}0C')
    source=source.replace(f'loadTexture("{hero:08X}",["idle"]);',f'loadTexture("{hero:X}0A",["idle","final-idle"]);')
    source=source.replace('["giant-gallant-rasengan"]','["standard"]')
    source=source.replace('["toad-mouth-barrier","toad-confrontation-chant","raging-lions-mane","senjutsu-power","tale-of-jiraiya-revival"]','["almighty","extreme","chase","laser","revive","final-revive","super"]')
    source=source.replace('if(leap){var pose:Object=role.PainRasenganPose();role.actor.x+=Number(pose.x);role.actor.y+=Number(pose.y);}','')
    source=source.replace('if(loaded<7)return;','if(loaded<8)return;')
    source=source.replace('4000','5000').replace('slot>=12','slot>=18').replace('slot<6?0:1','slot<9?0:1').replace('slot%6','slot%9')
    source=source.replace('    if(slot==6)SetPainBarrier(battle,false);','')
    source=source.replace('SetPainBarrier(battle,false);report("DONE shared native component; background cleared="+(battle.getChildByName("jiraiyaEsophagusBackdrop")==null));','var remaining:int=0;var hosts:Array=[battle];while(hosts.length){var fxHost:DisplayObjectContainer=hosts.pop() as DisplayObjectContainer;for(var q:int=0;q<fxHost.numChildren;q++){var child:DisplayObject=fxHost.getChildAt(q);if(child.name=="painSkillVfx")remaining++;if(child is DisplayObjectContainer)hosts.push(child);}} report("DONE Pain native component; remaining="+remaining);')
    source=source.replace('var hit:int=index==0?24:(metadata[name].hitFrames!=null?int(metadata[name].hitFrames[0]):8);','var hit:int=metadata[name].hitFrames!=null?int(metadata[name].hitFrames[0]):10;')
    source=source.replace('   var pose:String=', '''   var hitKey:String="HIT-"+skills[index]+"-camp-"+side;
   if(frame>=hit && !captured[hitKey]){captured[hitKey]=true;var hitStarted:int=getTimer();saveFrame(hitKey);readyAt+=getTimer()-hitStarted;}
   var pose:String=''')
    fields=source[source.index('  private var FId:'):source.index('  private var clips:')].replace('private var','public var').replace('private const','public const').replace('private static var','public static var')
    methods=methods.replace('TApplication','ProbeRole').replace('private function','public function').replace('private static function','public static function')
    source=source.replace('left=new TApplication(false);right=new TApplication(false);PreloadPainVfx();','left=new ProbeRole();right=new ProbeRole();ProbeRole.PreloadPainVfx();')
    source=source.replace('private var left:TApplication;','private var left:ProbeRole;').replace('private var right:TApplication;','private var right:ProbeRole;')
    source=source.replace('role:TApplication','role:ProbeRole').replace('caster:TApplication','caster:ProbeRole').replace('victim:TApplication','victim:ProbeRole')
    if args.status_check:
        start=source.index('   if(loaded<8)return;');end=source.index('  private function saveFrame(',start)
        source=source[:start]+"""
   if(loaded<8)return;
   if(readyAt<0){
      readyAt=getTimer();
      left.ShowPainStatusText("KAMUI",0xB9F47A);
      left.ShowPainStatusText("IMMOBILE",0xFFAA88);
      left.ShowPainStatusText("LIFE STEAL +120 HP",0xB9F47A);
      right.ShowPainStatusText("KAMUI TAG II",0xB9F47A);
      right.ShowPainStatusText("KNOCKDOWN",0xFFE299);
   }
   var age:int=getTimer()-readyAt;
   renderRole(left,"idle",int(age/100)%clips.idle.images.length);
   renderRole(right,"idle",int(age/100)%clips.idle.images.length);
   for each(var checkpoint:int in [1000,2400,3000,3500]){
      var tag:String="TEXT-"+checkpoint;
      if(age>=checkpoint&&!captured[tag]){
         captured[tag]=true;
         var count:int=0;
         var labelHost:DisplayObjectContainer=left.parent;
         for(var i:int=0;i<labelHost.numChildren;i++)if(labelHost.getChildAt(i).name.indexOf("painStatus_")==0)count++;
         if(count!=(checkpoint<3200?5:0))report("ERROR status lifetime at "+checkpoint+" count="+count);
         report("TEXT_CHECK "+checkpoint+" count="+count);saveFrame(tag);
      }
   }
   if(age>=3700){report("DONE status text; remaining=0");removeEventListener(Event.ENTER_FRAME,tick);}
  }
"""+source[end:]
    source=source.replace('if(loaded<8)return;','if(loaded<10)return;').replace('5000','8000')
    methods=methods.replace('frame:TAnimationFrame','frame:Object')
    fields+='\n public var FBitmap:Bitmap=actor;\n public var FPainFinal:Boolean=false;'
    if args.revival_check:
        start=production.index('      public function ChangeHP(')
        hp=production[start:production.index('      protected function OnMouseMove(',start)]
        start=production.index('      private function RestorePainAfterRevival(')
        end=production.index('      private function ShowPainStatusText(',start)
        restore=production[start:end].replace('private function','public function').replace('idle:TAnimationFrame','idle:Object')
        active=(BASE/'patched/Processors/Game/Battle/Character/TActive.as').read_text(encoding='utf-8')
        start=active.index('      protected function PlayFightIdle(')
        idle=active[start:active.index('      protected function PlayAttack(',start)].replace('protected function','public function')
        methods+=hp+restore+idle+'''
      public function RestoreKabutoAfterRevival():void {report("ERROR wrong hero recovery");}
      public function SetupPainIdle(base:Object,finalForm:Object):void {
         var sequences:Array=[];
         for each(var clip:Object in [base,finalForm])sequences.push({GetAnimationFrameByIndex:IdleFrames(clip)});
         FTextureFightIdle={Count:2,GetAnimationSequenceByIndex:function(i:int):Object{return sequences[i];}};
      }
      private function IdleFrames(clip:Object):Function {
         return function(i:int):Object{return {Surface:clip.images[i],Pivot:{X:clip.meta[i].px,Y:clip.meta[i].py}};};
      }
      public function SimulatePainRevival(surface:BitmapData,race:Boolean,amount:Number):void {
         FPainFinal=false;
         FIdlePosition=[x,y];CurHealth=0;FIsDie=!race;FWaitDie=true;
         FWaitNextCommand=true;FHideFrame=7;FHasFrozen=true;FHasGiddy=true;
         FIsAntiColorBlackWhite=true;FIsRedAntiColor=true;FSkillId=13120975;FSkilling=true;
         FCallBackDict[TYPE_ACTIVE_DIE]=function():void{report("ERROR stale death callback");};FTimeDict[TYPE_ACTIVE_DIE]=55;
         visible=false;alpha=0;FBitmap.visible=false;FBitmap.alpha=0;FBitmap.bitmapData=null;
         FShaderBmp.visible=false;FHpBar.visible=false;FBuffSprite.visible=false;
         FFrozenBitmap.visible=true;FGiddyBitmap.visible=true;
         filters=[new GlowFilter(0xFF0000)];FBitmap.filters=[new GlowFilter(0x00FF00)];
         x+=Camp==0?-20:20;
         FCurSequence={GetAnimationFrameByIndex:function(i:int):Object{return {Surface:surface,Pivot:{X:25,Y:151}};}};
         TweenUtil.to(this,1000,{alpha:0});TweenUtil.to(FBitmap,1000,{alpha:0});
         ChangeHP(-amount);
         if(!FPainFinal || CurHealth!=amount || FIsDie || FWaitDie || FWaitNextCommand || FHasFrozen || FHasGiddy || FIsAntiColorBlackWhite || FIsRedAntiColor || !visible || alpha!=1 || !FBitmap.visible || FBitmap.alpha!=1 || FBitmap.bitmapData!=surface || FFrameIndex!=-1 || FSkillId!=0 || FSkilling || FCallBackDict[TYPE_ACTIVE_DIE]!=null || FTimeDict[TYPE_ACTIVE_DIE]!=0 || !FHpBar.visible || !FShaderBmp.visible || !FBuffSprite.visible || FFrozenBitmap.visible || FGiddyBitmap.visible || filters.length || FBitmap.filters.length || x!=FIdlePosition[0] || y!=FIdlePosition[1])
            report("ERROR revival state camp="+Camp+" queued="+race);
         else report("RESTORE_OK camp="+Camp+" queued="+race+" hp="+CurHealth);
         var self:ProbeRole=this;
         setTimeout(function():void{
            if(!self.visible || self.alpha!=1 || !self.FBitmap.visible || self.FBitmap.alpha!=1 || self.FBitmap.bitmapData==null || self.FIsDie || self.FWaitDie)self.report("ERROR delayed death fade");
            else self.report("RESTORE_STABLE camp="+self.Camp);
         },1200);
      }
'''
        fields+='''
      public var FIsDie:Boolean=false;
      public var FSkilling:Boolean=false;
      public var FWaitDie:Boolean=false;
      public var FWaitNextCommand:Boolean=false;
      public var FHideFrame:int=-1;
      public var FHasFrozen:Boolean=false;
      public var FHasGiddy:Boolean=false;
      public var FIsAntiColorBlackWhite:Boolean=false;
      public var FIsRedAntiColor:Boolean=false;
      public var FCallBackDict:Object={};
      public var FTimeDict:Object={};
      public const TYPE_ACTIVE_DIE:int=9;
      public const TYPE_ACTIVE_FIGHT_IDLE:int=3;
      public var FTextureFightIdle:Object;
      public var FShaderBmp:Sprite=new Sprite();
      public var FHpBar:Sprite=new Sprite();
      public var FBuffSprite:Sprite=new Sprite();
      public var FFrozenBitmap:Bitmap=new Bitmap();
      public var FGiddyBitmap:Bitmap=new Bitmap();
      public var FIdlePosition:Array;
      public var CurHealth:Number=10000;
      public var FShieldBlood:Number=0;
      public var FShieldBitmap:Bitmap=new Bitmap();
      public var FTickReference:uint=0;
      public var FCurSequence:Object;
'''
        source=source.replace(' import flash.external.ExternalInterface;', ' import flash.external.ExternalInterface;\n import ghostcat.util.easing.TweenUtil;')
        source=re.sub(r'private var skills:Array=\[.*?\];','private var skills:Array=[13120977,13120978,13120979,13120977,13120978,13120979];',source)
        source=re.sub(r'private var clipNames:Array=\[.*?\];','private var clipNames:Array=["revive","final-revive","super","revive","final-revive","super"];',source)
        source=source.replace('slot>=18','slot>=12').replace('slot<9?0:1','slot<6?0:1').replace('slot%9','slot%6')
        source=source.replace('    left.FSkillId=0;right.FSkillId=0;', '    caster.SetupPainIdle(clips.idle,clips["final-idle"]);\n    caster.SimulatePainRevival(clips["final-idle"].images[0],index>=3,index%3==0?10000:4000);\n    caster.FIndex=2;\n    left.FSkillId=0;right.FSkillId=0;')
        source=source.replace('renderRole(caster,"idle",int(age/100)%clips.idle.images.length);','var idleName:String=caster.FPainFinal?"final-idle":"idle";renderRole(caster,idleName,int(age/40)%clips[idleName].images.length);')
        source=source.replace('renderRole(victim,"idle",int(age/100)%clips.idle.images.length);','var victimIdle:String=victim.FPainFinal?"final-idle":"idle";renderRole(victim,victimIdle,int(age/40)%clips[victimIdle].images.length);')
        source=source.replace('   var hitKey:String=', '''   var finalIdleKey:String="FINAL-IDLE-camp-"+side+"-slot-"+slot;
   if(frame>=clips[name].images.length+3 && !captured[finalIdleKey]){captured[finalIdleKey]=true;saveFrame(finalIdleKey);}
   var hitKey:String=''')
    source=source.replace('role.actor.y=-clip.meta[index].py;', 'role.actor.y=-clip.meta[index].py; role.PainStrikePose({Surface:clip.images[index],Pivot:{X:clip.meta[index].px,Y:clip.meta[index].py}});')
    if args.laser_check:
        # Match a real battle's scaled role container and unequal row heights.
        source=source.replace('var actors:Sprite=new Sprite();battle.addChild(actors);', 'var actors:Sprite=new Sprite();battle.addChild(actors);actors.x=70;actors.y=20;actors.scaleX=.9;actors.scaleY=.9;')
        source=source.replace('right.y=470;', 'right.y=410;')
        source=source.replace('  private var clips:Object={};','  private var clips:Object={};\n  private var laserExtras:Array=[];')
        source=source.replace('right.Camp=1;left.FTargets=[left,right,right];right.FTargets=[right,left,left];', '''right.Camp=1;
   left.FTargets=[left,right];right.FTargets=[right,left];
   for(var sideIndex:int=0;sideIndex<2;sideIndex++)
   {
      var group:Array=[];
      for(var extraIndex:int=0;extraIndex<4;extraIndex++)
      {
         var extra:ProbeRole=new ProbeRole();extra.Camp=sideIndex;extra.Pos=[1,11,7,12][extraIndex];
         extra.x=sideIndex==0?[200,100,310,150][extraIndex]:[1000,1100,890,1080][extraIndex];
         extra.y=[270,410,550,550][extraIndex];extra.scaleX=sideIndex==0?1:-1;actors.addChild(extra);laserExtras.push(extra);group.push(extra);
      }
      if(sideIndex==0)right.FTargets=right.FTargets.concat(group);else left.FTargets=left.FTargets.concat(group);
   }
   left.FResults=[{CMD:0,ResultInfo:{HurtHp:0}}];right.FResults=[{CMD:0,ResultInfo:{HurtHp:0}}];
   for(var victimIndex:int=0;victimIndex<5;victimIndex++){left.FResults.push({CMD:1,ResultInfo:{HurtHp:10}});right.FResults.push({CMD:1,ResultInfo:{HurtHp:10}});}
''')
        source=source.replace('left.FResults=results;right.FResults=results;','')
        source=source.replace('   renderRole(victim,"idle",int(age/100)%clips.idle.images.length);','   for each(var extraRole:ProbeRole in laserExtras)renderRole(extraRole,"idle",int(age/100)%clips.idle.images.length);\n   renderRole(victim,"idle",int(age/100)%clips.idle.images.length);')
        source=re.sub(r'private var skills:Array=\[.*?\];','private var skills:Array=[13120976];',source)
        source=re.sub(r'private var clipNames:Array=\[.*?\];','private var clipNames:Array=["laser"];',source)
        source=source.replace('slot>=18','slot>=2').replace('slot<9?0:1','slot<1?0:1').replace('slot%9','slot%1')
    if args.flight_check:
        source=re.sub(r'private var skills:Array=\[.*?\];','private var skills:Array=[13120972,13120973,13120979];',source)
        source=re.sub(r'private var clipNames:Array=\[.*?\];','private var clipNames:Array=["extreme","extreme","super"];',source)
        source=source.replace('slot>=18','slot>=6').replace('slot<9?0:1','slot<3?0:1').replace('slot%9','slot%3')
        # Match the native surface-change gate, then run production motion OUTSIDE it.
        source=source.replace('role.actor.bitmapData=clip.images[index];role.actor.x=-clip.meta[index].px;', 'if(role.actor.bitmapData!=clip.images[index]){role.actor.bitmapData=clip.images[index];role.actor.x=-clip.meta[index].px;')
        end='role.PainStrikePose({Surface:clip.images[index],Pivot:{X:clip.meta[index].px,Y:clip.meta[index].py}});'
        source=source.replace(end,end+'} role.PainFlightPose({Surface:clip.images[index],Pivot:{X:clip.meta[index].px,Y:clip.meta[index].py}}); if(role.FSkillId!=0)report("FLIGHT skill="+role.FSkillId+" camp="+role.Camp+" frame="+index+" feet="+(role.actor.y+clip.images[index].height));')
    if args.motion_check:
        source=re.sub(r'private var skills:Array=\[.*?\];','private var skills:Array=[13120971,13120974,13120975];',source)
        source=re.sub(r'private var clipNames:Array=\[.*?\];','private var clipNames:Array=["almighty","standard","chase"];',source)
        source=source.replace('slot>=18','slot>=6').replace('slot<9?0:1','slot<3?0:1').replace('slot%9','slot%3')
    source=source.replace('__METHODS__','').rstrip()
    source=source[:-1]+'\n internal class ProbeRole extends Sprite {\n'+fields+'\n public function ProbeRole(){actor.smoothing=true;addChild(actor);}\n public function report(text:String):void{if(ExternalInterface.available)ExternalInterface.call("vfxProbe",text);}\n'+methods+'\n}\n}\n'
    dest=BASE/'probe-source/TApplication.as';dest.parent.mkdir(exist_ok=True);dest.write_text(source,encoding='utf-8')
    output=BASE/('revival-probe.swf' if args.revival_check else 'status-probe.swf' if args.status_check else 'raster-probe.swf')
    subprocess.run(['java','-Xmx2g','-jar',args.ffdec,'-onerror','abort','-importScript',str(BASE/'source.swf'),str(output),str(dest.parent)],check=True)
    binary=bytearray(output.read_bytes());binary[3]=21;output.write_bytes(binary)
    print('PASS Pain component probe compiled')
if __name__=='__main__':main()
