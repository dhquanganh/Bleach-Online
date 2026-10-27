package Logics.Items
{
   public class TItems
   {
      
      private var FItems:Vector.<TItem>;
      
      public function TItems()
      {
         super();
         this.FItems = new Vector.<TItem>();
      }
      
      protected function GetItemIndexByTypeID(param1:int, param2:int, param3:int) : int
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TItem = null;
         _loc5_ = int(this.FItems.length);
         _loc4_ = param3;
         while(_loc4_ < _loc5_)
         {
            _loc6_ = this.FItems[_loc4_];
            if(_loc6_.Type == param1 && _loc6_.ID == param2)
            {
               return _loc4_;
            }
            _loc4_++;
         }
         return -1;
      }
      
      protected function MergeItem(param1:int, param2:int) : void
      {
         this.FItems[param2] += this.FItems[param1].Count;
         this.FItems.splice(param1,1);
         this.FItems[param2].StubReferences.Dereference(this);
      }
      
      public function get Count() : int
      {
         return this.FItems.length;
      }
      
      public function RewardByIndex(param1:int) : TItem
      {
         return this.FItems[param1];
      }
      
      public function GetItemById(param1:int) : TItem
      {
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < this.Count)
         {
            if(this.FItems[_loc2_].ID == param1)
            {
               return this.FItems[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public function get Money() : uint
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < this.FItems.length)
         {
            if(this.FItems[_loc1_].Type == 0 && this.FItems[_loc1_].ID == 0)
            {
               _loc2_ += this.FItems[_loc1_].Count;
            }
            _loc1_++;
         }
         return _loc2_;
      }
      
      public function get VainTravelCoin() : uint
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < this.FItems.length)
         {
            if(this.FItems[_loc1_].Type == 24 && this.FItems[_loc1_].ID == 28)
            {
               _loc2_ += this.FItems[_loc1_].Count;
            }
            _loc1_++;
         }
         return _loc2_;
      }
      
      public function get Fish() : uint
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < this.FItems.length)
         {
            if(this.FItems[_loc1_].Type == 17 && this.FItems[_loc1_].ID == 1000)
            {
               _loc2_ += this.FItems[_loc1_].Count;
            }
            _loc1_++;
         }
         return _loc2_;
      }
      
      public function get Prestige() : uint
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < this.FItems.length)
         {
            if(this.FItems[_loc1_].Type == 5)
            {
               _loc2_ += this.FItems[_loc1_].Count;
            }
            _loc1_++;
         }
         return _loc2_;
      }
      
      public function get Soul() : uint
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < this.FItems.length)
         {
            if(this.FItems[_loc1_].Type == 6)
            {
               _loc2_ += this.FItems[_loc1_].Count;
            }
            _loc1_++;
         }
         return _loc2_;
      }
      
      public function get Exp() : uint
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < this.FItems.length)
         {
            if(this.FItems[_loc1_].Type == 2)
            {
               _loc2_ += this.FItems[_loc1_].Count;
            }
            _loc1_++;
         }
         return _loc2_;
      }
      
      public function get ItemIDs() : Vector.<TItem>
      {
         var _loc1_:int = 0;
         var _loc2_:Vector.<TItem> = null;
         _loc2_ = new Vector.<TItem>();
         _loc1_ = 0;
         while(_loc1_ < this.FItems.length)
         {
            if(this.FItems[_loc1_].Type == 21 || this.FItems[_loc1_].Type == 1 || this.FItems[_loc1_].Type == 3 || this.FItems[_loc1_].Type == 17 || this.FItems[_loc1_].Type == 0 && this.FItems[_loc1_].ID == 2)
            {
               _loc2_.push(this.FItems[_loc1_]);
            }
            _loc1_++;
         }
         return _loc2_;
      }
      
      public function get Items() : Vector.<TItem>
      {
         return this.FItems;
      }
      
      public function set Items(param1:Vector.<TItem>) : void
      {
         this.FItems = param1;
      }
      
      public function Clear() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TItem = null;
         _loc1_ = int(this.FItems.length);
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = this.FItems[_loc2_];
            _loc3_.StubReferences.Dereference(this);
            _loc2_++;
         }
         this.FItems.length = 0;
      }
      
      public function Add(param1:TItem) : void
      {
         param1.StubReferences.Reference(this);
         this.FItems.push(param1);
      }
      
      public function MergeItems() : void
      {
         var _loc1_:* = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.GetItemIndexByTypeID(this.FItems[_loc1_].Type,this.FItems[_loc1_].ID,_loc1_ + 1);
            if(_loc3_ != -1)
            {
               this.MergeItem(_loc1_,_loc3_);
               _loc1_--;
            }
            _loc1_++;
         }
      }
   }
}

