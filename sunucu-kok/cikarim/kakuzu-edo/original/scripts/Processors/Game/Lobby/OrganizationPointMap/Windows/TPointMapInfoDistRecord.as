package Processors.Game.Lobby.OrganizationPointMap.Windows
{
   import Components.ScrollBar.TScrollBar;
   import Components.Slots.TUISlot;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Logics.Inventories.TInventories;
   import Logics.Inventories.TInventory;
   import Logics.Organization.NewFeatures.TNewOrgData;
   import Logics.Organization.VO.TOrgDistRecordBarVO;
   import Logics.SLogicsCore;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import Processors.Game.Lobby.Jade.TJadeCommon;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Processors.Game.Utilities.OverLayer.*;
   import Resources.Constants.CONST_COMMON;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class TPointMapInfoDistRecord extends TProcessorLobbyWindow
   {
      
      protected const MinScrollDistance:Number = 321;
      
      protected const ItemStamp:Number = 6.1;
      
      protected const SingleItemStamp:Number = 72;
      
      protected var FMainUI:MovieClip;
      
      protected var FData:TNewOrgData;
      
      protected var FScrollBar:TScrollBar;
      
      protected var FSlots:Vector.<TUISlot>;
      
      public function TPointMapInfoDistRecord(param1:TUIComponent)
      {
         super(param1);
         this.FData = SLogicsCore.NewOrgData;
         this.FSlots = new Vector.<TUISlot>();
      }
      
      override protected function LogicsPerform() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         super.LogicsPerform();
         if(Visible)
         {
            _loc2_ = this.FSlots.length;
            _loc1_ = 0;
            while(_loc1_ < _loc2_)
            {
               this.FSlots[_loc1_].Update();
               _loc1_++;
            }
         }
      }
      
      override public function set Visible(param1:Boolean) : void
      {
         super.Visible = param1;
         this.Update();
      }
      
      protected function OnCloseCall(param1:MouseEvent) : void
      {
         this.ResetSlots();
         ProcessorWindowClose();
      }
      
      protected function CreateItem() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:Vector.<TOrgDistRecordBarVO> = null;
         var _loc4_:TOrgDistRecordBarVO = null;
         var _loc5_:MovieClip = null;
         var _loc6_:TUISlot = null;
         var _loc7_:TInventories = null;
         var _loc8_:TInventory = null;
         _loc3_ = this.FData.DistRecordVOs;
         _loc2_ = _loc3_.length;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc4_ = _loc3_[_loc1_];
            _loc5_ = TUtilityReflection.CreateDisplayObjectInstance("MC_MapInfoDistRecordBar") as MovieClip;
            _loc6_ = new TUISlot(this);
            _loc6_.Resource = _loc5_["MC_Slot"];
            _loc6_.OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
            _loc6_.OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
            TJadeCommon.InitSlot(_loc6_);
            _loc6_.Init();
            _loc7_ = new TInventories();
            SToolReward.GetInventoryByID(CONST_COMMON.RewardIDToTemplateID(_loc4_.Type,_loc4_.Code),_loc7_);
            _loc8_ = _loc7_.GetInventoryByIndex(0);
            _loc8_.Quantity = _loc4_.Count;
            _loc6_.Context = _loc8_;
            this.FSlots.push(_loc6_);
            _loc5_.TF_Time.text = _loc4_.Time.toString();
            _loc5_.TF_Name.text = _loc4_.Name.toString();
            this.FScrollBar.AddItem(_loc5_);
            _loc1_++;
         }
      }
      
      protected function ResetSlots() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         if(this.FSlots != null)
         {
            _loc2_ = this.FSlots.length;
            _loc1_ = 0;
            while(_loc1_ < _loc2_)
            {
               this.FSlots[_loc1_].Dispose();
               _loc1_++;
            }
            this.FSlots.length = 0;
         }
      }
      
      public function UIDispatch() : void
      {
         this.FMainUI = TUtilityReflection.CreateDisplayObjectInstance("MC_PointMapInfoDistRecord") as MovieClip;
         addChild(this.FMainUI);
         this.FMainUI.Btn_Close.addEventListener(MouseEvent.CLICK,this.OnCloseCall);
         this.FScrollBar = new TScrollBar(this.FMainUI["MC_Scene"],this.MinScrollDistance,false,this.ItemStamp,this.SingleItemStamp);
      }
      
      public function Update() : void
      {
         if(Visible && this.FData != null)
         {
            this.ResetSlots();
            this.FScrollBar.Clear();
            this.CreateItem();
            this.FScrollBar.ScrollToUp();
            this.FScrollBar.Visible = true;
         }
      }
   }
}

