package Rendering.Overlayers.TOverlayerCustomHero
{
   import Foundation.Common.TBounds;
   import Foundation.Common.TCoordinate;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityString;
   import Logics.CustomHero.TCurHero;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Rendering.Overlayers.TOverlayer;
   import Rendering.Texts.TPainterHtmlTextEffect;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.display.Bitmap;
   
   public class TOverlayerCurHero extends TOverlayer
   {
      
      protected static const SIZE_Padding_01:uint = 15;
      
      protected static const SIZE_Padding_02:uint = 10;
      
      protected static const SIZE_Padding_03:uint = 5;
      
      protected static const SIZE_DividingLine_Max_Width:int = 248;
      
      protected static const COLOR_Context:uint = 4294940979;
      
      protected var FPainterTitle:TPainterHtmlTextEffect;
      
      protected var FDividingLines:Vector.<Bitmap>;
      
      protected var FPainterAttributes:Vector.<TPainterHtmlTextEffect>;
      
      protected var FPainterExtra:TPainterHtmlTextEffect;
      
      protected var FPainterSkills:Vector.<TPainterHtmlTextEffect>;
      
      protected var FBoundsDividLine:Vector.<TBounds>;
      
      protected var FBoundsAttributes:Vector.<TBounds>;
      
      protected var FBoundsExtra:TBounds;
      
      protected var FBoundsSkills:Vector.<TBounds>;
      
      protected var FCurHero:TCurHero;
      
      protected var FBoundsTitle:TBounds;
      
      protected var FBoundsOffset:TBounds;
      
      protected var FOldHeroId:uint;
      
      protected var FOldHerolv:uint;
      
      public function TOverlayerCurHero(param1:TUIComponent)
      {
         super(param1);
         this.FPainterTitle = ConstructPainterHtmlTextEffect();
         this.FBoundsTitle = new TBounds();
         this.FDividingLines = new Vector.<Bitmap>();
         this.FPainterAttributes = new Vector.<TPainterHtmlTextEffect>();
         this.FPainterSkills = new Vector.<TPainterHtmlTextEffect>();
         this.FPainterExtra = ConstructPainterHtmlTextEffect();
         this.FBoundsDividLine = new Vector.<TBounds>();
         this.FBoundsAttributes = new Vector.<TBounds>();
         this.FBoundsSkills = new Vector.<TBounds>();
         this.FBoundsExtra = new TBounds();
         FWordWrapWidth = 300;
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
         return param1 is TCurHero;
      }
      
      override protected function ContextModified() : Boolean
      {
         var _loc1_:TCurHero = null;
         var _loc2_:Boolean = false;
         _loc1_ = FContext as TCurHero;
         if(this.FOldHeroId == _loc1_.Identifier && this.FOldHerolv == _loc1_.Level)
         {
            return true;
         }
         return false;
      }
      
      override protected function ContextSynchronize() : void
      {
         this.FCurHero = FContext as TCurHero;
         this.DataReset();
         this.FBoundsOffset = this.FBoundsTitle;
         this.ConstructTitle(this.FCurHero);
         this.ConstructAttributes(this.FCurHero);
         this.ConstructExtra(this.FCurHero);
         this.ConstructSkill(this.FCurHero);
         this.FOldHeroId = this.FCurHero.Identifier;
         this.FOldHerolv = this.FCurHero.Level;
      }
      
      protected function ConstructTitle(param1:TCurHero) : void
      {
         var _loc2_:TPainterHtmlTextEffect = null;
         var _loc3_:TBounds = null;
         _loc2_ = ConstructPainterHtmlTextEffect(COLOR_Context);
         _loc2_.Font.Bold = true;
         this.FPainterTitle = _loc2_;
         this.FBoundsTitle = new TBounds();
      }
      
      protected function ConstructExtra(param1:TCurHero) : void
      {
         var _loc2_:TPainterHtmlTextEffect = null;
         var _loc3_:TBounds = null;
         _loc2_ = ConstructPainterHtmlTextEffect(COLOR_Context);
         _loc2_.Font.Bold = true;
         _loc2_.Multilineable = true;
         this.FPainterExtra = _loc2_;
         this.FBoundsExtra = new TBounds();
      }
      
      protected function ConstructAttributes(param1:TCurHero) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Bitmap = null;
         var _loc5_:TPainterHtmlTextEffect = null;
         var _loc6_:TBounds = null;
         _loc2_ = 0;
         while(_loc2_ < 1)
         {
            _loc5_ = ConstructPainterHtmlTextEffect(COLOR_Context);
            _loc5_.Font.Bold = false;
            _loc5_.Multilineable = true;
            this.FPainterAttributes.push(_loc5_);
            this.FBoundsAttributes.push(new TBounds());
            _loc2_++;
         }
      }
      
      protected function ConstructSkill(param1:TCurHero) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Bitmap = null;
         var _loc5_:TPainterHtmlTextEffect = null;
         var _loc6_:TBounds = null;
         _loc2_ = 0;
         while(_loc2_ < 1)
         {
            _loc5_ = ConstructPainterHtmlTextEffect(COLOR_Context);
            _loc5_.Font.Bold = false;
            _loc5_.WordWrap = true;
            _loc5_.Multilineable = true;
            this.FPainterSkills.push(_loc5_);
            this.FBoundsSkills.push(new TBounds());
            _loc2_++;
         }
      }
      
      protected function DataReset() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         super.Reset();
         this.removeChild(this.FPainterTitle);
         this.removeChild(this.FPainterExtra);
         _loc2_ = int(this.FPainterAttributes.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.removeChild(this.FPainterAttributes[_loc1_]);
            _loc1_++;
         }
         _loc2_ = int(this.FPainterSkills.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.removeChild(this.FPainterSkills[_loc1_]);
            _loc1_++;
         }
         this.FPainterTitle = null;
         this.FPainterExtra = null;
         this.FPainterAttributes.length = 0;
         this.FBoundsAttributes.length = 0;
         this.FBoundsTitle = null;
         this.FBoundsExtra = null;
         this.FPainterSkills.length = 0;
         this.FBoundsSkills.length = 0;
      }
      
      override protected function EvaluationPerform_Context() : void
      {
         this.EvaluationPerform_Hero(this.FCurHero);
      }
      
      protected function EvaluationPerform_Hero(param1:TCurHero) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TBounds = null;
         _loc4_ = this.FBoundsTitle;
         BoundsAlignDown(_loc4_,this.FBoundsOffset,SIZE_Padding_03);
         this.FPainterTitle.Text = "<font color=\'#FFFF00FF\' size=\'15\' font-weight=\'bold\'>" + TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.Exclusive_ItemTextTip01),param1.HeroName) + "</font>";
         this.FPainterTitle.Evaluate(_loc4_);
         BoundsContextUnion(_loc4_);
         this.FBoundsOffset = _loc4_;
         _loc2_ = 0;
         while(_loc2_ < 1)
         {
            _loc4_ = this.FBoundsAttributes[_loc2_];
            BoundsAlignDown(_loc4_,this.FBoundsOffset,SIZE_Padding_03);
            this.FPainterAttributes[_loc2_].Text = "<font color=\'#FF00FF00\'>" + TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.Exclusive_AllTextTip02),Number(param1.CurGrowth[0]).toFixed(2),Number(param1.CurGrowth[1]).toFixed(2),Number(param1.CurGrowth[2]).toFixed(2),Number(param1.CurGrowth[3]).toFixed(2)) + " </font>";
            this.FPainterAttributes[_loc2_].Evaluate(_loc4_);
            BoundsContextUnion(_loc4_);
            this.FBoundsOffset = _loc4_;
            _loc2_++;
         }
         _loc4_ = this.FBoundsExtra;
         BoundsAlignDown(_loc4_,this.FBoundsOffset,0);
         this.FPainterExtra.Text = "<font color=\'#FF00FF00\'>" + TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.Exclusive_ItemTextTip03),Number(param1.CurExtra[0]).toFixed(0),Number(param1.CurExtra[1]).toFixed(0),Number(param1.CurExtra[2]).toFixed(0),Number(param1.CurExtra[3]).toFixed(0)) + " </font>";
         this.FPainterExtra.Evaluate(_loc4_);
         BoundsContextUnion(_loc4_);
         this.FBoundsOffset = _loc4_;
         _loc2_ = 0;
         while(_loc2_ < 1)
         {
            _loc4_ = this.FBoundsSkills[_loc2_];
            BoundsAlignDown(_loc4_,this.FBoundsOffset,0);
            if(param1.HeroCongfig.ExclusiveLimit.length == 0)
            {
               this.FPainterSkills[_loc2_].Text = "<font color=\'#FF00FF00\'>" + TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.Exclusive_PanelText15) + "</font>";
            }
            else if(param1.Level == 0)
            {
               this.FPainterSkills[_loc2_].Text = "<font color=\'#FF00FF00\'>" + TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.Exclusive_CloseViewTxt) + "</font>";
            }
            else
            {
               this.FPainterSkills[_loc2_].Text = "<font color=\'#FFffeccc\'>" + param1.CurSkillDesc + "</font>";
            }
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
         this.FPainterTitle.X = FBoundsRendering.X;
         this.FPainterTitle.Y = FBoundsRendering.Y;
         _loc2_ = 0;
         while(_loc2_ < 1)
         {
            this.FPainterAttributes[_loc2_].X = FBoundsRendering.X;
            this.FPainterAttributes[_loc2_].Y = FBoundsRendering.Y + this.FBoundsAttributes[_loc2_].Y;
            _loc2_++;
         }
         this.FPainterExtra.X = FBoundsRendering.X;
         this.FPainterExtra.Y = FBoundsRendering.Y + this.FBoundsExtra.Y;
         _loc2_ = 0;
         while(_loc2_ < 1)
         {
            this.FPainterSkills[_loc2_].X = FBoundsRendering.X;
            this.FPainterSkills[_loc2_].Y = FBoundsRendering.Y + this.FBoundsSkills[_loc2_].Y;
            _loc2_++;
         }
      }
   }
}

