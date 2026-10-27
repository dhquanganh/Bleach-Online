package Processors.Game.Lobby.GongFuFightWindow
{
   import Components.Pages.TUIPage;
   import Components.Standard.TUIButton;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Logics.GongFuFight.TGongFuFightData;
   import Logics.GongFuFight.TGongFuFightRankInfor;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import Resources.Constants.CONST_COMMON;
   import Resources.Constants.CONST_GONGFUFIGHT;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class TWindowRank extends TProcessorLobbyWindow
   {
      
      protected static const ListNum:int = 10;
      
      protected static const NameColor:Vector.<uint> = Vector.<uint>([CONST_COMMON.TEXT_Red_Color,CONST_COMMON.TEXT_Green_Color,CONST_COMMON.TEXT_Yellow_Color,CONST_COMMON.TEXT_White_Color]);
      
      protected var FMainScene:Sprite;
      
      protected var FListItemVec_UI:Vector.<Sprite>;
      
      protected var FListItemVec_Rank:Vector.<TextField>;
      
      protected var FListItemVec_PlayerName:Vector.<TextField>;
      
      protected var FListItemVec_ServerName:Vector.<TextField>;
      
      protected var FListItemVec_Level:Vector.<TextField>;
      
      protected var FListItemVec_Score:Vector.<TextField>;
      
      protected var FListItemVec_GroupLevel:Vector.<TextField>;
      
      protected var FListItemVec_BG:Vector.<Sprite>;
      
      protected var FMyRank:TextField;
      
      protected var FUIPage:TUIPage;
      
      protected var FCurrentPageIndex:int;
      
      protected var FPendantLeft:MovieClip;
      
      protected var FPendantRight:MovieClip;
      
      protected var FBtnClose:TUIButton;
      
      protected var FGongFuFightData:TGongFuFightData;
      
      public function TWindowRank(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Sprite = null;
         this.FMainScene = TUtilityReflection.CreateDisplayObjectInstance("GongFuFightRankUI") as Sprite;
         addChild(this.FMainScene);
         this.FListItemVec_UI = new Vector.<Sprite>();
         this.FListItemVec_Rank = new Vector.<TextField>();
         this.FListItemVec_PlayerName = new Vector.<TextField>();
         this.FListItemVec_ServerName = new Vector.<TextField>();
         this.FListItemVec_Level = new Vector.<TextField>();
         this.FListItemVec_Score = new Vector.<TextField>();
         this.FListItemVec_GroupLevel = new Vector.<TextField>();
         this.FListItemVec_BG = new Vector.<Sprite>();
         _loc1_ = 0;
         while(_loc1_ < ListNum)
         {
            _loc2_ = this.FMainScene["MC_List_" + _loc1_];
            this.FListItemVec_UI.push(_loc2_);
            this.FListItemVec_Rank.push(_loc2_["TF_Rank"]);
            this.FListItemVec_PlayerName.push(_loc2_["TF_Name"]);
            this.FListItemVec_ServerName.push(_loc2_["TF_ServerID"]);
            this.FListItemVec_Level.push(_loc2_["TF_Level"]);
            this.FListItemVec_Score.push(_loc2_["TF_Score"]);
            this.FListItemVec_GroupLevel.push(_loc2_["TF_GroupLevel"]);
            this.FListItemVec_BG.push(_loc2_["MC_Bg"]);
            _loc1_++;
         }
         this.FMyRank = this.FMainScene["TF_MyRank"];
         this.FUIPage = new TUIPage(this);
         this.FUIPage.ButtonPrevious.Substrate = this.FMainScene["MC_PageLeft"];
         this.FUIPage.ButtonNext.Substrate = this.FMainScene["MC_PageRight"];
         this.FUIPage.LabelPage = this.FMainScene["TF_Page"];
         this.FUIPage.PageSize = ListNum;
         this.FUIPage.OnChangePage = this.SwitchPage;
         this.FBtnClose = new TUIButton();
         this.FBtnClose.Substrate = this.FMainScene["Btn_Close"];
         this.FBtnClose.OnClick = this.BtnCloseOnClick;
         this.FPendantLeft = this.FMainScene["MC_Animation_0"];
         this.FPendantRight = this.FMainScene["MC_Animation_1"];
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         super.ResourcesPerform_UILocations();
      }
      
      protected function RenderView(param1:TGongFuFightData) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TGongFuFightRankInfor = null;
         this.FMyRank.text = param1.GongFuFightBaseInfor.RankToday.toString();
         _loc2_ = this.FCurrentPageIndex * ListNum;
         _loc3_ = _loc2_ + ListNum;
         _loc3_ = _loc3_ > param1.GongFuFightRankEffectNum ? param1.GongFuFightRankEffectNum : _loc3_;
         _loc4_ = 0;
         _loc5_ = _loc2_;
         while(_loc5_ < _loc3_)
         {
            _loc6_ = param1.GongFuFightRankInfors[_loc5_];
            this.FListItemVec_UI[_loc4_].visible = true;
            this.FListItemVec_Rank[_loc4_].text = _loc6_.CurrentRank.toString();
            this.SetupNameColor(_loc5_,this.FListItemVec_Rank[_loc4_]);
            this.FListItemVec_PlayerName[_loc4_].text = _loc6_.PlayerName;
            this.SetupNameColor(_loc5_,this.FListItemVec_PlayerName[_loc4_]);
            this.FListItemVec_BG[_loc4_].visible = _loc5_ < 3;
            this.FListItemVec_ServerName[_loc4_].text = _loc6_.ServerName;
            this.FListItemVec_Level[_loc4_].text = _loc6_.PlayerLevel.toString();
            this.FListItemVec_Score[_loc4_].text = _loc6_.PlayerScore.toString();
            this.FListItemVec_GroupLevel[_loc4_].text = CONST_GONGFUFIGHT.GroupLevelNames[_loc6_.PlayerGroupLevel];
            _loc4_++;
            _loc5_++;
         }
         _loc5_ = _loc4_;
         while(_loc5_ < ListNum)
         {
            this.FListItemVec_UI[_loc5_].visible = false;
            _loc5_++;
         }
         this.FPendantLeft.gotoAndPlay(1);
         this.FPendantRight.gotoAndPlay(1);
      }
      
      protected function SetupNameColor(param1:int, param2:TextField) : void
      {
         if(param1 > 3)
         {
            param1 = 3;
         }
         param2.textColor = NameColor[param1];
      }
      
      protected function SetupPage(param1:int, param2:int) : void
      {
         this.FUIPage.TotalQuantity = param1;
         this.FUIPage.Update();
         this.FUIPage.PageIndex = param2;
         this.FCurrentPageIndex = param2;
      }
      
      protected function SwitchPage(param1:Object, param2:int) : void
      {
         this.FCurrentPageIndex = param2;
         this.RenderView(this.FGongFuFightData);
      }
      
      protected function BtnCloseOnClick(param1:Object, param2:MouseEvent) : void
      {
         ProcessorWindowClose();
      }
      
      public function Update(param1:TGongFuFightData) : void
      {
         this.FGongFuFightData = param1;
         this.SetupPage(param1.GongFuFightRankEffectNum,0);
         this.RenderView(param1);
      }
      
      public function Reset() : void
      {
         this.FGongFuFightData = null;
         FOnClose = null;
         this.FPendantLeft.stop();
         this.FPendantRight.stop();
      }
   }
}

