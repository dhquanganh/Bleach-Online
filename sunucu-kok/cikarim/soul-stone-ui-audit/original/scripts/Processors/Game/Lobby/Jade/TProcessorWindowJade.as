package Processors.Game.Lobby.Jade
{
   import Components.Standard.*;
   import Foundation.Common.THint;
   import Foundation.Registries.*;
   import Foundation.Resources.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Resources.Constants.*;
   import Resources.Strings.*;
   import flash.display.*;
   import flash.events.*;
   
   public class TProcessorWindowJade extends TProcessorLobbyWindow
   {
      
      protected static const TabMosaicIndex:int = 0;
      
      protected static const TabCombineIndex:int = 1;
      
      protected var FHelpTips:THint;
      
      protected var FScene:MovieClip;
      
      protected var FMosaicScene:TJadeMosaic;
      
      protected var FCombineScene:TJadeCombin;
      
      protected var FBTN_Close:SimpleButton;
      
      protected var FBtn_Help:SimpleButton;
      
      protected var FCurrentTabIndex:int;
      
      protected var FUITab:TUITab;
      
      protected var FTextRegistry:TRegistryInstance;
      
      protected var FMC_PendantLeft:MovieClip;
      
      protected var FMC_PendantRight:MovieClip;
      
      protected var FOnInventoryOver:Function;
      
      protected var FOnInventoryOut:Function;
      
      protected var FOnHelpTipsOver:Function;
      
      protected var FOnHelpTipsOut:Function;
      
      protected var FOnUpdatePower:Function;
      
      public function TProcessorWindowJade(param1:TUIComponent)
      {
         super(param1);
         this.FHelpTips = new THint();
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_JADE.RESOURCESID_JADE);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         this.FScene = TUtilityReflection.CreateDisplayObjectInstance(CONST_JADE.RESOURCE_ClassName_JADE) as MovieClip;
         addChild(this.FScene);
         this.FMosaicScene = new TJadeMosaic(this);
         this.FMosaicScene.OnInventoryOver = this.ProcessorInventoryOnOver;
         this.FMosaicScene.OnInventoryOut = this.ProcessorInventoryOnOut;
         this.FMosaicScene.FlyText = this.FlyText;
         this.FCombineScene = new TJadeCombin(this);
         this.FCombineScene.OnInventoryOver = this.ProcessorInventoryOnOver;
         this.FCombineScene.OnInventoryOut = this.ProcessorInventoryOnOut;
         this.FCombineScene.FlyText = this.FlyText;
         this.FMosaicScene.Perform_UIDispatch(this.FScene["MC_MosaicView"]);
         this.FMosaicScene.visible = false;
         this.FMosaicScene.UpdateHeroPower = this.UpdatePower;
         this.FScene.gotoAndStop("combine");
         this.FCombineScene.Perform_UIDispatch(this.FScene["MC_CombineView"]);
         this.FCombineScene.visible = false;
         this.FBTN_Close = this.FScene["btn_close"];
         this.FBtn_Help = this.FScene["btn_help"];
         this.FUITab = new TUITab(this);
         _loc2_ = 2;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FUITab.SetTabByIndex(this.FScene[CONST_JADE.JadeBtn[_loc1_]],_loc1_);
            _loc1_++;
         }
         this.FUITab.OnSwitch = this.SwitchTab;
         this.FUITab.Init();
         this.FMosaicScene.OnEffectText = FOnEffectText;
         this.FCombineScene.OnEffectText = FOnEffectText;
         this.FMC_PendantLeft = this.FScene["MC_PendantLeft"];
         this.FMC_PendantRight = this.FScene["MC_PendantRight"];
         TutorialSendArrowParent(CONST_FRESHGUIDE.MCID_JadeView,this.parent);
         TutorialSendComponent(CONST_FRESHGUIDE.MCID_JadeView,this.FScene);
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         this.FScene.btn_close.addEventListener(MouseEvent.CLICK,this.OnCloseWindow);
         this.FBTN_Close.addEventListener(MouseEvent.CLICK,this.OnCloseWindow);
         this.FBtn_Help.addEventListener(MouseEvent.MOUSE_MOVE,this.ButtonHelpOnOver,false,0,true);
         this.FBtn_Help.addEventListener(MouseEvent.MOUSE_OUT,this.ButtonHelpOnOut,false,0,true);
         this.FMosaicScene.Perform_UILocation();
         this.FCombineScene.Perform_UILocation();
         this.Perform_Reset();
         super.ResourcesPerform_UILocations();
      }
      
      protected function ProcessorInventoryOnOver(param1:Object, param2:Object) : void
      {
         if(this.FOnInventoryOver != null)
         {
            this.FOnInventoryOver(param1,param2);
         }
      }
      
      protected function ProcessorInventoryOnOut(param1:Object, param2:Object) : void
      {
         if(this.FOnInventoryOut != null)
         {
            this.FOnInventoryOut(param1,param2);
         }
      }
      
      protected function SwitchTab(param1:Object) : void
      {
         this.FCombineScene.Reset();
         if(param1 is int)
         {
            this.FCurrentTabIndex = param1 as int;
            switch(this.FCurrentTabIndex)
            {
               case 0:
                  this.FCurrentTabIndex = TabMosaicIndex;
                  this.Update();
                  this.FMosaicScene.visible = true;
                  this.FCombineScene.visible = false;
                  break;
               case 1:
                  this.FCurrentTabIndex = TabCombineIndex;
                  this.Update();
                  this.FMosaicScene.visible = false;
                  this.FCombineScene.visible = true;
            }
         }
      }
      
      protected function StopPendant() : void
      {
         this.FMC_PendantLeft.gotoAndStop(1);
         this.FMC_PendantRight.gotoAndStop(1);
      }
      
      protected function Perform_Reset() : void
      {
         this.FUITab.SwithTagManual(0);
         this.SwitchTab(0);
      }
      
      protected function FlyText(param1:int) : void
      {
         var _loc2_:String = null;
         _loc2_ = TUtilityLobby.GetStringByIdentifier(param1);
         EffectGenerateText(_loc2_);
      }
      
      protected function OnCloseWindow(param1:MouseEvent) : void
      {
         ProcessorWindowClose();
         this.Reset();
      }
      
      protected function ButtonHelpOnOver(param1:MouseEvent) : void
      {
         if(this.FOnHelpTipsOver != null)
         {
            this.FHelpTips.Content = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HELPTIPS_Jade);
            this.FOnHelpTipsOver(this,this.FHelpTips);
         }
      }
      
      protected function ButtonHelpOnOut(param1:MouseEvent) : void
      {
         if(this.FOnHelpTipsOut != null)
         {
            this.FOnHelpTipsOut(this,this.FHelpTips);
         }
      }
      
      protected function UpdatePower(param1:Object, param2:uint) : void
      {
         if(this.FOnUpdatePower != null)
         {
            this.FOnUpdatePower(param1,param2);
         }
      }
      
      public function set OnInventoryOver(param1:Function) : void
      {
         this.FOnInventoryOver = param1;
      }
      
      public function set OnInventoryOut(param1:Function) : void
      {
         this.FOnInventoryOut = param1;
      }
      
      public function get OnHelpTipsOver() : Function
      {
         return this.FOnHelpTipsOver;
      }
      
      public function set OnHelpTipsOver(param1:Function) : void
      {
         this.FOnHelpTipsOver = param1;
      }
      
      public function get OnHelpTipsOut() : Function
      {
         return this.FOnHelpTipsOut;
      }
      
      public function set OnHelpTipsOut(param1:Function) : void
      {
         this.FOnHelpTipsOut = param1;
      }
      
      public function set OnMountJade(param1:Function) : void
      {
         this.FMosaicScene.OnMountJade = param1;
      }
      
      public function set OnUnmountJade(param1:Function) : void
      {
         this.FMosaicScene.OnUnmountJade = param1;
      }
      
      public function set OnCombine(param1:Function) : void
      {
         this.FCombineScene.OnCombine = param1;
      }
      
      public function set ResultCode(param1:uint) : void
      {
         switch(this.FCurrentTabIndex)
         {
            case TabMosaicIndex:
               this.FMosaicScene.ResultCode = param1;
               break;
            case TabCombineIndex:
               this.FCombineScene.ResultCode = param1;
         }
      }
      
      override public function set OnEffectText(param1:Function) : void
      {
         FOnEffectText = param1;
      }
      
      public function set UpdateHeroPower(param1:Function) : void
      {
         this.FOnUpdatePower = param1;
      }
      
      public function Update() : void
      {
         switch(this.FCurrentTabIndex)
         {
            case TabMosaicIndex:
               this.FMosaicScene.Update();
               break;
            case TabCombineIndex:
               this.FCombineScene.Update();
         }
      }
      
      public function Reset() : void
      {
         this.Perform_Reset();
         this.FMosaicScene.Reset();
         this.FCombineScene.Reset();
      }
      
      public function ShackPendant() : void
      {
         this.FMC_PendantLeft.gotoAndPlay(1);
         this.FMC_PendantRight.gotoAndPlay(1);
      }
   }
}

