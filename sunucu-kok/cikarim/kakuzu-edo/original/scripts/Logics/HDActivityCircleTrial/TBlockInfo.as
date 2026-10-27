package Logics.HDActivityCircleTrial
{
   public class TBlockInfo
   {
      
      protected var FBlockType:int;
      
      protected var FBlockName:String;
      
      protected var FBlockScore:int;
      
      protected var FBlockPassTimes:int;
      
      protected var FIndex:int;
      
      public function TBlockInfo()
      {
         super();
      }
      
      public function get BlockType() : int
      {
         return this.FBlockType;
      }
      
      public function set BlockType(param1:int) : void
      {
         this.FBlockType = param1;
      }
      
      public function get BlockName() : String
      {
         return this.FBlockName;
      }
      
      public function set BlockName(param1:String) : void
      {
         this.FBlockName = param1;
      }
      
      public function get BlockScore() : int
      {
         return this.FBlockScore;
      }
      
      public function set BlockScore(param1:int) : void
      {
         this.FBlockScore = param1;
      }
      
      public function get BlockPassTimes() : int
      {
         return this.FBlockPassTimes;
      }
      
      public function set BlockPassTimes(param1:int) : void
      {
         this.FBlockPassTimes = param1;
      }
      
      public function get Index() : int
      {
         return this.FIndex;
      }
      
      public function set Index(param1:int) : void
      {
         this.FIndex = param1;
      }
   }
}

