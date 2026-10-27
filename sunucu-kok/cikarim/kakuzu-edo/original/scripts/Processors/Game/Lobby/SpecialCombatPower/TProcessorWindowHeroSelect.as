package Processors.Game.Lobby.SpecialCombatPower
{
   import Components.Standard.TUIButton;
   import Foundation.Resources.Bins.TBins;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Logics.Characters.THero;
   import Logics.Characters.THeros;
   import Logics.DatebaseVO.VO.TArticle;
   import Logics.DatebaseVO.VO.TFighterDetail;
   import Logics.DatebaseVO.VO.THeroChangeAttr;
   import Logics.FighterDetail.TFighterDetailData;
   import Logics.FighterDetail.TFighterDetails;
   import Logics.SLogicsCore;
   import Logics.Streamization.Characters.TUnstreamizerCharacter;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import Processors.Game.Lobby.Components.TUICredits;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Resources.Constants.CONST_COMMON;
   import Resources.Constants.CONST_DATEBASEVO;
   import Resources.Constants.CONST_SPECIALCOMBATPOWER;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import ghostcat.util.easing.TweenUtil;
   
   public class TProcessorWindowHeroSelect extends TProcessorLobbyWindow
   {
      
      protected static var MOVE_POS:int = 79;
      
      protected const HERO_LEN:int = 7;
      
      protected const SHOW_TIME:int = 200;
      
      protected const MOVE_TIME:int = 500;
      
      protected var FMainUI:Sprite;
      
      protected var FPersonInfoView:TprocessorPersonCombatInfomation;
      
      protected var FPersonPanel:Sprite;
      
      protected var FBtnClose:TUIButton;
      
      protected var FBtnHelp:TUIButton;
      
      protected var FBtnBack:TUIButton;
      
      protected var FUICredits:TUICredits;
      
      protected var FHeroList:Vector.<MovieClip>;
      
      protected var FHeroListButton:Vector.<TUIButton>;
      
      protected var FSelectHeroIndex:int = 0;
      
      protected var FIsScanSelectHero:Boolean = true;
      
      protected var FIsShowPersonInfoView:Boolean = false;
      
      protected var FSelectBtn_PosX:int = 0;
      
      protected var FSelectBtn_PosY:int = 0;
      
      protected var FIsOperate:Boolean;
      
      protected var FTBins:TBins;
      
      protected var FChangeHeroAttrTBins:TBins;
      
      protected var FUnstreamizerCharacter:TUnstreamizerCharacter;
      
      protected var FFighterDetails:TFighterDetails;
      
      protected var FOnUpdateHerosBaseAttributeReq:Function;
      
      public function TProcessorWindowHeroSelect(param1:TUIComponent)
      {
         super(param1);
         this.FHeroList = new Vector.<MovieClip>();
         this.FHeroListButton = new Vector.<TUIButton>();
         this.FFighterDetails = new TFighterDetails();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:MovieClip = null;
         var _loc4_:TUIButton = null;
         _loc2_ = this.HERO_LEN;
         this.FMainUI = TUtilityReflection.CreateDisplayObjectInstance("SpecialPowerUI") as Sprite;
         addChild(this.FMainUI);
         this.FPersonPanel = this.FMainUI["MC_PersonInfo"];
         this.FPersonInfoView = new TprocessorPersonCombatInfomation(this.FPersonPanel);
         this.FPersonInfoView.CloseViewFun = this.BtnCloseOnClick;
         this.FPersonPanel.visible = false;
         this.FBtnClose = new TUIButton();
         this.FBtnClose.Substrate = this.FMainUI["MC_Btns"]["Btn_Close"];
         this.FBtnClose.OnClick = this.BtnCloseOnClick;
         this.FBtnHelp = new TUIButton();
         this.FBtnHelp.Substrate = this.FMainUI["MC_Btns"]["Btn_Help"];
         this.FBtnHelp.OnClick = this.BtnShowHelpOnClick;
         this.FBtnBack = new TUIButton();
         this.FBtnBack.Substrate = this.FMainUI["Btn_Back"];
         this.FBtnBack.Visible = false;
         this.FBtnBack.OnClick = this.SelectHeroHandler;
         this.FUICredits = new TUICredits();
         this.FUICredits.Resource = this.FMainUI["MC_PanelCredits"];
         this.FUICredits.HintOnMove = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FUICredits.HintOnOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FUICredits.UpdatePanel();
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FMainUI["Hero" + _loc1_];
            _loc4_ = new TUIButton();
            _loc4_.Substrate = _loc3_;
            _loc4_.OnClick = this.SelectHeroHandler;
            this.FHeroList[_loc1_] = _loc3_;
            this.FHeroListButton[_loc1_] = _loc4_;
            _loc1_++;
         }
         this.FTBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_FighterDetail);
         this.FChangeHeroAttrTBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_HeroChangeAttr);
         this.FUnstreamizerCharacter = new TUnstreamizerCharacter();
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         super.ResourcesPerform_UILocations();
      }
      
      protected function InitData() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:int = 0;
         var _loc3_:THero = null;
         var _loc4_:THero = null;
         var _loc5_:Vector.<uint> = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:TArticle = null;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:TFighterDetail = null;
         var _loc12_:TFighterDetail = null;
         var _loc13_:TFighterDetailData = null;
         var _loc14_:TFighterDetailData = null;
         _loc6_ = this.HERO_LEN;
         _loc7_ = 0;
         var _loc15_:THeros = this.FFighterDetails.Heros;
         _loc5_ = new Vector.<uint>();
         _loc7_ = 0;
         while(_loc7_ < _loc6_)
         {
            _loc5_.length = 0;
            _loc11_ = this.FTBins.GetDatebaseByIndex(_loc7_) as TFighterDetail;
            _loc1_ = uint(_loc11_.Identifier);
            _loc5_.push(_loc1_);
            _loc2_ = _loc11_.UpHeroID;
            _loc5_.push(_loc2_);
            _loc12_ = this.FTBins.GetDatebaseByIdentifier(_loc2_) as TFighterDetail;
            _loc3_ = SLogicsCore.Character.Heros.GetHeroByIdentifier(_loc1_);
            _loc4_ = SLogicsCore.Character.Heros.GetHeroByIdentifier(_loc2_);
            _loc13_ = new TFighterDetailData();
            _loc14_ = new TFighterDetailData();
            _loc13_.IsCanEnlist = _loc3_ == null && _loc4_ == null;
            _loc14_.IsCanEnlist = _loc3_ != null && _loc4_ == null;
            this.FUnstreamizerCharacter.UnstreamizeGenerateHerosByIdentifiers(null,_loc15_,_loc5_);
            _loc13_.HeroID = _loc11_.Identifier;
            _loc10_ = int(CONST_COMMON.RewardIDToTemplateID(_loc11_.AskNeedArticalItem.Type,_loc11_.AskNeedArticalItem.Code));
            _loc8_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_Article,_loc10_) as TArticle;
            _loc13_.AskNeed = _loc8_.Name;
            _loc13_.ItemAskID = _loc10_;
            _loc13_.ItemAskAmount = _loc11_.AskNeedArticalItem.Amount;
            _loc9_ = int(CONST_COMMON.RewardIDToTemplateID(_loc11_.EnlistPaperArticalItem.Type,_loc11_.EnlistPaperArticalItem.Code));
            _loc8_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_Article,_loc9_) as TArticle;
            _loc13_.EnlistPaper = _loc8_.Name;
            _loc13_.ItemEnlistID = _loc9_;
            _loc13_.ItemEnlistAmount = _loc11_.EnlistPaperArticalItem.Amount;
            _loc13_.UpHeroID = _loc11_.UpHeroID;
            _loc13_.VipLevel = _loc11_.VipLimit;
            _loc13_.RoleLevel = _loc11_.MainHeroLevel;
            _loc13_.Type = _loc11_.Stype;
            _loc13_.FightReportAddr = _loc11_.FightReportAddr;
            _loc13_.StarLevel = (this.FChangeHeroAttrTBins.GetDatebaseByIdentifier(_loc13_.HeroID) as THeroChangeAttr).HeroStar.length;
            _loc14_.HeroID = _loc12_.Identifier;
            _loc10_ = int(CONST_COMMON.RewardIDToTemplateID(_loc12_.AskNeedArticalItem.Type,_loc12_.AskNeedArticalItem.Code));
            _loc8_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_Article,_loc10_) as TArticle;
            _loc14_.AskNeed = _loc8_.Name;
            _loc14_.ItemAskID = _loc10_;
            _loc14_.ItemAskAmount = _loc12_.AskNeedArticalItem.Amount;
            _loc9_ = int(CONST_COMMON.RewardIDToTemplateID(_loc12_.EnlistPaperArticalItem.Type,_loc12_.EnlistPaperArticalItem.Code));
            _loc8_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_Article,_loc9_) as TArticle;
            _loc14_.EnlistPaper = _loc8_.Name;
            _loc14_.ItemEnlistID = _loc9_;
            _loc14_.ItemEnlistAmount = _loc12_.EnlistPaperArticalItem.Amount;
            _loc14_.UpHeroID = _loc12_.UpHeroID;
            _loc14_.VipLevel = _loc12_.VipLimit;
            _loc14_.RoleLevel = _loc12_.MainHeroLevel;
            _loc14_.Type = _loc12_.Stype;
            _loc14_.FightReportAddr = _loc12_.FightReportAddr;
            _loc14_.StarLevel = (this.FChangeHeroAttrTBins.GetDatebaseByIdentifier(_loc14_.HeroID) as THeroChangeAttr).HeroStar.length;
            this.FFighterDetails.Add(_loc13_);
            this.FFighterDetails.Add(_loc14_);
            _loc7_++;
         }
         this.FIsOperate = true;
      }
      
      protected function UpDateData() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TFighterDetailData = null;
         var _loc4_:TFighterDetailData = null;
         var _loc5_:TFighterDetail = null;
         var _loc6_:THero = null;
         var _loc7_:THero = null;
         var _loc8_:uint = 0;
         var _loc9_:int = 0;
         _loc2_ = this.FFighterDetails.Count >> 1;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc5_ = this.FTBins.GetDatebaseByIndex(_loc1_) as TFighterDetail;
            _loc8_ = uint(_loc5_.Identifier);
            _loc9_ = _loc5_.UpHeroID;
            _loc6_ = SLogicsCore.Character.Heros.GetHeroByIdentifier(_loc8_);
            _loc7_ = SLogicsCore.Character.Heros.GetHeroByIdentifier(_loc9_);
            _loc3_ = this.FFighterDetails.GetTFighterDetail(_loc1_ * 2);
            _loc4_ = this.FFighterDetails.GetTFighterDetail(_loc1_ * 2 + 1);
            _loc3_.IsCanEnlist = _loc6_ == null && _loc7_ == null;
            _loc4_.IsCanEnlist = _loc6_ != null && _loc7_ == null;
            _loc1_++;
         }
      }
      
      protected function SelectHeroFinish() : void
      {
         var _loc1_:int = 0;
         TweenUtil.to(this.FPersonPanel,this.SHOW_TIME,{
            "visible":true,
            "alpha":1
         });
         this.FIsShowPersonInfoView = true;
         this.FBtnBack.Visible = true;
         this.HideHeroBtn();
         _loc1_ = (this.FTBins.GetDatebaseByIndex(this.FSelectHeroIndex) as TFighterDetail).Identifier;
         this.FPersonInfoView.SetHeroInfomation(this.FFighterDetails,this.FSelectHeroIndex,_loc1_);
      }
      
      protected function HideHeroBtn() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:MovieClip = null;
         _loc2_ = this.HERO_LEN;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FHeroList[_loc1_];
            if(_loc1_ != this.FSelectHeroIndex)
            {
               this.FHeroListButton[_loc1_].Enabled = false;
               TweenUtil.to(_loc3_,this.SHOW_TIME,{
                  "alpha":0,
                  "visible":false
               });
            }
            _loc1_++;
         }
      }
      
      protected function ShowHeroInit() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:MovieClip = null;
         _loc2_ = this.HERO_LEN;
         this.FIsScanSelectHero = true;
         TweenUtil.to(this.FPersonPanel,this.SHOW_TIME,{
            "visible":false,
            "alpha":0
         });
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FHeroList[_loc1_];
            if(_loc1_ == this.FSelectHeroIndex)
            {
               TweenUtil.to(_loc3_,this.MOVE_TIME,{
                  "x":this.FSelectBtn_PosX,
                  "y":this.FSelectBtn_PosY
               });
            }
            else
            {
               this.FHeroListButton[_loc1_].Enabled = true;
               TweenUtil.to(_loc3_,this.SHOW_TIME,{
                  "alpha":1,
                  "visible":true
               });
            }
            _loc1_++;
         }
      }
      
      protected function BtnCloseOnClick(param1:Object, param2:MouseEvent) : void
      {
         ProcessorWindowClose();
         this.SetPanelInitState();
      }
      
      protected function SetPanelInitState() : void
      {
         this.FIsScanSelectHero = true;
         this.FIsShowPersonInfoView = false;
         this.FBtnBack.Visible = false;
         this.FHeroList[this.FSelectHeroIndex].x = this.FSelectBtn_PosX;
         this.FHeroList[0].x = MOVE_POS;
         this.FPersonPanel.visible = false;
         var _loc1_:int = 0;
         while(_loc1_ < this.FHeroList.length)
         {
            this.FHeroList[_loc1_].visible = true;
            this.FHeroList[_loc1_].alpha = 1;
            this.FHeroListButton[_loc1_].Enabled = true;
            _loc1_++;
         }
      }
      
      protected function BtnShowHelpOnClick(param1:Object, param2:MouseEvent) : void
      {
      }
      
      protected function SelectHeroHandler(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:MovieClip = null;
         var _loc4_:MovieClip = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         if(this.FIsShowPersonInfoView)
         {
            this.ShowHeroInit();
            this.FIsShowPersonInfoView = false;
            this.FBtnBack.Visible = false;
            return;
         }
         if(!this.FIsScanSelectHero)
         {
            return;
         }
         this.FIsScanSelectHero = false;
         _loc6_ = this.HERO_LEN;
         _loc3_ = param2.currentTarget as MovieClip;
         _loc5_ = 0;
         while(_loc5_ < _loc6_)
         {
            _loc4_ = this.FHeroList[_loc5_];
            if(_loc4_ == _loc3_)
            {
               this.FSelectBtn_PosX = _loc4_.x;
               this.FSelectBtn_PosY = _loc4_.y;
               this.FSelectHeroIndex = _loc5_;
               TweenUtil.to(_loc3_,this.MOVE_TIME,{
                  "x":MOVE_POS,
                  "onComplete":this.SelectHeroFinish
               });
               break;
            }
            _loc5_++;
         }
      }
      
      public function set OnUpdateHerosBaseAttributeReq(param1:Function) : void
      {
         this.FOnUpdateHerosBaseAttributeReq = param1;
      }
      
      public function get OnUpdateHerosBaseAttributeReq() : Function
      {
         return this.FOnUpdateHerosBaseAttributeReq;
      }
      
      public function Update() : void
      {
         this.FUICredits.UpdatePanel();
      }
      
      public function RefreshData(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc3_:THeros = null;
         var _loc4_:Vector.<uint> = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:THero = null;
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         var _loc10_:THero = null;
         var _loc11_:uint = 0;
         var _loc12_:uint = 0;
         var _loc13_:uint = 0;
         _loc3_ = SLogicsCore.Character.Heros;
         _loc4_ = new Vector.<uint>(1);
         _loc6_ = this.FFighterDetails.Count;
         if(this.FPersonInfoView.AdvanceState == CONST_SPECIALCOMBATPOWER.ADVANCESTATE_BEFORE)
         {
            _loc2_ = param1;
            _loc5_ = 0;
            while(_loc5_ < _loc6_)
            {
               if(this.FFighterDetails.GetTFighterDetail(_loc5_).HeroID == param1)
               {
                  this.FFighterDetails.GetTFighterDetail(_loc5_).IsCanEnlist = false;
               }
               if(this.FFighterDetails.GetTFighterDetail(_loc5_).UpHeroID == param1)
               {
                  this.FFighterDetails.GetTFighterDetail(_loc5_).IsCanEnlist = true;
               }
               _loc5_++;
            }
         }
         else if(this.FPersonInfoView.AdvanceState == CONST_SPECIALCOMBATPOWER.ADVANCESTATE_BACK)
         {
            _loc10_ = SLogicsCore.Character.Heros.GetHeroByIdentifier(param1);
            _loc8_ = _loc10_.Experience.Low;
            _loc9_ = _loc10_.RebirthLevel;
            _loc11_ = _loc10_.RebirthNum;
            _loc12_ = _loc10_.PropPower;
            _loc13_ = _loc10_.AttackEffect;
            SLogicsCore.Character.Heros.Delete(_loc10_);
            _loc5_ = 0;
            while(_loc5_ < _loc6_)
            {
               if(this.FFighterDetails.GetTFighterDetail(_loc5_).UpHeroID == param1)
               {
                  this.FFighterDetails.GetTFighterDetail(_loc5_).IsCanEnlist = false;
               }
               if(this.FFighterDetails.GetTFighterDetail(_loc5_).HeroID == param1)
               {
                  this.FFighterDetails.GetTFighterDetail(_loc5_).IsCanEnlist = false;
                  _loc2_ = this.FFighterDetails.GetTFighterDetail(_loc5_).UpHeroID;
                  _loc4_[0] = _loc2_;
                  this.FUnstreamizerCharacter.UnstreamizeGenerateHerosByIdentifiers(null,_loc3_,_loc4_);
                  _loc7_ = SLogicsCore.Character.Heros.GetHeroByIdentifier(_loc2_);
                  _loc7_.Experience.Low = _loc8_;
                  _loc7_.RebirthLevel = _loc9_;
                  _loc7_.RebirthNum = _loc11_;
                  _loc7_.PropPower = _loc12_;
                  _loc7_.AttackEffect = _loc13_;
               }
               _loc5_++;
            }
         }
         if(this.FPersonPanel.visible)
         {
            this.FPersonInfoView.ClearSetProperty();
         }
         if(this.FOnUpdateHerosBaseAttributeReq != null && _loc2_ != 0)
         {
            this.FOnUpdateHerosBaseAttributeReq(_loc2_);
         }
      }
      
      public function Show() : void
      {
         Visible = true;
         if(this.FIsOperate)
         {
            this.UpDateData();
         }
         else
         {
            this.InitData();
         }
      }
   }
}

