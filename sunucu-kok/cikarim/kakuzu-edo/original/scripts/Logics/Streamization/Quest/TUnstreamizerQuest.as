package Logics.Streamization.Quest
{
   import Foundation.Resources.Bins.*;
   import Foundation.Resources.SResourcesCore;
   import Foundation.Streamization.*;
   import Logics.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.DatebaseVO.VO.Json.*;
   import Logics.Inventories.*;
   import Logics.Items.*;
   import Logics.Quests.*;
   import Logics.Spaces.*;
   import Logics.Streamization.Inventories.*;
   import Resources.Constants.*;
   import flash.utils.*;
   
   use namespace LogicsSpace;
   
   public class TUnstreamizerQuest extends TUnstreamizer
   {
      
      protected var FUnstreamizerInventoryReference:TUnstreamizerInventoryReference;
      
      public function TUnstreamizerQuest()
      {
         super();
         this.FUnstreamizerInventoryReference = new TUnstreamizerInventoryReference();
      }
      
      override protected function UnstreamizationPerform(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:TQuest = null;
         var _loc5_:TQuestObjective = null;
         var _loc6_:int = 0;
         _loc4_ = param2 as TQuest;
         _loc6_ = param1.readInt();
         _loc4_.Coerce(_loc6_);
         _loc4_.CurrentfKillTime = param1.readShort();
      }
      
      protected function CreateType0(param1:TItem) : uint
      {
         var _loc2_:uint = 0;
         switch(param1.ID)
         {
            case 0:
               _loc2_ = 14100022;
               break;
            case 1:
               _loc2_ = 14100023;
               break;
            case 2:
               _loc2_ = 14100024;
         }
         return _loc2_;
      }
      
      protected function CreateType1(param1:TItem) : uint
      {
         return param1.ID;
      }
      
      protected function CreateType2(param1:TItem) : uint
      {
         return 14100025;
      }
      
      protected function CreateType4(param1:TItem) : uint
      {
         switch(param1.ID)
         {
            case 11100101:
               return 14100043;
            case 11100102:
               return 14100044;
            default:
               return 0;
         }
      }
      
      protected function CreateType5(param1:TItem) : uint
      {
         return 14100026;
      }
      
      protected function CreateType6(param1:TItem) : uint
      {
         return 14100027;
      }
      
      protected function CreateRewardIDTemplate(param1:TItem) : uint
      {
         switch(param1.Type)
         {
            case 0:
               return this.CreateType0(param1);
            case 1:
               return this.CreateType1(param1);
            case 2:
               return this.CreateType2(param1);
            case 4:
               return this.CreateType4(param1);
            case 5:
               return this.CreateType5(param1);
            case 6:
               return this.CreateType6(param1);
            default:
               return 0;
         }
      }
      
      protected function FlushRewardNumber(param1:TInventories, param2:TTask) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:TInventory = null;
         _loc4_ = param1.Count;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc5_ = param1.GetInventoryByIndex(_loc3_);
            _loc5_.Quantity = param2.TaskRewards[_loc3_].Amount;
            _loc3_++;
         }
      }
      
      protected function UnstreamizationPerform_QuestByDatabases(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TBins = null;
         var _loc7_:TTask = null;
         var _loc8_:TQuest = null;
         var _loc9_:TItem = null;
         var _loc10_:TFixedAward = null;
         var _loc11_:Object = null;
         var _loc12_:Vector.<uint> = null;
         var _loc13_:uint = 0;
         var _loc14_:TNPC = null;
         _loc8_ = param2 as TQuest;
         _loc7_ = param3 as TTask;
         _loc8_.Category = this.QuestDeployTypeToSystemType(_loc7_.Type);
         _loc8_.EventType = _loc7_.EventType;
         _loc8_.CanCancle = _loc7_.Cancel == 1;
         _loc8_.Name = _loc7_.Name;
         _loc8_.PreQuestId = _loc7_.PreTaskId;
         _loc8_.RequirementLevelMin = _loc7_.Accept;
         _loc8_.AutoAccept = _loc7_.AutoAccept == 1;
         _loc8_.CanInstant = _loc7_.Instant == 1;
         _loc8_.Plot = _loc7_.Plot;
         _loc9_ = new TItem();
         _loc12_ = new Vector.<uint>();
         _loc5_ = int(_loc7_.TaskRewards.length);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc10_ = _loc7_.TaskRewards[_loc4_];
            _loc9_.Type = _loc10_.Type;
            _loc9_.ID = _loc10_.Code;
            _loc9_.Count = _loc10_.Amount;
            _loc13_ = this.CreateRewardIDTemplate(_loc9_);
            if(_loc13_ != 0)
            {
               _loc12_.push(_loc13_);
            }
            this.FUnstreamizerInventoryReference.UnstreamizeGenerateInventoriesByIdentifiers(null,_loc8_.RewardsInventory,_loc12_);
            _loc12_.length = 0;
            _loc4_++;
         }
         this.FlushRewardNumber(_loc8_.RewardsInventory,_loc7_);
         _loc8_.CityID = _loc7_.Point;
         _loc8_.CampId = _loc7_.CampId;
         _loc8_.KillTime = _loc7_.NeedKillTime;
         _loc8_.CurrentfKillTime = _loc7_.InitKillTime;
         _loc8_.Description = _loc7_.Description;
         _loc8_.GuideBefor = _loc7_.GuideBefor;
         _loc8_.Guiding = _loc7_.Guide;
         _loc8_.GuideEnd = _loc7_.GuideEnd;
         _loc8_.TalkBefor = _loc7_.TalkBefor;
         _loc8_.TalkEnd = _loc7_.TalkEnd;
         _loc8_.AcceptTaskNpc = _loc7_.StartNpcId;
         if(_loc7_.EventType == CONST_QUEST.QuestEventTypeJustRun)
         {
            _loc8_.AcceptTaskNpcCityID = _loc7_.Point;
         }
         else
         {
            _loc14_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_NPC,_loc8_.AcceptTaskNpc) as TNPC;
            _loc8_.AcceptTaskNpcCityID = _loc14_.Cityid;
         }
         _loc8_.BackTaskNpc = _loc7_.FinishNpcId;
         if(_loc7_.EventType == CONST_QUEST.QuestEventTypeJustRun)
         {
            _loc8_.BackTaskNpcCityID = _loc7_.Point;
         }
         else
         {
            _loc14_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_NPC,_loc8_.BackTaskNpc) as TNPC;
            _loc8_.BackTaskNpcCityID = _loc14_.Cityid;
         }
         _loc8_.AcceptTaskNpc = _loc7_.StartNpcId;
         _loc8_.BackTaskNpc = _loc7_.FinishNpcId;
         _loc8_.DoorID = _loc7_.Gate;
      }
      
      protected function QuestDeployTypeToSystemType(param1:int) : int
      {
         return --param1;
      }
      
      public function UnstreamizeQuestByDatabases(param1:ByteArray, param2:Object, param3:Object) : void
      {
         this.UnstreamizationPerform_QuestByDatabases(param1,param2,param3);
      }
   }
}

