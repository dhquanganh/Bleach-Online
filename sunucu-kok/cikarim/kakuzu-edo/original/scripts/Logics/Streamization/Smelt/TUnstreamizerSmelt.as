package Logics.Streamization.Smelt
{
   import Foundation.Network.SNetworkCore;
   import Foundation.Network.TPacket;
   import Foundation.Resources.SResourcesCore;
   import Logics.Characters.THero;
   import Logics.DatebaseVO.VO.TConfigValue;
   import Logics.DatebaseVO.VO.TKnifeStrengExp;
   import Logics.HeroChange.THeroChange;
   import Logics.KnifeOfKillSoul.TKnifeOfKillSoulData;
   import Logics.KnifeOfKillSoul.VO.TKnifeStrengthenAdd;
   import Logics.SLogicsCore;
   import Resources.Constants.CONST_CONFIGVALUE;
   import Resources.Constants.CONST_DATEBASEVO;
   import Resources.Constants.CONST_NETWORK;
   import flash.utils.ByteArray;
   
   public class TUnstreamizerSmelt
   {
      
      public static const Type_Change:uint = 0;
      
      public static const Type_Exclusive:uint = 1;
      
      public static const Type_Rebirth:uint = 2;
      
      public static const Type_Related:uint = 3;
      
      public static const Type_KnifeOfKillSoul:uint = 5;
      
      public function TUnstreamizerSmelt()
      {
         super();
      }
      
      protected function HeroChangeReset(param1:THero) : void
      {
         var _loc2_:THeroChange = null;
         _loc2_ = SLogicsCore.HeroChangeData.GetHeroChangeByHeroID(param1.Identifier);
         _loc2_.Hero.ChangeSchedule = 0;
         param1 = SLogicsCore.Character.Heros.GetHeroByIdentifier(param1.Identifier);
         if(param1 != null)
         {
            param1.ChangeSchedule = _loc2_.Hero.ChangeSchedule;
         }
      }
      
      protected function ExclusiveReset(param1:THero) : void
      {
         var _loc2_:TPacket = null;
         param1.CustomHero.Level = 0;
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_CustomHero_InitInfoReq);
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
      }
      
      protected function RebirthReset(param1:THero) : void
      {
         param1.RebirthNum = 0;
         param1.PropPower = 0;
         param1.AttackEffect = 0;
      }
      
      protected function RelatedReset(param1:THero) : void
      {
      }
      
      public function ResetRet(param1:ByteArray) : Object
      {
         var _loc2_:uint = 0;
         var _loc4_:THero = null;
         var _loc5_:TKnifeOfKillSoulData = null;
         var _loc6_:Object = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc3_:uint = 0;
         _loc6_ = new Object();
         _loc2_ = uint(param1.readByte());
         if(_loc2_ == Type_KnifeOfKillSoul)
         {
            _loc5_ = SLogicsCore.Character.KnifeOfKillSoul.GetByIndentifier(param1.readUnsignedInt());
         }
         else
         {
            _loc3_ = param1.readUnsignedInt();
            _loc4_ = SLogicsCore.Character.Heros.GetHeroByIdentifier(_loc3_);
         }
         switch(_loc2_)
         {
            case Type_Change:
               this.HeroChangeReset(_loc4_);
               break;
            case Type_Exclusive:
               this.ExclusiveReset(_loc4_);
               break;
            case Type_Rebirth:
               this.RebirthReset(_loc4_);
               break;
            case Type_Related:
               this.RelatedReset(_loc4_);
               break;
            case Type_KnifeOfKillSoul:
               _loc8_ = 3;
               _loc7_ = 0;
               while(_loc7_ < _loc8_)
               {
                  this.ResetStrengthenAttribute(_loc5_,_loc7_,1,0);
                  _loc7_++;
               }
               this.ResetStrengthenAdvance(_loc5_);
         }
         _loc6_.Type = _loc2_;
         _loc6_.HeroID = _loc3_;
         return _loc6_;
      }
      
      protected function ResetStrengthenAttribute(param1:TKnifeOfKillSoulData, param2:int, param3:int, param4:int) : void
      {
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:TKnifeStrengthenAdd = null;
         var _loc8_:TKnifeStrengExp = null;
         var _loc9_:TKnifeStrengExp = null;
         _loc8_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_KnifeStrengExp,param1.Quality * 1000 + param3) as TKnifeStrengExp;
         _loc7_ = param1.StrengthenAdd[param2];
         _loc7_.Exp = param4;
         _loc7_.Level = param3;
         _loc7_.UpExp = _loc8_.Exp;
         _loc7_.TotalExp = _loc8_.Accumulation;
         _loc7_.Value = _loc7_.BaseValue + param3 * _loc7_.UpAddValue;
         _loc9_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_KnifeStrengExp,param1.Quality * 1000 + param3 + 1) as TKnifeStrengExp;
         _loc7_.IsMax = _loc9_ == null;
         _loc6_ = param1.StrengthenAdd.length;
         _loc5_ = 0;
         while(_loc5_ < _loc6_)
         {
            _loc7_ = param1.StrengthenAdd[_loc5_];
            this.ResetStrengLevelNode(_loc7_,param1);
            _loc5_++;
         }
      }
      
      protected function ResetStrengLevelNode(param1:TKnifeStrengthenAdd, param2:TKnifeOfKillSoulData) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:Vector.<int> = null;
         var _loc6_:TConfigValue = null;
         var _loc7_:uint = 0;
         _loc6_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_ConfigValue).GetDatebaseByIdentifier(CONST_CONFIGVALUE.Knife_StrongNodeLevel) as TConfigValue;
         _loc5_ = Vector.<int>(_loc6_.Value);
         param1.IsNodeLevel = false;
         _loc4_ = _loc5_.length;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc7_ = uint(_loc5_[_loc3_]);
            if(_loc7_ == param1.Level && param1.IsNodeLevel)
            {
               break;
            }
            if(_loc7_ > param1.Level)
            {
               break;
            }
            _loc3_++;
         }
         param1.NextNodeLevel = _loc7_;
      }
      
      protected function ResetStrengthenAdvance(param1:TKnifeOfKillSoulData) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:Vector.<int> = null;
         var _loc5_:TConfigValue = null;
         _loc5_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_ConfigValue).GetDatebaseByIdentifier(CONST_CONFIGVALUE.Knife_StrongNodeLevel) as TConfigValue;
         _loc4_ = Vector.<int>(_loc5_.Value);
         _loc3_ = _loc4_.length;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            param1.StrengthenPhase[_loc2_].Activate = false;
            _loc2_++;
         }
      }
      
      public function ResetReq(param1:uint, param2:uint, param3:uint, param4:uint, param5:uint, param6:uint) : void
      {
         var _loc7_:TPacket = null;
         _loc7_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Smelt_ResetReq);
         _loc7_.Data.writeByte(param1);
         if(param1 == Type_KnifeOfKillSoul)
         {
            _loc7_.Data.writeUnsignedInt(param3);
         }
         else
         {
            _loc7_.Data.writeUnsignedInt(param2);
         }
         _loc7_.Data.writeUnsignedInt(param4);
         _loc7_.Data.writeUnsignedInt(param5);
         _loc7_.Data.writeByte(param6);
         SNetworkCore.Transceiver.PacketTransmit(_loc7_);
      }
   }
}

