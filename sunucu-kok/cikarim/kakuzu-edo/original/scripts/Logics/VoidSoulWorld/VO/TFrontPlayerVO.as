package Logics.VoidSoulWorld.VO
{
   import Foundation.Timing.STimingCore;
   
   public class TFrontPlayerVO
   {
      
      protected var FWarTime:Number;
      
      protected var FName:String;
      
      protected var FLowID:uint;
      
      protected var FHighID:uint;
      
      protected var FTempleteID:uint;
      
      protected var FTeam:uint;
      
      protected var FQuality:uint;
      
      public function TFrontPlayerVO()
      {
         super();
      }
      
      public function get WarTime() : Number
      {
         return this.FWarTime;
      }
      
      public function set WarTime(param1:Number) : void
      {
         this.FWarTime = param1 * 1000;
         if(this.FWarTime > STimingCore.ServerTickM)
         {
            this.FWarTime = STimingCore.ServerTickM;
         }
      }
      
      public function get Name() : String
      {
         return this.FName;
      }
      
      public function set Name(param1:String) : void
      {
         this.FName = param1;
      }
      
      public function get LowID() : uint
      {
         return this.FLowID;
      }
      
      public function set LowID(param1:uint) : void
      {
         this.FLowID = param1;
      }
      
      public function get HighID() : uint
      {
         return this.FHighID;
      }
      
      public function set HighID(param1:uint) : void
      {
         this.FHighID = param1;
      }
      
      public function get TempleteID() : uint
      {
         return this.FTempleteID;
      }
      
      public function set TempleteID(param1:uint) : void
      {
         this.FTempleteID = param1;
      }
      
      public function get Team() : uint
      {
         return this.FTeam;
      }
      
      public function set Team(param1:uint) : void
      {
         this.FTeam = param1;
      }
      
      public function get Quality() : uint
      {
         return this.FQuality;
      }
      
      public function set Quality(param1:uint) : void
      {
         this.FQuality = param1;
      }
   }
}

