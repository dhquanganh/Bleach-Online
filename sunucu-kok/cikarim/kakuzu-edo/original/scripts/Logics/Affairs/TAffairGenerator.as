package Logics.Affairs
{
   import Foundation.Common.TEntityList;
   import Foundation.Network.TPacket;
   import Foundation.Pools.TPoolAutomatic;
   import Logics.Spaces.LogicsSpace;
   
   use namespace LogicsSpace;
   
   public class TAffairGenerator extends TPoolAutomatic
   {
      
      protected var FIndexAffair:int;
      
      protected var FIndexAffairInt:int;
      
      protected var FIndexAffairUInt:int;
      
      protected var FIndexAffairUInt64:int;
      
      protected var FIndexAffairBoolean:int;
      
      protected var FIndexAffairString:int;
      
      protected var FIndexAffairInstance:int;
      
      protected var FIndexAffairPacket:int;
      
      protected var FIndexAffairDelay:int;
      
      protected var FAffairList:TEntityList;
      
      public function TAffairGenerator(param1:TEntityList)
      {
         super();
         this.FAffairList = param1;
      }
      
      override protected function RegisterClasses() : void
      {
         this.FIndexAffair = RegisterClass(TAffair);
         this.FIndexAffairInt = RegisterClass(TAffairInt);
         this.FIndexAffairUInt = RegisterClass(TAffairUInt);
         this.FIndexAffairUInt64 = RegisterClass(TAffairUInt64);
         this.FIndexAffairBoolean = RegisterClass(TAffairBoolean);
         this.FIndexAffairString = RegisterClass(TAffairString);
         this.FIndexAffairInstance = RegisterClass(TAffairInstance);
         this.FIndexAffairPacket = RegisterClass(TAffairPacket,this.ReleasingPerform_AffairPacket);
         this.FIndexAffairDelay = RegisterClass(TAffairDelay);
      }
      
      protected function AffairAppend(param1:TAffair) : void
      {
         if(this.FAffairList != null)
         {
            this.FAffairList.Add(param1);
         }
      }
      
      protected function ReleasingPerform_AffairPacket(param1:Object) : void
      {
         var _loc2_:TAffairPacket = null;
         _loc2_ = param1 as TAffairPacket;
         _loc2_.Packet = null;
      }
      
      public function get AffairList() : TEntityList
      {
         return this.FAffairList;
      }
      
      public function Dispose(param1:TAffair) : void
      {
         InstanceRelease(param1);
      }
      
      public function Generate(param1:uint) : TAffair
      {
         var _loc2_:TAffair = null;
         _loc2_ = InstanceAcquireByIndex(this.FIndexAffair) as TAffair;
         if(_loc2_ != null)
         {
            _loc2_.Coerce(param1);
         }
         else
         {
            _loc2_ = new TAffair(param1);
         }
         this.AffairAppend(_loc2_);
         return _loc2_;
      }
      
      public function GenerateInt(param1:uint, param2:int) : TAffairInt
      {
         var _loc3_:TAffairInt = null;
         _loc3_ = InstanceAcquireByIndex(this.FIndexAffairInt) as TAffairInt;
         if(_loc3_ != null)
         {
            _loc3_.Coerce(param1);
         }
         else
         {
            _loc3_ = new TAffairInt(param1);
         }
         _loc3_.Value = param2;
         this.AffairAppend(_loc3_);
         return _loc3_;
      }
      
      public function GenerateUInt(param1:uint, param2:uint) : TAffairUInt
      {
         var _loc3_:TAffairUInt = null;
         _loc3_ = InstanceAcquireByIndex(this.FIndexAffairUInt) as TAffairUInt;
         if(_loc3_ != null)
         {
            _loc3_.Coerce(param1);
         }
         else
         {
            _loc3_ = new TAffairUInt(param1);
         }
         _loc3_.Value = param2;
         this.AffairAppend(_loc3_);
         return _loc3_;
      }
      
      public function GenerateUInt64(param1:uint, param2:uint, param3:uint) : TAffairUInt64
      {
         var _loc4_:TAffairUInt64 = null;
         _loc4_ = InstanceAcquireByIndex(this.FIndexAffairUInt64) as TAffairUInt64;
         if(_loc4_ != null)
         {
            _loc4_.Coerce(param1);
         }
         else
         {
            _loc4_ = new TAffairUInt64(param1);
         }
         _loc4_.Value0 = param2;
         _loc4_.Value1 = param3;
         this.AffairAppend(_loc4_);
         return _loc4_;
      }
      
      public function GenerateBoolean(param1:uint, param2:Boolean) : TAffairBoolean
      {
         var _loc3_:TAffairBoolean = null;
         _loc3_ = InstanceAcquireByIndex(this.FIndexAffairBoolean) as TAffairBoolean;
         if(_loc3_ != null)
         {
            _loc3_.Coerce(param1);
         }
         else
         {
            _loc3_ = new TAffairBoolean(param1);
         }
         _loc3_.Value = param2;
         this.AffairAppend(_loc3_);
         return _loc3_;
      }
      
      public function GenerateString(param1:uint, param2:String) : TAffairString
      {
         var _loc3_:TAffairString = null;
         _loc3_ = InstanceAcquireByIndex(this.FIndexAffairString) as TAffairString;
         if(_loc3_ != null)
         {
            _loc3_.Coerce(param1);
         }
         else
         {
            _loc3_ = new TAffairString(param1);
         }
         _loc3_.Value = param2;
         this.AffairAppend(_loc3_);
         return _loc3_;
      }
      
      public function GenerateInstance(param1:uint, param2:Object) : TAffairInstance
      {
         var _loc3_:TAffairInstance = null;
         _loc3_ = InstanceAcquireByIndex(this.FIndexAffairInstance) as TAffairInstance;
         if(_loc3_ != null)
         {
            _loc3_.Coerce(param1);
         }
         else
         {
            _loc3_ = new TAffairInstance(param1);
         }
         _loc3_.Instance = param2;
         this.AffairAppend(_loc3_);
         return _loc3_;
      }
      
      public function GeneratePacket(param1:uint, param2:TPacket) : TAffairPacket
      {
         var _loc3_:TAffairPacket = null;
         _loc3_ = InstanceAcquireByIndex(this.FIndexAffairPacket) as TAffairPacket;
         if(_loc3_ != null)
         {
            _loc3_.Coerce(param1);
         }
         else
         {
            _loc3_ = new TAffairPacket(param1);
         }
         _loc3_.Packet = param2;
         this.AffairAppend(_loc3_);
         return _loc3_;
      }
      
      public function GenerateDelay(param1:uint, param2:int, param3:int = 0) : TAffairDelay
      {
         var _loc4_:TAffairDelay = null;
         _loc4_ = InstanceAcquireByIndex(this.FIndexAffairDelay) as TAffairDelay;
         if(_loc4_ != null)
         {
            _loc4_.Coerce(param1);
         }
         else
         {
            _loc4_ = new TAffairDelay(param1);
         }
         _loc4_.DelayTicks = param2;
         _loc4_.ReferenceTick = param3;
         this.AffairAppend(_loc4_);
         return _loc4_;
      }
   }
}

