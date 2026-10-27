package Processors.Game.Lobby.ShinobidoPractise
{
   import Components.Standard.*;
   import Foundation.Resources.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.Unlocks.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Utilities.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class TProcessorWindowShinobidoPractise extends TProcessorLobbyWindow
   {
      
      protected static const CAPACITY_TABS:uint = 3;
      
      protected static const CAPACITY_ITEMS:uint = 4;
      
      protected static const RESOURCE_Link_Vector:Vector.<String> = CONST_SHINOBIDOPRACTISE.RESOURCE_Link_Vector;
      
      protected static const POPTIP_Gotos:Vector.<uint> = CONST_SHINOBIDOPRACTISE.POPTIP_Gotos;
      
      protected static const POPTIP_FUNCTION_POSITION:Vector.<Array> = CONST_SHINOBIDOPRACTISE.POPTIP_FUNCTION_POSITION;
      
      protected static const NAME_NUM:uint = 11;
      
      protected var FMC_FightingPower:Sprite;
      
      protected var FMC_PageLeft:TUIButton;
      
      protected var FMC_PageRight:TUIButton;
      
      protected var FBtn_Help:SimpleButton;
      
      protected var FBtn_Close:SimpleButton;
      
      protected var FTF_FightingPower:TextField;
      
      protected var FTF_Tittle:TextField;
      
      protected var FBTN_FightingPowerRankings:TUIButton;
      
      protected var FUITab:TUITab;
      
      protected var FMCVec:Vector.<MovieClip>;
      
      protected var FMCModules:Vector.<MovieClip>;
      
      protected var FBtnModules:Vector.<TUIButton>;
      
      protected var FResource_Links:Vector.<Vector.<String>>;
      
      protected var FTabIndex:int;
      
      protected var FPageIndex:int;
      
      protected var FTitleVec:Vector.<String>;
      
      protected var FNameVec:Vector.<String>;
      
      protected var FOnOpenFightingCapacityRank:Function;
      
      protected var FOnHelpTipsOver:Function;
      
      protected var FOnHelpTipsOut:Function;
      
      protected var FOnGoto:Function;
      
      public function TProcessorWindowShinobidoPractise(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_SHINOBIDOPRACTISE.RESOURCESID_Swf_ShinobidoPractise);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:int = 0;
         var _loc2_:uint = 0;
         var _loc3_:MovieClip = null;
         var _loc4_:TUIButton = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         this.FMC_FightingPower = TUtilityReflection.CreateDisplayObjectInstance(CONST_SHINOBIDOPRACTISE.RESOURCE_ClassName_MC_ShinobidoPractise) as Sprite;
         addChild(this.FMC_FightingPower);
         this.FBtn_Help = this.FMC_FightingPower[CONST_COMMON.RESOURCE_Link_Btn_Help];
         this.FBtn_Close = this.FMC_FightingPower[CONST_COMMON.RESOURCE_Link_Btn_Close];
         this.FTF_FightingPower = this.FMC_FightingPower[CONST_SHINOBIDOPRACTISE.RESOURCE_Link_TF_FightingPower];
         this.FTF_Tittle = this.FMC_FightingPower[CONST_SHINOBIDOPRACTISE.RESOURCE_Link_TF_Tittle];
         this.FBTN_FightingPowerRankings = new TUIButton();
         this.FBTN_FightingPowerRankings.Substrate = this.FMC_FightingPower[CONST_SHINOBIDOPRACTISE.RESOURCE_Link_BTN_FightingPowerRankings];
         this.FBTN_FightingPowerRankings.OnClick = this.ButtonRankOnClick;
         this.FMC_PageLeft = new TUIButton();
         this.FMC_PageLeft.Substrate = this.FMC_FightingPower[CONST_SHINOBIDOPRACTISE.RESOURCE_Link_MC_PageLeft];
         this.FMC_PageLeft.OnClick = this.ButtonOnPageLeft;
         this.FMC_PageRight = new TUIButton();
         this.FMC_PageRight.Substrate = this.FMC_FightingPower[CONST_SHINOBIDOPRACTISE.RESOURCE_Link_MC_PageRight];
         this.FMC_PageRight.OnClick = this.ButtonOnPageRight;
         this.FResource_Links = new Vector.<Vector.<String>>();
         this.FResource_Links.push(CONST_SHINOBIDOPRACTISE.RESOURCE_Link_MakeStrong,CONST_SHINOBIDOPRACTISE.RESOURCE_Link_MakeMoney,CONST_SHINOBIDOPRACTISE.RESOURCE_Link_LevelUp);
         this.FUITab = new TUITab(this);
         _loc2_ = CAPACITY_TABS;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FUITab.SetTabByIndex(this.FMC_FightingPower[CONST_COMMON.RESOURCE_Link_MC_Tab + _loc1_],_loc1_);
            _loc1_++;
         }
         this.FUITab.OnSwitch = this.TabOnSwitch;
         this.FUITab.Init();
         this.FMCVec = new Vector.<MovieClip>();
         this.FMCVec.push(this.FMC_FightingPower["MC_Items"]["MC_MakeStrong"]);
         this.FMCVec.push(this.FMC_FightingPower["MC_Items"]["MC_MakeMoney"]);
         this.FMCVec.push(this.FMC_FightingPower["MC_Items"]["MC_LevelUp"]);
         this.FMCModules = new Vector.<MovieClip>(CAPACITY_ITEMS);
         this.FBtnModules = new Vector.<TUIButton>();
         _loc2_ = this.FMCVec.length;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc6_ = CAPACITY_ITEMS;
            _loc5_ = 0;
            while(_loc5_ < _loc6_)
            {
               this.FMCModules[_loc5_] = this.FMCVec[_loc1_][CONST_SHINOBIDOPRACTISE.RESOURCE_Link_MC_Item + _loc5_];
               _loc4_ = new TUIButton();
               _loc4_.Substrate = this.FMCModules[_loc5_]["mc_bt"];
               _loc4_.OnClick = this.ButtonOnGoto;
               this.FBtnModules.push(_loc4_);
               _loc5_++;
            }
            _loc1_++;
         }
         this.FTitleVec = new Vector.<String>(CAPACITY_TABS);
         this.FTitleVec = TUtilityLobby.GetStringsByIdentifier(CONST_SYSTEMLANGUAGE.SHINOBIDOPRACTISE_STRING_01);
         this.FNameVec = new Vector.<String>(NAME_NUM);
         this.FNameVec = TUtilityLobby.GetStringsByIdentifier(CONST_SYSTEMLANGUAGE.SHINOBIDOPRACTISE_STRING_02);
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         this.FBtn_Close.addEventListener(MouseEvent.CLICK,this.ButtonCloseOnClick,false,0,true);
         this.FBtn_Help.addEventListener(MouseEvent.MOUSE_MOVE,this.ButtonHelpOnOver,false,0,true);
         this.FBtn_Help.addEventListener(MouseEvent.MOUSE_OUT,this.ButtonHelpOnOut,false,0,true);
         super.ResourcesPerform_UILocations();
      }
      
      protected function UpdateMCUI() : void
      {
         var _loc1_:int = 0;
         var _loc2_:uint = 0;
         var _loc3_:MovieClip = null;
         var _loc4_:MovieClip = null;
         var _loc5_:int = 0;
         _loc2_ = this.FMCVec.length;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            if(_loc1_ == this.FTabIndex)
            {
               this.FMCVec[_loc1_].visible = true;
            }
            else
            {
               this.FMCVec[_loc1_].visible = false;
            }
            _loc1_++;
         }
         _loc2_ = this.FMCModules.length;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FMCModules[_loc1_] = this.FMCVec[this.FTabIndex][CONST_SHINOBIDOPRACTISE.RESOURCE_Link_MC_Item + _loc1_];
            if(this.FPageIndex * CAPACITY_ITEMS + _loc1_ >= this.FResource_Links[this.FTabIndex].length)
            {
               this.FMCModules[_loc1_].visible = false;
            }
            else
            {
               this.FMCModules[_loc1_]["mc_bg"].gotoAndStop(this.FResource_Links[this.FTabIndex][this.FPageIndex * CAPACITY_ITEMS + _loc1_]);
               this.FMCModules[_loc1_].visible = true;
               _loc5_ = 0;
               while(_loc5_ < RESOURCE_Link_Vector.length)
               {
                  if(RESOURCE_Link_Vector[_loc5_] == this.FMCModules[_loc1_]["mc_bg"].currentFrameLabel)
                  {
                     this.FMCModules[_loc1_]["mc_bt"].tf_bt.text = this.FNameVec[_loc5_];
                     if(this.VerificationLocaltionOperatingByPosition(POPTIP_FUNCTION_POSITION[_loc5_][0],POPTIP_FUNCTION_POSITION[_loc5_][1]))
                     {
                        this.FMCModules[_loc1_]["mc_bt"].mouseEnabled = true;
                        this.FMCModules[_loc1_].filters = [];
                     }
                     else
                     {
                        this.FMCModules[_loc1_]["mc_bt"].mouseEnabled = false;
                        this.FMCModules[_loc1_].filters = [TUtilityFilter.gBlackFilters];
                     }
                  }
                  _loc5_++;
               }
            }
            _loc1_++;
         }
      }
      
      protected function VerificationLocaltionOperatingByPosition(param1:uint, param2:uint) : Boolean
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:TUnlock = null;
         var _loc6_:TUnlocks = null;
         var _loc7_:Boolean = false;
         _loc7_ = false;
         _loc6_ = SLogicsCore.Unlocks;
         _loc4_ = _loc6_.Count;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc5_ = _loc6_.GetUnlockByIndex(_loc3_);
            if(param1 == _loc5_.Position && param2 == _loc5_.Index)
            {
               if(_loc5_.State == TUnlock.UNLOCKSTATE_Unlocked)
               {
                  _loc7_ = true;
                  break;
               }
            }
            _loc3_++;
         }
         return _loc7_;
      }
      
      protected function UpdatePageInfo() : void
      {
         var _loc1_:uint = 0;
         _loc1_ = Math.floor(this.FResource_Links[this.FTabIndex].length / CAPACITY_ITEMS);
         if(this.FResource_Links[this.FTabIndex].length < CAPACITY_ITEMS)
         {
            this.SetBTNPageState(false,false);
         }
         else if(this.FPageIndex > 0 && this.FPageIndex < _loc1_)
         {
            this.SetBTNPageState(true,true);
         }
         else if(this.FPageIndex == _loc1_)
         {
            this.SetBTNPageState(true,false);
         }
         else if(this.FPageIndex == 0)
         {
            this.SetBTNPageState(false,true);
         }
      }
      
      protected function SetBTNPageState(param1:Boolean, param2:Boolean) : void
      {
         this.FMC_PageLeft.Enabled = param1;
         this.FMC_PageRight.Enabled = param2;
      }
      
      protected function UpdateTextFieldInfo() : void
      {
         this.FTF_Tittle.text = this.FTitleVec[this.FTabIndex];
         this.FTF_FightingPower.text = SLogicsCore.Character.GetFightingPower().toString();
      }
      
      protected function ButtonCloseOnClick(param1:MouseEvent) : void
      {
         ProcessorWindowClose();
      }
      
      protected function ButtonOnGoto(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:uint = 0;
         var _loc5_:String = null;
         _loc5_ = param2.currentTarget.parent.mc_bg.currentFrameLabel;
         _loc4_ = RESOURCE_Link_Vector.length;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            if(_loc5_ == RESOURCE_Link_Vector[_loc3_])
            {
               if(this.FOnGoto != null)
               {
                  this.FOnGoto(this,POPTIP_Gotos[_loc3_]);
               }
            }
            _loc3_++;
         }
      }
      
      protected function ButtonHelpOnOver(param1:MouseEvent) : void
      {
      }
      
      protected function ButtonHelpOnOut(param1:MouseEvent) : void
      {
      }
      
      protected function ButtonRankOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FOnOpenFightingCapacityRank != null)
         {
            this.FOnOpenFightingCapacityRank(this);
         }
      }
      
      protected function TabOnSwitch(param1:Object) : void
      {
         this.FTabIndex = param1 as int;
         this.FPageIndex = 0;
         this.UpdateTextFieldInfo();
         this.UpdatePageInfo();
         this.UpdateMCUI();
      }
      
      protected function ButtonOnPageLeft(param1:Object, param2:MouseEvent) : void
      {
         --this.FPageIndex;
         if(this.FPageIndex < 0)
         {
            this.FPageIndex = 0;
         }
         this.UpdatePageInfo();
         this.UpdateMCUI();
      }
      
      protected function ButtonOnPageRight(param1:Object, param2:MouseEvent) : void
      {
         ++this.FPageIndex;
         this.UpdatePageInfo();
         this.UpdateMCUI();
      }
      
      public function get OnOpenFightingCapacityRank() : Function
      {
         return this.FOnOpenFightingCapacityRank;
      }
      
      public function set OnOpenFightingCapacityRank(param1:Function) : void
      {
         this.FOnOpenFightingCapacityRank = param1;
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
      
      public function get OnGoto() : Function
      {
         return this.FOnGoto;
      }
      
      public function set OnGoto(param1:Function) : void
      {
         this.FOnGoto = param1;
      }
      
      public function Init() : void
      {
         this.FUITab.SwithTagManual(this.FTabIndex);
         this.UpdatePageInfo();
         this.UpdateTextFieldInfo();
         this.UpdateMCUI();
      }
   }
}

