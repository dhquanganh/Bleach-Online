package Logics.Home.HomeSoul
{
   import Logics.Inventories.TInventories;
   
   public class THomeSoul
   {
      
      protected var FMonsterID:uint;
      
      protected var FFixedIDVect:Vector.<uint>;
      
      protected var FFixedInventories:TInventories;
      
      protected var FAwardIDVect:Vector.<uint>;
      
      protected var FInventories:TInventories;
      
      protected var FRecommend:String;
      
      protected var FPrompt:String;
      
      public function THomeSoul()
      {
         super();
         this.FFixedIDVect = new Vector.<uint>();
         this.FFixedInventories = new TInventories();
         this.FAwardIDVect = new Vector.<uint>();
         this.FInventories = new TInventories();
         this.FRecommend = "";
         this.FPrompt = "";
      }
      
      public function get MonsterID() : uint
      {
         return this.FMonsterID;
      }
      
      public function set MonsterID(param1:uint) : void
      {
         this.FMonsterID = param1;
      }
      
      public function get AwardIDVect() : Vector.<uint>
      {
         return this.FAwardIDVect;
      }
      
      public function set AwardIDVect(param1:Vector.<uint>) : void
      {
         this.FAwardIDVect = param1;
      }
      
      public function get Recommend() : String
      {
         return this.FRecommend;
      }
      
      public function set Recommend(param1:String) : void
      {
         this.FRecommend = param1;
      }
      
      public function get Prompt() : String
      {
         return this.FPrompt;
      }
      
      public function set Prompt(param1:String) : void
      {
         this.FPrompt = param1;
      }
      
      public function get Inventories() : TInventories
      {
         return this.FInventories;
      }
      
      public function set Inventories(param1:TInventories) : void
      {
         this.FInventories = param1;
      }
      
      public function get FixedIDVect() : Vector.<uint>
      {
         return this.FFixedIDVect;
      }
      
      public function set FixedIDVect(param1:Vector.<uint>) : void
      {
         this.FFixedIDVect = param1;
      }
      
      public function get FixedInventories() : TInventories
      {
         return this.FFixedInventories;
      }
      
      public function set FixedInventories(param1:TInventories) : void
      {
         this.FFixedInventories = param1;
      }
   }
}

