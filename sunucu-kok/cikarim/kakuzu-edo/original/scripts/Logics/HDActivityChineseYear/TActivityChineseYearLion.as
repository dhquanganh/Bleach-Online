package Logics.HDActivityChineseYear
{
   import Logics.HDActivityOS.TActivityOSBase;
   
   public class TActivityChineseYearLion extends TActivityOSBase
   {
      
      protected var FData:Vector.<TActivityLion>;
      
      protected var FCurDay:int;
      
      public function TActivityChineseYearLion()
      {
         super();
         this.FData = new Vector.<TActivityLion>();
      }
      
      public function get CurDay() : int
      {
         return this.FCurDay;
      }
      
      public function set CurDay(param1:int) : void
      {
         this.FCurDay = param1;
      }
      
      public function get Count() : int
      {
         return this.FData.length;
      }
      
      public function Add(param1:TActivityLion) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         _loc3_ = int(this.FData.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(param1.Index == this.FData[_loc2_].Index)
            {
               return;
            }
            _loc2_++;
         }
         this.FData.push(param1);
      }
      
      public function Delete(param1:TActivityLion) : void
      {
      }
      
      public function GetAwardData() : TActivityLion
      {
         if(this.FData.length > 0)
         {
            return this.FData[0];
         }
         return null;
      }
      
      public function GetAwardByUniqueIndex(param1:uint) : TActivityLion
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         _loc3_ = int(this.FData.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(this.FData[_loc2_].Index == param1)
            {
               return this.FData[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public function GetAwardByIndex(param1:uint) : TActivityLion
      {
         var _loc2_:int = 0;
         _loc2_ = int(param1);
         if(_loc2_ < this.FData.length)
         {
            return this.FData[_loc2_];
         }
         return null;
      }
      
      public function SetAwardStatusByUniqueIndex(param1:uint, param2:int) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _loc4_ = int(this.FData.length);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            if(this.FData[_loc3_].Index == param1)
            {
               this.FData[_loc3_].Status = param2;
               break;
            }
            _loc3_++;
         }
      }
   }
}

