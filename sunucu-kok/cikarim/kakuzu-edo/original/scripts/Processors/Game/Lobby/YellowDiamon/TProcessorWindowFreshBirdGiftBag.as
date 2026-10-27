package Processors.Game.Lobby.YellowDiamon
{
   import Components.Slots.TUISlot;
   import Components.Standard.TUIButton;
   import Externals.SExternalCore;
   import Foundation.Network.SNetworkCore;
   import Foundation.Network.TPacket;
   import Foundation.Resources.Bins.TBins;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.TUIComponent;
   import Logics.Agent.SParametersCore;
   import Logics.DatebaseVO.VO.Json.TFixedAward;
   import Logics.DatebaseVO.VO.TAward;
   import Logics.DatebaseVO.VO.THDYellowDiamonGiftBagFreshBag;
   import Logics.Inventories.TInventories;
   import Logics.SLogicsCore;
   import Logics.Streamization.Inventories.TUnstreamizerInventoryReference;
   import Logics.YellowDiamon.TYellowDiamon;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import Processors.Game.Lobby.Jade.TJadeCommon;
   import Resources.Constants.CONST_COMMON;
   import Resources.Constants.CONST_DATEBASEVO;
   import Resources.Constants.CONST_NETWORK;
   import Resources.Constants.CONST_YELLOWDIAMON;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class TProcessorWindowFreshBirdGiftBag extends TProcessorLobbyWindow
   {
      
      protected static const FreshGiftBagActivityID:int = 10005;
      
      protected var FUnstreamizerInventoryReference:TUnstreamizerInventoryReference;
      
      protected var FDredgeFlag:Sprite;
      
      protected var FDredgeYellowDiamon:TUIButton;
      
      protected var FReciveBtn:TUIButton;
      
      protected var FMC_AlreadyGet:Sprite;
      
      protected var FSlots:Vector.<TUISlot>;
      
      protected var FRewards:TInventories;
      
      protected var FYelloDiamondInfor:TYellowDiamon;
      
      protected var FGiftPrice:TextField;
      
      protected var FDredgeYearFlag:Sprite;
      
      protected var FSlotsYear:Vector.<TUISlot>;
      
      protected var FReciveYearBtn:TUIButton;
      
      protected var FYearRewards:TInventories;
      
      protected var FGiftPriceYear:TextField;
      
      protected var FMC_AlreadyGetYear:Sprite;
      
      protected var FSlotOnOver:Function;
      
      protected var FSlotOnOut:Function;
      
      protected var FHintOnOver:Function;
      
      protected var FHintOnOut:Function;
      
      public function TProcessorWindowFreshBirdGiftBag(param1:TUIComponent)
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
      
      public function UIDispatch_Perform(param1:Sprite) : void
      {
         var _loc2_:int = 0;
         var _loc3_:TUISlot = null;
         var _loc4_:MovieClip = null;
         var _loc5_:MovieClip = null;
         var _loc6_:THDYellowDiamonGiftBagFreshBag = null;
         addChild(param1);
         this.FGiftPrice = param1["GiftPrice"];
         this.FSlots = new Vector.<TUISlot>();
         _loc4_ = param1["Slots"];
         this.FSlotsYear = new Vector.<TUISlot>();
         _loc5_ = param1["SlotsYear"];
         _loc2_ = 0;
         while(_loc2_ < 6)
         {
            _loc3_ = new TUISlot(this);
            TJadeCommon.InitSlot(_loc3_);
            _loc3_.Resource = _loc4_["Slot" + _loc2_];
            _loc3_.OnOver = this.ProcessorOnSlotOver;
            _loc3_.OnOut = this.ProcessorOnSlotOut;
            _loc3_.Init();
            this.FSlots.push(_loc3_);
            _loc2_++;
         }
         this.FDredgeFlag = param1["DredgeFlag"];
         this.FDredgeYellowDiamon = new TUIButton();
         this.FDredgeYellowDiamon.Substrate = param1["Dredge"];
         this.FDredgeYellowDiamon.OnClick = this.OpenYellowDiamon;
         this.FReciveBtn = new TUIButton();
         this.FReciveBtn.Substrate = param1["ReciveBtn"];
         this.FRewards = new TInventories();
         this.FUnstreamizerInventoryReference = new TUnstreamizerInventoryReference();
         _loc6_ = this.LoadReawardInfor();
         this.FGiftPrice.text = _loc6_.Gold[0].toString();
         this.FMC_AlreadyGet = param1["MC_AlreadyGet"];
      }
      
      public function UILocation_Perform() : void
      {
         this.FReciveBtn.OnClick = this.OnReceiveBtnClick;
         this.Reset();
      }
      
      protected function Update_Perform() : void
      {
         this.FlushRewardInfor(this.FSlots,this.FRewards);
         this.FMC_AlreadyGet.visible = this.FYelloDiamondInfor.IFReciveFreshGiftBag;
         this.FDredgeYellowDiamon.Visible = !this.FYelloDiamondInfor.IFYellowDiamondUser;
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
      
      protected function LoadReawardInfor() : THDYellowDiamonGiftBagFreshBag
      {
         var _loc1_:TInventories = null;
         var _loc2_:int = 0;
         var _loc3_:THDYellowDiamonGiftBagFreshBag = null;
         var _loc4_:int = 0;
         _loc3_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_HDYDFreshGiftBag,FreshGiftBagActivityID) as THDYellowDiamonGiftBagFreshBag;
         _loc4_ = int(_loc3_.ActAwards.length);
         this.ProcessorGetInventories(_loc3_.ActAwards[0].Awards[0],this.FRewards);
         return _loc3_;
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
      
      protected function UpdateSlots() : void
      {
         var _loc1_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < this.FSlots.length)
         {
            this.FSlots[_loc1_].Update();
            _loc1_++;
         }
      }
      
      protected function OnReceiveBtnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TPacket = null;
         _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_YellowDiamondRecive_Req);
         _loc3_.Data.writeUnsignedInt(CONST_YELLOWDIAMON.YellowDiamondType_Fresh);
         _loc3_.Data.writeUnsignedInt(0);
         SNetworkCore.Transceiver.PacketTransmit(_loc3_);
      }
      
      protected function OnReceiveYearBtnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TPacket = null;
         _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_YellowDiamondRecive_Req);
         _loc3_.Data.writeUnsignedInt(CONST_YELLOWDIAMON.YellowDiamondType_Fresh);
         _loc3_.Data.writeUnsignedInt(1);
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
      
      public function Reset() : void
      {
         this.FReciveBtn.Enabled = false;
         this.FDredgeFlag.visible = false;
      }
      
      public function IfCanRecieve() : Boolean
      {
         if(this.FYelloDiamondInfor.IFYellowDiamondUser)
         {
            return !this.FYelloDiamondInfor.IFReciveFreshGiftBag;
         }
         return false;
      }
   }
}

