package Rendering.Overlayers.Pet
{
   import Foundation.Common.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Repositories.*;
   import Foundation.Resources.Textures.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.Pet.*;
   import Rendering.Overlayers.*;
   import Resources.Constants.*;
   import Resources.Strings.*;
   import flash.display.*;
   import flash.events.*;
   import flash.utils.*;
   
   public class TOverlayerPet extends TOverlayer
   {
      
      protected static const SIZE_WordWrapWidth:uint = 150;
      
      public static const CAPACITY_BASEATTRIBUTE:int = CONST_PET.CAPACITY_BASEATTRIBUTE;
      
      public static const CAPACITY_PVPATTRIBUTE:int = CONST_PET.CAPACITY_PVPATTRIBUTE;
      
      protected var FQuerySequenceTimer:Timer;
      
      protected var FResource:Sprite;
      
      protected var FBoundsOffset:TBounds;
      
      protected var FPetIcon:Bitmap;
      
      protected var FContextIDTemplate:uint;
      
      protected var FIdentifier0:uint;
      
      protected var FIdentifier1:uint;
      
      public function TOverlayerPet(param1:TUIComponent)
      {
         super(param1);
         this.FQuerySequenceTimer = new Timer(500,1);
         this.FQuerySequenceTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.TimeQuerySequence);
         FWordWrapWidth = SIZE_WordWrapWidth;
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:Sprite = null;
         this.FResource = TUtilityReflection.CreateDisplayObjectInstance("SP_PetTips") as Sprite;
         if(this.FResource == null)
         {
            return;
         }
         this.addChild(this.FResource);
         _loc1_ = this.FResource["MC_Icon"]["SP_Bmp_Icon"];
         this.FPetIcon = new Bitmap();
         _loc1_.addChild(this.FPetIcon);
         FMarginBottom = this.FResource.height;
         FOvarlaySubstrate.visible = false;
      }
      
      override protected function ContextVerificate(param1:Object) : Boolean
      {
         return param1 is TPetBase;
      }
      
      override protected function ContextModified() : Boolean
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:TPetBase = null;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:Boolean = false;
         _loc3_ = FContext as TPetBase;
         _loc4_ = _loc3_.Level;
         _loc5_ = _loc3_.GetTemplateIDByLevel(_loc4_);
         _loc6_ = _loc3_.Identifier0;
         _loc7_ = _loc3_.Identifier1;
         return this.FContextIDTemplate != _loc5_ || this.FIdentifier0 != _loc6_ || this.FIdentifier1 != _loc7_;
      }
      
      override protected function ContextSynchronize() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:TPetBase = null;
         var _loc4_:uint = 0;
         _loc3_ = FContext as TPetBase;
         _loc4_ = _loc3_.Level;
         this.FContextIDTemplate = _loc3_.GetTemplateIDByLevel(_loc4_);
         this.FIdentifier0 = _loc3_.Identifier0;
         this.FIdentifier1 = _loc3_.Identifier1;
      }
      
      override protected function EvaluationPerform_Icon() : void
      {
         var _loc1_:TPetBase = null;
         var _loc2_:TAnimationSequence = null;
         this.FPetIcon.bitmapData = null;
         _loc1_ = FContext as TPetBase;
         _loc2_ = SResourcesCore.TexturesHeadIcon.GetAnimationSequenceByIdentifiers(_loc1_.HeadIconID,0);
         if(_loc2_ != null)
         {
            this.FPetIcon.bitmapData = _loc2_.GetAnimationFrameByIndex(0).Surface;
         }
         else
         {
            this.FPetIcon.bitmapData = null;
            if(!this.FQuerySequenceTimer.running)
            {
               this.FQuerySequenceTimer.start();
            }
         }
      }
      
      override protected function EvaluationPerform_Context() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:TPetBase = null;
         _loc3_ = FContext as TPetBase;
         this.FResource["TF_Name"].text = _loc3_.Name;
         this.FResource["TF_Level"].text = TUtilityString.Format(STRING_COMMON.FORMAT_05,_loc3_.Level);
         _loc1_ = 0;
         while(_loc1_ < CAPACITY_BASEATTRIBUTE)
         {
            this.FResource["MC_BaseAttribute_" + _loc1_].gotoAndStop(_loc3_.GetBaseAttributeByIndex(_loc1_) + 1);
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < CAPACITY_PVPATTRIBUTE)
         {
            this.FResource["TF_BaseAttribute_" + _loc1_].text = _loc3_.GetPvPAttributeByIndex(_loc1_);
            _loc1_++;
         }
      }
      
      override protected function RenderingPerform_Context(param1:TCoordinate) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TBounds = null;
         FBoundsRendering.X = FMarginLeft;
         FBoundsRendering.Y = FMarginTop;
         this.FResource.x = FBoundsRendering.X;
         this.FResource.y = FBoundsRendering.Y;
      }
      
      override protected function Reset() : void
      {
         super.Reset();
         if(this.FPetIcon != null)
         {
            this.FPetIcon.bitmapData = null;
         }
      }
      
      protected function TimeQuerySequence(param1:TimerEvent) : void
      {
         var _loc2_:TPetBase = null;
         var _loc3_:TResourceRepositoryTexture = null;
         var _loc4_:TTexture = null;
         if(FContext == null)
         {
            return;
         }
         _loc2_ = FContext as TPetBase;
         _loc3_ = SResourcesCore.TexturesHeadIcon;
         _loc4_ = _loc3_.GetTextureByIdentifier(_loc2_.HeadIconID);
         if(_loc4_ != null)
         {
            this.FPetIcon.bitmapData = _loc4_.GetAnimationSequenceByIdentifier(0).GetAnimationFrameByIndex(0).Surface;
            this.FQuerySequenceTimer.reset();
            this.FQuerySequenceTimer.stop();
         }
         else
         {
            _loc3_.LoadSecondary(_loc2_.HeadIconID);
            this.FQuerySequenceTimer.reset();
            if(!this.FQuerySequenceTimer.running)
            {
               this.FQuerySequenceTimer.start();
            }
         }
      }
      
      public function get Resource() : Sprite
      {
         return this.FResource;
      }
      
      public function set Resource(param1:Sprite) : void
      {
         this.FResource = param1;
      }
   }
}

