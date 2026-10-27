package Logics.HDActivityChineseYear
{
   import Logics.HDActivityMode.TActivityCrossServerRank;
   import Logics.HDActivityMode.THDBoxStateData;
   import Logics.HDActivityOS.TActivityOSBase;
   
   public class THDDoubleFishData extends TActivityOSBase
   {
      
      protected var FCollectionCount:uint;
      
      protected var FCurPage:uint;
      
      protected var FMyRank:int;
      
      protected var FRankList:Vector.<TActivityCrossServerRank>;
      
      protected var FBoxStateList:Vector.<THDBoxStateData>;
      
      public function THDDoubleFishData()
      {
         super();
         this.FRankList = new Vector.<TActivityCrossServerRank>();
         this.FBoxStateList = new Vector.<THDBoxStateData>();
      }
      
      protected function SortByRank(param1:TActivityCrossServerRank, param2:TActivityCrossServerRank) : int
      {
         if(param1.Rank < param2.Rank)
         {
            return -1;
         }
         return 1;
      }
      
      public function get CountRankList() : uint
      {
         return this.FRankList.length;
      }
      
      public function get CountBoxStateList() : uint
      {
         return this.FBoxStateList.length;
      }
      
      public function get CollectionCount() : uint
      {
         return this.FCollectionCount;
      }
      
      public function set CollectionCount(param1:uint) : void
      {
         this.FCollectionCount = param1;
      }
      
      public function get CurPage() : uint
      {
         return this.FCurPage;
      }
      
      public function set CurPage(param1:uint) : void
      {
         this.FCurPage = param1;
      }
      
      public function get MyRank() : int
      {
         return this.FMyRank;
      }
      
      public function set MyRank(param1:int) : void
      {
         this.FMyRank = param1;
      }
      
      public function get BoxStateList() : Vector.<THDBoxStateData>
      {
         return this.FBoxStateList;
      }
      
      public function set BoxStateList(param1:Vector.<THDBoxStateData>) : void
      {
         this.FBoxStateList = param1;
      }
      
      public function ClearRank() : void
      {
         var _loc1_:* = 0;
         var _loc2_:int = 0;
         var _loc3_:TActivityCrossServerRank = null;
         _loc1_ = int(this.FRankList.length);
         while(_loc1_ > 0)
         {
            _loc3_ = this.FRankList[_loc1_ - 1];
            _loc3_ = null;
            this.FRankList.pop();
            _loc1_--;
         }
      }
      
      public function AddRank(param1:TActivityCrossServerRank) : void
      {
         this.FRankList.push(param1);
      }
      
      public function GetRankByIndex(param1:uint) : TActivityCrossServerRank
      {
         return this.FRankList[param1];
      }
      
      public function GetBoxByIndex(param1:uint) : THDBoxStateData
      {
         return this.FBoxStateList[param1];
      }
      
      public function RankSort() : void
      {
         this.FRankList.sort(this.SortByRank);
      }
   }
}

