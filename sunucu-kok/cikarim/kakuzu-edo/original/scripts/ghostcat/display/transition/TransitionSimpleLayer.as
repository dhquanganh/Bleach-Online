package ghostcat.display.transition
{
   import flash.display.Shape;
   
   public class TransitionSimpleLayer extends TransitionObjectLayer
   {
      
      public function TransitionSimpleLayer(param1:*, param2:Number, param3:Number, param4:uint = 16777215, param5:String = "normal", param6:int = 1000, param7:int = 1000, param8:Boolean = false, param9:Function = null, param10:Function = null)
      {
         var _loc11_:Shape = new Shape();
         _loc11_.graphics.beginFill(param4);
         _loc11_.graphics.drawRect(0,0,param2,param3);
         _loc11_.graphics.endFill();
         _loc11_.blendMode = param5;
         super(param1,_loc11_,null,param6,param7,param8,param9,param10);
      }
   }
}

