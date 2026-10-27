package Processors.Game.Battle.GoneWord
{
   import Foundation.Common.TBounds;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityFilter;
   import Foundation.Utilities.TUtilityReflection;
   import Processors.Game.Battle.TBattleHandle;
   import Rendering.Texts.TPainterTextEffect;
   import Resources.Constants.CONST_BATTLE;
   import Resources.Constants.CONST_FONTLIBRARY;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.filters.GlowFilter;
   import ghostcat.util.easing.Back;
   import ghostcat.util.easing.TweenUtil;
   
   public class TGoneWord extends TUIComponent
   {
      
      public static const TYPE_NORMAL:int = 1;
      
      public static const TYPE_MASKBG:int = 2;
      
      protected var FPainterTextEffect:TPainterTextEffect;
      
      protected var FMoveStampX:Number;
      
      protected var FMoveStampY:Number;
      
      protected var FBounds:TBounds;
      
      protected var FBrightness:Number;
      
      protected var FMaskFireBg:Sprite;
      
      protected var FMaskYellowBg:Sprite;
      
      protected var FType:int;
      
      public function TGoneWord(param1:TUIComponent)
      {
         super(param1);
         this.FPainterTextEffect = new TPainterTextEffect(this);
         this.FPainterTextEffect.Font.Name = CONST_FONTLIBRARY.FONT_NAME_Bleach_UI_00;
         this.FBounds = new TBounds();
         this.FMaskFireBg = TUtilityReflection.CreateDisplayObjectInstance(CONST_BATTLE.RESOURCE_ClassName_GoneWordBg) as MovieClip;
         this.FMaskYellowBg = TUtilityReflection.CreateDisplayObjectInstance(CONST_BATTLE.RESOURCE_ClassName_GoneWordYellowBg) as MovieClip;
         addChild(this.FMaskFireBg);
         addChild(this.FMaskYellowBg);
         this.FMaskFireBg.visible = false;
         this.FMaskYellowBg.visible = false;
         this.FMoveStampX = 0;
         this.FMoveStampY = 0;
      }
      
      protected function BigToNormal() : void
      {
         scaleX = 3;
         scaleY = 3;
         TweenUtil.to(this,250 / TBattleHandle.PlaybackRate,{
            "x":this.x + this.FMoveStampX,
            "y":this.y + this.FMoveStampY,
            "scaleX":1,
            "scaleY":1,
            "onComplete":this.BeginMove
         });
      }
      
      protected function BeginMove() : void
      {
         TweenUtil.to(this,600 / TBattleHandle.PlaybackRate,{
            "x":this.x + this.FMoveStampX,
            "y":this.y + this.FMoveStampY,
            "onComplete":this.GoneWhite
         });
      }
      
      protected function GoneWhite() : void
      {
         TweenUtil.to(this,100 / TBattleHandle.PlaybackRate,{
            "Brightness":100,
            "onComplete":this.EndGone
         });
      }
      
      protected function SmallToBig() : void
      {
         scaleX = 0.1;
         scaleY = 0.1;
         TweenUtil.to(this,250 / TBattleHandle.PlaybackRate,{
            "x":this.x + this.FMoveStampX,
            "y":this.y + this.FMoveStampY,
            "scaleX":1,
            "scaleY":1,
            "onComplete":this.BeginStand,
            "ease":Back.easeOut
         });
      }
      
      protected function BeginStand() : void
      {
         TweenUtil.to(this,600 / TBattleHandle.PlaybackRate,{"onComplete":this.AlphaHide});
      }
      
      protected function AlphaHide() : void
      {
         TweenUtil.to(this,100 / TBattleHandle.PlaybackRate,{
            "alpha":0,
            "onComplete":this.EndGone
         });
      }
      
      protected function ShowWaitUp() : void
      {
         TweenUtil.to(this,1000 / TBattleHandle.PlaybackRate,{"onComplete":this.AlphaUpHide});
      }
      
      protected function AlphaUpHide() : void
      {
         TweenUtil.to(this,200 / TBattleHandle.PlaybackRate,{
            "alpha":0,
            "y":this.y - 50,
            "onComplete":this.EndGone
         });
      }
      
      protected function ShowWaitDown() : void
      {
         TweenUtil.to(this,1000 / TBattleHandle.PlaybackRate,{"onComplete":this.AlphaDownHide});
      }
      
      protected function AlphaDownHide() : void
      {
         TweenUtil.to(this,200 / TBattleHandle.PlaybackRate,{
            "alpha":0,
            "y":this.y + 50,
            "onComplete":this.EndGone
         });
      }
      
      protected function EndGone() : void
      {
         if(this.FType == TYPE_NORMAL)
         {
            TPoolEffectGoneWord.SaveGoneWord(this);
         }
         else if(this.FType == TYPE_MASKBG)
         {
            TPoolEffectGoneWord.SaveGoneWordWithBg(this);
         }
         else
         {
            TPoolEffectGoneWord.SaveGoneWord(this);
         }
      }
      
      public function get EffectWidth() : int
      {
         return this.FPainterTextEffect.TextWidth;
      }
      
      public function get EffectHeight() : int
      {
         return this.FPainterTextEffect.TextHeight;
      }
      
      public function set Brightness(param1:Number) : void
      {
         this.FBrightness = param1;
         TUtilityFilter.SetBrightness(this,param1);
      }
      
      public function get Brightness() : Number
      {
         return this.FBrightness;
      }
      
      public function ResetGoneWord() : void
      {
         x = 0;
         y = 0;
         scaleX = 1;
         scaleY = 1;
         this.FMoveStampX = 0;
         this.FMoveStampY = 0;
         this.Brightness = 0;
         alpha = 1;
         this.FPainterTextEffect.Text = "";
         TweenUtil.removeTween(this);
      }
      
      public function SetGoneWord(param1:Number, param2:Number, param3:String, param4:Number = 0, param5:Number = 0, param6:uint = 20, param7:uint = 16777215, param8:uint = 0, param9:String = "Bleach_UI_00") : void
      {
         x = param1;
         y = param2;
         this.FBrightness = 0;
         this.FMoveStampX = param4;
         this.FMoveStampY = param5;
         this.FPainterTextEffect.Font.Name = param9;
         this.FPainterTextEffect.Font.Size = param6;
         this.FPainterTextEffect.Font.Color = param7;
         this.FPainterTextEffect.FontEffect.OutlineColor = param8;
         this.FPainterTextEffect.FontEffect.OutlineSize = 5;
         this.FPainterTextEffect.FontEffect.Outlined = true;
         this.FPainterTextEffect.Text = param3;
         this.FBounds.Width = this.FPainterTextEffect.TextWidth + 5;
         this.FBounds.Height = this.FPainterTextEffect.TextHeight + 5;
         this.FPainterTextEffect.RenderBounds(this.FBounds);
         this.FType = TYPE_NORMAL;
      }
      
      public function SetGoneWordWithBg(param1:Number, param2:Number, param3:String, param4:Number = 0, param5:Number = 0, param6:uint = 62, param7:String = "Bleach_UI_00") : void
      {
         x = param1;
         y = param2;
         this.FMoveStampX = param4;
         this.FMoveStampY = param5;
         this.FPainterTextEffect.Font.Name = param7;
         this.FPainterTextEffect.Font.Size = param6;
         this.FPainterTextEffect.Text = param3;
         this.FBounds.Width = this.FPainterTextEffect.TextWidth + 5;
         this.FBounds.Height = this.FPainterTextEffect.TextHeight + 5;
         this.FPainterTextEffect.RenderBounds(this.FBounds);
         this.FMaskFireBg.mask = this.FPainterTextEffect;
         filters = [new GlowFilter(2887438,1,5,5,20)];
         this.FType = TYPE_MASKBG;
         this.FMaskFireBg.visible = true;
      }
      
      public function SetGoneWordWithYellowBg(param1:Number, param2:Number, param3:String, param4:uint = 40, param5:String = "Bleach_UI_00") : void
      {
         x = param1;
         y = param2;
         this.FPainterTextEffect.Font.Name = param5;
         this.FPainterTextEffect.Font.Size = param4;
         this.FPainterTextEffect.Text = param3;
         this.FBounds.Width = this.FPainterTextEffect.TextWidth + 5;
         this.FBounds.Height = this.FPainterTextEffect.TextHeight + 5;
         this.FPainterTextEffect.RenderBounds(this.FBounds);
         this.FMaskYellowBg.mask = this.FPainterTextEffect;
         filters = [new GlowFilter(2887438,1,5,5,20)];
         this.FType = TYPE_MASKBG;
         this.FMaskYellowBg.visible = true;
      }
      
      public function StartFloat() : void
      {
         this.BigToNormal();
      }
      
      public function StartStand() : void
      {
         this.SmallToBig();
      }
      
      public function StartUp() : void
      {
         this.ShowWaitUp();
      }
      
      public function StartDown() : void
      {
         this.ShowWaitDown();
      }
      
      public function SaveSelf() : void
      {
         this.EndGone();
      }
   }
}

