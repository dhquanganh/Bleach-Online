package Processors.Game.Lobby.HeroChange
{
   import Components.Slots.*;
   import Components.Standard.*;
   import Foundation.Network.*;
   import Foundation.Resources.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.HeroChange.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Jade.*;
   import Processors.Game.Utilities.OverLayer.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class TProcessorWindowExchangePill extends TProcessorLobbyWindow
   {
      
      protected var FMainUI:Sprite;
      
      protected var FSlotNormalPill:TUISlot;
      
      protected var FTFNormalPillNum:TextField;
      
      protected var FSlotGradePill:TUISlot;
      
      protected var FTFGradePillNum:TextField;
      
      protected var FTFExchangeNum:TextField;
      
      protected var FTFCostNum:TextField;
      
      protected var FBtnIncrease:TUIButton;
      
      protected var FBtnReduce:TUIButton;
      
      protected var FBtnExchange:TUIButton;
      
      protected var FBtnClose:TUIButton;
      
      protected var FMaxSelectNum:int;
      
      protected var FCurrentSelectNum:int;
      
      protected var FExchagneRate:int;
      
      protected var FHeroChangeData:THeroChangeData;
      
      public function TProcessorWindowExchangePill(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(Visible)
         {
            this.UpdateSoulPill();
         }
      }
      
      public function UIDispatch() : void
      {
         var _loc1_:Sprite = null;
         var _loc2_:TConfigValue = null;
         this.FMainUI = TUtilityReflection.CreateDisplayObjectInstance("ExchangePillView") as Sprite;
         addChild(this.FMainUI);
         _loc1_ = this.FMainUI["NormalPillPanle"];
         this.FSlotNormalPill = new TUISlot(this);
         this.FSlotNormalPill.OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FSlotNormalPill.OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FSlotNormalPill.Resource = _loc1_["slot"];
         TJadeCommon.InitSlot(this.FSlotNormalPill);
         this.FSlotNormalPill.Init();
         this.FTFNormalPillNum = _loc1_["Num"];
         _loc1_ = this.FMainUI["GradelPillPanle"];
         this.FSlotGradePill = new TUISlot(this);
         this.FSlotGradePill.OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FSlotGradePill.OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FSlotGradePill.Resource = _loc1_["slot"];
         TJadeCommon.InitSlot(this.FSlotGradePill);
         this.FSlotGradePill.Init();
         this.FTFGradePillNum = _loc1_["Num"];
         this.FTFExchangeNum = this.FMainUI["ExchangeNum"];
         this.FTFExchangeNum.autoSize = "left";
         this.FTFExchangeNum.selectable = true;
         this.FTFExchangeNum.type = TextFieldType.INPUT;
         this.FTFExchangeNum.restrict = "0-9";
         this.FTFExchangeNum.maxChars = 6;
         this.FTFExchangeNum.addEventListener(Event.CHANGE,this.TextChange);
         this.FTFCostNum = this.FMainUI["CostNum"];
         this.FBtnIncrease = new TUIButton();
         this.FBtnIncrease.Substrate = this.FMainUI["BTN_Add"];
         this.FBtnIncrease.OnClick = this.BtnAddOnClick;
         this.FBtnReduce = new TUIButton();
         this.FBtnReduce.Substrate = this.FMainUI["BTN_Reduce"];
         this.FBtnReduce.OnClick = this.BtnReduceOnClick;
         this.FBtnExchange = new TUIButton();
         this.FBtnExchange.Substrate = this.FMainUI["Btn_Exchange"];
         this.FBtnExchange.OnClick = this.BtnExchangeOnClick;
         this.FBtnClose = new TUIButton();
         this.FBtnClose.Substrate = this.FMainUI["Close"];
         this.FBtnClose.OnClick = this.BtnCloseOnClick;
         _loc2_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.PillExchangeRate) as TConfigValue;
         this.FExchagneRate = _loc2_.Value as int;
      }
      
      public function UILocation() : void
      {
      }
      
      protected function RenderUI() : void
      {
         this.FTFNormalPillNum.text = this.FHeroChangeData.NormalSoulPillNum.toString();
         this.FTFGradePillNum.text = this.FHeroChangeData.GradeSoulPillNum.toString();
         this.FSlotNormalPill.Context = this.FHeroChangeData.NormalSoulPillInventory;
         this.FSlotGradePill.Context = this.FHeroChangeData.GradeSoulPillInventory;
      }
      
      protected function SetSelectNum(param1:int) : void
      {
         this.FCurrentSelectNum = param1;
         this.FTFExchangeNum.text = param1.toString();
         this.FTFCostNum.text = (param1 * this.FExchagneRate).toString();
      }
      
      protected function CheckSelectNum(param1:int) : int
      {
         if(param1 < 0)
         {
            return 0;
         }
         if(param1 > this.FMaxSelectNum)
         {
            return this.FMaxSelectNum;
         }
         return param1;
      }
      
      protected function InitMaxExchangeNum() : void
      {
         this.FMaxSelectNum = this.FHeroChangeData.NormalSoulPillNum / this.FExchagneRate;
      }
      
      protected function UpdateSoulPill() : void
      {
         this.FSlotNormalPill.Update();
         this.FSlotGradePill.Update();
      }
      
      protected function TextChange(param1:Event) : void
      {
         var _loc2_:int = 0;
         _loc2_ = parseInt(this.FTFExchangeNum.text);
         this.SetSelectNum(this.CheckSelectNum(_loc2_));
      }
      
      protected function BtnAddOnClick(param1:Object, param2:MouseEvent) : void
      {
         this.SetSelectNum(this.CheckSelectNum(this.FCurrentSelectNum + 1));
      }
      
      protected function BtnReduceOnClick(param1:Object, param2:MouseEvent) : void
      {
         this.SetSelectNum(this.CheckSelectNum(this.FCurrentSelectNum - 1));
      }
      
      protected function BtnExchangeOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TPacket = null;
         _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_HeroChange_ExchangePillReq);
         _loc3_.Data.writeInt(this.FCurrentSelectNum);
         SNetworkCore.Transceiver.PacketTransmit(_loc3_);
      }
      
      protected function BtnCloseOnClick(param1:Object, param2:MouseEvent) : void
      {
         ProcessorWindowClose();
         this.Reset();
      }
      
      public function set HeroChangeData(param1:THeroChangeData) : void
      {
         this.FHeroChangeData = param1;
      }
      
      public function Reset() : void
      {
         this.SetSelectNum(0);
         this.FSlotGradePill.Context = null;
         this.FSlotNormalPill.Context = null;
      }
      
      public function Show() : void
      {
         this.InitMaxExchangeNum();
         this.RenderUI();
         this.SetSelectNum(0);
         Visible = true;
      }
      
      public function ExchangePillNotify() : void
      {
         this.Show();
      }
   }
}

