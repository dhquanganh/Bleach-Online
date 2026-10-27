package Logics.Organization.VO
{
   import Logics.DatebaseVO.VO.TCity;
   
   public class TOrgCopyVO
   {
      
      protected var FCity:TCity;
      
      protected var FFightCount:uint;
      
      protected var FOpen:Boolean;
      
      protected var FPass:Boolean;
      
      protected var FRewardRemainTime:Number;
      
      protected var FDay:uint;
      
      protected var FHours:uint;
      
      protected var FMinute:uint;
      
      protected var FSecond:uint;
      
      protected var FPointInfoVOs:Vector.<TPointInfoVO>;
      
      protected var FSpoilsVOs:Vector.<TOrgSpoilsBarVO>;
      
      public function TOrgCopyVO()
      {
         super();
         this.FPointInfoVOs = new Vector.<TPointInfoVO>();
         this.FSpoilsVOs = new Vector.<TOrgSpoilsBarVO>();
      }
      
      public function get City() : TCity
      {
         return this.FCity;
      }
      
      public function set City(param1:TCity) : void
      {
         this.FCity = param1;
      }
      
      public function get PointInfoVOs() : Vector.<TPointInfoVO>
      {
         return this.FPointInfoVOs;
      }
      
      public function set PointInfoVOs(param1:Vector.<TPointInfoVO>) : void
      {
         this.FPointInfoVOs = param1;
      }
      
      public function get Open() : Boolean
      {
         return this.FOpen;
      }
      
      public function set Open(param1:Boolean) : void
      {
         this.FOpen = param1;
      }
      
      public function get RewardRemainTime() : Number
      {
         return this.FRewardRemainTime;
      }
      
      public function set RewardRemainTime(param1:Number) : void
      {
         this.FRewardRemainTime = param1;
      }
      
      public function get Pass() : Boolean
      {
         return this.FPass;
      }
      
      public function set Pass(param1:Boolean) : void
      {
         this.FPass = param1;
      }
      
      public function get Day() : uint
      {
         return this.FDay;
      }
      
      public function set Day(param1:uint) : void
      {
         this.FDay = param1;
      }
      
      public function get Hours() : uint
      {
         return this.FHours;
      }
      
      public function set Hours(param1:uint) : void
      {
         this.FHours = param1;
      }
      
      public function get Minute() : uint
      {
         return this.FMinute;
      }
      
      public function set Minute(param1:uint) : void
      {
         this.FMinute = param1;
      }
      
      public function get Second() : uint
      {
         return this.FSecond;
      }
      
      public function set Second(param1:uint) : void
      {
         this.FSecond = param1;
      }
      
      public function get FightCount() : uint
      {
         return this.FFightCount;
      }
      
      public function set FightCount(param1:uint) : void
      {
         this.FFightCount = param1;
      }
      
      public function get SpoilsVOs() : Vector.<TOrgSpoilsBarVO>
      {
         return this.FSpoilsVOs;
      }
      
      public function set SpoilsVOs(param1:Vector.<TOrgSpoilsBarVO>) : void
      {
         this.FSpoilsVOs = param1;
      }
   }
}

