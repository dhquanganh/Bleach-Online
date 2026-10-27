package Logics.Characters.MainRoleWake
{
   import flash.utils.Dictionary;
   
   public class THeroWakeData
   {
      
      public static const EquipsCount:uint = 8;
      
      public static const AllPos:uint = 6;
      
      public static const StonePos:uint = 7;
      
      protected var FEquips:Vector.<THeroWakeEquipment>;
      
      protected var FInited:Boolean;
      
      protected var FHeroWakeAttributeS2C:Dictionary;
      
      public function THeroWakeData()
      {
         super();
         this.FEquips = new Vector.<THeroWakeEquipment>(EquipsCount);
         this.FHeroWakeAttributeS2C = new Dictionary();
      }
      
      public static function IsEquips(param1:THeroWakeEquipment) : Boolean
      {
         return param1.WakeUpConfig.PosEquip != AllPos && param1.WakeUpConfig.PosEquip != StonePos;
      }
      
      public static function IsAll(param1:THeroWakeEquipment) : Boolean
      {
         return param1.WakeUpConfig.PosEquip == AllPos;
      }
      
      public static function IsStone(param1:THeroWakeEquipment) : Boolean
      {
         return param1.WakeUpConfig.PosEquip == StonePos;
      }
      
      public function get Equips() : Vector.<THeroWakeEquipment>
      {
         return this.FEquips;
      }
      
      public function get Inited() : Boolean
      {
         return this.FInited;
      }
      
      public function set Inited(param1:Boolean) : void
      {
         this.FInited = param1;
      }
      
      public function get HeroWakeAttributeS2C() : Dictionary
      {
         return this.FHeroWakeAttributeS2C;
      }
      
      public function GetAttributesGross(param1:uint) : Number
      {
         var _loc2_:THeroWakeEquipment = null;
         var _loc3_:Number = NaN;
         var _loc4_:Vector.<Object> = null;
         var _loc5_:Object = null;
         _loc3_ = 0;
         for each(_loc2_ in this.FEquips)
         {
            _loc4_ = _loc2_.WakeUpConfig.EquipAttr;
            for each(_loc5_ in _loc4_)
            {
               if(_loc5_.type == param1)
               {
                  _loc3_ += _loc5_.value;
               }
            }
         }
         return _loc3_;
      }
   }
}

