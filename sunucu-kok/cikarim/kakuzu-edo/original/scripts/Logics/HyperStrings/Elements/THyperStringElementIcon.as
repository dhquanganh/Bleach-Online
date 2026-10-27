package Logics.HyperStrings.Elements
{
   public class THyperStringElementIcon extends THyperStringElementGraphical
   {
      
      protected var FIDIcon:uint;
      
      public function THyperStringElementIcon()
      {
         super();
      }
      
      public function get IDIcon() : uint
      {
         return this.FIDIcon;
      }
      
      public function set IDIcon(param1:uint) : void
      {
         this.FIDIcon = param1;
      }
      
      override public function Reset() : void
      {
         super.Reset();
         this.FIDIcon = 0;
      }
      
      override public function FlushElement(param1:THyperStringElement) : void
      {
         var _loc2_:THyperStringElementIcon = null;
         _loc2_ = param1 as THyperStringElementIcon;
         _loc2_.IDIcon = this.FIDIcon;
         _loc2_.Tag = FTag;
      }
   }
}

