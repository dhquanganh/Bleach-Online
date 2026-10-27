package Processors.Game.Lobby.Activity.HDLuckyJoy
{
   import Components.SelectBox.*;
   import Components.Standard.*;
   import Foundation.Resources.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.HDActivityMode.*;
   import Logics.HDActivityOS.*;
   import Logics.HDLuckyJoy.*;
   import Logics.Inventories.*;
   import Logics.Log.*;
   import Processors.Game.Common.Effects.Display.*;
   import Processors.Game.Lobby.Activity.HDActivity.*;
   import Processors.Game.Lobby.Utilities.*;
   import Processors.Game.Utilities.Common.*;
   import Processors.Game.Utilities.EffectTextReward.*;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   import ghostcat.util.data.*;
   
   public class TProcessorHDWindowLuckyJoy extends TProcessorHDSingleWindowBase
   {
      
      protected var ROLLTYPENUM:int = 3;
      
      protected var ROLLICONNUM:int = 3;
      
      protected var AWARDINFORNUM:int = 8;
      
      protected var RollCircleNum:Vector.<int> = Vector.<int>([5,7,7]);
      
      protected var FShowAwardSeqIDS:Vector.<int> = Vector.<int>([1,2,3,4,5,9,11,14]);
      
      protected var MaxRollRecordNum:int = 10;
      
      protected var FTigerMachineUI:Sprite;
      
      protected var FSelectBoxSingle:TSelectBoxSingle;
      
      protected var FTigerMachineRoll:TUIButton;
      
      protected var FTFRoolCost:TextField;
      
      protected var FFreeTime:TextField;
      
      protected var FTFScore:TextField;
      
      protected var FBtnExchange:TUIButton;
      
      protected var FTigerMachineEffect:MovieClip;
      
      protected var FRollEffect:MovieClip;
      
      protected var FMachineIcon:Vector.<MovieClip>;
      
      protected var FCurrentRollType:int;
      
      protected var FRollCircleRest:int;
      
      protected var FIsRunning:Boolean;
      
      protected var FEffectBaseGlow:TEffectBaseGlow;
      
      protected var FEffectRollGlow:TEffectBaseGlow;
      
      protected var FCanExchange:Boolean;
      
      protected var FLotteryRecord:TextField;
      
      protected var FAwardShortcuts:MovieClip;
      
      protected var FAwardDetail:Vector.<TextField>;
      
      protected var FScoreDetail:TextField;
      
      protected var FBtnLookAward:TUIButton;
      
      protected var FLayerMask:Sprite;
      
      protected var FProcessorHDWindowScoreExchange:TProcessorHDWindowScoreExchange;
      
      protected var FActivityLuckyJoyData:TActivityLuckyJoyData;
      
      protected var FOnLoadLog:Function;
      
      public function TProcessorHDWindowLuckyJoy(param1:TUIComponent)
      {
         super(param1);
         FSceneResourceName = CONST_ACTIVITY.RESOURCE_ClassName_ActivitySingleLuckyJoy;
         FActivityID = CONST_ACTIVITY_MODE.Activity_LuckyJoy;
         this.FProcessorHDWindowScoreExchange = new TProcessorHDWindowScoreExchange(this);
         this.FProcessorHDWindowScoreExchange.OnBtnExchangeClick = this.ExchangeAwardReq;
         this.FProcessorHDWindowScoreExchange.OnClose = this.CloseExchangeWindow;
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(Visible)
         {
            this.UpdateTigerMachineEffect();
            this.UpdateRollEffect();
            this.UpdateBtnEffect();
            this.FEffectRollGlow.Run();
         }
      }
      
      override public function InitWindow(param1:Sprite = null) : void
      {
         super.InitWindow(param1);
         this.UIDispatchTigerMachine();
         this.UIDispatchRollRecord();
         this.FLayerMask = new Sprite();
         addChild(this.FLayerMask);
         this.FLayerMask.visible = false;
         this.FLayerMask.addChild(new Bitmap(SUtilityResource.BtmDataFullScreen));
         this.FLayerMask.x = -x;
         this.FLayerMask.y = -y;
         this.FProcessorHDWindowScoreExchange.UIDispatch();
         this.FProcessorHDWindowScoreExchange.x = (FScene.width - this.FProcessorHDWindowScoreExchange.width) / 2;
         this.FProcessorHDWindowScoreExchange.y = (FScene.height - this.FProcessorHDWindowScoreExchange.height) / 2;
         addChild(this.FProcessorHDWindowScoreExchange);
         this.Reset();
      }
      
      protected function UIDispatchTigerMachine() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         this.FTigerMachineUI = FScene["TigerMachineUI"];
         this.FSelectBoxSingle = new TSelectBoxSingle();
         _loc1_ = 0;
         while(_loc1_ < this.ROLLTYPENUM)
         {
            this.FSelectBoxSingle.SetTaskByIndex(_loc1_,this.FTigerMachineUI["RollType" + _loc1_]["MC_Button"]);
            _loc1_++;
         }
         this.FSelectBoxSingle.CallBackOnSelect = this.SelectBoxSingleOnClick;
         this.FSelectBoxSingle.Init();
         this.FTigerMachineRoll = new TUIButton();
         this.FTigerMachineRoll.Substrate = this.FTigerMachineUI["Roll"];
         this.FTigerMachineRoll.OnClick = this.BtnRollOnClick;
         this.FTFRoolCost = this.FTigerMachineUI["RollCost"];
         this.FTFScore = FScene["TF_Score"];
         this.FFreeTime = this.FTigerMachineUI["freeTime"]["TFFreeTime"];
         this.FBtnExchange = new TUIButton();
         this.FBtnExchange.Substrate = FScene["BtnExchange"];
         this.FBtnExchange.OnClick = this.BtnExchangeOnClick;
         this.FEffectBaseGlow = new TEffectBaseGlow();
         this.FEffectRollGlow = new TEffectBaseGlow();
         this.FEffectRollGlow.SetParameters(this.FTigerMachineRoll.Substrate,16776960,1);
         this.FTigerMachineEffect = this.FTigerMachineUI["TigerMachineEffect"];
         this.FRollEffect = this.FTigerMachineUI["RollEffect"];
         this.FMachineIcon = new Vector.<MovieClip>();
         _loc1_ = 0;
         while(_loc1_ < this.ROLLICONNUM)
         {
            this.FMachineIcon.push(this.FTigerMachineUI["RollIcon" + _loc1_]);
            _loc1_++;
         }
      }
      
      protected function UIDispatchRollRecord() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Sprite = null;
         this.FAwardDetail = new Vector.<TextField>();
         this.FLotteryRecord = FScene["LotteryRecord"]["TF_RollRecord"];
         this.FAwardShortcuts = FScene["AwardShortcuts"]["AwardShortcuts"];
         _loc3_ = this.FAwardShortcuts["AwardPanle"];
         _loc1_ = 0;
         while(_loc1_ < this.AWARDINFORNUM)
         {
            this.FAwardDetail[_loc1_] = _loc3_["AwardInfor" + _loc1_];
            _loc1_++;
         }
         this.FScoreDetail = _loc3_["ScoreInfor"];
         this.FBtnLookAward = new TUIButton();
         this.FBtnLookAward.Substrate = this.FAwardShortcuts["BtnLook"];
         this.FBtnLookAward.OnClick = this.BtnLookOnClick;
      }
      
      override protected function UpdateDataBase(param1:TActivityOSBase) : void
      {
         super.UpdateDataBase(param1);
         this.FActivityLuckyJoyData = param1 as TActivityLuckyJoyData;
         this.UpdateUI();
      }
      
      override protected function UpdateUI() : void
      {
         this.RenderTigerMachine();
         this.RenderAwardInfor();
         ProcessorFormatActivityTimeFromNowOn(FActivityAtoms.EndTime);
         ProcessorFormatActivityCountDown(FActivityAtoms.EndTime);
      }
      
      protected function RenderTigerMachine() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         if(this.FActivityLuckyJoyData.LastFreeTime >= this.FActivityLuckyJoyData.LotteryCount[this.FCurrentRollType])
         {
            this.FTFRoolCost.text = "0";
         }
         else
         {
            this.FTFRoolCost.text = this.FActivityLuckyJoyData.LotteryCost[this.FCurrentRollType].toString();
         }
         this.FTFScore.text = this.FActivityLuckyJoyData.CurrentScore.toString();
         this.FFreeTime.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_76),this.FActivityLuckyJoyData.LastFreeTime);
      }
      
      protected function RenderLotteryRecord(param1:Vector.<TLog>) : void
      {
         var _loc2_:* = 0;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:TLog = null;
         var _loc6_:Object = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:TArticle = null;
         var _loc11_:int = 0;
         _loc4_ = "";
         _loc11_ = 0;
         _loc3_ = int(param1.length);
         _loc2_ = int(_loc3_ - 1);
         while(_loc2_ >= 0)
         {
            _loc5_ = param1[_loc2_];
            _loc6_ = Json.decode(_loc5_.Data);
            _loc7_ = int(_loc6_.type);
            _loc8_ = int(_loc6_.code);
            _loc9_ = int(_loc6_.amount);
            _loc10_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_Article,CONST_COMMON.RewardIDToTemplateID(_loc7_,_loc8_)) as TArticle;
            _loc4_ += TUtilityString.Format("%0 * %1\n",_loc10_.Name,_loc9_);
            if(++_loc11_ >= this.MaxRollRecordNum)
            {
               break;
            }
            _loc2_--;
         }
         this.FLotteryRecord.text = _loc4_;
      }
      
      protected function RenderAwardInfor() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TInventory = null;
         _loc2_ = int(this.FShowAwardSeqIDS.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FActivityLuckyJoyData.AwardInventories[this.FShowAwardSeqIDS[_loc1_] - 1].GetInventoryByIndex(0);
            this.FAwardDetail[_loc1_].text = TUtilityString.Format("%0 * %1",_loc3_.Name,_loc3_.Quantity);
            _loc1_++;
         }
      }
      
      protected function UpdateTigerMachineEffect() : void
      {
         if(this.FIsRunning)
         {
            if(this.FTigerMachineEffect.currentFrame == this.FTigerMachineEffect.totalFrames)
            {
               --this.FRollCircleRest;
               if(this.FRollCircleRest <= 0)
               {
                  this.RollRequest();
                  this.FIsRunning = false;
               }
            }
         }
      }
      
      protected function UpdateRollEffect() : void
      {
         if(this.FRollEffect.visible)
         {
            if(this.FRollEffect.currentFrame == this.FRollEffect.totalFrames)
            {
               this.StopRollEffect();
            }
         }
      }
      
      protected function StartBtnEffect() : void
      {
         this.FEffectBaseGlow.SetParameters(this.FBtnExchange.Substrate,16776960,1);
      }
      
      protected function StopBtnEffect() : void
      {
         this.FEffectBaseGlow.Stop();
      }
      
      protected function UpdateBtnEffect() : void
      {
         if(this.FCanExchange)
         {
            this.FEffectBaseGlow.Run();
         }
      }
      
      protected function RollRequest() : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FActivityLuckyJoyData.LotteryIndex[this.FCurrentRollType]);
      }
      
      protected function GarbleVec(param1:Vector.<int>) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         _loc3_ = int(param1.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = Math.random() * int.MAX_VALUE % _loc3_;
            _loc5_ = param1[_loc2_];
            param1[_loc2_] = param1[_loc4_];
            param1[_loc4_] = _loc5_;
            _loc2_++;
         }
      }
      
      protected function UpdateTigerMachineIcon(param1:Boolean) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Vector.<int> = null;
         var _loc4_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < this.ROLLICONNUM)
         {
            this.FMachineIcon[_loc2_].visible = param1;
            _loc2_++;
         }
         if(this.FActivityLuckyJoyData.RateType == null)
         {
            return;
         }
         _loc4_ = this.FActivityLuckyJoyData.RollResultSeqID - 1;
         _loc4_ = _loc4_ < 0 ? 0 : _loc4_;
         _loc3_ = this.FActivityLuckyJoyData.RateType[_loc4_];
         this.GarbleVec(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < this.ROLLICONNUM)
         {
            if(param1)
            {
               this.FMachineIcon[_loc2_].gotoAndStop(_loc3_[_loc2_]);
            }
            _loc2_++;
         }
      }
      
      protected function StartTigerMachineEffect() : void
      {
         this.FTigerMachineEffect.gotoAndPlay(1);
         this.FTigerMachineEffect.visible = true;
         FScene.mouseChildren = false;
         FScene.mouseEnabled = false;
      }
      
      protected function StopTigerMachineEffect() : void
      {
         this.FTigerMachineEffect.gotoAndStop(1);
         this.FTigerMachineEffect.visible = false;
         FScene.mouseChildren = true;
         FScene.mouseEnabled = true;
      }
      
      protected function StartRollEffect() : void
      {
         this.FTigerMachineRoll.Visible = false;
         this.FRollEffect.gotoAndPlay(1);
         this.FRollEffect.visible = true;
      }
      
      protected function StopRollEffect() : void
      {
         this.FTigerMachineRoll.Visible = true;
         this.FRollEffect.gotoAndStop(1);
         this.FRollEffect.visible = false;
      }
      
      protected function LogArrive(param1:Vector.<TLog>) : void
      {
         this.RenderLotteryRecord(param1);
      }
      
      protected function CheckIfCanExchange() : Boolean
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc2_ = int(this.FActivityLuckyJoyData.ScoreExchangeCosts.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            if(this.FActivityLuckyJoyData.ScoreExchangeCosts[_loc1_] <= this.FActivityLuckyJoyData.CurrentScore)
            {
               return true;
            }
            _loc1_++;
         }
         return false;
      }
      
      protected function RollUIRequest(param1:Object) : void
      {
         this.FRollCircleRest = this.RollCircleNum[this.FCurrentRollType];
         this.FIsRunning = true;
         this.StartTigerMachineEffect();
         this.StartRollEffect();
         this.UpdateTigerMachineIcon(false);
      }
      
      protected function ExchangeAwardReq(param1:Object, param2:int) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,param2);
      }
      
      override protected function BtnCloseOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(FOnClose != null)
         {
            FOnClose(this);
         }
         this.Reset();
      }
      
      protected function BtnRollOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         if(this.FActivityLuckyJoyData.LastFreeTime < this.FActivityLuckyJoyData.LotteryCount[this.FCurrentRollType])
         {
            _loc3_ = this.FActivityLuckyJoyData.LotteryCost[this.FCurrentRollType];
            if(SLogicsCore.Character.CreditGold < _loc3_)
            {
               SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.GirlFriend_STRING_11));
               return;
            }
            SUtilityOverLayer.UIWindowConfirmation.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_06),this.FActivityLuckyJoyData.LotteryCost[this.FCurrentRollType]);
            SUtilityOverLayer.UIWindowConfirmation.Visible = true;
            SUtilityOverLayer.UIWindowConfirmation.OnOK = this.RollUIRequest;
         }
         else
         {
            this.RollUIRequest(this);
         }
      }
      
      protected function BtnExchangeOnClick(param1:Object, param2:MouseEvent) : void
      {
         this.FProcessorHDWindowScoreExchange.Show();
         this.FLayerMask.visible = true;
      }
      
      protected function SelectBoxSingleOnClick(param1:Object, param2:int) : void
      {
         this.FCurrentRollType = param2;
         this.RenderTigerMachine();
      }
      
      protected function BtnLookOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FAwardShortcuts.currentFrame == 1)
         {
            this.FAwardShortcuts.gotoAndPlay(1);
         }
         else if(this.FAwardShortcuts.currentFrame == this.FAwardShortcuts.totalFrames)
         {
            this.FAwardShortcuts.gotoAndStop(1);
         }
      }
      
      protected function CloseExchangeWindow(param1:Object) : void
      {
         this.FLayerMask.visible = false;
      }
      
      public function set ActivityLuckyJoyData(param1:TActivityLuckyJoyData) : void
      {
         this.FActivityLuckyJoyData = param1;
         this.FProcessorHDWindowScoreExchange.ActivityLuckyJoyData = param1;
      }
      
      public function set OnLoadLog(param1:Function) : void
      {
         this.FOnLoadLog = param1;
      }
      
      override public function Show(param1:TActivityAtoms = null, param2:THDActivityBase = null, param3:TActivityOSBase = null) : void
      {
         super.Show(param1,param2,param3);
         if(this.FProcessorHDWindowScoreExchange.Visible)
         {
            this.FProcessorHDWindowScoreExchange.Update();
         }
         if(this.FOnLoadLog != null)
         {
            this.FOnLoadLog(CONST_LOG.LOGTYPE_LuckyJoy,this.LogArrive);
         }
         this.FCanExchange = this.CheckIfCanExchange();
         if(this.FCanExchange)
         {
            this.StartBtnEffect();
         }
         else
         {
            this.StopBtnEffect();
         }
      }
      
      override protected function Reset() : void
      {
         super.Reset();
         this.FCurrentRollType = 0;
         this.FSelectBoxSingle.UnselectAll();
         this.FSelectBoxSingle.SetSelectByIndex(0);
         this.FActivityLuckyJoyData.RollResultSeqID = 0;
         this.StopTigerMachineEffect();
         this.UpdateTigerMachineIcon(true);
         this.StopRollEffect();
         this.FAwardShortcuts.gotoAndStop(1);
         this.FEffectRollGlow.Stop();
      }
      
      public function AwardArrive() : void
      {
         this.StopTigerMachineEffect();
         this.UpdateTigerMachineIcon(true);
         this.RenderTigerMachine();
      }
   }
}

