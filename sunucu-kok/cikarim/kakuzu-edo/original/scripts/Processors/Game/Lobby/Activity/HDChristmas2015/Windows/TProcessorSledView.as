package Processors.Game.Lobby.Activity.HDChristmas2015.Windows
{
   import Components.Standard.TUITab;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Logics.DatebaseVO.VO.THDActivityBase;
   import Logics.HDActivityMode.TActivityAtoms;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDChristmas2015.TSledData;
   import Logics.Log.TLog;
   import Processors.Game.Lobby.Activity.HDActivity.Common.THDScoreExchangeShop;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDSingleWindowBase;
   import Processors.Game.Lobby.Activity.HDChristmas2015.Components.TProcessorSnatchPanel;
   import Processors.Game.Lobby.Activity.HDChristmas2015.Components.TProcessorTransportPanel;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Resources.Constants.CONST_LOG;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public class TProcessorSledView extends TProcessorHDSingleWindowBase
   {
      
      protected var FData:TSledData;
      
      protected var FSnatchPanel:TProcessorSnatchPanel;
      
      protected var FTransportPanel:TProcessorTransportPanel;
      
      protected var FTab:TUITab;
      
      protected var FScoreExchangeShop:THDScoreExchangeShop;
      
      protected var FConfigFrist:Boolean;
      
      protected var FOnLoadLog:Function;
      
      public function TProcessorSledView(param1:TUIComponent)
      {
         super(param1);
         this.FConfigFrist = true;
      }
      
      override protected function Reset() : void
      {
         if(FScene != null)
         {
            this.FSnatchPanel.Reset();
            this.FTab.SwithTagManual(0);
         }
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
         if(FScene == null)
         {
            return;
         }
         this.FData = param1 as TSledData;
         if(this.FConfigFrist)
         {
            this.SetupScoreShop();
            this.FConfigFrist = false;
         }
         this.FSnatchPanel.UpdateDataBase(this.FData);
         this.FTransportPanel.UpdateDataBase(this.FData);
         this.FScoreExchangeShop.Update(this.FData.CurHaveChristmasCards,this.FData.ShopStates);
         if(this.FOnLoadLog != null)
         {
            this.FOnLoadLog(CONST_LOG.LOGTYPE_Sled,this.LogArrive);
         }
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(Boolean(FScene) && Boolean(this.FData))
         {
            this.FSnatchPanel.LogicsPerform();
         }
      }
      
      protected function OnSwitchFunction(param1:int) : void
      {
         this.FSnatchPanel.Visible = false;
         this.FTransportPanel.Visible = false;
         if(param1 == 0)
         {
            this.FTransportPanel.Visible = true;
         }
         else
         {
            if(this.FData.CurTransporting)
            {
               Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FData.Config.RobberyInterfaceIndex);
            }
            this.FSnatchPanel.Visible = true;
         }
         if(FScene != null)
         {
            if(this.FOnLoadLog != null)
            {
               this.FOnLoadLog(CONST_LOG.LOGTYPE_Sled,this.LogArrive);
            }
         }
      }
      
      protected function SetupScoreShop() : void
      {
         var _loc1_:Object = null;
         var _loc2_:Vector.<uint> = null;
         var _loc3_:Vector.<Boolean> = null;
         _loc2_ = new Vector.<uint>();
         _loc3_ = new Vector.<Boolean>();
         for each(_loc1_ in this.FData.Config.Shop)
         {
            _loc2_.push(_loc1_.cost);
            _loc3_.push(_loc1_.count == -1);
         }
         this.FScoreExchangeShop.SetupBasicInfo(this.FData.ScoreShop,_loc2_,_loc3_);
      }
      
      protected function ExchangeCall(param1:uint) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:Object = null;
         _loc3_ = this.FData.Config.Shop[param1];
         _loc2_ = uint(_loc3_.cost);
         if(this.FData.CurHaveChristmasCards >= _loc2_)
         {
            Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,_loc3_.index);
         }
         else
         {
            SToolReward.ShowMessage(this.FData.Config.Language.scoreLess);
         }
      }
      
      protected function OnStore() : void
      {
         this.FScoreExchangeShop.Visible = true;
         this.FScoreExchangeShop.Update(this.FData.CurHaveChristmasCards,this.FData.ShopStates);
      }
      
      protected function LogArrive(param1:Vector.<TLog>) : void
      {
         this.FTransportPanel.LogArrive(param1);
      }
      
      override public function InitWindow(param1:Sprite = null) : void
      {
         var _loc2_:MovieClip = null;
         super.InitWindow(param1);
         this.FSnatchPanel = new TProcessorSnatchPanel(this);
         this.FSnatchPanel.InitWindow(FScene["MC_SnatchPanel"]);
         this.FSnatchPanel.CSFun = Perform_CS_ActivityOperateReq;
         this.FSnatchPanel.UpdateView = this.UpdateDataBase;
         this.FSnatchPanel.X += param1.x;
         this.FSnatchPanel.Y += param1.y;
         this.FTransportPanel = new TProcessorTransportPanel(this);
         this.FTransportPanel.InitWindow(FScene["MC_TransportPanel"]);
         this.FTransportPanel.CSFun = Perform_CS_ActivityOperateReq;
         this.FTransportPanel.OnStore = this.OnStore;
         this.FTransportPanel.X += param1.x;
         this.FTransportPanel.Y += param1.y;
         this.FTransportPanel.OnGiftShow = ProcessorOnGiftBoxMove;
         this.FTransportPanel.OnGiftHide = ProcessorOnGiftBoxOut;
         this.FTab = new TUITab(this);
         this.FTab.SetTabByIndex(FScene["MC_Tab_0"],0);
         this.FTab.SetTabByIndex(FScene["MC_Tab_1"],1);
         this.FTab.OnSwitch = this.OnSwitchFunction;
         this.FTab.Init();
         _loc2_ = TUtilityReflection.CreateDisplayObjectInstance("MC_Christmas2015Shop") as MovieClip;
         this.FScoreExchangeShop = new THDScoreExchangeShop(this);
         this.FScoreExchangeShop.ExchangeCall = this.ExchangeCall;
         this.FScoreExchangeShop.UIDispatch(_loc2_);
      }
      
      override public function Show(param1:TActivityAtoms = null, param2:THDActivityBase = null, param3:TActivityOSBase = null) : void
      {
         super.Show(param1,param2,param3);
         if(FActivityAtoms != null)
         {
            this.FSnatchPanel.CSID = FActivityAtoms.Identifier;
            this.FTransportPanel.CSID = FActivityAtoms.Identifier;
         }
      }
      
      public function set OnLoadLog(param1:Function) : void
      {
         this.FOnLoadLog = param1;
      }
   }
}

