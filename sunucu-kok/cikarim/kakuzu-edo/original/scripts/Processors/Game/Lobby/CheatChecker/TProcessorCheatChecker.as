package Processors.Game.Lobby.CheatChecker
{
   import Foundation.Network.SNetworkCore;
   import Foundation.Timing.STimingCore;
   import Foundation.UI.TUIComponent;
   import Processors.TProcessor;
   import Resources.Constants.CONST_HACKCHECKER;
   
   public final class TProcessorCheatChecker extends TProcessor
   {
      
      protected static const LIMIT_HACKWARNING:uint = CONST_HACKCHECKER.LIMIT_HACKWARNING;
      
      protected var FCheckInterval:int;
      
      protected var FBlur:int;
      
      protected var FPrevDate:Number;
      
      protected var FPrevTime:int;
      
      protected var FCheatCount:int;
      
      protected var FWarningCount:int;
      
      protected var FTickReference:int;
      
      protected var FIsActivatingCheckSpeedUp:Boolean;
      
      protected var FOnHackNotification:Function;
      
      public function TProcessorCheatChecker(param1:TUIComponent)
      {
         super(param1);
         this.FCheckInterval = 1000;
         this.FBlur = 150;
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(this.FIsActivatingCheckSpeedUp)
         {
            this.LogicsPerform_CheckSpeedUp();
         }
      }
      
      protected function LogicsPerform_CheckSpeedUp() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Number = NaN;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         _loc1_ = int(STimingCore.TickCount);
         if(_loc1_ - this.FTickReference < this.FCheckInterval)
         {
            return;
         }
         _loc2_ = int(STimingCore.TickCount);
         _loc3_ = new Date().getTime();
         _loc4_ = _loc2_ - this.FPrevTime;
         _loc5_ = Math.abs(_loc4_ - (_loc3_ - this.FPrevDate));
         if(!isNaN(this.FPrevDate) && _loc5_ > this.FBlur)
         {
            ++this.FCheatCount;
            if(this.FCheatCount > LIMIT_HACKWARNING * 5)
            {
               if(this.FWarningCount < LIMIT_HACKWARNING)
               {
                  if(this.FOnHackNotification != null)
                  {
                     this.FOnHackNotification(this,this.FWarningCount++);
                  }
               }
               else
               {
                  SNetworkCore.Transceiver.Disconnect();
               }
               this.FIsActivatingCheckSpeedUp = false;
            }
         }
         else
         {
            this.FCheatCount = 0;
         }
         this.FPrevDate = _loc3_;
         this.FPrevTime = _loc2_;
         this.FTickReference = STimingCore.TickCount;
      }
      
      public function get CheckInterval() : int
      {
         return this.FCheckInterval;
      }
      
      public function set CheckInterval(param1:int) : void
      {
         this.FCheckInterval = param1;
      }
      
      public function get Blur() : int
      {
         return this.FBlur;
      }
      
      public function set Blur(param1:int) : void
      {
         this.FBlur = param1;
      }
      
      public function get OnHackNotification() : Function
      {
         return this.FOnHackNotification;
      }
      
      public function set OnHackNotification(param1:Function) : void
      {
         this.FOnHackNotification = param1;
      }
      
      public function EnabledCheatCheck() : void
      {
         this.FPrevTime = STimingCore.TickCount;
         this.FPrevDate = new Date().getTime();
         this.FTickReference = STimingCore.TickCount;
         this.FIsActivatingCheckSpeedUp = true;
      }
      
      public function HackWarningResponse() : void
      {
         this.EnabledCheatCheck();
      }
   }
}

