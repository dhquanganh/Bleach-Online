package Processors.Game.Lobby.BlackMarket
{
   import Foundation.Network.TPacket;
   
   public interface InterfaceTimeMarket
   {
      
      function MallInforInitRet(param1:int, param2:TPacket) : void;
      
      function MallRefreshRet(param1:int, param2:TPacket) : void;
      
      function MallBuyGoodRet(param1:int, param2:TPacket) : void;
   }
}

