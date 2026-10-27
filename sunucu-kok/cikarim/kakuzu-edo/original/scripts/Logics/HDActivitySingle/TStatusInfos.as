package Logics.HDActivitySingle
{
   public class TStatusInfos
   {
      
      protected var FStatusInfos:Vector.<TStatusInfo>;
      
      public function TStatusInfos()
      {
         super();
         this.FStatusInfos = new Vector.<TStatusInfo>();
      }
      
      public function get Count() : uint
      {
         return this.FStatusInfos.length;
      }
      
      public function GetStatusInfoByLimitID(param1:uint) : TStatusInfo
      {
         return this.FStatusInfos[param1];
      }
      
      public function Add(param1:TStatusInfo) : void
      {
         this.FStatusInfos.push(param1);
      }
      
      public function Clear() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TStatusInfo = null;
         _loc2_ = int(this.FStatusInfos.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FStatusInfos[_loc1_];
            _loc3_ = null;
            _loc1_++;
         }
         this.FStatusInfos.length = 0;
      }
   }
}

