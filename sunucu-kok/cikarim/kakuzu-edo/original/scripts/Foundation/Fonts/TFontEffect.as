package Foundation.Fonts
{
   import Foundation.Common.Stubs.TStubModification;
   
   public class TFontEffect
   {
      
      protected var FStubModification:TStubModification;
      
      protected var FAntiAliased:Boolean;
      
      protected var FGradiented:Boolean;
      
      protected var FGradientColorBegin:uint;
      
      protected var FGradientColorCenter:uint;
      
      protected var FGradientColorEnd:uint;
      
      protected var FGradientCenter:uint;
      
      protected var FGradientRotation:Number;
      
      protected var FOutlined:Boolean;
      
      protected var FOutlineSize:int;
      
      protected var FOutlineColor:uint;
      
      protected var FOutlineIntensity:int;
      
      protected var FShadowed:Boolean;
      
      protected var FShadowDistance:int;
      
      protected var FShadowAngle:int;
      
      protected var FShadowBlur:int;
      
      protected var FShadowColor:uint;
      
      public function TFontEffect(param1:TStubModification = null)
      {
         super();
         this.FStubModification = param1;
         this.FGradientColorBegin = 4284506367;
         this.FGradientColorCenter = 4292927743;
         this.FGradientColorEnd = 4282401023;
         this.FGradientCenter = 127;
         this.FGradientRotation = Math.PI / 2;
         this.FOutlineSize = 2;
         this.FOutlineColor = 4278190080;
         this.FOutlineIntensity = 4;
         this.FShadowDistance = 2;
         this.FShadowAngle = 45;
         this.FShadowBlur = 2;
         this.FShadowColor = 2147483648;
      }
      
      protected function ModificationUpdate() : void
      {
         if(this.FStubModification != null)
         {
            this.FStubModification.Modified = true;
         }
      }
      
      public function get AntiAliased() : Boolean
      {
         return this.FAntiAliased;
      }
      
      public function set AntiAliased(param1:Boolean) : void
      {
         if(param1 != this.FAntiAliased)
         {
            this.FAntiAliased = param1;
            this.ModificationUpdate();
         }
      }
      
      public function get Gradiented() : Boolean
      {
         return this.FGradiented;
      }
      
      public function set Gradiented(param1:Boolean) : void
      {
         if(param1 != this.FGradiented)
         {
            this.FGradiented = param1;
            this.ModificationUpdate();
         }
      }
      
      public function get GradientColorBegin() : uint
      {
         return this.FGradientColorBegin;
      }
      
      public function set GradientColorBegin(param1:uint) : void
      {
         if(param1 != this.FGradientColorBegin)
         {
            this.FGradientColorBegin = param1;
            this.ModificationUpdate();
         }
      }
      
      public function get GradientColorCenter() : uint
      {
         return this.FGradientColorCenter;
      }
      
      public function set GradientColorCenter(param1:uint) : void
      {
         if(param1 != this.FGradientColorCenter)
         {
            this.FGradientColorCenter = param1;
            this.ModificationUpdate();
         }
      }
      
      public function get GradientColorEnd() : uint
      {
         return this.FGradientColorEnd;
      }
      
      public function set GradientColorEnd(param1:uint) : void
      {
         if(param1 != this.FGradientColorEnd)
         {
            this.FGradientColorEnd = param1;
            this.ModificationUpdate();
         }
      }
      
      public function get GradientCenter() : uint
      {
         return this.FGradientCenter;
      }
      
      public function set GradientCenter(param1:uint) : void
      {
         if(param1 > 255)
         {
            param1 = 255;
         }
         if(param1 != this.FGradientCenter)
         {
            this.FGradientCenter = param1;
            this.ModificationUpdate();
         }
      }
      
      public function get GradientRotation() : Number
      {
         return this.FGradientRotation;
      }
      
      public function set GradientRotation(param1:Number) : void
      {
         if(param1 != this.FGradientRotation)
         {
            this.FGradientRotation = param1;
            this.ModificationUpdate();
         }
      }
      
      public function get Outlined() : Boolean
      {
         return this.FOutlined;
      }
      
      public function set Outlined(param1:Boolean) : void
      {
         if(param1 != this.FOutlined)
         {
            this.FOutlined = param1;
            this.ModificationUpdate();
         }
      }
      
      public function get OutlineSize() : int
      {
         return this.FOutlineSize;
      }
      
      public function set OutlineSize(param1:int) : void
      {
         if(param1 < 0)
         {
            param1 = 0;
         }
         if(param1 != this.FOutlineSize)
         {
            this.FOutlineSize = param1;
            this.ModificationUpdate();
         }
      }
      
      public function get OutlineColor() : uint
      {
         return this.FOutlineColor;
      }
      
      public function set OutlineColor(param1:uint) : void
      {
         if(param1 != this.FOutlineColor)
         {
            this.FOutlineColor = param1;
            this.ModificationUpdate();
         }
      }
      
      public function get OutlineIntensity() : int
      {
         return this.FOutlineIntensity;
      }
      
      public function set OutlineIntensity(param1:int) : void
      {
         if(param1 < 0)
         {
            param1 = 0;
         }
         if(param1 > 16)
         {
            param1 = 16;
         }
         if(param1 != this.FOutlineIntensity)
         {
            this.FOutlineIntensity = param1;
            this.ModificationUpdate();
         }
      }
      
      public function get Shadowed() : Boolean
      {
         return this.FShadowed;
      }
      
      public function set Shadowed(param1:Boolean) : void
      {
         if(param1 != this.FShadowed)
         {
            this.FShadowed = param1;
            this.ModificationUpdate();
         }
      }
      
      public function get ShadowDistance() : int
      {
         return this.FShadowDistance;
      }
      
      public function set ShadowDistance(param1:int) : void
      {
         if(param1 <= 0)
         {
            param1 = 0;
         }
         if(param1 != this.FShadowDistance)
         {
            this.FShadowDistance = param1;
            this.ModificationUpdate();
         }
      }
      
      public function get ShadowAngle() : int
      {
         return this.FShadowAngle;
      }
      
      public function set ShadowAngle(param1:int) : void
      {
         if(param1 != this.FShadowAngle)
         {
            this.FShadowAngle = param1;
            this.ModificationUpdate();
         }
      }
      
      public function get ShadowBlur() : int
      {
         return this.FShadowBlur;
      }
      
      public function set ShadowBlur(param1:int) : void
      {
         if(param1 < 0)
         {
            param1 = 0;
         }
         if(param1 != this.FShadowBlur)
         {
            this.FShadowBlur = param1;
            this.ModificationUpdate();
         }
      }
      
      public function get ShadowColor() : uint
      {
         return this.FShadowColor;
      }
      
      public function set ShadowColor(param1:uint) : void
      {
         if(param1 != this.FShadowColor)
         {
            this.FShadowColor = param1;
            this.ModificationUpdate();
         }
      }
      
      public function Assign(param1:TFontEffect) : void
      {
         var _loc2_:Boolean = false;
         _loc2_ = false;
         if(this.FAntiAliased != param1.FAntiAliased)
         {
            this.FAntiAliased = param1.FAntiAliased;
            _loc2_ = true;
         }
         if(this.FGradiented != param1.FGradiented)
         {
            this.FGradiented = param1.FGradiented;
            _loc2_ = true;
         }
         if(this.FGradientColorBegin != param1.FGradientColorBegin)
         {
            this.FGradientColorBegin = param1.FGradientColorBegin;
            _loc2_ = true;
         }
         if(this.FGradientColorCenter != param1.FGradientColorCenter)
         {
            this.FGradientColorCenter = param1.FGradientColorCenter;
            _loc2_ = true;
         }
         if(this.FGradientColorEnd != param1.FGradientColorEnd)
         {
            this.FGradientColorEnd = param1.FGradientColorEnd;
            _loc2_ = true;
         }
         if(this.FGradientCenter != param1.FGradientCenter)
         {
            this.FGradientCenter = param1.FGradientCenter;
            _loc2_ = true;
         }
         if(this.FGradientRotation != param1.FGradientRotation)
         {
            this.FGradientRotation = param1.FGradientRotation;
            _loc2_ = true;
         }
         if(this.FOutlined != param1.FOutlined)
         {
            this.FOutlined = param1.FOutlined;
            _loc2_ = true;
         }
         if(this.FOutlineSize != param1.FOutlineSize)
         {
            this.FOutlineSize = param1.FOutlineSize;
            _loc2_ = true;
         }
         if(this.FOutlineColor != param1.FOutlineColor)
         {
            this.FOutlineColor = param1.FOutlineColor;
            _loc2_ = true;
         }
         if(this.FOutlineIntensity != param1.FOutlineIntensity)
         {
            this.FOutlineIntensity = param1.FOutlineIntensity;
            _loc2_ = true;
         }
         if(this.FShadowed != param1.FShadowed)
         {
            this.FShadowed = param1.FShadowed;
            _loc2_ = true;
         }
         if(this.FShadowDistance != param1.FShadowDistance)
         {
            this.FShadowDistance = param1.FShadowDistance;
            _loc2_ = true;
         }
         if(this.FShadowAngle != param1.FShadowAngle)
         {
            this.FShadowAngle = param1.FShadowAngle;
            _loc2_ = true;
         }
         if(this.FShadowBlur != param1.FShadowBlur)
         {
            this.FShadowBlur = param1.FShadowBlur;
            _loc2_ = true;
         }
         if(this.FShadowColor != param1.FShadowColor)
         {
            this.FShadowColor = param1.FShadowColor;
            _loc2_ = true;
         }
         if(_loc2_)
         {
            this.ModificationUpdate();
         }
      }
   }
}

