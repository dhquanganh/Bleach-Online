package Processors.Game.Lobby.Activity.HDTimeLimitTurntable
{
   import Components.ScrollBar.TScrollBar;
   import Components.Standard.*;
   import Externals.SExternalCore;
   import Foundation.Resources.*;
   import Foundation.Resources.Bins.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.Agent.SParametersCore;
   import Logics.Characters.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.DatebaseVO.VO.Json.TRewards;
   import Logics.HDActivityMode.*;
   import Logics.HDActivityOS.*;
   import Logics.HDSwiftChange.*;
   import Logics.HDTimeLimitTurntable.TActivityGoldTurntableData;
   import Logics.Log.TLog;
   import Logics.Map.*;
   import Processors.Game.Lobby.Activity.HDActivity.*;
   import Processors.Game.Lobby.Common.Hero.*;
   import Processors.Game.Lobby.Common.Map.SceneSprite.*;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.Common.*;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Processors.Game.Utilities.HyperLink.*;
   import Processors.Game.Utilities.OverLayer.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   import flash.utils.setTimeout;
   import ghostcat.util.data.Json;
   
   public class TprocessorHDWindowTimeLimitView extends TProcessorHDSingleWindowBase
   {
      
      public static const Split_Amount:int = 6;
      
      public static const Angle:int = 360;
      
      public static const ExtractIng:int = -1;
      
      public static const DelaySendTime:int = 1500;
      
      private var FLowDescTF:TextField;
      
      private var FLowMaxExtractTF:TextField;
      
      private var FHighDescTF:TextField;
      
      private var FHighMaxExtractTF:TextField;
      
      private var FRechargeGoldTF:TextField;
      
      private var FRechargeBtn:TUIButton;
      
      private var FLowTurntableMc:Sprite;
      
      private var FLowExtractBtn:TUIButton;
      
      private var FLowExtractInfoTF:TextField;
      
      private var FLowCloseAnima:MovieClip;
      
      private var FLowCircleMC:Sprite;
      
      private var FLowAnimaMc:MovieClip;
      
      private var FhighTurntableMc:Sprite;
      
      private var FHighExtractBtn:TUIButton;
      
      private var FHighExtractInfoTF:TextField;
      
      private var FHighCloseAnima:MovieClip;
      
      private var FHighCircleMC:Sprite;
      
      private var FHighAnimaMc:MovieClip;
      
      protected var FScrollBar:TScrollBar;
      
      private var FIsLowStopAnima:Boolean;
      
      private var FIsHighStopAnima:Boolean;
      
      private var FCurPlayAnima:MovieClip;
      
      private var FTargetA:Number;
      
      private var FCurTurntableMc:Sprite;
      
      private var FCurTurntableState:int;
      
      protected var FActivityData:TActivityGoldTurntableData;
      
      protected var FOnLoadLog:Function;
      
      public function TprocessorHDWindowTimeLimitView(param1:TUIComponent)
      {
         super(param1);
         FSceneResourceName = "Main_GoldTurntable";
         FActivityID = CONST_ACTIVITY_MODE.Activity_TimeLimitTurntable;
         this.FCurTurntableState = 0;
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
         this.FLowDescTF = FScene["TF_LowDesc"];
         this.FLowMaxExtractTF = FScene["TF_LowMaxExtract"];
         this.FHighDescTF = FScene["TF_HighDesc"];
         this.FHighMaxExtractTF = FScene["TF_HighMaxExtract"];
         this.FRechargeGoldTF = FScene["TF_RechargeGold"];
         this.FRechargeBtn = new TUIButton();
         this.FRechargeBtn.OnClick = this.OnRightNowRecharge;
         this.FRechargeBtn.Substrate = FScene["Btn_Recharge"];
         this.FLowTurntableMc = FScene["MC_LowTurntable"];
         this.FLowExtractBtn = new TUIButton();
         this.FLowExtractBtn.Substrate = this.FLowTurntableMc["Btn_Extract"];
         this.FLowExtractBtn.OnClick = this.OnLowExtract;
         this.FLowExtractInfoTF = this.FLowTurntableMc["TF_Info"];
         this.FLowCircleMC = this.FLowTurntableMc["MC_Circle"];
         this.FLowCloseAnima = this.FLowTurntableMc["MC_CloseAnima"]["MC_SelectBox"];
         this.FLowCloseAnima.gotoAndStop(2);
         this.FLowCloseAnima.addEventListener(MouseEvent.CLICK,this.OnSelectLowAnimaState);
         this.FLowAnimaMc = this.FLowTurntableMc["MC_ExtractAnima"];
         this.FLowAnimaMc.visible = false;
         this.FLowAnimaMc.gotoAndStop(1);
         this.FhighTurntableMc = FScene["MC_HighTurntable"];
         this.FHighExtractBtn = new TUIButton();
         this.FHighExtractBtn.Substrate = this.FhighTurntableMc["Btn_Extract"];
         this.FHighExtractBtn.OnClick = this.OnHighExtract;
         this.FHighExtractInfoTF = this.FhighTurntableMc["TF_Info"];
         this.FHighCircleMC = this.FhighTurntableMc["MC_Circle"];
         this.FHighCloseAnima = this.FhighTurntableMc["MC_CloseAnima"]["MC_SelectBox"];
         this.FHighCloseAnima.gotoAndStop(2);
         this.FHighCloseAnima.addEventListener(MouseEvent.CLICK,this.OnSelectHighAnimaState);
         this.FHighAnimaMc = this.FhighTurntableMc["MC_ExtractAnima"];
         this.FHighAnimaMc.visible = false;
         this.FHighAnimaMc.gotoAndStop(1);
         this.FScrollBar = new TScrollBar(FScene["MC_Record"]["ScroolBarUI"],230,false);
         this.FScrollBar.Visible = false;
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(this.Visible)
         {
            if(this.FCurPlayAnima != null)
            {
               if(this.FCurPlayAnima.currentFrame >= this.FCurPlayAnima.totalFrames)
               {
                  this.FCurPlayAnima.gotoAndStop(1);
                  this.FCurPlayAnima.visible = false;
                  this.FCurTurntableState = 0;
               }
            }
         }
      }
      
      private function SetMCState(param1:MovieClip) : Boolean
      {
         var _loc2_:int = 0;
         var _loc3_:Boolean = false;
         _loc2_ = param1.currentFrame;
         if(_loc2_ == 1)
         {
            param1.gotoAndStop(2);
            _loc3_ = false;
         }
         else
         {
            param1.gotoAndStop(1);
            _loc3_ = true;
         }
         return _loc3_;
      }
      
      protected function LogArrive(param1:Vector.<TLog>) : void
      {
         this.RenderExtractArea(param1);
      }
      
      protected function RenderExtractArea(param1:Vector.<TLog>) : void
      {
         var _loc2_:* = 0;
         var _loc3_:int = 0;
         var _loc4_:TRewards = null;
         var _loc5_:Sprite = null;
         var _loc6_:TLog = null;
         var _loc7_:Object = null;
         var _loc8_:Vector.<Sprite> = null;
         var _loc9_:String = null;
         this.FScrollBar.Clear();
         _loc3_ = int(param1.length);
         _loc8_ = new Vector.<Sprite>();
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc6_ = param1[_loc2_];
            _loc7_ = Json.decode(_loc6_.Data);
            _loc5_ = TUtilityReflection.CreateDisplayObjectInstance("TurntableExtractRecordItem") as Sprite;
            _loc5_["TF"].text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_68),_loc6_.Name,SToolReward.GetNameByTypeCode(_loc7_.type,_loc7_.code),_loc7_.amount);
            _loc8_.push(_loc5_);
            _loc2_++;
         }
         _loc2_ = int(_loc3_ - 1);
         while(_loc2_ >= 0)
         {
            this.FScrollBar.AddItem(_loc8_[_loc2_]);
            _loc2_--;
         }
         this.FScrollBar.ScrollToUp();
         this.FScrollBar.Visible = true;
      }
      
      public function RefreshBaseInfo() : void
      {
         var _loc1_:String = null;
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         if(this.FOnLoadLog != null)
         {
            this.FOnLoadLog(CONST_LOG.LOGTYPE_GoldTurntable,this.LogArrive);
         }
         _loc1_ = TUtilityString.Format(this.FActivityData.ActivityConfig.LowDesc,this.FActivityData.ActivityConfig.LowGold);
         _loc2_ = TUtilityString.Format(this.FActivityData.ActivityConfig.LowMaxDesc,this.FActivityData.ActivityConfig.LowMaxTime);
         _loc3_ = TUtilityString.Format(this.FActivityData.ActivityConfig.LowDesc,this.FActivityData.ActivityConfig.HighGold);
         _loc4_ = TUtilityString.Format(this.FActivityData.ActivityConfig.LowMaxDesc,this.FActivityData.ActivityConfig.HighMaxTime);
         this.FRechargeGoldTF.text = this.FActivityData.RechargeGoldValue.toString();
         this.FLowExtractInfoTF.text = this.FActivityData.LowExtractValue + "/" + this.FActivityData.ActivityConfig.LowMaxTime;
         this.FHighExtractInfoTF.text = this.FActivityData.HighExtractValue + "/" + this.FActivityData.ActivityConfig.HighMaxTime;
         this.FLowDescTF.text = _loc1_;
         this.FLowMaxExtractTF.text = _loc2_;
         this.FHighDescTF.text = _loc3_;
         this.FHighMaxExtractTF.text = _loc4_;
         _loc5_ = Math.floor(this.FActivityData.RechargeGoldValue / this.FActivityData.ActivityConfig.HighGold);
         _loc5_ = _loc5_ >= this.FActivityData.ActivityConfig.HighMaxTime ? this.FActivityData.ActivityConfig.HighMaxTime : _loc5_;
         if(this.FActivityData.HighExtractValue >= this.FActivityData.ActivityConfig.HighMaxTime || _loc5_ <= this.FActivityData.HighExtractValue)
         {
            this.FHighExtractBtn.Enabled = false;
         }
         else
         {
            this.FHighExtractBtn.Enabled = true;
         }
         _loc6_ = _loc6_ = Math.floor(this.FActivityData.RechargeGoldValue / this.FActivityData.ActivityConfig.LowGold);
         _loc6_ = _loc6_ >= this.FActivityData.ActivityConfig.LowMaxTime ? this.FActivityData.ActivityConfig.LowMaxTime : _loc6_;
         if(this.FActivityData.LowExtractValue >= this.FActivityData.ActivityConfig.LowMaxTime || _loc6_ <= this.FActivityData.LowExtractValue)
         {
            this.FLowExtractBtn.Enabled = false;
         }
         else
         {
            this.FLowExtractBtn.Enabled = true;
         }
      }
      
      override protected function BtnCloseOnClick(param1:Object, param2:MouseEvent) : void
      {
         ProcessorWindowClose();
         this.FCurTurntableState = 0;
      }
      
      protected function OnRightNowRecharge(param1:Object, param2:MouseEvent) : void
      {
         SExternalCore.NavigateToRechargeUrl(SParametersCore.PayUrl);
      }
      
      protected function OnSelectLowAnimaState(param1:MouseEvent) : void
      {
         this.FIsLowStopAnima = this.SetMCState(this.FLowCloseAnima);
      }
      
      protected function OnSelectHighAnimaState(param1:MouseEvent) : void
      {
         this.FIsHighStopAnima = this.SetMCState(this.FHighCloseAnima);
      }
      
      protected function OnLowExtract(param1:Object, param2:MouseEvent) : void
      {
         var Index:int = 0;
         var Sender:Object = param1;
         var E:MouseEvent = param2;
         if(this.FCurTurntableState == ExtractIng)
         {
            return;
         }
         Index = this.FActivityData.ActivityConfig.LowExtractIndex;
         this.FCurTurntableMc = this.FLowCircleMC;
         this.FCurTurntableState = ExtractIng;
         if(!this.FIsLowStopAnima)
         {
            this.FCurPlayAnima = this.FLowAnimaMc;
            this.FLowAnimaMc.visible = true;
            this.FLowAnimaMc.play();
            setTimeout(function DelaySendMsg():void
            {
               Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,Index);
            },DelaySendTime);
         }
         else
         {
            this.FCurPlayAnima = null;
            Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,Index);
         }
      }
      
      protected function OnHighExtract(param1:Object, param2:MouseEvent) : void
      {
         var Index:int = 0;
         var Sender:Object = param1;
         var E:MouseEvent = param2;
         if(this.FCurTurntableState == ExtractIng)
         {
            return;
         }
         Index = this.FActivityData.ActivityConfig.HighExtractIndex;
         this.FCurTurntableMc = this.FHighCircleMC;
         this.FCurTurntableState = ExtractIng;
         if(!this.FIsHighStopAnima)
         {
            this.FCurPlayAnima = this.FHighAnimaMc;
            this.FHighAnimaMc.visible = true;
            this.FHighAnimaMc.play();
            setTimeout(function DelaySendMsg():void
            {
               Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,Index);
            },DelaySendTime);
         }
         else
         {
            this.FCurPlayAnima = null;
            Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,Index);
         }
      }
      
      public function set ActivityData(param1:TActivityGoldTurntableData) : void
      {
         this.FActivityData = param1;
      }
      
      public function set OnLoadLog(param1:Function) : void
      {
         this.FOnLoadLog = param1;
      }
      
      override public function Show(param1:TActivityAtoms = null, param2:THDActivityBase = null, param3:TActivityOSBase = null) : void
      {
         super.Show(param1,param2,param3);
         this.RefreshBaseInfo();
      }
      
      public function GetTurntableAwardPos(param1:int) : void
      {
         this.FTargetA = (Split_Amount - param1) * Angle / Split_Amount;
         if(this.FCurTurntableMc != null)
         {
            this.FCurTurntableMc.rotation = this.FTargetA;
         }
         if(this.FCurPlayAnima == null)
         {
            this.FCurTurntableState = 0;
         }
      }
   }
}

