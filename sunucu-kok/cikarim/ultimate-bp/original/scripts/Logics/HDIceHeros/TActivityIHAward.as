package Logics.HDIceHeros
{
   import Logics.HDActivityMode.TActivityEntity;
   
   public class TActivityIHAward extends TActivityEntity
   {
      
      protected var FGetType:uint;
      
      protected var FLimit:uint;
      
      protected var FCondition:uint;
      
      protected var FAwards:uint;
      
      protected var FStatus:int;
      
      protected var FHeroID:uint;
      
      protected var FHeroType:uint;
      
      protected var FReportID:String;
      
      public function TActivityIHAward(param1:uint)
      {
         super(param1);
      }
      
      public function get GetType() : uint
      {
         return this.FGetType;
      }
      
      public function set GetType(param1:uint) : void
      {
         this.FGetType = param1;
      }
      
      public function get Limit() : uint
      {
         return this.FLimit;
      }
      
      public function set Limit(param1:uint) : void
      {
         this.FLimit = param1;
      }
      
      public function get Condition() : uint
      {
         return this.FCondition;
      }
      
      public function set Condition(param1:uint) : void
      {
         this.FCondition = param1;
      }
      
      public function get Awards() : uint
      {
         return this.FAwards;
      }
      
      public function set Awards(param1:uint) : void
      {
         this.FAwards = param1;
      }
      
      public function get Status() : int
      {
         return this.FStatus;
      }
      
      public function set Status(param1:int) : void
      {
         this.FStatus = param1;
      }
      
      public function get HeroID() : uint
      {
         return this.FHeroID;
      }
      
      public function set HeroID(param1:uint) : void
      {
         this.FHeroID = param1;
      }
      
      public function get HeroType() : uint
      {
         return this.FHeroType;
      }
      
      public function set HeroType(param1:uint) : void
      {
         this.FHeroType = param1;
      }
      
      public function get ReportID() : String
      {
         return this.FReportID;
      }
      
      public function set ReportID(param1:String) : void
      {
         this.FReportID = param1;
      }
   }
}

