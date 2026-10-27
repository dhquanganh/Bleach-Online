package Logics.FighterDetail
{
   public class TFighterDetailData
   {
      
      protected var FHeroID:int;
      
      protected var FAskNeed:String;
      
      protected var FItemAskID:int;
      
      protected var FItemAskAmount:int;
      
      protected var FEnlistPaper:String;
      
      protected var FItemEnlistID:int;
      
      protected var FItemEnlistAmount:int;
      
      protected var FUpHeroID:int;
      
      protected var FVipLevel:int;
      
      protected var FRoleLevel:int;
      
      protected var FFightReportAddr:String;
      
      protected var FIsCanEnlist:Boolean;
      
      protected var FType:int;
      
      protected var FStarLevel:int;
      
      public function TFighterDetailData()
      {
         super();
      }
      
      public function get HeroID() : int
      {
         return this.FHeroID;
      }
      
      public function set HeroID(param1:int) : void
      {
         this.FHeroID = param1;
      }
      
      public function get AskNeed() : String
      {
         return this.FAskNeed;
      }
      
      public function set AskNeed(param1:String) : void
      {
         this.FAskNeed = param1;
      }
      
      public function get EnlistPaper() : String
      {
         return this.FEnlistPaper;
      }
      
      public function set EnlistPaper(param1:String) : void
      {
         this.FEnlistPaper = param1;
      }
      
      public function get UpHeroID() : int
      {
         return this.FUpHeroID;
      }
      
      public function set UpHeroID(param1:int) : void
      {
         this.FUpHeroID = param1;
      }
      
      public function get VipLevel() : int
      {
         return this.FVipLevel;
      }
      
      public function set VipLevel(param1:int) : void
      {
         this.FVipLevel = param1;
      }
      
      public function get RoleLevel() : int
      {
         return this.FRoleLevel;
      }
      
      public function set RoleLevel(param1:int) : void
      {
         this.FRoleLevel = param1;
      }
      
      public function get FightReportAddr() : String
      {
         return this.FFightReportAddr;
      }
      
      public function set FightReportAddr(param1:String) : void
      {
         this.FFightReportAddr = param1;
      }
      
      public function get IsCanEnlist() : Boolean
      {
         return this.FIsCanEnlist;
      }
      
      public function set IsCanEnlist(param1:Boolean) : void
      {
         this.FIsCanEnlist = param1;
      }
      
      public function get Type() : int
      {
         return this.FType;
      }
      
      public function set Type(param1:int) : void
      {
         this.FType = param1;
      }
      
      public function get ItemAskID() : int
      {
         return this.FItemAskID;
      }
      
      public function set ItemAskID(param1:int) : void
      {
         this.FItemAskID = param1;
      }
      
      public function get ItemAskAmount() : int
      {
         return this.FItemAskAmount;
      }
      
      public function set ItemAskAmount(param1:int) : void
      {
         this.FItemAskAmount = param1;
      }
      
      public function get ItemEnlistID() : int
      {
         return this.FItemEnlistID;
      }
      
      public function set ItemEnlistID(param1:int) : void
      {
         this.FItemEnlistID = param1;
      }
      
      public function get ItemEnlistAmount() : int
      {
         return this.FItemEnlistAmount;
      }
      
      public function set ItemEnlistAmount(param1:int) : void
      {
         this.FItemEnlistAmount = param1;
      }
      
      public function get StarLevel() : int
      {
         return this.FStarLevel;
      }
      
      public function set StarLevel(param1:int) : void
      {
         this.FStarLevel = param1;
      }
   }
}

