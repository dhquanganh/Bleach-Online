package Processors.Game.Lobby.Activity.HDDreamComeTrue.windows
{
   import Components.Standard.TUIButton;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityString;
   import Logics.HDDreamsComeTrue.TActivityDreamsData;
   import Logics.SLogicsCore;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Processors.Game.Windows.Information.TUIWindowConfirmation;
   import Resources.Constants.CONST_DREAMS;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   
   public class TProcessorTurntableView extends TUIComponent
   {
      
      public static const DelaySendTime:int = 1500;
      
      public static const FAdd_Speed:int = 0;
      
      public static const FUniform_Speed:int = 1;
      
      public static const FSlow_Speed:int = 2;
      
      public static const FPlayAnimaState:int = 3;
      
      public static const Split_Amount:int = 8;
      
      public static const Angle:int = 360;
      
      private const FVMax:Number = 20;
      
      private const FA:Number = 2;
      
      private const Decayrate:Number = 0.1;
      
      private var FMC_Scene:Sprite;
      
      private var FRankPanel:Sprite;
      
      private var FScoreRankView:TProcessorScoreRankView;
      
      private var FOpenRankBtn:TUIButton;
      
      private var FLowScoreTF:TextField;
      
      private var FHighScoreTF:TextField;
      
      private var FLowTurntable:Sprite;
      
      private var FHighTurntable:Sprite;
      
      private var FLowGetAwardMc:MovieClip;
      
      private var FHighGetAwardMc:MovieClip;
      
      private var FLowExtractBtn:TUIButton;
      
      private var FHighExtractBtn:TUIButton;
      
      private var FLowFreeMC:MovieClip;
      
      private var FLowFreeTimeTF:TextField;
      
      private var FHighFreeMC:MovieClip;
      
      private var FHighFreeTimeTF:TextField;
      
      private var FLowSelectCloseAnima:MovieClip;
      
      private var FHighSelectCloseAnima:MovieClip;
      
      private var FLowSelectTenExtract:MovieClip;
      
      private var FHigtSelectTenExtract:MovieClip;
      
      private var FIsLowAnima:Boolean;
      
      private var FIsHighAnima:Boolean;
      
      private var FIsLowMoreExtract:Boolean;
      
      private var FIsHighMoreExtract:Boolean;
      
      protected var WindowUIPopUp:TUIWindowConfirmation;
      
      private var FDelayTime:uint;
      
      private var FV:Number;
      
      private var FAng:Number;
      
      private var FJiasu:Boolean;
      
      private var FTargetA:Number;
      
      private var FTarA:Number;
      
      private var FCurTurntableState:int = -1;
      
      private var FCurTurntableMc:Sprite;
      
      private var FCurExtractMc:MovieClip;
      
      private var FCurPlayAnima:MovieClip;
      
      private var FIsJoinAddSpeed:Boolean;
      
      private var FRounds:int;
      
      private var FLowEffectMc:MovieClip;
      
      private var FHighEffectMc:MovieClip;
      
      private var FLowStaticEffect:MovieClip;
      
      private var FHighStaticEffect:MovieClip;
      
      protected var FSendData:Function;
      
      protected var FData:TActivityDreamsData;
      
      public function TProcessorTurntableView(param1:TUIComponent, param2:Sprite)
      {
         super(param1);
         this.FMC_Scene = param2;
         this.InitWindow();
      }
      
      protected function InitWindow() : void
      {
         this.FRankPanel = this.FMC_Scene["MC_RankView"];
         this.FScoreRankView = new TProcessorScoreRankView(this,this.FRankPanel);
         this.FOpenRankBtn = new TUIButton();
         this.FOpenRankBtn.OnClick = this.OnOpenRankViewHandler;
         this.FOpenRankBtn.Substrate = this.FMC_Scene["Btn_OpenView"];
         this.FLowScoreTF = this.FMC_Scene["TF_LowScore"];
         this.FHighScoreTF = this.FMC_Scene["TF_HighScore"];
         this.FLowTurntable = this.FMC_Scene["MC_LowTurnTable"]["MC_Rotation"];
         this.FHighTurntable = this.FMC_Scene["MC_HighTurnTable"]["MC_Rotation"];
         this.FLowGetAwardMc = this.FMC_Scene["MC_LowTurnTable"]["MC_GetAward"];
         this.FHighGetAwardMc = this.FMC_Scene["MC_HighTurnTable"]["MC_GetAward"];
         this.FLowEffectMc = this.FMC_Scene["MC_LowTurnTable"]["MC_Effect"];
         this.FLowEffectMc.visible = false;
         this.FHighEffectMc = this.FMC_Scene["MC_HighTurnTable"]["MC_Effect"];
         this.FHighEffectMc.visible = false;
         this.FLowStaticEffect = this.FMC_Scene["MC_LowTurnTable"]["MC_Static_Effect"];
         this.FLowStaticEffect.play();
         this.FHighStaticEffect = this.FMC_Scene["MC_HighTurnTable"]["MC_Static_Effect"];
         this.FHighStaticEffect.play();
         this.FLowExtractBtn = new TUIButton();
         this.FLowExtractBtn.Substrate = this.FMC_Scene["MC_LowTurnTable"]["MC_Extract"];
         this.FLowExtractBtn.OnClick = this.OnLowTurntableClick;
         this.FHighExtractBtn = new TUIButton();
         this.FHighExtractBtn.Substrate = this.FMC_Scene["MC_HighTurnTable"]["MC_Extract"];
         this.FHighExtractBtn.OnClick = this.OnHighTurntableClick;
         this.FLowFreeMC = this.FMC_Scene["MC_LowFreeOrGold"];
         this.FLowFreeMC.gotoAndStop(1);
         this.FHighFreeMC = this.FMC_Scene["MC_HighFreeOrGold"];
         this.FHighFreeMC.gotoAndStop(1);
         this.FLowFreeTimeTF = this.FLowFreeMC["TF_Value"];
         this.FHighFreeTimeTF = this.FHighFreeMC["TF_Value"];
         this.FLowSelectCloseAnima = this.FMC_Scene["MC_LowCloseAnima"]["MC_SelectBox"];
         this.FIsLowAnima = this.SetMCState(this.FLowSelectCloseAnima);
         this.FLowSelectCloseAnima.addEventListener(MouseEvent.CLICK,this.OnSelectMCState);
         this.FHighSelectCloseAnima = this.FMC_Scene["MC_HighCloseAnima"]["MC_SelectBox"];
         this.FIsHighAnima = this.SetMCState(this.FHighSelectCloseAnima);
         this.FHighSelectCloseAnima.addEventListener(MouseEvent.CLICK,this.OnSelectMCState);
         this.FLowSelectTenExtract = this.FMC_Scene["MC_LowExtractTen"]["MC_SelectBox"];
         this.FIsLowMoreExtract = this.SetMCState(this.FLowSelectTenExtract);
         this.FLowSelectTenExtract.addEventListener(MouseEvent.CLICK,this.OnSelectMCState);
         this.FHigtSelectTenExtract = this.FMC_Scene["MC_HighExtractTen"]["MC_SelectBox"];
         this.FIsHighMoreExtract = this.SetMCState(this.FHigtSelectTenExtract);
         this.FHigtSelectTenExtract.addEventListener(MouseEvent.CLICK,this.OnSelectMCState);
         this.WindowUIPopUp = SUtilityOverLayer.UIWindowConfirmation;
      }
      
      protected function SendServiceData(param1:int, param2:int, param3:Vector.<int>) : void
      {
         if(this.FSendData != null)
         {
            this.FSendData(param1,param2,param3);
         }
      }
      
      protected function RefreshTurntableInfo() : void
      {
         this.FLowScoreTF.text = this.FData.ActivityConfig.LowScore.toString();
         this.FHighScoreTF.text = this.FData.ActivityConfig.HighScore.toString();
         if(this.FData.LowFreeTime <= 0)
         {
            this.FLowFreeMC.gotoAndStop(2);
            this.FLowFreeTimeTF = this.FLowFreeMC["TF_Value"];
            this.FLowFreeTimeTF.text = this.FData.ActivityConfig.LowGoldCost.toString();
         }
         else
         {
            this.FLowFreeMC.gotoAndStop(1);
            this.FLowFreeTimeTF = this.FLowFreeMC["TF_Value"];
            this.FLowFreeTimeTF.text = this.FData.LowFreeTime.toString();
         }
         if(this.FData.HighFreeTime <= 0)
         {
            this.FHighFreeMC.gotoAndStop(2);
            this.FHighFreeTimeTF = this.FHighFreeMC["TF_Value"];
            this.FHighFreeTimeTF.text = this.FData.ActivityConfig.HighGoldCost.toString();
         }
         else
         {
            this.FHighFreeMC.gotoAndStop(1);
            this.FHighFreeTimeTF = this.FHighFreeMC["TF_Value"];
            this.FHighFreeTimeTF.text = this.FData.HighFreeTime.toString();
         }
      }
      
      private function UpdateUI() : void
      {
         this.RefreshTurntableInfo();
      }
      
      protected function OnOpenRankViewHandler(param1:Object, param2:MouseEvent) : void
      {
         this.FScoreRankView.Data = this.FData;
         this.FScoreRankView.Show();
      }
      
      protected function OnLowTurntableClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         _loc3_ = this.FData.ActivityConfig.LowExtractIndex;
         if(this.FCurTurntableState != -1)
         {
            return;
         }
         _loc7_ = this.FData.LowFreeTime * this.FData.ActivityConfig.LowGoldCost;
         _loc4_ = SLogicsCore.Character.CreditGold + _loc7_;
         if(this.FIsLowMoreExtract)
         {
            _loc5_ = this.FData.ActivityConfig.LowGoldCost * CONST_DREAMS.MaxExtractAmount;
            _loc8_ = CONST_DREAMS.MaxExtractAmount;
         }
         else
         {
            _loc5_ = this.FData.ActivityConfig.LowGoldCost;
            _loc8_ = 1;
         }
         _loc6_ = _loc5_ - _loc7_;
         if(_loc4_ < _loc5_)
         {
            SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.NOTENOUGH_Gold));
            return;
         }
         if(_loc6_ <= 0)
         {
            this.PlayerAnima(CONST_DREAMS.ExtractLowType,!this.FIsLowAnima,_loc3_,_loc8_);
         }
         else
         {
            this.WindowUIPopUp.visible = true;
            this.WindowUIPopUp.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_06),_loc6_);
            this.WindowUIPopUp.OnOK = this.WindowLowOk;
            this.WindowUIPopUp.Tag = _loc3_;
         }
      }
      
      private function WindowLowOk(param1:Object) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(this.FIsLowMoreExtract)
         {
            _loc3_ = CONST_DREAMS.MaxExtractAmount;
         }
         else
         {
            _loc3_ = 1;
         }
         _loc2_ = this.WindowUIPopUp.Tag;
         this.PlayerAnima(CONST_DREAMS.ExtractLowType,!this.FIsLowAnima,_loc2_,_loc3_);
      }
      
      private function WindowHighOk(param1:Object) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(this.FIsHighMoreExtract)
         {
            _loc3_ = CONST_DREAMS.MaxExtractAmount;
         }
         else
         {
            _loc3_ = 1;
         }
         _loc2_ = this.WindowUIPopUp.Tag;
         this.PlayerAnima(CONST_DREAMS.ExtractHighType,!this.FIsHighAnima,_loc2_,_loc3_);
      }
      
      protected function PlayerAnima(param1:int, param2:Boolean, param3:int, param4:int) : void
      {
         var TurntableType:int = param1;
         var isPlayAnima:Boolean = param2;
         var SendIndex:int = param3;
         var ExtractAmount:int = param4;
         if(TurntableType == CONST_DREAMS.ExtractLowType)
         {
            this.FAng = this.FLowTurntable.rotation;
            this.FCurTurntableMc = this.FLowTurntable;
            this.FCurExtractMc = this.FLowGetAwardMc;
            this.FCurPlayAnima = this.FLowEffectMc;
         }
         else
         {
            this.FAng = this.FHighTurntable.rotation;
            this.FCurTurntableMc = this.FHighTurntable;
            this.FCurExtractMc = this.FHighGetAwardMc;
            this.FCurPlayAnima = this.FHighEffectMc;
         }
         if(ExtractAmount > 1)
         {
            isPlayAnima = false;
         }
         if(isPlayAnima)
         {
            this.FDelayTime = setTimeout(function DelaySendFun():void
            {
               SendServiceData(SendIndex,0,Vector.<int>([ExtractAmount]));
               clearTimeout(FDelayTime);
            },DelaySendTime);
            this.FCurTurntableState = FPlayAnimaState;
            if(this.FCurPlayAnima != null)
            {
               this.FCurPlayAnima.visible = true;
               this.FCurPlayAnima.gotoAndPlay(1);
            }
            return;
         }
         this.FCurPlayAnima = null;
         this.SendServiceData(SendIndex,0,Vector.<int>([ExtractAmount]));
      }
      
      protected function OnHighTurntableClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         _loc3_ = this.FData.ActivityConfig.HighExtractIndex;
         if(this.FCurTurntableState != -1)
         {
            return;
         }
         _loc7_ = this.FData.HighFreeTime * this.FData.ActivityConfig.HighGoldCost;
         _loc4_ = SLogicsCore.Character.CreditGold + _loc7_;
         if(this.FIsHighMoreExtract)
         {
            _loc5_ = this.FData.ActivityConfig.HighGoldCost * CONST_DREAMS.MaxExtractAmount;
            _loc8_ = CONST_DREAMS.MaxExtractAmount;
         }
         else
         {
            _loc5_ = this.FData.ActivityConfig.HighGoldCost;
            _loc8_ = 1;
         }
         _loc6_ = _loc5_ - _loc7_;
         if(_loc4_ < _loc5_)
         {
            SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.NOTENOUGH_Gold));
            return;
         }
         if(_loc6_ <= 0)
         {
            this.PlayerAnima(CONST_DREAMS.ExtractHighType,!this.FIsHighAnima,_loc3_,_loc8_);
         }
         else
         {
            this.WindowUIPopUp.visible = true;
            this.WindowUIPopUp.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_06),_loc6_);
            this.WindowUIPopUp.OnOK = this.WindowHighOk;
            this.WindowUIPopUp.Tag = _loc3_;
         }
      }
      
      private function OnSelectMCState(param1:MouseEvent) : void
      {
         switch(param1.currentTarget)
         {
            case this.FLowSelectCloseAnima:
               this.FIsLowAnima = this.SetMCState(this.FLowSelectCloseAnima);
               break;
            case this.FHighSelectCloseAnima:
               this.FIsHighAnima = this.SetMCState(this.FHighSelectCloseAnima);
               break;
            case this.FLowSelectTenExtract:
               this.FIsLowMoreExtract = this.SetMCState(this.FLowSelectTenExtract);
               break;
            case this.FHigtSelectTenExtract:
               this.FIsHighMoreExtract = this.SetMCState(this.FHigtSelectTenExtract);
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
      
      public function set SendData(param1:Function) : void
      {
         this.FSendData = param1;
      }
      
      public function set Data(param1:TActivityDreamsData) : void
      {
         this.FData = param1;
      }
      
      public function ShowView() : void
      {
         this.UpdateUI();
         if(this.FRankPanel.visible)
         {
            this.FScoreRankView.Data = this.FData;
            this.FScoreRankView.Show();
         }
      }
      
      public function LogicsPerform_EnterFrame() : void
      {
         var _loc1_:Number = NaN;
         switch(this.FCurTurntableState)
         {
            case FAdd_Speed:
               this.FV += this.FA;
               if(this.FV >= this.FVMax)
               {
                  this.FV = this.FVMax;
                  this.FCurTurntableState = FUniform_Speed;
               }
               this.FIsJoinAddSpeed = true;
               this.FAng += this.FV;
               this.FCurTurntableMc.rotation = this.FAng;
               this.FRounds = Math.ceil(this.FAng / Angle) + 1;
               break;
            case FUniform_Speed:
               this.FAng += this.FV;
               this.FCurTurntableMc.rotation = this.FAng;
               this.FRounds = Math.ceil(this.FAng / Angle) + 1;
               break;
            case FSlow_Speed:
               _loc1_ = (this.FTarA - this.FAng) * this.Decayrate;
               this.FV = _loc1_ > this.FVMax ? this.FVMax : _loc1_;
               if(this.FV < 0.1)
               {
                  this.FCurTurntableState = -1;
                  this.FIsJoinAddSpeed = false;
               }
               this.FAng += this.FV;
               this.FCurTurntableMc.rotation = this.FAng;
               this.FRounds = Math.ceil(this.FAng / Angle) + 1;
         }
         if(this.FCurPlayAnima != null)
         {
            if(this.FCurPlayAnima.currentFrame >= this.FCurPlayAnima.totalFrames)
            {
               this.FCurPlayAnima.gotoAndStop(1);
               this.FCurPlayAnima.visible = false;
               this.FCurTurntableState = -1;
            }
         }
         this.FScoreRankView.LogicsPerform_EnterFrame();
      }
      
      public function GetTurntableAward(param1:int) : void
      {
         this.FTargetA = param1 * Angle / Split_Amount;
         this.FCurExtractMc.gotoAndStop(param1 + 1);
         if(this.FCurPlayAnima == null)
         {
            this.FCurTurntableState = -1;
         }
         this.FCurTurntableMc.rotation = this.FTargetA;
      }
   }
}

