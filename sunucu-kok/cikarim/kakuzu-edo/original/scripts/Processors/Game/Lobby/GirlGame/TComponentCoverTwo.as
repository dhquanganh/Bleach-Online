package Processors.Game.Lobby.GirlGame
{
   import Foundation.Resources.SResourcesCore;
   import Foundation.Resources.Textures.TTexture;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import Resources.Constants.CONST_COMMON;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class TComponentCoverTwo extends TProcessorLobbyWindow
   {
      
      protected static const State_Ready:int = 0;
      
      protected static const State_Covering:int = 1;
      
      protected static const State_WaitingTime:int = 2;
      
      protected static const State_WaitCancle:int = 3;
      
      protected static const CoveringStateTime:int = 1000;
      
      protected var FCurrentState:int;
      
      protected var FMainUI:MovieClip;
      
      protected var FTFDialog:TextField;
      
      protected var FTFAssess:TextField;
      
      protected var FPicMountPoint:Bitmap;
      
      protected var FTickCount:int;
      
      protected var FNotifyCancled:Boolean;
      
      protected var FOnCoverOver:Function;
      
      protected var FOnCancleOver:Function;
      
      public function TComponentCoverTwo(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(!Visible)
         {
            return;
         }
         switch(this.FCurrentState)
         {
            case State_Ready:
               if(this.FMainUI.currentFrame == 40)
               {
                  this.Visible = false;
                  if(this.FOnCancleOver != null)
                  {
                     this.FOnCancleOver(this);
                  }
               }
               break;
            case State_Covering:
               if(this.FMainUI.currentFrame == 20)
               {
                  this.FCurrentState = State_WaitingTime;
                  if(this.FOnCoverOver != null)
                  {
                     this.FOnCoverOver(this);
                  }
               }
               this.FTickCount = 0;
               break;
            case State_WaitingTime:
               if(this.FTickCount >= CoveringStateTime)
               {
                  this.FCurrentState = State_WaitCancle;
               }
               this.FTickCount += CONST_COMMON.SIZE_FrameRatePerSecond;
               break;
            case State_WaitCancle:
               if(this.FNotifyCancled)
               {
                  this.FMainUI.play();
                  this.FCurrentState = State_Ready;
               }
         }
      }
      
      public function UIDispatch() : void
      {
         var _loc1_:MovieClip = null;
         this.FMainUI = TUtilityReflection.CreateDisplayObjectInstance("CoverTwo") as MovieClip;
         addChild(this.FMainUI);
         _loc1_ = this.FMainUI["AccountView"];
         this.FTFDialog = _loc1_["TFDialog"];
         this.FTFAssess = _loc1_["TFAssess"];
         this.FPicMountPoint = new Bitmap();
         _loc1_["PicMountPoint"].addChild(this.FPicMountPoint);
      }
      
      public function UILocation() : void
      {
      }
      
      protected function LoadGirlPic(param1:uint) : void
      {
         SResourcesCore.TexturesMiddlePic.LoadAutoSecondary(param1,this.CallBack_PicArrive);
      }
      
      protected function CallBack_PicArrive(param1:Object, param2:TTexture, param3:uint) : void
      {
         this.FPicMountPoint.bitmapData = param2.GetAnimationSequenceByIndex(0).GetAnimationFrameByIndex(0).Surface;
      }
      
      public function set OnCoverOver(param1:Function) : void
      {
         this.FOnCoverOver = param1;
      }
      
      public function set OnCancleOver(param1:Function) : void
      {
         this.FOnCancleOver = param1;
      }
      
      public function LoadResources() : void
      {
         this.UIDispatch();
         this.UILocation();
      }
      
      public function ShowResult(param1:String, param2:String, param3:uint) : void
      {
         this.FTFDialog.text = param1;
         this.FTFAssess.text = param2;
         this.LoadGirlPic(param3);
      }
      
      public function StartCover() : void
      {
         this.FMainUI.gotoAndPlay(1);
         this.FCurrentState = State_Covering;
         this.FNotifyCancled = false;
      }
      
      public function CancleCover() : void
      {
         this.FNotifyCancled = true;
      }
      
      public function Reset() : void
      {
         this.FMainUI.stop();
         this.FCurrentState = State_Ready;
         this.FTickCount = 0;
         this.FNotifyCancled = false;
         this.FPicMountPoint.bitmapData = null;
      }
   }
}

