package Processors.Game.Lobby.ReveredBook
{
   import Components.Standard.*;
   import Foundation.Network.SNetworkCore;
   import Foundation.Network.TPacket;
   import Foundation.UI.*;
   import Logics.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.ReveredBook.*;
   import Logics.ReveredBook.Decoder.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Resources.Constants.CONST_FRESHGUIDE;
   import Resources.Constants.CONST_NETWORK;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   import flash.utils.ByteArray;
   
   public class TComponentTeaching extends TProcessorLobbyWindow
   {
      
      protected static const SelectBoxNum:int = 3;
      
      protected var FMainUI:Sprite;
      
      protected var FTFQuestion:TextField;
      
      protected var FAnswerSelectButton:Vector.<TUIButton>;
      
      protected var FAnswerWaitSelectButton:Vector.<TUIButton>;
      
      protected var FTFAnswers:Vector.<TextField>;
      
      protected var FTFReward:TextField;
      
      protected var FBtn_Ensure:TUIButton;
      
      protected var FBtn_NextQuestion:TUIButton;
      
      protected var FBtn_GoFight:TUIButton;
      
      protected var FReveredBookQuestions:TReveredBookQuestions = new TReveredBookQuestions();
      
      protected var FCurrentSeverQustionIndex:int;
      
      protected var FAnswerIndex:int;
      
      protected var FUnstreamizerReveredBook:TUnstreamizerReveredBook;
      
      protected var FCurrentSeverQustionID:uint;
      
      public function TComponentTeaching(param1:TUIComponent)
      {
         super(param1);
      }
      
      protected function UIDispatch() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Sprite = null;
         var _loc3_:TUIButton = null;
         this.FTFQuestion = this.FMainUI["Title"];
         this.FAnswerSelectButton = new Vector.<TUIButton>();
         this.FAnswerWaitSelectButton = new Vector.<TUIButton>();
         this.FTFAnswers = new Vector.<TextField>();
         _loc1_ = 0;
         while(_loc1_ < SelectBoxNum)
         {
            _loc2_ = this.FMainUI["SelectBox" + _loc1_];
            _loc3_ = new TUIButton();
            _loc3_.Substrate = _loc2_["Selected"];
            this.FAnswerSelectButton.push(_loc3_);
            _loc3_ = new TUIButton();
            _loc3_.Substrate = _loc2_["Unselected"];
            this.FAnswerWaitSelectButton.push(_loc3_);
            _loc3_.OnClick = this.WaitSelectBoxOnClick;
            this.FTFAnswers.push(this.FMainUI["Answer" + _loc1_]);
            _loc1_++;
         }
         this.FTFReward = this.FMainUI["RewardPanle"];
         this.FBtn_Ensure = new TUIButton();
         this.FBtn_Ensure.Substrate = this.FMainUI["Btn_Ensure"];
         this.FBtn_GoFight = new TUIButton();
         this.FBtn_GoFight.Substrate = this.FMainUI["Btn_Fight"];
         this.FBtn_GoFight.StopPropagation();
         this.FBtn_NextQuestion = new TUIButton();
         this.FBtn_NextQuestion.Substrate = this.FMainUI["Btn_NextQuestion"];
      }
      
      protected function UILocation() : void
      {
         this.FBtn_Ensure.OnClick = this.BtnEnsureOnMouseClick;
         this.FBtn_GoFight.OnClick = this.BtnGoFightOnMouseClick;
         this.FBtn_NextQuestion.OnClick = this.BtnNextOnMouseClick;
      }
      
      protected function CheckSeverQustionIndex() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         this.FUnstreamizerReveredBook.UnstreamizationQuestion(null,this.FReveredBookQuestions,null);
         _loc2_ = int(this.FReveredBookQuestions.Questions.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            if(this.FReveredBookQuestions.Questions[_loc1_].ID == this.FCurrentSeverQustionID)
            {
               this.FCurrentSeverQustionIndex = _loc1_;
               break;
            }
            _loc1_++;
         }
         if(this.FCurrentSeverQustionID != 0)
         {
            ++this.FCurrentSeverQustionIndex;
         }
      }
      
      protected function RenderingQuestion() : void
      {
         var _loc1_:TReveredBookQuestion = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         _loc1_ = this.FReveredBookQuestions.Questions[this.FCurrentSeverQustionIndex];
         this.GarbleQustion(_loc1_);
         this.FTFQuestion.text = _loc1_.Question;
         _loc2_ = 0;
         while(_loc2_ < SelectBoxNum)
         {
            this.FTFAnswers[_loc2_].text = _loc1_.Answers[_loc2_];
            _loc2_++;
         }
         this.ClearAnswerTrace();
         this.HideAllButton();
         this.FBtn_Ensure.Visible = true;
         this.FBtn_Ensure.Enabled = false;
      }
      
      protected function WaitSelectBoxOnClick(param1:Object, param2:MouseEvent) : void
      {
         this.ClearAnswerTrace();
         this.FAnswerIndex = this.FAnswerWaitSelectButton.indexOf(param1 as TUIButton);
         this.FAnswerSelectButton[this.FAnswerIndex].Visible = true;
         this.FBtn_Ensure.Enabled = true;
         TutorialNextStep(CONST_FRESHGUIDE.EVENTID_ClickItemBox);
      }
      
      protected function ClearAnswerTrace() : void
      {
         var _loc1_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < SelectBoxNum)
         {
            this.FAnswerSelectButton[_loc1_].Visible = false;
            _loc1_++;
         }
         this.FAnswerIndex = -1;
      }
      
      protected function HideAllButton() : void
      {
         this.FBtn_Ensure.Visible = false;
         this.FBtn_GoFight.Visible = false;
         this.FBtn_NextQuestion.Visible = false;
      }
      
      protected function SetVisibleSelectBox(param1:Boolean) : void
      {
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < SelectBoxNum)
         {
            this.FAnswerSelectButton[_loc2_].Visible = param1;
            this.FAnswerWaitSelectButton[_loc2_].Visible = param1;
            this.FTFAnswers[_loc2_].visible = param1;
            _loc2_++;
         }
      }
      
      protected function GarbleQustion(param1:TReveredBookQuestion) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         _loc3_ = int(param1.Answers.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = int(Math.random() * 800) % 3;
            _loc5_ = param1.Answers[_loc2_];
            _loc6_ = param1.Answers[_loc4_];
            param1.Answers[_loc2_] = _loc6_;
            param1.Answers[_loc4_] = _loc5_;
            _loc5_ = param1.Responded[_loc2_];
            _loc6_ = param1.Responded[_loc4_];
            param1.Responded[_loc2_] = _loc6_;
            param1.Responded[_loc4_] = _loc5_;
            _loc5_ = param1.Rewards[_loc2_];
            _loc6_ = param1.Rewards[_loc4_];
            param1.Rewards[_loc2_] = _loc6_;
            param1.Rewards[_loc4_] = _loc5_;
            _loc7_ = param1.InitialIndex[_loc2_];
            _loc8_ = param1.InitialIndex[_loc4_];
            param1.InitialIndex[_loc2_] = _loc8_;
            param1.InitialIndex[_loc4_] = _loc7_;
            _loc2_++;
         }
      }
      
      protected function RenderingReward() : void
      {
         this.FTFQuestion.text = this.FReveredBookQuestions.Questions[this.FCurrentSeverQustionIndex].Responded[this.FAnswerIndex];
         this.FTFReward.text = this.FReveredBookQuestions.Questions[this.FCurrentSeverQustionIndex].Rewards[this.FAnswerIndex];
         this.HideAllButton();
         this.FBtn_NextQuestion.Visible = true;
      }
      
      protected function SetVisibleRewardField(param1:Boolean) : void
      {
         this.FTFReward.visible = param1;
      }
      
      protected function RenderingPromptFight() : void
      {
         var _loc1_:Boolean = false;
         _loc1_ = this.VerificationQustionNum();
         if(!_loc1_)
         {
            this.FTFReward.text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_Nip_05);
            this.HideAllButton();
            this.FBtn_GoFight.Visible = true;
            return;
         }
         _loc1_ = this.VerificationLevel();
         if(!_loc1_)
         {
            this.FTFReward.text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_Nip_06);
            this.HideAllButton();
            this.FBtn_GoFight.Visible = true;
            return;
         }
      }
      
      protected function TryGotoNext() : void
      {
         if(!this.VerificationQustionNum() || !this.VerificationLevel())
         {
            this.SetVisibleSelectBox(false);
            this.SetVisibleRewardField(true);
            this.RenderingPromptFight();
         }
         else
         {
            this.SetVisibleSelectBox(true);
            this.ClearAnswerTrace();
            this.SetVisibleRewardField(false);
            this.RenderingQuestion();
         }
      }
      
      protected function VerificationQustionNum() : Boolean
      {
         return this.FCurrentSeverQustionIndex < this.FReveredBookQuestions.Questions.length - 1;
      }
      
      protected function VerificationLevel() : Boolean
      {
         return this.FReveredBookQuestions.Questions[this.FCurrentSeverQustionIndex].Level <= SLogicsCore.Character.GetMainLevel();
      }
      
      protected function BtnEnsureOnMouseClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:ByteArray = null;
         var _loc4_:TReveredBookQuestion = null;
         var _loc5_:TPacket = null;
         _loc4_ = this.FReveredBookQuestions.Questions[this.FCurrentSeverQustionIndex];
         _loc5_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_ReveredBook_QuestionReq);
         _loc3_ = _loc5_.Data;
         _loc3_.writeUnsignedInt(_loc4_.ID);
         _loc3_.writeUnsignedInt(_loc4_.InitialIndex[this.FAnswerIndex]);
         SNetworkCore.Transceiver.PacketTransmit(_loc5_);
         TutorialNextStep(CONST_FRESHGUIDE.EVENTID_ClickEnsure);
      }
      
      protected function BtnNextOnMouseClick(param1:Object, param2:MouseEvent) : void
      {
         this.TryGotoNext();
      }
      
      protected function BtnGoFightOnMouseClick(param1:Object, param2:MouseEvent) : void
      {
         ProcessorWindowClose();
      }
      
      public function set UnstreamizerReveredBook(param1:TUnstreamizerReveredBook) : void
      {
         this.FUnstreamizerReveredBook = param1;
      }
      
      public function get TabInfor() : Vector.<String>
      {
         return null;
      }
      
      public function set CurrentSeverQustionID(param1:int) : void
      {
         this.FCurrentSeverQustionID = param1;
         this.CheckSeverQustionIndex();
      }
      
      public function get CurrentSeverQustionID() : int
      {
         return this.FCurrentSeverQustionID;
      }
      
      public function LoadResource(param1:Sprite) : void
      {
         this.FMainUI = param1;
         addChild(this.FMainUI);
         this.UIDispatch();
         this.UILocation();
      }
      
      override public function set visible(param1:Boolean) : void
      {
         super.visible = param1;
         if(param1)
         {
            this.TryGotoNext();
         }
      }
      
      public function AnswerQustionNotify() : void
      {
         this.SetVisibleSelectBox(false);
         this.SetVisibleRewardField(true);
         this.RenderingReward();
         ++this.FCurrentSeverQustionIndex;
         ++this.FCurrentSeverQustionID;
      }
      
      public function Reset() : void
      {
      }
      
      public function IfHaveQuestionCanAnswer() : Boolean
      {
         return this.VerificationQustionNum() && this.VerificationLevel();
      }
   }
}

