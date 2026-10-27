package Processors.Game.Lobby.Activity.HDEaster2016.windows
{
   import Components.Slots.TUISlot;
   import Components.Standard.TUIButton;
   import Foundation.Common.THint;
   import Foundation.Timing.STimingCore;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.VO.THDEaster2016_2;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDEaster2016.THDEasterData2016_2;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDSingleWindowBase;
   import Processors.Game.Lobby.Jade.TJadeCommon;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Rendering.Overlayers.HDGiftBox.TOverlayerGiftBox;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import Utilities.Timing.TUtilityTiming;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class TProcessorHDWindowEaster2016_2 extends TProcessorHDSingleWindowBase
   {
      
      protected var FBtn_ShowRank:TUIButton;
      
      protected var FMC_Eggs:Vector.<Sprite>;
      
      protected var FMC_EggGiftScene:Sprite;
      
      protected var FBtn_Eggs:Vector.<TUIButton>;
      
      protected var FBtn_OpenOnces:Vector.<TUIButton>;
      
      protected var FBtn_OpenTen:Vector.<TUIButton>;
      
      protected var FBtn_Gifts:Vector.<TUIButton>;
      
      protected var FBtn_GiftsGet:Vector.<TUIButton>;
      
      protected var FMC_Rank:Sprite;
      
      protected var FRankView:TProcessorEasterEggRank;
      
      protected var FShowReward:Sprite;
      
      protected var FSlots:Vector.<TUISlot>;
      
      protected var FBtn_CloseReward:TUIButton;
      
      protected var FTempIndex:uint;
      
      protected var FConfig:THDEaster2016_2;
      
      protected var FData:THDEasterData2016_2;
      
      public function TProcessorHDWindowEaster2016_2(param1:TUIComponent)
      {
         super(param1);
         FHint = new THint();
      }
      
      override protected function UpdateUIConfig() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:THDEaster2016_2 = null;
         super.UpdateUIConfig();
         _loc3_ = FHDActivityConfig as THDEaster2016_2;
         this.FConfig = _loc3_;
         if(FActivityAtoms != null)
         {
            ProcessorFormatActivityTimeFromNowOn(FActivityAtoms.EndTime);
            ProcessorFormatActivityCountDown(FActivityAtoms.EndTime);
         }
         FScene["MC_Egg_0"]["TF_Score"].text = this.FConfig.CopperEgg.score + "";
         FScene["MC_Egg_1"]["TF_Score"].text = this.FConfig.SliverEgg.score + "";
         FScene["MC_Egg_2"]["TF_Score"].text = this.FConfig.GoldEgg.score + "";
         _loc2_ = 9;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            FScene["MC_EggGiftScene"]["MC_EggRollGift_" + _loc1_]["TF_Count"].text = this.FConfig.ScoreGift["infos"][_loc1_].score + "";
            _loc1_++;
         }
      }
      
      override protected function UpdateDataBase(param1:TActivityOSBase) : void
      {
         var _loc2_:* = 0;
         var _loc3_:uint = 0;
         this.FData = param1 as THDEasterData2016_2;
         FScene["TF_Score"].text = this.FData.CurScore + "";
         _loc3_ = 9;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FBtn_GiftsGet[_loc2_].Enabled = this.FData.CurScore < this.FConfig.ScoreGift["infos"][_loc2_].score || this.FData.GiftStatus[_loc2_] == 1 ? false : true;
            FScene["MC_EggGiftScene"]["MC_EggRollGift_" + _loc2_]["MC_Get"].visible = this.FData.GiftStatus[_loc2_] == 1 ? true : false;
            _loc2_++;
         }
         this.FRankView.RankDatas = this.FData.RankVec;
         _loc3_ = this.FData.RankVec.length;
         if(_loc3_ == 0 || this.FData.CurScore >= this.FData.RankVec[0].Value)
         {
            FScene["TF_RankLast"].visible = FScene["TF_head"].visible = FScene["TF_End"].visible = false;
         }
         else if(this.FData.CurScore < this.FData.RankVec[0].Value && this.FData.CurScore >= this.FData.RankVec[_loc3_ - 1].Value)
         {
            FScene["TF_RankLast"].visible = FScene["TF_head"].visible = FScene["TF_End"].visible = true;
            _loc2_ = int(_loc3_ - 1);
            while(_loc2_ >= 0)
            {
               if(this.FData.RankVec[_loc2_].Value > this.FData.CurScore)
               {
                  FScene["TF_RankLast"].text = this.FData.RankVec[_loc2_].Value - this.FData.CurScore;
                  return;
               }
               _loc2_--;
            }
         }
         else
         {
            FScene["TF_RankLast"].visible = FScene["TF_head"].visible = FScene["TF_End"].visible = true;
            FScene["TF_RankLast"].text = this.FData.RankVec[_loc3_ - 1].Value - this.FData.CurScore;
         }
      }
      
      override protected function LogicsPerform() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         super.LogicsPerform();
         if(!Visible)
         {
            return;
         }
         FScene["TF_Time"].text = TUtilityTiming.fomatTimeTwo(this.FData.Time - STimingCore.ServerTick);
         if(FScene["MC_ShowReward"].visible == false)
         {
            return;
         }
         _loc1_ = 6;
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            this.FSlots[_loc2_].Update();
            _loc2_++;
         }
      }
      
      protected function ProcessorShowRank(param1:Object, param2:MouseEvent) : void
      {
         this.FRankView.Show(FActivityAtoms,FHDActivityConfig,this.FData);
      }
      
      protected function ProcessorGiftOnMove(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:uint = 0;
         _loc3_ = uint((param1 as TUIButton).Tag);
         ProcessorOnGiftBoxMove(this,this.FData.GiftInvs[_loc3_],TOverlayerGiftBox.TYPE_ALL);
      }
      
      protected function ProcessorGiftOnOut(param1:Object, param2:MouseEvent) : void
      {
         ProcessorOnGiftBoxOut(this);
      }
      
      protected function ProcessorShowRewards(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         _loc3_ = 6;
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            this.FSlots[_loc4_].Context = this.FData.Rewards[param1.Tag * _loc3_ + _loc4_];
            _loc4_++;
         }
         this.FShowReward.visible = true;
      }
      
      protected function ProcessorCloseRewards(param1:Object, param2:MouseEvent) : void
      {
         this.FShowReward.visible = false;
      }
      
      protected function ProcessorOnceMove(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         _loc4_ = uint(param2.currentTarget.parent.name.split("_")[2]);
         switch(_loc4_)
         {
            case 0:
               if(this.FData.Time - STimingCore.ServerTick < 0)
               {
                  FHint.Caption = "";
                  return;
               }
               _loc3_ = uint(this.FConfig.CopperEgg.gold);
               FHint.Caption = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.SHORTCUTS_STRING_02),_loc3_);
               break;
            case 1:
               _loc3_ = uint(this.FConfig.SliverEgg.gold);
               FHint.Caption = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.SHORTCUTS_STRING_02),_loc3_);
               break;
            case 2:
               _loc3_ = uint(this.FConfig.GoldEgg.gold);
               FHint.Caption = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.SHORTCUTS_STRING_02),_loc3_);
         }
         SUtilityOverLayer.UIComponentsHintOnOver(this,FHint);
      }
      
      protected function ProcessorTenMove(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         _loc4_ = uint(param2.currentTarget.parent.name.split("_")[2]);
         switch(_loc4_)
         {
            case 0:
               if(this.FData.Time - STimingCore.ServerTick < 0)
               {
                  _loc3_ = this.FConfig.CopperEgg.gold * this.FConfig.DisCount / 100 * 9;
                  FHint.Caption = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.SHORTCUTS_STRING_02),_loc3_);
               }
               else
               {
                  _loc3_ = this.FConfig.CopperEgg.gold * this.FConfig.DisCount / 10;
                  FHint.Caption = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.SHORTCUTS_STRING_02),_loc3_);
               }
               break;
            case 1:
               _loc3_ = this.FConfig.SliverEgg.gold * this.FConfig.DisCount / 10;
               FHint.Caption = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.SHORTCUTS_STRING_02),_loc3_);
               break;
            case 2:
               _loc3_ = this.FConfig.GoldEgg.gold * this.FConfig.DisCount / 10;
               FHint.Caption = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.SHORTCUTS_STRING_02),_loc3_);
         }
         SUtilityOverLayer.UIComponentsHintOnOver(this,FHint);
      }
      
      protected function ProcessorHintOut(param1:Object, param2:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOut(this,FHint);
      }
      
      protected function ProcessorOpenOnce(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:uint = 0;
         this.FTempIndex = param2.currentTarget.parent.name.split("_")[2];
         switch(this.FTempIndex)
         {
            case 0:
               if(this.FData.Time - STimingCore.ServerTick < 0)
               {
                  this.ConfirmOpenOnce(null);
                  return;
               }
               _loc3_ = uint(this.FConfig.CopperEgg.gold);
               break;
            case 1:
               _loc3_ = uint(this.FConfig.SliverEgg.gold);
               break;
            case 2:
               _loc3_ = uint(this.FConfig.GoldEgg.gold);
         }
         GoldBuy(_loc3_,this.ConfirmOpenOnce);
      }
      
      protected function ConfirmOpenOnce(param1:Object) : void
      {
         var _loc2_:Vector.<int> = null;
         _loc2_ = new Vector.<int>(1);
         _loc2_[0] = 1;
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FTempIndex,0,_loc2_);
      }
      
      protected function ProcessorOpenTen(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:uint = 0;
         this.FTempIndex = param2.currentTarget.parent.name.split("_")[2];
         switch(this.FTempIndex)
         {
            case 0:
               if(this.FData.Time - STimingCore.ServerTick < 0)
               {
                  _loc3_ = this.FConfig.CopperEgg.gold * this.FConfig.DisCount / 100 * 9;
               }
               else
               {
                  _loc3_ = this.FConfig.CopperEgg.gold * this.FConfig.DisCount / 10;
               }
               break;
            case 1:
               _loc3_ = this.FConfig.SliverEgg.gold * this.FConfig.DisCount / 10;
               break;
            case 2:
               _loc3_ = this.FConfig.GoldEgg.gold * this.FConfig.DisCount / 10;
         }
         GoldBuy(_loc3_,this.ConfirmOpenTen);
      }
      
      protected function ConfirmOpenTen(param1:Object) : void
      {
         var _loc2_:Vector.<int> = null;
         _loc2_ = new Vector.<int>(1);
         _loc2_[0] = 10;
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FTempIndex,0,_loc2_);
      }
      
      protected function ProcessorGiftGet(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:Vector.<int> = null;
         _loc3_ = new Vector.<int>(1);
         _loc3_[0] = param1.Tag;
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FConfig.ScoreGift.index,0,_loc3_);
      }
      
      override public function InitWindow(param1:Sprite = null) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         super.InitWindow(param1);
         this.FBtn_ShowRank = new TUIButton();
         this.FBtn_ShowRank.Substrate = FScene["Btn_ShowRank"];
         this.FBtn_ShowRank.OnClick = this.ProcessorShowRank;
         _loc2_ = 3;
         this.FBtn_Eggs = new Vector.<TUIButton>(_loc2_);
         this.FBtn_OpenOnces = new Vector.<TUIButton>(_loc2_);
         this.FBtn_OpenTen = new Vector.<TUIButton>(_loc2_);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            this.FBtn_Eggs[_loc3_] = new TUIButton();
            this.FBtn_Eggs[_loc3_].Substrate = FScene["MC_Egg_" + _loc3_]["Btn_Egg"];
            this.FBtn_Eggs[_loc3_].OnClick = this.ProcessorShowRewards;
            this.FBtn_Eggs[_loc3_].Tag = _loc3_;
            this.FBtn_OpenOnces[_loc3_] = new TUIButton();
            this.FBtn_OpenOnces[_loc3_].Substrate = FScene["MC_Egg_" + _loc3_]["Btn_OpenOnce"];
            this.FBtn_OpenOnces[_loc3_].OnMove = this.ProcessorOnceMove;
            this.FBtn_OpenOnces[_loc3_].OnOut = this.ProcessorHintOut;
            this.FBtn_OpenOnces[_loc3_].OnClick = this.ProcessorOpenOnce;
            this.FBtn_OpenTen[_loc3_] = new TUIButton();
            this.FBtn_OpenTen[_loc3_].Substrate = FScene["MC_Egg_" + _loc3_]["Btn_OpenTen"];
            this.FBtn_OpenTen[_loc3_].OnMove = this.ProcessorTenMove;
            this.FBtn_OpenTen[_loc3_].OnOut = this.ProcessorHintOut;
            this.FBtn_OpenTen[_loc3_].OnClick = this.ProcessorOpenTen;
            _loc3_++;
         }
         _loc2_ = 9;
         this.FBtn_Gifts = new Vector.<TUIButton>(_loc2_);
         this.FBtn_GiftsGet = new Vector.<TUIButton>(_loc2_);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            this.FBtn_Gifts[_loc3_] = new TUIButton();
            this.FBtn_Gifts[_loc3_].Substrate = FScene["MC_EggGiftScene"]["MC_EggRollGift_" + _loc3_]["MC_Gift"];
            this.FBtn_Gifts[_loc3_].OnMove = this.ProcessorGiftOnMove;
            this.FBtn_Gifts[_loc3_].OnOut = this.ProcessorGiftOnOut;
            this.FBtn_Gifts[_loc3_].Tag = _loc3_;
            this.FBtn_GiftsGet[_loc3_] = new TUIButton();
            this.FBtn_GiftsGet[_loc3_].Substrate = FScene["MC_EggGiftScene"]["MC_EggRollGift_" + _loc3_]["Btn_Get"];
            this.FBtn_GiftsGet[_loc3_].Tag = _loc3_;
            this.FBtn_GiftsGet[_loc3_].OnClick = this.ProcessorGiftGet;
            _loc3_++;
         }
         this.FShowReward = FScene["MC_ShowReward"];
         this.FShowReward.visible = false;
         this.FBtn_CloseReward = new TUIButton();
         this.FBtn_CloseReward.Substrate = FScene["MC_ShowReward"]["btn_close"];
         this.FBtn_CloseReward.OnClick = this.ProcessorCloseRewards;
         _loc2_ = 6;
         this.FSlots = new Vector.<TUISlot>(_loc2_);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            this.FSlots[_loc3_] = new TUISlot(this);
            this.FSlots[_loc3_].Resource = FScene["MC_ShowReward"]["slot" + _loc3_];
            this.FSlots[_loc3_].OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
            this.FSlots[_loc3_].OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
            TJadeCommon.InitSlot(this.FSlots[_loc3_]);
            this.FSlots[_loc3_].Init();
            _loc3_++;
         }
         this.FMC_Rank = FScene["MC_Rank"];
         this.FRankView = new TProcessorEasterEggRank(this);
         this.FRankView.RankNum = 12;
         this.FRankView.InitWindow(FScene["MC_Rank"]);
         this.FRankView.OnGiftBoxMove = ProcessorOnGiftBoxMove;
         this.FRankView.OnGiftBoxOut = ProcessorOnGiftBoxOut;
      }
   }
}

