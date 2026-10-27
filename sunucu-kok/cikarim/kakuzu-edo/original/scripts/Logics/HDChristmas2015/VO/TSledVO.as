package Logics.HDChristmas2015.VO
{
   public class TSledVO
   {
      
      protected var FName:String;
      
      protected var FHighID:uint;
      
      protected var FLowID:uint;
      
      protected var FStartTime:uint;
      
      protected var FIsRobbed:Boolean;
      
      protected var FType:uint;
      
      protected var FTypeIndex:uint;
      
      public function TSledVO()
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
      
      public function get HighID() : uint
      {
         return this.FHighID;
      }
      
      public function set HighID(param1:uint) : void
      {
         this.FHighID = param1;
      }
      
      public function get LowID() : uint
      {
         return this.FLowID;
      }
      
      public function set LowID(param1:uint) : void
      {
         this.FLowID = param1;
      }
      
      public function get StartTime() : uint
      {
         return this.FStartTime;
      }
      
      public function set StartTime(param1:uint) : void
      {
         this.FStartTime = param1;
      }
      
      public function get IsRobbed() : Boolean
      {
         return this.FIsRobbed;
      }
      
      public function set IsRobbed(param1:Boolean) : void
      {
         this.FIsRobbed = param1;
      }
      
      public function get TypeIndex() : uint
      {
         return this.FTypeIndex;
      }
      
      public function set TypeIndex(param1:uint) : void
      {
         this.FTypeIndex = param1;
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

