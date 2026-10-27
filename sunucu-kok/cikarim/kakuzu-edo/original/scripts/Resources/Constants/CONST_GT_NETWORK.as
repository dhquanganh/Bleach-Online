package Resources.Constants
{
   public class CONST_GT_NETWORK
   {
      
      public static const CONNECTIONSTATE_Disconnected:int = 0;
      
      public static const CONNECTIONSTATE_Connecting:int = 1;
      
      public static const CONNECTIONSTATE_Connected:int = 2;
      
      public static const CONNECTIONSTATE_Failed:int = 3;
      
      public static const PACKET_MAX_LEN:uint = 65535;
      
      public static const SIZE_PacketLength:uint = 4;
      
      public static const SIZE_CheckCodeLength:uint = 1;
      
      public static const SIZE_PacketID:uint = 4;
      
      public static const SIZE_PacketHeader:uint = SIZE_PacketLength + SIZE_PacketID;
      
      public static const PACKETID_CS_AS:uint = 23134208;
      
      public static const PACKETID_CS_GM:uint = 23138304;
      
      public static const PACKETID_CS_CS:uint = 23142400;
      
      public static const PACKETID_SC_AS:uint = 18219008;
      
      public static const PACKETID_SC_GM:uint = 18223104;
      
      public static const PACKETID_SC_CS:uint = 18227200;
      
      public static const PACKETID_CS_LOGIN_Base:uint = PACKETID_CS_AS;
      
      public static const PACKETID_SC_LOGIN_Base:uint = PACKETID_SC_AS;
      
      public static const PACKETID_CS_CENTER_SERVER_Base:uint = 24182784;
      
      public static const PACKETID_SC_CENTER_SERVER_Base:uint = 18284544;
      
      public static const PACKETID_CS_LOBBY_Base:uint = 25231360;
      
      public static const PACKETID_SC_LOBBY_Base:uint = 18350080;
      
      public static const PACKETID_SocketBase:uint = 4278190080;
      
      public static const PACKETID_SocketConnect:uint = PACKETID_SocketBase + 0;
      
      public static const PACKETID_SocketDisconnect:uint = PACKETID_SocketBase + 1;
      
      public static const PACKETID_SocketError:uint = PACKETID_SocketBase + 2;
      
      public static const PACKETID_SOCKET_Base:uint = PACKETID_SocketBase;
      
      public static const PACKETID_SOCKET_End:uint = PACKETID_SocketError;
      
      public static const MASK_TRANSMIT:uint = 268369920;
      
      public static const MASK_RECEIVE:uint = 268431360;
      
      public function CONST_GT_NETWORK()
      {
         super();
      }
   }
}

