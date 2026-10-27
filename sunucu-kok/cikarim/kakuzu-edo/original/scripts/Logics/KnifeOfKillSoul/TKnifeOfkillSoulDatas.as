package Logics.KnifeOfKillSoul
{
   public class TKnifeOfkillSoulDatas
   {
      
      protected var FDatas:Vector.<TKnifeOfKillSoulData>;
      
      public function TKnifeOfkillSoulDatas()
      {
         super();
         this.FDatas = new Vector.<TKnifeOfKillSoulData>();
      }
      
      protected function Compare(param1:TKnifeOfKillSoulData, param2:TKnifeOfKillSoulData) : int
      {
         if(param1.ID < param2.ID)
         {
            return -1;
         }
         if(param1.ID > param2.ID)
         {
            return 1;
         }
         return 0;
      }
      
      public function get Count() : int
      {
         return this.FDatas.length;
      }
      
      public function Add(param1:TKnifeOfKillSoulData) : void
      {
         this.FDatas.push(param1);
      }
      
      public function GetByIndex(param1:int) : TKnifeOfKillSoulData
      {
         return this.FDatas[param1];
      }
      
      public function GetByIndentifier(param1:uint) : TKnifeOfKillSoulData
      {
         var _loc2_:int = 0;
         var _loc3_:TKnifeOfKillSoulData = null;
         _loc2_ = 0;
         while(_loc2_ < this.FDatas.length)
         {
            _loc3_ = this.FDatas[_loc2_];
            if(_loc3_.ID == param1)
            {
               return _loc3_;
            }
            _loc2_++;
         }
         return null;
      }
      
      public function Sort(param1:Function = null) : void
      {
         if(param1 == null)
         {
            this.FDatas.sort(this.Compare);
         }
         else
         {
            this.FDatas.sort(param1);
         }
      }
      
      public function Clear() : void
      {
         this.FDatas.length = 0;
      }
   }
}

