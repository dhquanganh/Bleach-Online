package Logics.HDUniteTask.VO
{
   import Logics.Inventories.TInventories;
   
   public class TUniteTaskTaskVO
   {
      
      protected var FDescName:String;
      
      protected var FDescAddReward:String;
      
      protected var FDescProgKey:String;
      
      protected var FDescProgValue:String;
      
      protected var FLink:uint;
      
      protected var FInventories:TInventories;
      
      protected var FIsFinish:Boolean;
      
      protected var FIsReceive:Boolean;
      
      protected var FAwardBtnEnabled:Boolean;
      
      public function TUniteTaskTaskVO()
      {
         super();
         this.FInventories = new TInventories();
      }
      
      public function get DescName() : String
      {
         return this.FDescName;
      }
      
      public function set DescName(param1:String) : void
      {
         this.FDescName = param1;
      }
      
      public function get DescAddReward() : String
      {
         return this.FDescAddReward;
      }
      
      public function set DescAddReward(param1:String) : void
      {
         this.FDescAddReward = param1;
      }
      
      public function get DescProgKey() : String
      {
         return this.FDescProgKey;
      }
      
      public function set DescProgKey(param1:String) : void
      {
         this.FDescProgKey = param1;
      }
      
      public function get DescProgValue() : String
      {
         return this.FDescProgValue;
      }
      
      public function set DescProgValue(param1:String) : void
      {
         this.FDescProgValue = param1;
      }
      
      public function get Link() : uint
      {
         return this.FLink;
      }
      
      public function set Link(param1:uint) : void
      {
         this.FLink = param1;
      }
      
      public function get Inventories() : TInventories
      {
         return this.FInventories;
      }
      
      public function set Inventories(param1:TInventories) : void
      {
         this.FInventories = param1;
      }
      
      public function get IsFinish() : Boolean
      {
         return this.FIsFinish;
      }
      
      public function set IsFinish(param1:Boolean) : void
      {
         this.FIsFinish = param1;
      }
      
      public function get IsReceive() : Boolean
      {
         return this.FIsReceive;
      }
      
      public function set IsReceive(param1:Boolean) : void
      {
         this.FIsReceive = param1;
      }
      
      public function get AwardBtnEnabled() : Boolean
      {
         return this.FAwardBtnEnabled;
      }
      
      public function set AwardBtnEnabled(param1:Boolean) : void
      {
         this.FAwardBtnEnabled = param1;
      }
   }
}

