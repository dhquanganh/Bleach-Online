package Processors.Game.Lobby.RelatedPartner.BattleReady
{
   import flash.display.Bitmap;
   
   public interface IRelatedReadySlot
   {
      
      function get Level() : int;
      
      function set Level(param1:int) : void;
      
      function get MountPoint() : Bitmap;
      
      function get Visible() : Boolean;
      
      function set Visible(param1:Boolean) : void;
   }
}

