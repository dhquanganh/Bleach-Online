package Logics.Streamization.HDActivityMode
{
   import Foundation.Streamization.TUnstreamizer;
   import Foundation.Timing.STimingCore;
   import Logics.HDActivityMode.TActivityAtoms;
   import Logics.HDActivityMode.TActivityModes;
   import Logics.SLogicsCore;
   import flash.utils.ByteArray;
   
   public class TUnstreamizerActivityModes extends TUnstreamizer
   {
      
      protected var FUnstreamizerActivityAtoms:TUnstreamizerActivityAtoms;
      
      public function TUnstreamizerActivityModes()
      {
         super();
         this.FUnstreamizerActivityAtoms = new TUnstreamizerActivityAtoms();
      }
      
      override protected function UnstreamizationPerform(param1:ByteArray, param2:Object, param3:Object) : void
      {
         this.UnstreamizationPerform_ActivityModes(param1,param2,param3);
      }
      
      protected function UnstreamizationPerform_ActivityModes(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:TActivityModes = null;
         var _loc5_:TActivityAtoms = null;
         var _loc6_:uint = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         _loc4_ = param2 as TActivityModes;
         _loc4_.Clear();
         _loc7_ = param1.readShort();
         _loc8_ = 0;
         while(_loc8_ < _loc7_)
         {
            _loc6_ = param1.readUnsignedInt();
            _loc5_ = new TActivityAtoms(_loc6_);
            this.FUnstreamizerActivityAtoms.Unstreamize(param1,_loc5_,param3);
            _loc5_.Status = param1.readByte();
            _loc5_.EffectCoolingDown = param1.readInt();
            if(_loc5_.EffectCoolingDown != -1)
            {
               _loc5_.EffectCoolingDown += STimingCore.ServerTick;
            }
            if(SLogicsCore.Character.GetMainLevel() >= _loc5_.PlayerLevel && SLogicsCore.Character.VipLevel >= _loc5_.VipLevel)
            {
               _loc4_.Add(_loc5_);
            }
            _loc8_++;
         }
      }
      
      protected function UnstreamizationPerform_UpdateActivityModes(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:TActivityModes = null;
         var _loc5_:TActivityAtoms = null;
         var _loc6_:Boolean = false;
         var _loc7_:uint = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         _loc4_ = param2 as TActivityModes;
         _loc8_ = param1.readShort();
         _loc9_ = 0;
         while(_loc9_ < _loc8_)
         {
            _loc6_ = Boolean(param1.readByte());
            _loc7_ = param1.readUnsignedInt();
            if(_loc6_)
            {
               _loc5_ = new TActivityAtoms(_loc7_);
               this.FUnstreamizerActivityAtoms.Unstreamize(param1,_loc5_,param3);
               _loc5_.Status = param1.readByte();
               _loc5_.EffectCoolingDown = param1.readInt();
               if(_loc5_.EffectCoolingDown != -1)
               {
                  _loc5_.EffectCoolingDown += STimingCore.ServerTick;
               }
               if(SLogicsCore.Character.GetMainLevel() >= _loc5_.PlayerLevel && SLogicsCore.Character.VipLevel >= _loc5_.VipLevel)
               {
                  _loc4_.Add(_loc5_);
               }
               else
               {
                  _loc4_.DeleteByIdentifier(_loc7_);
               }
            }
            else
            {
               param1.readByte();
               param1.readInt();
               _loc4_.DeleteByIdentifier(_loc7_);
            }
            _loc9_++;
         }
      }
      
      public function UnstreamizeUpdateActivity(param1:ByteArray, param2:Object, param3:Object) : void
      {
         this.UnstreamizationPerform_UpdateActivityModes(param1,param2,param3);
      }
   }
}

