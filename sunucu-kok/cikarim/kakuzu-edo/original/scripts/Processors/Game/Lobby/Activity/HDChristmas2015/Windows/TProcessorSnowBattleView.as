package Processors.Game.Lobby.Activity.HDChristmas2015.Windows
{
   import Components.Slots.TUISlot;
   import Components.Standard.TUIButton;
   import Foundation.Timing.STimingCore;
   import Foundation.UI.TUIComponent;
   import Logics.DatebaseVO.VO.THDActivityBase;
   import Logics.HDActivityMode.TActivityAtoms;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDChristmas2015.TSnowBattleData;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDSingleWindowBase;
   import Processors.Game.Lobby.Jade.TJadeCommon;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import Utilities.Timing.TUtilityTiming;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.ui.Keyboard;
   
   public class TProcessorSnowBattleView extends TProcessorHDSingleWindowBase
   {
      
      protected const ArticleCount:uint = 4;
      
      protected const BlockCount:uint = 4;
      
      protected var Speed:int = 15;
      
      protected var FStartBtn:TUIButton;
      
      protected var FSlots:Vector.<TUISlot>;
      
      protected var FTitleReceiveBtn:TUIButton;
      
      protected var FArticleReceiveBtns:Vector.<TUIButton>;
      
      protected var FData:TSnowBattleData;
      
      protected var FStartTimestamp:int;
      
      protected var FCursor:MovieClip;
      
      protected var FBlock:Vector.<MovieClip>;
      
      protected var FStartBlock:MovieClip;
      
      protected var FEndBlock:MovieClip;
      
      protected var FGameStart:Boolean;
      
      protected var FLastTick:int;
      
      protected var FCardsBtn:TUIButton;
      
      public function TProcessorSnowBattleView(param1:TUIComponent)
      {
         super(param1);
         this.FGameStart = false;
      }
      
      override protected function Reset() : void
      {
         if(this.FData)
         {
            this.GameReset(true);
            stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.CallBack_KeyDown);
         }
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
         var _loc2_:MovieClip = null;
         var _loc3_:uint = 0;
         var _loc4_:TUIButton = null;
         var _loc5_:TUISlot = null;
         var _loc6_:Object = null;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:String = null;
         this.FData = param1 as TSnowBattleData;
         if(!this.FGameStart)
         {
            this.GameReset();
         }
         FScene["TF_TotalScore"].text = this.FData.TotalScore.toString();
         FScene["TF_GameCount"].text = this.FData.GameCount.toString();
         _loc2_ = FScene["MC_TitleGift"];
         _loc2_.TF_TotalValue.text = String(this.FData.Config.TitleGift.candy);
         _loc2_.MC_Geted.visible = this.FData.TitleState == Activity_AlreadyReceive;
         this.FTitleReceiveBtn.Enabled = !_loc2_.MC_Geted.visible && this.FData.TotalScore >= this.FData.Config.TitleGift.candy;
         _loc7_ = uint(this.FData.Config.Gift[this.ArticleCount - 1].candy);
         _loc3_ = 0;
         while(_loc3_ < this.ArticleCount)
         {
            _loc2_ = FScene["MC_Article_" + _loc3_];
            _loc6_ = this.FData.Config.Gift[_loc3_];
            _loc4_ = this.FArticleReceiveBtns[_loc3_];
            _loc5_ = this.FSlots[_loc3_];
            _loc8_ = this.FData.Wheel * _loc7_ + _loc6_.candy;
            _loc2_.TF_TotalValue.text = _loc8_.toString();
            _loc2_.MC_Geted.visible = this.FData.ArticleState[_loc3_] == Activity_AlreadyReceive;
            _loc5_.Context = this.FData.Invs.GetInventoryByIndex(_loc3_);
            _loc4_.Enabled = !_loc2_.MC_Geted.visible && this.FData.TotalScore >= _loc8_;
            _loc3_++;
         }
         if(this.FData.CurGetScore != -1)
         {
            _loc9_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ITEMNAME_Integral) + "*" + this.FData.CurGetScore;
            SToolReward.ShowMessage(_loc9_);
         }
         _loc3_ = 0;
         while(_loc3_ < this.BlockCount)
         {
            FScene["TF_Score_" + _loc3_].text = String(this.FData.Config.ResultType[_loc3_]);
            _loc3_++;
         }
         if(this.FCardsBtn)
         {
            this.FCardsBtn.Enabled = this.FData.CardsBtnState != Activity_AlreadyReceive;
         }
         this.FData.Reset();
      }
      
      override protected function LogicsPerform() : void
      {
         var _loc1_:TUISlot = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:MovieClip = null;
         var _loc5_:int = 0;
         super.LogicsPerform();
         if(!this.Visible)
         {
            return;
         }
         if(this.FData)
         {
            for each(_loc1_ in this.FSlots)
            {
               _loc1_.Update();
            }
            if(this.FGameStart)
            {
               _loc5_ = this.GetRemainTime();
               FScene["TF_Remain"].text = TUtilityTiming.fomatTimeTwo(_loc5_);
               this.FCursor.x += this.Speed;
               if(this.FCursor.x <= this.FStartBlock.x)
               {
                  this.FCursor.x = this.FStartBlock.x;
                  this.Speed *= -1;
               }
               else if(this.FCursor.x + this.FCursor.width >= this.FEndBlock.x + this.FEndBlock.width)
               {
                  this.FCursor.x = this.FEndBlock.x + this.FEndBlock.width - this.FCursor.width;
                  this.Speed *= -1;
               }
               if(_loc5_ <= 0)
               {
                  this.CallBack_KeyDown(null);
               }
            }
         }
      }
      
      protected function GameReset(param1:Boolean = false) : void
      {
         this.FStartTimestamp = STimingCore.ServerTick;
         this.FGameStart = false;
         FScene["TF_Remain"].text = TUtilityTiming.fomatTimeTwo(this.GetRemainTime());
         this.FStartBtn.Enabled = this.FData.GameCount > 0;
         if(param1)
         {
            this.FCursor.visible = false;
            this.FCursor.x = this.FStartBlock.x;
         }
         this.Speed = Math.abs(this.Speed);
      }
      
      protected function GetRemainTime() : int
      {
         var _loc1_:int = 0;
         _loc1_ = STimingCore.ServerTick - this.FStartTimestamp;
         return Math.max(0,this.FData.Config.Countdown - _loc1_);
      }
      
      protected function Launch() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:MovieClip = null;
         var _loc3_:Number = NaN;
         _loc3_ = this.FCursor.x + this.FCursor.width / 2;
         _loc1_ = 1;
         while(_loc1_ < this.BlockCount)
         {
            _loc2_ = this.FBlock[_loc1_];
            if(_loc2_.x > _loc3_)
            {
               break;
            }
            _loc1_++;
         }
         _loc1_--;
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FData.Config.Notify,0,Vector.<int>([this.FData.Config.ResultType[_loc1_]]));
         FScene["MC_SnowballEffect_" + _loc1_].gotoAndPlay(2);
      }
      
      protected function OnAddBtnClick(param1:MouseEvent) : void
      {
         GoldBuy(this.FData.Config.Gold,this.OnAddBtnClickOK);
      }
      
      protected function OnStartBtnClick(param1:Object, param2:MouseEvent) : void
      {
         this.GameReset(true);
         this.FGameStart = true;
         this.FStartBtn.Enabled = false;
         this.FCursor.visible = true;
         this.FLastTick = STimingCore.TickCount;
         stage.addEventListener(KeyboardEvent.KEY_DOWN,this.CallBack_KeyDown);
      }
      
      protected function OnArticleReceiveBtnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:Object = null;
         _loc3_ = this.FData.Config.Gift[param1.Tag];
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,_loc3_.index);
      }
      
      protected function OnTitleReceiveBtnClick(param1:Object, param2:MouseEvent) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FData.Config.TitleGift.index);
      }
      
      protected function OnAddBtnClickOK(param1:Object) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FData.Config.BuyIndex);
      }
      
      protected function CallBack_KeyDown(param1:KeyboardEvent) : void
      {
         if((param1 == null || param1.keyCode == Keyboard.SPACE) && this.FGameStart)
         {
            this.GameReset();
            this.Launch();
         }
      }
      
      protected function OnCardsBtnClick(param1:Object, param2:MouseEvent) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FData.CardsIndex);
      }
      
      override public function InitWindow(param1:Sprite = null) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:TUISlot = null;
         var _loc4_:TUIButton = null;
         var _loc5_:MovieClip = null;
         super.InitWindow(param1);
         FScene["Btn_AddCount"].addEventListener(MouseEvent.CLICK,this.OnAddBtnClick);
         this.FStartBtn = new TUIButton();
         this.FStartBtn.Substrate = FScene["Btn_Start"];
         this.FStartBtn.OnClick = this.OnStartBtnClick;
         this.FTitleReceiveBtn = new TUIButton();
         this.FTitleReceiveBtn.Substrate = FScene["MC_TitleGift"].Btn_Receive;
         this.FTitleReceiveBtn.OnClick = this.OnTitleReceiveBtnClick;
         this.FSlots = new Vector.<TUISlot>();
         this.FArticleReceiveBtns = new Vector.<TUIButton>();
         _loc2_ = 0;
         while(_loc2_ < this.ArticleCount)
         {
            _loc5_ = FScene["MC_Article_" + _loc2_];
            _loc3_ = new TUISlot(this);
            _loc3_.Resource = _loc5_.MC_Slot.Slot;
            _loc3_.OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
            _loc3_.OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
            TJadeCommon.InitSlot(_loc3_);
            _loc3_.Init();
            this.FSlots[_loc2_] = _loc3_;
            _loc4_ = new TUIButton();
            _loc4_.Substrate = _loc5_.Btn_Receive;
            _loc4_.OnClick = this.OnArticleReceiveBtnClick;
            this.FArticleReceiveBtns[_loc2_] = _loc4_;
            _loc4_.Tag = _loc2_;
            _loc2_++;
         }
         this.FCursor = FScene["MC_Cursor"];
         this.FBlock = new Vector.<MovieClip>();
         _loc2_ = 0;
         while(_loc2_ < this.BlockCount)
         {
            this.FBlock[_loc2_] = FScene["MC_Score_" + _loc2_];
            _loc2_++;
         }
         this.FStartBlock = this.FBlock[0];
         this.FEndBlock = this.FBlock[this.BlockCount - 1];
         this.FCursor.visible = false;
         this.FCursor.x = this.FStartBlock.x;
         _loc5_ = FScene["MC_CardsBtn"];
         if(_loc5_)
         {
            this.FCardsBtn = new TUIButton();
            this.FCardsBtn.Substrate = _loc5_;
            this.FCardsBtn.OnClick = this.OnCardsBtnClick;
         }
      }
      
      override public function Show(param1:TActivityAtoms = null, param2:THDActivityBase = null, param3:TActivityOSBase = null) : void
      {
         super.Show(param1,param2,param3);
      }
   }
}

