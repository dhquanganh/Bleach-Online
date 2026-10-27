package Processors.Game.Lobby.Smithy
{
   import Components.Pages.*;
   import Components.ScrollBar.*;
   import Components.Slots.*;
   import Components.Standard.*;
   import Foundation.Queries.*;
   import Foundation.Queries.Textures.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Repositories.*;
   import Foundation.Resources.Textures.*;
   import Foundation.UI.*;
   import Logics.*;
   import Logics.Characters.*;
   import Logics.Inventories.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Jade.*;
   import Processors.Game.Lobby.Talisman.*;
   import Processors.Game.Lobby.Utilities.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class TProcessorWindowEquipShow extends TProcessorLobbyWindow
   {
      
      protected static const QUALITYCOLOR_INDEX:Vector.<uint> = CONST_COMMON.QUALITYCOLOR_INDEX;
      
      public static const State_SelectAllEquit:int = 0;
      
      public static const State_SelectJustArm:int = 1;
      
      protected var FUIDispatchRoutines:Vector.<Function>;
      
      protected var FUILocationRoutines:Vector.<Function>;
      
      protected var FInitialization:Boolean;
      
      protected var FMC_SingleEquipList:Vector.<TSingleEquip>;
      
      protected var FCurrentClickSingleEquip:TSingleEquip;
      
      protected var FMC_List:MovieClip;
      
      protected var FScrollBar:TScrollBar;
      
      protected var FMC_HeroTags:Vector.<MovieClip>;
      
      protected var FHeroNameTab:TUITab;
      
      protected var FUIPageHeroList:TUIPage;
      
      protected var FPageIndexHeroList:int;
      
      protected var FCurrentShowTagIndex:int;
      
      protected var FCurrentShowEquipmentBag:TInventories;
      
      protected var FCurrentStateStore:int;
      
      protected var FOnEquipmentClick:Function;
      
      protected var FOnSlotMouseOver:Function;
      
      protected var FOnSlotMouseOut:Function;
      
      protected var FOnChangeHeroPage:Function;
      
      protected var FCurrentState:int;
      
      public function TProcessorWindowEquipShow(param1:TUIComponent)
      {
         super(param1);
         this.ConstructDispatchRoutines();
         this.ConstructLocationRoutines();
      }
      
      protected function ConstructDispatchRoutines() : void
      {
         this.FUIDispatchRoutines = new Vector.<Function>();
         this.FUIDispatchRoutines.push(this.HeroTagUIDispath);
         this.FUIDispatchRoutines.push(this.EquipmentUIDispath);
      }
      
      public function Perform_UIDispatch(param1:MovieClip) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Function = null;
         _loc2_ = 0;
         while(_loc2_ < this.FUIDispatchRoutines.length)
         {
            _loc3_ = this.FUIDispatchRoutines[_loc2_];
            _loc3_(param1);
            _loc2_++;
         }
      }
      
      protected function ConstructLocationRoutines() : void
      {
         this.FUILocationRoutines = new Vector.<Function>();
         this.FUILocationRoutines.push(this.HeroTagLocation);
         this.FUILocationRoutines.push(this.EquipmentLocation);
      }
      
      public function Perform_UILocation() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Function = null;
         _loc1_ = 0;
         while(_loc1_ < this.FUILocationRoutines.length)
         {
            _loc2_ = this.FUILocationRoutines[_loc1_];
            _loc2_();
            _loc1_++;
         }
         this.Reset();
         this.FInitialization = true;
      }
      
      override protected function LogicsPerform() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TSingleEquip = null;
         super.LogicsPerform();
         if(!this.Visible)
         {
            return;
         }
         if(this.FInitialization)
         {
            _loc2_ = int(this.FMC_SingleEquipList.length);
            _loc1_ = 0;
            while(_loc1_ < _loc2_)
            {
               _loc3_ = this.FMC_SingleEquipList[_loc1_];
               _loc3_.UpdateSingleEquip();
               _loc1_++;
            }
         }
      }
      
      protected function HeroTagUIDispath(param1:MovieClip) : void
      {
         var _loc2_:int = 0;
         var _loc3_:MovieClip = null;
         var _loc4_:TextField = null;
         var _loc5_:MovieClip = null;
         this.FMC_HeroTags = new Vector.<MovieClip>();
         _loc5_ = param1["GeneralNameGroup"];
         _loc2_ = 0;
         while(_loc2_ < CONST_JADE.MAX_HeroCount)
         {
            _loc3_ = _loc5_["General_" + _loc2_];
            this.FMC_HeroTags.push(_loc3_);
            _loc2_++;
         }
         this.FUIPageHeroList = new TUIPage(this);
         this.FUIPageHeroList.ButtonPrevious.Substrate = param1["MC_HeroPage"]["btn_left"];
         this.FUIPageHeroList.ButtonNext.Substrate = param1["MC_HeroPage"]["btn_right"];
         this.FUIPageHeroList.LabelPage = param1["MC_HeroPage"]["TF_Page"];
         this.FUIPageHeroList.PageSize = CONST_JADE.MAX_HeroCount;
         this.FUIPageHeroList.OnChangePage = this.HeroListPageOnChange;
      }
      
      protected function HeroTagLocation() : void
      {
         var _loc1_:int = 0;
         this.FHeroNameTab = new TUITab(this);
         _loc1_ = 0;
         while(_loc1_ < CONST_JADE.MAX_HeroCount)
         {
            this.FHeroNameTab.SetTabByIndex(this.FMC_HeroTags[_loc1_],_loc1_);
            _loc1_++;
         }
         this.FHeroNameTab.Init();
         this.FHeroNameTab.OnSwitch = this.OnSwitchTab;
         addChild(this.FHeroNameTab);
         this.FCurrentShowEquipmentBag = new TInventories();
      }
      
      protected function UpdateHerosTag() : void
      {
         this.SetTagName();
      }
      
      protected function ResetHerosTag() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:MovieClip = null;
         _loc2_ = int(this.FMC_HeroTags.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FMC_HeroTags[_loc1_];
            _loc3_.visible = false;
            _loc1_++;
         }
         this.FHeroNameTab.SwithTagManual(0);
         this.FPageIndexHeroList = 0;
         this.UpdateHerosTag();
         this.FCurrentShowTagIndex = -1;
         this.SelectEquipmentsIntoBag(0,this.FCurrentShowEquipmentBag);
         this.ConstructScroolBar();
         this.UpdateEquipmentInfor();
         this.SetupHeroListPage(SLogicsCore.Character.Heros.Count,0);
      }
      
      protected function SetTagName() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:THeros = null;
         var _loc4_:THero = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         _loc3_ = SLogicsCore.Character.Heros;
         _loc5_ = this.FPageIndexHeroList * CONST_JADE.MAX_HeroCount;
         _loc6_ = _loc5_ + CONST_JADE.MAX_HeroCount;
         _loc6_ = _loc6_ > _loc3_.Count ? _loc3_.Count : _loc6_;
         _loc7_ = 0;
         _loc1_ = _loc5_;
         while(_loc1_ < _loc6_)
         {
            _loc4_ = _loc3_.GetHeroByIndex(_loc1_);
            this.FHeroNameTab.SetTabCaptionByIndex(_loc4_.Name,_loc7_,QUALITYCOLOR_INDEX[_loc4_.Quality]);
            this.FHeroNameTab.SetTabShowByIndex(_loc7_);
            _loc7_++;
            _loc1_++;
         }
         if(_loc7_ < CONST_JADE.MAX_HeroCount)
         {
            this.FHeroNameTab.SetTabCaptionByIndex(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.SMITHY_STRING_36),_loc7_,16775109);
            this.FHeroNameTab.SetTabShowByIndex(_loc7_);
            _loc7_++;
         }
         _loc1_ = _loc7_;
         while(_loc1_ < CONST_JADE.MAX_HeroCount)
         {
            this.FHeroNameTab.SetTabHideByIndex(_loc1_);
            _loc1_++;
         }
      }
      
      protected function HideAndShowTagByHeroNum(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _loc3_ = this.FPageIndexHeroList;
         this.FHeroNameTab.Reset();
         if(param1 > CONST_JADE.MAX_HeroCount)
         {
            if(_loc3_ == uint(param1 / CONST_JADE.MAX_HeroCount))
            {
               _loc4_ = param1 - CONST_JADE.MAX_HeroCount;
            }
            else
            {
               _loc4_ = CONST_JADE.MAX_HeroCount;
            }
         }
         else
         {
            _loc4_ = param1;
         }
         if(_loc4_ <= 0)
         {
            return;
         }
         _loc2_ = 0;
         while(_loc2_ < CONST_JADE.MAX_HeroCount)
         {
            if(_loc2_ < _loc4_)
            {
               this.FHeroNameTab.SetTabShowByIndex(_loc2_);
            }
            else
            {
               this.FHeroNameTab.SetTabHideByIndex(_loc2_);
            }
            _loc2_++;
         }
      }
      
      protected function SelectEquipmentsIntoBag(param1:int, param2:TInventories) : void
      {
         var _loc3_:THero = null;
         var _loc4_:int = 0;
         var _loc5_:TCollectionInventory = null;
         var _loc6_:TInventory = null;
         var _loc7_:int = 0;
         if(param1 + this.FPageIndexHeroList * CONST_JADE.MAX_HeroCount < SLogicsCore.Character.Heros.Count)
         {
            _loc3_ = SLogicsCore.Character.Heros.GetHeroByIndex(param1 + this.FPageIndexHeroList * CONST_JADE.MAX_HeroCount);
            _loc5_ = _loc3_.EquipmentsMounted;
            param2.Clear();
            _loc4_ = 0;
            for(; _loc4_ < _loc5_.Capacity; _loc4_++)
            {
               _loc6_ = _loc5_.GetInventoryByIndex(_loc4_);
               if(_loc6_ == null)
               {
                  continue;
               }
               switch(this.FCurrentState)
               {
                  case State_SelectAllEquit:
                     param2.Add(_loc6_);
                     break;
                  case State_SelectJustArm:
                     if(_loc6_.CategorySecond == 1)
                     {
                        param2.Add(_loc6_);
                     }
               }
            }
         }
         else
         {
            _loc7_ = int(SLogicsCore.Character.Equipments.Count);
            param2.Clear();
            _loc4_ = 0;
            for(; _loc4_ < _loc7_; _loc4_++)
            {
               _loc6_ = SLogicsCore.Character.Equipments.GetInventoryByIndex(_loc4_);
               if(_loc6_ == null)
               {
                  continue;
               }
               switch(this.FCurrentState)
               {
                  case State_SelectAllEquit:
                     param2.Add(_loc6_);
                     break;
                  case State_SelectJustArm:
                     if(_loc6_.CategorySecond == 1)
                     {
                        param2.Add(_loc6_);
                     }
               }
            }
         }
      }
      
      private function HeroListPageOnChange(param1:Object, param2:int) : void
      {
         this.FPageIndexHeroList = param2;
         this.FHeroNameTab.SwithTagManual(0);
         this.UpdateHerosTag();
         this.SelectEquipmentsIntoBag(0,this.FCurrentShowEquipmentBag);
         this.ConstructScroolBar();
         this.UpdateEquipmentInfor();
         if(this.FOnChangeHeroPage != null)
         {
            this.FOnChangeHeroPage();
         }
      }
      
      protected function SetupHeroListPage(param1:int, param2:int) : void
      {
         this.FUIPageHeroList.TotalQuantity = param1;
         this.FUIPageHeroList.Update();
         this.FUIPageHeroList.PageIndex = param2;
      }
      
      protected function EquipmentUIDispath(param1:MovieClip) : void
      {
         var _loc2_:int = 0;
         var _loc3_:MovieClip = null;
         var _loc4_:TUISlot = null;
         this.FMC_List = param1["mc_list"];
         this.FScrollBar = new TScrollBar(this.FMC_List,341,false,0,56);
         this.FMC_SingleEquipList = new Vector.<TSingleEquip>();
      }
      
      protected function EquipmentLocation() : void
      {
         this.FCurrentShowTagIndex = -1;
      }
      
      protected function ConstructScroolBar() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TSingleEquip = null;
         var _loc4_:TInventory = null;
         var _loc5_:int = 0;
         _loc2_ = int(this.FMC_SingleEquipList.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FMC_SingleEquipList[_loc1_];
            _loc3_.Release();
            _loc3_.StubReferences.Dereference(this);
            _loc1_++;
         }
         this.FMC_SingleEquipList.length = 0;
         this.FCurrentClickSingleEquip = null;
         this.FScrollBar.Clear();
         _loc5_ = this.FCurrentShowEquipmentBag.Count;
         if(_loc5_ < CONST_SMITHY.MinSingleEquipmentNum)
         {
            _loc2_ = CONST_SMITHY.MinSingleEquipmentNum;
         }
         else
         {
            _loc2_ = _loc5_;
         }
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = SLogicsCore.PoolUISingleEquipment.AcquireUISingleEquipment(this);
            _loc3_.StubReferences.Reference(this);
            _loc3_.OnClick = this.EquipmentClick;
            _loc3_.OnQuerySequenceContext = this.SlotsOnQuerySequenceContext;
            _loc3_.OnQueryEuqipLevel = this.SlotsOnQueryEuqipLevel;
            _loc3_.OnOut = this.UIComponentsHintOnOut;
            _loc3_.OnOver = this.UIComponentsHintOnOver;
            this.FScrollBar.AddItem(_loc3_);
            this.FMC_SingleEquipList.push(_loc3_);
            _loc1_++;
         }
      }
      
      protected function UpdateEquipmentInfor() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TEquipment = null;
         var _loc4_:int = 0;
         var _loc5_:TSingleEquip = null;
         var _loc6_:String = null;
         _loc6_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.SMITHY_STRING_61);
         _loc4_ = this.FCurrentShowEquipmentBag.Count;
         _loc1_ = 0;
         while(_loc1_ < _loc4_)
         {
            _loc3_ = this.FCurrentShowEquipmentBag.GetInventoryByIndex(_loc1_) as TEquipment;
            _loc5_ = this.FMC_SingleEquipList[_loc1_];
            _loc5_.SetEquip(_loc3_,_loc3_.Name,_loc6_ + _loc3_.UpgradingLevel,_loc3_.Quality);
            _loc1_++;
         }
      }
      
      protected function EquipmentClick(param1:Object, param2:Object) : void
      {
         var _loc3_:THeros = null;
         var _loc4_:uint = 0;
         var _loc5_:TEquipment = null;
         var _loc6_:TSingleEquip = null;
         _loc6_ = param1 as TSingleEquip;
         _loc5_ = param2 as TEquipment;
         if(this.FCurrentClickSingleEquip != null)
         {
            this.FCurrentClickSingleEquip.BClick = false;
         }
         this.FCurrentClickSingleEquip = _loc6_;
         _loc3_ = SLogicsCore.Character.Heros;
         _loc4_ = 0;
         if(_loc3_.Count > this.FCurrentShowTagIndex + this.FPageIndexHeroList * CONST_JADE.MAX_HeroCount)
         {
            _loc4_ = _loc3_.GetHeroByIndex(this.FCurrentShowTagIndex + this.FPageIndexHeroList * CONST_JADE.MAX_HeroCount).Identifier;
         }
         this.SendShowEquipment(_loc5_,_loc4_);
         TutorialNextStep(CONST_FRESHGUIDE.EVENTID_SelectEquit);
      }
      
      protected function SendShowEquipment(param1:TEquipment, param2:uint) : void
      {
         if(this.FOnEquipmentClick != null)
         {
            this.FOnEquipmentClick(param1,param2);
         }
      }
      
      public function OnSwitchTab(param1:int) : void
      {
         if(param1 != this.FCurrentShowTagIndex || this.FCurrentStateStore != this.FCurrentState)
         {
            this.SelectEquipmentsIntoBag(param1,this.FCurrentShowEquipmentBag);
            this.ConstructScroolBar();
            if(this.FOnChangeHeroPage != null)
            {
               this.FOnChangeHeroPage();
            }
            this.FCurrentStateStore = this.FCurrentState;
         }
         this.UpdateEquipmentInfor();
         this.FCurrentShowTagIndex = param1;
      }
      
      protected function UIComponentsHintOnOver(param1:Object, param2:TInventory) : void
      {
         if(this.FOnSlotMouseOver != null)
         {
            this.FOnSlotMouseOver(param1,param2);
         }
      }
      
      protected function UIComponentsHintOnOut(param1:Object, param2:TInventory) : void
      {
         if(this.FOnSlotMouseOut != null)
         {
            this.FOnSlotMouseOut(param1,param2);
         }
      }
      
      protected function SlotsOnQuerySequenceContext(param1:Object, param2:Object, param3:TQueryAnimationSequence, param4:uint = 0) : void
      {
         var _loc5_:TInventory = null;
         var _loc6_:TResourceRepositoryTexture = null;
         var _loc7_:TTexture = null;
         _loc5_ = param2 as TInventory;
         _loc6_ = SResourcesCore.TexturesInventory;
         _loc7_ = _loc6_.GetTextureByIdentifier(_loc5_.IDTexture);
         if(_loc7_ != null)
         {
            param3.Value = _loc7_.GetAnimationSequenceByIdentifier(param4);
         }
         else
         {
            _loc6_.LoadSecondary(_loc5_.IDTexture);
         }
      }
      
      protected function SlotsOnQueryEuqipLevel(param1:Object, param2:Object, param3:TQueryString) : void
      {
         var _loc4_:TEquipment = null;
         if(param2 is TEquipment)
         {
            _loc4_ = param2 as TEquipment;
            if(_loc4_.UpgradingLevel > 0)
            {
               param3.Value = "Lv." + _loc4_.UpgradingLevel.toString();
            }
         }
      }
      
      public function set OnEquipmentClick(param1:Function) : void
      {
         this.FOnEquipmentClick = param1;
      }
      
      public function set OnSlotMouseOver(param1:Function) : void
      {
         this.FOnSlotMouseOver = param1;
      }
      
      public function set OnSlotMouseOut(param1:Function) : void
      {
         this.FOnSlotMouseOut = param1;
      }
      
      public function set OnChangeHeroPage(param1:Function) : void
      {
         this.FOnChangeHeroPage = param1;
      }
      
      public function get CurrentShowTagIndex() : int
      {
         return this.FCurrentShowTagIndex;
      }
      
      public function set CurrentState(param1:int) : void
      {
         this.FCurrentState = param1;
      }
      
      public function Update() : void
      {
         if(this.FCurrentShowTagIndex == -1)
         {
            this.UpdateHerosTag();
            this.OnSwitchTab(0);
            this.SetupHeroListPage(SLogicsCore.Character.Heros.Count + 1,0);
         }
         else
         {
            this.OnSwitchTab(this.FCurrentShowTagIndex);
            if(this.FCurrentClickSingleEquip != null)
            {
               this.FCurrentClickSingleEquip.BClick = true;
            }
         }
      }
      
      public function Reset() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TSingleEquip = null;
         this.ResetHerosTag();
         _loc2_ = int(this.FMC_SingleEquipList.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FMC_SingleEquipList[_loc1_];
            _loc3_.Release();
            _loc3_.StubReferences.Dereference(this);
            _loc1_++;
         }
         this.FCurrentShowTagIndex = -1;
         this.FCurrentState = State_SelectAllEquit;
         this.FCurrentStateStore = 0;
      }
      
      public function UpdateAdvanced() : void
      {
         this.SelectEquipmentsIntoBag(this.FCurrentShowTagIndex + this.FPageIndexHeroList * CONST_JADE.MAX_HeroCount,this.FCurrentShowEquipmentBag);
         this.ConstructScroolBar();
         this.UpdateEquipmentInfor();
      }
      
      public function SetListVisible(param1:Boolean) : void
      {
         this.FMC_List.visible = param1;
      }
   }
}

