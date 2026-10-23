package Processors.Game.Lobby.DailyQuest
{
   import Components.Standard.TUIButton;
   import Foundation.Network.SNetworkCore;
   import Foundation.Network.TPacket;
   import Foundation.Resources.Bins.TBins;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.TUIComponent;
   import Logics.Characters.TCharacter;
   import Logics.Dailytask.TDailytask;
   import Logics.DatebaseVO.VO.TDailyAward;
   import Logics.Inventories.TInventories;
   import Logics.Inventories.TInventory;
   import Logics.SLogicsCore;
   import Logics.Streamization.Inventories.TUnstreamizerInventoryReference;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import Processors.Game.Lobby.DailyQuest.Component.TUIRewardList;
   import Resources.Constants.CONST_COMMON;
   import Resources.Constants.CONST_DAILY_QUEST;
   import Resources.Constants.CONST_DATEBASEVO;
   import Resources.Constants.CONST_NETWORK;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.utils.ByteArray;
   import ghostcat.operation.RepeatOper;
   import ghostcat.operation.TweenOper;
   import ghostcat.util.easing.Cubic;
   
   public class TProcessorWindowPoint extends TProcessorLobbyWindow
   {
      
      protected static const REWARD_LISTS:uint = 10;
      
      protected static const TOTAL_POINT:uint = 165;
      
      protected static const OFFSET:uint = 5;
      
      protected static const GRADE:uint = 15;
      
      protected static const DOUBLE_TYPE:uint = 18;
      
      protected static const GIFTCERTIFICATES_ID:uint = 14100024;
      
      protected var FRepeatOperExpBar:RepeatOper;
      
      protected var FRepeatOperFloatingBar:RepeatOper;
      
      protected var FRepeatOperFire:RepeatOper;
      
      protected var FTweenOperInExpBar:TweenOper;
      
      protected var FTweenOperOutExpBar:TweenOper;
      
      protected var FTweenOperInFloatingBar:TweenOper;
      
      protected var FTweenOperOutFloatingBar:TweenOper;
      
      protected var FTweenOperStartFadeIn:TweenOper;
      
      protected var FTweenOperStartFadeOut:TweenOper;
      
      protected var FTweenOperEndFadeIn:TweenOper;
      
      protected var FTweenOperEndFadeOut:TweenOper;
      
      protected var FMC_Point:MovieClip;
      
      protected var FMC_ExpBar:Sprite;
      
      protected var FMC_YellowBar:Sprite;
      
      protected var FMC_CurrentPoint:Sprite;
      
      protected var FMC_Friction:MovieClip;
      
      protected var FMC_Gear:MovieClip;
      
      protected var FMC_Fire:MovieClip;
      
      protected var FMC_DoubleExplanation:MovieClip;
      
      protected var FTF_CurrentPoint:TextField;
      
      protected var FMC_GainRewardBT:TUIButton;
      
      protected var FMC_RewardLists:Vector.<TUIRewardList>;
      
      protected var FIndex:int;
      
      protected var FDailyTaskBin:TBins;
      
      protected var FDailyAwardBin:TBins;
      
      protected var FDailytask:TDailytask;
      
      protected var FCharacter:TCharacter;
      
      protected var FAwardIndex:uint;
      
      protected var FCurrentPoint:uint;
      
      protected var FIsInit:Boolean;
      
      protected var FUnstreamizerInventoryReference:TUnstreamizerInventoryReference;
      
      protected var FInventories:TInventories;
      
      protected var FIDTemplates:Vector.<uint>;
      
      protected var FPoint:uint;
      
      protected var FListRewardOnOver:Function;
      
      protected var FListRewardOnOut:Function;
      
      public function TProcessorWindowPoint(param1:TUIComponent, param2:MovieClip)
      {
         super(param1);
         this.ConstructTweens();
         this.FMC_RewardLists = new Vector.<TUIRewardList>(REWARD_LISTS);
         this.FIDTemplates = new Vector.<uint>(REWARD_LISTS);
         this.FInventories = new TInventories();
         this.FUnstreamizerInventoryReference = new TUnstreamizerInventoryReference();
         this.FDailytask = SLogicsCore.Character.DailyTask;
         this.FCharacter = SLogicsCore.Character;
         this.FMC_Point = param2;
         this.FIsInit = false;
         this.InitPoint();
      }
      
      protected function ConstructTweens() : void
      {
         this.FRepeatOperFire = new RepeatOper();
         this.FTweenOperStartFadeIn = new TweenOper();
         this.FTweenOperStartFadeOut = new TweenOper();
         this.FTweenOperEndFadeIn = new TweenOper();
         this.FTweenOperEndFadeOut = new TweenOper();
         this.FRepeatOperExpBar = new RepeatOper();
         this.FRepeatOperFloatingBar = new RepeatOper();
         this.FTweenOperInExpBar = new TweenOper();
         this.FTweenOperOutExpBar = new TweenOper();
         this.FTweenOperInFloatingBar = new TweenOper();
         this.FTweenOperOutFloatingBar = new TweenOper();
         this.FTweenOperStartFadeIn.duration = 10;
         this.FTweenOperStartFadeOut.duration = 500;
         this.FTweenOperEndFadeIn.duration = 10;
         this.FTweenOperEndFadeOut.duration = 1000;
         this.FTweenOperInExpBar.duration = 10;
         this.FTweenOperOutExpBar.duration = 1000;
         this.FTweenOperInFloatingBar.duration = 10;
         this.FTweenOperOutFloatingBar.duration = 1000;
         this.FRepeatOperFire.loop = 1;
         this.FRepeatOperFire.children = [this.FTweenOperStartFadeIn,this.FTweenOperStartFadeOut,this.FTweenOperEndFadeIn,this.FTweenOperEndFadeOut];
         this.FRepeatOperExpBar.loop = 1;
         this.FRepeatOperExpBar.children = [this.FTweenOperInExpBar,this.FTweenOperOutExpBar];
         this.FRepeatOperFloatingBar.loop = 1;
         this.FRepeatOperFloatingBar.children = [this.FTweenOperInFloatingBar,this.FTweenOperOutFloatingBar];
      }
      
      protected function InitPoint() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:MovieClip = null;
         var _loc4_:TUIRewardList = null;
         this.FMC_DoubleExplanation = this.FMC_Point[CONST_DAILY_QUEST.RESOURCE_Link_MC_DoubleExplanation];
         this.FMC_ExpBar = this.FMC_Point[CONST_DAILY_QUEST.RESOURCE_Link_MC_ExpBar];
         this.FMC_CurrentPoint = this.FMC_ExpBar[CONST_DAILY_QUEST.RESOURCE_Link_MC_CurrentPoint];
         this.FMC_YellowBar = this.FMC_ExpBar["MC_Bar"][CONST_DAILY_QUEST.RESOURCE_Link_MC_YellowBar];
         this.FMC_YellowBar.y += this.FMC_YellowBar.height;
         this.FTF_CurrentPoint = this.FMC_CurrentPoint[CONST_DAILY_QUEST.RESOURCE_Link_TF_CurrentPoint];
         this.FMC_Gear = this.FMC_CurrentPoint[CONST_DAILY_QUEST.RESOURCE_Link_MC_Gear];
         this.FMC_Friction = this.FMC_CurrentPoint[CONST_DAILY_QUEST.RESOURCE_Link_MC_Friction];
         this.FMC_Fire = this.FMC_CurrentPoint[CONST_DAILY_QUEST.RESOURCE_Link_MC_Fire];
         this.FMC_Fire.play();
         this.FMC_Friction.alpha = 0;
         this.FMC_GainRewardBT = new TUIButton();
         this.FMC_GainRewardBT.Substrate = this.FMC_Point[CONST_DAILY_QUEST.RESOURCE_Link_MC_GainRewardBT];
         this.FMC_GainRewardBT.OnClick = this.GainRewarOnClick;
         _loc2_ = REWARD_LISTS;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FMC_Point[CONST_DAILY_QUEST.RESOURCE_Link_MC_RewardLists + _loc1_];
            _loc4_ = new TUIRewardList(this);
            _loc4_.Perform_UIDispatch(_loc3_);
            _loc4_.OnOver = this.ListOnOver;
            _loc4_.OnOut = this.ListOnOut;
            this.FMC_RewardLists[_loc1_] = _loc4_;
            _loc1_++;
         }
         this.FDailyTaskBin = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_DailyTask);
         this.FDailyAwardBin = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_DailyAward);
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(!this.Visible)
         {
            return;
         }
         if(this.FMC_Friction != null)
         {
            if(this.FMC_Friction.alpha != 0)
            {
               if(!this.FMC_Gear.isPlaying)
               {
                  this.FMC_Gear.play();
               }
            }
            else
            {
               this.FMC_Gear.stop();
            }
         }
      }
      
      private function ListOnOut(param1:TUIRewardList) : void
      {
         if(this.FListRewardOnOut != null)
         {
            this.FListRewardOnOut(this,param1.Context);
         }
      }
      
      protected function ListOnOver(param1:TUIRewardList, param2:Object) : void
      {
         if(this.FListRewardOnOver != null)
         {
            this.FListRewardOnOver(this,param2);
         }
      }
      
      protected function GainRewarOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TPacket = null;
         var _loc4_:ByteArray = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:String = null;
         var _loc8_:uint = 0;
         var _loc9_:TDailyAward = null;
         var _loc10_:uint = 0;
         _loc7_ = this.FDailytask.IsAward.toString(2);
         _loc10_ = uint(_loc7_.length);
         if(_loc7_ == "0")
         {
            _loc10_ = 0;
         }
         _loc6_ = uint(this.FDailyAwardBin.Count);
         _loc8_ = this.FCharacter.GetMainLevel();
         _loc5_ = 0;
         while(_loc5_ < _loc6_)
         {
            _loc9_ = this.FDailyAwardBin.GetDatebaseByIndex(_loc5_) as TDailyAward;
            if(_loc8_ < _loc9_.Level1)
            {
               break;
            }
            _loc5_++;
         }
         _loc5_ -= REWARD_LISTS;
         this.FAwardIndex = _loc5_ + _loc10_ + 1;
         _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_DailyTask_RewardReq);
         _loc4_ = _loc3_.Data;
         _loc4_.writeInt(this.FAwardIndex);
         SNetworkCore.Transceiver.PacketTransmit(_loc3_);
         this.FMC_GainRewardBT.Enabled = false;
      }
      
      protected function PointUpdat() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:int = 0;
         this.FTF_CurrentPoint.text = this.FPoint.toString();
         this.FMC_Friction.play();
         this.FTweenOperStartFadeIn.target = this.FMC_Friction;
         this.FTweenOperStartFadeIn.params = {"alpha":0};
         this.FTweenOperStartFadeOut.target = this.FMC_Friction;
         this.FTweenOperStartFadeOut.params = {"alpha":1};
         _loc1_ = this.FPoint / TOTAL_POINT;
         if(_loc1_ > 1)
         {
            _loc1_ = 1;
         }
         _loc2_ = this.FMC_YellowBar.height * _loc1_;
         if(this.FCurrentPoint == this.FPoint)
         {
            return;
         }
         this.FTweenOperInExpBar.target = this.FMC_YellowBar;
         this.FTweenOperInExpBar.params = {
            "y":this.FMC_YellowBar.y,
            "ease":Cubic.easeIn
         };
         this.FTweenOperOutExpBar.target = this.FMC_YellowBar;
         this.FTweenOperOutExpBar.params = {
            "y":this.FMC_YellowBar.height - _loc2_ + this.FMC_YellowBar.height,
            "ease":Cubic.easeOut
         };
         this.FTweenOperInFloatingBar.target = this.FMC_CurrentPoint;
         this.FTweenOperInFloatingBar.params = {
            "y":this.FMC_CurrentPoint.y,
            "ease":Cubic.easeIn
         };
         this.FTweenOperOutFloatingBar.target = this.FMC_CurrentPoint;
         this.FTweenOperOutFloatingBar.params = {
            "y":this.FMC_YellowBar.height - _loc2_ - 23,
            "ease":Cubic.easeOut
         };
         this.FTweenOperEndFadeIn.target = this.FMC_Friction;
         this.FTweenOperEndFadeIn.params = {"alpha":1};
         this.FTweenOperEndFadeOut.target = this.FMC_Friction;
         this.FTweenOperEndFadeOut.params = {"alpha":0};
         this.FRepeatOperExpBar.execute();
         this.FRepeatOperFloatingBar.execute();
         this.FRepeatOperFire.execute();
         this.FCurrentPoint = this.FPoint;
      }
      
      protected function ListTextUpdate() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:TDailyAward = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         var _loc10_:TInventory = null;
         this.FIDTemplates.length = 0;
         this.FInventories.Clear();
         _loc2_ = uint(this.FDailyAwardBin.Count);
         _loc3_ = this.FCharacter.GetMainLevel();
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc4_ = this.FDailyAwardBin.GetDatebaseByIndex(_loc1_) as TDailyAward;
            if(_loc3_ < _loc4_.Level1)
            {
               break;
            }
            _loc1_++;
         }
         _loc1_ -= REWARD_LISTS;
         _loc5_ = 0;
         while(_loc5_ < REWARD_LISTS)
         {
            _loc4_ = this.FDailyAwardBin.GetDatebaseByIndex(_loc5_ + _loc1_) as TDailyAward;
            _loc6_ = _loc4_.RewardsVect[0].Type;
            _loc7_ = _loc4_.RewardsVect[0].Code;
            this.FIDTemplates[_loc5_] = CONST_COMMON.RewardIDToTemplateID(_loc6_,_loc7_);
            _loc5_++;
         }
         this.FUnstreamizerInventoryReference.UnstreamizeGenerateInventoriesByIdentifiers(null,this.FInventories,this.FIDTemplates);
         _loc5_ = 0;
         while(_loc5_ < REWARD_LISTS)
         {
            _loc10_ = this.FInventories.GetInventoryByIndex(_loc5_);
            _loc4_ = this.FDailyAwardBin.GetDatebaseByIndex(_loc5_ + _loc1_) as TDailyAward;
            _loc8_ = _loc4_.RewardsVect[0].Amount;
            _loc10_.Quantity = _loc8_;
            this.FMC_RewardLists[_loc5_].Context = _loc10_;
            this.FMC_RewardLists[_loc5_].Update();
            _loc5_++;
         }
      }
      
      protected function ListUpdate(param1:Boolean) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:Array = null;
         var _loc5_:String = null;
         _loc5_ = this.FDailytask.IsAward.toString(2);
         _loc4_ = _loc5_.split("");
         _loc4_.reverse();
         if(this.FPoint >= GRADE)
         {
            this.FIndex = Math.floor((this.FPoint - GRADE) / GRADE);
         }
         else
         {
            this.FIndex = -1;
         }
         _loc2_ = 0;
         while(_loc2_ < REWARD_LISTS)
         {
            if(_loc2_ > this.FIndex)
            {
               _loc3_ = uint(TUIRewardList.RENDERINGSTATE_Disabled);
               if(this.FDailytask.IsDouble == 0)
               {
                  this.FMC_RewardLists[_loc2_].IsDouble = false;
               }
            }
            else
            {
               if(_loc4_[_loc2_] == "1")
               {
                  _loc3_ = uint(TUIRewardList.RENDERINGSTATE_Normal);
               }
               else
               {
                  _loc3_ = uint(TUIRewardList.RENDERINGSTATE_Selected);
               }
               if(this.FDailytask.IsDouble == 1)
               {
                  this.FMC_RewardLists[_loc2_].IsDouble = true;
               }
            }
            this.FMC_RewardLists[_loc2_].SetStatus(_loc3_,param1);
            _loc2_++;
         }
         if(this.FIndex == -1)
         {
            this.FMC_GainRewardBT.Enabled = false;
         }
         else if(this.FMC_RewardLists[this.FIndex].MC_List.currentFrame == TUIRewardList.RENDERINGSTATE_Normal)
         {
            this.FMC_GainRewardBT.Enabled = false;
         }
         else
         {
            this.FMC_GainRewardBT.Enabled = true;
         }
      }
      
      public function get AwardIndex() : uint
      {
         return this.FAwardIndex - 1;
      }
      
      public function get ListRewardOnOver() : Function
      {
         return this.FListRewardOnOver;
      }
      
      public function set ListRewardOnOver(param1:Function) : void
      {
         this.FListRewardOnOver = param1;
      }
      
      public function get ListRewardOnOut() : Function
      {
         return this.FListRewardOnOut;
      }
      
      public function set ListRewardOnOut(param1:Function) : void
      {
         this.FListRewardOnOut = param1;
      }
      
      public function Update(param1:Boolean) : void
      {
         this.FPoint = this.FDailytask.Point;
         this.ListTextUpdate();
         this.ListUpdate(param1);
         this.PointUpdat();
         this.FMC_Fire.play();
         if(this.FDailytask.IsDouble == 1)
         {
            this.FMC_DoubleExplanation.gotoAndStop(2);
         }
         else
         {
            this.FMC_DoubleExplanation.gotoAndStop(1);
         }
      }
      
      public function awardListUpdate() : void
      {
         this.ListUpdate(false);
      }
      
      public function UpdateDouble() : void
      {
         this.FDailytask.IsDouble = 1;
         this.ListUpdate(true);
         if(this.FDailytask.IsDouble == 1)
         {
            this.FMC_DoubleExplanation.gotoAndStop(2);
         }
         else
         {
            this.FMC_DoubleExplanation.gotoAndStop(1);
         }
      }
      
      public function Reset() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         this.FMC_Fire.stop();
         this.FMC_Friction.stop();
         this.FInventories.Clear();
         _loc2_ = REWARD_LISTS;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FMC_RewardLists[_loc1_].Context = null;
            _loc1_++;
         }
      }
   }
}

