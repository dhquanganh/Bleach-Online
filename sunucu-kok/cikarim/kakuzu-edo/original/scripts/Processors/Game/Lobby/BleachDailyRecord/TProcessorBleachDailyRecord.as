package Processors.Game.Lobby.BleachDailyRecord
{
   import Foundation.Common.TBounds;
   import Foundation.Network.SNetworkCore;
   import Foundation.Network.TPacket;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.TUIComponent;
   import Logics.BleachDailyRecord.TBleachDailyRecords;
   import Logics.Streamization.BleachDailyRecord.TUnstreamizerBleachDailyRecord;
   import Processors.Game.Lobby.Common.TLobbyParameters;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindows;
   import Resources.Constants.CONST_BLEACHDAILYRECORD;
   import Resources.Constants.CONST_NETWORK;
   import flash.utils.ByteArray;
   
   public class TProcessorBleachDailyRecord extends TProcessorLobbyWindows
   {
      
      protected static const WINDOW_WIDTH:int = 594;
      
      protected static const WINDOW_HEIGHT:int = 449;
      
      protected var FWindowBleachDailyRecord:TWindowBleachDailyRecord;
      
      protected var FWindowBounds:TBounds;
      
      protected var FUnstreamizerBleachDailyRecord:TUnstreamizerBleachDailyRecord;
      
      protected var FBleachDailyRecords:TBleachDailyRecords;
      
      public function TProcessorBleachDailyRecord(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,param2);
         this.FWindowBounds = new TBounds();
         this.FWindowBounds.Width = WINDOW_WIDTH;
         this.FWindowBounds.Height = WINDOW_HEIGHT;
         this.FWindowBleachDailyRecord = new TWindowBleachDailyRecord(this);
         this.FWindowBleachDailyRecord.OnClose = this.SubWinowClose;
         ComponentBoundsCenter(this.FWindowBleachDailyRecord,this.FWindowBounds);
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_BLEACHDAILYRECORD.RESOURCE_BleachDailyRecordID);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         this.FBleachDailyRecords = new TBleachDailyRecords();
         this.FUnstreamizerBleachDailyRecord = new TUnstreamizerBleachDailyRecord();
         this.FUnstreamizerBleachDailyRecord.UnstreamizationByDataBase(null,this.FBleachDailyRecords,null);
         this.FWindowBleachDailyRecord.BleachDailyRecords = this.FBleachDailyRecords;
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         super.ResourcesPerform_UILocations();
      }
      
      override protected function PacketRegisterRoutines() : void
      {
         super.PacketRegisterRoutines();
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_BleachDailyRecord_Ret,this.PerformPacket_SC_BleachDailyRecordRet);
      }
      
      protected function PerformPacket_SC_BleachDailyRecordRet(param1:TPacket) : void
      {
         this.FUnstreamizerBleachDailyRecord.Unstreamize(param1.Data,this.FBleachDailyRecords,null);
         this.FWindowBleachDailyRecord.InitView();
         this.FWindowBleachDailyRecord.Visible = true;
      }
      
      protected function RequestDailyRecordInfor() : void
      {
         var _loc1_:TPacket = null;
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_BleachDailyRecord_Req);
         SNetworkCore.Transceiver.PacketTransmit(_loc1_);
      }
      
      protected function SubWinowClose(param1:Object) : void
      {
         ProcessorClose();
      }
      
      override public function Mount(param1:ByteArray = null) : void
      {
         super.Mount(param1);
         if(!FIsResourcesLoadCompleted)
         {
            this.FWindowBleachDailyRecord.Load();
            return;
         }
         this.RequestDailyRecordInfor();
      }
      
      override public function Unmount() : void
      {
         super.Unmount();
         this.FWindowBleachDailyRecord.Reset();
      }
   }
}

