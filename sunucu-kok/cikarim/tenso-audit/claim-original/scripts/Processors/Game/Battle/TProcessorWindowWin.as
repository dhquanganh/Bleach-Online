package Processors.Game.Battle
{
   import Components.Slots.*;
   import Components.Standard.TUIButton;
   import Foundation.Common.THint;
   import Foundation.Queries.TQueryString;
   import Foundation.Queries.Textures.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Bins.*;
   import Foundation.Resources.Repositories.*;
   import Foundation.Resources.Textures.*;
   import Foundation.Timing.STimingCore;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.Inventories.*;
   import Logics.Items.*;
   import Logics.Streamization.Inventories.TUnstreamizerInventoryReference;
   import Logics.Streamization.Items.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Resources.Constants.*;
   import Resources.Strings.*;
   import flash.display.*;
   import flash.events.*;
   import flash.utils.*;
   
   public class TProcessorWindowWin extends TProcessorLobbyWindow
   {
      
      public static const MAX_COUNT:int = 3;
      
      public static const QUALITYCOLOR_INDEX:Vector.<uint> = CONST_COMMON.QUALITYCOLOR_INDEX;
      
      protected static const CloseDurationTime:int = 3000;
      
      protected var FScene:MovieClip;
      
      protected var FReward:TItems;
      
      protected var FCurPage:int;
      
      protected var FTotlePage:int;
      
      protected var FUISlots:Vector.<TUISlot>;
      
      protected var FArticle:TBins;
      
      protected var FIDTemplates:Vector.<uint>;
      
      protected var FQualityTemplates:Vector.<uint>;
      
      protected var FInventories:TInventories;
      
      protected var FUnstreamizerInventoryReference:TUnstreamizerInventoryReference;
      
      protected var FHintBtn:THint;
      
      protected var FBT_Get:TUIButton;
      
      protected var FBT_Statistics:TUIButton;
      
      protected var FClickCallBack:Function;
      
      protected var FReplayCallBack:Function;
      
      protected var FStatisticsCallBack:Function;
      
      protected var FSlotsOnMove:Function;
      
      protected var FSlotsOnOut:Function;
      
      protected var FHintOnMove:Function;
      
      protected var FHintOnOut:Function;
      
      protected var FAutoClose:Boolean;
      
      protected var FTimeRecord:int;
      
      public function TProcessorWindowWin(param1:TUIComponent)
      {
         super(param1);
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
      
      protected function InitBattleWinWindow() : void
      {
         var _loc1_:int = 0;
         this.FHintBtn = new THint();
         this.FArticle = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_Article);
         this.FCurPage = 1;
         this.FTotlePage = 1;
         this.FUISlots = new Vector.<TUISlot>(MAX_COUNT);
         this.FIDTemplates = new Vector.<uint>(MAX_COUNT);
         this.FQualityTemplates = new Vector.<uint>(MAX_COUNT);
         this.FInventories = new TInventories();
         this.FUnstreamizerInventoryReference = new TUnstreamizerInventoryReference();
         if(this.FScene == null)
         {
            this.FScene = TUtilityReflection.CreateDisplayObjectInstance(CONST_BATTLE.RESOURCE_ClassName_Win) as MovieClip;
            addChild(this.FScene);
         }
         this.FBT_Get = new TUIButton();
         this.FBT_Get.Substrate = this.FScene.btn_get;
         this.FBT_Get.OnClick = this.OnOutBattle;
         this.FBT_Get.Enabled = true;
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
         _loc1_ = 0;
         while(_loc1_ < MAX_COUNT)
         {
            this.FUISlots[_loc1_] = this.GetSlot();
            this.FUISlots[_loc1_].Resource = this.FScene["mc_slot_" + _loc1_];
            this.FUISlots[_loc1_].Init();
            _loc1_++;
         }
      }
      
      protected function GetSlot() : TUISlot
      {
         var _loc1_:TUISlot = null;
         _loc1_ = new TUISlot(this);
         _loc1_.SequenceDefaultIcon = SResourcesCore.TexturesLobby.GetAnimationSequenceByIdentifiers(CONST_LOBBY.RESOURCESID_Texture_SlotDefaultEffect,0);
         _loc1_.OnOver = this.FSlotsOnMove;
         _loc1_.OnOut = this.FSlotsOnOut;
         _loc1_.OnQuerySequenceContext = this.SlotsOnQuerySequenceContext;
         _loc1_.OnQuerySubscript = this.SlotsOnQuerySubscript;
         return _loc1_;
      }
      
      protected function SlotsOnQuerySequenceContext(param1:Object, param2:Object, param3:TQueryAnimationSequence, param4:uint = 0) : void
      {
         var _loc5_:TInventory = null;
         var _loc6_:TResourceRepositoryTexture = null;
         var _loc7_:TTexture = null;
         _loc5_ = param2 as TInventory;
         _loc6_ = SResourcesCore.TexturesInventory;
         _loc7_ = _loc6_.GetTextureByIdentifier(_loc5_.IDTexture);
         if(_loc7_ != null)
         {
            param3.Value = _loc7_.GetAnimationSequenceByIdentifier(param4);
         }
         else
         {
            _loc6_.LoadSecondary(_loc5_.IDTexture);
         }
      }
      
      protected function SlotsOnQuerySubscript(param1:Object, param2:Object, param3:TQueryString) : void
      {
         var _loc4_:TAppliance = null;
         if(param2 is TAppliance)
         {
            _loc4_ = param2 as TAppliance;
            param3.Value = _loc4_.Quantity.toString();
         }
      }
      
      protected function CheckBtn() : void
      {
      }
      
      protected function SetSlot() : void
      {
         var _loc1_:int = 0;
         var _loc2_:String = null;
         var _loc3_:TArticle = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:String = null;
         var _loc7_:TItem = null;
         var _loc8_:uint = 0;
         var _loc9_:TInventory = null;
         this.FScene.mc_info.mc_exp.visible = false;
         this.FScene.mc_info.mc_money.visible = false;
         this.FScene.mc_info.mc_soul.visible = false;
         _loc6_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_BATTLE_09);
         if(this.FReward != null)
         {
            this.FIDTemplates.length = 0;
            this.FQualityTemplates.length = 0;
            _loc4_ = (this.FCurPage - 1) * MAX_COUNT;
            if(this.FReward.Exp > 0)
            {
               this.FScene.mc_info.mc_exp.tf_name.text = _loc6_ + TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ITEMNAME_Exp);
               this.FScene.mc_info.mc_exp.tf_value.text = "+" + this.FReward.Exp;
               this.FScene.mc_info.mc_exp.visible = true;
            }
            else if(this.FReward.Prestige > 0)
            {
               this.FScene.mc_info.mc_exp.tf_name.text = _loc6_ + TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ITEMNAME_Prestige);
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
               this.FScene.mc_info.mc_money.tf_name.text = _loc6_ + TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ITEMNAME_Coin);
               this.FScene.mc_info.mc_money.tf_value.text = "+" + this.FReward.Money;
            }
            this.FScene.mc_info.mc_soul.visible = Boolean(this.FReward.Soul > 0);
            if(this.FReward.Soul > 0)
            {
               this.FScene.mc_info.mc_soul.tf_name.text = _loc6_ + TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ITEMNAME_Soul);
               this.FScene.mc_info.mc_soul.tf_value.text = "+" + this.FReward.Soul;
            }
            _loc1_ = 0;
            while(_loc1_ < MAX_COUNT)
            {
               if(_loc1_ + _loc4_ < this.FReward.ItemIDs.length)
               {
                  _loc7_ = this.FReward.ItemIDs[_loc1_ + _loc4_];
                  _loc8_ = CONST_COMMON.RewardIDToTemplateID(_loc7_.Type,_loc7_.ID);
                  this.FScene["mc_slot_" + _loc1_].visible = true;
                  _loc3_ = this.FArticle.GetDatebaseByIdentifier(_loc8_) as TArticle;
                  _loc2_ = _loc3_.Name;
                  _loc5_ = _loc3_.Quality;
                  this.FIDTemplates.push(_loc8_);
                  this.FQualityTemplates.push(_loc7_.Count);
                  this.FScene["mc_slot_" + _loc1_].tf_name.text = _loc2_;
                  this.FScene["mc_slot_" + _loc1_].tf_name.textColor = QUALITYCOLOR_INDEX[_loc5_];
               }
               else
               {
                  this.FScene["mc_slot_" + _loc1_].visible = false;
               }
               _loc1_++;
            }
            this.FInventories.Clear();
            this.FUnstreamizerInventoryReference.UnstreamizeGenerateInventoriesByIdentifiers(null,this.FInventories,this.FIDTemplates);
            _loc1_ = 0;
            while(_loc1_ < this.FInventories.Count)
            {
               _loc9_ = this.FInventories.GetInventoryByIndex(_loc1_);
               _loc9_.Quantity = this.FQualityTemplates[_loc1_];
               this.FUISlots[_loc1_].Context = _loc9_;
               _loc1_++;
            }
            _loc1_ = this.FInventories.Count;
            while(_loc1_ < MAX_COUNT)
            {
               this.FUISlots[_loc1_].Context = null;
               _loc1_++;
            }
         }
      }
      
      protected function OnOutBattle(param1:Object, param2:MouseEvent = null) : void
      {
         this.visible = false;
         this.FCurPage = 1;
         this.FReward = null;
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
         this.visible = false;
         if(this.FReplayCallBack != null)
         {
            this.FReplayCallBack(this);
         }
      }
      
      protected function OnUp(param1:MouseEvent) : void
      {
         --this.FCurPage;
         if(this.FCurPage < 1)
         {
            this.FCurPage = 1;
         }
         this.CheckBtn();
         this.SetSlot();
      }
      
      protected function OnDown(param1:MouseEvent) : void
      {
         ++this.FCurPage;
         if(this.FCurPage > this.FTotlePage)
         {
            this.FCurPage = this.FTotlePage;
         }
         this.CheckBtn();
         this.SetSlot();
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
      
      public function set SlotsOnMove(param1:Function) : void
      {
         this.FSlotsOnMove = param1;
      }
      
      public function get SlotsOnMove() : Function
      {
         return this.FSlotsOnMove;
      }
      
      public function set SlotsOnOut(param1:Function) : void
      {
         this.FSlotsOnOut = param1;
      }
      
      public function get SlotsOnOut() : Function
      {
         return this.FSlotsOnOut;
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
      
      override public function set visible(param1:Boolean) : void
      {
         super.visible = param1;
         if(param1)
         {
            this.FScene.gotoAndPlay(1);
         }
      }
      
      public function get StatisticsCallBack() : Function
      {
         return this.FStatisticsCallBack;
      }
      
      public function set StatisticsCallBack(param1:Function) : void
      {
         this.FStatisticsCallBack = param1;
      }
      
      public function Setup() : void
      {
         this.InitBattleWinWindow();
      }
      
      public function SetWindow(param1:TItems, param2:Boolean = false, param3:Boolean = false, param4:Boolean = false) : void
      {
         this.FReward = param1;
         this.FTotlePage = Math.max(int(this.FReward.ItemIDs.length - 1) / MAX_COUNT + 1,1);
         this.FScene.btn_copy.visible = param2;
         this.FScene.btn_replay.visible = param3;
         this.CheckBtn();
         this.SetSlot();
         this.FAutoClose = param4;
         this.FTimeRecord = STimingCore.TickCount + CloseDurationTime;
      }
      
      public function UpdataSlot() : void
      {
         var _loc1_:int = 0;
         if(this.FReward == null)
         {
            return;
         }
         _loc1_ = 0;
         while(_loc1_ < MAX_COUNT)
         {
            if(_loc1_ < this.FUISlots.length)
            {
               this.FUISlots[_loc1_].Update();
            }
            _loc1_++;
         }
      }
      
      public function set StatisticsBtnEnabled(param1:Boolean) : void
      {
         this.FBT_Statistics.Enabled = param1;
      }
   }
}

