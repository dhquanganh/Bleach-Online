package Processors.Game.Lobby.QianKunARoll.Component
{
   import Foundation.Common.TAlignment;
   import Foundation.Common.TBounds;
   import Foundation.Common.TCoordinate;
   import Foundation.UI.TUIComponent;
   import Logics.DatebaseVO.VO.THomeGamble;
   import Logics.Inventories.TInventories;
   import Logics.Inventories.TInventory;
   import Logics.Streamization.Inventories.TUnstreamizerInventoryReference;
   import Rendering.Overlayers.TOverlayer;
   import Rendering.Texts.TPainterTextEffect;
   import Resources.Constants.CONST_COMMON;
   import flash.text.TextFormat;
   
   public class TOverlayerGambleBox extends TOverlayer
   {
      
      protected static const QUALITYCOLOR_None:uint = CONST_COMMON.QUALITYCOLOR_None;
      
      protected static const QUALITYCOLOR_White:uint = CONST_COMMON.QUALITYCOLOR_White;
      
      protected static const QUALITYCOLOR_Green:uint = CONST_COMMON.QUALITYCOLOR_Green;
      
      protected static const QUALITYCOLOR_Blue:uint = CONST_COMMON.QUALITYCOLOR_Blue;
      
      protected static const QUALITYCOLOR_Purple:uint = CONST_COMMON.QUALITYCOLOR_Purple;
      
      protected static const QUALITYCOLOR_Yellow:uint = CONST_COMMON.QUALITYCOLOR_Yellow;
      
      protected static const QUALITYCOLOR_Red:uint = CONST_COMMON.QUALITYCOLOR_Red;
      
      protected static const QUALITYCOLOR_Orange:uint = CONST_COMMON.QUALITYCOLOR_Orange;
      
      public static const QUALITYCOLOR_INDEX:Vector.<uint> = CONST_COMMON.QUALITYCOLOR_INDEX;
      
      protected var FPainterExplain:TPainterTextEffect;
      
      protected var FContextExplain:String;
      
      protected var FBoundsExplain:TBounds;
      
      protected var FBoundsOffsetY:TBounds;
      
      protected var FExplainTextFormat:TextFormat;
      
      protected var FIDTemplates:Vector.<uint>;
      
      protected var FInventories:TInventories;
      
      protected var FUnstreamizerInventoryReference:TUnstreamizerInventoryReference;
      
      public function TOverlayerGambleBox(param1:TUIComponent)
      {
         super(param1);
         this.FPainterExplain = ConstructPainterTextEffect(COLOR_ContextDefault);
         this.FBoundsExplain = new TBounds();
         this.FExplainTextFormat = new TextFormat();
         this.FIDTemplates = new Vector.<uint>();
         this.FInventories = new TInventories();
         this.FUnstreamizerInventoryReference = new TUnstreamizerInventoryReference();
      }
      
      override protected function ContextVerificate(param1:Object) : Boolean
      {
         return param1 is THomeGamble;
      }
      
      override protected function ContextSynchronize() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         this.FPainterExplain.Text = "";
         this.FContextExplain = "";
      }
      
      override protected function EvaluationPerform_Context() : void
      {
         this.EvaluationPerform_Explain();
         this.FBoundsOffsetY = this.FBoundsExplain;
      }
      
      override protected function SketchingPerform_Context() : void
      {
         this.SketchingPerform_Explain();
      }
      
      override protected function RenderingPerform_Context(param1:TCoordinate) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TBounds = null;
         var _loc7_:TPainterTextEffect = null;
         _loc6_ = new TBounds();
         this.FPainterExplain.x = 15;
         this.FPainterExplain.y = 10;
      }
      
      protected function EvaluationPerform_Explain() : void
      {
         var _loc1_:THomeGamble = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TInventory = null;
         var _loc5_:uint = 0;
         _loc1_ = FContext as THomeGamble;
         this.FContextExplain = "";
         this.FIDTemplates.length = 0;
         _loc3_ = int(_loc1_.AwardBoxVect.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(_loc1_.AwardBoxVect[_loc2_].type != 1)
            {
               _loc5_ = CONST_COMMON.RewardIDToTemplateID(_loc1_.AwardBoxVect[_loc2_].type,_loc1_.AwardBoxVect[_loc2_].code);
            }
            else
            {
               _loc5_ = uint(_loc1_.AwardBoxVect[_loc2_].code);
            }
            this.FIDTemplates.push(_loc5_);
            _loc2_++;
         }
         this.FInventories.Clear();
         this.FUnstreamizerInventoryReference.UnstreamizeGenerateInventoriesByIdentifiers(null,this.FInventories,this.FIDTemplates);
         _loc2_ = 0;
         while(_loc2_ < this.FInventories.Count)
         {
            _loc4_ = this.FInventories.GetInventoryByIndex(_loc2_);
            this.FContextExplain += _loc4_.Name + "x" + _loc1_.AwardBoxVect[_loc2_].amount + "\n";
            _loc2_++;
         }
         BoundsAlignDown(this.FBoundsExplain);
         this.FPainterExplain.Text = this.FContextExplain;
         this.FPainterExplain.Evaluate(this.FBoundsExplain);
         BoundsContextUnion(this.FBoundsExplain);
      }
      
      protected function SketchingPerform_Explain() : void
      {
         var _loc1_:TInventory = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         this.FPainterExplain.RenderBounds(this.FBoundsExplain,TAlignment.HORIZONTAL_Center);
         _loc4_ = 0;
         while(_loc4_ < this.FInventories.Count)
         {
            _loc1_ = this.FInventories.GetInventoryByIndex(_loc4_);
            this.FExplainTextFormat.color = QUALITYCOLOR_INDEX[_loc1_.Quality];
            _loc3_ = this.FContextExplain.indexOf("\n",_loc2_ + 1);
            this.FPainterExplain.SetTextFormat(this.FExplainTextFormat,_loc2_,_loc3_);
            _loc2_ = _loc3_;
            _loc4_++;
         }
      }
   }
}

