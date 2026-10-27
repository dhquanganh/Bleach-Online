package Processors.Game.Lobby.Activity.HDUniteTask.windows
{
   import Components.ScrollBar.TScrollBar;
   import Components.Standard.TUIButton;
   import Foundation.Common.TCoordinate;
   import Foundation.Common.THint;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityCartisian;
   import Foundation.Utilities.TUtilityReflection;
   import Foundation.Utilities.TUtilityString;
   import Foundation.Utilities.TUtilityTexture;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDUniteTask.TUniteTaskData;
   import Logics.HDUniteTask.VO.TUltimateRewardVO;
   import Logics.HDUniteTask.VO.TUniteTaskTaskVO;
   import Logics.KnifeOfKillSoul.TKnifeOfKillSoulData;
   import Logics.Map.TMoudleInfor;
   import Logics.SLogicsCore;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDSingleWindowBase;
   import Processors.Game.Lobby.Activity.HDUniteTask.components.TUniteTaskLotteryCom;
   import Processors.Game.Lobby.Common.Hero.TProcessorWindowHeroDescription;
   import Processors.Game.Lobby.Common.Map.SceneSprite.TSceneSpriteMoudle;
   import Processors.Game.Lobby.TacticalDeployment.Components.TKnifeInforTip;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.HyperLink.SUtilityHyperLink;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Rendering.Overlayers.HDGiftBox.TOverlayerGiftBox;
   import Resources.Constants.CONST_COMMON;
   import Resources.Constants.CONST_MAP;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class TProcessorUniteTaskView extends TProcessorHDSingleWindowBase
   {
      
      protected const MinScrollDistance:Number = 301;
      
      protected const ItemStamp:Number = 0.55;
      
      protected const SingleItemStamp:Number = 74.45;
      
      protected const MoveFrame:uint = 2;
      
      protected const OutFrame:uint = 1;
      
      protected const ReceiveFrame:uint = 3;
      
      protected var FData:TUniteTaskData;
      
      protected var FTaskRewards:Vector.<TUIButton>;
      
      protected var FGoToTaskBtns:Vector.<TUIButton>;
      
      protected var FLowEmploymentBtn:TUIButton;
      
      protected var FSeniorEmploymentBtn:TUIButton;
      
      protected var FWindowShowHero:TProcessorWindowHeroDescription;
      
      protected var FRoleMoudle:TSceneSpriteMoudle;
      
      protected var FQueryModel:TMoudleInfor;
      
      protected var FUltimateRewardBtn:TUIButton;
      
      protected var FScrollBar:TScrollBar;
      
      protected var FLotteryCom:TUniteTaskLotteryCom;
      
      protected var FCurrentOverHint:THint;
      
      protected var FKnifePop:TKnifeInforTip;
      
      protected var FKnifeOfKillSoulData:TKnifeOfKillSoulData;
      
      protected var FOnCreateKnifeOfKillSoulData:Function;
      
      public function TProcessorUniteTaskView(param1:TUIComponent)
      {
         super(param1);
         this.FCurrentOverHint = new THint();
      }
      
      override protected function Reset() : void
      {
         if(this.FWindowShowHero != null)
         {
            this.FWindowShowHero.Hide();
         }
         if(this.FLotteryCom != null)
         {
            this.FLotteryCom.Reset();
         }
      }
      
      override protected function UpdateUIConfig() : void
      {
         super.UpdateUIConfig();
         if(FActivityAtoms != null)
         {
            ProcessorFormatActivityTimeFromNowOn(FActivityAtoms.EndTime);
            ProcessorFormatActivityCountDown(FActivityAtoms.EndTime);
         }
      }
      
      override protected function UpdateDataBase(param1:TActivityOSBase) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:TUIButton = null;
         var _loc4_:TUniteTaskTaskVO = null;
         var _loc5_:TUltimateRewardVO = null;
         var _loc6_:TextField = null;
         var _loc7_:MovieClip = null;
         var _loc8_:MovieClip = null;
         this.FData = param1 as TUniteTaskData;
         _loc2_ = 0;
         while(_loc2_ < TUniteTaskData.TaskCount)
         {
            _loc8_ = this.FScrollBar.Items[_loc2_] as MovieClip;
            _loc4_ = this.FData.TaskVOs[_loc2_];
            _loc8_.TF_DescName.text = _loc4_.DescName;
            _loc8_.TF_DescAddReward.text = _loc4_.DescAddReward;
            _loc8_.TF_DescProgKey.text = _loc4_.DescProgKey;
            _loc8_.TF_DescProgValue.text = _loc4_.DescProgValue;
            _loc3_ = this.FTaskRewards[_loc2_];
            _loc3_.Enabled = _loc4_.AwardBtnEnabled;
            _loc8_.MC_Receive.visible = _loc4_.IsReceive;
            _loc8_.MC_Finish.visible = _loc4_.IsFinish;
            _loc2_++;
         }
         this.FLowEmploymentBtn.Enabled = this.FData.LowEmploymentEnabled;
         this.FSeniorEmploymentBtn.Enabled = this.FData.SeniorEmploymentEnabled;
         FScene["TF_LowEmploymentCost"].text = this.FData.Config.Employ[0].cost.toString();
         FScene["TF_SeniorEmploymentCost"].text = this.FData.Config.Employ[1].cost.toString();
         _loc5_ = this.FData.UltimateRewardVO;
         _loc8_ = FScene["MC_UltimateReward"];
         if(_loc5_.Type == TUltimateRewardVO.RewardType_Hero || _loc5_.Type == TUltimateRewardVO.RewardType_Knife)
         {
            _loc8_.MC_Gift.visible = false;
            _loc8_.TF_HeroName.visible = true;
            _loc8_.MC_NameBack.visible = true;
            _loc8_.MC_MountPoint.visible = true;
            TUtilityTexture.QueryTwoDirectionShowCase(CONST_MAP.DIRECTION_RIGHT,_loc5_.MoudleID,this.FQueryModel);
            this.FRoleMoudle.ChangeRoleMoudle(this.FQueryModel.TextureID,1);
            _loc8_.TF_HeroName.text = _loc5_.Name;
            _loc8_.TF_HeroName.textColor = CONST_COMMON.QUALITYCOLOR_INDEX[_loc5_.Quality];
            _loc8_.MC_MountPoint.buttonMode = _loc5_.Type == TUltimateRewardVO.RewardType_Hero;
            if(_loc5_.Type == TUltimateRewardVO.RewardType_Knife)
            {
               if(this.FOnCreateKnifeOfKillSoulData != null)
               {
                  this.FKnifeOfKillSoulData = this.FOnCreateKnifeOfKillSoulData(_loc5_.KnifeID);
               }
               this.FKnifePop.KnifeData = this.FKnifeOfKillSoulData;
            }
         }
         else
         {
            _loc8_.MC_Gift.visible = true;
            _loc8_.TF_HeroName.visible = false;
            _loc8_.MC_NameBack.visible = false;
            _loc8_.MC_MountPoint.visible = false;
         }
         _loc8_.MC_Receive.visible = _loc5_.IsReceive;
         this.FUltimateRewardBtn.Enabled = _loc5_.ReceiveEnabled;
         if(_loc5_.IsReceive)
         {
            _loc8_.MC_Gift.gotoAndStop(this.ReceiveFrame);
         }
         this.FLotteryCom.UpdateUI(this.FData);
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(!this.Visible)
         {
            return;
         }
         if(this.FData.UltimateRewardVO.Type == TUltimateRewardVO.RewardType_Hero || this.FData.UltimateRewardVO.Type == TUltimateRewardVO.RewardType_Knife)
         {
            if(this.FRoleMoudle.TextrueID != 0)
            {
               this.FRoleMoudle.UpdateView();
            }
         }
         if(this.FLotteryCom != null)
         {
            this.FLotteryCom.LogicsPerform();
         }
      }
      
      protected function Lottery_C2S() : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FData.Config.Extract.index);
      }
      
      protected function OnTaskAwardClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TUIButton = null;
         _loc3_ = param1 as TUIButton;
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FData.Config.Tasks[_loc3_.Tag].index);
      }
      
      protected function OnTaskAwardMove(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TUIButton = null;
         var _loc4_:TUniteTaskTaskVO = null;
         _loc3_ = param1 as TUIButton;
         _loc4_ = this.FData.TaskVOs[_loc3_.Tag];
         ProcessorOnGiftBoxMove(this,_loc4_.Inventories,TOverlayerGiftBox.TYPE_ALL);
      }
      
      protected function OnTaskAwardOut(param1:Object, param2:MouseEvent) : void
      {
         ProcessorOnGiftBoxOut(this);
      }
      
      protected function OnGoTaskClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TUIButton = null;
         var _loc4_:TUniteTaskTaskVO = null;
         _loc3_ = param1 as TUIButton;
         _loc4_ = this.FData.TaskVOs[_loc3_.Tag];
         SUtilityHyperLink.ShortcutHyperlink(_loc4_.Link);
      }
      
      protected function OnLowEmploymentClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:uint = 0;
         _loc3_ = uint(this.FData.Config.Employ[0].cost);
         if(_loc3_ <= SLogicsCore.Character.CreditGold)
         {
            FUIWindowConfirmation.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_06),_loc3_);
            FUIWindowConfirmation.OnOK = this.OnLowEmploymentClickOK;
            FUIWindowConfirmation.Visible = true;
         }
         else
         {
            FUIWindowRecharge.SetGoldNum(_loc3_);
            FUIWindowRecharge.Visible = true;
         }
      }
      
      protected function OnLowEmploymentMove(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:String = null;
         _loc3_ = this.FData.Config.Employ[0].tips[this.FData.Day];
         _loc3_ = TUtilityString.WrapFormat(_loc3_);
         this.FCurrentOverHint.Caption = _loc3_;
         SUtilityOverLayer.UIComponentsHintOnOver(this,this.FCurrentOverHint);
      }
      
      protected function OnLowEmploymentOut(param1:Object, param2:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOut(this,this.FCurrentOverHint);
      }
      
      protected function OnSeniorEmploymentClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:uint = 0;
         _loc3_ = uint(this.FData.Config.Employ[1].cost);
         if(_loc3_ <= SLogicsCore.Character.CreditGold)
         {
            FUIWindowConfirmation.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_06),_loc3_);
            FUIWindowConfirmation.OnOK = this.OnSeniorEmploymentClickOK;
            FUIWindowConfirmation.Visible = true;
         }
         else
         {
            FUIWindowRecharge.SetGoldNum(_loc3_);
            FUIWindowRecharge.Visible = true;
         }
      }
      
      protected function OnSeniorEmploymentMove(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:String = null;
         _loc3_ = this.FData.Config.Employ[1].tips[this.FData.Day];
         _loc3_ = TUtilityString.WrapFormat(_loc3_);
         this.FCurrentOverHint.Caption = _loc3_;
         SUtilityOverLayer.UIComponentsHintOnOver(this,this.FCurrentOverHint);
      }
      
      protected function OnSeniorEmploymentOut(param1:Object, param2:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOut(this,this.FCurrentOverHint);
      }
      
      protected function OnUltimateRewardReceiveClick(param1:Object, param2:MouseEvent) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FData.Config.FinalAward.index);
      }
      
      protected function OnHeroClick(param1:MouseEvent) : void
      {
         var _loc2_:TUltimateRewardVO = null;
         var _loc3_:TCoordinate = null;
         if(this.FData.UltimateRewardVO.Type == TUltimateRewardVO.RewardType_Hero)
         {
            if(!this.FWindowShowHero.Visible)
            {
               _loc2_ = this.FData.UltimateRewardVO;
               this.FWindowShowHero.HeroID = _loc2_.MoudleID;
               this.FWindowShowHero.Show();
               _loc3_ = TUtilityCartisian.GetScreenCoordinateByDisplayObject(this);
               this.FWindowShowHero.X = -_loc3_.X;
               this.FWindowShowHero.Y = -_loc3_.Y;
            }
         }
      }
      
      protected function OnHeroMove(param1:MouseEvent) : void
      {
         var _loc2_:TCoordinate = null;
         if(this.FData.UltimateRewardVO.Type == TUltimateRewardVO.RewardType_Knife)
         {
            this.FKnifePop.Visible = true;
            this.FKnifePop.UpdatePosition();
            _loc2_ = TUtilityCartisian.GetScreenCoordinateByDisplayObject(FParent);
            this.FKnifePop.x -= _loc2_.X;
            this.FKnifePop.y -= _loc2_.Y;
         }
      }
      
      protected function OnHeroOut(param1:MouseEvent) : void
      {
         this.FKnifePop.Visible = false;
      }
      
      protected function OnUltimateRewardGiftMove(param1:MouseEvent) : void
      {
         var _loc2_:TUltimateRewardVO = null;
         var _loc3_:MovieClip = null;
         _loc2_ = this.FData.UltimateRewardVO;
         ProcessorOnGiftBoxMove(this,_loc2_.Inventories,TOverlayerGiftBox.TYPE_ALL);
         _loc3_ = FScene["MC_UltimateReward"].MC_Gift;
         if(_loc3_.currentFrame != this.ReceiveFrame)
         {
            _loc3_.gotoAndStop(this.MoveFrame);
         }
      }
      
      protected function OnUltimateRewardGiftOut(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = null;
         ProcessorOnGiftBoxOut(this);
         _loc2_ = FScene["MC_UltimateReward"].MC_Gift;
         if(_loc2_.currentFrame != this.ReceiveFrame)
         {
            _loc2_.gotoAndStop(this.OutFrame);
         }
      }
      
      protected function OnLowEmploymentClickOK(param1:Object) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FData.Config.Employ[0].index);
      }
      
      protected function OnSeniorEmploymentClickOK(param1:Object) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FData.Config.Employ[1].index);
      }
      
      public function set OnCreateKnifeOfKillSoulData(param1:Function) : void
      {
         this.FOnCreateKnifeOfKillSoulData = param1;
      }
      
      override public function InitWindow(param1:Sprite = null) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:MovieClip = null;
         var _loc4_:MovieClip = null;
         var _loc5_:TUIButton = null;
         super.InitWindow(param1);
         this.FTaskRewards = new Vector.<TUIButton>(TUniteTaskData.TaskCount);
         this.FGoToTaskBtns = new Vector.<TUIButton>(TUniteTaskData.TaskCount);
         this.FScrollBar = new TScrollBar(FScene["MC_RollScene"],this.MinScrollDistance,false,this.ItemStamp,this.SingleItemStamp);
         this.FScrollBar.Visible = true;
         _loc2_ = 0;
         while(_loc2_ < TUniteTaskData.TaskCount)
         {
            _loc3_ = TUtilityReflection.CreateDisplayObjectInstance("MC_UniteTaskBar") as MovieClip;
            this.FScrollBar.AddItem(_loc3_);
            _loc4_ = _loc3_.MC_Award.MC_Awards;
            _loc4_.gotoAndStop(_loc2_ + 1);
            _loc5_ = new TUIButton();
            _loc5_.Substrate = _loc4_.Btn_Award;
            _loc5_.OnClick = this.OnTaskAwardClick;
            _loc5_.OnMove = this.OnTaskAwardMove;
            _loc5_.OnOut = this.OnTaskAwardOut;
            _loc5_.Tag = _loc2_;
            this.FTaskRewards[_loc2_] = _loc5_;
            _loc5_ = new TUIButton();
            _loc5_.Substrate = _loc3_.Btn_GoTask;
            _loc5_.OnClick = this.OnGoTaskClick;
            _loc5_.Tag = _loc2_;
            this.FGoToTaskBtns[_loc2_] = _loc5_;
            _loc4_ = _loc3_.MC_Receive;
            _loc4_.mouseEnabled = false;
            _loc4_ = _loc3_.MC_Finish;
            _loc4_.mouseEnabled = false;
            _loc2_++;
         }
         this.FLowEmploymentBtn = new TUIButton();
         this.FLowEmploymentBtn.Substrate = FScene["Btn_LowEmployment"];
         this.FLowEmploymentBtn.OnClick = this.OnLowEmploymentClick;
         this.FLowEmploymentBtn.OnMove = this.OnLowEmploymentMove;
         this.FLowEmploymentBtn.OnOut = this.OnLowEmploymentOut;
         this.FSeniorEmploymentBtn = new TUIButton();
         this.FSeniorEmploymentBtn.Substrate = FScene["Btn_SeniorEmployment"];
         this.FSeniorEmploymentBtn.OnClick = this.OnSeniorEmploymentClick;
         this.FSeniorEmploymentBtn.OnMove = this.OnSeniorEmploymentMove;
         this.FSeniorEmploymentBtn.OnOut = this.OnSeniorEmploymentOut;
         this.FWindowShowHero = new TProcessorWindowHeroDescription(this);
         this.FWindowShowHero.Perform_UIDispatch();
         this.FWindowShowHero.HintOnOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FWindowShowHero.HintOnOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FWindowShowHero.Visible = false;
         this.FQueryModel = new TMoudleInfor();
         this.FRoleMoudle = new TSceneSpriteMoudle();
         _loc3_ = FScene["MC_UltimateReward"];
         _loc4_ = _loc3_.MC_MountPoint;
         _loc4_.addChild(this.FRoleMoudle);
         _loc4_.addEventListener(MouseEvent.CLICK,this.OnHeroClick);
         _loc4_.addEventListener(MouseEvent.ROLL_OVER,this.OnHeroMove);
         _loc4_.addEventListener(MouseEvent.ROLL_OUT,this.OnHeroOut);
         this.FUltimateRewardBtn = new TUIButton();
         _loc4_ = _loc3_.Btn_Receive;
         this.FUltimateRewardBtn.Substrate = _loc4_;
         this.FUltimateRewardBtn.OnClick = this.OnUltimateRewardReceiveClick;
         _loc4_ = _loc3_.MC_Gift;
         _loc4_.addEventListener(MouseEvent.MOUSE_MOVE,this.OnUltimateRewardGiftMove);
         _loc4_.addEventListener(MouseEvent.MOUSE_OUT,this.OnUltimateRewardGiftOut);
         _loc4_ = _loc3_.MC_Receive;
         _loc4_.mouseEnabled = false;
         this.FLotteryCom = new TUniteTaskLotteryCom(this);
         this.FLotteryCom.Lottery_C2S = this.Lottery_C2S;
         this.FLotteryCom.InitWindow(FScene["MC_Lottery"]);
         this.FKnifePop = new TKnifeInforTip(FParent);
         this.FKnifePop.UIDispatch();
         this.FKnifePop.Visible = false;
      }
   }
}

