package Rendering.Overlayers.NijiaStar
{
   import Foundation.Common.TAlignment;
   import Foundation.Common.TBounds;
   import Foundation.Common.TCoordinate;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityString;
   import Logics.NijiaStar.TNijiaStar;
   import Logics.NijiaStar.TNijiaStarAtom;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Rendering.Overlayers.TOverlayer;
   import Rendering.Texts.TPainterTextEffect;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.display.Bitmap;
   import flash.text.TextFormat;
   
   public class TOverlayerNijiaStarSubPoint extends TOverlayer
   {
      
      protected static const SIZE_DividingLineOffset:uint = 3;
      
      protected static const CAPACITY_AppendAttributes:uint = 6;
      
      protected static const SIZE_Padding_01:uint = 3;
      
      protected static const SIZE_Padding_02:uint = 5;
      
      protected static const SIZE_Padding_03:uint = 15;
      
      protected static const COLOR_Context_White:uint = 4294967295;
      
      protected static const COLOR_Context_Red:uint = 4294836224;
      
      protected static const COLOR_Context_Green:uint = 4285071106;
      
      protected static const COLOR_Context_AppendAttributes:uint = 4284940032;
      
      protected static const SIZE_DividingLine_Max_Width:uint = 280;
      
      protected static const SIZE_DividingLine_Min_Width:uint = 270;
      
      protected var FPainterCaption:TPainterTextEffect;
      
      protected var FPainterExplainCaption:TPainterTextEffect;
      
      protected var FPainterAttributeCaption:TPainterTextEffect;
      
      protected var FPainterAppendAttributes:Vector.<TPainterTextEffect>;
      
      protected var FPainterActivateCaption:TPainterTextEffect;
      
      protected var FBoundsCaption:TBounds;
      
      protected var FBoundsExplainCaption:TBounds;
      
      protected var FBoundsPartCaption:TBounds;
      
      protected var FBoundsAttributeCaption:TBounds;
      
      protected var FBoundsAppendAttributes:Vector.<TBounds>;
      
      protected var FBoundsPartAttribute:TBounds;
      
      protected var FBoundsActivateCaption:TBounds;
      
      protected var FTextFormatCaptionA:TextFormat;
      
      protected var FBoundsOffset:TBounds;
      
      protected var FDividingLinePartCaption:Bitmap;
      
      protected var FDividingLinePartAttribute:Bitmap;
      
      protected var FCaptionName:String;
      
      protected var FIsActivated:Boolean;
      
      protected var FSubContext:Object;
      
      public function TOverlayerNijiaStarSubPoint(param1:TUIComponent)
      {
         var _loc2_:int = 0;
         var _loc3_:TBounds = null;
         var _loc4_:TPainterTextEffect = null;
         super(param1);
         this.FPainterCaption = ConstructPainterTextEffect(COLOR_Context_Red);
         this.FBoundsCaption = new TBounds();
         this.FPainterExplainCaption = ConstructPainterTextEffect(COLOR_Context_White);
         this.FBoundsExplainCaption = new TBounds();
         this.FPainterAttributeCaption = ConstructPainterTextEffect(COLOR_Context_White);
         this.FBoundsAttributeCaption = new TBounds();
         this.FPainterAppendAttributes = new Vector.<TPainterTextEffect>(CAPACITY_AppendAttributes);
         this.FBoundsAppendAttributes = new Vector.<TBounds>(CAPACITY_AppendAttributes);
         _loc2_ = 0;
         while(_loc2_ < CAPACITY_AppendAttributes)
         {
            _loc4_ = ConstructPainterTextEffect(COLOR_Context_AppendAttributes);
            this.FPainterAppendAttributes[_loc2_] = _loc4_;
            _loc3_ = new TBounds();
            this.FBoundsAppendAttributes[_loc2_] = _loc3_;
            _loc2_++;
         }
         this.FPainterActivateCaption = ConstructPainterTextEffect(COLOR_Context_White);
         this.FBoundsActivateCaption = new TBounds();
         this.FDividingLinePartCaption = new Bitmap();
         this.FDividingLinePartAttribute = new Bitmap();
         addChild(this.FDividingLinePartCaption);
         addChild(this.FDividingLinePartAttribute);
         this.FBoundsPartCaption = new TBounds();
         this.FBoundsPartAttribute = new TBounds();
         this.FTextFormatCaptionA = new TextFormat();
         FMarginLeft = 15;
         FMarginTop = 15;
         FMarginRight = 1;
         FMarginBottom = 15;
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         this.FDividingLinePartCaption.bitmapData = FDividingLine;
         this.FDividingLinePartAttribute.bitmapData = FDividingLine;
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ContextModified() : Boolean
      {
         var _loc1_:TNijiaStar = null;
         var _loc2_:TNijiaStarAtom = null;
         var _loc3_:Boolean = false;
         if(FContext is TNijiaStarAtom)
         {
            _loc2_ = FContext as TNijiaStarAtom;
            _loc3_ = _loc2_.IsActivate != this.FIsActivated;
         }
         return _loc3_;
      }
      
      override protected function ContextSynchronize() : void
      {
         var _loc1_:TNijiaStar = null;
         _loc1_ = FContext as TNijiaStar;
         this.FDividingLinePartCaption.width = SIZE_DividingLine_Min_Width;
         this.FDividingLinePartAttribute.width = SIZE_DividingLine_Min_Width;
      }
      
      override protected function EvaluationPerform_Context() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TNijiaStar = null;
         var _loc4_:TPainterTextEffect = null;
         _loc3_ = FContext as TNijiaStar;
         this.EvaluationPerform_Caption(_loc3_);
         this.FBoundsOffset = this.FBoundsCaption;
         this.EvaluationPerform_ExplainCaption(_loc3_);
         this.FBoundsOffset = this.FBoundsExplainCaption;
         this.EvaluationPerform_PartCaption(null);
         this.FBoundsOffset = this.FBoundsPartCaption;
         this.EvaluationPerform_AttributeCaption(_loc3_);
         this.FBoundsOffset = this.FBoundsAttributeCaption;
         this.EvaluationPerform_AppendAttributes(_loc3_);
         this.EvaluationPerform_PartAttribute(null);
         this.FBoundsOffset = this.FBoundsPartAttribute;
         this.EvaluationPerform_ActivateCaption(_loc3_);
      }
      
      protected function EvaluationPerform_Caption(param1:TNijiaStar) : void
      {
         var _loc2_:String = null;
         BoundsAlignDown(this.FBoundsCaption);
         if(FContext is TNijiaStar)
         {
            _loc2_ = param1.FinalStarName;
         }
         else if(FContext is TNijiaStarAtom)
         {
            _loc2_ = (FContext as TNijiaStarAtom).LittleStarName;
         }
         this.FPainterCaption.Text = _loc2_;
         this.FPainterCaption.Evaluate(this.FBoundsCaption);
         BoundsContextUnion(this.FBoundsCaption);
      }
      
      protected function EvaluationPerform_ExplainCaption(param1:TNijiaStar) : void
      {
         var _loc2_:String = null;
         var _loc3_:TNijiaStarAtom = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TNijiaStar = null;
         BoundsAlignDown(this.FBoundsExplainCaption);
         _loc6_ = this.FSubContext as TNijiaStar;
         if(FContext is TNijiaStar)
         {
            _loc2_ = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.NIJIASTAR_STRING_17),param1.FinalStarName);
            this.FPainterExplainCaption.Text = _loc2_;
            this.FPainterExplainCaption.Evaluate(this.FBoundsExplainCaption);
         }
         else if(FContext is TNijiaStarAtom)
         {
            _loc3_ = FContext as TNijiaStarAtom;
            _loc2_ = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.NIJIASTAR_STRING_18),_loc6_.FinalStarName,_loc3_.CostSoul);
            this.FIsActivated = _loc3_.IsActivate;
            if(this.FIsActivated)
            {
               _loc2_ += TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.NIJIASTAR_STRING_20);
               this.FTextFormatCaptionA.color = COLOR_Context_Green;
            }
            else
            {
               _loc2_ += TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.NIJIASTAR_STRING_19);
               this.FTextFormatCaptionA.color = COLOR_Context_Red;
            }
            this.FPainterExplainCaption.Text = _loc2_;
            this.FPainterExplainCaption.Evaluate(this.FBoundsExplainCaption);
            _loc4_ = _loc2_.length - 5;
            _loc5_ = _loc2_.length;
            this.FPainterExplainCaption.SetTextFormat(this.FTextFormatCaptionA,_loc4_,_loc5_);
         }
         this.FBoundsExplainCaption.X += 15;
         BoundsContextUnion(this.FBoundsExplainCaption);
      }
      
      protected function EvaluationPerform_PartCaption(param1:TNijiaStar) : void
      {
         this.FBoundsPartCaption.Width = this.FDividingLinePartCaption.width;
         this.FBoundsPartCaption.Height = this.FDividingLinePartCaption.height;
         BoundsAlignDown(this.FBoundsPartCaption,this.FBoundsOffset,SIZE_Padding_02);
         this.FBoundsPartCaption.X = 0;
         BoundsContextUnion(this.FBoundsPartCaption);
      }
      
      protected function EvaluationPerform_AttributeCaption(param1:TNijiaStar) : void
      {
         BoundsAlignDown(this.FBoundsAttributeCaption,this.FBoundsOffset,SIZE_Padding_02);
         this.FPainterAttributeCaption.Text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.NIJIASTAR_STRING_21);
         this.FPainterAttributeCaption.Evaluate(this.FBoundsAttributeCaption);
         BoundsContextUnion(this.FBoundsAttributeCaption);
      }
      
      protected function EvaluationPerform_AppendAttributes(param1:TNijiaStar) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TBounds = null;
         var _loc5_:TPainterTextEffect = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:TNijiaStarAtom = null;
         _loc3_ = int(CAPACITY_AppendAttributes);
         _loc2_ = 0;
         while(_loc2_ < CAPACITY_AppendAttributes)
         {
            _loc4_ = this.FBoundsAppendAttributes[_loc2_];
            BoundsAlignDown(_loc4_,this.FBoundsOffset);
            this.FBoundsOffset = _loc4_;
            _loc5_ = this.FPainterAppendAttributes[_loc2_];
            _loc7_ = TUtilityLobby.GetStringsByIdentifier(CONST_SYSTEMLANGUAGE.STRINGS_ATTRIBUTENIJIASTAR)[_loc2_];
            if(FContext is TNijiaStar)
            {
               param1 = FContext as TNijiaStar;
               _loc6_ = "" + param1.ExtraAddValues[_loc2_];
            }
            else if(FContext is TNijiaStarAtom)
            {
               _loc8_ = FContext as TNijiaStarAtom;
               _loc6_ = "" + _loc8_.AddValues[_loc2_];
            }
            _loc5_.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.NIJIASTAR_STRING_12),_loc7_,_loc6_);
            _loc5_.Evaluate(_loc4_);
            BoundsContextUnion(_loc4_);
            _loc2_++;
         }
      }
      
      protected function EvaluationPerform_PartAttribute(param1:TNijiaStar) : void
      {
         this.FBoundsPartAttribute.Width = this.FDividingLinePartAttribute.width;
         this.FBoundsPartAttribute.Height = this.FDividingLinePartAttribute.height;
         BoundsAlignDown(this.FBoundsPartAttribute,this.FBoundsOffset,SIZE_Padding_02);
         this.FBoundsPartAttribute.X = 0;
         BoundsContextUnion(this.FBoundsPartAttribute);
      }
      
      protected function EvaluationPerform_ActivateCaption(param1:TNijiaStar) : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:TNijiaStar = null;
         BoundsAlignDown(this.FBoundsActivateCaption);
         if(FContext is TNijiaStar)
         {
            _loc4_ = FContext as TNijiaStar;
         }
         else
         {
            _loc4_ = this.FSubContext as TNijiaStar;
         }
         _loc2_ = _loc4_.Desc;
         _loc3_ = _loc4_.FinalStarName;
         this.FPainterActivateCaption.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.NIJIASTAR_STRING_14),_loc2_,_loc3_);
         this.FPainterActivateCaption.Evaluate(this.FBoundsActivateCaption);
         this.FBoundsActivateCaption.Y += 5;
         BoundsContextUnion(this.FBoundsActivateCaption);
      }
      
      override protected function SketchingPerform_Context() : void
      {
         this.SketchingPerform_Caption();
      }
      
      protected function SketchingPerform_Caption() : void
      {
         this.FPainterCaption.RenderBounds(this.FBoundsCaption,TAlignment.HORIZONTAL_Left);
         this.FPainterAttributeCaption.RenderBounds(this.FBoundsAttributeCaption,TAlignment.HORIZONTAL_Left);
         this.FPainterActivateCaption.RenderBounds(this.FBoundsActivateCaption,TAlignment.HORIZONTAL_Left);
      }
      
      override protected function RenderingPerform_Context(param1:TCoordinate) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TBounds = null;
         var _loc7_:TPainterTextEffect = null;
         var _loc8_:TNijiaStar = null;
         _loc8_ = FContext as TNijiaStar;
         _loc6_ = new TBounds();
         FBoundsRendering.X = FMarginLeft;
         FBoundsRendering.Y = FMarginTop;
         this.FPainterCaption.x = FBoundsRendering.X;
         this.FPainterCaption.y = FBoundsRendering.Y + this.FBoundsCaption.Y;
         this.FPainterExplainCaption.x = this.FBoundsExplainCaption.X;
         this.FPainterExplainCaption.y = FBoundsRendering.Y + this.FBoundsExplainCaption.Y;
         this.FDividingLinePartCaption.x = FBoundsRendering.X + this.FBoundsPartCaption.X - FMarginLeft + SIZE_DividingLineOffset;
         this.FDividingLinePartCaption.y = FBoundsRendering.Y + this.FBoundsPartCaption.Y;
         this.FPainterAttributeCaption.x = FBoundsRendering.X;
         this.FPainterAttributeCaption.y = FBoundsRendering.Y + this.FBoundsAttributeCaption.Y;
         _loc3_ = int(CAPACITY_AppendAttributes);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc7_ = this.FPainterAppendAttributes[_loc2_];
            _loc6_ = this.FBoundsAppendAttributes[_loc2_];
            _loc7_.X = FBoundsRendering.X + _loc6_.X;
            _loc7_.Y = FBoundsRendering.Y + _loc6_.Y;
            _loc2_++;
         }
         this.FDividingLinePartAttribute.x = FBoundsRendering.X + this.FBoundsPartAttribute.X - FMarginLeft + SIZE_DividingLineOffset;
         this.FDividingLinePartAttribute.y = FBoundsRendering.Y + this.FBoundsPartAttribute.Y;
         this.FPainterActivateCaption.x = FBoundsRendering.X;
         this.FPainterActivateCaption.y = FBoundsRendering.Y + this.FBoundsActivateCaption.Y;
         this.FDividingLinePartCaption.width = SIZE_DividingLine_Max_Width;
         this.FDividingLinePartAttribute.width = SIZE_DividingLine_Max_Width;
      }
      
      override public function Show() : void
      {
         if(FContext == null && this.FSubContext == null)
         {
            return;
         }
         super.Show();
      }
      
      public function get SubContext() : Object
      {
         return this.FSubContext;
      }
      
      public function set SubContext(param1:Object) : void
      {
         this.FSubContext = param1;
      }
   }
}

