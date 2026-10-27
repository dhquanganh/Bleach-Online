package Rendering.Overlayers.TOverlayerCustomHero
{
   import Foundation.Common.TBounds;
   import Foundation.Common.TCoordinate;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityString;
   import Logics.CustomHero.TCustomHero;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Rendering.Overlayers.TOverlayer;
   import Rendering.Texts.TPainterHtmlTextEffect;
   import Rendering.Texts.TPainterTextEffect;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.display.Bitmap;
   import flash.text.TextFormat;
   
   public class TOverlayerCustomHero extends TOverlayer
   {
      
      protected static const SIZE_Padding_01:uint = 15;
      
      protected static const SIZE_Padding_02:uint = 10;
      
      protected static const SIZE_Padding_03:uint = 5;
      
      protected static const SIZE_DividingLine_Max_Width:int = 248;
      
      protected static const COLOR_Context:uint = 4294940979;
      
      protected var FPainterTitle:TPainterTextEffect;
      
      protected var FDividingLines:Vector.<Bitmap>;
      
      protected var FPainterAttributesCaption:Vector.<TPainterHtmlTextEffect>;
      
      protected var FPainterAttributes:Vector.<TPainterHtmlTextEffect>;
      
      protected var FPainterSkillsCaption:Vector.<TPainterHtmlTextEffect>;
      
      protected var FPainterSkills:Vector.<TPainterHtmlTextEffect>;
      
      protected var FBoundsDividLine:Vector.<TBounds>;
      
      protected var FBoundsAttributesCaption:Vector.<TBounds>;
      
      protected var FBoundsAttributes:Vector.<TBounds>;
      
      protected var FBoundsSkillsCaption:Vector.<TBounds>;
      
      protected var FBoundsSkills:Vector.<TBounds>;
      
      protected var FCurHero:TCustomHero;
      
      protected var FBoundsTitle:TBounds;
      
      protected var FBoundsOffset:TBounds;
      
      protected var FTextFormat:TextFormat;
      
      protected var FOldHeroID:uint;
      
      protected var FChangeLevelNames:Vector.<String>;
      
      public function TOverlayerCustomHero(param1:TUIComponent)
      {
         super(param1);
         this.FDividingLines = new Vector.<Bitmap>();
         this.FPainterAttributesCaption = new Vector.<TPainterHtmlTextEffect>();
         this.FPainterAttributes = new Vector.<TPainterHtmlTextEffect>();
         this.FPainterSkillsCaption = new Vector.<TPainterHtmlTextEffect>();
         this.FPainterSkills = new Vector.<TPainterHtmlTextEffect>();
         this.FBoundsDividLine = new Vector.<TBounds>();
         this.FBoundsAttributesCaption = new Vector.<TBounds>();
         this.FBoundsAttributes = new Vector.<TBounds>();
         this.FBoundsSkillsCaption = new Vector.<TBounds>();
         this.FBoundsSkills = new Vector.<TBounds>();
         FWordWrapWidth = 300;
         this.FTextFormat = new TextFormat();
         FMarginLeft = 15;
         FMarginTop = 15;
         FMarginRight = 15;
         FMarginBottom = 15;
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
      }
      
      override protected function ContextVerificate(param1:Object) : Boolean
      {
         return param1 is TCustomHero;
      }
      
      override protected function ContextModified() : Boolean
      {
         var _loc1_:TCustomHero = null;
         var _loc2_:Boolean = false;
         _loc1_ = FContext as TCustomHero;
         return this.FOldHeroID != _loc1_.Identifier;
      }
      
      override protected function ContextSynchronize() : void
      {
         this.FCurHero = FContext as TCustomHero;
         this.FBoundsOffset = this.FBoundsTitle;
         this.DataReset();
         this.ConstructAttributes(this.FCurHero);
         this.ConstructSkill(this.FCurHero);
         this.FOldHeroID = this.FCurHero.Identifier;
      }
      
      protected function ConstructAttributes(param1:TCustomHero) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Bitmap = null;
         var _loc5_:TPainterHtmlTextEffect = null;
         var _loc6_:TBounds = null;
         _loc2_ = 0;
         while(_loc2_ < 4)
         {
            _loc5_ = ConstructPainterHtmlTextEffect(COLOR_Context);
            _loc5_.Font.Bold = true;
            this.FPainterAttributesCaption.push(_loc5_);
            _loc5_ = ConstructPainterHtmlTextEffect(COLOR_Context);
            _loc5_.Font.Bold = false;
            _loc5_.Multilineable = true;
            this.FPainterAttributes.push(_loc5_);
            this.FBoundsAttributesCaption.push(new TBounds());
            this.FBoundsAttributes.push(new TBounds());
            _loc2_++;
         }
      }
      
      protected function ConstructSkill(param1:TCustomHero) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Bitmap = null;
         var _loc5_:TPainterHtmlTextEffect = null;
         var _loc6_:TBounds = null;
         _loc2_ = 0;
         while(_loc2_ < 3)
         {
            _loc5_ = ConstructPainterHtmlTextEffect(COLOR_Context);
            _loc5_.Font.Bold = true;
            this.FPainterSkillsCaption.push(_loc5_);
            _loc5_ = ConstructPainterHtmlTextEffect(COLOR_Context);
            _loc5_.Font.Bold = false;
            _loc5_.WordWrap = true;
            _loc5_.Multilineable = true;
            this.FPainterSkills.push(_loc5_);
            this.FBoundsSkillsCaption.push(new TBounds());
            this.FBoundsSkills.push(new TBounds());
            _loc2_++;
         }
      }
      
      protected function DataReset() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         super.Reset();
         _loc2_ = int(this.FPainterAttributesCaption.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.removeChild(this.FPainterAttributesCaption[_loc1_]);
            this.removeChild(this.FPainterAttributes[_loc1_]);
            _loc1_++;
         }
         _loc2_ = int(this.FPainterSkillsCaption.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.removeChild(this.FPainterSkillsCaption[_loc1_]);
            this.removeChild(this.FPainterSkills[_loc1_]);
            _loc1_++;
         }
         this.FPainterAttributesCaption.length = 0;
         this.FBoundsAttributesCaption.length = 0;
         this.FPainterAttributes.length = 0;
         this.FBoundsAttributes.length = 0;
         this.FPainterSkillsCaption.length = 0;
         this.FBoundsSkillsCaption.length = 0;
         this.FPainterSkills.length = 0;
         this.FBoundsSkills.length = 0;
      }
      
      override protected function EvaluationPerform_Context() : void
      {
         this.EvaluationPerform_Hero(this.FCurHero);
      }
      
      protected function EvaluationPerform_Hero(param1:TCustomHero) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TBounds = null;
         _loc2_ = 0;
         while(_loc2_ < 4)
         {
            _loc4_ = this.FBoundsAttributesCaption[_loc2_];
            BoundsAlignDown(_loc4_,this.FBoundsOffset,SIZE_Padding_03);
            this.FPainterAttributesCaption[_loc2_].Text = "<font color=\'#FFFF00FF\' size=\'13\' font-weight=\'bold\'>" + TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.Exclusive_AllTextTip01),param1.HeroCongfig.GrowthLimit[_loc2_]) + "</font>";
            this.FPainterAttributesCaption[_loc2_].Evaluate(_loc4_);
            BoundsContextUnion(_loc4_);
            this.FBoundsOffset = _loc4_;
            _loc4_ = this.FBoundsAttributes[_loc2_];
            BoundsAlignDown(_loc4_,this.FBoundsOffset,SIZE_Padding_03);
            this.FPainterAttributes[_loc2_].Text = "<font color=\'#FF00FF00\'>" + TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.Exclusive_AllTextTip02),Number(param1.HeroCongfig.Growth[0] * (_loc2_ + 1)).toFixed(2),Number(param1.HeroCongfig.Growth[1] * (_loc2_ + 1)).toFixed(2),Number(param1.HeroCongfig.Growth[2] * (_loc2_ + 1)).toFixed(2),Number(param1.HeroCongfig.Growth[3] * (_loc2_ + 1)).toFixed(2)) + " </font>";
            this.FPainterAttributes[_loc2_].Evaluate(_loc4_);
            BoundsContextUnion(_loc4_);
            this.FBoundsOffset = _loc4_;
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < param1.HeroCongfig.ExclusiveLimit.length)
         {
            _loc4_ = this.FBoundsSkillsCaption[_loc2_];
            BoundsAlignDown(_loc4_,this.FBoundsOffset,SIZE_Padding_03);
            this.FPainterSkillsCaption[_loc2_].Text = "<font color=\'#FFFF00FF\' size=\'13\' font-weight=\'bold\'>" + TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.Exclusive_AllTextTip01),param1.HeroCongfig.ExclusiveLimit[_loc2_]) + "</font>";
            this.FPainterSkillsCaption[_loc2_].Evaluate(_loc4_);
            BoundsContextUnion(_loc4_);
            this.FBoundsOffset = _loc4_;
            _loc4_ = this.FBoundsSkills[_loc2_];
            BoundsAlignDown(_loc4_,this.FBoundsOffset,SIZE_Padding_03);
            this.FPainterSkills[_loc2_].Text = "<font color=\'#FF00FF00\'>" + param1.SkillNames[_loc2_] + "</font>";
            this.FPainterSkills[_loc2_].Evaluate(_loc4_);
            BoundsContextUnion(_loc4_);
            this.FBoundsOffset = _loc4_;
            _loc2_++;
         }
      }
      
      override protected function RenderingPerform_Context(param1:TCoordinate) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         FBoundsRendering.X = FMarginLeft;
         FBoundsRendering.Y = FMarginTop;
         _loc2_ = 0;
         while(_loc2_ < 4)
         {
            this.FPainterAttributesCaption[_loc2_].X = FBoundsRendering.X;
            this.FPainterAttributesCaption[_loc2_].Y = FBoundsRendering.Y + this.FBoundsAttributesCaption[_loc2_].Y;
            this.FPainterAttributes[_loc2_].X = FBoundsRendering.X;
            this.FPainterAttributes[_loc2_].Y = FBoundsRendering.Y + this.FBoundsAttributes[_loc2_].Y;
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < this.FCurHero.HeroCongfig.ExclusiveLimit.length)
         {
            this.FPainterSkillsCaption[_loc2_].X = FBoundsRendering.X;
            this.FPainterSkillsCaption[_loc2_].Y = FBoundsRendering.Y + this.FBoundsSkillsCaption[_loc2_].Y;
            this.FPainterSkills[_loc2_].X = FBoundsRendering.X;
            this.FPainterSkills[_loc2_].Y = FBoundsRendering.Y + this.FBoundsSkills[_loc2_].Y;
            _loc2_++;
         }
      }
   }
}

