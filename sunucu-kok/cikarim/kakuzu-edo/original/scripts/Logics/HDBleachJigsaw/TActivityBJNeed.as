package Logics.HDBleachJigsaw
{
   import Logics.HDActivityMode.TActivityEntity;
   
   public class TActivityBJNeed extends TActivityEntity
   {
      
      protected var FNeedNum:uint;
      
      protected var FAward:uint;
      
      protected var FBtnIndex:uint;
      
      protected var FPrompt:String;
      
      protected var FPrompt2:String;
      
      protected var FPrompt3:String;
      
      protected var FCost:uint;
      
      public function TActivityBJNeed(param1:uint)
      {
         super(param1);
      }
      
      public function get NeedNum() : uint
      {
         return this.FNeedNum;
      }
      
      public function set NeedNum(param1:uint) : void
      {
         this.FNeedNum = param1;
      }
      
      public function get Award() : uint
      {
         return this.FAward;
      }
      
      public function set Award(param1:uint) : void
      {
         this.FAward = param1;
      }
      
      public function get BtnIndex() : uint
      {
         return this.FBtnIndex;
      }
      
      public function set BtnIndex(param1:uint) : void
      {
         this.FBtnIndex = param1;
      }
      
      public function get Prompt() : String
      {
         return this.FPrompt;
      }
      
      public function set Prompt(param1:String) : void
      {
         this.FPrompt = param1;
      }
      
      public function get Cost() : uint
      {
         return this.FCost;
      }
      
      public function set Cost(param1:uint) : void
      {
         this.FCost = param1;
      }
      
      public function get Prompt2() : String
      {
         return this.FPrompt2;
      }
      
      public function set Prompt2(param1:String) : void
      {
         this.FPrompt2 = param1;
      }
      
      public function get Prompt3() : String
      {
         return this.FPrompt3;
      }
      
      public function set Prompt3(param1:String) : void
      {
         this.FPrompt3 = param1;
      }
   }
}

