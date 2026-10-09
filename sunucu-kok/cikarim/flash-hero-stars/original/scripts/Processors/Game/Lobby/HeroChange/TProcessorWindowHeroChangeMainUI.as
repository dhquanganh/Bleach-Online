package Processors.Game.Lobby.HeroChange
{
   import Components.Standard.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.Characters.*;
   import Logics.HeroChange.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.Common.*;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import Resources.Strings.*;
   import flash.display.*;
   import flash.events.*;
   
   public class TProcessorWindowHeroChangeMainUI extends TProcessorLobbyWindow
   {
      
      protected static const HeroTabNum:int = 4;
      
      protected static var FunctionTabNum:int = 2;
      
      protected static const HeroSourceID:Vector.<int> = Vector.<int>([1,2,3,4]);
      
      protected var FMainUI:Sprite;
      
      protected var FTabFunction:TUITab;
      
      protected var FTabHeros:TUITab;
      
      protected var FTabNames:Vector.<String>;
      
      protected var FProcessorWindowHeroChange:TProcessorWindowHeroChange;
      
      protected var FProcessorWindowTrainField:TProcessorWindowTrainField;
      
      protected var FProcessorWindowInheritance:TProcessorWindowInheritance;
      
      protected var FProcessorWindowSingleChange:TProcessorWindowSingleChange;
      
      protected var FProcessorWindowSingleTrain:TProcessorWindowSingleTrain;
      
      protected var FProcessorWindowMakePill:TProcessorWindowMakePill;
      
      protected var FProcessorWindowExchangePill:TProcessorWindowExchangePill;
      
      protected var FFunctionWindow:Vector.<TProcessorLobbyWindow>;
      
      protected var FCurrentSelectFunctionIndex:int;
      
      protected var FCurrentSelectHeros:THeros;
      
      protected var FLayerMask:Sprite;
      
      protected var FBtnMakePill:TUIButton;
      
      protected var FBtnClose:TUIButton;
      
      protected var FHeroChangeData:THeroChangeData;
      
      public function TProcessorWindowHeroChangeMainUI(param1:TUIComponent)
      {
         FunctionTabNum = 3;
         super(param1);
         this.FFunctionWindow = new Vector.<TProcessorLobbyWindow>();
         this.FProcessorWindowHeroChange = new TProcessorWindowHeroChange(this);
         this.FProcessorWindowHeroChange.OnJmpToHeroChange = this.ShowSingleHeroChange;
         this.FProcessorWindowHeroChange.OnJmpToHeroTrain = this.OpenSingleTrain;
         this.FProcessorWindowHeroChange.OnClose = this.BtnCloseOnClick;
         this.FProcessorWindowTrainField = new TProcessorWindowTrainField(this);
         this.FProcessorWindowTrainField.OnIntoSingleTrain = this.OpenSingleTrain;
         this.FFunctionWindow.push(this.FProcessorWindowHeroChange);
         this.FFunctionWindow.push(this.FProcessorWindowTrainField);
         this.FLayerMask = new Sprite();
         addChild(this.FLayerMask);
         this.FLayerMask.visible = false;
         this.FProcessorWindowSingleChange = new TProcessorWindowSingleChange(this);
         this.FProcessorWindowSingleChange.OnMakePill = this.OpenMakePillWindow;
         this.FProcessorWindowSingleChange.OnClose = this.CancleMouseLock;
         this.FProcessorWindowSingleTrain = new TProcessorWindowSingleTrain(this);
         this.FProcessorWindowSingleTrain.OnClose = this.CancleMouseLock;
         this.FProcessorWindowMakePill = new TProcessorWindowMakePill(this);
         this.FProcessorWindowMakePill.OnExchagne = this.OpenExchangePillWindow;
         this.FProcessorWindowMakePill.OnClose = this.CancleMouseLock;
         this.FProcessorWindowExchangePill = new TProcessorWindowExchangePill(this);
         this.FProcessorWindowExchangePill.OnClose = this.CancleMouseLock;
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Sprite = null;
         this.FMainUI = TUtilityReflection.CreateDisplayObjectInstance("HeroChangeMainUI") as Sprite;
         addChildAt(this.FMainUI,0);
         this.FMainUI.alpha = 1;
         this.FTabNames = TUtilityLobby.GetStringsByIdentifier(CONST_SYSTEMLANGUAGE.STRING_HeroChange_12);
         _loc2_ = this.FMainUI["MainBoard"];
         this.FTabFunction = new TUITab(this);
         _loc1_ = 0;
         while(_loc1_ < FunctionTabNum)
         {
            this.FTabFunction.SetTabByIndex(_loc2_["MC_Tab_" + _loc1_],_loc1_);
            _loc1_++;
         }
         this.FTabFunction.OnSwitch = this.FunctionTabOnSwitch;
         this.FTabFunction.Init();
         this.FTabHeros = new TUITab(this);
         _loc1_ = 0;
         while(_loc1_ < HeroTabNum)
         {
            this.FTabHeros.SetTabByIndex(_loc2_["HeroTab" + _loc1_],_loc1_);
            this.FTabHeros.SetTabCaptionByIndex(this.FTabNames[_loc1_],_loc1_);
            _loc1_++;
         }
         this.FTabHeros.OnSwitch = this.HeroTabOnSwitch;
         this.FTabHeros.Init();
         this.FProcessorWindowHeroChange.UIDispatch(this.FMainUI["ChangeUI"]);
         this.FProcessorWindowHeroChange.UILocation();
         this.FProcessorWindowTrainField.UIDispatch(this.FMainUI["HeroTrain"]);
         this.FProcessorWindowTrainField.UILocation();
         this.FMainUI["InheritanceUI"].visible = false;
         _loc2_["MC_Tab_2"].visible = false;
         this.FProcessorWindowSingleChange.UIDispatch();
         this.FProcessorWindowSingleChange.UILocation();
         addChild(this.FProcessorWindowSingleChange);
         this.FProcessorWindowSingleChange.x = (this.FMainUI.width - this.FProcessorWindowSingleChange.width) / 2;
         this.FProcessorWindowSingleChange.y = (this.FMainUI.height - this.FProcessorWindowSingleChange.height) / 2;
         this.FProcessorWindowSingleTrain.UIDispatch();
         this.FProcessorWindowSingleTrain.UILocation();
         addChild(this.FProcessorWindowSingleTrain);
         this.FProcessorWindowSingleTrain.x = (this.FMainUI.width - this.FProcessorWindowSingleTrain.width) / 2;
         this.FProcessorWindowSingleTrain.y = (this.FMainUI.height - this.FProcessorWindowSingleTrain.height) / 2;
         this.FProcessorWindowMakePill.UIDispatch();
         this.FProcessorWindowMakePill.UILocation();
         addChild(this.FProcessorWindowMakePill);
         this.FProcessorWindowMakePill.x = (this.FMainUI.width - this.FProcessorWindowMakePill.width) / 2;
         this.FProcessorWindowMakePill.y = (this.FMainUI.height - this.FProcessorWindowMakePill.height) / 2;
         this.FProcessorWindowExchangePill.UIDispatch();
         this.FProcessorWindowExchangePill.UILocation();
         addChild(this.FProcessorWindowExchangePill);
         this.FProcessorWindowExchangePill.x = (this.FMainUI.width - this.FProcessorWindowExchangePill.width) / 2;
         this.FProcessorWindowExchangePill.y = (this.FMainUI.height - this.FProcessorWindowExchangePill.height) / 2;
         this.FBtnClose = new TUIButton();
         this.FBtnClose.Substrate = _loc2_["Close"];
         this.FBtnClose.OnClick = this.BtnCloseOnClick;
         this.FBtnMakePill = new TUIButton();
         this.FBtnMakePill.Substrate = this.FMainUI["MakePill"];
         this.FBtnMakePill.OnClick = this.BtnMakePillOnClick;
         this.FLayerMask.addChild(new Bitmap(SUtilityResource.BtmDataFullScreen));
         this.FLayerMask.x = -x;
         this.FLayerMask.y = -y;
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         super.ResourcesPerform_UILocations();
      }
      
      protected function ResetHeroTab() : void
      {
         this.FTabHeros.SwithTagManual(0);
      }
      
      protected function HeroTabOnSwitch(param1:int) : void
      {
         var _loc2_:* = undefined;
         _loc2_ = this.FFunctionWindow[this.FCurrentSelectFunctionIndex];
         _loc2_.ChangeHeroList(this.FHeroChangeData.AllHeroRegistry.GetInstanceByIdentifier(HeroSourceID[param1]),param1);
      }
      
      protected function FunctionTabOnSwitch(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         _loc3_ = int(this.FFunctionWindow.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FFunctionWindow[_loc2_].Visible = false;
            _loc2_++;
         }
         this.FFunctionWindow[param1].Visible = true;
         this.FCurrentSelectFunctionIndex = param1;
         this.ResetHeroTab();
      }
      
      protected function ShowSingleHeroChange(param1:Vector.<THeroChange>, param2:int) : void
      {
         this.FLayerMask.visible = true;
         this.FProcessorWindowSingleChange.Show(param1,param2);
      }
      
      protected function OpenMakePillWindow(param1:Object) : void
      {
         this.FLayerMask.visible = true;
         this.FProcessorWindowMakePill.Show();
      }
      
      protected function CancleMouseLock(param1:Object) : void
      {
         this.FLayerMask.visible = false;
      }
      
      protected function OpenExchangePillWindow(param1:Object) : void
      {
         this.FLayerMask.visible = true;
         this.FProcessorWindowExchangePill.Show();
      }
      
      protected function OpenSingleTrain(param1:Object) : void
      {
         this.FLayerMask.visible = true;
         this.FProcessorWindowSingleTrain.Show(param1 as THeroChange);
      }
      
      protected function BtnCloseOnClick(param1:Object, param2:MouseEvent = null) : void
      {
         ProcessorWindowClose();
      }
      
      protected function BtnMakePillOnClick(param1:Object, param2:MouseEvent) : void
      {
         this.OpenMakePillWindow(param1);
      }
      
      public function set HeroChangeData(param1:THeroChangeData) : void
      {
         this.FHeroChangeData = param1;
         this.FProcessorWindowHeroChange.HeroChangeData = param1;
         this.FProcessorWindowSingleChange.HeroChangeData = param1;
         this.FProcessorWindowMakePill.HeroChangeData = param1;
         this.FProcessorWindowExchangePill.HeroChangeData = param1;
         this.FProcessorWindowTrainField.HeroChangeData = param1;
         this.FProcessorWindowSingleTrain.HeroChangeData = param1;
      }
      
      public function Show() : void
      {
         Visible = true;
         this.FTabFunction.SwithTagManual(0);
         if(this.FProcessorWindowSingleTrain.Visible)
         {
            this.FProcessorWindowSingleTrain.FightNotify();
         }
      }
      
      public function ChangeNotify() : void
      {
         this.FProcessorWindowHeroChange.ChangeNotify();
         this.FProcessorWindowSingleChange.ChangeNotify();
      }
      
      public function MakePillNotify() : void
      {
         this.FProcessorWindowMakePill.MakePillNotify();
         this.FProcessorWindowHeroChange.MakePillNotify();
      }
      
      public function ExchangePillNotify() : void
      {
         this.FProcessorWindowExchangePill.ExchangePillNotify();
      }
      
      public function CommonMaterialUpdateNotify() : void
      {
         if(this.FProcessorWindowHeroChange.Visible)
         {
            this.FProcessorWindowHeroChange.CommonMaterialUpdateNotify();
         }
      }
      
      public function GradeMaterialUpdateNotify() : void
      {
         if(this.FProcessorWindowSingleTrain.Visible)
         {
            this.FProcessorWindowSingleTrain.GradeMaterialUpdateNotify();
         }
         if(this.FProcessorWindowTrainField.Visible)
         {
            this.FProcessorWindowTrainField.GradeMaterialUpdateNotify();
         }
      }
      
      public function BuyTimeNotify() : void
      {
         this.FProcessorWindowTrainField.BuyTimeNotify();
      }
      
      public function FightNotify() : void
      {
         if(this.FProcessorWindowTrainField.Visible)
         {
            this.FProcessorWindowTrainField.FightNotify();
         }
         if(this.FProcessorWindowSingleTrain)
         {
            this.FProcessorWindowSingleTrain.FightNotify();
         }
      }
      
      public function OneKeyFightNotify() : void
      {
         this.FProcessorWindowSingleTrain.OneKeyFightNotify();
         if(this.FProcessorWindowTrainField.Visible)
         {
            this.FProcessorWindowTrainField.FightNotify();
         }
      }
      
      public function ReliveNotify() : void
      {
         this.FProcessorWindowSingleTrain.ReliveNotify();
      }
   }
}

