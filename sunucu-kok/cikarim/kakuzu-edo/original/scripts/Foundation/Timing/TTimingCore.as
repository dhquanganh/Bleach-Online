package Foundation.Timing
{
   import Foundation.Timing.Spaces.TimingSpace;
   import flash.utils.getTimer;
   
   use namespace TimingSpace;
   
   public class TTimingCore
   {
      
      protected var FTickCount:int;
      
      protected var FServerTimeZoneAtStartServer:int;
      
      protected var FClientTimeZoneAtStartServer:int;
      
      protected var FServerTimeZoneCurrent:int;
      
      protected var FClientTimeZoneCurrent:int;
      
      protected var FServerTime:uint;
      
      protected var FServerStartTime:uint;
      
      protected var FServerTimeTick:int;
      
      public function TTimingCore()
      {
         var _loc1_:Date = null;
         super();
         _loc1_ = new Date();
         this.FClientTimeZoneCurrent = _loc1_.timezoneOffset * 60;
      }
      
      TimingSpace function SetServerStartTimeZone(param1:int) : void
      {
         this.FServerTimeZoneAtStartServer = param1;
      }
      
      TimingSpace function SetTimeZone(param1:int) : void
      {
         this.FServerTimeZoneCurrent = param1;
      }
      
      TimingSpace function SetServerTime(param1:uint) : void
      {
         this.FServerTime = param1;
         this.FServerTimeTick = this.FTickCount;
      }
      
      TimingSpace function SetServerStartTime(param1:uint) : void
      {
         var _loc2_:Date = null;
         this.FServerStartTime = param1;
         _loc2_ = new Date(this.FServerStartTime * 1000);
         this.FClientTimeZoneAtStartServer = _loc2_.timezoneOffset * 60;
      }
      
      public function get TickCount() : int
      {
         return this.FTickCount;
      }
      
      public function get ServerTimeZone() : int
      {
         return this.FServerTimeZoneCurrent;
      }
      
      public function get ClientTimezoneOffset() : int
      {
         return this.FClientTimeZoneCurrent;
      }
      
      public function get ServerTick() : uint
      {
         return this.FServerTime + (this.FTickCount - this.FServerTimeTick) / 1000;
      }
      
      public function get ServerTickM() : Number
      {
         return this.FServerTime * 1000 + (this.FTickCount - this.FServerTimeTick);
      }
      
      public function get ServerTime() : uint
      {
         return this.ServerTick - this.FServerTimeZoneCurrent + this.FClientTimeZoneCurrent;
      }
      
      public function get ServerLocalTime() : uint
      {
         return this.ServerTick - this.FServerTimeZoneCurrent;
      }
      
      public function get ServerStartTick() : uint
      {
         return this.FServerStartTime;
      }
      
      public function get ServerStartTime() : uint
      {
         return this.FServerStartTime - this.FServerTimeZoneAtStartServer + this.FClientTimeZoneAtStartServer;
      }
      
      public function Update() : void
      {
         this.FTickCount = getTimer();
      }
   }
}

