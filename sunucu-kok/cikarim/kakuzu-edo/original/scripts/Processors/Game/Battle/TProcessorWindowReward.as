package Processors.Game.Battle
{
   import Components.Standard.*;
   import Foundation.Common.*;
   import Foundation.Timing.STimingCore;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.DatebaseVO.VO.TArticle;
   import Logics.Items.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Utilities.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   
   public class TProcessorWindowReward extends TProcessorLobbyWindow
   {
      
      protected static const CloseDurationTime:int = 3000;
      
      protected var FScene:MovieClip;
      
      protected var FReward:TItems;
      
      protected var FHintBtn:THint;
      
      protected var FBT_Ok:TUIButton;
      
      protected var FBT_Statistics:TUIButton;
      
      protected var FEnterType:uint;
      
      protected var FOnBattleTurnBack:Function;
      
      protected var FOnBattleReplay:Function;
      
      protected var FStatisticsCallBack:Function;
      
      protected var FHintOnMove:Function;
      
      protected var FHintOnOut:Function;
      
      protected var FAutoClose:Boolean;
      
      protected var FTimeRecord:int;
      
      public function TProcessorWindowReward(param1:TUIComponent)
      {
         super(param1);
         this.InitBattleResultWindow();
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(!Visible)
         {
            return;
         }
         if(this.FAutoClose && STimingCore.TickCount > this.FTimeRecord)
         {
            this.OnOutBattle(this);
         }
      }
      
      protected function InitBattleResultWindow() : void
      {
         this.FHintBtn = new THint();
         if(this.FScene == null)
         {
            this.FScene = TUtilityReflection.CreateDisplayObjectInstance(CONST_BATTLE.RESOURCE_ClassName_Result) as MovieClip;
            addChild(this.FScene);
         }
         this.FBT_Ok = new TUIButton();
         this.FBT_Ok.Substrate = this.FScene.btn_ok;
         this.FBT_Ok.OnClick = this.OnOutBattle;
         this.FBT_Ok.StopPropagation();
         this.FBT_Ok.Enabled = true;
         this.FBT_Statistics = new TUIButton();
         this.FBT_Statistics.Substrate = this.FScene.btn_statistics;
         this.FBT_Statistics.OnClick = this.OnStatistics;
         this.FBT_Statistics.Enabled = false;
         this.FScene.btn_copy.addEventListener(MouseEvent.MOUSE_UP,this.OnCopyBattle);
         this.FScene.btn_replay.addEventListener(MouseEvent.MOUSE_UP,this.OnReplayBattle);
         this.FScene.btn_copy.visible = false;
         this.FScene.btn_copy.addEventListener(MouseEvent.MOUSE_MOVE,this.Btn_CopyOnMove,false,0,true);
         this.FScene.btn_copy.addEventListener(MouseEvent.MOUSE_OUT,this.Btn_OnOut,false,0,true);
         this.FScene.btn_replay.addEventListener(MouseEvent.MOUSE_MOVE,this.Btn_ReplayOnMove,false,0,true);
         this.FScene.btn_replay.addEventListener(MouseEvent.MOUSE_OUT,this.Btn_OnOut,false,0,true);
      }
      
      protected function UpdataUI() : void
      {
         var _loc1_:TItem = null;
         var _loc2_:String = null;
         var _loc3_:TArticle = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Vector.<TItem> = null;
         this.FScene.mc_info.mc_exp.visible = false;
         this.FScene.mc_info.mc_money.visible = false;
         this.FScene.mc_info.mc_soul.visible = false;
         _loc2_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_BATTLE_09);
         if(this.FReward != null)
         {
            if(this.FReward.Exp > 0)
            {
               this.FScene.mc_info.mc_exp.tf_name.text = _loc2_ + TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ITEMNAME_Exp);
               this.FScene.mc_info.mc_exp.tf_value.text = "+" + this.FReward.Exp;
               this.FScene.mc_info.mc_exp.visible = true;
            }
            else if(this.FReward.Prestige > 0)
            {
               this.FScene.mc_info.mc_exp.tf_name.text = _loc2_ + TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ITEMNAME_Prestige);
               this.FScene.mc_info.mc_exp.tf_value.text = "+" + this.FReward.Prestige;
               this.FScene.mc_info.mc_exp.visible = true;
            }
            else
            {
               this.FScene.mc_info.mc_exp.visible = false;
            }
            this.FScene.mc_info.mc_money.visible = Boolean(this.FReward.Money > 0);
            if(this.FReward.Money > 0)
            {
               this.FScene.mc_info.mc_money.tf_name.text = _loc2_ + TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ITEMNAME_Coin);
               this.FScene.mc_info.mc_money.tf_value.text = "+" + this.FReward.Money;
            }
            if(this.FReward.Soul > 0)
            {
               this.FScene.mc_info.mc_soul.tf_name.text = _loc2_ + TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ITEMNAME_Soul);
               this.FScene.mc_info.mc_soul.tf_value.text = "+" + this.FReward.Soul;
               this.FScene.mc_info.mc_soul.visible = true;
            }
            else
            {
               _loc1_ = this.FReward.GetItemById(CONST_COMMON.TREASUREMAP_BLUESTAR);
               if(_loc1_ != null)
               {
                  this.FScene.mc_info.mc_soul.tf_name.text = _loc2_ + TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ITEMNAME_BlueStar);
                  this.FScene.mc_info.mc_soul.tf_value.text = "+" + _loc1_.Count;
                  this.FScene.mc_info.mc_soul.visible = true;
               }
               else
               {
                  _loc1_ = this.FReward.GetItemById(CONST_COMMON.TREASUREMAP_REDSTAR);
                  if(_loc1_ != null)
                  {
                     this.FScene.mc_info.mc_soul.tf_name.text = _loc2_ + TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ITEMNAME_RedStar);
                     this.FScene.mc_info.mc_soul.tf_value.text = "+" + _loc1_.Count;
                     this.FScene.mc_info.mc_soul.visible = true;
                  }
                  else
                  {
                     this.FScene.mc_info.mc_soul.visible = false;
                  }
               }
            }
         }
      }
      
      protected function OnOutBattle(param1:Object, param2:MouseEvent = null) : void
      {
         this.visible = false;
         this.FReward = null;
         this.FAutoClose = false;
         if(this.FOnBattleTurnBack != null)
         {
            this.FOnBattleTurnBack(this);
         }
         if(this.FEnterType != CONST_BATTLE.BattleType_Replay && this.FEnterType != CONST_BATTLE.BattleType_Video)
         {
            TutorialNextStep(CONST_FRESHGUIDE.EVENTID_PickUp);
         }
      }
      
      protected function OnStatistics(param1:Object, param2:MouseEvent = null) : void
      {
         if(this.FStatisticsCallBack != null)
         {
            this.FStatisticsCallBack(this);
         }
      }
      
      protected function OnCopyBattle(param1:MouseEvent) : void
      {
      }
      
      protected function OnReplayBattle(param1:MouseEvent) : void
      {
         this.visible = false;
         if(this.FOnBattleReplay != null)
         {
            this.FOnBattleReplay(this);
         }
      }
      
      protected function Btn_CopyOnMove(param1:MouseEvent) : void
      {
         if(this.FHintOnMove != null)
         {
            this.FHintBtn.Caption = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_BATTLE_03);
            this.FHintOnMove(param1,this.FHintBtn);
         }
      }
      
      protected function Btn_ReplayOnMove(param1:MouseEvent) : void
      {
         if(this.FHintOnMove != null)
         {
            this.FHintBtn.Caption = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_BATTLE_04);
            this.FHintOnMove(param1,this.FHintBtn);
         }
      }
      
      protected function Btn_OnOut(param1:MouseEvent) : void
      {
         if(this.FHintOnOut != null)
         {
            this.FHintOnOut(param1,this.FHintBtn);
         }
      }
      
      public function set OnBattleTurnBack(param1:Function) : void
      {
         this.FOnBattleTurnBack = param1;
      }
      
      public function get OnBattleTurnBack() : Function
      {
         return this.FOnBattleTurnBack;
      }
      
      public function set OnBattleReplay(param1:Function) : void
      {
         this.FOnBattleReplay = param1;
      }
      
      public function get OnBattleReplay() : Function
      {
         return this.FOnBattleReplay;
      }
      
      public function set HintOnMove(param1:Function) : void
      {
         this.FHintOnMove = param1;
      }
      
      public function get HintOnMove() : Function
      {
         return this.FHintOnMove;
      }
      
      public function set HintOnOut(param1:Function) : void
      {
         this.FHintOnOut = param1;
      }
      
      public function get HintOnOut() : Function
      {
         return this.FHintOnOut;
      }
      
      public function get StatisticsCallBack() : Function
      {
         return this.FStatisticsCallBack;
      }
      
      public function set StatisticsCallBack(param1:Function) : void
      {
         this.FStatisticsCallBack = param1;
      }
      
      override public function set visible(param1:Boolean) : void
      {
         super.visible = param1;
         if(param1)
         {
            this.FScene.gotoAndPlay(1);
         }
      }
      
      public function SetWindow(param1:TItems, param2:Boolean = true, param3:Boolean = false, param4:Boolean = false, param5:uint = 0, param6:Boolean = false) : void
      {
         this.FEnterType = param5;
         this.FReward = param1;
         this.FScene.btn_copy.visible = param3;
         this.FScene.btn_replay.visible = param4;
         this.FScene.mc_title.gotoAndStop(param2 ? 2 : 1);
         this.UpdataUI();
         this.FAutoClose = param6;
         this.FTimeRecord = STimingCore.TickCount + CloseDurationTime;
      }
      
      public function set StatisticsBtnEnabled(param1:Boolean) : void
      {
         this.FBT_Statistics.Enabled = param1;
      }
   }
}

