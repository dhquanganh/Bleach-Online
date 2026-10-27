package Logics.Mentorship
{
   import Logics.Mentorship.Elements.TDisciple;
   
   public class TMentorship
   {
      
      protected const CAPACITY_Disciples:uint = 3;
      
      protected var FIdentity:int;
      
      protected var FTodayArrestCount:uint;
      
      protected var FTodayRescueCount:uint;
      
      protected var FTodayGetExp:uint;
      
      protected var FTodayInteractionCount:uint;
      
      protected var FTodaySOSCount:uint;
      
      protected var FTodayResistCount:uint;
      
      protected var FMasterID0:uint;
      
      protected var FMasterID1:uint;
      
      protected var FMasterName:String;
      
      protected var FMasterLevel:uint;
      
      protected var FMasterHeroID:int;
      
      protected var FMasterGuildName:String;
      
      protected var FInteractionCDTime:uint;
      
      protected var FDiscipleList:Vector.<TDisciple>;
      
      public function TMentorship()
      {
         super();
         this.FDiscipleList = new Vector.<TDisciple>(this.CAPACITY_Disciples);
      }
      
      public function get Identity() : uint
      {
         return this.FIdentity;
      }
      
      public function set Identity(param1:uint) : void
      {
         this.FIdentity = param1;
      }
      
      public function get TodayArrestCount() : uint
      {
         return this.FTodayArrestCount;
      }
      
      public function set TodayArrestCount(param1:uint) : void
      {
         this.FTodayArrestCount = param1;
      }
      
      public function get TodayRescueCount() : uint
      {
         return this.FTodayRescueCount;
      }
      
      public function set TodayRescueCount(param1:uint) : void
      {
         this.FTodayRescueCount = param1;
      }
      
      public function get TodayGetExp() : uint
      {
         return this.FTodayGetExp;
      }
      
      public function set TodayGetExp(param1:uint) : void
      {
         this.FTodayGetExp = param1;
      }
      
      public function get TodayInteractionCount() : uint
      {
         return this.FTodayInteractionCount;
      }
      
      public function set TodayInteractionCount(param1:uint) : void
      {
         this.FTodayInteractionCount = param1;
      }
      
      public function get MasterID0() : uint
      {
         return this.FMasterID0;
      }
      
      public function set MasterID0(param1:uint) : void
      {
         this.FMasterID0 = param1;
      }
      
      public function get MasterID1() : uint
      {
         return this.FMasterID1;
      }
      
      public function set MasterID1(param1:uint) : void
      {
         this.FMasterID1 = param1;
      }
      
      public function get MasterName() : String
      {
         return this.FMasterName;
      }
      
      public function set MasterName(param1:String) : void
      {
         this.FMasterName = param1;
      }
      
      public function get MasterLevel() : uint
      {
         return this.FMasterLevel;
      }
      
      public function set MasterLevel(param1:uint) : void
      {
         this.FMasterLevel = param1;
      }
      
      public function get MasterHeroID() : uint
      {
         return this.FMasterHeroID;
      }
      
      public function set MasterHeroID(param1:uint) : void
      {
         this.FMasterHeroID = param1;
      }
      
      public function get MasterGuildName() : String
      {
         return this.FMasterGuildName;
      }
      
      public function set MasterGuildName(param1:String) : void
      {
         this.FMasterGuildName = param1;
      }
      
      public function get DiscipleList() : Vector.<TDisciple>
      {
         return this.FDiscipleList;
      }
      
      public function set DiscipleList(param1:Vector.<TDisciple>) : void
      {
         this.FDiscipleList = param1;
      }
      
      public function get TodaySOSCount() : uint
      {
         return this.FTodaySOSCount;
      }
      
      public function set TodaySOSCount(param1:uint) : void
      {
         this.FTodaySOSCount = param1;
      }
      
      public function get InteractionCDTime() : uint
      {
         return this.FInteractionCDTime;
      }
      
      public function set InteractionCDTime(param1:uint) : void
      {
         this.FInteractionCDTime = param1;
      }
      
      public function get TodayResistCount() : uint
      {
         return this.FTodayResistCount;
      }
      
      public function set TodayResistCount(param1:uint) : void
      {
         this.FTodayResistCount = param1;
      }
      
      public function GetDiscipleByID(param1:uint, param2:uint) : TDisciple
      {
         var _loc3_:int = 0;
         var _loc4_:uint = 0;
         var _loc5_:TDisciple = null;
         _loc4_ = this.FDiscipleList.length;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc5_ = this.FDiscipleList[_loc3_];
            if(_loc5_.DiscipleID0 == param1 && _loc5_.DiscipleID1 == param2)
            {
               return _loc5_;
            }
            _loc3_++;
         }
         return null;
      }
      
      public function DeleteDiscipleByID(param1:uint, param2:uint) : void
      {
         var _loc3_:int = 0;
         var _loc4_:uint = 0;
         var _loc5_:TDisciple = null;
         _loc4_ = this.FDiscipleList.length;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc5_ = this.FDiscipleList[_loc3_];
            if(_loc5_.DiscipleID0 == param1 && _loc5_.DiscipleID1 == param2)
            {
               this.FDiscipleList.splice(_loc3_,1);
               break;
            }
            _loc3_++;
         }
      }
   }
}

