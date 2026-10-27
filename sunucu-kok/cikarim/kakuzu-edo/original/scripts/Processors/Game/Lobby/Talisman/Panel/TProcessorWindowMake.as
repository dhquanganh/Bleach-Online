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
   import Logics.DatebaseVO.VO.TBaseEquip;
   import Logics.DatebaseVO.VO.TConfigValue;
   import Logics.DatebaseVO.VO.TEquipGenerate;
   import Logics.Inventories.TEquipment;
   import Logics.Inventories.TInventories;
   import Logics.Inventories.TInventory;
   import Logics.SLogicsCore;
   import Processors.Game.ComponentNew.TUtilityMovieClip;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Processors.Game.Windows.Information.TUIWindowConfirmation;
   import Resources.Constants.CONST_COMMON;
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
   
   public class TProcessorWindowMake extends TProcessorLobbyWindow
   {
      
      private static const ItemMax:int = 4;
      
      private static const AttrMax:int = 2;
      
      private var StringTreasureSuitNameVec:Vector.<String>;
      
      private var FScene:MovieClip;
      
      private var FLevelComboBox:TComboBox;
      
      private var FLevelList:Vector.<DisplayObject>;
      
      private var FLevelIndex:uint;
      
      private var FCurInventories:TInventories;
      
      private var FUISlotVec:Vector.<TUISlot>;
      
      private var FTFNameVec:Vector.<TextField>;
      
      private var FUISlot:TUISlot;
      
      private var FTFName:TextField;
      
      private var FEF:MovieClip;
      
      private var FTFAttrPlusVec:Vector.<TextField>;
      
      private var FTFCostName:TextField;
      
      private var FTFCostValue:TextField;
      
      private var FTFOwnName:TextField;
      
      private var FTFOwnValue:TextField;
      
      private var FBtnMake:TUIButton;
      
      private var FUIWindowConfirmationMall:TUIWindowConfirmation;
      
      private var FTreasureIdVec:Vector.<Vector.<int>>;
      
      private var FChooseTreasure:TInventory;
      
      public function TProcessorWindowMake(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Vector.<String> = null;
         var _loc4_:DisplayObject = null;
         var _loc5_:TUISlot = null;
         var _loc6_:TextField = null;
         this.StringTreasureSuitNameVec = TUtilityLobby.GetStringsByIdentifier(CONST_SYSTEMLANGUAGE.TALISMAN_STRING_37);
         this.FScene = TUtilityReflection.CreateDisplayObjectInstance("MC_Make") as MovieClip;
         this.x = CONST_TALISMAN.POSX_NEW_SCENE;
         this.y = CONST_TALISMAN.POSY_NEW_SCENE;
         addChild(this.FScene);
         this.FLevelList = new Vector.<DisplayObject>();
         _loc3_ = this.StringTreasureSuitNameVec;
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
         this.FTFNameVec = new Vector.<TextField>(_loc2_);
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
            _loc6_ = this.FScene["TF_Name_" + _loc1_];
            _loc6_.mouseEnabled = false;
            this.FTFNameVec[_loc1_] = _loc6_;
            _loc1_++;
         }
         this.FUISlot = new TUISlot(FParent);
         this.FUISlot.Resource = this.FScene["MC_Slot"];
         this.FUISlot.SequenceDefaultIcon = SResourcesCore.TexturesLobby.GetAnimationSequenceByIdentifiers(CONST_LOBBY.RESOURCESID_Texture_SlotDefaultEffect,0);
         this.FUISlot.OnQuerySequenceContext = this.OnQuerySequenceContext;
         this.FUISlot.OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FUISlot.OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FUISlot.Init();
         this.FTFName = this.FScene["TF_Name"];
         this.FTFName.mouseEnabled = false;
         this.FEF = this.FScene["EF"];
         this.FEF.mouseChildren = false;
         this.FEF.mouseEnabled = false;
         this.FEF.visible = false;
         this.FEF.addFrameScript(this.FEF.totalFrames - 1,this.EFStop);
         TUtilityMovieClip.StopMovieClipAction(this.FEF);
         this.FTFAttrPlusVec = new Vector.<TextField>(AttrMax);
         _loc2_ = AttrMax;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc6_ = this.FScene["TF_AttrPlus_" + _loc1_];
            _loc6_.mouseEnabled = false;
            this.FTFAttrPlusVec[_loc1_] = _loc6_;
            _loc1_++;
         }
         this.FTFCostName = this.FScene["TF_CostName_0"];
         this.FTFCostName.mouseEnabled = false;
         this.FTFCostValue = this.FScene["TF_CostNum_0"];
         this.FTFCostValue.mouseEnabled = false;
         this.FTFOwnName = this.FScene["TF_CostName_1"];
         this.FTFOwnName.mouseEnabled = false;
         this.FTFOwnValue = this.FScene["TF_CostNum_1"];
         this.FTFOwnValue.mouseEnabled = false;
         this.FBtnMake = new TUIButton();
         this.FBtnMake.Substrate = this.FScene["Btn_Product"];
         this.FBtnMake.OnClick = this.MakeOnClick;
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
         this.FUISlot.Update();
      }
      
      private function UpdateUI() : void
      {
         this.UpdateBackpack();
         this.UpdateSlotsInfo();
         this.UpdateCanGetInfo();
      }
      
      private function UpdateBackpack() : void
      {
         var _loc1_:int = 0;
         var _loc2_:uint = 0;
         var _loc3_:TInventory = null;
         var _loc4_:TInventories = null;
         _loc4_ = new TInventories();
         SToolReward.GetInventoriesByIDVec(this.TreasureIdVec[this.FLevelIndex],_loc4_);
         this.FCurInventories = _loc4_;
      }
      
      private function UpdateSlotsInfo() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TInventory = null;
         _loc2_ = this.FCurInventories.Count;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FCurInventories.GetInventoryByIndex(_loc1_);
            this.FUISlotVec[_loc1_].Context = _loc3_;
            this.FUISlotVec[_loc1_].Visible = true;
            this.FTFNameVec[_loc1_].text = _loc3_.Name;
            _loc1_++;
         }
      }
      
      private function UpdateCanGetInfo() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TBaseEquip = null;
         var _loc4_:TEquipGenerate = null;
         var _loc5_:String = null;
         var _loc6_:TInventories = null;
         var _loc7_:TInventory = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         if(this.FChooseTreasure == null)
         {
            this.SlotOnClick(this.FUISlotVec[0],this.FUISlotVec[0].Context);
         }
         _loc3_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_BaseEquip,this.FChooseTreasure.IDTemplate) as TBaseEquip;
         _loc4_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_EquipGenerate,this.FChooseTreasure.IDTemplate) as TEquipGenerate;
         _loc6_ = new TInventories();
         SToolReward.GetInventoryByID(_loc4_.Materials[0],_loc6_);
         _loc7_ = _loc6_.GetInventoryByIndex(0);
         _loc5_ = _loc7_.Name;
         _loc8_ = int(SLogicsCore.Character.Appliances.GetInventoryAllNumByTempletID(_loc7_.IDTemplate));
         _loc9_ = _loc4_.Quantitys[0];
         this.FUISlot.Context = this.FChooseTreasure;
         this.FUISlot.Visible = true;
         this.FTFName.text = this.FChooseTreasure.Name;
         _loc2_ = AttrMax;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FTFAttrPlusVec[_loc1_].text = TUtilityLobby.GetBaseAttributeNameByType(_loc3_.MainType[_loc1_]) + "+" + _loc3_.MainValue[_loc1_];
            _loc1_++;
         }
         this.FTFCostName.text = this.FTFOwnName.text = _loc5_;
         this.FTFCostValue.text = _loc9_ + "";
         this.FTFOwnValue.text = _loc8_ + "";
         this.FTFOwnValue.textColor = _loc8_ >= _loc9_ ? CONST_COMMON.QUALITYCOLOR_Green : CONST_COMMON.QUALITYCOLOR_Red;
         this.FBtnMake.Enabled = _loc8_ >= _loc9_;
      }
      
      private function OnLevelSelect(param1:Object, param2:uint) : void
      {
         if(!Visible)
         {
            return;
         }
         this.FLevelIndex = param2;
         this.UpdateBackpack();
         this.UpdateSlotsInfo();
         this.UpdateCanGetInfo();
      }
      
      private function SlotOnClick(param1:TUISlot, param2:Object) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _loc4_ = int(this.FUISlotVec.length);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            this.FUISlotVec[_loc3_].IsSelected = false;
            _loc3_++;
         }
         this.FChooseTreasure = param2 as TInventory;
         param1.IsSelected = true;
         this.UpdateCanGetInfo();
      }
      
      private function EFStop() : void
      {
         TUtilityMovieClip.StopMovieClipAction(this.FEF);
         this.FEF.visible = false;
      }
      
      private function MakeOnClick(param1:Object, param2:MouseEvent) : void
      {
         this.FUIWindowConfirmationMall.Text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TALISMAN_STRING_36);
         this.FUIWindowConfirmationMall.Visible = true;
      }
      
      private function MallOnOK(param1:Object) : void
      {
         var _loc2_:TPacket = null;
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Equip_Make);
         _loc2_.Data.writeUnsignedInt(this.FChooseTreasure.IDTemplate);
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
      }
      
      private function get TreasureIdVec() : Vector.<Vector.<int>>
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Object = null;
         var _loc4_:Vector.<Object> = null;
         var _loc5_:Vector.<int> = null;
         var _loc6_:TConfigValue = null;
         if(this.FTreasureIdVec == null)
         {
            _loc6_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.Treasure_Id) as TConfigValue;
            _loc4_ = _loc6_.Value as Vector.<Object>;
            _loc2_ = int(_loc4_.length);
            this.FTreasureIdVec = new Vector.<Vector.<int>>();
            _loc1_ = 0;
            while(_loc1_ < _loc2_)
            {
               _loc3_ = _loc4_[_loc1_];
               _loc5_ = Vector.<int>(_loc3_);
               this.FTreasureIdVec.push(_loc5_);
               _loc1_++;
            }
         }
         return this.FTreasureIdVec;
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

