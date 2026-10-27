package Logics.Mentorship
{
   import Logics.Mentorship.Elements.TSOSPlayer;
   
   public class TSOS
   {
      
      protected var FSOSList:Vector.<TSOSPlayer>;
      
      public function TSOS()
      {
         super();
         this.FSOSList = new Vector.<TSOSPlayer>();
      }
      
      public function get SOSList() : Vector.<TSOSPlayer>
      {
         return this.FSOSList;
      }
      
      public function set SOSList(param1:Vector.<TSOSPlayer>) : void
      {
         this.FSOSList = param1;
      }
      
      public function GetSOSPlayerByID(param1:uint, param2:uint) : TSOSPlayer
      {
         var _loc3_:int = 0;
         var _loc4_:uint = 0;
         var _loc5_:TSOSPlayer = null;
         _loc4_ = this.FSOSList.length;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc5_ = this.FSOSList[_loc3_];
            if(_loc5_.Identifier0 == param1 && _loc5_.Identifier1 == param2)
            {
               return _loc5_;
            }
            _loc3_++;
         }
         return null;
      }
   }
}

