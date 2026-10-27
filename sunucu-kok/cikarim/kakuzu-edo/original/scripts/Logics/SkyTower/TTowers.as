package Logics.SkyTower
{
   public class TTowers
   {
      
      protected var FTowers:Vector.<TTower>;
      
      public function TTowers()
      {
         super();
         this.FTowers = new Vector.<TTower>();
      }
      
      protected function SortTower(param1:TTower, param2:TTower) : int
      {
         if(param1.Identifier < param2.Identifier)
         {
            return -1;
         }
         return 1;
      }
      
      public function get Count() : int
      {
         return this.FTowers.length;
      }
      
      public function GetTowerByIndex(param1:int) : TTower
      {
         return this.FTowers[param1];
      }
      
      public function Clear() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TTower = null;
         _loc1_ = int(this.FTowers.length);
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = this.FTowers[_loc2_];
            _loc3_.Clear();
            _loc2_++;
         }
         this.FTowers.length = 0;
      }
      
      public function Add(param1:TTower) : void
      {
         this.FTowers.push(param1);
      }
      
      public function GetTowerByIdentifier(param1:uint) : TTower
      {
         var _loc2_:int = 0;
         var _loc3_:TTower = null;
         var _loc4_:TTower = null;
         _loc2_ = 0;
         while(_loc2_ < this.Count)
         {
            _loc3_ = this.FTowers[_loc2_];
            if(_loc3_.Identifier == param1)
            {
               _loc4_ = _loc3_;
               break;
            }
            _loc2_++;
         }
         return _loc4_;
      }
      
      public function DeleteByIdentifier(param1:uint) : void
      {
         var _loc2_:int = 0;
         var _loc3_:TTower = null;
         _loc2_ = 0;
         while(_loc2_ < this.Count)
         {
            _loc3_ = this.FTowers[_loc2_];
            if(_loc3_.Identifier == param1)
            {
               this.FTowers.splice(_loc2_,1);
            }
            _loc2_++;
         }
      }
      
      public function SortTowers() : void
      {
         this.FTowers.sort(this.SortTower);
      }
   }
}

