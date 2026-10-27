package Foundation.DataProtected
{
   import Foundation.Crypto.*;
   import flash.utils.*;
   
   public class TDataProtected
   {
      
      protected var FTrueValue:Object;
      
      protected var FPseudoValue:Object;
      
      protected var FOnErrorHandler:Function;
      
      public function TDataProtected()
      {
         super();
         this.FPseudoValue = new Object();
         this.FTrueValue = new Object();
      }
      
      protected function Equal(param1:*, param2:*) : Boolean
      {
         var _loc3_:ByteArray = null;
         var _loc4_:ByteArray = null;
         _loc3_ = new ByteArray();
         _loc3_.writeObject(param1);
         _loc3_.position = 0;
         _loc4_ = new ByteArray();
         _loc4_.writeObject(param2);
         _loc4_.position = 0;
         if(_loc3_.length == _loc4_.length)
         {
            while(_loc3_.bytesAvailable)
            {
               if(_loc3_.readByte() != _loc4_.readByte())
               {
                  return false;
               }
            }
            return true;
         }
         return false;
      }
      
      protected function DefaultErrorOnHandler() : void
      {
         if(this.FOnErrorHandler != null)
         {
            this.FOnErrorHandler(this);
         }
         throw new Error("数据验证失败！");
      }
      
      public function get OnErrorHandler() : Function
      {
         return this.FOnErrorHandler;
      }
      
      public function set OnErrorHandler(param1:Function) : void
      {
         this.FOnErrorHandler = param1;
      }
      
      public function GetProperty(param1:*) : *
      {
         var _loc2_:* = undefined;
         _loc2_ = TAES.Decrypt(this.FTrueValue[param1]);
         if(_loc2_ is int || _loc2_ is uint || _loc2_ is Number || _loc2_ is String)
         {
            if(_loc2_ != this.FPseudoValue[param1])
            {
               this.DefaultErrorOnHandler();
            }
         }
         else if(!this.Equal(_loc2_,this.FPseudoValue[param1]))
         {
            this.DefaultErrorOnHandler();
         }
         return _loc2_;
      }
      
      public function SetProperty(param1:*, param2:*) : void
      {
         var _loc3_:ByteArray = null;
         if(param2 is int || param2 is uint || param2 is Number || param2 is String)
         {
            this.FPseudoValue[param1] = param2;
         }
         else
         {
            _loc3_ = new ByteArray();
            _loc3_.writeObject(param2);
            _loc3_.position = 0;
            this.FPseudoValue[param1] = _loc3_.readObject();
         }
         this.FTrueValue[param1] = TAES.Encrypt(param2);
      }
   }
}

