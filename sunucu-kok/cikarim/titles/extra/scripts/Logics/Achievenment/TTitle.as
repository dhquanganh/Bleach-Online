package Logics.Achievenment
{
   public class TTitle
   {
      
      protected var FID:uint;
      
      protected var FName:String;
      
      protected var FLevelTitle:int;
      
      protected var FIfAddAttribute:Boolean;
      
      protected var FTitleTypeGroup:int;
      
      protected var FIfTimeLimit:Boolean;
      
      protected var FTimeLimit:int;
      
      protected var FDepPosition:int;
      
      protected var FTitleAttributeType:Vector.<int>;
      
      protected var FTitleAttributeValue:Vector.<Number>;
      
      protected var FIfGetTitle:Boolean;
      
      protected var FAchievementInfor:TAchievementInfor;
      
      protected var FIfOverTime:Boolean;
      
      protected var FIfNew:Boolean;
      
      protected var FTargetTime:uint;
      
      public function TTitle()
      {
         super();
         this.FTitleAttributeType = new Vector.<int>();
         this.FTitleAttributeValue = new Vector.<Number>();
      }
      
      public function get ID() : uint
      {
         return this.FID;
      }
      
      public function set ID(param1:uint) : void
      {
         this.FID = param1;
      }
      
      public function get IfAddAttribute() : Boolean
      {
         return this.FIfAddAttribute;
      }
      
      public function set IfAddAttribute(param1:Boolean) : void
      {
         this.FIfAddAttribute = param1;
      }
      
      public function get IfTimeLimit() : Boolean
      {
         return this.FIfTimeLimit;
      }
      
      public function set IfTimeLimit(param1:Boolean) : void
      {
         this.FIfTimeLimit = param1;
      }
      
      public function get TimeLimit() : int
      {
         return this.FTimeLimit;
      }
      
      public function set TimeLimit(param1:int) : void
      {
         this.FTimeLimit = param1;
      }
      
      public function get DepPosition() : int
      {
         return this.FDepPosition;
      }
      
      public function set DepPosition(param1:int) : void
      {
         this.FDepPosition = param1;
      }
      
      public function get TitleAttributeType() : Vector.<int>
      {
         return this.FTitleAttributeType;
      }
      
      public function set TitleAttributeType(param1:Vector.<int>) : void
      {
         this.FTitleAttributeType = param1;
      }
      
      public function get TitleAttributeValue() : Vector.<Number>
      {
         return this.FTitleAttributeValue;
      }
      
      public function set TitleAttributeValue(param1:Vector.<Number>) : void
      {
         this.FTitleAttributeValue = param1;
      }
      
      public function get AchievementInfor() : TAchievementInfor
      {
         return this.FAchievementInfor;
      }
      
      public function set AchievementInfor(param1:TAchievementInfor) : void
      {
         this.FAchievementInfor = param1;
      }
      
      public function get IfGetTitle() : Boolean
      {
         return this.FIfGetTitle;
      }
      
      public function set IfGetTitle(param1:Boolean) : void
      {
         this.FIfGetTitle = param1;
      }
      
      public function get Name() : String
      {
         return this.FName;
      }
      
      public function set Name(param1:String) : void
      {
         this.FName = param1;
      }
      
      public function get IfOverTime() : Boolean
      {
         return this.FIfOverTime;
      }
      
      public function set IfOverTime(param1:Boolean) : void
      {
         this.FIfOverTime = param1;
      }
      
      public function get IfNew() : Boolean
      {
         return this.FIfNew;
      }
      
      public function set IfNew(param1:Boolean) : void
      {
         this.FIfNew = param1;
      }
      
      public function get TitleTypeGroup() : int
      {
         return this.FTitleTypeGroup;
      }
      
      public function set TitleTypeGroup(param1:int) : void
      {
         this.FTitleTypeGroup = param1;
      }
      
      public function get LevelTitle() : int
      {
         return this.FLevelTitle;
      }
      
      public function set LevelTitle(param1:int) : void
      {
         this.FLevelTitle = param1;
      }
      
      public function get TargetTime() : uint
      {
         return this.FTargetTime;
      }
      
      public function set TargetTime(param1:uint) : void
      {
         this.FTargetTime = param1;
      }
   }
}

