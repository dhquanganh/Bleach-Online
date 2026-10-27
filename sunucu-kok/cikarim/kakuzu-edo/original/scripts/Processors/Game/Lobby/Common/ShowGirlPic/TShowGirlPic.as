package Processors.Game.Lobby.Common.ShowGirlPic
{
   import Foundation.Resources.SResourcesCore;
   import Foundation.Resources.Textures.TAnimationSequence;
   import Foundation.Resources.Textures.TTexture;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   
   public class TShowGirlPic extends Sprite
   {
      
      protected static const State_Normal:int = 0;
      
      protected static const State_NormalToSpecial:int = 1;
      
      protected static const State_Special:int = 2;
      
      protected static const State_SpecialToNormal:int = 3;
      
      protected var FCurrentState:int = 0;
      
      protected var FCurrentSequence:TAnimationSequence;
      
      protected var FTexture:TTexture;
      
      protected var FHeadMountPoint:Bitmap;
      
      protected var FBodyMountPoint:Bitmap;
      
      protected var FTickStore:int;
      
      protected var FTextureID:int;
      
      protected var FIFCanGetReward:Boolean;
      
      public function TShowGirlPic()
      {
         super();
         this.FCurrentState = State_Normal;
         this.FHeadMountPoint = new Bitmap();
         this.FBodyMountPoint = new Bitmap();
         addChild(this.FHeadMountPoint);
         addChild(this.FBodyMountPoint);
      }
      
      protected function StateChangeRole() : int
      {
         switch(this.FCurrentState)
         {
            case State_Normal:
               return State_Normal;
            case State_NormalToSpecial:
               return State_Special;
            case State_Special:
               if(this.FIFCanGetReward)
               {
                  return State_Special;
               }
               return State_Normal;
               break;
            case State_SpecialToNormal:
               return State_Normal;
            default:
               return -1;
         }
      }
      
      protected function SwitchState(param1:int) : void
      {
         this.FCurrentState = param1;
         this.FTickStore = 0;
         if(this.FTexture != null)
         {
            this.FCurrentSequence = this.FTexture.GetAnimationSequenceByIndex(param1);
         }
      }
      
      protected function ResourceArrive(param1:Object, param2:TTexture, param3:int) : void
      {
         this.FTexture = param2;
         this.FBodyMountPoint.bitmapData = this.FTexture.GetAnimationSequenceByIndex(4).GetAnimationFrameByIndex(0).Surface;
         this.FBodyMountPoint.y = this.FTexture.GetAnimationSequenceByIndex(0).GetAnimationFrameByIndex(0).Surface.height;
         this.FBodyMountPoint.x = -this.FTexture.GetAnimationSequenceByIndex(4).GetAnimationFrameByIndex(0).Pivot.X;
         this.FHeadMountPoint.y = 0;
         this.SwitchState(this.FCurrentState);
      }
      
      protected function Update_Perform() : void
      {
         var _loc1_:BitmapData = null;
         if(this.FCurrentSequence == null)
         {
            return;
         }
         this.FTickStore += 33;
         if(this.FTickStore >= this.FCurrentSequence.Duration)
         {
            this.SwitchState(this.StateChangeRole());
         }
         _loc1_ = this.FCurrentSequence.GetAnimationFrameByTick(this.FTickStore).Surface;
         this.FHeadMountPoint.bitmapData = _loc1_;
      }
      
      public function set IFCanGetReward(param1:Boolean) : void
      {
         this.FIFCanGetReward = param1;
         if(this.FIFCanGetReward)
         {
            this.SwitchState(State_Special);
         }
         else
         {
            this.SwitchState(State_Normal);
         }
      }
      
      public function get IFCanGetReward() : Boolean
      {
         return this.FIFCanGetReward;
      }
      
      public function Update() : void
      {
         this.Update_Perform();
      }
      
      public function Reset() : void
      {
         SResourcesCore.TexturesLobby.DeleteByIdentifier(this.FTextureID,true);
         this.FHeadMountPoint.bitmapData = null;
         this.FBodyMountPoint.bitmapData = null;
         this.FCurrentSequence = null;
         this.FTexture = null;
         this.FCurrentState = State_Normal;
         this.FTextureID = 0;
      }
      
      public function LoadResource(param1:int) : void
      {
         this.FTextureID = param1;
         if(this.FTexture == null)
         {
            SResourcesCore.TexturesLobby.LoadAutoSecondary(param1,this.ResourceArrive);
         }
      }
      
      public function TriggerSpecial() : void
      {
         this.SwitchState(State_NormalToSpecial);
      }
   }
}

