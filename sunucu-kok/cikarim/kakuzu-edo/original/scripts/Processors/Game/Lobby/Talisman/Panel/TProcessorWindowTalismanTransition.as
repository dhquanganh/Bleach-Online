package Processors.Game.Lobby.Talisman.Panel
{
   import Components.ScrollBar.*;
   import Components.Slots.*;
   import Components.Standard.*;
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
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class TProcessorWindowTalismanTransition extends TProcessorLobbyWindow
   {
      
      protected static const QUALITYCOLOR_INDEX:Vector.<uint> = CONST_COMMON.QUALITYCOLOR_INDEX;
      
      protected const CAPACITY_MC_EquipTransitiont:uint = 3;
      
      protected var FScene:MovieClip;
      
      protected var FMC_SingleEquipList:Vector.<TSingleEquip>;
      
      protected var FMC_EquipTransitionList:Vector.<MovieClip>;
      
      protected var FMC_EffectList:Vector.<MovieClip>;
      
      protected var FMC_EquipTransitionSlotList:Vector.<TUISlot>;
      
      protected var FBtn_Transition:TUIButton;
      
      protected var FMC_TransitionSlot:TUISlot;
      
      protected var FRoleIndex:uint;
      
      protected var FTransitionSlot:TUISlot;
      
      protected var FTF_NeedCost:TextField;
      
      protected var FTF_TransitionPaper:TextField;
      
      protected var FTF_CostNum:TextField;
      
      protected var FMC_List:MovieClip;
      
      protected var FInitialized:Boolean;
      
      protected var FScrollBar:TScrollBar;
      
      protected var FTF_TalismanNameBefore:TextField;
      
      protected var FTF_PropertyValueBefore:TextField;
      
      protected var FTF_TalismanName:TextField;
      
      protected var FTF_PropertyValue:TextField;
      
      protected var FTF_CurrentTranistionPaperName:TextField;
      
      protected var FTF_CurrentNum:TextField;
      
      protected var FTransitionPaperNum:uint;
      
      protected var FMC_FloatEffect:MovieClip;
      
      protected var FIndex:uint;
      
      protected var FUnstreamizerInventoryReference:TUnstreamizerInventoryReference;
      
      protected var FBin:Vector.<TArticle>;
      
      protected var FSystemLanguageBin:TBins;
      
      protected var FSystemLanguage:TSystemLanguage;
      
      protected var FCharacter:TCharacter;
      
      protected var FOnClick:Function;
      
      protected var FOnInventoryOver:Function;
      
      protected var FOnInventoryOut:Function;
      
      public function TProcessorWindowTalismanTransition(param1:TUIComponent)
      {
         super(param1);
         this.FInitialized = false;
         this.FBin = new Vector.<TArticle>();
         this.FUnstreamizerInventoryReference = new TUnstreamizerInventoryReference();
         this.FMC_SingleEquipList = new Vector.<TSingleEquip>();
         this.FMC_EquipTransitionList = new Vector.<MovieClip>();
         this.FMC_EquipTransitionSlotList = new Vector.<TUISlot>();
         this.FMC_EffectList = new Vector.<MovieClip>();
         this.FCharacter = SLogicsCore.Character;
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_TALISMAN.RESOURCESID_Swf_Talisman);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:int = 0;
         var _loc3_:MovieClip = null;
         var _loc4_:TUISlot = null;
         super.ResourcesPerform_UIDispatch();
         this.FScene = TUtilityReflection.CreateDisplayObjectInstance("MC_Transition") as MovieClip;
         addChild(this.FScene);
         this.x = CONST_TALISMAN.POSX_MC_SCENE;
         this.y = CONST_TALISMAN.POSY_MC_SCENE;
         this.visible = false;
         this.FBtn_Transition = new TUIButton();
         this.FBtn_Transition.Substrate = this.FScene["Btn_Transition"];
         this.FBtn_Transition.OnClick = this.FBtn_TransitionClickHandler;
         this.FTF_TransitionPaper = this.FScene["TF_TransitionPaper"];
         this.FTF_TransitionPaper.mouseEnabled = false;
         this.FTF_NeedCost = this.FScene["TF_NeedCost"];
         this.FTF_NeedCost.mouseEnabled = false;
         this.FTF_CostNum = this.FScene["TF_CostNum"];
         this.FTF_CostNum.mouseEnabled = false;
         this.FTF_TalismanNameBefore = this.FScene["TF_TalismanNameBefore"];
         this.FTF_TalismanNameBefore.mouseEnabled = false;
         this.FTF_PropertyValueBefore = this.FScene["TF_PropertyValueBefore"];
         this.FTF_PropertyValueBefore.mouseEnabled = false;
         this.FTF_TalismanName = this.FScene["TF_TalismanName"];
         this.FTF_TalismanName.mouseEnabled = false;
         this.FTF_PropertyValue = this.FScene["TF_PropertyValue"];
         this.FTF_PropertyValue.mouseEnabled = false;
         this.FTF_CurrentTranistionPaperName = this.FScene["CurTransitionPaper"];
         this.FTF_CurrentTranistionPaperName.mouseEnabled = false;
         this.FTF_CurrentNum = this.FScene["TF_CurrentNum"];
         this.FTF_CurrentNum.mouseEnabled = false;
         this.FMC_TransitionSlot = new TUISlot(this);
         this.FMC_TransitionSlot.Resource = this.FScene["MC_TransitionSlot"] as Sprite;
         this.FMC_TransitionSlot.SequenceDefaultIcon = SResourcesCore.TexturesLobby.GetAnimationSequenceByIdentifiers(CONST_LOBBY.RESOURCESID_Texture_SlotDefaultEffect,0);
         this.FMC_TransitionSlot.OnQuerySequenceContext = this.SlotsOnQuerySequenceContext;
         this.FMC_TransitionSlot.OnOver = this.SlotsOnMove;
         this.FMC_TransitionSlot.OnOut = this.SlotsOnOut;
         this.FMC_TransitionSlot.Init();
         this.FMC_List = this.FScene["mc_list"];
         this.FMC_FloatEffect = this.FScene["MC_FloatEffect"];
         _loc1_ = 3;
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = this.FScene["MC_EquipTransition_" + _loc2_];
            _loc3_.addEventListener(MouseEvent.CLICK,this.EquipTransitionOnClick);
            _loc3_.buttonMode = true;
            this.FMC_EquipTransitionList[_loc2_] = _loc3_;
            this.FMC_EffectList[_loc2_] = _loc3_["MC_Effect"];
            _loc4_ = new TUISlot(this);
            _loc4_.Resource = _loc3_["MC_Slot"] as Sprite;
            _loc4_.SequenceDefaultIcon = SResourcesCore.TexturesLobby.GetAnimationSequenceByIdentifiers(CONST_LOBBY.RESOURCESID_Texture_SlotDefaultEffect,0);
            _loc4_.Tag = _loc2_;
            _loc4_.OnQuerySequenceContext = this.SlotsOnQuerySequenceContext;
            _loc4_.OnOver = this.SlotsOnMove;
            _loc4_.OnOut = this.SlotsOnOut;
            _loc4_.Init();
            this.FMC_EquipTransitionSlotList[_loc2_] = _loc4_;
            _loc2_++;
         }
         this.FScrollBar = new TScrollBar(this.FMC_List,343,false,1);
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
            _loc2_ = int(this.FMC_EquipTransitionSlotList.length);
            _loc1_ = 0;
            while(_loc1_ < _loc2_)
            {
               _loc3_ = this.FMC_EquipTransitionSlotList[_loc1_];
               _loc3_.Update();
               _loc1_++;
            }
            this.FMC_TransitionSlot.Update();
            _loc2_ = int(this.FMC_SingleEquipList.length);
            _loc1_ = 0;
            while(_loc1_ < _loc2_)
            {
               this.FMC_SingleEquipList[_loc1_].UpdateSingleEquip();
               _loc1_++;
            }
            if(this.FMC_EffectList[this.FIndex].currentFrame == this.FMC_EffectList[this.FIndex].totalFrames)
            {
               this.FMC_EffectList[this.FIndex].gotoAndStop(1);
               this.SendMessage();
            }
         }
      }
      
      protected function UpdateEquip() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:* = 0;
         var _loc3_:TSingleEquip = null;
         var _loc4_:MovieClip = null;
         var _loc5_:TUISlot = null;
         this.FScrollBar.Clear();
         _loc1_ = this.FMC_EquipTransitionList.length;
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            _loc4_ = this.FMC_EquipTransitionList[_loc2_];
            _loc4_.gotoAndStop(CONST_TALISMAN.MC_Frame_Normal);
            _loc5_ = this.FMC_EquipTransitionSlotList[_loc2_];
            _loc5_.Context = null;
            _loc5_.Resource.visible = false;
            _loc2_++;
         }
         _loc1_ = this.FMC_SingleEquipList.length;
         _loc2_ = int(_loc1_ - 1);
         while(_loc2_ > -1)
         {
            _loc3_ = this.FMC_SingleEquipList[_loc2_];
            this.FMC_SingleEquipList.pop();
            _loc3_.StubReferences.Dereference(this);
            _loc2_--;
         }
         this.FMC_SingleEquipList.length = 0;
         this.FBtn_Transition.Enabled = false;
         this.FMC_TransitionSlot.Context = null;
         this.FMC_TransitionSlot.Resource.visible = false;
      }
      
      protected function UpdateBackpack() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:int = 0;
         var _loc3_:TSingleEquip = null;
         var _loc4_:TEquipment = null;
         var _loc5_:String = null;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         var _loc10_:uint = 0;
         var _loc11_:String = null;
         _loc11_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TALISMAN_STRING_14);
         _loc8_ = uint(this.FCharacter.Heros.Count);
         _loc9_ = _loc8_ - 1;
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
               _loc3_.OnOut = this.SlotsOnOut;
               _loc3_.OnOver = this.SlotsOnMove;
               _loc3_.OnQuerySequenceContext = this.SlotsOnQuerySequenceContext;
               _loc3_.OnQueryEuqipLevel = this.SlotsOnQueryEuqipLevel;
               this.FMC_SingleEquipList.push(_loc3_);
               if(_loc4_.RequirementLevel < 100)
               {
                  _loc3_.SetEquip(_loc4_,_loc5_,_loc11_ + _loc6_,_loc7_);
                  this.FScrollBar.AddItem(_loc3_);
                  _loc10_++;
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
      
      protected function UpdateSlot(param1:Object) : void
      {
         var _loc2_:int = 0;
         var _loc3_:uint = 0;
         var _loc4_:TUISlot = null;
         var _loc5_:MovieClip = null;
         var _loc6_:TBins = null;
         var _loc7_:TInventories = null;
         var _loc8_:TInventory = null;
         var _loc9_:TArticle = null;
         var _loc10_:Vector.<uint> = null;
         this.FMC_TransitionSlot.Context = param1 as TInventory;
         this.FMC_TransitionSlot.Resource.visible = true;
         _loc7_ = new TInventories();
         _loc10_ = new Vector.<uint>();
         _loc8_ = param1 as TInventory;
         while(this.FBin.length > 0)
         {
            this.FBin.pop();
         }
         _loc6_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_Article);
         _loc3_ = uint(_loc6_.Count);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc9_ = _loc6_.GetDatebaseByIndex(_loc2_) as TArticle;
            if(_loc9_.MajorType == 4)
            {
               this.FBin.push(_loc9_);
            }
            _loc2_++;
         }
         _loc3_ = this.FBin.length;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc9_ = this.FBin[_loc2_];
            if(_loc9_.Identifier != _loc8_.IDTemplate && _loc9_.Level == _loc8_.RequirementLevel)
            {
               _loc10_.push(_loc9_.Identifier);
            }
            _loc2_++;
         }
         this.FUnstreamizerInventoryReference.UnstreamizeGenerateInventoriesByIdentifiers(null,_loc7_,_loc10_);
         _loc3_ = this.FMC_EquipTransitionList.length;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = this.FMC_EquipTransitionSlotList[_loc2_];
            _loc8_ = _loc7_.GetInventoryByIndex(_loc2_);
            _loc4_.Context = _loc8_;
            _loc4_.Resource.visible = true;
            _loc2_++;
         }
      }
      
      protected function UpdateText() : void
      {
         var _loc1_:TInventory = null;
         var _loc2_:TInventories = null;
         var _loc3_:int = 0;
         var _loc4_:uint = 0;
         this.FTF_TransitionPaper.text = "";
         this.FTF_CostNum.text = "";
         this.FTF_TalismanName.text = "";
         this.FTF_PropertyValue.text = "";
         this.FTF_TalismanNameBefore.text = "";
         this.FTF_PropertyValueBefore.text = "";
         _loc2_ = SLogicsCore.Character.Appliances;
         _loc4_ = uint(_loc2_.Count);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc1_ = _loc2_.GetInventoryByIndex(_loc3_);
            if(_loc1_.CategorySecond == CONST_INVENTORY.CATEGORYSECOND_TreasureTransform)
            {
               this.FTransitionPaperNum += _loc1_.Quantity;
            }
            _loc3_++;
         }
         this.FTF_CurrentTranistionPaperName.text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TALISMAN_STRING_26);
         this.FTF_CurrentNum.text = "x " + this.FTransitionPaperNum;
      }
      
      protected function SendMessage() : void
      {
         this.FOnClick(this,this.FMC_TransitionSlot.Context,this.FTransitionSlot.Context);
         this.SetBtnLock(false);
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         super.ResourcesPerform_UILocations();
      }
      
      protected function FBtn_TransitionClickHandler(param1:Object, param2:Event) : void
      {
         this.FMC_EffectList[this.FIndex].play();
      }
      
      protected function EquipTransitionOnClick(param1:Event) : void
      {
         var _loc2_:int = 0;
         var _loc3_:uint = 0;
         var _loc4_:MovieClip = null;
         var _loc5_:MovieClip = null;
         var _loc6_:int = 0;
         var _loc7_:Vector.<String> = null;
         var _loc8_:TUISlot = null;
         var _loc9_:TEquipment = null;
         _loc5_ = param1.currentTarget as MovieClip;
         _loc6_ = int(_loc5_.name.split("_")[2]);
         this.FIndex = _loc6_;
         this.FTransitionSlot = this.FMC_EquipTransitionSlotList[_loc6_];
         if(this.FTransitionSlot.Context == null)
         {
            return;
         }
         _loc5_.gotoAndStop(CONST_TALISMAN.MC_Frame_Selected);
         _loc3_ = this.FMC_EquipTransitionList.length;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = this.FMC_EquipTransitionList[_loc2_];
            if(_loc4_ != _loc5_ && _loc4_.currentFrame == CONST_TALISMAN.MC_Frame_Selected)
            {
               _loc4_.gotoAndStop(CONST_TALISMAN.MC_Frame_Normal);
               break;
            }
            _loc2_++;
         }
         if(this.FTransitionPaperNum > 0)
         {
            this.FTF_NeedCost.textColor = CONST_COMMON.TEXT_Green_Color;
            this.FTF_CostNum.textColor = CONST_COMMON.TEXT_Green_Color;
            this.FBtn_Transition.Enabled = true;
         }
         else
         {
            this.FTF_NeedCost.textColor = CONST_COMMON.TEXT_Red_Color;
            this.FTF_CostNum.textColor = CONST_COMMON.TEXT_Red_Color;
            this.FBtn_Transition.Enabled = false;
         }
         this.FTF_NeedCost.text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TALISMAN_STRING_16);
         this.FTF_CostNum.text = "x " + 1;
         this.FTF_TransitionPaper.text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TALISMAN_STRING_20);
         _loc7_ = TUtilityLobby.GetStringsByIdentifier(CONST_SYSTEMLANGUAGE.TALISMAN_STRING_21);
         _loc8_ = this.FMC_EquipTransitionSlotList[_loc6_];
         _loc9_ = _loc8_.Context as TEquipment;
         this.FTF_TalismanName.text = _loc9_.Name;
         this.FTF_TalismanName.textColor = CONST_COMMON.QUALITYCOLOR_INDEX[_loc9_.Quality];
         this.FTF_PropertyValue.text = _loc7_[_loc9_.CategorySecond - 7] + (_loc9_.BasisProperty[0] + (_loc9_.UpgradingBasisProperty.length > 0 ? _loc9_.UpgradingBasisProperty[0] : 0));
         _loc9_ = this.FMC_TransitionSlot.Context as TEquipment;
         this.FTF_TalismanNameBefore.text = _loc9_.Name;
         this.FTF_TalismanNameBefore.textColor = CONST_COMMON.QUALITYCOLOR_INDEX[_loc9_.Quality];
         this.FTF_PropertyValueBefore.text = _loc7_[_loc9_.CategorySecond - 7] + (_loc9_.BasisProperty[0] + (_loc9_.UpgradingBasisProperty.length > 0 ? _loc9_.UpgradingBasisProperty[0] : 0));
      }
      
      protected function ResetTextField() : void
      {
         this.FTF_NeedCost.text = "";
         this.FTF_CostNum.text = "";
         this.FTF_TransitionPaper.text = "";
         this.FTF_TalismanName.text = "";
         this.FTF_PropertyValue.text = "";
         this.FTF_TalismanNameBefore.text = "";
         this.FTF_PropertyValueBefore.text = "";
      }
      
      protected function SingleEquipOnClick(param1:Object, param2:Object) : void
      {
         var _loc3_:TUISlot = null;
         var _loc4_:TEquipment = null;
         var _loc5_:int = 0;
         var _loc6_:uint = 0;
         var _loc7_:THero = null;
         var _loc8_:TSingleEquip = null;
         var _loc9_:TSingleEquip = null;
         var _loc10_:uint = 0;
         _loc8_ = param1 as TSingleEquip;
         _loc4_ = param2 as TEquipment;
         _loc10_ = uint(this.FCharacter.Heros.Count);
         if(this.FRoleIndex < _loc10_)
         {
            _loc8_.BSelect = false;
            this.FSystemLanguage = this.FSystemLanguageBin.GetDatebaseByIdentifier(CONST_SYSTEMLANGUAGE.TALISMAN_STRING_11) as TSystemLanguage;
            EffectGenerateText(this.FSystemLanguage.Desc);
            return;
         }
         if(_loc4_.UpgradingLevel > 0)
         {
            _loc8_.BSelect = false;
            this.FSystemLanguage = this.FSystemLanguageBin.GetDatebaseByIdentifier(CONST_SYSTEMLANGUAGE.TALISMAN_STRING_12) as TSystemLanguage;
            EffectGenerateText(this.FSystemLanguage.Desc);
            return;
         }
         _loc6_ = this.FMC_SingleEquipList.length;
         _loc5_ = 0;
         while(_loc5_ < _loc6_)
         {
            _loc9_ = this.FMC_SingleEquipList[_loc5_];
            if(_loc8_ != _loc9_ && _loc9_.BClick)
            {
               _loc9_.BClick = false;
               break;
            }
            _loc5_++;
         }
         _loc8_.BSelect = true;
         this.UpdateSlot(param2);
         this.UpdateTransitionSlots();
         this.FBtn_Transition.Enabled = false;
         this.ResetTextField();
      }
      
      protected function UpdateTransitionSlots() : void
      {
         var _loc1_:int = 0;
         var _loc2_:uint = 0;
         var _loc3_:MovieClip = null;
         _loc2_ = this.FMC_EquipTransitionList.length;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FMC_EquipTransitionList[_loc1_];
            _loc3_.gotoAndStop(CONST_TALISMAN.MC_Frame_Normal);
            _loc1_++;
         }
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
      
      public function get TransitionOnClick() : Function
      {
         return this.FOnClick;
      }
      
      public function set TransitionOnClick(param1:Function) : void
      {
         this.FOnClick = param1;
      }
      
      public function get OnInventoryOver() : Function
      {
         return this.OnInventoryOver;
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
         this.Reset();
         this.UpdateEquip();
         this.UpdateText();
         this.UpdateBackpack();
         this.FMC_FloatEffect.play();
      }
      
      public function Reset() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TSingleEquip = null;
         var _loc4_:TUISlot = null;
         this.FSystemLanguage = null;
         this.FTransitionPaperNum = 0;
         _loc2_ = int(this.FMC_SingleEquipList.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FMC_SingleEquipList[_loc1_];
            _loc3_.Release();
            _loc3_.StubReferences.Dereference(this);
            _loc1_++;
         }
         _loc2_ = int(this.FMC_EquipTransitionSlotList.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc4_ = this.FMC_EquipTransitionSlotList[_loc1_];
            _loc4_.Context = null;
            _loc1_++;
         }
         this.FMC_TransitionSlot.Context = null;
         this.FMC_FloatEffect.stop();
      }
      
      public function SetBtnLock(param1:Boolean) : void
      {
         this.FBtn_Transition.Enabled = param1;
      }
   }
}

