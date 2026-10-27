package Processors.Game.Lobby.MakeEquip
{
   import Components.ComboBox.*;
   import Components.ScrollBar.*;
   import Components.Slots.*;
   import Components.Standard.*;
   import Foundation.Common.*;
   import Foundation.Queries.*;
   import Foundation.Queries.Coordinate.*;
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
   import Processors.Game.Common.Effects.Texts.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.MakeEquip.EquipSlots.*;
   import Processors.Game.Lobby.Utilities.*;
   import Processors.Game.Utilities.HyperLink.*;
   import Resources.Constants.*;
   import Resources.Strings.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   import flash.utils.*;
   
   public class TProcessorWindowMakeEquip extends TProcessorLobbyWindow
   {
      
      public static const CAPACITY_MC_Tabs:uint = CONST_EQUIPMAKE.CAPACITY_MC_Tabs;
      
      public static const ComboBox_Height:uint = CONST_EQUIPMAKE.ComboBox_Height;
      
      public static const FRAME_First:uint = 1;
      
      public static const FRAME_Second:uint = 2;
      
      protected static const QUALITYCOLOR_INDEX:Vector.<uint> = CONST_COMMON.QUALITYCOLOR_INDEX;
      
      protected var FHelpTips:THint;
      
      protected var FEquipMC:MovieClip;
      
      protected var FLeftGroup:MovieClip;
      
      protected var FUITab:TUITab;
      
      protected var FLevelDisplay:DisplayObject;
      
      protected var FLevelList:Vector.<String>;
      
      protected var FLevelTypeList:Vector.<DisplayObject>;
      
      protected var FLevelTypeComboBox:TComboBox;
      
      protected var FQualityDisplay:DisplayObject;
      
      protected var FQualityList:Vector.<String>;
      
      protected var FQualityTypeList:Vector.<DisplayObject>;
      
      protected var FQualityTypeComboBox:TComboBox;
      
      protected var FEquipSingle:MovieClip;
      
      protected var FMC_List:MovieClip;
      
      protected var FMaterialFilterButton:MovieClip;
      
      protected var FBtn_MaterialFilterSelected:SimpleButton;
      
      protected var FBtn_MaterialFilterUnSelected:SimpleButton;
      
      protected var FBtn_Help:SimpleButton;
      
      protected var FBtn_Close:SimpleButton;
      
      protected var FBtn_Make:TUIButton;
      
      protected var FTF_ConsumeMoney:TextField;
      
      protected var FMC_EquipBox:MovieClip;
      
      protected var FMC_EquipBoxSlot:TUISlot;
      
      protected var FMC_EquipBoxName:TextField;
      
      protected var FMC_EquipBoxGrade:TextField;
      
      protected var FMC_Effect:MovieClip;
      
      protected var FClickNum:int;
      
      protected var FBHide:Boolean;
      
      protected var FLevelIndex:int;
      
      protected var FLevel:int;
      
      protected var FQualityIndex:uint;
      
      protected var FQuality:uint;
      
      protected var FCostSilver:uint;
      
      protected var FEquipSlot:TEquipSlot;
      
      protected var FEquipSlotList:TEquipSlotList;
      
      protected var FCharacter:TCharacter;
      
      protected var FEquipInventories:TInventories;
      
      protected var FBin:TBins;
      
      protected var FUnstreamizerInventoryReference:TUnstreamizerInventoryReference;
      
      protected var FEquipTypeIndex:uint;
      
      protected var FScrollBar:TScrollBar;
      
      protected var FDictionary:Dictionary;
      
      protected var FOwnMaterialNumList:Vector.<uint>;
      
      protected var FNeedMaterialNumList:Vector.<uint>;
      
      protected var FMaterialSlotList:Vector.<TUISlot>;
      
      protected var FMateriaNumTextFieldList:Vector.<TextField>;
      
      protected var FEffectCoordinateParameters:TEffectCoordinateParameters;
      
      protected var FQueryCoordinate:TQueryCoordinate;
      
      protected var FPoints:TextField;
      
      protected var FDuplicate:TextField;
      
      protected var FOnInventoryOver:Function;
      
      protected var FOnInventoryOut:Function;
      
      protected var FOnHelpTipsOver:Function;
      
      protected var FOnHelpTipsOut:Function;
      
      protected var FEquipMake:Function;
      
      protected var FOnEffectAcquireInventory:Function;
      
      protected var FOnQueryShortcutCoordinate:Function;
      
      public function TProcessorWindowMakeEquip(param1:TUIComponent)
      {
         super(param1);
         this.FHelpTips = new THint();
         this.FEquipSlotList = new TEquipSlotList(this);
         this.FEquipInventories = new TInventories();
         this.FDictionary = new Dictionary(true);
         this.FOwnMaterialNumList = new Vector.<uint>();
         this.FNeedMaterialNumList = new Vector.<uint>();
         this.FMaterialSlotList = new Vector.<TUISlot>();
         this.FMateriaNumTextFieldList = new Vector.<TextField>();
         this.FUnstreamizerInventoryReference = new TUnstreamizerInventoryReference();
         this.ConstructEffectParameters();
         this.FQueryCoordinate = new TQueryCoordinate();
         this.FBHide = false;
      }
      
      protected function ConstructEffectParameters() : void
      {
         this.FEffectCoordinateParameters = new TEffectCoordinateParameters();
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_EQUIPMAKE.RESOURCESID_EQUIP);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:MovieClip = null;
         var _loc4_:MovieClip = null;
         var _loc5_:TUISlot = null;
         this.FCharacter = SLogicsCore.Character;
         this.FBin = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_EquipGenerate);
         this.FEquipMC = TUtilityReflection.CreateDisplayObjectInstance(CONST_EQUIPMAKE.RESOURCESID_ClassName_Equip_Make) as MovieClip;
         addChild(this.FEquipMC);
         this.FBtn_Help = this.FEquipMC[CONST_COMMON.RESOURCE_Link_Btn_Help];
         this.FBtn_Close = this.FEquipMC[CONST_COMMON.RESOURCE_Link_Btn_Close];
         this.FMaterialFilterButton = this.FEquipMC[CONST_EQUIPMAKE.RESOURCE_Link_MaterialFilterButton];
         this.FBtn_MaterialFilterSelected = this.FMaterialFilterButton[CONST_EQUIPMAKE.RESOURCE_Link_Btn_MaterialFilterSelected];
         this.FBtn_MaterialFilterSelected.visible = false;
         this.FBtn_MaterialFilterUnSelected = this.FMaterialFilterButton[CONST_EQUIPMAKE.RESOURCE_Link_Btn_MaterialFilterUnSelected];
         this.FBtn_MaterialFilterUnSelected.visible = true;
         this.FBtn_Make = new TUIButton();
         this.FBtn_Make.Substrate = this.FEquipMC[CONST_EQUIPMAKE.RESOURCE_Link_Btn_Make];
         this.FBtn_Make.OnClick = this.BtnMakeHandler;
         this.FBtn_Make.Enabled = false;
         this.FTF_ConsumeMoney = this.FEquipMC[CONST_EQUIPMAKE.RESOURCE_Link_TF_ConsumeMoney];
         this.FTF_ConsumeMoney.visible = false;
         this.FMC_EquipBox = this.FEquipMC[CONST_EQUIPMAKE.RESOURCE_Link_MC_EquipBox];
         this.FMC_EquipBoxName = this.FMC_EquipBox[CONST_EQUIPMAKE.RESOURCE_Link_EquipName];
         this.FMC_EquipBoxName.visible = false;
         this.FMC_EquipBoxGrade = this.FMC_EquipBox[CONST_EQUIPMAKE.RESOURCE_Link_TF_EquipGrade];
         this.FMC_EquipBoxGrade.visible = false;
         this.FMC_Effect = this.FMC_EquipBox[CONST_EQUIPMAKE.RESOURCE_Link_MC_Effect];
         this.FMC_EquipBoxSlot = new TUISlot(this);
         this.FMC_EquipBoxSlot.Resource = this.FMC_EquipBox[CONST_EQUIPMAKE.RESOURCE_Link_MC_Equip_slot] as Sprite;
         this.FMC_EquipBoxSlot.SequenceDefaultIcon = SResourcesCore.TexturesLobby.GetAnimationSequenceByIdentifiers(CONST_LOBBY.RESOURCESID_Texture_SlotDefaultEffect,0);
         this.FMC_EquipBoxSlot.OnQuerySequenceContext = this.OnQuerySequenceContext;
         this.FMC_EquipBoxSlot.OnOver = this.SlotsOnMove;
         this.FMC_EquipBoxSlot.OnOut = this.SlotsOnOut;
         this.FMC_EquipBoxSlot.Init();
         this.FLeftGroup = this.FEquipMC[CONST_EQUIPMAKE.RESOURCES_MCName_LeftLabelGroup];
         this.FUITab = new TUITab(this);
         _loc2_ = int(CAPACITY_MC_Tabs);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FLeftGroup[CONST_EQUIPMAKE.RESOURCES_MCName_MC_Tab_ + _loc1_];
            _loc4_ = _loc3_[CONST_EQUIPMAKE.RESOURCES_MCName_MC_Tab_Icon];
            _loc4_.gotoAndStop(_loc1_ + 1);
            this.FUITab.SetTabByIndex(_loc3_,_loc1_);
            _loc1_++;
         }
         this.FUITab.OnSwitch = this.TabOnSwitch;
         this.FUITab.Init();
         this.FMC_List = this.FEquipMC[CONST_EQUIPMAKE.RESOURCE_Link_Mc_List];
         this.FScrollBar = new TScrollBar(this.FMC_List,341,false,1);
         this.FLevelList = TUtilityLobby.GetStringsByIdentifier(CONST_SYSTEMLANGUAGE.EQUIPMAKE_STRING_05);
         this.FLevelTypeList = new Vector.<DisplayObject>();
         this.MakeComboBox(this.FLevelList,this.FLevelTypeList,this.FLevelDisplay,this.FLevelTypeComboBox,CONST_EQUIPMAKE.RESOURCES_MCName_MC_list_level,this.OnLevelSelect);
         this.FQualityList = TUtilityLobby.GetStringsByIdentifier(CONST_SYSTEMLANGUAGE.EQUIPMAKE_STRING_06);
         this.FQualityTypeList = new Vector.<DisplayObject>();
         this.MakeComboBox(this.FQualityList,this.FQualityTypeList,this.FQualityDisplay,this.FQualityTypeComboBox,CONST_EQUIPMAKE.RESOURCES_MCName_MC_list_color,this.OnQualitySelect);
         _loc2_ = int(CONST_EQUIPMAKE.CAPACITY_MC_MaterialSlot);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc5_ = new TUISlot(this);
            _loc5_.Resource = this.FEquipMC[CONST_EQUIPMAKE.RESOURCE_Link_MaterialBox][CONST_EQUIPMAKE.RESOURCE_Link_Material_Slot + _loc1_] as Sprite;
            _loc5_.SequenceDefaultIcon = SResourcesCore.TexturesLobby.GetAnimationSequenceByIdentifiers(CONST_LOBBY.RESOURCESID_Texture_SlotDefaultEffect,0);
            _loc5_.OnQuerySequenceContext = this.OnQuerySequenceContext;
            _loc5_.OnQuerySubscript = this.SlotsOnQuerySubscript;
            _loc5_.OnOver = this.SlotsOnMove;
            _loc5_.OnOut = this.SlotsOnOut;
            _loc5_.Init();
            this.FMaterialSlotList[_loc1_] = _loc5_;
            this.FMateriaNumTextFieldList[_loc1_] = this.FEquipMC[CONST_EQUIPMAKE.RESOURCE_Link_MaterialBox][CONST_EQUIPMAKE.RESOURCE_Link_Material_Slot + _loc1_][CONST_EQUIPMAKE.RESOURCE_Link_TF_NeedNum] as TextField;
            this.FMateriaNumTextFieldList[_loc1_].visible = false;
            _loc1_++;
         }
         this.FPoints = this.FEquipMC.tf_Points;
         this.FDuplicate = this.FEquipMC.tf_Duplicate;
         this.FPoints.htmlText = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.EQUIPMAKE_STRING_03);
         this.FDuplicate.htmlText = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.EQUIPMAKE_STRING_04);
         TutorialSendArrowParent(CONST_FRESHGUIDE.MCID_MakeEquip,this.parent);
         TutorialSendComponent(CONST_FRESHGUIDE.MCID_MakeEquip,this);
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         this.FBtn_Help.addEventListener(MouseEvent.MOUSE_MOVE,this.ButtonHelpOnOver,false,0,true);
         this.FBtn_Help.addEventListener(MouseEvent.MOUSE_OUT,this.ButtonHelpOnOut,false,0,true);
         if(!this.FMaterialFilterButton.hasEventListener(MouseEvent.CLICK))
         {
            this.FMaterialFilterButton.addEventListener(MouseEvent.CLICK,this.HideLackMaterialOnClick,false,0,true);
         }
         if(!this.FBtn_Close.hasEventListener(MouseEvent.CLICK))
         {
            this.FBtn_Close.addEventListener(MouseEvent.CLICK,this.BtnCloseHandler,false,0,true);
         }
         this.FPoints.addEventListener(TextEvent.LINK,this.GotoBigMapOnLink);
         this.FDuplicate.addEventListener(TextEvent.LINK,this.GotoBigMapOnLink);
         super.ResourcesPerform_UILocations();
      }
      
      override protected function ResourcesPerform_UIFinalize() : void
      {
         super.ResourcesPerform_UIFinalize();
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(!this.Visible)
         {
            return;
         }
         if(this.FMC_Effect != null && this.FMC_Effect.currentFrame == this.FMC_Effect.totalFrames)
         {
            if(this.FEquipMake != null)
            {
               this.ProcessorEffectAcquireInventory(this.FMC_EquipBoxSlot);
            }
            this.FMC_Effect.gotoAndStop(1);
            this.SetEnabled(true);
            this.Update();
         }
         this.UpdateSlots();
      }
      
      protected function UpdateSlots() : void
      {
         var _loc1_:int = 0;
         var _loc2_:uint = 0;
         var _loc3_:TEquipSlot = null;
         var _loc4_:TUISlot = null;
         _loc2_ = this.FEquipSlotList.Count;
         if(_loc2_ > 0)
         {
            _loc1_ = 0;
            while(_loc1_ < _loc2_)
            {
               _loc3_ = this.FEquipSlotList.GetSlotByIndex(_loc1_);
               _loc3_.Update();
               _loc1_++;
            }
         }
         _loc2_ = this.FMaterialSlotList.length;
         if(_loc2_ > 0)
         {
            _loc1_ = 0;
            while(_loc1_ < _loc2_)
            {
               _loc4_ = this.FMaterialSlotList[_loc1_];
               _loc4_.Update();
               _loc1_++;
            }
         }
         if(this.FMC_EquipBoxSlot != null)
         {
            this.FMC_EquipBoxSlot.Update();
         }
      }
      
      protected function MakeEquipList(param1:uint = 0, param2:uint = 0, param3:Boolean = false) : void
      {
         var _loc4_:int = 0;
         var _loc5_:uint = 0;
         var _loc6_:THero = null;
         var _loc7_:TEquipGenerate = null;
         var _loc8_:uint = 0;
         var _loc9_:Vector.<uint> = null;
         var _loc10_:TInventories = null;
         var _loc11_:TInventory = null;
         var _loc12_:TInventories = null;
         var _loc13_:TAppliance = null;
         var _loc14_:int = 0;
         var _loc15_:uint = 0;
         var _loc16_:uint = 0;
         var _loc17_:uint = 0;
         var _loc18_:Vector.<int> = null;
         var _loc19_:uint = 0;
         var _loc20_:* = undefined;
         var _loc21_:int = 0;
         var _loc22_:int = 0;
         var _loc23_:* = undefined;
         var _loc24_:int = 0;
         _loc9_ = new Vector.<uint>();
         _loc10_ = new TInventories();
         _loc18_ = new Vector.<int>();
         _loc8_ = this.FEquipTypeIndex + 1;
         _loc6_ = this.FCharacter.Heros.GetHeroByIndex(0);
         _loc12_ = this.FCharacter.Materials;
         this.FEquipSlotList.Clear(this.FScrollBar);
         this.FEquipInventories.Clear();
         for(_loc20_ in this.FDictionary)
         {
            delete this.FDictionary[_loc20_];
         }
         _loc5_ = uint(this.FBin.Count);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc7_ = this.FBin.GetDatebaseByIndex(_loc4_) as TEquipGenerate;
            _loc14_ = int(_loc7_.Materials.length);
            if(_loc7_.Identifier % 10 == _loc8_)
            {
               while(_loc18_.length > 0)
               {
                  _loc18_.pop();
               }
               _loc18_.length = 0;
               if(_loc6_.Level >= _loc7_.OpenLevel)
               {
                  _loc15_ = 0;
                  _loc21_ = 0;
                  while(_loc21_ < _loc14_)
                  {
                     _loc16_ = 0;
                     _loc17_ = uint(_loc7_.Quantitys[_loc21_]);
                     _loc22_ = 0;
                     while(_loc22_ < _loc12_.Count)
                     {
                        _loc13_ = _loc12_.GetInventoryByIndex(_loc22_) as TAppliance;
                        if(_loc13_ != null && _loc13_.IDTemplate == _loc7_.Materials[_loc21_])
                        {
                           _loc16_ += _loc13_.Quantity;
                        }
                        _loc22_++;
                     }
                     if(_loc16_ >= _loc17_)
                     {
                        _loc18_.push(Math.floor(_loc16_ / _loc17_));
                        _loc15_++;
                     }
                     _loc21_++;
                  }
                  if(_loc15_ > 1)
                  {
                     _loc18_.sort(Array.NUMERIC);
                     this.FDictionary[_loc7_.Identifier] = _loc18_[0];
                  }
                  _loc9_.push(_loc7_.Identifier);
               }
            }
            _loc4_++;
         }
         this.FUnstreamizerInventoryReference.UnstreamizeGenerateInventoriesByIdentifiers(null,this.FEquipInventories,_loc9_);
         _loc5_ = uint(this.FEquipInventories.Count);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc11_ = this.FEquipInventories.GetInventoryByIndex(_loc4_);
            if(this.CheckLevel(_loc11_) && this.CheckQuality(_loc11_))
            {
               if(param3 && this.FDictionary[_loc11_.IDTemplate] > 0)
               {
                  _loc10_.Add(_loc11_);
               }
               else if(!param3)
               {
                  _loc10_.Add(_loc11_);
               }
            }
            _loc4_++;
         }
         this.FEquipInventories = _loc10_;
         _loc5_ = uint(this.FEquipInventories.Count);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            this.FEquipSlot = new TEquipSlot(this);
            _loc11_ = this.FEquipInventories.GetInventoryByIndex(_loc5_ - 1 - _loc4_);
            this.FEquipSlot.EquipSlotMC = this.FEquipSingle;
            this.FEquipSlot.OnQuerySequenceContext = this.OnQuerySequenceContext;
            this.FEquipSlot.OnOver = this.SlotsOnMove;
            this.FEquipSlot.OnOut = this.SlotsOnOut;
            this.FEquipSlot.OnClick = this.SingleEquipOnClick;
            for(_loc23_ in this.FDictionary)
            {
               if(_loc23_ == _loc11_.IDTemplate)
               {
                  if(this.FDictionary[_loc23_] > 0)
                  {
                     _loc11_.Quantity = this.FDictionary[_loc23_];
                  }
               }
            }
            this.FEquipSlot.Context = _loc11_;
            this.FEquipSlot.Init();
            this.FEquipSlotList.AddDisplay(this.FEquipSlot,this.FScrollBar);
            _loc4_++;
         }
         if(_loc5_ < CONST_EQUIPMAKE.CAPACITY_MC_SingleEquip)
         {
            _loc5_ = CONST_EQUIPMAKE.CAPACITY_MC_SingleEquip - _loc5_;
            _loc24_ = 0;
            while(_loc24_ < _loc5_)
            {
               this.FEquipSlot = new TEquipSlot(this);
               this.FEquipSlot.Init();
               this.FEquipSlot.SetPicture();
               this.FEquipSlotList.AddDisplay(this.FEquipSlot,this.FScrollBar);
               _loc24_++;
            }
         }
      }
      
      protected function CheckLevel(param1:TInventory) : Boolean
      {
         if(this.FLevel == 0)
         {
            return true;
         }
         if(this.FLevel == param1.RequirementLevel)
         {
            return true;
         }
         return false;
      }
      
      protected function CheckQuality(param1:TInventory) : Boolean
      {
         if(this.FQuality == 0)
         {
            return true;
         }
         if(this.FQuality == param1.Quality)
         {
            return true;
         }
         return false;
      }
      
      protected function MakeComboBox(param1:Vector.<String>, param2:Vector.<DisplayObject>, param3:DisplayObject, param4:TComboBox, param5:String, param6:Function) : void
      {
         var _loc7_:int = 0;
         _loc7_ = 0;
         while(_loc7_ < param1.length)
         {
            param3 = this.MakeComboItem(param1[_loc7_]);
            param2.push(param3);
            _loc7_++;
         }
         param4 = new TComboBox(this,this.FEquipMC[param5],param2,ComboBox_Height,param6);
      }
      
      protected function MakeComboItem(param1:String) : DisplayObject
      {
         var _loc2_:MovieClip = null;
         _loc2_ = TUtilityReflection.CreateDisplayObjectInstance(CONST_EQUIPMAKE.RESOURCESID_ClassName_Equit_BoxItem) as MovieClip;
         _loc2_.tf_into.text = param1;
         return _loc2_;
      }
      
      protected function InitialRight() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:int = 0;
         var _loc3_:TextField = null;
         var _loc4_:TUISlot = null;
         _loc1_ = this.FMateriaNumTextFieldList.length;
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = this.FMateriaNumTextFieldList[_loc2_];
            _loc3_.visible = false;
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            _loc4_ = this.FMaterialSlotList[_loc2_];
            _loc4_.Context = null;
            _loc2_++;
         }
         this.FMC_EquipBoxSlot.Context = null;
         this.FMC_EquipBoxName.visible = false;
         this.FMC_EquipBoxGrade.visible = false;
         this.FTF_ConsumeMoney.visible = false;
         this.FBtn_Make.Enabled = false;
      }
      
      protected function ProcessorEffectAcquireInventory(param1:TUISlot) : void
      {
         var _loc2_:Object = null;
         var _loc3_:TCoordinate = null;
         _loc2_ = param1.Context;
         if(_loc2_ == null)
         {
            return;
         }
         if(this.FOnQueryShortcutCoordinate != null)
         {
            this.FOnQueryShortcutCoordinate(this,CONST_SHORTCUTS.TYPE_MainFunction_Backpack,this.FQueryCoordinate);
         }
         _loc3_ = TUtilityCartisian.GetScreenCoordinateByDisplayObject(param1.Resource);
         _loc3_.X += 4;
         _loc3_.Y += 4;
         this.FEffectCoordinateParameters.CoordinateSource.Assign(_loc3_);
         this.FEffectCoordinateParameters.CoordinateDestination.Assign(this.FQueryCoordinate.Value);
         if(this.FOnEffectAcquireInventory != null)
         {
            this.FOnEffectAcquireInventory(this,_loc2_,this.FEffectCoordinateParameters);
         }
      }
      
      private function GotoBigMapOnLink(param1:TextEvent) : void
      {
         this.InitialRight();
         SUtilityHyperLink.ShortcutHyperlink(TUtilityHyperLink.HyperLink_WorldMap);
      }
      
      protected function BtnMakeHandler(param1:Object, param2:MouseEvent) : void
      {
         if(this.FCostSilver < this.FCharacter.CreditSilverCoin.ToNumber())
         {
            if(this.FEquipMake != null)
            {
               this.FEquipMake(this,this.FMC_EquipBoxSlot.Context);
            }
            this.SetEnabled(false);
         }
         else
         {
            EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.NOTENOUGH_Coin));
         }
      }
      
      protected function BtnCloseHandler(param1:MouseEvent) : void
      {
         this.InitialRight();
         ProcessorWindowClose();
      }
      
      protected function ButtonHelpOnOver(param1:MouseEvent) : void
      {
         if(TUtilityString.Empty(this.FHelpTips.Content))
         {
            this.FHelpTips.Content = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HELPTIPS_MakeEquip);
         }
         if(this.FOnHelpTipsOver != null)
         {
            this.FOnHelpTipsOver(this,this.FHelpTips);
         }
      }
      
      protected function ButtonHelpOnOut(param1:MouseEvent) : void
      {
         if(this.FOnHelpTipsOut != null)
         {
            this.FOnHelpTipsOut(this,this.FHelpTips);
         }
      }
      
      protected function HideLackMaterialOnClick(param1:MouseEvent) : void
      {
         ++this.FClickNum;
         if(this.FClickNum % 2 == 1)
         {
            this.FBHide = true;
            this.FBtn_MaterialFilterSelected.visible = true;
            this.FBtn_MaterialFilterUnSelected.visible = false;
         }
         else
         {
            this.FBHide = false;
            this.FBtn_MaterialFilterSelected.visible = false;
            this.FBtn_MaterialFilterUnSelected.visible = true;
         }
         this.MakeEquipList(this.FLevel,this.FQuality,this.FBHide);
      }
      
      protected function TabOnSwitch(param1:Object) : void
      {
         this.FEquipTypeIndex = param1 as int;
         this.InitialRight();
         this.MakeEquipList(this.FLevel,this.FQuality,this.FBHide);
         if(this.FEquipTypeIndex == 6)
         {
            TutorialNextStep(CONST_FRESHGUIDE.EVENTID_SelectEquiptTab);
         }
      }
      
      protected function OnLevelSelect(param1:Object, param2:int) : void
      {
         var _loc3_:int = 0;
         if(this.FLevelIndex == param2)
         {
            return;
         }
         this.FLevelIndex = param2;
         _loc3_ = int(this.FLevelList[param2].split(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.EQUIPMAKE_STRING_02))[0]);
         this.FLevel = _loc3_;
         this.MakeEquipList(this.FLevel,this.FQuality,this.FBHide);
      }
      
      protected function OnQualitySelect(param1:Object, param2:int) : void
      {
         if(this.FQualityIndex == param2)
         {
            return;
         }
         this.FQualityIndex = param2;
         if(param2 == 0)
         {
            this.FQuality = 0;
         }
         else
         {
            this.FQuality = this.FQualityIndex + 2;
         }
         this.MakeEquipList(this.FLevel,this.FQuality,this.FBHide);
      }
      
      protected function SlotsOnMove(param1:Object, param2:TInventory) : void
      {
         if(this.FOnInventoryOver != null)
         {
            this.FOnInventoryOver(this,param2);
         }
      }
      
      protected function SlotsOnOut(param1:Object, param2:TInventory) : void
      {
         if(this.FOnInventoryOut != null)
         {
            this.FOnInventoryOut(this,param2);
         }
      }
      
      protected function OnQuerySequenceContext(param1:Object, param2:Object, param3:TQueryAnimationSequence, param4:uint = 0) : void
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
      
      protected function SlotsOnQuerySubscript(param1:Object, param2:Object, param3:TQueryString) : void
      {
         var _loc4_:TAppliance = null;
         if(param2 is TAppliance)
         {
            _loc4_ = param2 as TAppliance;
            param3.Value = _loc4_.Quantity.toString();
         }
      }
      
      protected function SingleEquipOnClick(param1:Object, param2:Object) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:int = 0;
         var _loc5_:TEquipSlot = null;
         var _loc6_:TEquipSlot = null;
         var _loc7_:TInventory = null;
         var _loc8_:TEquipGenerate = null;
         var _loc9_:TAppliance = null;
         var _loc10_:TInventories = null;
         var _loc11_:Vector.<uint> = null;
         var _loc12_:TInventories = null;
         var _loc13_:TUISlot = null;
         var _loc14_:TInventory = null;
         var _loc15_:TextField = null;
         var _loc16_:uint = 0;
         var _loc17_:uint = 0;
         var _loc18_:uint = 0;
         var _loc19_:int = 0;
         _loc11_ = new Vector.<uint>();
         _loc12_ = new TInventories();
         _loc7_ = param2 as TInventory;
         _loc6_ = param1 as TEquipSlot;
         _loc10_ = this.FCharacter.Materials;
         _loc16_ = 0;
         _loc3_ = this.FEquipSlotList.Count;
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = this.FEquipSlotList.GetSlotByIndex(_loc4_);
            if(_loc6_ != _loc5_ && _loc5_.BClick)
            {
               _loc5_.BClick = false;
               break;
            }
            _loc4_++;
         }
         _loc6_.BClick = true;
         _loc8_ = this.FBin.GetDatebaseByIdentifier(_loc7_.IDTemplate) as TEquipGenerate;
         _loc3_ = _loc8_.Materials.length;
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            _loc17_ = 0;
            _loc18_ = uint(_loc8_.Quantitys[_loc4_]);
            _loc19_ = 0;
            while(_loc19_ < _loc10_.Count)
            {
               _loc9_ = _loc10_.GetInventoryByIndex(_loc19_) as TAppliance;
               if(_loc9_ != null && _loc9_.IDTemplate == _loc8_.Materials[_loc4_])
               {
                  _loc17_ += _loc9_.Quantity;
               }
               _loc19_++;
            }
            this.FOwnMaterialNumList[_loc4_] = _loc17_;
            this.FNeedMaterialNumList[_loc4_] = _loc18_;
            _loc11_.push(_loc8_.Materials[_loc4_]);
            _loc4_++;
         }
         this.FUnstreamizerInventoryReference.UnstreamizeGenerateInventoriesByIdentifiers(null,_loc12_,_loc11_);
         _loc3_ = this.FMaterialSlotList.length;
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            _loc13_ = this.FMaterialSlotList[_loc4_];
            _loc14_ = _loc12_.GetInventoryByTempletID(_loc11_[_loc4_]) as TInventory;
            _loc13_.Context = _loc14_;
            _loc15_ = this.FMateriaNumTextFieldList[_loc4_];
            _loc15_.text = this.FOwnMaterialNumList[_loc4_] + "/" + this.FNeedMaterialNumList[_loc4_];
            if(this.FOwnMaterialNumList[_loc4_] >= this.FNeedMaterialNumList[_loc4_])
            {
               _loc16_++;
               _loc15_.textColor = CONST_COMMON.TEXT_Green_Color;
            }
            else
            {
               _loc15_.textColor = CONST_COMMON.TEXT_White_Color;
            }
            _loc15_.visible = true;
            _loc4_++;
         }
         this.FMC_EquipBoxSlot.Context = _loc7_;
         this.FMC_EquipBoxName.text = _loc7_.Name;
         this.FMC_EquipBoxName.textColor = QUALITYCOLOR_INDEX[_loc7_.Quality];
         this.FMC_EquipBoxName.visible = true;
         this.FMC_EquipBoxGrade.text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.EQUIPMAKE_STRING_01) + _loc7_.RequirementLevel + TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.EQUIPMAKE_STRING_02);
         this.FMC_EquipBoxGrade.visible = true;
         this.FTF_ConsumeMoney.text = _loc8_.Cost.toString();
         this.FTF_ConsumeMoney.visible = true;
         this.FCostSilver = _loc8_.Cost;
         if(_loc16_ > 1 && this.FCharacter.CreditSilverCoin.ToNumber() > this.FCostSilver)
         {
            this.FBtn_Make.Enabled = true;
         }
         TutorialNextStep(CONST_FRESHGUIDE.EVENTID_SelectTargetEquip);
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
      
      public function get OnHelpTipsOver() : Function
      {
         return this.FOnHelpTipsOver;
      }
      
      public function set OnHelpTipsOver(param1:Function) : void
      {
         this.FOnHelpTipsOver = param1;
      }
      
      public function get OnHelpTipsOut() : Function
      {
         return this.FOnHelpTipsOut;
      }
      
      public function set OnHelpTipsOut(param1:Function) : void
      {
         this.FOnHelpTipsOut = param1;
      }
      
      public function get EquipMake() : Function
      {
         return this.FEquipMake;
      }
      
      public function set EquipMake(param1:Function) : void
      {
         this.FEquipMake = param1;
      }
      
      public function get OnEffectAcquireInventory() : Function
      {
         return this.FOnEffectAcquireInventory;
      }
      
      public function set OnEffectAcquireInventory(param1:Function) : void
      {
         this.FOnEffectAcquireInventory = param1;
      }
      
      public function get OnQueryShortcutCoordinate() : Function
      {
         return this.FOnQueryShortcutCoordinate;
      }
      
      public function set OnQueryShortcutCoordinate(param1:Function) : void
      {
         this.FOnQueryShortcutCoordinate = param1;
      }
      
      public function Perform_UIDispatch() : void
      {
         this.ResourcesPerform_UIDispatch();
      }
      
      public function Update() : void
      {
         this.MakeEquipList(this.FLevel,this.FQuality,this.FBHide);
         this.InitialRight();
      }
      
      public function SetEnabled(param1:Boolean) : void
      {
         if(!Visible)
         {
            return;
         }
         this.FMC_List.mouseEnabled = param1;
         this.FBtn_Make.Enabled = param1;
      }
      
      public function UpdateMade() : void
      {
         if(!Visible)
         {
            return;
         }
         this.FMC_Effect.gotoAndPlay(1);
      }
      
      public function Reset() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         _loc2_ = CONST_EQUIPMAKE.CAPACITY_MC_MaterialSlot;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FMaterialSlotList[_loc1_].Context = null;
            _loc1_++;
         }
         this.FEquipSlotList.Clear(this.FScrollBar);
         this.FMC_EquipBoxSlot.Context = null;
      }
   }
}

