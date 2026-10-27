package Rendering.Overlayers.Home
{
   import Foundation.Common.TAlignment;
   import Foundation.Common.TBounds;
   import Foundation.Common.TCoordinate;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityString;
   import Logics.Home.GirlFriend.TGirlFriend;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Rendering.Overlayers.TOverlayer;
   import Rendering.Texts.TPainterHtmlTextEffect;
   import Rendering.Texts.TPainterTextEffect;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.display.Bitmap;
   import flash.text.TextFormat;
   
   public class TOverlayerGirlFriend extends TOverlayer
   {
      
      protected static const COLOR_ContextDefault:uint = 4294967295;
      
      protected static const COLOR_ContextValue:uint = 4294967040;
      
      protected static const COLOR_Context_AppendAttributes:uint = 4284940032;
      
      protected static const COLOR_Context_Green:uint = 4278255360;
      
      protected static const SIZE_Padding_01:uint = 15;
      
      protected static const SIZE_Padding_02:uint = 10;
      
      protected static const SIZE_DividingLine_Max_Width:int = 248;
      
      public var FORMAT_GirlCaption:String;
      
      public var FORMAT_GirlAddition:String;
      
      public var FORMAT_GirlUpgradeCondition:String;
      
      public var FORMAT_GirlDescription:String;
      
      protected var FPainterGirlCaption:TPainterTextEffect;
      
      protected var FDividingLineOne:Bitmap;
      
      protected var FPainterGirlAddition:TPainterTextEffect;
      
      protected var FDividingLineTwo:Bitmap;
      
      protected var FPainterGirlUpgradeCondition:TPainterTextEffect;
      
      protected var FDividingLineThree:Bitmap;
      
      protected var FPainterGirlDescription:TPainterHtmlTextEffect;
      
      protected var FBoundsGirlCaption:TBounds;
      
      protected var FBoundsLineOne:TBounds;
      
      protected var FBoundsGirlAddition:TBounds;
      
      protected var FBoundsLineTwo:TBounds;
      
      protected var FBoundsGirlUpgradeCondition:TBounds;
      
      protected var FBoundsLineThree:TBounds;
      
      protected var FBoundsGirlDescription:TBounds;
      
      protected var FBoundsOffset:TBounds;
      
      protected var FTextFormatCaption:TextFormat;
      
      protected var FContextResourceID:uint;
      
      public function TOverlayerGirlFriend(param1:TUIComponent)
      {
         super(param1);
         this.FPainterGirlCaption = ConstructPainterTextEffect(COLOR_Context_Green);
         this.FBoundsGirlCaption = new TBounds();
         this.FPainterGirlAddition = ConstructPainterTextEffect(COLOR_ContextDefault);
         this.FBoundsGirlAddition = new TBounds();
         this.FPainterGirlUpgradeCondition = ConstructPainterTextEffect(COLOR_Context_Green);
         this.FBoundsGirlUpgradeCondition = new TBounds();
         FWordWrapWidth = SIZE_DividingLine_Max_Width;
         this.FPainterGirlDescription = new TPainterHtmlTextEffect(this);
         this.FPainterGirlDescription.FontEffect.AntiAliased = true;
         this.FPainterGirlDescription.FontEffect.Outlined = true;
         this.FPainterGirlDescription.FontEffect.Shadowed = true;
         this.FPainterGirlDescription.WordWrap = true;
         this.FPainterGirlDescription.WordWrapWidth = FWordWrapWidth;
         this.FPainterGirlDescription.Multilineable = true;
         this.FBoundsGirlDescription = new TBounds();
         this.FDividingLineOne = new Bitmap();
         addChild(this.FDividingLineOne);
         this.FBoundsLineOne = new TBounds();
         this.FDividingLineTwo = new Bitmap();
         addChild(this.FDividingLineTwo);
         this.FBoundsLineTwo = new TBounds();
         this.FDividingLineThree = new Bitmap();
         addChild(this.FDividingLineThree);
         this.FBoundsLineThree = new TBounds();
         this.FTextFormatCaption = new TextFormat();
         FMarginLeft = 15;
         FMarginTop = 15;
         FMarginRight = 15;
         FMarginBottom = 15;
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         this.FDividingLineOne.bitmapData = FDividingLine;
         this.FDividingLineTwo.bitmapData = FDividingLine;
         this.FDividingLineThree.bitmapData = FDividingLine;
         this.FORMAT_GirlCaption = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.GirlFriend_STRING_28);
         this.FORMAT_GirlAddition = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.GirlFriend_STRING_29);
         this.FORMAT_GirlUpgradeCondition = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.GirlFriend_STRING_30);
         this.FORMAT_GirlDescription = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.GirlFriend_STRING_31);
      }
      
      override protected function ContextVerificate(param1:Object) : Boolean
      {
         return param1 is TGirlFriend;
      }
      
      override protected function ContextModified() : Boolean
      {
         var _loc1_:Boolean = false;
         var _loc2_:TGirlFriend = null;
         _loc2_ = FContext as TGirlFriend;
         return this.FContextResourceID != _loc2_.ID;
      }
      
      override protected function ContextSynchronize() : void
      {
         var _loc1_:TGirlFriend = null;
         _loc1_ = FContext as TGirlFriend;
         this.FContextResourceID = _loc1_.ID;
      }
      
      override protected function EvaluationPerform_Context() : void
      {
         var _loc1_:TGirlFriend = null;
         _loc1_ = FContext as TGirlFriend;
         this.EvaluationPerform_Caption(_loc1_);
         this.FBoundsOffset = this.FBoundsGirlCaption;
         this.EvaluationPerform_CutLineOne();
         this.FBoundsOffset = this.FBoundsLineOne;
         this.EvaluationPerform_GirlAddition(_loc1_);
         this.FBoundsOffset = this.FBoundsGirlAddition;
         this.EvaluationPerform_CutLineTwo();
         this.FBoundsOffset = this.FBoundsLineTwo;
         this.EvaluationPerform_UpgradeCondition(_loc1_);
         this.FBoundsOffset = this.FBoundsGirlUpgradeCondition;
         this.EvaluationPerform_CutLineThree();
         this.FBoundsOffset = this.FBoundsLineThree;
         this.EvaluationPerform_GirlDescription(_loc1_);
         this.FBoundsOffset = this.FBoundsGirlDescription;
      }
      
      protected function EvaluationPerform_Caption(param1:TGirlFriend) : void
      {
         var _loc2_:int = 0;
         BoundsAlignDown(this.FBoundsGirlCaption);
         this.FPainterGirlCaption.Text = TUtilityString.Format(this.FORMAT_GirlCaption,param1.Level.toString());
         this.FPainterGirlCaption.Evaluate(this.FBoundsGirlCaption);
         BoundsContextUnion(this.FBoundsGirlCaption);
      }
      
      protected function EvaluationPerform_CutLineOne() : void
      {
         this.FBoundsLineOne.Width = this.FDividingLineOne.width;
         this.FBoundsLineOne.Height = this.FDividingLineOne.height;
         BoundsAlignDown(this.FBoundsLineOne,this.FBoundsOffset,SIZE_Padding_02);
         this.FBoundsLineOne.X = 0;
         BoundsContextUnion(this.FBoundsLineOne);
      }
      
      protected function EvaluationPerform_GirlAddition(param1:TGirlFriend) : void
      {
         var _loc2_:int = 0;
         BoundsAlignDown(this.FBoundsGirlAddition,this.FBoundsOffset,SIZE_Padding_02);
         this.FPainterGirlAddition.Text = TUtilityString.Format(this.FORMAT_GirlAddition,param1.CanCommunicateTime.toString(),param1.CanMakeTofuTime.toString(),param1.MakeTofuAwardNum.toString());
         this.FTextFormatCaption.color = COLOR_ContextDefault;
         this.FPainterGirlAddition.Evaluate(this.FBoundsGirlAddition);
         BoundsContextUnion(this.FBoundsGirlAddition);
      }
      
      protected function EvaluationPerform_CutLineTwo() : void
      {
         this.FBoundsLineTwo.Width = this.FDividingLineTwo.width;
         this.FBoundsLineTwo.Height = this.FDividingLineTwo.height;
         BoundsAlignDown(this.FBoundsLineTwo,this.FBoundsOffset,SIZE_Padding_02);
         this.FBoundsLineTwo.X = 0;
         BoundsContextUnion(this.FBoundsLineTwo);
      }
      
      protected function EvaluationPerform_UpgradeCondition(param1:TGirlFriend) : void
      {
         var _loc2_:int = 0;
         BoundsAlignDown(this.FBoundsGirlUpgradeCondition,this.FBoundsOffset,SIZE_Padding_02);
         this.FPainterGirlUpgradeCondition.Text = TUtilityString.Format(this.FORMAT_GirlUpgradeCondition,param1.HomeLevelLimitName,param1.UpgradeInventoryNum);
         this.FTextFormatCaption.color = COLOR_ContextDefault;
         this.FPainterGirlUpgradeCondition.Evaluate(this.FBoundsGirlUpgradeCondition);
         BoundsContextUnion(this.FBoundsGirlUpgradeCondition);
      }
      
      protected function EvaluationPerform_CutLineThree() : void
      {
         this.FBoundsLineThree.Width = this.FDividingLineThree.width;
         this.FBoundsLineThree.Height = this.FDividingLineThree.height;
         BoundsAlignDown(this.FBoundsLineThree,this.FBoundsOffset,SIZE_Padding_02);
         this.FBoundsLineThree.X = 0;
         BoundsContextUnion(this.FBoundsLineThree);
      }
      
      protected function EvaluationPerform_GirlDescription(param1:TGirlFriend) : void
      {
         var _loc2_:int = 0;
         BoundsAlignDown(this.FBoundsGirlDescription,this.FBoundsOffset,SIZE_Padding_02);
         this.FPainterGirlDescription.Text = TUtilityString.Format(this.FORMAT_GirlDescription,param1.GirlDescrption);
         this.FTextFormatCaption.color = COLOR_ContextDefault;
         this.FPainterGirlDescription.Evaluate(this.FBoundsGirlDescription);
         BoundsContextUnion(this.FBoundsGirlDescription);
      }
      
      override protected function SketchingPerform_Context() : void
      {
         this.SketchingPerform_Caption();
      }
      
      protected function SketchingPerform_Caption() : void
      {
         this.FPainterGirlCaption.RenderBounds(this.FBoundsGirlCaption,TAlignment.HORIZONTAL_Left);
         this.FPainterGirlAddition.RenderBounds(this.FBoundsGirlAddition,TAlignment.HORIZONTAL_Left);
         this.FPainterGirlUpgradeCondition.RenderBounds(this.FBoundsGirlUpgradeCondition,TAlignment.HORIZONTAL_Left);
         this.FPainterGirlDescription.RenderBounds(this.FBoundsGirlDescription,TAlignment.HORIZONTAL_Left);
      }
      
      override protected function RenderingPerform_Context(param1:TCoordinate) : void
      {
         FBoundsRendering.X = FMarginLeft;
         FBoundsRendering.Y = FMarginTop;
         this.FPainterGirlCaption.x = FBoundsRendering.X + this.FBoundsGirlCaption.X;
         this.FPainterGirlCaption.y = FBoundsRendering.Y + this.FBoundsGirlCaption.Y;
         this.FDividingLineOne.x = FBoundsRendering.X + this.FBoundsLineOne.X - FMarginLeft + 2;
         this.FDividingLineOne.y = FBoundsRendering.Y + this.FBoundsLineOne.Y;
         this.FPainterGirlAddition.x = FBoundsRendering.X + this.FBoundsGirlAddition.X;
         this.FPainterGirlAddition.y = FBoundsRendering.Y + this.FBoundsGirlAddition.Y;
         this.FDividingLineTwo.x = FBoundsRendering.X + this.FBoundsLineTwo.X - FMarginLeft + 2;
         this.FDividingLineTwo.y = FBoundsRendering.Y + this.FBoundsLineTwo.Y;
         this.FPainterGirlUpgradeCondition.x = FBoundsRendering.X + this.FBoundsGirlUpgradeCondition.X;
         this.FPainterGirlUpgradeCondition.y = FBoundsRendering.Y + this.FBoundsGirlUpgradeCondition.Y;
         this.FDividingLineThree.x = FBoundsRendering.X + this.FBoundsLineThree.X - FMarginLeft + 2;
         this.FDividingLineThree.y = FBoundsRendering.Y + this.FBoundsLineThree.Y;
         this.FPainterGirlDescription.x = FBoundsRendering.X + this.FBoundsGirlDescription.X;
         this.FPainterGirlDescription.y = FBoundsRendering.Y + this.FBoundsGirlDescription.Y;
         this.FDividingLineOne.width = SIZE_DividingLine_Max_Width;
         this.FDividingLineTwo.width = SIZE_DividingLine_Max_Width;
         this.FDividingLineThree.width = SIZE_DividingLine_Max_Width;
      }
   }
}

