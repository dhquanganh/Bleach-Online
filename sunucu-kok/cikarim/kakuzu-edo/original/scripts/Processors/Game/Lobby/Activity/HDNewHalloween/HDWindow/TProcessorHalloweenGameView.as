package Processors.Game.Lobby.Activity.HDNewHalloween.HDWindow
{
   import Components.Pages.TUIPage;
   import Components.Slots.TUISlot;
   import Components.Standard.TUIButton;
   import Foundation.Resources.SResourcesCore;
   import Foundation.Resources.Textures.TAnimationSequence;
   import Foundation.Resources.Textures.TTexture;
   import Foundation.UI.TUIComponent;
   import Logics.DatebaseVO.VO.TPetLevelUp;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDNewHalloween.THDNewHalloweenGameData;
   import Logics.Inventories.TInventories;
   import Logics.SLogicsCore;
   import Logics.TimeCoolDown.TTimeCoolDown;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDSingleWindowBase;
   import Processors.Game.Lobby.Jade.TJadeCommon;
   import Processors.Game.Utilities.HyperLink.SUtilityHyperLink;
   import Processors.Game.Utilities.HyperLink.TUtilityHyperLink;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Resources.Constants.CONST_COMMON;
   import Resources.Constants.CONST_DATEBASEVO;
   import Resources.Constants.CONST_NewHalloween;
   import Utilities.Timing.TUtilityTiming;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.ui.Keyboard;
   
   public class TProcessorHalloweenGameView extends TProcessorHDSingleWindowBase
   {
      
      public static const AwardMax:uint = 3;
      
      public static const Normal_State:int = 0;
      
      public static const Throw_state:int = 1;
      
      public static const Effect_State:int = 2;
      
      public static const Check_Frame:int = 15;
      
      protected var FData:THDNewHalloweenGameData;
      
      protected var FStartBtn:TUIButton;
      
      protected var FBuyBtn:TUIButton;
      
      protected var FMyCandyTF:TextField;
      
      protected var FGameTimesTF:TextField;
      
      protected var FCountdownTF:TextField;
      
      protected var FAwardSPVec:Vector.<Sprite>;
      
      protected var FAwardSlotVec:Vector.<TUISlot>;
      
      protected var FAwardBtnVec:Vector.<TUIButton>;
      
      protected var FAwardSignVec:Vector.<Sprite>;
      
      protected var FAwardConditionTFVec:Vector.<TextField>;
      
      protected var FUIAwardPage:TUIPage;
      
      protected var FCurrentPageIndex:int;
      
      protected var FTitleGetBtn:TUIButton;
      
      protected var FTitleSlot:TUISlot;
      
      protected var FTitleConTF:TextField;
      
      protected var FPetBmp:Bitmap;
      
      protected var FPointPetMC:Sprite;
      
      protected var FPetLevelUp:TPetLevelUp;
      
      protected var FBombermanMc:MovieClip;
      
      protected var FPersonImgMc:MovieClip;
      
      protected var FBombMc:MovieClip;
      
      protected var FBombNormal:MovieClip;
      
      protected var FBombThrow:MovieClip;
      
      protected var FBombEffect:MovieClip;
      
      protected var FLeftMc:Sprite;
      
      protected var FRightMc:Sprite;
      
      protected var FMcAutoMoveTarget:MovieClip;
      
      protected var FIsStart:Boolean;
      
      protected var FIsShotting:Boolean;
      
      protected var FTargetSpeed:int = 6;
      
      protected var FGunSpeed:int = 8;
      
      protected var FTimeCoolDown:TTimeCoolDown;
      
      protected var FGamePromptMsg:Sprite;
      
      protected var FCurrentState:int;
      
      protected var FIsInitResource:Boolean;
      
      protected var FOnMainClose:Function;
      
      public function TProcessorHalloweenGameView(param1:TUIComponent)
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
         var _loc2_:TextField = null;
         this.FData = param1 as THDNewHalloweenGameData;
         super.UpdateDataBase(param1);
         this.FMyCandyTF.text = this.FData.Candy.toString();
         this.FGameTimesTF.text = this.FData.GameTimes.toString();
         this.FTitleConTF.text = this.FData.ActivityConfig.TitleObj.candy.toString();
         this.FTitleGetBtn.Enabled = this.FData.TitleState == CONST_NewHalloween.ScanGetState;
         this.FStartBtn.Enabled = this.FData.GameTimes > 0;
         this.RenderList();
         this.FPetLevelUp = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_PetLevelUp,this.FData.ActivityConfig.VicePet.petListID) as TPetLevelUp;
         if(this.FPetLevelUp != null)
         {
            SResourcesCore.TexturesLargeIcon.LoadAutoSecondary(this.FPetLevelUp.PetResourceID,this.AutoLoadCallBack);
         }
      }
      
      private function RenderList() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TUIButton = null;
         var _loc7_:TInventories = null;
         this.FUIAwardPage.TotalQuantity = this.FData.CandyVoVec.length;
         this.FUIAwardPage.PageIndex = this.FCurrentPageIndex;
         this.FUIAwardPage.Update();
         _loc5_ = 0;
         _loc3_ = this.FCurrentPageIndex * AwardMax;
         _loc4_ = (this.FCurrentPageIndex + 1) * AwardMax;
         _loc1_ = _loc3_;
         while(_loc1_ < _loc4_)
         {
            if(_loc1_ < this.FData.CandyVoVec.length)
            {
               this.FAwardSPVec[_loc5_].visible = true;
               _loc7_ = this.FData.CandyVoVec[_loc1_].Inventories;
               this.FAwardSlotVec[_loc5_].Context = null;
               this.FAwardSlotVec[_loc5_].Context = _loc7_.GetInventoryByIndex(0);
               this.FAwardConditionTFVec[_loc5_].text = this.FData.CandyVoVec[_loc1_].Condition.toString();
               this.FAwardBtnVec[_loc5_].Enabled = this.FData.CandyVoVec[_loc1_].State == CONST_NewHalloween.ScanGetState;
               this.FAwardSignVec[_loc5_].visible = this.FData.CandyVoVec[_loc1_].State == CONST_NewHalloween.Finish;
            }
            else
            {
               this.FAwardSPVec[_loc5_].visible = false;
            }
            _loc5_++;
            _loc1_++;
         }
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(!this.FIsInitResource)
         {
            return;
         }
         this.UpdatePropSlots(this.FAwardSlotVec);
         this.UpdateCountdown();
         this.TargetMove();
         this.ShotTargetMove();
         this.ShottingBullet();
      }
      
      private function UpdatePropSlots(param1:Vector.<TUISlot>) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         _loc3_ = int(param1.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            param1[_loc2_].Update();
            _loc2_++;
         }
      }
      
      private function GameStart() : void
      {
         if(this.FIsStart)
         {
            return;
         }
         this.FIsStart = true;
         this.FTimeCoolDown.TimingTime = this.FData.ActivityConfig.Countdown;
      }
      
      private function TargetMove() : void
      {
         this.FMcAutoMoveTarget.x += this.FTargetSpeed;
         if(this.FMcAutoMoveTarget.hitTestObject(this.FLeftMc) || this.FMcAutoMoveTarget.hitTestObject(this.FRightMc))
         {
            this.FTargetSpeed *= -1;
            this.FMcAutoMoveTarget.scaleX *= -1;
         }
      }
      
      private function ShotTargetMove() : void
      {
         if(this.FIsStart && !this.FIsShotting)
         {
            this.FBombermanMc.x += this.FGunSpeed;
            if(this.FPersonImgMc.hitTestObject(this.FLeftMc) || this.FPersonImgMc.hitTestObject(this.FRightMc))
            {
               this.FGunSpeed *= -1;
               this.FBombermanMc.scaleX *= -1;
            }
         }
      }
      
      private function ShottingBullet() : void
      {
         switch(this.FCurrentState)
         {
            case Normal_State:
               this.FBombNormal.visible = true;
               this.FBombThrow.visible = false;
               this.FBombEffect.visible = false;
               this.FPersonImgMc.gotoAndStop(1);
               break;
            case Throw_state:
               this.FPersonImgMc.gotoAndStop(2);
               this.FBombNormal.visible = false;
               this.FBombThrow.visible = true;
               if(this.FBombThrow.hitTestObject(this.FMcAutoMoveTarget) && this.FBombThrow.currentFrame > Check_Frame)
               {
                  this.FBombThrow.gotoAndStop(1);
                  this.FCurrentState = Effect_State;
                  this.FBombEffect.play();
                  this.FMcAutoMoveTarget.gotoAndPlay(1);
               }
               if(this.FBombThrow.currentFrame >= this.FBombThrow.totalFrames && this.FCurrentState != Effect_State)
               {
                  this.FBombThrow.gotoAndStop(1);
                  this.FCurrentState = Normal_State;
                  this.FIsStart = false;
                  this.FIsShotting = false;
                  this.SendGameResult(0);
               }
               break;
            case Effect_State:
               this.FBombThrow.visible = false;
               this.FBombEffect.visible = true;
               if(this.FBombEffect.currentFrame >= this.FBombEffect.totalFrames)
               {
                  this.FBombEffect.gotoAndStop(1);
                  this.FCurrentState = Normal_State;
                  this.FIsStart = false;
                  this.FIsShotting = false;
                  this.SendGameResult(1);
                  this.FMcAutoMoveTarget.gotoAndStop(1);
               }
               if(this.FMcAutoMoveTarget.currentFrame >= this.FMcAutoMoveTarget.totalFrames)
               {
                  this.FMcAutoMoveTarget.gotoAndStop(1);
               }
         }
      }
      
      private function UpdateCountdown() : void
      {
         if(this.FIsStart)
         {
            this.FCountdownTF.text = TUtilityTiming.fomatTime(this.FTimeCoolDown.TimingTime);
            if(this.FTimeCoolDown.TimingTime <= 0 && !this.FIsShotting)
            {
               this.FCountdownTF.text = "";
               this.AutoThrowBomb();
            }
         }
      }
      
      private function SendGameResult(param1:int) : void
      {
         var _loc2_:Vector.<int> = null;
         _loc2_ = new Vector.<int>();
         _loc2_.push(param1);
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FData.ActivityConfig.NotifyIndex,0,_loc2_);
      }
      
      protected function GameStartBtnOnClick(param1:Object, param2:MouseEvent) : void
      {
         this.FGamePromptMsg.visible = false;
         if(this.FData.GameTimes > 0)
         {
            this.GameStart();
         }
      }
      
      protected function BuyGameTimesOnClick(param1:Object, param2:MouseEvent) : void
      {
         var Sender:Object = param1;
         var E:MouseEvent = param2;
         GoldBuy(this.FData.ActivityConfig.BuyGameGold,function SendBuyGameTimesReq():void
         {
            Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,FData.ActivityConfig.BuyIndex);
         });
      }
      
      protected function GetAwardOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TUIButton = null;
         var _loc4_:int = 0;
         _loc3_ = param1 as TUIButton;
         _loc4_ = this.FCurrentPageIndex * AwardMax + this.FAwardBtnVec.indexOf(_loc3_);
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FData.CandyVoVec[_loc4_].Index);
      }
      
      protected function TitleAwardOnClick(param1:Object, param2:MouseEvent) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FData.ActivityConfig.TitleObj.index);
      }
      
      protected function AutoLoadCallBack(param1:Object, param2:TTexture, param3:uint) : void
      {
         var _loc4_:TAnimationSequence = null;
         switch(param3)
         {
            case this.FPetLevelUp.PetResourceID:
               _loc4_ = param2.GetAnimationSequenceByIndex(0);
               this.FPetBmp.bitmapData = _loc4_.GetAnimationFrameByIndex(0).Surface;
         }
      }
      
      protected function CallBack_KeyDown(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == Keyboard.SPACE && this.FIsStart && !this.FIsShotting)
         {
            this.AutoThrowBomb();
         }
      }
      
      private function AutoThrowBomb() : void
      {
         this.FCurrentState = Throw_state;
         this.FIsShotting = true;
         this.FBombThrow.gotoAndPlay(1);
      }
      
      protected function LinkPetOnClick(param1:MouseEvent) : void
      {
         if(this.FOnMainClose != null)
         {
            this.FOnMainClose(null,null);
         }
         SUtilityHyperLink.ShortcutHyperlink(TUtilityHyperLink.HyperLink_Pet);
      }
      
      protected function SwitchPage(param1:Object, param2:int) : void
      {
         this.FCurrentPageIndex = param2;
         this.RenderList();
      }
      
      public function get OnMainClose() : Function
      {
         return this.FOnMainClose;
      }
      
      public function set OnMainClose(param1:Function) : void
      {
         this.FOnMainClose = param1;
      }
      
      override public function InitWindow(param1:Sprite = null) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:int = 0;
         var _loc4_:TUIButton = null;
         var _loc5_:MovieClip = null;
         var _loc6_:Sprite = null;
         var _loc7_:TUISlot = null;
         var _loc8_:TextField = null;
         super.InitWindow(param1);
         this.FStartBtn = new TUIButton();
         this.FStartBtn.Substrate = FScene["Btn_Start"];
         this.FStartBtn.OnClick = this.GameStartBtnOnClick;
         this.FMyCandyTF = FScene["TF_Candy"];
         this.FGameTimesTF = FScene["TF_GameTimes"];
         this.FBuyBtn = new TUIButton();
         this.FBuyBtn.Substrate = FScene["Btn_AddSlotNum"];
         this.FBuyBtn.OnClick = this.BuyGameTimesOnClick;
         this.FCountdownTF = FScene["TF_Countdown"];
         _loc5_ = FScene["MC_RightArea"];
         _loc3_ = int(AwardMax);
         this.FAwardSPVec = new Vector.<Sprite>();
         this.FAwardSlotVec = new Vector.<TUISlot>();
         this.FAwardBtnVec = new Vector.<TUIButton>();
         this.FAwardSignVec = new Vector.<Sprite>();
         this.FAwardConditionTFVec = new Vector.<TextField>();
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc6_ = _loc5_["Item" + _loc2_];
            this.FAwardSPVec[_loc2_] = _loc6_;
            _loc7_ = new TUISlot(this);
            _loc7_.Resource = _loc6_["Slot"];
            _loc7_.OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
            _loc7_.OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
            TJadeCommon.InitSlot(_loc7_);
            _loc7_.Init();
            this.FAwardSlotVec[_loc2_] = _loc7_;
            _loc4_ = new TUIButton();
            _loc4_.Substrate = _loc6_["Btn_GetAward"];
            _loc4_.OnClick = this.GetAwardOnClick;
            this.FAwardBtnVec[_loc2_] = _loc4_;
            _loc8_ = _loc6_["TFCondition"];
            this.FAwardConditionTFVec[_loc2_] = _loc8_;
            this.FAwardSignVec[_loc2_] = _loc6_["MC_AlreadyGet"];
            _loc2_++;
         }
         this.FTitleConTF = _loc5_["Item_Title"]["TFCondition"];
         this.FTitleGetBtn = new TUIButton();
         this.FTitleGetBtn.Substrate = _loc5_["Item_Title"]["Btn_GetAward"];
         this.FTitleGetBtn.OnClick = this.TitleAwardOnClick;
         this.FIsStart = false;
         this.FTimeCoolDown = new TTimeCoolDown(CONST_COMMON.TIME_COOLDOWN_NewHalloween);
         SLogicsCore.TimeCoolDowns.Add(this.FTimeCoolDown);
         this.FUIAwardPage = new TUIPage(this);
         this.FUIAwardPage.ButtonPrevious.Substrate = _loc5_["MC_PageLeft"];
         this.FUIAwardPage.ButtonNext.Substrate = _loc5_["MC_PageRight"];
         this.FUIAwardPage.PageSize = AwardMax;
         this.FUIAwardPage.OnChangePage = this.SwitchPage;
         this.FUIAwardPage.Init();
         this.FPointPetMC = _loc5_["MC_MountPoint"];
         this.FPointPetMC.buttonMode = true;
         this.FPointPetMC.addEventListener(MouseEvent.CLICK,this.LinkPetOnClick);
         this.FPetBmp = new Bitmap();
         this.FPointPetMC.addChild(this.FPetBmp);
         this.FBombermanMc = FScene["MC_Bomberman"];
         this.FPersonImgMc = this.FBombermanMc["MC_Person"];
         this.FBombMc = this.FBombermanMc["MC_Bomb"];
         this.FBombNormal = this.FBombMc["BombNormal"];
         this.FBombNormal.play();
         this.FBombThrow = this.FBombMc["BombThrow"];
         this.FBombThrow.visible = false;
         this.FBombEffect = this.FBombMc["BombEffect"];
         this.FBombEffect.visible = false;
         this.FMcAutoMoveTarget = FScene["MC_Target"];
         this.FLeftMc = FScene["MC_Left"];
         this.FRightMc = FScene["MC_Right"];
         this.FGamePromptMsg = FScene["TF_Prompt"];
         stage.addEventListener(KeyboardEvent.KEY_DOWN,this.CallBack_KeyDown);
         this.FIsInitResource = true;
      }
   }
}

