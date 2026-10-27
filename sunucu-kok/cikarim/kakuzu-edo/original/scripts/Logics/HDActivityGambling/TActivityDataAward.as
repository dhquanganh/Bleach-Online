package Logics.HDActivityGambling
{
   import Logics.HDActivityMode.TActivityEntity;
   
   public class TActivityDataAward extends TActivityEntity
   {
      
      protected static const COUNT_AwardsLength:uint = 1;
      
      protected var FAwards:Vector.<uint>;
      
      protected var FCondition:uint;
      
      protected var FPrompt:String;
      
      protected var FStatus:int;
      
      public function TActivityDataAward(param1:uint)
      {
         super(param1);
         this.FAwards = new Vector.<uint>(COUNT_AwardsLength);
      }
      
      public function get Awards() : Vector.<uint>
      {
         return this.FAwards;
      }
      
      public function set Awards(param1:Vector.<uint>) : void
      {
         this.FAwards = param1;
      }
      
      public function get Condition() : uint
      {
         return this.FCondition;
      }
      
      public function set Condition(param1:uint) : void
      {
         this.FCondition = param1;
      }
      
      public function get Prompt() : String
      {
         return this.FPrompt;
      }
      
      public function set Prompt(param1:String) : void
      {
         this.FPrompt = param1;
      }
      
      public function get Status() : int
      {
         return this.FStatus;
      }
      
      public function set Status(param1:int) : void
      {
         this.FStatus = param1;
      }
   }
}

