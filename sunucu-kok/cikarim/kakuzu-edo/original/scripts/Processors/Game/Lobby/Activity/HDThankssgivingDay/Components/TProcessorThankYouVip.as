package Processors.Game.Lobby.Activity.HDThankssgivingDay.Components
{
   import Foundation.UI.TUIComponent;
   
   public class TProcessorThankYouVip extends TProcessorThankYouAwardList
   {
      
      public function TProcessorThankYouVip(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function CanReceive(param1:uint, param2:uint) : Boolean
      {
         var _loc3_:uint = 0;
         var _loc4_:Boolean = false;
         if(param1 != FCurValue)
         {
            return false;
         }
         _loc3_ = 0;
         while(_loc3_ < param2)
         {
            _loc4_ = Boolean(FKeys >> _loc3_ & 1);
            if(_loc4_)
            {
               return false;
            }
            _loc3_++;
         }
         return true;
      }
   }
}

