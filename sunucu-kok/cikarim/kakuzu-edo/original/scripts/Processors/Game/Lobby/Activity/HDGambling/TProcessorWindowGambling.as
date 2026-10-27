package Processors.Game.Lobby.Activity.HDGambling
{
   import Components.SelectBox.*;
   import Components.Standard.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.HDActivityGambling.*;
   import Logics.HDActivityOS.*;
   import Logics.Inventories.*;
   import Processors.Game.Lobby.Activity.HDActivity.*;
   import Processors.Game.Lobby.Utilities.*;
   import Processors.Game.Utilities.OverLayer.*;
   import Processors.Game.Windows.Information.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class TProcessorWindowGambling extends TProcessorHDSingleWindowBase
   {
      
      protected static const COUNT_MC_Dice:uint = 3;
      
      protected static const COUNT_TF_Rank:uint = 10;
      
      protected static const COUNT_MC_Wins:uint = 10;
      
      protected static const Activity_CanNotReceive:int = CONST_ACTIVITY_MODE.Activity_CanNotReceive;
      
      protected static const Activity_AlreadyReceive:int = CONST_ACTIVITY_MODE.Activity_AlreadyReceive;
      
      protected static const Activity_CanReceive:int = CONST_ACTIVITY_MODE.Activity_CanReceive;
      
      protected static const FRAME_MC_DiceContainer_Start:uint = 1;
      
      protected static const FRAME_MC_DiceContainer_Hide:uint = 30;
      
      protected static const FRAME_MC_DiceContainer_Show:uint = 48;
      
      protected static const STATUS_DiceContainer_Start:uint = 0;
      
      protected static const STATUS_DiceContainer_Show:uint = 1;
      
      protected static const STATUS_DiceContainer_Hide:uint = 2;
      
      protected static const Dice_TotalPoints_MustWin:Vector.<uint> = Vector.<uint>([3,18]);
      
      protected static const BUTTONTYPE_Gambling_Start:uint = CONST_ACTIVITY_MODE.BUTTONTYPE_Gambling_Start;
      
      protected static const BUTTONTYPE_Gambling_Small:uint = CONST_ACTIVITY_MODE.BUTTONTYPE_Gambling_Small;
      
      protected static const BUTTONTYPE_Gambling_Big:uint = CONST_ACTIVITY_MODE.BUTTONTYPE_Gambling_Big;
      
      protected static const STAGE_Gambling_None:int = CONST_ACTIVITY_MODE.STAGE_Gambling_None;
      
      protected static const STAGE_Gambling_Start:int = CONST_ACTIVITY_MODE.STAGE_Gambling_Start;
      
      protected static const STAGE_Gambling_IsWin:int = CONST_ACTIVITY_MODE.STAGE_Gambling_IsWin;
      
      protected static const STATUS_Gambling_Failure:int = CONST_ACTIVITY_MODE.STATUS_Gambling_Failure;
      
      protected static const STATUS_Gambling_None:int = CONST_ACTIVITY_MODE.STATUS_Gambling_None;
      
      protected static const STATUS_Gambling_Win:int = CONST_ACTIVITY_MODE.STATUS_Gambling_Win;
      
      protected static const STATUS_SelectBox_No:uint = 0;
      
      protected static const STATUS_SelectBox_Yes:uint = 1;
      
      protected var FTF_Title:TextField;
      
      protected var FBtn_Start:TUIButton;
      
      protected var FBtn_Big:TUIButton;
      
      protected var FBtn_Small:TUIButton;
      
      protected var FSelectBox_StartCount:TSelectBoxSingle;
      
      protected var FSelectBox_FailoverCount:TSelectBoxSingle;
      
      protected var FSelectBox_StartPrompt:TextField;
      
      protected var FSelectBox_FailoverPrompt:TextField;
      
      protected var FTF_StartCount:TextField;
      
      protected var FTF_FailoverCount:TextField;
      
      protected var FTF_FreeCount:TextField;
      
      protected var FMC_OppDices:Vector.<MovieClip>;
      
      protected var FMC_OwnDices:Vector.<MovieClip>;
      
      protected var FMC_OppDiceContainer:MovieClip;
      
      protected var FMC_OwnDiceContainer:MovieClip;
      
      protected var FBtn_OK:TUIButton;
      
      protected var FMC_Bar:MovieClip;
      
      protected var FMC_WinVect:Vector.<Sprite>;
      
      protected var FTF_WinCountVect:Vector.<TextField>;
      
      protected var FTF_WinAwardVect:Vector.<TextField>;
      
      protected var FBtn_Rank:Sprite;
      
      protected var FBtn_RankOpen:TUIButton;
      
      protected var FBtn_RankClose:TUIButton;
      
      protected var FTF_RankVect:Vector.<TextField>;
      
      protected var FMC_ActivityPrompt:Sprite;
      
      protected var FTF_CurWins:TextField;
      
      protected var FDataGambling:TActivityGambling;
      
      protected var FHDGambling:THDGambling;
      
      protected var FStatus_SelectBoxStart:int;
      
      protected var FStatus_SelectBoxFailover:int;
      
      protected var FCurrentButtonData:TActivityDataButton;
      
      protected var FOppDicePoints:Vector.<uint>;
      
      protected var FOwnDicePoints:Vector.<uint>;
      
      protected var FIsInitWindow:Boolean;
      
      protected var FIsOppPlayMC:Boolean;
      
      protected var FIsOwnPlayMC:Boolean;
      
      protected var FIsGetAward:Boolean;
      
      protected var FUIWindowUseCount:TUIWindowConfirmation;
      
      public function TProcessorWindowGambling(param1:TUIComponent)
      {
         super(param1);
         FSceneResourceName = CONST_ACTIVITY.RESOURCE_ClassName_ActivitySingleGambling;
         this.FOppDicePoints = new Vector.<uint>(COUNT_MC_Dice);
         this.FOwnDicePoints = new Vector.<uint>(COUNT_MC_Dice);
         this.FStatus_SelectBoxStart = STATUS_SelectBox_No;
         this.FStatus_SelectBoxFailover = STATUS_SelectBox_No;
         this.FIsInitWindow = false;
         this.FIsOppPlayMC = false;
         this.FIsOwnPlayMC = false;
         this.FIsGetAward = false;
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(!this.FIsInitWindow)
         {
            return;
         }
         if(this.FIsOppPlayMC && this.FMC_OppDiceContainer.currentFrame == this.FMC_OppDiceContainer.totalFrames)
         {
            this.FIsOppPlayMC = false;
            this.ProcessorPlayOppDiceContainer(STATUS_DiceContainer_Start);
            this.FBtn_Big.Visible = true;
            this.FBtn_Small.Visible = true;
         }
         if(this.FIsOwnPlayMC && this.FMC_OwnDiceContainer.currentFrame == this.FMC_OwnDiceContainer.totalFrames - 4)
         {
            this.ProcessorShowOwnDice();
         }
         if(this.FIsOwnPlayMC && this.FMC_OwnDiceContainer.currentFrame == this.FMC_OwnDiceContainer.totalFrames)
         {
            this.FIsOwnPlayMC = false;
            this.ProcessorPlayOwnDiceContainer(STATUS_DiceContainer_Start);
            if(this.FDataGambling.DataIsWin == STATUS_Gambling_Win)
            {
               EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_43));
            }
            else
            {
               EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_44));
               this.ProcessorHandleFailover();
            }
         }
      }
      
      override public function InitWindow(param1:Sprite = null) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TextField = null;
         var _loc5_:MovieClip = null;
         var _loc6_:Sprite = null;
         super.InitWindow(param1);
         this.FTF_Title = FScene[CONST_ACTIVITY.RESOURCE_Link_TF_Title];
         this.FTF_Title.mouseEnabled = false;
         this.FBtn_Start = new TUIButton();
         this.FBtn_Start.Substrate = FScene[CONST_ACTIVITY.RESOURCE_Link_Btn_Start];
         this.FBtn_Start.OnClick = this.BtnStartOnClick;
         this.FBtn_Start.Visible = false;
         this.FBtn_Big = new TUIButton();
         this.FBtn_Big.Substrate = FScene[CONST_ACTIVITY.RESOURCE_Link_Btn_Big];
         this.FBtn_Big.OnClick = this.BtnBigOnClick;
         this.FBtn_Big.Visible = false;
         this.FBtn_Small = new TUIButton();
         this.FBtn_Small.Substrate = FScene[CONST_ACTIVITY.RESOURCE_Link_Btn_Small];
         this.FBtn_Small.OnClick = this.BtnSmallOnClick;
         this.FBtn_Small.Visible = false;
         this.FMC_ActivityPrompt = FScene[CONST_ACTIVITY.RESOURCE_Link_MC_ActivityPrompt];
         this.FMC_ActivityPrompt.addEventListener(MouseEvent.MOUSE_MOVE,this.MCActivityPromptOver);
         this.FMC_ActivityPrompt.addEventListener(MouseEvent.MOUSE_OUT,this.MCActivityPromptOut);
         this.FTF_FreeCount = FScene[CONST_ACTIVITY.RESOURCE_Link_TF_StartCount];
         this.FTF_FreeCount.mouseEnabled = false;
         _loc6_ = FScene[CONST_ACTIVITY.RESOURCE_Link_MC_ARoll];
         this.FMC_OppDiceContainer = _loc6_[CONST_ACTIVITY.RESOURCE_Link_MC_OppoDiceContainer];
         this.FMC_OppDiceContainer.stop();
         this.FMC_OwnDiceContainer = _loc6_[CONST_ACTIVITY.RESOURCE_Link_MC_MyDiceContainer];
         this.FMC_OwnDiceContainer.stop();
         _loc3_ = int(COUNT_MC_Dice);
         this.FMC_OppDices = new Vector.<MovieClip>(_loc3_);
         this.FMC_OwnDices = new Vector.<MovieClip>(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FMC_OppDices[_loc2_] = _loc6_[CONST_ACTIVITY.RESOURCE_Link_MC_Dice + _loc2_];
            this.FMC_OppDices[_loc2_].stop();
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FMC_OwnDices[_loc2_] = _loc6_[CONST_ACTIVITY.RESOURCE_Link_MC_Dice + (_loc2_ + _loc3_)];
            this.FMC_OwnDices[_loc2_].stop();
            _loc2_++;
         }
         _loc3_ = int(COUNT_MC_Wins);
         _loc6_ = FScene[CONST_ACTIVITY.RESOURCE_Link_MC_Wins];
         this.FMC_WinVect = new Vector.<Sprite>(_loc3_);
         this.FTF_WinCountVect = new Vector.<TextField>(_loc3_);
         this.FTF_WinAwardVect = new Vector.<TextField>(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FMC_WinVect[_loc2_] = _loc6_[CONST_ACTIVITY.RESOURCE_Link_MC_WinsElement + _loc2_];
            this.FMC_WinVect[_loc2_].addEventListener(MouseEvent.MOUSE_MOVE,this.MCWinsOnOver);
            this.FMC_WinVect[_loc2_].addEventListener(MouseEvent.MOUSE_OUT,this.MCWinsOnOut);
            this.FTF_WinCountVect[_loc2_] = this.FMC_WinVect[_loc2_][CONST_ACTIVITY.RESOURCE_Link_TF_WinCount];
            this.FTF_WinCountVect[_loc2_].mouseEnabled = false;
            this.FTF_WinAwardVect[_loc2_] = this.FMC_WinVect[_loc2_][CONST_ACTIVITY.RESOURCE_Link_TF_WinAwardCount];
            this.FTF_WinAwardVect[_loc2_].mouseEnabled = false;
            _loc2_++;
         }
         this.FMC_Bar = FScene[CONST_ACTIVITY.RESOURCE_Link_MC_Bar];
         this.FMC_Bar.stop();
         this.FBtn_OK = new TUIButton();
         this.FBtn_OK.Substrate = FScene[CONST_ACTIVITY.RESOURCE_Link_BTN_OK];
         this.FBtn_OK.OnClick = this.BtnGetAwardOnClick;
         this.FBtn_OK.Enabled = false;
         _loc3_ = int(COUNT_TF_Rank);
         _loc6_ = FScene[CONST_ACTIVITY.RESOURCE_Link_MC_RankList];
         this.FTF_RankVect = new Vector.<TextField>(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FTF_RankVect[_loc2_] = _loc6_[CONST_ACTIVITY.RESOURCE_Link_TF_RankElement + _loc2_];
            this.FTF_RankVect[_loc2_].mouseEnabled = false;
            _loc2_++;
         }
         this.FSelectBox_StartCount = new TSelectBoxSingle();
         this.FSelectBox_StartCount.CallBackOnSelect = this.SelectBoxStartCountOnSelect;
         this.FSelectBox_StartCount.CallBackOnUnselect = this.SelectBoxStartCountOnUnselect;
         this.FSelectBox_StartCount.SetTaskByIndex(0,FScene[CONST_ACTIVITY.RESOURCE_Link_MC_SelectBox + 0]);
         this.FSelectBox_StartCount.Init();
         this.FSelectBox_StartPrompt = FScene[CONST_ACTIVITY.RESOURCE_Link_TF_SelectBoxPrompt + 0];
         this.FSelectBox_StartPrompt.mouseEnabled = false;
         this.FTF_StartCount = FScene[CONST_ACTIVITY.RESOURCE_Link_TF_StartCount];
         this.FTF_StartCount.mouseEnabled = false;
         this.FSelectBox_FailoverCount = new TSelectBoxSingle();
         this.FSelectBox_FailoverCount.CallBackOnSelect = this.SelectBoxFailoverCountOnSelect;
         this.FSelectBox_FailoverCount.CallBackOnUnselect = this.SelectBoxFailoverCountOnUnselect;
         this.FSelectBox_FailoverCount.SetTaskByIndex(0,FScene[CONST_ACTIVITY.RESOURCE_Link_MC_SelectBox + 1]);
         this.FSelectBox_FailoverCount.Init();
         this.FSelectBox_FailoverPrompt = FScene[CONST_ACTIVITY.RESOURCE_Link_TF_SelectBoxPrompt + 1];
         this.FSelectBox_FailoverPrompt.mouseEnabled = false;
         this.FSelectBox_StartPrompt.mouseEnabled = false;
         this.FUIWindowUseCount = SUtilityOverLayer.UIWindowConfirmation;
         _loc6_ = FScene[CONST_ACTIVITY.RESOURCE_Link_TF_TargetWinCount];
         this.FTF_CurWins = _loc6_[CONST_ACTIVITY.RESOURCE_Link_TF_CurrentPoint];
         this.FTF_CurWins.mouseEnabled = false;
         this.FIsInitWindow = true;
         this.ResetText();
      }
      
      override protected function UpdateUIConfig() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Vector.<uint> = null;
         super.UpdateUIConfig();
         this.FHDGambling = FHDActivityConfig as THDGambling;
         _loc2_ = int(this.FHDGambling.DataAwards.length);
         _loc3_ = new Vector.<uint>(_loc2_);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_[_loc1_] = this.FHDGambling.DataAwards[_loc1_].Awards[0];
            _loc1_++;
         }
         FInventoriesVect = ProcessorGetInventoriesVectByAwardID(_loc3_);
      }
      
      override protected function UpdateDataBase(param1:TActivityOSBase) : void
      {
         super.UpdateDataBase(param1);
         this.FDataGambling = param1 as TActivityGambling;
         this.ProcessorCheckEffect();
         this.UpdateUI();
      }
      
      protected function ProcessorCheckEffect() : void
      {
         if(FUpdateStatus != null)
         {
            if(FUpdateStatus != null)
            {
               FUpdateStatus(this);
            }
         }
      }
      
      override protected function UpdateUI() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:uint = 0;
         super.UpdateUI();
         this.UpdateUIAwardButton();
         this.UpdateUIBar();
         if(this.FIsGetAward)
         {
            this.FIsGetAward = false;
            return;
         }
         this.UpdateUIStage();
         this.UpdateUIRank();
         this.UpdateUICurWins();
         this.UpdateUICount();
         this.UpdateUISelectBoxPrompt();
         this.ProcessorShowOppDice();
         _loc2_ = int(COUNT_MC_Dice);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ += this.FOppDicePoints[_loc1_];
            _loc1_++;
         }
      }
      
      protected function UpdateUICurWins() : void
      {
         this.FTF_CurWins.text = this.FDataGambling.DataWinCount.WinCount.toString();
      }
      
      protected function UpdateUICount() : void
      {
         this.FTF_FreeCount.text = TUtilityString.Format(this.FHDGambling.AutoBuyPrompt[0],this.FDataGambling.DataStartCount.Count) + "," + TUtilityString.Format(this.FHDGambling.AutoBuyPrompt[1],this.FDataGambling.DataFailOverCount.Count);
      }
      
      protected function UpdateUISelectBoxPrompt() : void
      {
         this.FSelectBox_StartPrompt.text = TUtilityString.Format(this.FHDGambling.AutoBuyPrompt[3],this.FHDGambling.DataStartCount.Cost);
         this.FSelectBox_FailoverPrompt.text = TUtilityString.Format(this.FHDGambling.AutoBuyPrompt[4],this.FHDGambling.DataFailOverCount.Cost);
      }
      
      protected function UpdateUIStage() : void
      {
         switch(this.FDataGambling.DataStage)
         {
            case STAGE_Gambling_None:
               this.FBtn_Start.Visible = true;
               this.FBtn_Big.Visible = false;
               this.FBtn_Small.Visible = false;
               if(!this.FIsOppPlayMC)
               {
                  this.ProcessorPlayOppDiceContainer(STATUS_DiceContainer_Start);
               }
               if(this.FMC_OwnDiceContainer.currentFrame >= FRAME_MC_DiceContainer_Hide)
               {
                  this.ProcessorPlayOwnDiceContainer(STATUS_DiceContainer_Show);
               }
               else if(this.FMC_OwnDiceContainer.currentFrame == 1)
               {
                  this.ProcessorPlayOwnDiceContainer(STATUS_DiceContainer_Start);
               }
               break;
            case STAGE_Gambling_Start:
               this.FBtn_Start.Visible = false;
               this.FBtn_Big.Visible = false;
               this.FBtn_Small.Visible = false;
               this.ProcessorPlayOppDiceContainer(STATUS_DiceContainer_Show);
               this.ProcessorPlayOwnDiceContainer(STATUS_DiceContainer_Hide);
               break;
            case STAGE_Gambling_IsWin:
               this.FBtn_Big.Visible = false;
               this.FBtn_Small.Visible = false;
               if(!this.FIsOppPlayMC)
               {
                  this.ProcessorPlayOppDiceContainer(STATUS_DiceContainer_Start);
               }
               this.ProcessorPlayOwnDiceContainer(STATUS_DiceContainer_Show);
         }
      }
      
      protected function ProcessorHandlerStart() : void
      {
         if(this.FDataGambling.DataStartCount.Count > 0 || this.FStatus_SelectBoxStart == STATUS_SelectBox_Yes)
         {
            Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FDataGambling.DataStartCount.Index);
         }
         else if(FCharacter.CreditGold >= this.FDataGambling.DataStartCount.Cost)
         {
            FUIWindowConfirmation.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_55),this.FDataGambling.DataStartCount.Cost);
            FUIWindowConfirmation.OnOK = this.WindowInformationOnOK;
            FUIWindowConfirmation.OnCancel = WindowInformationOnCancel;
            FUIWindowConfirmation.SetCoordinate(400,370);
            FUIWindowConfirmation.Visible = true;
         }
         else
         {
            FUIWindowRecharge.SetCoordinate(400,370);
            FUIWindowRecharge.OnCancel = this.ProcessorUIWindowRechargeOnCancel;
            FUIWindowRecharge.Visible = true;
         }
      }
      
      protected function ProcessorHandleFailover() : void
      {
         if(this.FDataGambling.DataIsWin == STATUS_Gambling_Failure)
         {
            if(this.FStatus_SelectBoxFailover == STATUS_SelectBox_Yes)
            {
               if(this.FDataGambling.DataFailOverCount.Count > 0)
               {
                  Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FDataGambling.DataFailOverCount.Index);
               }
               else if(FCharacter.CreditGold <= this.FDataGambling.DataFailOverCount.Cost)
               {
                  EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.NOTENOUGH_Gold));
                  FUIWindowRecharge.SetCoordinate(400,370);
                  FUIWindowRecharge.OnCancel = this.ProcessorUIWindowRechargeOnCancel;
                  FUIWindowRecharge.Visible = true;
               }
               else
               {
                  Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FDataGambling.DataFailOverCount.Index);
               }
            }
            else
            {
               this.FUIWindowUseCount.Text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_53);
               this.FUIWindowUseCount.OnOK = this.UIWindowUseCountOnOk;
               this.FUIWindowUseCount.OnCancel = this.UIWindowUseCountOnCancel;
               this.FUIWindowUseCount.SetCoordinate(400,370);
               this.FUIWindowUseCount.Visible = true;
            }
         }
      }
      
      protected function UpdateUIAwardButton() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         this.FBtn_OK.Enabled = false;
         _loc2_ = int(COUNT_MC_Wins);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            if(this.FDataGambling.GetAwardDataByIndex(_loc1_).Status >= Activity_CanReceive)
            {
               this.FBtn_OK.Enabled = true;
               break;
            }
            _loc1_++;
         }
      }
      
      protected function UpdateUIBar() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TActivityDataAward = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         _loc5_ = 0;
         _loc2_ = int(COUNT_MC_Wins);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FDataGambling.GetAwardDataByIndex(_loc1_);
            this.FTF_WinCountVect[_loc1_].text = _loc3_.Prompt;
            _loc4_ = _loc3_.Status;
            if(_loc4_ <= Activity_CanNotReceive)
            {
               _loc4_ = Activity_CanNotReceive;
               this.FTF_WinAwardVect[_loc1_].text = "";
            }
            else
            {
               this.FTF_WinAwardVect[_loc1_].text = "x" + _loc4_.toString();
            }
            if(this.FDataGambling.DataWinCount.WinCount >= _loc3_.Condition)
            {
               _loc5_ = _loc1_ + 1;
            }
            _loc1_++;
         }
         this.FMC_Bar.gotoAndStop(_loc5_ + 1);
      }
      
      protected function UpdateUIRank() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         if(this.FDataGambling.DataRankList == null)
         {
            return;
         }
         _loc2_ = int(COUNT_TF_Rank);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            if(_loc1_ < this.FDataGambling.DataRankList.length)
            {
               this.FTF_RankVect[_loc1_].text = TUtilityString.Format(this.FHDGambling.AutoBuyPrompt[2],this.FDataGambling.DataRankList[_loc1_].Name,this.FDataGambling.DataRankList[_loc1_].Level);
            }
            else
            {
               this.FTF_RankVect[_loc1_].text = "";
            }
            _loc1_++;
         }
      }
      
      protected function ProcessorPlayOppDiceContainer(param1:uint) : void
      {
         switch(param1)
         {
            case STATUS_DiceContainer_Start:
               this.FMC_OppDiceContainer.gotoAndStop(FRAME_MC_DiceContainer_Start);
               break;
            case STATUS_DiceContainer_Show:
               this.FMC_OppDiceContainer.gotoAndPlay(1);
               this.FIsOppPlayMC = true;
         }
      }
      
      protected function ProcessorPlayOwnDiceContainer(param1:uint) : void
      {
         switch(param1)
         {
            case STATUS_DiceContainer_Start:
               this.FMC_OwnDiceContainer.gotoAndStop(FRAME_MC_DiceContainer_Start);
               break;
            case STATUS_DiceContainer_Hide:
               this.FMC_OwnDiceContainer.gotoAndPlay(1);
               this.FIsOwnPlayMC = true;
               break;
            case STATUS_DiceContainer_Show:
               this.FMC_OwnDiceContainer.gotoAndPlay(FRAME_MC_DiceContainer_Hide);
               this.FIsOwnPlayMC = true;
         }
      }
      
      protected function ProcessorShowOppDice() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         _loc3_ = int(this.FDataGambling.DataDicePoint);
         this.FOppDicePoints[0] = (_loc3_ - _loc3_ % 100) / 100;
         this.FOppDicePoints[1] = (_loc3_ - this.FOppDicePoints[0] * 100 - (_loc3_ - this.FOppDicePoints[0] * 100) % 10) / 10;
         this.FOppDicePoints[2] = _loc3_ % 10;
         _loc2_ = int(COUNT_MC_Dice);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FMC_OppDices[_loc1_].gotoAndStop(this.FOppDicePoints[_loc1_]);
            _loc1_++;
         }
      }
      
      protected function UpdateUISelectBox() : void
      {
         if(this.FStatus_SelectBoxStart == STATUS_SelectBox_Yes)
         {
            this.FSelectBox_StartCount.SetSelectByIndex(0);
         }
         else
         {
            this.FSelectBox_StartCount.SetUnselectByIndex(0);
         }
         if(this.FStatus_SelectBoxFailover == STATUS_SelectBox_Yes)
         {
            this.FSelectBox_FailoverCount.SetSelectByIndex(0);
         }
         else
         {
            this.FSelectBox_FailoverCount.SetUnselectByIndex(0);
         }
      }
      
      protected function ProcessorShowOwnDice() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         if(this.FCurrentButtonData == null)
         {
            return;
         }
         _loc4_ = this.FCurrentButtonData.ButtonType;
         _loc2_ = int(COUNT_MC_Dice);
         _loc3_ = 0;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ += this.FOppDicePoints[_loc1_];
            _loc1_++;
         }
         if(this.FDataGambling.DataIsWin == STATUS_Gambling_None)
         {
            _loc1_ = 0;
            while(_loc1_ < _loc2_)
            {
               this.FOwnDicePoints[_loc1_] = 1;
               _loc1_++;
            }
         }
         else if(this.FDataGambling.DataIsWin == STATUS_Gambling_Win)
         {
            if(_loc3_ == Dice_TotalPoints_MustWin[0])
            {
               this.GetDicePointRandom(_loc3_,BUTTONTYPE_Gambling_Big);
            }
            else if(_loc3_ == Dice_TotalPoints_MustWin[1])
            {
               this.GetDicePointRandom(_loc3_,BUTTONTYPE_Gambling_Small);
            }
            else if(_loc4_ == BUTTONTYPE_Gambling_Small)
            {
               this.GetDicePointRandom(_loc3_,BUTTONTYPE_Gambling_Big);
            }
            else
            {
               this.GetDicePointRandom(_loc3_,BUTTONTYPE_Gambling_Small);
            }
         }
         else if(this.FDataGambling.DataIsWin == STATUS_Gambling_Failure)
         {
            if(_loc3_ == Dice_TotalPoints_MustWin[0])
            {
               _loc1_ = 0;
               while(_loc1_ < _loc2_)
               {
                  this.FOwnDicePoints[_loc1_] = 1;
                  _loc1_++;
               }
            }
            else if(_loc3_ == Dice_TotalPoints_MustWin[1])
            {
               _loc1_ = 0;
               while(_loc1_ < _loc2_)
               {
                  this.FOwnDicePoints[_loc1_] = 6;
                  _loc1_++;
               }
            }
            else if(_loc4_ == BUTTONTYPE_Gambling_Small)
            {
               this.GetDicePointRandom(_loc3_,BUTTONTYPE_Gambling_Small);
            }
            else
            {
               this.GetDicePointRandom(_loc3_,BUTTONTYPE_Gambling_Big);
            }
         }
         _loc2_ = int(COUNT_MC_Dice);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FMC_OwnDices[_loc1_].gotoAndStop(this.FOwnDicePoints[_loc1_]);
            _loc1_++;
         }
      }
      
      protected function GetDicePointRandom(param1:uint, param2:uint) : void
      {
         var _loc3_:uint = 0;
         if(param2 == BUTTONTYPE_Gambling_Small)
         {
            do
            {
               _loc3_ = this.GetRandom();
            }
            while(_loc3_ >= param1);
         }
         else
         {
            do
            {
               _loc3_ = this.GetRandom();
            }
            while(_loc3_ <= param1);
         }
      }
      
      protected function GetRandom() : uint
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:uint = 0;
         _loc2_ = int(COUNT_MC_Dice);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FOwnDicePoints[_loc1_] = Math.random() * 6 + 1;
            _loc3_ += this.FOwnDicePoints[_loc1_];
            _loc1_++;
         }
         return _loc3_;
      }
      
      protected function ResetText() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         if(!this.FIsInitWindow)
         {
            return;
         }
         this.FSelectBox_FailoverPrompt.text = "";
         this.FSelectBox_StartPrompt.text = "";
         this.FTF_CurWins.text = "";
         this.FTF_FreeCount.text = "";
         _loc2_ = int(COUNT_MC_Wins);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FTF_WinAwardVect[_loc1_].text = "";
            this.FTF_WinCountVect[_loc1_].text = "";
            this.FTF_RankVect[_loc1_].text = "";
            _loc1_++;
         }
      }
      
      override protected function Reset() : void
      {
         super.Reset();
         if(!this.FIsInitWindow)
         {
            return;
         }
         this.ResetText();
         this.FMC_OppDiceContainer.gotoAndStop(1);
         this.FMC_OwnDiceContainer.gotoAndStop(1);
         this.FIsGetAward = false;
      }
      
      protected function BtnStartOnClick(param1:Object, param2:MouseEvent) : void
      {
         this.ProcessorHandlerStart();
      }
      
      protected function BtnBigOnClick(param1:Object, param2:MouseEvent) : void
      {
         this.FCurrentButtonData = this.FDataGambling.GetButtonDataByType(BUTTONTYPE_Gambling_Big);
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FCurrentButtonData.Index);
      }
      
      protected function BtnSmallOnClick(param1:Object, param2:MouseEvent) : void
      {
         this.FCurrentButtonData = this.FDataGambling.GetButtonDataByType(BUTTONTYPE_Gambling_Small);
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FCurrentButtonData.Index);
      }
      
      protected function MCActivityPromptOver(param1:MouseEvent) : void
      {
         FHint.Caption = this.FHDGambling.Desc;
         SUtilityOverLayer.UIComponentsHintOnOver(this,FHint);
      }
      
      protected function MCActivityPromptOut(param1:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOut(this,FHint);
      }
      
      protected function MCWinsOnOver(param1:MouseEvent) : void
      {
         var _loc2_:TInventories = null;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:Array = null;
         _loc4_ = param1.currentTarget.name;
         _loc3_ = int(_loc4_.split("_")[2]);
         _loc2_ = FInventoriesVect[_loc3_];
         if(FOnGiftBoxMove != null)
         {
            FOnGiftBoxMove(this,_loc2_);
         }
      }
      
      protected function MCWinsOnOut(param1:MouseEvent) : void
      {
         if(FOnGiftBoxOut != null)
         {
            FOnGiftBoxOut(this);
         }
      }
      
      protected function BtnGetAwardOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:TActivityDataAward = null;
         _loc4_ = int(COUNT_MC_Wins);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc5_ = this.FDataGambling.GetAwardDataByIndex(_loc3_);
            if(_loc5_.Status >= Activity_CanReceive)
            {
               break;
            }
            _loc3_++;
         }
         if(_loc5_.Status >= Activity_CanReceive)
         {
            Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,_loc5_.Index);
            this.FIsGetAward = true;
         }
         else
         {
            EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_56));
         }
      }
      
      protected function SelectBoxStartCountOnSelect(param1:int, param2:int) : void
      {
         this.FStatus_SelectBoxStart = STATUS_SelectBox_Yes;
      }
      
      protected function SelectBoxStartCountOnUnselect(param1:int, param2:int) : void
      {
         this.FStatus_SelectBoxStart = STATUS_SelectBox_No;
      }
      
      protected function SelectBoxFailoverCountOnSelect(param1:int, param2:int) : void
      {
         this.FStatus_SelectBoxFailover = STATUS_SelectBox_Yes;
      }
      
      protected function SelectBoxFailoverCountOnUnselect(param1:int, param2:int) : void
      {
         this.FStatus_SelectBoxFailover = STATUS_SelectBox_No;
      }
      
      protected function UIWindowUseCountOnOk(param1:Object) : void
      {
         if(this.FDataGambling.DataStage == STAGE_Gambling_IsWin && this.FDataGambling.DataIsWin == STATUS_Gambling_Failure)
         {
            if(this.FDataGambling.DataFailOverCount.Count > 0)
            {
               this.FIsGetAward = false;
               Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FDataGambling.DataFailOverCount.Index);
            }
            else if(FCharacter.CreditGold >= this.FDataGambling.DataFailOverCount.Cost)
            {
               FUIWindowConfirmation.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_52),this.FDataGambling.DataFailOverCount.Cost);
               FUIWindowConfirmation.OnOK = this.WindowInformationOnOK;
               FUIWindowConfirmation.OnCancel = WindowInformationOnCancel;
               FUIWindowConfirmation.SetCoordinate(400,370);
               FUIWindowConfirmation.Visible = true;
            }
            else
            {
               FUIWindowRecharge.SetCoordinate(400,370);
               FUIWindowRecharge.OnCancel = this.ProcessorUIWindowRechargeOnCancel;
               FUIWindowRecharge.Visible = true;
            }
         }
      }
      
      protected function UIWindowUseCountOnCancel(param1:Object) : void
      {
         if(this.FDataGambling.DataStage == STAGE_Gambling_IsWin)
         {
            Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FDataGambling.GetButtonDataByType(BUTTONTYPE_Gambling_Start).Index);
            this.FTF_CurWins.text = "0";
         }
      }
      
      override protected function WindowInformationOnOK(param1:Object) : void
      {
         super.WindowInformationOnOK(param1);
         if(this.FDataGambling.DataStage == STAGE_Gambling_IsWin && this.FDataGambling.DataIsWin == STATUS_Gambling_Failure)
         {
            Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FDataGambling.DataFailOverCount.Index);
         }
         else
         {
            Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FDataGambling.DataStartCount.Index);
         }
      }
      
      override protected function BtnCloseOnClick(param1:Object, param2:MouseEvent) : void
      {
         super.BtnCloseOnClick(param1,param2);
         if(FOnBtnCloseClick != null)
         {
            FOnBtnCloseClick(this);
         }
      }
      
      protected function ProcessorUIWindowRechargeOnCancel(param1:Object) : void
      {
         if(this.FDataGambling.DataStage == STAGE_Gambling_IsWin && this.FDataGambling.DataIsWin == STATUS_Gambling_Failure)
         {
            this.FUIWindowUseCount.Text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_53);
            this.FUIWindowUseCount.OnOK = this.UIWindowUseCountOnOk;
            this.FUIWindowUseCount.OnCancel = this.UIWindowUseCountOnCancel;
            this.FUIWindowUseCount.SetCoordinate(400,370);
            this.FUIWindowUseCount.Visible = true;
         }
      }
      
      public function ValuesChange(param1:TActivityGambling) : void
      {
         this.UpdateDataBase(param1);
      }
   }
}

