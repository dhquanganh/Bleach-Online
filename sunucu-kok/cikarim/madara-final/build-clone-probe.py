"""Native actor/action preview and lifecycle checks for six independent Madara Shadow Clone."""
from pathlib import Path
import importlib.util,json,re
B=Path(__file__).resolve().parent
s=importlib.util.spec_from_file_location('client',B.parent/'tsunade-asian/build-client.py');c=importlib.util.module_from_spec(s);s.loader.exec_module(c);c.JAR=str(B.parents[2]/'tools/ffdec/ffdec.jar')
data=json.loads((B/'animation.json').read_text())
template=(B.parent/'tsunade-asian/probe-source/TApplication.as').read_text()
def extract(name):
 start=re.search(r'private function '+name+r'\(',template).start();return template[start:c.b.method_end(template,start)]
helpers='\n'.join(extract(n) for n in ['loadTexture','decodeTexture','saveFrame'])
helpers=helpers.replace('/Resources/Textures/Model/', '/Resources/Textures/')
runtime=(B.parent/'tsunade-asian/katsuyu.as.txt').read_text().replace('__DEAD_FRAMES__',str(len(data['clips']['dead']['assets']))).replace('__ENTRY_FRAMES__',str(len(data['clips']['entry']['assets'])))
runtime=runtime.replace('SmallKatsuyu','MadaraClone').replace('11120993','11121002').replace('dying?1:0','dying?10:9').replace('FMadaraCloneDying?1:0','FMadaraCloneDying?10:9').replace('FTextureSkill.Count>=2','FTextureSkill.Count>=11')
runtime=runtime.replace('private var','public var').replace('private function','public function').replace(':TAnimationSequence',':Object').replace(':TAnimationFrame',':Object').replace('TBattleHandle.PlaybackTime','getTimer()')
source='''package {
 import Foundation.Decoder.Pak.TPakDecoder;
 import flash.display.*;import flash.events.*;import flash.net.*;import flash.geom.*;import flash.utils.*;import flash.text.*;import flash.external.ExternalInterface;
 public class TApplication extends MovieClip {
  private var clips:Object={};private var decoders:Array=[];private var loaded:int=0;
  private var actors:Array=[];private var effects:Array=[];private var readyAt:int=-1;private var phase:int=-1;private var captured:Object={};private var deathCallbacks:int=0;private var staleCallbacks:int=0;
  private var label:TextField=new TextField();
  public function TApplication(){if(stage)boot();else addEventListener(Event.ADDED_TO_STAGE,boot);}
  private function report(t:String):void {if(ExternalInterface.available)ExternalInterface.call("vfxProbe",t);}
  private function check(ok:Boolean,message:String):void {if(!ok)throw new Error(message);}
  private function boot(e:Event=null):void {
   removeEventListener(Event.ADDED_TO_STAGE,boot);stage.scaleMode=StageScaleMode.NO_SCALE;stage.align=StageAlign.TOP_LEFT;stage.frameRate=25;
   loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR,function(e:UncaughtErrorEvent):void{report("ERROR "+e.error);});
   graphics.beginFill(0x18252b);graphics.drawRect(0,0,1250,650);graphics.endFill();
   label.defaultTextFormat=new TextFormat("_sans",22,0xffffff,true);label.width=1200;label.height=40;label.x=20;label.y=20;addChild(label);
   loadTexture("Model/__BASE__",["idle"]);loadTexture("Model/__ATTACK__",["standard","burst-standard"]);loadTexture("Model/__SKILL__",["mystery","chase","complete","burst-mystery","burst-chase","summon","clone-counter","reflection","burst","entry","dead"]);loadTexture("Model/__HIT__",["hit"]);loadTexture("Model/__RUN__",["run"]);
   addEventListener(Event.ENTER_FRAME,tick);
  }
  private function sequence(name:String):Object {return {GetAnimationFrameByIndex:function(i:int):Object {var a:Object=clips[name];return {Surface:a.images[i],Pivot:{X:a.meta[i].px,Y:a.meta[i].py}};}};}
  private function pose(actor:SmallActor,name:String,frame:int):void {var a:Object=clips[name];frame=Math.max(0,Math.min(frame,a.images.length-1));actor.FBitmap.bitmapData=a.images[frame];actor.FBitmap.x=-a.meta[frame].px;actor.FBitmap.y=-a.meta[frame].py;}
  private function spawn(actor:SmallActor):void {actor.FIsDie=false;actor.visible=true;actor.alpha=1;actor.FHpBar.visible=true;actor.FShaderBmp.visible=true;actor.FBuffSprite.visible=true;actor.PlayMadaraClonePose(false);}
  private function tick(e:Event):void {
   try {
    for each(var decoder:TPakDecoder in decoders)if(decoder.Unstreamizing)decoder.Process();if(loaded<16)return;
    if(readyAt<0){
     for(var i:int=0;i<6;i++){var a:SmallActor=new SmallActor();a.x=180+(i%3)*170+(i>=3?550:0);a.y=440;a.scaleX=i>=3?-1:1;
      a.FTextureSkill={Count:11,GetAnimationSequenceByIndex:function(index:int):Object{return sequence(index==9?"entry":"dead");}};addChild(a);actors.push(a);var fx:Bitmap=new Bitmap();fx.smoothing=true;addChild(fx);effects.push(fx);
     }readyAt=getTimer();report("CASE six original Madara Shadow Clone, both camps");
    }
    var age:int=getTimer()-readyAt;var current:int=int(age/1800);var local:int=age%1800;
    if(current!=phase){phase=current;label.text="Small Madara Shadow Clone native asset | phase "+phase+" | three summons per camp";
     for each(a in actors){
      if(phase==0||phase==5)spawn(a);
      if(phase==0){a.FTextureSkill=null;}
      if(phase==4)a.PlayMadaraClonePose(true,function(t:uint):void{deathCallbacks++;},7);
      if(phase==6){a.PlayMadaraClonePose(true,function(t:uint):void{staleCallbacks++;},8);}
     }
     if(phase==0)setTimeout(function():void{for each(var a:SmallActor in actors){check(a.FMadaraCloneStarted>=0,"entry waits for delayed texture");a.FTextureSkill={Count:11,GetAnimationSequenceByIndex:function(index:int):Object{return sequence(index==9?"entry":"dead");}};}report("LATE_TEXTURE_OK six pending entries");},200);
     if(phase==6)setTimeout(function():void{for each(var a:SmallActor in actors)spawn(a);},200);
     if(phase==7){check(deathCallbacks==6,"death callbacks exactly once");check(staleCallbacks==0,"respawn cancelled old death callbacks");for each(a in actors)check(a.visible&&a.alpha==1&&!a.FIsDie,"respawn visibility");report("RESTORE_OK six summons; cancelled death callback; source entry/idle restored");}
     if(phase==8){a=actors[0];a.PlayMadaraClonePose(true,function(t:uint):void{staleCallbacks++;},9);removeChild(a);addChild(a);spawn(a);}
     if(phase==9){check(staleCallbacks==0,"removed-from-stage callback cleanup");var remaining:int=0;for each(a in actors)if(a.FMadaraCloneStarted>=0)remaining++;check(remaining==0,"no stale pose listeners");report("DONE Madara Shadow Clone native lifecycle; remaining="+remaining);removeEventListener(Event.ENTER_FRAME,tick);return;}
    }
    for(i=0;i<actors.length;i++){
     a=actors[i];if(a.FMadaraCloneStarted<0&&!a.FIsDie)pose(a,phase==2?"standard":phase==3?"hit":phase==7?"run":"idle",int(local/40)%clips[phase==2?"standard":phase==3?"hit":phase==7?"run":"idle"].images.length);
     fx=effects[i];fx.visible=false;
     if(fx.visible){var h:Object=clips.healing;var k:int=Math.min(h.images.length-1,int(local/40));fx.bitmapData=h.images[k];fx.x=a.x-h.meta[k].px;fx.y=a.y-h.meta[k].py;}
    }
    if(local>=600&&!captured[phase]){captured[phase]=true;saveFrame("katsuyu-phase-"+phase);}
   }catch(error:Error){report("ERROR "+error+" "+error.getStackTrace());removeEventListener(Event.ENTER_FRAME,tick);}
  }
__HELPERS__
 }
 internal class SmallActor extends Sprite {
  public var FId:int=11121002;public var FTextureSkill:Object;public var FDefaultRoleTexture:Object=null;public var FIsDie:Boolean=false;public var FWaitDie:Boolean=false;public var FHideFrame:int=-1;
  public var FBitmap:Bitmap=new Bitmap();public var FShaderBmp:Sprite=new Sprite();public var FHpBar:Sprite=new Sprite();public var FBuffSprite:Sprite=new Sprite();
  public function SmallActor(){FBitmap.smoothing=true;addChild(FBitmap);}
__RUNTIME__
 }
}'''
for key,value in {'__HELPERS__':helpers,'__RUNTIME__':runtime,'__BASE__':f'{11121001:08X}','__ATTACK__':f'{11121001:X}0B','__SKILL__':f'{11121001:X}0C','__HIT__':f'{11121001:X}0D','__RUN__':f'{11121001:X}0F','__FX__':f'{13622609:08X}'}.items():source=source.replace(key,value)
W=B/'clone-lifecycle';dest=W/'probe-source/TApplication.as';dest.parent.mkdir(parents=True,exist_ok=True);dest.write_text(source)
c.ff('-onerror','abort','-importScript',B/'source.swf',W/'raster-probe.swf',dest.parent)
raw=bytearray((W/'raster-probe.swf').read_bytes());raw[3]=21;(W/'raster-probe.swf').write_bytes(raw)
js=(B.parent/'tsunade-asian/runtime-raster.js').read_text().replace("path.resolve(base,'../../..')","path.resolve(base,'../../../..')").replace('7474','7502').replace('7475','7503').replace('Textures\\/Model\\/','Textures\\/(Model|Skill)\\/')
(W/'runtime-raster.js').write_text(js)
(W/'validation/native').mkdir(parents=True,exist_ok=True)
print('PASS six-summon native Madara Shadow Clone asset and lifecycle probe compiled')
