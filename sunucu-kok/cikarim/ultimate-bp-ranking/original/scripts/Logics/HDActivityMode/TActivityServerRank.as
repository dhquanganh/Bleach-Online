package Logics.HDActivityMode
{
   public class TActivityServerRank
   {
      
      protected var FHighID:uint;
      
      protected var FLowID:uint;
      
      protected var FName:String;
      
      protected var FServerID:uint;
      
      protected var FValue:uint;
      
      protected var FRank:uint;
      
      public function TActivityServerRank(param1:uint, param2:uint, param3:uint, param4:Object)
      {
         super();
         this.FHighID = param1;
         this.FLowID = param2;
         this.FRank = param3 + 1;
         if(param4[0].name)
         {
            this.FName = param4[0].name;
         }
         if(param4[0].serverID)
         {
            this.FServerID = param4[0].serverID;
         }
         if(param4[0].value)
         {
            this.FValue = param4[0].value;
         }
      }
      
      public function get HighID() : uint
      {
         return this.FHighID;
      }
      
      public function get LowID() : uint
      {
         return this.FLowID;
      }
      
      public function get Name() : String
      {
         return this.FName;
      }
      
      public function get ServerID() : uint
      {
         return this.FServerID;
      }
      
      public function get Value() : uint
      {
         return this.FValue;
      }
      
      public function get Rank() : uint
      {
         return this.FRank;
      }
   }
}

