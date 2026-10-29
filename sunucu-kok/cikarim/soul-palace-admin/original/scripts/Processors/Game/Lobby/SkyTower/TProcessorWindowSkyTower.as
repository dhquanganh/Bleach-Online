package Processors.Game.Lobby.SkyTower
{
   import Components.Pages.*;
   import Components.Standard.TUIButton;
   import Foundation.Resources.*;
   import Foundation.Timing.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.SkyTower.*;
   import Logics.TimeCoolDown.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.SkyTower.Components.*;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Resources.Constants.*;
   import Resources.Strings.*;
   import Utilities.Timing.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class TProcessorWindowSkyTower extends TProcessorLobbyWindow
   {
      
      protected static const CAPACITY_Page_Towers:uint = CONST_SKYTOWER.CAPACITY_Page_Towers;
      
      protected static const TIME_INTERVAL_PVP_PERIOD:int = 1000;
      
      protected var FSkyTower:TSkyTower;
      
      protected var FSP_SkyTower:Sprite;
      
      protected var FSP_OnOff:Sprite;
      
      protected var FBtn_Close:SimpleButton;
      
      protected var FMC_Effect_01:MovieClip;
      
      protected var FMC_Towers_Effect:MovieClip;
      
      protected var FUITowers:Vector.<TUITower>;
      
      protected var FUITower_One:TUITower;
      
      protected var FUIPageTower:TUIPage;
      
      protected var FSP_PvpTitleOff:Sprite;
      
      protected var FSP_PvpTitleOn:Sprite;
      
      protected var FTF_Pvp_Title_01:TextField;
      
      protected var FTF_Pvp_Title_02:TextField;
      
      protected var FSP_Received:Sprite;
      
      protected var FBtn_Chest:TUIButton;
      
      protected var FPvpTimer:uint;
      
      protected var FTickPvpTimer:int;
      
      protected var FPageTowerIndex:int;
      
      protected var FFirstEnter:Boolean;
      
      protected var FInitialization:Boolean;
      
      protected var FOnEnterPve:Function;
      
      protected var FOnChest:Function;
      
      public function TProcessorWindowSkyTower(param1:TUIComponent)
      {
         super(param1);
         this.FSkyTower = SLogicsCore.SkyTower;
         this.FFirstEnter = true;
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_SKYTOWER.RESOURCESID_Swf_SkyTower);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Sprite = null;
         var _loc4_:TUITower = null;
         this.FSP_SkyTower = TUtilityReflection.CreateDisplayObjectInstance(CONST_SKYTOWER.RESOURCE_ClassName_SP_SkyTower) as Sprite;
         addChild(this.FSP_SkyTower);
         _loc3_ = this.FSP_SkyTower[CONST_SKYTOWER.RESOURCE_Link_SP_Top];
         this.FSP_OnOff = _loc3_[CONST_SKYTOWER.RESOURCE_Link_SP_OnOff];
         this.FBtn_Close = this.FSP_OnOff[CONST_COMMON.RESOURCE_Link_Btn_Close];
         this.FBtn_Close.tabEnabled = false;
         this.FMC_Effect_01 = this.FSP_SkyTower[CONST_SKYTOWER.RESOURCE_ClassName_MC_Effect_01];
         this.FMC_Effect_01.mouseChildren = false;
         this.FMC_Effect_01.mouseEnabled = false;
         this.FMC_Towers_Effect = this.FSP_SkyTower[CONST_SKYTOWER.RESOURCE_Link_MC_Towers_Effect];
         this.FMC_Towers_Effect.stop();
         _loc3_ = this.FMC_Towers_Effect[CONST_SKYTOWER.RESOURCE_Link_SP_Towers];
         _loc2_ = int(CAPACITY_Page_Towers);
         this.FUITowers = new Vector.<TUITower>(_loc2_);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc4_ = new TUITower(null);
            _loc4_.Resource = _loc3_[CONST_SKYTOWER.RESOURCE_Link_MC_Tower + _loc1_];
            _loc4_.Perform_UIDispatch();
            _loc4_.OnEnterPve = this.TowerOnEnterPve;
            this.FUITowers[_loc1_] = _loc4_;
            _loc1_++;
         }
         this.FUITower_One = new TUITower(null);
         this.FUITower_One.Resource = _loc3_[CONST_SKYTOWER.RESOURCE_Link_MC_Tower_One];
         this.FUITower_One.Perform_UIDispatch();
         this.FUITower_One.OnEnterPve = this.TowerOnEnterPve;
         _loc3_ = this.FSP_SkyTower[CONST_COMMON.RESOURCE_Link_SP_Page];
         this.FUIPageTower = new TUIPage(null);
         this.FUIPageTower.ButtonPrevious.Substrate = _loc3_[CONST_COMMON.RESOURCE_Link_MC_PageLeft];
         this.FUIPageTower.ButtonNext.Substrate = _loc3_[CONST_COMMON.RESOURCE_Link_MC_PageRight];
         this.FUIPageTower.LabelPage = _loc3_[CONST_COMMON.RESOURCE_Link_TF_Page];
         this.FUIPageTower.LabelPage.text = "0/0";
         this.FUIPageTower.PageSize = CAPACITY_Page_Towers;
         this.FUIPageTower.OnChangePage = this.PageTowerOnChange;
         this.FUIPageTower.Init();
         _loc3_ = this.FSP_SkyTower[CONST_SKYTOWER.RESOURCE_Link_SP_TowerTitle];
         this.FSP_PvpTitleOff = _loc3_[CONST_SKYTOWER.RESOURCE_Link_SP_Pvp_Title_01];
         this.FSP_PvpTitleOn = _loc3_[CONST_SKYTOWER.RESOURCE_Link_SP_Pvp_Title_02];
         this.FTF_Pvp_Title_01 = this.FSP_PvpTitleOn[CONST_SKYTOWER.RESOURCE_Link_TF_Pvp_Title_01];
         this.FTF_Pvp_Title_02 = this.FSP_PvpTitleOn[CONST_SKYTOWER.RESOURCE_Link_TF_Pvp_Title_02];
         _loc3_ = this.FSP_SkyTower[CONST_SKYTOWER.RESOURCE_Link_SP_Chest];
         this.FSP_Received = _loc3_[CONST_SKYTOWER.RESOURCE_Link_SP_Received];
         this.FSP_Received.mouseEnabled = false;
         this.FBtn_Chest = new TUIButton();
         this.FBtn_Chest.Substrate = _loc3_[CONST_SKYTOWER.RESOURCE_Link_Btn_Chest];
         this.FBtn_Chest.OnClick = this.Btn_ChestOnClick;
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         this.FBtn_Close.addEventListener(MouseEvent.CLICK,this.ButtonCloseOnClick,false,0,true);
         this.FInitialization = true;
         this.Reset();
         super.ResourcesPerform_UILocations();
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(this.Visible)
         {
            if(this.FInitialization)
            {
               this.LogicsPerform_TowersEffect();
               this.LogicsPerform_PvpTime();
            }
         }
      }
      
      protected function LogicsPerform_TowersEffect() : void
      {
         if(this.FMC_Towers_Effect.isPlaying)
         {
            if(this.FMC_Towers_Effect.currentFrame == this.FMC_Towers_Effect.totalFrames / 2)
            {
               this.UpdateUITowers();
            }
            if(this.FMC_Towers_Effect.currentFrame == this.FMC_Towers_Effect.totalFrames)
            {
               this.FMC_Towers_Effect.stop();
            }
         }
      }
      
      protected function LogicsPerform_PvpTime() : void
      {
         var _loc1_:int = 0;
         if(this.FSP_PvpTitleOn.visible)
         {
            _loc1_ = int(STimingCore.TickCount);
            if(_loc1_ - this.FTickPvpTimer >= TIME_INTERVAL_PVP_PERIOD)
            {
               this.FTF_Pvp_Title_02.text = TUtilityTiming.fomatTime(STimingCore.ServerTick - this.FPvpTimer);
               this.FTickPvpTimer = _loc1_;
            }
         }
      }
      
      protected function ProcessorUpdateUIPvp() : void
      {
         var _loc1_:TTower = null;
         var _loc2_:TLayer = null;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         _loc3_ = uint(SLogicsCore.Character.Identifier0);
         _loc4_ = uint(SLogicsCore.Character.Identifier1);
         _loc1_ = SLogicsCore.SkyTower.GetCharacterPvpTower(_loc3_,_loc4_);
         _loc2_ = SLogicsCore.SkyTower.GetCharacterPvpLayer(_loc3_,_loc4_);
         if(_loc2_ != null)
         {
            this.FTF_Pvp_Title_01.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_SkyTower_04),_loc1_.Name);
            this.FPvpTimer = _loc2_.PvpTimer;
            this.FTickPvpTimer = STimingCore.TickCount;
            this.FSP_PvpTitleOn.visible = true;
            this.FSP_PvpTitleOff.visible = false;
         }
         else
         {
            this.FSP_PvpTitleOn.visible = false;
            this.FSP_PvpTitleOff.visible = true;
         }
      }
      
      protected function UpdateUIPageTowers() : void
      {
         var _loc1_:* = 0;
         var _loc2_:int = 0;
         var _loc3_:TTower = null;
         var _loc4_:uint = 0;
         if(this.FFirstEnter)
         {
            _loc4_ = this.FSkyTower.LockedTowerID;
            _loc2_ = this.FSkyTower.Towers.Count;
            _loc1_ = 0;
            while(_loc1_ < _loc2_)
            {
               _loc3_ = this.FSkyTower.Towers.GetTowerByIndex(_loc1_);
               if(_loc4_ > 0 && _loc4_ == _loc3_.Identifier)
               {
                  break;
               }
               if(!_loc3_.IsUnlock)
               {
                  _loc1_--;
                  break;
               }
               _loc1_++;
            }
            this.FPageTowerIndex = _loc1_ / CAPACITY_Page_Towers;
            this.FFirstEnter = false;
         }
         this.FUIPageTower.TotalQuantity = this.FSkyTower.Towers.Count;
         this.FUIPageTower.PageIndex = this.FPageTowerIndex;
         this.FUIPageTower.Update();
      }
      
      protected function ProcessorUpdateUITowers() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:TTower = null;
         var _loc8_:TTowers = null;
         var _loc9_:TUITower = null;
         _loc6_ = this.FPageTowerIndex;
         _loc1_ = 0;
         while(_loc1_ < CAPACITY_Page_Towers)
         {
            _loc9_ = this.FUITowers[_loc1_];
            _loc9_.Context = null;
            _loc9_.Tag = 0;
            _loc9_.Visible = false;
            _loc1_++;
         }
         this.FUITower_One.Context = null;
         this.FUITower_One.Tag = 0;
         this.FUITower_One.Visible = false;
         _loc8_ = this.FSkyTower.Towers;
         _loc5_ = _loc6_ * CAPACITY_Page_Towers;
         if(_loc6_ == CAPACITY_Page_Towers - 1)
         {
            _loc7_ = _loc8_.GetTowerByIndex(_loc5_);
            this.FUITower_One.Tag = this.FSkyTower.LockedTowerID;
            this.FUITower_One.Context = _loc7_;
            this.FUITower_One.Visible = true;
         }
         else
         {
            _loc2_ = _loc8_.Count - 1;
            _loc1_ = 0;
            while(_loc1_ < CAPACITY_Page_Towers)
            {
               if(_loc1_ + _loc5_ >= _loc2_)
               {
                  return;
               }
               _loc7_ = _loc8_.GetTowerByIndex(_loc1_ + _loc5_);
               _loc9_ = this.FUITowers[_loc1_];
               _loc9_.Tag = this.FSkyTower.LockedTowerID;
               _loc9_.Context = _loc7_;
               _loc9_.Visible = true;
               _loc1_++;
            }
         }
      }
      
      protected function UpdateUIChestState() : void
      {
         if(this.FSkyTower.ReceiveChestID > 0)
         {
            this.FSP_Received.visible = true;
         }
         else
         {
            this.FSP_Received.visible = false;
         }
      }
      
      override protected function ProcessorResize() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         if(!this.FInitialization || !this.Visible)
         {
            return;
         }
         _loc1_ = FUICore.StageWidth;
         _loc2_ = FUICore.StageHeight;
         this.FSP_OnOff.x = _loc1_ - this.FSP_OnOff.width;
      }
      
      protected function ButtonCloseOnClick(param1:MouseEvent) : void
      {
         ProcessorWindowClose();
      }
      
      protected function Btn_ChestOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FOnChest != null)
         {
            this.FOnChest(this);
         }
      }
      
      protected function PageTowerOnChange(param1:Object, param2:int) : void
      {
         if(this.FMC_Towers_Effect.isPlaying)
         {
            this.FUIPageTower.PageIndex = this.FPageTowerIndex;
            return;
         }
         this.FPageTowerIndex = param2;
         this.FMC_Towers_Effect.play();
      }
      
      protected function TowerOnEnterPve(param1:Object, param2:TTower) : void
      {
         this.FSkyTower.SelectTowerID = param2.Identifier;
         if(this.FOnEnterPve != null)
         {
            this.FOnEnterPve(this,param2);
         }
      }
      
      public function get OnEnterPve() : Function
      {
         return this.FOnEnterPve;
      }
      
      public function set OnEnterPve(param1:Function) : void
      {
         this.FOnEnterPve = param1;
      }
      
      public function get OnChest() : Function
      {
         return this.FOnChest;
      }
      
      public function set OnChest(param1:Function) : void
      {
         this.FOnChest = param1;
      }
      
      override public function Dispose() : void
      {
         var _loc1_:int = 0;
         this.Reset();
         if(!this.FInitialization)
         {
            return;
         }
         this.FBtn_Close.removeEventListener(MouseEvent.CLICK,this.ButtonCloseOnClick);
         this.FBtn_Close = null;
         this.FSP_OnOff = null;
         this.FMC_Effect_01 = null;
         this.FMC_Towers_Effect = null;
         _loc1_ = 0;
         while(_loc1_ < CAPACITY_Page_Towers)
         {
            this.FUITowers[_loc1_].Dispose();
            this.FUITowers[_loc1_] = null;
            _loc1_++;
         }
         this.FUITowers.length = 0;
         this.FUITower_One.Dispose();
         this.FUITower_One = null;
         this.FUIPageTower.Dispose();
         this.FSP_PvpTitleOff = null;
         this.FSP_PvpTitleOn = null;
         this.FTF_Pvp_Title_01 = null;
         this.FTF_Pvp_Title_02 = null;
         this.FSP_Received = null;
         this.FBtn_Chest.Dispose();
         this.FBtn_Chest = null;
         this.removeChild(this.FSP_SkyTower);
         this.FSP_SkyTower = null;
         this.FInitialization = false;
      }
      
      public function Reset() : void
      {
         var _loc1_:int = 0;
         if(!this.FInitialization)
         {
            return;
         }
         _loc1_ = 0;
         while(_loc1_ < CAPACITY_Page_Towers)
         {
            this.FUITowers[_loc1_].Context = null;
            this.FUITowers[_loc1_].Tag = 0;
            this.FUITowers[_loc1_].Visible = false;
            _loc1_++;
         }
         this.FUITower_One.Context = null;
         this.FUITower_One.Tag = 0;
         this.FUITower_One.Visible = false;
         this.FPvpTimer = 0;
         this.FTickPvpTimer = 0;
         this.FPageTowerIndex = 0;
         this.FMC_Effect_01.stop();
         this.FMC_Towers_Effect.stop();
         this.FTF_Pvp_Title_01.text = "";
         this.FTF_Pvp_Title_02.text = "";
         this.FFirstEnter = true;
         this.FSP_PvpTitleOn.visible = false;
         this.FSP_PvpTitleOff.visible = false;
         this.FSP_Received.visible = false;
      }
      
      public function Update() : void
      {
         this.ProcessorUpdateUIPvp();
         this.UpdateUITowers();
         this.UpdateChestState();
         this.FMC_Effect_01.play();
         this.ProcessorResize();
      }
      
      public function UpdateUITowers() : void
      {
         this.UpdateUIPageTowers();
         this.ProcessorUpdateUITowers();
      }
      
      public function UpdateUIPvp() : void
      {
         this.ProcessorUpdateUIPvp();
      }
      
      public function UpdateChestState() : void
      {
         this.UpdateUIChestState();
      }
   }
}

