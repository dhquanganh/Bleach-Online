package Logics.HDActivitySoulBox
{
   import Logics.HDActivityMode.TActivityEntity;
   import Resources.Constants.CONST_ACTIVITY_MODE;
   
   public class TActivityMoneyPennyBox extends TActivityEntity
   {
      
      protected var FGetType:uint;
      
      protected var FLimit:uint;
      
      protected var FStatus:int;
      
      protected var FExcharged:uint;
      
      protected var FReturn:uint;
      
      public function TActivityMoneyPennyBox(param1:uint)
      {
         super(param1);
         this.FStatus = CONST_ACTIVITY_MODE.Activity_CanNotReceive;
         this.FExcharged = 0;
         this.FReturn = 0;
      }
      
      public function get GetType() : uint
      {
         return this.FGetType;
      }
      
      public function set GetType(param1:uint) : void
      {
         this.FGetType = param1;
      }
      
      public function get Limit() : uint
      {
         return this.FLimit;
      }
      
      public function set Limit(param1:uint) : void
      {
         this.FLimit = param1;
      }
      
      public function get Status() : int
      {
         return this.FStatus;
      }
      
      public function set Status(param1:int) : void
      {
         this.FStatus = param1;
      }
      
      public function get Excharged() : uint
      {
         return this.FExcharged;
      }
      
      public function set Excharged(param1:uint) : void
      {
         this.FExcharged = param1;
      }
      
      public function get Return() : uint
      {
         return this.FReturn;
      }
      
      public function set Return(param1:uint) : void
      {
         this.FReturn = param1;
      }
   }
}

