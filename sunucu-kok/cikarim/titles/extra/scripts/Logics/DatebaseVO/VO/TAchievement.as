package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.TDatebaseVO;
   import Logics.DatebaseVO.VO.Json.TAchievementCondition;
   import Logics.DatebaseVO.VO.Json.TRewards;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class TAchievement extends TDatebaseVO
   {
      
      protected var FName:String;
      
      protected var FFollowPic:uint;
      
      protected var FCondition:Vector.<TAchievementCondition>;
      
      protected var FConditonString:String;
      
      protected var FRewardString:String;
      
      protected var FRewards:TRewards;
      
      protected var FIfHaveTitle:int;
      
      protected var FTitleID:int;
      
      public function TAchievement()
      {
         super();
         this.FCondition = new Vector.<TAchievementCondition>();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         var _loc3_:String = null;
         var _loc4_:Array = null;
         var _loc5_:Array = null;
         var _loc6_:TAchievementCondition = null;
         this.FName = TUtilityString.FetchUTF(param1);
         this.FFollowPic = param1.readUnsignedInt();
         _loc3_ = TUtilityString.FetchUTF(param1);
         _loc4_ = Json.decode(_loc3_) as Array;
         this.FConditonString = TUtilityString.FetchUTF(param1);
         this.FRewardString = TUtilityString.FetchUTF(param1);
         _loc3_ = TUtilityString.FetchUTF(param1);
         this.FRewards = new TRewards(_loc3_);
         _loc3_ = TUtilityString.FetchUTF(param1);
         _loc5_ = Json.decode(_loc3_) as Array;
         _loc2_ = 0;
         while(_loc2_ < _loc4_.length)
         {
            _loc6_ = new TAchievementCondition(_loc4_[_loc2_]);
            _loc6_.NeedTimes = _loc5_[_loc2_];
            this.FCondition.push(_loc6_);
            _loc2_++;
         }
         this.FIfHaveTitle = param1.readInt();
         this.FTitleID = param1.readInt();
      }
      
      public function get IfHaveTitle() : int
      {
         return this.FIfHaveTitle;
      }
      
      public function get TitleID() : int
      {
         return this.FTitleID;
      }
      
      public function get Condition() : Vector.<TAchievementCondition>
      {
         return this.FCondition;
      }
      
      public function get ConditonString() : String
      {
         return this.FConditonString;
      }
      
      public function get RewardString() : String
      {
         return this.FRewardString;
      }
      
      public function get Rewards() : TRewards
      {
         return this.FRewards;
      }
      
      public function get Name() : String
      {
         return this.FName;
      }
      
      public function get FollowPic() : uint
      {
         return this.FFollowPic;
      }
   }
}

