package Logics.KnifeOfKillSoul.VO
{
   public class TKnifeStrengthenAdd
   {
      
      protected var FType:uint;
      
      protected var FValue:uint;
      
      protected var FLevel:uint;
      
      protected var FExp:uint;
      
      protected var FUpExp:uint;
      
      protected var FTotalExp:int;
      
      protected var FUpAddValue:uint;
      
      protected var FIsMax:Boolean;
      
      protected var FBaseValue:uint;
      
      protected var FIsNodeLevel:Boolean;
      
      protected var FNextNodeLevel:uint;
      
      public function TKnifeStrengthenAdd()
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
      
      public function get Value() : uint
      {
         return this.FValue;
      }
      
      public function set Value(param1:uint) : void
      {
         this.FValue = param1;
      }
      
      public function get Level() : uint
      {
         return this.FLevel;
      }
      
      public function set Level(param1:uint) : void
      {
         this.FLevel = param1;
      }
      
      public function get Exp() : uint
      {
         return this.FExp;
      }
      
      public function set Exp(param1:uint) : void
      {
         this.FExp = param1;
      }
      
      public function get UpExp() : uint
      {
         return this.FUpExp;
      }
      
      public function set UpExp(param1:uint) : void
      {
         this.FUpExp = param1;
      }
      
      public function get UpAddValue() : uint
      {
         return this.FUpAddValue;
      }
      
      public function set UpAddValue(param1:uint) : void
      {
         this.FUpAddValue = param1;
      }
      
      public function get IsMax() : Boolean
      {
         return this.FIsMax;
      }
      
      public function set IsMax(param1:Boolean) : void
      {
         this.FIsMax = param1;
      }
      
      public function get BaseValue() : uint
      {
         return this.FBaseValue;
      }
      
      public function set BaseValue(param1:uint) : void
      {
         this.FBaseValue = param1;
      }
      
      public function get IsNodeLevel() : Boolean
      {
         return this.FIsNodeLevel;
      }
      
      public function set IsNodeLevel(param1:Boolean) : void
      {
         this.FIsNodeLevel = param1;
      }
      
      public function get NextNodeLevel() : uint
      {
         return this.FNextNodeLevel;
      }
      
      public function set NextNodeLevel(param1:uint) : void
      {
         this.FNextNodeLevel = param1;
      }
      
      public function get TotalExp() : int
      {
         return this.FTotalExp;
      }
      
      public function set TotalExp(param1:int) : void
      {
         this.FTotalExp = param1;
      }
   }
}

