package Processors.Game.Lobby.Activity.HDChess
{
   import Components.Slots.*;
   import Components.Standard.*;
   import Foundation.Common.*;
   import Foundation.Queries.Coordinate.*;
   import Foundation.Resources.*;
   import Foundation.Timing.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.HDActivityOS.*;
   import Logics.HDChess.*;
   import Logics.Inventories.*;
   import Processors.Game.Common.Effects.Display.*;
   import Processors.Game.Lobby.Activity.HDActivity.*;
   import Processors.Game.Lobby.Utilities.*;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Resources.Constants.*;
   import Utilities.Timing.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class TProcessorWindowChess extends TProcessorHDSingleWindowBase
   {
      
      protected var FHD_Chess:THDChess;
      
      protected var FData_Chess:TActivityChess;
      
      protected var FAwardInventories:Vector.<TInventories>;
      
      protected var FFinalAwardInventories:Vector.<TInventories>;
      
      protected var FBtn_Normal:TUIButton;
      
      protected var FBtn_Reset:TUIButton;
      
      protected var FBtn_Super:TUIButton;
      
      protected var FBtn_Hero:TUIButton;
      
      protected var FBtn_Achieve:TUIButton;
      
      protected var FBtn_Reflash:TUIButton;
      
      protected var FBtn_Dices:Vector.<TUIButton>;
      
      protected var FBtn_Dice:TUIButton;
      
      protected var FStartTime:uint;
      
      protected var FIsInitWindow:Boolean;
      
      protected var FFreeFlag:Vector.<int>;
      
      protected var FCurPos:int;
      
      protected var FLastPos:int;
      
      protected var FGlowTwo:TEffectBaseGlowTwo;
      
      protected var FGlowTwoReset:TEffectBaseGlowTwo;
      
      protected var FShowFinal:Boolean;
      
      protected var FRand:Vector.<uint>;
      
      protected var FSlot:TUISlot;
      
      protected var FBaseTime:int;
      
      protected var FNowTime:Date;
      
      protected var FPos:uint;
      
      protected var FAwardIDs:Vector.<uint>;
      
      protected var FIsNotInit:Boolean;
      
      protected var FTempVec:Vector.<int>;
      
      protected var FMC_Man:MovieClip;
      
      protected var FMC_NormalMoive:MovieClip;
      
      protected var FMC_DiceOut:MovieClip;
      
      protected var FMC_DiceIn:MovieClip;
      
      protected var FMC_DiceBarInner:MovieClip;
      
      protected var FMC_Chesstable:Sprite;
      
      protected var FMC_FinalBar:Sprite;
      
      protected var FMC_ChessBoxs:Vector.<Sprite>;
      
      protected var FTF_CoolDown:TextField;
      
      protected var FMC_FinalBarAward:MovieClip;
      
      protected var FOnAchieve:Function;
      
      public function TProcessorWindowChess(param1:TUIComponent)
      {
         super(param1);
         FSceneResourceName = "MC_Chess";
         FActivityID = CONST_ACTIVITY_MODE.Activity_Chess;
         this.FFreeFlag = new Vector.<int>(1);
         this.FNowTime = new Date();
         this.FShowFinal = false;
         this.FIsNotInit = false;
         this.FIsInitWindow = false;
      }
      
      protected function OprateReq(param1:Object) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,SUtilityOverLayer.UIWindowConfirmation.Tag);
         this.FShowFinal = true;
      }
      
      protected function NormalClickOkReq(param1:Object) : void
      {
         this.FIsNotInit = true;
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,SUtilityOverLayer.UIWindowConfirmation.Tag,0,this.FFreeFlag);
      }
      
      protected function SuperClickOkReq(param1:Object) : void
      {
         this.FIsNotInit = true;
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,SUtilityOverLayer.UIWindowConfirmation.Tag,0,this.FTempVec);
      }
      
      override public function InitWindow(param1:Sprite = null) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:int = 0;
         var _loc4_:TUIButton = null;
         super.InitWindow(param1);
         this.FBtn_Normal = new TUIButton();
         this.FBtn_Normal.Substrate = FScene["Btn_Normal"];
         this.FBtn_Normal.OnClick = this.NormalOnClick;
         this.FBtn_Normal.OnMove = this.OnBtnNormalOnOver;
         this.FBtn_Normal.OnOut = this.ProcessorOnHintOut;
         this.FBtn_Reset = new TUIButton();
         this.FBtn_Reset.Substrate = FScene["Btn_Reset"];
         this.FBtn_Reset.OnClick = this.ResetOnClick;
         this.FBtn_Reset.Visible = false;
         this.FGlowTwoReset = new TEffectBaseGlowTwo();
         this.FGlowTwoReset.SetParameters(FScene["Btn_Reset"],16776960,20,2);
         this.FBtn_Super = new TUIButton();
         this.FBtn_Super.Substrate = FScene["MC_DiceOut"]["Btn_Super"];
         this.FBtn_Super.OnClick = this.ShowDiceBarOnClick;
         this.FBtn_Super.OnMove = this.OnBtnSuperOnOver;
         this.FBtn_Super.OnOut = this.ProcessorOnHintOut;
         this.FBtn_Hero = new TUIButton();
         this.FBtn_Hero.Substrate = FScene["Btn_Hero"];
         this.FBtn_Achieve = new TUIButton();
         this.FBtn_Achieve.Substrate = FScene["Btn_Achieve"];
         this.FBtn_Achieve.OnClick = this.AchieveOnClick;
         this.FMC_FinalBarAward = FScene["MC_FinalBar"];
         this.FBtn_Reflash = new TUIButton();
         this.FBtn_Reflash.Substrate = this.FMC_FinalBarAward["Btn_OK"];
         this.FBtn_Reflash.OnClick = this.ProcessorOnBtnOkClick;
         this.FSlot = new TUISlot(this);
         this.FSlot.Resource = this.FMC_FinalBarAward["MC_Slot_0"];
         this.FSlot.SequenceDefaultIcon = SResourcesCore.TexturesLobby.GetAnimationSequenceByIdentifiers(CONST_LOBBY.RESOURCESID_Texture_SlotDefaultEffect,0);
         this.FSlot.OnQuerySequenceContext = SlotsOnQuerySequenceContext;
         this.FSlot.OnOver = ProcessorOnSlotOver;
         this.FSlot.OnOut = ProcessorOnSlotOut;
         this.FSlot.OnQuerySubscript = SlotsOnQuerySubscript;
         this.FSlot.Init();
         this.FMC_Man = FScene["MC_Man"];
         this.FMC_Man["MC_head"]["MC_eye_left"].play();
         this.FMC_Man["MC_head"]["MC_eye_right"].play();
         this.FMC_Man.mouseChildren = false;
         this.FMC_Man.mouseEnabled = false;
         this.FTF_CoolDown = FScene["Btn_Normal"]["TF_CoolDown"];
         this.FMC_NormalMoive = FScene["MC_NormalMovie"];
         this.FMC_DiceOut = FScene["MC_DiceOut"];
         this.FMC_DiceIn = FScene["MC_SuperBar"];
         this.FMC_DiceIn.visible = false;
         this.FMC_DiceBarInner = this.FMC_DiceOut["MC_DiceBarInner"];
         _loc2_ = 6;
         this.FBtn_Dices = new Vector.<TUIButton>(_loc2_);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = new TUIButton();
            _loc4_.Substrate = this.FMC_DiceBarInner["Btn_Dice_" + _loc3_];
            _loc4_.OnClick = this.SuperDiceOnClick;
            this.FBtn_Dices[_loc3_] = _loc4_;
            _loc3_++;
         }
         this.FMC_Chesstable = FScene["MC_Chesstable"];
         _loc2_ = 100;
         this.FMC_ChessBoxs = new Vector.<Sprite>(_loc2_);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            this.FMC_ChessBoxs[_loc3_] = this.FMC_Chesstable["MC_Chess_" + _loc3_];
            this.FMC_ChessBoxs[_loc3_]["TF_Prompt"].text = (_loc3_ + 1).toString();
            this.FMC_ChessBoxs[_loc3_].mouseChildren = false;
            this.FMC_ChessBoxs[_loc3_].mouseEnabled = false;
            if(this.FMC_ChessBoxs[_loc3_]["MC_mv"] != null)
            {
               this.FMC_ChessBoxs[_loc3_]["MC_mv"].play();
            }
            _loc3_++;
         }
         _loc2_ = 9;
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            this.FMC_ChessBoxs[_loc3_ * 10 + _loc2_].mouseChildren = true;
            this.FMC_ChessBoxs[_loc3_ * 10 + _loc2_].mouseEnabled = true;
            this.FMC_ChessBoxs[_loc3_ * 10 + _loc2_].addEventListener(MouseEvent.MOUSE_MOVE,this.ChessOnMove);
            this.FMC_ChessBoxs[_loc3_ * 10 + _loc2_].addEventListener(MouseEvent.MOUSE_OUT,this.ChessOnOut);
            _loc3_++;
         }
         this.FMC_ChessBoxs[99].mouseChildren = true;
         this.FMC_ChessBoxs[99].mouseEnabled = true;
         this.FMC_ChessBoxs[99].addEventListener(MouseEvent.MOUSE_MOVE,this.ChessOnMove);
         this.FMC_ChessBoxs[99].addEventListener(MouseEvent.MOUSE_OUT,this.ChessOnOut);
         this.FMC_FinalBar = FScene["MC_FinalBar"];
         this.FStartTime = STimingCore.ServerTick;
         this.FIsInitWindow = true;
      }
      
      protected function OnBtnSuperOnOver(param1:Object, param2:MouseEvent) : void
      {
         FHint.Caption = this.FHD_Chess.Prompt1;
         if(FOnHintOver != null)
         {
            FOnHintOver(this,FHint);
         }
      }
      
      protected function ShowDiceBarOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(SLogicsCore.Character.CreditGold < this.FHD_Chess.ControlCost)
         {
            if(FOnEffectText != null)
            {
               FOnEffectText(this,TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ORGANIZATION_STRING_59));
            }
            return;
         }
         if(this.FMC_DiceOut.currentFrame == this.FMC_DiceOut.totalFrames)
         {
            this.FMC_DiceOut.gotoAndStop(1);
            this.FMC_DiceIn.visible = true;
            this.FMC_DiceIn.gotoAndPlay(1);
         }
         else
         {
            this.FMC_DiceIn.visible = false;
            this.FMC_DiceOut.gotoAndPlay(1);
         }
      }
      
      protected function AchieveOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FOnAchieve != null)
         {
            this.FOnAchieve();
         }
      }
      
      protected function NormalOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FFreeFlag[0] == 0)
         {
            this.FStartTime = STimingCore.ServerTick;
         }
         else if(SLogicsCore.Character.CreditGold < this.FHD_Chess.NormalCost)
         {
            if(FOnEffectText != null)
            {
               FOnEffectText(this,TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ORGANIZATION_STRING_59));
            }
            return;
         }
         if(this.FFreeFlag[0] == 1)
         {
            SUtilityOverLayer.UIWindowConfirmation.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_06),this.FHD_Chess.NormalCost);
            SUtilityOverLayer.UIWindowConfirmation.Visible = true;
            SUtilityOverLayer.UIWindowConfirmation.OnOK = this.NormalClickOkReq;
            SUtilityOverLayer.UIWindowConfirmation.Tag = this.FHD_Chess.NormalIndex;
         }
         else
         {
            this.FIsNotInit = true;
            Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FHD_Chess.NormalIndex,0,this.FFreeFlag);
         }
      }
      
      protected function ShowBtn() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         _loc1_ = false;
         _loc3_ = int(this.FData_Chess.AchieveAward.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(this.FData_Chess.AchieveAward[_loc2_].Status == 1)
            {
               _loc1_ = true;
            }
            _loc2_++;
         }
         if(_loc1_ == false)
         {
            if(this.FGlowTwo != null)
            {
               this.FGlowTwo.Stop();
               this.FGlowTwo = null;
            }
         }
         else
         {
            this.FGlowTwo = new TEffectBaseGlowTwo();
            this.FGlowTwo.SetParameters(FScene["Btn_Achieve"],16776960,20,2);
         }
      }
      
      protected function ResetOnClick(param1:Object, param2:MouseEvent) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FHD_Chess.ResetIndex);
      }
      
      protected function SuperDiceOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(SLogicsCore.Character.CreditGold < this.FHD_Chess.FinalCost)
         {
            if(FOnEffectText != null)
            {
               FOnEffectText(this,TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ORGANIZATION_STRING_59));
            }
            return;
         }
         SUtilityOverLayer.UIWindowConfirmation.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_06),this.FHD_Chess.ControlCost);
         SUtilityOverLayer.UIWindowConfirmation.Visible = true;
         SUtilityOverLayer.UIWindowConfirmation.OnOK = this.SuperClickOkReq;
         SUtilityOverLayer.UIWindowConfirmation.Tag = this.FHD_Chess.ControlIndex;
         this.FTempVec[0] = int(param2.currentTarget.name.split("_")[2]) + 1;
      }
      
      protected function ProcessorOnBtnOkClick(param1:Object, param2:uint) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:uint = 0;
         if(SLogicsCore.Character.CreditGold < this.FHD_Chess.FinalCost)
         {
            if(FOnEffectText != null)
            {
               FOnEffectText(this,TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ORGANIZATION_STRING_59));
            }
            return;
         }
         this.FBaseTime = STimingCore.TickCount;
         this.FPos = 0;
         _loc5_ = this.FData_Chess.FinalAward.length - 1;
         _loc4_ = _loc5_ * 5;
         this.FRand = new Vector.<uint>(_loc4_);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            this.FRand[_loc3_] = int(Math.random() * 10);
            _loc3_++;
         }
         SUtilityOverLayer.UIWindowConfirmation.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_06),this.FHD_Chess.FinalCost);
         SUtilityOverLayer.UIWindowConfirmation.Visible = true;
         SUtilityOverLayer.UIWindowConfirmation.OnOK = this.OprateReq;
         SUtilityOverLayer.UIWindowConfirmation.Tag = this.FHD_Chess.RefreshFinalIndex;
      }
      
      override protected function UpdateDataBase(param1:TActivityOSBase) : void
      {
         var _loc2_:Vector.<String> = null;
         var _loc3_:Vector.<uint> = null;
         super.UpdateDataBase(param1);
         this.FData_Chess = param1 as TActivityChess;
         if(this.FData_Chess.LocationPos == 100)
         {
            this.FBtn_Reset.Visible = true;
            this.FBtn_Reflash.Enabled = false;
            this.FBtn_Normal.Enabled = false;
            this.FBtn_Super.Enabled = false;
            this.FMC_DiceOut.gotoAndStop(1);
            this.FMC_DiceIn.visible = false;
         }
         else
         {
            this.FBtn_Reset.Visible = false;
            this.FBtn_Reflash.Enabled = false;
            this.FBtn_Normal.Enabled = true;
            this.FBtn_Super.Enabled = true;
         }
         if(this.FData_Chess.LocationPos == 0)
         {
            this.FBtn_Reflash.Enabled = true;
         }
         this.FMC_Man.gotoAndStop(this.FData_Chess.LocationPos + 1);
         if(this.FData_Chess.LocationPos > 0 && this.FData_Chess.LocationPos < 101 && this.FIsNotInit && this.FMC_ChessBoxs[this.FData_Chess.LocationPos - 1]["MC_Box"] != null)
         {
            this.FMC_ChessBoxs[this.FData_Chess.LocationPos - 1]["MC_Box"].play();
         }
         _loc3_ = new Vector.<uint>(1);
         this.FAwardIDs = new Vector.<uint>(1);
         _loc3_[0] = this.FHD_Chess.FinalAward[this.FData_Chess.FinalBoxIndex];
         this.FAwardIDs[0] = _loc3_[0];
         _loc2_ = new Vector.<String>(2);
         _loc2_[0] = ProcessorGetInventoriesVectByAwardID(_loc3_)[0].GetInventoryByIndex(0).Name;
         _loc2_[1] = this.FHD_Chess.FinalCost.toString();
         this.FFinalAwardInventories = new Vector.<TInventories>();
         this.FFinalAwardInventories = ProcessorGetInventoriesVectByAwardID(_loc3_);
         this.FMC_FinalBarAward["TF_Prompt_0"].text = ProcessorGetInventoriesVectByAwardID(_loc3_)[0].GetInventoryByIndex(0).Name;
         this.FMC_FinalBarAward["TF_Prompt_1"].text = this.FHD_Chess.FinalCost.toString();
         this.FSlot.Context = ProcessorGetInventoriesVectByAwardID(_loc3_)[0].GetInventoryByIndex(0);
         this.ShowBtn();
         this.FTempVec = new Vector.<int>(1);
      }
      
      override protected function UpdateUIConfig() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Vector.<uint> = null;
         super.UpdateUIConfig();
         this.FHD_Chess = FHDActivityConfig as THDChess;
         ProcessorFormatActivityTimeFromNowOn(FActivityAtoms.EndTime);
         ProcessorFormatActivityCountDown(FActivityAtoms.EndTime);
         _loc2_ = 9;
         _loc3_ = new Vector.<uint>(_loc2_);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_[_loc1_] = this.FHD_Chess.Boxes[_loc1_ * 10 + 9];
            _loc1_++;
         }
         this.FAwardInventories = ProcessorGetInventoriesVectByAwardID(_loc3_);
         this.FMC_FinalBarAward["TF_Prompt_0"].text = ProcessorGetInventoriesVectByAwardID(_loc3_)[0].GetInventoryByIndex(0).Name;
         this.FMC_FinalBarAward["TF_Prompt_1"].text = this.FHD_Chess.FinalCost.toString();
         this.FSlot.Context = ProcessorGetInventoriesVectByAwardID(_loc3_)[0].GetInventoryByIndex(0);
         this.FBtn_Hero.Visible = this.FHD_Chess.VistaIndex == 1 ? true : false;
         this.UpdateUI();
      }
      
      protected function ProcessorOnMove(param1:Object, param2:uint) : void
      {
         FHint.Caption = this.FHD_Chess.Prompt2;
         if(FOnHintOver != null)
         {
            FOnHintOver(this,FHint);
         }
      }
      
      protected function ProcessorOnOut(param1:Object, param2:uint) : void
      {
         if(FOnHintOut != null)
         {
            FOnHintOut(this,FHint);
         }
      }
      
      protected function ProcessorOnHintOut(param1:Object, param2:MouseEvent) : void
      {
         if(FOnHintOut != null)
         {
            FOnHintOut(this,FHint);
         }
      }
      
      protected function OnBtnNormalOnOver(param1:Object, param2:MouseEvent) : void
      {
         if(this.FFreeFlag[0] == 1)
         {
            FHint.Caption = this.FHD_Chess.Prompt0;
         }
         else
         {
            FHint.Caption = null;
         }
         if(FOnHintOver != null)
         {
            FOnHintOver(this,FHint);
         }
      }
      
      override protected function UpdateUI() : void
      {
         var _loc1_:Vector.<String> = null;
         var _loc2_:Vector.<uint> = null;
         _loc2_ = new Vector.<uint>(1);
         _loc2_[0] = this.FHD_Chess.FinalAward[0];
         _loc1_ = new Vector.<String>(2);
         _loc1_[0] = ProcessorGetInventoriesVectByAwardID(_loc2_)[0].GetInventoryByIndex(0).Name;
         _loc1_[1] = this.FHD_Chess.FinalCost.toString();
      }
      
      override protected function LogicsPerform() : void
      {
         if(this.FHD_Chess == null || this.FData_Chess == null)
         {
            return;
         }
         if(this.FHD_Chess != null && this.FHD_Chess.FinalAward != null)
         {
            this.FSlot.Update();
         }
         if(this.FStartTime + this.FData_Chess.CoolDown - STimingCore.ServerTick >= 0)
         {
            this.FFreeFlag[0] = 1;
            this.FTF_CoolDown.text = TUtilityString.Format("%0",TUtilityTiming.fomatTime(this.FStartTime + this.FData_Chess.CoolDown - STimingCore.ServerTick));
         }
         else
         {
            this.FFreeFlag[0] = 0;
         }
         if(this.FGlowTwo != null)
         {
            this.FGlowTwo.Run();
         }
         if(this.FGlowTwoReset != null)
         {
            this.FGlowTwoReset.Run();
         }
         if(this.FShowFinal)
         {
            this.ShowReflash();
         }
      }
      
      protected function ShowReflash() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Vector.<uint> = null;
         var _loc4_:Vector.<String> = null;
         var _loc5_:uint = 0;
         _loc3_ = new Vector.<uint>(1);
         this.FBtn_Reflash.Enabled = false;
         this.FBtn_Normal.Enabled = false;
         this.FBtn_Super.Enabled = false;
         _loc1_ = int(this.FRand.length);
         if(STimingCore.TickCount - this.FBaseTime >= 300)
         {
            ++this.FPos;
            this.FBaseTime = STimingCore.TickCount;
            _loc3_[0] = this.FHD_Chess.FinalAward[this.FRand[this.FPos]];
            this.FMC_FinalBarAward["TF_Prompt_0"].text = ProcessorGetInventoriesVectByAwardID(_loc3_)[0].GetInventoryByIndex(0).Name;
            this.FSlot.Context = ProcessorGetInventoriesVectByAwardID(_loc3_)[0].GetInventoryByIndex(0);
            if(this.FPos > 7)
            {
               this.FShowFinal = false;
               this.FMC_FinalBarAward["TF_Prompt_0"].text = ProcessorGetInventoriesVectByAwardID(this.FAwardIDs)[0].GetInventoryByIndex(0).Name;
               this.FMC_FinalBarAward["TF_Prompt_1"].text = this.FHD_Chess.FinalCost.toString();
               this.FSlot.Context = ProcessorGetInventoriesVectByAwardID(this.FAwardIDs)[0].GetInventoryByIndex(0);
               this.FBtn_Reflash.Enabled = true;
               this.FBtn_Normal.Enabled = true;
               this.FBtn_Super.Enabled = true;
            }
         }
      }
      
      protected function ChessOnMove(param1:MouseEvent) : void
      {
         var _loc2_:uint = 0;
         _loc2_ = uint(param1.currentTarget.name.split("_")[2]);
         if(FOnGiftBoxMove != null)
         {
            if(_loc2_ == 99)
            {
               FOnGiftBoxMove(this,this.FFinalAwardInventories[0]);
            }
            else
            {
               FOnGiftBoxMove(this,this.FAwardInventories[(_loc2_ + 1) / 10 - 1]);
            }
         }
      }
      
      protected function FinalOnMove(param1:MouseEvent) : void
      {
         var _loc2_:uint = 0;
         _loc2_ = uint(param1.currentTarget.name.split("_")[2]);
         if(FOnGiftBoxMove != null)
         {
            FOnGiftBoxMove(this,this.FAwardInventories[(_loc2_ + 1) / 10 - 1]);
         }
      }
      
      protected function ChessOnOut(param1:MouseEvent) : void
      {
         var _loc2_:uint = 0;
         _loc2_ = uint(param1.currentTarget.name.split("_")[2]);
         if(FOnGiftBoxOut != null)
         {
            FOnGiftBoxOut(this);
         }
      }
      
      override protected function Reset() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         if(!this.FIsInitWindow)
         {
            return;
         }
         this.FGlowTwo = null;
         _loc1_ = int(this.FAwardInventories.length);
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            this.FAwardInventories[_loc2_].Clear();
            _loc2_++;
         }
         _loc1_ = int(this.FFinalAwardInventories.length);
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            this.FFinalAwardInventories[_loc2_].Clear();
            _loc2_++;
         }
         this.FMC_NormalMoive.gotoAndStop(1);
         this.FMC_DiceOut.stop();
         this.FMC_DiceIn.stop();
         this.FMC_DiceBarInner.stop();
         this.FIsNotInit = false;
      }
      
      override protected function BtnCloseOnClick(param1:Object, param2:MouseEvent) : void
      {
         super.BtnCloseOnClick(param1,param2);
         if(FOnBtnCloseClick != null)
         {
            FOnBtnCloseClick();
         }
      }
      
      public function get OnAchieve() : Function
      {
         return this.FOnAchieve;
      }
      
      public function set OnAchieve(param1:Function) : void
      {
         this.FOnAchieve = param1;
      }
      
      public function get CurPos() : int
      {
         return this.FCurPos;
      }
      
      public function set CurPos(param1:int) : void
      {
         this.FCurPos = param1;
      }
      
      public function get LastPos() : int
      {
         return this.FLastPos;
      }
      
      public function set LastPos(param1:int) : void
      {
         this.FLastPos = param1;
      }
      
      public function PlayDice(param1:uint) : void
      {
         this.FCurPos = param1;
         if(param1 == 0)
         {
            this.FLastPos = 0;
            return;
         }
         this.FMC_NormalMoive["MC_DiceNum"].gotoAndStop(this.FCurPos - this.FLastPos);
         this.FMC_NormalMoive.gotoAndPlay(1);
         this.FLastPos = this.FData_Chess.LocationPos;
      }
      
      public function QueryMonsterCoordinate(param1:TQueryCoordinate) : void
      {
         var _loc2_:TCoordinate = null;
         var _loc3_:Sprite = null;
         if(this.FLastPos > 99)
         {
            this.FLastPos = 99;
         }
         _loc3_ = this.FMC_ChessBoxs[this.FLastPos - 1];
         if(_loc3_ != null)
         {
            _loc2_ = TUtilityCartisian.GetScreenCoordinateByDisplayObject(_loc3_);
            _loc2_.X -= _loc3_.width / 3;
            _loc2_.Y -= _loc3_.height / 3;
            param1.Value.Assign(_loc2_);
         }
      }
   }
}

