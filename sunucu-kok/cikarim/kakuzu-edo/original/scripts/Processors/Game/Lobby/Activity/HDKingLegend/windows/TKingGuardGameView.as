package Processors.Game.Lobby.Activity.HDKingLegend.windows
{
   import Components.Standard.TUIButton;
   import Foundation.Common.THint;
   import Foundation.Network.TPacket;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityString;
   import Logics.Characters.TCharacter;
   import Logics.DatebaseVO.VO.THDKingGuard;
   import Logics.HDKingLegend.TActivityKingGuardData;
   import Logics.SLogicsCore;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.Common.SUtilityResource;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Processors.Game.Windows.Information.TUIWindowConfirmation;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.utils.*;
   
   public class TKingGuardGameView extends TUIComponent
   {
      
      protected static const CONST_Win:int = 1;
      
      protected static const CONST_Planish:int = 2;
      
      protected static const CONST_Lose:int = 3;
      
      protected static const CONST_MORA_COUNT:int = 4;
      
      protected static const CONST_MORACHOOSE_MAX:int = 3;
      
      protected static const MoraType_Count:uint = 3;
      
      protected static const CONST_HEROLIST_MAX:uint = 3;
      
      protected static const CONST_KingCount:int = 5;
      
      protected static const WIN:String = "Win";
      
      protected static const LOSE:String = "Lose";
      
      protected static const PLANISH:String = "Planish";
      
      protected var FScene:Sprite;
      
      protected var FUIWindowConfirmation:TUIWindowConfirmation;
      
      protected var FBtns:Vector.<TUIButton>;
      
      protected var FTFCount:TextField;
      
      protected var FSelected:Boolean;
      
      protected var FCurGuard:int;
      
      protected var FCharacter:TCharacter;
      
      protected var FLeftHand:MovieClip;
      
      protected var FLeftHandInner:MovieClip;
      
      protected var FRightHand:MovieClip;
      
      protected var FRightHandInner:MovieClip;
      
      protected var FHead:MovieClip;
      
      protected var FResult:MovieClip;
      
      protected var FResultInner:MovieClip;
      
      protected var FData:THDKingGuard;
      
      protected var FActivityData:TActivityKingGuardData;
      
      protected var FSelectIndex:int;
      
      protected var FGameStatus:int;
      
      protected var FBackSp:Sprite;
      
      protected var FClose:TUIButton;
      
      protected var FHint:THint;
      
      protected var FSendData:Function;
      
      public function TKingGuardGameView(param1:TUIComponent, param2:Sprite)
      {
         super(param1);
         this.FScene = param2;
         this.addChild(this.FScene);
         this.InitWindow();
         this.Hide();
      }
      
      protected function InitWindow() : void
      {
         var _loc1_:int = 0;
         var _loc2_:TUIButton = null;
         this.FBtns = new Vector.<TUIButton>(CONST_MORA_COUNT);
         this.FUIWindowConfirmation = SUtilityOverLayer.UIWindowConfirmation;
         _loc1_ = 0;
         while(_loc1_ < CONST_MORACHOOSE_MAX)
         {
            _loc2_ = new TUIButton();
            _loc2_.Substrate = this.FScene["mc_moraBTs"]["mc_mora_" + _loc1_];
            _loc2_.OnClick = this.OnMoraClick;
            _loc2_.OnMove = this.OnMoraMove;
            _loc2_.OnOut = this.OnMoraOut;
            this.FScene["mc_moraBTs"]["mc_moraBG_" + _loc1_].visible = false;
            this.FBtns[_loc1_] = _loc2_;
            _loc1_++;
         }
         _loc2_ = new TUIButton();
         _loc2_.Substrate = this.FScene["mc_moraBTs"]["mc_mora_Win"];
         _loc2_.OnClick = this.OnMoraWinClick;
         _loc2_.OnMove = this.OnMoraMove;
         _loc2_.OnOut = this.OnMoraOut;
         this.FScene["mc_moraBTs"]["mc_moraBG_Win"].visible = false;
         this.FBtns[CONST_MORA_COUNT - 1] = _loc2_;
         this.FLeftHand = this.FScene["mc_leftHand"];
         this.FLeftHandInner = this.FLeftHand["mc_handInner"];
         this.FRightHand = this.FScene["mc_rightHand"];
         this.FRightHandInner = this.FRightHand["mc_handInner"];
         this.FHead = this.FScene["MC_HeroHead"];
         this.FResult = this.FScene["mc_moraResult"];
         this.FResultInner = this.FResult["mc_resultInner"];
         this.FTFCount = this.FScene["TF_Count"];
         this.FScene.x += 95;
         this.FScene.y += 55;
         this.FBackSp = new Sprite();
         this.FBackSp.addChild(new Bitmap(SUtilityResource.BtmDataFullScreen));
         this.FBackSp.x = -FParent.X;
         this.FBackSp.y = -FParent.Y;
         this.addChildAt(this.FBackSp,0);
         this.FClose = new TUIButton();
         this.FClose.Substrate = this.FScene["btn_close"];
         this.FClose.OnClick = this.CloseOnClick;
         this.FHead.gotoAndStop(1);
         this.FLeftHandInner.gotoAndStop(1);
         this.FRightHandInner.gotoAndStop(1);
         this.FResultInner.gotoAndStop(1);
         this.ResetRounds();
         this.FHint = new THint();
      }
      
      protected function SendServiceData(param1:int) : void
      {
         if(this.FSendData != null)
         {
            this.FSendData(param1);
         }
      }
      
      protected function OnMoraClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TUIButton = null;
         var _loc4_:TPacket = null;
         var _loc5_:ByteArray = null;
         var _loc6_:String = null;
         var _loc7_:int = 0;
         if(this.FSelected)
         {
            return;
         }
         _loc3_ = param1 as TUIButton;
         _loc7_ = this.FBtns.indexOf(_loc3_);
         this.FSelectIndex = _loc7_ + 1;
         this.FSelected = true;
         this.FScene["mc_moraBTs"]["mc_moraBG_" + _loc7_].visible = true;
         if(this.FActivityData.FreeCount > 0 || this.FCurGuard != 0 || this.FActivityData.LastGameStatus == 1)
         {
            this.SendServiceData(this.FData.GameIndex);
         }
         else
         {
            _loc6_ = TUtilityString.Format(this.FData.GetString(6),this.FData.GameCost);
            this.FUIWindowConfirmation.Text = _loc6_;
            this.FUIWindowConfirmation.OnOK = this.OnMoraPay;
            this.FUIWindowConfirmation.OnCancel = this.OnMoraClose;
            this.FUIWindowConfirmation.OnClose = this.OnMoraClose;
            this.FUIWindowConfirmation.Visible = true;
         }
         this.EnableBtn(false);
      }
      
      protected function OnMoraPay(param1:Object) : void
      {
         if(this.FData.GameCost > SLogicsCore.Character.CreditGold)
         {
            SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.NOTENOUGH_Gold));
            this.EnableBtn(true);
            return;
         }
         this.SendServiceData(this.FData.GameIndex);
      }
      
      private function OnMoraMove(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _loc3_ = this.FBtns.indexOf(param1 as TUIButton);
         if(_loc3_ == -1)
         {
            return;
         }
         if(_loc3_ == CONST_MORA_COUNT - 1)
         {
            this.FScene["mc_moraBTs"]["mc_moraBG_Win"].visible = true;
            _loc4_ = this.FData.GameWinCost;
            this.FHint.Caption = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HELLBUTTERFLY_STRING_02),_loc4_);
            SUtilityOverLayer.UIComponentsHintOnOver(FParent,this.FHint);
            return;
         }
         this.FScene["mc_moraBTs"]["mc_moraBG_" + _loc3_].visible = true;
         if(this.FActivityData.FreeCount > 0)
         {
            return;
         }
      }
      
      private function OnMoraOut(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         _loc3_ = this.FBtns.indexOf(param1 as TUIButton);
         if(_loc3_ == CONST_MORA_COUNT - 1)
         {
            this.FScene["mc_moraBTs"]["mc_moraBG_Win"].visible = false;
            SUtilityOverLayer.UIComponentsHintOnOut(FParent,this.FHint);
            return;
         }
         this.FScene["mc_moraBTs"]["mc_moraBG_" + _loc3_].visible = false;
      }
      
      protected function OnMoraWinClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:String = null;
         var _loc4_:int = 0;
         if(this.FSelected)
         {
            return;
         }
         _loc4_ = this.FData.GameWinCost;
         if(this.FCurGuard == 0 && this.FActivityData.FreeCount < 1)
         {
            if(this.FActivityData.LastGameStatus == 0)
            {
               _loc4_ += this.FData.GameCost;
            }
         }
         if(this.FData.GameWinCost > SLogicsCore.Character.CreditGold)
         {
            SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.NOTENOUGH_Gold));
            return;
         }
         _loc3_ = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TAVERN_STRING_11),_loc4_);
         this.FUIWindowConfirmation.Text = _loc3_;
         this.FUIWindowConfirmation.OnOK = this.OnMoraWinSure;
         this.FUIWindowConfirmation.OnCancel = this.OnMoraWinSureClose;
         this.FUIWindowConfirmation.Visible = true;
         this.EnableBtn(false);
      }
      
      protected function OnMoraWinSure(param1:Object) : void
      {
         this.SendServiceData(this.FData.GameWinIndex);
      }
      
      protected function OnMoraWinSureClose(param1:Object) : void
      {
         this.EnableBtn(true);
      }
      
      protected function OnMoraClose(param1:Object) : void
      {
         this.EnableBtn(true);
         this.Hide();
      }
      
      protected function EnableBtn(param1:Boolean) : void
      {
         this.FScene.mouseEnabled = param1;
         this.FScene.mouseChildren = param1;
         this.FSelected = !param1;
      }
      
      protected function PlayResult() : void
      {
         var _loc1_:int = 0;
         this.FLeftHandInner.gotoAndStop(this.FSelectIndex);
         switch(this.FGameStatus)
         {
            case CONST_Win:
               _loc1_ = 1500;
               this.FRightHandInner.gotoAndStop(1 + this.FSelectIndex % MoraType_Count);
               this.FResultInner.gotoAndStop(WIN);
               break;
            case CONST_Lose:
               _loc1_ = 1500;
               this.FRightHandInner.gotoAndStop(1 + (this.FSelectIndex + 1) % MoraType_Count);
               this.FResultInner.gotoAndStop(LOSE);
               break;
            case CONST_Planish:
               _loc1_ = 800;
               this.FRightHandInner.gotoAndStop(this.FSelectIndex);
               this.FResultInner.gotoAndStop(PLANISH);
         }
         this.FRightHand.visible = true;
         this.FLeftHand.visible = true;
         this.FResult.visible = true;
         this.FResult.play();
         this.FLeftHand.play();
         this.FRightHand.play();
         setTimeout(this.ResetRounds,_loc1_);
      }
      
      protected function ResetRounds() : void
      {
         this.FRightHand.visible = false;
         this.FLeftHand.visible = false;
         this.FResult.visible = false;
         this.FSelected = false;
         this.OnEndMovie();
      }
      
      protected function OnEndMovie() : void
      {
         this.EnableBtn(true);
         switch(this.FGameStatus)
         {
            case CONST_Win:
               if(this.FCurGuard < CONST_KingCount)
               {
                  this.FHead.gotoAndStop(this.FCurGuard + 1);
               }
               else
               {
                  this.Hide();
               }
               break;
            case CONST_Lose:
               this.Hide();
               break;
            case CONST_Planish:
               return;
         }
         if(this.FCurGuard == 0)
         {
            this.Hide();
         }
      }
      
      protected function CloseOnClick(param1:Object, param2:MouseEvent) : void
      {
         this.Hide();
      }
      
      public function get SendData() : Function
      {
         return this.FSendData;
      }
      
      public function set SendData(param1:Function) : void
      {
         this.FSendData = param1;
      }
      
      public function set Data(param1:THDKingGuard) : void
      {
         this.FData = param1;
      }
      
      public function set ActivityData(param1:TActivityKingGuardData) : void
      {
         this.FActivityData = param1;
      }
      
      public function Show(param1:int) : void
      {
         this.FCurGuard = param1;
         this.FHead.gotoAndStop(this.FCurGuard + 1);
         this.FTFCount.text = this.FData.GetCards(this.FCurGuard) + "";
         this.FGameStatus = 0;
         this.FSelected = false;
         this.Visible = true;
      }
      
      public function Hide() : void
      {
         this.Visible = false;
      }
      
      public function UpdateGame(param1:int) : void
      {
         this.FGameStatus = param1;
         this.FCurGuard = this.FActivityData.CurGuard;
         if(this.FSelectIndex == 0)
         {
            this.FSelectIndex = Math.random() * MoraType_Count + 1;
         }
         this.PlayResult();
      }
   }
}

