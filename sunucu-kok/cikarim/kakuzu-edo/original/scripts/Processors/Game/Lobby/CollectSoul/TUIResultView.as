package Processors.Game.Lobby.CollectSoul
{
   import Components.Slots.TUISlot;
   import Components.Standard.TUIButton;
   import Foundation.Common.TCoordinate;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityCartisian;
   import Logics.Inventories.TInventories;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import Processors.Game.Lobby.Jade.TJadeCommon;
   import Processors.Game.Utilities.Common.SUtilityResource;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class TUIResultView extends TProcessorLobbyWindow
   {
      
      protected var FMainUI:MovieClip;
      
      protected var FBtn_Get:TUIButton;
      
      protected var FSlots:Vector.<TUISlot>;
      
      protected var FNames:Vector.<TextField>;
      
      public function TUIResultView(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function LogicsPerform() : void
      {
         var _loc1_:TUISlot = null;
         super.LogicsPerform();
         if(!Visible)
         {
            return;
         }
         if(this.FSlots != null)
         {
            for each(_loc1_ in this.FSlots)
            {
               _loc1_.Update();
            }
         }
      }
      
      protected function OnCloseBtnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         _loc4_ = 10;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            this.FNames[_loc3_].text = "";
            this.FSlots[_loc3_].Context = null;
            _loc3_++;
         }
         ProcessorWindowClose();
      }
      
      public function UIDispatch(param1:MovieClip) : void
      {
         var _loc2_:Bitmap = null;
         var _loc3_:TCoordinate = null;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:TUISlot = null;
         this.FMainUI = param1;
         _loc2_ = new Bitmap(SUtilityResource.BtmDataFullScreen);
         addChild(_loc2_);
         addChild(this.FMainUI);
         this.FMainUI.x = (_loc2_.width - this.FMainUI.width) / 2;
         this.FMainUI.y = (_loc2_.height - this.FMainUI.height) / 2;
         _loc5_ = 10;
         this.FSlots = new Vector.<TUISlot>(_loc5_);
         this.FNames = new Vector.<TextField>(_loc5_);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            this.FSlots[_loc4_] = new TUISlot(this);
            this.FSlots[_loc4_].Resource = this.FMainUI["mc_slot_" + _loc4_];
            this.FSlots[_loc4_].OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
            this.FSlots[_loc4_].OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
            TJadeCommon.InitSlot(this.FSlots[_loc4_]);
            this.FSlots[_loc4_].Init();
            this.FNames[_loc4_] = new TextField();
            this.FNames[_loc4_] = this.FMainUI["mc_slot_" + _loc4_]["tf_name"];
            _loc4_++;
         }
         this.FBtn_Get = new TUIButton();
         this.FBtn_Get.Substrate = this.FMainUI.btn_get;
         this.FBtn_Get.OnClick = this.OnCloseBtnClick;
         _loc3_ = TUtilityCartisian.GetScreenCoordinateByDisplayObject(Parent);
         X -= _loc3_.X;
         Y -= _loc3_.Y;
      }
      
      public function Update(param1:TInventories) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         if(!Visible || this.FMainUI == null)
         {
            return;
         }
         _loc3_ = 10;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FSlots[_loc2_].Visible = false;
            this.FNames[_loc2_].visible = false;
            _loc2_++;
         }
         _loc3_ = uint(param1.Count);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FSlots[_loc2_].Context = param1.GetInventoryByIndex(_loc2_);
            this.FNames[_loc2_].text = param1.GetInventoryByIndex(_loc2_).Name;
            this.FSlots[_loc2_].Visible = true;
            this.FNames[_loc2_].visible = true;
            _loc2_++;
         }
      }
      
      public function show(param1:TInventories) : void
      {
         this.Visible = true;
         this.Update(param1);
         this.FMainUI.play();
      }
   }
}

