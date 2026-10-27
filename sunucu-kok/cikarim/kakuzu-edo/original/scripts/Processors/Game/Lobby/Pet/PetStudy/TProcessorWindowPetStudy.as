package Processors.Game.Lobby.Pet.PetStudy
{
   import Components.Standard.*;
   import Foundation.Resources.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.DatebaseVO.VO.*;
   import Processors.Game.Lobby.Common.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class TProcessorWindowPetStudy extends TProcessorLobbyWindow
   {
      
      protected static const CAPACITY_PETS:uint = 6;
      
      protected static const CAPACITY_WINDOWS:int = 6;
      
      protected var FBtn_Close:SimpleButton;
      
      protected var FBtn_PetHelp:SimpleButton;
      
      protected var FSP_MountPoint:Sprite;
      
      protected var FUITab:TUITab;
      
      protected var FTabIndex:int;
      
      protected var FProcessorLobbyWindows:Vector.<TProcessorLobbyWindow>;
      
      protected var FInitialization:Boolean;
      
      protected var FOnOpenPetStudy:Function;
      
      public function TProcessorWindowPetStudy(param1:TUIComponent)
      {
         super(param1);
         this.FProcessorLobbyWindows = new Vector.<TProcessorLobbyWindow>(CAPACITY_WINDOWS);
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_PET.RESOURCESID_Swf_PetStudy);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Sprite = null;
         var _loc3_:MovieClip = null;
         _loc2_ = TUtilityReflection.CreateDisplayObjectInstance(CONST_PET.RESOURCE_ClassName_MC_PetStudy) as Sprite;
         addChild(_loc2_);
         this.FBtn_Close = _loc2_[CONST_COMMON.RESOURCE_Link_Btn_Close];
         this.FBtn_PetHelp = _loc2_[CONST_COMMON.RESOURCE_Link_Btn_Help];
         this.FSP_MountPoint = _loc2_[CONST_PET.RESOURCE_Link_SP_MountPoint];
         _loc1_ = 0;
         while(_loc1_ < CAPACITY_WINDOWS)
         {
            this.FSP_MountPoint.addChild(this.FProcessorLobbyWindows[_loc1_]);
            _loc1_++;
         }
         this.FUITab = new TUITab(this);
         _loc1_ = 0;
         while(_loc1_ < CAPACITY_PETS)
         {
            _loc3_ = _loc2_[CONST_COMMON.RESOURCE_Link_MC_Tab + _loc1_];
            this.FUITab.SetTabByIndex(_loc3_,_loc1_);
            _loc1_++;
         }
         this.FUITab.OnSwitch = this.TabOnSwitch;
         this.FUITab.Init();
         _loc2_[CONST_COMMON.RESOURCE_Link_MC_Tab + 3].visible = false;
         _loc2_[CONST_COMMON.RESOURCE_Link_MC_Tab + 4].visible = false;
         _loc2_[CONST_COMMON.RESOURCE_Link_MC_Tab + 5].x = _loc2_[CONST_COMMON.RESOURCE_Link_MC_Tab + 3].x;
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         this.FBtn_Close.addEventListener(MouseEvent.CLICK,this.BtnCloseOnClick);
         this.FInitialization = true;
         super.ResourcesPerform_UILocations();
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(!this.Visible || !this.FInitialization)
         {
            return;
         }
      }
      
      protected function UpdatePetStudy() : void
      {
         var _loc1_:TConfigValue = null;
         var _loc2_:Vector.<Object> = null;
         var _loc3_:Object = null;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:Vector.<uint> = null;
         var _loc7_:uint = 0;
         _loc1_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.Vice_Pet_Limit_Num) as TConfigValue;
         _loc4_ = uint(SLogicsCore.Character.GetMainLevel());
         _loc2_ = _loc1_.Value as Vector.<Object>;
         for each(_loc3_ in _loc2_)
         {
            _loc5_ = parseInt(_loc3_.level);
            if(_loc4_ >= _loc5_)
            {
               _loc7_ = parseInt(_loc3_.num);
            }
         }
         SLogicsCore.PetData.PetStudyStoreCapacity = _loc7_;
      }
      
      protected function BtnCloseOnClick(param1:MouseEvent) : void
      {
         ProcessorWindowClose();
         TutorialNextStep(CONST_FRESHGUIDE.EVENTID_CloseSubPetWindow);
      }
      
      private function TabOnSwitch(param1:uint) : void
      {
         if(this.FOnOpenPetStudy != null)
         {
            this.FOnOpenPetStudy(this,param1,this.FTabIndex);
         }
         this.FTabIndex = param1;
         if(this.FTabIndex == CONST_PET.INDEX_WINDOW_PET_COMPOSITE)
         {
            TutorialNextStep(CONST_FRESHGUIDE.EVENTID_ClickCombineTab);
         }
         if(this.FTabIndex == CONST_PET.INDEX_WINDOW_PET_CARRY)
         {
            TutorialNextStep(CONST_FRESHGUIDE.EVENTID_ClickCarryTab);
         }
      }
      
      public function get ProcessorLobbyWindows() : Vector.<TProcessorLobbyWindow>
      {
         return this.FProcessorLobbyWindows;
      }
      
      public function SetProcessorLobbyWindowsByIndex(param1:TProcessorLobbyWindow, param2:int) : void
      {
         this.FProcessorLobbyWindows[param2] = param1;
      }
      
      public function set OnOpenPetStudy(param1:Function) : void
      {
         this.FOnOpenPetStudy = param1;
      }
      
      public function get OnOpenPetStudy() : Function
      {
         return this.FOnOpenPetStudy;
      }
      
      public function Reset() : void
      {
         if(!this.FInitialization)
         {
            return;
         }
      }
      
      public function Update() : void
      {
         this.UpdatePetStudy();
         this.TabOnSwitch(this.FTabIndex);
      }
   }
}

