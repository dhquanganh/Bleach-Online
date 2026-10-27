package Processors.Game.Login
{
   import Components.Controls.*;
   import Components.Controls.Managers.*;
   import Components.Controls.Skin.*;
   import Debugging.*;
   import Externals.*;
   import Foundation.Common.*;
   import Foundation.Crypto.*;
   import Foundation.Network.*;
   import Foundation.Registries.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Repositories.*;
   import Foundation.Resources.Textures.*;
   import Foundation.Timing.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import LocalStorages.*;
   import Logging.*;
   import Logics.*;
   import Logics.Affairs.*;
   import Logics.Agent.*;
   import Processors.Game.*;
   import Processors.Game.Windows.Information.*;
   import Resources.Constants.*;
   import Resources.Strings.*;
   import Utilities.UI.Windows.*;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.system.*;
   import flash.text.*;
   import flash.utils.*;
   
   public class TProcessorLogin extends TProcessorGame
   {
      
      protected static const RESOURCESSTATE_Request:int = 0;
      
      protected static const RESOURCESSTATE_Delay:int = 1;
      
      protected static const RESOURCESSTATE_Wait:int = 2;
      
      protected static const RESOURCESSTATE_Dispatch:int = 3;
      
      public static const CONNECTIONSTATE_Disconnected:int = CONST_NETWORK.CONNECTIONSTATE_Disconnected;
      
      public static const CONNECTIONSTATE_Connecting:int = CONST_NETWORK.CONNECTIONSTATE_Connecting;
      
      public static const CONNECTIONSTATE_Connected:int = CONST_NETWORK.CONNECTIONSTATE_Connected;
      
      public static const CONNECTIONSTATE_Failed:int = CONST_NETWORK.CONNECTIONSTATE_Failed;
      
      protected static const LOGINSTATE_LoggedOut:uint = 0;
      
      protected static const LOGINSTATE_StatusServerConnect:uint = 1;
      
      protected static const LOGINSTATE_StatusServerConnectWait:uint = 2;
      
      protected static const LOGINSTATE_StatusServerDelay:uint = 3;
      
      protected static const LOGINSTATE_StatusServerTransmitToken:uint = 4;
      
      protected static const LOGINSTATE_StatusServerTransmitTokenWait:uint = 5;
      
      protected static const LOGINSTATE_StatusToGateDelay:uint = 6;
      
      protected static const LOGINSTATE_GateServerConnect:uint = 7;
      
      protected static const LOGINSTATE_GateServerConnectWait:uint = 8;
      
      protected static const LOGINSTATE_GateServerTransmitToken:uint = 9;
      
      protected static const LOGINSTATE_GateServerTransmitTokenWait:uint = 10;
      
      protected static const LOGINSTATE_LoggedIn:uint = 11;
      
      protected static const TIMEOUT_Default:int = 200001;
      
      protected static const AFFAIRID_Error:uint = 4278190080;
      
      protected static const AFFAIRID_ConnectionDrop:uint = 4278190081;
      
      protected static const ERRORCODE_OK:int = 0;
      
      protected static const ERRORCODE_Network:int = 1;
      
      protected static const ERRORCODE_Timeout:int = 2;
      
      protected static const ERRORCODE_Status:int = 3;
      
      protected static const ERRORCODE_GateServer:int = 4;
      
      protected static const LOGIN_DelayTicks:int = 500;
      
      protected var FTransceiver:TTransceiver;
      
      protected var FResourcesDelayReferenceTick:int;
      
      protected var FLoginRoutines:TRegistryRoutine;
      
      protected var FLoginState:int;
      
      protected var FLoginTimeoutTick:int;
      
      protected var FLoginDelayReferenceTick:int;
      
      protected var FLoginModeToken:Boolean;
      
      protected var FOperatorUserID:String;
      
      protected var FAgentID:uint;
      
      protected var FMainServerID:uint;
      
      protected var FServerID:uint;
      
      protected var FVersion:uint;
      
      protected var FLoginToken:String;
      
      protected var FLoginTime:String;
      
      protected var FUIWindowConfirmation:TUIWindowConfirmation;
      
      protected var FServerHost:String;
      
      protected var FServerPort:uint;
      
      protected var FErrorCode:int;
      
      protected var FOnLogingError:Function;
      
      protected var FOnLoggedIn:Function;
      
      protected var FOnConnectionDrop:Function;
      
      public function TProcessorLogin(param1:TUIComponent)
      {
         super(param1);
         this.FTransceiver = SNetworkCore.Transceiver;
         this.FTransceiver.OnSilenceDetected = this.OnKeepAliveACK;
         this.FTransceiver.IsCipher = false;
         this.FLoginRoutines = new TRegistryRoutine();
         this.LoginRegisterRoutines();
         this.FLoginToken = "";
         this.FLoginTime = "";
         this.FErrorCode = -1;
      }
      
      protected function FetchParameters() : void
      {
         var _loc1_:String = null;
         var _loc2_:int = 0;
         _loc1_ = SParametersCore.ServerHost;
         _loc2_ = int(SParametersCore.ServerPort);
         this.FOperatorUserID = SParametersCore.OperatorUserID;
         this.FAgentID = SParametersCore.AgentID;
         this.FServerID = SParametersCore.ServerID;
         this.FLoginToken = SParametersCore.LoginStringToken;
         this.FVersion = SParametersCore.ClientVersion;
         this.FLoginTime = SParametersCore.LoginTime;
         SLogger.TraceTransceiver(TLogger.LEVEL_Login,"LoginServer Parameters from external: ","\tHost: " + _loc1_ + "\n\tPort: " + _loc2_.toString() + "\n\tUserID: " + this.FOperatorUserID.toString() + "\n\tAgentID: " + this.FAgentID.toString() + "\n\tServerID: " + this.FServerID.toString() + "\n\tToken: " + this.FLoginToken + "\n\tVersion: " + this.FVersion.toString() + "\n\tLoginTime: " + this.FLoginTime);
         if(TUtilityString.Empty(this.FLoginToken))
         {
            this.FLoginToken = "";
         }
         this.FServerHost = _loc1_.toString();
         this.FServerPort = _loc2_;
      }
      
      protected function LoginModeTokenValidate() : Boolean
      {
         var _loc1_:Boolean = false;
         return !TUtilityString.Empty(this.FOperatorUserID) && this.FAgentID != 0 && this.FServerID != 0 && this.FVersion != 0 && this.FLoginToken.length != 0;
      }
      
      protected function LoginReset() : void
      {
         this.FTransceiver.Disconnect();
         this.FTransceiver.SilenceDetection = false;
         this.FLoginModeToken = false;
         this.FLoginState = LOGINSTATE_LoggedOut;
         SLogger.TraceTransceiver(TLogger.LEVEL_Login,"Login: Login procedure reseted.");
      }
      
      protected function LoginStart(param1:int = 1) : void
      {
         this.FLoginState = param1;
      }
      
      protected function LoginAutoStart() : void
      {
         SLogger.TraceTransceiver(TLogger.LEVEL_Login,"Login: Autostart.");
         this.FetchParameters();
         this.FLoginModeToken = this.LoginModeTokenValidate();
         if(this.FLoginModeToken)
         {
            this.LoginStart();
         }
         else
         {
            SLogger.TraceTransceiver(TLogger.LEVEL_Login,"Login: Manually Start.");
         }
      }
      
      protected function LoginConnectionVerify() : Boolean
      {
         var _loc1_:int = 0;
         _loc1_ = this.FTransceiver.ConnectionState;
         if(_loc1_ == CONNECTIONSTATE_Connected)
         {
            return true;
         }
         return false;
      }
      
      protected function LoginTimeoutSetup(param1:int) : void
      {
         this.FLoginTimeoutTick = STimingCore.TickCount + param1;
      }
      
      protected function LoginTimeoutVerify() : Boolean
      {
         var _loc1_:int = 0;
         _loc1_ = int(STimingCore.TickCount);
         return _loc1_ <= this.FLoginTimeoutTick;
      }
      
      protected function LoginErrorGenerate(param1:uint) : void
      {
         if(this.FOnLogingError != null)
         {
            this.FOnLogingError(this);
         }
         FAffairGenerator.GenerateInt(AFFAIRID_Error,param1);
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         this.LogicsPerform_Login();
      }
      
      protected function LogicsPerform_Login() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Function = null;
         do
         {
            _loc1_ = this.FLoginState;
            _loc2_ = this.FLoginRoutines.GetRoutineByIndentifier(this.FLoginState);
            if(_loc2_ != null)
            {
               _loc2_();
            }
            else
            {
               SLogger.TraceTransceiver(TLogger.LEVEL_Login,"Unregistered login state." + this.FLoginState.toString());
            }
         }
         while(_loc1_ != this.FLoginState);
      }
      
      override protected function ResourcesRegisterRoutines() : void
      {
         FResourcesRoutines.Register(RESOURCESSTATE_Request,this.ResourcesPerform_Request);
         FResourcesRoutines.Register(RESOURCESSTATE_Delay,this.ResourcesPerform_Delay);
         FResourcesRoutines.Register(RESOURCESSTATE_Wait,this.ResourcesPerform_Wait);
         FResourcesRoutines.Register(RESOURCESSTATE_Dispatch,this.ResourcesPerform_Dispatch);
      }
      
      protected function ResourcesPerform_Request() : void
      {
         SResourcesCore.TexturesSwfCommon.LoadPrimary(CONST_COMMON.RESOURCESID_SwfCommon_Common);
         this.FResourcesDelayReferenceTick = STimingCore.TickCount;
         FResourcesState = RESOURCESSTATE_Delay;
      }
      
      protected function ResourcesPerform_Delay() : void
      {
         var _loc1_:int = 0;
         _loc1_ = STimingCore.TickCount - this.FResourcesDelayReferenceTick;
         if(_loc1_ <= 1000)
         {
            return;
         }
         FResourcesState = RESOURCESSTATE_Wait;
      }
      
      protected function ResourcesPerform_Wait() : void
      {
         if(SParametersCore.IsNewUser)
         {
            if(!SResourcesCore.ResourceBin.Loading && !SResourcesCore.TexturesSwfCommon.Loading && !SResourcesCore.TexturesSwfCreateChar.Loading)
            {
               FResourcesState = RESOURCESSTATE_Dispatch;
            }
         }
         else if(!SResourcesCore.ResourceBin.Loading && !SResourcesCore.TexturesSwfCommon.Loading)
         {
            FResourcesState = RESOURCESSTATE_Dispatch;
         }
      }
      
      protected function ResourcesPerform_Dispatch() : void
      {
         this.FUIWindowConfirmation = new TUIWindowConfirmation(this);
         this.FUIWindowConfirmation.OnOK = this.WindowOnOK;
         this.FUIWindowConfirmation.OnCancel = this.WindowOnCancel;
         TUtilityUIWindow.SetupWindowConfirmation(this.FUIWindowConfirmation);
         this.LoginAutoStart();
         FResourcesState = RESOURCESSTATE_Ready;
      }
      
      override protected function AffairRegisterRoutines() : void
      {
         super.AffairRegisterRoutines();
         FAffairRoutines.Register(AFFAIRID_Error,this.AffairPerform_Error);
         FAffairRoutines.Register(AFFAIRID_ConnectionDrop,this.AffairPerform_ConnectionDrop);
      }
      
      protected function AffairPerform_Error(param1:TAffair) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         _loc2_ = int(STRING_LOGIN.STRINGS_Error.length);
         _loc3_ = (param1 as TAffairInt).Value;
         if(_loc3_ < _loc2_)
         {
            this.FUIWindowConfirmation.Text = STRING_LOGIN.STRING_Error + ":  " + STRING_LOGIN.STRINGS_Error[_loc3_] + CONST_COMMON.STRING_ParenthesesLeft + this.FErrorCode.toString() + CONST_COMMON.STRING_ParenthesesRight;
         }
         else
         {
            this.FUIWindowConfirmation.Text = STRING_LOGIN.STRING_Error + ":  " + "Error Code(" + _loc3_.toString() + ")";
         }
         this.FUIWindowConfirmation.Visible = true;
      }
      
      protected function AffairPerform_ConnectionDrop(param1:TAffair) : void
      {
         if(this.FOnConnectionDrop != null)
         {
            this.FOnConnectionDrop(this);
         }
         this.FUIWindowConfirmation.Visible = false;
      }
      
      protected function LoginRegisterRoutines() : void
      {
         this.FLoginRoutines.Register(LOGINSTATE_LoggedOut,this.LoginPerform_LoggedOut);
         this.FLoginRoutines.Register(LOGINSTATE_StatusServerConnect,this.LoginPerform_StatusServerConnect);
         this.FLoginRoutines.Register(LOGINSTATE_StatusServerConnectWait,this.LoginPerform_StatusServerConnectWait);
         this.FLoginRoutines.Register(LOGINSTATE_StatusServerDelay,this.LoginPerform_StatusServerDelay);
         this.FLoginRoutines.Register(LOGINSTATE_StatusServerTransmitToken,this.LoginPerform_StatusServerTransmitToken);
         this.FLoginRoutines.Register(LOGINSTATE_StatusServerTransmitTokenWait,this.LoginPerform_StatusServerTransmitTokenWait);
         this.FLoginRoutines.Register(LOGINSTATE_StatusToGateDelay,this.LoginPerform_StatusToGateDelay);
         this.FLoginRoutines.Register(LOGINSTATE_GateServerConnect,this.LoginPerform_GateServerConnect);
         this.FLoginRoutines.Register(LOGINSTATE_GateServerConnectWait,this.LoginPerform_GateServerConnectWait);
         this.FLoginRoutines.Register(LOGINSTATE_GateServerTransmitToken,this.LoginPerform_GateServerTransmitToken);
         this.FLoginRoutines.Register(LOGINSTATE_GateServerTransmitTokenWait,this.LoginPerform_GateServerTransmitTokenWait);
         this.FLoginRoutines.Register(LOGINSTATE_LoggedIn,this.LoginPerform_LoggedIn);
      }
      
      protected function LoginPerform_LoggedOut() : void
      {
      }
      
      protected function LoginPerform_StatusServerConnect() : void
      {
         SLogger.TraceTransceiver(TLogger.LEVEL_Login,"Login: Connecting to LoginServer ..." + "\tServerHost:" + this.FServerHost + "\tServerPort:" + this.FServerPort.toString());
         this.FTransceiver.ServerHost = this.FServerHost;
         this.FTransceiver.ServerPort = this.FServerPort;
         this.FTransceiver.Connect();
         this.FLoginState = LOGINSTATE_StatusServerConnectWait;
      }
      
      protected function LoginPerform_StatusServerConnectWait() : void
      {
         var _loc1_:int = 0;
         _loc1_ = this.FTransceiver.ConnectionState;
         if(_loc1_ == CONNECTIONSTATE_Connecting)
         {
            return;
         }
         if(!this.LoginConnectionVerify())
         {
            this.LoginErrorGenerate(ERRORCODE_Network);
            this.LoginReset();
            return;
         }
         SLogger.TraceTransceiver(TLogger.LEVEL_Login,"Login: StatusServer Connected.");
         this.FLoginDelayReferenceTick = STimingCore.TickCount;
         this.FLoginState = LOGINSTATE_StatusServerDelay;
      }
      
      protected function LoginPerform_StatusServerDelay() : void
      {
         var _loc1_:int = 0;
         _loc1_ = STimingCore.TickCount - this.FLoginDelayReferenceTick;
         if(_loc1_ < LOGIN_DelayTicks)
         {
            return;
         }
         this.FLoginState = LOGINSTATE_StatusServerTransmitToken;
      }
      
      protected function LoginPerform_StatusServerTransmitToken() : void
      {
         var _loc1_:TPacket = null;
         var _loc2_:ByteArray = null;
         var _loc3_:String = null;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:uint = 0;
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Login_StatusServerTransmitToken);
         _loc2_ = _loc1_.Data;
         if(!this.FLoginModeToken)
         {
            SLogger.TraceTransceiver(TLogger.LEVEL_Login,"Login: Logging in manually on StatusServer Transmit Token...");
            SLogger.TraceTransceiver(TLogger.LEVEL_Login,"Login: Logging in by token on status server...","\tUserID: " + _loc3_ + "\n\tAgentID: " + _loc4_.toString() + "\n\tServerID: " + _loc5_.toString() + "\n\tToken: " + _loc6_ + "\n\tVersion: " + _loc8_.toString() + "\n\tLoginTime: " + _loc7_);
            TUtilityString.FlushUTF(_loc2_,_loc3_);
            _loc2_.writeUnsignedInt(_loc4_);
            _loc2_.writeUnsignedInt(_loc5_);
            TUtilityString.FlushUTF(_loc2_,_loc6_);
            _loc2_.writeUnsignedInt(_loc8_);
            TUtilityString.FlushUTF(_loc2_,_loc7_);
         }
         else
         {
            SLogger.TraceTransceiver(TLogger.LEVEL_Login,"Login: Logging in by token on status server...","\tUserID: " + this.FOperatorUserID.toString() + "\n\tAgentID: " + this.FAgentID.toString() + "\n\tServerID: " + this.FServerID.toString() + "\n\tToken: " + this.FLoginToken + "\n\tVersion: " + this.FVersion.toString() + "\n\tLoginTime: " + this.FLoginTime);
            TUtilityString.FlushUTF(_loc2_,this.FOperatorUserID);
            _loc2_.writeUnsignedInt(this.FAgentID);
            _loc2_.writeUnsignedInt(this.FServerID);
            TUtilityString.FlushUTF(_loc2_,this.FLoginToken);
            _loc2_.writeUnsignedInt(this.FVersion);
            TUtilityString.FlushUTF(_loc2_,this.FLoginTime);
         }
         this.FTransceiver.PacketTransmit(_loc1_);
         this.FErrorCode = -1;
         SLogger.TraceTransceiver(TLogger.LEVEL_Login,"Login: StatusServer Transmit Token Wait.");
         this.LoginTimeoutSetup(TIMEOUT_Default);
         this.FLoginState = LOGINSTATE_StatusServerTransmitTokenWait;
      }
      
      protected function LoginPerform_StatusServerTransmitTokenWait() : void
      {
         if(!this.LoginConnectionVerify())
         {
            this.LoginErrorGenerate(ERRORCODE_Network);
            this.LoginReset();
            return;
         }
         if(!this.LoginTimeoutVerify())
         {
            this.LoginErrorGenerate(ERRORCODE_Timeout);
            this.LoginReset();
            return;
         }
         if(this.FErrorCode < 0)
         {
            return;
         }
         if(this.FErrorCode != 0)
         {
            this.LoginErrorGenerate(ERRORCODE_Status);
            this.LoginReset();
            return;
         }
         SLogger.TraceTransceiver(TLogger.LEVEL_Login,"Login: Status server dispatched." + "\tAddress: " + this.FServerHost + ":" + this.FServerPort.toString());
         this.FTransceiver.Disconnect();
         this.FLoginDelayReferenceTick = STimingCore.TickCount;
         this.FLoginState = LOGINSTATE_StatusToGateDelay;
      }
      
      protected function LoginPerform_StatusToGateDelay() : void
      {
         var _loc1_:int = 0;
         _loc1_ = STimingCore.TickCount - this.FLoginDelayReferenceTick;
         if(_loc1_ < LOGIN_DelayTicks)
         {
            return;
         }
         this.FLoginState = LOGINSTATE_GateServerConnect;
      }
      
      protected function LoginPerform_GateServerConnect() : void
      {
         SLogger.TraceTransceiver(TLogger.LEVEL_Login,"Login: Connecting to GateServer..." + "\tAddress: " + this.FServerHost + ":" + this.FServerPort.toString());
         this.FTransceiver.ServerHost = this.FServerHost;
         this.FTransceiver.ServerPort = this.FServerPort;
         this.FTransceiver.Connect();
         this.FLoginState = LOGINSTATE_GateServerConnectWait;
      }
      
      protected function LoginPerform_GateServerConnectWait() : void
      {
         var _loc1_:int = 0;
         _loc1_ = this.FTransceiver.ConnectionState;
         if(_loc1_ == CONNECTIONSTATE_Connecting)
         {
            return;
         }
         if(!this.LoginConnectionVerify())
         {
            this.LoginErrorGenerate(ERRORCODE_Network);
            this.LoginReset();
            return;
         }
         SLogger.TraceTransceiver(TLogger.LEVEL_Login,"Login: GateServer Connected.");
         this.FLoginState = LOGINSTATE_GateServerTransmitToken;
      }
      
      protected function LoginPerform_GateServerTransmitToken() : void
      {
         var _loc1_:TPacket = null;
         var _loc2_:ByteArray = null;
         var _loc3_:String = null;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:String = null;
         var _loc8_:String = null;
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Login_GateServerTransmitToken);
         _loc2_ = _loc1_.Data;
         if(!this.FLoginModeToken)
         {
            SLogger.TraceTransceiver(TLogger.LEVEL_Login,"Login: Logging in manually on GateServer Transmit Token...");
            SLogger.TraceTransceiver(TLogger.LEVEL_Login,"Login: Logging in by token on gate server...","\tUserID: " + _loc3_ + "\n\tAgentID: " + _loc4_.toString() + "\n\tServerID: " + _loc5_.toString() + "\n\tToken: " + _loc7_ + "\n\tVersion: " + _loc6_.toString() + "\n\tLoginTime: " + _loc8_);
            TUtilityString.FlushUTF(_loc2_,_loc3_);
            _loc2_.writeUnsignedInt(_loc4_);
            _loc2_.writeUnsignedInt(_loc5_);
            TUtilityString.FlushUTF(_loc2_,_loc7_);
            _loc2_.writeUnsignedInt(_loc6_);
            TUtilityString.FlushUTF(_loc2_,_loc8_);
         }
         else
         {
            SLogger.TraceTransceiver(TLogger.LEVEL_Login,"Login: Logging in by token on gate server...","\tUserID: " + this.FOperatorUserID.toString() + "\n\tAgentID: " + this.FAgentID.toString() + "\n\tServerID: " + this.FServerID.toString() + "\n\tToken: " + this.FLoginToken + "\n\tVersion: " + this.FVersion.toString() + "\n\tLoginTime: " + this.FLoginTime);
            TUtilityString.FlushUTF(_loc2_,this.FOperatorUserID);
            _loc2_.writeUnsignedInt(this.FAgentID);
            _loc2_.writeUnsignedInt(this.FServerID);
            TUtilityString.FlushUTF(_loc2_,this.FLoginToken);
            this.FVersion = SParametersCore.ClientVersion;
            _loc2_.writeUnsignedInt(this.FVersion);
            TUtilityString.FlushUTF(_loc2_,this.FLoginTime);
         }
         this.FTransceiver.PacketTransmit(_loc1_);
         SLogger.TraceTransceiver(TLogger.LEVEL_Login,"Login: GateServer Transmit Token.");
         this.LoginTimeoutSetup(TIMEOUT_Default);
         this.FLoginState = LOGINSTATE_GateServerTransmitTokenWait;
      }
      
      protected function LoginPerform_GateServerTransmitTokenWait() : void
      {
         if(!this.LoginConnectionVerify())
         {
            this.LoginErrorGenerate(ERRORCODE_Network);
            this.LoginReset();
            return;
         }
         if(!this.LoginTimeoutVerify())
         {
            this.LoginErrorGenerate(ERRORCODE_Timeout);
            this.LoginReset();
            return;
         }
         if(this.FErrorCode < 0)
         {
            return;
         }
         if(this.FErrorCode != 0)
         {
            this.LoginErrorGenerate(ERRORCODE_GateServer);
            this.LoginReset();
            return;
         }
         SLogger.TraceTransceiver(TLogger.LEVEL_Login,"Login: Successfully logged in.");
         if(this.FOnLoggedIn != null)
         {
            this.FOnLoggedIn(this);
         }
         this.FTransceiver.SilenceDetection = true;
         this.FLoginState = LOGINSTATE_LoggedIn;
      }
      
      protected function LoginPerform_LoggedIn() : void
      {
         if(!this.LoginConnectionVerify())
         {
            this.LoginReset();
            FAffairGenerator.Generate(AFFAIRID_ConnectionDrop);
            return;
         }
      }
      
      override protected function PacketRegisterRoutines() : void
      {
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SocketConnect,this.PacketPerform_SocketConnect);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SocketDisconnect,this.PacketPerform_SocketDisconnect);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SocketError,this.PacketPerform_SocketError);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Login_StatusServerTransmitTokenRet,this.PacketPerform_SC_StatusServerTransmitTokenRet);
      }
      
      protected function PacketPerform_SocketConnect(param1:TPacket) : void
      {
      }
      
      protected function PacketPerform_SocketDisconnect(param1:TPacket) : void
      {
      }
      
      protected function PacketPerform_SocketError(param1:TPacket) : void
      {
      }
      
      protected function PacketPerform_SC_StatusServerTransmitTokenRet(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         _loc2_ = param1.Data;
         this.FErrorCode = _loc2_.readUnsignedInt();
         if(this.FErrorCode != 0)
         {
            SLogger.TraceTransceiver(TLogger.LEVEL_Login,"Login: GateServer dispatching failed.");
            this.FServerHost = "";
            this.FServerPort = 0;
            return;
         }
         SLogicsCore.MainServerID = _loc2_.readUnsignedInt();
      }
      
      protected function OnKeepAliveACK(param1:Object) : void
      {
         var _loc2_:TPacket = null;
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_KeepAliveAck);
         this.FTransceiver.PacketTransmit(_loc2_);
      }
      
      protected function WindowOnOK(param1:Object) : void
      {
         this.FUIWindowConfirmation.Visible = false;
         SExternalCore.ReloadGame();
      }
      
      protected function WindowOnCancel(param1:Object) : void
      {
         this.FUIWindowConfirmation.Visible = false;
         SExternalCore.GameURLNavigate(SParametersCore.OfficeUrl);
      }
      
      public function get OnLogingError() : Function
      {
         return this.FOnLogingError;
      }
      
      public function set OnLogingError(param1:Function) : void
      {
         this.FOnLogingError = param1;
      }
      
      public function get OnLoggedIn() : Function
      {
         return this.FOnLoggedIn;
      }
      
      public function set OnLoggedIn(param1:Function) : void
      {
         this.FOnLoggedIn = param1;
      }
      
      public function get OnConnectionDrop() : Function
      {
         return this.FOnConnectionDrop;
      }
      
      public function set OnConnectionDrop(param1:Function) : void
      {
         this.FOnConnectionDrop = param1;
      }
   }
}

