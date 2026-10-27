package Processors.Game.Lobby.Talisman.Panel
{
   import Components.ComboBox.*;
   import Components.Pages.*;
   import Components.Slots.*;
   import Components.Standard.*;
   import Foundation.Common.*;
   import Foundation.Queries.*;
   import Foundation.Queries.Textures.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Bins.*;
   import Foundation.Resources.Repositories.*;
   import Foundation.Resources.Textures.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.Characters.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.Inventories.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Components.*;
   import Processors.Game.Lobby.Utilities.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.filters.*;
   import flash.text.*;
   
   public class TProcessorWindowTalismanEquip extends TProcessorLobbyWindow
   {
      
      protected static const CAPACITY_MC_Slots:uint = 24;
      
      protected static const CAPACITY_Equip:uint = 6;
      
      protected static const TALISMAN_StartIndex:uint = 7;
      
      protected static const TALISMAN_TextWidth:uint = 96;
      
      protected static const TALISMAN_TextPosX:uint = 19;
      
      protected static const CAPACITY_TF_Property:uint = 4;
      
      protected static const CAPACITY_MC_Talisman:uint = 4;
      
      public static const COLOR_ADDITIONBASEATTRIBUTE:uint = 65280;
      
      public static const COLOR_REDUCINGBASEATTRIBUTE:uint = 16711680;
      
      private var StringLevelVec:Vector.<String>;
      
      protected var FScene:MovieClip;
      
      protected var FUISlots:Vector.<TUISlot>;
      
      protected var FEquipSlots:Vector.<TUISlot>;
      
      protected var FUIPage:TUIPage;
      
      protected var FMC_HeroPosition:MovieClip;
      
      protected var FLevelList:Vector.<DisplayObject>;
      
      protected var FTypeList:Vector.<DisplayObject>;
      
      protected var FLevelComboBox:TComboBox;
      
      protected var FTypeComboBox:TComboBox;
      
      protected var FLevelIndex:uint;
      
      protected var FTypeIndex:uint;
      
      protected var FTF_PropertyList:Vector.<TextField>;
      
      protected var FTF_Page:TextField;
      
      protected var FRoleIndex:uint;
      
      protected var FMC_Role:MovieClip;
      
      protected var FPage_Index:int;
      
      protected var FInitialized:Boolean;
      
      protected var FCharacter:TCharacter;
      
      protected var FTargetSlot:TUISlot;
      
      protected var FInventory:TInventory;
      
      protected var FUIHero:TUIHero;
      
      protected var FButtonPrevious:TUIButton;
      
      protected var FButtonNext:TUIButton;
      
      protected var FSystemLanguage:TSystemLanguage;
      
      protected var FSystemLanguageBin:TBins;
      
      protected var FUpgradingTextList:Vector.<TextField>;
      
      protected var FSpecialLevleTextList:Vector.<TextField>;
      
      protected var FTalismanTextList:Vector.<MovieClip>;
      
      protected var FNameTextList:Vector.<TextField>;
      
      protected var FBmpIconList:Vector.<MovieClip>;
      
      protected var FMC_Effect:MovieClip;
      
      protected var FCurInventories:TInventories;
      
      protected var FRolesModelID:Vector.<int>;
      
      protected var FSlotOnClick:Function;
      
      protected var FOnInventoryOver:Function;
      
      protected var FOnInventoryOut:Function;
      
      public function TProcessorWindowTalismanEquip(param1:TUIComponent)
      {
         super(param1);
         this.FCharacter = SLogicsCore.Character;
         this.FTF_PropertyList = new Vector.<TextField>(CAPACITY_TF_Property);
         this.FUISlots = new Vector.<TUISlot>(CAPACITY_MC_Slots);
         this.FEquipSlots = new Vector.<TUISlot>(CAPACITY_MC_Talisman);
         this.FUpgradingTextList = new Vector.<TextField>();
         this.FSpecialLevleTextList = new Vector.<TextField>();
         this.FTalismanTextList = new Vector.<MovieClip>();
         this.FNameTextList = new Vector.<TextField>();
         this.FBmpIconList = new Vector.<MovieClip>();
         this.FRolesModelID = new Vector.<int>();
         this.FInitialized = false;
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_TALISMAN.RESOURCESID_Swf_Talisman);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:MovieClip = null;
         var _loc4_:TextField = null;
         var _loc5_:TUISlot = null;
         var _loc6_:Vector.<String> = null;
         var _loc7_:DisplayObject = null;
         var _loc8_:TBounds = null;
         var _loc9_:TCoordinate = null;
         super.ResourcesPerform_UIDispatch();
         this.StringLevelVec = TUtilityLobby.GetStringsByIdentifier(CONST_SYSTEMLANGUAGE.TALISMAN_STRING_33);
         this.FScene = TUtilityReflection.CreateDisplayObjectInstance("MC_Equip") as MovieClip;
         this.x = CONST_TALISMAN.POSX_MC_SCENE;
         this.y = CONST_TALISMAN.POSY_MC_SCENE;
         addChild(this.FScene);
         this.FUIPage = new TUIPage(this);
         _loc3_ = this.FScene["MC_PageLeft"];
         this.FUIPage.ButtonPrevious.Substrate = _loc3_;
         _loc3_ = this.FScene["MC_PageRight"];
         this.FUIPage.ButtonNext.Substrate = _loc3_;
         this.FUIPage.OnChangePage = this.ChangePage;
         this.FTF_Page = this.FScene["TF_Page"];
         this.FUIPage.LabelPage = this.FTF_Page;
         this.FUIPage.PageSize = CAPACITY_MC_Slots;
         this.FUIPage.Init();
         this.FButtonPrevious = this.FUIPage.ButtonPrevious;
         this.FButtonNext = this.FUIPage.ButtonNext;
         this.FTF_Page = this.FScene["TF_Page"];
         this.FMC_Role = this.FScene["MC_Role"];
         this.FMC_HeroPosition = this.FScene["MC_HeroPosition"];
         this.FPage_Index = 0;
         _loc2_ = int(this.FTF_PropertyList.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc4_ = this.FScene["TF_Property_" + _loc1_];
            _loc4_.mouseEnabled = false;
            this.FTF_PropertyList[_loc1_] = _loc4_;
            _loc1_++;
         }
         _loc2_ = int(CAPACITY_MC_Slots);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc5_ = new TUISlot(this);
            _loc5_.Resource = this.FScene["MC_Slot_" + _loc1_] as Sprite;
            _loc5_.SequenceDefaultIcon = SResourcesCore.TexturesLobby.GetAnimationSequenceByIdentifiers(CONST_LOBBY.RESOURCESID_Texture_SlotDefaultEffect,0);
            _loc5_.Tag = _loc1_;
            _loc5_.OnClick = this.EquipOnOnClick;
            _loc5_.OnQuerySequenceContext = this.SlotsOnQuerySequenceContext;
            _loc5_.OnQueryEuqipLevel = this.SlotsOnQueryEuqipLevel;
            _loc5_.OnOver = this.SlotsOnMove;
            _loc5_.OnOut = this.SlotsOnOut;
            _loc5_.Init();
            this.FUISlots[_loc1_] = _loc5_;
            _loc1_++;
         }
         _loc2_ = int(this.FEquipSlots.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc5_ = new TUISlot(this);
            _loc5_.Resource = this.FScene["MC_Equip_" + _loc1_] as Sprite;
            _loc5_.SequenceDefaultIcon = SResourcesCore.TexturesLobby.GetAnimationSequenceByIdentifiers(CONST_LOBBY.RESOURCESID_Texture_SlotDefaultEffect,0);
            _loc5_.Tag = _loc1_;
            _loc5_.OnClick = this.EquipOffOnClick;
            _loc5_.OnQuerySequenceContext = this.SlotsOnBigQuerySequenceContext;
            _loc5_.OnOver = this.SlotsOnMove;
            _loc5_.OnOut = this.SlotsOnOut;
            _loc5_.Init();
            this.FEquipSlots[_loc1_] = _loc5_;
            this.FTalismanTextList[_loc1_] = _loc5_.Resource["TalismanText"];
            this.FUpgradingTextList[_loc1_] = _loc5_.Resource["TalismanText"]["TF_Upgrading"];
            this.FUpgradingTextList[_loc1_].mouseEnabled = false;
            this.FSpecialLevleTextList[_loc1_] = _loc5_.Resource["TalismanText"]["TF_SpecialLevel"];
            this.FSpecialLevleTextList[_loc1_].mouseEnabled = false;
            this.FNameTextList[_loc1_] = _loc5_.Resource["TalismanText"]["TF_Name"];
            this.FNameTextList[_loc1_].mouseEnabled = false;
            this.FBmpIconList[_loc1_] = _loc5_.Resource["MC_Bmp_Icon"];
            _loc1_++;
         }
         this.FLevelList = new Vector.<DisplayObject>();
         _loc6_ = TUtilityLobby.GetStringsByIdentifier(CONST_SYSTEMLANGUAGE.TALISMAN_STRING_23);
         _loc1_ = 0;
         while(_loc1_ < _loc6_.length)
         {
            _loc7_ = this.MakeComboItem(_loc6_[_loc1_]);
            this.FLevelList.push(_loc7_);
            _loc1_++;
         }
         this.FLevelComboBox = new TComboBox(this,this.FScene["MC_TalismanLevel"],this.FLevelList,90,this.OnLevelSelect);
         this.FTypeList = new Vector.<DisplayObject>();
         _loc6_ = TUtilityLobby.GetStringsByIdentifier(CONST_SYSTEMLANGUAGE.TALISMAN_STRING_22);
         _loc1_ = 0;
         while(_loc1_ < _loc6_.length)
         {
            _loc7_ = this.MakeComboItem(_loc6_[_loc1_]);
            this.FTypeList.push(_loc7_);
            _loc1_++;
         }
         this.FTypeComboBox = new TComboBox(this,this.FScene["MC_TalismanType"],this.FTypeList,90,this.OnTypeSelect);
         this.FUIHero = new TUIHero(this);
         this.FMC_HeroPosition.addChild(this.FUIHero);
         this.FUIHero.OnQuerySequenceContext = this.HeroOnQuerySequenceContext;
         this.FUIHero.SequenceDefaultRole = SResourcesCore.TexturesLobby.GetAnimationSequenceByIdentifiers(CONST_LOBBY.RESOURCEID_Textures_DefaultRole,0);
         _loc8_ = new TBounds();
         _loc9_ = new TCoordinate();
         this.FUIHero.SequenceDefaultRole.Evaluate(_loc9_,_loc8_);
         this.FUIHero.X = _loc8_.X;
         this.FUIHero.Y = _loc8_.Y;
         this.FInitialized = true;
      }
      
      override protected function ResourcesPerform_UIFinalize() : void
      {
         this.FSystemLanguageBin = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_SystemLanguage);
         super.ResourcesPerform_UIFinalize();
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
         if(this.FInitialized)
         {
            _loc2_ = int(CAPACITY_MC_Slots);
            _loc1_ = 0;
            while(_loc1_ < _loc2_)
            {
               _loc3_ = this.FUISlots[_loc1_];
               _loc3_.Update();
               _loc1_++;
            }
            _loc2_ = int(this.FEquipSlots.length);
            _loc1_ = 0;
            while(_loc1_ < _loc2_)
            {
               _loc3_ = this.FEquipSlots[_loc1_];
               _loc3_.Update();
               _loc1_++;
            }
            this.FUIHero.Update();
         }
      }
      
      protected function OnLevelSelect(param1:Object, param2:uint) : void
      {
         this.FLevelIndex = param2;
         this.UpdateBackpack();
         this.UpdatePageInfo();
         this.UpdateSlotsInfo();
      }
      
      protected function OnTypeSelect(param1:Object, param2:int) : void
      {
         if(param2 == 0)
         {
            this.FTypeIndex = param2;
         }
         else
         {
            this.FTypeIndex = param2 + CONST_TALISMAN.CAPACITY_EQUIP;
         }
         this.UpdateBackpack();
         this.UpdatePageInfo();
         this.UpdateSlotsInfo();
      }
      
      protected function MakeComboItem(param1:String) : DisplayObject
      {
         var _loc2_:MovieClip = null;
         _loc2_ = TUtilityReflection.CreateDisplayObjectInstance("MC_TalismanList") as MovieClip;
         _loc2_.tf_into.text = param1;
         return _loc2_;
      }
      
      protected function UpdatePageInfo() : void
      {
         this.FPage_Index = 0;
         this.FUIPage.TotalQuantity = this.FCurInventories.Count;
         this.FUIPage.PageIndex = this.FPage_Index;
         this.FUIPage.Update();
      }
      
      protected function UpdateSlotsInfo() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:uint = 0;
         var _loc4_:TUISlot = null;
         _loc3_ = CAPACITY_MC_Slots;
         _loc1_ = 0;
         while(_loc1_ < _loc3_)
         {
            _loc4_ = this.FUISlots[_loc1_];
            _loc4_.Context = null;
            _loc4_.Resource.visible = false;
            _loc1_++;
         }
         _loc2_ = this.FPage_Index * CAPACITY_MC_Slots;
         _loc3_ = uint(this.FCurInventories.Count);
         this.FCurInventories.Sort();
         _loc1_ = 0;
         while(_loc1_ < CAPACITY_MC_Slots)
         {
            if(_loc3_ <= _loc2_ + _loc1_)
            {
               break;
            }
            _loc4_ = this.FUISlots[_loc1_];
            _loc4_.Context = this.FCurInventories.GetInventoryByIndex(_loc2_ + _loc1_);
            _loc4_.Resource.visible = true;
            _loc1_++;
         }
      }
      
      protected function UpdateBackpack() : void
      {
         var _loc1_:int = 0;
         var _loc2_:uint = 0;
         var _loc3_:TInventory = null;
         var _loc4_:TInventories = null;
         _loc4_ = new TInventories();
         if(this.FLevelIndex == 0 && this.FTypeIndex == 0)
         {
            _loc4_ = this.FCharacter.Treasures;
         }
         else
         {
            _loc2_ = uint(this.FCharacter.Treasures.Count);
            _loc1_ = 0;
            while(_loc1_ < _loc2_)
            {
               _loc3_ = this.FCharacter.Treasures.GetInventoryByIndex(_loc1_);
               if(this.CheckLevel(_loc3_) && this.CheckType(_loc3_))
               {
                  _loc4_.Add(_loc3_);
               }
               _loc1_++;
            }
         }
         this.FCurInventories = _loc4_;
      }
      
      protected function CheckLevel(param1:TInventory) : Boolean
      {
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
      
      protected function CheckType(param1:TInventory) : Boolean
      {
         if(this.FTypeIndex == 0)
         {
            return true;
         }
         if(param1.CategorySecond == this.FTypeIndex)
         {
            return true;
         }
         return false;
      }
      
      protected function UpdateRole() : void
      {
         var _loc1_:THero = null;
         _loc1_ = this.FCharacter.Heros.GetHeroByIndex(this.FRoleIndex);
         this.FUIHero.Context = _loc1_;
      }
      
      protected function UpdateEquip() : void
      {
         var _loc1_:int = 0;
         var _loc2_:uint = 0;
         var _loc3_:TUISlot = null;
         var _loc4_:TEquipment = null;
         var _loc5_:THero = null;
         var _loc6_:uint = 0;
         _loc5_ = this.FCharacter.Heros.GetHeroByIndex(this.FRoleIndex);
         _loc2_ = uint(_loc5_.TalismansMounted.Capacity);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FEquipSlots[_loc1_];
            _loc3_.Context = null;
            this.FUpgradingTextList[_loc1_].text = "";
            this.FSpecialLevleTextList[_loc1_].text = "";
            this.FNameTextList[_loc1_].text = "";
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FEquipSlots[_loc1_];
            _loc4_ = _loc5_.TalismansMounted.GetInventoryByIndex(_loc1_) as TEquipment;
            _loc3_.Context = _loc4_;
            if(_loc4_ != null)
            {
               _loc6_ = _loc5_.GetSuitCountByTalisman(_loc4_);
               _loc5_.SetTreasureSuitCount(_loc4_,_loc6_);
               this.FBmpIconList[_loc1_].filters = [new GlowFilter(CONST_COMMON.QUALITYCOLOR_INDEX[_loc4_.Quality],0.9,17,15,3)];
               if(_loc4_.UpgradingLevel > 0)
               {
                  if(_loc4_.RequirementLevel < 100)
                  {
                     this.FUpgradingTextList[_loc1_].text = "+" + _loc4_.UpgradingLevel;
                     this.FUpgradingTextList[_loc1_].visible = true;
                     this.FSpecialLevleTextList[_loc1_].visible = false;
                  }
                  else
                  {
                     this.FSpecialLevleTextList[_loc1_].text = this.GetLevelStringName(_loc4_.UpgradingLevel);
                     this.FUpgradingTextList[_loc1_].visible = false;
                     this.FSpecialLevleTextList[_loc1_].visible = true;
                  }
                  this.FNameTextList[_loc1_].x = TALISMAN_TextPosX;
               }
               else
               {
                  this.FNameTextList[_loc1_].x = (TALISMAN_TextWidth - this.FNameTextList[_loc1_].width) / 2;
               }
               this.FNameTextList[_loc1_].text = _loc4_.Name;
               this.FNameTextList[_loc1_].textColor = CONST_COMMON.QUALITYCOLOR_INDEX[_loc4_.Quality];
               this.FTalismanTextList[_loc1_].visible = true;
            }
            else
            {
               this.FTalismanTextList[_loc1_].visible = false;
            }
            _loc1_++;
         }
      }
      
      private function GetLevelStringName(param1:int) : String
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         _loc2_ = Math.floor(param1 / 10);
         _loc3_ = Math.floor(param1 % 10) + 1;
         return this.StringLevelVec[_loc2_] + TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TALISMAN_STRING_34),_loc3_);
      }
      
      protected function UpdatePropertyText() : void
      {
         var _loc1_:int = 0;
         var _loc2_:uint = 0;
         var _loc3_:TextField = null;
         var _loc4_:THero = null;
         var _loc5_:Number = NaN;
         _loc4_ = this.FCharacter.Heros.GetHeroByIndex(this.FRoleIndex);
         _loc2_ = uint(_loc4_.TalismansMounted.Capacity);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FTF_PropertyList[_loc1_];
            _loc5_ = _loc4_.GetFirstAttributeByIndex(_loc1_);
            if(_loc5_ > 0)
            {
               _loc3_.text = "+ " + _loc5_;
               _loc3_.textColor = CONST_COMMON.TEXT_Green_Color;
            }
            else
            {
               _loc3_.text = "+ " + _loc5_;
               _loc3_.textColor = CONST_COMMON.TEXT_White_Color;
            }
            _loc1_++;
         }
      }
      
      protected function ChangePage(param1:Object, param2:uint) : void
      {
         this.FPage_Index = param2;
         this.UpdateBackpack();
         this.UpdateSlotsInfo();
      }
      
      protected function CharacterUpdateBaseAttributes() : void
      {
         if(this.FInitialized)
         {
            this.UpdatePropertyText();
         }
      }
      
      protected function CheckEquipmentMouted(param1:Function, param2:TInventory) : void
      {
         var _loc3_:THero = null;
         var _loc4_:THeros = null;
         var _loc5_:int = 0;
         var _loc6_:uint = 0;
         var _loc7_:TInventory = null;
         _loc4_ = this.FCharacter.Heros;
         _loc3_ = _loc4_.GetHeroByIndex(this.FRoleIndex);
         _loc6_ = CONST_TALISMAN.CAPACITY_TalismanNum;
         if(param2.Category == 4)
         {
            _loc5_ = 0;
            while(_loc5_ < _loc6_)
            {
               _loc7_ = _loc3_.TalismansMounted.GetInventoryByIndex(_loc5_);
               if(_loc7_ != null && _loc7_ != param2 && _loc7_.CategorySecond == param2.CategorySecond)
               {
                  if(param1 != null)
                  {
                     param1(this,param2,_loc7_);
                  }
                  return;
               }
               _loc5_++;
            }
            if(param1 != null)
            {
               param1(this,param2,null);
            }
         }
         else if(param1 != null)
         {
            param1(this,param2,null);
         }
      }
      
      protected function EquipOnOnClick(param1:Object, param2:Object) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:TBins = null;
         var _loc6_:THero = null;
         this.FTargetSlot = param1 as TUISlot;
         this.FInventory = param2 as TInventory;
         _loc4_ = this.FCharacter.StarMapIndex;
         if(this.FInventory == null)
         {
            return;
         }
         this.FSystemLanguage = this.FSystemLanguageBin.GetDatebaseByIdentifier(CONST_SYSTEMLANGUAGE.TALISMAN_STRING_07) as TSystemLanguage;
         _loc6_ = this.FCharacter.Heros.GetHeroByIndex(this.FRoleIndex);
         _loc3_ = _loc6_.Quality;
         if(this.FTargetSlot.Context == null)
         {
            return;
         }
         if(this.FInventory.Quality > _loc3_ + TUtilityLobby.GetConfigValue(60104009)[_loc6_.AddQuality - 1 < 0 ? 0 : _loc6_.AddQuality - 1])
         {
            EffectGenerateText(this.FSystemLanguage.Desc);
            return;
         }
         this.FSlotOnClick(this,this.FInventory,CONST_TALISMAN.TalismanOn_Type,_loc6_.Identifier);
         this.CheckEquipmentMouted(this.FOnInventoryOut,this.FInventory);
         TutorialNextStep(CONST_FRESHGUIDE.EVENTID_EquipTreasure);
         this.SlotsOnOut(param1,param2 as TInventory);
      }
      
      protected function EquipOffOnClick(param1:Object, param2:Object) : void
      {
         var _loc3_:THero = null;
         var _loc4_:TEquipment = null;
         _loc3_ = this.FCharacter.Heros.GetHeroByIndex(this.FRoleIndex);
         this.FTargetSlot = param1 as TUISlot;
         this.FInventory = param2 as TInventory;
         if(this.FInventory == null)
         {
            return;
         }
         this.FSlotOnClick(this,this.FInventory,CONST_TALISMAN.TalismanOff_Type,_loc3_.Identifier);
         this.CheckEquipmentMouted(this.FOnInventoryOut,this.FInventory);
      }
      
      protected function SlotsOnBigQuerySequenceContext(param1:Object, param2:Object, param3:TQueryAnimationSequence, param4:uint = 1) : void
      {
         this.SlotsOnQuerySequenceContext(param1,param2,param3,param4);
      }
      
      protected function SlotsOnQuerySequenceContext(param1:Object, param2:Object, param3:TQueryAnimationSequence, param4:uint = 0) : void
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
      
      protected function SlotsOnQueryEuqipLevel(param1:Object, param2:Object, param3:TQueryString) : void
      {
         var _loc4_:TEquipment = null;
         if(param2 is TEquipment)
         {
            _loc4_ = param2 as TEquipment;
            if(_loc4_.UpgradingLevel > 0)
            {
               param3.Value = "Lv." + _loc4_.UpgradingLevel.toString();
            }
         }
      }
      
      protected function SlotsOnMove(param1:Object, param2:TInventory) : void
      {
         this.CheckEquipmentMouted(this.FOnInventoryOver,param2);
      }
      
      protected function SlotsOnOut(param1:Object, param2:TInventory) : void
      {
         this.CheckEquipmentMouted(this.FOnInventoryOut,param2);
      }
      
      protected function HeroOnQuerySequenceContext(param1:Object, param2:Object, param3:TQueryAnimationSequence, param4:uint = 0) : void
      {
         var _loc5_:THero = null;
         var _loc6_:TResourceRepositoryTexture = null;
         var _loc7_:TTexture = null;
         var _loc8_:TBounds = null;
         var _loc9_:TCoordinate = null;
         var _loc10_:uint = 0;
         var _loc11_:int = 0;
         _loc5_ = param2 as THero;
         _loc6_ = SResourcesCore.TexturesModel;
         _loc10_ = CONST_ROLE.GetModelIDByIndex(_loc5_.Identifier,CONST_ROLE.ROLE_SEQUENCEINDEX_Showcase);
         _loc7_ = _loc6_.GetTextureByIdentifier(_loc10_);
         if(_loc7_ != null)
         {
            _loc8_ = new TBounds();
            _loc9_ = new TCoordinate();
            param3.Value = _loc7_.GetAnimationSequenceByIndex(0);
            param3.Value.Evaluate(_loc9_,_loc8_);
            this.FUIHero.X = _loc8_.X;
            this.FUIHero.Y = _loc8_.Y;
         }
         else
         {
            _loc6_.LoadSecondary(_loc10_);
         }
         this.SetRoleModelID(_loc10_);
      }
      
      protected function SetRoleModelID(param1:uint) : void
      {
         var _loc2_:int = 0;
         _loc2_ = this.FRolesModelID.indexOf(param1);
         if(_loc2_ < 0)
         {
            this.FRolesModelID.push(param1);
         }
      }
      
      public function get SlotOnClick() : Function
      {
         return this.FSlotOnClick;
      }
      
      public function set SlotOnClick(param1:Function) : void
      {
         this.FSlotOnClick = param1;
      }
      
      public function get OnInventoryOver() : Function
      {
         return this.FOnInventoryOver;
      }
      
      public function set OnInventoryOver(param1:Function) : void
      {
         this.FOnInventoryOver = param1;
      }
      
      public function get OnInventoryOut() : Function
      {
         return this.FOnInventoryOut;
      }
      
      public function set OnInventoryOut(param1:Function) : void
      {
         this.FOnInventoryOut = param1;
      }
      
      public function Update(param1:uint, param2:uint = 0) : void
      {
         this.FRoleIndex = param1;
         this.UpdateBackpack();
         this.UpdatePageInfo();
         this.UpdateSlotsInfo();
         this.UpdateRole();
         this.UpdateEquip();
         this.UpdatePropertyText();
      }
      
      public function UpdateCharacterBaseAttributes() : void
      {
         this.CharacterUpdateBaseAttributes();
      }
      
      public function UpdateEquipSlots() : void
      {
         this.UpdateEquip();
         this.UpdateBackpack();
         this.UpdateSlotsInfo();
         this.UpdatePropertyText();
      }
      
      public function Reset() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:TUISlot = null;
         var _loc4_:Boolean = false;
         var _loc5_:uint = 0;
         this.FInventory = null;
         this.FTargetSlot = null;
         this.FSystemLanguage = null;
         this.FUIHero.Context = null;
         _loc2_ = CAPACITY_MC_Slots;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FUISlots[_loc1_];
            _loc3_.Context = null;
            _loc1_++;
         }
         _loc2_ = this.FRolesModelID.length;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc5_ = uint(this.FRolesModelID[_loc1_]);
            _loc4_ = CONST_COMMON.CheckMainHeroModelID(_loc5_,this.FCharacter.RoleSencePosition);
            if(!_loc4_)
            {
               SResourcesCore.TexturesModel.DeleteByIdentifier(_loc5_,true);
            }
            _loc1_++;
         }
         this.FRolesModelID.length = 0;
         _loc2_ = CAPACITY_MC_Talisman;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FEquipSlots[_loc1_];
            _loc3_.Context = null;
            _loc1_++;
         }
      }
   }
}

