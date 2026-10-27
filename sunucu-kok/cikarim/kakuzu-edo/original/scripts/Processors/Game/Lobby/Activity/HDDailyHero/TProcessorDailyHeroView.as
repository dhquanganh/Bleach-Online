package Processors.Game.Lobby.Activity.HDDailyHero
{
   import Components.Pages.TUIPage;
   import Components.Standard.TUIButton;
   import Externals.SExternalCore;
   import Foundation.UI.TUIComponent;
   import Logics.DatebaseVO.VO.THDDailyHero;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDDailyHero.THDDailyHeroData;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDSingleWindowBase;
   import Processors.Game.Lobby.Activity.HDNewYearSheep.HDWindow.TShowAwardUI;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class TProcessorDailyHeroView extends TProcessorHDSingleWindowBase
   {
      
      public static const NUM:uint = 4;
      
      protected var FDataVO:THDDailyHeroData;
      
      protected var FConfig:THDDailyHero;
      
      protected var FAwards:Vector.<TShowAwardUI>;
      
      protected var FPageUI:TUIPage;
      
      protected var FCurrentPage:uint;
      
      protected var FBtnReports:Vector.<TUIButton>;
      
      protected var FBtnGet:Vector.<TUIButton>;
      
      protected var FMCGet:Vector.<Sprite>;
      
      protected var FTF_Score:TextField;
      
      public function TProcessorDailyHeroView(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function UpdateUIConfig() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         super.UpdateUIConfig();
         this.FConfig = FHDActivityConfig as THDDailyHero;
         if(FActivityAtoms != null)
         {
            ProcessorFormatActivityTimeFromNowOn(FActivityAtoms.EndTime);
            ProcessorFormatActivityCountDown(FActivityAtoms.EndTime);
         }
      }
      
      protected function Onreport(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:uint = 0;
         _loc3_ = this.FBtnReports.indexOf(param1);
         SExternalCore.NavigateToLinkUrl(this.FConfig.Awards[_loc3_ + this.FCurrentPage * NUM].FightReportAddr);
      }
      
      override protected function UpdateDataBase(param1:TActivityOSBase) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         this.FDataVO = param1 as THDDailyHeroData;
         this.FTF_Score.text = this.FDataVO.Score + "";
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
         this.FPageUI.TotalQuantity = this.FConfig.Awards.length;
         this.FPageUI.Update();
         _loc2_ = NUM;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            if(_loc1_ + this.FCurrentPage * NUM >= this.FConfig.Awards.length)
            {
               FScene["MC_Gift_" + _loc1_].visible = false;
            }
            else
            {
               FScene["MC_Gift_" + _loc1_].visible = true;
               this.FAwards[_loc1_].SetData(this.FConfig.Awards[_loc1_ + this.FCurrentPage * NUM].AwardType,this.FConfig.Awards[_loc1_ + this.FCurrentPage * NUM].AwardID,this.FConfig.Awards[_loc1_ + this.FCurrentPage * NUM].ShowAwardID);
               FScene["MC_Gift_" + _loc1_]["TF_Condition1"].text = this.FConfig.Awards[_loc1_ + this.FCurrentPage * NUM].Condition;
               this.FMCGet[_loc1_].visible = this.FDataVO.AwardStates[_loc1_ + this.FCurrentPage * NUM] == 0 ? false : true;
               this.FBtnGet[_loc1_].Visible = !this.FMCGet[_loc1_].visible;
               this.FBtnGet[_loc1_].Enabled = this.FDataVO.Score >= this.FConfig.Awards[_loc1_ + this.FCurrentPage * NUM].Condition[0];
               if(this.FConfig.Awards[_loc1_ + this.FCurrentPage * NUM].FightReportAddr == "")
               {
                  this.FBtnReports[_loc1_].Visible = false;
               }
               else
               {
                  this.FBtnReports[_loc1_].Visible = true;
               }
            }
            _loc1_++;
         }
      }
      
      protected function OnGet(param1:Object, param2:MouseEvent) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FConfig.Awards[param1.Tag + this.FCurrentPage * NUM].CS_Index);
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
         this.FMCGet = new Vector.<Sprite>(NUM);
         _loc2_ = 0;
         while(_loc2_ < NUM)
         {
            _loc5_ = new TShowAwardUI(this);
            _loc5_.UIDispatch(FScene["MC_Gift_" + _loc2_]);
            this.FAwards[_loc2_] = _loc5_;
            this.FBtnGet[_loc2_] = new TUIButton();
            this.FBtnGet[_loc2_].Substrate = FScene["MC_Gift_" + _loc2_]["Btn_Get"];
            this.FBtnGet[_loc2_].OnClick = this.OnGet;
            this.FBtnGet[_loc2_].Tag = _loc2_;
            this.FMCGet[_loc2_] = FScene["MC_Gift_" + _loc2_]["MC_Get"];
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
         this.FBtnReports = new Vector.<TUIButton>(NUM);
         _loc2_ = 0;
         while(_loc2_ < NUM)
         {
            _loc4_ = new TUIButton();
            _loc4_.Substrate = FScene["MC_Gift_" + _loc2_]["Btn_FightReport"];
            _loc4_.OnClick = this.Onreport;
            this.FBtnReports[_loc2_] = _loc4_;
            _loc2_++;
         }
      }
   }
}

