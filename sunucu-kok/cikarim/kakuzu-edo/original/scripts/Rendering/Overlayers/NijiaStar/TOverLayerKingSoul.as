package Rendering.Overlayers.NijiaStar
{
   import Foundation.Common.TBounds;
   import Foundation.Common.TCoordinate;
   import Foundation.Resources.Bins.TBins;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.TUIComponent;
   import Logics.DatebaseVO.VO.TSevenHeroDailyAward;
   import Logics.DatebaseVO.VO.TSevenHeroSoul;
   import Rendering.Overlayers.TOverlayer;
   import Rendering.Texts.TPainterTextEffect;
   import Resources.Constants.CONST_DATEBASEVO;
   
   public class TOverLayerKingSoul extends TOverlayer
   {
      
      protected static const COLOR_Context_White:uint = 4294967295;
      
      protected var FPainterCaption:TPainterTextEffect;
      
      protected var FPainterExplain:TPainterTextEffect;
      
      protected var FBoundsCaption:TBounds;
      
      protected var FBoundsExplain:TBounds;
      
      protected var FBoundsOffset:TBounds;
      
      public function TOverLayerKingSoul(param1:TUIComponent)
      {
         super(param1);
         this.FPainterCaption = ConstructPainterTextEffect(COLOR_Context_White);
         this.FBoundsCaption = new TBounds();
         this.FPainterExplain = ConstructPainterTextEffect(COLOR_Context_White);
         this.FBoundsExplain = new TBounds();
         this.FBoundsOffset = new TBounds();
         FMarginLeft = 15;
         FMarginTop = 15;
         FMarginRight = 1;
         FMarginBottom = 15;
      }
      
      override protected function EvaluationPerform_Context() : void
      {
         var _loc1_:TSevenHeroSoul = null;
         _loc1_ = FContext as TSevenHeroSoul;
         this.EvaluationPerform_Caption(_loc1_);
         this.FBoundsOffset = this.FBoundsCaption;
         this.EvaluationPerform_Explain(_loc1_);
      }
      
      protected function EvaluationPerform_Caption(param1:TSevenHeroSoul) : void
      {
         var _loc2_:int = 0;
         var _loc3_:uint = 0;
         var _loc4_:String = null;
         var _loc5_:uint = 0;
         var _loc6_:TSevenHeroDailyAward = null;
         var _loc7_:TBins = null;
         BoundsAlignDown(this.FBoundsCaption);
         if(FContext is TSevenHeroSoul)
         {
            param1 = FContext as TSevenHeroSoul;
            _loc4_ = param1.Name;
            _loc5_ = param1.TextColor;
         }
         else if(FContext is TSevenHeroDailyAward)
         {
            _loc6_ = FContext as TSevenHeroDailyAward;
            _loc4_ = _loc6_.Name;
            _loc7_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_SevenHeroSoul) as TBins;
            _loc3_ = uint(_loc7_.Count);
            _loc2_ = 0;
            while(_loc2_ < _loc3_)
            {
               param1 = _loc7_.GetDatebaseByIndex(_loc2_) as TSevenHeroSoul;
               if(param1.Heroid == _loc6_.Identifier)
               {
                  _loc5_ = param1.TextColor;
                  break;
               }
               _loc2_++;
            }
         }
         this.FPainterCaption.Text = _loc4_;
         this.FPainterCaption.Font.Color = _loc5_;
         this.FPainterCaption.Evaluate(this.FBoundsCaption);
         BoundsContextUnion(this.FBoundsCaption);
      }
      
      protected function EvaluationPerform_Explain(param1:TSevenHeroSoul) : void
      {
         var _loc2_:String = null;
         var _loc3_:TSevenHeroDailyAward = null;
         BoundsAlignDown(this.FBoundsExplain,this.FBoundsOffset);
         if(FContext is TSevenHeroSoul)
         {
            param1 = FContext as TSevenHeroSoul;
            _loc2_ = param1.Soultips;
         }
         else if(FContext is TSevenHeroDailyAward)
         {
            _loc3_ = FContext as TSevenHeroDailyAward;
            _loc2_ = _loc3_.Tips;
         }
         this.FPainterExplain.Text = _loc2_;
         this.FPainterExplain.Evaluate(this.FBoundsExplain);
         this.FBoundsExplain.X += 15;
         BoundsContextUnion(this.FBoundsExplain);
      }
      
      override protected function RenderingPerform_Context(param1:TCoordinate) : void
      {
         FBoundsRendering.X = FMarginLeft;
         FBoundsRendering.Y = FMarginTop;
         this.FPainterCaption.x = FBoundsRendering.X;
         this.FPainterCaption.y = FBoundsRendering.Y + this.FBoundsCaption.Y;
         this.FPainterExplain.x = this.FBoundsExplain.X;
         this.FPainterExplain.y = FBoundsRendering.Y + this.FBoundsExplain.Y;
      }
   }
}

