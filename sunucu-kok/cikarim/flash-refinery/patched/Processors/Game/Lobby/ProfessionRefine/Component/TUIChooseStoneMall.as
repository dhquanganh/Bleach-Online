package Processors.Game.Lobby.ProfessionRefine.Component
{
   import Components.Slots.TUISlot;
   import Components.Standard.TUIButton;
   import Foundation.Network.SNetworkCore;
   import Foundation.Network.TPacket;
   import Foundation.Queries.TQueryBoolean;
   import Foundation.Queries.TQueryString;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.TUIComponent;
   import Logics.Inventories.TInventories;
   import Logics.Inventories.TInventory;
   import Logics.SLogicsCore;
   import Processors.Game.ComponentNew.TUICheckBox;
   import Processors.Game.ComponentNew.TUICustomComponent;
   import Processors.Game.ComponentNew.TUIPage;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Processors.Game.Windows.Information.TUIWindowConfirmation;
   import Resources.Constants.CONST_COMMON;
   import Resources.Constants.CONST_LOBBY;
   import Resources.Constants.CONST_NETWORK;
   import Resources.Constants.CONST_ProfessionRefine;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import Utilities.UI.Windows.TUtilityUIWindow;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.utils.ByteArray;
   
   public class TUIChooseStoneMall extends TUICustomComponent
   {
      
      protected static const ItemMax:int = 35;
      
      protected var FUICheckBoxAll:TUICheckBox;
      
      protected var FUICheckBoxVec:Vector.<TUICheckBox>;
      
      protected var FUISlotVec:Vector.<TUISlot>;
      
      protected var FUIPage:TUIPage;
      
      protected var FBtnSelectAll:TUIButton;
      
      protected var FUISlotCanGet:TUISlot;
      
      protected var FTFName:TextField;
      
      protected var FTFNum:TextField;
      
      protected var FTFCost:TextField;
      
      protected var FBtnMall:TUIButton;
      
      protected var FChooseLevelVec:Vector.<int>;
      
      protected var FInventoryVec:Vector.<TInventory>;
      
      protected var FMallNum:int;

      protected var FLastGemCount:int = -1;
      
      protected var FUIWindowConfirmationMall:TUIWindowConfirmation;
      
      public function TUIChooseStoneMall(param1:TUIComponent)
      {
         super();
         FParent = param1;
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TUICheckBox = null;
         var _loc4_:TUISlot = null;
         this.FUICheckBoxAll = new TUICheckBox();
         this.FUICheckBoxAll.Resource = FResource["MC_ChooseAll"];
         this.FUICheckBoxAll.OnClick = this.OnAllCheckClick;
         this.FUICheckBoxAll.Checked = true;
         this.FUICheckBoxAll.Show();
         _loc2_ = GetUIComponentsCapacity(FResource,"MC_Choose_");
         this.FUICheckBoxVec = new Vector.<TUICheckBox>(_loc2_);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = new TUICheckBox();
            _loc3_.Resource = FResource["MC_Choose_" + _loc1_];
            _loc3_.OnClick = this.OnLevelCheckClick;
            _loc3_.Checked = false;
            _loc3_.Show();
            this.FUICheckBoxVec[_loc1_] = _loc3_;
            _loc1_++;
         }
         _loc2_ = GetUIComponentsCapacity(FResource,"MC_Slot_");
         this.FUISlotVec = new Vector.<TUISlot>(_loc2_);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc4_ = new TUISlot(FParent);
            _loc4_.Resource = FResource["MC_Slot_" + _loc1_];
            _loc4_.SequenceDefaultIcon = SResourcesCore.TexturesLobby.GetAnimationSequenceByIdentifiers(CONST_LOBBY.RESOURCESID_Texture_SlotDefaultEffect,0);
            _loc4_.OnQuerySequenceContext = OnQuerySequenceContext;
            _loc4_.OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
            _loc4_.OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
            _loc4_.OnClick = this.SlotOnClick;
            _loc4_.OnQuerySelectedContext = this.SlotsOnSelectedContext;
            _loc4_.OnQuerySubscript = this.SlotsOnQuerySubscript;
            _loc4_.Init();
            this.FUISlotVec[_loc1_] = _loc4_;
            _loc1_++;
         }
         this.FUIPage = new TUIPage();
         this.FUIPage.PageSize = _loc2_;
         this.FUIPage.Resource = FResource["SP_Page"];
         this.FUIPage.OnChangePage = this.PageOnChange;
         this.FBtnSelectAll = new TUIButton();
         this.FBtnSelectAll.Substrate = FResource["Btn_ChooseAll"];
         this.FBtnSelectAll.OnClick = this.SelectAllOnClick;
         this.FUISlotCanGet = new TUISlot(FParent);
         this.FUISlotCanGet.Resource = FResource["MC_Slot"];
         this.FUISlotCanGet.SequenceDefaultIcon = SResourcesCore.TexturesLobby.GetAnimationSequenceByIdentifiers(CONST_LOBBY.RESOURCESID_Texture_SlotDefaultEffect,0);
         this.FUISlotCanGet.OnQuerySequenceContext = OnQuerySequenceContext;
         this.FUISlotCanGet.OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FUISlotCanGet.OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FUISlotCanGet.Init();
         this.FTFName = FResource["TF_Name"];
         this.FTFNum = FResource["TF_Num"];
         this.FTFCost = FResource["TF_Cost"];
         this.FBtnMall = new TUIButton();
         this.FBtnMall.Substrate = FResource["Btn_Product"];
         this.FBtnMall.OnClick = this.MallOnClick;
         this.FUIWindowConfirmationMall = new TUIWindowConfirmation(this.Parent.Parent);
         this.FUIWindowConfirmationMall.OnOK = this.MallOnOK;
         TUtilityUIWindow.SetupWindowConfirmation(this.FUIWindowConfirmationMall);
         this.FUIWindowConfirmationMall.SetCheckBoxUsable(false);
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function UpdateUI() : void
      {
         var _loc1_:TInventories = null;
         var _loc2_:TInventory = null;
         super.UpdateUI();
         this.OnAllCheckClick(true);
         _loc1_ = new TInventories();
         SToolReward.GetInventoryByID(CONST_ProfessionRefine.BloodStoneId,_loc1_);
         _loc2_ = _loc1_.GetInventoryByIndex(0);
         this.FUISlotCanGet.Context = _loc2_;
         this.FTFName.text = _loc2_.Name;
         this.FTFName.textColor = CONST_COMMON.QUALITYCOLOR_INDEX[_loc2_.Quality];
         this.UpdateCanGetInfo();
      }
      
      protected function GetShowInventoryVec(param1:Boolean) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TInventory = null;
         var _loc5_:int = 0;
         if(this.FChooseLevelVec == null)
         {
            this.FChooseLevelVec = new Vector.<int>();
         }
         this.FChooseLevelVec.length = 0;
         _loc3_ = int(this.FUICheckBoxVec.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(this.FUICheckBoxVec[_loc2_].Checked)
            {
               this.FChooseLevelVec.push(_loc2_ + 1);
            }
            _loc2_++;
         }
         if(this.FInventoryVec == null)
         {
            this.FInventoryVec = new Vector.<TInventory>();
         }
         this.FInventoryVec.length = 0;
         _loc3_ = int(SLogicsCore.Character.Gems.Count);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = SLogicsCore.Character.Gems.GetInventoryByIndex(_loc2_);
            _loc4_.IsSelling = false;
            _loc5_ = this.FChooseLevelVec.indexOf(_loc4_.RequirementLevel);
            if(param1 || -1 != _loc5_)
            {
               this.FInventoryVec.push(_loc4_);
            }
            _loc2_++;
         }
         this.FInventoryVec.sort(this.SortBySortIndex);
      }
      
      protected function UpdateSlots() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         _loc2_ = this.FUIPage.PageIndex * ItemMax;
         _loc3_ = int(this.FInventoryVec.length);
         _loc1_ = 0;
         while(_loc1_ < ItemMax)
         {
            if(_loc2_ + _loc1_ < _loc3_)
            {
               this.FUISlotVec[_loc1_].Context = this.FInventoryVec[_loc2_ + _loc1_];
               this.FUISlotVec[_loc1_].IsSelected = this.FInventoryVec[_loc2_ + _loc1_].IsSelling;
               this.FUISlotVec[_loc1_].Visible = true;
            }
            else
            {
               this.FUISlotVec[_loc1_].Visible = false;
            }
            _loc1_++;
         }
      }
      
      protected function SortBySortIndex(param1:TInventory, param2:TInventory) : int
      {
         if(param1.RequirementLevel > param2.RequirementLevel)
         {
            return 1;
         }
         if(param1.RequirementLevel < param2.RequirementLevel)
         {
            return -1;
         }
         if(param1.SortIndex > param2.SortIndex)
         {
            return 1;
         }
         if(param1.SortIndex < param2.SortIndex)
         {
            return -1;
         }
         return 0;
      }
      
      protected function SlotsOnSelectedContext(param1:Object, param2:Object, param3:TQueryBoolean) : void
      {
         var _loc4_:TInventory = null;
         _loc4_ = param2 as TInventory;
         param3.Value = _loc4_.IsSelling;
      }
      
      protected function SlotsOnQuerySubscript(param1:Object, param2:Object, param3:TQueryString) : void
      {
         var _loc4_:TInventory = null;
         _loc4_ = param2 as TInventory;
         param3.Value = _loc4_.Quantity + "";
      }
      
      protected function UpdateCanGetInfo() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Number = 0;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         this.FMallNum = 0;
         _loc3_ = 0;
         _loc4_ = 0;
         _loc2_ = int(this.FInventoryVec.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            if(this.FInventoryVec[_loc1_].IsSelling)
            {
               ++this.FMallNum;
               _loc3_ += SLogicsCore.ProfessionRefineList.ProductVec[this.FInventoryVec[_loc1_].RequirementLevel - 1] * this.FInventoryVec[_loc1_].Quantity;
               _loc4_ += SLogicsCore.ProfessionRefineList.CostVec[this.FInventoryVec[_loc1_].RequirementLevel - 1] * this.FInventoryVec[_loc1_].Quantity;
            }
            _loc1_++;
         }
         this.FTFNum.text = _loc3_ + "";
         this.FTFNum.textColor = CONST_COMMON.QUALITYCOLOR_Green;
         _loc5_ = Number(SLogicsCore.Character.CreditSilverCoin.ToNumber());
         this.FTFCost.text = _loc4_ + "";
         this.FTFCost.textColor = _loc5_ >= _loc4_ ? CONST_COMMON.QUALITYCOLOR_Green : CONST_COMMON.QUALITYCOLOR_Red;
         this.FBtnMall.Enabled = _loc3_ > 0 && _loc4_ > 0 && _loc5_ >= _loc4_ && _loc3_ + TUtilityLobby.GetArticleQuantity(CONST_ProfessionRefine.BloodStoneId,1) <= 65535 && !SLogicsCore.ProfessionRefineList.Pending;
      }
      
      protected function OnAllCheckClick(param1:Boolean) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         _loc3_ = int(this.FUICheckBoxVec.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FUICheckBoxVec[_loc2_].Checked = param1;
            this.FUICheckBoxVec[_loc2_].Update();
            _loc2_++;
         }
         this.GetShowInventoryVec(param1);
         this.FUIPage.PageIndex = 0;
         this.FUIPage.TotalQuantity = this.FInventoryVec.length;
         this.UpdateSlots();
         this.UpdateCanGetInfo();
      }
      
      protected function OnLevelCheckClick(param1:Boolean) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(param1 == false)
         {
            this.FUICheckBoxAll.Checked = false;
            this.FUICheckBoxAll.Update();
         }
         this.GetShowInventoryVec(false);
         this.FUIPage.PageIndex = 0;
         this.FUIPage.TotalQuantity = this.FInventoryVec.length;
         this.UpdateSlots();
         this.UpdateCanGetInfo();
      }
      
      protected function PageOnChange(param1:Object, param2:int) : void
      {
         this.UpdateSlots();
      }
      
      protected function SlotOnClick(param1:TUISlot, param2:Object) : void
      {
         var _loc3_:TInventory = null;
         _loc3_ = param2 as TInventory;
         _loc3_.IsSelling = !_loc3_.IsSelling;
         param1.IsSelected = _loc3_.IsSelling;
         this.UpdateCanGetInfo();
      }
      
      protected function SelectAllOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _loc4_ = int(this.FInventoryVec.length);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            this.FInventoryVec[_loc3_].IsSelling = true;
            _loc3_++;
         }
         _loc4_ = int(this.FUISlotVec.length);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            if(this.FUISlotVec[_loc3_].Visible)
            {
               this.FUISlotVec[_loc3_].IsSelected = true;
            }
            _loc3_++;
         }
         this.UpdateCanGetInfo();
      }
      
      protected function MallOnClick(param1:Object, param2:MouseEvent) : void
      {
         this.FUIWindowConfirmationMall.Text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ProfessionRefine_SysText_04);
         this.FUIWindowConfirmationMall.Visible = true;
      }
      
      protected function MallOnOK(param1:Object) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TPacket = null;
         var _loc5_:ByteArray = null;
         var _loc6_:TInventory = null;
         if(SLogicsCore.ProfessionRefineList.Pending || this.FMallNum <= 0) return;
         SLogicsCore.ProfessionRefineList.Pending = true;
         _loc4_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_ProfessionRefine_Mall);
         _loc5_ = _loc4_.Data;
         _loc5_.writeShort(this.FMallNum);
         _loc3_ = int(this.FInventoryVec.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc6_ = this.FInventoryVec[_loc2_];
            if(_loc6_.IsSelling)
            {
               _loc5_.writeUnsignedInt(_loc6_.Identifier);
               _loc5_.writeUnsignedInt(_loc6_.IDTemplate);
            }
            _loc2_++;
         }
         SNetworkCore.Transceiver.PacketTransmit(_loc4_);
      }
      
      override public function Reset() : void
      {
         this.GetShowInventoryVec(false);
         super.Reset();
      }
      
      public function LogicsPerform() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc2_ = int(this.FUISlotVec.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            if(this.FUISlotVec[_loc1_].Visible)
            {
               this.FUISlotVec[_loc1_].Update();
            }
            _loc1_++;
         }
         if(!SLogicsCore.ProfessionRefineList.Pending && this.FLastGemCount != SLogicsCore.Character.Gems.Count)
         {
            this.FLastGemCount = SLogicsCore.Character.Gems.Count;
            this.GetShowInventoryVec(false);
            this.UpdateUI();
         }
         this.UpdateCanGetInfo();
         this.FUISlotCanGet.Update();
      }
      
      public function MallSuccess() : void
      {
         this.UpdateUI();
      }
   }
}

