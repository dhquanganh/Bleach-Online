package Processors.Game.Lobby.Activity.HDNewYearSheep.HDWindow
{
   import Components.Standard.TUIButton;
   import Foundation.Resources.SResourcesCore;
   import Foundation.Resources.Textures.TAnimationSequence;
   import Foundation.Resources.Textures.TTexture;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityString;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDNewYearSheep.PetYearVO.TPetYearChipGiftBoxVO;
   import Logics.HDNewYearSheep.PetYearVO.TPetYearTaskVO;
   import Logics.HDNewYearSheep.TPetYearData;
   import Logics.Pet.TVicePet;
   import Logics.SLogicsCore;
   import Logics.Unlocks.TUnlock;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDSingleWindowBase;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Processors.Game.Utilities.HyperLink.SUtilityHyperLink;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Rendering.Overlayers.HDGiftBox.TOverlayerGiftBox;
   import Resources.Constants.CONST_FUNCTIONSWITCH;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class TProcessorPetYearView extends TProcessorHDSingleWindowBase
   {
      
      protected const MoveFrame:uint = 2;
      
      protected const OutFrame:uint = 1;
      
      protected const ReceiveFrame:uint = 4;
      
      protected const RankOnFrame:int = 2;
      
      protected const RankOffFrame:int = 1;
      
      protected var FData:TPetYearData;
      
      protected var FLoginBoxBtn:TUIButton;
      
      protected var FLinkBtns:Vector.<TUIButton>;
      
      protected var FVicePetReceiveBtn:TUIButton;
      
      protected var FVicePetFeedBtn:TUIButton;
      
      protected var FChipBoxBtns:Vector.<TUIButton>;
      
      protected var FPetBmp:Bitmap;
      
      protected var FCurChipBtnTag:int;
      
      protected var FCurOverPetData:TVicePet;
      
      protected var FTaskBoxBtn:Vector.<TUIButton>;
      
      protected var FCurRankIndex:int;
      
      public function TProcessorPetYearView(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function Reset() : void
      {
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
         var _loc2_:int = 0;
         var _loc3_:TUIButton = null;
         var _loc4_:TPetYearChipGiftBoxVO = null;
         var _loc5_:TPetYearTaskVO = null;
         var _loc6_:TextField = null;
         var _loc7_:TextField = null;
         var _loc8_:MovieClip = null;
         var _loc9_:MovieClip = null;
         var _loc10_:Object = null;
         var _loc11_:Object = null;
         var _loc12_:int = 0;
         this.FData = param1 as TPetYearData;
         _loc9_ = FScene["MC_Login"];
         _loc8_ = _loc9_.MC_Box;
         _loc8_.gotoAndStop(this.FData.LoginGiftBoxState == Activity_AlreadyReceive ? this.ReceiveFrame : _loc8_.currentFrame);
         _loc8_ = _loc9_.MC_ReciveFlag;
         _loc8_.visible = this.FData.LoginGiftBoxState == Activity_AlreadyReceive;
         this.FLoginBoxBtn.Enabled = !_loc8_.visible;
         _loc2_ = 0;
         while(_loc2_ < TPetYearData.TaskCount)
         {
            _loc5_ = this.FData.TaskVOs[_loc2_];
            _loc10_ = this.FData.Config.Task[_loc2_];
            _loc11_ = this.FData.Config.Language.taskDesc[_loc2_];
            _loc12_ = int(_loc10_.condition[0].value);
            _loc9_ = FScene["MC_Task_" + _loc2_];
            _loc3_ = this.FTaskBoxBtn[_loc2_];
            _loc3_.Enabled = _loc5_.Progress != Activity_AlreadyReceive && _loc5_.Progress >= _loc12_;
            _loc8_ = _loc9_.MC_ReceiveFlag;
            _loc8_.visible = _loc5_.Progress == Activity_AlreadyReceive;
            _loc8_ = _loc9_.MC_FinishFlag;
            _loc8_.visible = _loc5_.Progress == Activity_AlreadyReceive || _loc5_.Progress >= _loc12_;
            _loc6_ = _loc9_.TF_DeskName;
            _loc6_.text = _loc11_.name;
            _loc6_ = _loc9_.TF_DeskProg;
            _loc6_.text = TUtilityString.Format(_loc11_.prog,_loc5_.Progress == Activity_AlreadyReceive ? _loc12_ : _loc5_.Progress,_loc12_);
            _loc2_++;
         }
         _loc9_ = FScene["MC_PetMask"];
         if(this.FData.VicePetVO.State == Activity_AlreadyReceive)
         {
            _loc9_.visible = false;
            SResourcesCore.TexturesLargeIcon.LoadAutoSecondary(this.FData.VicePetVO.ResourceID,this.AutoLoadCallBack);
            _loc6_ = FScene["TF_CurChipCount"];
            _loc6_.text = this.FData.ChipCount.toString();
            _loc6_ = FScene["TF_NextRankInfo"];
            if(this.FCurRankIndex == -1)
            {
               _loc6_.text = this.FData.VicePetVO.NextRankInfo;
            }
            else
            {
               _loc6_.text = this.FData.GetRankInfo(this.FCurRankIndex);
            }
            _loc6_ = FScene["TF_Level"];
            _loc6_.text = this.FData.VicePetVO.Level;
            _loc6_ = FScene["TF_Name"];
            _loc6_.text = this.FData.VicePetVO.Name;
         }
         else
         {
            _loc9_.visible = true;
         }
         _loc2_ = 0;
         while(_loc2_ < TPetYearData.RankCount)
         {
            _loc9_ = FScene["MC_Rank_" + _loc2_];
            _loc8_ = _loc9_.MC_Over;
            _loc8_.visible = false;
            _loc2_++;
         }
         if(this.FData.VicePetVO.State == Activity_AlreadyReceive && this.FData.VicePetVO.IsExist)
         {
            _loc9_ = FScene["MC_Rank_" + this.FData.VicePetVO.CurRank];
            _loc8_ = _loc9_.MC_Over;
            _loc8_.visible = true;
         }
         _loc2_ = 0;
         while(_loc2_ < TPetYearData.BoxCount)
         {
            _loc9_ = FScene["MC_Box_" + _loc2_];
            _loc6_ = _loc9_.TF_Cost;
            _loc6_.text = this.FData.ChipGiftBoxVOs[_loc2_].Cost.toString();
            _loc2_++;
         }
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(!this.Visible)
         {
            return;
         }
      }
      
      protected function LoginBoxBtnOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TUIButton = null;
         _loc3_ = param1 as TUIButton;
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FData.Config.FreeAward.index);
      }
      
      protected function LinkBtnOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TUIButton = null;
         _loc3_ = param1 as TUIButton;
         SUtilityHyperLink.ShortcutHyperlink(this.FData.Config.Link.task[_loc3_.Tag]);
      }
      
      protected function VicePetReceiveBtnOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TUnlock = null;
         _loc3_ = SLogicsCore.Unlocks.GetUnlockByIdentifier(CONST_FUNCTIONSWITCH.UNLOCK_Pet);
         if(_loc3_ != null && _loc3_.State == TUnlock.UNLOCKSTATE_Unlocked)
         {
            Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FData.Config.VicePet.index);
         }
         else
         {
            SToolReward.ShowMessage(this.FData.Config.Language.petLock);
         }
      }
      
      protected function VicePetFeedBtnOnClick(param1:Object, param2:MouseEvent) : void
      {
         SUtilityHyperLink.ShortcutHyperlink(this.FData.Config.Link.pet);
      }
      
      protected function ChipBoxBtnOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TUIButton = null;
         var _loc4_:uint = 0;
         _loc3_ = param1 as TUIButton;
         this.FCurChipBtnTag = _loc3_.Tag;
         _loc4_ = uint(this.FData.Config.ChipBox[this.FCurChipBtnTag].cost);
         if(_loc4_ <= SLogicsCore.Character.CreditGold)
         {
            FUIWindowConfirmation.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_06),_loc4_);
            FUIWindowConfirmation.OnOK = this.ChipBoxBtnOnClickOK;
            FUIWindowConfirmation.Visible = true;
         }
         else
         {
            FUIWindowRecharge.SetGoldNum(_loc4_);
            FUIWindowRecharge.Visible = true;
         }
      }
      
      protected function TaskBoxBtnOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TUIButton = null;
         _loc3_ = param1 as TUIButton;
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FData.Config.Task[_loc3_.Tag].index);
      }
      
      protected function LoginBoxOnMove(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:MovieClip = null;
         ProcessorOnGiftBoxMove(this,this.FData.LoginGiftBoxInventories,TOverlayerGiftBox.TYPE_ALL);
         _loc3_ = FScene["MC_Login"];
         _loc2_ = _loc3_.MC_Box;
         if(_loc2_.currentFrame != this.ReceiveFrame)
         {
            _loc2_.gotoAndStop(this.MoveFrame);
         }
      }
      
      protected function LoginBoxOnOut(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:MovieClip = null;
         ProcessorOnGiftBoxOut(this);
         _loc3_ = FScene["MC_Login"];
         _loc2_ = _loc3_.MC_Box;
         if(_loc2_.currentFrame != this.ReceiveFrame)
         {
            _loc2_.gotoAndStop(this.OutFrame);
         }
      }
      
      protected function TaskBoxBtnOnMove(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TUIButton = null;
         var _loc4_:int = 0;
         _loc3_ = param1 as TUIButton;
         _loc4_ = _loc3_.Tag;
         ProcessorOnGiftBoxMove(this,this.FData.TaskVOs[_loc4_].Inventories,TOverlayerGiftBox.TYPE_ALL);
      }
      
      protected function TaskBoxBtnOnOut(param1:Object, param2:MouseEvent) : void
      {
         ProcessorOnGiftBoxOut(this);
      }
      
      protected function ChipBoxOnMove(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:MovieClip = null;
         var _loc4_:int = 0;
         _loc4_ = int(param1.currentTarget.Tag);
         ProcessorOnGiftBoxMove(this,this.FData.ChipGiftBoxVOs[_loc4_].Inventories,TOverlayerGiftBox.TYPE_ALL);
         _loc3_ = FScene["MC_Box_" + _loc4_];
         _loc2_ = _loc3_.MC_Box;
         if(_loc2_.currentFrame != this.ReceiveFrame)
         {
            _loc2_.gotoAndStop(this.MoveFrame);
         }
      }
      
      protected function ChipBoxOnOut(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:MovieClip = null;
         var _loc4_:int = 0;
         _loc4_ = int(param1.currentTarget.Tag);
         ProcessorOnGiftBoxOut(this);
         _loc3_ = FScene["MC_Box_" + _loc4_];
         _loc2_ = _loc3_.MC_Box;
         if(_loc2_.currentFrame != this.ReceiveFrame)
         {
            _loc2_.gotoAndStop(this.OutFrame);
         }
      }
      
      protected function RankMcOnMove(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:int = 0;
         _loc3_ = int(param1.currentTarget.Tag);
         this.FCurOverPetData = this.FData.PetRankDatas[_loc3_];
         SUtilityOverLayer.UIComponentsHintOnOver(this,this.FCurOverPetData);
      }
      
      protected function RankMcOnOut(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:int = 0;
         _loc3_ = int(param1.currentTarget.Tag);
         SUtilityOverLayer.UIComponentsHintOnOut(this,this.FCurOverPetData);
      }
      
      protected function RankMcOnClick(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:TextField = null;
         if(this.FCurRankIndex != -1)
         {
            _loc2_ = FScene["MC_Rank_" + this.FCurRankIndex];
            _loc2_.gotoAndStop(this.RankOffFrame);
         }
         this.FCurRankIndex = param1.currentTarget.Tag;
         _loc2_ = FScene["MC_Rank_" + this.FCurRankIndex];
         _loc2_.gotoAndStop(this.RankOnFrame);
         _loc3_ = FScene["TF_NextRankInfo"];
         _loc3_.text = this.FData.GetRankInfo(this.FCurRankIndex);
      }
      
      protected function AutoLoadCallBack(param1:Object, param2:TTexture, param3:uint) : void
      {
         var _loc4_:TAnimationSequence = null;
         switch(param3)
         {
            case this.FData.VicePetVO.ResourceID:
               _loc4_ = param2.GetAnimationSequenceByIndex(0);
               this.FPetBmp.bitmapData = _loc4_.GetAnimationFrameByIndex(0).Surface;
         }
      }
      
      protected function ChipBoxBtnOnClickOK(param1:Object) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FData.Config.ChipBox[this.FCurChipBtnTag].index);
      }
      
      override public function InitWindow(param1:Sprite = null) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:MovieClip = null;
         var _loc4_:MovieClip = null;
         var _loc5_:TUIButton = null;
         super.InitWindow(param1);
         _loc3_ = FScene["MC_Login"];
         _loc4_ = _loc3_.Btn_BoxBtn;
         this.FLoginBoxBtn = new TUIButton();
         this.FLoginBoxBtn.Substrate = _loc4_;
         this.FLoginBoxBtn.OnClick = this.LoginBoxBtnOnClick;
         _loc4_ = _loc3_.MC_Box;
         _loc4_.gotoAndStop(this.OutFrame);
         _loc4_.addEventListener(MouseEvent.MOUSE_MOVE,this.LoginBoxOnMove);
         _loc4_.addEventListener(MouseEvent.MOUSE_OUT,this.LoginBoxOnOut);
         _loc4_ = _loc3_.MC_ReciveFlag;
         _loc4_.visible = false;
         _loc4_.mouseEnabled = false;
         this.FLinkBtns = new Vector.<TUIButton>(TPetYearData.TaskCount);
         this.FTaskBoxBtn = new Vector.<TUIButton>(TPetYearData.TaskCount);
         _loc2_ = 0;
         while(_loc2_ < TPetYearData.TaskCount)
         {
            _loc3_ = FScene["MC_Task_" + _loc2_];
            _loc4_ = _loc3_.Btn_GoTask;
            _loc5_ = new TUIButton();
            _loc5_.Substrate = _loc4_;
            _loc5_.OnClick = this.LinkBtnOnClick;
            _loc5_.Tag = _loc2_;
            this.FLinkBtns[_loc2_] = _loc5_;
            _loc4_ = _loc3_.MC_ReceiveFlag;
            _loc4_.visible = false;
            _loc4_.mouseEnabled = false;
            _loc4_ = _loc3_.MC_FinishFlag;
            _loc4_.visible = false;
            _loc4_.mouseEnabled = false;
            _loc5_ = new TUIButton();
            _loc5_.Substrate = _loc3_.Btn_Box;
            _loc5_.OnClick = this.TaskBoxBtnOnClick;
            _loc5_.OnMove = this.TaskBoxBtnOnMove;
            _loc5_.OnOut = this.TaskBoxBtnOnOut;
            _loc5_.Tag = _loc2_;
            this.FTaskBoxBtn[_loc2_] = _loc5_;
            _loc2_++;
         }
         _loc3_ = FScene["MC_PetMask"];
         _loc4_ = _loc3_.Btn_Receive;
         this.FVicePetReceiveBtn = new TUIButton();
         this.FVicePetReceiveBtn.Substrate = _loc4_;
         this.FVicePetReceiveBtn.OnClick = this.VicePetReceiveBtnOnClick;
         _loc4_ = FScene["Btn_Feed"];
         this.FVicePetFeedBtn = new TUIButton();
         this.FVicePetFeedBtn.Substrate = _loc4_;
         this.FVicePetFeedBtn.OnClick = this.VicePetFeedBtnOnClick;
         this.FChipBoxBtns = new Vector.<TUIButton>(TPetYearData.BoxCount);
         _loc2_ = 0;
         while(_loc2_ < TPetYearData.BoxCount)
         {
            _loc3_ = FScene["MC_Box_" + _loc2_];
            _loc4_ = _loc3_.Btn_Box;
            _loc5_ = new TUIButton();
            _loc5_.Substrate = _loc4_;
            _loc5_.OnClick = this.ChipBoxBtnOnClick;
            _loc5_.Tag = _loc2_;
            this.FChipBoxBtns[_loc2_] = _loc5_;
            _loc4_ = _loc3_.MC_Box;
            _loc4_.gotoAndStop(this.OutFrame);
            _loc4_.addEventListener(MouseEvent.MOUSE_MOVE,this.ChipBoxOnMove);
            _loc4_.addEventListener(MouseEvent.MOUSE_OUT,this.ChipBoxOnOut);
            _loc4_.Tag = _loc2_;
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < TPetYearData.RankCount)
         {
            _loc3_ = FScene["MC_Rank_" + _loc2_];
            _loc3_.addEventListener(MouseEvent.MOUSE_MOVE,this.RankMcOnMove);
            _loc3_.addEventListener(MouseEvent.MOUSE_OUT,this.RankMcOnOut);
            _loc3_.addEventListener(MouseEvent.CLICK,this.RankMcOnClick);
            _loc3_.gotoAndStop(this.RankOffFrame);
            _loc3_.buttonMode = true;
            _loc3_.Tag = _loc2_;
            _loc2_++;
         }
         this.FPetBmp = new Bitmap();
         _loc4_ = FScene["MC_MountPoint"];
         _loc4_.addChild(this.FPetBmp);
         this.FCurRankIndex = -1;
      }
   }
}

