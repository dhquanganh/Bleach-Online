package Processors.Game.Lobby.Common.Map.MapWindowContorl
{
   import Foundation.Common.TBounds;
   import Foundation.Common.TCoordinate;
   import Logics.Map.TMapParameter;
   import Processors.Game.Lobby.Common.Map.DrawMap.TDrawMapTwo;
   
   public class TMapWindowControlCoordinate extends TMapWindowControl
   {
      
      protected var FBounds:TBounds;
      
      protected var FFollowCoordinate:TCoordinate;
      
      public function TMapWindowControlCoordinate(param1:TCoordinate, param2:TMapParameter, param3:TDrawMapTwo)
      {
         super(param2,param3);
         this.FFollowCoordinate = param1;
         this.FBounds = new TBounds();
      }
      
      protected function MoveScreen() : void
      {
         if(FMapParameter.MapData == null)
         {
            return;
         }
         this.FBounds.X = this.FFollowCoordinate.X - (FMapParameter.ScreenBounds.Width >> 1);
         this.FBounds.Y = this.FFollowCoordinate.Y - (FMapParameter.ScreenBounds.Height >> 1);
         this.FBounds.Width = FMapParameter.ScreenBounds.Width;
         this.FBounds.Height = FMapParameter.ScreenBounds.Height;
         ReLocationCoordinate(this.FBounds);
         FMapParameter.ScreenBounds.Assign(this.FBounds);
         FMapDrawer.SetScreenShowArea(this.FBounds);
      }
      
      override public function Update() : void
      {
         super.Update();
         this.MoveScreen();
      }
   }
}

