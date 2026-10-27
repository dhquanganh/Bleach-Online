package Processors.Game.Common.Effects.Display
{
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.geom.Point;
   
   public class TEffectBase extends Sprite
   {
      
      protected var FSource:DisplayObject;
      
      protected var FIsRunOver:Boolean;
      
      protected var FCallBack:Function;
      
      public function TEffectBase()
      {
         super();
         this.mouseEnabled = false;
         this.mouseChildren = false;
      }
      
      public static function MoveToPosition(param1:DisplayObject, param2:Point) : void
      {
         param1.x = param2.x;
         param1.y = param2.y;
      }
      
      public function get Source() : DisplayObject
      {
         return this.FSource;
      }
      
      public function set Source(param1:DisplayObject) : void
      {
         this.FSource = param1;
      }
      
      public function get IsRunOver() : Boolean
      {
         return this.FIsRunOver;
      }
      
      public function set IsRunOver(param1:Boolean) : void
      {
         this.FIsRunOver = param1;
      }
      
      public function get CallBack() : Function
      {
         return this.FCallBack;
      }
      
      public function set CallBack(param1:Function) : void
      {
         this.FCallBack = param1;
      }
      
      public function Reset() : void
      {
      }
      
      public function Run() : void
      {
      }
      
      public function Dispose() : void
      {
      }
   }
}

