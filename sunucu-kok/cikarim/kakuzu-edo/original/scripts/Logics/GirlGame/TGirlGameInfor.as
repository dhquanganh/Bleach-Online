package Logics.GirlGame
{
   public class TGirlGameInfor
   {
      
      protected var FGameGirls:Vector.<TGirlInfor>;
      
      protected var FSingedTime:int;
      
      protected var FUndressTime:int;
      
      protected var FAddUndressTime:int;
      
      public function TGirlGameInfor()
      {
         super();
         this.FGameGirls = new Vector.<TGirlInfor>();
      }
      
      public function get GameGirls() : Vector.<TGirlInfor>
      {
         return this.FGameGirls;
      }
      
      public function set GameGirls(param1:Vector.<TGirlInfor>) : void
      {
         this.FGameGirls = param1;
      }
      
      public function get UndressTime() : int
      {
         return this.FUndressTime;
      }
      
      public function set UndressTime(param1:int) : void
      {
         this.FUndressTime = param1;
      }
      
      public function get AddUndressTime() : int
      {
         return this.FAddUndressTime;
      }
      
      public function set AddUndressTime(param1:int) : void
      {
         this.FAddUndressTime = param1;
      }
      
      public function get SingedTime() : int
      {
         return this.FSingedTime;
      }
      
      public function set SingedTime(param1:int) : void
      {
         this.FSingedTime = param1;
      }
   }
}

