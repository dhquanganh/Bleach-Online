package Processors.Game.Lobby.Activity.HDThankssgivingDay.Windows
{
   import Components.Standard.TUIButton;
   import Foundation.Resources.SResourcesCore;
   import Foundation.Resources.Textures.TTexture;
   import Foundation.UI.TUIComponent;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDThanksgivingDay.TThanksFeastData;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDSingleWindowBase;
   import Processors.Game.Utilities.HyperLink.SUtilityHyperLink;
   import Processors.Game.Utilities.HyperLink.TUtilityHyperLink;
   import Rendering.Overlayers.HDGiftBox.TOverlayerGiftBox;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class TProcessorThanksFeastView extends TProcessorHDSingleWindowBase
   {
      
      protected const PuzzleBtnCount:uint = 9;
      
      protected const DailyGiftCount:uint = 5;
      
      protected var FData:TThanksFeastData;
      
      protected var FBrightGifts:Vector.<TUIButton>;
      
      protected var FDarkGifts:Vector.<TUIButton>;
      
      protected var FPetReceive:TUIButton;
      
      protected var FBtm:Bitmap;
      
      protected var FDailyGiftReceiveBtns:Vector.<TUIButton>;
      
      protected var FDailyGifts:Vector.<TUIButton>;
      
      public function TProcessorThanksFeastView(param1:TUIComponent)
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
         this.FData = param1 as TThanksFeastData;
         this.UpdatePuzzle();
         this.UpdatePet();
         this.UpdateDailyGift();
      }
      
      protected function InitPuzzle() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:TUIButton = null;
         var _loc3_:MovieClip = null;
         this.FDarkGifts = new Vector.<TUIButton>(this.PuzzleBtnCount);
         this.FBrightGifts = new Vector.<TUIButton>(this.PuzzleBtnCount);
         _loc1_ = 0;
         while(_loc1_ < this.PuzzleBtnCount)
         {
            _loc3_ = FScene["MC_Map_" + _loc1_];
            _loc3_.TF_Count.mouseEnabled = false;
            _loc2_ = new TUIButton();
            _loc2_.Tag = _loc1_;
            _loc2_.Substrate = _loc3_.Btn_Dark;
            _loc2_.OnMove = this.PuzzleMove;
            _loc2_.OnOut = this.PuzzleOut;
            this.FDarkGifts[_loc1_] = _loc2_;
            _loc2_ = new TUIButton();
            _loc2_.Tag = _loc1_;
            _loc2_.Substrate = _loc3_.MC_Bright;
            _loc2_.OnMove = this.PuzzleMove;
            _loc2_.OnOut = this.PuzzleOut;
            _loc2_.OnClick = this.PuzzleClick;
            this.FBrightGifts[_loc1_] = _loc2_;
            _loc1_++;
         }
      }
      
      protected function InitPet() : void
      {
         var _loc1_:MovieClip = null;
         this.FBtm = new Bitmap();
         _loc1_ = FScene["MC_Pet"] as MovieClip;
         _loc1_.SP_MountPoint.addChild(this.FBtm);
         _loc1_.SP_MountPoint.addEventListener(MouseEvent.CLICK,this.GoToPetMap);
         _loc1_.SP_MountPoint.buttonMode = true;
         this.FPetReceive = new TUIButton();
         this.FPetReceive.Substrate = _loc1_.Btn_Receive;
         this.FPetReceive.OnClick = this.OnPetReceiveBtnClick;
      }
      
      protected function InitDailyGift() : void
      {
         var _loc1_:TUIButton = null;
         var _loc2_:MovieClip = null;
         var _loc3_:MovieClip = null;
         var _loc4_:uint = 0;
         this.FDailyGiftReceiveBtns = new Vector.<TUIButton>(this.DailyGiftCount);
         this.FDailyGifts = new Vector.<TUIButton>(this.DailyGiftCount);
         _loc2_ = FScene["MC_DailyGift"] as MovieClip;
         _loc4_ = 0;
         while(_loc4_ < this.DailyGiftCount)
         {
            _loc3_ = _loc2_["MC_Item" + _loc4_];
            _loc1_ = new TUIButton();
            _loc1_.Substrate = _loc3_.Btn_Gift;
            _loc1_.OnMove = this.OnDailyGiftsMove;
            _loc1_.OnOut = this.OnDailyGiftsOut;
            _loc1_.Tag = _loc4_;
            this.FDailyGifts[_loc4_] = _loc1_;
            _loc1_ = new TUIButton();
            _loc1_.Substrate = _loc3_.Btn_ExchargeOne;
            _loc1_.OnClick = this.OnDailyGiftsReceiveClick;
            _loc1_.Tag = _loc4_;
            this.FDailyGiftReceiveBtns[_loc4_] = _loc1_;
            _loc4_++;
         }
      }
      
      protected function UpdatePuzzle() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:Boolean = false;
         var _loc3_:MovieClip = null;
         var _loc4_:Object = null;
         _loc1_ = 0;
         while(_loc1_ < this.PuzzleBtnCount)
         {
            _loc3_ = FScene["MC_Map_" + _loc1_];
            _loc4_ = this.FData.Config.Puzzle.award[_loc1_];
            _loc3_.TF_Count.text = String(_loc4_.condition);
            _loc2_ = Boolean(this.FData.PuzzleKeys >> _loc1_ & 1);
            if(_loc2_)
            {
               _loc3_.MC_Get.visible = true;
            }
            else
            {
               _loc3_.MC_Get.visible = false;
            }
            if(this.FData.RechargeGold >= _loc4_.condition)
            {
               this.FBrightGifts[_loc1_].Visible = true;
               this.FDarkGifts[_loc1_].Visible = false;
            }
            else
            {
               this.FBrightGifts[_loc1_].Visible = false;
               this.FDarkGifts[_loc1_].Visible = true;
            }
            _loc1_++;
         }
      }
      
      protected function UpdatePet() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:MovieClip = null;
         SResourcesCore.TexturesLargeIcon.LoadAutoSecondary(this.FData.Config.Pet.modelID,this.PetResLoadOK);
         _loc2_ = FScene["MC_Pet"];
         _loc1_ = Boolean(this.FData.PetKey);
         if(_loc1_)
         {
            _loc2_.MC_Get.visible = true;
            this.FPetReceive.Enabled = false;
         }
         else
         {
            _loc2_.MC_Get.visible = false;
            this.FPetReceive.Enabled = this.PetCanReceive();
         }
      }
      
      protected function PetCanReceive() : Boolean
      {
         var _loc1_:uint = 0;
         _loc1_ = 0;
         while(_loc1_ < this.PuzzleBtnCount)
         {
            if(this.FData.RechargeGold < this.FData.Config.Puzzle.award[_loc1_].condition)
            {
               return false;
            }
            _loc1_++;
         }
         return true;
      }
      
      protected function UpdateDailyGift() : void
      {
         var _loc1_:MovieClip = null;
         var _loc2_:MovieClip = null;
         var _loc3_:uint = 0;
         var _loc4_:Object = null;
         var _loc5_:Boolean = false;
         var _loc6_:TUIButton = null;
         _loc1_ = FScene["MC_DailyGift"];
         _loc1_.TF_Count.text = this.FData.DailyRechargeGold.toString();
         _loc3_ = 0;
         while(_loc3_ < this.DailyGiftCount)
         {
            _loc4_ = this.FData.Config.DailyGift.award[this.FData.Day][_loc3_];
            _loc2_ = _loc1_["MC_Item" + _loc3_];
            _loc2_.TF_Count.text = String(_loc4_.condition);
            _loc6_ = this.FDailyGiftReceiveBtns[_loc3_];
            _loc5_ = Boolean(this.FData.AwardListKeys >> _loc3_ & 1);
            if(_loc5_)
            {
               _loc2_.MC_Get.visible = true;
               _loc6_.Enabled = false;
            }
            else
            {
               _loc2_.MC_Get.visible = false;
               if(this.FData.DailyRechargeGold >= _loc4_.condition)
               {
                  _loc6_.Enabled = true;
               }
               else
               {
                  _loc6_.Enabled = false;
               }
            }
            _loc3_++;
         }
      }
      
      protected function PuzzleMove(param1:Object, param2:MouseEvent) : void
      {
         ProcessorOnGiftBoxMove(this,this.FData.PuzzleInvs[param1.Tag],TOverlayerGiftBox.TYPE_ALL);
      }
      
      protected function PuzzleOut(param1:Object, param2:MouseEvent) : void
      {
         ProcessorOnGiftBoxOut(this);
      }
      
      protected function PuzzleClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:Object = null;
         var _loc4_:uint = 0;
         var _loc5_:Boolean = false;
         _loc4_ = uint(param1.Tag);
         _loc3_ = this.FData.Config.Puzzle.award[_loc4_];
         _loc5_ = Boolean(this.FData.PuzzleKeys >> _loc4_ & 1);
         if(this.FData.RechargeGold >= _loc3_.condition && !_loc5_)
         {
            Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FData.Config.Puzzle.index,0,Vector.<int>([_loc4_]));
         }
      }
      
      protected function OnPetReceiveBtnClick(param1:Object, param2:MouseEvent) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FData.Config.Pet.index);
      }
      
      protected function OnDailyGiftsMove(param1:Object, param2:MouseEvent) : void
      {
         ProcessorOnGiftBoxMove(this,this.FData.DailyGiftInvs[param1.Tag],TOverlayerGiftBox.TYPE_ALL);
      }
      
      protected function OnDailyGiftsOut(param1:Object, param2:MouseEvent) : void
      {
         ProcessorOnGiftBoxOut(this);
      }
      
      protected function OnDailyGiftsReceiveClick(param1:Object, param2:MouseEvent) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FData.Config.DailyGift.index,0,Vector.<int>([param1.Tag]));
      }
      
      protected function PetResLoadOK(param1:Object, param2:TTexture, param3:uint) : void
      {
         this.FBtm.bitmapData = param2.GetAnimationSequenceByIndex(0).GetAnimationFrameByIndex(0).Surface;
      }
      
      protected function GoToPetMap(param1:MouseEvent) : void
      {
         SUtilityHyperLink.ShortcutHyperlink(TUtilityHyperLink.HyperLink_Pet);
      }
      
      override public function InitWindow(param1:Sprite = null) : void
      {
         super.InitWindow(param1);
         this.InitPuzzle();
         this.InitPet();
         this.InitDailyGift();
      }
   }
}

