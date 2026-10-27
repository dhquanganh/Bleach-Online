package Logics.Organization.VO
{
   public class TOrgDistRecordBarVO
   {
      
      protected var FName:String;
      
      protected var FTime:String;
      
      protected var FCode:uint;
      
      protected var FCount:uint;
      
      protected var FType:uint;
      
      public function TOrgDistRecordBarVO()
      {
         super();
      }
      
      public function get Name() : String
      {
         return this.FName;
      }
      
      public function set Name(param1:String) : void
      {
         this.FName = param1;
      }
      
      public function get Time() : String
      {
         return this.FTime;
      }
      
      public function set Time(param1:String) : void
      {
         this.FTime = param1;
      }
      
      public function get Code() : uint
      {
         return this.FCode;
      }
      
      public function set Code(param1:uint) : void
      {
         this.FCode = param1;
      }
      
      public function get Count() : uint
      {
         return this.FCount;
      }
      
      public function set Count(param1:uint) : void
      {
         this.FCount = param1;
      }
      
      public function get Type() : uint
      {
         return this.FType;
      }
      
      public function set Type(param1:uint) : void
      {
         this.FType = param1;
      }
   }
}

