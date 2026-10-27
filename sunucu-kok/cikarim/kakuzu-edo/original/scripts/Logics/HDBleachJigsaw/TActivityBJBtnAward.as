package Logics.HDBleachJigsaw
{
   import Logics.HDActivityMode.TActivityEntity;
   
   public class TActivityBJBtnAward extends TActivityEntity
   {
      
      protected var FCost:uint;
      
      protected var FAwards:Vector.<uint>;
      
      protected var FPrompt:String;
      
      protected var FPrompt2:String;
      
      public function TActivityBJBtnAward(param1:uint)
      {
         super(param1);
      }
      
      public function get Cost() : uint
      {
         return this.FCost;
      }
      
      public function set Cost(param1:uint) : void
      {
         this.FCost = param1;
      }
      
      public function get Awards() : Vector.<uint>
      {
         return this.FAwards;
      }
      
      public function set Awards(param1:Vector.<uint>) : void
      {
         this.FAwards = param1;
      }
      
      public function get Prompt() : String
      {
         return this.FPrompt;
      }
      
      public function set Prompt(param1:String) : void
      {
         this.FPrompt = param1;
      }
      
      public function get Prompt2() : String
      {
         return this.FPrompt2;
      }
      
      public function set Prompt2(param1:String) : void
      {
         this.FPrompt2 = param1;
      }
   }
}

