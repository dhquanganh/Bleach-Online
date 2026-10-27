package Resources.Constants
{
   public class CONST_SMITHY
   {
      
      public static const RESOURCESID_SMITHY:uint = 603979776;
      
      public static const RESOURCESID_SMITHYDoubleEffect:uint = 603979777;
      
      public static const RESOURCESID_ClassName_Strengthen:String = "Strengthen";
      
      public static const RESOURCESID_ClassName_BatchRefined:String = "BatchWash";
      
      public static const RESOURCESID_ClassName_DoubleEffect:String = "DoubleEffect";
      
      public static const RESOURCESID_ClassName_SelectBox:String = "Select_box";
      
      public static const Tab_Names:Vector.<String> = Vector.<String>(["Btn_Strengthen","Btn_Refined","Btn_Inherit","Btn_Advanced","Btn_GetSkill","Btn_FlushSpirit","Btn_Punch"]);
      
      public static const MinSingleEquipmentNum:int = 6;
      
      public static const SMITHY_TAB_NUM:int = 7;
      
      public static const TAB_INDEX_STRENGTHEN:int = 0;
      
      public static const TAB_INDEX_REFINED:int = 1;
      
      public static const TAB_INDEX_INHERIT:int = 2;
      
      public static const TAB_INDEX_ADVANCED:int = 3;
      
      public static const TAB_INDEX_GETSKILL:int = 4;
      
      public static const TAB_INDEX_PUNCH:int = 6;
      
      public static const STRENGTHENTYPE_NORMAL:int = 3;
      
      public static const STRENGTHTYPEARRAY:Vector.<int> = Vector.<int>([1,0,2]);
      
      public static const STRENGTHTYPECONFIGS:Vector.<uint> = Vector.<uint>([60106015,60106016,60106017]);
      
      public static const ACTIVITYNUM:int = 2;
      
      public static const CHANGEREDMINUTETIMEID:int = 60106004;
      
      public static var StrengthenMaxLevel:int = 150;
      
      public static const MAX_ATTRIBUTENUM:int = 3;
      
      public static const MAX_ACTIVITYNUM:int = 2;
      
      public static const MAX_BATCHREFINED_ATTRIBUTENUM:int = 3;
      
      public static const MAX_BATCHREFINED_ATTRIBUTELISTNUM:int = 3;
      
      public static const MAX_BATCHREFINED_ACTIVITYNUM:int = 2;
      
      public static const MAX_BATCHREFINED_NEWATTRIBUTENUM:int = 10;
      
      public static const HitPercentRate:Vector.<Number> = Vector.<Number>([0.1,0.49,0.79,0.99,1]);
      
      public static const TextColor:Vector.<String> = Vector.<String>([CONST_COMMON.HTMLCOLOR_White,CONST_COMMON.HTMLCOLOR_Green,CONST_COMMON.HTMLCOLOR_Blue,CONST_COMMON.HTMLCOLOR_Purple,CONST_COMMON.HTMLCOLOR_Yellow]);
      
      public static const REFINEDTYPEARRAY:Vector.<int> = Vector.<int>([0,1,2]);
      
      public static const NORMALREFINEDCOSTTIMES:int = 3;
      
      public static const ONEKEYREFINEDTIMES:int = 10;
      
      public static const MoneyKeepRate:Number = 0.8;
      
      public static const STONE_NUM:uint = 14;
      
      public static const SKILL_RANDOM:uint = 8;
      
      public static const FlushSpiritSuccessCode:uint = 0;
      
      public static const FlushSpiritSuccessFailed:uint = 1;
      
      public function CONST_SMITHY()
      {
         super();
      }
      
      public static function GetBuildValueID(param1:int, param2:int, param3:int) : uint
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:String = null;
         var _loc7_:String = null;
         _loc6_ = param3.toString() + param2.toString();
         _loc7_ = param1.toString();
         _loc5_ = 3;
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            if(_loc7_.length >= _loc5_)
            {
               break;
            }
            _loc7_ = "0" + _loc7_;
            _loc4_++;
         }
         _loc6_ += _loc7_;
         return parseInt(_loc6_);
      }
      
      public static function GetBuildConsumeID(param1:int, param2:int) : uint
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         _loc6_ = param1.toString();
         _loc7_ = param2.toString();
         _loc4_ = 4 - (_loc6_.length + _loc7_.length);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc6_ += "0";
            _loc3_++;
         }
         _loc5_ = _loc6_ + _loc7_;
         return parseInt(_loc5_);
      }
   }
}

