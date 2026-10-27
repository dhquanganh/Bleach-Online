package Rendering.Overlayers.Inventories
{
   import Components.Standard.*;
   import Foundation.Common.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Textures.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.Inventories.*;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Rendering.Overlayers.*;
   import Rendering.Texts.*;
   import Resources.Constants.*;
   import Resources.Strings.*;
   import flash.text.*;
   
   public class TOverlayerAppliance extends TOverlayerInventory
   {
      
      protected static const SIZE_DividingLine_Max_Width:uint = 293;
      
      protected static const SIZE_DividingLine_Min_Width:uint = 270;
      
      protected static const SIZE_TextFormat_leading:uint = 2;
      
      protected static const SIZE_WordWrapWidth:uint = 100;
      
      protected static const SIZE_Padding_01:uint = 5;
      
      protected static const SIZE_Padding_03:uint = 10;
      
      protected static const SIZE_WordWrapWidthDefault:uint = 500;
      
      protected var FPainterRequirementLevel:TPainterTextEffect;
      
      protected var FPainterDescCaption:TPainterTextEffect;
      
      protected var FPainterDesc:TPainterHtmlTextEffect;
      
      protected var FBoundsRequirementLevel:TBounds;
      
      protected var FBoundsDescCaption:TBounds;
      
      protected var FBoundsDesc:TBounds;
      
      public function TOverlayerAppliance(param1:TUIComponent)
      {
         super(param1);
         FWordWrapWidth = 300;
         this.FPainterRequirementLevel = ConstructPainterTextEffect(COLOR_Context_White);
         this.FBoundsRequirementLevel = new TBounds();
         this.FPainterDescCaption = ConstructPainterTextEffect(COLOR_Context_Title);
         this.FBoundsDescCaption = new TBounds();
         this.FPainterDesc = this.ConstructPainterHtmlTextEffect(COLOR_Context_Explanation);
         this.FBoundsDesc = new TBounds();
         FMarginLeft = 15;
         FMarginTop = 15;
         FMarginRight = 15;
         FMarginBottom = 15;
      }
      
      override protected function ConstructPainterHtmlTextEffect(param1:uint = 4294958161) : TPainterHtmlTextEffect
      {
         var _loc2_:TPainterHtmlTextEffect = null;
         _loc2_ = super.ConstructPainterHtmlTextEffect(param1);
         _loc2_.WordWrap = true;
         _loc2_.Multilineable = true;
         return _loc2_;
      }
      
      override protected function ContextVerificate(param1:Object) : Boolean
      {
         return param1 is TAppliance;
      }
      
      override protected function ContextModified() : Boolean
      {
         var _loc1_:Boolean = false;
         var _loc2_:TAppliance = null;
         _loc2_ = FContext as TAppliance;
         return FContextIdentifier != _loc2_.Identifier || FContextIDTemplate != _loc2_.IDTemplate || FContextTimingTime != _loc2_.TimingTime;
      }
      
      override protected function ContextSynchronize() : void
      {
         var _loc1_:TAppliance = null;
         _loc1_ = FContext as TAppliance;
         FContextIdentifier = _loc1_.Identifier;
         FContextIDTemplate = _loc1_.IDTemplate;
         FContextTimingTime = _loc1_.TimingTime;
         FDividingLinePartTimingTime.width = SIZE_DividingLine_Min_Width;
         super.ContextSynchronize();
      }
      
      override protected function EvaluationPerform_Context() : void
      {
         var _loc1_:TAppliance = null;
         _loc1_ = FContext as TAppliance;
         this.EvaluationPerform_Caption(_loc1_);
         FBoundsOffset = FBoundsCaption;
         this.EvaluationPerform_RequirementLevel(_loc1_);
         FBoundsOffset = this.FBoundsRequirementLevel;
         this.EvaluationPerform_DescCaption(_loc1_);
         FBoundsOffset = this.FBoundsDescCaption;
         this.EvaluationPerform_Desc(_loc1_);
         FBoundsOffset = this.FBoundsDesc;
         this.EvaluationPerform_SalePrice(_loc1_);
         FBoundsOffset = FBoundsSalePrice;
         if(_loc1_.TimingTime > 0)
         {
            FPainterTimingTime.Visible = true;
            FDividingLinePartTimingTime.visible = true;
            EvaluationPerform_PartTimingTime(null);
            FBoundsOffset = FBoundsPartTimingTime;
            EvaluationPerform_TimingTime(_loc1_);
            FBoundsOffset = FBoundsTimingTime;
         }
         else
         {
            FPainterTimingTime.Visible = false;
            FDividingLinePartTimingTime.visible = false;
         }
      }
      
      override protected function EvaluationPerform_Caption(param1:TInventory) : void
      {
         var _loc2_:String = null;
         BoundsAlignDown(FBoundsCaption,null,SIZE_Padding_01);
         _loc2_ = param1.Name;
         FPainterCaption.Text = _loc2_;
         FPainterCaption.Font.Size = SIZE_Context_00;
         FPainterCaption.Font.Color = QUALITYCOLOR_INVENTORY_INDEX[param1.Quality];
         FBoundsCaption.Y -= 5;
         FPainterCaption.Evaluate(FBoundsCaption);
         BoundsContextUnion(FBoundsCaption);
      }
      
      protected function EvaluationPerform_RequirementLevel(param1:TAppliance) : void
      {
         var _loc2_:int = 0;
         var _loc3_:String = null;
         BoundsAlignDown(this.FBoundsRequirementLevel,FBoundsOffset,SIZE_Padding_01);
         _loc3_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.FORMAT_APPLIANCE_RequirementLevel);
         _loc2_ = _loc3_.length - TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.FORMAT_APPLIANCE_01).length;
         this.FPainterRequirementLevel.Text = TUtilityString.Format(_loc3_,param1.RequirementLevel);
         ResetTextFormat();
         FTextFormat.size = this.FPainterRequirementLevel.Font.Size;
         FTextFormat.color = COLOR_Context_Title;
         this.FPainterRequirementLevel.Evaluate(this.FBoundsRequirementLevel);
         this.FPainterRequirementLevel.SetTextFormat(FTextFormat,0,_loc2_);
         BoundsContextUnion(this.FBoundsRequirementLevel);
      }
      
      protected function EvaluationPerform_DescCaption(param1:TAppliance) : void
      {
         BoundsAlignDown(this.FBoundsDescCaption,FBoundsOffset,SIZE_Padding_01);
         this.FPainterDescCaption.Text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.FORMAT_APPLIANCE_DescCaption);
         this.FPainterDescCaption.Evaluate(this.FBoundsDescCaption);
         BoundsContextUnion(this.FBoundsDescCaption);
      }
      
      protected function EvaluationPerform_Desc(param1:TAppliance) : void
      {
         BoundsAlignRight(this.FBoundsDesc,FBoundsOffset);
         this.FPainterDesc.Text = param1.Description;
         this.FPainterDesc.Evaluate(this.FBoundsDesc);
         BoundsContextUnion(this.FBoundsDesc);
      }
      
      override protected function EvaluationPerform_SalePrice(param1:TInventory) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         BoundsAlignDown(FBoundsSalePrice,FBoundsOffset,SIZE_Padding_01);
         _loc3_ = int(param1.SellValue);
         _loc5_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.FORMAT_INVENTORY_SalePrice);
         _loc4_ = _loc5_.length - "%0".length;
         FPainterSalePrice.Text = TUtilityString.Format(_loc5_,_loc3_);
         ResetTextFormat();
         FTextFormat.color = COLOR_Context_Title;
         FBoundsSalePrice.X = 0;
         FPainterSalePrice.Evaluate(FBoundsSalePrice);
         FPainterSalePrice.SetTextFormat(FTextFormat,0,_loc4_);
         BoundsContextUnion(FBoundsSalePrice);
      }
      
      override protected function SketchingPerform_Context() : void
      {
         var _loc1_:TAppliance = null;
         _loc1_ = FContext as TAppliance;
      }
      
      protected function SketchingPerform_Caption() : void
      {
         FPainterCaption.RenderBounds(FBoundsCaption,TAlignment.HORIZONTAL_Left);
      }
      
      protected function SketchingPerform_RequirementLevel() : void
      {
         this.FPainterRequirementLevel.RenderBounds(this.FBoundsRequirementLevel,TAlignment.HORIZONTAL_Left);
      }
      
      protected function SketchingPerform_DescCaption() : void
      {
         this.FPainterDescCaption.RenderBounds(this.FBoundsDescCaption,TAlignment.HORIZONTAL_Left);
      }
      
      protected function SketchingPerform_Desc() : void
      {
         this.FPainterDesc.RenderBounds(this.FBoundsDesc,TAlignment.HORIZONTAL_Left);
      }
      
      protected function SketchingPerform_SalePrice() : void
      {
         FPainterSalePrice.RenderBounds(FBoundsSalePrice,TAlignment.HORIZONTAL_Left);
      }
      
      override protected function RenderingPerform_Context(param1:TCoordinate) : void
      {
         var _loc2_:TAppliance = null;
         _loc2_ = FContext as TAppliance;
         FBoundsRendering.X = FMarginLeft;
         FBoundsRendering.Y = FMarginTop;
         FPainterCaption.X = FBoundsRendering.X + FBoundsCaption.X;
         FPainterCaption.Y = FBoundsRendering.Y + FBoundsCaption.Y;
         this.FPainterRequirementLevel.X = FBoundsRendering.X + this.FBoundsRequirementLevel.X;
         this.FPainterRequirementLevel.Y = FBoundsRendering.Y + this.FBoundsRequirementLevel.Y;
         this.FPainterDescCaption.X = FBoundsRendering.X + this.FBoundsDescCaption.X;
         this.FPainterDescCaption.Y = FBoundsRendering.Y + this.FBoundsDescCaption.Y;
         this.FPainterDesc.X = FBoundsRendering.X + this.FBoundsDesc.X;
         this.FPainterDesc.Y = FBoundsRendering.Y + this.FBoundsDesc.Y;
         FPainterSalePrice.X = FBoundsRendering.X + FBoundsSalePrice.X;
         FPainterSalePrice.Y = FBoundsRendering.Y + FBoundsSalePrice.Y;
         if(_loc2_.TimingTime > 0)
         {
            FDividingLinePartTimingTime.x = FBoundsRendering.X + FBoundsPartTimingTime.X - FMarginLeft + SIZE_DividingLineOffset;
            FDividingLinePartTimingTime.y = FBoundsRendering.Y + FBoundsPartTimingTime.Y;
            FPainterTimingTime.X = FBoundsRendering.X + FBoundsTimingTime.X;
            FPainterTimingTime.Y = FBoundsRendering.Y + FBoundsTimingTime.Y;
         }
         FDividingLinePartTimingTime.width = SIZE_DividingLine_Max_Width;
      }
   }
}

