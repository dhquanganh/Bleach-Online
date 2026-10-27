package Processors.Game.Lobby.NpcDialog
{
   import Components.Slots.TUISlot;
   import Foundation.Common.TCoordinate;
   import Foundation.Queries.Coordinate.TQueryCoordinate;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityCartisian;
   import Logics.Inventories.TInventories;
   import Logics.Inventories.TInventory;
   import Logics.Quests.TQuest;
   import Processors.Game.Common.Effects.Texts.TEffectCoordinateParameters;
   import Processors.Game.Lobby.Jade.TJadeCommon;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Resources.Constants.CONST_COMMON;
   import Resources.Constants.CONST_INVENTORY;
   import Resources.Constants.CONST_SHORTCUTS;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class TProcessorWindowNpcQuestReward extends TUIComponent
   {
      
      protected static const SLOT_NUM:int = 6;
      
      protected var FTF_Reward:TextField;
      
      protected var FSlot_Reward:Vector.<TUISlot>;
      
      protected var FRewardInventories:TInventories;
      
      protected var FEffectCoordinateParameters:TEffectCoordinateParameters;
      
      protected var FQueryCoordinate:TQueryCoordinate;
      
      protected var FSlotOver:Function;
      
      protected var FSlotOut:Function;
      
      protected var FOnEffectAcquireInventory:Function;
      
      protected var FOnQueryShortcutCoordinate:Function;
      
      public function TProcessorWindowNpcQuestReward(param1:TUIComponent)
      {
         super(param1);
      }
      
      public function UIDispath(param1:MovieClip) : void
      {
         var _loc2_:int = 0;
         var _loc3_:TUISlot = null;
         var _loc4_:MovieClip = null;
         param1.gotoAndStop(1);
         _loc4_ = param1["UI_Reward"];
         this.x = _loc4_.x;
         this.y = _loc4_.y;
         _loc4_.x = 0;
         _loc4_.y = 0;
         addChild(_loc4_);
         this.FTF_Reward = _loc4_["TF_ItemText"];
         this.FSlot_Reward = new Vector.<TUISlot>();
         _loc2_ = 0;
         while(_loc2_ < SLOT_NUM)
         {
            _loc3_ = new TUISlot(this);
            _loc3_.Resource = _loc4_["MC_Slot_" + (_loc2_ + 1)];
            TJadeCommon.InitSlot(_loc3_);
            _loc3_.tabIndex = _loc2_;
            _loc3_.OnOver = this.FSlotOver;
            _loc3_.OnOut = this.FSlotOut;
            _loc3_.Init();
            this.FSlot_Reward.push(_loc3_);
            _loc2_++;
         }
         this.FRewardInventories = new TInventories();
         this.FEffectCoordinateParameters = new TEffectCoordinateParameters();
         this.FQueryCoordinate = new TQueryCoordinate();
      }
      
      public function UILocation() : void
      {
      }
      
      protected function ShowRewardDescription(param1:TQuest) : void
      {
         this.FTF_Reward.text = this.GetRewardDescription(param1.RewardsInventory);
      }
      
      protected function ShowRewardSlog(param1:TQuest) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         this.FRewardInventories.Clear();
         this.GetRewardsOfInventory(param1.RewardsInventory,this.FRewardInventories);
         _loc3_ = this.FRewardInventories.Count;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(_loc2_ >= 6)
            {
               return;
            }
            this.FSlot_Reward[_loc2_].Context = this.FRewardInventories.GetInventoryByIndex(_loc2_);
            this.FSlot_Reward[_loc2_].visible = true;
            _loc2_++;
         }
         _loc2_ = _loc3_;
         while(_loc2_ < this.FSlot_Reward.length)
         {
            this.FSlot_Reward[_loc2_].Context = null;
            this.FSlot_Reward[_loc2_].visible = false;
            _loc2_++;
         }
      }
      
      protected function GetRewardDescription(param1:TInventories) : String
      {
         var _loc2_:Boolean = false;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:TInventory = null;
         var _loc6_:String = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:Vector.<uint> = null;
         _loc6_ = "";
         _loc4_ = param1.Count;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc5_ = param1.GetInventoryByIndex(_loc3_);
            _loc2_ = this.IfInventory(_loc5_.IDTemplate);
            if(!_loc2_)
            {
               _loc10_ = CONST_COMMON.REWARDIDNotInventory_DATA;
               _loc9_ = _loc10_.indexOf(_loc5_.IDTemplate);
               _loc7_ = int(CONST_COMMON.REWARDID_TOMAINCODE[_loc9_]);
               _loc8_ = int(CONST_COMMON.REWARDID_TOSUBCODE[_loc9_]);
               _loc6_ += TUtilityLobby.GetItemName(_loc7_,_loc8_);
               _loc6_ = _loc6_ + (":" + _loc5_.Quantity + "    ");
            }
            _loc3_++;
         }
         return _loc6_;
      }
      
      protected function GetRewardsOfInventory(param1:TInventories, param2:TInventories) : void
      {
         var _loc3_:Boolean = false;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TInventory = null;
         _loc5_ = param1.Count;
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc6_ = param1.GetInventoryByIndex(_loc4_);
            _loc3_ = this.IfInventory(_loc6_.IDTemplate);
            if(_loc3_)
            {
               param2.Add(_loc6_);
            }
            _loc4_++;
         }
      }
      
      protected function IfInventory(param1:uint) : Boolean
      {
         var _loc2_:int = 0;
         var _loc3_:Vector.<uint> = null;
         _loc3_ = CONST_COMMON.REWARDIDNotInventory_DATA;
         _loc2_ = _loc3_.indexOf(param1);
         return _loc2_ < 0;
      }
      
      protected function UpdateSlots_Perform() : void
      {
         var _loc1_:int = 0;
         var _loc2_:TUISlot = null;
         _loc1_ = 0;
         while(_loc1_ < this.FSlot_Reward.length)
         {
            _loc2_ = this.FSlot_Reward[_loc1_];
            if(_loc2_.visible)
            {
               _loc2_.Update();
            }
            _loc1_++;
         }
      }
      
      protected function ProcessorEffectAcquireInventory(param1:Vector.<TUISlot>) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:uint = 0;
         var _loc5_:TUISlot = null;
         var _loc6_:Object = null;
         var _loc7_:TInventory = null;
         var _loc8_:TCoordinate = null;
         _loc3_ = int(param1.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc5_ = param1[_loc2_];
            _loc6_ = _loc5_.Context;
            if(_loc6_ == null)
            {
               break;
            }
            _loc7_ = _loc6_ as TInventory;
            switch(_loc7_.Category)
            {
               case CONST_INVENTORY.CATEGORY_Normal:
                  switch(_loc7_.CategorySecond)
                  {
                     case 300:
                        _loc4_ = CONST_SHORTCUTS.TYPE_MainFunction_TacticalDeployment;
                        break;
                     default:
                        _loc4_ = CONST_SHORTCUTS.TYPE_MainFunction_Backpack;
                  }
                  break;
               default:
                  _loc4_ = CONST_SHORTCUTS.TYPE_MainFunction_Backpack;
            }
            if(this.FOnQueryShortcutCoordinate != null)
            {
               this.FOnQueryShortcutCoordinate(this,CONST_SHORTCUTS.POSITION_MainFunction,_loc4_,this.FQueryCoordinate);
            }
            _loc8_ = TUtilityCartisian.GetScreenCoordinateByDisplayObject(_loc5_.Resource);
            _loc8_.X += 4;
            _loc8_.Y += 4;
            this.FEffectCoordinateParameters.CoordinateSource.Assign(_loc8_);
            this.FEffectCoordinateParameters.CoordinateDestination.Assign(this.FQueryCoordinate.Value);
            if(this.FOnEffectAcquireInventory != null)
            {
               this.FOnEffectAcquireInventory(this,_loc6_,this.FEffectCoordinateParameters);
            }
            _loc2_++;
         }
      }
      
      public function set SlotOver(param1:Function) : void
      {
         this.FSlotOver = param1;
      }
      
      public function set SlotOut(param1:Function) : void
      {
         this.FSlotOut = param1;
      }
      
      public function set OnEffectAcquireInventory(param1:Function) : void
      {
         this.FOnEffectAcquireInventory = param1;
      }
      
      public function set OnQueryShortcutCoordinate(param1:Function) : void
      {
         this.FOnQueryShortcutCoordinate = param1;
      }
      
      public function ShowByQuest(param1:TQuest) : void
      {
         this.ShowRewardDescription(param1);
         this.ShowRewardSlog(param1);
      }
      
      public function UpdateSlots() : void
      {
         this.UpdateSlots_Perform();
      }
      
      public function PlayRewardIntoBackpack() : void
      {
         this.ProcessorEffectAcquireInventory(this.FSlot_Reward);
      }
   }
}

