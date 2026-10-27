package Processors.Game.Lobby.FBBuyGold
{
   import Components.SelectBox.TSelectBoxSingle;
   import Components.Standard.TUIButton;
   import Externals.SExternalCore;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class TProcessorWindowBuyGold extends TProcessorLobbyWindow
   {
      
      protected static const SelectButtonNum:int = 8;
      
      protected static const GoldNumVec:Vector.<int> = Vector.<int>([200,400,800,2000,4000,8000,20000,40000]);
      
      protected var FMainUI:Sprite;
      
      protected var FButtons:Vector.<MovieClip>;
      
      protected var FButtonOK:TUIButton;
      
      protected var FButtonClose:TUIButton;
      
      protected var FSelectBoxSingle:TSelectBoxSingle;
      
      protected var FCurrentSelectIndex:int;
      
      public function TProcessorWindowBuyGold(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:int = 0;
         this.FMainUI = TUtilityReflection.CreateDisplayObjectInstance("FBExchangeGold") as Sprite;
         addChild(this.FMainUI);
         this.FSelectBoxSingle = new TSelectBoxSingle();
         _loc1_ = 0;
         while(_loc1_ < SelectButtonNum)
         {
            this.FSelectBoxSingle.SetTaskByIndex(_loc1_,this.FMainUI["MC_" + _loc1_]["MC_Button"]);
            _loc1_++;
         }
         this.FSelectBoxSingle.CallBackOnSelect = this.OnSelectIndex;
         this.FSelectBoxSingle.Init();
         this.FButtonOK = new TUIButton();
         this.FButtonOK.Substrate = this.FMainUI["Btn_OK"];
         this.FButtonOK.OnClick = this.BtnOKOnClick;
         this.FButtonClose = new TUIButton();
         this.FButtonClose.Substrate = this.FMainUI["btn_close"];
         this.FButtonClose.OnClick = this.BtnCloseOnClick;
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         super.ResourcesPerform_UILocations();
      }
      
      protected function BtnOKOnClick(param1:Object, param2:MouseEvent) : void
      {
         SExternalCore.FBBuyGoldRequest(GoldNumVec[this.FCurrentSelectIndex]);
      }
      
      protected function OnSelectIndex(param1:Object, param2:int) : void
      {
         this.FCurrentSelectIndex = param2;
      }
      
      protected function BtnCloseOnClick(param1:Object, param2:MouseEvent) : void
      {
         this.FSelectBoxSingle.UnselectAll();
         this.FSelectBoxSingle.SetSelectByIndex(0);
         this.FCurrentSelectIndex = 0;
         ProcessorWindowClose();
      }
   }
}

