package Processors.Game.Lobby.Smithy
{
   import Components.Slots.*;
   import Foundation.Queries.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Bins.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.Inventories.*;
   import Logics.Streamization.Inventories.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Jade.*;
   import Processors.Game.Lobby.Utilities.*;
   import Processors.Game.Utilities.HyperLink.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class TProcessorWindowAdvanced extends TProcessorLobbyWindow
   {
      
      protected var FScence:MovieClip;
      
      protected var FOldSlot:TUISlot;
      
      protected var FNewSlot:TUISlot;
      
      protected var FMateriaSlot:TUISlot;
      
      protected var FOldLevel:TextField;
      
      protected var FNewLevel:TextField;
      
      protected var FNeedNum:TextField;
      
      protected var FHaveNum:TextField;
      
      protected var FTreasureMap:TextField;
      
      protected var FDuplicate:TextField;
      
      protected var FMC_Advanced:MovieClip;
      
      protected var FInitialization:Boolean;
      
      protected var FHeroID:uint;
      
      protected var FEquipmentUpgradeBin:TBins;
      
      protected var FArticleBin:TBins;
      
      protected var FUnstreamizerInventoryReference:TUnstreamizerInventoryReference;
      
      protected var FOldEquiment:TEquipment;
      
      protected var FNewEquiment:TEquipment;
      
      protected var FMaterial:TInventory;
      
      protected var FLevelLimit:int;
      
      protected var FTF_Limit:TextField;
      
      protected var FOnAdvanced:Function;
      
      protected var FOnGoto:Function;
      
      protected var FOnSlotMouseOver:Function;
      
      protected var FOnSlotMouseOut:Function;
      
      protected var FUpdateHeroPower:Function;
      
      public function TProcessorWindowAdvanced(param1:TUIComponent)
      {
         super(param1);
         this.FUnstreamizerInventoryReference = new TUnstreamizerInventoryReference();
      }
      
      private function AdvancedInit() : void
      {
         var _loc1_:TConfigValue = null;
         this.FOldSlot = new TUISlot(this);
         this.FOldSlot.Resource = this.FScence["Old_Slot"];
         this.FOldSlot.TextureAdvancedEffect = SResourcesCore.TexturesLobby.GetTextureByIdentifier(CONST_LOBBY.RESOURCESID_Texture_SlotAdvancedEffect);
         TJadeCommon.InitSlot(this.FOldSlot);
         this.FOldSlot.OnClick = this.OnSlotClick;
         this.FOldSlot.OnOver = this.UIComponentsHintOnOver;
         this.FOldSlot.OnOut = this.UIComponentsHintOnOut;
         this.FOldSlot.OnQueryEdgeColor = this.SlotsOnQueryEdgeColor;
         this.FOldSlot.Init();
         this.FNewSlot = new TUISlot(this);
         this.FNewSlot.Resource = this.FScence["New_Slot"];
         this.FNewSlot.TextureAdvancedEffect = SResourcesCore.TexturesLobby.GetTextureByIdentifier(CONST_LOBBY.RESOURCESID_Texture_SlotAdvancedEffect);
         TJadeCommon.InitSlot(this.FNewSlot);
         this.FNewSlot.OnOver = this.UIComponentsHintOnOver;
         this.FNewSlot.OnOut = this.UIComponentsHintOnOut;
         this.FNewSlot.OnQueryEdgeColor = this.SlotsOnQueryEdgeColor;
         this.FNewSlot.Init();
         this.FMateriaSlot = new TUISlot(this);
         this.FMateriaSlot.Resource = this.FScence["Material_Slot"];
         TJadeCommon.InitSlot(this.FMateriaSlot);
         this.FMateriaSlot.OnOver = this.UIComponentsHintOnOver;
         this.FMateriaSlot.OnOut = this.UIComponentsHintOnOut;
         this.FMateriaSlot.Init();
         this.FOldLevel = this.FScence["tf_oldLevel"];
         this.FNewLevel = this.FScence["tf_newLevel"];
         this.FNeedNum = this.FScence["tf_needNum"];
         this.FHaveNum = this.FScence["tf_haveNum"];
         this.FTreasureMap = this.FScence["tf_TreasureMap"];
         this.FTreasureMap.htmlText = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.SMITHY_STRING_28);
         this.FTreasureMap.addEventListener(TextEvent.LINK,this.GotoTreasureMap);
         this.FMC_Advanced = this.FScence["bt_Advanced"];
         TGameUtil.setButtonMode(this.FMC_Advanced,true);
         this.FMC_Advanced.addEventListener(MouseEvent.CLICK,this.AdvancedOnClick);
         this.FEquipmentUpgradeBin = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_EquipUpgrade);
         this.FArticleBin = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_Article);
         this.FTF_Limit = this.FScence["TF_Limit"];
         this.FTF_Limit.selectable = false;
         this.FTF_Limit.x += this.FScence.x;
         this.FTF_Limit.y += this.FScence.y;
         this.addChild(this.FTF_Limit);
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(!this.Visible)
         {
            return;
         }
         if(this.FInitialization)
         {
            this.FNewSlot.Update();
            this.FMateriaSlot.Update();
            this.FOldSlot.Update();
         }
      }
      
      private function ButtonReset() : void
      {
         if(this.FOldSlot.Context == null)
         {
            TGameUtil.setButtonMode(this.FMC_Advanced,false);
            this.FMC_Advanced.mouseEnabled = false;
         }
         else
         {
            TGameUtil.setButtonMode(this.FMC_Advanced,true);
            this.FMC_Advanced.mouseEnabled = true;
         }
      }
      
      private function TextReset() : void
      {
         this.FOldLevel.text = "";
         this.FNewLevel.text = "";
         this.FNeedNum.text = "";
         this.FHaveNum.text = "";
      }
      
      private function SlotReset() : void
      {
         this.FOldSlot.Context = null;
         this.FNewSlot.Context = null;
         this.FMateriaSlot.Context = null;
      }
      
      private function UpdateEquipment(param1:Object) : void
      {
         var _loc2_:Vector.<uint> = null;
         var _loc3_:TInventories = null;
         var _loc4_:TInventory = null;
         var _loc5_:TEquipUpgrade = null;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         _loc2_ = new Vector.<uint>();
         _loc3_ = new TInventories();
         this.FOldEquiment = param1 as TEquipment;
         this.FOldSlot.Context = this.FOldEquiment;
         this.FOldLevel.text = this.FOldEquiment.UpgradingLevel.toString();
         _loc5_ = this.FEquipmentUpgradeBin.GetDatebaseByIdentifier(this.FOldEquiment.IDTemplate) as TEquipUpgrade;
         _loc2_.push(_loc5_.GotEquipId);
         _loc2_.push(_loc5_.Material);
         this.FUnstreamizerInventoryReference.UnstreamizeGenerateInventoriesByIdentifiers(null,_loc3_,_loc2_);
         this.FNewEquiment = _loc3_.GetInventoryByIndex(0) as TEquipment;
         this.FMaterial = _loc3_.GetInventoryByIndex(1);
         this.FNewSlot.Context = this.FNewEquiment;
         _loc6_ = this.getAdvancedLevel(this.FOldEquiment,this.FNewEquiment);
         this.FNewLevel.text = _loc6_.toString();
         this.FMateriaSlot.Context = this.FMaterial;
         this.FNeedNum.text = _loc5_.Quantity.toString();
         _loc3_ = SLogicsCore.Character.Materials;
         _loc9_ = uint(_loc3_.Count);
         _loc7_ = 0;
         _loc8_ = 0;
         while(_loc8_ < _loc9_)
         {
            _loc4_ = _loc3_.GetInventoryByIndex(_loc8_);
            if(_loc4_.IDTemplate == _loc5_.Material)
            {
               _loc7_ += _loc4_.Quantity;
            }
            _loc8_++;
         }
         this.FHaveNum.text = _loc7_.toString();
         if(_loc5_.Quantity <= _loc7_)
         {
            this.FHaveNum.textColor = CONST_COMMON.QUALITYCOLOR_INDEX[2];
            TGameUtil.setButtonMode(this.FMC_Advanced,true);
            this.FMC_Advanced.mouseEnabled = true;
         }
         else
         {
            this.FHaveNum.textColor = CONST_COMMON.QUALITYCOLOR_INDEX[7];
            TGameUtil.setButtonMode(this.FMC_Advanced,false);
            this.FMC_Advanced.mouseEnabled = false;
         }
      }
      
      private function getAdvancedLevel(param1:TEquipment, param2:TEquipment) : uint
      {
         var _loc3_:int = 0;
         var _loc4_:uint = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         _loc3_ = int(param1.SellingValue);
         _loc6_ = 0;
         while(true)
         {
            _loc4_ = CONST_SMITHY.GetBuildConsumeID(param2.Quality,_loc6_);
            _loc5_ = this.GetConsumeByID(_loc4_);
            if(_loc5_ == -1)
            {
               break;
            }
            if(_loc3_ < _loc5_)
            {
               break;
            }
            _loc3_ -= _loc5_;
            _loc6_++;
         }
         return _loc6_;
      }
      
      protected function GetConsumeByID(param1:uint) : int
      {
         var _loc2_:TBuildConsume = null;
         _loc2_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_BuildConsume,param1) as TBuildConsume;
         return _loc2_.Consume;
      }
      
      private function CheckCanAdvanced(param1:Object) : Boolean
      {
         var _loc2_:TEquipment = null;
         _loc2_ = param1 as TEquipment;
         if(!_loc2_.IsAdvancedEquip)
         {
            EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.SMITHY_STRING_30));
            return false;
         }
         return true;
      }
      
      protected function CheckIfLevelEnough() : Boolean
      {
         var _loc1_:TConfigValue = null;
         var _loc2_:Boolean = false;
         _loc1_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.EQUIP_LZ_LEVEL) as TConfigValue;
         this.FLevelLimit = _loc1_.Value as uint;
         this.FTF_Limit.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.SMITHY_STRING_44),this.FLevelLimit);
         this.FTF_Limit.textColor = CONST_COMMON.TEXT_Red_Color;
         _loc2_ = this.FLevelLimit <= SLogicsCore.Character.GetMainLevel();
         if(_loc2_)
         {
            this.FScence.mouseChildren = true;
            this.FScence.mouseEnabled = true;
            this.FScence.filters = null;
            this.FTF_Limit.visible = false;
         }
         else
         {
            this.FScence.mouseChildren = false;
            this.FScence.mouseEnabled = false;
            this.FScence.filters = [TUtilityFilter.GaryColorFilters];
            this.FTF_Limit.visible = true;
         }
         return _loc2_;
      }
      
      protected function UIComponentsHintOnOver(param1:Object, param2:TInventory) : void
      {
         if(this.FOnSlotMouseOver != null)
         {
            this.FOnSlotMouseOver(param1,param2);
         }
      }
      
      protected function UIComponentsHintOnOut(param1:Object, param2:TInventory) : void
      {
         if(this.FOnSlotMouseOut != null)
         {
            this.FOnSlotMouseOut(param1,param2);
         }
      }
      
      protected function SlotsOnQueryEdgeColor(param1:Object, param2:Object, param3:TQueryUInt) : void
      {
         var _loc4_:TEquipment = null;
         if(param2 is TEquipment)
         {
            _loc4_ = param2 as TEquipment;
            param3.Value = _loc4_.IsEdgeColor;
         }
      }
      
      private function GotoDuplicate(param1:TextEvent) : void
      {
         if(this.FOnGoto != null)
         {
            this.FOnGoto(this,TUtilityHyperLink.HyperLink_WorldMap);
         }
      }
      
      private function GotoTreasureMap(param1:TextEvent) : void
      {
         if(this.FOnGoto != null)
         {
            this.FOnGoto(this,TUtilityHyperLink.HyperLink_TreasureMap);
         }
      }
      
      private function AdvancedOnClick(param1:MouseEvent) : void
      {
         if(this.FOnAdvanced != null)
         {
            this.FOnAdvanced(this,this.FHeroID,this.FOldEquiment);
         }
      }
      
      protected function OnSlotClick(param1:Object = null, param2:Object = null) : void
      {
         this.Reset();
      }
      
      public function get OnGoto() : Function
      {
         return this.FOnGoto;
      }
      
      public function set OnGoto(param1:Function) : void
      {
         this.FOnGoto = param1;
      }
      
      public function get OnAdvanced() : Function
      {
         return this.FOnAdvanced;
      }
      
      public function set OnAdvanced(param1:Function) : void
      {
         this.FOnAdvanced = param1;
      }
      
      public function set OnSlotMouseOver(param1:Function) : void
      {
         this.FOnSlotMouseOver = param1;
      }
      
      public function set OnSlotMouseOut(param1:Function) : void
      {
         this.FOnSlotMouseOut = param1;
      }
      
      public function set UpdateHeroPower(param1:Function) : void
      {
         this.FUpdateHeroPower = param1;
      }
      
      public function Perform_UIDispatch(param1:MovieClip) : void
      {
         this.FScence = param1;
         addChild(this.FScence);
         this.AdvancedInit();
         this.Reset();
         this.FInitialization = true;
      }
      
      public function UpdateUI(param1:Object, param2:uint) : void
      {
         var _loc3_:Boolean = false;
         _loc3_ = this.CheckIfLevelEnough();
         if(!_loc3_)
         {
            return;
         }
         _loc3_ = this.CheckCanAdvanced(param1);
         if(!_loc3_)
         {
            return;
         }
         this.FHeroID = param2;
         this.ButtonReset();
         this.UpdateEquipment(param1);
      }
      
      public function Update() : void
      {
         var _loc1_:Boolean = false;
         this.Reset();
         _loc1_ = this.CheckIfLevelEnough();
         if(!_loc1_)
         {
            return;
         }
         if(this.FUpdateHeroPower != null && this.FHeroID != 0)
         {
            this.FUpdateHeroPower(this,this.FHeroID);
         }
      }
      
      public function Reset() : void
      {
         this.TextReset();
         this.SlotReset();
         this.ButtonReset();
      }
   }
}

