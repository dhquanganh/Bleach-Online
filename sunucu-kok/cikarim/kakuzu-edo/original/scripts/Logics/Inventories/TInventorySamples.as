package Logics.Inventories
{
   public class TInventorySamples
   {
      
      protected var FInventorySamples:Vector.<TInventorySample>;
      
      public function TInventorySamples()
      {
         super();
         this.FInventorySamples = new Vector.<TInventorySample>();
      }
      
      protected function SortRoutineSequenceID(param1:TInventorySample, param2:TInventorySample) : int
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         _loc3_ = param1.SortID;
         _loc4_ = param2.SortID;
         if(_loc3_ > _loc4_)
         {
            return 1;
         }
         if(_loc3_ <= _loc4_)
         {
            return -1;
         }
         return 0;
      }
      
      protected function InstanceReplace(param1:int, param2:TInventorySample) : void
      {
         var _loc3_:TInventorySample = null;
         var _loc4_:TInventorySample = null;
         _loc3_ = this.FInventorySamples[param1];
         if(_loc3_ != null)
         {
            _loc4_ = _loc3_ as TInventorySample;
            _loc4_.StubReferences.Dereference(this);
         }
         if(param2 != null)
         {
            _loc4_ = param2 as TInventorySample;
            _loc4_.StubReferences.Reference(this);
         }
         this.FInventorySamples[param1] = param2;
      }
      
      public function get Count() : int
      {
         return this.FInventorySamples.length;
      }
      
      public function GetInventorySampleByIndex(param1:int) : TInventorySample
      {
         return this.FInventorySamples[param1];
      }
      
      public function GetInventorySampleByTemplateID(param1:uint) : TInventorySample
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TInventorySample = null;
         _loc2_ = int(this.FInventorySamples.length);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = this.FInventorySamples[_loc3_];
            if(_loc4_.TemplateID == param1)
            {
               return _loc4_;
            }
            _loc3_++;
         }
         return null;
      }
      
      public function Clear() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TInventorySample = null;
         _loc1_ = int(this.FInventorySamples.length);
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = this.FInventorySamples[_loc2_];
            _loc3_.StubReferences.Dereference(this);
            _loc2_++;
         }
         this.FInventorySamples.length = 0;
      }
      
      public function Add(param1:TInventorySample) : void
      {
         param1.StubReferences.Reference(this);
         this.FInventorySamples.push(param1);
      }
      
      public function Insert(param1:int, param2:TInventorySample) : void
      {
         var _loc3_:TInventorySample = null;
         if(param2 != null)
         {
            _loc3_ = param2 as TInventorySample;
            _loc3_.StubReferences.Reference(this);
            this.FInventorySamples.splice(param1,0,param2);
         }
      }
      
      public function SetInventoryByIndex(param1:int, param2:TInventorySample) : void
      {
         this.InstanceReplace(param1,param2);
      }
      
      public function SortBySequenceID() : void
      {
         this.FInventorySamples.sort(this.SortRoutineSequenceID);
      }
      
      public function DeleteSampleByIndex(param1:int) : TInventorySample
      {
         var _loc2_:TInventorySample = null;
         _loc2_ = this.FInventorySamples[param1];
         _loc2_.StubReferences.Dereference(this);
         this.FInventorySamples.splice(param1,1);
         return _loc2_;
      }
   }
}

