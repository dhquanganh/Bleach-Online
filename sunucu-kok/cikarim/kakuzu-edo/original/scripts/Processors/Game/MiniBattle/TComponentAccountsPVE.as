package Processors.Game.MiniBattle
{
   import Components.Slots.*;
   import Components.Standard.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.Inventories.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Jade.*;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.MiniBattle.Mode.*;
   import Processors.Game.Utilities.OverLayer.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class TComponentAccountsPVE extends TProcessorLobbyWindow
   {
      
      protected static const RewardMaxSize:int = 3;
      
      protected static const RewardScreenX:int = (1250 - 622) / 2;
      
      protected static const RewardScreenY:Vector.<int> = Vector.<int>([200,150,100]);
      
      protected var FNomalRewardView:Vector.<TComponentRewardSingle>;
      
      protected var FTailUI:MovieClip;
      
      protected var FTailAdded:TextField;
      
      protected var FTailSlotBoard:Vector.<Sprite>;
      
      protected var FTailSlots:Vector.<TUISlot>;
      
      protected var FTailRewardNum:Vector.<TextField>;
      
      protected var FTailBtnBack:TUIButton;
      
      protected var FLoseView:MovieClip;
      
      protected var FLoseBtn:TUIButton;
      
      protected var FFormatStr:String;
      
      protected var FMiniBattleInfor:TMiniBattleInfor;
      
      protected var FOnBtnBackClick:Function;
      
      public function TComponentAccountsPVE(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function LogicsPerform() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         super.LogicsPerform();
         if(Visible)
         {
            _loc2_ = int(this.FTailSlots.length);
            _loc1_ = 0;
            while(_loc1_ < _loc2_)
            {
               this.FTailSlots[_loc1_].Update();
               _loc1_++;
            }
            if(this.FTailUI.currentFrame == this.FTailUI.totalFrames)
            {
               this.FTailUI.stop();
            }
         }
      }
      
      protected function LoadResource_Perform() : void
      {
         var _loc1_:int = 0;
         var _loc2_:TComponentRewardSingle = null;
         this.FNomalRewardView = new Vector.<TComponentRewardSingle>();
         _loc1_ = 0;
         while(_loc1_ < RewardMaxSize)
         {
            _loc2_ = new TComponentRewardSingle(this);
            _loc2_.LoadResource();
            _loc2_.visible = false;
            this.FNomalRewardView.push(_loc2_);
            _loc1_++;
         }
         this.LoadTailResource();
         this.LoadLoseResource();
         this.FFormatStr = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TeamBattle_String_71);
      }
      
      protected function LoadTailResource() : void
      {
         var _loc1_:Sprite = null;
         var _loc2_:int = 0;
         var _loc3_:TUISlot = null;
         var _loc4_:MovieClip = null;
         this.FTailUI = TUtilityReflection.CreateDisplayObjectInstance("PVERewardTail") as MovieClip;
         addChild(this.FTailUI);
         this.FTailUI.x = RewardScreenX;
         this.FTailUI.visible = false;
         _loc4_ = this.FTailUI["Board"];
         this.FTailAdded = _loc4_["Added"];
         this.FTailSlots = new Vector.<TUISlot>();
         this.FTailRewardNum = new Vector.<TextField>();
         this.FTailSlotBoard = new Vector.<Sprite>();
         this.FTailBtnBack = new TUIButton();
         this.FTailBtnBack.Substrate = _loc4_["BtnBack"];
         this.FTailBtnBack.OnClick = this.BtnBackOnMouseClick;
         _loc2_ = 0;
         while(_loc2_ < 2)
         {
            _loc1_ = _loc4_["Slot" + _loc2_];
            this.FTailSlotBoard.push(_loc1_);
            _loc3_ = new TUISlot(this);
            _loc3_.Resource = _loc1_["mc_slot"];
            TJadeCommon.InitSlot(_loc3_);
            _loc3_.OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
            _loc3_.OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
            _loc3_.Init();
            this.FTailSlots.push(_loc3_);
            this.FTailRewardNum.push(_loc1_["KillNum"]);
            _loc2_++;
         }
      }
      
      protected function LoadLoseResource() : void
      {
         this.FLoseView = TUtilityReflection.CreateDisplayObjectInstance("PVELose") as MovieClip;
         this.FLoseView.visible = false;
         this.FLoseView.x = RewardScreenX;
         this.FLoseView.y = (CONST_COMMON.STAGE_Height - this.FLoseView.height) / 2;
         this.FLoseBtn = new TUIButton();
         this.FLoseBtn.Substrate = this.FLoseView["btn_ok"];
         this.FLoseBtn.OnClick = this.BtnBackOnMouseClick;
         addChild(this.FLoseView);
      }
      
      protected function FindMVPIndex() : int
      {
         var _loc1_:TSoliderReward = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         _loc4_ = -1;
         _loc3_ = int(this.FMiniBattleInfor.SoliderRewards.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc1_ = this.FMiniBattleInfor.SoliderRewards[_loc2_];
            if(_loc1_.KillNum > _loc4_)
            {
               _loc4_ = _loc1_.KillNum;
               _loc5_ = _loc2_;
            }
            else if(_loc1_.KillNum == _loc4_)
            {
               return -1;
            }
            _loc2_++;
         }
         return _loc5_;
      }
      
      protected function FindMySelfSoliderReward() : TSoliderReward
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TSoliderReward = null;
         _loc2_ = int(this.FMiniBattleInfor.SoliderRewards.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FMiniBattleInfor.SoliderRewards[_loc1_];
            if(_loc3_.SoliderName == SLogicsCore.Character.NickName)
            {
               return _loc3_;
            }
            _loc1_++;
         }
         return null;
      }
      
      protected function RenderingByData() : void
      {
         var _loc1_:int = 0;
         var _loc2_:TSoliderReward = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         this.FLoseView.visible = this.FMiniBattleInfor.BattleResult == CONST_MINIBATTLE.BattleResult_Lose;
         if(this.FMiniBattleInfor.BattleResult == CONST_MINIBATTLE.BattleResult_Lose)
         {
            this.FLoseView.gotoAndPlay(1);
            return;
         }
         if(this.FMiniBattleInfor.SoliderRewards.length == 0)
         {
            this.FNomalRewardView[0].y = 150;
            this.FNomalRewardView[0].ShowRewardAccount(null,false,true);
            this.FNomalRewardView[0].visible = true;
            this.FTailUI.y = this.FNomalRewardView[0].y + this.FNomalRewardView[0].height;
            this.FTailUI.visible = true;
            this.RenderingTailByData(null);
            return;
         }
         _loc1_ = this.FindMVPIndex();
         if(_loc1_ != -1)
         {
            _loc2_ = this.FMiniBattleInfor.SoliderRewards[_loc1_];
            this.FMiniBattleInfor.SoliderRewards.splice(_loc1_,1);
            this.FMiniBattleInfor.SoliderRewards.splice(0,0,_loc2_);
         }
         _loc5_ = RewardScreenY[this.FMiniBattleInfor.SoliderRewards.length - 1];
         this.FNomalRewardView[0].ShowRewardAccount(this.FMiniBattleInfor.SoliderRewards[0],_loc1_ != -1,true);
         this.FNomalRewardView[0].visible = true;
         this.FNomalRewardView[0].y = _loc5_;
         _loc5_ += 145 - 36;
         _loc4_ = int(this.FMiniBattleInfor.SoliderRewards.length);
         _loc3_ = 1;
         while(_loc3_ < _loc4_)
         {
            this.FNomalRewardView[_loc3_].ShowRewardAccount(this.FMiniBattleInfor.SoliderRewards[_loc3_],false,false);
            this.FNomalRewardView[_loc3_].visible = true;
            this.FNomalRewardView[_loc3_].y = _loc5_;
            _loc5_ += 109;
            _loc3_++;
         }
         while(_loc3_ < RewardMaxSize)
         {
            this.FNomalRewardView[_loc3_].visible = false;
            _loc3_++;
         }
         _loc5_ += 36;
         _loc2_ = this.FindMySelfSoliderReward();
         this.RenderingTailByData(_loc2_);
         this.FTailUI.visible = true;
         this.FTailUI.y = _loc5_;
      }
      
      protected function RenderingTailByData(param1:TSoliderReward) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TInventory = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         this.FTailUI.gotoAndPlay(1);
         if(param1 == null)
         {
            _loc3_ = 0;
            this.FTailAdded.text = "";
         }
         else
         {
            _loc5_ = param1.FriendAdded ? this.FMiniBattleInfor.AddInfor[1] : 0;
            _loc6_ = param1.GuideAdded ? this.FMiniBattleInfor.AddInfor[2] : 0;
            this.FTailAdded.htmlText = TUtilityString.Format(this.FFormatStr,this.FMiniBattleInfor.AddInfor[0],_loc5_,_loc6_);
            _loc3_ = param1.AddedReward.Count;
         }
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FTailSlotBoard[_loc2_].visible = true;
            _loc4_ = param1.AddedReward.GetInventoryByIndex(_loc2_);
            this.FTailSlots[_loc2_].Context = _loc4_;
            this.FTailRewardNum[_loc2_].text = "x" + _loc4_.Quantity.toString();
            _loc2_++;
         }
         while(_loc2_ < 2)
         {
            this.FTailSlotBoard[_loc2_].visible = false;
            _loc2_++;
         }
      }
      
      protected function BtnBackOnMouseClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FOnBtnBackClick != null)
         {
            this.FOnBtnBackClick(this);
         }
      }
      
      public function set OnBtnBackClick(param1:Function) : void
      {
         this.FOnBtnBackClick = param1;
      }
      
      public function LoadResource() : void
      {
         this.LoadResource_Perform();
      }
      
      public function Reset() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         this.FMiniBattleInfor = null;
         _loc2_ = int(this.FNomalRewardView.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FNomalRewardView[_loc1_].Reset();
            _loc1_++;
         }
         _loc2_ = int(this.FTailSlots.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FTailSlots[_loc1_].Context = null;
            this.FTailRewardNum[_loc1_].text = "";
            _loc1_++;
         }
         this.FTailAdded.text = "";
         this.FTailUI.gotoAndStop(1);
      }
      
      public function ShowRewardAccount(param1:TMiniBattleInfor) : void
      {
         this.FMiniBattleInfor = param1;
         this.RenderingByData();
      }
   }
}

