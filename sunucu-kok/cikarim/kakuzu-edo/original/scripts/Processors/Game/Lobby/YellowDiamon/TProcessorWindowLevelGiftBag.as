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
   import Logics.DatebaseVO.VO.THDYellowDiamonGiftBagLevelBag;
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
   
   public class TProcessorWindowLevelGiftBag extends TProcessorLobbyWindow
   {
      
      protected static const LevelNum:int = 5;
      
      protected static const LevelGiftBagActivityID:int = 10004;
      
      protected static const ReciveState_CanRecive:int = 1;
      
      protected static const ReciveFlag_AlreadyRecive:int = 2;
      
      protected var FUnstreamizerInventoryReference:TUnstreamizerInventoryReference;
      
      protected var FBoxsUI:Vector.<MovieClip>;
      
      protected var FBoxs:Vector.<MovieClip>;
      
      protected var FSelectBox:Vector.<MovieClip>;
      
      protected var FSuspensionBox:Vector.<MovieClip>;
      
      protected var FReciveFlags:Vector.<MovieClip>;
      
      protected var FSlots:Vector.<TUISlot>;
      
      protected var FSlotGroup:Sprite;
      
      protected var FLockedFlag:Sprite;
      
      protected var FReciveFlag:MovieClip;
      
      protected var FRenewal:TUIButton;
      
      protected var FReciveBtn:TUIButton;
      
      protected var FTF_Level:TextField;
      
      protected var FRewards:Vector.<TInventories>;
      
      protected var FCurrentSelectBoxIndex:int;
      
      protected var FYelloDiamondInfor:TYellowDiamon;
      
      protected var FSlotOnOver:Function;
      
      protected var FSlotOnOut:Function;
      
      protected var FHintOnOver:Function;
      
      protected var FHintOnOut:Function;
      
      public function TProcessorWindowLevelGiftBag(param1:TUIComponent)
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
         var _loc3_:MovieClip = null;
         var _loc4_:TUISlot = null;
         addChild(param1);
         this.FBoxsUI = new Vector.<MovieClip>();
         this.FBoxs = new Vector.<MovieClip>();
         this.FSelectBox = new Vector.<MovieClip>();
         this.FSuspensionBox = new Vector.<MovieClip>();
         this.FSlots = new Vector.<TUISlot>();
         this.FReciveFlags = new Vector.<MovieClip>();
         _loc2_ = 0;
         while(_loc2_ < LevelNum)
         {
            _loc3_ = param1["GrowBag" + _loc2_];
            this.FBoxs.push(_loc3_["Box"]);
            this.FSelectBox.push(_loc3_["SelectBox"]);
            this.FSuspensionBox.push(_loc3_["SuspensionBox"]);
            this.FReciveFlags.push(_loc3_["reciveFlag"]);
            this.FBoxsUI.push(_loc3_);
            _loc2_++;
         }
         this.FSlotGroup = param1["SlotGroup"];
         _loc2_ = 0;
         while(_loc2_ < 6)
         {
            _loc4_ = new TUISlot(this);
            TJadeCommon.InitSlot(_loc4_);
            _loc4_.Resource = this.FSlotGroup["Slot" + _loc2_];
            _loc4_.OnOver = this.ProcessorOnSlotOver;
            _loc4_.OnOut = this.ProcessorOnSlotOut;
            _loc4_.Init();
            this.FSlots.push(_loc4_);
            _loc2_++;
         }
         this.FLockedFlag = param1["Locked"];
         this.FReciveFlag = param1["ReciveFlag"];
         this.FRenewal = new TUIButton();
         this.FRenewal.Substrate = param1["Renewal"];
         this.FRenewal.OnClick = this.OpenYellowDiamon;
         this.FReciveBtn = new TUIButton();
         this.FReciveBtn.Substrate = param1["ReciveBtn"];
         this.FTF_Level = param1["Level"];
         this.FUnstreamizerInventoryReference = new TUnstreamizerInventoryReference();
         this.FRewards = new Vector.<TInventories>();
         this.LoadReawardInfor();
      }
      
      public function UILocation_Perform() : void
      {
         var _loc1_:int = 0;
         var _loc2_:MovieClip = null;
         _loc1_ = 0;
         while(_loc1_ < LevelNum)
         {
            _loc2_ = this.FBoxsUI[_loc1_];
            _loc2_.buttonMode = true;
            _loc2_.addEventListener(MouseEvent.CLICK,this.OnBoxClick);
            _loc2_.addEventListener(MouseEvent.MOUSE_OVER,this.OnBoxOver);
            _loc2_.addEventListener(MouseEvent.MOUSE_OUT,this.OnBoxOut);
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < this.FBoxs.length)
         {
            this.FBoxs[_loc1_].gotoAndStop(_loc1_ + 2);
            _loc1_++;
         }
         this.FReciveBtn.OnClick = this.ReciveBtnClick;
         this.Reset();
      }
      
      public function Update_BoxState() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < LevelNum)
         {
            this.FReciveFlags[_loc1_].stop();
            _loc2_ = 1 << _loc1_;
            if(this.FYelloDiamondInfor.IFYellowDiamondUser)
            {
               if((this.FYelloDiamondInfor.LevelGiftBagState & _loc2_) != 0)
               {
                  this.FReciveFlags[_loc1_].visible = true;
                  this.FReciveFlags[_loc1_].gotoAndStop(ReciveFlag_AlreadyRecive);
               }
               else if(this.FYelloDiamondInfor.Level == _loc1_ + 1)
               {
                  this.FReciveFlags[_loc1_].visible = true;
                  this.FReciveFlags[_loc1_].gotoAndStop(ReciveState_CanRecive);
               }
               else
               {
                  this.FReciveFlags[_loc1_].visible = false;
               }
            }
            else
            {
               this.FReciveFlags[_loc1_].visible = false;
            }
            _loc1_++;
         }
      }
      
      public function Update_GoldBoxState() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < LevelNum)
         {
            this.FReciveFlags[_loc1_].stop();
            _loc2_ = 1 << _loc1_ + 1;
            this.FReciveFlags[_loc1_].visible = false;
            if(this.FYelloDiamondInfor.IFYellowDiamondUser)
            {
               if((this.FYelloDiamondInfor.LevelGiftBagState & _loc2_) != 0)
               {
                  this.FReciveFlags[_loc1_].visible = true;
                  this.FReciveFlags[_loc1_].gotoAndStop(ReciveFlag_AlreadyRecive);
               }
               else if(this.FYelloDiamondInfor.Level >= _loc1_ + 2)
               {
                  this.FReciveFlags[_loc1_].visible = true;
                  this.FReciveFlags[_loc1_].gotoAndStop(ReciveState_CanRecive);
               }
            }
            _loc1_++;
         }
      }
      
      public function Update_Perform() : void
      {
         var _loc1_:int = 0;
         this.FlushRewardInfor(this.FSlots,this.FRewards[this.FCurrentSelectBoxIndex]);
         this.FReciveFlag.visible = false;
         this.FReciveBtn.Enabled = false;
         this.FLockedFlag.visible = false;
         this.FTF_Level.visible = false;
         this.FRenewal.Enabled = true;
         this.FRenewal.Visible = !this.FYelloDiamondInfor.IFYellowDiamondUser;
         if(this.FYelloDiamondInfor.IFYellowDiamondUser)
         {
            this.FLockedFlag.visible = false;
            this.FTF_Level.visible = true;
            this.FTF_Level.text = "LV" + this.FYelloDiamondInfor.Level;
            _loc1_ = 1 << this.FCurrentSelectBoxIndex;
            if((this.FYelloDiamondInfor.LevelGiftBagState & _loc1_) != 0)
            {
               this.FReciveFlag.visible = true;
            }
            else if(this.FYelloDiamondInfor.Level == this.FCurrentSelectBoxIndex + 1)
            {
               this.FReciveBtn.Visible = true;
               this.FReciveBtn.Enabled = true;
            }
         }
      }
      
      public function Update_GoldPerform() : void
      {
         var _loc1_:int = 0;
         this.FlushRewardInfor(this.FSlots,this.FRewards[this.FCurrentSelectBoxIndex]);
         this.FReciveFlag.visible = false;
         this.FReciveBtn.Enabled = false;
         this.FLockedFlag.visible = false;
         this.FTF_Level.visible = false;
         this.FRenewal.Enabled = true;
         this.FRenewal.Visible = !this.FYelloDiamondInfor.IFYellowDiamondUser;
         if(this.FYelloDiamondInfor.IFYellowDiamondUser)
         {
            this.FLockedFlag.visible = false;
            this.FTF_Level.visible = true;
            this.FTF_Level.text = "LV" + this.FYelloDiamondInfor.Level;
            _loc1_ = 1 << this.FCurrentSelectBoxIndex + 1;
            if((this.FYelloDiamondInfor.LevelGiftBagState & _loc1_) != 0)
            {
               this.FReciveFlag.visible = true;
            }
            else if(this.FYelloDiamondInfor.Level >= this.FCurrentSelectBoxIndex + 2)
            {
               this.FReciveBtn.Visible = true;
               this.FReciveBtn.Enabled = true;
            }
         }
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
      
      protected function LoadReawardInfor() : void
      {
         var _loc1_:TInventories = null;
         var _loc2_:int = 0;
         var _loc3_:THDYellowDiamonGiftBagLevelBag = null;
         var _loc4_:int = 0;
         _loc3_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_HDYDLevelGiftBag,LevelGiftBagActivityID) as THDYellowDiamonGiftBagLevelBag;
         _loc4_ = int(_loc3_.ActAwards.length);
         _loc2_ = 0;
         while(_loc2_ < _loc4_)
         {
            _loc1_ = new TInventories();
            this.ProcessorGetInventories(_loc3_.ActAwards[_loc2_].Awards[0],_loc1_);
            this.FRewards.push(_loc1_);
            _loc2_++;
         }
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
      
      protected function OnBoxClick(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = null;
         _loc2_ = param1.currentTarget as MovieClip;
         this.FSelectBox[this.FCurrentSelectBoxIndex].visible = false;
         this.FSelectBox[this.FCurrentSelectBoxIndex].stop();
         this.FCurrentSelectBoxIndex = this.FBoxsUI.indexOf(_loc2_);
         this.FSelectBox[this.FCurrentSelectBoxIndex].visible = true;
         this.FSelectBox[this.FCurrentSelectBoxIndex].gotoAndPlay(1);
         this.Update_GoldPerform();
      }
      
      protected function OnBoxOver(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:int = 0;
         _loc2_ = param1.currentTarget as MovieClip;
         _loc3_ = this.FBoxsUI.indexOf(_loc2_);
         this.FSuspensionBox[_loc3_].visible = true;
      }
      
      protected function OnBoxOut(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:int = 0;
         _loc2_ = param1.currentTarget as MovieClip;
         _loc3_ = this.FBoxsUI.indexOf(_loc2_);
         this.FSuspensionBox[_loc3_].visible = false;
      }
      
      protected function ReciveBtnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TPacket = null;
         _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_YellowDiamondRecive_Req);
         _loc3_.Data.writeUnsignedInt(CONST_YELLOWDIAMON.YellowDiamondType_Level);
         _loc3_.Data.writeUnsignedInt(this.FCurrentSelectBoxIndex + 1);
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
         this.Update_GoldPerform();
         this.Update_GoldBoxState();
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
         var _loc1_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < LevelNum)
         {
            this.FBoxs[_loc1_].stop();
            this.FSelectBox[_loc1_].stop();
            this.FSelectBox[_loc1_].visible = false;
            this.FSuspensionBox[_loc1_].stop();
            this.FSuspensionBox[_loc1_].visible = false;
            _loc1_++;
         }
         this.FReciveFlag.visible = false;
         this.FReciveFlag.stop();
         this.FRenewal.Enabled = false;
         this.FReciveBtn.Enabled = false;
      }
      
      public function IfCanRecieve() : Boolean
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < LevelNum)
         {
            _loc2_ = 1 << _loc1_ + 1;
            if(this.FYelloDiamondInfor.IFYellowDiamondUser)
            {
               if(this.FYelloDiamondInfor.Level >= _loc1_ + 2 && (this.FYelloDiamondInfor.LevelGiftBagState & _loc2_) == 0)
               {
                  return true;
               }
            }
            _loc1_++;
         }
         return false;
      }
   }
}

