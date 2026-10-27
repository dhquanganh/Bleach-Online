package Logics.Organization
{
   public class TBaseOrganiztionList
   {
      
      protected var FOrgID:uint;
      
      protected var FOrgName:String;
      
      protected var FOrgLevel:uint;
      
      protected var FOrgMasterName:String;
      
      protected var FOrgMembersCount:uint;
      
      protected var FOrgFamily:uint;
      
      protected var FOrgIsApply:Boolean;
      
      protected var FOrgMaxMemberCount:uint;
      
      protected var FScore:int;
      
      public function TBaseOrganiztionList()
      {
         super();
      }
      
      public function get OrgID() : uint
      {
         return this.FOrgID;
      }
      
      public function set OrgID(param1:uint) : void
      {
         this.FOrgID = param1;
      }
      
      public function get OrgName() : String
      {
         return this.FOrgName;
      }
      
      public function set OrgName(param1:String) : void
      {
         this.FOrgName = param1;
      }
      
      public function get OrgLevel() : uint
      {
         return this.FOrgLevel;
      }
      
      public function set OrgLevel(param1:uint) : void
      {
         this.FOrgLevel = param1;
      }
      
      public function get OrgMembersCount() : uint
      {
         return this.FOrgMembersCount;
      }
      
      public function set OrgMembersCount(param1:uint) : void
      {
         this.FOrgMembersCount = param1;
      }
      
      public function get OrgIsApply() : Boolean
      {
         return this.FOrgIsApply;
      }
      
      public function set OrgIsApply(param1:Boolean) : void
      {
         this.FOrgIsApply = param1;
      }
      
      public function get OrgMasterName() : String
      {
         return this.FOrgMasterName;
      }
      
      public function set OrgMasterName(param1:String) : void
      {
         this.FOrgMasterName = param1;
      }
      
      public function get OrgFamily() : uint
      {
         return this.FOrgFamily;
      }
      
      public function set OrgFamily(param1:uint) : void
      {
         this.FOrgFamily = param1;
      }
      
      public function get OrgMaxMemberCount() : uint
      {
         return this.FOrgMaxMemberCount;
      }
      
      public function set OrgMaxMemberCount(param1:uint) : void
      {
         this.FOrgMaxMemberCount = param1;
      }
      
      public function get Score() : int
      {
         return this.FScore;
      }
      
      public function set Score(param1:int) : void
      {
         this.FScore = param1;
      }
   }
}

