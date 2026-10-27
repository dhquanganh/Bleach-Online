package Logics.Inventories
{
   public class TCrashJade extends TInventory
   {
      
      protected var FExp:int;
      
      protected var FLevel:int;
      
      protected var FAddAttributeType:Vector.<int> = new Vector.<int>();
      
      protected var FAddAttributeValue:Vector.<Number> = new Vector.<Number>();
      
      protected var FLevelUpExp:int;
      
      protected var FNextLevelID:uint;
      
      protected var FSwallowExp:int;
      
      protected var FEffectID:int;
      
      protected var FJadePower:int;
      
      protected var FAddValueTxt:Vector.<Number> = new Vector.<Number>();
      
      protected var FMountedHeroID:uint;
      
      protected var FJadeTypeText:String = "";
      
      public function TCrashJade(param1:uint)
      {
         super(param1);
      }
      
      protected function ReserVecInt(param1:Vector.<int>) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         if(param1 != null)
         {
            _loc3_ = param1.length;
            _loc2_ = 0;
            while(_loc2_ < _loc3_)
            {
               param1[_loc2_] = 0;
               _loc2_++;
            }
         }
      }
      
      protected function ReserVecNum(param1:Vector.<Number>) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         if(param1 != null)
         {
            _loc3_ = param1.length;
            _loc2_ = 0;
            while(_loc2_ < _loc3_)
            {
               param1[_loc2_] = 0;
               _loc2_++;
            }
         }
      }
      
      public function get Exp() : int
      {
         return this.FExp;
      }
      
      public function set Exp(param1:int) : void
      {
         this.FExp = param1;
      }
      
      public function get Level() : int
      {
         return this.FLevel;
      }
      
      public function set Level(param1:int) : void
      {
         this.FLevel = param1;
      }
      
      public function get LevelUpExp() : int
      {
         return this.FLevelUpExp;
      }
      
      public function set LevelUpExp(param1:int) : void
      {
         this.FLevelUpExp = param1;
      }
      
      public function get NextLevelID() : uint
      {
         return this.FNextLevelID;
      }
      
      public function set NextLevelID(param1:uint) : void
      {
         this.FNextLevelID = param1;
      }
      
      public function get SwallowExp() : int
      {
         return this.FSwallowExp;
      }
      
      public function set SwallowExp(param1:int) : void
      {
         this.FSwallowExp = param1;
      }
      
      public function get MountedHeroID() : uint
      {
         return this.FMountedHeroID;
      }
      
      public function set MountedHeroID(param1:uint) : void
      {
         this.FMountedHeroID = param1;
      }
      
      public function get JadePower() : int
      {
         return this.FJadePower;
      }
      
      public function set JadePower(param1:int) : void
      {
         this.FJadePower = param1;
      }
      
      public function get EffectID() : int
      {
         return this.FEffectID;
      }
      
      public function set EffectID(param1:int) : void
      {
         this.FEffectID = param1;
      }
      
      public function get AddAttributeType() : Vector.<int>
      {
         return this.FAddAttributeType;
      }
      
      public function set AddAttributeType(param1:Vector.<int>) : void
      {
         this.FAddAttributeType = param1.concat();
      }
      
      public function get AddAttributeValue() : Vector.<Number>
      {
         return this.FAddAttributeValue;
      }
      
      public function set AddAttributeValue(param1:Vector.<Number>) : void
      {
         this.FAddAttributeValue = param1.concat();
      }
      
      public function get AddValueTxt() : Vector.<Number>
      {
         return this.FAddValueTxt;
      }
      
      public function set AddValueTxt(param1:Vector.<Number>) : void
      {
         this.FAddValueTxt = param1.concat();
      }
      
      public function get JadeTypeText() : String
      {
         return this.FJadeTypeText;
      }
      
      public function set JadeTypeText(param1:String) : void
      {
         this.FJadeTypeText = param1;
      }
      
      override public function Reset() : void
      {
         super.Reset();
         this.FExp = 0;
         this.FLevel = 0;
         this.FLevelUpExp = 0;
         this.FNextLevelID = 0;
         this.FSwallowExp = 0;
         this.FEffectID = 0;
         this.FJadePower = 0;
         this.FMountedHeroID = 0;
         this.ReserVecInt(this.FAddAttributeType);
         this.ReserVecNum(this.FAddAttributeValue);
         this.ReserVecNum(this.FAddValueTxt);
      }
   }
}

