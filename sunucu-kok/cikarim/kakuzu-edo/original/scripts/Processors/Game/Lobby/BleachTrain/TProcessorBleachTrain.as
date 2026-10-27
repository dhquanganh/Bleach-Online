package Processors.Game.Lobby.BleachTrain
{
   import Foundation.Common.TBounds;
   import Foundation.Network.SNetworkCore;
   import Foundation.Network.TPacket;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.TUIComponent;
   import Logics.BleachTrain.TBleachTrainData;
   import Logics.BleachTrain.TBleachTrainDatas;
   import Logics.SLogicsCore;
   import Logics.Streamization.BleachTrain.TUnstreamizerBleachTrain;
   import Processors.Game.Lobby.Common.TLobbyParameters;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindows;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Resources.Constants.CONST_BLEACHTRAIN;
   import Resources.Constants.CONST_NETWORK;
   import Resources.Constants.CONST_SHORTCUTS;
   import flash.utils.ByteArray;
   
   public class TProcessorBleachTrain extends TProcessorLobbyWindows
   {
      
      protected static const WINDOW_WIDTH:int = 837;
      
      protected static const WINDOW_HEIGHT:int = 563;
      
      protected var FWindowBleachTrain:TWindowBleachTrain;
      
      protected var FWindowBounds:TBounds;
      
      protected var FUnstreamizerBleachTrain:TUnstreamizerBleachTrain;
      
      protected var FBleachTrainDatas:TBleachTrainDatas;
      
      protected var FBleachTrainDataVec:Vector.<TBleachTrainData>;
      
      protected var FOnShowEffect:Function;
      
      protected var FOnFollowBleachTrain:Function;
      
      protected var FOnShutDownFunction:Function;
      
      public function TProcessorBleachTrain(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,param2);
         this.FWindowBounds = new TBounds();
         this.FWindowBounds.Width = WINDOW_WIDTH;
         this.FWindowBounds.Height = WINDOW_HEIGHT;
         this.FBleachTrainDatas = new TBleachTrainDatas();
         this.FBleachTrainDataVec = new Vector.<TBleachTrainData>();
         this.FWindowBleachTrain = new TWindowBleachTrain(this);
         this.FWindowBleachTrain.OnClose = this.SubWinowClose;
         this.FWindowBleachTrain.BleachTrainDatas = this.FBleachTrainDatas;
         ComponentBoundsCenter(this.FWindowBleachTrain,this.FWindowBounds);
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_BLEACHTRAIN.RESOURCE_BleachTrainID);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         super.ResourcesPerform_UILocations();
      }
      
      override protected function PacketRegisterRoutines() : void
      {
         super.PacketRegisterRoutines();
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_CS_BleachTrain_Ret,this.PerformPacket_SC_BleachTrainRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_CS_BleachTrainGetReward_Ret,this.PerformPacket_SC_BleachTrainAwardRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_CS_BleachTrainUpdate,this.PerformPacket_SC_BleachTrainUpdate);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_CS_BleachTrainVipBag_Ret,this.PerformPacket_SC_BleachTrainAwardVipBag);
      }
      
      protected function PerformPacket_SC_BleachTrainRet(param1:TPacket) : void
      {
         this.FUnstreamizerBleachTrain.Unstreamize(param1.Data,this.FBleachTrainDatas,this.FBleachTrainDataVec);
         this.RoleLevelUpNotify_Perform();
         this.CheckIfCanGetReward();
         this.CheckIfCanFollow();
         this.CheckIfShutDownBleanTrain();
      }
      
      protected function PerformPacket_SC_BleachTrainAwardRet(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:TBleachTrainData = null;
         _loc2_ = param1.Data.readUnsignedInt();
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         _loc3_ = param1.Data.readUnsignedInt();
         _loc4_ = this.FBleachTrainDatas.GetBleachTrainByID(_loc3_);
         _loc4_.IfGotReward = true;
         _loc4_.IfCanGotReward = false;
         SToolReward.ShowReward(param1.Data);
         if(Visible)
         {
            this.FWindowBleachTrain.Update();
         }
         this.CheckIfCanGetReward();
         this.CheckIfCanFollow();
         this.CheckIfShutDownBleanTrain();
      }
      
      protected function PerformPacket_SC_BleachTrainUpdate(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:TBleachTrainData = null;
         _loc2_ = param1.Data.readUnsignedInt();
         _loc4_ = param1.Data.readUnsignedInt();
         _loc5_ = this.FBleachTrainDatas.GetBleachTrainByID(_loc2_);
         if(_loc5_ == null)
         {
            return;
         }
         _loc5_.IfGotReward = false;
         _loc5_.CurrentScheduel = _loc4_;
         _loc5_.IfOpen = true;
         if(_loc5_.IfGotReward)
         {
            _loc5_.IfCanGotReward = false;
         }
         else
         {
            _loc5_.IfCanGotReward = _loc5_.CurrentScheduel >= _loc5_.GrowRoadTask.AllNumber;
         }
         if(Visible)
         {
            this.FWindowBleachTrain.Update();
         }
         this.CheckIfCanGetReward();
         this.CheckIfCanFollow();
      }
      
      protected function PerformPacket_SC_BleachTrainAwardVipBag(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         _loc2_ = param1.Data.readUnsignedInt();
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         _loc3_ = param1.Data.readUnsignedInt();
         _loc4_ = param1.Data.readUnsignedInt();
         this.FWindowBleachTrain.VipBagBuyedNotify(_loc3_,_loc4_);
         SToolReward.ShowReward(param1.Data);
      }
      
      protected function CheckIfCanGetReward() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:TBleachTrainData = null;
         var _loc6_:Vector.<TBleachTrainData> = null;
         _loc2_ = int(this.FBleachTrainDatas.BleachTrainDatas.length);
         _loc1_ = 0;
         loop0:
         while(_loc1_ < _loc2_)
         {
            _loc6_ = this.FBleachTrainDatas.BleachTrainDatas[_loc1_];
            _loc4_ = int(_loc6_.length);
            _loc3_ = 0;
            while(true)
            {
               if(_loc3_ >= _loc4_)
               {
                  _loc1_++;
                  continue loop0;
               }
               _loc5_ = _loc6_[_loc3_];
               if(_loc5_.IfCanGotReward)
               {
                  break;
               }
               _loc3_++;
            }
            _loc5_.IfOpen = true;
            if(this.FOnShowEffect != null)
            {
               this.FOnShowEffect(this,true);
            }
            return;
         }
         if(this.FOnShowEffect != null)
         {
            this.FOnShowEffect(this,false);
         }
      }
      
      protected function GetUnlockBleachTrain() : TBleachTrainData
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:TBleachTrainData = null;
         var _loc6_:Vector.<TBleachTrainData> = null;
         var _loc7_:int = 0;
         var _loc8_:TBleachTrainData = null;
         _loc7_ = 1000;
         _loc2_ = int(this.FBleachTrainDatas.BleachTrainDatas.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc6_ = this.FBleachTrainDatas.BleachTrainDatas[_loc1_];
            _loc4_ = int(_loc6_.length);
            _loc3_ = 0;
            while(_loc3_ < _loc4_)
            {
               _loc5_ = _loc6_[_loc3_];
               if(!_loc5_.IfOpen && _loc5_.GrowRoadTask.IsPoptip)
               {
                  if(_loc5_.GrowRoadTask.Accept < _loc7_)
                  {
                     _loc7_ = _loc5_.GrowRoadTask.Accept;
                     _loc8_ = _loc5_;
                  }
               }
               _loc3_++;
            }
            _loc1_++;
         }
         return _loc8_;
      }
      
      protected function CompareMethod(param1:TBleachTrainData, param2:TBleachTrainData) : int
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         _loc3_ = uint(param1.GrowRoadTask.Accept);
         if(!param1.IfGotReward && param1.IfOpen && !param1.IfCanGotReward)
         {
            _loc3_ += 1000;
         }
         else if(!param1.IfOpen)
         {
            _loc3_ += 10000;
         }
         else if(param1.IfGotReward)
         {
            _loc3_ += 100000;
         }
         _loc4_ = uint(param2.GrowRoadTask.Accept);
         if(!param2.IfGotReward && param2.IfOpen && !param2.IfCanGotReward)
         {
            _loc4_ += 1000;
         }
         else if(!param2.IfOpen)
         {
            _loc4_ += 10000;
         }
         else if(param2.IfGotReward)
         {
            _loc4_ += 100000;
         }
         if(_loc3_ < _loc4_)
         {
            return -1;
         }
         if(_loc3_ > _loc4_)
         {
            return 1;
         }
         if(param1.GrowRoadTask.Identifier < param2.GrowRoadTask.Identifier)
         {
            return -1;
         }
         if(param1.GrowRoadTask.Identifier > param2.GrowRoadTask.Identifier)
         {
            return 1;
         }
         return 0;
      }
      
      protected function CheckIfCanFollow() : void
      {
         var _loc1_:TBleachTrainData = null;
         _loc1_ = this.GetUnlockBleachTrain();
         if(_loc1_ != null)
         {
            if(this.FOnFollowBleachTrain != null)
            {
               this.FOnFollowBleachTrain(_loc1_);
            }
            return;
         }
         this.FBleachTrainDataVec.sort(this.CompareMethod);
         _loc1_ = this.FBleachTrainDataVec[0];
         if(_loc1_.IfCanGotReward || !_loc1_.IfGotReward && _loc1_.IfOpen && !_loc1_.IfCanGotReward)
         {
            if(this.FOnFollowBleachTrain != null)
            {
               this.FOnFollowBleachTrain(_loc1_);
            }
            return;
         }
         if(this.FOnFollowBleachTrain != null)
         {
            this.FOnFollowBleachTrain(null);
         }
      }
      
      protected function RoleLevelUpNotify_Perform() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TBleachTrainData = null;
         var _loc7_:Vector.<TBleachTrainData> = null;
         _loc1_ = int(SLogicsCore.Character.GetMainLevel());
         _loc3_ = int(this.FBleachTrainDatas.BleachTrainDatas.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc7_ = this.FBleachTrainDatas.BleachTrainDatas[_loc2_];
            _loc5_ = int(_loc7_.length);
            _loc4_ = 0;
            while(_loc4_ < _loc5_)
            {
               _loc6_ = _loc7_[_loc4_];
               _loc6_.IfOpen = _loc6_.GrowRoadTask.Accept <= _loc1_;
               _loc4_++;
            }
            _loc2_++;
         }
         if(Visible)
         {
            this.FWindowBleachTrain.Update();
         }
         this.CheckIfCanFollow();
      }
      
      protected function CheckIfShutDownBleanTrain() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TBleachTrainData = null;
         _loc2_ = int(this.FBleachTrainDataVec.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FBleachTrainDataVec[_loc1_];
            if(!_loc3_.IfGotReward)
            {
               return;
            }
            _loc1_++;
         }
         if(this.FOnShutDownFunction != null)
         {
            this.FOnShutDownFunction(this,CONST_SHORTCUTS.POSITION_SecondaryFunctionC,CONST_SHORTCUTS.TYPE_SecondaryFunctionC_BleachTrain);
         }
      }
      
      protected function SubWinowClose(param1:Object) : void
      {
         ProcessorClose();
      }
      
      public function set OnShowEffect(param1:Function) : void
      {
         this.FOnShowEffect = param1;
      }
      
      public function set OnFollowBleachTrain(param1:Function) : void
      {
         this.FOnFollowBleachTrain = param1;
      }
      
      public function set OnShutDownFunction(param1:Function) : void
      {
         this.FOnShutDownFunction = param1;
      }
      
      override public function Mount(param1:ByteArray = null) : void
      {
         super.Mount(param1);
         if(!FIsResourcesLoadCompleted)
         {
            this.FWindowBleachTrain.Load();
            return;
         }
         this.FWindowBleachTrain.InitView();
         this.FWindowBleachTrain.Visible = true;
      }
      
      override public function Unmount() : void
      {
         super.Unmount();
         this.FWindowBleachTrain.Reset();
         this.CheckIfCanFollow();
      }
      
      public function RoleLevelUpNotify() : void
      {
         this.RoleLevelUpNotify_Perform();
      }
      
      public function LoadBleahTrainInfor() : void
      {
         var _loc1_:TPacket = null;
         this.FUnstreamizerBleachTrain = new TUnstreamizerBleachTrain();
         this.FUnstreamizerBleachTrain.UnstreamizationByDataBase(null,this.FBleachTrainDatas,this.FBleachTrainDataVec);
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_BleachTrain_Req);
         SNetworkCore.Transceiver.PacketTransmit(_loc1_);
      }
   }
}

