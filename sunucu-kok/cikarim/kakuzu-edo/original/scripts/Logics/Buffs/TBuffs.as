package Logics.Buffs
{
   public class TBuffs
   {
      
      protected var FBuffs:Vector.<TBuff>;
      
      public function TBuffs()
      {
         super();
         this.FBuffs = new Vector.<TBuff>();
      }
      
      public function get Count() : int
      {
         return this.FBuffs.length;
      }
      
      public function GetBuffByIndex(param1:int) : TBuff
      {
         return this.FBuffs[param1];
      }
      
      public function Clear() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TBuff = null;
         _loc1_ = int(this.FBuffs.length);
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = this.FBuffs[_loc2_];
            _loc3_.StubReferences.Dereference(this);
            _loc2_++;
         }
         this.FBuffs.length = 0;
      }
      
      public function Add(param1:TBuff) : void
      {
         param1.StubReferences.Reference(this);
         this.FBuffs.push(param1);
      }
      
      public function Delete(param1:int) : void
      {
         var _loc2_:TBuff = null;
         _loc2_ = this.FBuffs[param1];
         _loc2_.StubReferences.Dereference(this);
         this.FBuffs.splice(param1,1);
      }
      
      public function GetIndexByIDTemplate(param1:int) : int
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:TBuff = null;
         return -1;
      }
   }
}

