package Processors.Game.Lobby.Talisman.Panel
{
   import Components.ComboBox.TComboBox;
   import Components.Slots.TUISlot;
   import Components.Standard.TUIButton;
   import Foundation.Network.SNetworkCore;
   import Foundation.Network.TPacket;
   import Foundation.Queries.TQueryString;
   import Foundation.Queries.Textures.TQueryAnimationSequence;
   import Foundation.Resources.Repositories.TResourceRepositoryTexture;
   import Foundation.Resources.SResourcesCore;
   import Foundation.Resources.Textures.TTexture;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Logics.DatebaseVO.VO.TConfigValue;
   import Logics.DatebaseVO.VO.TTreasureUpgrade;
   import Logics.Inventories.TEquipment;
   import Logics.Inventories.TInventories;
   import Logics.Inventories.TInventory;
   import Logics.SLogicsCore;
   import Processors.Game.ComponentNew.TUIPage;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Processors.Game.Windows.Information.TUIWindowConfirmation;
   import Resources.Constants.CONST_CONFIGVALUE;
   import Resources.Constants.CONST_DATEBASEVO;
   import Resources.Constants.CONST_LOBBY;
   import Resources.Constants.CONST_NETWORK;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import Resources.Constants.CONST_TALISMAN;
   import Utilities.UI.Windows.TUtilityUIWindow;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.utils.ByteArray;
   
   public class TProcessorWindowProduct extends TProcessorLobbyWindow
   {
      
      private static const IndexLevelVec:Vector.<uint> = Vector.<uint>([0,8,9,10,11,12,13,CONST_TALISMAN.TALISMAN_UpgradePaper,CONST_TALISMAN.TALISMAN_TransitionPaper]);
      
      private static const ItemMax:int = 35;
      
      private var FScene:MovieClip;
      
      private var FLevelComboBox:TComboBox;
      
      private var FLevelList:Vector.<DisplayObject>;
      
      private var FLevelIndex:uint;
      
      private var FCurInventories:TInventories;
      
      private var FUISlotVec:Vector.<TUISlot>;
      
      private var FUIPage:TUIPage;
      
      private var FBtnSelectAll:TUIButton;
      
      private var FUISlotCanGet:TUISlot;
      
      private var FTFName:TextField;
      
      private var FTFNum:TextField;
      
      private var FBtnMall:TUIButton;
      
      private var FUIWindowConfirmationMall:TUIWindowConfirmation;
      
      private var FMallNum:int;
      
      private var FProductNum:int;
      
      private var FProductId:int;
      
      public function TProcessorWindowProduct(param1:TUIComponent)
      {
         super(param1);
         this.FProductNum = 0;
         this.FProductId = 0;
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Vector.<String> = null;
         var _loc4_:DisplayObject = null;
         var _loc5_:TUISlot = null;
         this.FScene = TUtilityReflection.CreateDisplayObjectInstance("MC_Product") as MovieClip;
         this.x = CONST_TALISMAN.POSX_NEW_SCENE;
         this.y = CONST_TALISMAN.POSY_NEW_SCENE;
         addChild(this.FScene);
         this.FLevelList = new Vector.<DisplayObject>();
         _loc3_ = TUtilityLobby.GetStringsByIdentifier(CONST_SYSTEMLANGUAGE.TALISMAN_STRING_39);
         _loc2_ = int(_loc3_.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc4_ = this.MakeComboItem(_loc3_[_loc1_]);
            this.FLevelList.push(_loc4_);
            _loc1_++;
         }
         this.FLevelComboBox = new TComboBox(this,this.FScene["MC_TalismanLevel"],this.FLevelList,90,this.OnLevelSelect);
         _loc2_ = ItemMax;
         this.FUISlotVec = new Vector.<TUISlot>(_loc2_);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc5_ = new TUISlot(FParent);
            _loc5_.Resource = this.FScene["MC_Slot_" + _loc1_];
            _loc5_.SequenceDefaultIcon = SResourcesCore.TexturesLobby.GetAnimationSequenceByIdentifiers(CONST_LOBBY.RESOURCESID_Texture_SlotDefaultEffect,0);
            _loc5_.OnQuerySequenceContext = this.OnQuerySequenceContext;
            _loc5_.OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
            _loc5_.OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
            _loc5_.OnClick = this.SlotOnClick;
            _loc5_.OnQueryEuqipLevel = this.SlotsOnQueryEuqipLevel;
            _loc5_.Init();
            this.FUISlotVec[_loc1_] = _loc5_;
            _loc1_++;
         }
         this.FUIPage = new TUIPage();
         this.FUIPage.PageSize = _loc2_;
         this.FUIPage.Resource = this.FScene["SP_Page"];
         this.FUIPage.OnChangePage = this.PageOnChange;
         this.FBtnSelectAll = new TUIButton();
         this.FBtnSelectAll.Substrate = this.FScene["Btn_ChooseAll"];
         this.FBtnSelectAll.OnClick = this.SelectAllOnClick;
         this.FUISlotCanGet = new TUISlot(FParent);
         this.FUISlotCanGet.Resource = this.FScene["MC_Slot"];
         this.FUISlotCanGet.SequenceDefaultIcon = SResourcesCore.TexturesLobby.GetAnimationSequenceByIdentifiers(CONST_LOBBY.RESOURCESID_Texture_SlotDefaultEffect,0);
         this.FUISlotCanGet.OnQuerySequenceContext = this.OnQuerySequenceContext;
         this.FUISlotCanGet.OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FUISlotCanGet.OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FUISlotCanGet.Init();
         this.FTFName = this.FScene["TF_Name"];
         this.FTFNum = this.FScene["TF_Num"];
         this.FBtnMall = new TUIButton();
         this.FBtnMall.Substrate = this.FScene["Btn_Product"];
         this.FBtnMall.OnClick = this.MallOnClick;
         this.FUIWindowConfirmationMall = new TUIWindowConfirmation(this.Parent.Parent);
         this.FUIWindowConfirmationMall.OnOK = this.MallOnOK;
         TUtilityUIWindow.SetupWindowConfirmation(this.FUIWindowConfirmationMall);
         this.FUIWindowConfirmationMall.SetCheckBoxUsable(false);
         super.ResourcesPerform_UIDispatch();
      }
      
      private function MakeComboItem(param1:String) : DisplayObject
      {
         var _loc2_:MovieClip = null;
         _loc2_ = TUtilityReflection.CreateDisplayObjectInstance("MC_TalismanList") as MovieClip;
         _loc2_.tf_into.text = param1;
         return _loc2_;
      }
      
      private function OnQuerySequenceContext(param1:Object, param2:Object, param3:TQueryAnimationSequence, param4:uint = 0) : void
      {
         var _loc5_:TInventory = null;
         var _loc6_:TResourceRepositoryTexture = null;
         var _loc7_:TTexture = null;
         _loc5_ = param2 as TInventory;
         _loc6_ = SResourcesCore.TexturesInventory;
         _loc7_ = _loc6_.GetTextureByIdentifier(_loc5_.IDTexture);
         if(_loc7_ != null)
         {
            param3.Value = _loc7_.GetAnimationSequenceByIdentifier(param4);
         }
         else
         {
            _loc6_.LoadSecondary(_loc5_.IDTexture);
         }
      }
      
      private function SlotsOnQueryEuqipLevel(param1:Object, param2:Object, param3:TQueryString) : void
      {
         var _loc4_:TEquipment = null;
         var _loc5_:TInventory = null;
         if(param2 is TEquipment)
         {
            _loc4_ = param2 as TEquipment;
            if(_loc4_.UpgradingLevel > 0)
            {
               param3.Value = "Lv." + _loc4_.UpgradingLevel.toString();
            }
         }
         else
         {
            _loc5_ = param2 as TInventory;
            if(_loc5_ != null)
            {
               param3.Value = _loc5_.Quantity + "";
            }
         }
      }
      
      override protected function LogicsPerform() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TUISlot = null;
         super.LogicsPerform();
         if(!Visible)
         {
            return;
         }
         _loc2_ = ItemMax;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FUISlotVec[_loc1_].Update();
            _loc1_++;
         }
         this.FUISlotCanGet.Update();
      }
      
      private function UpdateUI() : void
      {
         this.OnLevelSelect(null,0);
         this.UpdateCanGetInfo();
      }
      
      private function UpdateBackpack() : void
      {
         var _loc1_:int = 0;
         var _loc2_:uint = 0;
         var _loc3_:TInventory = null;
         var _loc4_:TInventories = null;
         _loc4_ = new TInventories();
         _loc2_ = uint(SLogicsCore.Character.Treasures.Count);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = SLogicsCore.Character.Treasures.GetInventoryByIndex(_loc1_);
            if(_loc3_ != null && this.CheckLevel(_loc3_))
            {
               _loc3_.IsSelling = false;
               _loc4_.Add(_loc3_);
            }
            _loc1_++;
         }
         switch(this.FLevelIndex)
         {
            case 0:
               _loc3_ = this.UpgradePaper;
               if(_loc3_ != null)
               {
                  _loc3_.IsSelling = false;
                  _loc4_.Add(_loc3_);
               }
               _loc3_ = this.TransitionPaper;
               if(_loc3_ != null)
               {
                  _loc3_.IsSelling = false;
                  _loc4_.Add(_loc3_);
               }
               break;
            case CONST_TALISMAN.TALISMAN_UpgradePaper:
               _loc3_ = this.UpgradePaper;
               if(_loc3_ != null)
               {
                  _loc3_.IsSelling = false;
                  _loc4_.Add(_loc3_);
               }
               break;
            case CONST_TALISMAN.TALISMAN_TransitionPaper:
               _loc3_ = this.TransitionPaper;
               if(_loc3_ != null)
               {
                  _loc3_.IsSelling = false;
                  _loc4_.Add(_loc3_);
               }
         }
         this.FCurInventories = _loc4_;
         this.FCurInventories.SortByFunction(this.SortBySortIndex);
      }
      
      private function SortBySortIndex(param1:TInventory, param2:TInventory) : int
      {
         if(param1.Identifier == CONST_TALISMAN.TALISMAN_UpgradePaper || param1.Identifier == CONST_TALISMAN.TALISMAN_TransitionPaper)
         {
            return 1;
         }
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
      
      private function UpdatePageInfo() : void
      {
         this.FUIPage.PageIndex = 0;
         this.FUIPage.TotalQuantity = this.FCurInventories.Count;
      }
      
      private function UpdateSlotsInfo() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TInventory = null;
         _loc2_ = this.FUIPage.PageIndex * ItemMax;
         _loc3_ = this.FCurInventories.Count;
         _loc1_ = 0;
         while(_loc1_ < ItemMax)
         {
            if(_loc2_ + _loc1_ < _loc3_)
            {
               _loc4_ = this.FCurInventories.GetInventoryByIndex(_loc2_ + _loc1_);
               this.FUISlotVec[_loc1_].Context = _loc4_;
               this.FUISlotVec[_loc1_].IsSelected = _loc4_.IsSelling;
               this.FUISlotVec[_loc1_].Visible = true;
            }
            else
            {
               this.FUISlotVec[_loc1_].Visible = false;
            }
            _loc1_++;
         }
      }
      
      private function CheckLevel(param1:TInventory) : Boolean
      {
         var _loc2_:TEquipment = null;
         var _loc3_:uint = 0;
         var _loc4_:TTreasureUpgrade = null;
         _loc2_ = param1 as TEquipment;
         if(_loc2_ != null)
         {
            _loc3_ = this.GetUpgradingValue(_loc2_.IDTemplate,_loc2_.UpgradingLevel);
            _loc4_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_TreasureUpgrade,_loc3_) as TTreasureUpgrade;
            if(_loc4_.ProductCount <= 0)
            {
               return false;
            }
         }
         if(this.FLevelIndex == 0)
         {
            return true;
         }
         if(param1.RequirementLevel == this.FLevelIndex)
         {
            return true;
         }
         return false;
      }
      
      private function UpdateCanGetInfo() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TInventory = null;
         var _loc5_:TEquipment = null;
         var _loc6_:uint = 0;
         var _loc7_:TTreasureUpgrade = null;
         var _loc8_:TInventories = null;
         _loc8_ = new TInventories();
         SToolReward.GetInventoryByID(this.ProductId,_loc8_);
         _loc4_ = _loc8_.GetInventoryByIndex(0);
         this.FUISlotCanGet.Context = _loc4_;
         this.FTFName.text = _loc4_.Name;
         this.FMallNum = 0;
         _loc3_ = 0;
         _loc2_ = this.FCurInventories.Count;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc4_ = this.FCurInventories.GetInventoryByIndex(_loc1_);
            if(_loc4_.IsSelling)
            {
               ++this.FMallNum;
               _loc5_ = _loc4_ as TEquipment;
               if(_loc5_ != null)
               {
                  _loc6_ = this.GetUpgradingValue(_loc5_.IDTemplate,_loc5_.UpgradingLevel);
                  _loc7_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_TreasureUpgrade,_loc6_) as TTreasureUpgrade;
                  _loc3_ += _loc7_.ProductCount;
               }
               else if(_loc4_.IDTemplate == CONST_TALISMAN.TALISMAN_UpgradePaper || _loc4_.IDTemplate == CONST_TALISMAN.TALISMAN_TransitionPaper)
               {
                  _loc3_ += _loc4_.Quantity * this.ProductNum;
               }
            }
            _loc1_++;
         }
         this.FTFNum.text = _loc3_ + "";
         this.FBtnMall.Enabled = this.FMallNum > 0;
      }
      
      private function GetUpgradingValue(param1:uint, param2:int) : uint
      {
         return Math.floor(param1 % 1000) * 1000 + param2;
      }
      
      private function OnLevelSelect(param1:Object, param2:uint) : void
      {
         if(!Visible)
         {
            return;
         }
         this.FLevelIndex = IndexLevelVec[param2];
         this.UpdateBackpack();
         this.UpdatePageInfo();
         this.UpdateSlotsInfo();
      }
      
      private function PageOnChange(param1:Object, param2:int) : void
      {
         this.UpdateSlotsInfo();
      }
      
      private function SelectAllOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _loc4_ = int(this.FUISlotVec.length);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            if(this.FUISlotVec[_loc3_].Visible)
            {
               this.FUISlotVec[_loc3_].IsSelected = true;
               (this.FUISlotVec[_loc3_].Context as TInventory).IsSelling = true;
            }
            _loc3_++;
         }
         this.UpdateCanGetInfo();
      }
      
      private function MallOnClick(param1:Object, param2:MouseEvent) : void
      {
         this.FUIWindowConfirmationMall.Text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TALISMAN_STRING_38);
         this.FUIWindowConfirmationMall.Visible = true;
      }
      
      private function MallOnOK(param1:Object) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TPacket = null;
         var _loc5_:ByteArray = null;
         var _loc6_:TInventory = null;
         _loc4_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_TalismanProductRequest);
         _loc5_ = _loc4_.Data;
         _loc5_.writeShort(this.FMallNum);
         _loc3_ = this.FCurInventories.Count;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc6_ = this.FCurInventories.GetInventoryByIndex(_loc2_);
            if(_loc6_.IsSelling)
            {
               _loc5_.writeUnsignedInt(_loc6_.Identifier);
               _loc5_.writeUnsignedInt(_loc6_.IDTemplate);
            }
            _loc2_++;
         }
         SNetworkCore.Transceiver.PacketTransmit(_loc4_);
      }
      
      private function SlotOnClick(param1:TUISlot, param2:Object) : void
      {
         var _loc3_:TInventory = null;
         _loc3_ = param2 as TInventory;
         _loc3_.IsSelling = !_loc3_.IsSelling;
         param1.IsSelected = _loc3_.IsSelling;
         this.UpdateCanGetInfo();
      }
      
      private function get UpgradePaper() : TInventory
      {
         return SLogicsCore.Character.Appliances.GetInventoryByTempletID(CONST_TALISMAN.TALISMAN_UpgradePaper);
      }
      
      private function get TransitionPaper() : TInventory
      {
         return SLogicsCore.Character.Appliances.GetInventoryByTempletID(CONST_TALISMAN.TALISMAN_TransitionPaper);
      }
      
      private function get ProductNum() : int
      {
         var _loc1_:TConfigValue = null;
         if(this.FProductNum == 0)
         {
            _loc1_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.Treasure_Product) as TConfigValue;
            this.FProductNum = int(_loc1_.Value);
         }
         return this.FProductNum;
      }
      
      private function get ProductId() : int
      {
         var _loc1_:TConfigValue = null;
         if(this.FProductId == 0)
         {
            _loc1_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.Treasure_ProductId) as TConfigValue;
            this.FProductId = int(_loc1_.Value);
         }
         return this.FProductId;
      }
      
      public function Show() : void
      {
         Visible = true;
         this.Update();
      }
      
      public function Hide() : void
      {
         this.Reset();
         Visible = false;
      }
      
      public function Update() : void
      {
         this.UpdateUI();
      }
      
      public function Reset() : void
      {
      }
   }
}

