package Processors.Game.Lobby.Activity.HDRandCard
{
   import Components.ScrollBar.*;
   import Components.Standard.*;
   import Foundation.Timing.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.DatebaseVO.VO.Json.*;
   import Logics.HDActivityMode.*;
   import Logics.HDActivityOS.*;
   import Logics.HDRandCard.*;
   import Logics.Inventories.*;
   import Logics.Log.*;
   import Processors.Game.Lobby.Activity.HDActivity.*;
   import Processors.Game.Lobby.Activity.HDRandCard.Compent.TUIActivityRCCard;
   import Processors.Game.Utilities.EffectTextReward.*;
   import Processors.Game.Utilities.OverLayer.*;
   import Resources.Constants.*;
   import Utilities.Timing.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   import ghostcat.util.data.*;
   
   public class TProcessorHDWindowRandCard extends TProcessorHDSingleWindowBase
   {
      
      protected static const COUNT_MC_AwardCard:uint = 5;
      
      protected static const WIDTH_SCORE_Total:uint = 85;
      
      protected var FBtn_HDDesc:TUIButton;
      
      protected var FSP_GoldCard:Sprite;
      
      protected var FSP_SuperCard:Sprite;
      
      protected var FSP_GoldMain:Sprite;
      
      protected var FSP_SuperMain:Sprite;
      
      protected var FMC_GoldShuffle:MovieClip;
      
      protected var FMC_GoldCards:Vector.<TUIActivityRCCard>;
      
      protected var FBtn_GoldStart:TUIButton;
      
      protected var FBtn_GoldRestart:TUIButton;
      
      protected var FBtn_GoldRefresh:TUIButton;
      
      protected var FTF_CoolingDown:TextField;
      
      protected var FTF_CostGold:TextField;
      
      protected var FMC_SuperCards:Vector.<TUIActivityRCCard>;
      
      protected var FMC_SuperShuffle:MovieClip;
      
      protected var FBtn_SuperStart:TUIButton;
      
      protected var FBtn_SuperRestart:TUIButton;
      
      protected var FTF_SuperLimitCount:TextField;
      
      protected var FTF_PromptSuperCard:TextField;
      
      protected var FSP_BarLoad:Sprite;
      
      protected var FTF_BarLoad:TextField;
      
      protected var FSP_AwardLog:Sprite;
      
      protected var FScrollBar:TScrollBar;
      
      protected var FIsInitWindow:Boolean;
      
      protected var FIsInitData:Boolean;
      
      protected var FDataRandCard:TActivityRandCard;
      
      protected var FHDRandCard:THDRandCard;
      
      protected var FSuperInventoriesVect:Vector.<TInventories>;
      
      protected var FFreeTime:int;
      
      protected var FSuperStartCount:int;
      
      protected var FIsGoldStartOpreate:Boolean;
      
      protected var FIsSuperStartOpreate:Boolean;
      
      protected var FIsGoldCardOnOpreate:Boolean;
      
      protected var FIsGoldRefreshOpreate:Boolean;
      
      protected var FIsGoldRestartOpereate:Boolean;
      
      protected var FVectInt:Vector.<int>;
      
      protected var FOnLoadLog:Function;
      
      public function TProcessorHDWindowRandCard(param1:TUIComponent)
      {
         super(param1);
         FSceneResourceName = CONST_ACTIVITY.RESOURCE_ClassName_ActivitySingleRandCard;
         this.FIsInitWindow = false;
         this.FIsInitData = false;
         this.FIsGoldStartOpreate = false;
         this.FIsSuperStartOpreate = false;
         this.FIsGoldCardOnOpreate = false;
      }
      
      override protected function LogicsPerform() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         super.LogicsPerform();
         if(!this.FIsInitData)
         {
            return;
         }
         if(this.FDataRandCard.FreeCoolingTime - STimingCore.ServerTick >= 0)
         {
            this.FTF_CoolingDown.text = TUtilityString.Format(this.FHDRandCard.Prompts.Prompt0,TUtilityTiming.fomatTime(this.FDataRandCard.FreeCoolingTime - STimingCore.ServerTick));
         }
         if(this.FMC_GoldShuffle.currentFrame == this.FMC_GoldShuffle.totalFrames || this.FMC_GoldShuffle.currentFrame == 1)
         {
            this.FMC_GoldShuffle.stop();
            this.FMC_GoldShuffle.visible = false;
         }
         if(this.FMC_GoldShuffle.currentFrame == 8)
         {
            this.HideShowGoldBaseCards(true);
         }
         if(this.FMC_SuperShuffle.currentFrame == this.FMC_SuperShuffle.totalFrames || this.FMC_SuperShuffle.currentFrame == 1)
         {
            this.FMC_SuperShuffle.stop();
            this.FMC_SuperShuffle.visible = false;
         }
         _loc2_ = int(this.FMC_GoldCards.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FMC_GoldCards[_loc1_].LogicsPerform();
            _loc1_++;
         }
         _loc2_ = int(this.FMC_SuperCards.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FMC_SuperCards[_loc1_].LogicsPerform();
            _loc1_++;
         }
      }
      
      override public function InitWindow(param1:Sprite = null) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Sprite = null;
         super.InitWindow(param1);
         this.FBtn_HDDesc = new TUIButton();
         this.FBtn_HDDesc.Substrate = FScene[CONST_ACTIVITY.RESOURCE_Link_MC_HDDesc];
         this.FBtn_HDDesc.OnMove = this.BtnHDDescOnOver;
         this.FBtn_HDDesc.OnOut = this.BtnHDDescOnOut;
         this.FSP_GoldCard = FScene[CONST_ACTIVITY.RESOURCE_Link_MC_GoldCard];
         this.FSP_GoldMain = this.FSP_GoldCard[CONST_ACTIVITY.RESOURCE_Link_MC_CardMain];
         this.FBtn_GoldStart = new TUIButton();
         this.FBtn_GoldStart.Substrate = this.FSP_GoldCard[CONST_ACTIVITY.RESOURCE_Link_Btn_Start];
         this.FBtn_GoldStart.OnClick = this.BtnGoldStartOnClick;
         this.FBtn_GoldStart.OnMove = this.BtnGoldStartOnOver;
         this.FBtn_GoldStart.OnOut = this.BtnGoldStartOnOut;
         this.FBtn_GoldStart.Enabled = false;
         this.FBtn_GoldRestart = new TUIButton();
         this.FBtn_GoldRestart.Substrate = this.FSP_GoldCard[CONST_ACTIVITY.RESOURCE_Link_Btn_Restart];
         this.FBtn_GoldRestart.OnClick = this.BtnGoldRestartOnClick;
         this.FBtn_GoldRestart.Enabled = false;
         this.FBtn_GoldRefresh = new TUIButton();
         this.FBtn_GoldRefresh.Substrate = this.FSP_GoldCard[CONST_ACTIVITY.RESOURCE_Link_Btn_Refresh];
         this.FBtn_GoldRefresh.OnClick = this.BtnGoldRefreshOnClick;
         this.FBtn_GoldRefresh.OnMove = this.BtnGoldRefreshOnOver;
         this.FBtn_GoldRefresh.OnOut = this.BtnGoldRefreshOnOut;
         this.FBtn_GoldRefresh.Enabled = false;
         this.FTF_CoolingDown = this.FSP_GoldCard[CONST_ACTIVITY.RESOURCE_Link_TF_CoolingDown];
         this.FTF_CoolingDown.mouseEnabled = false;
         _loc4_ = this.FSP_GoldCard[CONST_ACTIVITY.RESOURCE_Link_MC_CostGold];
         this.FTF_CostGold = _loc4_[CONST_ACTIVITY.RESOURCE_Link_TF_CostGold];
         this.FTF_CostGold.mouseEnabled = false;
         this.FMC_GoldShuffle = this.FSP_GoldCard[CONST_ACTIVITY.RESOURCE_Link_MC_ShuffleCard];
         this.FMC_GoldShuffle.mouseChildren = false;
         this.FMC_GoldShuffle.mouseEnabled = false;
         this.FMC_GoldShuffle.visible = false;
         this.FMC_GoldShuffle.stop();
         _loc3_ = int(COUNT_MC_AwardCard);
         this.FMC_GoldCards = new Vector.<TUIActivityRCCard>(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FMC_GoldCards[_loc2_] = new TUIActivityRCCard(this);
            this.FMC_GoldCards[_loc2_].AwardCardOnClick = this.BtnGoldCardOnClick;
            this.FMC_GoldCards[_loc2_].QueryOnSequenceContext = SlotsOnQuerySequenceContext;
            this.FMC_GoldCards[_loc2_].QueryOnSubscript = SlotsOnQuerySubscript;
            this.FMC_GoldCards[_loc2_].SlotOnOver = ProcessorOnSlotOver;
            this.FMC_GoldCards[_loc2_].SlotOnOut = ProcessorOnSlotOut;
            this.FMC_GoldCards[_loc2_].Perform_UIDispatch(this,this.FSP_GoldMain[CONST_ACTIVITY.RESOURCE_Link_MC_Cards + _loc2_],CONST_ACTIVITY_MODE.TYPE_RC_Gold);
            _loc2_++;
         }
         this.FSP_SuperCard = FScene[CONST_ACTIVITY.RESOURCE_Link_MC_SuperCard];
         this.FSP_SuperMain = this.FSP_SuperCard[CONST_ACTIVITY.RESOURCE_Link_MC_CardMain];
         this.FMC_SuperShuffle = this.FSP_SuperCard[CONST_ACTIVITY.RESOURCE_Link_MC_ShuffleCard];
         this.FMC_SuperShuffle.mouseChildren = false;
         this.FMC_SuperShuffle.mouseEnabled = false;
         this.FMC_SuperShuffle.visible = false;
         this.FMC_SuperShuffle.stop();
         this.FBtn_SuperStart = new TUIButton();
         this.FBtn_SuperStart.Substrate = this.FSP_SuperCard[CONST_ACTIVITY.RESOURCE_Link_Btn_Start];
         this.FBtn_SuperStart.OnClick = this.BtnSuperStartOnClick;
         this.FBtn_SuperStart.Enabled = false;
         this.FBtn_SuperRestart = new TUIButton();
         this.FBtn_SuperRestart.Substrate = this.FSP_SuperCard[CONST_ACTIVITY.RESOURCE_Link_Btn_Restart];
         this.FBtn_SuperRestart.OnClick = this.BtnSuperRestartOnClick;
         this.FBtn_SuperRestart.Enabled = false;
         _loc3_ = int(COUNT_MC_AwardCard);
         this.FMC_SuperCards = new Vector.<TUIActivityRCCard>(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FMC_SuperCards[_loc2_] = new TUIActivityRCCard(this);
            this.FMC_SuperCards[_loc2_].AwardCardOnClick = this.BtnSuperCardOnClick;
            this.FMC_SuperCards[_loc2_].SlotOnOver = ProcessorOnSlotOver;
            this.FMC_SuperCards[_loc2_].SlotOnOut = ProcessorOnSlotOut;
            this.FMC_SuperCards[_loc2_].QueryOnSequenceContext = SlotsOnQuerySequenceContext;
            this.FMC_SuperCards[_loc2_].QueryOnSubscript = SlotsOnQuerySubscript;
            this.FMC_SuperCards[_loc2_].Perform_UIDispatch(this,this.FSP_SuperMain[CONST_ACTIVITY.RESOURCE_Link_MC_Cards + _loc2_],CONST_ACTIVITY_MODE.TYPE_RC_Super);
            _loc2_++;
         }
         _loc4_ = this.FSP_SuperCard[CONST_ACTIVITY.RESOURCE_Link_MC_Bar];
         this.FSP_BarLoad = _loc4_[CONST_ACTIVITY.RESOURCE_Link_MC_BarLoad];
         this.FTF_BarLoad = _loc4_[CONST_ACTIVITY.RESOURCE_Link_TF_BarLoad];
         this.FTF_SuperLimitCount = this.FSP_SuperCard[CONST_ACTIVITY.RESOURCE_Link_TF_LimitCount];
         this.FTF_SuperLimitCount.mouseEnabled = false;
         this.FTF_PromptSuperCard = this.FSP_SuperCard[CONST_ACTIVITY.RESOURCE_Link_TF_PromptSuperCard];
         this.FTF_PromptSuperCard.mouseEnabled = false;
         this.FSP_AwardLog = FScene[CONST_ACTIVITY.RESOURCE_Link_MC_AwardLog];
         this.FScrollBar = new TScrollBar(this.FSP_AwardLog["ScroolBarUI"],200,false);
         this.FScrollBar.Visible = false;
         this.FIsInitWindow = true;
         this.ResetTextField();
      }
      
      override protected function UpdateUIConfig() : void
      {
         super.UpdateUIConfig();
         this.FHDRandCard = FHDActivityConfig as THDRandCard;
         this.FTF_CostGold.text = "0";
         this.FTF_PromptSuperCard.text = this.FHDRandCard.Prompts.Prompt2;
      }
      
      override protected function UpdateDataBase(param1:TActivityOSBase) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Vector.<uint> = null;
         var _loc5_:TActivityRCAwardCard = null;
         var _loc6_:TActivityRCAwardCard = null;
         var _loc7_:TActivityRCButton = null;
         super.UpdateDataBase(param1);
         this.FDataRandCard = param1 as TActivityRandCard;
         _loc7_ = this.FDataRandCard.FreeTime;
         this.FIsInitData = true;
         this.ProcessorGetGoldInventories();
         _loc4_ = new Vector.<uint>(COUNT_MC_AwardCard);
         _loc3_ = COUNT_MC_AwardCard - 1;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc5_ = this.FDataRandCard.SuperAwards.RandAwards[_loc2_];
            _loc4_[_loc2_] = _loc5_.Award;
            _loc2_++;
         }
         _loc4_[_loc3_] = this.FDataRandCard.SuperAwards.FixAward;
         this.FSuperInventoriesVect = ProcessorGetInventoriesVectByAwardID(_loc4_);
         _loc3_ = int(COUNT_MC_AwardCard);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc5_ = this.FDataRandCard.CurGoldAwards.AwardCard[_loc2_];
            this.FMC_GoldCards[_loc2_].Show(_loc2_,_loc5_,this.FHDRandCard,FInventoriesVect[_loc2_]);
            if(_loc2_ == _loc3_ - 1)
            {
               _loc5_ = this.FDataRandCard.SuperAwards.FixedAward;
            }
            else
            {
               _loc5_ = this.FDataRandCard.SuperAwards.RandAwards[_loc2_];
            }
            this.FMC_SuperCards[_loc2_].Show(_loc2_,_loc5_,this.FHDRandCard,this.FSuperInventoriesVect[_loc2_]);
            _loc2_++;
         }
         this.UpdateUI();
      }
      
      protected function ProcessorGetGoldInventories() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Vector.<uint> = null;
         var _loc4_:TActivityRCAwardCard = null;
         _loc2_ = int(COUNT_MC_AwardCard);
         _loc3_ = new Vector.<uint>(_loc2_);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc4_ = this.FDataRandCard.CurGoldAwards.AwardCard[_loc1_];
            _loc3_[_loc1_] = _loc4_.Award;
            _loc1_++;
         }
         FInventoriesVect = ProcessorGetInventoriesVectByAwardID(_loc3_);
      }
      
      override protected function UpdateUI() : void
      {
         super.UpdateUI();
         this.UpdateUIScoreBar();
         this.UpdateUIGoldCard();
         this.UpdateUISuperCard();
      }
      
      protected function UpdateUIDeleteCost() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         _loc2_ = int(COUNT_MC_AwardCard);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            if(this.FDataRandCard.GetGoldCardByUIndex(_loc1_).IsDelete)
            {
               _loc3_++;
            }
            _loc1_++;
         }
         this.FTF_CostGold.text = (_loc3_ * this.FHDRandCard.DeleteCost).toString();
      }
      
      protected function UpdateUIScoreBar() : void
      {
         var _loc1_:TActivityRCScore = null;
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         _loc1_ = this.FDataRandCard.Score;
         _loc2_ = _loc1_.Num;
         _loc3_ = _loc1_.Condition;
         this.FSuperStartCount = _loc4_ = Math.floor(_loc2_ / _loc3_);
         this.FTF_BarLoad.text = _loc2_ - _loc4_ * _loc3_ + "/" + _loc3_.toString();
         this.FSP_BarLoad.width = Math.floor((_loc2_ - _loc4_ * _loc3_) * WIDTH_SCORE_Total / _loc3_);
         this.FSP_BarLoad.visible = true;
         this.FTF_SuperLimitCount.text = TUtilityString.Format(this.FHDRandCard.Prompts.Prompt1,_loc4_);
      }
      
      protected function UpdateUIGoldCard() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TActivityRCAwardCard = null;
         this.ProcessorGetGoldInventories();
         _loc2_ = int(COUNT_MC_AwardCard);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FDataRandCard.CurGoldAwards.AwardCard[_loc1_];
            if(this.FIsGoldRefreshOpreate)
            {
               _loc3_.IsDelete = false;
            }
            this.FMC_GoldCards[_loc1_].UpdateUI(this.FDataRandCard.GoldStage.Stage,_loc3_,FInventoriesVect[_loc1_]);
            _loc1_++;
         }
         if(this.FIsGoldRefreshOpreate)
         {
            this.UpdateUIDeleteCost();
            this.FIsGoldRefreshOpreate = false;
         }
         this.FBtn_GoldStart.Enabled = false;
         this.FBtn_GoldRestart.Enabled = false;
         this.FBtn_GoldRefresh.Enabled = false;
         switch(this.FDataRandCard.GoldStage.Stage)
         {
            case CONST_ACTIVITY_MODE.STAGE_RC_NoStart:
               this.FBtn_GoldStart.Enabled = true;
               this.FBtn_GoldRefresh.Enabled = true;
               break;
            case CONST_ACTIVITY_MODE.STAGE_RC_Start:
               if(this.FIsGoldStartOpreate)
               {
                  this.HideShowGoldBaseCards(false);
                  this.FMC_GoldShuffle.gotoAndPlay(2);
                  this.FMC_GoldShuffle.visible = true;
                  this.FIsGoldStartOpreate = false;
               }
               break;
            case CONST_ACTIVITY_MODE.STAGE_RC_End:
               this.FBtn_GoldRestart.Enabled = true;
         }
      }
      
      protected function HideShowGoldBaseCards(param1:Boolean) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         _loc3_ = int(this.FMC_GoldCards.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FMC_GoldCards[_loc2_].Visible = param1;
            _loc2_++;
         }
      }
      
      protected function UpdateUISuperCard() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TActivityRCAwardCard = null;
         _loc2_ = int(COUNT_MC_AwardCard);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            if(_loc1_ == COUNT_MC_AwardCard - 1)
            {
               _loc3_ = this.FDataRandCard.SuperAwards.FixedAward;
            }
            else
            {
               _loc3_ = this.FDataRandCard.SuperAwards.RandAwards[_loc1_];
            }
            this.FMC_SuperCards[_loc1_].UpdateUI(this.FDataRandCard.SuperStage.Stage,_loc3_,this.FSuperInventoriesVect[_loc1_]);
            _loc1_++;
         }
         this.FBtn_SuperStart.Enabled = false;
         this.FBtn_SuperRestart.Enabled = false;
         switch(this.FDataRandCard.SuperStage.Stage)
         {
            case CONST_ACTIVITY_MODE.STAGE_RC_NoStart:
               if(this.FSuperStartCount > 0)
               {
                  this.FBtn_SuperStart.Enabled = true;
               }
               break;
            case CONST_ACTIVITY_MODE.STAGE_RC_Start:
               if(this.FIsSuperStartOpreate)
               {
                  this.FMC_SuperShuffle.gotoAndPlay(2);
                  this.FMC_SuperShuffle.visible = true;
                  this.FIsSuperStartOpreate = false;
               }
               break;
            case CONST_ACTIVITY_MODE.STAGE_RC_End:
               this.FBtn_SuperRestart.Enabled = true;
         }
      }
      
      protected function RenderRankArea(param1:Vector.<TLog>) : void
      {
         var _loc2_:* = 0;
         var _loc3_:int = 0;
         var _loc4_:TRewards = null;
         var _loc5_:Sprite = null;
         var _loc6_:TLog = null;
         var _loc7_:Object = null;
         var _loc8_:Vector.<Sprite> = null;
         var _loc9_:String = null;
         this.FScrollBar.Clear();
         _loc3_ = int(param1.length);
         _loc8_ = new Vector.<Sprite>();
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc6_ = param1[_loc2_];
            _loc7_ = Json.decode(_loc6_.Data);
            _loc5_ = TUtilityReflection.CreateDisplayObjectInstance("MC_RCAwardItem") as Sprite;
            _loc5_["TF"].text = TUtilityString.Format(this.FHDRandCard.Prompts.Prompt3,_loc6_.Name,SToolReward.GetNameByTypeCode(_loc7_.type,_loc7_.code),_loc7_.amount);
            _loc8_.push(_loc5_);
            _loc2_++;
         }
         _loc2_ = int(_loc3_ - 1);
         while(_loc2_ >= 0)
         {
            this.FScrollBar.AddItem(_loc8_[_loc2_]);
            _loc2_--;
         }
         this.FScrollBar.Visible = true;
      }
      
      protected function ProcessorMatchAward(param1:Vector.<TFixedAward>) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:TInventories = null;
         var _loc6_:Vector.<TInventories> = null;
         _loc5_ = ProcessorGetInventories(0,param1);
         if(this.FIsGoldCardOnOpreate)
         {
            this.UpdateUIGoldCard();
            _loc3_ = int(this.FDataRandCard.CurGoldAwards.AwardCard.length);
            _loc2_ = 0;
            while(_loc2_ < _loc3_)
            {
               if(this.FDataRandCard.CurGoldAwards.AwardCard[_loc2_].IsSelect)
               {
                  _loc4_ = _loc2_;
                  break;
               }
               _loc2_++;
            }
            _loc3_ = int(FInventoriesVect.length);
            this.FDataRandCard.GoldStage.Stage = CONST_ACTIVITY_MODE.STAGE_RC_End;
            _loc2_ = 0;
            while(_loc2_ < _loc3_)
            {
               if(_loc5_.GetInventoryByIndex(0).Identifier0 == FInventoriesVect[_loc2_].GetInventoryByIndex(0).Identifier0 && _loc5_.GetInventoryByIndex(0).Identifier1 == FInventoriesVect[_loc2_].GetInventoryByIndex(0).Identifier1)
               {
                  this.FMC_GoldCards[_loc4_].UpdateUI(this.FDataRandCard.GoldStage.Stage,this.FDataRandCard.GetGoldCardByUIndex(_loc4_),_loc5_);
                  break;
               }
               _loc2_++;
            }
         }
         else
         {
            this.UpdateUISuperCard();
            _loc3_ = int(this.FDataRandCard.SuperAwards.RandAwards.length);
            _loc2_ = 0;
            while(_loc2_ < _loc3_)
            {
               if(this.FDataRandCard.SuperAwards.RandAwards[_loc2_].IsSelect)
               {
                  _loc4_ = _loc2_;
                  break;
               }
               _loc2_++;
            }
            _loc3_ = int(this.FSuperInventoriesVect.length);
            this.FDataRandCard.SuperStage.Stage = CONST_ACTIVITY_MODE.STAGE_RC_End;
            _loc2_ = 0;
            while(_loc2_ < _loc3_)
            {
               if(_loc5_.GetInventoryByIndex(0).Identifier0 == this.FSuperInventoriesVect[_loc2_].GetInventoryByIndex(0).Identifier0 && _loc5_.GetInventoryByIndex(0).Identifier1 == this.FSuperInventoriesVect[_loc2_].GetInventoryByIndex(0).Identifier1)
               {
                  this.FMC_SuperCards[_loc4_].UpdateUI(this.FDataRandCard.SuperStage.Stage,this.FDataRandCard.GetSuperCardByUIndex(_loc4_),_loc5_);
                  this.FMC_SuperCards[this.FMC_SuperCards.length - 1].UpdateUI(this.FDataRandCard.SuperStage.Stage,this.FDataRandCard.GetSuperCardByUIndex(_loc4_),this.FSuperInventoriesVect[this.FMC_SuperCards.length - 1]);
                  break;
               }
               _loc2_++;
            }
         }
      }
      
      override protected function Reset() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         super.Reset();
         if(!this.FIsInitWindow)
         {
            return;
         }
         this.ResetTextField();
         _loc2_ = int(this.FMC_GoldCards.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FMC_GoldCards[_loc1_].Hide();
            _loc1_++;
         }
         _loc2_ = int(this.FMC_SuperCards.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FMC_SuperCards[_loc1_].Hide();
            _loc1_++;
         }
         this.FMC_GoldShuffle.stop();
         this.FMC_SuperShuffle.stop();
         this.FScrollBar.Clear();
      }
      
      protected function ResetTextField() : void
      {
         if(!this.FIsInitWindow)
         {
            return;
         }
         this.FTF_BarLoad.text = "";
         this.FTF_CoolingDown.text = "";
         this.FTF_PromptSuperCard.text = "";
         this.FTF_CostGold.text = "";
         this.FTF_SuperLimitCount.text = "";
      }
      
      protected function LogArrive(param1:Vector.<TLog>) : void
      {
         this.RenderRankArea(param1);
      }
      
      protected function ClearCards(param1:uint) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TActivityRCAwardCard = null;
         switch(param1)
         {
            case CONST_ACTIVITY_MODE.TYPE_RC_Gold:
               _loc3_ = int(this.FMC_GoldCards.length);
               _loc2_ = 0;
               while(_loc2_ < _loc3_)
               {
                  _loc4_ = this.FDataRandCard.CurGoldAwards.AwardCard[_loc2_];
                  _loc4_.IsSelect = false;
                  this.FMC_GoldCards[_loc2_].UpdateUI(this.FDataRandCard.GoldStage.Stage,_loc4_);
                  _loc2_++;
               }
               break;
            case CONST_ACTIVITY_MODE.TYPE_RC_Super:
               _loc3_ = int(this.FMC_SuperCards.length);
               _loc2_ = 0;
               while(_loc2_ < _loc3_)
               {
                  if(_loc2_ == _loc3_ - 1)
                  {
                     _loc4_ = this.FDataRandCard.SuperAwards.FixedAward;
                  }
                  else
                  {
                     _loc4_ = this.FDataRandCard.SuperAwards.RandAwards[_loc2_];
                  }
                  _loc4_.IsSelect = false;
                  this.FMC_SuperCards[_loc2_].UpdateUI(this.FDataRandCard.SuperStage.Stage,_loc4_);
                  _loc2_++;
               }
         }
      }
      
      protected function BtnGoldCardOnClick(param1:uint) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:TActivityRCAwardCard = null;
         var _loc6_:Boolean = false;
         _loc5_ = this.FDataRandCard.GetGoldCardByUIndex(param1);
         if(_loc5_ == null)
         {
            return;
         }
         switch(this.FDataRandCard.GoldStage.Stage)
         {
            case CONST_ACTIVITY_MODE.STAGE_RC_NoStart:
               _loc3_ = int(this.FDataRandCard.CurGoldAwards.AwardCard.length);
               _loc2_ = 0;
               while(_loc2_ < _loc3_)
               {
                  _loc5_ = this.FDataRandCard.CurGoldAwards.AwardCard[_loc2_];
                  if(_loc5_.IsDelete)
                  {
                     _loc4_++;
                  }
                  _loc2_++;
               }
               _loc5_ = this.FDataRandCard.GetGoldCardByUIndex(param1);
               if(_loc4_ >= this.FHDRandCard.CanDeleteCount && !_loc5_.IsDelete)
               {
                  return;
               }
               _loc6_ = _loc5_.IsDelete;
               _loc5_.IsDelete = !_loc6_;
               break;
            case CONST_ACTIVITY_MODE.STAGE_RC_Start:
               if(_loc5_.IsDelete)
               {
                  return;
               }
               this.ClearCards(CONST_ACTIVITY_MODE.TYPE_RC_Gold);
               Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FDataRandCard.GoldSelectBtn.Index);
               _loc6_ = _loc5_.IsSelect;
               _loc5_.IsSelect = !_loc6_;
               break;
            case CONST_ACTIVITY_MODE.STAGE_RC_End:
               return;
         }
         this.FMC_GoldCards[param1].UpdateUI(this.FDataRandCard.GoldStage.Stage,_loc5_);
         this.FIsGoldCardOnOpreate = true;
         this.UpdateUIDeleteCost();
      }
      
      protected function BtnGoldStartOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Vector.<TActivityRCAwardCard> = null;
         var _loc6_:Vector.<int> = null;
         var _loc7_:TActivityRCButton = null;
         var _loc8_:int = 0;
         _loc7_ = this.FDataRandCard.GoldStartBtn;
         _loc5_ = this.FDataRandCard.CurGoldAwards.AwardCard;
         _loc4_ = int(_loc5_.length);
         _loc6_ = new Vector.<int>();
         if(this.FDataRandCard.FreeTime.Status <= 0)
         {
            _loc6_.push(CONST_ACTIVITY_MODE.STATUS_RC_ChooseFree);
         }
         else
         {
            _loc6_.push(CONST_ACTIVITY_MODE.STATUS_RC_ChooseGold);
         }
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            if(_loc5_[_loc3_].IsDelete)
            {
               _loc8_ += this.FHDRandCard.DeleteCost;
            }
            _loc6_.push(int(!_loc5_[_loc3_].IsDelete));
            _loc3_++;
         }
         this.FIsGoldStartOpreate = true;
         if(_loc6_[0] == CONST_ACTIVITY_MODE.STATUS_RC_ChooseFree)
         {
            Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,_loc7_.Index,0,_loc6_);
         }
         else if(FCharacter.CreditGold >= this.FHDRandCard.SelectCost + _loc8_)
         {
            Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,_loc7_.Index,0,_loc6_);
         }
         else
         {
            FUIWindowRecharge.Visible = true;
         }
      }
      
      protected function BtnGoldRestartOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TActivityRCButton = null;
         _loc3_ = this.FDataRandCard.GoldRestartBtn;
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,_loc3_.Index);
      }
      
      protected function BtnGoldRefreshOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:TActivityRCButton = null;
         _loc5_ = this.FDataRandCard.GoldRefreshBtn;
         if(FCharacter.CreditGold >= this.FHDRandCard.RefreshCost)
         {
            Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,_loc5_.Index);
            this.FIsGoldRefreshOpreate = true;
         }
         else
         {
            FUIWindowRecharge.Visible = true;
         }
      }
      
      protected function BtnSuperCardOnClick(param1:uint) : void
      {
         var _loc2_:TActivityRCAwardCard = null;
         var _loc3_:Boolean = false;
         _loc2_ = this.FDataRandCard.GetSuperCardByUIndex(param1);
         if(_loc2_ == null)
         {
            return;
         }
         switch(this.FDataRandCard.SuperStage.Stage)
         {
            case CONST_ACTIVITY_MODE.STAGE_RC_Start:
               this.ClearCards(CONST_ACTIVITY_MODE.TYPE_RC_Super);
               Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FDataRandCard.SuperSelectBtn.Index);
               _loc3_ = _loc2_.IsSelect;
               _loc2_.IsSelect = !_loc3_;
               break;
            case CONST_ACTIVITY_MODE.STAGE_RC_End:
               return;
         }
         this.FMC_SuperCards[param1].UpdateUI(this.FDataRandCard.SuperStage.Stage,_loc2_);
         this.FIsGoldCardOnOpreate = false;
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FDataRandCard.SuperSelectBtn.Index);
      }
      
      protected function BtnSuperStartOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TActivityRCButton = null;
         _loc3_ = this.FDataRandCard.SuperStartBtn;
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,_loc3_.Index);
         this.FIsSuperStartOpreate = true;
      }
      
      protected function BtnSuperRestartOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TActivityRCButton = null;
         _loc3_ = this.FDataRandCard.SuperRestartBtn;
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,_loc3_.Index);
      }
      
      protected function BtnHDDescOnOver(param1:Object, param2:MouseEvent) : void
      {
         if(!this.FIsInitWindow)
         {
            return;
         }
         FHint.Caption = this.FHDRandCard.Desc;
         SUtilityOverLayer.UIComponentsHintOnOver(this,FHint);
      }
      
      protected function BtnHDDescOnOut(param1:Object, param2:MouseEvent) : void
      {
         if(!this.FIsInitWindow)
         {
            return;
         }
         SUtilityOverLayer.UIComponentsHintOnOut(this,FHint);
      }
      
      override protected function BtnCloseOnClick(param1:Object, param2:MouseEvent) : void
      {
         super.BtnCloseOnClick(param1,param2);
         if(FOnBtnCloseClick != null)
         {
            FOnBtnCloseClick(param1);
         }
      }
      
      protected function BtnGoldStartOnOver(param1:Object, param2:MouseEvent) : void
      {
         if(!this.FIsInitWindow)
         {
            return;
         }
         FHint.Caption = TUtilityString.Format(this.FHDRandCard.Prompts.Prompt9,this.FHDRandCard.SelectCost + int(this.FTF_CostGold.text));
         SUtilityOverLayer.UIComponentsHintOnOver(this,FHint);
      }
      
      protected function BtnGoldStartOnOut(param1:Object, param2:MouseEvent) : void
      {
         if(!this.FIsInitWindow)
         {
            return;
         }
         SUtilityOverLayer.UIComponentsHintOnOut(this,FHint);
      }
      
      protected function BtnGoldRefreshOnOver(param1:Object, param2:MouseEvent) : void
      {
         if(!this.FIsInitWindow)
         {
            return;
         }
         FHint.Caption = TUtilityString.Format(this.FHDRandCard.Prompts.Prompt9,this.FHDRandCard.RefreshCost);
         SUtilityOverLayer.UIComponentsHintOnOver(this,FHint);
      }
      
      protected function BtnGoldRefreshOnOut(param1:Object, param2:MouseEvent) : void
      {
         if(!this.FIsInitWindow)
         {
            return;
         }
         SUtilityOverLayer.UIComponentsHintOnOut(this,FHint);
      }
      
      public function set OnLoadLog(param1:Function) : void
      {
         this.FOnLoadLog = param1;
      }
      
      override public function Show(param1:TActivityAtoms = null, param2:THDActivityBase = null, param3:TActivityOSBase = null) : void
      {
         super.Show(param1,param2,param3);
         if(this.FOnLoadLog != null)
         {
            this.FOnLoadLog(CONST_LOG.LOGTYPE_RandCard,this.LogArrive);
         }
      }
      
      public function WindowUpDateUI(param1:Vector.<int>) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(param1[0] == CONST_ACTIVITY_MODE.TYPE_RC_Gold)
         {
            this.FDataRandCard.GoldStage.Stage = param1[1];
            this.FDataRandCard.SetGoldAward(param1[2]);
            this.UpdateUIGoldCard();
         }
         else
         {
            this.FDataRandCard.SuperStage.Stage = param1[1];
            this.UpdateUISuperCard();
         }
      }
      
      public function OperateRet(param1:Vector.<TFixedAward>) : void
      {
         if(this.FIsGoldCardOnOpreate)
         {
            this.FDataRandCard.GoldStage.Stage = CONST_ACTIVITY_MODE.STAGE_RC_End;
         }
         else
         {
            this.FDataRandCard.SuperStage.Stage = CONST_ACTIVITY_MODE.STAGE_RC_End;
         }
         this.ProcessorMatchAward(param1);
      }
   }
}

