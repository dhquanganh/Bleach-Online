package Processors.Game.Lobby.Home.GirlFriend
{
   import Components.Standard.*;
   import Foundation.Common.*;
   import Foundation.Network.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Bins.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.Home.GirlFriend.*;
   import Logics.TimeCoolDown.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Utilities.*;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Processors.Game.Windows.Information.*;
   import Resources.Constants.*;
   import Utilities.Timing.TUtilityTiming;
   import Utilities.UI.Windows.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class TProcessorWindowGirlFriendSpriteCommunicate extends TProcessorLobbyWindow
   {
      
      protected static const StartX:int = 12;
      
      protected static const DisBlank:int = 82;
      
      protected var FEffectState_None:int = 0;
      
      protected var FEffectState_Loop:int = 1;
      
      protected var FEffectState_SlowDown:int = 2;
      
      protected var FEffectState_Location:int = 3;
      
      protected var FEffectLoopCount:int = 5;
      
      protected var FEffectLoopTimeBlank:int = 2;
      
      protected var FHeadNum:int = 5;
      
      protected var FGirlFriend:TGirlFriend;
      
      protected var FTF_CommunicateTime:TextField;
      
      protected var FTF_CDTime:TextField;
      
      protected var FTF_DayTime:TextField;
      
      protected var FBTN_ClearTime:TUIButton;
      
      protected var FBTN_NormalCommunicate:TUIButton;
      
      protected var FBTN_GoldCommunicate:TUIButton;
      
      protected var FTimeCoolDown:TTimeCoolDown;
      
      protected var FCurrentSpriteCommunicateType:int;
      
      protected var FCheckCondition:Vector.<Function>;
      
      protected var FUIWindowConfirmation:TUIWindowConfirmation;
      
      protected var FNeedWarn:Boolean;
      
      protected var FWindowClearCDTimeConfirmation:TUIWindowConfirmation;
      
      protected var FSelectBox:Sprite;
      
      protected var FSelectBoxCurrentIndex:int;
      
      protected var FCurrentEffectState:int;
      
      protected var FFrameBlank:int;
      
      protected var FTimePassed:int;
      
      protected var FLoopCount:int;
      
      protected var FSlowDownCount:int;
      
      protected var FHeadInfor:THint;
      
      protected var FHeadPic:Vector.<MovieClip>;
      
      protected var FSpriteCommunicateDescription:Vector.<String>;
      
      protected var FGirlMoods:Vector.<String>;
      
      protected var FHintOnOver:Function;
      
      protected var FHintOnOut:Function;
      
      protected var FPlayRewardEffect:Function;
      
      public function TProcessorWindowGirlFriendSpriteCommunicate(param1:TUIComponent)
      {
         super(param1);
         this.FGirlFriend = SLogicsCore.Home.GirlFriend;
         this.FTimeCoolDown = new TTimeCoolDown(CONST_COMMON.TIME_COOLDOWN_Home_SpriteCommunicate);
         SLogicsCore.TimeCoolDowns.Add(this.FTimeCoolDown);
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(this.Visible)
         {
            this.FTF_CDTime.text = TUtilityTiming.fomatTime(this.FTimeCoolDown.TimingTime);
            this.FBTN_ClearTime.Enabled = this.FTimeCoolDown.TimingTime > 0 && this.FGirlFriend.CurrentSpriteCommunicateTime < this.FGirlFriend.CanCommunicateTime && this.FGirlFriend.GirlMood == 0;
            if(this.FGirlFriend.GirlMood != 0)
            {
               this.PlayEffect();
            }
         }
      }
      
      protected function UIDispatch_Peform(param1:MovieClip) : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:int = 0;
         addChild(param1);
         this.FTF_CommunicateTime = param1["CommunicateTime"];
         this.FTF_CDTime = param1["TF_CDTime"];
         this.FTF_DayTime = param1["DayTime"];
         this.FBTN_ClearTime = new TUIButton();
         this.FBTN_ClearTime.Substrate = param1["Btn_Cleartime"];
         this.FBTN_NormalCommunicate = new TUIButton();
         this.FBTN_NormalCommunicate.Substrate = param1["BTN_Normal"];
         this.FBTN_GoldCommunicate = new TUIButton();
         this.FBTN_GoldCommunicate.Substrate = param1["BTN_Soul"];
         this.FSelectBox = param1["SelectBox"];
         this.FCheckCondition = new Vector.<Function>();
         this.FUIWindowConfirmation = new TUIWindowConfirmation(Parent.Parent);
         this.FUIWindowConfirmation.OnOK = this.WindowOnOK;
         TUtilityUIWindow.SetupWindowConfirmation(this.FUIWindowConfirmation);
         this.FUIWindowConfirmation.SetCheckBoxUsable(true);
         this.FNeedWarn = true;
         this.FWindowClearCDTimeConfirmation = SUtilityOverLayer.UIWindowConfirmation;
         this.FHeadPic = new Vector.<MovieClip>();
         _loc3_ = 0;
         while(_loc3_ < this.FHeadNum)
         {
            this.FHeadPic.push(param1["Head" + _loc3_]);
            _loc3_++;
         }
         this.FHeadInfor = new THint();
         this.FGirlMoods = TUtilityLobby.GetStringsByIdentifier(CONST_SYSTEMLANGUAGE.GirlFriend_STRING_18);
         this.LoadCommunicateDescrption();
      }
      
      protected function UILocation_Peform() : void
      {
         var _loc1_:int = 0;
         var _loc2_:MovieClip = null;
         this.FTF_DayTime.text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.GirlFriend_STRING_27);
         this.FBTN_NormalCommunicate.OnClick = this.BtnNormalCommunicateClicked;
         this.FBTN_NormalCommunicate.OnMove = this.NormalBtnOnMove;
         this.FBTN_NormalCommunicate.OnOut = this.BtnOnOut;
         this.FBTN_GoldCommunicate.OnClick = this.BtnGoldCommunicateClicked;
         this.FBTN_GoldCommunicate.OnMove = this.SoulBtnOnMove;
         this.FBTN_GoldCommunicate.OnOut = this.BtnOnOut;
         this.FBTN_ClearTime.OnClick = this.BtnClearClicked;
         this.FSelectBox.x = StartX;
         this.FCheckCondition.push(this.CheckCanSpriteCommunicateTime);
         this.FCheckCondition.push(this.CheckIfCDTime);
         this.FCheckCondition.push(this.CheckIfEnoughCoin);
         _loc1_ = 0;
         while(_loc1_ < this.FHeadNum)
         {
            _loc2_ = this.FHeadPic[_loc1_];
            _loc2_.addEventListener(MouseEvent.MOUSE_MOVE,this.HeadOnOver);
            _loc2_.addEventListener(MouseEvent.MOUSE_OUT,this.HeadOnOut);
            _loc1_++;
         }
      }
      
      protected function LoadCommunicateDescrption() : void
      {
         var _loc1_:int = 0;
         var _loc2_:TBins = null;
         var _loc3_:TArticle = null;
         var _loc4_:TArticle = null;
         var _loc5_:THomeGirlMood = null;
         var _loc6_:String = null;
         this.FSpriteCommunicateDescription = new Vector.<String>();
         _loc2_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_HomeGirlMood);
         _loc1_ = 0;
         while(_loc1_ < _loc2_.Count)
         {
            _loc5_ = _loc2_.GetDatebaseByIndex(_loc1_) as THomeGirlMood;
            _loc3_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_Article,_loc5_.NormalCommunicateReward.Code) as TArticle;
            _loc4_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_Article,_loc5_.GoldCommunicateReward.Code) as TArticle;
            _loc6_ = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.GirlFriend_STRING_19),this.FGirlMoods[_loc1_],_loc5_.NormalCommunicateReward.Amount.toString(),_loc3_.Name,_loc5_.GoldCommunicateReward.Amount.toString(),_loc4_.Name);
            this.FSpriteCommunicateDescription.push(_loc6_);
            _loc1_++;
         }
      }
      
      public function Update_Perform() : void
      {
         this.FTF_CommunicateTime.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.GirlFriend_STRING_1),this.FGirlFriend.CurrentSpriteCommunicateTime,this.FGirlFriend.CanCommunicateTime);
         if(this.FGirlFriend.GirlMood != 0)
         {
            if(!Visible)
            {
               this.FGirlFriend.GirlMood = 0;
            }
            else
            {
               this.FFrameBlank = 5;
               this.FSelectBoxCurrentIndex = 0;
               this.FSelectBox.x = StartX;
               this.FCurrentEffectState = this.FEffectState_Loop;
            }
            this.FBTN_GoldCommunicate.Enabled = false;
            this.FBTN_NormalCommunicate.Enabled = false;
         }
      }
      
      protected function CheckSpriteCommunicateCondition() : Boolean
      {
         var _loc1_:Boolean = false;
         var _loc2_:int = 0;
         var _loc3_:Function = null;
         _loc2_ = 0;
         while(_loc2_ < this.FCheckCondition.length)
         {
            _loc3_ = this.FCheckCondition[_loc2_];
            if(!_loc3_())
            {
               return false;
            }
            _loc2_++;
         }
         return true;
      }
      
      protected function CheckCanSpriteCommunicateTime() : Boolean
      {
         if(this.FGirlFriend.CurrentSpriteCommunicateTime >= this.FGirlFriend.CanCommunicateTime)
         {
            EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.GirlFriend_STRING_7));
            return false;
         }
         return true;
      }
      
      protected function CheckIfCDTime() : Boolean
      {
         if(this.FTimeCoolDown.TimingTime > 0)
         {
            EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.GirlFriend_STRING_8));
            return false;
         }
         return true;
      }
      
      protected function CheckIfEnoughCoin() : Boolean
      {
         switch(this.FCurrentSpriteCommunicateType)
         {
            case CONST_GIRLFRIEND.CommunicateType_Normal:
               if(SLogicsCore.Character.CreditSilverCoin.ToNumber() < this.FGirlFriend.NomalSpriteCommunicateCost)
               {
                  EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.GirlFriend_STRING_10));
                  return false;
               }
               break;
            case CONST_GIRLFRIEND.CommunicateType_Gold:
               if(SLogicsCore.Character.CreditGold + SLogicsCore.Character.CreditGiftCertificate < this.FGirlFriend.GoldSpriteCommunicateCost)
               {
                  EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.GirlFriend_STRING_11));
                  return false;
               }
         }
         return true;
      }
      
      protected function RequestGoldCommunicate() : void
      {
         var _loc1_:TPacket = null;
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Home_GirlFriendSpriteCommnicate);
         _loc1_.Data.writeByte(CONST_GIRLFRIEND.CommunicateType_Gold);
         SNetworkCore.Transceiver.PacketTransmit(_loc1_);
      }
      
      protected function PlayEffect() : void
      {
         if(this.FFrameBlank > ++this.FTimePassed)
         {
            return;
         }
         this.GotoNextPosition();
         this.FTimePassed = 0;
         switch(this.FCurrentEffectState)
         {
            case this.FEffectState_Loop:
               this.FFrameBlank = this.FEffectLoopTimeBlank;
               if(this.FSelectBoxCurrentIndex == this.FHeadNum - 1)
               {
                  if(++this.FLoopCount >= this.FEffectLoopCount)
                  {
                     this.FCurrentEffectState = this.FEffectState_SlowDown;
                  }
               }
               break;
            case this.FEffectState_SlowDown:
               this.FFrameBlank += 1;
               if(this.FSelectBoxCurrentIndex == this.FHeadNum - 1)
               {
                  if(++this.FSlowDownCount == 1)
                  {
                     this.FCurrentEffectState = this.FEffectState_Location;
                  }
               }
               break;
            case this.FEffectState_Location:
               this.FFrameBlank += 1;
               if(this.FSelectBoxCurrentIndex == this.FGirlFriend.GirlMood - 1)
               {
                  this.EffectOver();
               }
         }
      }
      
      protected function EffectOver() : void
      {
         var _loc1_:TArticle = null;
         var _loc2_:String = null;
         var _loc3_:String = null;
         this.FGirlFriend.GirlMood = 0;
         this.FLoopCount = 0;
         this.FSlowDownCount = 0;
         _loc1_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_Article,this.FGirlFriend.SpriteCommunicateAwardID) as TArticle;
         _loc2_ = _loc1_.Name;
         _loc3_ = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.GirlFriend_STRING_23),this.FGirlMoods[this.FSelectBoxCurrentIndex],_loc2_,this.FGirlFriend.SpriteCommunicateAwardNum);
         EffectGenerateText(_loc3_);
         this.FBTN_GoldCommunicate.Enabled = true;
         this.FBTN_NormalCommunicate.Enabled = true;
         if(this.FPlayRewardEffect != null)
         {
            this.FPlayRewardEffect();
         }
      }
      
      protected function GotoNextPosition() : void
      {
         ++this.FSelectBoxCurrentIndex;
         this.FSelectBoxCurrentIndex %= this.FHeadNum;
         this.FSelectBox.x = StartX + DisBlank * this.FSelectBoxCurrentIndex;
      }
      
      protected function OnClearTimeOk(param1:Object) : void
      {
         var _loc2_:TPacket = null;
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Home_GirlFriendClearSpriteCommnicateCD);
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
      }
      
      protected function BtnNormalCommunicateClicked(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:Boolean = false;
         var _loc4_:TPacket = null;
         TutorialNextStep(CONST_FRESHGUIDE.EVENTID_ClickSpriteCommunicateNormal);
         this.FCurrentSpriteCommunicateType = CONST_GIRLFRIEND.CommunicateType_Normal;
         _loc3_ = this.CheckSpriteCommunicateCondition();
         if(!_loc3_)
         {
            return;
         }
         _loc4_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Home_GirlFriendSpriteCommnicate);
         _loc4_.Data.writeByte(CONST_GIRLFRIEND.CommunicateType_Normal);
         SNetworkCore.Transceiver.PacketTransmit(_loc4_);
      }
      
      protected function BtnGoldCommunicateClicked(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TPacket = null;
         var _loc4_:Boolean = false;
         this.FCurrentSpriteCommunicateType = CONST_GIRLFRIEND.CommunicateType_Gold;
         _loc4_ = this.CheckSpriteCommunicateCondition();
         if(!_loc4_)
         {
            return;
         }
         if(this.FNeedWarn)
         {
            this.FUIWindowConfirmation.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.GirlFriend_STRING_12),this.FGirlFriend.GoldSpriteCommunicateCost);
            this.FUIWindowConfirmation.visible = true;
         }
         else
         {
            this.RequestGoldCommunicate();
         }
      }
      
      protected function NormalBtnOnMove(param1:Object, param2:MouseEvent) : void
      {
         if(this.FHintOnOver != null)
         {
            this.FHeadInfor.Caption = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.GirlFriend_STRING_20);
            this.FHintOnOver(this,this.FHeadInfor);
         }
      }
      
      protected function SoulBtnOnMove(param1:Object, param2:MouseEvent) : void
      {
         if(this.FHintOnOver != null)
         {
            this.FHeadInfor.Caption = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.GirlFriend_STRING_21);
            this.FHintOnOver(this,this.FHeadInfor);
         }
      }
      
      protected function BtnOnOut(param1:Object, param2:MouseEvent) : void
      {
         if(this.FHintOnOut != null)
         {
            this.FHintOnOut(this,this.FHeadInfor);
         }
      }
      
      protected function BtnClearClicked(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         _loc3_ = Math.ceil(this.FTimeCoolDown.TimingTime / 60);
         this.FWindowClearCDTimeConfirmation.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.GirlFriend_STRING_24),_loc3_);
         this.FWindowClearCDTimeConfirmation.OnOK = this.OnClearTimeOk;
         this.FWindowClearCDTimeConfirmation.visible = true;
      }
      
      protected function WindowOnOK(param1:Object) : void
      {
         if(this.FUIWindowConfirmation.IsSelected)
         {
            this.FNeedWarn = false;
         }
         this.RequestGoldCommunicate();
      }
      
      protected function HeadOnOver(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         _loc2_ = this.FHeadPic.indexOf(param1.currentTarget as MovieClip);
         if(this.FHintOnOver != null)
         {
            this.FHeadInfor.Caption = this.FSpriteCommunicateDescription[_loc2_];
            this.FHintOnOver(this,this.FHeadInfor);
         }
      }
      
      protected function HeadOnOut(param1:Object) : void
      {
         if(this.FHintOnOut != null)
         {
            this.FHintOnOut(this,this.FHeadInfor);
         }
      }
      
      public function set HintOnOver(param1:Function) : void
      {
         this.FHintOnOver = param1;
      }
      
      public function set HintOnOut(param1:Function) : void
      {
         this.FHintOnOut = param1;
      }
      
      public function set PlayRewardEffect(param1:Function) : void
      {
         this.FPlayRewardEffect = param1;
      }
      
      public function UIDispatch(param1:MovieClip) : void
      {
         this.UIDispatch_Peform(param1);
      }
      
      public function UILocation() : void
      {
         this.UILocation_Peform();
      }
      
      public function Update() : void
      {
         this.Update_Perform();
      }
      
      public function GetMovieClipByMood(param1:int) : Sprite
      {
         return this.FHeadPic[param1 - 1];
      }
      
      public function Reset() : void
      {
         this.FBTN_GoldCommunicate.Enabled = true;
         this.FBTN_NormalCommunicate.Enabled = true;
         this.FGirlFriend.GirlMood = 0;
         this.FTimePassed = 0;
         this.FLoopCount = 0;
         this.FSelectBoxCurrentIndex = 0;
         this.FCurrentEffectState = this.FEffectState_None;
      }
   }
}

