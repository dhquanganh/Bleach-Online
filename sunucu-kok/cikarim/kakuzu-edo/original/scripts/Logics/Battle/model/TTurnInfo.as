package Logics.Battle.model
{
   import Debugging.*;
   import flash.utils.*;
   
   public class TTurnInfo
   {
      
      protected var FActiveCount:int;
      
      protected var FCurTurn:int;
      
      protected var FActiveInfos:Vector.<TActiveInfo>;
      
      public function TTurnInfo()
      {
         super();
         this.FActiveInfos = new Vector.<TActiveInfo>();
      }
      
      public function get ActiveCount() : int
      {
         return this.FActiveCount;
      }
      
      public function set ActiveCount(param1:int) : void
      {
         this.FActiveCount = param1;
      }
      
      public function get CurTurn() : int
      {
         return this.FCurTurn;
      }
      
      public function set CurTurn(param1:int) : void
      {
         this.FCurTurn = param1;
      }
      
      public function get ActiveInfos() : Vector.<TActiveInfo>
      {
         return this.FActiveInfos;
      }
      
      public function FillData() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TActiveInfo = null;
         _loc2_ = int(this.FActiveInfos.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FActiveInfos[_loc1_];
            _loc3_.FillData();
            _loc1_++;
         }
      }
      
      public function Reset() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TActiveInfo = null;
         this.FActiveCount = 0;
         this.FCurTurn = 0;
         _loc2_ = int(this.FActiveInfos.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FActiveInfos[_loc1_];
            _loc3_.Reset();
            _loc3_ = null;
            _loc1_++;
         }
         this.FActiveInfos.length = 0;
      }
      
      public function SetDataByObj(param1:Object) : void
      {
         var _loc2_:int = 0;
         var _loc3_:TActiveInfo = null;
         this.FCurTurn = param1.CurTurn;
         this.FActiveCount = param1.ActiveCount;
         _loc2_ = 0;
         while(_loc2_ < this.FActiveCount)
         {
            _loc3_ = new TActiveInfo(_loc2_);
            _loc3_.SetDataByObj(param1.Active["Active" + _loc2_]);
            this.FActiveInfos.push(_loc3_);
            _loc2_++;
         }
      }
      
      public function toString() : String
      {
         var _loc1_:int = 0;
         var _loc2_:String = null;
         _loc2_ = "{";
         _loc1_ = 0;
         while(_loc1_ < this.ActiveInfos.length)
         {
            _loc2_ += "\n\t" + " \"Active" + _loc1_ + "\":" + this.ActiveInfos[_loc1_].toString();
            if(_loc1_ != this.ActiveInfos.length - 1)
            {
               _loc2_ += ",";
            }
            _loc1_++;
         }
         _loc2_ += "}";
         return "{ \"CurTurn\":" + this.FCurTurn + ", \"ActiveCount\":" + this.FActiveCount + ", \"Active\":" + _loc2_ + "}";
      }
   }
}

