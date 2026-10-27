package Logics.HDActivityChineseYear
{
   import Logics.HDActivityOS.TActivityOSBase;
   
   public class TActivityChineseYearSignIn extends TActivityOSBase
   {
      
      protected var FDateSigns:Vector.<TActivityDateSign>;
      
      public function TActivityChineseYearSignIn()
      {
         super();
         this.FDateSigns = new Vector.<TActivityDateSign>();
      }
      
      public function Add(param1:TActivityDateSign) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         _loc3_ = int(this.FDateSigns.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(this.FDateSigns[_loc2_].Index == param1.Index)
            {
               return;
            }
            _loc2_++;
         }
         this.FDateSigns.push(param1);
      }
      
      public function Delete(param1:TActivityDateSign) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         _loc3_ = int(this.FDateSigns.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(this.FDateSigns[_loc2_].Index == param1.Index)
            {
               this.FDateSigns.splice(_loc2_,1);
               break;
            }
            _loc2_++;
         }
      }
      
      public function GetSignByIndex(param1:int) : TActivityDateSign
      {
         return this.FDateSigns[param1];
      }
      
      public function GetSignByUniqueIndex(param1:uint) : TActivityDateSign
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         _loc3_ = int(this.FDateSigns.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(this.FDateSigns[_loc2_].Index == param1)
            {
               return this.FDateSigns[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public function GetCurSign() : TActivityDateSign
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc2_ = int(this.FDateSigns.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            if(this.FDateSigns[_loc1_].IsCur)
            {
               return this.FDateSigns[_loc1_];
            }
            _loc1_++;
         }
         return null;
      }
      
      public function GetIndexByUniqueIndex(param1:uint) : int
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         _loc3_ = int(this.FDateSigns.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(this.FDateSigns[_loc2_].Index == param1)
            {
               return _loc2_;
            }
            _loc2_++;
         }
         return -1;
      }
      
      public function SetCurSignByUniqueIndex(param1:uint) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         _loc3_ = int(this.FDateSigns.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(this.FDateSigns[_loc2_].Index == param1)
            {
               this.FDateSigns[_loc2_].IsCur = true;
            }
            else
            {
               this.FDateSigns[_loc2_].IsCur = false;
            }
            _loc2_++;
         }
      }
      
      public function SetSignStatusByUniqueIndex(param1:uint, param2:int) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _loc4_ = int(this.FDateSigns.length);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            if(this.FDateSigns[_loc3_].Index == param1)
            {
               this.FDateSigns[_loc3_].Status = param2;
               break;
            }
            _loc3_++;
         }
      }
   }
}

