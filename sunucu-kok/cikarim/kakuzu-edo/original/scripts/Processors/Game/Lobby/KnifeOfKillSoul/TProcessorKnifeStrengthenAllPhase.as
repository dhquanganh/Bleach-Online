package Processors.Game.Lobby.KnifeOfKillSoul
{
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Logics.KnifeOfKillSoul.TKnifeOfKillSoulData;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import Processors.Game.Utilities.Common.SUtilityResource;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class TProcessorKnifeStrengthenAllPhase extends TProcessorLobbyWindow
   {
      
      protected const PhaseNum:uint = 3;
      
      protected var FPhaseUI:Vector.<TKnifeStrengthenPhaseUI>;
      
      protected var FMainUI:MovieClip;
      
      protected var FMask:Bitmap;
      
      protected var FData:TKnifeOfKillSoulData;
      
      public function TProcessorKnifeStrengthenAllPhase(param1:TUIComponent)
      {
         super(param1);
      }
      
      protected function OnCloseClick(param1:MouseEvent) : void
      {
         ProcessorWindowClose();
      }
      
      public function UIDispatch() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:TKnifeStrengthenPhaseUI = null;
         this.FMainUI = TUtilityReflection.CreateDisplayObjectInstance("MC_AllPhase") as MovieClip;
         this.FMask = new Bitmap(SUtilityResource.BtmDataFullScreen);
         addChild(this.FMask);
         addChild(this.FMainUI);
         this.FMainUI.x = (this.FMask.width - this.FMainUI.width) / 2;
         this.FMainUI.y = (this.FMask.height - this.FMainUI.height) / 2;
         this.FMainUI.Btn_Close.addEventListener(MouseEvent.CLICK,this.OnCloseClick);
         this.FPhaseUI = new Vector.<TKnifeStrengthenPhaseUI>(this.PhaseNum);
         _loc1_ = 0;
         while(_loc1_ < this.PhaseNum)
         {
            _loc2_ = new TKnifeStrengthenPhaseUI();
            _loc2_.UIDispath(this.FMainUI["MC_Phase_" + _loc1_]);
            this.FPhaseUI[_loc1_] = _loc2_;
            _loc1_++;
         }
      }
      
      public function set Data(param1:TKnifeOfKillSoulData) : void
      {
         var _loc2_:TKnifeStrengthenPhaseUI = null;
         var _loc3_:uint = 0;
         this.FData = param1;
         _loc3_ = 0;
         while(_loc3_ < this.PhaseNum)
         {
            _loc2_ = this.FPhaseUI[_loc3_];
            _loc2_.SetData(this.FData.StrengthenPhase[_loc3_]);
            _loc3_++;
         }
      }
   }
}

