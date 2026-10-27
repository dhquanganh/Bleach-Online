package Logics.VoidSoulWorld.VO
{
   public class TFrontVO
   {
      
      protected var FPlayers:Vector.<TFrontPlayerVO>;
      
      public function TFrontVO()
      {
         super();
         this.FPlayers = new Vector.<TFrontPlayerVO>();
      }
      
      public function get Players() : Vector.<TFrontPlayerVO>
      {
         return this.FPlayers;
      }
      
      public function GetPlayerByOnlyID(param1:uint, param2:uint) : TFrontPlayerVO
      {
         var _loc3_:TFrontPlayerVO = null;
         for each(_loc3_ in this.FPlayers)
         {
            if(_loc3_.LowID == param1 && _loc3_.HighID == param2)
            {
               return _loc3_;
            }
         }
         return null;
      }
   }
}

