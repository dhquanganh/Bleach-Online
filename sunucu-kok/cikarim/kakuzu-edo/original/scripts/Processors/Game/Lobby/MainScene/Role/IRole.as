package Processors.Game.Lobby.MainScene.Role
{
   public interface IRole
   {
      
      function get MapX() : Number;
      
      function set MapX(param1:Number) : void;
      
      function get MapY() : Number;
      
      function set MapY(param1:Number) : void;
      
      function SetupTargetPosition(param1:Number, param2:Number, param3:Number) : void;
   }
}

