package Logics.Pet.Train
{
   import Resources.Constants.*;
   
   public class TTrainDatas
   {
      
      protected var FTrainDatas:Vector.<TTrainData>;
      
      public function TTrainDatas()
      {
         super();
         this.FTrainDatas = new Vector.<TTrainData>();
      }
      
      protected function SortByIdentifier() : void
      {
         this.FTrainDatas.sort(this.SortIdentifier);
      }
      
      protected function SortIdentifier(param1:TTrainData, param2:TTrainData) : int
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         _loc3_ = param1.Identifier;
         _loc4_ = param2.Identifier;
         if(_loc3_ < _loc4_)
         {
            return -1;
         }
         if(_loc3_ > _loc4_)
         {
            return 1;
         }
         return 0;
      }
      
      public function get Count() : int
      {
         return this.FTrainDatas.length;
      }
      
      public function GetTrainDataByIndex(param1:int) : TTrainData
      {
         return this.FTrainDatas[param1];
      }
      
      public function GetTrainDataByIdentifier(param1:uint) : TTrainData
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TTrainData = null;
         _loc2_ = int(this.FTrainDatas.length);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = this.FTrainDatas[_loc3_];
            if(_loc4_.Identifier == param1)
            {
               return _loc4_;
            }
            _loc3_++;
         }
         return null;
      }
      
      public function GetTrainDataByPetIdentifier(param1:uint, param2:uint) : TTrainData
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:TTrainData = null;
         if(param1 == 0 && param2 == 0)
         {
            return null;
         }
         _loc3_ = int(this.FTrainDatas.length);
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = this.FTrainDatas[_loc4_];
            if(_loc5_.VicePetHighID == param1 && _loc5_.VicePetLowID == param2)
            {
               return _loc5_;
            }
            _loc4_++;
         }
         return null;
      }
      
      public function Clear() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TTrainData = null;
         _loc1_ = int(this.FTrainDatas.length);
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            this.FTrainDatas[_loc2_] = null;
            _loc2_++;
         }
         this.FTrainDatas.length = 0;
      }
      
      public function Add(param1:TTrainData) : void
      {
         this.FTrainDatas.push(param1);
      }
      
      public function Delete(param1:int) : void
      {
         this.FTrainDatas.splice(param1,1);
      }
      
      public function GetUseSlots() : uint
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:uint = 0;
         _loc1_ = int(this.FTrainDatas.length);
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            if(this.FTrainDatas[_loc2_].VicePetHighID != 0 && this.FTrainDatas[_loc2_].VicePetLowID != 0)
            {
               _loc3_++;
            }
            _loc2_++;
         }
         return _loc3_;
      }
      
      public function Sort() : void
      {
         this.SortByIdentifier();
      }
   }
}

