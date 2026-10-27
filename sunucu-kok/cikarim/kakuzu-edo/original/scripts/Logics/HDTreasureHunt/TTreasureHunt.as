package Logics.HDTreasureHunt
{
   import Logics.DatebaseVO.VO.THDTreasureHunt;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.Inventories.TInventories;
   
   public class TTreasureHunt extends TActivityOSBase
   {
      
      protected var FCurTime:uint;
      
      protected var FCurMap:uint;
      
      protected var FCurItem:uint;
      
      protected var FCurLevel:uint;
      
      protected var FScore:uint;
      
      protected var FInvs:TInventories;
      
      protected var FConfig:THDTreasureHunt;
      
      public function TTreasureHunt()
      {
         super();
         this.FInvs = new TInventories();
      }
      
      public function get CurTime() : uint
      {
         return this.FCurTime;
      }
      
      public function set CurTime(param1:uint) : void
      {
         this.FCurTime = param1;
      }
      
      public function get Config() : THDTreasureHunt
      {
         return this.FConfig;
      }
      
      public function set Config(param1:THDTreasureHunt) : void
      {
         this.FConfig = param1;
      }
      
      public function get Invs() : TInventories
      {
         return this.FInvs;
      }
      
      public function set Invs(param1:TInventories) : void
      {
         this.FInvs = param1;
      }
      
      public function get CurMap() : uint
      {
         return this.FCurMap;
      }
      
      public function set CurMap(param1:uint) : void
      {
         this.FCurMap = param1;
      }
      
      public function get CurItem() : uint
      {
         return this.FCurItem;
      }
      
      public function set CurItem(param1:uint) : void
      {
         this.FCurItem = param1;
      }
      
      public function get CurLevel() : uint
      {
         return this.FCurLevel;
      }
      
      public function set CurLevel(param1:uint) : void
      {
         this.FCurLevel = param1;
      }
      
      public function get Score() : uint
      {
         return this.FScore;
      }
      
      public function set Score(param1:uint) : void
      {
         this.FScore = param1;
      }
      
      public function FindItemIndexByAwardId(param1:uint) : int
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         _loc2_ = this.Config.Items.length;
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            if(param1 == this.Config.Items[_loc3_].awardId)
            {
               return _loc3_ % 4;
            }
            _loc3_++;
         }
         return -1;
      }
   }
}

