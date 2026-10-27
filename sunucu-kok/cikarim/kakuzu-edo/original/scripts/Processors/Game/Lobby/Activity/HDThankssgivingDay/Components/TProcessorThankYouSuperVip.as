package Processors.Game.Lobby.Activity.HDThankssgivingDay.Components
{
   import Components.Standard.TUIButton;
   import Foundation.UI.TUIComponent;
   import Processors.Game.Lobby.Activity.HDNewYearSheep.HDWindow.TShowAwardUI;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import Rendering.Overlayers.HDGiftBox.TOverlayerGiftBox;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class TProcessorThankYouSuperVip extends TProcessorLobbyWindow
   {
      
      protected var FMainUI:MovieClip;
      
      protected var FShowUI:TShowAwardUI;
      
      protected var FReceiveBtn:TUIButton;
      
      protected var FCurValue:uint;
      
      protected var FKeys:int;
      
      protected var FConfig:Object;
      
      protected var FActivityID:uint;
      
      protected var FPost:Function;
      
      public function TProcessorThankYouSuperVip(param1:TUIComponent)
      {
         super(param1);
      }
      
      protected function OnReceiveBtnClick(param1:Object, param2:MouseEvent) : void
      {
         this.FPost(this.FActivityID,this.FConfig.index);
      }
      
      public function set Post(param1:Function) : void
      {
         this.FPost = param1;
      }
      
      public function InitWindow(param1:MovieClip) : void
      {
         var _loc2_:MovieClip = null;
         this.FMainUI = param1;
         addChild(this.FMainUI);
         _loc2_ = this.FMainUI.ShowAward;
         this.FShowUI = new TShowAwardUI(this);
         this.FShowUI.UIDispatch(_loc2_);
         this.FReceiveBtn = new TUIButton();
         this.FReceiveBtn.Substrate = this.FMainUI.Btn_Receive;
         this.FReceiveBtn.OnClick = this.OnReceiveBtnClick;
      }
      
      public function Update(param1:uint, param2:int, param3:Object, param4:uint) : void
      {
         var _loc5_:Object = null;
         var _loc6_:Boolean = false;
         this.FCurValue = param1;
         this.FKeys = param2;
         this.FConfig = param3;
         this.FActivityID = param4;
         _loc5_ = this.FConfig.award[0];
         this.FShowUI.SetData(_loc5_.showType,_loc5_.awardID,_loc5_.showID,TOverlayerGiftBox.TYPE_ALL);
         _loc6_ = Boolean(param2);
         if(_loc6_)
         {
            this.FMainUI.MC_Get.visible = true;
            this.FReceiveBtn.Enabled = false;
         }
         else
         {
            this.FMainUI.MC_Get.visible = false;
            if(_loc5_.condition <= param1)
            {
               this.FReceiveBtn.Enabled = true;
            }
            else
            {
               this.FReceiveBtn.Enabled = false;
            }
         }
         this.FMainUI.TF_Condition.text = String(_loc5_.condition);
      }
   }
}

