"""Exercise the compiled ChangeHP/restore code against live Flash death tweens."""
from pathlib import Path
import importlib.util
B=Path(__file__).resolve().parent;W=B/'revival-repair'
s=importlib.util.spec_from_file_location('repair',B/'repair-client.py');r=importlib.util.module_from_spec(s);s.loader.exec_module(r)
c=r.c
role=(W/'verify/scripts'/c.b.ROLE).read_text(encoding='utf-8')
methods='\n'.join(c.m.extract(role,name) for name in ['ChangeHP','RestoreTsunadeAfterRevival']).replace(':TAnimationFrame',':Object')
source='''package {
 import flash.display.*;import flash.events.*;import flash.utils.*;import flash.external.ExternalInterface;
 import ghostcat.util.easing.TweenUtil;
 public class TApplication extends MovieClip {
  private var actors:Array=[];
  public function TApplication(){if(stage)run();else addEventListener(Event.ADDED_TO_STAGE,run);}
  private function report(s:String):void{ExternalInterface.call("vfxProbe",s);}
  private function check(ok:Boolean,message:String):void{if(!ok)throw new Error(message);}
  private function run(e:Event=null):void{
   stage.frameRate=25;stage.scaleMode=StageScaleMode.NO_SCALE;stage.align=StageAlign.TOP_LEFT;
   loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR,function(e:UncaughtErrorEvent):void{report("ERROR "+e.error);});
   graphics.beginFill(0x18252b);graphics.drawRect(0,0,1250,650);graphics.endFill();
   for(var camp:int=0;camp<2;camp++)for each(var id:int in [11120997,11100001])for each(var delay:int in [100,1200]){
    var actor:ReviveActor=new ReviveActor();actor.FId=id;actor.x=100+actors.length*140;actor.y=400;actor.FIdlePosition=[actor.x,actor.y];actor.scaleX=camp==0?1:-1;addChild(actor);actors.push(actor);
    actor.FIsDie=true;actor.FWaitDie=true;actor.CurHealth=0;actor.FHideFrame=0;actor.FHpBar.visible=false;actor.FBuffSprite.visible=false;
    TweenUtil.to(actor,1000,{alpha:0});
    report("CASE camp="+camp+" hero="+id+" delay="+delay);
    schedule(actor,delay);
   }
   setTimeout(function():void{
    for each(var a:ReviveActor in actors){check(a.CurHealth==300,"HP exactly once");check(a.visible&&a.alpha==1&&a.FBitmap.visible&&a.FBitmap.alpha==1,"no stale death fade");check(!a.FIsDie&&!a.FWaitDie&&a.FHideFrame==-1,"death flags reset");check(a.FHpBar.visible&&a.FBuffSprite.visible,"UI restored");check(a.x==a.FIdlePosition[0]&&a.y==a.FIdlePosition[1],"formation anchor restored");report("RESTORE_STABLE "+a.FId);}
    report("DONE native Kakuzu and ally revival; remaining=0");
   },2600);
  }
  private function schedule(a:ReviveActor,delay:int):void{setTimeout(function():void{a.ChangeHP(-300);check(a.visible&&a.alpha==1&&!a.FIsDie,"immediate recovery");report("RESTORE_OK "+a.FId);},delay);}
 }
 internal class ReviveActor extends Sprite {
  public var FId:int;public var CurHealth:Number=0;public var FIsDie:Boolean=false;public var FWaitDie:Boolean=false;public var FWaitNextCommand:Boolean=true;public var FHideFrame:int=0;
  public var FHasFrozen:Boolean=true;public var FHasGiddy:Boolean=true;public var FIsAntiColorBlackWhite:Boolean=true;public var FIsRedAntiColor:Boolean=true;
  public var FCallBackDict:Object={};public var FTimeDict:Object={};public const TYPE_ACTIVE_DIE:int=9;public var FSkillId:int=123;public var FSkilling:Boolean=true;public var FTsunadeVfxStarted:Boolean=true;
  public var FBitmap:Bitmap=new Bitmap(new BitmapData(50,100,false,0xc18a4c));public var FShaderBmp:Sprite=new Sprite();public var FHpBar:Sprite=new Sprite();public var FBuffSprite:Sprite=new Sprite();public var FFrozenBitmap:Sprite=new Sprite();public var FGiddyBitmap:Sprite=new Sprite();public var FShieldBitmap:Sprite=new Sprite();public var FShieldBlood:Number=0;
  public var FIdlePosition:Array;public var FCurSequence:Object;
  public function ReviveActor(){addChild(FBitmap);var data:BitmapData=FBitmap.bitmapData;FCurSequence={GetAnimationFrameByIndex:function(i:int):Object{return {Surface:data,Pivot:{X:25,Y:100}};}};}
  public function PlayFightIdle():void{}
  public function PlaySmallKatsuyuPose(v:Boolean):void{}
  public function PlayWhiteZetsuPose(v:Boolean):void{}
  public function PlayWaterClonePose(v:Boolean):void{}
  public function RestorePainAfterRevival():void{throw new Error("Pain uses its existing recovery path");}
__METHODS__
 }
}'''.replace('__METHODS__',methods)
dest=W/'revival-probe-source/TApplication.as';dest.parent.mkdir(exist_ok=True);dest.write_text(source,encoding='utf-8')
c.ff('-onerror','abort','-importScript',W/'compiled.swf',W/'recovery-probe.swf',dest.parent)
raw=bytearray((W/'recovery-probe.swf').read_bytes());raw[3]=21;(W/'recovery-probe.swf').write_bytes(raw)
print('PASS 8 native resurrection/death-tween probe cases compiled')
