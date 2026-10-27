package Logics.HyperStrings.Atoms
{
   import Foundation.Common.TCoordinate;
   import Foundation.Fonts.TFont;
   import Foundation.Fonts.TFontEffect;
   import Foundation.UI.TUIComponent;
   import Rendering.Texts.TPainterTextEffect;
   
   public class THyperStringAtomTextual extends THyperStringAtom
   {
      
      protected var FRenderingPainterText:TPainterTextEffect;
      
      protected var FCoordinate:TCoordinate;
      
      public function THyperStringAtomTextual(param1:TUIComponent)
      {
         super(param1);
         this.FRenderingPainterText = this.ConstructPainterTextEffect();
         this.FCoordinate = new TCoordinate();
      }
      
      protected function ConstructPainterTextEffect() : TPainterTextEffect
      {
         var _loc1_:TPainterTextEffect = null;
         return new TPainterTextEffect(this);
      }
      
      public function get Font() : TFont
      {
         return this.FRenderingPainterText.Font;
      }
      
      public function get FontEffect() : TFontEffect
      {
         return this.FRenderingPainterText.FontEffect;
      }
      
      public function get Text() : String
      {
         return this.FRenderingPainterText.Text;
      }
      
      public function set Text(param1:String) : void
      {
         if(param1 == null)
         {
            param1 = "";
         }
         this.FRenderingPainterText.Text = param1;
      }
      
      override public function Reset() : void
      {
         super.Reset();
         this.FRenderingPainterText.Text = "";
      }
      
      override public function Render() : void
      {
         this.FRenderingPainterText.Render(this.FCoordinate);
      }
   }
}

