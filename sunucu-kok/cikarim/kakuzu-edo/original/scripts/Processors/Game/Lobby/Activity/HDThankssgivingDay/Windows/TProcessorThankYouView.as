package Processors.Game.Lobby.Activity.HDThankssgivingDay.Windows
{
   import Components.Standard.TUITab;
   import Foundation.UI.TUIComponent;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDThanksgivingDay.TThankYouData;
   import Logics.SLogicsCore;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDSingleWindowBase;
   import Processors.Game.Lobby.Activity.HDThankssgivingDay.Components.TProcessorThankYouAwardList;
   import Processors.Game.Lobby.Activity.HDThankssgivingDay.Components.TProcessorThankYouSuperVip;
   import Processors.Game.Lobby.Activity.HDThankssgivingDay.Components.TProcessorThankYouVip;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import flash.display.Sprite;
   
   public class TProcessorThankYouView extends TProcessorHDSingleWindowBase
   {
      
      protected var FData:TThankYouData;
      
      protected var FTab:TUITab;
      
      protected var FWitnessUI:TProcessorThankYouAwardList;
      
      protected var FGrowthUI:TProcessorThankYouAwardList;
      
      protected var FVipUI:TProcessorThankYouVip;
      
      protected var FSuperVipUI:TProcessorThankYouSuperVip;
      
      protected var FUIs:Vector.<TProcessorLobbyWindow>;
      
      public function TProcessorThankYouView(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function Reset() : void
      {
      }
      
      override protected function UpdateUIConfig() : void
      {
         super.UpdateUIConfig();
         if(FActivityAtoms != null)
         {
            ProcessorFormatActivityTimeFromNowOn(FActivityAtoms.EndTime);
            ProcessorFormatActivityCountDown(FActivityAtoms.EndTime);
         }
      }
      
      override protected function UpdateDataBase(param1:TActivityOSBase) : void
      {
         this.FData = param1 as TThankYouData;
         this.FWitnessUI.Update(this.FData.OnlineDay,this.FData.WitnessKeys,this.FData.Config.Witness,FActivityAtoms.Identifier);
         this.FGrowthUI.Update(SLogicsCore.Character.GetMainLevel(),this.FData.GrowthKeys,this.FData.Config.Growth,FActivityAtoms.Identifier);
         this.FVipUI.Update(SLogicsCore.Character.VipLevel,this.FData.VipKeys,this.FData.Config.Vip,FActivityAtoms.Identifier);
         this.FSuperVipUI.Update(SLogicsCore.Character.VipLevel,this.FData.SuperVipKeys,this.FData.Config.SuperVip,FActivityAtoms.Identifier);
      }
      
      protected function OnSwitch(param1:int) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:TProcessorLobbyWindow = null;
         _loc3_ = this.FUIs.length;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = this.FUIs[_loc2_];
            _loc4_.Visible = false;
            _loc2_++;
         }
         _loc4_ = this.FUIs[param1];
         _loc4_.Visible = true;
      }
      
      override public function InitWindow(param1:Sprite = null) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         super.InitWindow(param1);
         this.FWitnessUI = new TProcessorThankYouAwardList(this);
         this.FWitnessUI.Post = Perform_CS_ActivityOperateReq;
         this.FWitnessUI.InitWindow(FScene["MC_Witness"]);
         this.FWitnessUI.X += param1.x;
         this.FWitnessUI.Y += param1.y;
         this.FGrowthUI = new TProcessorThankYouAwardList(this);
         this.FGrowthUI.Post = Perform_CS_ActivityOperateReq;
         this.FGrowthUI.InitWindow(FScene["MC_Growth"]);
         this.FGrowthUI.X += param1.x;
         this.FGrowthUI.Y += param1.y;
         this.FVipUI = new TProcessorThankYouVip(this);
         this.FVipUI.Post = Perform_CS_ActivityOperateReq;
         this.FVipUI.InitWindow(FScene["MC_Vip"]);
         this.FVipUI.X += param1.x;
         this.FVipUI.Y += param1.y;
         this.FSuperVipUI = new TProcessorThankYouSuperVip(this);
         this.FSuperVipUI.Post = Perform_CS_ActivityOperateReq;
         this.FSuperVipUI.InitWindow(FScene["MC_SuperVip"]);
         this.FSuperVipUI.X += param1.x;
         this.FSuperVipUI.Y += param1.y;
         this.FUIs = Vector.<TProcessorLobbyWindow>([this.FWitnessUI,this.FGrowthUI,this.FVipUI,this.FSuperVipUI]);
         _loc3_ = this.FUIs.length;
         this.FTab = new TUITab(this);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FTab.SetTabByIndex(FScene["MC_Tab_" + _loc2_],_loc2_);
            _loc2_++;
         }
         this.FTab.OnSwitch = this.OnSwitch;
         this.FTab.Init();
         this.FTab.SwithTagManual(0);
      }
   }
}

