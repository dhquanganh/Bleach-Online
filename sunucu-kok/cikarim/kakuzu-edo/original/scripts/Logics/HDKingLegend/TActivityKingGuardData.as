package Logics.HDKingLegend
{
   import Logics.HDActivityOS.TActivityOSBase;
   
   public class TActivityKingGuardData extends TActivityOSBase
   {
      
      protected var FFreeCount:int;
      
      protected var FChipCountVec:Vector.<int>;
      
      protected var FChipIndexVec:Vector.<int>;
      
      protected var FCurGuard:int;
      
      protected var FResult:int;
      
      protected var FIsResult:Boolean;
      
      protected var FCurDay:int;
      
      protected var FChipExchangeVec:Vector.<int>;
      
      protected var FLastGameStatus:int;
      
      public function TActivityKingGuardData()
      {
         super();
         this.FChipCountVec = new Vector.<int>();
         this.FChipIndexVec = new Vector.<int>();
         this.FChipExchangeVec = new Vector.<int>();
      }
      
      public function get FreeCount() : int
      {
         return this.FFreeCount;
      }
      
      public function set FreeCount(param1:int) : void
      {
         this.FFreeCount = param1;
      }
      
      public function get CurGuard() : int
      {
         return this.FCurGuard;
      }
      
      public function set CurGuard(param1:int) : void
      {
         this.FCurGuard = param1;
      }
      
      public function get Result() : int
      {
         return this.FResult;
      }
      
      public function set Result(param1:int) : void
      {
         this.FResult = param1;
      }
      
      public function get IsResult() : Boolean
      {
         return this.FIsResult;
      }
      
      public function set IsResult(param1:Boolean) : void
      {
         this.FIsResult = param1;
      }
      
      public function get CurDay() : int
      {
         return this.FCurDay;
      }
      
      public function set CurDay(param1:int) : void
      {
         this.FCurDay = param1;
      }
      
      public function get LastGameStatus() : int
      {
         return this.FLastGameStatus;
      }
      
      public function set LastGameStatus(param1:int) : void
      {
         this.FLastGameStatus = param1;
      }
      
      public function AddChip(param1:int, param2:int) : void
      {
         var _loc3_:int = 0;
         _loc3_ = this.FChipIndexVec.indexOf(param1);
         if(_loc3_ == -1)
         {
            this.FChipIndexVec.push(param1);
            this.FChipCountVec.push(param2);
            this.FChipExchangeVec.push(0);
         }
         else
         {
            this.FChipCountVec[_loc3_] = param2;
         }
      }
      
      public function SetExchange(param1:int, param2:int) : void
      {
         var _loc3_:int = 0;
         _loc3_ = this.FChipIndexVec.indexOf(param1);
         if(_loc3_ != -1)
         {
            this.FChipExchangeVec[_loc3_] = param2;
         }
      }
      
      public function GetExchangeStatus(param1:int) : int
      {
         var _loc2_:int = 0;
         _loc2_ = this.FChipIndexVec.indexOf(param1);
         if(_loc2_ != -1)
         {
            return this.FChipExchangeVec[_loc2_];
         }
         return 0;
      }
      
      public function GetChip(param1:int) : int
      {
         var _loc2_:int = 0;
         _loc2_ = this.FChipIndexVec.indexOf(param1);
         if(_loc2_ != -1)
         {
            return this.FChipCountVec[_loc2_];
         }
         return 0;
      }
   }
}

