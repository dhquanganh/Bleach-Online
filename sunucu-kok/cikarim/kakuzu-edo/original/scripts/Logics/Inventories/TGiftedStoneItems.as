package Logics.Inventories
{
   import Resources.Constants.*;
   
   public class TGiftedStoneItems
   {
      
      protected var FGiftedStones:Vector.<TAppliance>;
      
      public function TGiftedStoneItems()
      {
         super();
         this.FGiftedStones = new Vector.<TAppliance>();
      }
      
      public function get Count() : int
      {
         return this.FGiftedStones.length;
      }
      
      public function GetGiftedStoneByIndex(param1:int) : TAppliance
      {
         return this.FGiftedStones[param1];
      }
      
      public function GetGiftedStoneByIdentifier(param1:uint) : TAppliance
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TAppliance = null;
         _loc2_ = int(this.FGiftedStones.length);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = this.FGiftedStones[_loc3_];
            if(_loc4_.Identifier == param1)
            {
               return _loc4_;
            }
            _loc3_++;
         }
         return null;
      }
      
      public function Clear() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TAppliance = null;
         _loc1_ = int(this.FGiftedStones.length);
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = this.FGiftedStones[_loc2_];
            if(_loc3_ != null)
            {
               _loc3_.StubReferences.Dereference(this);
            }
            _loc2_++;
         }
         this.FGiftedStones.length = 0;
      }
      
      public function Add(param1:TAppliance) : void
      {
         param1.StubReferences.Reference(this);
         this.FGiftedStones.push(param1);
      }
      
      public function Delete(param1:int) : TAppliance
      {
         var _loc2_:TAppliance = null;
         if(param1 == 0)
         {
            return this.FGiftedStones.shift();
         }
         _loc2_ = this.FGiftedStones[param1];
         if(_loc2_ != null)
         {
            _loc2_.StubReferences.Dereference(this);
         }
         this.FGiftedStones.splice(param1,1);
         return _loc2_;
      }
   }
}

