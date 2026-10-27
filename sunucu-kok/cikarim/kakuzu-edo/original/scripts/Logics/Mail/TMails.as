package Logics.Mail
{
   import Foundation.Common.Integer.UInt64;
   
   public class TMails
   {
      
      protected var FMails:Vector.<TMail>;
      
      public function TMails()
      {
         super();
         this.FMails = new Vector.<TMail>();
      }
      
      protected function SortByIndex(param1:TMail, param2:TMail) : int
      {
         if(param1.CreatTime > param2.CreatTime)
         {
            return -1;
         }
         if(param1.CreatTime < param2.CreatTime)
         {
            return 1;
         }
         return 0;
      }
      
      protected function SortByRead(param1:TMail, param2:TMail) : int
      {
         if(param1.HasRead > param2.HasRead)
         {
            return 1;
         }
         if(param1.HasRead < param2.HasRead)
         {
            return -1;
         }
         return 0;
      }
      
      public function get Count() : int
      {
         return this.FMails.length;
      }
      
      public function GetMailByIndex(param1:int) : TMail
      {
         return this.FMails[param1];
      }
      
      public function GetMailByTypeBySortIndex(param1:uint, param2:UInt64) : TMail
      {
         var _loc3_:uint = 0;
         var _loc4_:TMail = null;
         _loc3_ = this.FMails.length;
         var _loc5_:int = 0;
         while(_loc5_ < _loc3_)
         {
            _loc4_ = this.FMails[_loc5_];
            if(_loc4_.Type == param1 && _loc4_.SortIndex.High == param2.High && _loc4_.SortIndex.Low == param2.Low)
            {
               break;
            }
            _loc5_++;
         }
         return _loc4_;
      }
      
      public function Clear() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TMail = null;
         _loc1_ = int(this.FMails.length);
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = this.FMails[_loc2_];
            _loc3_.StubReferences.Dereference(this);
            _loc2_++;
         }
         this.FMails.length = 0;
      }
      
      public function Add(param1:TMail) : void
      {
         param1.StubReferences.Reference(this);
         this.FMails.push(param1);
      }
      
      public function Delete(param1:TMail) : void
      {
         var _loc2_:int = 0;
         var _loc3_:TMail = null;
         _loc2_ = 0;
         while(_loc2_ < this.FMails.length)
         {
            _loc3_ = this.FMails[_loc2_];
            if(_loc3_ == param1)
            {
               param1.StubReferences.Dereference(this);
               this.FMails.splice(_loc2_,1);
               break;
            }
            _loc2_++;
         }
      }
      
      public function Sort() : void
      {
         this.FMails.sort(this.SortByIndex);
      }
      
      public function SortByIsRead() : void
      {
         this.FMails.sort(this.SortByRead);
      }
   }
}

