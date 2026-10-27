package Logics.HDIceHeros
{
   import Logics.HDActivityMode.TActivityEntity;
   import Logics.Inventories.TInventories;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   
   public class TActivityIHChipBox extends TActivityEntity
   {
      
      protected var FCost:uint;
      
      protected var FAwards:uint;
      
      protected var FPrompts:Vector.<String>;
      
      protected var FStatus:int;
      
      protected var FName:String;
      
      protected var FInventories:TInventories;
      
      public function TActivityIHChipBox(param1:uint)
      {
         super(param1);
         this.FPrompts = new Vector.<String>();
         this.FInventories = new TInventories();
      }
      
      public function ConstructInventoies() : void
      {
         SToolReward.GetAwardsByAwardID(this.FAwards,this.FInventories,true);
      }
      
      public function get Cost() : uint
      {
         return this.FCost;
      }
      
      public function set Cost(param1:uint) : void
      {
         this.FCost = param1;
      }
      
      public function get Awards() : uint
      {
         return this.FAwards;
      }
      
      public function set Awards(param1:uint) : void
      {
         this.FAwards = param1;
      }
      
      public function get Status() : int
      {
         return this.FStatus;
      }
      
      public function set Status(param1:int) : void
      {
         this.FStatus = param1;
      }
      
      public function get Prompts() : Vector.<String>
      {
         return this.FPrompts;
      }
      
      public function set Prompts(param1:Vector.<String>) : void
      {
         this.FPrompts = param1;
      }
      
      public function get Name() : String
      {
         return this.FName;
      }
      
      public function set Name(param1:String) : void
      {
         this.FName = param1;
      }
      
      public function get Inventories() : TInventories
      {
         return this.FInventories;
      }
   }
}

