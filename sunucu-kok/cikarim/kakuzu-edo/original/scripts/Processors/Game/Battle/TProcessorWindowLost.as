package Processors.Game.Battle
{
   import Components.Standard.*;
   import Foundation.Common.*;
   import Foundation.Timing.STimingCore;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Utilities.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   
   public class TProcessorWindowLost extends TProcessorLobbyWindow
   {
      
      protected static const CloseDurationTime:int = 3000;
      
      protected var FScene:MovieClip;
      
      protected var FHintBtn:THint;
      
      protected var FBT_Ok:TUIButton;
      
      protected var FBT_Statistics:TUIButton;
      
      protected var FClickCallBack:Function;
      
      protected var FReplayCallBack:Function;
      
      protected var FStatisticsCallBack:Function;
      
      protected var FHintOnMove:Function;
      
      protected var FHintOnOut:Function;
      
      protected var FAutoClose:Boolean;
      
      protected var FTimeRecord:int;
      
      public function TProcessorWindowLost(param1:TUIComponent)
      {
         super(param1);
         this.InitBattleLostWindow();
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
      
      protected function InitBattleLostWindow() : void
      {
         this.FHintBtn = new THint();
         this.FScene = TUtilityReflection.CreateDisplayObjectInstance(CONST_BATTLE.RESOURCE_ClassName_Lost) as MovieClip;
         addChild(this.FScene);
         this.FBT_Ok = new TUIButton();
         this.FBT_Ok.Substrate = this.FScene.btn_ok;
         this.FBT_Ok.OnClick = this.OnOutBattle;
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
      
      protected function OnOutBattle(param1:Object, param2:MouseEvent = null) : void
      {
         this.Visible = false;
         this.FAutoClose = false;
         if(this.FClickCallBack != null)
         {
            this.FClickCallBack(this);
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
         this.Visible = false;
         if(this.FReplayCallBack != null)
         {
            this.FReplayCallBack(this);
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
      
      public function set ClickCallBack(param1:Function) : void
      {
         this.FClickCallBack = param1;
      }
      
      public function get ClickCallBack() : Function
      {
         return this.FClickCallBack;
      }
      
      public function set ReplayCallBack(param1:Function) : void
      {
         this.FReplayCallBack = param1;
      }
      
      public function get ReplayCallBack() : Function
      {
         return this.FReplayCallBack;
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
      
      public function SetWindow(param1:String, param2:Boolean = false, param3:Boolean = false, param4:Boolean = false) : void
      {
         this.FScene.btn_copy.visible = param2;
         this.FScene.btn_replay.visible = param3;
         this.FAutoClose = param4;
         this.FTimeRecord = STimingCore.TickCount + CloseDurationTime;
      }
      
      public function set StatisticsBtnEnabled(param1:Boolean) : void
      {
         this.FBT_Statistics.Enabled = param1;
      }
   }
}

