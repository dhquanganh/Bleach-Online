package Processors.Game.Lobby.Activity.HDHerosMarket
{
   import Components.Pages.TUIPage;
   import Components.ScrollBar.TScrollBar;
   import Components.Standard.TUIButton;
   import Foundation.Common.THint;
   import Foundation.Resources.Bins.TBins;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Logics.DatebaseVO.VO.THDHerosMarket;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDHerosMarket.TActivityHerosMarkets;
   import Logics.Inventories.TInventories;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDSingleWindowBase;
   import Processors.Game.Lobby.Activity.HDHerosMarket.Component.TUIHMAchieve;
   import Processors.Game.Lobby.Activity.HDHerosMarket.Component.TUIHeroHead;
   import Resources.Constants.CONST_ACTIVITY_MODE;
   import Resources.Constants.CONST_DATEBASEVO;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class TProcessorWindowHMAchieve extends TProcessorHDSingleWindowBase
   {
      
      protected var FMC_ScollBar:TScrollBar;
      
      protected var FHD_HerosMarket:THDHerosMarket;
      
      protected var FData_HerosMarket:TActivityHerosMarkets;
      
      protected var FRoldModelBins:TBins;
      
      protected var FMC_AwardBar:Vector.<TUIHMAchieve>;
      
      protected var FMC_HeadList:Vector.<TUIHeroHead>;
      
      protected var FInventories:Vector.<TInventories>;
      
      protected var FMC_HeadIcons:Vector.<Sprite>;
      
      protected var FFlag:uint;
      
      protected var FIsInitWindow:Boolean;
      
      public function TProcessorWindowHMAchieve(param1:TUIComponent)
      {
         super(param1);
         FSceneResourceName = "MC_Achieve";
         FActivityID = CONST_ACTIVITY_MODE.Activity_HerosMarkets;
         FHint = new THint();
         this.FIsInitWindow = false;
      }
      
      override public function InitWindow(param1:Sprite = null) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:TUIHeroHead = null;
         super.InitWindow(param1);
         FBtn_Close = new TUIButton();
         FBtn_Close.Substrate = FScene["btn_close"];
         FBtn_Close.OnClick = this.ProcessorOnHide;
         FMC_PageLeft = FScene["btn_left"];
         FMC_PageRight = FScene["btn_right"];
         FUIPage = new TUIPage(this);
         FUIPage.ButtonPrevious.Substrate = FMC_PageLeft;
         FUIPage.ButtonNext.Substrate = FMC_PageRight;
         FUIPage.OnChangePage = ProcessorPageOnChange;
         FUIPage.Init();
         this.UpdateUIPage();
         this.FMC_ScollBar = new TScrollBar(FScene["mc_scroll"],380,false,0,60);
         this.FMC_ScollBar.Visible = false;
         this.FRoldModelBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_RoleModel);
         _loc2_ = 4;
         this.FMC_HeadList = new Vector.<TUIHeroHead>(_loc2_);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = new TUIHeroHead(this,FScene["MC_Slot_" + _loc3_],this.FRoldModelBins);
            this.FMC_HeadList[_loc3_] = _loc4_;
            _loc3_++;
         }
         this.FIsInitWindow = true;
      }
      
      protected function UpdateHeadList() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         _loc1_ = this.FMC_HeadList.length;
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            if(this.FFlag == 0)
            {
               if(_loc2_ + FPageIndex * this.FMC_HeadList.length <= this.FHD_HerosMarket.HerosHotId.length - 1)
               {
                  this.FMC_HeadList[_loc2_].UpdateIcon(this.FHD_HerosMarket.HerosHotId[_loc2_ + FPageIndex * this.FMC_HeadList.length],this.FFlag);
                  this.FMC_HeadList[_loc2_].BackGroundVisible = true;
                  if(this.FData_HerosMarket.HerosHotStatus[_loc2_ + FPageIndex * this.FMC_HeadList.length] == 1)
                  {
                     this.FMC_HeadList[_loc2_].BackGroundNormal = true;
                  }
                  else
                  {
                     this.FMC_HeadList[_loc2_].BackGroundGrey = true;
                  }
               }
               else
               {
                  this.FMC_HeadList[_loc2_].BackGroundVisible = false;
               }
            }
            else if(_loc2_ + FPageIndex * this.FMC_HeadList.length <= this.FHD_HerosMarket.KnifeHotId.length - 1)
            {
               this.FMC_HeadList[_loc2_].UpdateIcon(this.FHD_HerosMarket.KnifeHotId[_loc2_ + FPageIndex * this.FMC_HeadList.length],this.FFlag);
               this.FMC_HeadList[_loc2_].BackGroundVisible = true;
               if(this.FData_HerosMarket.KnifesHotStatus[_loc2_ + FPageIndex * this.FMC_HeadList.length] == 1)
               {
                  this.FMC_HeadList[_loc2_].BackGroundNormal = true;
               }
               else
               {
                  this.FMC_HeadList[_loc2_].BackGroundGrey = true;
               }
            }
            else
            {
               this.FMC_HeadList[_loc2_].BackGroundVisible = false;
            }
            _loc2_++;
         }
      }
      
      protected function UpdateUIPage() : void
      {
         FUIPage.Update();
         FUIPage.PageIndex = FPageIndex;
      }
      
      protected function ProcessorOnHide(param1:Object, param2:MouseEvent) : void
      {
         this.FMC_ScollBar.Visible = false;
         if(FOnBtnCloseClick != null)
         {
            FOnBtnCloseClick();
         }
      }
      
      override protected function UpdateDataBase(param1:TActivityOSBase) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         super.UpdateDataBase(param1);
         this.FData_HerosMarket = param1 as TActivityHerosMarkets;
         this.UpdateHeadList();
         if(this.FFlag == 0)
         {
            _loc2_ = this.FHD_HerosMarket.HerosAchieveAward.length;
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               this.FMC_AwardBar[_loc3_].UpdateUI(_loc3_,this.FHD_HerosMarket,this.FData_HerosMarket.HerosAchieveStatus[_loc3_],this.FFlag);
               _loc3_++;
            }
         }
         else
         {
            _loc2_ = this.FHD_HerosMarket.KnifeAchieveAward.length;
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               this.FMC_AwardBar[_loc3_].UpdateUI(_loc3_,this.FHD_HerosMarket,this.FData_HerosMarket.KnifesAchieveStatus[_loc3_],this.FFlag);
               _loc3_++;
            }
         }
      }
      
      override protected function UpdateUIConfig() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:TUIHMAchieve = null;
         var _loc4_:Vector.<uint> = null;
         var _loc5_:Sprite = null;
         super.UpdateUIConfig();
         this.FHD_HerosMarket = FHDActivityConfig as THDHerosMarket;
         if(this.FFlag == 0)
         {
            _loc1_ = this.FHD_HerosMarket.HerosAchieveAward.length;
         }
         else
         {
            _loc1_ = this.FHD_HerosMarket.KnifeAchieveAward.length;
         }
         if(!this.FMC_ScollBar.Visible)
         {
            this.FMC_AwardBar = new Vector.<TUIHMAchieve>(_loc1_);
            this.FMC_ScollBar.Clear();
            _loc2_ = 0;
            while(_loc2_ < _loc1_)
            {
               _loc3_ = new TUIHMAchieve(this);
               _loc3_.OnQuerySequenceContext = SlotsOnQuerySequenceContext;
               _loc3_.OnSlotOver = this.ShowTipOnMove;
               _loc3_.OnSlotOut = this.HideTipOnOut;
               _loc3_.OnBtnOkClick = this.BtnOKOnClick;
               _loc3_.OnBtnOkMove = OnHintOver;
               _loc3_.OnBtnOkOut = OnHintOut;
               _loc3_.OnEffectText = FOnEffectText;
               _loc5_ = TUtilityReflection.CreateDisplayObjectInstance("MC_AchieveItem") as Sprite;
               _loc3_.Perform_UIDispatch(_loc5_);
               this.FMC_AwardBar[_loc2_] = _loc3_;
               this.FMC_ScollBar.AddItem(_loc3_);
               _loc2_++;
            }
            this.FMC_ScollBar.Visible = true;
         }
         _loc4_ = new Vector.<uint>(_loc1_);
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            if(this.FFlag == 0)
            {
               _loc4_[_loc2_] = this.FHD_HerosMarket.HerosAchieveAward[_loc2_];
            }
            else
            {
               _loc4_[_loc2_] = this.FHD_HerosMarket.KnifeAchieveAward[_loc2_];
            }
            _loc2_++;
         }
         this.FInventories = ProcessorGetInventoriesVectByAwardID(_loc4_);
         if(this.FFlag == 0)
         {
            FUIPage.TotalQuantity = this.FHD_HerosMarket.HerosHotId.length;
         }
         else
         {
            FUIPage.TotalQuantity = this.FHD_HerosMarket.KnifeHotId.length;
         }
      }
      
      override protected function BtnOKOnClick(param1:Object, param2:uint) : void
      {
         var _loc3_:int = 0;
         if(this.FFlag == 0)
         {
            _loc3_ = int(this.FHD_HerosMarket.HerosAchieveIndex[param2]);
         }
         else
         {
            _loc3_ = int(this.FHD_HerosMarket.KnifeAchieveIndex[param2]);
         }
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,_loc3_);
      }
      
      protected function ShowTipOnMove(param1:Object, param2:uint) : void
      {
         if(FOnGiftBoxMove != null)
         {
            FOnGiftBoxMove(this,this.FInventories[param2]);
         }
      }
      
      protected function HideTipOnOut(param1:Object) : void
      {
         if(FOnGiftBoxOut != null)
         {
            FOnGiftBoxOut(this);
         }
      }
      
      public function get Flag() : uint
      {
         return this.FFlag;
      }
      
      public function set Flag(param1:uint) : void
      {
         this.FFlag = param1;
      }
   }
}

