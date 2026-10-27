package Processors.Game.Lobby.Common.Map.HeadDecoration
{
   import Foundation.Resources.SResourcesCore;
   import Foundation.Resources.Textures.TAnimationFrame;
   import Foundation.Resources.Textures.TAnimationSequence;
   import Foundation.Resources.Textures.TTexture;
   import Processors.Game.Lobby.Common.Map.SceneSprite.TSceneSpriteMoudleInMapCanRunPlayer;
   import Resources.Constants.CONST_COMMON;
   import flash.display.Bitmap;
   
   public class TDecorationTitle extends TDecoration
   {
      
      protected var MaxTitleNum:int = 4;
      
      protected var FPlayer:TSceneSpriteMoudleInMapCanRunPlayer;
      
      protected var FAnimationSequence:Vector.<TAnimationSequence>;
      
      protected var FPicMountPoint:Vector.<Bitmap>;
      
      protected var FTimeStore:Vector.<uint>;
      
      public function TDecorationTitle()
      {
         var _loc1_:int = 0;
         var _loc2_:Bitmap = null;
         super();
         this.FPicMountPoint = new Vector.<Bitmap>(this.MaxTitleNum);
         this.FAnimationSequence = new Vector.<TAnimationSequence>(this.MaxTitleNum);
         this.FTimeStore = new Vector.<uint>(this.MaxTitleNum);
         _loc1_ = 0;
         while(_loc1_ < this.MaxTitleNum)
         {
            _loc2_ = new Bitmap();
            this.FPicMountPoint[_loc1_] = _loc2_;
            addChild(_loc2_);
            _loc1_++;
         }
      }
      
      protected function Update_Perform() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:uint = 0;
         _loc2_ = int(this.FPlayer.TitlesID.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = uint(this.FPlayer.TitlesID[_loc1_]);
            if(_loc3_ != 0)
            {
               SResourcesCore.TexturesAchievementTitle.LoadAutoSecondary(_loc3_,this.CallBack_TextureArrive);
            }
            _loc1_++;
         }
      }
      
      protected function CallBack_TextureArrive(param1:Object, param2:TTexture, param3:uint) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:uint = 0;
         var _loc7_:Bitmap = null;
         _loc5_ = int(this.FPlayer.TitlesID.length);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc6_ = uint(this.FPlayer.TitlesID[_loc4_]);
            if(param3 == _loc6_)
            {
               this.FAnimationSequence[_loc4_] = param2.GetAnimationSequenceByIndex(0);
               break;
            }
            _loc4_++;
         }
         this.UpdateCorrdinate();
      }
      
      protected function UpdateCorrdinate() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TAnimationFrame = null;
         _loc2_ = 0;
         _loc1_ = 0;
         while(_loc1_ < this.FAnimationSequence.length)
         {
            if(this.FAnimationSequence[_loc1_] != null)
            {
               _loc3_ = this.FAnimationSequence[_loc1_].GetAnimationFrameByIndex(0);
               this.FPicMountPoint[_loc1_].x = -_loc3_.Pivot.X;
               this.FPicMountPoint[_loc1_].y = _loc2_;
               _loc2_ += _loc3_.Surface.height;
            }
            _loc1_++;
         }
      }
      
      protected function UpdateView_Perform() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:uint = 0;
         _loc2_ = int(this.FAnimationSequence.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            if(this.FAnimationSequence[_loc1_] != null)
            {
               _loc3_ = this.FTimeStore[_loc1_];
               this.FPicMountPoint[_loc1_].bitmapData = this.FAnimationSequence[_loc1_].GetAnimationFrameByTick(_loc3_).Surface;
               this.FTimeStore[_loc1_] += CONST_COMMON.SIZE_FrameRatePerSecond;
            }
            _loc1_++;
         }
      }
      
      override public function get Position() : int
      {
         return POSITION_TOP;
      }
      
      override public function Update(param1:Object) : void
      {
         this.FPlayer = param1 as TSceneSpriteMoudleInMapCanRunPlayer;
         this.Release();
         this.Update_Perform();
      }
      
      override public function UpdateView() : void
      {
         this.UpdateView_Perform();
      }
      
      override public function Release() : void
      {
         var _loc1_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < this.MaxTitleNum)
         {
            this.FPicMountPoint[_loc1_].bitmapData = null;
            this.FPicMountPoint[_loc1_].y = 0;
            this.FPicMountPoint[_loc1_].x = 0;
            this.FAnimationSequence[_loc1_] = null;
            this.FTimeStore[_loc1_] = 0;
            _loc1_++;
         }
      }
   }
}

