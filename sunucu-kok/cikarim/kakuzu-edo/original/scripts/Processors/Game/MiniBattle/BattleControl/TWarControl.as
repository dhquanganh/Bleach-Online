package Processors.Game.MiniBattle.BattleControl
{
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.MiniBattle.Mode.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.text.*;
   
   public class TWarControl extends TProcessorLobbyWindow
   {
      
      protected static const MaxBattleSize:int = 3;
      
      protected var FBattleControl:Vector.<TBattleControl>;
      
      protected var FSelectedControl:Vector.<TBattleControl>;
      
      protected var FBattleOverRecord:int;
      
      protected var FCurrentScrrenBattleIndex:int;
      
      protected var FCurrentOneScreenBattle:TOneScreenBattle;
      
      protected var FMCRound:MovieClip;
      
      protected var FTFRound:TextField;
      
      protected var FWaitPlayRound:Boolean;
      
      protected var FRoundInforFormatStr:String;
      
      protected var FOnWarOver:Function;
      
      protected var FOneBattleOver:Function;
      
      protected var FOneBattleStart:Function;
      
      protected var FMiniBattleInfor:TMiniBattleInfor;
      
      public function TWarControl(param1:TUIComponent)
      {
         var _loc2_:int = 0;
         var _loc3_:TBattleControl = null;
         super(param1);
         this.FBattleControl = new Vector.<TBattleControl>();
         this.FBattleOverRecord = new Vector.<Boolean>(MaxBattleSize);
         this.FSelectedControl = new Vector.<TBattleControl>();
         _loc2_ = 0;
         while(_loc2_ < MaxBattleSize)
         {
            _loc3_ = new TBattleControl(this);
            _loc3_.LinePosition = CONST_MINIBATTLE.SoldierPositionArr[_loc2_];
            _loc3_.OnBattleOver = this.CallBack_BattleOver;
            this.FBattleControl.push(_loc3_);
            _loc2_++;
         }
      }
      
      protected function StartWarByIndex(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         this.FCurrentOneScreenBattle = this.FMiniBattleInfor.OneScreenBattles[param1];
         this.FSelectedControl.length = 0;
         _loc2_ = int(this.FCurrentOneScreenBattle.Battles.length);
         this.SelectLine(_loc2_,this.FSelectedControl);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            this.FSelectedControl[_loc3_].BattleData = this.FCurrentOneScreenBattle.Battles[_loc3_];
            this.FSelectedControl[_loc3_].StartBattle();
            if(this.FOneBattleStart != null)
            {
               this.FOneBattleStart(this.FCurrentOneScreenBattle.Battles[_loc3_]);
            }
            _loc3_++;
         }
      }
      
      protected function SelectLine(param1:int, param2:Vector.<TBattleControl>) : void
      {
         switch(param1)
         {
            case 1:
               param2.push(this.FBattleControl[1]);
               this.FBattleControl[0].Reset();
               this.FBattleControl[2].Reset();
               break;
            case 2:
               param2.push(this.FBattleControl[0]);
               param2.push(this.FBattleControl[2]);
               this.FBattleControl[1].Reset();
               break;
            case 3:
               param2.push(this.FBattleControl[0]);
               param2.push(this.FBattleControl[1]);
               param2.push(this.FBattleControl[2]);
         }
      }
      
      protected function LoadResource() : void
      {
         if(this.FMCRound == null)
         {
            this.FMCRound = TUtilityReflection.CreateDisplayObjectInstance("MC_MiniBattleReady") as MovieClip;
            this.FTFRound = this.FMCRound["RoundNum"];
            this.FMCRound.x = (CONST_COMMON.STAGE_Width - this.FMCRound.width) / 2;
            this.FMCRound.y = (CONST_COMMON.STAGE_Height - this.FMCRound.height) / 2;
            addChild(this.FMCRound);
            this.FRoundInforFormatStr = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TeamBattle_String_68);
         }
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(this.FWaitPlayRound)
         {
            if(this.FMCRound["RoundNum"] != null)
            {
               this.FMCRound["RoundNum"]["Lable"].text = TUtilityString.Format(this.FRoundInforFormatStr,this.FCurrentScrrenBattleIndex + 1);
            }
            if(this.FMCRound.currentFrame == this.FMCRound.totalFrames)
            {
               this.StartWarByIndex(this.FCurrentScrrenBattleIndex);
               this.FBattleOverRecord = 0;
               this.FMCRound.visible = false;
               this.FWaitPlayRound = false;
            }
         }
      }
      
      protected function CallBack_BattleOver(param1:TBattleControl) : void
      {
         var _loc2_:int = 0;
         ++this.FBattleOverRecord;
         if(this.FOneBattleOver != null)
         {
            this.FOneBattleOver(param1.BattleData);
         }
         if(this.FBattleOverRecord == this.FCurrentOneScreenBattle.Count)
         {
            ++this.FCurrentScrrenBattleIndex;
            if(this.FCurrentScrrenBattleIndex >= this.FMiniBattleInfor.OneScreenBattles.length)
            {
               if(this.FOnWarOver != null)
               {
                  this.FOnWarOver(this);
               }
            }
            else
            {
               this.StartNewRound();
            }
         }
      }
      
      protected function StartNewRound() : void
      {
         this.FBattleOverRecord = 0;
         this.FMCRound.visible = true;
         this.FMCRound.gotoAndPlay(1);
         this.FWaitPlayRound = true;
      }
      
      public function set OnWarOver(param1:Function) : void
      {
         this.FOnWarOver = param1;
      }
      
      public function set OneBattleOver(param1:Function) : void
      {
         this.FOneBattleOver = param1;
      }
      
      public function set OneBattleStart(param1:Function) : void
      {
         this.FOneBattleStart = param1;
      }
      
      public function StartWar(param1:TMiniBattleInfor) : void
      {
         this.LoadResource();
         this.FCurrentScrrenBattleIndex = 0;
         this.FBattleOverRecord = 0;
         this.FMiniBattleInfor = param1;
         this.StartNewRound();
         Visible = true;
      }
      
      public function EndWar() : void
      {
         var _loc1_:int = 0;
         this.FMiniBattleInfor = null;
         _loc1_ = 0;
         while(_loc1_ < MaxBattleSize)
         {
            this.FBattleControl[_loc1_].EndBattle();
            _loc1_++;
         }
         Visible = false;
         this.FWaitPlayRound = false;
      }
      
      public function Reset() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc2_ = int(this.FBattleControl.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FBattleControl[_loc1_].Reset();
            _loc1_++;
         }
         this.FSelectedControl.length = 0;
         this.FBattleOverRecord = 0;
         this.FCurrentScrrenBattleIndex = 0;
         this.FCurrentOneScreenBattle = null;
         this.FWaitPlayRound = false;
         this.FMCRound.gotoAndStop(1);
         this.FMCRound.visible = false;
      }
   }
}

