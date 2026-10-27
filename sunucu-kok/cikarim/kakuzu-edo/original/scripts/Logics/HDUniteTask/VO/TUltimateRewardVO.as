package Logics.HDUniteTask.VO
{
   import Logics.Inventories.TInventories;
   
   public class TUltimateRewardVO
   {
      
      public static const RewardType_Hero:uint = 0;
      
      public static const RewardType_Knife:uint = 1;
      
      public static const RewardType_Gifts:uint = 2;
      
      protected var FType:uint;
      
      protected var FInventories:TInventories;
      
      protected var FIsReceive:Boolean;
      
      protected var FReceiveEnabled:Boolean;
      
      protected var FQuality:int;
      
      protected var FName:String;
      
      protected var FMoudleID:uint;
      
      protected var FKnifeID:uint;
      
      public function TUltimateRewardVO()
      {
         super();
         this.FInventories = new TInventories();
      }
      
      public function get Type() : uint
      {
         return this.FType;
      }
      
      public function set Type(param1:uint) : void
      {
         this.FType = param1;
      }
      
      public function get Inventories() : TInventories
      {
         return this.FInventories;
      }
      
      public function set Inventories(param1:TInventories) : void
      {
         this.FInventories = param1;
      }
      
      public function get IsReceive() : Boolean
      {
         return this.FIsReceive;
      }
      
      public function set IsReceive(param1:Boolean) : void
      {
         this.FIsReceive = param1;
      }
      
      public function get ReceiveEnabled() : Boolean
      {
         return this.FReceiveEnabled;
      }
      
      public function set ReceiveEnabled(param1:Boolean) : void
      {
         this.FReceiveEnabled = param1;
      }
      
      public function get Quality() : int
      {
         return this.FQuality;
      }
      
      public function set Quality(param1:int) : void
      {
         this.FQuality = param1;
      }
      
      public function get Name() : String
      {
         return this.FName;
      }
      
      public function set Name(param1:String) : void
      {
         this.FName = param1;
      }
      
      public function get MoudleID() : uint
      {
         return this.FMoudleID;
      }
      
      public function set MoudleID(param1:uint) : void
      {
         this.FMoudleID = param1;
      }
      
      public function get KnifeID() : uint
      {
         return this.FKnifeID;
      }
      
      public function set KnifeID(param1:uint) : void
      {
         this.FKnifeID = param1;
      }
   }
}

