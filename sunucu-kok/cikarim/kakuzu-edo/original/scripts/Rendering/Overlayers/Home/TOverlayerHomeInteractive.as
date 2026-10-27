package Rendering.Overlayers.Home
{
   import Components.Standard.*;
   import Foundation.Common.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Repositories.*;
   import Foundation.Resources.Textures.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.Home.*;
   import Logics.Home.GirlFriend.TGirlFriendInteractive;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Rendering.Overlayers.*;
   import Rendering.Texts.*;
   import Resources.Constants.*;
   import Resources.Strings.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   import flash.utils.*;
   
   public class TOverlayerHomeInteractive extends TOverlayer
   {
      
      protected static const SIZE_DividingLine_Max_Width:uint = 385;
      
      protected static const SIZE_DividingLine_Min_Width:uint = 375;
      
      protected static const SIZE_WordWrapWidth:uint = 130;
      
      protected static const SIZE_TextFormat_leading:uint = 2;
      
      protected static const SIZE_Padding_01:uint = 3;
      
      protected static const SIZE_Padding_02:uint = 5;
      
      protected static const COLOR_Context_White:uint = 4294967295;
      
      protected static const QUALITYCOLOR_INDEX:Vector.<uint> = CONST_COMMON.QUALITYCOLOR_INDEX;
      
      protected static const CAPACITY_InteractiveContents:uint = 7;
      
      protected var FPainterCaption:TPainterTextEffect;
      
      protected var FPainterInteractiveTitle:TPainterTextEffect;
      
      protected var FPainterInteractiveContents:Vector.<TPainterTextEffect>;
      
      protected var FPainterInteractiveDesc:TPainterTextEffect;
      
      protected var FBoundsOffset:TBounds;
      
      protected var FBoundsCaption:TBounds;
      
      protected var FBoundsInteractiveTitle:TBounds;
      
      protected var FBoundsInteractiveContents:Vector.<TBounds>;
      
      protected var FBoundsInteractiveDesc:TBounds;
      
      protected var FDividingLinePart1:Bitmap;
      
      protected var FDividingLinePart2:Bitmap;
      
      protected var FBoundsPart1:TBounds;
      
      protected var FBoundsPart2:TBounds;
      
      protected var FTextFormat:TextFormat;
      
      protected var FContextIdentifier0:uint;
      
      protected var FContextIdentifier1:uint;
      
      protected var FContextInteractiveScore:uint;
      
      public function TOverlayerHomeInteractive(param1:TUIComponent)
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TPainterTextEffect = null;
         var _loc5_:TBounds = null;
         super(param1);
         this.FPainterCaption = ConstructPainterTextEffect(COLOR_Context_White);
         this.FBoundsCaption = new TBounds();
         this.FPainterInteractiveTitle = ConstructPainterTextEffect(COLOR_Context_White);
         this.FBoundsInteractiveTitle = new TBounds();
         this.FPainterInteractiveContents = new Vector.<TPainterTextEffect>(CAPACITY_InteractiveContents);
         this.FBoundsInteractiveContents = new Vector.<TBounds>(CAPACITY_InteractiveContents);
         _loc3_ = int(CAPACITY_InteractiveContents);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = ConstructPainterTextEffect(COLOR_Context_White);
            _loc5_ = new TBounds();
            this.FPainterInteractiveContents[_loc2_] = _loc4_;
            this.FBoundsInteractiveContents[_loc2_] = _loc5_;
            _loc2_++;
         }
         this.FPainterInteractiveDesc = ConstructPainterTextEffect(COLOR_Context_White);
         this.FBoundsInteractiveDesc = new TBounds();
         this.FDividingLinePart1 = new Bitmap();
         this.FDividingLinePart2 = new Bitmap();
         addChild(this.FDividingLinePart1);
         addChild(this.FDividingLinePart2);
         this.FBoundsPart1 = new TBounds();
         this.FBoundsPart2 = new TBounds();
         this.FTextFormat = new TextFormat();
         FMarginLeft = 15;
         FMarginTop = 15;
         FMarginRight = 1;
         FMarginBottom = 15;
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         this.FDividingLinePart1.bitmapData = FDividingLine;
         this.FDividingLinePart2.bitmapData = FDividingLine;
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ContextVerificate(param1:Object) : Boolean
      {
         return param1 is THome;
      }
      
      override protected function ContextModified() : Boolean
      {
         var _loc1_:Boolean = false;
         var _loc2_:THome = null;
         _loc2_ = FContext as THome;
         return this.FContextIdentifier0 != _loc2_.Identifier0 || this.FContextIdentifier1 != _loc2_.Identifier1 || this.FContextInteractiveScore != _loc2_.InteractiveScore;
      }
      
      override protected function ContextSynchronize() : void
      {
         var _loc1_:THome = null;
         _loc1_ = FContext as THome;
         this.FContextIdentifier0 = _loc1_.Identifier0;
         this.FContextIdentifier1 = _loc1_.Identifier1;
         this.FContextInteractiveScore = _loc1_.InteractiveScore;
         this.FDividingLinePart1.width = SIZE_DividingLine_Min_Width;
         this.FDividingLinePart2.width = SIZE_DividingLine_Min_Width;
      }
      
      override protected function EvaluationPerform_Context() : void
      {
         var _loc1_:THome = null;
         _loc1_ = FContext as THome;
         this.EvaluationPerform_Caption(_loc1_);
         this.FBoundsOffset = this.FBoundsCaption;
         this.EvaluationPerform_InteractiveTitle(_loc1_);
         this.FBoundsOffset = this.FBoundsInteractiveTitle;
         this.EvaluationPerform_Part1(null);
         this.FBoundsOffset = this.FBoundsPart1;
         this.EvaluationPerform_InteractiveContents(_loc1_);
         this.FBoundsOffset = this.FBoundsInteractiveContents[CAPACITY_InteractiveContents - 1];
         this.EvaluationPerform_Part2(null);
         this.FBoundsOffset = this.FBoundsPart2;
         this.EvaluationPerform_InteractiveDesc(_loc1_);
         this.FBoundsOffset = this.FBoundsInteractiveDesc;
      }
      
      protected function EvaluationPerform_Caption(param1:THome) : void
      {
         var _loc2_:String = null;
         BoundsAlignDown(this.FBoundsCaption,null,SIZE_Padding_02);
         _loc2_ = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.FORMAT_HOMEINTERACTIVE_01),param1.InteractiveScore);
         this.FPainterCaption.Text = _loc2_;
         this.FPainterCaption.Evaluate(this.FBoundsCaption);
         BoundsContextUnion(this.FBoundsCaption);
      }
      
      protected function EvaluationPerform_InteractiveTitle(param1:THome) : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         BoundsAlignDown(this.FBoundsInteractiveTitle,this.FBoundsOffset,SIZE_Padding_01);
         _loc3_ = param1.InteractiveTitle;
         _loc2_ = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.FORMAT_HOMEINTERACTIVE_02),_loc3_);
         _loc4_ = uint(_loc2_.lastIndexOf(_loc3_));
         _loc5_ = _loc4_ + _loc3_.length;
         this.FPainterInteractiveTitle.Text = _loc2_;
         this.FTextFormat.color = QUALITYCOLOR_INDEX[param1.InteractiveQuality];
         this.FPainterInteractiveTitle.Evaluate(this.FBoundsInteractiveTitle);
         this.FPainterInteractiveTitle.SetTextFormat(this.FTextFormat,_loc4_,_loc5_);
         BoundsContextUnion(this.FBoundsInteractiveTitle);
      }
      
      protected function EvaluationPerform_Part1(param1:THome) : void
      {
         this.FBoundsPart1.Width = this.FDividingLinePart1.width;
         this.FBoundsPart1.Height = this.FDividingLinePart1.height;
         BoundsAlignDown(this.FBoundsPart1,this.FBoundsOffset,SIZE_Padding_02);
         this.FBoundsPart1.X = 0;
         BoundsContextUnion(this.FBoundsPart1);
      }
      
      protected function EvaluationPerform_InteractiveContents(param1:THome) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:TBounds = null;
         var _loc10_:TBounds = null;
         var _loc11_:TPainterTextEffect = null;
         var _loc12_:TGirlFriendInteractive = null;
         _loc10_ = this.FBoundsOffset;
         _loc3_ = int(CAPACITY_InteractiveContents);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc11_ = this.FPainterInteractiveContents[_loc2_];
            _loc9_ = this.FBoundsInteractiveContents[_loc2_];
            if(_loc2_ == 0)
            {
               BoundsAlignDown(_loc9_,_loc10_,SIZE_Padding_02);
            }
            else
            {
               BoundsAlignDown(_loc9_,_loc10_,SIZE_Padding_01);
            }
            _loc12_ = param1.GirlFriendInteractives.GetGirlFriendInteractiveByIndex(_loc2_);
            _loc5_ = _loc12_.InteractiveTitle;
            _loc6_ = _loc12_.InteractiveScore.toString();
            _loc4_ = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.FORMAT_HOMEINTERACTIVE_03),_loc6_,_loc5_,_loc12_.InteractiveReward,_loc12_.InteractiveAdditional);
            _loc7_ = uint(_loc4_.lastIndexOf(_loc5_));
            _loc8_ = _loc7_ + _loc5_.length;
            _loc11_.Text = _loc4_;
            this.FTextFormat.color = QUALITYCOLOR_INDEX[_loc12_.InteractiveQuality];
            _loc11_.Evaluate(_loc9_);
            _loc11_.SetTextFormat(this.FTextFormat,_loc7_,_loc8_);
            BoundsContextUnion(_loc9_);
            _loc10_ = _loc9_;
            _loc2_++;
         }
      }
      
      protected function EvaluationPerform_Part2(param1:THome) : void
      {
         this.FBoundsPart2.Width = this.FDividingLinePart2.width;
         this.FBoundsPart2.Height = this.FDividingLinePart2.height;
         BoundsAlignDown(this.FBoundsPart2,this.FBoundsOffset,SIZE_Padding_02);
         this.FBoundsPart2.X = 0;
         BoundsContextUnion(this.FBoundsPart2);
      }
      
      protected function EvaluationPerform_InteractiveDesc(param1:THome) : void
      {
         var _loc2_:String = null;
         var _loc3_:TGirlFriendInteractive = null;
         BoundsAlignDown(this.FBoundsInteractiveDesc,this.FBoundsOffset,SIZE_Padding_02);
         _loc3_ = param1.GirlFriendInteractives.GetGirlFriendInteractiveByIndex(0);
         _loc2_ = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.FORMAT_HOMEINTERACTIVE_04),_loc3_.InteractiveReward);
         this.FPainterInteractiveDesc.Text = _loc2_;
         this.FPainterInteractiveDesc.Evaluate(this.FBoundsInteractiveDesc);
         BoundsContextUnion(this.FBoundsInteractiveDesc);
      }
      
      override protected function SketchingPerform_Context() : void
      {
      }
      
      override protected function RenderingPerform_Context(param1:TCoordinate) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TBounds = null;
         var _loc5_:TPainterTextEffect = null;
         FBoundsRendering.X = FMarginLeft;
         FBoundsRendering.Y = FMarginTop;
         this.FPainterCaption.X = FBoundsRendering.X + this.FBoundsCaption.X;
         this.FPainterCaption.Y = FBoundsRendering.Y + this.FBoundsCaption.Y;
         this.FPainterInteractiveTitle.X = FBoundsRendering.X + this.FBoundsInteractiveTitle.X;
         this.FPainterInteractiveTitle.Y = FBoundsRendering.Y + this.FBoundsInteractiveTitle.Y;
         this.FDividingLinePart1.x = FBoundsRendering.X + this.FBoundsPart1.X - FMarginLeft + 2;
         this.FDividingLinePart1.y = FBoundsRendering.Y + this.FBoundsPart1.Y;
         _loc3_ = int(CAPACITY_InteractiveContents);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc5_ = this.FPainterInteractiveContents[_loc2_];
            _loc4_ = this.FBoundsInteractiveContents[_loc2_];
            _loc5_.X = FBoundsRendering.X + _loc4_.X;
            _loc5_.Y = FBoundsRendering.Y + _loc4_.Y;
            _loc2_++;
         }
         this.FDividingLinePart2.x = FBoundsRendering.X + this.FBoundsPart2.X - FMarginLeft + 2;
         this.FDividingLinePart2.y = FBoundsRendering.Y + this.FBoundsPart2.Y;
         this.FPainterInteractiveDesc.X = FBoundsRendering.X + this.FBoundsInteractiveDesc.X;
         this.FPainterInteractiveDesc.Y = FBoundsRendering.Y + this.FBoundsInteractiveDesc.Y;
         this.FDividingLinePart1.width = SIZE_DividingLine_Max_Width;
         this.FDividingLinePart2.width = SIZE_DividingLine_Max_Width;
      }
   }
}

