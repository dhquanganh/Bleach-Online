package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.TDatebaseVO;
   import Logics.DatebaseVO.VO.Json.TArticalItem;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class TFighterDetail extends TDatebaseVO
   {
      
      protected var FDesc:String;
      
      protected var FName:String;
      
      protected var FAskNeed:String;
      
      protected var FAskNeedArticalItem:TArticalItem;
      
      protected var FEnlistPaper:String;
      
      protected var FEnlistPaperArticalItem:TArticalItem;
      
      protected var FUpHeroID:int;
      
      protected var FStype:int;
      
      protected var FVipLimit:int;
      
      protected var FMainHeroLevel:int;
      
      protected var FFightReportAddr:String;
      
      public function TFighterDetail()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         this.FDesc = TUtilityString.FetchUTF(param1);
         this.FName = TUtilityString.FetchUTF(param1);
         this.FAskNeed = TUtilityString.FetchUTF(param1);
         this.FAskNeedArticalItem = new TArticalItem(Json.decode(this.FAskNeed));
         this.FEnlistPaper = TUtilityString.FetchUTF(param1);
         this.FEnlistPaperArticalItem = new TArticalItem(Json.decode(this.FEnlistPaper));
         this.FUpHeroID = param1.readInt();
         this.FStype = param1.readInt();
         this.FVipLimit = param1.readInt();
         this.FMainHeroLevel = param1.readInt();
         this.FFightReportAddr = TUtilityString.FetchUTF(param1);
      }
      
      public function get Desc() : String
      {
         return this.FDesc;
      }
      
      public function get Name() : String
      {
         return this.FName;
      }
      
      public function get AskNeedArticalItem() : TArticalItem
      {
         return this.FAskNeedArticalItem;
      }
      
      public function get EnlistPaperArticalItem() : TArticalItem
      {
         return this.FEnlistPaperArticalItem;
      }
      
      public function get UpHeroID() : int
      {
         return this.FUpHeroID;
      }
      
      public function get Stype() : int
      {
         return this.FStype;
      }
      
      public function get VipLimit() : int
      {
         return this.FVipLimit;
      }
      
      public function get MainHeroLevel() : int
      {
         return this.FMainHeroLevel;
      }
      
      public function get FightReportAddr() : String
      {
         return this.FFightReportAddr;
      }
   }
}

