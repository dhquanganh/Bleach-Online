package Logics.HDActivityChineseYear.ActivityLukia
{
   import Logics.Inventories.TInventories;
   
   public class TActivityExchangeBag
   {
      
      protected static const BagNum:int = 3;
      
      protected var FIndex:Vector.<int>;
      
      protected var FBagsID:Vector.<uint>;
      
      protected var FChipNeed:Vector.<int>;
      
      protected var FBagInventories:Vector.<TInventories>;
      
      protected var FStatusVect:Vector.<int>;
      
      public function TActivityExchangeBag(param1:Object)
      {
         super();
         this.BuildDeployInfor(param1);
         this.FStatusVect = new Vector.<int>(BagNum);
      }
      
      protected function BuildDeployInfor(param1:Object) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Array = null;
         var _loc4_:Object = null;
         this.FIndex = new Vector.<int>();
         this.FBagsID = new Vector.<uint>();
         this.FChipNeed = new Vector.<int>();
         _loc3_ = param1 as Array;
         _loc2_ = 0;
         while(_loc2_ < BagNum)
         {
            _loc4_ = _loc3_[_loc2_];
            this.FIndex.push(_loc4_.index);
            this.FBagsID.push(_loc4_.award[0]);
            this.FChipNeed.push(_loc4_.keys[0].amount);
            _loc2_++;
         }
      }
      
      public function get Count() : int
      {
         return this.FBagsID.length;
      }
      
      public function get Index() : Vector.<int>
      {
         return this.FIndex;
      }
      
      public function get BagsID() : Vector.<uint>
      {
         return this.FBagsID;
      }
      
      public function get ChipNeed() : Vector.<int>
      {
         return this.FChipNeed;
      }
      
      public function get BagInventories() : Vector.<TInventories>
      {
         return this.FBagInventories;
      }
      
      public function set BagInventories(param1:Vector.<TInventories>) : void
      {
         this.FBagInventories = param1;
      }
      
      public function get StatusVect() : Vector.<int>
      {
         return this.FStatusVect;
      }
      
      public function set StatusVect(param1:Vector.<int>) : void
      {
         this.FStatusVect = param1;
      }
      
      public function UpdateState(param1:int, param2:int) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _loc4_ = int(this.FBagsID.length);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            if(this.FIndex[_loc3_] == param1)
            {
               this.FStatusVect[_loc3_] = param2;
            }
            _loc3_++;
         }
      }
      
      public function FlushActivityData(param1:int, param2:int) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _loc4_ = int(this.FBagsID.length);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            if(this.FIndex[_loc3_] == param1)
            {
               this.FStatusVect[_loc3_] = param2;
            }
            _loc3_++;
         }
      }
   }
}

