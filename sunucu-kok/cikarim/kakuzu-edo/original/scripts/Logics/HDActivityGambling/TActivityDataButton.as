package Logics.HDActivityGambling
{
   import Logics.HDActivityMode.TActivityEntity;
   
   public class TActivityDataButton extends TActivityEntity
   {
      
      protected var FButtonType:uint;
      
      protected var FButtonStatus:int;
      
      public function TActivityDataButton(param1:uint)
      {
         super(param1);
      }
      
      public function get ButtonType() : uint
      {
         return this.FButtonType;
      }
      
      public function set ButtonType(param1:uint) : void
      {
         this.FButtonType = param1;
      }
      
      public function get ButtonStatus() : int
      {
         return this.FButtonStatus;
      }
      
      public function set ButtonStatus(param1:int) : void
      {
         this.FButtonStatus = param1;
      }
   }
}

