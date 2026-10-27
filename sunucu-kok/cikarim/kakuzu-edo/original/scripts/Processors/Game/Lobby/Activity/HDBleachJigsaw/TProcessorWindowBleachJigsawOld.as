package Processors.Game.Lobby.Activity.HDBleachJigsaw
{
   import Components.ScrollBar.*;
   import Components.Slots.*;
   import Components.Standard.*;
   import Foundation.Common.*;
   import Foundation.Queries.*;
   import Foundation.Queries.Textures.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Bins.*;
   import Foundation.Resources.Repositories.*;
   import Foundation.Resources.Textures.*;
   import Foundation.Timing.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.DatebaseVO.VO.Json.*;
   import Logics.HDActivityMode.*;
   import Logics.HDActivityOS.*;
   import Logics.HDBleachJigsaw.*;
   import Logics.Inventories.*;
   import Logics.Streamization.Inventories.*;
   import Processors.Game.Common.Effects.Display.*;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDSingleWindowBase;
   import Processors.Game.Lobby.Activity.HDBleachJigsaw.Component.TUIAwardItem;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Utilities.*;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Resources.Constants.*;
   import Utilities.Timing.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class TProcessorWindowBleachJigsawOld extends TProcessorHDSingleWindowBase
   {
      
      public static const COUNT_FINALAWARD:uint = 6;
      
      public static const COUNT_JIGSAW:uint = 25;
      
      public static const Activity_CanNotReceive:int = CONST_ACTIVITY_MODE.Activity_CanNotReceive;
      
      public static const Activity_AlreadyReceive:int = CONST_ACTIVITY_MODE.Activity_AlreadyReceive;
      
      public static const Activity_CanReceive:int = CONST_ACTIVITY_MODE.Activity_CanReceive;
      
      protected static const TYPE_StartTime:uint = 0;
      
      protected static const TYPE_EndTime:uint = 1;
      
      protected var FBtn_close:TUIButton;
      
      protected var FMC_HDDesc:Sprite;
      
      protected var FMC_Jigsaw:Sprite;
      
      protected var FTF_FreeCD:TextField;
      
      protected var FBtn_NormalOpen:TUIButton;
      
      protected var FBtn_LuckyOpen:TUIButton;
      
      protected var FBtn_AllOpen:TUIButton;
      
      protected var FMC_ScollBar:TScrollBar;
      
      protected var FMC_Bar:MovieClip;
      
      protected var FMC_FinalAwardsVec:Vector.<TUISlot>;
      
      protected var FBtn_GetAward:TUIButton;
      
      protected var FMC_AwardBar:Vector.<TUIAwardItem>;
      
      protected var FMC_AllGet:MovieClip;
      
      protected var FMC_JigsawSlot:Vector.<Sprite>;
      
      protected var FIsShowOneGet:Boolean;
      
      protected var FCurStatus:uint;
      
      protected var FBarStatus:uint;
      
      protected var FFreeFlag:Vector.<int>;
      
      protected var FStartTime:uint;
      
      protected var FCurPos:int;
      
      protected var FLastalpha:uint;
      
      protected var FIsSingleGet:Boolean;
      
      protected var FRandVec:Vector.<uint>;
      
      protected var FGlowTwo:TEffectBaseGlowTwo;
      
      protected var FTF_Score:TextField;
      
      protected var FMC_AlreadyGet:Sprite;
      
      protected var FIsInitWindow:Boolean;
      
      protected var FData:TActivityBleachJigsaw;
      
      protected var FHD_BleachJigsaw:THDBleachJigSaw;
      
      protected var FAwardInventories:Vector.<TInventories>;
      
      protected var FAwardNeedInventories:Vector.<TInventories>;
      
      protected var FOnQuerySequenceContext:Function;
      
      public function TProcessorWindowBleachJigsawOld(param1:TUIComponent)
      {
         super(param1);
         FSceneResourceName = "MC_BleachJigsaw";
         FActivityID = CONST_ACTIVITY_MODE.Activity_BleachJigsaw;
         this.FFreeFlag = new Vector.<int>(1);
         this.FIsInitWindow = false;
      }
      
      override public function InitWindow(param1:Sprite = null) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TUISlot = null;
         super.InitWindow(param1);
         this.FMC_HDDesc = FScene["MC_HDDesc"];
         this.FMC_HDDesc.addEventListener(MouseEvent.MOUSE_MOVE,this.OnDescOnOver);
         this.FMC_HDDesc.addEventListener(MouseEvent.MOUSE_OUT,this.OnDescOut);
         FTF_OpenTime = FScene["TF_OpenTime"];
         FTF_CoolingTime = FScene["TF_CoolingTime"];
         this.FMC_Jigsaw = FScene["MC_Jigsaw"];
         this.FMC_AllGet = this.FMC_Jigsaw["MC_AllGet"];
         this.FTF_Score = FScene["MC_ScoreTip"]["TF_Score"];
         this.FMC_AlreadyGet = FScene["MC_AlreadyGet"];
         this.FMC_JigsawSlot = new Vector.<Sprite>(COUNT_JIGSAW);
         _loc3_ = int(COUNT_JIGSAW);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FMC_JigsawSlot[_loc2_] = this.FMC_Jigsaw["MC_Slot_" + _loc2_];
            _loc2_++;
         }
         this.FTF_FreeCD = FScene["TF_FreeCD"];
         this.FBtn_NormalOpen = new TUIButton();
         this.FBtn_NormalOpen.Substrate = FScene["Btn_NormalOpen"];
         this.FBtn_NormalOpen.OnClick = this.NormalOpenOnClick;
         this.FBtn_NormalOpen.OnMove = this.OnBtnNormalOnOver;
         this.FBtn_NormalOpen.OnOut = this.ProcessorOnHintOut;
         this.FBtn_LuckyOpen = new TUIButton();
         this.FBtn_LuckyOpen.Substrate = FScene["Btn_LuckyOpen"];
         this.FBtn_LuckyOpen.OnClick = this.LuckyOpenOnClick;
         this.FBtn_LuckyOpen.OnMove = this.OnBtnLuckyOnOver;
         this.FBtn_LuckyOpen.OnOut = this.ProcessorOnHintOut;
         this.FBtn_AllOpen = new TUIButton();
         this.FBtn_AllOpen.Substrate = FScene["Btn_AllOpen"];
         this.FBtn_AllOpen.OnClick = this.AllOpenOnClick;
         this.FBtn_AllOpen.OnMove = this.OnBtnAllGetOnOver;
         this.FBtn_AllOpen.OnOut = this.ProcessorOnHintOut;
         this.FMC_ScollBar = new TScrollBar(FScene["MC_ScollBar"],300,false,0,60);
         this.FMC_ScollBar.Visible = false;
         this.FMC_Bar = FScene["MC_Bar"];
         this.FMC_FinalAwardsVec = new Vector.<TUISlot>(COUNT_FINALAWARD);
         _loc3_ = int(COUNT_FINALAWARD);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = new TUISlot(this);
            _loc4_.Resource = FScene["MC_Slot_" + _loc2_];
            _loc4_.SequenceDefaultIcon = SResourcesCore.TexturesLobby.GetAnimationSequenceByIdentifiers(CONST_LOBBY.RESOURCESID_Texture_SlotDefaultEffect,0);
            _loc4_.OnQuerySequenceContext = SlotsOnQuerySequenceContext;
            _loc4_.OnOver = ProcessorOnSlotOver;
            _loc4_.OnOut = ProcessorOnSlotOut;
            _loc4_.OnQuerySubscript = SlotsOnQuerySubscript;
            _loc4_.Init();
            this.FMC_FinalAwardsVec[_loc2_] = _loc4_;
            _loc2_++;
         }
         this.FBtn_GetAward = new TUIButton();
         this.FBtn_GetAward.Substrate = FScene["Btn_GetAward"];
         this.FBtn_GetAward.OnClick = this.GetAwardOnClick;
         this.FBtn_GetAward.OnMove = this.OnBtnFinalGetOnOver;
         this.FBtn_GetAward.OnOut = this.ProcessorOnHintOut;
         this.FStartTime = STimingCore.ServerTick;
         this.FIsInitWindow = true;
      }
      
      override protected function UpdateDataBase(param1:TActivityOSBase) : void
      {
         var _loc2_:int = 0;
         var _loc3_:uint = 0;
         super.UpdateDataBase(param1);
         this.FBarStatus = 1;
         this.FData = param1 as TActivityBleachJigsaw;
         _loc3_ = this.FHD_BleachJigsaw.JigSawNeedsVec.length;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FMC_AwardBar[_loc2_].UpdateNum(this.FData.JigSawItemsVec);
            _loc2_++;
         }
         _loc3_ = COUNT_JIGSAW;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(this.FData.JigSawItemsVec[_loc2_].IsHad != 0)
            {
               ++this.FBarStatus;
            }
            _loc2_++;
         }
         this.FMC_Bar["MC_Bar"].gotoAndStop(this.FBarStatus);
         this.FTF_Score.text = (COUNT_JIGSAW - this.FBarStatus + 1).toString();
         if(this.FData.JigSawFinalStatus != Activity_CanReceive || this.FBarStatus < COUNT_JIGSAW)
         {
            if(this.FGlowTwo != null)
            {
               this.FGlowTwo.Stop();
               this.FGlowTwo = null;
            }
            this.FBtn_GetAward.Enabled = false;
         }
         else
         {
            this.FGlowTwo = new TEffectBaseGlowTwo();
            this.FGlowTwo.SetParameters(this.FMC_Bar["MC_Bar"],16711680,20,2);
            this.FBtn_GetAward.Enabled = true;
         }
         if(this.FData.JigSawFinalStatus != Activity_CanNotReceive)
         {
            FScene["MC_ScoreTip"].visible = false;
         }
         this.UpdateData();
         if(this.FData.JigSawFinalStatus == Activity_AlreadyReceive)
         {
            this.FMC_AlreadyGet.visible = true;
            this.FBtn_GetAward.Visible = false;
         }
         else
         {
            this.FMC_AlreadyGet.visible = false;
            this.FBtn_GetAward.Visible = true;
         }
      }
      
      override protected function UpdateUIConfig() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Vector.<uint> = null;
         var _loc4_:Sprite = null;
         var _loc5_:TUIAwardItem = null;
         super.UpdateUIConfig();
         this.FHD_BleachJigsaw = FHDActivityConfig as THDBleachJigSaw;
         if(!this.FMC_ScollBar.Visible)
         {
            _loc2_ = int(this.FHD_BleachJigsaw.JigSawNeedsVec.length);
            this.FMC_AwardBar = new Vector.<TUIAwardItem>(_loc2_);
            this.FMC_ScollBar.Clear();
            _loc1_ = 0;
            while(_loc1_ < _loc2_)
            {
               _loc5_ = new TUIAwardItem(this);
               _loc5_.OnQuerySequenceContext = SlotsOnQuerySequenceContext;
               _loc5_.OnSlotOver = this.ShowTipOnMove;
               _loc5_.OnSlotOut = this.HideTipOnOut;
               _loc5_.OnBtnOkClick = this.BtnOKOnClick;
               _loc5_.OnBtnOkMove = OnHintOver;
               _loc5_.OnBtnOkOut = OnHintOut;
               _loc5_.OnEffectText = FOnEffectText;
               _loc5_.OnQuerySubscript = SlotsOnQuerySubscript;
               _loc4_ = TUtilityReflection.CreateDisplayObjectInstance("MC_JigsawAward") as Sprite;
               _loc5_.Perform_UIDispatch(_loc4_);
               this.FMC_AwardBar[_loc1_] = _loc5_;
               this.FMC_ScollBar.AddItem(_loc5_);
               _loc1_++;
            }
            this.FMC_ScollBar.Visible = true;
         }
         _loc2_ = int(this.FHD_BleachJigsaw.JigSawFinalAwardVec.length);
         _loc3_ = new Vector.<uint>(_loc2_);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_[_loc1_] = this.FHD_BleachJigsaw.JigSawFinalAwardVec[_loc1_].Award;
            _loc1_++;
         }
         this.FAwardInventories = ProcessorGetInventoriesVectByAwardID(_loc3_);
         _loc2_ = this.FAwardInventories[0].Count;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FMC_FinalAwardsVec[_loc1_].Context = this.FAwardInventories[0].GetInventoryByIndex(_loc1_);
            this.FMC_FinalAwardsVec[_loc1_].Update();
            _loc1_++;
         }
         _loc2_ = int(this.FHD_BleachJigsaw.JigSawNeedsVec.length);
         _loc3_ = new Vector.<uint>(_loc2_);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_[_loc1_] = this.FHD_BleachJigsaw.JigSawNeedsVec[_loc1_][0].Award;
            _loc1_++;
         }
         this.FAwardNeedInventories = ProcessorGetInventoriesVectByAwardID(_loc3_);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FMC_AwardBar[_loc1_].UpdateUI(_loc1_,this.FAwardNeedInventories[_loc1_].GetInventoryByIndex(0),this.FHD_BleachJigsaw.JigSawNeedsVec[_loc1_]);
            _loc1_++;
         }
         _loc2_ = int(this.FHD_BleachJigsaw.JigSawItemsVec.length);
         _loc3_ = new Vector.<uint>(_loc2_);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_[_loc1_] = this.FHD_BleachJigsaw.JigSawItemsVec[_loc1_].Award;
            _loc1_++;
         }
         this.FAwardInventories = ProcessorGetInventoriesVectByAwardID(_loc3_);
         _loc2_ = int(COUNT_JIGSAW);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FMC_Jigsaw["MC_ShowTip_" + _loc1_].addEventListener(MouseEvent.MOUSE_MOVE,this.JigsawOnMove);
            this.FMC_Jigsaw["MC_ShowTip_" + _loc1_].addEventListener(MouseEvent.MOUSE_OUT,this.JigsawOnOut);
            this.FMC_Jigsaw["MC_ShowTip_" + _loc1_].alpha = 0;
            _loc1_++;
         }
         ProcessorFormatActivityDesc();
         ProcessorFormatActivityTimeFromNowOn(FActivityAtoms.EndTime);
         ProcessorFormatActivityCountDown(FActivityAtoms.EndTime);
      }
      
      override protected function LogicsPerform() : void
      {
         var _loc1_:int = 0;
         var _loc2_:uint = 0;
         super.LogicsPerform();
         if(FHDActivityConfig == null && this.FData == null)
         {
            return;
         }
         if(this.FGlowTwo != null)
         {
            this.FGlowTwo.Run();
         }
         if(this.FIsShowOneGet == true && this.FCurPos != -1 && this.FIsSingleGet == true)
         {
            this.ShowOneGet();
         }
         _loc2_ = this.FMC_FinalAwardsVec.length;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FMC_FinalAwardsVec[_loc1_].Update();
            _loc1_++;
         }
         if(this.FStartTime + this.FData.JigSawCoolDown - STimingCore.ServerTick >= 0)
         {
            this.FFreeFlag[0] = 1;
            this.FTF_FreeCD.text = TUtilityString.Format("%0",TUtilityTiming.fomatTime(this.FStartTime + this.FData.JigSawCoolDown - STimingCore.ServerTick));
         }
         else
         {
            this.FFreeFlag[0] = 0;
         }
      }
      
      protected function ShowAllGet() : void
      {
         this.FMC_AllGet.play();
      }
      
      protected function ShowTipOnMove(param1:Object, param2:uint) : void
      {
         if(FOnGiftBoxMove != null)
         {
            FOnGiftBoxMove(this,this.FAwardNeedInventories[param2]);
         }
      }
      
      protected function HideTipOnOut(param1:Object) : void
      {
         if(FOnGiftBoxOut != null)
         {
            FOnGiftBoxOut(this);
         }
      }
      
      protected function UpdateData() : void
      {
         var _loc1_:int = 0;
         var _loc2_:uint = 0;
         this.FBtn_LuckyOpen.Enabled = false;
         if(this.FIsShowOneGet == false || this.FIsSingleGet == false)
         {
            _loc2_ = COUNT_JIGSAW;
            _loc1_ = 0;
            while(_loc1_ < _loc2_)
            {
               if(this.FData.JigSawItemsVec[_loc1_].Num > 0)
               {
                  this.FMC_JigsawSlot[_loc1_]["TF_Prompt"].text = "x" + this.FData.JigSawItemsVec[_loc1_].Num.toString();
                  this.FMC_JigsawSlot[_loc1_].alpha = 1;
               }
               else
               {
                  this.FMC_JigsawSlot[_loc1_]["TF_Prompt"].text = "";
                  this.FMC_JigsawSlot[_loc1_].alpha = 0;
               }
               _loc1_++;
            }
            _loc2_ = COUNT_JIGSAW;
            _loc1_ = 0;
            while(_loc1_ < _loc2_)
            {
               if(this.FData.JigSawItemsVec[_loc1_].Num == 0)
               {
                  this.FBtn_LuckyOpen.Enabled = true;
                  this.FMC_JigsawSlot[_loc1_].alpha = 0;
               }
               else
               {
                  this.FMC_JigsawSlot[_loc1_].alpha = 1;
               }
               _loc1_++;
            }
         }
      }
      
      protected function ShowOneGet() : void
      {
         var _loc1_:MovieClip = null;
         var _loc2_:int = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         this.FIsShowOneGet = true;
         _loc1_ = this.FMC_JigsawSlot[this.FRandVec[this.FCurStatus]]["MC_Mask"]["MC_Border"] as MovieClip;
         this.FMC_JigsawSlot[this.FRandVec[this.FCurStatus]].alpha = 1;
         _loc1_.play();
         if(_loc1_.currentFrame == _loc1_.totalFrames && this.FCurStatus < this.FRandVec.length)
         {
            _loc3_ = COUNT_JIGSAW;
            _loc2_ = 0;
            while(_loc2_ < _loc3_)
            {
               if(this.FData.JigSawItemsVec[_loc2_].Num == 0)
               {
                  this.FMC_JigsawSlot[_loc2_].alpha = 0;
               }
               else
               {
                  this.FMC_JigsawSlot[this.FCurPos].alpha = this.FLastalpha;
               }
               _loc2_++;
            }
            this.FMC_JigsawSlot[this.FCurPos].alpha = this.FLastalpha;
            ++this.FCurStatus;
            _loc1_.gotoAndStop(0);
         }
         if(this.FCurStatus == this.FRandVec.length - 1)
         {
            this.FIsShowOneGet = false;
            this.UpdateData();
            this.FCurStatus = 0;
            _loc1_ = this.FMC_JigsawSlot[this.FCurPos]["MC_Mask"]["MC_Border"] as MovieClip;
            _loc1_.gotoAndPlay(1);
            _loc1_ = this.FMC_JigsawSlot[this.FCurPos]["MC_Mask"]["MC_Get"] as MovieClip;
            _loc1_.gotoAndPlay(1);
         }
      }
      
      protected function FlyText(param1:int) : void
      {
         var _loc2_:String = null;
         _loc2_ = TUtilityLobby.GetStringByIdentifier(param1);
         EffectGenerateText(_loc2_);
      }
      
      override protected function Reset() : void
      {
         var _loc1_:int = 0;
         var _loc2_:uint = 0;
         if(!this.FIsInitWindow)
         {
            return;
         }
         this.FIsShowOneGet = false;
         this.FCurPos = -1;
         this.FTF_Score.text = "";
         this.FGlowTwo = null;
         _loc2_ = this.FMC_AwardBar.length;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FMC_AwardBar[_loc1_].Reset();
            _loc1_++;
         }
      }
      
      protected function NormalOpenRequest(param1:Object, param2:Boolean = true) : void
      {
         var _loc3_:int = 0;
         var _loc4_:uint = 0;
         this.FRandVec = new Vector.<uint>();
         this.FCurStatus = 0;
         this.FIsSingleGet = true;
         if(param2)
         {
            if(SLogicsCore.Character.CreditGold < this.FData.JigSawBtnVec[0].Cost)
            {
               if(FOnEffectText != null)
               {
                  FOnEffectText(this,TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ORGANIZATION_STRING_59));
               }
               return;
            }
         }
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FHD_BleachJigsaw.JigSawBtnVec[0].Index,0,this.FFreeFlag);
         _loc4_ = COUNT_JIGSAW - 15;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            this.FRandVec.push(uint(COUNT_JIGSAW * Math.random()));
            _loc3_++;
         }
      }
      
      protected function LuckyOpenRequest(param1:Object) : void
      {
         var _loc2_:int = 0;
         var _loc3_:uint = 0;
         if(SLogicsCore.Character.CreditGold < this.FData.JigSawBtnVec[1].Cost)
         {
            if(FOnEffectText != null)
            {
               FOnEffectText(this,TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ORGANIZATION_STRING_59));
            }
            return;
         }
         this.FIsSingleGet = true;
         this.FCurStatus = 0;
         this.FRandVec = new Vector.<uint>();
         _loc3_ = COUNT_JIGSAW;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(this.FData.JigSawItemsVec[_loc2_].Num == 0)
            {
               this.FRandVec.push(_loc2_);
            }
            _loc2_++;
         }
         this.FIsSingleGet = true;
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FHD_BleachJigsaw.JigSawBtnVec[1].Index);
      }
      
      protected function AllOpenRequest(param1:Object) : void
      {
         this.FIsSingleGet = false;
         if(SLogicsCore.Character.CreditGold < this.FData.JigSawBtnVec[2].Cost)
         {
            if(FOnEffectText != null)
            {
               FOnEffectText(this,TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ORGANIZATION_STRING_59));
            }
            return;
         }
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FHD_BleachJigsaw.JigSawBtnVec[2].Index);
         this.ShowAllGet();
      }
      
      override protected function BtnOKOnClick(param1:Object, param2:uint) : void
      {
         this.FIsSingleGet = false;
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,param2);
      }
      
      protected function NormalOpenOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FFreeFlag[0] == 0)
         {
            this.FStartTime = STimingCore.ServerTick;
            this.NormalOpenRequest(this,false);
         }
         else
         {
            SUtilityOverLayer.UIWindowConfirmation.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_06),this.FData.JigSawBtnVec[0].Cost);
            SUtilityOverLayer.UIWindowConfirmation.OnOK = this.NormalOpenRequest;
            SUtilityOverLayer.UIWindowConfirmation.Visible = true;
         }
      }
      
      protected function LuckyOpenOnClick(param1:Object, param2:MouseEvent) : void
      {
         SUtilityOverLayer.UIWindowConfirmation.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_06),this.FData.JigSawBtnVec[1].Cost);
         SUtilityOverLayer.UIWindowConfirmation.OnOK = this.LuckyOpenRequest;
         SUtilityOverLayer.UIWindowConfirmation.Visible = true;
      }
      
      protected function AllOpenOnClick(param1:Object, param2:MouseEvent) : void
      {
         SUtilityOverLayer.UIWindowConfirmation.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_06),this.FData.JigSawBtnVec[2].Cost);
         SUtilityOverLayer.UIWindowConfirmation.OnOK = this.AllOpenRequest;
         SUtilityOverLayer.UIWindowConfirmation.Visible = true;
      }
      
      protected function GetAwardOnClick(param1:Object, param2:MouseEvent) : void
      {
         this.FIsSingleGet = false;
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,COUNT_JIGSAW);
      }
      
      override protected function BtnCloseOnClick(param1:Object, param2:MouseEvent) : void
      {
         super.BtnCloseOnClick(param1,param2);
         if(FOnBtnCloseClick != null)
         {
            FOnBtnCloseClick();
         }
      }
      
      protected function OnBtnNormalOnOver(param1:Object, param2:MouseEvent) : void
      {
         if(this.FFreeFlag[0] == 1)
         {
            FHint.Caption = this.FHD_BleachJigsaw.JigSawBtnVec[0].Prompt;
         }
         else
         {
            FHint.Caption = this.FHD_BleachJigsaw.JigSawBtnVec[0].Prompt2;
         }
         if(FOnHintOver != null)
         {
            FOnHintOver(this,FHint);
         }
      }
      
      protected function OnBtnLuckyOnOver(param1:Object, param2:MouseEvent) : void
      {
         FHint.Caption = this.FHD_BleachJigsaw.JigSawBtnVec[1].Prompt;
         if(FOnHintOver != null)
         {
            FOnHintOver(this,FHint);
         }
      }
      
      protected function OnBtnAllGetOnOver(param1:Object, param2:MouseEvent) : void
      {
         FHint.Caption = this.FHD_BleachJigsaw.JigSawBtnVec[2].Prompt;
         if(FOnHintOver != null)
         {
            FOnHintOver(this,FHint);
         }
      }
      
      protected function OnBtnFinalGetOnOver(param1:Object, param2:MouseEvent) : void
      {
      }
      
      protected function ProcessorOnHintOut(param1:Object, param2:MouseEvent) : void
      {
         if(FOnHintOut != null)
         {
            FOnHintOut(this,FHint);
         }
      }
      
      protected function OnDescOnOver(param1:MouseEvent) : void
      {
         FHint.Caption = this.FHD_BleachJigsaw.Desc;
         if(FOnHintOver != null)
         {
            FOnHintOver(this,FHint);
         }
      }
      
      protected function OnDescOut(param1:MouseEvent) : void
      {
         if(FOnHintOut != null)
         {
            FOnHintOut(this,FHint);
         }
      }
      
      protected function JigsawOnMove(param1:MouseEvent) : void
      {
         var _loc2_:uint = 0;
         _loc2_ = uint(param1.currentTarget.name.split("_")[2]);
         if(FOnGiftBoxMove != null)
         {
            FOnGiftBoxMove(this,this.FAwardInventories[_loc2_]);
         }
      }
      
      protected function JigsawOnOut(param1:MouseEvent) : void
      {
         var _loc2_:uint = 0;
         _loc2_ = uint(param1.currentTarget.name.split("_")[2]);
         if(FOnGiftBoxOut != null)
         {
            FOnGiftBoxOut(this);
         }
      }
      
      public function get OnQuerySequenceContext() : Function
      {
         return this.FOnQuerySequenceContext;
      }
      
      public function set OnQuerySequenceContext(param1:Function) : void
      {
         this.FOnQuerySequenceContext = param1;
      }
      
      public function SetCurPos(param1:uint) : void
      {
         this.FCurPos = param1;
         this.FLastalpha = this.FMC_JigsawSlot[this.FCurPos].alpha;
         this.FIsShowOneGet = true;
      }
   }
}

