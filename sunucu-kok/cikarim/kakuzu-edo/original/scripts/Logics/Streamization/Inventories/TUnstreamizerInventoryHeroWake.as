package Logics.Streamization.Inventories
{
   import Foundation.Network.SNetworkCore;
   import Foundation.Network.TPacket;
   import Foundation.Resources.Bins.TBins;
   import Foundation.Resources.SResourcesCore;
   import Logics.Characters.MainRoleWake.THeroWakeData;
   import Logics.Characters.MainRoleWake.THeroWakeEquipment;
   import Logics.DatebaseVO.VO.TLeaderWakeUp;
   import Resources.Constants.CONST_DATEBASEVO;
   import Resources.Constants.CONST_NETWORK;
   import flash.utils.ByteArray;
   
   public class TUnstreamizerInventoryHeroWake extends TUnstreamizerInventory
   {
      
      public const ReqType_Advanced:uint = 0;
      
      public const ReqType_Streng:uint = 1;
      
      public function TUnstreamizerInventoryHeroWake()
      {
         super();
      }
      
      protected function GetHeroWakeEquipmentByPos(param1:uint, param2:THeroWakeData) : THeroWakeEquipment
      {
         var _loc3_:THeroWakeEquipment = null;
         for each(_loc3_ in param2.Equips)
         {
            if(_loc3_.WakeUpConfig.PosEquip == param1)
            {
               return _loc3_;
            }
         }
         return null;
      }
      
      protected function GetHeroWakeEquipmentByID(param1:uint, param2:THeroWakeData) : THeroWakeEquipment
      {
         var _loc3_:THeroWakeEquipment = null;
         for each(_loc3_ in param2.Equips)
         {
            if(_loc3_.WakeUpConfig.Identifier == param1)
            {
               return _loc3_;
            }
         }
         return null;
      }
      
      protected function UpdateAllEquip(param1:THeroWakeData) : void
      {
         var _loc2_:THeroWakeEquipment = null;
         var _loc3_:int = 0;
         var _loc4_:THeroWakeEquipment = null;
         _loc3_ = int.MAX_VALUE;
         _loc4_ = param1.Equips[THeroWakeData.AllPos];
         for each(_loc2_ in param1.Equips)
         {
            if(THeroWakeData.IsEquips(_loc2_))
            {
               if(_loc2_.WakeUpConfig.WakeStage < _loc3_)
               {
                  _loc3_ = _loc2_.WakeUpConfig.WakeStage;
               }
            }
         }
         this.UpdateHeroWakeEquipment(14152000 + THeroWakeData.AllPos * 100 + _loc3_,_loc4_);
      }
      
      protected function UnstreamizationPerform_WakeAttribute(param1:ByteArray, param2:THeroWakeData) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         _loc3_ = param1.readUnsignedShort();
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = param1.readUnsignedInt();
            _loc6_ = param1.readUnsignedInt();
            param2.HeroWakeAttributeS2C[_loc5_] = _loc6_;
            _loc4_++;
         }
      }
      
      public function CreateHeroWakeEquipment(param1:uint) : THeroWakeEquipment
      {
         var _loc2_:THeroWakeEquipment = null;
         var _loc3_:TLeaderWakeUp = null;
         if(param1 == 0)
         {
            return null;
         }
         _loc2_ = new THeroWakeEquipment(param1);
         _loc2_.IDTemplate = param1;
         UnstreamizationPerform_InventoryByDatabase(_loc2_);
         _loc3_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_LeaderWakeUp,param1) as TLeaderWakeUp;
         _loc2_.CurStreng = 0;
         _loc2_.WakeUpConfig = _loc3_;
         return _loc2_;
      }
      
      public function UpdateHeroWakeEquipment(param1:uint, param2:THeroWakeEquipment) : void
      {
         var _loc3_:TLeaderWakeUp = null;
         if(param1 == 0)
         {
            return;
         }
         param2.IDTemplate = param1;
         UnstreamizationPerform_InventoryByDatabase(param2);
         _loc3_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_LeaderWakeUp,param1) as TLeaderWakeUp;
         param2.CurStreng = 0;
         param2.WakeUpConfig = _loc3_;
      }
      
      public function AdvancedOrStrengReq(param1:uint, param2:THeroWakeEquipment) : void
      {
         var _loc3_:TPacket = null;
         var _loc4_:ByteArray = null;
         _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_HeroWakeUp_AdvancedOrStrengReq);
         _loc4_ = _loc3_.Data;
         _loc4_.writeInt(param1);
         _loc4_.writeInt(param2.IDTemplate);
         _loc4_.writeInt(param2.WakeUpConfig.PosEquip);
         SNetworkCore.Transceiver.PacketTransmit(_loc3_);
      }
      
      public function InitRet(param1:ByteArray, param2:THeroWakeData) : void
      {
         var _loc3_:TBins = null;
         var _loc4_:TLeaderWakeUp = null;
         var _loc5_:THeroWakeEquipment = null;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         var _loc10_:uint = 0;
         if(!param2.Inited)
         {
            _loc3_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_LeaderWakeUp);
            _loc6_ = 0;
            while(_loc6_ < _loc3_.Count)
            {
               _loc4_ = _loc3_.GetDatebaseByIndex(_loc6_) as TLeaderWakeUp;
               if(_loc4_.WakeStage == 0)
               {
                  _loc5_ = this.CreateHeroWakeEquipment(_loc4_.Identifier);
                  param2.Equips[_loc4_.PosEquip] = _loc5_;
               }
               _loc6_++;
            }
            _loc7_ = param1.readUnsignedShort();
            _loc6_ = 0;
            while(_loc6_ < _loc7_)
            {
               _loc9_ = param1.readUnsignedInt();
               _loc8_ = param1.readUnsignedInt();
               _loc10_ = param1.readUnsignedInt();
               _loc5_ = this.GetHeroWakeEquipmentByPos(_loc8_,param2);
               this.UpdateHeroWakeEquipment(_loc9_,_loc5_);
               _loc5_.CurStreng = _loc10_;
               _loc6_++;
            }
            this.UnstreamizationPerform_WakeAttribute(param1,param2);
            this.UpdateAllEquip(param2);
            param2.Inited = true;
         }
      }
      
      public function AdvancedOrStrengRet(param1:ByteArray, param2:THeroWakeData) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:THeroWakeEquipment = null;
         _loc3_ = param1.readInt();
         _loc4_ = param1.readInt();
         _loc5_ = this.GetHeroWakeEquipmentByID(_loc4_,param2);
         if(_loc3_ == this.ReqType_Advanced)
         {
            this.UpdateHeroWakeEquipment(_loc5_.WakeUpConfig.NextID,_loc5_);
            this.UpdateAllEquip(param2);
         }
         else
         {
            ++_loc5_.CurStreng;
         }
         this.UnstreamizationPerform_WakeAttribute(param1,param2);
      }
   }
}

