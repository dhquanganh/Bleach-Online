package Logics.TimeCoolDown
{
   public class TTimeCoolDowns
   {
      
      protected var FTimeCoolDowns:Vector.<TTimeCoolDown>;
      
      public function TTimeCoolDowns()
      {
         super();
         this.FTimeCoolDowns = new Vector.<TTimeCoolDown>();
      }
      
      public function get Count() : int
      {
         return this.FTimeCoolDowns.length;
      }
      
      public function GetTimeByIndex(param1:int) : TTimeCoolDown
      {
         return this.FTimeCoolDowns[param1];
      }
      
      public function GetTimeByIdentifier(param1:int) : TTimeCoolDown
      {
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < this.Count)
         {
            if(this.FTimeCoolDowns[_loc2_].Identifier == param1)
            {
               return this.FTimeCoolDowns[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public function Clear() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TTimeCoolDown = null;
         _loc1_ = int(this.FTimeCoolDowns.length);
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = this.FTimeCoolDowns[_loc2_];
            _loc2_++;
         }
         this.FTimeCoolDowns.length = 0;
      }
      
      public function Add(param1:TTimeCoolDown) : void
      {
         this.FTimeCoolDowns.push(param1);
      }
      
      public function Delete(param1:TTimeCoolDown) : void
      {
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < this.FTimeCoolDowns.length)
         {
            if(param1.Identifier == this.FTimeCoolDowns[_loc2_].Identifier)
            {
               this.FTimeCoolDowns.splice(_loc2_,1);
               break;
            }
            _loc2_++;
         }
      }
   }
}

