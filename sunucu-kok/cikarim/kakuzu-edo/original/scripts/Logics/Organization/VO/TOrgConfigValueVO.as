package Logics.Organization.VO
{
   public class TOrgConfigValueVO
   {
      
      protected var FPersonal_Daily_Number:int;
      
      protected var FPersonal_Everyone_ActionForce:int;
      
      protected var FPersonal_Reset_Price:Vector.<uint>;
      
      protected var FActionForce_LegionActive:int;
      
      protected var FLegion_DailyTimes:uint;
      
      protected var FLegion_Additional_AwardTime:uint;
      
      protected var FLegion_Additional_Award:Vector.<uint>;
      
      protected var FLegion_Open_Consumption:Vector.<uint>;
      
      protected var FLegion_Reset_Consumption:Vector.<uint>;
      
      protected var FORG_Mall_RefleshTime:Vector.<uint>;
      
      protected var FORG_Mall_DailyRefleshTime:Vector.<uint>;
      
      protected var FMall_Reset_Price:Vector.<uint>;
      
      protected var FTotalResetCount:uint;
      
      protected var FTotalResetCount_Mall:uint;
      
      public function TOrgConfigValueVO()
      {
         super();
      }
      
      public function get Personal_Daily_Number() : int
      {
         return this.FPersonal_Daily_Number;
      }
      
      public function set Personal_Daily_Number(param1:int) : void
      {
         this.FPersonal_Daily_Number = param1;
      }
      
      public function get Personal_Everyone_ActionForce() : int
      {
         return this.FPersonal_Everyone_ActionForce;
      }
      
      public function set Personal_Everyone_ActionForce(param1:int) : void
      {
         this.FPersonal_Everyone_ActionForce = param1;
      }
      
      public function get Personal_Reset_Price() : Vector.<uint>
      {
         return this.FPersonal_Reset_Price;
      }
      
      public function set Personal_Reset_Price(param1:Vector.<uint>) : void
      {
         this.FPersonal_Reset_Price = param1;
         this.FTotalResetCount = param1.length;
      }
      
      public function get TotalResetCount() : uint
      {
         return this.FTotalResetCount;
      }
      
      public function get ActionForce_LegionActive() : int
      {
         return this.FActionForce_LegionActive;
      }
      
      public function set ActionForce_LegionActive(param1:int) : void
      {
         this.FActionForce_LegionActive = param1;
      }
      
      public function get Legion_Open_Consumption() : Vector.<uint>
      {
         return this.FLegion_Open_Consumption;
      }
      
      public function set Legion_Open_Consumption(param1:Vector.<uint>) : void
      {
         this.FLegion_Open_Consumption = param1;
      }
      
      public function get Legion_Reset_Consumption() : Vector.<uint>
      {
         return this.FLegion_Reset_Consumption;
      }
      
      public function set Legion_Reset_Consumption(param1:Vector.<uint>) : void
      {
         this.FLegion_Reset_Consumption = param1;
      }
      
      public function get Legion_DailyTimes() : uint
      {
         return this.FLegion_DailyTimes;
      }
      
      public function set Legion_DailyTimes(param1:uint) : void
      {
         this.FLegion_DailyTimes = param1;
      }
      
      public function get Legion_Additional_AwardTime() : uint
      {
         return this.FLegion_Additional_AwardTime;
      }
      
      public function set Legion_Additional_AwardTime(param1:uint) : void
      {
         this.FLegion_Additional_AwardTime = param1;
      }
      
      public function get Legion_Additional_Award() : Vector.<uint>
      {
         return this.FLegion_Additional_Award;
      }
      
      public function set Legion_Additional_Award(param1:Vector.<uint>) : void
      {
         this.FLegion_Additional_Award = param1;
      }
      
      public function get ORG_Mall_RefleshTime() : Vector.<uint>
      {
         return this.FORG_Mall_RefleshTime;
      }
      
      public function set ORG_Mall_RefleshTime(param1:Vector.<uint>) : void
      {
         this.FORG_Mall_RefleshTime = param1;
      }
      
      public function get ORG_Mall_DailyRefleshTime() : Vector.<uint>
      {
         return this.FORG_Mall_DailyRefleshTime;
      }
      
      public function set ORG_Mall_DailyRefleshTime(param1:Vector.<uint>) : void
      {
         this.FORG_Mall_DailyRefleshTime = param1;
      }
      
      public function get Mall_Reset_Price() : Vector.<uint>
      {
         return this.FMall_Reset_Price;
      }
      
      public function set Mall_Reset_Price(param1:Vector.<uint>) : void
      {
         this.FMall_Reset_Price = param1;
         this.FTotalResetCount_Mall = param1.length;
      }
      
      public function get TotalResetCount_Mall() : uint
      {
         return this.FTotalResetCount_Mall;
      }
   }
}

