package Processors.Game.Lobby.Pet.PetTrain
{
   import Foundation.Common.TBounds;
   import Foundation.Network.SNetworkCore;
   import Foundation.Network.TPacket;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.VO.TPetLevelUp;
   import Logics.Pet.TPetBase;
   import Logics.Pet.TPetData;
   import Logics.Pet.TVicePet;
   import Logics.Pet.Train.TTrainData;
   import Logics.SLogicsCore;
   import Logics.Streamization.Pet.TUnstreamizerPet;
   import Logics.Streamization.Pet.TUnstreamizerPetData;
   import Processors.Game.Lobby.Common.TLobbyParameters;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindows;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Resources.Constants.CONST_DATEBASEVO;
   import Resources.Constants.CONST_NETWORK;
   import Resources.Constants.CONST_PET;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.utils.ByteArray;
   
   public class TProcessorPetTrain extends TProcessorLobbyWindows
   {
      
      protected static const SIZE_WindowPetTrain_Width:uint = 548;
      
      protected static const SIZE_WindowPetTrain_Height:uint = 453;
      
      protected static const SIZE_WindowPetTrainModel_Width:uint = 538;
      
      protected static const SIZE_WindowPetTrainModel_Height:uint = 352;
      
      protected var FPetData:TPetData;
      
      protected var FUnstreamizerPetData:TUnstreamizerPetData;
      
      protected var FUnstreamizerPet:TUnstreamizerPet;
      
      protected var FCurrentVicePet:TVicePet;
      
      protected var FCurrentGridIndex:int;
      
      protected var FProcessorWindowPetTrain:TProcessorWindowPetTrain;
      
      protected var FProcessorWindowPetTrainModel:TProcessorWindowPetTrainModel;
      
      protected var FOnSlotOver:Function;
      
      protected var FOnSlotOut:Function;
      
      public function TProcessorPetTrain(param1:TUIComponent, param2:TLobbyParameters)
      {
         var _loc3_:TBounds = null;
         super(param1,param2);
         this.FPetData = SLogicsCore.PetData;
         this.FProcessorWindowPetTrain = new TProcessorWindowPetTrain(param1);
         this.FProcessorWindowPetTrain.Visible = false;
         this.FProcessorWindowPetTrain.OnClose = this.ProcessorWindowClose;
         this.FProcessorWindowPetTrain.OnEffectText = ProcessorsOnEffectText;
         this.FProcessorWindowPetTrain.HintOnOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FProcessorWindowPetTrain.HintOnOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FProcessorWindowPetTrain.OnOpenTrainModel = this.ProcessorsTrainModelOnOpen;
         this.FProcessorWindowPetTrain.OnSlotOver = this.ProcessorOnSlotOver;
         this.FProcessorWindowPetTrain.OnSlotOut = this.ProcessorOnSlotOut;
         _loc3_ = new TBounds();
         _loc3_.X = this.FProcessorWindowPetTrain.X;
         _loc3_.Y = this.FProcessorWindowPetTrain.Y;
         _loc3_.Width = SIZE_WindowPetTrain_Width;
         _loc3_.Height = SIZE_WindowPetTrain_Height;
         ComponentBoundsCenter(this.FProcessorWindowPetTrain,_loc3_);
         this.FProcessorWindowPetTrainModel = new TProcessorWindowPetTrainModel(param1);
         this.FProcessorWindowPetTrainModel.OnClose = this.ProcessorWindowOnClose;
         this.FProcessorWindowPetTrainModel.OnEffectText = ProcessorsOnEffectText;
         this.FProcessorWindowPetTrainModel.OnTrain = this.ProcessorOnTrain;
         this.FProcessorWindowPetTrainModel.HintOnOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FProcessorWindowPetTrainModel.HintOnOut = SUtilityOverLayer.UIComponentsHintOnOut;
         _loc3_ = new TBounds();
         _loc3_.X = this.FProcessorWindowPetTrainModel.X;
         _loc3_.Y = this.FProcessorWindowPetTrainModel.Y;
         _loc3_.Width = SIZE_WindowPetTrainModel_Width;
         _loc3_.Height = SIZE_WindowPetTrainModel_Height;
         ComponentBoundsCenter(this.FProcessorWindowPetTrainModel,_loc3_);
         _loc3_ = null;
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_PET.RESOURCESID_Swf_PetTrain);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         this.FUnstreamizerPetData = new TUnstreamizerPetData();
         this.FUnstreamizerPet = new TUnstreamizerPet();
         this.Reset();
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function PacketRegisterRoutines() : void
      {
         super.PacketRegisterRoutines();
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_VicePetTrainRet,this.PerformPacket_SC_VicePetTrainRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_VicePetTrainCancelRet,this.PerformPacket_SC_VicePetTrainCancelRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_VicePetTrainClearCDRet,this.PerformPacket_SC_VicePetTrainClearCDRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_VicePetTrainGetRet,this.PerformPacket_SC_VicePetTrainGetRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_TrainSlotOpenRet,this.PerformPacket_SC_TrainSlotOpenRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_TrainExpCardRet,this.PerformPacket_SC_TrainExpCardRet);
      }
      
      protected function PerformPacket_SC_VicePetTrainRet(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:TTrainData = null;
         _loc2_ = param1.Data;
         _loc3_ = int(_loc2_.readUnsignedInt());
         if(_loc3_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc3_);
            return;
         }
         _loc4_ = int(_loc2_.readUnsignedInt());
         _loc5_ = this.FPetData.TrainDatas.GetTrainDataByIdentifier(_loc4_);
         this.FUnstreamizerPetData.UnstreamizeTrainPet(_loc2_,_loc5_,null);
         _loc5_.Status = TTrainData.TYPE_USED;
         this.FProcessorWindowPetTrainModel.Visible = false;
         this.FProcessorWindowPetTrain.Visible = true;
         this.FProcessorWindowPetTrain.Update();
         this.FProcessorWindowPetTrain.ResetTimingTime(_loc5_);
      }
      
      protected function PerformPacket_SC_VicePetTrainCancelRet(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:int = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:TTrainData = null;
         var _loc7_:TPetBase = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         _loc2_ = param1.Data;
         _loc3_ = int(_loc2_.readUnsignedInt());
         if(_loc3_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc3_);
            return;
         }
         _loc4_ = _loc2_.readUnsignedInt();
         _loc5_ = _loc2_.readUnsignedInt();
         _loc10_ = int(_loc2_.readUnsignedInt());
         _loc9_ = int(_loc2_.readUnsignedInt());
         _loc6_ = this.FPetData.TrainDatas.GetTrainDataByPetIdentifier(_loc4_,_loc5_);
         if(_loc6_ != null)
         {
            _loc6_.Clear();
         }
         _loc7_ = this.FPetData.OwnVicePets.GetPetByIdentifier(_loc4_,_loc5_);
         _loc8_ = int(_loc7_.Level);
         _loc7_.Level = _loc9_;
         _loc7_.Experience = _loc10_;
         if(_loc8_ < _loc7_.Level)
         {
            this.FUnstreamizerPet.UnstreamizeVicePet(null,_loc7_,null);
         }
         this.FProcessorWindowPetTrain.Update();
      }
      
      protected function PerformPacket_SC_VicePetTrainClearCDRet(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:int = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:TTrainData = null;
         _loc2_ = param1.Data;
         _loc3_ = int(_loc2_.readUnsignedInt());
         if(_loc3_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc3_);
            return;
         }
         ++this.FPetData.TrainCDCount;
         _loc4_ = _loc2_.readUnsignedInt();
         _loc5_ = _loc2_.readUnsignedInt();
         _loc6_ = this.FPetData.TrainDatas.GetTrainDataByPetIdentifier(_loc4_,_loc5_);
         if(_loc6_ != null)
         {
            _loc6_.Status = TTrainData.TYPE_COMPLETED;
         }
         this.FProcessorWindowPetTrain.Update();
      }
      
      protected function PerformPacket_SC_VicePetTrainGetRet(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:int = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:int = 0;
         var _loc8_:TTrainData = null;
         var _loc9_:String = null;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:TPetBase = null;
         var _loc14_:int = 0;
         _loc2_ = param1.Data;
         _loc3_ = int(_loc2_.readUnsignedInt());
         if(_loc3_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc3_);
            return;
         }
         _loc4_ = _loc2_.readUnsignedInt();
         _loc5_ = _loc2_.readUnsignedInt();
         _loc10_ = int(_loc2_.readUnsignedInt());
         _loc11_ = int(_loc2_.readUnsignedInt());
         _loc12_ = int(_loc2_.readUnsignedInt());
         _loc13_ = this.FPetData.OwnVicePets.GetPetByIdentifier(_loc4_,_loc5_);
         _loc14_ = int(_loc13_.Level);
         _loc13_.Level = _loc10_;
         _loc13_.Experience = _loc11_;
         if(_loc14_ < _loc13_.Level)
         {
            this.FUnstreamizerPet.UnstreamizeVicePet(null,_loc13_,null);
         }
         _loc9_ = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_PET_35),_loc12_,_loc10_);
         EffectGenerateText(_loc9_);
         _loc7_ = int(this.FPetData.CurrentVicePetTrainSlotCount);
         _loc6_ = 0;
         while(_loc6_ < _loc7_)
         {
            _loc8_ = this.FPetData.TrainDatas.GetTrainDataByIndex(_loc6_);
            if(_loc8_.VicePetHighID == _loc4_ && _loc8_.VicePetLowID == _loc5_)
            {
               _loc8_.Clear();
               break;
            }
            _loc6_++;
         }
         this.FProcessorWindowPetTrain.Update();
      }
      
      protected function PerformPacket_SC_TrainSlotOpenRet(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:int = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:TTrainData = null;
         _loc2_ = param1.Data;
         _loc3_ = int(_loc2_.readUnsignedInt());
         if(_loc3_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc3_);
            return;
         }
         this.FPetData.BuyVicePetTrainSlotCount = _loc2_.readUnsignedInt();
         _loc5_ = this.FPetData.CurrentVicePetTrainSlotCount - 1;
         _loc6_ = this.FPetData.TrainDatas.GetTrainDataByIndex(_loc5_);
         _loc6_.Status = TTrainData.TYPE_USABLE;
         this.FProcessorWindowPetTrain.Update();
      }
      
      protected function PerformPacket_SC_TrainExpCardRet(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:int = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:TPetBase = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:TTrainData = null;
         var _loc11_:String = null;
         var _loc12_:int = 0;
         var _loc13_:TPetLevelUp = null;
         var _loc14_:int = 0;
         _loc2_ = param1.Data;
         _loc3_ = int(_loc2_.readUnsignedInt());
         if(_loc3_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc3_);
            return;
         }
         _loc4_ = _loc2_.readUnsignedInt();
         _loc5_ = _loc2_.readUnsignedInt();
         _loc7_ = int(_loc2_.readUnsignedInt());
         _loc9_ = int(_loc2_.readUnsignedInt());
         _loc8_ = int(_loc2_.readUnsignedInt());
         _loc6_ = this.FPetData.OwnVicePets.GetPetByIdentifier(_loc4_,_loc5_);
         _loc14_ = int(_loc6_.Level);
         _loc6_.Level = _loc7_;
         _loc6_.Experience = _loc9_;
         if(_loc14_ < _loc6_.Level)
         {
            this.FUnstreamizerPet.UnstreamizeVicePet(null,_loc6_,null);
         }
         _loc11_ = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_PET_59),_loc6_.Name,_loc8_,_loc7_);
         SToolReward.ShowMessage(_loc11_);
         _loc12_ = int(_loc6_.GetTemplateIDByLevel(_loc7_));
         _loc13_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_PetLevelUp,_loc12_) as TPetLevelUp;
         if(_loc13_.IsMaxLevel == 1)
         {
            _loc10_ = this.FPetData.TrainDatas.GetTrainDataByPetIdentifier(_loc4_,_loc5_);
            _loc10_.Status = TTrainData.TYPE_COMPLETED;
         }
         else
         {
            _loc13_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_PetLevelUp,_loc12_ + 1) as TPetLevelUp;
            _loc6_.NextExperience = _loc13_.NeedExp;
         }
         this.FProcessorWindowPetTrain.Update();
      }
      
      protected function ProcessorsTrainModelOnOpen(param1:Object, param2:TVicePet, param3:int = -1) : void
      {
         this.FCurrentVicePet = param2;
         this.FCurrentGridIndex = param3;
         this.FProcessorWindowPetTrainModel.Update();
         this.FProcessorWindowPetTrain.Visible = false;
         this.FProcessorWindowPetTrainModel.Visible = true;
      }
      
      protected function ProcessorWindowClose(param1:Object) : void
      {
         BarrierDeactuateWindows(param1);
         this.Unmount();
      }
      
      protected function ProcessorWindowOnClose(param1:Object) : void
      {
         this.FProcessorWindowPetTrainModel.Reset();
         this.FProcessorWindowPetTrain.Visible = true;
      }
      
      protected function ProcessorOnTrain(param1:Object, param2:uint, param3:uint) : void
      {
         var _loc4_:TPacket = null;
         var _loc5_:uint = 0;
         var _loc6_:TTrainData = null;
         var _loc7_:int = 0;
         if(this.FCurrentGridIndex >= 0)
         {
            _loc7_ = this.FCurrentGridIndex;
         }
         else
         {
            _loc7_ = -1;
            _loc5_ = 0;
            while(_loc5_ < this.FPetData.TrainDatas.Count)
            {
               _loc6_ = this.FPetData.TrainDatas.GetTrainDataByIndex(_loc5_);
               if(_loc6_.VicePetHighID == 0 && _loc6_.VicePetLowID == 0)
               {
                  _loc7_ = int(_loc6_.Identifier);
                  break;
               }
               _loc5_++;
            }
         }
         if(_loc7_ < 0)
         {
            return;
         }
         _loc4_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_VicePetTrainReq);
         _loc4_.Data.writeUnsignedInt(this.FCurrentVicePet.Identifier0);
         _loc4_.Data.writeUnsignedInt(this.FCurrentVicePet.Identifier1);
         _loc4_.Data.writeUnsignedInt(param2);
         _loc4_.Data.writeUnsignedInt(param3);
         _loc4_.Data.writeUnsignedInt(_loc7_);
         SNetworkCore.Transceiver.PacketTransmit(_loc4_);
      }
      
      protected function ProcessorOnSlotOver(param1:Object, param2:Object) : void
      {
         if(this.FOnSlotOver != null)
         {
            this.FOnSlotOver(param1,param2);
         }
      }
      
      protected function ProcessorOnSlotOut(param1:Object, param2:Object) : void
      {
         if(this.FOnSlotOut != null)
         {
            this.FOnSlotOut(param1,param2);
         }
      }
      
      public function get OnSlotOver() : Function
      {
         return this.FOnSlotOver;
      }
      
      public function set OnSlotOver(param1:Function) : void
      {
         this.FOnSlotOver = param1;
      }
      
      public function get OnSlotOut() : Function
      {
         return this.FOnSlotOut;
      }
      
      public function set OnSlotOut(param1:Function) : void
      {
         this.FOnSlotOut = param1;
      }
      
      override public function Mount(param1:ByteArray = null) : void
      {
         super.Mount(param1);
         if(!FIsResourcesLoadCompleted)
         {
            this.FProcessorWindowPetTrain.Load();
            this.FProcessorWindowPetTrainModel.Load();
            return;
         }
         BarrierActuateWindows(this.FProcessorWindowPetTrain);
         this.FProcessorWindowPetTrain.Update();
         this.FProcessorWindowPetTrain.Visible = true;
      }
      
      override public function Unmount() : void
      {
         super.Unmount();
         this.Reset();
         this.FProcessorWindowPetTrain.Reset();
         this.FProcessorWindowPetTrainModel.Reset();
         this.FProcessorWindowPetTrain.Visible = false;
         this.FProcessorWindowPetTrainModel.Visible = false;
      }
      
      public function Reset() : void
      {
         this.FCurrentVicePet = null;
         this.FCurrentGridIndex = -1;
      }
   }
}

