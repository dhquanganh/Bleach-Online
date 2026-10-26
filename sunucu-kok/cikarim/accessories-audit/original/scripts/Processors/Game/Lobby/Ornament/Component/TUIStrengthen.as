package Processors.Game.Lobby.Ornament.Component
{
   import Components.Slots.*;
   import Components.Standard.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Bins.*;
   import Foundation.UI.*;
   import Logics.*;
   import Logics.Characters.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.Inventories.*;
   import Logics.Streamization.Inventories.*;
   import Processors.Game.Lobby.Utilities.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class TUIStrengthen extends TUIComponent
   {
      
      protected static const TYPE_UIWINDOW_STRENGTHEN:uint = CONST_ORNAMENT.TYPE_UIWINDOW_STRENGTHEN;
      
      protected static const TYPE_UIWINDOW_ADVANCED:uint = CONST_ORNAMENT.TYPE_UIWINDOW_ADVANCED;
      
      protected static const BASEATTRIBUTENAMES:Vector.<uint> = CONST_COMMON.BASEATTRIBUTENAMES;
      
      protected static const QUALITYCOLOR_INDEX:Vector.<uint> = CONST_COMMON.QUALITYCOLOR_INDEX;
      
      protected var FOrnamentValues:TBins;
      
      protected var FMC_Scene:Sprite;
      
      protected var FMC_Slot:TUISlot;
      
      protected var FTF_Level:TextField;
      
      protected var FTF_OldValue:TextField;
      
      protected var FTF_NewValue:TextField;
      
      protected var FTF_NeedCount:TextField;
      
      protected var FTF_OwnedCount:TextField;
      
      protected var FTF_Provenance:TextField;
      
      protected var FBtn_OK:TUIButton;
      
      protected var FCharacter:TCharacter;
      
      protected var FReciveEquipment:TEquipment;
      
      protected var FHeroID:uint;
      
      protected var FIDTemplates:Vector.<uint>;
      
      protected var FCostInventories:TInventories;
      
      protected var FOwnedInventoryVect:Vector.<TInventory>;
      
      protected var FUnstreamizerInventoryReference:TUnstreamizerInventoryReference;
      
      protected var FCurValue:TOrnamentValue;
      
      protected var FNextValue:TOrnamentValue;
      
      protected var FIsEnoughItem:Boolean;
      
      protected var FOnBtnOKClick:Function;
      
      protected var FOnSlotOver:Function;
      
      protected var FOnSlotOut:Function;
      
      protected var FOnQuerySequenceContext:Function;
      
      protected var FOnQuerySubscript:Function;
      
      protected var FOnEffectText:Function;
      
      public function TUIStrengthen(param1:TUIComponent)
      {
         super(param1);
         this.FCharacter = SLogicsCore.Character;
         this.FCostInventories = new TInventories();
         this.FUnstreamizerInventoryReference = new TUnstreamizerInventoryReference();
         this.FIsEnoughItem = false;
      }
      
      protected function InitWindow(param1:Sprite) : void
      {
         this.FMC_Scene = param1;
         this.FTF_Level = this.FMC_Scene[CONST_ORNAMENT.RESOURCE_Link_TF_Level];
         this.FTF_Level.mouseEnabled = false;
         this.FTF_OldValue = this.FMC_Scene[CONST_ORNAMENT.RESOURCE_Link_TF_OldValue];
         this.FTF_OldValue.mouseEnabled = false;
         this.FTF_NewValue = this.FMC_Scene[CONST_ORNAMENT.RESOURCE_Link_TF_NewValue];
         this.FTF_NewValue.mouseEnabled = false;
         this.FTF_NeedCount = this.FMC_Scene[CONST_ORNAMENT.RESOURCE_Link_TF_NeedCount];
         this.FTF_NeedCount.mouseEnabled = false;
         this.FTF_OwnedCount = this.FMC_Scene[CONST_ORNAMENT.RESOURCE_Link_TF_OwnedCount];
         this.FTF_OwnedCount.mouseEnabled = false;
         this.FTF_Provenance = this.FMC_Scene[CONST_ORNAMENT.RESOURCE_Link_TF_Provenance];
         this.FTF_Provenance.mouseEnabled = false;
         this.FBtn_OK = new TUIButton();
         this.FBtn_OK.Substrate = this.FMC_Scene[CONST_ORNAMENT.RESOURCE_Link_Btn_OK];
         this.FBtn_OK.OnClick = this.BtnOKOnClick;
         this.FMC_Slot = new TUISlot(this);
         this.FMC_Slot.OnQuerySequenceContext = this.FOnQuerySequenceContext;
         this.FMC_Slot.OnOver = this.FOnSlotOver;
         this.FMC_Slot.OnOut = this.FOnSlotOut;
         this.FMC_Slot.OnQuerySubscript = this.FOnQuerySubscript;
         this.FMC_Slot.Resource = this.FMC_Scene[CONST_ORNAMENT.RESOURCE_Link_MC_Slot];
         this.FMC_Slot.SequenceDefaultIcon = SResourcesCore.TexturesLobby.GetAnimationSequenceByIdentifiers(CONST_LOBBY.RESOURCESID_Texture_SlotDefaultEffect,0);
         this.FMC_Slot.Init();
         this.DoClear();
      }
      
      protected function UpdateUI() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         this.FTF_OwnedCount.text = "";
         this.FTF_NeedCount.text = "";
         this.FMC_Slot.Context = this.FReciveEquipment;
         this.FTF_Level.text = "Lv." + this.FReciveEquipment.UpgradingLevel.toString();
         _loc1_ = BASEATTRIBUTENAMES.indexOf(this.FReciveEquipment.BasisPropertyCategory[0]);
         this.FTF_OldValue.text = TUtilityLobby.GetBaseAttributeNameByIndex(_loc1_) + ":" + ((this.FReciveEquipment.UpgradingBasisProperty.length > 0 ? this.FReciveEquipment.UpgradingBasisProperty[0] : 0) + this.FReciveEquipment.BasisProperty[0]);
         this.FTF_NewValue.text = TUtilityLobby.GetBaseAttributeNameByIndex(_loc1_) + ":" + (this.FReciveEquipment.BasisProperty[0] + this.FNextValue.AddValue);
         this.GetInventories();
         _loc2_ = this.FCostInventories.Count;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FTF_NeedCount.appendText(this.FCostInventories.GetInventoryByIndex(_loc1_).Name + "*" + this.FCostInventories.GetInventoryByIndex(_loc1_).Quantity);
            if(this.FOwnedInventoryVect[_loc1_] == null)
            {
               this.FTF_OwnedCount.appendText(this.FCostInventories.GetInventoryByIndex(_loc1_).Name + "*0");
               this.FIsEnoughItem = false;
            }
            else
            {
               this.FTF_OwnedCount.appendText(this.FOwnedInventoryVect[_loc1_].Name + "*" + this.FCharacter.Materials.GetCountByTempleteID(this.FOwnedInventoryVect[_loc1_].IDTemplate));
               if(this.FCharacter.Materials.GetCountByTempleteID(this.FOwnedInventoryVect[_loc1_].IDTemplate) >= this.FCostInventories.GetInventoryByIndex(_loc1_).Quantity)
               {
                  this.FIsEnoughItem = true;
               }
               else
               {
                  this.FIsEnoughItem = false;
               }
            }
            _loc1_++;
         }
         this.UpdateUIBtn();
      }
      
      protected function UpdateUIBtn() : void
      {
         if(this.FReciveEquipment.UpgradingLevel >= CONST_ORNAMENT.MAX_LEVEL_STRENGTHEN || !this.FIsEnoughItem)
         {
            this.FBtn_OK.Enabled = false;
         }
         else
         {
            this.FBtn_OK.Enabled = true;
         }
      }
      
      protected function GetInventories() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Vector.<uint> = null;
         var _loc4_:Vector.<TInventory> = null;
         this.FCostInventories.Clear();
         _loc2_ = int(this.FNextValue.CostItems.length);
         _loc3_ = new Vector.<uint>(_loc2_);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_[_loc1_] = CONST_COMMON.RewardIDToTemplateID(this.FNextValue.CostItems[_loc1_].Type,this.FNextValue.CostItems[_loc1_].Code);
            _loc1_++;
         }
         this.FUnstreamizerInventoryReference.UnstreamizeGenerateInventoriesByIdentifiers(null,this.FCostInventories,_loc3_);
         _loc2_ = this.FCostInventories.Count;
         _loc4_ = new Vector.<TInventory>(_loc2_);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FCostInventories.GetInventoryByIndex(_loc1_).Quantity = this.FNextValue.CostItems[_loc1_].Amount;
            _loc4_[_loc1_] = this.FCharacter.Materials.GetInventoryByTempletID(this.FCostInventories.GetInventoryByIndex(_loc1_).IDTemplate);
            _loc1_++;
         }
         this.FOwnedInventoryVect = _loc4_;
      }
      
      protected function GetValueByIDAndLevel(param1:uint, param2:uint) : TOrnamentValue
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:TOrnamentValue = null;
         if(this.FOrnamentValues == null)
         {
            this.FOrnamentValues = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_OrnamentValue);
         }
         _loc4_ = this.FOrnamentValues.Count;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc5_ = this.FOrnamentValues.GetDatebaseByIndex(_loc3_) as TOrnamentValue;
            if(_loc5_.ItemID == param1 && _loc5_.Level == param2)
            {
               return _loc5_;
            }
            _loc3_++;
         }
         return null;
      }
      
      protected function DoClear() : void
      {
         if(this.FMC_Slot != null)
         {
            this.FMC_Slot.Context = null;
         }
         this.FTF_Level.text = "";
         this.FTF_OldValue.text = "";
         this.FTF_NewValue.text = "";
         this.FTF_NeedCount.text = "";
         this.FTF_OwnedCount.text = "";
         this.FTF_Provenance.text = "";
         this.FBtn_OK.Enabled = false;
      }
      
      protected function BtnOKOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FOnBtnOKClick != null)
         {
            this.FOnBtnOKClick(TYPE_UIWINDOW_STRENGTHEN,this.FReciveEquipment,this.FHeroID);
         }
      }
      
      public function get OnBtnOKClick() : Function
      {
         return this.FOnBtnOKClick;
      }
      
      public function set OnBtnOKClick(param1:Function) : void
      {
         this.FOnBtnOKClick = param1;
      }
      
      public function get OnSlotOver() : Function
      {
         return this.FOnSlotOver;
      }
      
      public function set OnSlotOver(param1:Function) : void
      {
         this.FOnSlotOver = param1;
      }
      
      public function get OnSlotOut() : Function
      {
         return this.FOnSlotOut;
      }
      
      public function set OnSlotOut(param1:Function) : void
      {
         this.FOnSlotOut = param1;
      }
      
      public function get OnQuerySequenceContext() : Function
      {
         return this.FOnQuerySequenceContext;
      }
      
      public function set OnQuerySequenceContext(param1:Function) : void
      {
         this.FOnQuerySequenceContext = param1;
      }
      
      public function get OnQuerySubscript() : Function
      {
         return this.FOnQuerySubscript;
      }
      
      public function set OnQuerySubscript(param1:Function) : void
      {
         this.FOnQuerySubscript = param1;
      }
      
      public function get OnEffectText() : Function
      {
         return this.FOnEffectText;
      }
      
      public function set OnEffectText(param1:Function) : void
      {
         this.FOnEffectText = param1;
      }
      
      public function ResourcesPerform_UIDispatch(param1:Sprite, param2:uint) : void
      {
         this.InitWindow(param1);
      }
      
      public function ProcessorUpdateUI(param1:TEquipment, param2:uint) : void
      {
         if(param1.UpgradingLevel == CONST_ORNAMENT.MAX_LEVEL_STRENGTHEN)
         {
            if(this.FOnEffectText != null)
            {
               this.FOnEffectText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.SMITHY_STRING_49));
            }
            this.DoClear();
            return;
         }
         this.FReciveEquipment = param1;
         this.FHeroID = param2;
         this.FCurValue = this.GetValueByIDAndLevel(this.FReciveEquipment.IDTemplate,this.FReciveEquipment.UpgradingLevel);
         this.FNextValue = this.GetValueByIDAndLevel(this.FReciveEquipment.IDTemplate,this.FReciveEquipment.UpgradingLevel + 1);
         this.UpdateUI();
      }
      
      public function UpdateSlot() : void
      {
         if(this.FMC_Slot.Context != null)
         {
            this.FMC_Slot.Update();
         }
      }
      
      public function Clear() : void
      {
         this.DoClear();
      }
      
      public function Show() : void
      {
         this.FMC_Scene.visible = true;
      }
      
      public function Hide() : void
      {
         this.FMC_Scene.visible = false;
      }
   }
}

