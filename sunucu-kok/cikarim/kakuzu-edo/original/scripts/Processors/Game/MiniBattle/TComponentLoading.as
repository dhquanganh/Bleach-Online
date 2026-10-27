package Processors.Game.MiniBattle
{
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.text.TextField;
   
   public class TComponentLoading extends TProcessorLobbyWindow
   {
      
      protected var FProgressBar:Sprite;
      
      protected var FTFProgress:TextField;
      
      public function TComponentLoading(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:Sprite = null;
         _loc1_ = TUtilityReflection.CreateDisplayObjectInstance("MC_BattleLoad") as MovieClip;
         addChild(_loc1_);
         this.FProgressBar = _loc1_["SP_LoadBar"]["SP_ProgressBar"];
         this.FTFProgress = _loc1_["SP_LoadBar"]["TF_ProgressBar"];
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         super.ResourcesPerform_UILocations();
      }
      
      public function UpdateScheduleInfor(param1:int, param2:int) : void
      {
         var _loc3_:int = 0;
         if(!FIsResourcesLoadCompleted)
         {
            return;
         }
         _loc3_ = param2 - param1;
         this.FProgressBar.scaleX = _loc3_ / param2;
         this.FTFProgress.text = int(_loc3_ / param2 * 100) + "%";
      }
      
      public function Reset() : void
      {
         if(!FIsResourcesLoadCompleted)
         {
            return;
         }
         this.FProgressBar.scaleX = 0;
         this.FTFProgress.text = "";
      }
   }
}

