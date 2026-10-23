package Processors.Game.Lobby.VoidSoulWorld
{
   import Foundation.Common.THint;
   import Foundation.Timing.STimingCore;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Foundation.Utilities.TUtilityString;
   import Logics.SLogicsCore;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Processors.Game.Windows.Information.TUIWindowRecharge;
   import Resources.Constants.CONST_COMMON;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class TProcessorGoldRebirth extends TProcessorLobbyWindow
   {
      
      protected var FMainUI:MovieClip;
      
      protected var FStartTime:uint;
      
      protected var FHint:THint;
      
      protected var FRemainTime:int;
      
      protected var FUIWindowRecharge:TUIWindowRecharge;
      
      protected var FTimeUp:Function;
      
      protected var FOnRebirth:Function;
      
      protected var FTotalTime:uint;
      
      protected var FXCost:uint;
      
      protected var FXSecond:uint;
      
      public function TProcessorGoldRebirth(param1:TUIComponent)
      {
         super(param1);
         this.FHint = new THint();
      }
      
      override protected function LogicsPerform() : void
      {
         var _loc1_:int = 0;
         if(Visible)
         {
            _loc1_ = STimingCore.TickCount - this.FStartTime;
            this.FRemainTime = Math.max(0,this.FTotalTime - _loc1_ / 1000);
            this.FMainUI.TF_CDNumber.text = this.FRemainTime.toString();
            if(this.FRemainTime == 0)
            {
               Visible = false;
               if(this.FTimeUp != null)
               {
                  this.FTimeUp();
               }
            }
         }
         super.LogicsPerform();
      }
      
      protected function OnRebirthBtnClick(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         _loc2_ = Math.ceil(this.FRemainTime / this.FXSecond) * this.FXCost;
         if(_loc2_ > SLogicsCore.Character.CreditGold + SLogicsCore.Character.CreditGiftCertificate)
         {
            this.FUIWindowRecharge.SetGoldNum(_loc2_);
            this.FUIWindowRecharge.Visible = true;
            return;
         }
         if(this.FOnRebirth != null)
         {
            this.FOnRebirth();
         }
      }
      
      protected function OnRebirthBtnMove(param1:MouseEvent) : void
      {
         this.FHint.Caption = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.FIGHTPET_STRING_07),Math.ceil(this.FRemainTime / this.FXSecond) * this.FXCost);
         SUtilityOverLayer.UIComponentsHintOnOver(this,this.FHint);
      }
      
      protected function OnRebirthBtnOut(param1:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOut(this,this.FHint);
      }
      
      public function set TotalTime(param1:uint) : void
      {
         this.FTotalTime = param1;
      }
      
      public function set TimeUp(param1:Function) : void
      {
         this.FTimeUp = param1;
      }
      
      public function set XCost(param1:uint) : void
      {
         this.FXCost = param1;
      }
      
      public function set OnRebirth(param1:Function) : void
      {
         this.FOnRebirth = param1;
      }
      
      public function set XSecond(param1:uint) : void
      {
         this.FXSecond = param1;
      }
      
      public function UIDispatch() : void
      {
         this.FMainUI = TUtilityReflection.CreateDisplayObjectInstance("MC_RebirthCD") as MovieClip;
         addChild(this.FMainUI);
         this.FMainUI.BT_Resurrection.addEventListener(MouseEvent.CLICK,this.OnRebirthBtnClick);
         this.FMainUI.BT_Resurrection.addEventListener(MouseEvent.MOUSE_MOVE,this.OnRebirthBtnMove);
         this.FMainUI.BT_Resurrection.addEventListener(MouseEvent.MOUSE_OUT,this.OnRebirthBtnOut);
         this.FUIWindowRecharge = SUtilityOverLayer.UIWindowRecharge;
         X = (CONST_COMMON.STAGE_Width - Width) / 2;
         Y = (CONST_COMMON.STAGE_Height - Height) / 2;
      }
      
      public function Start() : void
      {
         this.FStartTime = STimingCore.TickCount;
         Visible = true;
         this.LogicsPerform();
      }
   }
}

