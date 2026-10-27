package Processors.Game.Lobby.Pet.Components
{
   import Components.Pages.*;
   import Components.Slots.*;
   import Components.Standard.*;
   import Foundation.Queries.*;
   import Foundation.Queries.Textures.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Repositories.*;
   import Foundation.Resources.Textures.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.Pet.*;
   import Resources.Constants.*;
   import Resources.Strings.*;
   import flash.display.*;
   
   public class TUIPetList extends TUIComponent
   {
      
      protected static const PETTRAIN_CAPACITY_TABS:uint = CONST_PET.PETTRAIN_CAPACITY_TABS;
      
      protected var FUITab:TUITab;
      
      protected var FUIPage:TUIPage;
      
      protected var FUISlots:Vector.<TUISlot>;
      
      protected var FTabIndex:int;
      
      protected var FPageIndex:int;
      
      protected var FFilterPets:TPets;
      
      protected var FInitialization:Boolean;
      
      protected var FResource:Sprite;
      
      protected var FContext:TPets;
      
      protected var FPageSize:uint;
      
      protected var FOnClick:Function;
      
      protected var FOnPetsFilter:Function;
      
      protected var FOnSetSlotFilters:Function;
      
      protected var FOnOver:Function;
      
      protected var FOnOut:Function;
      
      protected var FDraggingEnabled:Boolean;
      
      protected var FOnDragBegin:Function;
      
      protected var FOnDragEnd:Function;
      
      protected var FOnDragQuery:Function;
      
      protected var FOnDragDrop:Function;
      
      public function TUIPetList(param1:TUIComponent)
      {
         super(param1);
      }
      
      protected function Initialization() : void
      {
         var _loc1_:int = 0;
         var _loc2_:TUISlot = null;
         this.FUITab = new TUITab(this);
         _loc1_ = 0;
         while(_loc1_ < PETTRAIN_CAPACITY_TABS)
         {
            this.FUITab.SetTabByIndex(this.FResource[CONST_COMMON.RESOURCE_Link_MC_Tab + _loc1_],_loc1_);
            _loc1_++;
         }
         this.FUITab.OnSwitch = this.UITabOnSwitch;
         this.FUITab.Init();
         this.FUIPage = new TUIPage(this);
         this.FUIPage.ButtonPrevious.Substrate = this.FResource[CONST_COMMON.RESOURCE_Link_MC_PageLeft];
         this.FUIPage.ButtonNext.Substrate = this.FResource[CONST_COMMON.RESOURCE_Link_MC_PageRight];
         this.FUIPage.LabelPage = this.FResource[CONST_COMMON.RESOURCE_Link_TF_Page];
         this.FUIPage.PageSize = this.FPageSize;
         this.FUIPage.OnChangePage = this.PageOnChange;
         this.FUIPage.Init();
         this.FUISlots = new Vector.<TUISlot>(this.FPageSize);
         _loc1_ = 0;
         while(_loc1_ < this.FPageSize)
         {
            _loc2_ = new TUISlot(this);
            _loc2_.Resource = this.FResource[CONST_PET.RESOURCE_Link_MC_Slot + _loc1_];
            _loc2_.SequenceDefaultIcon = SResourcesCore.TexturesLobby.GetAnimationSequenceByIdentifiers(CONST_LOBBY.RESOURCESID_Texture_SlotDefaultEffect,0);
            _loc2_.Tag = _loc1_;
            _loc2_.OnQuerySequenceContext = this.SlotsOnQuerySequenceContext;
            _loc2_.OnQuerySubscript = this.SlotsOnQuerySubscript;
            if(this.FDraggingEnabled)
            {
               _loc2_.DraggingEnabled = true;
               _loc2_.DraggingActiveQuery = true;
               _loc2_.OnDragBegin = this.SlotsOnDragBegin;
               _loc2_.OnDragQuery = this.SlotsOnDragQuery;
               _loc2_.OnDragDrop = this.SlotsOnDragDrop;
               _loc2_.OnDragEnd = this.SlotsOnDragEnd;
            }
            _loc2_.OnClick = this.SlotsOnClick;
            _loc2_.OnOver = this.ProcessorOnSlotOver;
            _loc2_.OnOut = this.ProcessorOnSlotOut;
            _loc2_.Init();
            this.FUISlots[_loc1_] = _loc2_;
            _loc1_++;
         }
         this.FFilterPets = new TPets();
         this.Reset();
         this.FInitialization = true;
      }
      
      protected function UpdateUIPetList() : void
      {
         var _loc1_:int = 0;
         var _loc2_:uint = 0;
         if(this.FResource == null)
         {
            return;
         }
         _loc2_ = uint(this.FFilterPets.Count);
         this.ProcessorFilterPetsByQuality(this.FContext,this.FFilterPets);
         this.UpdateSlotsByPets(this.FUISlots,this.FFilterPets);
         if(_loc2_ != this.FFilterPets.Count)
         {
            this.FUIPage.SetupPage(this.FFilterPets.Count,0);
         }
      }
      
      protected function ProcessorFilterPetsByQuality(param1:TPets, param2:TPets) : void
      {
         var _loc3_:int = 0;
         param2.Clear();
         _loc3_ = this.FTabIndex + 1;
         if(this.FOnPetsFilter != null)
         {
            this.FOnPetsFilter(this,param1,param2,_loc3_);
         }
      }
      
      protected function UpdateSlotsByPets(param1:Vector.<TUISlot>, param2:TPets) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:TUISlot = null;
         var _loc8_:TPetBase = null;
         _loc6_ = this.FPageIndex;
         _loc4_ = int(this.FPageSize);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc7_ = param1[_loc3_];
            _loc7_.Context = null;
            _loc7_.Visible = false;
            _loc3_++;
         }
         _loc4_ = param2.Count;
         if(_loc4_ <= 0)
         {
            return;
         }
         _loc5_ = _loc6_ * this.FPageSize;
         _loc3_ = 0;
         while(_loc3_ < this.FPageSize)
         {
            if(_loc3_ + _loc5_ >= _loc4_)
            {
               break;
            }
            _loc7_ = param1[_loc3_];
            _loc8_ = param2.GetPetByIndex(_loc3_ + _loc5_);
            _loc7_.Context = _loc8_;
            if(this.FOnSetSlotFilters != null)
            {
               this.FOnSetSlotFilters(this,_loc8_,_loc7_);
            }
            _loc7_.Visible = true;
            _loc3_++;
         }
      }
      
      protected function SlotsOnQuerySequenceContext(param1:Object, param2:Object, param3:TQueryAnimationSequence, param4:uint = 0) : void
      {
         var _loc5_:TPetBase = null;
         var _loc6_:TResourceRepositoryTexture = null;
         var _loc7_:TTexture = null;
         _loc5_ = param2 as TPetBase;
         _loc6_ = SResourcesCore.TexturesHeadIcon;
         _loc7_ = _loc6_.GetTextureByIdentifier(_loc5_.HeadIconID);
         if(_loc7_ != null)
         {
            param3.Value = _loc7_.GetAnimationSequenceByIdentifier(param4);
         }
         else
         {
            _loc6_.LoadSecondary(_loc5_.HeadIconID);
         }
      }
      
      protected function SlotsOnQuerySubscript(param1:Object, param2:Object, param3:TQueryString) : void
      {
         var _loc4_:TPetBase = null;
         if(param2 is TPetBase)
         {
            _loc4_ = param2 as TPetBase;
            param3.Value = TUtilityString.Format(STRING_COMMON.FORMAT_05,_loc4_.Level);
         }
      }
      
      protected function SlotsOnClick(param1:Object, param2:Object) : void
      {
         if(this.FOnClick != null)
         {
            this.FOnClick(this,param2);
         }
      }
      
      protected function SlotsOnDragBegin(param1:Object) : void
      {
         if(this.FOnDragBegin != null)
         {
            this.FOnDragBegin(param1);
         }
      }
      
      protected function SlotsOnDragQuery(param1:Object, param2:TUIComponent, param3:Object, param4:TQueryBoolean) : void
      {
         if(this.FOnDragQuery != null)
         {
            this.FOnDragQuery(param1,param2,param3,param4);
         }
      }
      
      protected function SlotsOnDragDrop(param1:Object, param2:TUIComponent, param3:Object) : void
      {
         if(this.FOnDragDrop != null)
         {
            this.FOnDragDrop(param1,param2,param3);
         }
      }
      
      protected function SlotsOnDragEnd(param1:Object) : void
      {
         if(this.FOnDragEnd != null)
         {
            this.FOnDragEnd(param1);
         }
      }
      
      protected function UITabOnSwitch(param1:int) : void
      {
         var _loc2_:uint = 0;
         this.FTabIndex = param1;
         this.FPageIndex = 0;
         _loc2_ = uint(this.FFilterPets.Count);
         if(this.FContext != null)
         {
            this.ProcessorFilterPetsByQuality(this.FContext,this.FFilterPets);
            this.UpdateSlotsByPets(this.FUISlots,this.FFilterPets);
         }
         if(_loc2_ != this.FFilterPets.Count)
         {
            this.FUIPage.SetupPage(this.FFilterPets.Count,0);
         }
      }
      
      protected function PageOnChange(param1:Object, param2:int) : void
      {
         this.FPageIndex = param2;
         this.UpdateSlotsByPets(this.FUISlots,this.FFilterPets);
      }
      
      protected function ProcessorOnSlotOver(param1:Object, param2:Object) : void
      {
         if(this.FOnOver != null)
         {
            this.FOnOver(param1,param2);
         }
      }
      
      protected function ProcessorOnSlotOut(param1:Object, param2:Object) : void
      {
         if(this.FOnOut != null)
         {
            this.FOnOut(param1,param2);
         }
      }
      
      public function get Resource() : Sprite
      {
         return this.FResource;
      }
      
      public function set Resource(param1:Sprite) : void
      {
         if(param1 == null)
         {
            return;
         }
         if(param1 != this.FResource)
         {
            this.FResource = param1;
         }
         if(!this.FInitialization)
         {
            this.Initialization();
         }
      }
      
      public function get OnClick() : Function
      {
         return this.FOnClick;
      }
      
      public function set OnClick(param1:Function) : void
      {
         this.FOnClick = param1;
      }
      
      public function get OnPetsFilter() : Function
      {
         return this.FOnPetsFilter;
      }
      
      public function set OnPetsFilter(param1:Function) : void
      {
         this.FOnPetsFilter = param1;
      }
      
      public function get OnOver() : Function
      {
         return this.FOnOver;
      }
      
      public function set OnOver(param1:Function) : void
      {
         this.FOnOver = param1;
      }
      
      public function get OnOut() : Function
      {
         return this.FOnOut;
      }
      
      public function set OnOut(param1:Function) : void
      {
         this.FOnOut = param1;
      }
      
      public function get DraggingEnabled() : Boolean
      {
         return this.FDraggingEnabled;
      }
      
      public function set DraggingEnabled(param1:Boolean) : void
      {
         this.FDraggingEnabled = param1;
      }
      
      public function get OnDragBegin() : Function
      {
         return this.FOnDragBegin;
      }
      
      public function set OnDragBegin(param1:Function) : void
      {
         this.FOnDragBegin = param1;
      }
      
      public function get OnDragEnd() : Function
      {
         return this.FOnDragEnd;
      }
      
      public function set OnDragEnd(param1:Function) : void
      {
         this.FOnDragEnd = param1;
      }
      
      public function get OnDragQuery() : Function
      {
         return this.FOnDragQuery;
      }
      
      public function set OnDragQuery(param1:Function) : void
      {
         this.FOnDragQuery = param1;
      }
      
      public function get OnDragDrop() : Function
      {
         return this.FOnDragDrop;
      }
      
      public function set OnDragDrop(param1:Function) : void
      {
         this.FOnDragDrop = param1;
      }
      
      override public function set Visible(param1:Boolean) : void
      {
         super.Visible = param1;
         if(!this.FInitialization)
         {
            return;
         }
         this.FResource.visible = param1;
      }
      
      public function get Context() : TPets
      {
         return this.FContext;
      }
      
      public function set Context(param1:TPets) : void
      {
         this.FContext = param1;
         if(param1 != null)
         {
            this.UpdateUIPetList();
         }
         else
         {
            this.Reset();
         }
      }
      
      public function get PageSize() : uint
      {
         return this.FPageSize;
      }
      
      public function set PageSize(param1:uint) : void
      {
         this.FPageSize = param1;
      }
      
      public function get OnSetSlotFilters() : Function
      {
         return this.FOnSetSlotFilters;
      }
      
      public function set OnSetSlotFilters(param1:Function) : void
      {
         this.FOnSetSlotFilters = param1;
      }
      
      public function Reset() : void
      {
         var _loc1_:int = 0;
         if(this.FResource == null)
         {
            return;
         }
         _loc1_ = 0;
         while(_loc1_ < this.FPageSize)
         {
            this.FUISlots[_loc1_].Context = null;
            _loc1_++;
         }
         this.FFilterPets.Clear();
         this.FTabIndex = 0;
         this.FPageIndex = 0;
         this.FUITab.SwithTagManual(this.FTabIndex);
         this.FUIPage.PageIndex = this.FPageIndex;
      }
      
      public function Update() : void
      {
         var _loc1_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < this.FPageSize)
         {
            this.FUISlots[_loc1_].Update();
            _loc1_++;
         }
      }
   }
}

