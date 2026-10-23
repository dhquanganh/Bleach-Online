package Logics.KingChallenge
{
   public class TUserBaseInfo
   {
      
      protected var FGroup:uint;
      
      protected var FPermission:Boolean;
      
      protected var FRank:uint;
      
      protected var FAwardStatus:int;
      
      public function TUserBaseInfo()
      {
         super();
      }
      
      public function get Group() : uint
      {
         return this.FGroup;
      }
      
      public function set Group(param1:uint) : void
      {
         this.FGroup = param1;
      }
      
      public function get Permission() : Boolean
      {
         return this.FPermission;
      }
      
      public function set Permission(param1:Boolean) : void
      {
         this.FPermission = param1;
      }
      
      public function get Rank() : uint
      {
         return this.FRank;
      }
      
      public function set Rank(param1:uint) : void
      {
         this.FRank = param1;
      }
      
      public function get AwardStatus() : int
      {
         return this.FAwardStatus;
      }
      
      public function set AwardStatus(param1:int) : void
      {
         this.FAwardStatus = param1;
      }
   }
}

