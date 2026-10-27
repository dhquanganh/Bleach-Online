package {
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
      public function ChangeHP(param1:Number) : void
      {
         if(param1 < 0 && (CurHealth <= 0 || FIsDie || FWaitDie))
         {
            CurHealth -= param1;
            if(CurHealth > 0)
            {
               if(FId == 11120930)
               {
                  RestorePainAfterRevival();
               }
               else
               {
                  RestoreTsunadeAfterRevival();
               }
            }
            return;
         }
         if(param1 < 0)
         {
            if(FId == 11120930 && (CurHealth <= 0 || FIsDie || FWaitDie))
            {
               CurHealth -= param1;
               if(CurHealth > 0)
               {
                  RestorePainAfterRevival();
               }
               return;
            }
            if((FId == 11120902 || FId == 11120903) && FIsDie)
            {
               TweenUtil.removeTween(this,false);
               FIsDie = false;
               this.alpha = 1;
               this.visible = true;
               this.filters = [];
               FBitmap.filters = [];
               FShaderBmp.visible = true;
               FHpBar.visible = true;
               FBuffSprite.visible = true;
               if(FIdlePosition != null)
               {
                  this.x = FIdlePosition[0];
                  this.y = FIdlePosition[1];
               }
               PlayFightIdle();
            }
            CurHealth -= param1;
         }
         else
         {
            this.FShieldBlood -= param1;
            if(this.FShieldBlood < 0)
            {
               CurHealth += this.FShieldBlood;
               this.FShieldBlood = 0;
               if(this.FShieldBitmap.visible != false)
               {
                  this.FShieldBitmap.visible = false;
               }
            }
         }
      }
      private function RestoreTsunadeAfterRevival() : void
      {
         TweenUtil.removeTween(this,false);
         TweenUtil.removeTween(FBitmap,false);
         FIsDie = false;
         FWaitDie = false;
         FWaitNextCommand = false;
         FHideFrame = -1;
         FHasFrozen = false;
         FHasGiddy = false;
         FIsAntiColorBlackWhite = false;
         FIsRedAntiColor = false;
         FCallBackDict[TYPE_ACTIVE_DIE] = null;
         FTimeDict[TYPE_ACTIVE_DIE] = 0;
         FSkillId = 0;
         FSkilling = false;
         FTsunadeVfxStarted = false;
         alpha = 1;
         visible = true;
         filters = [];
         FBitmap.alpha = 1;
         FBitmap.visible = true;
         FBitmap.filters = [];
         FShaderBmp.visible = true;
         FHpBar.visible = true;
         FBuffSprite.visible = true;
         FFrozenBitmap.visible = false;
         FGiddyBitmap.visible = false;
         if(FIdlePosition != null)
         {
            x = FIdlePosition[0];
            y = FIdlePosition[1];
         }
         PlayFightIdle();
         var idle:Object = FCurSequence.GetAnimationFrameByIndex(0);
         if(idle != null)
         {
            FBitmap.bitmapData = idle.Surface;
            FBitmap.x = -idle.Pivot.X;
            FBitmap.y = -idle.Pivot.Y;
         }
         if(FId == 11120993)
         {
            PlaySmallKatsuyuPose(false);
         }
         if(FId == 11120996)
         {
            PlayWhiteZetsuPose(false);
         }
         if(FId == 11120998)
         {
            PlayWaterClonePose(false);
         }
      }
 }
}