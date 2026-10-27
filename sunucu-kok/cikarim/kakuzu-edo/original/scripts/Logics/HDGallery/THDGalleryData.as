package Logics.HDGallery
{
   import Logics.HDActivityOS.TActivityOSBase;
   
   public class THDGalleryData extends TActivityOSBase
   {
      
      protected static const Color_Num:int = 4;
      
      protected var FFreeCount:int;
      
      protected var FCurInventories:Vector.<Vector.<int>>;
      
      protected var FRemoveStatus:int;
      
      protected var FCurScore:int;
      
      protected var FCurDay:int;
      
      protected var FLoginCanGet:Boolean;
      
      protected var FExchangeStatus:int;
      
      protected var FResults:Vector.<int>;
      
      protected var FCurIndex:int;
      
      protected var FIsInit:int;
      
      public function THDGalleryData()
      {
         super();
         this.FCurInventories = new Vector.<Vector.<int>>(Color_Num);
         this.FResults = new Vector.<int>(2);
      }
      
      public function get FreeCount() : int
      {
         return this.FFreeCount;
      }
      
      public function set FreeCount(param1:int) : void
      {
         this.FFreeCount = param1;
      }
      
      public function get CurInventories() : Vector.<Vector.<int>>
      {
         return this.FCurInventories;
      }
      
      public function set CurInventories(param1:Vector.<Vector.<int>>) : void
      {
         this.FCurInventories = param1;
      }
      
      public function get RemoveStatus() : int
      {
         return this.FRemoveStatus;
      }
      
      public function set RemoveStatus(param1:int) : void
      {
         this.FRemoveStatus = param1;
      }
      
      public function get CurScore() : int
      {
         return this.FCurScore;
      }
      
      public function set CurScore(param1:int) : void
      {
         this.FCurScore = param1;
      }
      
      public function get CurDay() : int
      {
         return this.FCurDay;
      }
      
      public function set CurDay(param1:int) : void
      {
         this.FCurDay = param1;
      }
      
      public function get ExchangeStatus() : int
      {
         return this.FExchangeStatus;
      }
      
      public function set ExchangeStatus(param1:int) : void
      {
         this.FExchangeStatus = param1;
      }
      
      public function get LoginCanGet() : Boolean
      {
         return this.FLoginCanGet;
      }
      
      public function set LoginCanGet(param1:Boolean) : void
      {
         this.FLoginCanGet = param1;
      }
      
      public function get Results() : Vector.<int>
      {
         return this.FResults;
      }
      
      public function set Results(param1:Vector.<int>) : void
      {
         this.FResults = param1;
      }
      
      public function get CurIndex() : int
      {
         return this.FCurIndex;
      }
      
      public function set CurIndex(param1:int) : void
      {
         this.FCurIndex = param1;
      }
      
      public function get IsInit() : int
      {
         return this.FIsInit;
      }
      
      public function set IsInit(param1:int) : void
      {
         this.FIsInit = param1;
      }
   }
}

