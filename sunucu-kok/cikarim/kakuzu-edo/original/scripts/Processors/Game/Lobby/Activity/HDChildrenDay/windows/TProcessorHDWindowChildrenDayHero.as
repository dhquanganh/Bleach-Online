package Processors.Game.Lobby.Activity.HDChildrenDay.windows
{
   import Components.Pages.TUIPage;
   import Components.Standard.TUIButton;
   import Externals.SExternalCore;
   import Foundation.Resources.Bins.TBins;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.TUIComponent;
   import Logics.Agent.SParametersCore;
   import Logics.Characters.THero;
   import Logics.DatebaseVO.VO.THDChildrenDayHero;
   import Logics.DatebaseVO.VO.TTimeHero;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDChildrenDay.TChildrenDayHero;
   import Logics.SLogicsCore;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDSingleWindowBase;
   import Processors.Game.Lobby.Activity.HDNewYearSheep.HDWindow.TShowAwardUI;
   import Resources.Constants.CONST_DATEBASEVO;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class TProcessorHDWindowChildrenDayHero extends TProcessorHDSingleWindowBase
   {
      
      public static const NUM:uint = 3;
      
      protected var FAwards:Vector.<TShowAwardUI>;
      
      protected var FPageUI:TUIPage;
      
      protected var FCurrentPage:uint;
      
      protected var FBtnRent:Vector.<TUIButton>;
      
      protected var FBtnGet:Vector.<TUIButton>;
      
      protected var FTF_Score:TextField;
      
      protected var FBtnTag:uint;
      
      protected var FTimeHeroBins:TBins;
      
      protected var FBtnRecharge:TUIButton;
      
      protected var FData:TChildrenDayHero;
      
      protected var FConfig:THDChildrenDayHero;
      
      public function TProcessorHDWindowChildrenDayHero(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function UpdateUIConfig() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         super.UpdateUIConfig();
         this.FConfig = FHDActivityConfig as THDChildrenDayHero;
         if(FActivityAtoms != null)
         {
            ProcessorFormatActivityTimeFromNowOn(FActivityAtoms.EndTime);
            ProcessorFormatActivityCountDown(FActivityAtoms.EndTime);
         }
      }
      
      override protected function UpdateDataBase(param1:TActivityOSBase) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         this.UpdateCurrentPage();
      }
      
      protected function PageOnSwitch(param1:Object, param2:int) : void
      {
         this.FCurrentPage = param2;
         this.UpdateCurrentPage();
      }
      
      protected function UpdateCurrentPage() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:THero = null;
         this.FTimeHeroBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_TimeHero);
         this.FPageUI.TotalQuantity = this.FTimeHeroBins.Count;
         this.FPageUI.Update();
         _loc2_ = NUM;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            if(_loc1_ + this.FCurrentPage * NUM >= this.FTimeHeroBins.Count)
            {
               FScene["MC_Gift_" + _loc1_].visible = false;
            }
            else
            {
               FScene["MC_Gift_" + _loc1_].visible = true;
               this.FAwards[_loc1_].SetData(0,21403040,(this.FTimeHeroBins.GetDatebaseByIndex(_loc1_ + this.FCurrentPage * NUM) as TTimeHero).Identifier);
               FScene["MC_Gift_" + _loc1_]["TF_CostCandy"].text = (this.FTimeHeroBins.GetDatebaseByIndex(_loc1_ + this.FCurrentPage * NUM) as TTimeHero).NeedCandy + "";
               _loc3_ = SLogicsCore.Character.Heros.GetHeroByIdentifier((this.FTimeHeroBins.GetDatebaseByIndex(_loc1_ + this.FCurrentPage * NUM) as TTimeHero).Identifier);
               if(_loc3_ == null)
               {
                  FScene["MC_Gift_" + _loc1_]["MC_AlreadyGet"].visible = false;
                  this.FBtnGet[_loc1_].Visible = this.FBtnRent[_loc1_].Visible = true;
                  FScene["MC_Gift_" + _loc1_]["TF_Cost"].visible = true;
                  FScene["MC_Gift_" + _loc1_]["TF_Cost"].text = (this.FTimeHeroBins.GetDatebaseByIndex(_loc1_ + this.FCurrentPage * NUM) as TTimeHero).ForeverCost + "";
               }
               else
               {
                  FScene["MC_Gift_" + _loc1_]["MC_AlreadyGet"].visible = true;
                  if(_loc3_.HeroOverTime == 0)
                  {
                     this.FBtnGet[_loc1_].Visible = this.FBtnRent[_loc1_].Visible = false;
                     FScene["MC_Gift_" + _loc1_]["TF_Cost"].visible = false;
                  }
                  else
                  {
                     this.FBtnGet[_loc1_].Visible = this.FBtnRent[_loc1_].Visible = true;
                     FScene["MC_Gift_" + _loc1_]["TF_Cost"].visible = true;
                  }
                  FScene["MC_Gift_" + _loc1_]["TF_Cost"].text = (this.FTimeHeroBins.GetDatebaseByIndex(_loc1_ + this.FCurrentPage * NUM) as TTimeHero).ForeverCost - _loc3_.HeroCostGold + "";
               }
            }
            _loc1_++;
         }
      }
      
      protected function OnGoldGet(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:THero = null;
         var _loc4_:uint = 0;
         this.FBtnTag = param1.Tag;
         _loc3_ = SLogicsCore.Character.Heros.GetHeroByIdentifier((this.FTimeHeroBins.GetDatebaseByIndex(this.FBtnTag + this.FCurrentPage * NUM) as TTimeHero).Identifier);
         if(_loc3_ == null)
         {
            _loc4_ = 0;
         }
         else
         {
            _loc4_ = _loc3_.HeroCostGold;
         }
         GoldBuy((this.FTimeHeroBins.GetDatebaseByIndex(this.FBtnTag + this.FCurrentPage * NUM) as TTimeHero).ForeverCost - _loc4_,this.OnGet);
      }
      
      protected function OnGet(param1:Object) : void
      {
         var _loc2_:Vector.<int> = null;
         _loc2_ = new Vector.<int>(1);
         _loc2_[0] = this.FTimeHeroBins.GetDatebaseByIndex(this.FBtnTag + this.FCurrentPage * NUM).Identifier;
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FConfig.BuyGoldIndex,0,_loc2_);
      }
      
      protected function OnRent(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:Vector.<int> = null;
         var _loc4_:uint = 0;
         _loc3_ = new Vector.<int>(1);
         _loc3_[0] = this.FTimeHeroBins.GetDatebaseByIndex(param1.Tag + this.FCurrentPage * NUM).Identifier;
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FConfig.BuyScoreIndex,0,_loc3_);
      }
      
      protected function ProcessorRecharge(param1:Object, param2:MouseEvent) : void
      {
         SExternalCore.NavigateToRechargeUrl(SParametersCore.PayUrl);
      }
      
      override public function InitWindow(param1:Sprite = null) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:TUIButton = null;
         var _loc5_:TShowAwardUI = null;
         super.InitWindow(param1);
         this.FAwards = new Vector.<TShowAwardUI>(NUM);
         this.FBtnGet = new Vector.<TUIButton>(NUM);
         _loc2_ = 0;
         while(_loc2_ < NUM)
         {
            _loc5_ = new TShowAwardUI(this);
            _loc5_.UIDispatch(FScene["MC_Gift_" + _loc2_]);
            this.FAwards[_loc2_] = _loc5_;
            this.FBtnGet[_loc2_] = new TUIButton();
            this.FBtnGet[_loc2_].Substrate = FScene["MC_Gift_" + _loc2_]["MC_Get"];
            this.FBtnGet[_loc2_].OnClick = this.OnGoldGet;
            this.FBtnGet[_loc2_].Tag = _loc2_;
            _loc2_++;
         }
         this.FPageUI = new TUIPage(this);
         this.FPageUI.ButtonNext.Substrate = FScene["MC_PageRight"];
         this.FPageUI.ButtonPrevious.Substrate = FScene["MC_PageLeft"];
         this.FPageUI.PageSize = NUM;
         this.FPageUI.OnChangePage = this.PageOnSwitch;
         this.FPageUI.Init();
         this.FPageUI.Update();
         this.FTF_Score = new TextField();
         this.FTF_Score = FScene["TF_Score"];
         this.FBtnRent = new Vector.<TUIButton>(NUM);
         _loc2_ = 0;
         while(_loc2_ < NUM)
         {
            _loc4_ = new TUIButton();
            _loc4_.Substrate = FScene["MC_Gift_" + _loc2_]["Btn_Rent"];
            _loc4_.OnClick = this.OnRent;
            _loc4_.Tag = _loc2_;
            this.FBtnRent[_loc2_] = _loc4_;
            _loc2_++;
         }
         this.FBtnRecharge = new TUIButton();
         this.FBtnRecharge.Substrate = FScene["MC_Prompt"]["Btn_Recharge"];
         this.FBtnRecharge.OnClick = this.ProcessorRecharge;
      }
   }
}

