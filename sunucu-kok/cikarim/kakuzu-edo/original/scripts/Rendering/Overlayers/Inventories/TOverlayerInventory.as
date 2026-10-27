package Rendering.Overlayers.Inventories
{
   import Components.Standard.*;
   import Foundation.Common.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Repositories.*;
   import Foundation.Resources.Textures.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.Inventories.*;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Rendering.Overlayers.*;
   import Rendering.Texts.*;
   import Resources.Constants.*;
   import Resources.Strings.*;
   import Utilities.Timing.TUtilityTiming;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   import flash.utils.*;
   
   public class TOverlayerInventory extends TOverlayer
   {
      
      protected static const SIZE_DividingLineOffset:uint = 3;
      
      protected static const SIZE_Padding_01:uint = 3;
      
      protected static const SIZE_Padding_02:uint = 5;
      
      protected static const SIZE_Padding_03:uint = 10;
      
      protected static const SIZE_Padding_04:uint = 15;
      
      protected static const SIZE_Context_00:uint = 14;
      
      protected static const COLOR_Context_White:uint = 4294967295;
      
      protected static const COLOR_Context_Title:uint = 4293162496;
      
      protected static const COLOR_Context_00:uint = 4294967040;
      
      protected static const COLOR_Context_01:uint = 4293162496;
      
      protected static const COLOR_Context_02:uint = 4294967040;
      
      protected static const COLOR_Context_03:uint = 4294890346;
      
      protected static const COLOR_Context_Invalid:uint = 4287730065;
      
      protected static const COLOR_Context_Unknown:uint = 4278255615;
      
      protected static const COLOR_Context_Attributes:uint = 4278255360;
      
      protected static const COLOR_Context_Explanation:uint = 4290086742;
      
      protected static const SIZE_Image_Width:uint = 42;
      
      protected static const SIZE_Image_Height:uint = 42;
      
      protected static const SIZE_DefaultIcon_Width:uint = 40;
      
      protected static const SIZE_DefaultIcon_Height:uint = 40;
      
      protected static const QUALITYCOLOR_INVENTORY_INDEX:Vector.<uint> = CONST_INVENTORY.QUALITYCOLOR_INVENTORY_INDEX;
      
      protected var FQuerySequenceTimer:Timer;
      
      protected var FInventoryIcon:TUIImage;
      
      protected var FPainterCaption:TPainterTextEffect;
      
      protected var FPainterSalePrice:TPainterTextEffect;
      
      protected var FPainterTimingTime:TPainterTextEffect;
      
      protected var FBoundsImage:TBounds;
      
      protected var FBoundsCaption:TBounds;
      
      protected var FBoundsSalePrice:TBounds;
      
      protected var FBoundsTimingTime:TBounds;
      
      protected var FBoundsOffset:TBounds;
      
      protected var FDividingLinePartTimingTime:Bitmap;
      
      protected var FBoundsPartTimingTime:TBounds;
      
      protected var FTextFormat:TextFormat;
      
      protected var FTextFormatCaptionA:TextFormat;
      
      protected var FTextFormatCaptionB:TextFormat;
      
      protected var FContextIdentifier:uint;
      
      protected var FContextIDTemplate:uint;
      
      protected var FContextTimingTime:uint;
      
      protected var FIsEquiped:Boolean;
      
      public function TOverlayerInventory(param1:TUIComponent)
      {
         var _loc2_:int = 0;
         var _loc3_:TBounds = null;
         var _loc4_:TPainterTextEffect = null;
         super(param1);
         this.FPainterCaption = this.ConstructPainterTextEffect();
         this.FPainterCaption.Font.Bold = true;
         this.FBoundsCaption = new TBounds();
         this.FPainterSalePrice = this.ConstructPainterTextEffect(COLOR_Context_00);
         this.FBoundsSalePrice = new TBounds();
         this.FPainterTimingTime = this.ConstructPainterTextEffect(COLOR_Context_White);
         this.FBoundsTimingTime = new TBounds();
         this.FDividingLinePartTimingTime = new Bitmap();
         addChild(this.FDividingLinePartTimingTime);
         this.FBoundsPartTimingTime = new TBounds();
         this.FTextFormat = new TextFormat();
         FMarginLeft = 10;
         FMarginTop = 15;
         FMarginRight = 1;
         FMarginBottom = 5;
         this.FIsEquiped = false;
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         this.FDividingLinePartTimingTime.bitmapData = FDividingLine;
      }
      
      override protected function ConstructPainterTextEffect(param1:uint = 4294958161) : TPainterTextEffect
      {
         var _loc2_:TPainterTextEffect = null;
         return super.ConstructPainterTextEffect(param1);
      }
      
      override protected function ContextVerificate(param1:Object) : Boolean
      {
         return param1 is TInventory;
      }
      
      override protected function ContextSynchronize() : void
      {
         super.ContextSynchronize();
      }
      
      protected function ResetTextFormat() : void
      {
         this.FTextFormat.bold = null;
         this.FTextFormat.color = null;
         this.FTextFormat.font = null;
         this.FTextFormat.indent = null;
         this.FTextFormat.kerning = null;
         this.FTextFormat.leading = null;
         this.FTextFormat.letterSpacing = null;
         this.FTextFormat.size = null;
      }
      
      protected function EvaluationPerform_Caption(param1:TInventory) : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         BoundsAlignRight(this.FBoundsCaption,null,SIZE_Padding_01);
         _loc2_ = param1.Name;
         _loc4_ = 0;
         if(!this.FIsEquiped)
         {
            this.FPainterCaption.Text = _loc2_;
            this.FPainterCaption.Font.Size = SIZE_Context_00;
            this.FPainterCaption.Font.Color = QUALITYCOLOR_INVENTORY_INDEX[param1.Quality];
         }
         else
         {
            _loc3_ = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.FORMAT_INVENTORY_Equiped),_loc2_);
            this.FPainterCaption.Text = _loc3_;
            this.FTextFormatCaptionA.color = 16755236;
            this.FTextFormatCaptionA.size = SIZE_Context_00;
            this.FTextFormatCaptionB.color = QUALITYCOLOR_INVENTORY_INDEX[param1.Quality];
            this.FTextFormatCaptionB.size = SIZE_Context_00;
            this.FPainterCaption.Evaluate(this.FBoundsCaption);
            _loc5_ = _loc3_.length - _loc2_.length;
            this.FPainterCaption.SetTextFormat(this.FTextFormatCaptionA,_loc4_,_loc5_);
            this.FPainterCaption.SetTextFormat(this.FTextFormatCaptionB,_loc5_,_loc3_.length);
         }
         this.FBoundsCaption.Y -= 5;
         this.FPainterCaption.Evaluate(this.FBoundsCaption);
         BoundsContextUnion(this.FBoundsCaption);
      }
      
      protected function EvaluationPerform_SalePrice(param1:TInventory) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         BoundsAlignDown(this.FBoundsSalePrice,this.FBoundsOffset,SIZE_Padding_02);
         _loc3_ = param1.SellValue + param1.SellingValue;
         _loc4_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.FORMAT_INVENTORY_SalePrice);
         _loc2_ = _loc4_.length - "%0".length;
         this.FPainterSalePrice.Text = TUtilityString.Format(_loc4_,_loc3_);
         this.ResetTextFormat();
         this.FTextFormat.color = COLOR_Context_Title;
         this.FPainterSalePrice.Evaluate(this.FBoundsSalePrice);
         this.FPainterSalePrice.SetTextFormat(this.FTextFormat,0,_loc2_);
         BoundsContextUnion(this.FBoundsSalePrice);
      }
      
      protected function EvaluationPerform_PartTimingTime(param1:TInventory) : void
      {
         this.FBoundsPartTimingTime.Width = this.FDividingLinePartTimingTime.width;
         this.FBoundsPartTimingTime.Height = this.FDividingLinePartTimingTime.height;
         BoundsAlignDown(this.FBoundsPartTimingTime,this.FBoundsOffset,SIZE_Padding_02);
         this.FBoundsPartTimingTime.X = 0;
         BoundsContextUnion(this.FBoundsPartTimingTime);
      }
      
      protected function EvaluationPerform_TimingTime(param1:TInventory) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:String = null;
         var _loc4_:String = null;
         BoundsAlignDown(this.FBoundsTimingTime,this.FBoundsOffset,SIZE_Padding_02);
         _loc2_ = param1.TimingTime;
         _loc3_ = TUtilityTiming.FormatDHMSBySeconds(_loc2_);
         this.FPainterTimingTime.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.FORMAT_INVENTORY_TimingTime),_loc3_);
         this.FPainterTimingTime.Evaluate(this.FBoundsTimingTime);
         BoundsContextUnion(this.FBoundsTimingTime);
      }
      
      override protected function Reset() : void
      {
         super.Reset();
         if(this.FInventoryIcon != null)
         {
            this.FInventoryIcon.Sequence = null;
         }
      }
      
      protected function TimeQuerySequence(param1:TimerEvent) : void
      {
         var _loc2_:TInventory = null;
         var _loc3_:TResourceRepositoryTexture = null;
         var _loc4_:TTexture = null;
         if(FContext == null)
         {
            return;
         }
         _loc2_ = FContext as TInventory;
         _loc3_ = SResourcesCore.TexturesInventory;
         _loc4_ = _loc3_.GetTextureByIdentifier(_loc2_.IDTexture);
         if(_loc4_ != null)
         {
            this.FInventoryIcon.Sequence = _loc4_.GetAnimationSequenceByIdentifier(0);
            this.FQuerySequenceTimer.reset();
            this.FQuerySequenceTimer.stop();
         }
         else
         {
            _loc3_.LoadSecondary(_loc2_.IDTexture);
            this.FQuerySequenceTimer.reset();
            if(!this.FQuerySequenceTimer.running)
            {
               this.FQuerySequenceTimer.start();
            }
         }
      }
      
      public function get IsEquiped() : Boolean
      {
         return this.FIsEquiped;
      }
      
      public function set IsEquiped(param1:Boolean) : void
      {
         if(param1 != this.FIsEquiped)
         {
            this.FIsEquiped = param1;
            FModified = true;
         }
      }
   }
}

