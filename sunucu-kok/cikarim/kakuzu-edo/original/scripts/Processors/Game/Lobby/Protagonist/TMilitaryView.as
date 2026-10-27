package Processors.Game.Lobby.Protagonist
{
   import Foundation.Resources.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.Military.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Utilities.*;
   import Processors.Game.Utilities.HyperLink.*;
   import Resources.Constants.*;
   import Resources.Strings.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class TMilitaryView extends TProcessorLobbyWindow
   {
      
      protected static const PRESTIGE_ENOUGH:uint = 4285071106;
      
      protected static const PRESTIGE_NOT_ENOUGH:uint = 4294836224;
      
      protected static const PROPERTY_NUM:uint = 6;
      
      protected var FTF_CurrentMilitaryPrefixName:TextField;
      
      protected var FTF_CurrentMilitarySubfixName:TextField;
      
      protected var FTF_NextMilitarySubfixName:TextField;
      
      protected var FTF_CurrentMilitaryDayCost:TextField;
      
      protected var FTF_CurrentMilitarySiliverCoin:TextField;
      
      protected var FTF_CurrentMilitarySpirit:TextField;
      
      protected var FTF_CurrentMilitaryMaxHeroNum:TextField;
      
      protected var FTF_CurrentMilitaryMaxFightHeroNum:TextField;
      
      protected var FTF_CurNeedPrestige:TextField;
      
      protected var FTF_CurrentPresitige:TextField;
      
      protected var FMC_CurPropertyList:Vector.<MovieClip>;
      
      protected var FTF_PointMilitaryPrefixName:TextField;
      
      protected var FTF_PointMilitarySubfixName:TextField;
      
      protected var FTF_PointMilitaryName:TextField;
      
      protected var FTF_PointMilitaryDayCost:TextField;
      
      protected var FTF_PointMilitarySiliverCoin:TextField;
      
      protected var FTF_PointMilitarySpirit:TextField;
      
      protected var FTF_PointMilitaryMaxHeroNum:TextField;
      
      protected var FTF_PointMilitaryMaxFightHeroNum:TextField;
      
      protected var FTF_NextNeedPrestige:TextField;
      
      protected var FMC_NextPropertyList:Vector.<MovieClip>;
      
      protected var FMCArray_MilitaryCard:Array;
      
      protected var FArrorLeft_MilitaryCard:MovieClip;
      
      protected var FArrorRight_MilitaryCard:MovieClip;
      
      protected var FTF_UpgradeNeedPresitige:TextField;
      
      protected var FStartMilitaryIDInMilitaryCards:int;
      
      protected var FSelectMilitaryCardId:int;
      
      protected var FCurrentMilitary_Arrow:MovieClip;
      
      protected var FMaxMilitaryID:int;
      
      protected var FBTN_Close:SimpleButton;
      
      protected var FBTN_Infor:SimpleButton;
      
      protected var FBTN_UpgradeMilitary:MovieClip;
      
      protected var FTFGotoArena:TextField;
      
      protected var FPendantLeft:MovieClip;
      
      protected var FPendantRight:MovieClip;
      
      protected var FUIDispatchRoutines:Vector.<Function>;
      
      protected var FUILocationRoutines:Vector.<Function>;
      
      protected var FMilitaryData:TMilitaryData;
      
      protected var FOnUpgradeMilitary:Function;
      
      protected var FOnBack:Function;
      
      protected var FUpdateHeroPower:Function;
      
      protected var FOnCloseList:Function;
      
      public function TMilitaryView(param1:TUIComponent)
      {
         super(param1);
         this.FMC_CurPropertyList = new Vector.<MovieClip>(PROPERTY_NUM);
         this.FMC_NextPropertyList = new Vector.<MovieClip>(PROPERTY_NUM);
         this.ConstructDispath();
         this.ConstructLocation();
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_PROTAGONIST.RESOURCESID_Swf_MilitaryList);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Function = null;
         var _loc3_:MovieClip = null;
         _loc3_ = TUtilityReflection.CreateDisplayObjectInstance("MilitaryInforUI") as MovieClip;
         addChild(_loc3_);
         _loc1_ = 0;
         while(_loc1_ < this.FUIDispatchRoutines.length)
         {
            _loc2_ = this.FUIDispatchRoutines[_loc1_];
            _loc2_(_loc3_);
            _loc1_++;
         }
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Function = null;
         _loc1_ = 0;
         while(_loc1_ < this.FUIDispatchRoutines.length)
         {
            _loc2_ = this.FUILocationRoutines[_loc1_];
            _loc2_();
            _loc1_++;
         }
         super.ResourcesPerform_UILocations();
      }
      
      protected function ConstructDispath() : void
      {
         this.FUIDispatchRoutines = new Vector.<Function>();
         this.FUIDispatchRoutines.push(this.DispatchUICurrentMilitary);
         this.FUIDispatchRoutines.push(this.DispatchUIPointMilitary);
         this.FUIDispatchRoutines.push(this.DispatchUIMilitaryCards);
         this.FUIDispatchRoutines.push(this.DispatchUIButton);
      }
      
      protected function ConstructLocation() : void
      {
         this.FUILocationRoutines = new Vector.<Function>();
         this.FUILocationRoutines.push(this.LocationCurrentMilitary);
         this.FUILocationRoutines.push(this.LocationPointMilitary);
         this.FUILocationRoutines.push(this.LocationMilitaryMilitaryCards);
         this.FUILocationRoutines.push(this.LocationButton);
      }
      
      protected function DispatchUICurrentMilitary(param1:MovieClip) : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:int = 0;
         var _loc4_:uint = 0;
         _loc2_ = param1["CurrentMilitaryName"];
         this.FTF_CurrentMilitarySubfixName = param1["TF_CurrentMilitaryName"];
         this.FTF_CurrentMilitaryDayCost = param1["TF_CostPrestige"];
         this.FTF_CurrentMilitarySiliverCoin = param1["TF_Silivercoin_Military"];
         this.FTF_CurrentMilitarySpirit = param1["TF_Spirit_Military"];
         this.FTF_CurrentMilitaryMaxHeroNum = param1["TF_MaxHeroNum"];
         this.FTF_CurrentMilitaryMaxFightHeroNum = param1["TF_FightHeroNum"];
         this.FTF_CurNeedPrestige = param1["TF_CurNeedPrestige"];
         this.FTF_CurrentPresitige = param1["TF_Prestige"];
         _loc4_ = PROPERTY_NUM;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            this.FMC_CurPropertyList[_loc3_] = param1["mc_curProperty_" + _loc3_];
            _loc3_++;
         }
      }
      
      protected function LocationCurrentMilitary() : void
      {
      }
      
      protected function UpdateCurrentMilitary() : void
      {
         var _loc1_:TMilitaryLocalData = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _loc1_ = this.GetMilitaryLocalInforByMilitaryRank(this.FMilitaryData.MilitaryRank);
         this.FTF_CurrentMilitarySubfixName.text = _loc1_.AnyMilitaryName;
         this.FTF_CurrentMilitaryDayCost.text = _loc1_.AnyMilitaryCreditDayCost.toString();
         this.FTF_CurrentMilitarySiliverCoin.text = _loc1_.AnyMilitarySalarySilvercoin.toString();
         this.FTF_CurrentMilitarySpirit.text = _loc1_.AnyMilitarySalarySpirit.toString();
         this.FTF_CurrentMilitaryMaxHeroNum.text = _loc1_.AnyMilitaryMaxHeroNum.toString();
         this.FTF_CurrentMilitaryMaxFightHeroNum.text = _loc1_.AnyMilitaryFightHeroNum.toString();
         this.FTF_CurNeedPrestige.text = _loc1_.UpgradeAnyLevelNeedCredit.toString();
         _loc3_ = _loc1_.AnyMilitaryUseableCount;
         this.FTF_CurrentPresitige.text = this.FMilitaryData.CurrentCredit.toString();
         _loc3_ = int(PROPERTY_NUM);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(_loc1_.AnyMilitaryAttributesValue[_loc2_] != null)
            {
               this.FMC_CurPropertyList[_loc2_].visible = true;
               this.FMC_CurPropertyList[_loc2_].mc_Property.gotoAndStop(_loc2_ + 1);
               this.FMC_CurPropertyList[_loc2_].tf_Property.text = this.CreateAddAttributeShowString(_loc1_.AnyMilitaryAttributesValue[_loc2_],_loc2_);
            }
            else
            {
               this.FMC_CurPropertyList[_loc2_].visible = false;
            }
            _loc2_++;
         }
         _loc1_ = this.GetMilitaryLocalInforByMilitaryRank(this.FMilitaryData.MilitaryRank + 1);
         if(_loc1_ == null)
         {
            this.ResetNext();
            this.FTF_UpgradeNeedPresitige.text = "";
            return;
         }
         _loc4_ = _loc1_.UpgradeAnyLevelNeedCredit - this.FMilitaryData.CurrentCredit;
         if(_loc4_ < 0)
         {
            _loc4_ = 0;
         }
         this.FTF_UpgradeNeedPresitige.text = _loc4_.toString();
         if(this.FMilitaryData.CurrentCredit >= _loc1_.UpgradeAnyLevelNeedCredit)
         {
            this.FTF_CurrentPresitige.textColor = PRESTIGE_ENOUGH;
         }
         else
         {
            this.FTF_CurrentPresitige.textColor = PRESTIGE_NOT_ENOUGH;
         }
      }
      
      private function ResetNext() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         this.FTF_NextMilitarySubfixName.text = "";
         this.FTF_PointMilitaryDayCost.text = "";
         this.FTF_PointMilitarySiliverCoin.text = "";
         this.FTF_PointMilitarySpirit.text = "";
         this.FTF_PointMilitaryMaxHeroNum.text = "";
         this.FTF_PointMilitaryMaxFightHeroNum.text = "";
         this.FTF_NextNeedPrestige.text = "";
         _loc2_ = PROPERTY_NUM;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FMC_NextPropertyList[_loc1_].visible = false;
            _loc1_++;
         }
      }
      
      protected function CreateAddAttributeShowString(param1:String, param2:int) : String
      {
         var _loc3_:int = 0;
         if(param2 > 3)
         {
            _loc3_ = Number(param1) * 100;
            param1 = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.Protagonist_STRING_0),_loc3_.toString());
         }
         return "+" + param1;
      }
      
      protected function GetMilitaryLocalInforByMilitaryRank(param1:int) : TMilitaryLocalData
      {
         var _loc2_:int = 0;
         var _loc3_:TMilitaryLocalData = null;
         _loc2_ = param1 - CONST_PROTAGONIST.MilitaryInforMinID;
         if(_loc2_ >= 0 && _loc2_ < this.FMilitaryData.InforCount)
         {
            _loc3_ = this.FMilitaryData.GetMilitaryInforByIndex(_loc2_);
         }
         return _loc3_;
      }
      
      protected function DispatchUIPointMilitary(param1:MovieClip) : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:int = 0;
         var _loc4_:uint = 0;
         _loc2_ = param1["PointMilitaryName"];
         this.FTF_NextMilitarySubfixName = param1["TF_NextMilitaryName"];
         this.FTF_PointMilitaryDayCost = param1["TF_NextCostPrestige"];
         this.FTF_PointMilitarySiliverCoin = param1["TF_NextSilivercoin_PointMilitary"];
         this.FTF_PointMilitarySpirit = param1["TF_NextSpirit_PointMilitary"];
         this.FTF_PointMilitaryMaxHeroNum = param1["TF_NextMaxHeroNum_PointMilitary"];
         this.FTF_PointMilitaryMaxFightHeroNum = param1["TF_NextFightHeroNum_PointMilitary"];
         this.FTF_NextNeedPrestige = param1["TF_NextNeedPrestige"];
         _loc4_ = PROPERTY_NUM;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            this.FMC_NextPropertyList[_loc3_] = param1["mc_nextProperty_" + _loc3_];
            _loc3_++;
         }
      }
      
      protected function LocationPointMilitary() : void
      {
      }
      
      protected function UpdatePointMilitaryInfor(param1:int) : void
      {
         var _loc2_:TMilitaryLocalData = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         _loc2_ = this.GetMilitaryLocalInforByMilitaryRank(param1);
         this.FTF_NextMilitarySubfixName.text = _loc2_.AnyMilitaryName;
         this.FTF_PointMilitaryDayCost.text = _loc2_.AnyMilitaryCreditDayCost.toString();
         this.FTF_PointMilitarySiliverCoin.text = _loc2_.AnyMilitarySalarySilvercoin.toString();
         this.FTF_PointMilitarySpirit.text = _loc2_.AnyMilitarySalarySpirit.toString();
         this.FTF_PointMilitaryMaxHeroNum.text = _loc2_.AnyMilitaryMaxHeroNum.toString();
         this.FTF_PointMilitaryMaxFightHeroNum.text = _loc2_.AnyMilitaryFightHeroNum.toString();
         this.FTF_NextNeedPrestige.text = _loc2_.UpgradeAnyLevelNeedCredit.toString();
         _loc4_ = _loc2_.AnyMilitaryUseableCount;
         _loc5_ = 0;
         _loc4_ = int(PROPERTY_NUM);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            if(_loc2_.AnyMilitaryAttributesValue[_loc3_] != null)
            {
               this.FMC_NextPropertyList[_loc3_].visible = true;
               this.FMC_NextPropertyList[_loc3_].mc_Property.gotoAndStop(_loc3_ + 1);
               this.FMC_NextPropertyList[_loc3_].tf_Property.text = this.CreateAddAttributeShowString(_loc2_.AnyMilitaryAttributesValue[_loc3_],_loc3_);
            }
            else
            {
               this.FMC_NextPropertyList[_loc3_].visible = false;
            }
            _loc3_++;
         }
      }
      
      protected function DispatchUIMilitaryCards(param1:MovieClip) : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:int = 0;
         this.FMCArray_MilitaryCard = new Array();
         _loc3_ = 0;
         while(_loc3_ < CONST_PROTAGONIST.MILITARYCARD_NUM)
         {
            _loc2_ = param1["Military_Card_" + _loc3_];
            this.FMCArray_MilitaryCard.push(_loc2_);
            _loc3_++;
         }
         this.FArrorLeft_MilitaryCard = param1["MC_ArrorLeft"];
         this.FArrorRight_MilitaryCard = param1["MC_ArrorRight"];
         this.FTF_UpgradeNeedPresitige = param1["TF_NeedPrestige"];
         this.FCurrentMilitary_Arrow = param1["MC_CurrentMilitary"];
      }
      
      protected function LocationMilitaryMilitaryCards() : void
      {
         var _loc1_:int = 0;
         var _loc2_:MovieClip = null;
         TUtilityStandardBTN.SetBtnEventListener(this.FArrorLeft_MilitaryCard,this.LeftArrorOnMouseClick);
         TUtilityStandardBTN.SetBtnEventListener(this.FArrorRight_MilitaryCard,this.RightArrorOnMouseClick);
         _loc1_ = 0;
         while(_loc1_ < CONST_PROTAGONIST.MILITARYCARD_NUM)
         {
            _loc2_ = this.FMCArray_MilitaryCard[_loc1_];
            _loc2_.addEventListener(MouseEvent.CLICK,this.OnMilitaryCardClick);
            _loc2_.addEventListener(MouseEvent.MOUSE_MOVE,this.OnMilitaryCardMove);
            _loc2_.addEventListener(MouseEvent.MOUSE_OUT,this.OnMilitaryCardOut);
            _loc2_.buttonMode = true;
            _loc2_.mouseChildren = false;
            _loc1_++;
         }
         this.FArrorLeft_MilitaryCard.buttonMode = true;
         this.FArrorRight_MilitaryCard.buttonMode = true;
      }
      
      protected function UpdateMilitaryCardInfor() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < CONST_PROTAGONIST.MILITARYCARD_NUM)
         {
            this.FlushTextMilitaryCard(this.FMCArray_MilitaryCard[_loc1_],this.FStartMilitaryIDInMilitaryCards + _loc1_);
            if(this.FMCArray_MilitaryCard[_loc1_]["MC_PreMilitary"] != null)
            {
               this.FMCArray_MilitaryCard[_loc1_]["MC_PreMilitary"].visible = this.FStartMilitaryIDInMilitaryCards + _loc1_ < this.FMilitaryData.MilitaryRank;
            }
            _loc1_++;
         }
         this.FCurrentMilitary_Arrow.visible = false;
         _loc2_ = this.FMilitaryData.MilitaryRank - this.FStartMilitaryIDInMilitaryCards;
         if(_loc2_ <= CONST_PROTAGONIST.MILITARYCARD_NUM - 1 && _loc2_ >= 0)
         {
            this.FCurrentMilitary_Arrow.visible = true;
            this.FCurrentMilitary_Arrow.y = this.FMCArray_MilitaryCard[_loc2_].y - 7;
            this.FMCArray_MilitaryCard[_loc2_]["MC_PreMilitary"].visible = false;
         }
      }
      
      protected function UpdateMilitaryArrorState() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc2_ = CONST_PROTAGONIST.MilitaryInforMinID;
         if(this.FStartMilitaryIDInMilitaryCards <= _loc2_)
         {
            this.FArrorLeft_MilitaryCard.gotoAndStop("Disable");
         }
         else
         {
            this.FArrorLeft_MilitaryCard.gotoAndStop("Enable");
         }
         _loc1_ = CONST_PROTAGONIST.MilitaryInforMaxID - CONST_PROTAGONIST.MILITARYCARD_NUM + 1;
         if(this.FStartMilitaryIDInMilitaryCards >= _loc1_)
         {
            this.FArrorRight_MilitaryCard.gotoAndStop("Disable");
         }
         else
         {
            this.FArrorRight_MilitaryCard.gotoAndStop("Enable");
         }
      }
      
      protected function FlushTextMilitaryCard(param1:MovieClip, param2:int) : void
      {
         var _loc3_:TMilitaryLocalData = null;
         var _loc4_:TextField = null;
         var _loc5_:MovieClip = null;
         _loc3_ = this.GetMilitaryLocalInforByMilitaryRank(param2);
         if(param2 == this.FSelectMilitaryCardId)
         {
            if(param2 > this.FMilitaryData.MilitaryRank)
            {
               param1.gotoAndStop("BlackChoosed");
            }
            else
            {
               param1.gotoAndStop("WhiteChoosed");
            }
            _loc5_ = param1["SelectTask"];
            _loc5_.gotoAndPlay(1);
         }
         else if(param2 > this.FMilitaryData.MilitaryRank)
         {
            param1.gotoAndStop("BlackUnchoosed");
         }
         else
         {
            param1.gotoAndStop("WhiteUnchoosed");
         }
         _loc4_ = param1["rolename"];
         _loc4_.text = _loc3_.AnyMilitaryName;
      }
      
      protected function DispatchUIButton(param1:MovieClip) : void
      {
         this.FBTN_Close = param1["BTN_Close"];
         this.FBTN_Infor = param1["Btn_Infor"];
         this.FBTN_UpgradeMilitary = param1["MC_UpgradeMilitary"];
         this.FPendantLeft = param1["MC_PendantLeft"];
         this.FPendantRight = param1["MC_PendantRight"];
         this.FTFGotoArena = param1["TF_Arena"];
      }
      
      protected function LocationButton() : void
      {
         this.FBTN_Close.addEventListener(MouseEvent.CLICK,this.OnBtnCloseClick);
         TUtilityStandardBTN.SetBtnEventListener(this.FBTN_UpgradeMilitary,this.OnUpgradeMilitaryClick);
         this.FBTN_UpgradeMilitary.buttonMode = true;
         this.FTFGotoArena.htmlText = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.Protagonist_STRING_4);
         this.FTFGotoArena.addEventListener(TextEvent.LINK,this.GotoArena);
      }
      
      protected function ShackPendant() : void
      {
         this.FPendantLeft.gotoAndPlay(1);
         this.FPendantRight.gotoAndPlay(1);
      }
      
      protected function StopPendant() : void
      {
         this.FPendantLeft.gotoAndStop(1);
         this.FPendantRight.gotoAndStop(1);
      }
      
      protected function UpdateBtns(param1:uint = 0) : void
      {
         var _loc2_:TMilitaryLocalData = null;
         var _loc3_:TMilitaryLocalData = null;
         _loc2_ = this.GetMilitaryLocalInforByMilitaryRank(this.FMilitaryData.MilitaryRank + 1);
         if(_loc2_ == null)
         {
            this.FBTN_UpgradeMilitary.gotoAndStop("Disable");
            return;
         }
         if(this.FMilitaryData.CurrentCredit < _loc2_.UpgradeAnyLevelNeedCredit)
         {
            this.FBTN_UpgradeMilitary.gotoAndStop("Disable");
         }
         else
         {
            this.FBTN_UpgradeMilitary.gotoAndStop("Enable");
         }
         if(param1 != 0)
         {
            _loc3_ = this.GetMilitaryLocalInforByMilitaryRank(param1);
            if(_loc3_ != _loc2_)
            {
               this.FBTN_UpgradeMilitary.gotoAndStop("Disable");
            }
            else if(this.FMilitaryData.CurrentCredit < _loc2_.UpgradeAnyLevelNeedCredit)
            {
               this.FBTN_UpgradeMilitary.gotoAndStop("Disable");
            }
            else
            {
               this.FBTN_UpgradeMilitary.gotoAndStop("Enable");
            }
         }
      }
      
      protected function OnBtnCloseClick(param1:MouseEvent) : void
      {
         if(this.FOnCloseList != null)
         {
            this.FOnCloseList();
         }
      }
      
      protected function OnUpgradeMilitaryClick(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = null;
         _loc2_ = param1.currentTarget as MovieClip;
         if(_loc2_.currentLabel != "Disable")
         {
            if(this.FOnUpgradeMilitary != null)
            {
               this.FOnUpgradeMilitary();
            }
         }
      }
      
      protected function GotoArena(param1:TextEvent) : void
      {
         SUtilityHyperLink.ShortcutHyperlink(TUtilityHyperLink.HyperLink_Arena);
      }
      
      protected function LeftArrorOnMouseClick(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:int = 0;
         _loc2_ = param1.currentTarget as MovieClip;
         _loc3_ = CONST_PROTAGONIST.MilitaryInforMinID;
         if(this.FStartMilitaryIDInMilitaryCards > _loc3_)
         {
            --this.FStartMilitaryIDInMilitaryCards;
            this.UpdateMilitaryCardInfor();
         }
         this.UpdateMilitaryArrorState();
      }
      
      protected function RightArrorOnMouseClick(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:int = 0;
         _loc2_ = param1.currentTarget as MovieClip;
         _loc3_ = CONST_PROTAGONIST.MilitaryInforMaxID - CONST_PROTAGONIST.MILITARYCARD_NUM + 1;
         if(this.FStartMilitaryIDInMilitaryCards < _loc3_)
         {
            ++this.FStartMilitaryIDInMilitaryCards;
            this.UpdateMilitaryCardInfor();
         }
         this.UpdateMilitaryArrorState();
      }
      
      protected function OnMilitaryCardClick(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < this.FMCArray_MilitaryCard.length)
         {
            if(param1.currentTarget == this.FMCArray_MilitaryCard[_loc2_])
            {
               break;
            }
            _loc2_++;
         }
         this.FSelectMilitaryCardId = this.FStartMilitaryIDInMilitaryCards + _loc2_;
         this.UpdatePointMilitaryInfor(this.FSelectMilitaryCardId);
         this.UpdateMilitaryCardInfor();
         this.UpdateBtns(this.FSelectMilitaryCardId);
      }
      
      protected function OnMilitaryCardMove(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = null;
         _loc2_ = param1.currentTarget as MovieClip;
         if(_loc2_.currentFrame == 1 || _loc2_.currentFrame == 4)
         {
            _loc2_.gotoAndStop(_loc2_.currentFrame + 1);
         }
      }
      
      protected function OnMilitaryCardOut(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = null;
         _loc2_ = param1.currentTarget as MovieClip;
         if(_loc2_.currentFrame == 2 || _loc2_.currentFrame == 5)
         {
            _loc2_.gotoAndStop(_loc2_.currentFrame - 1);
         }
      }
      
      public function set MilitaryData(param1:TMilitaryData) : void
      {
         this.FMilitaryData = param1;
      }
      
      public function set OnUpgradeMilitary(param1:Function) : void
      {
         this.FOnUpgradeMilitary = param1;
      }
      
      public function set OnBack(param1:Function) : void
      {
         this.FOnBack = param1;
      }
      
      public function set UpdateHeroPower(param1:Function) : void
      {
         this.FUpdateHeroPower = param1;
      }
      
      public function get OnCloseList() : Function
      {
         return this.FOnCloseList;
      }
      
      public function set OnCloseList(param1:Function) : void
      {
         this.FOnCloseList = param1;
      }
      
      public function Update() : void
      {
         var _loc1_:int = 0;
         if(this.FMilitaryData == null)
         {
            return;
         }
         this.UpdateCurrentMilitary();
         if(this.FMilitaryData.MilitaryRank < CONST_PROTAGONIST.MilitaryInforMaxID)
         {
            this.FSelectMilitaryCardId = this.FMilitaryData.MilitaryRank + 1;
            this.UpdatePointMilitaryInfor(this.FSelectMilitaryCardId);
         }
         else
         {
            this.FSelectMilitaryCardId = this.FMilitaryData.MilitaryRank;
            this.UpdatePointMilitaryInfor(this.FSelectMilitaryCardId);
         }
         _loc1_ = CONST_PROTAGONIST.MilitaryInforMaxID - CONST_PROTAGONIST.MILITARYCARD_NUM + 1;
         this.FStartMilitaryIDInMilitaryCards = this.FMilitaryData.MilitaryRank;
         if(this.FStartMilitaryIDInMilitaryCards > _loc1_)
         {
            this.FStartMilitaryIDInMilitaryCards = _loc1_;
         }
         this.UpdateMilitaryArrorState();
         this.UpdateMilitaryCardInfor();
         this.UpdateBtns();
      }
      
      public function Show() : void
      {
         this.visible = true;
      }
   }
}

