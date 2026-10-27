package Logics.HyperStrings.Elements
{
   import Foundation.Common.TBounds;
   import Foundation.Common.TCoordinate;
   import Foundation.Resources.Repositories.TResourceRepositoryTexture;
   import Foundation.Resources.Textures.TAnimationFrame;
   import Foundation.Resources.Textures.TAnimationSequence;
   import Foundation.Resources.Textures.TTexture;
   import Foundation.Timing.STimingCore;
   import Foundation.Utilities.TUtilityCartisian;
   import Foundation.Utilities.TUtilityString;
   import Logics.Inventories.TInventory;
   import Rendering.Texts.TPainterTextEffect;
   import Resources.Constants.CONST_COMMON;
   
   public class THyperStringElementInventory extends THyperStringElementMonolithic
   {
      
      protected static const SIZE_ElementWidth:int = 160;
      
      protected static const SIZE_ElementHeight:int = 60;
      
      protected static const COORDINATE_IconPivotX:int = 30;
      
      protected static const COORDINATE_IconPivotY:int = 30;
      
      protected static const COORDINATE_NamePivotX:int = 105;
      
      protected static const COORDINATE_NamePivotY:int = 30;
      
      protected var FPainterName:TPainterTextEffect;
      
      protected var FCoordinatePivot:TCoordinate;
      
      protected var FTextureInventory:TTexture;
      
      protected var FCaptionInventory:String;
      
      protected var FSequenceSubstrate:TAnimationSequence;
      
      protected var FRepositoryTexture:TResourceRepositoryTexture;
      
      protected var FInventory:TInventory;
      
      public function THyperStringElementInventory()
      {
         super();
         this.FCoordinatePivot = new TCoordinate();
      }
      
      override protected function RenderingPerform(param1:TBounds) : void
      {
         this.RenderingUpdateResources();
         if(this.FInventory == null)
         {
            return;
         }
         this.RenderingPerform_Icon(param1);
         this.RenderingPerform_Name(param1);
      }
      
      protected function RenderingPerform_Icon(param1:TBounds) : void
      {
         var _loc2_:TAnimationSequence = null;
         var _loc3_:TAnimationFrame = null;
         if(this.FTextureInventory == null)
         {
            return;
         }
         _loc2_ = this.FTextureInventory.GetAnimationSequenceByIdentifier(CONST_COMMON.SEQUENCEID_Default);
         if(_loc2_ == null)
         {
            return;
         }
         _loc3_ = _loc2_.GetAnimationFrameByTick(STimingCore.TickCount);
         if(_loc3_ != null)
         {
            TUtilityCartisian.CoordinateSet(this.FCoordinatePivot,param1.X + COORDINATE_IconPivotX,param1.Y + COORDINATE_IconPivotY);
         }
      }
      
      protected function RenderingPerform_Name(param1:TBounds) : void
      {
         var _loc2_:String = null;
         if(this.FCaptionInventory == null)
         {
            _loc2_ = this.FInventory.Name;
            if(this.Inventory.Quantity > 1)
            {
               _loc2_ += TUtilityString.Format("\nx%0",this.FInventory.Quantity);
            }
            this.FCaptionInventory = _loc2_;
         }
      }
      
      protected function RenderingUpdateResources() : void
      {
         if(this.FInventory == null)
         {
            return;
         }
         this.RenderingUpdateResources_Inventory();
      }
      
      protected function RenderingUpdateResources_Inventory() : void
      {
         var _loc1_:uint = 0;
         if(this.FTextureInventory != null)
         {
            return;
         }
         if(this.FRepositoryTexture == null)
         {
            return;
         }
         _loc1_ = this.FInventory.IDTexture;
         this.FTextureInventory = this.FRepositoryTexture.GetTextureByIdentifier(_loc1_);
         if(this.FTextureInventory == null)
         {
            this.FRepositoryTexture.LoadSecondary(_loc1_);
         }
      }
      
      public function get SequenceSubstrate() : TAnimationSequence
      {
         return this.FSequenceSubstrate;
      }
      
      public function set SequenceSubstrate(param1:TAnimationSequence) : void
      {
         this.FSequenceSubstrate = param1;
      }
      
      public function get RepositoryTexture() : TResourceRepositoryTexture
      {
         return this.FRepositoryTexture;
      }
      
      public function set RepositoryTexture(param1:TResourceRepositoryTexture) : void
      {
         this.FRepositoryTexture = param1;
      }
      
      public function get Inventory() : TInventory
      {
         return this.FInventory;
      }
      
      public function set Inventory(param1:TInventory) : void
      {
         if(param1 != this.FInventory)
         {
            if(this.FInventory != null)
            {
               this.FInventory.StubReferences.Dereference(this);
            }
            if(param1 != null)
            {
               param1.StubReferences.Reference(this);
            }
            this.FInventory = param1;
            this.FTextureInventory = null;
            this.FCaptionInventory = null;
         }
      }
      
      override public function Reset() : void
      {
         super.Reset();
         this.FTextureInventory = null;
         this.FCaptionInventory = null;
         this.FSequenceSubstrate = null;
         this.FRepositoryTexture = null;
         if(this.FInventory != null)
         {
            this.FInventory.StubReferences.Dereference(this);
            this.FInventory = null;
         }
      }
      
      override public function Evaluate(param1:TBounds) : void
      {
         param1.Width = SIZE_ElementWidth;
         param1.Height = SIZE_ElementHeight;
      }
   }
}

