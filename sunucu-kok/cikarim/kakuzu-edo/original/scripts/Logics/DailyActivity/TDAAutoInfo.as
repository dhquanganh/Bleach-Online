package Logics.DailyActivity
{
   public class TDAAutoInfo
   {
      
      protected var FType:uint;
      
      protected var FIsSign:Boolean;
      
      protected var FCanSign:Boolean;
      
      protected var FSilver:uint;
      
      protected var FExp:uint;
      
      public function TDAAutoInfo()
      {
         super();
      }
      
      public function get Type() : uint
      {
         return this.FType;
      }
      
      public function set Type(param1:uint) : void
      {
         this.FType = param1;
      }
      
      public function get IsSign() : Boolean
      {
         return this.FIsSign;
      }
      
      public function set IsSign(param1:Boolean) : void
      {
         this.FIsSign = param1;
      }
      
      public function get CanSign() : Boolean
      {
         return this.FCanSign;
      }
      
      public function set CanSign(param1:Boolean) : void
      {
         this.FCanSign = param1;
      }
      
      public function get Silver() : uint
      {
         return this.FSilver;
      }
      
      public function set Silver(param1:uint) : void
      {
         this.FSilver = param1;
      }
      
      public function get Exp() : uint
      {
         return this.FExp;
      }
      
      public function set Exp(param1:uint) : void
      {
         this.FExp = param1;
      }
   }
}

