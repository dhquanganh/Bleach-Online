package Logics.Quests
{
   import Foundation.Common.*;
   import Foundation.Common.Stubs.*;
   import Foundation.Resources.Bins.*;
   import Logics.*;
   import Logics.Characters.THero;
   import Logics.DatebaseVO.VO.*;
   import Logics.DatebaseVO.VO.Json.*;
   import Logics.Inventories.*;
   import Logics.Items.*;
   import Logics.Spaces.*;
   import Resources.Constants.*;
   
   use namespace LogicsSpace;
   
   public class TQuest extends TEntity
   {
      
      protected var FStubReferences:TStubReferences;
      
      protected var FCategory:uint;
      
      protected var FEventType:int;
      
      protected var FRewardsInventory:TInventories;
      
      protected var FRewardHeros:Vector.<THero>;
      
      protected var FCanCancle:Boolean;
      
      protected var FName:String;
      
      protected var FPreQuestId:int;
      
      protected var FRequirementLevelMin:int;
      
      protected var FAutoAccept:Boolean;
      
      protected var FCanInstant:Boolean;
      
      protected var FCityID:int;
      
      protected var FCampId:int;
      
      protected var FCurrentfKillTime:int;
      
      protected var FKillTime:int;
      
      protected var FDescription:String;
      
      protected var FGuideBefor:String;
      
      protected var FGuiding:String;
      
      protected var FGuideEnd:String;
      
      protected var FTalkBefor:String;
      
      protected var FTalkEnd:String;
      
      protected var FAcceptTaskNpc:int;
      
      protected var FAcceptTaskNpcCityID:int;
      
      protected var FBackTaskNpc:int;
      
      protected var FBackTaskNpcCityID:int;
      
      protected var FDoorID:uint;
      
      protected var FCompleted:Boolean;
      
      protected var FTaskState:int;
      
      protected var FPreView:Boolean;
      
      protected var FTaskGuideInforCompound:String;
      
      protected var FPlot:String;
      
      protected var FCurrentAutoSearchWayNpcID:int;
      
      public function TQuest(param1:uint)
      {
         super(param1);
         this.FStubReferences = new TStubReferences(this);
         this.FRewardsInventory = new TInventories();
         this.FRewardHeros = new Vector.<THero>();
      }
      
      LogicsSpace function Coerce(param1:uint) : void
      {
         FIdentifier = param1;
      }
      
      public function get Category() : uint
      {
         return this.FCategory;
      }
      
      public function set Category(param1:uint) : void
      {
         this.FCategory = param1;
      }
      
      public function get StubReferences() : TStubReferences
      {
         return this.FStubReferences;
      }
      
      public function set StubReferences(param1:TStubReferences) : void
      {
         this.FStubReferences = param1;
      }
      
      public function get EventType() : int
      {
         return this.FEventType;
      }
      
      public function set EventType(param1:int) : void
      {
         this.FEventType = param1;
      }
      
      public function get CanCancle() : Boolean
      {
         return this.FCanCancle;
      }
      
      public function set CanCancle(param1:Boolean) : void
      {
         this.FCanCancle = param1;
      }
      
      public function get Name() : String
      {
         return this.FName;
      }
      
      public function set Name(param1:String) : void
      {
         this.FName = param1;
      }
      
      public function get PreQuestId() : int
      {
         return this.FPreQuestId;
      }
      
      public function set PreQuestId(param1:int) : void
      {
         this.FPreQuestId = param1;
      }
      
      public function get RequirementLevelMin() : int
      {
         return this.FRequirementLevelMin;
      }
      
      public function set RequirementLevelMin(param1:int) : void
      {
         this.FRequirementLevelMin = param1;
      }
      
      public function get AutoAccept() : Boolean
      {
         return this.FAutoAccept;
      }
      
      public function set AutoAccept(param1:Boolean) : void
      {
         this.FAutoAccept = param1;
      }
      
      public function get CanInstant() : Boolean
      {
         return this.FCanInstant;
      }
      
      public function set CanInstant(param1:Boolean) : void
      {
         this.FCanInstant = param1;
      }
      
      public function get CampId() : int
      {
         return this.FCampId;
      }
      
      public function set CampId(param1:int) : void
      {
         this.FCampId = param1;
      }
      
      public function get CurrentfKillTime() : int
      {
         return this.FCurrentfKillTime;
      }
      
      public function set CurrentfKillTime(param1:int) : void
      {
         this.FCurrentfKillTime = param1;
      }
      
      public function get KillTime() : int
      {
         return this.FKillTime;
      }
      
      public function set KillTime(param1:int) : void
      {
         this.FKillTime = param1;
      }
      
      public function get Description() : String
      {
         return this.FDescription;
      }
      
      public function set Description(param1:String) : void
      {
         this.FDescription = param1;
      }
      
      public function get GuideBefor() : String
      {
         return this.FGuideBefor;
      }
      
      public function set GuideBefor(param1:String) : void
      {
         this.FGuideBefor = param1;
      }
      
      public function get Guiding() : String
      {
         return this.FGuiding;
      }
      
      public function set Guiding(param1:String) : void
      {
         this.FGuiding = param1;
      }
      
      public function get GuideEnd() : String
      {
         return this.FGuideEnd;
      }
      
      public function set GuideEnd(param1:String) : void
      {
         this.FGuideEnd = param1;
      }
      
      public function get TalkBefor() : String
      {
         return this.FTalkBefor;
      }
      
      public function set TalkBefor(param1:String) : void
      {
         this.FTalkBefor = param1;
      }
      
      public function get TalkEnd() : String
      {
         return this.FTalkEnd;
      }
      
      public function set TalkEnd(param1:String) : void
      {
         this.FTalkEnd = param1;
      }
      
      public function get AcceptTaskNpc() : int
      {
         return this.FAcceptTaskNpc;
      }
      
      public function set AcceptTaskNpc(param1:int) : void
      {
         this.FAcceptTaskNpc = param1;
      }
      
      public function get BackTaskNpc() : int
      {
         return this.FBackTaskNpc;
      }
      
      public function set BackTaskNpc(param1:int) : void
      {
         this.FBackTaskNpc = param1;
      }
      
      public function get Completed() : Boolean
      {
         return this.FCompleted;
      }
      
      public function set Completed(param1:Boolean) : void
      {
         this.FCompleted = param1;
      }
      
      public function get TaskState() : int
      {
         return this.FTaskState;
      }
      
      public function set TaskState(param1:int) : void
      {
         this.FTaskState = param1;
      }
      
      public function get TaskGuideInforCompound() : String
      {
         return this.FTaskGuideInforCompound;
      }
      
      public function set TaskGuideInforCompound(param1:String) : void
      {
         this.FTaskGuideInforCompound = param1;
      }
      
      public function get CityID() : int
      {
         return this.FCityID;
      }
      
      public function set CityID(param1:int) : void
      {
         this.FCityID = param1;
      }
      
      public function get RewardsInventory() : TInventories
      {
         return this.FRewardsInventory;
      }
      
      public function get RewardHeros() : Vector.<THero>
      {
         return this.FRewardHeros;
      }
      
      public function get AcceptTaskNpcCityID() : int
      {
         return this.FAcceptTaskNpcCityID;
      }
      
      public function set AcceptTaskNpcCityID(param1:int) : void
      {
         this.FAcceptTaskNpcCityID = param1;
      }
      
      public function get BackTaskNpcCityID() : int
      {
         return this.FBackTaskNpcCityID;
      }
      
      public function set BackTaskNpcCityID(param1:int) : void
      {
         this.FBackTaskNpcCityID = param1;
      }
      
      public function get Plot() : String
      {
         return this.FPlot;
      }
      
      public function set Plot(param1:String) : void
      {
         this.FPlot = param1;
      }
      
      public function get CurrentAutoSearchWayNpcID() : int
      {
         return this.FCurrentAutoSearchWayNpcID;
      }
      
      public function set CurrentAutoSearchWayNpcID(param1:int) : void
      {
         this.FCurrentAutoSearchWayNpcID = param1;
      }
      
      public function get DoorID() : uint
      {
         return this.FDoorID;
      }
      
      public function set DoorID(param1:uint) : void
      {
         this.FDoorID = param1;
      }
      
      public function get PreView() : Boolean
      {
         return this.FPreView;
      }
      
      public function set PreView(param1:Boolean) : void
      {
         this.FPreView = param1;
      }
      
      public function Reset() : void
      {
         this.FStubReferences.Dereference(this);
         this.FName = null;
         this.FDescription = null;
         this.FGuideBefor = null;
         this.FGuiding = null;
         this.FGuideEnd = null;
         this.FTalkBefor = null;
         this.FTalkEnd = null;
      }
   }
}

