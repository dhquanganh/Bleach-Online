package Processors.Game.Lobby.Activity.HDNewYearDay.components
{
   import Components.Pages.TUIPage;
   import Components.Slots.TUISlot;
   import Components.Standard.TUIButton;
   import Foundation.Common.TCoordinate;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityCartisian;
   import Logics.HDNewYear.THDNewYearLuckEggData;
   import Logics.Inventories.TInventories;
   import Processors.Game.Lobby.Jade.TJadeCommon;
   import Processors.Game.Utilities.Common.SUtilityResource;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class TNewYearLuckEggRewardCom extends TUIComponent
   {
      
      protected const EachPage_Count:uint = 20;
      
      protected var FPage:TUIPage;
      
      protected var FSlots:Vector.<TUISlot>;
      
      protected var FMainUI:MovieClip;
      
      protected var FData:THDNewYearLuckEggData;
      
      protected var FCloseBtn:TUIButton;
      
      protected var FCurPage:uint;
      
      protected var FInventories:TInventories;
      
      protected var FLastIndex:int;
      
      protected var FMask:Sprite;
      
      public function TNewYearLuckEggRewardCom(param1:TUIComponent)
      {
         super(param1);
      }
      
      protected function GetGlobalIndexByLocalIndex(param1:uint) : uint
      {
         return this.FCurPage * this.EachPage_Count + param1;
      }
      
      protected function UpdatePage() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:TUISlot = null;
         var _loc3_:uint = 0;
         _loc1_ = 0;
         while(_loc1_ < this.EachPage_Count)
         {
            _loc2_ = this.FSlots[_loc1_];
            _loc3_ = this.GetGlobalIndexByLocalIndex(_loc1_);
            if(_loc3_ <= this.FInventories.Count - 1)
            {
               _loc2_.Visible = true;
               _loc2_.Context = this.FInventories.GetInventoryByIndex(_loc3_);
            }
            else
            {
               _loc2_.Visible = false;
            }
            _loc1_++;
         }
      }
      
      protected function PageOnSwitch(param1:Object, param2:int) : void
      {
         this.FCurPage = param2;
         this.UpdatePage();
      }
      
      protected function OnClose(param1:Object, param2:MouseEvent) : void
      {
         this.Visible = false;
      }
      
      public function UIDispatch(param1:MovieClip) : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:TUISlot = null;
         var _loc4_:uint = 0;
         var _loc5_:TCoordinate = null;
         this.FMainUI = param1;
         this.FMask = new Sprite();
         addChild(this.FMask);
         addChild(this.FMainUI);
         _loc2_ = this.FMainUI["MC_Page"];
         this.FPage = new TUIPage(this);
         this.FPage.ButtonNext.Substrate = _loc2_["MC_PageRight"];
         this.FPage.ButtonPrevious.Substrate = _loc2_["MC_PageLeft"];
         this.FPage.LabelPage = _loc2_["TF_Page"];
         this.FPage.PageSize = this.EachPage_Count;
         this.FPage.OnChangePage = this.PageOnSwitch;
         this.FPage.Init();
         this.FCloseBtn = new TUIButton();
         this.FCloseBtn.Substrate = this.FMainUI["Btn_Close"];
         this.FCloseBtn.OnClick = this.OnClose;
         this.FSlots = new Vector.<TUISlot>(this.EachPage_Count);
         _loc4_ = 0;
         while(_loc4_ < this.EachPage_Count)
         {
            _loc3_ = new TUISlot(this);
            _loc3_.Resource = this.FMainUI["Slot_" + _loc4_];
            _loc3_.OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
            _loc3_.OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
            TJadeCommon.InitSlot(_loc3_);
            _loc3_.Init();
            this.FSlots[_loc4_] = _loc3_;
            _loc4_++;
         }
         this.FMask.addChild(new Bitmap(SUtilityResource.BtmDataFullScreen));
         _loc5_ = TUtilityCartisian.GetScreenCoordinateByDisplayObject(this);
         this.FMask.x = -_loc5_.X;
         this.FMask.y = -_loc5_.Y;
      }
      
      public function Show(param1:THDNewYearLuckEggData, param2:uint) : void
      {
         if(Visible && this.FLastIndex == param2)
         {
            return;
         }
         this.FData = param1;
         this.FInventories = this.FData.Eggs[param2].Inventories;
         this.FCurPage = 0;
         this.FPage.SetupPage(this.FInventories.Count,this.FCurPage);
         this.UpdatePage();
         this.Visible = true;
         this.FLastIndex = param2;
      }
      
      public function LogicsPerform() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:TUISlot = null;
         if(!Visible)
         {
            return;
         }
         _loc1_ = 0;
         while(_loc1_ < this.EachPage_Count)
         {
            _loc2_ = this.FSlots[_loc1_];
            if(_loc2_.Visible)
            {
               _loc2_.Update();
            }
            _loc1_++;
         }
      }
      
      override public function set Visible(param1:Boolean) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:TUISlot = null;
         super.Visible = param1;
         if(!param1 && this.FSlots != null)
         {
            _loc2_ = 0;
            while(_loc2_ < this.EachPage_Count)
            {
               _loc3_ = this.FSlots[_loc2_];
               _loc3_.Context = null;
               _loc2_++;
            }
         }
      }
   }
}

