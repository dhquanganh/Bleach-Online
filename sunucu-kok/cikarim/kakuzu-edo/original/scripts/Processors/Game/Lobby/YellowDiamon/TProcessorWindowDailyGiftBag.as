package Processors.Game.Lobby.YellowDiamon
{
   import Components.Slots.*;
   import Components.Standard.*;
   import Externals.*;
   import Foundation.Network.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Bins.*;
   import Foundation.UI.*;
   import Logics.*;
   import Logics.Agent.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.DatebaseVO.VO.Json.*;
   import Logics.Inventories.*;
   import Logics.Streamization.Inventories.*;
   import Logics.YellowDiamon.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Jade.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   
   public class TProcessorWindowDailyGiftBag extends TProcessorLobbyWindow
   {
      
      protected static const LevelNum:int = 6;
      
      protected static const DailyGiftBagActivityID:int = 10001;
      
      protected static const YearDailyGiftBagActivityID:int = 10002;
      
      protected var FUnstreamizerInventoryReference:TUnstreamizerInventoryReference;
      
      protected var FDredgeYellowDiamon:TUIButton;
      
      protected var FDredgeYearYellowDiamon:TUIButton;
      
      protected var FReciveGiftBag:TUIButton;
      
      protected var FYellowDiamonAlreadReciveFlag:Sprite;
      
      protected var FBtn_OpenYellows:Vector.<TUIButton>;
      
      protected var FAlreadyReciveFlag:Vector.<Sprite>;
      
      protected var FReciveBtns:Vector.<TUIButton>;
      
      protected var FRewardSlots:Vector.<Vector.<TUISlot>>;
      
      protected var FRedBoard:Vector.<Sprite>;
      
      protected var FRewards:Vector.<TInventories>;
      
      protected var FYearRewards:TInventories;
      
      protected var FYearRewardSlot:TUISlot;
      
      protected var FYelloDiamondInfor:TYellowDiamon;
      
      protected var FSlotOnOver:Function;
      
      protected var FSlotOnOut:Function;
      
      protected var FHintOnOver:Function;
      
      protected var FHintOnOut:Function;
      
      public function TProcessorWindowDailyGiftBag(param1:TUIComponent)
      {
         super(param1);
         this.FYelloDiamondInfor = SLogicsCore.Character.YellowDimondInfor;
      }
      
      override protected function LogicsPerform() : void
      {
         var _loc1_:int = 0;
         super.LogicsPerform();
         if(visible)
         {
            this.UpdateSlots();
         }
      }
      
      protected function UIDispatch_Perform(param1:Sprite) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TUISlot = null;
         var _loc5_:Vector.<TUISlot> = null;
         var _loc6_:MovieClip = null;
         var _loc7_:TUIButton = null;
         addChild(param1);
         this.FBtn_OpenYellows = new Vector.<TUIButton>();
         this.FAlreadyReciveFlag = new Vector.<Sprite>();
         this.FReciveBtns = new Vector.<TUIButton>();
         this.FRewardSlots = new Vector.<Vector.<TUISlot>>();
         this.FRedBoard = new Vector.<Sprite>();
         _loc2_ = 0;
         while(_loc2_ < LevelNum)
         {
            _loc6_ = param1["RewardSlots" + _loc2_];
            _loc5_ = new Vector.<TUISlot>();
            this.FRewardSlots.push(_loc5_);
            _loc3_ = 0;
            while(_loc3_ < 4)
            {
               _loc4_ = new TUISlot(this);
               _loc4_.OnOver = this.ProcessorOnSlotOver;
               _loc4_.OnOut = this.ProcessorOnSlotOut;
               TJadeCommon.InitSlot(_loc4_);
               _loc4_.Resource = _loc6_["Slot" + _loc3_];
               _loc4_.Init();
               _loc5_.push(_loc4_);
               _loc3_++;
            }
            _loc6_ = _loc6_["BagState"];
            _loc7_ = new TUIButton();
            _loc7_.Substrate = _loc6_["BtnRecive"];
            this.FReciveBtns.push(_loc7_);
            _loc7_ = new TUIButton();
            _loc7_.Substrate = _loc6_["Btn_OpenYellow"];
            this.FBtn_OpenYellows.push(_loc7_);
            this.FAlreadyReciveFlag.push(_loc6_["AlreadyRecive"]);
            this.FRedBoard.push(_loc6_["RedBoard"]);
            _loc2_++;
         }
         this.FDredgeYellowDiamon = new TUIButton();
         this.FDredgeYellowDiamon.Substrate = param1["DredgeYellowDiamon"];
         this.FDredgeYellowDiamon.OnClick = this.OpenYellowDiamon;
         this.FDredgeYearYellowDiamon = new TUIButton();
         this.FDredgeYearYellowDiamon.Substrate = param1["DredgeYearYellowDiamon"];
         this.FDredgeYearYellowDiamon.OnClick = this.OpenYearYellowDiamon;
         this.FReciveGiftBag = new TUIButton();
         this.FReciveGiftBag.Substrate = param1["ReceiveBag"];
         this.FReciveGiftBag.OnClick = this.ReciveYearBtnClick;
         this.FYellowDiamonAlreadReciveFlag = param1["AlreadyReceiveFlag"];
         this.FYearRewardSlot = new TUISlot(this);
         this.FYearRewardSlot.Resource = param1["YearSlot"];
         TJadeCommon.InitSlot(this.FYearRewardSlot);
         this.FYearRewardSlot.OnOver = this.ProcessorOnSlotOver;
         this.FYearRewardSlot.OnOut = this.ProcessorOnSlotOut;
         this.FYearRewardSlot.Init();
         this.FUnstreamizerInventoryReference = new TUnstreamizerInventoryReference();
         this.FRewards = new Vector.<TInventories>();
         this.FYearRewards = new TInventories();
         this.LoadReawardInfor();
      }
      
      protected function UILocation_Perform() : void
      {
         var _loc1_:int = 0;
         var _loc2_:TUIButton = null;
         _loc1_ = 0;
         while(_loc1_ < LevelNum)
         {
            _loc2_ = this.FReciveBtns[_loc1_];
            _loc2_.OnClick = this.ReciveBtnClick;
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < LevelNum)
         {
            _loc2_ = this.FBtn_OpenYellows[_loc1_];
            _loc2_.OnClick = this.Btn_OpenYellowOnClick;
            _loc1_++;
         }
      }
      
      protected function Update_Perform() : void
      {
         var _loc1_:int = 0;
         var _loc2_:TUIButton = null;
         var _loc3_:int = 0;
         this.FlushSlots();
         _loc1_ = 0;
         while(_loc1_ < LevelNum)
         {
            this.FBtn_OpenYellows[_loc1_].Visible = false;
            this.FAlreadyReciveFlag[_loc1_].visible = false;
            this.FReciveBtns[_loc1_].Visible = true;
            this.FReciveBtns[_loc1_].Enabled = false;
            this.FRedBoard[_loc1_].visible = false;
            _loc1_++;
         }
         this.FReciveGiftBag.Enabled = false;
         this.FYellowDiamonAlreadReciveFlag.visible = false;
         if(this.FYelloDiamondInfor.IFYellowDiamondUser)
         {
            _loc1_ = this.FYelloDiamondInfor.Level - 1;
            if(this.FYelloDiamondInfor.IFReciveDailyGiftBag)
            {
               this.FBtn_OpenYellows[_loc1_].Visible = false;
               this.FAlreadyReciveFlag[_loc1_].visible = true;
               this.FReciveBtns[_loc1_].Visible = false;
            }
            else
            {
               this.FBtn_OpenYellows[_loc1_].Visible = false;
               this.FAlreadyReciveFlag[_loc1_].visible = false;
               this.FReciveBtns[_loc1_].Visible = true;
               this.FReciveBtns[_loc1_].Enabled = true;
               this.FRedBoard[_loc1_].visible = true;
            }
            this.FDredgeYellowDiamon.Visible = false;
         }
         else
         {
            this.FDredgeYellowDiamon.Visible = true;
            this.FDredgeYellowDiamon.Enabled = true;
         }
         if(this.FYelloDiamondInfor.IFYearYellowDiamondUser)
         {
            _loc1_ = this.FYelloDiamondInfor.Level - 1;
            if(this.FYelloDiamondInfor.IFReciveYearDailyGiftBag)
            {
               this.FReciveGiftBag.Enabled = false;
               this.FReciveGiftBag.Visible = false;
               this.FYellowDiamonAlreadReciveFlag.visible = true;
            }
            else
            {
               this.FReciveGiftBag.Enabled = true;
               this.FReciveGiftBag.Visible = true;
               this.FYellowDiamonAlreadReciveFlag.visible = false;
            }
            this.FDredgeYearYellowDiamon.Visible = false;
         }
         else
         {
            this.FDredgeYearYellowDiamon.Visible = true;
            this.FDredgeYearYellowDiamon.Enabled = true;
         }
      }
      
      private function FlushSlots() : void
      {
         this.FYearRewardSlot.Context = this.FYearRewards.GetInventoryByIndex(0);
      }
      
      protected function UpdateSlots() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Vector.<TUISlot> = null;
         _loc1_ = 0;
         while(_loc1_ < this.FRewardSlots.length)
         {
            _loc3_ = this.FRewardSlots[_loc1_];
            _loc2_ = 0;
            while(_loc2_ < _loc3_.length)
            {
               _loc3_[_loc2_].Update();
               _loc2_++;
            }
            _loc1_++;
         }
         this.FYearRewardSlot.Update();
      }
      
      protected function FlushRewardInfor(param1:Vector.<TUISlot>, param2:TInventories) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:TUISlot = null;
         _loc4_ = param2.Count;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc5_ = param1[_loc3_];
            _loc5_.Context = param2.GetInventoryByIndex(_loc3_);
            _loc3_++;
         }
      }
      
      protected function LoadReawardInfor() : void
      {
         var _loc1_:TInventories = null;
         var _loc2_:int = 0;
         var _loc3_:THDYellowDiamonGiftBagDailyBag = null;
         var _loc4_:int = 0;
         var _loc5_:Vector.<uint> = null;
         _loc3_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_HDYDDailyGiftBag,DailyGiftBagActivityID) as THDYellowDiamonGiftBagDailyBag;
         _loc4_ = int(_loc3_.ActAwards.length);
         _loc2_ = 0;
         while(_loc2_ < _loc4_)
         {
            _loc1_ = new TInventories();
            this.ProcessorGetInventories(_loc3_.ActAwards[_loc2_].Awards[0],_loc1_);
            this.FRewards.push(_loc1_);
            _loc2_++;
         }
         _loc3_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_HDYDDailyGiftBag,YearDailyGiftBagActivityID) as THDYellowDiamonGiftBagDailyBag;
         this.ProcessorGetInventories(_loc3_.ActAwards[0].Awards[0],this.FYearRewards);
      }
      
      protected function ProcessorGetInventories(param1:int, param2:TInventories) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:TAward = null;
         var _loc6_:TFixedAward = null;
         var _loc7_:Vector.<uint> = null;
         var _loc8_:TBins = null;
         _loc8_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_Award);
         _loc5_ = _loc8_.GetDatebaseByIdentifier(param1) as TAward;
         _loc4_ = int(_loc5_.FixedAwards.length);
         _loc7_ = new Vector.<uint>(_loc4_);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc6_ = _loc5_.FixedAwards[_loc3_];
            _loc7_[_loc3_] = CONST_COMMON.RewardIDToTemplateID(_loc6_.Type,_loc6_.Code);
            _loc3_++;
         }
         this.FUnstreamizerInventoryReference.UnstreamizeGenerateInventoriesByIdentifiers(null,param2,_loc7_);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc6_ = _loc5_.FixedAwards[_loc3_];
            param2.GetInventoryByIndex(_loc3_).Quantity = _loc6_.Amount;
            _loc3_++;
         }
      }
      
      protected function ReciveBtnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TUIButton = null;
         var _loc4_:int = 0;
         var _loc5_:TPacket = null;
         _loc4_ = this.FReciveBtns.indexOf(param1 as TUIButton);
         _loc5_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_YellowDiamondRecive_Req);
         _loc5_.Data.writeUnsignedInt(CONST_YELLOWDIAMON.YellowDiamondType_Daily);
         _loc5_.Data.writeUnsignedInt(_loc4_);
         SNetworkCore.Transceiver.PacketTransmit(_loc5_);
      }
      
      protected function Btn_OpenYellowOnClick(param1:Object, param2:MouseEvent) : void
      {
         this.OpenYellowDiamon(param1,param2);
      }
      
      protected function ReciveYearBtnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TPacket = null;
         _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_YellowDiamondRecive_Req);
         _loc3_.Data.writeUnsignedInt(CONST_YELLOWDIAMON.YellowDiamondType_YearDaily);
         _loc3_.Data.writeUnsignedInt(0);
         SNetworkCore.Transceiver.PacketTransmit(_loc3_);
      }
      
      protected function ProcessorOnSlotOver(param1:Object, param2:Object) : void
      {
         if(this.FSlotOnOver != null)
         {
            this.FSlotOnOver(this,param2);
         }
      }
      
      protected function ProcessorOnSlotOut(param1:Object, param2:Object) : void
      {
         if(this.FSlotOnOut != null)
         {
            this.FSlotOnOut(this,param2);
         }
      }
      
      protected function OpenYellowDiamon(param1:Object, param2:MouseEvent) : void
      {
         SExternalCore.NavigateToLinkUrl(SParametersCore.YellowVipUrl);
      }
      
      protected function OpenYearYellowDiamon(param1:Object, param2:MouseEvent) : void
      {
         SExternalCore.NavigateToLinkUrl(SParametersCore.YearYellowVipUrl);
         SExternalCore.onOpenButton();
      }
      
      public function set SlotOnOver(param1:Function) : void
      {
         this.FSlotOnOver = param1;
      }
      
      public function set SlotOnOut(param1:Function) : void
      {
         this.FSlotOnOut = param1;
      }
      
      public function set HintOnOver(param1:Function) : void
      {
         this.FHintOnOver = param1;
      }
      
      public function set HintOnOut(param1:Function) : void
      {
         this.FHintOnOut = param1;
      }
      
      public function Update() : void
      {
         this.Update_Perform();
      }
      
      public function UIDispatch(param1:Sprite) : void
      {
         this.UIDispatch_Perform(param1);
      }
      
      public function UILocation() : void
      {
         this.UILocation_Perform();
      }
      
      public function IfCanRecieve() : Boolean
      {
         if(this.FYelloDiamondInfor.IFYellowDiamondUser)
         {
            if(this.FYelloDiamondInfor.IFYearYellowDiamondUser)
            {
               return !this.FYelloDiamondInfor.IFReciveYearDailyGiftBag;
            }
            return !this.FYelloDiamondInfor.IFReciveDailyGiftBag;
         }
         return false;
      }
   }
}

