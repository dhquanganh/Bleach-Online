package Processors.Game.Lobby.Activity.HDHalloween.windows
{
   import Components.Standard.TUIButton;
   import Foundation.UI.TUIComponent;
   import Logics.HDActivityHalloween.TActivityHalloweenPumpkinData;
   import Logics.HDActivityMode.TActivityAtoms;
   import Logics.Log.TLog;
   import Processors.Game.Utilities.Common.SUtilityResource;
   import Processors.Game.Utilities.HyperLink.SUtilityHyperLink;
   import Processors.Game.Utilities.HyperLink.TUtilityHyperLink;
   import Resources.Constants.CONST_LOG;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class TprocessorWindowHDHalloweenPumpkin extends TUIComponent
   {
      
      protected const Item_Count:uint = 5;
      
      protected const LuckPlayer_Count:uint = 3;
      
      protected var FInit:Boolean;
      
      protected var FMainUI:Sprite;
      
      protected var FGoBtns:Vector.<TUIButton>;
      
      protected var FRankBtn:TUIButton;
      
      protected var FAllServerRewardBtn:TUIButton;
      
      protected var FLuckRewardMC:MovieClip;
      
      protected var FPumpkinGame:TprocessorWindowHDHalloweenPumpkinGame;
      
      protected var FPumpkinRank:TprocessorWindowHDHalloweenPumpkinRank;
      
      protected var FLayerMask:Sprite;
      
      protected var FData:TActivityHalloweenPumpkinData;
      
      protected var FOnGiftBoxMove:Function;
      
      protected var FOnGiftBoxOut:Function;
      
      protected var FActivityOperateReq:Function;
      
      protected var FGetInventoriesVectByAwardID:Function;
      
      protected var FAtoms:TActivityAtoms;
      
      protected var FOnLoadLog:Function;
      
      protected var FOnMainClose:Function;
      
      public function TprocessorWindowHDHalloweenPumpkin(param1:TUIComponent, param2:Sprite)
      {
         super(param1);
         this.FMainUI = param2;
         this.InitWindow();
      }
      
      protected function InitWindow() : void
      {
         var _loc1_:TUIButton = null;
         var _loc2_:uint = 0;
         var _loc3_:MovieClip = null;
         var _loc4_:MovieClip = null;
         this.FInit = true;
         this.FGoBtns = new Vector.<TUIButton>(this.Item_Count);
         _loc3_ = this.FMainUI["MC_Items"];
         _loc2_ = 0;
         while(_loc2_ < this.Item_Count)
         {
            _loc1_ = new TUIButton();
            _loc1_.Substrate = _loc3_["MC_Item_" + _loc2_]["Btn_Go"];
            _loc1_.OnClick = this.GoBtnOnClick;
            this.FGoBtns[_loc2_] = _loc1_;
            _loc2_++;
         }
         this.FRankBtn = new TUIButton();
         this.FRankBtn.Substrate = this.FMainUI["Btn_Rank"];
         this.FRankBtn.OnClick = this.RankBtnOnClick;
         this.FAllServerRewardBtn = new TUIButton();
         this.FAllServerRewardBtn.Substrate = this.FMainUI["Btn_AllServerReward"];
         this.FAllServerRewardBtn.OnClick = this.AllServerRewardBtnOnClick;
         this.FAllServerRewardBtn.OnMove = this.AllServerRewardBtnOnMove;
         this.FAllServerRewardBtn.OnOut = this.AllServerRewardBtnOnOut;
         this.FLuckRewardMC = this.FMainUI["MC_LuckReward"];
         this.FLuckRewardMC.addEventListener(MouseEvent.MOUSE_MOVE,this.LuckRewardMCOnMove);
         this.FLuckRewardMC.addEventListener(MouseEvent.MOUSE_OUT,this.LuckRewardMCOnOut);
         this.FLayerMask = new Sprite();
         this.FPumpkinGame = new TprocessorWindowHDHalloweenPumpkinGame(this,this.FMainUI["MC_PumpkinGame"]);
         this.FPumpkinRank = new TprocessorWindowHDHalloweenPumpkinRank(this,this.FMainUI["MC_PumpRank"]);
         this.FPumpkinRank.LayerMask = this.FLayerMask;
         this.FMainUI["MC_PumpRank"].visible = false;
         Parent.addChild(this.FLayerMask);
         Parent.addChild(this.FMainUI["MC_PumpRank"]);
         this.FLayerMask.addChild(new Bitmap(SUtilityResource.BtmDataFullScreen));
         this.FLayerMask.visible = false;
         this.FMainUI["MC_PumpRank"].x += this.FMainUI.x;
         this.FMainUI["MC_PumpRank"].y += this.FMainUI.y;
         this.FLayerMask.x -= Parent.x;
         this.FLayerMask.y -= Parent.y;
      }
      
      protected function UpdateTaskUI() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:MovieClip = null;
         var _loc3_:MovieClip = null;
         _loc3_ = this.FMainUI["MC_Items"];
         _loc1_ = 0;
         while(_loc1_ < this.Item_Count)
         {
            _loc2_ = _loc3_["MC_Item_" + _loc1_];
            _loc2_.visible = _loc1_ + 1 <= this.FData.TaskCount;
            if(_loc2_.visible)
            {
               _loc2_["TF_Describe"].text = this.FData.GetTaskString(_loc1_,0);
               _loc2_["TF_Progress"].text = this.FData.GetTaskString(_loc1_,1);
            }
            _loc2_ = _loc3_["MC_ItemOK_" + _loc1_];
            if(_loc1_ + 1 <= this.FData.TaskCount && this.FData.TaskIsOK(_loc1_))
            {
               _loc2_.visible = true;
            }
            else
            {
               _loc2_.visible = false;
            }
            _loc1_++;
         }
      }
      
      protected function UpdateAllServerUI() : void
      {
         this.FMainUI["TF_NeedLightCount"].text = this.FData.AllServerRewardDescribe;
         this.FMainUI["TF_AllLightCount"].text = this.FData.AllLightCount.toString();
         this.FAllServerRewardBtn.Enabled = this.FData.AllowGetAllServerReward;
         this.FMainUI["MC_AllServerRewardGet"].visible = this.FData.AllServerRewardGet;
      }
      
      protected function UpdateLuckyPlayerUI() : void
      {
         var _loc1_:uint = 0;
         _loc1_ = 0;
         while(_loc1_ < this.LuckPlayer_Count)
         {
            this.FMainUI["TF_Name_" + _loc1_].text = this.FData.LuckPlayerName[_loc1_];
            _loc1_++;
         }
         this.FMainUI["MC_LuckRewardGet"].visible = this.FData.LuckRewardGet;
      }
      
      protected function SetLuckyPlayer(param1:Vector.<TLog>) : void
      {
         this.FData.SetLuckyPlayer(param1,this.FAtoms.StartTime);
         this.UpdateLuckyPlayerUI();
      }
      
      protected function GoBtnOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         _loc3_ = this.FGoBtns.indexOf(param1 as TUIButton);
         _loc4_ = this.FData.GetTaskID(_loc3_);
         SUtilityHyperLink.ShortcutHyperlink(_loc4_);
         if(_loc4_ == TUtilityHyperLink.HyperLink_ReturnCity)
         {
            this.FOnMainClose(null,null);
         }
      }
      
      protected function RankBtnOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:MovieClip = this.FMainUI["MC_PumpRank"];
         _loc3_.visible = !_loc3_.visible;
         this.FLayerMask.visible = !this.FLayerMask.visible;
      }
      
      protected function AllServerRewardBtnOnClick(param1:Object, param2:MouseEvent) : void
      {
         this.FActivityOperateReq(this.FAtoms.Identifier,this.FData.Config.ServerAwardIndex);
      }
      
      protected function AllServerRewardBtnOnMove(param1:Object, param2:MouseEvent) : void
      {
         this.FOnGiftBoxMove(this,this.FData.AllServerRewardData);
      }
      
      protected function AllServerRewardBtnOnOut(param1:Object, param2:MouseEvent) : void
      {
         this.FOnGiftBoxOut(this);
      }
      
      protected function LuckRewardMCOnMove(param1:MouseEvent) : void
      {
         this.FOnGiftBoxMove(this,this.FData.LuckRewardData);
      }
      
      protected function LuckRewardMCOnOut(param1:MouseEvent) : void
      {
         this.FOnGiftBoxOut(this);
      }
      
      public function set ViewVisible(param1:Boolean) : void
      {
         this.FMainUI.visible = param1;
         if(!param1)
         {
            this.FPumpkinGame.AnimStop();
         }
      }
      
      public function set Data(param1:TActivityHalloweenPumpkinData) : void
      {
         this.FData = param1;
         this.FPumpkinGame.Data = param1;
      }
      
      public function set OnGiftBoxMove(param1:Function) : void
      {
         this.FOnGiftBoxMove = param1;
         this.FPumpkinGame.OnGiftBoxMove = param1;
         this.FPumpkinRank.OnBagOver = param1;
      }
      
      public function set OnGiftBoxOut(param1:Function) : void
      {
         this.FOnGiftBoxOut = param1;
         this.FPumpkinGame.OnGiftBoxOut = param1;
         this.FPumpkinRank.OnBagOut = param1;
      }
      
      public function set ActivityOperateReq(param1:Function) : void
      {
         this.FActivityOperateReq = param1;
         this.FPumpkinGame.ActivityOperateReq = param1;
      }
      
      public function set Atoms(param1:TActivityAtoms) : void
      {
         this.FAtoms = param1;
         this.FPumpkinGame.Atoms = param1;
      }
      
      public function set GetInventoriesVectByAwardID(param1:Function) : void
      {
         this.FGetInventoriesVectByAwardID = param1;
         this.FPumpkinGame.GetInventoriesVectByAwardID = param1;
      }
      
      public function set OnLoadLog(param1:Function) : void
      {
         this.FOnLoadLog = param1;
      }
      
      public function set OnMainClose(param1:Function) : void
      {
         this.FOnMainClose = param1;
      }
      
      public function MainViewClose() : void
      {
         this.FPumpkinGame.AnimStop();
      }
      
      public function UpdateUI() : void
      {
         this.UpdateTaskUI();
         this.UpdateAllServerUI();
         this.UpdateLuckyPlayerUI();
         this.FPumpkinGame.UpdateUI();
         this.FPumpkinRank.UpdateRankUI(this.FData.Config,this.FData,this.FGetInventoriesVectByAwardID(this.FData.RankValues));
         if(this.FInit)
         {
            this.FInit = false;
            this.FOnLoadLog(CONST_LOG.LOGTYPE_PumpkinLuckyPlayer,this.SetLuckyPlayer);
         }
      }
      
      public function removeEvents() : void
      {
         this.FLuckRewardMC.removeEventListener(MouseEvent.MOUSE_MOVE,this.LuckRewardMCOnMove);
         this.FLuckRewardMC.removeEventListener(MouseEvent.MOUSE_OUT,this.LuckRewardMCOnOut);
         this.FPumpkinGame.removeEvents();
      }
      
      public function Loop() : void
      {
         this.FPumpkinGame.Loop();
      }
   }
}

