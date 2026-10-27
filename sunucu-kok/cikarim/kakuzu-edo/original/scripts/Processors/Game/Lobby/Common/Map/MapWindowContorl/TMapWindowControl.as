package Processors.Game.Lobby.Common.Map.MapWindowContorl
{
   import Foundation.Common.TCoordinate;
   import Logics.Map.TMapParameter;
   import Processors.Game.Lobby.Common.Map.DrawMap.TDrawMapTwo;
   
   public class TMapWindowControl
   {
      
      protected var FMapDrawer:TDrawMapTwo;
      
      protected var FModify:Boolean;
      
      protected var FMapParameter:TMapParameter;
      
      public function TMapWindowControl(param1:TMapParameter, param2:TDrawMapTwo)
      {
         super();
         this.FMapParameter = param1;
         this.FMapDrawer = param2;
      }
      
      protected function ReLocationCoordinate(param1:TCoordinate) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         _loc2_ = this.FMapParameter.MapData.MapWidth - this.FMapParameter.ScreenBounds.Width;
         _loc3_ = this.FMapParameter.MapData.MapHeight - this.FMapParameter.ScreenBounds.Height;
         param1.X = param1.X > _loc2_ ? _loc2_ : param1.X;
         param1.X = param1.X < 0 ? 0 : param1.X;
         param1.Y = param1.Y > _loc3_ ? _loc3_ : param1.Y;
         param1.Y = param1.Y < 0 ? 0 : param1.Y;
      }
      
      public function get MapDrawer() : TDrawMapTwo
      {
         return this.FMapDrawer;
      }
      
      public function set MapDrawer(param1:TDrawMapTwo) : void
      {
         this.FMapDrawer = param1;
      }
      
      public function Update() : void
      {
      }
      
      public function Modify() : void
      {
         this.FModify = true;
      }
      
      public function Release() : void
      {
      }
   }
}

