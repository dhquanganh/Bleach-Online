package Logics.ProfessionRefine.Unstreamizer
{
   import Foundation.Streamization.TUnstreamizer;
   import Logics.ProfessionRefine.TProfessionRefine;
   import Logics.ProfessionRefine.TProfessionRefineList;
   import flash.utils.ByteArray;
   
   public class TUnstreamizerProfessionRefine extends TUnstreamizer
   {
      
      public function TUnstreamizerProfessionRefine()
      {
         super();
      }
      
      protected function Info(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TProfessionRefineList = null;
         var _loc7_:TProfessionRefine = null;
         _loc6_ = param2 as TProfessionRefineList;
         _loc5_ = int(param1.readUnsignedShort());
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc7_ = _loc6_.GetProfessionRefineById(_loc4_ + 1);
            _loc7_.CurLevel = param1.readInt();
            _loc4_++;
         }
      }
      
      protected function Levelup(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:TProfessionRefineList = null;
         var _loc5_:TProfessionRefine = null;
         _loc4_ = param2 as TProfessionRefineList;
         _loc5_ = _loc4_.GetProfessionRefineById(param1.readInt());
         if(_loc5_ == null) return;
         if(param1.bytesAvailable >= 4) _loc5_.CurLevel = param1.readInt();
         else ++_loc5_.CurLevel;
         param3.HeroType = _loc5_.HeroType;
      }
      
      public function UnstreamizationPerform_Info(param1:ByteArray, param2:Object, param3:Object) : void
      {
         this.Info(param1,param2,param3);
      }
      
      public function UnstreamizationPerform_Levelup(param1:ByteArray, param2:Object, param3:Object) : void
      {
         this.Levelup(param1,param2,param3);
      }
   }
}

