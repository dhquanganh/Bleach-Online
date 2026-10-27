package Logics.HDNewYearSheep.PetYearVO
{
   import Resources.Constants.CONST_ACTIVITY_MODE;
   
   public class TPetYearVicePetVO
   {
      
      protected var FNextRankInfo:String;
      
      protected var FLevel:String;
      
      protected var FName:String;
      
      protected var FResourceID:int;
      
      protected var FState:int;
      
      protected var FIsExist:Boolean;
      
      protected var FCurRank:int;
      
      public function TPetYearVicePetVO()
      {
         super();
         this.FState = CONST_ACTIVITY_MODE.Activity_CanReceive;
         this.FIsExist = true;
      }
      
      public function get NextRankInfo() : String
      {
         return this.FNextRankInfo;
      }
      
      public function set NextRankInfo(param1:String) : void
      {
         this.FNextRankInfo = param1;
      }
      
      public function get Level() : String
      {
         return this.FLevel;
      }
      
      public function set Level(param1:String) : void
      {
         this.FLevel = param1;
      }
      
      public function get Name() : String
      {
         return this.FName;
      }
      
      public function set Name(param1:String) : void
      {
         this.FName = param1;
      }
      
      public function get ResourceID() : int
      {
         return this.FResourceID;
      }
      
      public function set ResourceID(param1:int) : void
      {
         this.FResourceID = param1;
      }
      
      public function get State() : int
      {
         return this.FState;
      }
      
      public function set State(param1:int) : void
      {
         this.FState = param1;
      }
      
      public function get CurRank() : int
      {
         return this.FCurRank;
      }
      
      public function set CurRank(param1:int) : void
      {
         this.FCurRank = param1;
      }
      
      public function get IsExist() : Boolean
      {
         return this.FIsExist;
      }
      
      public function set IsExist(param1:Boolean) : void
      {
         this.FIsExist = param1;
      }
   }
}

