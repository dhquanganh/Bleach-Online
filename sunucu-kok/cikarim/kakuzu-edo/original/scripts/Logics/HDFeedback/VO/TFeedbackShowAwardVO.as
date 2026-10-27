package Logics.HDFeedback.VO
{
   import Logics.Inventories.TInventories;
   import Rendering.Overlayers.HDGiftBox.TOverlayerGiftBox;
   
   public class TFeedbackShowAwardVO
   {
      
      protected var FTitle1:String;
      
      protected var FTitle2:String;
      
      protected var FAwardType:int;
      
      protected var FAwardID:int;
      
      protected var FShowAwardID:int;
      
      protected var FGiftType:int;
      
      protected var FGiftState:int;
      
      protected var FFightReportAddr:String;
      
      protected var FCS_Index:int;
      
      protected var FCS_Bit:int;
      
      protected var FInventories:TInventories;
      
      public function TFeedbackShowAwardVO()
      {
         super();
         this.FGiftType = TOverlayerGiftBox.TYPE_ALL;
      }
      
      public function get Title1() : String
      {
         return this.FTitle1;
      }
      
      public function set Title1(param1:String) : void
      {
         this.FTitle1 = param1;
      }
      
      public function get Title2() : String
      {
         return this.FTitle2;
      }
      
      public function set Title2(param1:String) : void
      {
         this.FTitle2 = param1;
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
      
      public function get GiftState() : int
      {
         return this.FGiftState;
      }
      
      public function set GiftState(param1:int) : void
      {
         this.FGiftState = param1;
      }
      
      public function get FightReportAddr() : String
      {
         return this.FFightReportAddr;
      }
      
      public function set FightReportAddr(param1:String) : void
      {
         this.FFightReportAddr = param1;
      }
      
      public function get CS_Index() : int
      {
         return this.FCS_Index;
      }
      
      public function set CS_Index(param1:int) : void
      {
         this.FCS_Index = param1;
      }
      
      public function get Inventories() : TInventories
      {
         return this.FInventories;
      }
      
      public function set Inventories(param1:TInventories) : void
      {
         this.FInventories = param1;
      }
      
      public function get CS_Bit() : int
      {
         return this.FCS_Bit;
      }
      
      public function set CS_Bit(param1:int) : void
      {
         this.FCS_Bit = param1;
      }
   }
}

