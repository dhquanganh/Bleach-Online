package Logics.Achievenment
{
   import Logics.Inventories.TInventories;
   
   public class TAchievementInfor
   {
      
      protected var FID:uint;
      
      protected var FFollowPic:uint;
      
      protected var FName:String;
      
      protected var FIfGotReward:Boolean;
      
      protected var FAchievementSchedules:Vector.<TAchievementSchedule>;
      
      protected var FIfComplete:Boolean;
      
      protected var FRewardString:String;
      
      protected var FRewardStringFormat:String;
      
      protected var FFlyText:String;
      
      protected var FRewards:TInventories;
      
      protected var FTitle:TTitle;
      
      protected var FIfNew:Boolean;
      
      protected var FIfFollow:Boolean;
      
      protected var FTotalSchedule:int;
      
      protected var FCurrentSchedule:int;
      
      protected var FAchievementGroupInfor:TAchievementGroupInfor;
      
      public function TAchievementInfor()
      {
         super();
         this.FAchievementSchedules = new Vector.<TAchievementSchedule>();
         this.FRewards = new TInventories();
      }
      
      public function get ID() : uint
      {
         return this.FID;
      }
      
      public function set ID(param1:uint) : void
      {
         this.FID = param1;
      }
      
      public function get IfComplete() : Boolean
      {
         return this.FIfComplete;
      }
      
      public function set IfComplete(param1:Boolean) : void
      {
         this.FIfComplete = param1;
      }
      
      public function get AchievementSchedules() : Vector.<TAchievementSchedule>
      {
         return this.FAchievementSchedules;
      }
      
      public function set AchievementSchedules(param1:Vector.<TAchievementSchedule>) : void
      {
         this.FAchievementSchedules = param1;
      }
      
      public function get IfGotReward() : Boolean
      {
         return this.FIfGotReward;
      }
      
      public function set IfGotReward(param1:Boolean) : void
      {
         this.FIfGotReward = param1;
      }
      
      public function get RewardString() : String
      {
         return this.FRewardString;
      }
      
      public function set RewardString(param1:String) : void
      {
         this.FRewardString = param1;
      }
      
      public function get RewardStringFormat() : String
      {
         return this.FRewardStringFormat;
      }
      
      public function set RewardStringFormat(param1:String) : void
      {
         this.FRewardStringFormat = param1;
      }
      
      public function get FlyText() : String
      {
         return this.FFlyText;
      }
      
      public function set FlyText(param1:String) : void
      {
         this.FFlyText = param1;
      }
      
      public function get IfNew() : Boolean
      {
         return this.FIfNew;
      }
      
      public function set IfNew(param1:Boolean) : void
      {
         this.FIfNew = param1;
      }
      
      public function get IfFollow() : Boolean
      {
         return this.FIfFollow;
      }
      
      public function set IfFollow(param1:Boolean) : void
      {
         this.FIfFollow = param1;
      }
      
      public function set AchievementGroupInfor(param1:TAchievementGroupInfor) : void
      {
         this.FAchievementGroupInfor = param1;
      }
      
      public function get AchievementGroupInfor() : TAchievementGroupInfor
      {
         return this.FAchievementGroupInfor;
      }
      
      public function get TotalSchedule() : int
      {
         return this.FTotalSchedule;
      }
      
      public function set TotalSchedule(param1:int) : void
      {
         this.FTotalSchedule = param1;
      }
      
      public function get CurrentSchedule() : int
      {
         return this.FCurrentSchedule;
      }
      
      public function set CurrentSchedule(param1:int) : void
      {
         this.FCurrentSchedule = param1;
      }
      
      public function get Name() : String
      {
         return this.FName;
      }
      
      public function set Name(param1:String) : void
      {
         this.FName = param1;
      }
      
      public function get Rewards() : TInventories
      {
         return this.FRewards;
      }
      
      public function get Title() : TTitle
      {
         return this.FTitle;
      }
      
      public function set Title(param1:TTitle) : void
      {
         this.FTitle = param1;
      }
      
      public function get FollowPic() : uint
      {
         return this.FFollowPic;
      }
      
      public function set FollowPic(param1:uint) : void
      {
         this.FFollowPic = param1;
      }
   }
}

