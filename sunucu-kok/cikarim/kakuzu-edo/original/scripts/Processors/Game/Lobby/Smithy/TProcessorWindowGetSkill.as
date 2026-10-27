package Processors.Game.Lobby.Smithy
{
   import Components.Pages.*;
   import Components.Slots.*;
   import Foundation.Common.*;
   import Foundation.Queries.TQueryUInt;
   import Foundation.Resources.*;
   import Foundation.Resources.Bins.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.Characters.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.Inventories.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Jade.*;
   import Processors.Game.Lobby.Utilities.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class TProcessorWindowGetSkill extends TProcessorLobbyWindow
   {
      
      protected var FScence:MovieClip;
      
      protected var FEquipmentSlot:TUISlot;
      
      protected var FEnchantingSlot:TUISlot;
      
      protected var FStones:Vector.<TUISlot>;
      
      protected var FStonePage:TUIPage;
      
      protected var FTF_EquipmentLevel:TextField;
      
      protected var FTF_EnchantingName:TextField;
      
      protected var FTF_SkillName:TextField;
      
      protected var FTF_SkillDesc:TextField;
      
      protected var FBT_Enchanting:MovieClip;
      
      protected var FMC_Rectangle:MovieClip;
      
      protected var FSkills:Vector.<MovieClip>;
      
      protected var FSelectBox:MovieClip;
      
      protected var FInitialization:Boolean;
      
      protected var FStoneInventories:TInventories;
      
      protected var FPageIndex:uint;
      
      protected var FCurEquiment:TEquipment;
      
      protected var FMaterial:TInventory;
      
      protected var FMagicStoneBin:TBins;
      
      protected var FWeaponSkillConfigBin:TBins;
      
      protected var FSkillHint:THint;
      
      protected var FBaseEquipment:TBins;
      
      protected var FHeroID:uint;
      
      protected var FClickIndex:uint;
      
      protected var FSelectPage:uint;
      
      protected var FStonesCount:uint;
      
      protected var FLevelLimit:int;
      
      protected var FTF_Limit:TextField;
      
      protected var FOnSlotMouseOver:Function;
      
      protected var FOnSlotMouseOut:Function;
      
      protected var FHintOnOver:Function;
      
      protected var FHintOnOut:Function;
      
      protected var FOnClickEnchanting:Function;
      
      protected var FUpdateHeroPower:Function;
      
      public function TProcessorWindowGetSkill(param1:TUIComponent)
      {
         super(param1);
         this.FEquipmentSlot = new TUISlot(this);
         this.FEnchantingSlot = new TUISlot(this);
         this.FStones = new Vector.<TUISlot>(CONST_SMITHY.STONE_NUM);
         this.FSkills = new Vector.<MovieClip>(CONST_SMITHY.SKILL_RANDOM);
         this.FStoneInventories = new TInventories();
         this.FSkillHint = new THint();
         this.FClickIndex = 0;
         this.FSelectPage = 0;
         this.FStonesCount = 0;
      }
      
      private function SkillInit() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:TUISlot = null;
         var _loc4_:MovieClip = null;
         this.FEquipmentSlot.Resource = this.FScence["equipmentSlot"];
         this.FEquipmentSlot.TextureAdvancedEffect = SResourcesCore.TexturesLobby.GetTextureByIdentifier(CONST_LOBBY.RESOURCESID_Texture_SlotAdvancedEffect);
         TJadeCommon.InitSlot(this.FEquipmentSlot);
         this.FEquipmentSlot.OnClick = this.EquipmentSlotOnClick;
         this.FEquipmentSlot.OnOver = this.SlotOnOver;
         this.FEquipmentSlot.OnOut = this.SlotOnOut;
         this.FEquipmentSlot.OnQueryEdgeColor = this.SlotsOnQueryEdgeColor;
         this.FEquipmentSlot.Init();
         this.FEnchantingSlot.Resource = this.FScence["EnchantingSlot"];
         this.FEnchantingSlot.TextureAdvancedEffect = SResourcesCore.TexturesLobby.GetTextureByIdentifier(CONST_LOBBY.RESOURCESID_Texture_SlotAdvancedEffect);
         TJadeCommon.InitSlot(this.FEnchantingSlot);
         this.FEnchantingSlot.OnOver = this.SlotOnOver;
         this.FEnchantingSlot.OnOut = this.SlotOnOut;
         this.FEnchantingSlot.OnQueryEdgeColor = this.SlotsOnQueryEdgeColor;
         this.FEnchantingSlot.Init();
         _loc2_ = CONST_SMITHY.STONE_NUM;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc4_ = this.FScence["mc_stone_" + _loc1_];
            _loc3_ = new TUISlot(this);
            _loc3_.Resource = _loc4_;
            TJadeCommon.InitSlot(_loc3_);
            _loc3_.OnOver = this.SlotOnOver;
            _loc3_.OnOut = this.SlotOnOut;
            _loc3_.OnClick = this.SlotOnClick;
            _loc3_.Init();
            this.FStones[_loc1_] = _loc3_;
            _loc1_++;
         }
         _loc2_ = CONST_SMITHY.SKILL_RANDOM;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc4_ = this.FScence["mc_skill_" + _loc1_];
            _loc4_.tf_skillName.mouseEnabled = false;
            _loc4_.addEventListener(MouseEvent.MOUSE_MOVE,this.SkillOnMove);
            _loc4_.addEventListener(MouseEvent.MOUSE_OUT,this.SkillOnOut);
            this.FSkills[_loc1_] = _loc4_;
            _loc1_++;
         }
         this.FTF_EquipmentLevel = this.FScence["tf_equipLevel"];
         this.FTF_EnchantingName = this.FScence["tf_EnchantingName"];
         this.FTF_SkillName = this.FScence["tf_skillName"];
         this.FTF_SkillDesc = this.FScence["tf_skillDesc"];
         this.FStonePage = new TUIPage(this);
         this.FStonePage.ButtonPrevious.Substrate = this.FScence["btn_left"];
         this.FStonePage.ButtonNext.Substrate = this.FScence["btn_right"];
         this.FStonePage.LabelPage = this.FScence["TF_Page"];
         this.FStonePage.PageSize = CONST_SMITHY.STONE_NUM;
         this.FStonePage.OnChangePage = this.PageOnChange;
         this.FStonePage.Init();
         this.FBT_Enchanting = this.FScence["mc_Enchanting"];
         this.FBT_Enchanting.addEventListener(MouseEvent.CLICK,this.EnchantingOnClick);
         this.FMC_Rectangle = this.FScence["mc_Rectangle"];
         this.FMC_Rectangle.visible = false;
         this.FMagicStoneBin = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_MagicStone);
         this.FWeaponSkillConfigBin = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_WeaponSkillConfig);
         this.FBaseEquipment = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_BaseEquip);
         this.FSelectBox = TUtilityReflection.CreateDisplayObjectInstance(CONST_SMITHY.RESOURCESID_ClassName_SelectBox) as MovieClip;
         this.FSelectBox.mouseEnabled = false;
         this.FSelectBox.mouseChildren = false;
         this.FSelectBox.visible = false;
         this.FScence.addChild(this.FSelectBox);
         this.FTF_Limit = this.FScence["TF_Limit"];
         this.FTF_Limit.selectable = false;
         this.FTF_Limit.x += this.FScence.x;
         this.FTF_Limit.y += this.FScence.y;
         this.addChild(this.FTF_Limit);
      }
      
      override protected function LogicsPerform() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TUISlot = null;
         super.LogicsPerform();
         if(!this.Visible)
         {
            return;
         }
         if(this.FInitialization)
         {
            this.FEquipmentSlot.Update();
            this.FEnchantingSlot.Update();
            _loc2_ = int(CONST_SMITHY.STONE_NUM);
            _loc1_ = 0;
            while(_loc1_ < _loc2_)
            {
               _loc3_ = this.FStones[_loc1_];
               _loc3_.Update();
               _loc1_++;
            }
         }
      }
      
      private function ButtonReset() : void
      {
         if(this.FEquipmentSlot.Context != null && this.FEnchantingSlot.Context != null)
         {
            TGameUtil.setButtonMode(this.FBT_Enchanting,true);
            this.FBT_Enchanting.mouseEnabled = true;
         }
         else
         {
            TGameUtil.setButtonMode(this.FBT_Enchanting,false);
            this.FBT_Enchanting.mouseEnabled = false;
         }
      }
      
      private function TextReset() : void
      {
         this.FTF_EquipmentLevel.text = "";
         this.FTF_EnchantingName.text = "";
         this.FTF_SkillName.text = "";
         this.FTF_SkillDesc.text = "";
      }
      
      private function SlotReset() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TUISlot = null;
         this.FEquipmentSlot.Context = null;
         this.FEnchantingSlot.Context = null;
         _loc2_ = int(CONST_SMITHY.STONE_NUM);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FStones[_loc1_];
            _loc3_.Context = null;
            _loc3_.Resource.visible = false;
            _loc1_++;
         }
      }
      
      private function WeaponSkillsReset() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         _loc2_ = CONST_SMITHY.SKILL_RANDOM;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FSkills[_loc1_].visible = false;
            _loc1_++;
         }
      }
      
      private function CheckCanGetSkill(param1:Object) : Boolean
      {
         var _loc2_:TEquipment = null;
         var _loc3_:TBaseEquip = null;
         _loc2_ = param1 as TEquipment;
         _loc3_ = this.FBaseEquipment.GetDatebaseByIdentifier(_loc2_.IDTemplate) as TBaseEquip;
         if(_loc3_.SkillRevise <= 0)
         {
            EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.SMITHY_STRING_31));
            return false;
         }
         if(_loc2_ == this.FCurEquiment)
         {
            return false;
         }
         return true;
      }
      
      private function FilterStones() : void
      {
         var _loc1_:TInventories = null;
         var _loc2_:TInventory = null;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         _loc1_ = SLogicsCore.Character.GetBackpackByIndex(CONST_COMMON.INVENTORIESINDEX_Appliances);
         this.FStoneInventories.Clear();
         _loc4_ = uint(_loc1_.Count);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc2_ = _loc1_.GetInventoryByIndex(_loc3_);
            if(_loc2_.CategorySecond == CONST_INVENTORY.CATEGORYSECOND_MagicStone)
            {
               this.FStoneInventories.Add(_loc2_);
            }
            _loc3_++;
         }
      }
      
      private function SetStoneSlots() : void
      {
         var _loc1_:TUISlot = null;
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:TInventory = null;
         _loc3_ = CONST_SMITHY.STONE_NUM;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc1_ = this.FStones[_loc2_];
            _loc1_.Context = null;
            _loc1_.Resource.visible = false;
            _loc2_++;
         }
         if(this.FStoneInventories == null)
         {
            this.Reset();
            return;
         }
         _loc3_ = CONST_SMITHY.STONE_NUM;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(_loc2_ + this.FPageIndex * CONST_SMITHY.STONE_NUM >= this.FStoneInventories.Count)
            {
               break;
            }
            _loc4_ = this.FStoneInventories.GetInventoryByIndex(_loc2_ + this.FPageIndex * CONST_SMITHY.STONE_NUM);
            this.FStones[_loc2_].Context = _loc4_;
            this.FStones[_loc2_].Resource.visible = true;
            _loc2_++;
         }
      }
      
      private function UpdateEquipment(param1:Object) : void
      {
         var _loc2_:TWeaponSkillConfig = null;
         this.FCurEquiment = param1 as TEquipment;
         this.FEquipmentSlot.Context = this.FCurEquiment;
         this.FTF_EquipmentLevel.text = this.FCurEquiment.UpgradingLevel.toString();
         if(this.FCurEquiment.WeaponSkillID <= 0)
         {
            this.FTF_SkillName.text = "";
            this.FTF_SkillDesc.text = "";
            return;
         }
         _loc2_ = this.FWeaponSkillConfigBin.GetDatebaseByIdentifier(this.FCurEquiment.WeaponSkillID) as TWeaponSkillConfig;
         this.FTF_SkillName.textColor = CONST_COMMON.QUALITYCOLOR_INDEX[_loc2_.SkillQuality];
         this.FTF_SkillName.text = this.FCurEquiment.WeaponSkillName;
         this.FTF_SkillDesc.text = this.FCurEquiment.WeaponSkillDesc;
      }
      
      private function UpdateMaterial() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:TMagicStone = null;
         var _loc4_:TWeaponSkillConfig = null;
         var _loc5_:TUISlot = null;
         if(this.FStoneInventories.Count == 0)
         {
            this.FEnchantingSlot.Context = null;
            _loc2_ = CONST_SMITHY.STONE_NUM;
            _loc1_ = 0;
            while(_loc1_ < _loc2_)
            {
               _loc5_ = this.FStones[_loc1_];
               _loc5_.Context = null;
               _loc5_.Resource.visible = false;
               _loc1_++;
            }
            this.WeaponSkillsReset();
            this.FClickIndex = 0;
            this.FSelectPage = 0;
            this.FStonesCount = 0;
            this.FSelectBox.visible = false;
            this.FCurEquiment = null;
            this.FTF_EnchantingName.text = "";
            return;
         }
         if(this.FStoneInventories.Count < this.FStonesCount)
         {
            this.FStonesCount = this.FStoneInventories.Count;
            this.FMaterial = this.FStoneInventories.GetInventoryByIndex(0);
            this.FSelectPage = 0;
            this.FClickIndex = 0;
         }
         else
         {
            this.FMaterial = this.FStoneInventories.GetInventoryByIndex(this.FClickIndex + this.FSelectPage * CONST_SMITHY.STONE_NUM);
         }
         _loc2_ = CONST_SMITHY.STONE_NUM;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            if(this.FMaterial == this.FStones[_loc1_].Context)
            {
               _loc5_ = this.FStones[_loc1_];
               break;
            }
            _loc1_++;
         }
         if(_loc5_ != null)
         {
            this.FSelectBox.x = _loc5_.Resource.x - 7;
            this.FSelectBox.y = _loc5_.Resource.y - 7;
         }
         else
         {
            this.FSelectBox.x = this.FStones[0].Resource.x - 7;
            this.FSelectBox.y = this.FStones[0].Resource.y - 7;
         }
         if(this.FSelectPage == this.FPageIndex)
         {
            this.FSelectBox.visible = true;
         }
         else
         {
            this.FSelectBox.visible = false;
         }
         this.FEnchantingSlot.Context = this.FMaterial;
         this.FTF_EnchantingName.text = this.FMaterial.Name;
         this.FTF_EnchantingName.textColor = CONST_COMMON.QUALITYCOLOR_INDEX[this.FMaterial.Quality];
         _loc3_ = this.FMagicStoneBin.GetDatebaseByIdentifier(this.FMaterial.IDTemplate) as TMagicStone;
         this.WeaponSkillsReset();
         _loc2_ = _loc3_.MagicSkills.WeaponSkillid.length;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc4_ = this.FWeaponSkillConfigBin.GetDatebaseByIdentifier(_loc3_.MagicSkills.WeaponSkillid[_loc1_]) as TWeaponSkillConfig;
            this.FSkills[_loc1_].tf_skillName.text = _loc4_.Name;
            this.FSkills[_loc1_].tf_skillName.textColor = CONST_COMMON.QUALITYCOLOR_INDEX[_loc4_.SkillQuality];
            this.FSkills[_loc1_].visible = true;
            _loc1_++;
         }
      }
      
      protected function SetupStonePage(param1:int, param2:int) : void
      {
         this.FPageIndex = param2;
         this.FStonePage.TotalQuantity = param1;
         this.FStonePage.Update();
         this.FStonePage.PageIndex = param2;
      }
      
      private function SetEquipment(param1:uint) : TEquipment
      {
         var _loc2_:THero = null;
         var _loc3_:TCollectionInventory = null;
         var _loc4_:TInventories = null;
         var _loc5_:TEquipment = null;
         if(this.FHeroID == 0)
         {
            _loc4_ = SLogicsCore.Character.Equipments;
            return _loc4_.GetInventoryByIdentifier(param1) as TEquipment;
         }
         _loc2_ = SLogicsCore.Character.Heros.GetHeroByIdentifier(this.FHeroID);
         _loc3_ = _loc2_.EquipmentsMounted;
         return _loc3_.GetInventoryByIdentifier(param1) as TEquipment;
      }
      
      private function SetStoneSelect() : void
      {
         var _loc1_:TUISlot = null;
         this.FClickIndex = 0;
         this.FSelectPage = 0;
         _loc1_ = this.FStones[this.FClickIndex];
         this.FSelectBox.x = _loc1_.Resource.x - 7;
         this.FSelectBox.y = _loc1_.Resource.y - 7;
         this.FSelectBox.visible = true;
      }
      
      protected function CheckIfLevelEnough() : Boolean
      {
         var _loc1_:TConfigValue = null;
         var _loc2_:Boolean = false;
         _loc1_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.EQUIP_FM_LEVEL) as TConfigValue;
         this.FLevelLimit = _loc1_.Value as uint;
         this.FTF_Limit.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.SMITHY_STRING_45),this.FLevelLimit);
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
      
      private function PageOnChange(param1:Object, param2:int) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:TUISlot = null;
         if(this.FSelectPage == param2)
         {
            this.FSelectBox.visible = true;
         }
         else
         {
            this.FSelectBox.visible = false;
         }
         this.FPageIndex = param2;
         _loc4_ = int(CONST_SMITHY.STONE_NUM);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc5_ = this.FStones[_loc3_];
            _loc5_.Context = null;
            _loc5_.Resource.visible = false;
            _loc3_++;
         }
         this.SetStoneSlots();
      }
      
      private function SlotOnOut(param1:Object, param2:TInventory) : void
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
      
      private function SlotOnOver(param1:Object, param2:TInventory) : void
      {
         if(this.FOnSlotMouseOver != null)
         {
            this.FOnSlotMouseOver(param1,param2);
         }
      }
      
      private function SlotOnClick(param1:Object, param2:TInventory) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:TMagicStone = null;
         var _loc6_:TWeaponSkillConfig = null;
         var _loc7_:TUISlot = null;
         if(this.FEquipmentSlot.Context == null)
         {
            EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.SMITHY_STRING_32));
            return;
         }
         _loc4_ = CONST_SMITHY.STONE_NUM;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            if(param2 == this.FStones[_loc3_].Context)
            {
               this.FClickIndex = _loc3_;
               _loc7_ = this.FStones[_loc3_];
               break;
            }
            _loc3_++;
         }
         this.FSelectPage = this.FPageIndex;
         this.FSelectBox.x = _loc7_.Resource.x - 7;
         this.FSelectBox.y = _loc7_.Resource.y - 7;
         this.FSelectBox.visible = true;
         this.FMaterial = param2;
         this.FEnchantingSlot.Context = this.FMaterial;
         this.FTF_EnchantingName.text = this.FMaterial.Name;
         this.FTF_EnchantingName.textColor = CONST_COMMON.QUALITYCOLOR_INDEX[this.FMaterial.Quality];
         _loc5_ = this.FMagicStoneBin.GetDatebaseByIdentifier(this.FMaterial.IDTemplate) as TMagicStone;
         this.WeaponSkillsReset();
         _loc4_ = _loc5_.MagicSkills.WeaponSkillid.length;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc6_ = this.FWeaponSkillConfigBin.GetDatebaseByIdentifier(_loc5_.MagicSkills.WeaponSkillid[_loc3_]) as TWeaponSkillConfig;
            this.FSkills[_loc3_].tf_skillName.text = _loc6_.Name;
            this.FSkills[_loc3_].tf_skillName.textColor = CONST_COMMON.QUALITYCOLOR_INDEX[_loc6_.SkillQuality];
            this.FSkills[_loc3_].visible = true;
            _loc3_++;
         }
      }
      
      private function EquipmentSlotOnClick(param1:Object, param2:TInventory) : void
      {
         this.FCurEquiment = null;
         this.FEquipmentSlot.Context = null;
         this.FEnchantingSlot.Context = null;
         this.TextReset();
         this.ButtonReset();
         this.WeaponSkillsReset();
         if(this.FOnSlotMouseOut != null)
         {
            this.FOnSlotMouseOut(param1,param2);
         }
         this.FClickIndex = 0;
         this.FSelectBox.visible = false;
      }
      
      private function SkillOnOut(param1:MouseEvent) : void
      {
         if(this.FHintOnOut != null)
         {
            this.FHintOnOut(this,this.FSkillHint);
         }
      }
      
      private function SkillOnMove(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:uint = 0;
         var _loc4_:TWeaponSkillConfig = null;
         var _loc5_:TMagicStone = null;
         var _loc6_:String = null;
         var _loc7_:uint = 0;
         _loc2_ = param1.currentTarget as MovieClip;
         _loc3_ = this.FSkills.indexOf(_loc2_);
         _loc5_ = this.FMagicStoneBin.GetDatebaseByIdentifier(this.FMaterial.IDTemplate) as TMagicStone;
         _loc7_ = _loc5_.MagicSkills.WeaponSkillid[_loc3_];
         _loc4_ = this.FWeaponSkillConfigBin.GetDatebaseByIdentifier(_loc7_) as TWeaponSkillConfig;
         _loc6_ = _loc4_.Desc;
         this.FSkillHint.Caption = _loc6_;
         if(this.FHintOnOver != null)
         {
            this.FHintOnOver(this,this.FSkillHint);
         }
      }
      
      private function EnchantingOnClick(param1:MouseEvent) : void
      {
         if(this.FOnClickEnchanting != null)
         {
            this.FOnClickEnchanting(this,this.FHeroID,this.FCurEquiment,this.FMaterial);
         }
      }
      
      public function set OnSlotMouseOver(param1:Function) : void
      {
         this.FOnSlotMouseOver = param1;
      }
      
      public function set OnSlotMouseOut(param1:Function) : void
      {
         this.FOnSlotMouseOut = param1;
      }
      
      public function set HintOnOver(param1:Function) : void
      {
         this.FHintOnOver = param1;
      }
      
      public function set HintOnOut(param1:Function) : void
      {
         this.FHintOnOut = param1;
      }
      
      public function get OnClickEnchanting() : Function
      {
         return this.FOnClickEnchanting;
      }
      
      public function set OnClickEnchanting(param1:Function) : void
      {
         this.FOnClickEnchanting = param1;
      }
      
      public function set CurEquiment(param1:TEquipment) : void
      {
         this.FCurEquiment = param1;
      }
      
      public function set UpdateHeroPower(param1:Function) : void
      {
         this.FUpdateHeroPower = param1;
      }
      
      public function Perform_UIDispatch(param1:MovieClip) : void
      {
         this.FScence = param1;
         this.addChild(this.FScence);
         this.SkillInit();
         this.Reset();
         this.FInitialization = true;
      }
      
      public function Reset() : void
      {
         this.TextReset();
         this.SlotReset();
         this.ButtonReset();
         this.WeaponSkillsReset();
         this.FClickIndex = 0;
         this.FSelectPage = 0;
         this.FStonesCount = 0;
         this.FSelectBox.visible = false;
         this.FCurEquiment = null;
      }
      
      public function UpdateUI(param1:Object, param2:uint) : void
      {
         var _loc3_:Boolean = false;
         _loc3_ = this.CheckIfLevelEnough();
         if(!_loc3_)
         {
            return;
         }
         if(!this.CheckCanGetSkill(param1))
         {
            return;
         }
         this.FClickIndex = 0;
         this.FHeroID = param2;
         this.UpdateEquipment(param1);
         this.FilterStones();
         this.SetupStonePage(this.FStoneInventories.Count,0);
         this.PageOnChange(null,this.FPageIndex);
         this.UpdateMaterial();
         this.ButtonReset();
         this.FSelectPage = 0;
         this.UpdateStonesSlot();
      }
      
      public function UpdateStonesSlot() : void
      {
         this.FilterStones();
         this.SetStoneSlots();
         this.SetupStonePage(this.FStoneInventories.Count,0);
         this.FStonesCount = this.FStoneInventories.Count;
      }
      
      public function Update() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:TEquipment = null;
         _loc1_ = this.CheckIfLevelEnough();
         if(!_loc1_)
         {
            return;
         }
         if(this.FCurEquiment == null)
         {
            return;
         }
         this.FEquipmentSlot.Context = this.FCurEquiment;
         this.FilterStones();
         if(this.FStoneInventories.Count <= CONST_SMITHY.STONE_NUM)
         {
            this.FPageIndex = this.FSelectPage;
         }
         this.SetStoneSlots();
         this.SetupStonePage(this.FStoneInventories.Count,this.FPageIndex);
         this.UpdateEquipment(this.FCurEquiment);
         this.UpdateMaterial();
         this.ButtonReset();
         this.UpdateStonesSlot();
         if(this.FUpdateHeroPower != null && this.FHeroID != 0)
         {
            this.FUpdateHeroPower(this,this.FHeroID);
         }
      }
   }
}

