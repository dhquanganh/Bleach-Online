package Logics.HDActivitySingle
{
   import Logics.DatebaseVO.VO.Json.TActVipBoxAward;
   import Logics.HDActivityOS.TActivityOSBase;
   import Resources.Constants.CONST_ACTIVITY_MODE;
   
   public class TActivitySingleValentinesDay extends TActivityOSBase
   {
      
      protected static const TYPE_ValentinesDay_FreeBox:uint = CONST_ACTIVITY_MODE.TYPE_ValentinesDay_FreeBox;
      
      protected static const TYPE_ValentinesDay_BuyBox:uint = CONST_ACTIVITY_MODE.TYPE_ValentinesDay_BuyBox;
      
      protected var FFreeVipBox:Vector.<TActVipBoxAward>;
      
      protected var FBuyVipBox:Vector.<TActVipBoxAward>;
      
      public function TActivitySingleValentinesDay()
      {
         super();
         this.FFreeVipBox = new Vector.<TActVipBoxAward>();
         this.FBuyVipBox = new Vector.<TActVipBoxAward>();
      }
      
      public function get FreeVipBox() : Vector.<TActVipBoxAward>
      {
         return this.FFreeVipBox;
      }
      
      public function set FreeVipBox(param1:Vector.<TActVipBoxAward>) : void
      {
         this.FFreeVipBox = param1;
      }
      
      public function get BuyVipBox() : Vector.<TActVipBoxAward>
      {
         return this.FBuyVipBox;
      }
      
      public function set BuyVipBox(param1:Vector.<TActVipBoxAward>) : void
      {
         this.FBuyVipBox = param1;
      }
      
      public function GetBoxByUniqueIndex(param1:uint) : TActVipBoxAward
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         _loc3_ = int(this.FFreeVipBox.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(this.FFreeVipBox[_loc2_].Index == param1)
            {
               return this.FFreeVipBox[_loc2_];
            }
            _loc2_++;
         }
         _loc3_ = int(this.FBuyVipBox.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(this.FBuyVipBox[_loc2_].Index == param1)
            {
               return this.FBuyVipBox[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public function GetMaxFreeBox() : TActVipBoxAward
      {
         var _loc1_:int = 0;
         _loc1_ = this.FFreeVipBox.length - 1;
         return this.FFreeVipBox[_loc1_];
      }
      
      public function GetFreeBoxByIndex(param1:int) : TActVipBoxAward
      {
         return this.FFreeVipBox[param1];
      }
      
      public function GetFreeBoxByUniqueIndex(param1:uint) : TActVipBoxAward
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         _loc3_ = int(this.FFreeVipBox.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(this.FFreeVipBox[_loc2_].Index == param1)
            {
               return this.FFreeVipBox[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public function GetBuyBoxByIndex(param1:int) : TActVipBoxAward
      {
         return this.FBuyVipBox[param1];
      }
      
      public function GetBuyBoxByUniqueIndex(param1:uint) : TActVipBoxAward
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         _loc3_ = int(this.FBuyVipBox.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(this.FBuyVipBox[_loc2_].Index == param1)
            {
               return this.FBuyVipBox[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public function SetStatusByUniqueIndex(param1:uint, param2:int) : int
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _loc4_ = int(this.FFreeVipBox.length);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            if(this.FFreeVipBox[_loc3_].Index == param1)
            {
               this.FFreeVipBox[_loc3_].Status = param2;
               return TYPE_ValentinesDay_FreeBox;
            }
            _loc3_++;
         }
         _loc4_ = int(this.FBuyVipBox.length);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            if(this.FBuyVipBox[_loc3_].Index == param1)
            {
               this.FBuyVipBox[_loc3_].Status = param2;
               return TYPE_ValentinesDay_BuyBox;
            }
            _loc3_++;
         }
         return -1;
      }
   }
}

