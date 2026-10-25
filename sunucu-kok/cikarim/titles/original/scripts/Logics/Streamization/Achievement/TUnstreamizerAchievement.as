package Logics.Streamization.Achievement
{
   import Foundation.Resources.Bins.TBins;
   import Foundation.Resources.SResourcesCore;
   import Foundation.Streamization.TUnstreamizer;
   import Foundation.Utilities.TUtilityString;
   import Logics.Achievenment.TAchievementClassInfor;
   import Logics.Achievenment.TAchievementGroupInfor;
   import Logics.Achievenment.TAchievementInfor;
   import Logics.Achievenment.TAchievementInfors;
   import Logics.Achievenment.TAchievementSchedule;
   import Logics.Achievenment.TTitle;
   import Logics.Achievenment.TTitles;
   import Logics.DatebaseVO.VO.TAchievement;
   import Logics.DatebaseVO.VO.TAchievementClass;
   import Logics.DatebaseVO.VO.TAchievementGroup;
   import Logics.DatebaseVO.VO.TAchievementTitle;
   import Logics.DatebaseVO.VO.TArticle;
   import Logics.Streamization.Inventories.TUnstreamizerInventoryReference;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Resources.Constants.CONST_COMMON;
   import Resources.Constants.CONST_DATEBASEVO;
   import flash.utils.ByteArray;
   
   public class TUnstreamizerAchievement extends TUnstreamizer
   {
      
      protected var FIDTemplates:Vector.<uint>;
      
      protected var FUnstreamizerInventoryReference:TUnstreamizerInventoryReference;
      
      public function TUnstreamizerAchievement()
      {
         super();
         this.FIDTemplates = new Vector.<uint>();
         this.FUnstreamizerInventoryReference = new TUnstreamizerInventoryReference();
      }
      
      override protected function UnstreamizationPerform(param1:ByteArray, param2:Object, param3:Object) : void
      {
      }
      
      protected function UnstreamizationByDataBase_Perform(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:TAchievementInfors = null;
         var _loc5_:TAchievementInfor = null;
         var _loc6_:TAchievement = null;
         var _loc7_:TBins = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         _loc7_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_Achievement);
         _loc4_ = param2 as TAchievementInfors;
         _loc9_ = _loc7_.Count;
         _loc8_ = 0;
         while(_loc8_ < _loc9_)
         {
            _loc6_ = _loc7_.GetDatebaseByIndex(_loc8_) as TAchievement;
            _loc5_ = new TAchievementInfor();
            _loc5_.ID = _loc6_.Identifier;
            _loc5_.FollowPic = _loc6_.FollowPic;
            _loc5_.IfComplete = false;
            _loc5_.Name = _loc6_.Name;
            _loc5_.RewardStringFormat = _loc6_.RewardString;
            _loc5_.RewardString = this.GetRewardDescription(_loc6_);
            _loc5_.FlyText = this.GetFlyText(_loc6_);
            this.FlushAchievementCondition(_loc5_,_loc6_);
            this.FlushAchievementReward(_loc5_,_loc6_);
            this.CreateTitleByAchievment(_loc5_,_loc6_);
            _loc4_.Add(_loc5_);
            _loc8_++;
         }
      }
      
      protected function UnstreamizationDirectory_Perform(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TAchievementInfors = null;
         var _loc7_:TBins = null;
         var _loc8_:TAchievementClassInfor = null;
         var _loc9_:Vector.<TAchievementClassInfor> = null;
         var _loc10_:TAchievementClass = null;
         _loc6_ = param2 as TAchievementInfors;
         _loc9_ = param3 as Vector.<TAchievementClassInfor>;
         _loc7_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_AchievementClass);
         _loc4_ = 0;
         while(_loc4_ < _loc7_.Count)
         {
            _loc8_ = new TAchievementClassInfor();
            _loc10_ = _loc7_.GetDatebaseByIndex(_loc4_) as TAchievementClass;
            _loc8_.AchievementClassName = _loc10_.Name;
            this.FlushAchievementGroupToClass(_loc8_,_loc10_,_loc6_);
            _loc9_.push(_loc8_);
            _loc4_++;
         }
      }
      
      protected function UnstreamizationAchievementTitle_Perform(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:Vector.<TTitles> = null;
         var _loc5_:TTitles = null;
         var _loc6_:TTitle = null;
         var _loc7_:Vector.<TAchievementClassInfor> = null;
         var _loc8_:TAchievementClassInfor = null;
         var _loc9_:TAchievementGroupInfor = null;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         _loc4_ = param2 as Vector.<TTitles>;
         _loc7_ = param3 as Vector.<TAchievementClassInfor>;
         _loc11_ = int(_loc7_.length);
         _loc10_ = 0;
         while(_loc10_ < _loc11_)
         {
            _loc8_ = _loc7_[_loc10_];
            _loc5_ = new TTitles();
            _loc13_ = int(_loc8_.AchivementGroups.length);
            _loc12_ = 0;
            while(_loc12_ < _loc13_)
            {
               _loc9_ = _loc8_.AchivementGroups[_loc12_];
               this.FlushTitleToVec(_loc9_,_loc5_);
               _loc12_++;
            }
            _loc4_.push(_loc5_);
            _loc10_++;
         }
      }
      
      protected function FlushTitleToVec(param1:TAchievementGroupInfor, param2:TTitles) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:TAchievementInfor = null;
         _loc4_ = param1.AchievementInfors.Count;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc5_ = param1.AchievementInfors.GetAchievementByIndex(_loc3_);
            if(_loc5_.Title != null)
            {
               param2.Add(_loc5_.Title);
            }
            _loc3_++;
         }
      }
      
      protected function CreateTitleByAchievment(param1:TAchievementInfor, param2:TAchievement) : void
      {
         var _loc3_:TTitle = null;
         var _loc4_:TAchievementTitle = null;
         var _loc5_:int = 0;
         if(param2.TitleID != 0)
         {
            _loc4_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_AchievementTitle,param2.TitleID) as TAchievementTitle;
            _loc3_ = new TTitle();
            _loc3_.ID = _loc4_.Identifier;
            _loc3_.Name = _loc4_.Name;
            _loc3_.LevelTitle = _loc4_.LevelTitle;
            _loc3_.TitleTypeGroup = _loc4_.TitleTypeGroup;
            _loc3_.IfAddAttribute = _loc4_.NotOrProp == 1;
            _loc3_.IfTimeLimit = _loc4_.TimeLimitNot == 1;
            _loc3_.TimeLimit = _loc4_.ValTimeLimit;
            _loc3_.DepPosition = _loc4_.FormationType;
            _loc3_.AchievementInfor = param1;
            _loc5_ = 0;
            while(_loc5_ < _loc4_.AddOtherArray.length)
            {
               _loc3_.TitleAttributeType.push(_loc4_.AddOtherArray[_loc5_].Type);
               _loc3_.TitleAttributeValue.push(Number(_loc4_.AddOtherArray[_loc5_].Value));
               _loc5_++;
            }
            param1.Title = _loc3_;
         }
      }
      
      protected function FlushAchievementGroupToClass(param1:TAchievementClassInfor, param2:TAchievementClass, param3:TAchievementInfors) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TAchievementGroupInfor = null;
         var _loc7_:TAchievementGroup = null;
         var _loc8_:TBins = null;
         _loc8_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_AchievementGroup);
         _loc4_ = 0;
         while(_loc4_ < param2.AchievementGroupsID.length)
         {
            _loc6_ = new TAchievementGroupInfor();
            _loc6_.AchievementClassInfor = param1;
            _loc7_ = _loc8_.GetDatebaseByIdentifier(param2.AchievementGroupsID[_loc4_]) as TAchievementGroup;
            _loc6_.GroupName = _loc7_.Name;
            _loc6_.TotalSchedule = _loc7_.AchievementsID.length;
            this.FlushAchievementToGroup(_loc6_,_loc7_,param3);
            param1.AchivementGroups.push(_loc6_);
            param1.TotalSchedule += _loc7_.AchievementsID.length;
            _loc4_++;
         }
      }
      
      protected function FlushAchievementToGroup(param1:TAchievementGroupInfor, param2:TAchievementGroup, param3:TAchievementInfors) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TAchievementInfor = null;
         var _loc7_:uint = 0;
         _loc4_ = 0;
         while(_loc4_ < param2.AchievementsID.length)
         {
            _loc7_ = param2.AchievementsID[_loc4_];
            _loc6_ = param3.GetAchievementByID(_loc7_);
            _loc6_.AchievementGroupInfor = param1;
            param1.AchievementInfors.Add(_loc6_);
            _loc4_++;
         }
      }
      
      protected function GetFlyText(param1:TAchievement) : String
      {
         var _loc2_:String = null;
         var _loc3_:int = 0;
         var _loc4_:TArticle = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         _loc5_ = "";
         _loc3_ = 0;
         while(_loc3_ < param1.Rewards.Count)
         {
            _loc4_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_Article,param1.Rewards.Code[_loc3_]) as TArticle;
            if(_loc4_ == null)
            {
               _loc6_ = TUtilityLobby.GetItemName(param1.Rewards.Type[_loc3_],param1.Rewards.Code[_loc3_]);
            }
            else
            {
               _loc6_ = _loc4_.Name;
            }
            _loc5_ += _loc6_ + "*" + param1.Rewards.Amount[_loc3_] + "\n";
            _loc3_++;
         }
         return _loc5_;
      }
      
      protected function GetRewardDescription(param1:TAchievement) : String
      {
         var _loc2_:String = null;
         var _loc3_:int = 0;
         var _loc4_:TArticle = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         _loc2_ = param1.RewardString;
         _loc5_ = "";
         _loc3_ = 0;
         while(_loc3_ < param1.Rewards.Count)
         {
            _loc4_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_Article,param1.Rewards.Code[_loc3_]) as TArticle;
            if(_loc4_ == null)
            {
               _loc6_ = TUtilityLobby.GetItemName(param1.Rewards.Type[_loc3_],param1.Rewards.Code[_loc3_]);
               _loc7_ = CONST_COMMON.HTMLCOLOR_Green;
            }
            else
            {
               _loc6_ = _loc4_.Name;
               _loc7_ = CONST_COMMON.TextColor[_loc4_.Quality];
            }
            _loc5_ += TUtilityString.Format("<font color=\'%0\'>%1 * %2</font>\n",_loc7_,_loc6_,param1.Rewards.Amount[_loc3_]);
            _loc3_++;
         }
         return _loc5_;
      }
      
      protected function FlushAchievementReward(param1:TAchievementInfor, param2:TAchievement) : void
      {
         var _loc3_:int = 0;
         var _loc4_:uint = 0;
         var _loc5_:int = 0;
         _loc5_ = int(param2.Rewards.Count);
         this.FIDTemplates.length = 0;
         _loc3_ = 0;
         while(_loc3_ < _loc5_)
         {
            _loc4_ = CONST_COMMON.RewardIDToTemplateID(param2.Rewards.Type[_loc3_],param2.Rewards.Code[_loc3_]);
            this.FIDTemplates.push(_loc4_);
            _loc3_++;
         }
         this.FUnstreamizerInventoryReference.UnstreamizeGenerateInventoriesByIdentifiers(null,param1.Rewards,this.FIDTemplates);
         _loc3_ = 0;
         while(_loc3_ < _loc5_)
         {
            param1.Rewards.GetInventoryByIndex(_loc3_).Quantity = param2.Rewards.Amount[_loc3_];
            _loc3_++;
         }
      }
      
      protected function FlushAchievementCondition(param1:TAchievementInfor, param2:TAchievement) : void
      {
         var _loc3_:int = 0;
         var _loc4_:Array = null;
         var _loc5_:TAchievementSchedule = null;
         var _loc6_:int = 0;
         _loc4_ = param2.ConditonString.split("#");
         _loc6_ = 0;
         _loc3_ = 0;
         while(_loc3_ < param2.Condition.length)
         {
            _loc5_ = new TAchievementSchedule();
            _loc5_.Type = param2.Condition[_loc3_].Type;
            _loc5_.CurrentSchedule = 0;
            _loc5_.Value = param2.Condition[_loc3_].NeedTimes;
            _loc6_ += _loc5_.Value;
            if(_loc4_.length > _loc3_)
            {
               _loc5_.ConditionStrings = _loc4_[_loc3_];
            }
            param1.AchievementSchedules[_loc3_] = _loc5_;
            _loc3_++;
         }
         param1.TotalSchedule = _loc6_;
      }
      
      protected function UnstreamizationServerInfor_Perform(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         var _loc10_:uint = 0;
         var _loc11_:uint = 0;
         var _loc12_:TAchievementInfor = null;
         var _loc13_:TAchievementInfors = null;
         var _loc14_:int = 0;
         _loc13_ = param2 as TAchievementInfors;
         _loc6_ = param1.readShort();
         _loc4_ = 0;
         while(_loc4_ < _loc6_)
         {
            _loc8_ = param1.readUnsignedInt();
            _loc12_ = _loc13_.GetAchievementByID(_loc8_);
            if(_loc12_ == null)
            {
               return;
            }
            _loc12_.IfGotReward = param1.readUnsignedInt() == 1;
            _loc14_ = 0;
            _loc7_ = param1.readShort();
            _loc5_ = 0;
            while(_loc5_ < _loc7_)
            {
               _loc9_ = param1.readUnsignedInt();
               _loc10_ = param1.readUnsignedInt();
               _loc14_ += this.UpdateSchedule(_loc12_.AchievementSchedules,_loc9_,_loc10_);
               _loc5_++;
            }
            _loc12_.CurrentSchedule = _loc14_;
            _loc4_++;
         }
         this.CheckAchievementIfComplete(_loc13_);
      }
      
      protected function UpdateSchedule(param1:Vector.<TAchievementSchedule>, param2:uint, param3:uint) : int
      {
         var _loc4_:int = 0;
         var _loc5_:TAchievementSchedule = null;
         var _loc6_:int = 0;
         _loc6_ = 0;
         _loc4_ = 0;
         while(_loc4_ < param1.length)
         {
            _loc5_ = param1[_loc4_];
            if(_loc5_.Type == param2)
            {
               _loc6_ += param3 - _loc5_.CurrentSchedule;
               _loc5_.CurrentSchedule = param3 > _loc5_.Value ? _loc5_.Value : int(param3);
               if(_loc5_.CurrentSchedule >= _loc5_.Value)
               {
                  _loc5_.Complete = true;
               }
            }
            _loc4_++;
         }
         return _loc6_;
      }
      
      protected function UnstreamizationAchievementInforUpdate_Perform(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:TAchievementInfor = null;
         var _loc8_:TAchievementInfors = null;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:Boolean = false;
         _loc8_ = param2 as TAchievementInfors;
         _loc4_ = param3 as uint;
         _loc7_ = _loc8_.GetAchievementByID(_loc4_);
         _loc12_ = _loc7_.IfComplete;
         _loc7_.IfGotReward = param1.readUnsignedInt() == 1;
         _loc11_ = 0;
         _loc10_ = param1.readShort();
         _loc9_ = 0;
         while(_loc9_ < _loc10_)
         {
            _loc5_ = param1.readUnsignedInt();
            _loc6_ = param1.readUnsignedInt();
            _loc11_ += this.UpdateSchedule(_loc7_.AchievementSchedules,_loc5_,_loc6_);
            _loc9_++;
         }
         _loc7_.CurrentSchedule += _loc11_;
         this.CheckSingleAchievementIfComplete(_loc7_);
         if(!_loc12_ && _loc7_.IfComplete)
         {
            _loc7_.IfNew = true;
         }
      }
      
      protected function CheckAchievementIfComplete(param1:TAchievementInfors) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         _loc3_ = param1.Count;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.CheckSingleAchievementIfComplete(param1.GetAchievementByIndex(_loc2_));
            _loc2_++;
         }
      }
      
      protected function CheckSingleAchievementIfComplete(param1:TAchievementInfor) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         _loc3_ = int(param1.AchievementSchedules.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(!param1.AchievementSchedules[_loc2_].Complete)
            {
               param1.IfComplete = false;
               return;
            }
            _loc2_++;
         }
         if(param1.AchievementGroupInfor != null)
         {
            ++param1.AchievementGroupInfor.CurrentSchedule;
            if(param1.AchievementGroupInfor.AchievementClassInfor != null)
            {
               ++param1.AchievementGroupInfor.AchievementClassInfor.CurrentSchedule;
            }
         }
         param1.IfComplete = true;
      }
      
      public function UnstreamizationByDataBase(param1:ByteArray, param2:Object, param3:Object) : void
      {
         this.UnstreamizationByDataBase_Perform(param1,param2,param3);
         this.UnstreamizationDirectory_Perform(param1,param2,param3);
      }
      
      public function UnstreamizationTitleByDataBase(param1:ByteArray, param2:Object, param3:Object) : void
      {
         this.UnstreamizationAchievementTitle_Perform(param1,param2,param3);
      }
      
      public function UnstreamizationServerInfor(param1:ByteArray, param2:Object, param3:Object) : void
      {
         this.UnstreamizationServerInfor_Perform(param1,param2,param3);
      }
      
      public function UnstreamizationAchievementInforUpdate(param1:ByteArray, param2:Object, param3:Object) : void
      {
         this.UnstreamizationAchievementInforUpdate_Perform(param1,param2,param3);
      }
   }
}

