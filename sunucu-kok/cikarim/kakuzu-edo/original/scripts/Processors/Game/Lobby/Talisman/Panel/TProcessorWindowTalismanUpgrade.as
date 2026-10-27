package Processors.Game.Lobby.Talisman.Panel
{
   import Components.ScrollBar.*;
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
   import Logics.Streamization.Inventories.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Talisman.TSingleEquip;
   import Processors.Game.Lobby.Utilities.*;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Processors.Game.Utilities.OverLayer.*;
   import Processors.Game.Windows.Information.*;
   import Resources.Constants.*;
   import Resources.Strings.*;
   import Utilities.UI.Windows.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class TProcessorWindowTalismanUpgrade extends TProcessorLobbyWindow
   {
      
      protected static const QUALITYCOLOR_INDEX:Vector.<uint> = CONST_COMMON.QUALITYCOLOR_INDEX;
      
      private var StringLevelVec:Vector.<String>;
      
      protected var FScene:MovieClip;
      
      protected var FTF_CostNum:TextField;
      
      protected var FTF_OwnNum:TextField;
      
      protected var FTF_NeedCost:TextField;
      
      protected var FTF_TalismanUpgrading:TextField;
      
      protected var FTF_TalismanUpgradingNext:TextField;
      
      protected var FBtn_Upgrade:TUIButton;
      
      protected var FMC_SingleEquipList:Vector.<TSingleEquip>;
      
      protected var FTF_OldProperty:TextField;
      
      protected var FTF_NewProperty:TextField;
      
      protected var FMC_UpgradeSlot:TUISlot;
      
      protected var FMC_Effect:MovieClip;
      
      protected var FMC_Arrow:MovieClip;
      
      protected var FTF_CurrentOwn:TextField;
      
      protected var FTF_UpgradeNum:TextField;
      
      protected var FMC_List:MovieClip;
      
      protected var FBin:TBins;
      
      protected var FRoleIndex:uint;
      
      protected var FInventories:TInventories;
      
      protected var FTCollectionInventory:TCollectionInventory;
      
      protected var FInitialized:Boolean;
      
      protected var FScrollBar:TScrollBar;
      
      protected var FCharacter:TCharacter;
      
      protected var FUIWindowCostGoldConfirmation:TUIWindowConfirmation;
      
      protected var FUIWindowRecharge:TUIWindowRecharge;
      
      protected var FCostGold:int;
      
      protected var FMC_FloatEffect:MovieClip;
      
      protected var FRandomNum:uint;
      
      protected var FUnstreamizerInventoryReference:TUnstreamizerInventoryReference;
      
      protected var FContext:Object;
      
      protected var FItemIndex:uint;
      
      protected var FIdentifier:uint;
      
      protected var FSystemLanguageBin:TBins;
      
      protected var FSystemLanguage:TSystemLanguage;
      
      protected var FTalismanNameList:Vector.<TextField>;
      
      protected var FUpgradePaperNum:uint;
      
      protected var FCostNum:uint;
      
      protected var FHaveNum:uint;
      
      protected var FItemName:String;
      
      protected var FTreasureName:String;
      
      protected var FHint:THint;
      
      protected var FSPNormal:Sprite;
      
      protected var FSPNormalInfo:Sprite;
      
      protected var FSPSpecial:Sprite;
      
      protected var FTFSpecialCurLevel:TextField;
      
      protected var FTFSpecialCurAttr0:TextField;
      
      protected var FTFSpecialCurAttr1:TextField;
      
      protected var FTFSpecialNextLevel:TextField;
      
      protected var FTFSpecialNextAttr0:TextField;
      
      protected var FTFSpecialNextAttr1:TextField;
      
      private var FProductId:int;
      
      protected var FOnUpgrade:Function;
      
      protected var FOnInventoryOver:Function;
      
      protected var FOnInventoryOut:Function;
      
      protected var FHintOnOver:Function;
      
      protected var FHintOnOut:Function;
      
      public function TProcessorWindowTalismanUpgrade(param1:TUIComponent)
      {
         super(param1);
         this.FUnstreamizerInventoryReference = new TUnstreamizerInventoryReference();
         this.FCharacter = SLogicsCore.Character;
         this.FTalismanNameList = new Vector.<TextField>(3);
         this.FInitialized = false;
         this.FHint = new THint();
         this.FProductId = 0;
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_TALISMAN.RESOURCESID_Swf_Talisman);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:int = 0;
         var _loc2_:uint = 0;
         var _loc3_:MovieClip = null;
         var _loc4_:TConfigValue = null;
         var _loc5_:TArticle = null;
         var _loc6_:uint = 0;
         super.ResourcesPerform_UIDispatch();
         this.StringLevelVec = TUtilityLobby.GetStringsByIdentifier(CONST_SYSTEMLANGUAGE.TALISMAN_STRING_33);
         this.FScene = TUtilityReflection.CreateDisplayObjectInstance("MC_Upgrade") as MovieClip;
         addChild(this.FScene);
         this.x = CONST_TALISMAN.POSX_MC_SCENE;
         this.y = CONST_TALISMAN.POSY_MC_SCENE;
         this.visible = false;
         this.FMC_SingleEquipList = new Vector.<TSingleEquip>();
         this.FBtn_Upgrade = new TUIButton();
         this.FBtn_Upgrade.Substrate = this.FScene["Btn_Upgrade"];
         this.FBtn_Upgrade.OnClick = this.FBtn_UpgradeClickHandler;
         this.FBtn_Upgrade.OnMove = this.FBtn_UpgradeMoveHandler;
         this.FBtn_Upgrade.OnOut = this.FBtn_UpgradeOutHandler;
         this.FSPNormal = this.FScene["SP_Normal"];
         this.FSPNormal.mouseChildren = false;
         this.FSPNormal.mouseEnabled = false;
         this.FTF_TalismanUpgrading = this.FSPNormal["TF_TalismanUpgrading"];
         this.FTF_TalismanUpgrading.mouseEnabled = false;
         this.FTF_TalismanUpgradingNext = this.FSPNormal["TF_TalismanUpgradingNext"];
         this.FTF_TalismanUpgradingNext.mouseEnabled = false;
         this.FTF_OldProperty = this.FSPNormal["TF_OldProperty"];
         this.FTF_OldProperty.mouseEnabled = false;
         this.FTF_NewProperty = this.FSPNormal["TF_NewProperty"];
         this.FTF_NewProperty.mouseEnabled = false;
         this.FSPNormal.visible = false;
         this.FSPSpecial = this.FScene["SP_Special"];
         this.FSPSpecial.mouseEnabled = false;
         this.FSPSpecial.mouseChildren = false;
         this.FTFSpecialCurLevel = this.FSPSpecial["TF_TalismanUpgrading"];
         this.FTFSpecialCurLevel.mouseEnabled = false;
         this.FTFSpecialCurAttr0 = this.FSPSpecial["TF_OldProperty_0"];
         this.FTFSpecialCurAttr0.mouseEnabled = false;
         this.FTFSpecialCurAttr1 = this.FSPSpecial["TF_OldProperty_1"];
         this.FTFSpecialCurAttr1.mouseEnabled = false;
         this.FTFSpecialNextLevel = this.FSPSpecial["TF_TalismanUpgradingNext"];
         this.FTFSpecialNextLevel.mouseEnabled = false;
         this.FTFSpecialNextAttr0 = this.FSPSpecial["TF_NewProperty_0"];
         this.FTFSpecialNextAttr0.mouseEnabled = false;
         this.FTFSpecialNextAttr1 = this.FSPSpecial["TF_NewProperty_1"];
         this.FTFSpecialNextAttr1.mouseEnabled = false;
         this.FSPSpecial.visible = false;
         this.FTF_CostNum = this.FScene["TF_CostNum"];
         this.FTF_CostNum.mouseEnabled = false;
         this.FTF_OwnNum = this.FScene["TF_OwnNum"];
         this.FTF_OwnNum.mouseEnabled = false;
         this.FTF_NeedCost = this.FScene["TF_NeedCost"];
         this.FTF_NeedCost.mouseEnabled = false;
         this.FSPNormalInfo = this.FScene["SP_NormalInfo"];
         this.FSPNormalInfo.mouseChildren = false;
         this.FSPNormalInfo.mouseEnabled = false;
         this.FTF_CurrentOwn = this.FSPNormalInfo["TF_CurrentOwn"];
         this.FTF_CurrentOwn.mouseEnabled = false;
         this.FTF_UpgradeNum = this.FSPNormalInfo["TF_UpgradeNum"];
         this.FTF_UpgradeNum.mouseEnabled = false;
         this.FMC_UpgradeSlot = new TUISlot(this);
         this.FMC_UpgradeSlot.Resource = this.FScene["MC_UpgradeSlot"] as Sprite;
         this.FMC_UpgradeSlot.SequenceDefaultIcon = SResourcesCore.TexturesLobby.GetAnimationSequenceByIdentifiers(CONST_LOBBY.RESOURCESID_Texture_SlotDefaultEffect,0);
         this.FMC_UpgradeSlot.OnQuerySequenceContext = this.SlotsOnBigQuerySequenceContext;
         this.FMC_UpgradeSlot.OnOver = this.SlotsOnMove;
         this.FMC_UpgradeSlot.OnOut = this.SlotsOnOut;
         this.FMC_UpgradeSlot.Init();
         this.FMC_FloatEffect = this.FScene["MC_FloatEffect"];
         _loc2_ = this.FTalismanNameList.length;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FTalismanNameList[_loc1_] = this.FScene["TF_TalismanName_" + _loc1_];
            _loc1_++;
         }
         this.FMC_Effect = this.FScene["MC_Effect"];
         this.FMC_Effect.visible = false;
         this.FMC_List = this.FScene["mc_list"];
         this.FScrollBar = new TScrollBar(this.FMC_List,343,false,1);
         this.FUIWindowCostGoldConfirmation = SUtilityOverLayer.UIWindowConfirmation;
         this.FUIWindowRecharge = SUtilityOverLayer.UIWindowRecharge;
         _loc4_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.KILL_UPGRADE_ITEM) as TConfigValue;
         _loc6_ = _loc4_.Value as uint;
         _loc5_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_Article,_loc6_) as TArticle;
         this.FItemName = _loc5_.Name;
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
         var _loc2_:uint = 0;
         super.LogicsPerform();
         if(!this.Visible)
         {
            return;
         }
         if(this.FInitialized == true)
         {
            this.FMC_UpgradeSlot.Update();
            _loc2_ = this.FMC_SingleEquipList.length;
            _loc1_ = 0;
            while(_loc1_ < _loc2_)
            {
               this.FMC_SingleEquipList[_loc1_].UpdateSingleEquip();
               _loc1_++;
            }
            this.FMC_FloatEffect.play();
         }
      }
      
      protected function SetEquipInfo() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:int = 0;
         var _loc3_:TSingleEquip = null;
         var _loc4_:TInventory = null;
         var _loc5_:TEquipment = null;
         var _loc6_:String = null;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         var _loc10_:uint = 0;
         var _loc11_:String = null;
         _loc9_ = uint(this.FCharacter.Heros.Count);
         _loc10_ = _loc9_ - 1;
         if(this.FRoleIndex > _loc10_)
         {
            this.FInventories = this.FCharacter.Treasures;
            _loc1_ = uint(this.FCharacter.Treasures.Count);
            _loc2_ = 0;
            while(_loc2_ < _loc1_)
            {
               _loc5_ = this.FInventories.GetInventoryByIndex(_loc2_) as TEquipment;
               if(_loc5_ != null)
               {
                  _loc3_ = this.FMC_SingleEquipList[_loc2_];
                  if(_loc3_ != null)
                  {
                     _loc6_ = _loc5_.Name;
                     _loc7_ = _loc5_.UpgradingLevel;
                     _loc8_ = _loc5_.Quality;
                     _loc11_ = _loc5_.RequirementLevel >= 100 ? this.GetLevelStringName(_loc7_) : TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TALISMAN_STRING_14) + _loc7_;
                     _loc3_.SetEquip(_loc5_,_loc6_,_loc11_,_loc8_);
                     if(_loc5_.Identifier == this.FIdentifier)
                     {
                        _loc3_.OnSelect();
                     }
                  }
               }
               _loc2_++;
            }
         }
         else
         {
            this.FTCollectionInventory = this.FCharacter.Heros.GetHeroByIndex(this.FRoleIndex).TalismansMounted;
            this.FInventories = this.FCharacter.Inventories;
            this.FInventories.Clear();
            _loc1_ = CONST_TALISMAN.CAPACITY_TalismanNum;
            _loc2_ = 0;
            while(_loc2_ < _loc1_)
            {
               _loc4_ = this.FTCollectionInventory.GetInventoryByIndex(_loc2_);
               if(_loc4_ != null)
               {
                  this.FInventories.Add(_loc4_);
               }
               _loc2_++;
            }
            _loc1_ = uint(this.FInventories.Count);
            _loc2_ = 0;
            while(_loc2_ < _loc1_)
            {
               _loc5_ = this.FInventories.GetInventoryByIndex(_loc2_) as TEquipment;
               if(_loc5_ != null)
               {
                  _loc3_ = this.FMC_SingleEquipList[_loc2_];
                  if(_loc3_ != null)
                  {
                     _loc6_ = _loc5_.Name;
                     _loc7_ = _loc5_.UpgradingLevel;
                     _loc8_ = _loc5_.Quality;
                     _loc11_ = _loc5_.RequirementLevel >= 100 ? this.GetLevelStringName(_loc7_) : TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TALISMAN_STRING_14) + _loc7_;
                     _loc3_.SetEquip(_loc5_,_loc6_,_loc11_,_loc8_);
                     if(_loc5_.CategorySecond == this.FIdentifier)
                     {
                        _loc3_.OnSelect();
                     }
                  }
               }
               _loc2_++;
            }
            this.FInventories.Clear();
         }
      }
      
      protected function UpdateEquip() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:* = 0;
         var _loc3_:TSingleEquip = null;
         var _loc4_:TEquipment = null;
         var _loc5_:String = null;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         var _loc10_:uint = 0;
         var _loc11_:String = null;
         this.FScrollBar.Clear();
         _loc10_ = 0;
         _loc8_ = uint(this.FCharacter.Heros.Count);
         _loc9_ = _loc8_ - 1;
         _loc11_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TALISMAN_STRING_14);
         _loc1_ = this.FMC_SingleEquipList.length;
         _loc2_ = int(_loc1_ - 1);
         while(_loc2_ > -1)
         {
            _loc3_ = this.FMC_SingleEquipList[_loc2_];
            _loc3_.StubReferences.Dereference(this);
            _loc2_--;
         }
         this.FMC_SingleEquipList.length = 0;
         if(this.FRoleIndex > _loc9_)
         {
            _loc1_ = uint(this.FCharacter.Treasures.Count);
         }
         else
         {
            _loc1_ = CONST_TALISMAN.CAPACITY_TalismanNum;
         }
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            if(this.FRoleIndex > _loc9_)
            {
               _loc4_ = this.FCharacter.Treasures.GetInventoryByIndex(_loc2_) as TEquipment;
            }
            else
            {
               _loc4_ = this.FCharacter.Heros.GetHeroByIndex(this.FRoleIndex).TalismansMounted.GetInventoryByIndex(_loc2_) as TEquipment;
            }
            if(_loc4_ != null)
            {
               _loc5_ = _loc4_.Name;
               _loc6_ = _loc4_.UpgradingLevel;
               _loc7_ = _loc4_.Quality;
               _loc3_ = SLogicsCore.PoolUISingleEquipment.AcquireUISingleEquipment(this);
               _loc3_.StubReferences.Reference(this);
               _loc3_.OnClick = this.SingleEquipOnClick;
               _loc3_.OnQuerySequenceContext = this.SlotsOnQuerySequenceContext;
               _loc3_.OnQueryEuqipLevel = this.SlotsOnQueryEuqipLevel;
               _loc3_.OnOut = this.SlotsOnOut;
               _loc3_.OnOver = this.SlotsOnMove;
               this.FMC_SingleEquipList.push(_loc3_);
               _loc11_ = _loc4_.RequirementLevel >= 100 ? this.GetLevelStringName(_loc6_) : TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TALISMAN_STRING_14) + _loc6_;
               _loc3_.SetEquip(_loc4_,_loc5_,_loc11_,_loc7_);
               this.FScrollBar.AddItem(_loc3_);
               _loc10_++;
               if(_loc4_.Identifier == this.FIdentifier)
               {
                  _loc3_.OnSelect();
               }
            }
            _loc2_++;
         }
         if(_loc1_ < CONST_TALISMAN.CAPACITY_EQUIP || _loc1_ == 0)
         {
            _loc1_ = CONST_TALISMAN.CAPACITY_EQUIP;
            _loc2_ = 0;
            while(_loc2_ < _loc1_ - _loc10_)
            {
               _loc3_ = SLogicsCore.PoolUISingleEquipment.AcquireUISingleEquipment(this);
               this.FScrollBar.AddItem(_loc3_);
               _loc2_++;
            }
         }
      }
      
      protected function UpdateText() : void
      {
         var _loc1_:int = 0;
         var _loc2_:uint = 0;
         var _loc3_:TInventories = null;
         this.FTF_OldProperty.text = "";
         this.FTF_NewProperty.text = "";
         this.FTF_CostNum.text = "";
         this.FTF_OwnNum.text = "";
         this.FTF_NeedCost.textColor = 15518068;
         this.FSPNormal.visible = true;
         this.FSPSpecial.visible = false;
         this.FTF_TalismanUpgrading.text = "";
         this.FTF_TalismanUpgradingNext.text = "";
         _loc2_ = this.FTalismanNameList.length;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FTalismanNameList[_loc1_].text = "";
            _loc1_++;
         }
         _loc3_ = SLogicsCore.Character.Appliances;
         if(_loc3_.Count > 0)
         {
            this.FUpgradePaperNum = _loc3_.GetCountByTempleteID(CONST_TALISMAN.TALISMAN_UpgradePaper);
         }
         this.FSPNormalInfo.visible = true;
         this.FTF_CurrentOwn.text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TALISMAN_STRING_25);
         this.FTF_UpgradeNum.text = "x " + this.FUpgradePaperNum.toString();
      }
      
      protected function UpdateBtn() : void
      {
         this.FBtn_Upgrade.Enabled = false;
         this.FMC_UpgradeSlot.Context = null;
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         super.ResourcesPerform_UILocations();
      }
      
      protected function FBtn_UpgradeClickHandler(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TEquipment = null;
         var _loc4_:uint = 0;
         var _loc5_:Vector.<String> = null;
         var _loc6_:String = null;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:MovieClip = null;
         var _loc10_:String = null;
         var _loc11_:THero = null;
         var _loc12_:uint = 0;
         if(this.FCostGold > this.FCharacter.CreditGold)
         {
            this.FUIWindowRecharge.visible = true;
            return;
         }
         _loc10_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TALISMAN_STRING_17);
         _loc9_ = param2.currentTarget as MovieClip;
         if(_loc9_.currentFrameLabel == "Disable")
         {
            return;
         }
         _loc3_ = this.FContext as TEquipment;
         if(this.FRoleIndex > this.FCharacter.Heros.Count - 1)
         {
            this.FIdentifier = _loc3_.Identifier;
         }
         else
         {
            this.FIdentifier = _loc3_.CategorySecond;
         }
         if(this.FHaveNum < this.FCostNum)
         {
            if(this.FUpgradePaperNum > this.FCostNum)
            {
               _loc4_ = this.FCostNum - this.FHaveNum;
            }
            else
            {
               _loc4_ = this.FUpgradePaperNum;
            }
            _loc5_ = this.CostItems();
            _loc6_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TALISMAN_STRING_18);
            _loc8_ = _loc5_.length;
            _loc7_ = 0;
            while(_loc7_ < _loc8_)
            {
               switch(_loc5_[_loc7_])
               {
                  case this.FTreasureName:
                     _loc6_ += this.FTreasureName + "*" + this.FHaveNum + " ";
                     break;
                  case this.FItemName:
                     _loc6_ += this.FItemName + "*" + _loc4_ + " ";
                     break;
                  case _loc10_:
                     _loc6_ += "\n" + _loc10_ + "*" + this.FCostGold + " ";
               }
               _loc7_++;
            }
            this.FUIWindowCostGoldConfirmation.Text = _loc6_;
            this.FUIWindowCostGoldConfirmation.OnOK = this.CostConfirm;
            this.FUIWindowCostGoldConfirmation.Visible = true;
            return;
         }
         _loc12_ = 0;
         if(this.FRoleIndex <= this.FCharacter.Heros.Count - 1)
         {
            _loc11_ = this.FCharacter.Heros.GetHeroByIndex(this.FRoleIndex);
            _loc12_ = _loc11_.Identifier;
         }
         this.FOnUpgrade(this,_loc12_,this.FContext);
         this.SetBtnLock(false);
         this.FMC_Effect.visible = true;
         this.FMC_Effect.play();
      }
      
      private function FBtn_UpgradeOutHandler(param1:Object, param2:MouseEvent) : void
      {
         if(this.FHintOnOut != null)
         {
            this.FHintOnOut(this,this.FHint);
         }
      }
      
      private function FBtn_UpgradeMoveHandler(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TEquipment = null;
         _loc3_ = this.FContext as TEquipment;
         this.FHint.Caption = _loc3_.RequirementLevel < 100 ? TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TALISMAN_STRING_19) : TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TALISMAN_STRING_42);
         if(this.FHintOnOver != null)
         {
            this.FHintOnOver(this,this.FHint);
         }
      }
      
      protected function CostItems() : Vector.<String>
      {
         var _loc1_:TTreasureUpgrade = null;
         var _loc2_:TEquipment = null;
         var _loc3_:Vector.<String> = null;
         _loc2_ = this.FContext as TEquipment;
         _loc1_ = this.FBin.GetDatebaseByIdentifier(this.GetUpgradingValue(_loc2_.IDTemplate,_loc2_.UpgradingLevel + 1)) as TTreasureUpgrade;
         _loc3_ = new Vector.<String>();
         if(this.FHaveNum > 0)
         {
            _loc3_.push(this.FTreasureName);
         }
         if(_loc1_.CostItemCount > 0 && this.FUpgradePaperNum > 0)
         {
            _loc3_.push(this.FItemName);
         }
         if(this.FCostGold > 0)
         {
            _loc3_.push(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TALISMAN_STRING_17));
         }
         return _loc3_;
      }
      
      protected function CostConfirm(param1:Object) : void
      {
         var _loc2_:THero = null;
         var _loc3_:uint = 0;
         if(this.FCharacter.CreditGold < this.FCostGold)
         {
            EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.NOTENOUGH_Gold));
            return;
         }
         _loc3_ = 0;
         if(this.FRoleIndex <= this.FCharacter.Heros.Count - 1)
         {
            _loc2_ = this.FCharacter.Heros.GetHeroByIndex(this.FRoleIndex);
            _loc3_ = _loc2_.Identifier;
         }
         this.FOnUpgrade(this,_loc3_,this.FContext);
         this.FMC_Effect.visible = true;
         this.FMC_Effect.play();
      }
      
      protected function SingleEquipOnClick(param1:Object, param2:Object) : void
      {
         var _loc3_:TEquipment = null;
         var _loc4_:TTreasureUpgrade = null;
         var _loc5_:TTreasureUpgrade = null;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:Vector.<int> = null;
         var _loc9_:uint = 0;
         var _loc10_:TBaseEquip = null;
         var _loc11_:Vector.<int> = null;
         var _loc12_:Vector.<int> = null;
         var _loc13_:uint = 0;
         var _loc14_:uint = 0;
         var _loc15_:uint = 0;
         var _loc16_:int = 0;
         var _loc17_:uint = 0;
         var _loc18_:TSingleEquip = null;
         var _loc19_:TSingleEquip = null;
         var _loc20_:TEquipment = null;
         var _loc21_:Vector.<int> = null;
         var _loc22_:uint = 0;
         var _loc23_:TInventories = null;
         var _loc24_:TEquipment = null;
         var _loc25_:Vector.<uint> = null;
         var _loc26_:Vector.<String> = null;
         var _loc27_:Boolean = false;
         var _loc28_:TInventory = null;
         _loc25_ = new Vector.<uint>();
         _loc23_ = new TInventories();
         this.FContext = param2 as TInventory;
         _loc3_ = param2 as TEquipment;
         _loc18_ = param1 as TSingleEquip;
         _loc27_ = false;
         _loc13_ = _loc3_.IDTemplate;
         _loc22_ = _loc3_.UpgradingLevel;
         _loc6_ = _loc22_ + 1;
         _loc4_ = this.FBin.GetDatebaseByIdentifier(this.GetUpgradingValue(_loc3_.IDTemplate,_loc22_)) as TTreasureUpgrade;
         _loc5_ = this.FBin.GetDatebaseByIdentifier(this.GetUpgradingValue(_loc3_.IDTemplate,_loc6_)) as TTreasureUpgrade;
         _loc27_ = _loc5_ != null;
         if(!_loc27_)
         {
            _loc18_.BSelect = false;
            this.FSystemLanguage = this.FSystemLanguageBin.GetDatebaseByIdentifier(CONST_SYSTEMLANGUAGE.TALISMAN_STRING_13) as TSystemLanguage;
            EffectGenerateText(this.FSystemLanguage.Desc);
            return;
         }
         _loc21_ = _loc4_.AddValue;
         _loc14_ = _loc5_.Itemid;
         _loc15_ = _loc5_.Level;
         _loc7_ = _loc5_.CostItemCount;
         _loc8_ = _loc5_.AddValue;
         _loc25_.push(_loc14_);
         this.FUnstreamizerInventoryReference.UnstreamizeGenerateInventoriesByIdentifiers(null,_loc23_,_loc25_);
         _loc24_ = _loc23_.GetInventoryByTempletID(_loc14_) as TEquipment;
         _loc24_.UpgradingLevel = _loc15_;
         _loc17_ = _loc8_.length;
         _loc24_.UpgradingBasisProperty.length = 0;
         _loc16_ = 0;
         while(_loc16_ < _loc17_)
         {
            _loc24_.UpgradingBasisProperty.push(_loc8_[_loc16_]);
            _loc16_++;
         }
         _loc17_ = this.FMC_SingleEquipList.length;
         _loc16_ = 0;
         while(_loc16_ < _loc17_)
         {
            _loc19_ = this.FMC_SingleEquipList[_loc16_];
            if(_loc18_ != _loc19_ && _loc19_.BClick)
            {
               _loc19_.BClick = false;
               break;
            }
            _loc16_++;
         }
         _loc18_.BSelect = true;
         this.FMC_UpgradeSlot.Context = _loc3_;
         _loc11_ = _loc3_.BasisProperty;
         _loc12_ = _loc3_.BasisPropertyCategory;
         if(_loc3_.RequirementLevel < 100)
         {
            this.FSPNormalInfo.visible = true;
            this.FSPNormal.visible = true;
            this.FSPSpecial.visible = false;
            _loc9_ = 0;
            _loc17_ = uint(this.FCharacter.Treasures.Count);
            _loc16_ = 0;
            while(_loc16_ < _loc17_)
            {
               _loc20_ = this.FCharacter.Treasures.GetInventoryByIndex(_loc16_) as TEquipment;
               if(_loc20_ != _loc3_ && _loc20_.IDTemplate == _loc3_.IDTemplate && _loc20_.UpgradingLevel == 0)
               {
                  _loc9_++;
               }
               _loc16_++;
            }
            this.FCostGold = _loc5_.CostGold * (_loc7_ - (_loc9_ + this.FUpgradePaperNum));
            if(this.FCostGold < 0)
            {
               this.FCostGold = 0;
            }
            _loc26_ = TUtilityLobby.GetStringsByIdentifier(CONST_SYSTEMLANGUAGE.TALISMAN_STRING_21);
            this.FTF_OldProperty.text = _loc26_[_loc3_.CategorySecond - 7] + (_loc11_[0] + _loc21_[0]);
            this.FTF_NewProperty.text = _loc26_[_loc3_.CategorySecond - 7] + (_loc11_[0] + _loc8_[0]);
            if(_loc7_ <= _loc9_ + this.FUpgradePaperNum)
            {
               this.FTF_NeedCost.textColor = CONST_COMMON.TEXT_Green_Color;
               this.FTF_CostNum.textColor = CONST_COMMON.TEXT_Green_Color;
            }
            else
            {
               this.FTF_NeedCost.textColor = CONST_COMMON.TEXT_Red_Color;
               this.FTF_CostNum.textColor = CONST_COMMON.TEXT_Red_Color;
            }
            _loc17_ = this.FTalismanNameList.length;
            _loc16_ = 0;
            while(_loc16_ < _loc17_)
            {
               this.FTalismanNameList[_loc16_].text = _loc3_.Name;
               this.FTalismanNameList[_loc16_].textColor = QUALITYCOLOR_INDEX[_loc3_.Quality];
               _loc16_++;
            }
            this.FTreasureName = _loc3_.Name;
            this.FCostNum = _loc7_;
            this.FHaveNum = _loc9_;
            this.FTF_CostNum.text = "x " + _loc7_;
            this.FTF_OwnNum.text = "x " + _loc9_;
            this.FTF_NeedCost.text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TALISMAN_STRING_16);
            this.FTF_TalismanUpgrading.text = "Lv." + _loc22_;
            this.FTF_TalismanUpgradingNext.text = "Lv." + (_loc22_ + 1);
         }
         else
         {
            this.FSPNormalInfo.visible = false;
            this.FSPNormal.visible = false;
            this.FSPSpecial.visible = true;
            _loc28_ = this.ProductInventory;
            _loc9_ = uint(this.ProductNum);
            this.FCostGold = _loc5_.CostGold * (_loc5_.CostStoneCount - _loc9_);
            if(this.FCostGold < 0)
            {
               this.FCostGold = 0;
            }
            _loc26_ = TUtilityLobby.GetStringsByIdentifier(CONST_SYSTEMLANGUAGE.TALISMAN_STRING_21);
            this.FTFSpecialCurAttr0.text = TUtilityLobby.GetBaseAttributeNameByType(_loc12_[0]) + (_loc11_[0] + _loc21_[0]);
            this.FTFSpecialCurAttr1.text = TUtilityLobby.GetBaseAttributeNameByType(_loc12_[1]) + (_loc11_[1] + _loc21_[1]);
            this.FTFSpecialNextAttr0.text = TUtilityLobby.GetBaseAttributeNameByType(_loc12_[0]) + (_loc11_[0] + _loc8_[0]);
            this.FTFSpecialNextAttr1.text = TUtilityLobby.GetBaseAttributeNameByType(_loc12_[1]) + (_loc11_[1] + _loc8_[1]);
            if(_loc9_ >= _loc5_.CostStoneCount)
            {
               this.FTF_NeedCost.textColor = CONST_COMMON.TEXT_Green_Color;
               this.FTF_CostNum.textColor = CONST_COMMON.TEXT_Green_Color;
            }
            else
            {
               this.FTF_NeedCost.textColor = CONST_COMMON.TEXT_Red_Color;
               this.FTF_CostNum.textColor = CONST_COMMON.TEXT_Red_Color;
            }
            this.FTalismanNameList[0].text = _loc3_.Name;
            this.FTalismanNameList[1].text = _loc28_.Name;
            this.FTalismanNameList[2].text = _loc28_.Name;
            this.FTreasureName = _loc28_.Name;
            this.FCostNum = _loc5_.CostStoneCount;
            this.FHaveNum = _loc9_;
            this.FTF_CostNum.text = "x " + _loc5_.CostStoneCount;
            this.FTF_OwnNum.text = "x " + _loc9_;
            this.FTF_NeedCost.text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TALISMAN_STRING_16);
            this.FTFSpecialCurLevel.text = this.GetLevelStringName(_loc22_);
            this.FTFSpecialNextLevel.text = this.GetLevelStringName(_loc22_ + 1);
         }
         this.FBtn_Upgrade.Enabled = true;
      }
      
      private function GetUpgradingValue(param1:uint, param2:int) : uint
      {
         return Math.floor(param1 % 1000) * 1000 + param2;
      }
      
      protected function SlotsOnMove(param1:Object, param2:TInventory) : void
      {
         if(this.FOnInventoryOver != null)
         {
            this.FOnInventoryOver(this,param2,null);
         }
      }
      
      protected function SlotsOnOut(param1:Object, param2:TInventory) : void
      {
         if(this.FOnInventoryOut != null)
         {
            this.FOnInventoryOut(this,param2,null);
         }
      }
      
      protected function SlotsOnBigQuerySequenceContext(param1:Object, param2:Object, param3:TQueryAnimationSequence, param4:uint = 0) : void
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
      
      private function GetLevelStringName(param1:int) : String
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         _loc2_ = Math.floor(param1 / 10);
         _loc3_ = Math.floor(param1 % 10) + 1;
         return this.StringLevelVec[_loc2_] + TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TALISMAN_STRING_34),_loc3_);
      }
      
      public function get Bin() : TBins
      {
         return this.FBin;
      }
      
      public function set Bin(param1:TBins) : void
      {
         this.FBin = param1;
      }
      
      public function get OnUpgrade() : Function
      {
         return this.FOnUpgrade;
      }
      
      public function set OnUpgrade(param1:Function) : void
      {
         this.FOnUpgrade = param1;
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
      
      public function get HintOnOut() : Function
      {
         return this.FHintOnOut;
      }
      
      public function set HintOnOut(param1:Function) : void
      {
         this.FHintOnOut = param1;
      }
      
      public function get HintOnOver() : Function
      {
         return this.FHintOnOver;
      }
      
      public function set HintOnOver(param1:Function) : void
      {
         this.FHintOnOver = param1;
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
      
      private function get ProductInventory() : TInventory
      {
         var _loc1_:TInventory = null;
         var _loc2_:TInventories = null;
         _loc1_ = SLogicsCore.Character.Appliances.GetInventoryByTempletID(this.ProductId);
         if(_loc1_ == null)
         {
            _loc2_ = new TInventories();
            SToolReward.GetInventoryByID(this.ProductId,_loc2_);
            _loc1_ = _loc2_.GetInventoryByIndex(0);
            _loc1_.Quantity = 0;
         }
         return _loc1_;
      }
      
      private function get ProductNum() : int
      {
         return SLogicsCore.Character.Appliances.GetInventoryAllNumByTempletID(this.ProductId);
      }
      
      public function Update(param1:uint, param2:uint = 0) : void
      {
         this.FRoleIndex = param1;
         this.FItemIndex = param2;
         this.FRandomNum = Math.floor(Math.random() * 3);
         this.Reset();
         this.UpdateBtn();
         this.UpdateText();
         this.UpdateEquip();
         this.FMC_FloatEffect.play();
      }
      
      public function UpdateUpgradeEquip() : void
      {
         this.UpdateBtn();
         this.UpdateText();
         this.SetEquipInfo();
      }
      
      public function Reset() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TSingleEquip = null;
         this.FCostGold = 0;
         this.FRandomNum = 0;
         this.FContext = null;
         this.FItemIndex = 0;
         this.FUpgradePaperNum = 0;
         this.FSystemLanguage = null;
         this.FMC_UpgradeSlot.Context = null;
         _loc2_ = int(this.FMC_SingleEquipList.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FMC_SingleEquipList[_loc1_];
            _loc3_.Release();
            _loc3_.StubReferences.Dereference(this);
            _loc1_++;
         }
         this.FMC_FloatEffect.stop();
      }
      
      public function SetBtnLock(param1:Boolean) : void
      {
         this.FBtn_Upgrade.Enabled = param1;
      }
   }
}

