package Logics.ActivityVO
{
   import Rendering.Overlayers.HDGiftBox.TOverlayerGiftBox;
   
   public class THDShowAwardVO
   {
      
      protected var FState:int;
      
      protected var FCondition:Vector.<int>;
      
      protected var FCS_Index:int;
      
      protected var FCS_Bit:int;
      
      protected var FAwardType:int;
      
      protected var FAwardID:int;
      
      protected var FShowAwardID:int;
      
      protected var FGiftType:int;
      
      protected var FFightReportAddr:String;
      
      public function THDShowAwardVO()
      {
         super();
         this.FGiftType = TOverlayerGiftBox.TYPE_ALL;
         this.FCondition = new Vector.<int>();
      }
      
      public function get State() : int
      {
         return this.FState;
      }
      
      public function set State(param1:int) : void
      {
         this.FState = param1;
      }
      
      public function get Condition() : Vector.<int>
      {
         return this.FCondition;
      }
      
      public function set Condition(param1:Vector.<int>) : void
      {
         this.FCondition = param1;
      }
      
      public function get CS_Index() : int
      {
         return this.FCS_Index;
      }
      
      public function set CS_Index(param1:int) : void
      {
         this.FCS_Index = param1;
      }
      
      public function get CS_Bit() : int
      {
         return this.FCS_Bit;
      }
      
      public function set CS_Bit(param1:int) : void
      {
         this.FCS_Bit = param1;
      }
      
      public function get AwardType() : int
      {
         return this.FAwardType;
      }
      
      public function set AwardType(param1:int) : void
      {
         this.FAwardType = param1;
      }
      
      public function get AwardID() : int
      {
         return this.FAwardID;
      }
      
      public function set AwardID(param1:int) : void
      {
         this.FAwardID = param1;
      }
      
      public function get ShowAwardID() : int
      {
         return this.FShowAwardID;
      }
      
      public function set ShowAwardID(param1:int) : void
      {
         this.FShowAwardID = param1;
      }
      
      public function get GiftType() : int
      {
         return this.FGiftType;
      }
      
      public function set GiftType(param1:int) : void
      {
         this.FGiftType = param1;
      }
      
      public function get FightReportAddr() : String
      {
         return this.FFightReportAddr;
      }
      
      public function set FightReportAddr(param1:String) : void
      {
         this.FFightReportAddr = param1;
      }
   }
}

