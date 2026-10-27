package Logics.KnifeOfKillSoul
{
   import Logics.DatebaseVO.VO.Json.TKnifeAdd;
   import Logics.KnifeOfKillSoul.VO.TKnifeStrengthenAdd;
   import Logics.KnifeOfKillSoul.VO.TKnifeStrengthenPhase;
   
   public class TKnifeOfKillSoulData
   {
      
      public static const StrengthenType_Speed:uint = 1;
      
      public static const StrengthenType_Attack:uint = 2;
      
      public static const StrengthenType_Defense:uint = 3;
      
      protected var FID:uint;
      
      protected var FType:int;
      
      protected var FName:String;
      
      protected var FLevel:int;
      
      protected var FSkillID:uint;
      
      protected var FNeedKnifeSoulLevel:int;
      
      protected var FQuality:int;
      
      protected var FKnifeSoulAdded:int;
      
      protected var FAddedFront:Vector.<TKnifeAdd>;
      
      protected var FAddedMiddle:Vector.<TKnifeAdd>;
      
      protected var FAddedBack:Vector.<TKnifeAdd>;
      
      protected var FNormalTrainExp:int;
      
      protected var FGoldTrainExp:int;
      
      protected var FCurrentExp:int;
      
      protected var FNeedExp:int;
      
      protected var FHandBook:uint;
      
      protected var FHandBookName:String;
      
      protected var FAppraise:String;
      
      protected var FGetRoad:String;
      
      protected var FAttackAttr:int;
      
      protected var FDefenseAttr:int;
      
      protected var FRecoveryAttr:int;
      
      protected var FResistanceAttr:int;
      
      protected var FSpeedAttr:int;
      
      protected var FRelationID:int;
      
      protected var FCurrentState:int;
      
      protected var FStrengthenAdd:Vector.<TKnifeStrengthenAdd>;
      
      protected var FStrengthenType:uint;
      
      protected var FStrengthenPhase:Vector.<TKnifeStrengthenPhase>;
      
      public function TKnifeOfKillSoulData()
      {
         super();
         this.FStrengthenAdd = new Vector.<TKnifeStrengthenAdd>();
         this.FStrengthenPhase = new Vector.<TKnifeStrengthenPhase>();
      }
      
      public function get ID() : uint
      {
         return this.FID;
      }
      
      public function set ID(param1:uint) : void
      {
         this.FID = param1;
      }
      
      public function get Type() : int
      {
         return this.FType;
      }
      
      public function set Type(param1:int) : void
      {
         this.FType = param1;
      }
      
      public function get Name() : String
      {
         return this.FName;
      }
      
      public function set Name(param1:String) : void
      {
         this.FName = param1;
      }
      
      public function get Level() : int
      {
         return this.FLevel;
      }
      
      public function set Level(param1:int) : void
      {
         this.FLevel = param1;
      }
      
      public function get SkillID() : uint
      {
         return this.FSkillID;
      }
      
      public function set SkillID(param1:uint) : void
      {
         this.FSkillID = param1;
      }
      
      public function get NeedKnifeSoulLevel() : int
      {
         return this.FNeedKnifeSoulLevel;
      }
      
      public function set NeedKnifeSoulLevel(param1:int) : void
      {
         this.FNeedKnifeSoulLevel = param1;
      }
      
      public function get Quality() : int
      {
         return this.FQuality;
      }
      
      public function set Quality(param1:int) : void
      {
         this.FQuality = param1;
      }
      
      public function get KnifeSoulAdded() : int
      {
         return this.FKnifeSoulAdded;
      }
      
      public function set KnifeSoulAdded(param1:int) : void
      {
         this.FKnifeSoulAdded = param1;
      }
      
      public function get AddedFront() : Vector.<TKnifeAdd>
      {
         return this.FAddedFront;
      }
      
      public function set AddedFront(param1:Vector.<TKnifeAdd>) : void
      {
         this.FAddedFront = param1;
      }
      
      public function get AddedMiddle() : Vector.<TKnifeAdd>
      {
         return this.FAddedMiddle;
      }
      
      public function set AddedMiddle(param1:Vector.<TKnifeAdd>) : void
      {
         this.FAddedMiddle = param1;
      }
      
      public function get AddedBack() : Vector.<TKnifeAdd>
      {
         return this.FAddedBack;
      }
      
      public function set AddedBack(param1:Vector.<TKnifeAdd>) : void
      {
         this.FAddedBack = param1;
      }
      
      public function get NormalTrainExp() : int
      {
         return this.FNormalTrainExp;
      }
      
      public function set NormalTrainExp(param1:int) : void
      {
         this.FNormalTrainExp = param1;
      }
      
      public function get GoldTrainExp() : int
      {
         return this.FGoldTrainExp;
      }
      
      public function set GoldTrainExp(param1:int) : void
      {
         this.FGoldTrainExp = param1;
      }
      
      public function get NeedExp() : int
      {
         return this.FNeedExp;
      }
      
      public function set NeedExp(param1:int) : void
      {
         this.FNeedExp = param1;
      }
      
      public function get HandBook() : uint
      {
         return this.FHandBook;
      }
      
      public function set HandBook(param1:uint) : void
      {
         this.FHandBook = param1;
      }
      
      public function get Appraise() : String
      {
         return this.FAppraise;
      }
      
      public function set Appraise(param1:String) : void
      {
         this.FAppraise = param1;
      }
      
      public function get GetRoad() : String
      {
         return this.FGetRoad;
      }
      
      public function set GetRoad(param1:String) : void
      {
         this.FGetRoad = param1;
      }
      
      public function get AttackAttr() : int
      {
         return this.FAttackAttr;
      }
      
      public function set AttackAttr(param1:int) : void
      {
         this.FAttackAttr = param1;
      }
      
      public function get DefenseAttr() : int
      {
         return this.FDefenseAttr;
      }
      
      public function set DefenseAttr(param1:int) : void
      {
         this.FDefenseAttr = param1;
      }
      
      public function get RecoveryAttr() : int
      {
         return this.FRecoveryAttr;
      }
      
      public function set RecoveryAttr(param1:int) : void
      {
         this.FRecoveryAttr = param1;
      }
      
      public function get ResistanceAttr() : int
      {
         return this.FResistanceAttr;
      }
      
      public function set ResistanceAttr(param1:int) : void
      {
         this.FResistanceAttr = param1;
      }
      
      public function get SpeedAttr() : int
      {
         return this.FSpeedAttr;
      }
      
      public function set SpeedAttr(param1:int) : void
      {
         this.FSpeedAttr = param1;
      }
      
      public function get RelationID() : int
      {
         return this.FRelationID;
      }
      
      public function set RelationID(param1:int) : void
      {
         this.FRelationID = param1;
      }
      
      public function get CurrentExp() : int
      {
         return this.FCurrentExp;
      }
      
      public function set CurrentExp(param1:int) : void
      {
         this.FCurrentExp = param1;
      }
      
      public function get CurrentState() : int
      {
         return this.FCurrentState;
      }
      
      public function set CurrentState(param1:int) : void
      {
         this.FCurrentState = param1;
      }
      
      public function get HandBookName() : String
      {
         return this.FHandBookName;
      }
      
      public function set HandBookName(param1:String) : void
      {
         this.FHandBookName = param1;
      }
      
      public function get StrengthenAdd() : Vector.<TKnifeStrengthenAdd>
      {
         return this.FStrengthenAdd;
      }
      
      public function get StrengthenPhase() : Vector.<TKnifeStrengthenPhase>
      {
         return this.FStrengthenPhase;
      }
      
      public function get StrengthenType() : uint
      {
         return this.FStrengthenType;
      }
      
      public function set StrengthenType(param1:uint) : void
      {
         this.FStrengthenType = param1;
      }
      
      public function Reset() : void
      {
         this.FID = 0;
         this.FType = 0;
         this.FName = "";
         this.FLevel = 0;
         this.FSkillID = 0;
         this.FNeedKnifeSoulLevel = 0;
         this.FQuality = 0;
         this.FKnifeSoulAdded = 0;
         if(this.FAddedFront != null)
         {
            this.FAddedFront = null;
         }
         if(this.FAddedMiddle != null)
         {
            this.FAddedMiddle = null;
         }
         if(this.FAddedBack != null)
         {
            this.FAddedBack = null;
         }
         this.FNormalTrainExp = 0;
         this.FGoldTrainExp = 0;
         this.FCurrentExp = 0;
         this.FNeedExp = 0;
         this.FHandBook = 0;
         this.FHandBookName = "";
         this.FAppraise = "";
         this.FGetRoad = "";
         this.FAttackAttr = 0;
         this.FDefenseAttr = 0;
         this.FRecoveryAttr = 0;
         this.FResistanceAttr = 0;
         this.FSpeedAttr = 0;
         this.FRelationID = 0;
         this.FCurrentState = 0;
      }
   }
}

