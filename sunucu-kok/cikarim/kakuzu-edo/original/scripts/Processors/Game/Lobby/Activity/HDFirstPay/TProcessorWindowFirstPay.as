package Processors.Game.Lobby.Activity.HDFirstPay
{
   import Externals.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Bins.*;
   import Foundation.UI.*;
   import Logics.Agent.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.DatebaseVO.VO.Json.*;
   import Logics.HDActivityRecharge.*;
   import Logics.Inventories.*;
   import Logics.Streamization.Inventories.*;
   import Processors.Game.Lobby.Activity.HDFirstPay.Component.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class TProcessorWindowFirstPay extends TUIComponent
   {
      
      protected var FScence:Sprite;
      
      protected var FBT_Close:SimpleButton;
      
      protected var FTF_TotalPay:TextField;
      
      protected var FTF_NeedlPay:TextField;
      
      protected var FAward:TFirstPayAwardList;
      
      protected var FUnstreamizerInventoryReference:TUnstreamizerInventoryReference;
      
      protected var FAwardBins:TBins;
      
      protected var FAwardIndex:int;
      
      protected var FSlotOnOver:Function;
      
      protected var FSlotOnOut:Function;
      
      protected var FOnClose:Function;
      
      protected var FOnGetAward:Function;
      
      public function TProcessorWindowFirstPay(param1:TUIComponent, param2:Sprite)
      {
         super(param1);
         this.FScence = param2;
         this.FUnstreamizerInventoryReference = new TUnstreamizerInventoryReference();
         this.FAwardIndex = -1;
      }
      
      private function WindowFirstPayInit() : void
      {
         var _loc1_:Sprite = null;
         this.FBT_Close = this.FScence["btn_close"];
         this.FBT_Close.addEventListener(MouseEvent.CLICK,this.CloseOnClick);
         if(this.FScence["TF_TotalPay"])
         {
            this.FTF_TotalPay = this.FScence["TF_TotalPay"];
         }
         if(this.FScence["TF_NeedlPay"])
         {
            this.FTF_NeedlPay = this.FScence["TF_NeedlPay"];
         }
         _loc1_ = this.FScence["MC_Award"];
         this.FAward = new TFirstPayAwardList(this,_loc1_);
         this.FAward.OnOver = this.FSlotOnOver;
         this.FAward.OnOut = this.FSlotOnOut;
         this.FAward.OnRecharge = this.ProcessorOnRecharge;
         this.FAward.OnAwardClick = this.ProcessorOnGetAward;
         this.FAward.ListInit();
         this.FAwardBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_Award);
      }
      
      private function ProcessorOnRecharge(param1:Object) : void
      {
         this.CloseOnClick(null);
         SExternalCore.NavigateToRechargeUrl(SParametersCore.PayUrl);
      }
      
      private function ProcessorOnGetAward(param1:Object) : void
      {
         if(this.FOnGetAward != null)
         {
            this.FOnGetAward(this,this.FAwardIndex);
         }
      }
      
      private function UpdateAward(param1:THDFirstPayData) : void
      {
         var _loc2_:TInventories = null;
         _loc2_ = this.GetInventories(param1.GetAwardByIndex(this.FAwardIndex).ItemIdList[0]);
         this.FAward.Context = _loc2_;
         this.SetButton(this.FAwardIndex,param1);
         if(this.FAwardIndex < 2)
         {
            this.FAward.SetEffect(true);
         }
         else
         {
            this.FAward.SetEffect(false);
         }
      }
      
      private function SetButton(param1:uint, param2:THDFirstPayData) : void
      {
         var _loc3_:int = 0;
         _loc3_ = param2.GetAwardByIndex(param1).State;
         this.FAward.SetButton(_loc3_);
      }
      
      private function UpdateText(param1:THDFirstPayData) : void
      {
         this.FTF_TotalPay.text = param1.TotalPay.toString();
         this.FTF_NeedlPay.text = param1.GetAwardByIndex(this.FAwardIndex).Name;
      }
      
      protected function GetInventories(param1:uint = 0, param2:Vector.<TFixedAward> = null) : TInventories
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:TAward = null;
         var _loc6_:Vector.<TFixedAward> = null;
         var _loc7_:TInventories = null;
         var _loc8_:Vector.<uint> = null;
         var _loc9_:Vector.<uint> = null;
         if(param2 != null)
         {
            _loc6_ = param2;
         }
         else
         {
            _loc5_ = this.FAwardBins.GetDatebaseByIdentifier(param1) as TAward;
            _loc4_ = int(_loc5_.FixedAwards.length);
            _loc6_ = new Vector.<TFixedAward>(_loc4_);
            _loc3_ = 0;
            while(_loc3_ < _loc4_)
            {
               _loc6_[_loc3_] = _loc5_.FixedAwards[_loc3_];
               _loc3_++;
            }
         }
         _loc4_ = int(_loc6_.length);
         _loc8_ = new Vector.<uint>(_loc4_);
         _loc9_ = new Vector.<uint>(_loc4_);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc8_[_loc3_] = CONST_COMMON.RewardIDToTemplateID(_loc6_[_loc3_].Type,_loc6_[_loc3_].Code);
            _loc9_[_loc3_] = _loc6_[_loc3_].Amount;
            _loc3_++;
         }
         _loc7_ = new TInventories();
         this.FUnstreamizerInventoryReference.UnstreamizeGenerateInventoriesByIdentifiers(null,_loc7_,_loc8_);
         _loc4_ = _loc7_.Count;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc7_.GetInventoryByIndex(_loc3_).Quantity = _loc9_[_loc3_];
            _loc3_++;
         }
         return _loc7_;
      }
      
      private function CloseOnClick(param1:MouseEvent) : void
      {
         this.FScence.visible = false;
         if(this.FOnClose != null)
         {
            this.FOnClose(this);
         }
      }
      
      public function set SlotOnOver(param1:Function) : void
      {
         this.FSlotOnOver = param1;
      }
      
      public function set SlotOnOut(param1:Function) : void
      {
         this.FSlotOnOut = param1;
      }
      
      public function get OnClose() : Function
      {
         return this.FOnClose;
      }
      
      public function set OnClose(param1:Function) : void
      {
         this.FOnClose = param1;
      }
      
      public function get Scence() : Sprite
      {
         return this.FScence;
      }
      
      public function set Scence(param1:Sprite) : void
      {
         this.FScence = param1;
      }
      
      public function get OnGetAward() : Function
      {
         return this.FOnGetAward;
      }
      
      public function set OnGetAward(param1:Function) : void
      {
         this.FOnGetAward = param1;
      }
      
      public function FirstPayInit() : void
      {
         this.WindowFirstPayInit();
      }
      
      public function UpdateWindow(param1:uint, param2:THDFirstPayData) : void
      {
         this.FAwardIndex = param1;
         if(this.FAwardIndex > 0)
         {
            this.UpdateText(param2);
         }
         this.UpdateAward(param2);
         this.FScence.x = (CONST_COMMON.STAGE_Width - this.FScence.width) / 2;
         this.FScence.y = (CONST_COMMON.STAGE_Height - this.FScence.height) / 2;
      }
      
      public function UpdateSlot() : void
      {
         this.FAward.UpdateSlot();
      }
      
      public function Reset() : void
      {
         this.FAwardIndex = -1;
         this.FAward.Reset();
      }
   }
}

