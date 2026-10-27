package Processors.Game.Lobby.Activity.HDHalloween.windows
{
   import Components.Standard.TUIButton;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityString;
   import Logics.HDActivityHalloween.TActivityHalloweenPumpkinData;
   import Logics.HDActivityMode.TActivityAtoms;
   import Logics.Inventories.TInventories;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.display.DisplayObjectContainer;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.utils.getTimer;
   
   public class TprocessorWindowHDHalloweenPumpkinGame extends TUIComponent
   {
      
      protected const FPumpkin_Count:int = 10;
      
      protected const FMatchPumpkin_Count:int = 6;
      
      protected const FSpeed:int = 90;
      
      protected const FTurns:Array = [1,2,3];
      
      protected var FMainUI:Sprite;
      
      protected var FLightBtn:TUIButton;
      
      protected var FCoinLightBtn:TUIButton;
      
      protected var FPumpkins:Vector.<MovieClip>;
      
      protected var FPumpkinPanel:MovieClip;
      
      protected var FCurrentGameStart:Boolean;
      
      protected var FPumpkinData:Vector.<TInventories>;
      
      protected var FGameStop:Boolean;
      
      protected var FCurrentPumpkinIndex:uint;
      
      protected var FCurrentTurns:uint;
      
      protected var FTotalTurns:uint;
      
      protected var FDestPumpkinCount:uint;
      
      protected var FTime:int;
      
      protected var FLastTime:int;
      
      protected var FWindows:TUIComponent;
      
      protected var FOnGiftBoxMove:Function;
      
      protected var FOnGiftBoxOut:Function;
      
      protected var FActivityOperateReq:Function;
      
      protected var FAtoms:TActivityAtoms;
      
      protected var FGetInventoriesVectByAwardID:Function;
      
      protected var FData:TActivityHalloweenPumpkinData;
      
      public function TprocessorWindowHDHalloweenPumpkinGame(param1:TUIComponent, param2:Sprite)
      {
         super(param1);
         this.FMainUI = param2;
         this.InitWindow();
         this.FWindows = param1.Parent.Parent;
      }
      
      protected function InitWindow() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:MovieClip = null;
         var _loc3_:MovieClip = null;
         this.FPumpkinData = new Vector.<TInventories>(this.FPumpkin_Count);
         this.FCurrentPumpkinIndex = 0;
         this.reset();
         this.FLightBtn = new TUIButton();
         this.FLightBtn.Substrate = this.FMainUI["Btn_Light"];
         this.FLightBtn.OnClick = this.LightBtnOnClick;
         this.FLightBtn.OnMove = this.LightBtnOnMove;
         this.FLightBtn.OnOut = this.LightBtnOnOut;
         this.FCoinLightBtn = new TUIButton();
         this.FCoinLightBtn.Substrate = this.FMainUI["Btn_CoinLight"];
         this.FCoinLightBtn.OnClick = this.CoinLightBtnOnClick;
         this.FCoinLightBtn.OnMove = this.CoinLightBtnOnMove;
         this.FCoinLightBtn.OnOut = this.CoinLightBtnOnOut;
         this.FPumpkins = new Vector.<MovieClip>(this.FPumpkin_Count);
         this.FPumpkinPanel = this.FMainUI["MC_Pumpkins"];
         this.FPumpkinPanel.addEventListener(MouseEvent.MOUSE_MOVE,this.PumpkinsMCOnMove);
         this.FPumpkinPanel.addEventListener(MouseEvent.MOUSE_OUT,this.PumpkinsMCOnOut);
         _loc1_ = 0;
         while(_loc1_ < this.FPumpkin_Count)
         {
            _loc3_ = this.FPumpkinPanel["MC_Pumpkin_" + _loc1_];
            this.FPumpkins[_loc1_] = _loc3_;
            _loc3_["MC_Pumpkin"].stop();
            _loc3_["MC_Fire"].visible = false;
            _loc3_ = _loc3_["MC_SelectBox"];
            _loc3_.mouseChildren = _loc3_.mouseEnabled = _loc3_.visible = false;
            _loc1_++;
         }
      }
      
      protected function GameStart() : void
      {
         var _loc1_:uint = Math.round(Math.random() * (this.FTurns.length - 1));
         if(!this.FCurrentGameStart)
         {
            this.FTotalTurns = this.FTurns[_loc1_];
            this.FTime = this.FSpeed;
            this.FLastTime = getTimer();
            this.FPumpkins[this.FCurrentPumpkinIndex]["MC_SelectBox"].visible = false;
            this.FPumpkins[this.FCurrentPumpkinIndex]["MC_Fire"].visible = false;
            this.FPumpkins[this.FCurrentPumpkinIndex]["MC_Fire"].stop();
            this.FPumpkins[0]["MC_SelectBox"].visible = true;
            this.FCurrentGameStart = true;
            this.FCurrentPumpkinIndex = 0;
         }
      }
      
      protected function reset() : void
      {
         this.FCurrentGameStart = false;
         this.FGameStop = false;
         this.FCurrentTurns = 0;
         this.FTotalTurns = 0;
         this.FDestPumpkinCount = 0;
         this.FTime = this.FSpeed;
         this.FLastTime = 0;
      }
      
      protected function LightBtnOnMove(param1:Object, param2:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOver(this,this.FData.NeedMatchTipData);
      }
      
      protected function LightBtnOnOut(param1:Object, param2:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOut(this,this.FData.NeedMatchTipData);
      }
      
      protected function CoinLightBtnOnMove(param1:Object, param2:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOver(this,this.FData.NeedCoinTipData);
      }
      
      protected function CoinLightBtnOnOut(param1:Object, param2:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOut(this,this.FData.NeedCoinTipData);
      }
      
      protected function LightBtnOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(!this.FCurrentGameStart)
         {
            this.FDestPumpkinCount = this.FMatchPumpkin_Count;
            this.GameStart();
         }
      }
      
      protected function CoinLightBtnOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(!this.FCurrentGameStart)
         {
            SUtilityOverLayer.UIWindowConfirmation.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_06),this.FData.Config.NeedCoinToLight);
            SUtilityOverLayer.UIWindowConfirmation.Visible = true;
            SUtilityOverLayer.UIWindowConfirmation.OnOK = this.WindowOk;
         }
      }
      
      private function WindowOk(param1:Object) : void
      {
         this.FDestPumpkinCount = this.FPumpkin_Count;
         this.GameStart();
      }
      
      protected function PumpkinsMCOnMove(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:DisplayObjectContainer = null;
         var _loc4_:String = null;
         _loc2_ = param1.target as MovieClip;
         _loc3_ = _loc2_.parent;
         _loc4_ = _loc3_.name;
         var _loc5_:uint = uint(_loc4_.split("_")[2]);
         this.FOnGiftBoxMove(this,this.FPumpkinData[_loc5_]);
      }
      
      protected function PumpkinsMCOnOut(param1:MouseEvent) : void
      {
         this.FOnGiftBoxOut(this);
      }
      
      public function set Data(param1:TActivityHalloweenPumpkinData) : void
      {
         this.FData = param1;
         if(this.FGetInventoriesVectByAwardID != null)
         {
            this.FPumpkinData = this.FGetInventoriesVectByAwardID(this.FData.PumpkinData);
         }
      }
      
      public function set OnGiftBoxMove(param1:Function) : void
      {
         this.FOnGiftBoxMove = param1;
      }
      
      public function set OnGiftBoxOut(param1:Function) : void
      {
         this.FOnGiftBoxOut = param1;
      }
      
      public function set GetInventoriesVectByAwardID(param1:Function) : void
      {
         this.FGetInventoriesVectByAwardID = param1;
         if(this.FData != null)
         {
            this.FPumpkinData = this.FGetInventoriesVectByAwardID(this.FData.PumpkinData);
         }
      }
      
      public function set ActivityOperateReq(param1:Function) : void
      {
         this.FActivityOperateReq = param1;
      }
      
      public function set Atoms(param1:TActivityAtoms) : void
      {
         this.FAtoms = param1;
      }
      
      public function UpdateUI() : void
      {
         this.FMainUI["TF_MyLightCount"].text = this.FData.MyLightCount;
         this.FMainUI["TF_MatchCount"].text = this.FData.MatchCount;
         this.FLightBtn.Enabled = this.FData.AllowMatchLight;
         this.FCoinLightBtn.Enabled = this.FData.AllowCoinLight;
         if(this.FCurrentGameStart && this.FData.IsUpdatePackage)
         {
            this.FGameStop = true;
         }
      }
      
      public function removeEvents() : void
      {
         this.FPumpkinPanel.removeEventListener(MouseEvent.MOUSE_MOVE,this.PumpkinsMCOnMove);
         this.FPumpkinPanel.removeEventListener(MouseEvent.MOUSE_OUT,this.PumpkinsMCOnOut);
      }
      
      public function AnimStop() : void
      {
         this.FPumpkins[this.FCurrentPumpkinIndex]["MC_Fire"].visible = false;
         this.FPumpkins[this.FCurrentPumpkinIndex]["MC_Fire"].stop();
      }
      
      public function Loop() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         if(this.FCurrentGameStart)
         {
            _loc2_ = getTimer();
            _loc1_ = _loc2_ - this.FLastTime;
            this.FLastTime = _loc2_;
            this.FTime -= _loc1_;
            if(this.FTime <= 0)
            {
               this.FTime = this.FSpeed;
               this.FPumpkins[this.FCurrentPumpkinIndex]["MC_SelectBox"].visible = false;
               ++this.FCurrentPumpkinIndex;
               if(this.FCurrentPumpkinIndex == this.FDestPumpkinCount - 1)
               {
                  ++this.FCurrentTurns;
                  if(this.FCurrentTurns == this.FTotalTurns)
                  {
                     if(this.FDestPumpkinCount == this.FMatchPumpkin_Count)
                     {
                        this.FActivityOperateReq(this.FAtoms.Identifier,this.FData.Config.MatchLightIndex);
                     }
                     else
                     {
                        this.FActivityOperateReq(this.FAtoms.Identifier,this.FData.Config.CoinGetLightIndex);
                     }
                  }
               }
               this.FCurrentPumpkinIndex %= this.FDestPumpkinCount;
               this.FPumpkins[this.FCurrentPumpkinIndex]["MC_SelectBox"].visible = true;
               if(this.FGameStop && this.FCurrentPumpkinIndex == this.FData.GetPumpkinIndexByRewardID())
               {
                  this.FPumpkins[this.FCurrentPumpkinIndex]["MC_SelectBox"].visible = false;
                  if(parent.visible && this.FWindows.Visible)
                  {
                     this.FPumpkins[this.FCurrentPumpkinIndex]["MC_Fire"].visible = true;
                     this.FPumpkins[this.FCurrentPumpkinIndex]["MC_Fire"].play();
                  }
                  this.reset();
               }
            }
         }
      }
   }
}

