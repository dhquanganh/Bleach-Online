package Processors.Game.Lobby.GongFuFight.MainUIComponent
{
   import Components.Standard.TUIButton;
   import Foundation.UI.TUIComponent;
   import Logics.GongFuFight.TGongFuFightData;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Resources.Constants.CONST_GONGFUFIGHT;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class TComponentSubFunction extends TProcessorLobbyWindow
   {
      
      protected var FMainScene:MovieClip;
      
      protected var FBtnChallengeCard:TUIButton;
      
      protected var FBtnPeakStone:TUIButton;
      
      protected var FBtnPay:TUIButton;
      
      protected var FBtnRankList:TUIButton;
      
      protected var FOnOpenSubWindow:Function;
      
      protected var FOnOpenTokenShop:Function;
      
      protected var FOnOpenStoneShop:Function;
      
      public function TComponentSubFunction(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(Visible && this.FMainScene != null)
         {
            if(this.FMainScene.currentFrame == this.FMainScene.totalFrames)
            {
               this.FMainScene.stop();
            }
         }
      }
      
      public function UIDispatch(param1:Sprite) : void
      {
         this.FMainScene = param1["SubFunctionPanle"];
         this.FBtnChallengeCard = new TUIButton();
         this.FBtnChallengeCard.Substrate = this.FMainScene["ChallengeCardUI"]["Btn"];
         this.FBtnChallengeCard.OnClick = this.BtnOnClick;
         this.FBtnChallengeCard.Caption = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_GongFuGight_31);
         this.FBtnPeakStone = new TUIButton();
         this.FBtnPeakStone.Substrate = this.FMainScene["PeakStoneUI"]["Btn"];
         this.FBtnPeakStone.OnClick = this.BtnOnClick;
         this.FBtnPeakStone.Caption = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_GongFuGight_32);
         this.FBtnPay = new TUIButton();
         this.FBtnPay.Substrate = this.FMainScene["PayUI"]["Btn"];
         this.FBtnPay.OnClick = this.BtnOnClick;
         this.FBtnRankList = new TUIButton();
         this.FBtnRankList.Substrate = param1["PanleBaseInfor"]["Btn"];
         this.FBtnRankList.OnClick = this.BtnOnClick;
      }
      
      protected function BtnOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TUIButton = null;
         var _loc4_:uint = 0;
         _loc3_ = param1 as TUIButton;
         if(_loc3_ == this.FBtnPay)
         {
            _loc4_ = uint(CONST_GONGFUFIGHT.PayViewID);
            if(this.FOnOpenSubWindow != null)
            {
               this.FOnOpenSubWindow(this,_loc4_);
            }
         }
         else if(_loc3_ == this.FBtnRankList)
         {
            _loc4_ = uint(CONST_GONGFUFIGHT.RankViewID);
            if(this.FOnOpenSubWindow != null)
            {
               this.FOnOpenSubWindow(this,_loc4_);
            }
         }
         else if(_loc3_ == this.FBtnChallengeCard)
         {
            if(this.FOnOpenTokenShop != null)
            {
               this.FOnOpenTokenShop(this);
            }
         }
         else if(_loc3_ == this.FBtnPeakStone)
         {
            if(this.FOnOpenStoneShop != null)
            {
               this.FOnOpenStoneShop(this);
            }
         }
      }
      
      public function set OnOpenSubWindow(param1:Function) : void
      {
         this.FOnOpenSubWindow = param1;
      }
      
      public function set OnOpenTokenShop(param1:Function) : void
      {
         this.FOnOpenTokenShop = param1;
      }
      
      public function set OnOpenStoneShop(param1:Function) : void
      {
         this.FOnOpenStoneShop = param1;
      }
      
      public function Update(param1:TGongFuFightData) : void
      {
      }
      
      public function OpenView() : void
      {
         this.FMainScene.gotoAndPlay(1);
      }
      
      public function Reset() : void
      {
         this.FMainScene.gotoAndStop(1);
      }
   }
}

