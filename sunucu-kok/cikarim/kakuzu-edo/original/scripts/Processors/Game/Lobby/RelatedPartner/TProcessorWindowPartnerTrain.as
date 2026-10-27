package Processors.Game.Lobby.RelatedPartner
{
   import Components.Standard.*;
   import Foundation.Common.THint;
   import Foundation.Network.SNetworkCore;
   import Foundation.Network.TPacket;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.TUIComponent;
   import Logics.Characters.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.Streamization.RelatedPartner.VO.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.RelatedPartner.Component.*;
   import Processors.Game.Lobby.RelatedPartner.PartnerTrain.*;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.Common.SUtilityResource;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.utils.ByteArray;
   
   public class TProcessorWindowPartnerTrain extends TProcessorLobbyWindow
   {
      
      protected static const FrameIndex_WaitCross:int = CONST_RELATEDPARTNER.FrameIndex_WaitCross;
      
      protected static const FrameIndex_Selected:int = CONST_RELATEDPARTNER.FrameIndex_Selected;
      
      protected static const FrameIndex_AlreadyCross:int = CONST_RELATEDPARTNER.FrameIndex_AlreadyCross;
      
      protected static const Point_Num:int = CONST_RELATEDPARTNER.PartnerTrain_Point_Num;
      
      protected static const Point_Star:int = CONST_RELATEDPARTNER.PartnerTrain_Point_Star;
      
      protected static const Point_Height:int = 75;
      
      protected var FBackGound:Bitmap;
      
      protected var FDailyRewardView:TWindowTrainDailyReward;
      
      protected var FStarRewardView:TWindowTrainStarReward;
      
      protected var FBtnStarReward:TUIButton;
      
      protected var FBtnDailyReward:TUIButton;
      
      protected var FTFStarCount:TextField;
      
      protected var FFightPoints:Vector.<TItemTrainPoint>;
      
      protected var FHeroInfo:TPartnerTrainHeroPointVO;
      
      protected var FGainStarCount:int;
      
      protected var FHint:THint;
      
      protected var FMainUI:Sprite;
      
      protected var FCurPointIndex:int;
      
      protected var FSelectedIndex:int;
      
      protected var FMCAnimation:MovieClip;
      
      protected var FMaxStar:int;
      
      protected var FStarRewardStatus:int;
      
      protected var FOnBattleReady:Function;
      
      public function TProcessorWindowPartnerTrain(param1:TUIComponent)
      {
         super(param1);
      }
      
      public function InitView(param1:Sprite) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Sprite = null;
         var _loc4_:TItemTrainPoint = null;
         this.FMainUI = param1;
         this.FBackGound = new Bitmap(SUtilityResource.BtmDataFullScreen);
         this.FDailyRewardView = new TWindowTrainDailyReward(this,this.FMainUI["MC_DailyTrain"]);
         this.FDailyRewardView.Visible = false;
         this.FStarRewardView = new TWindowTrainStarReward(this,this.FMainUI["MC_StarReward"]);
         this.FStarRewardView.Visible = false;
         this.FBtnStarReward = new TUIButton();
         this.FBtnStarReward.Substrate = this.FMainUI["Btn_Reward"];
         this.FBtnStarReward.OnClick = this.BtnOnRewardClick;
         this.FBtnDailyReward = new TUIButton();
         this.FBtnDailyReward.Substrate = this.FMainUI["Btn_DailyReward"];
         this.FBtnDailyReward.OnClick = this.BtnOnRewardClick;
         this.FTFStarCount = this.FMainUI["TF_Count"];
         this.FFightPoints = new Vector.<TItemTrainPoint>();
         _loc2_ = 0;
         while(_loc2_ < Point_Num)
         {
            _loc4_ = new TItemTrainPoint(this.FMainUI["MC_Point_" + _loc2_]);
            _loc4_.OnMove = this.PointOnMove;
            _loc4_.OnOut = this.PointOnOut;
            _loc4_.OnClick = this.PointOnClick;
            this.FFightPoints.push(_loc4_);
            _loc2_++;
         }
         this.FSelectedIndex = -1;
         this.FHeroInfo = new TPartnerTrainHeroPointVO();
         this.FHint = new THint();
         this.FMCAnimation = this.FMainUI["MC_Animation"];
         this.FMaxStar = Point_Num * Point_Star;
      }
      
      protected function RenderUI() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         this.FTFStarCount.text = this.FGainStarCount + "";
         _loc1_ = 0;
         while(_loc1_ < Point_Num)
         {
            this.FFightPoints[_loc1_].SetStar(this.FHeroInfo.Stars[_loc1_]);
            this.FFightPoints[_loc1_].PveId = this.FHeroInfo.PveIds[_loc1_];
            if(this.FHeroInfo.Stars[_loc1_] > 0)
            {
               this.FFightPoints[_loc1_].SetPointStatus(FrameIndex_AlreadyCross);
               _loc2_ = _loc1_ + 1 == Point_Num ? _loc1_ : int(_loc1_ + 1);
            }
            else
            {
               this.FFightPoints[_loc1_].SetPointStatus(FrameIndex_WaitCross);
            }
            _loc1_++;
         }
         this.FCurPointIndex = _loc2_;
         if(this.FSelectedIndex > -1)
         {
            if(this.FSelectedIndex <= this.FCurPointIndex)
            {
               this.FFightPoints[this.FSelectedIndex].SetPointStatus(FrameIndex_Selected);
            }
            else
            {
               SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_NREORG_59));
            }
            if(this.FSelectedIndex != this.FCurPointIndex)
            {
               this.FFightPoints[this.FCurPointIndex].SetPointStatus(FrameIndex_AlreadyCross);
            }
         }
         else if(this.FHeroInfo.GetStarCount() < this.FMaxStar)
         {
            this.FFightPoints[this.FCurPointIndex].SetPointStatus(FrameIndex_Selected);
         }
         this.SetAnimationPos(this.FSelectedIndex);
         this.FSelectedIndex = -1;
      }
      
      protected function SetAnimationPos(param1:int) : void
      {
         var _loc2_:Sprite = null;
         if(param1 < 0)
         {
            return;
         }
         _loc2_ = this.FMainUI["MC_Point_" + param1];
         this.FMCAnimation.x = _loc2_.x;
         this.FMCAnimation.y = _loc2_.y + Point_Height;
         this.FMCAnimation.play();
         this.FMCAnimation.visible = true;
      }
      
      protected function Reset() : void
      {
         var _loc1_:int = 0;
         this.FTFStarCount.text = "0";
         _loc1_ = 0;
         while(_loc1_ < Point_Num)
         {
            this.FFightPoints[_loc1_].Reset();
            _loc1_++;
         }
      }
      
      protected function PointInfoReq() : void
      {
         var _loc1_:TPacket = null;
         var _loc2_:ByteArray = null;
         var _loc3_:int = 0;
         this.Reset();
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Related_PointInfoReq);
         _loc2_ = _loc1_.Data;
         SNetworkCore.Transceiver.PacketTransmit(_loc1_);
      }
      
      protected function BtnOnRewardClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TUIButton = null;
         _loc3_ = param1 as TUIButton;
         switch(_loc3_)
         {
            case this.FBtnStarReward:
               this.FStarRewardView.Show(this.FHeroInfo.GetStarCount());
               this.FStarRewardView.SetBackground(this.FBackGound);
               break;
            case this.FBtnDailyReward:
               this.FDailyRewardView.Visible = true;
               this.FDailyRewardView.SetBackground(this.FBackGound);
         }
      }
      
      protected function PointOnClick(param1:Object, param2:int) : void
      {
         var _loc3_:uint = 0;
         if(param2 <= 0)
         {
            SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_NREORG_59));
            return;
         }
         if(this.FOnBattleReady != null)
         {
            _loc3_ = this.FFightPoints.indexOf(param1);
            this.FOnBattleReady(param2,this.FHeroInfo.Stars[_loc3_]);
         }
      }
      
      protected function PointOnMove(param1:int) : void
      {
         var _loc2_:TRelatedPartnerPoint = null;
         if(param1 <= 0)
         {
            return;
         }
         _loc2_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_RelatedPartnerPoint,param1) as TRelatedPartnerPoint;
         this.FHint.Caption = _loc2_.Name;
         SUtilityOverLayer.UIComponentsHintOnOver(FUICore,this.FHint);
      }
      
      protected function PointOnOut(param1:int) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOut(FUICore,this.FHint);
      }
      
      public function get OnBattleReady() : Function
      {
         return this.FOnBattleReady;
      }
      
      public function set OnBattleReady(param1:Function) : void
      {
         this.FOnBattleReady = param1;
      }
      
      public function get StarRewardStatus() : int
      {
         return this.FStarRewardStatus;
      }
      
      public function set StarRewardStatus(param1:int) : void
      {
         this.FStarRewardStatus = param1;
         this.FStarRewardView.SetStatus(this.FStarRewardStatus);
      }
      
      override public function get Visible() : Boolean
      {
         return super.Visible;
      }
      
      override public function set Visible(param1:Boolean) : void
      {
         super.Visible = param1;
         if(this.FMainUI != null)
         {
            this.FMainUI.visible = param1;
         }
      }
      
      public function Render(param1:TPartnerTrainHeroPointVO) : void
      {
         var _loc2_:int = 0;
         this.FHeroInfo = param1;
         this.FDailyRewardView.SetHeroInfo(this.FHeroInfo);
         this.FGainStarCount = 0;
         _loc2_ = 0;
         while(_loc2_ < Point_Num)
         {
            this.FGainStarCount += this.FHeroInfo.Stars[_loc2_];
            _loc2_++;
         }
         this.RenderUI();
      }
      
      public function Show() : void
      {
         this.PointInfoReq();
         this.FMCAnimation.stop();
         this.FMCAnimation.visible = false;
      }
      
      public function GotoSelectPoint(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         this.FSelectedIndex = -1;
         _loc3_ = int(this.FFightPoints.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(this.FFightPoints[_loc2_].PveId == param1)
            {
               this.FSelectedIndex = _loc2_;
               break;
            }
            _loc2_++;
         }
         this.RenderUI();
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(this.FDailyRewardView != null && this.FDailyRewardView.Visible)
         {
            this.FDailyRewardView.Update();
         }
      }
   }
}

