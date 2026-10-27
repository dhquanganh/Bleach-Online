package Logics.HDBrushHappy
{
   import Logics.DatebaseVO.VO.THDBrushHappy;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.Inventories.TInventories;
   
   public class TBrushHappyData extends TActivityOSBase
   {
      
      public static const ItemCount:uint = 4;
      
      public static const InvsCount:uint = 8;
      
      protected var FArticles:Vector.<TBrushHappyArticle>;
      
      protected var FTime:uint;
      
      protected var FSpecialItemBuyed:Boolean;
      
      protected var FInvs:TInventories;
      
      protected var FDay:uint;
      
      protected var FConfig:THDBrushHappy;
      
      public function TBrushHappyData()
      {
         super();
         this.init();
      }
      
      public function get Articles() : Vector.<TBrushHappyArticle>
      {
         return this.FArticles;
      }
      
      public function get Time() : uint
      {
         return this.FTime;
      }
      
      public function set Time(param1:uint) : void
      {
         this.FTime = param1;
      }
      
      public function get SpecialItemBuyed() : Boolean
      {
         return this.FSpecialItemBuyed;
      }
      
      public function set SpecialItemBuyed(param1:Boolean) : void
      {
         this.FSpecialItemBuyed = param1;
      }
      
      public function get Invs() : TInventories
      {
         return this.FInvs;
      }
      
      public function set Invs(param1:TInventories) : void
      {
         this.FInvs = param1;
      }
      
      public function get Config() : THDBrushHappy
      {
         return this.FConfig;
      }
      
      public function set Config(param1:THDBrushHappy) : void
      {
         this.FConfig = param1;
      }
      
      public function get Day() : uint
      {
         return this.FDay;
      }
      
      public function set Day(param1:uint) : void
      {
         this.FDay = param1;
      }
      
      protected function init() : void
      {
         var _loc1_:uint = 0;
         this.FArticles = new Vector.<TBrushHappyArticle>();
         _loc1_ = 0;
         while(_loc1_ < ItemCount)
         {
            this.FArticles[_loc1_] = new TBrushHappyArticle();
            _loc1_++;
         }
         this.FInvs = new TInventories();
      }
   }
}

