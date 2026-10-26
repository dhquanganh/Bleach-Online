package {
 import flash.display.*;import flash.events.*;import flash.external.ExternalInterface;import flash.utils.*;
 public class TApplication extends MovieClip {
  private var actors:Array=[];private var callbacks:Array=[0,0];private var begun:int=0;
  public function TApplication(){if(stage)boot();else addEventListener(Event.ADDED_TO_STAGE,boot);}
  private function report(s:String):void{ExternalInterface.call("vfxProbe",s);}
  private function check(v:Boolean,s:String):void{if(!v)throw new Error(s);}
  private function boot(e:Event=null):void{try{
   for(var i:int=0;i<2;i++){var z:SmallActor=new SmallActor();z.FTextureSkill=i==0?{Count:2,GetAnimationSequenceByIndex:function(index:int):Object{return null;}}:{Count:2,GetAnimationSequenceByIndex:function(index:int):Object{return {GetAnimationFrameByIndex:function(frame:int):Object{return null;}};}};addChild(z);actors.push(z);}
   // First actor loses an in-flight attack; the second is a normal death.
   actors[0].FIndex=SmallActor.TYPE_ACTIVE_ATTACK;
   actors[0].FCallBackDict[SmallActor.TYPE_ACTIVE_ATTACK]=function(t:uint):void{callbacks[0]++;};
   actors[0].PlayWhiteZetsuPose(true,null,11);
   actors[1].PlayWhiteZetsuPose(true,function(t:uint):void{callbacks[1]++;},12);
   begun=getTimer();addEventListener(Event.ENTER_FRAME,tick);report("CASE floor 68 two Zetsu die concurrently");
  }catch(err:Error){report("ERROR "+err+" "+err.getStackTrace());}}
  private function tick(e:Event):void{try{
   for each(var z:SmallActor in actors)z.UpdateWhiteZetsuPose();
   if(getTimer()-begun<2400)return;
   check(callbacks[0]==1&&callbacks[1]==1,"both death callbacks exactly once");
   for each(z in actors)check(z.FWhiteZetsuStarted<0&&z.FIsDie&&!z.visible,"death pose completed and hidden");
   report("DONE two deaths; callbacks="+callbacks.join(",")+" remaining=0");removeEventListener(Event.ENTER_FRAME,tick);
  }catch(err:Error){report("ERROR "+err+" "+err.getStackTrace());removeEventListener(Event.ENTER_FRAME,tick);}}
 }
 internal class TBattleHandle {public static var PlaybackTime:Number=0;}
 internal class SmallActor extends Sprite {
  public static const TYPE_ACTIVE_ATTACK:int=1;public static const TYPE_ACTIVE_SKILL:int=2;
  public var FId:int=11120996;public var FTextureSkill:Object;public var FDefaultRoleTexture:Object=null;
  public var FWhiteZetsuSequence:Object;public var FWhiteZetsuStarted:Number=-1;public var FWhiteZetsuWallStarted:int=-1;
  public var FWhiteZetsuFrames:int=0;public var FWhiteZetsuDying:Boolean=false;public var FWhiteZetsuSpawned:Boolean=true;
  public var FWhiteZetsuCallback:Function;public var FWhiteZetsuTime:uint=0;
  public var FIndex:int=0;public var FWaitNextCommand:Boolean=false;public var FActiveCallBack:Function;public var FCallBackDict:Array=[];
  public var FIsDie:Boolean=false;public var FWaitDie:Boolean=false;public var FHideFrame:int=-1;
  public var FBitmap:Bitmap=new Bitmap();public var FShaderBmp:Sprite=new Sprite();public var FHpBar:Sprite=new Sprite();public var FBuffSprite:Sprite=new Sprite();
  public function SmallActor(){addChild(FBitmap);}
      public function ClearWhiteZetsuPose(event:Event = null) : void
      {
         removeEventListener(Event.ENTER_FRAME,UpdateWhiteZetsuPose);
         removeEventListener(Event.REMOVED_FROM_STAGE,ClearWhiteZetsuPose);
         FWhiteZetsuSequence = null;
         FWhiteZetsuStarted = -1;
         FWhiteZetsuWallStarted = -1;
         FWhiteZetsuCallback = null;
      }
      public function PlayWhiteZetsuPose(dying:Boolean, callback:Function = null, time:uint = 0) : void
      {
         if(FId != 11120996)
         {
            return;
         }
         ClearWhiteZetsuPose();
         if(dying && !FWhiteZetsuSpawned)
         {
            FIsDie = true;
            visible = false;
            if(callback != null)
            {
               callback(time);
            }
            return;
         }
         FWhiteZetsuDying = dying;
         FWhiteZetsuSpawned = true;
         FWhiteZetsuCallback = callback;
         // A fatal counter can interrupt Zetsu's own action before its normal
         // completion callback. Carry that callback through the death pose.
         if(dying && FWhiteZetsuCallback == null && (FIndex == TYPE_ACTIVE_ATTACK || FIndex == TYPE_ACTIVE_SKILL))
         {
            FWhiteZetsuCallback = FWaitNextCommand && FActiveCallBack != null ? FActiveCallBack : FCallBackDict[FIndex];
            FWaitNextCommand = false;
         }
         FWhiteZetsuTime = time;
         FWhiteZetsuFrames = dying ? 19 : 15;
         FWhiteZetsuStarted = TBattleHandle.PlaybackTime;
         FWhiteZetsuWallStarted = getTimer();
         if(FTextureSkill != null && FTextureSkill != FDefaultRoleTexture && FTextureSkill.Count >= 2)
         {
            FWhiteZetsuSequence = FTextureSkill.GetAnimationSequenceByIndex(dying ? 1 : 0);
         }
         FIsDie = dying;
         FWaitDie = false;
         FHideFrame = -1;
         visible = true;
         alpha = 1;
         FBitmap.visible = true;
         FBitmap.alpha = 1;
         FBitmap.filters = [];
         filters = [];
         if(dying)
         {
            FShaderBmp.visible = false;
            FHpBar.visible = false;
            FBuffSprite.visible = false;
         }
         addEventListener(Event.ENTER_FRAME,UpdateWhiteZetsuPose);
         addEventListener(Event.REMOVED_FROM_STAGE,ClearWhiteZetsuPose);
         UpdateWhiteZetsuPose();
      }
      public function UpdateWhiteZetsuPose(event:Event = null) : void
      {
         if(FId != 11120996 || FWhiteZetsuStarted < 0)
         {
            return;
         }
         // A partially loaded texture can report two sequences while the death
         // sequence is still null. Never restart its timeout on every frame.
         if(FWhiteZetsuSequence == null && FTextureSkill != null && FTextureSkill != FDefaultRoleTexture && FTextureSkill.Count >= 2)
         {
            var ready:Object = FTextureSkill.GetAnimationSequenceByIndex(FWhiteZetsuDying ? 1 : 0);
            if(ready != null)
            {
               FWhiteZetsuSequence = ready;
               FWhiteZetsuStarted = TBattleHandle.PlaybackTime;
               FWhiteZetsuWallStarted = getTimer();
            }
         }
         // PlaybackTime may pause while the battle waits on this actor. The
         // wall clock guarantees that two simultaneous deaths finish.
         var elapsed:Number = Math.max(TBattleHandle.PlaybackTime - FWhiteZetsuStarted,getTimer() - FWhiteZetsuWallStarted);
         if(FWhiteZetsuSequence == null && elapsed < 2000)
         {
            return;
         }
         var index:int = FWhiteZetsuSequence == null ? FWhiteZetsuFrames : Math.max(0,int(elapsed / 40));
         if(index >= FWhiteZetsuFrames)
         {
            var callback:Function = FWhiteZetsuCallback;
            var time:uint = FWhiteZetsuTime;
            var dying:Boolean = FWhiteZetsuDying;
            ClearWhiteZetsuPose();
            if(dying)
            {
               visible = false;
               alpha = 0;
               if(callback != null)
               {
                  callback(time);
               }
            }
            return;
         }
         if(FWhiteZetsuSequence != null)
         {
            var frame:Object = FWhiteZetsuSequence.GetAnimationFrameByIndex(index);
            if(frame != null)
            {
               FBitmap.bitmapData = frame.Surface;
               FBitmap.x = -frame.Pivot.X;
               FBitmap.y = -frame.Pivot.Y;
            }
         }
      }
 }
}