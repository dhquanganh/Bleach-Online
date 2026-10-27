package Processors.Game.Lobby.Activity.HDPrivilegeLease
{
   import Components.Pages.TUIPage;
   import Components.SelectBox.TSelectBoxSingle;
   import Components.Standard.TUIButton;
   import Foundation.Resources.SResourcesCore;
   import Foundation.Resources.Textures.TTexture;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityFilter;
   import Foundation.Utilities.TUtilityString;
   import Foundation.Utilities.TUtilityTexture;
   import Logics.Characters.THero;
   import Logics.DatebaseVO.VO.THDActivityBase;
   import Logics.HDActivityMode.TActivityAtoms;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDPrivilegeLease.TActivityPrivilegeLeaseData;
   import Logics.Map.TMoudleInfor;
   import Logics.SLogicsCore;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDSingleWindowBase;
   import Processors.Game.Lobby.Common.Hero.TProcessorWindowHeroDescription;
   import Processors.Game.Lobby.Common.Map.SceneSprite.TSceneSpriteMoudle;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Resources.Constants.CONST_ACTIVITY;
   import Resources.Constants.CONST_ACTIVITY_MODE;
   import Resources.Constants.CONST_COMMON;
   import Resources.Constants.CONST_MAP;
   import Resources.Constants.CONST_PRIVILEGELEASE;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class TprocessorHDWindowsPrivilegeLease extends TProcessorHDSingleWindowBase
   {
      
      protected static const Filters:Array = [TUtilityFilter.highLightFilters];
      
      protected const CheckBox_Len:int = 4;
      
      protected const CONST_Day:int = 86400;
      
      protected const SLOTNUM:int = 6;
      
      protected var FMcHero:MovieClip;
      
      protected var FBtnGetHero:TUIButton;
      
      protected var FRoleMoudles:Vector.<TSceneSpriteMoudle>;
      
      protected var FQueryModel:TMoudleInfor;
      
      protected var FSelectBox:TSelectBoxSingle;
      
      protected var FHeroInfoBtn:TUIButton;
      
      protected var FSelectBoxDayList:Vector.<TextField>;
      
      protected var FSelectBoxPriceList:Vector.<TextField>;
      
      protected var FHeroStateMcRenew:Sprite;
      
      protected var FheroStateMcHave:Sprite;
      
      protected var FSP:Sprite;
      
      protected var FWindowShowHero:TProcessorWindowHeroDescription;
      
      protected var FUiPage:TUIPage;
      
      protected var FStatus_SelectBoxStart:int;
      
      protected var FCurrentPageIndex:int = 0;
      
      protected var FCurrentDataIndex:int = 0;
      
      protected var FCurrentCSIndex:int = 0;
      
      protected var FImageList:Vector.<MovieClip>;
      
      protected var FBitmapList:Vector.<Bitmap>;
      
      protected var FActivityPrivilegeLeaseData:TActivityPrivilegeLeaseData;
      
      public function TprocessorHDWindowsPrivilegeLease(param1:TUIComponent)
      {
         super(param1);
         FSceneResourceName = CONST_ACTIVITY.RESOURCE_ClassName_ActivitySinglePrivilegeLease;
         FActivityID = CONST_ACTIVITY_MODE.Activity_PrivilegeLease;
         this.FSelectBoxDayList = new Vector.<TextField>();
         this.FSelectBoxPriceList = new Vector.<TextField>();
         this.FImageList = new Vector.<MovieClip>();
         this.FBitmapList = new Vector.<Bitmap>();
      }
      
      override public function InitWindow(param1:Sprite = null) : void
      {
         super.InitWindow(param1);
         this.UIDispatch();
      }
      
      override protected function UpdateDataBase(param1:TActivityOSBase) : void
      {
         super.UpdateDataBase(param1);
         this.UpdateUI();
      }
      
      override protected function UpdateUI() : void
      {
         ProcessorFormatActivityTimeFromNowOn(FActivityAtoms.EndTime);
         ProcessorFormatActivityCountDown(FActivityAtoms.EndTime);
      }
      
      protected function UIDispatch() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TSceneSpriteMoudle = null;
         var _loc4_:Bitmap = null;
         FBtn_Close.OnClick = this.BtnCloseOnClick;
         this.FMcHero = FScene["MC_Hero"];
         this.FSP = this.FMcHero["MC_MountPoint"];
         this.FSP.addEventListener(MouseEvent.MOUSE_OVER,this.HeroOnMouseOver);
         this.FSP.addEventListener(MouseEvent.MOUSE_OUT,this.HeroOnMouseOut);
         this.FHeroInfoBtn = new TUIButton();
         this.FHeroInfoBtn.Substrate = this.FMcHero["Btn_Back"];
         this.FHeroInfoBtn.OnClick = this.HitHeroClickHandler;
         this.FHeroStateMcRenew = this.FMcHero["MC_StateRenew"];
         this.FheroStateMcHave = this.FMcHero["MC_StateHave"];
         this.FRoleMoudles = new Vector.<TSceneSpriteMoudle>();
         this.FQueryModel = new TMoudleInfor();
         _loc3_ = new TSceneSpriteMoudle();
         this.FRoleMoudles.push(_loc3_);
         this.FSP.addChild(_loc3_);
         this.FBtnGetHero = new TUIButton();
         this.FBtnGetHero.Substrate = FScene["MC_GetHero"];
         this.FBtnGetHero.OnClick = this.BtnBuyOperateOnClick;
         this.FSelectBox = new TSelectBoxSingle();
         _loc2_ = this.CheckBox_Len;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FSelectBox.SetTaskByIndex(_loc1_,FScene["MC_CheckBox"]["MC_SelectBox_" + _loc1_]["MC_Button"]);
            _loc1_++;
         }
         this.FSelectBox.CallBackOnSelect = this.SelectBoxSingleOnClick;
         this.FSelectBox.Init();
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FSelectBoxDayList.push(FScene["MC_CheckBox"]["MC_SelectBox_" + _loc1_]["TF_Day"]);
            this.FSelectBoxPriceList.push(FScene["MC_CheckBox"]["MC_SelectBox_" + _loc1_]["TF_Gold"]);
            _loc1_++;
         }
         this.FUiPage = new TUIPage(this);
         this.FUiPage.ButtonPrevious.Substrate = FScene["MC_UIPage"]["MC_PageLeft"];
         this.FUiPage.ButtonNext.Substrate = FScene["MC_UIPage"]["MC_PageRight"];
         this.FUiPage.PageSize = this.SLOTNUM;
         this.FUiPage.OnChangePage = this.SwitchPage;
         this.FUiPage.Init();
         _loc2_ = this.SLOTNUM;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FImageList.push(FScene["MC_UIPage"]["Item_" + _loc1_]);
            this.FImageList[_loc1_]["mc_over"].visible = false;
            (this.FImageList[_loc1_] as Sprite).addEventListener(MouseEvent.MOUSE_OVER,this.HeroHeadOnOver);
            (this.FImageList[_loc1_] as Sprite).addEventListener(MouseEvent.MOUSE_OUT,this.HeroHeadOnOut);
            (this.FImageList[_loc1_] as Sprite).addEventListener(MouseEvent.CLICK,this.HeroHeadOnClickHandler);
            (this.FImageList[_loc1_]["mc_head"] as Sprite).buttonMode = true;
            _loc4_ = new Bitmap();
            this.FBitmapList.push(_loc4_);
            this.FImageList[_loc1_]["mc_head"].addChild(_loc4_);
            (this.FImageList[_loc1_]["mc_over"] as Sprite).visible = false;
            (this.FImageList[_loc1_]["mc_normal"] as Sprite).visible = true;
            _loc1_++;
         }
         this.FWindowShowHero = new TProcessorWindowHeroDescription(FParent);
         this.FWindowShowHero.Perform_UIDispatch();
         this.FWindowShowHero.HintOnOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FWindowShowHero.HintOnOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FWindowShowHero.OnClose = this.BtnCloseLukiaWindowOnMouseClick;
      }
      
      protected function SelectBoxSingleOnClick(param1:int, param2:int) : void
      {
         this.FStatus_SelectBoxStart = param2;
      }
      
      protected function SwitchPage(param1:Object, param2:int) : void
      {
         this.FCurrentPageIndex = param2;
         this.SetupPage(this.FActivityPrivilegeLeaseData.DataList.length,this.FCurrentPageIndex);
         this.ShowHeroHeadRender();
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(Visible)
         {
            this.UpdateRoleModel();
         }
      }
      
      protected function UpdateRoleModel() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc2_ = 1;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            if(this.FRoleMoudles[_loc1_].TextrueID != 0)
            {
               this.FRoleMoudles[_loc1_].UpdateView();
            }
            _loc1_++;
         }
      }
      
      protected function RenderHeroModel() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:THero = null;
         _loc4_ = this.FActivityPrivilegeLeaseData.DataList[this.FCurrentDataIndex].Hero;
         (this.FMcHero["TF_Name"] as TextField).text = _loc4_.Name;
         (this.FMcHero["TF_Name"] as TextField).textColor = CONST_COMMON.QUALITYCOLOR_INDEX[_loc4_.Quality];
         TUtilityTexture.QueryTwoDirectionShowCase(CONST_MAP.DIRECTION_RIGHT,_loc4_.Identifier,this.FQueryModel);
         this.FRoleMoudles[0].ChangeRoleMoudle(this.FQueryModel.TextureID,1);
         this.SetHeroState(this.FActivityPrivilegeLeaseData.DataList[this.FCurrentDataIndex].HeroState);
      }
      
      protected function SetHeroState(param1:int) : void
      {
         switch(param1)
         {
            case CONST_PRIVILEGELEASE.HeroState_Buy:
               this.FheroStateMcHave.visible = false;
               this.FHeroStateMcRenew.visible = false;
               this.FBtnGetHero.Enabled = true;
               break;
            case CONST_PRIVILEGELEASE.HeroState_Have:
               this.FheroStateMcHave.visible = true;
               this.FHeroStateMcRenew.visible = false;
               this.FBtnGetHero.Enabled = false;
               break;
            case CONST_PRIVILEGELEASE.HeroState_Renew:
               this.FheroStateMcHave.visible = false;
               this.FHeroStateMcRenew.visible = true;
               this.FBtnGetHero.Enabled = true;
         }
      }
      
      protected function ShowHeroHeadRender() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Vector.<uint> = null;
         _loc4_ = int(this.FActivityPrivilegeLeaseData.DataList.length);
         _loc1_ = this.FCurrentPageIndex * this.SLOTNUM;
         _loc2_ = this.FCurrentPageIndex * this.SLOTNUM + this.SLOTNUM;
         _loc2_ = _loc2_ > _loc4_ ? _loc4_ : _loc2_;
         _loc5_ = 0;
         _loc3_ = _loc1_;
         while(_loc3_ < _loc2_)
         {
            SResourcesCore.TexturesHeadIcon.LoadAutoSecondary(this.FActivityPrivilegeLeaseData.DataList[_loc3_].Hero.SmallID,this.GetBitmapData);
            this.FImageList[_loc5_]["MC_Mask"].visible = false;
            _loc5_++;
            _loc3_++;
         }
         _loc3_ = _loc5_;
         while(_loc3_ < this.SLOTNUM)
         {
            this.FImageList[_loc3_]["MC_Mask"].visible = true;
            _loc3_++;
         }
      }
      
      protected function GetBitmapData(param1:Object, param2:TTexture, param3:int) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         _loc5_ = this.FCurrentPageIndex * this.SLOTNUM;
         _loc6_ = this.FCurrentPageIndex * this.SLOTNUM + this.SLOTNUM;
         _loc6_ = _loc6_ > this.FActivityPrivilegeLeaseData.DataList.length ? int(this.FActivityPrivilegeLeaseData.DataList.length) : _loc6_;
         _loc7_ = 0;
         _loc4_ = _loc5_;
         while(_loc4_ < _loc6_)
         {
            if(this.FActivityPrivilegeLeaseData.DataList[_loc4_].Hero.SmallID == param3)
            {
               this.FBitmapList[_loc7_].bitmapData = param2.GetAnimationSequenceByIndex(0).GetAnimationFrameByIndex(0).Surface;
               _loc8_ = int(this.FActivityPrivilegeLeaseData.DataList[_loc4_].Hero.Profession);
               this.FImageList[_loc7_]["mc_militaryType"].gotoAndStop(TUtilityLobby.GetStandPositionWithProfession(_loc8_));
            }
            _loc7_++;
            _loc4_++;
         }
      }
      
      protected function SetupPage(param1:int, param2:int) : void
      {
         this.FUiPage.TotalQuantity = param1;
         this.FUiPage.Update();
         this.FUiPage.PageIndex = param2;
      }
      
      protected function SetCheckBoxMsg() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         this.FSelectBox.UnselectAll();
         this.FSelectBox.SetSelectByIndex(0);
         this.FStatus_SelectBoxStart = 0;
         _loc2_ = this.CheckBox_Len;
         _loc3_ = this.FCurrentDataIndex;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            if(_loc1_ == 0)
            {
               _loc4_ = this.FActivityPrivilegeLeaseData.DataList[_loc3_].DayA / this.CONST_Day;
               _loc5_ = this.FActivityPrivilegeLeaseData.DataList[_loc3_].PriceA;
               this.FSelectBoxPriceList[_loc1_].text = _loc5_.toString();
            }
            else if(_loc1_ == 1)
            {
               _loc4_ = this.FActivityPrivilegeLeaseData.DataList[_loc3_].DayB / this.CONST_Day;
               _loc5_ = this.FActivityPrivilegeLeaseData.DataList[_loc3_].PriceB;
               this.FSelectBoxPriceList[_loc1_].text = _loc5_.toString();
            }
            else if(_loc1_ == 2)
            {
               _loc4_ = this.FActivityPrivilegeLeaseData.DataList[_loc3_].DayC / this.CONST_Day;
               _loc5_ = this.FActivityPrivilegeLeaseData.DataList[_loc3_].PriceC;
               this.FSelectBoxPriceList[_loc1_].text = _loc5_.toString();
            }
            else
            {
               _loc4_ = this.FActivityPrivilegeLeaseData.DataList[_loc3_].DayD / this.CONST_Day;
               _loc5_ = this.FActivityPrivilegeLeaseData.DataList[_loc3_].PriceD;
               this.SetForever();
            }
            if(_loc4_ == 0)
            {
               this.FSelectBoxDayList[_loc1_].text = this.FActivityPrivilegeLeaseData.PromptsList[0];
            }
            else
            {
               this.FSelectBoxDayList[_loc1_].text = TUtilityString.Format(this.FActivityPrivilegeLeaseData.PromptsList[1],_loc4_);
            }
            _loc1_++;
         }
      }
      
      protected function SetForever() : void
      {
         var _loc1_:THero = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         _loc2_ = this.FActivityPrivilegeLeaseData.DataList[this.FCurrentDataIndex].HeroId;
         _loc1_ = SLogicsCore.Character.Heros.GetHeroByIdentifier(_loc2_) as THero;
         if(_loc1_ != null)
         {
            _loc3_ = this.FActivityPrivilegeLeaseData.DataList[this.FCurrentDataIndex].PriceD - _loc1_.HeroCostGold;
            _loc3_ = _loc3_ <= 0 ? 0 : _loc3_;
            this.FSelectBoxPriceList[this.FSelectBoxPriceList.length - 1].text = _loc3_.toString();
         }
         else
         {
            this.FSelectBoxPriceList[this.FSelectBoxPriceList.length - 1].text = this.FActivityPrivilegeLeaseData.DataList[this.FCurrentDataIndex].PriceD.toString();
         }
      }
      
      override protected function BtnCloseOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _loc4_ = int(this.FBitmapList.length);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            this.FBitmapList[_loc3_].bitmapData = null;
            _loc3_++;
         }
         this.FCurrentCSIndex = 0;
         this.FCurrentDataIndex = 0;
         this.FCurrentPageIndex = 0;
         this.FStatus_SelectBoxStart = 0;
         ProcessorWindowClose();
      }
      
      protected function BtnBuyOperateOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         this.FCurrentCSIndex = this.FCurrentDataIndex * this.CheckBox_Len + this.FStatus_SelectBoxStart;
         _loc3_ = this.FCurrentCSIndex;
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,_loc3_);
      }
      
      protected function HeroOnMouseOver(param1:MouseEvent) : void
      {
         this.FSP.filters = Filters;
      }
      
      protected function HeroOnMouseOut(param1:MouseEvent) : void
      {
         this.FSP.filters = null;
      }
      
      protected function HitHeroClickHandler(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         _loc3_ = this.FActivityPrivilegeLeaseData.DataList[this.FCurrentDataIndex].HeroId;
         this.FWindowShowHero.HeroID = _loc3_;
         this.FWindowShowHero.Show();
      }
      
      protected function HeroHeadOnOver(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         _loc2_ = int(param1.currentTarget.name.split("_")[1]);
         (this.FImageList[_loc2_]["mc_over"] as Sprite).visible = true;
         (this.FImageList[_loc2_]["mc_normal"] as Sprite).visible = false;
      }
      
      protected function HeroHeadOnOut(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         _loc2_ = int(param1.currentTarget.name.split("_")[1]);
         (this.FImageList[_loc2_]["mc_over"] as Sprite).visible = false;
         (this.FImageList[_loc2_]["mc_normal"] as Sprite).visible = true;
      }
      
      protected function HeroHeadOnClickHandler(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         _loc2_ = int(param1.currentTarget.name.split("_")[1]);
         this.FCurrentDataIndex = this.FCurrentPageIndex * this.SLOTNUM + _loc2_;
         if(this.FImageList[_loc2_]["MC_Mask"].visible)
         {
            return;
         }
         this.RenderHeroModel();
         this.SetCheckBoxMsg();
      }
      
      protected function BtnCloseLukiaWindowOnMouseClick(param1:Object) : void
      {
         this.FWindowShowHero.Hide();
      }
      
      public function set ActivityPrivilegeLeaseData(param1:TActivityPrivilegeLeaseData) : void
      {
         this.FActivityPrivilegeLeaseData = param1;
      }
      
      override public function Show(param1:TActivityAtoms = null, param2:THDActivityBase = null, param3:TActivityOSBase = null) : void
      {
         super.Show(param1,param2,param3);
         this.RenderHeroModel();
         this.ShowHeroHeadRender();
         this.SetupPage(this.FActivityPrivilegeLeaseData.DataList.length,0);
         this.SetCheckBoxMsg();
      }
      
      public function RefreshHeroState() : void
      {
         this.RenderHeroModel();
         this.SetForever();
      }
   }
}

