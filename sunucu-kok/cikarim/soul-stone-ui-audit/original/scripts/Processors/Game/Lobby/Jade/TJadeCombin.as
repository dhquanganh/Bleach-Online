package Processors.Game.Lobby.Jade
{
   import Components.ComboBox.*;
   import Components.Pages.*;
   import Components.Slots.*;
   import Foundation.Resources.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.Characters.TCharacter;
   import Logics.DatebaseVO.VO.*;
   import Logics.Inventories.*;
   import Logics.Streamization.Inventories.*;
   import Processors.Game.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Jade.Component.TUIAutoCombinPopTip;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Resources.Constants.*;
   import Resources.Strings.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class TJadeCombin extends TProcessorLobbyWindow
   {
      
      protected static var STATE_READY:int = 0;
      
      protected static var STATE_WAITBACK:int = 1;
      
      protected static var JadeClassNum:int = 11 * 12;
      
      protected static const COMBINNOMAL_X:uint = 495;
      
      protected static const COMBINVIP_X:uint = 454;
      
      protected static const COMBIN_Y:uint = 300;
      
      protected var FUIDispatchRoutines:Vector.<Function>;
      
      protected var FUILocationRoutines:Vector.<Function>;
      
      protected var FInitialization:Boolean;
      
      protected var FBackpackSlots:Vector.<TUISlot>;
      
      protected var FJadeBackCollection:TCollectionInventory;
      
      protected var FUIPage:TUIPage;
      
      protected var FPageIndex:int;
      
      protected var FJadeLevelComboBox:TComboBox;
      
      protected var FJadeTypeComboBox:TComboBox;
      
      protected var FSelectJadeUsetoShow:TInventories;
      
      protected var FJadeLevelComboBoxSelectIndex:int;
      
      protected var FJadeTypeComboBoxSelectIndex:int;
      
      protected var FCombineEffect:MovieClip;
      
      protected var FLeftJadeShowSlot:TUISlot;
      
      protected var FRightJadeShowSlot:TUISlot;
      
      protected var FCombineJadeShowSlot:TUISlot;
      
      protected var FTF_CombineJadeNum:TextField;
      
      protected var FTF_CombineJadeMaxNum:TextField;
      
      protected var FCombineMaxNum:int;
      
      protected var FCurrentCombineNum:int;
      
      protected var FBTN_MaxCombineNum:SimpleButton;
      
      protected var FBTN_Combine:MovieClip;
      
      protected var FBTN_CombineAll:MovieClip;
      
      protected var FTF_VipTip:TextField;
      
      protected var FCurrentShowJade:TAppliance;
      
      protected var FIDTemplates:Vector.<uint>;
      
      protected var FCurrentJadeInventory:TInventories;
      
      protected var FUnstreamizerInventoryReference:TUnstreamizerInventoryReference;
      
      protected var FSelectBox:Sprite;
      
      protected var FSelectPage:int;
      
      protected var FCurrentState:int;
      
      protected var FWaiting:Boolean;
      
      protected var FCharacter:TCharacter;
      
      protected var FAutoPopTip:TUIAutoCombinPopTip;
      
      protected var FType:uint;
      
      protected var FJadeLevelNames:Vector.<String>;
      
      protected var FJadeTypeNames:Vector.<String>;
      
      protected var FOnCombine:Function;
      
      protected var FOnInventoryOver:Function;
      
      protected var FOnInventoryOut:Function;
      
      protected var FFlyText:Function;
      
      protected var FResultCode:int;
      
      public function TJadeCombin(param1:TUIComponent)
      {
         super(param1);
         this.FCharacter = SLogicsCore.Character;
         this.ConstructDispatchRoutines();
         this.ConstructLocationRoutines();
         this.FAutoPopTip = new TUIAutoCombinPopTip(param1);
         this.FAutoPopTip.PopTipVisible = false;
         this.FAutoPopTip.OnBack = this.PopTipBack;
         this.FAutoPopTip.OnOk = this.PopTipOk;
         this.FType = 100;
      }
      
      protected function ConstructDispatchRoutines() : void
      {
         this.FUIDispatchRoutines = new Vector.<Function>();
         this.FUIDispatchRoutines.push(this.BackPackUIDispath);
         this.FUIDispatchRoutines.push(this.JadeCombineUIDispath);
      }
      
      public function Perform_UIDispatch(param1:MovieClip) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Function = null;
         this.addChild(param1);
         _loc2_ = 0;
         while(_loc2_ < this.FUIDispatchRoutines.length)
         {
            _loc3_ = this.FUIDispatchRoutines[_loc2_];
            _loc3_(param1);
            _loc2_++;
         }
      }
      
      protected function ConstructLocationRoutines() : void
      {
         this.FUILocationRoutines = new Vector.<Function>();
         this.FUILocationRoutines.push(this.BackPackLocation);
         this.FUILocationRoutines.push(this.JadeCombineLocation);
      }
      
      public function Perform_UILocation() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Function = null;
         _loc1_ = 0;
         while(_loc1_ < this.FUILocationRoutines.length)
         {
            _loc2_ = this.FUILocationRoutines[_loc1_];
            _loc2_();
            _loc1_++;
         }
         this.Reset();
         this.FInitialization = true;
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
            TJadeCommon.ProcessorUpdateSlotsRenderingState(this.FBackpackSlots);
            this.FLeftJadeShowSlot.Update();
            this.FRightJadeShowSlot.Update();
            this.FCombineJadeShowSlot.Update();
            if(this.FCombineEffect.currentFrame == this.FCombineEffect.totalFrames)
            {
               this.ResetCombine();
               this.FWaiting = false;
               this.FCombineEffect.visible = false;
               this.FCombineEffect.gotoAndStop(1);
            }
         }
      }
      
      protected function BackPackUIDispath(param1:MovieClip) : void
      {
         var _loc2_:int = 0;
         var _loc3_:TUISlot = null;
         var _loc4_:Vector.<DisplayObject> = null;
         var _loc5_:Vector.<DisplayObject> = null;
         var _loc6_:Array = null;
         var _loc7_:int = 0;
         var _loc8_:DisplayObject = null;
         this.FSelectJadeUsetoShow = new TInventories();
         this.FBackpackSlots = new Vector.<TUISlot>();
         _loc2_ = 0;
         while(_loc2_ < CONST_JADE.MAX_JadeCombineSlotCount)
         {
            _loc3_ = new TUISlot(this);
            _loc3_.Resource = param1["mc_grid_" + _loc2_];
            this.FBackpackSlots.push(_loc3_);
            TJadeCommon.InitSlot(_loc3_);
            _loc3_.Tag = _loc2_;
            _loc3_.OnClick = this.BackpackJadeSlotsOnClick;
            _loc3_.Init();
            _loc3_.OnOver = this.SlotsOnMove;
            _loc3_.OnOut = this.SlotsOnOut;
            _loc2_++;
         }
         this.FUIPage = new TUIPage(this);
         this.FUIPage.ButtonPrevious.Substrate = param1["btn_left"];
         this.FUIPage.ButtonNext.Substrate = param1["btn_right"];
         this.FUIPage.LabelPage = param1["TF_Page"];
         this.FJadeLevelNames = TUtilityLobby.GetStringsByIdentifier(CONST_SYSTEMLANGUAGE.Jade_STRING_0);
         _loc4_ = new Vector.<DisplayObject>();
         _loc7_ = int(this.FJadeLevelNames.length);
         _loc2_ = 0;
         while(_loc2_ < _loc7_)
         {
            _loc8_ = this.MakeComboItem(this.FJadeLevelNames[_loc2_]);
            _loc4_.push(_loc8_);
            _loc2_++;
         }
         this.FJadeLevelComboBox = new TComboBox(this,param1["mc_list_level"],_loc4_,CONST_JADE.MAX_ComboboxHeight,this.OnLevelSelect);
         this.FJadeTypeNames = TUtilityLobby.GetStringsByIdentifier(CONST_SYSTEMLANGUAGE.Jade_STRING_1);
         _loc5_ = new Vector.<DisplayObject>();
         _loc7_ = int(this.FJadeTypeNames.length);
         _loc2_ = 0;
         while(_loc2_ < _loc7_)
         {
            _loc8_ = this.MakeComboItem(this.FJadeTypeNames[_loc2_]);
            _loc5_.push(_loc8_);
            _loc2_++;
         }
         this.FJadeTypeComboBox = new TComboBox(this,param1.mc_list_type,_loc5_,CONST_JADE.MAX_ComboboxHeight,this.OnTypeSelect);
         this.FJadeBackCollection = new TCollectionInventory(JadeClassNum);
      }
      
      protected function BackPackLocation() : void
      {
         this.FUIPage.PageSize = CONST_JADE.MAX_JadeCombineSlotCount;
         this.FUIPage.OnChangePage = this.PageOnChange;
         this.FUIPage.Init();
      }
      
      protected function SetButton() : void
      {
         this.FBTN_CombineAll.visible = false;
         this.FBTN_Combine.x = COMBINNOMAL_X;
         if(this.FCharacter.VipData.StoneOneTime)
         {
            this.FBTN_CombineAll.visible = true;
            this.FBTN_Combine.x = COMBINVIP_X;
            this.FTF_VipTip.visible = false;
         }
      }
      
      protected function UpdateBackpackJade() : void
      {
         var _loc1_:int = 0;
         var _loc2_:TUISlot = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TInventory = null;
         this.SelectCanShowJade(this.FJadeLevelComboBoxSelectIndex,this.FJadeTypeComboBoxSelectIndex,this.FSelectJadeUsetoShow);
         this.FSelectJadeUsetoShow.Sort();
         this.SetupJadePage(this.FSelectJadeUsetoShow.Count,this.FPageIndex);
         _loc3_ = int(this.FBackpackSlots.length);
         _loc4_ = this.FSelectJadeUsetoShow.Count;
         _loc5_ = this.FPageIndex * CONST_JADE.MAX_JadeCombineSlotCount;
         _loc1_ = 0;
         while(_loc1_ < _loc3_)
         {
            _loc2_ = this.FBackpackSlots[_loc1_];
            if(_loc1_ + _loc5_ < _loc4_)
            {
               _loc6_ = this.FSelectJadeUsetoShow.GetInventoryByIndex(_loc1_ + _loc5_) as TAppliance;
               _loc2_.Context = _loc6_;
            }
            else
            {
               _loc2_.Context = null;
            }
            _loc1_++;
         }
      }
      
      protected function GetJadeNum(param1:TInventory) : int
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TInventory = null;
         var _loc5_:TInventories = null;
         var _loc6_:int = 0;
         _loc5_ = SLogicsCore.Character.Gems;
         _loc6_ = 0;
         _loc3_ = _loc5_.Count;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = _loc5_.GetInventoryByIndex(_loc2_);
            if(_loc4_.IDTemplate == param1.IDTemplate)
            {
               _loc6_ += _loc4_.Quantity;
            }
            _loc2_++;
         }
         return _loc6_;
      }
      
      protected function SetupJadePage(param1:int, param2:int) : void
      {
         this.FUIPage.TotalQuantity = param1;
         this.FUIPage.Update();
         this.FUIPage.PageIndex = param2;
      }
      
      protected function SelectCanShowJade(param1:int, param2:int, param3:TInventories) : void
      {
         var _loc4_:TInventories = null;
         _loc4_ = SLogicsCore.Character.GetBackpackByIndex(CONST_COMMON.INVENTORIESINDEX_Gems);
         this.FSelectJadeUsetoShow.Clear();
         TJadeCommon.GetSpecialJade(_loc4_,this.FSelectJadeUsetoShow,CONST_JADE.ComboBoxJadeLevel[this.FJadeLevelComboBoxSelectIndex],CONST_JADE.ComboBoxJadeSecondType[this.FJadeTypeComboBoxSelectIndex]);
      }
      
      protected function MakeComboItem(param1:String) : DisplayObject
      {
         var _loc2_:MovieClip = null;
         _loc2_ = TUtilityReflection.CreateDisplayObjectInstance(CONST_JADE.RESOURCE_ClassName_ComboBoxItem) as MovieClip;
         _loc2_.tf_into.text = param1;
         return _loc2_;
      }
      
      protected function ResetBackPack() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TUISlot = null;
         _loc2_ = int(this.FBackpackSlots.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FBackpackSlots[_loc1_];
            _loc3_.Context = null;
            _loc1_++;
         }
         this.FJadeLevelComboBoxSelectIndex = 0;
         this.FJadeTypeComboBoxSelectIndex = 0;
         this.FPageIndex = 0;
         this.SetupJadePage(0,0);
         this.FSelectJadeUsetoShow.Clear();
         this.FSelectBox.visible = false;
         this.FSelectPage = -1;
      }
      
      protected function JadeCombineUIDispath(param1:MovieClip) : void
      {
         var _loc2_:MovieClip = null;
         this.FLeftJadeShowSlot = new TUISlot(this);
         _loc2_ = param1["mc_stone_0"];
         _loc2_["TF_Subscript"].visible = false;
         this.FLeftJadeShowSlot.Resource = _loc2_;
         this.FRightJadeShowSlot = new TUISlot(this);
         _loc2_ = param1["mc_stone_1"];
         _loc2_["TF_Subscript"].visible = false;
         this.FRightJadeShowSlot.Resource = _loc2_;
         this.FCombineJadeShowSlot = new TUISlot(this);
         _loc2_ = param1["mc_stone_2"];
         _loc2_["TF_Subscript"].visible = false;
         this.FCombineJadeShowSlot.Resource = _loc2_;
         this.FTF_CombineJadeNum = param1["tf_input"];
         this.FTF_CombineJadeMaxNum = param1["tf_max"];
         this.FBTN_MaxCombineNum = param1["btn_max"];
         this.FBTN_Combine = param1["btn_combin"];
         this.FBTN_CombineAll = param1["btn_combinAll"];
         this.FTF_VipTip = param1["tf_vipTip"];
         this.FTF_VipTip.mouseEnabled = false;
         this.FCombineEffect = param1["composeEff"];
         this.FCombineEffect.visible = false;
         this.FSelectBox = TUtilityReflection.CreateDisplayObjectInstance("Select_box") as Sprite;
         this.FSelectBox.mouseEnabled = false;
         param1.addChild(this.FSelectBox);
      }
      
      protected function JadeCombineLocation() : void
      {
         TJadeCommon.InitSlot(this.FLeftJadeShowSlot);
         this.FLeftJadeShowSlot.OnClick = this.CombineJadeSlotsOnClick;
         this.FLeftJadeShowSlot.Init();
         this.FLeftJadeShowSlot.OnOver = this.SlotsOnMove;
         this.FLeftJadeShowSlot.OnOut = this.SlotsOnOut;
         TJadeCommon.InitSlot(this.FRightJadeShowSlot);
         this.FRightJadeShowSlot.OnClick = this.CombineJadeSlotsOnClick;
         this.FRightJadeShowSlot.Init();
         this.FRightJadeShowSlot.OnOver = this.SlotsOnMove;
         this.FRightJadeShowSlot.OnOut = this.SlotsOnOut;
         TJadeCommon.InitSlot(this.FCombineJadeShowSlot);
         this.FCombineJadeShowSlot.OnClick = this.CombineJadeSlotsOnClick;
         this.FCombineJadeShowSlot.Init();
         this.FCombineJadeShowSlot.OnOver = this.SlotsOnMove;
         this.FCombineJadeShowSlot.OnOut = this.SlotsOnOut;
         this.FTF_CombineJadeNum.addEventListener(Event.CHANGE,this.OnJadeCombineInputChange);
         this.FTF_CombineJadeNum.type = TextFieldType.INPUT;
         this.FTF_CombineJadeMaxNum.text = "0";
         this.FTF_CombineJadeNum.text = "0";
         this.FIDTemplates = new Vector.<uint>(1);
         this.FCurrentJadeInventory = new TInventories();
         this.FUnstreamizerInventoryReference = new TUnstreamizerInventoryReference();
         TUtilityStandardBTN.SetBtnEventListener(this.FBTN_Combine,this.OnBtnCombineClick);
         TUtilityStandardBTN.SetBtnEventListener(this.FBTN_CombineAll,this.OnBtnCombineClick);
         this.FBTN_MaxCombineNum.addEventListener(MouseEvent.CLICK,this.OnBtnCombineMaxNumClick);
      }
      
      protected function UpdateCombineJadeShow() : void
      {
         var _loc1_:TBaseStone = null;
         var _loc2_:TArticle = null;
         var _loc3_:TAppliance = null;
         this.FLeftJadeShowSlot.Context = this.FCurrentShowJade;
         this.FRightJadeShowSlot.Context = this.FCurrentShowJade;
         _loc1_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_BaseStone,this.FCurrentShowJade.IDTemplate) as TBaseStone;
         this.FCurrentJadeInventory.Clear();
         this.FIDTemplates[0] = _loc1_.NextId;
         this.FUnstreamizerInventoryReference.UnstreamizeGenerateInventoriesByIdentifiers(null,this.FCurrentJadeInventory,this.FIDTemplates);
         _loc3_ = this.FCurrentJadeInventory.GetInventoryByIndex(0) as TAppliance;
         _loc2_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_Article,_loc3_.IDTemplate) as TArticle;
         _loc3_.IDTexture = uint(_loc2_.Picture);
         this.FCombineJadeShowSlot.Context = _loc3_;
         this.FCombineMaxNum = this.FCurrentCombineNum / 2;
         this.FTF_CombineJadeMaxNum.text = this.FCombineMaxNum.toString();
         this.FTF_CombineJadeNum.text = "1";
      }
      
      protected function ResetCombineJade() : void
      {
         this.FLeftJadeShowSlot.Context = null;
         this.FRightJadeShowSlot.Context = null;
      }
      
      protected function ResetCombine() : void
      {
         this.FCombineJadeShowSlot.Context = null;
         this.FTF_CombineJadeNum.text = "0";
         this.FTF_CombineJadeMaxNum.text = "0";
         this.FCurrentShowJade = null;
         this.FCurrentCombineNum = 0;
         this.FCombineMaxNum = 0;
         this.FBTN_Combine.gotoAndStop("Disable");
      }
      
      protected function OnJadeCombineInputChange(param1:Event) : void
      {
         var _loc2_:int = 0;
         _loc2_ = parseInt(this.FTF_CombineJadeNum.text);
         if(_loc2_ < 1)
         {
            this.FTF_CombineJadeNum.text = "1";
         }
         else if(_loc2_ > this.FCombineMaxNum)
         {
            this.FTF_CombineJadeNum.text = this.FCombineMaxNum.toString();
         }
      }
      
      protected function CombineJadeSlotsOnClick(param1:Object, param2:Object) : void
      {
         var _loc3_:TUISlot = null;
         _loc3_ = param1 as TUISlot;
         this.ResetCombineJade();
         this.ResetCombine();
         this.SlotsOnOut(param1,param2 as TInventory);
      }
      
      protected function BackpackJadeSlotsOnClick(param1:Object, param2:Object) : void
      {
         var _loc3_:TAppliance = null;
         var _loc4_:TUISlot = null;
         if(this.FWaiting)
         {
            return;
         }
         _loc3_ = param2 as TAppliance;
         _loc4_ = param1 as TUISlot;
         this.FSelectBox.x = _loc4_.Resource.x - 7;
         this.FSelectBox.y = _loc4_.Resource.y - 7;
         this.FSelectBox.visible = true;
         this.FSelectPage = this.FPageIndex;
         this.FCurrentCombineNum = this.GetJadeNum(_loc3_);
         if(this.FCurrentCombineNum < 2)
         {
            this.FFlyText(CONST_SYSTEMLANGUAGE.Jade_STRING_11);
            return;
         }
         if(_loc3_.RequirementLevel >= 12)
         {
            this.FFlyText(CONST_SYSTEMLANGUAGE.Jade_STRING_10);
            return;
         }
         this.FCurrentShowJade = _loc3_;
         this.UpdateCombineJadeShow();
         this.FBTN_Combine.gotoAndStop("Enable");
      }
      
      protected function OnLevelSelect(param1:Object, param2:int) : void
      {
         this.FJadeLevelComboBoxSelectIndex = param2;
         this.FPageIndex = 0;
         this.UpdateBackpackJade();
      }
      
      protected function OnTypeSelect(param1:Object, param2:int) : void
      {
         this.FJadeTypeComboBoxSelectIndex = param2;
         this.FPageIndex = 0;
         this.UpdateBackpackJade();
      }
      
      protected function PageOnChange(param1:Object, param2:int) : void
      {
         if(param2 == this.FSelectPage)
         {
            this.FSelectBox.visible = true;
         }
         else
         {
            this.FSelectBox.visible = false;
         }
         this.FPageIndex = param2;
         this.UpdateBackpackJade();
      }
      
      protected function OnBtnCombineClick(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:MovieClip = null;
         if(this.FWaiting)
         {
            return;
         }
         this.FWaiting = true;
         _loc3_ = param1.currentTarget as MovieClip;
         if(_loc3_.currentFrameLabel == "Disable")
         {
            this.FWaiting = false;
            return;
         }
         _loc2_ = parseInt(this.FTF_CombineJadeNum.text);
         if(this.FOnCombine != null)
         {
            if(_loc3_ == this.FBTN_Combine)
            {
               if(_loc2_ == 0)
               {
                  this.FWaiting = false;
                  return;
               }
               this.FOnCombine(this,0,this.FCurrentShowJade,_loc2_,0);
               this.FType = 0;
            }
            else if(_loc3_ == this.FBTN_CombineAll)
            {
               this.FAutoPopTip.PopTipVisible = true;
            }
            this.FCurrentState = STATE_WAITBACK;
         }
      }
      
      protected function OnBtnCombineMaxNumClick(param1:MouseEvent) : void
      {
         if(this.FWaiting)
         {
            return;
         }
         this.FTF_CombineJadeNum.text = this.FCombineMaxNum.toString();
      }
      
      protected function SlotsOnMove(param1:Object, param2:TInventory) : void
      {
         if(this.FOnInventoryOver != null)
         {
            this.FOnInventoryOver(param1,param2);
         }
      }
      
      protected function SlotsOnOut(param1:Object, param2:TInventory) : void
      {
         if(this.FOnInventoryOut != null)
         {
            this.FOnInventoryOut(param1,param2);
         }
      }
      
      private function PopTipOk(param1:Object, param2:uint) : void
      {
         if(this.FOnCombine != null)
         {
            this.FOnCombine(this,1,null,param2,param2);
            this.FType = 1;
         }
      }
      
      private function PopTipBack() : void
      {
         this.FWaiting = false;
      }
      
      public function set OnCombine(param1:Function) : void
      {
         this.FOnCombine = param1;
      }
      
      public function set OnInventoryOver(param1:Function) : void
      {
         this.FOnInventoryOver = param1;
      }
      
      public function set OnInventoryOut(param1:Function) : void
      {
         this.FOnInventoryOut = param1;
      }
      
      public function set FlyText(param1:Function) : void
      {
         this.FFlyText = param1;
      }
      
      public function set ResultCode(param1:int) : void
      {
         this.FResultCode = param1;
      }
      
      public function Update() : void
      {
         switch(this.FCurrentState)
         {
            case STATE_READY:
               this.ResetBackPack();
               break;
            case STATE_WAITBACK:
               this.FCurrentState = STATE_READY;
               if(this.FResultCode == 0)
               {
                  this.FSelectBox.visible = false;
                  this.UpdateBackpackJade();
                  this.FCombineEffect.gotoAndPlay(1);
                  this.FCombineEffect.visible = true;
                  this.ResetCombineJade();
                  this.FFlyText(CONST_SYSTEMLANGUAGE.Jade_STRING_7);
               }
               else if(this.FResultCode == 3)
               {
                  this.FFlyText(CONST_SYSTEMLANGUAGE.Jade_STRING_13);
               }
               else if(this.FType == 0)
               {
                  this.FFlyText(CONST_SYSTEMLANGUAGE.Jade_STRING_12);
               }
               else if(this.FType == 1)
               {
                  this.FFlyText(CONST_SYSTEMLANGUAGE.Jade_STRING_14);
               }
         }
         this.SetButton();
         this.UpdateBackpackJade();
      }
      
      public function Reset() : void
      {
         this.ResetBackPack();
         this.ResetCombineJade();
         this.ResetCombine();
         this.FJadeLevelComboBox.HideComboBoxList();
         this.FJadeTypeComboBox.HideComboBoxList();
         this.FCombineEffect.gotoAndStop(1);
         this.FCombineEffect.visible = false;
         this.FType = 100;
         this.FWaiting = false;
      }
   }
}

