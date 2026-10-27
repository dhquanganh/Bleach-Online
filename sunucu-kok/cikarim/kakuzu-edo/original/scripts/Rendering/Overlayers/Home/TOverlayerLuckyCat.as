package Rendering.Overlayers.Home
{
   import Foundation.Common.TAlignment;
   import Foundation.Common.TBounds;
   import Foundation.Common.TCoordinate;
   import Foundation.Resources.Bins.TBins;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityString;
   import Logics.Characters.TCharacter;
   import Logics.DatebaseVO.VO.THomeFortune;
   import Logics.Home.LuckyCat.TLuckyCat;
   import Logics.SLogicsCore;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Rendering.Overlayers.TOverlayer;
   import Rendering.Texts.TPainterTextEffect;
   import Resources.Constants.CONST_DATEBASEVO;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.text.TextFormat;
   
   public class TOverlayerLuckyCat extends TOverlayer
   {
      
      protected static const COLOUR_CLICK:uint = 4294953095;
      
      protected static const COLOR_Context_Green:uint = 4278255360;
      
      protected static const SIZE_Padding_01:uint = 15;
      
      protected static const SIZE_Padding_02:uint = 10;
      
      protected var FPainterLuckyCatCaption:TPainterTextEffect;
      
      protected var FPainterIncome:TPainterTextEffect;
      
      protected var FPainterDesc:TPainterTextEffect;
      
      protected var FPainterClick:TPainterTextEffect;
      
      protected var FBoundsLuckyCatCaption:TBounds;
      
      protected var FBoundsIncome:TBounds;
      
      protected var FBoundsDesc:TBounds;
      
      protected var FBoundsClick:TBounds;
      
      protected var FBoundsOffset:TBounds;
      
      protected var FTextFormatCaption:TextFormat;
      
      protected var FCount:uint;
      
      protected var FCharacter:TCharacter;
      
      protected var FLevel:uint;
      
      protected var FHomeFortuneBin:TBins;
      
      public function TOverlayerLuckyCat(param1:TUIComponent)
      {
         super(param1);
         FWordWrapWidth = 125;
         this.FPainterLuckyCatCaption = ConstructPainterTextEffect(COLOR_Context_Green);
         this.FBoundsLuckyCatCaption = new TBounds();
         this.FPainterIncome = ConstructPainterTextEffect(COLOR_ContextDefault);
         this.FBoundsIncome = new TBounds();
         this.FPainterDesc = ConstructPainterTextEffect(COLOR_ContextDefault);
         this.FBoundsDesc = new TBounds();
         this.FPainterClick = ConstructPainterTextEffect(COLOUR_CLICK);
         this.FBoundsClick = new TBounds();
         this.FTextFormatCaption = new TextFormat();
         FMarginLeft = 15;
         FMarginTop = 15;
         FMarginRight = 15;
         FMarginBottom = 15;
         this.FCharacter = SLogicsCore.Character;
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
      }
      
      override protected function ContextVerificate(param1:Object) : Boolean
      {
         return param1 is TLuckyCat;
      }
      
      override protected function ContextModified() : Boolean
      {
         var _loc1_:Boolean = false;
         var _loc2_:TLuckyCat = null;
         _loc2_ = FContext as TLuckyCat;
         return this.FCount != _loc2_.MaxLuckyCatCount || this.FLevel != this.FCharacter.GetMainLevel();
      }
      
      override protected function ContextSynchronize() : void
      {
         var _loc1_:TLuckyCat = null;
         _loc1_ = FContext as TLuckyCat;
         this.FCount = _loc1_.MaxLuckyCatCount;
         this.FLevel = this.FCharacter.GetMainLevel();
      }
      
      override protected function EvaluationPerform_Context() : void
      {
         var _loc1_:TLuckyCat = null;
         _loc1_ = FContext as TLuckyCat;
         this.EvaluationPerform_Caption(_loc1_);
         this.FBoundsOffset = this.FBoundsLuckyCatCaption;
         this.EvaluationPerform_Income(_loc1_);
         this.FBoundsOffset = this.FBoundsIncome;
         this.EvaluationPerform_Desc(_loc1_);
         this.FBoundsOffset = this.FBoundsDesc;
         this.EvaluationPerform_Click(_loc1_);
         this.FBoundsOffset = this.FBoundsClick;
      }
      
      protected function EvaluationPerform_Caption(param1:TLuckyCat) : void
      {
         var _loc2_:int = 0;
         BoundsAlignDown(this.FBoundsLuckyCatCaption);
         this.FPainterLuckyCatCaption.Text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_LUCKYCAT_01);
         this.FPainterLuckyCatCaption.Evaluate(this.FBoundsLuckyCatCaption);
         BoundsContextUnion(this.FBoundsLuckyCatCaption);
      }
      
      protected function EvaluationPerform_Income(param1:TLuckyCat) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:THomeFortune = null;
         BoundsAlignDown(this.FBoundsIncome,this.FBoundsOffset,SIZE_Padding_02);
         if(this.FHomeFortuneBin == null)
         {
            this.FHomeFortuneBin = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_HomeFortune);
         }
         _loc3_ = this.FHomeFortuneBin.GetDatebaseByIdentifier(this.FCharacter.GetMainRebirthLevel()) as THomeFortune;
         _loc2_ = _loc3_.BaseMoney;
         this.FPainterIncome.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_LUCKYCAT_02),_loc2_);
         this.FTextFormatCaption.color = COLOR_ContextDefault;
         this.FPainterIncome.Evaluate(this.FBoundsIncome);
         BoundsContextUnion(this.FBoundsIncome);
      }
      
      protected function EvaluationPerform_Desc(param1:TLuckyCat) : void
      {
         var _loc2_:String = null;
         BoundsAlignDown(this.FBoundsDesc,this.FBoundsOffset,SIZE_Padding_02);
         _loc2_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_LUCKYCAT_03) + param1.Desc;
         this.FPainterDesc.Text = TUtilityString.Format(_loc2_,param1.MaxLuckyCatCount);
         this.FTextFormatCaption.color = COLOR_ContextDefault;
         this.FPainterDesc.Evaluate(this.FBoundsDesc);
         BoundsContextUnion(this.FBoundsDesc);
      }
      
      protected function EvaluationPerform_Click(param1:TLuckyCat) : void
      {
         var _loc2_:int = 0;
         BoundsAlignDown(this.FBoundsClick,this.FBoundsOffset,SIZE_Padding_02);
         this.FPainterClick.Text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_LUCKYCAT_04);
         this.FTextFormatCaption.color = COLOUR_CLICK;
         this.FPainterClick.Evaluate(this.FBoundsClick);
         BoundsContextUnion(this.FBoundsClick);
      }
      
      override protected function SketchingPerform_Context() : void
      {
         this.SketchingPerform_Caption();
      }
      
      protected function SketchingPerform_Caption() : void
      {
         this.FPainterLuckyCatCaption.RenderBounds(this.FBoundsLuckyCatCaption,TAlignment.HORIZONTAL_Left);
         this.FPainterIncome.RenderBounds(this.FBoundsIncome,TAlignment.HORIZONTAL_Left);
         this.FPainterDesc.RenderBounds(this.FBoundsDesc,TAlignment.HORIZONTAL_Left);
         this.FPainterClick.RenderBounds(this.FBoundsClick,TAlignment.HORIZONTAL_Left);
      }
      
      override protected function RenderingPerform_Context(param1:TCoordinate) : void
      {
         FBoundsRendering.X = FMarginLeft;
         FBoundsRendering.Y = FMarginTop;
         this.FPainterLuckyCatCaption.x = FBoundsRendering.X + this.FBoundsLuckyCatCaption.X;
         this.FPainterLuckyCatCaption.y = FBoundsRendering.Y + this.FBoundsLuckyCatCaption.Y;
         this.FPainterIncome.x = FBoundsRendering.X + this.FBoundsIncome.X;
         this.FPainterIncome.y = FBoundsRendering.Y + this.FBoundsIncome.Y;
         this.FPainterDesc.x = FBoundsRendering.X + this.FBoundsDesc.X;
         this.FPainterDesc.y = FBoundsRendering.Y + this.FBoundsDesc.Y;
         this.FPainterClick.x = FBoundsRendering.X + this.FBoundsClick.X;
         this.FPainterClick.y = FBoundsRendering.Y + this.FBoundsClick.Y;
      }
   }
}

