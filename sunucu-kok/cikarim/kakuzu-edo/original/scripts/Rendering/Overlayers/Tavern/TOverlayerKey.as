package Rendering.Overlayers.Tavern
{
   import Foundation.Common.TAlignment;
   import Foundation.Common.TBounds;
   import Foundation.Common.TCoordinate;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityString;
   import Logics.Tavern.TPayConfig;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Rendering.Overlayers.TOverlayer;
   import Rendering.Texts.TPainterTextEffect;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.text.TextFormat;
   
   public class TOverlayerKey extends TOverlayer
   {
      
      protected static const SIZE_TextFormat_leading:uint = 2;
      
      protected static const SIZE_WordWrapWidth:uint = 170;
      
      protected static const SIZE_Padding_01:uint = 5;
      
      protected static const SIZE_Padding_03:uint = 10;
      
      protected static const SIZE_Context_00:uint = 15;
      
      protected static const COLOR_Context_White:uint = 4294967295;
      
      protected static const COLOR_Context_Red:uint = 4294901760;
      
      protected static const COLOR_Context_01:uint = 4291545959;
      
      protected static const COLOR_Context_02:uint = 4294967040;
      
      protected var FPainterCaption:TPainterTextEffect;
      
      protected var FPainterDescCaption:TPainterTextEffect;
      
      protected var FPainterVIP:TPainterTextEffect;
      
      protected var FPainterCoinPrice:TPainterTextEffect;
      
      protected var FPainterGoldPrice:TPainterTextEffect;
      
      protected var FBoundsCaption:TBounds;
      
      protected var FBoundsDescCaption:TBounds;
      
      protected var FBoundsVIP:TBounds;
      
      protected var FBoundsCoinPrice:TBounds;
      
      protected var FBoundsGoldPrice:TBounds;
      
      protected var FBoundsOffset:TBounds;
      
      protected var FTextFormatCaption:TextFormat;
      
      protected var FTextFormatDesc:TextFormat;
      
      protected var FTextFormatCoinPrice:TextFormat;
      
      protected var FTextFormatGoldPrice:TextFormat;
      
      protected var FContextIdentifier:uint;
      
      protected var FContextIDTemplate:uint;
      
      protected var FPayConfiId:int;
      
      protected var FIsVip:Boolean;
      
      public function TOverlayerKey(param1:TUIComponent)
      {
         super(param1);
         this.FPainterCaption = ConstructPainterTextEffect(COLOR_Context_01);
         this.FBoundsCaption = new TBounds();
         this.FPainterDescCaption = ConstructPainterTextEffect(COLOR_Context_01);
         this.FBoundsDescCaption = new TBounds();
         this.FPainterCoinPrice = ConstructPainterTextEffect(COLOR_Context_01);
         this.FBoundsCoinPrice = new TBounds();
         this.FPainterGoldPrice = ConstructPainterTextEffect(COLOR_Context_01);
         this.FBoundsGoldPrice = new TBounds();
         this.FPainterVIP = ConstructPainterTextEffect(COLOR_Context_Red);
         this.FBoundsVIP = new TBounds();
         this.FTextFormatCaption = new TextFormat();
         this.FTextFormatDesc = new TextFormat();
         this.FTextFormatCoinPrice = new TextFormat();
         this.FTextFormatGoldPrice = new TextFormat();
         this.FPayConfiId = -1;
      }
      
      override protected function ContextVerificate(param1:Object) : Boolean
      {
         return param1 is TPayConfig;
      }
      
      override protected function ContextModified() : Boolean
      {
         var _loc1_:Boolean = false;
         var _loc2_:TPayConfig = null;
         _loc2_ = FContext as TPayConfig;
         return this.FContextIDTemplate != _loc2_.ID;
      }
      
      override protected function ContextSynchronize() : void
      {
         var _loc1_:TPayConfig = null;
         _loc1_ = FContext as TPayConfig;
         this.FContextIDTemplate = _loc1_.ID;
      }
      
      override protected function EvaluationPerform_Context() : void
      {
         var _loc1_:TPayConfig = null;
         _loc1_ = FContext as TPayConfig;
         this.FBoundsCaption.Reset();
         this.FBoundsDescCaption.Reset();
         this.FBoundsCoinPrice.Reset();
         this.EvaluationPerform_Caption(_loc1_);
         this.FBoundsOffset = this.FBoundsCaption;
         this.EvaluationPerform_DescCaption(_loc1_);
         this.FBoundsOffset = this.FBoundsDescCaption;
         this.EvaluationPerform_CoinPrice(_loc1_);
         this.FBoundsOffset = this.FBoundsCoinPrice;
         this.EvaluationPerform_VIP(_loc1_);
      }
      
      protected function EvaluationPerform_Caption(param1:TPayConfig) : void
      {
         var _loc2_:String = null;
         BoundsAlignDown(this.FBoundsCaption,this.FBoundsOffset,SIZE_Padding_01);
         _loc2_ = param1.Title;
         this.FPainterCaption.Text = _loc2_;
         this.FPainterCaption.Font.Size = SIZE_Context_00;
         this.FPainterCaption.Font.Color = COLOR_Context_White;
         this.FBoundsCaption.Y -= 5;
         this.FPainterCaption.Evaluate(this.FBoundsCaption);
         BoundsContextUnion(this.FBoundsCaption);
      }
      
      protected function EvaluationPerform_DescCaption(param1:TPayConfig) : void
      {
         BoundsAlignDown(this.FBoundsDescCaption,this.FBoundsOffset,SIZE_Padding_01);
         this.FPainterDescCaption.Text = param1.Context;
         this.FPainterDescCaption.Evaluate(this.FBoundsDescCaption);
         BoundsContextUnion(this.FBoundsDescCaption);
      }
      
      protected function EvaluationPerform_CoinPrice(param1:TPayConfig) : void
      {
         var _loc2_:int = 0;
         var _loc3_:String = null;
         BoundsAlignDown(this.FBoundsCoinPrice,this.FBoundsOffset,SIZE_Padding_01);
         _loc3_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.FORMAT_CoinPrice);
         _loc2_ = _loc3_.length - " %0".length;
         this.FPainterCoinPrice.Text = TUtilityString.Format(_loc3_,param1.Value);
         this.FTextFormatCoinPrice.leading = SIZE_TextFormat_leading;
         this.FTextFormatCoinPrice.color = COLOR_Context_White;
         this.FPainterCoinPrice.Evaluate(this.FBoundsCoinPrice);
         this.FPainterCoinPrice.SetTextFormat(this.FTextFormatCoinPrice,_loc2_,this.FPainterCoinPrice.Text.length);
         BoundsContextUnion(this.FBoundsCoinPrice);
      }
      
      protected function EvaluationPerform_GoldPrice(param1:TPayConfig) : void
      {
         var _loc2_:int = 0;
         var _loc3_:String = null;
         _loc2_ = this.FPainterCoinPrice.x + this.FPainterCoinPrice.TextHeight;
         BoundsAlignDown(this.FBoundsGoldPrice,this.FBoundsOffset,_loc2_);
         _loc3_ = param1.Value;
         this.FPainterGoldPrice.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.FORMAT_GoldPrice),_loc3_);
         this.FTextFormatGoldPrice.color = COLOR_Context_White;
         this.FPainterGoldPrice.Evaluate(this.FBoundsGoldPrice);
         BoundsContextUnion(this.FBoundsGoldPrice);
      }
      
      protected function EvaluationPerform_VIP(param1:TPayConfig) : void
      {
         if(param1.OpenLevel == null || param1.OpenLevel.length <= 0)
         {
            this.FIsVip = false;
            return;
         }
         BoundsAlignDown(this.FBoundsVIP,this.FBoundsOffset,SIZE_Padding_01);
         this.FPainterVIP.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.FORMAT_VIP),param1.OpenLevel);
         this.FTextFormatDesc.size = this.FPainterVIP.Font.Size;
         this.FTextFormatDesc.color = COLOR_Context_Red;
         this.FPainterVIP.Evaluate(this.FBoundsVIP);
         BoundsContextUnion(this.FBoundsVIP);
         this.FIsVip = true;
      }
      
      override protected function SketchingPerform_Context() : void
      {
         var _loc1_:TPayConfig = null;
         _loc1_ = FContext as TPayConfig;
         this.SketchingPerform_Caption();
         this.SketchingPerform_DescCaption();
         this.SketchingPerform_CoinPrice();
         this.SketchingPerform_VIP();
      }
      
      protected function SketchingPerform_Caption() : void
      {
         this.FPainterCaption.RenderBounds(this.FBoundsCaption,TAlignment.HORIZONTAL_Left);
      }
      
      protected function SketchingPerform_DescCaption() : void
      {
         this.FPainterDescCaption.RenderBounds(this.FBoundsDescCaption,TAlignment.HORIZONTAL_Left);
      }
      
      protected function SketchingPerform_VIP() : void
      {
         this.FPainterVIP.RenderBounds(this.FBoundsVIP,TAlignment.HORIZONTAL_Left);
      }
      
      protected function SketchingPerform_CoinPrice() : void
      {
         this.FPainterCoinPrice.RenderBounds(this.FBoundsCoinPrice,TAlignment.HORIZONTAL_Left);
      }
      
      protected function SketchingPerform_GoldPrice() : void
      {
         this.FPainterGoldPrice.RenderBounds(this.FBoundsGoldPrice,TAlignment.HORIZONTAL_Left);
      }
      
      override protected function RenderingPerform_Context(param1:TCoordinate) : void
      {
         var _loc2_:TPayConfig = null;
         _loc2_ = FContext as TPayConfig;
         FBoundsRendering.X = FMarginLeft;
         FBoundsRendering.Y = FMarginTop;
         this.FPainterCaption.X = FBoundsRendering.X + this.FBoundsCaption.X;
         this.FPainterCaption.Y = FBoundsRendering.Y + this.FBoundsCaption.Y;
         this.FPainterDescCaption.X = FBoundsRendering.X + this.FBoundsDescCaption.X;
         this.FPainterDescCaption.Y = FBoundsRendering.Y + this.FBoundsDescCaption.Y;
         this.FPainterCoinPrice.X = FBoundsRendering.X + this.FBoundsCoinPrice.X;
         this.FPainterCoinPrice.Y = FBoundsRendering.Y + this.FBoundsCoinPrice.Y;
         if(this.FIsVip)
         {
            this.FPainterVIP.X = FBoundsRendering.X + this.FBoundsVIP.X;
            this.FPainterVIP.Y = FBoundsRendering.Y + this.FBoundsVIP.Y;
            this.FPainterVIP.visible = true;
         }
         else
         {
            this.FPainterVIP.visible = false;
         }
      }
      
      override public function set Context(param1:Object) : void
      {
         var _loc2_:TPayConfig = null;
         _loc2_ = param1 as TPayConfig;
         if(_loc2_ != null)
         {
            if(!this.ContextVerificate(_loc2_))
            {
               _loc2_ = null;
            }
         }
         if(_loc2_ != FContext)
         {
            FContext = _loc2_;
            this.FPayConfiId = _loc2_.ID;
            FModified = true;
         }
         if(_loc2_.ID != this.FPayConfiId)
         {
            this.FPayConfiId = _loc2_.ID;
            FModified = true;
         }
      }
      
      override public function Hide() : void
      {
         this.FPayConfiId = -1;
         OverLayerVisible = false;
         super.Hide();
      }
   }
}

