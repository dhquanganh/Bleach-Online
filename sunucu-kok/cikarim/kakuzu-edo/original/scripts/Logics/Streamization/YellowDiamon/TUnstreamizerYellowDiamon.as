package Logics.Streamization.YellowDiamon
{
   import Foundation.Streamization.TUnstreamizer;
   import Logics.YellowDiamon.TYellowDiamon;
   import Resources.Constants.CONST_YELLOWDIAMON;
   import flash.utils.ByteArray;
   
   public class TUnstreamizerYellowDiamon extends TUnstreamizer
   {
      
      public function TUnstreamizerYellowDiamon()
      {
         super();
      }
      
      override protected function UnstreamizationPerform(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:TYellowDiamon = null;
         var _loc5_:int = 0;
         _loc4_ = param2 as TYellowDiamon;
         _loc4_.IFYellowDiamondUser = param1.readUnsignedByte() != 0;
         _loc4_.IFYearYellowDiamondUser = param1.readUnsignedByte() != 0;
         _loc4_.Level = param1.readUnsignedByte();
         _loc5_ = int(param1.readUnsignedByte());
         _loc4_.IFReciveFreshGiftBag = Boolean(_loc5_ & 1);
         _loc4_.IFReciveYearFreshGiftBag = Boolean(_loc5_ & 2);
         _loc4_.IFReciveDailyGiftBag = param1.readUnsignedByte() != 0;
         _loc4_.IFReciveYearDailyGiftBag = param1.readUnsignedByte() != 0;
         _loc4_.GrowUpGiftBagState = param1.readUnsignedInt();
         _loc4_.LevelGiftBagState = param1.readUnsignedInt();
      }
      
      protected function UnstreamizationPerform_UpdateYellowDiamondGiftBagState_Perform(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:TYellowDiamon = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         _loc4_ = param2 as TYellowDiamon;
         _loc5_ = param1.readUnsignedInt();
         _loc6_ = param1.readUnsignedInt();
         switch(_loc5_)
         {
            case CONST_YELLOWDIAMON.YellowDiamondType_Fresh:
               _loc4_.IFReciveFreshGiftBag = Boolean(_loc6_ & 1);
               _loc4_.IFReciveYearFreshGiftBag = Boolean(_loc6_ & 2);
               break;
            case CONST_YELLOWDIAMON.YellowDiamondType_Daily:
               _loc4_.IFReciveDailyGiftBag = _loc6_ != 0;
               break;
            case CONST_YELLOWDIAMON.YellowDiamondType_YearDaily:
               _loc4_.IFReciveYearDailyGiftBag = _loc6_ != 0;
               break;
            case CONST_YELLOWDIAMON.YellowDiamondType_GrowUp:
               _loc4_.GrowUpGiftBagState = _loc6_;
               break;
            case CONST_YELLOWDIAMON.YellowDiamondType_Level:
               _loc4_.LevelGiftBagState = _loc6_;
         }
      }
      
      public function UnstreamizationPerform_UpdateYellowDiamondGiftBagState(param1:ByteArray, param2:Object, param3:Object) : void
      {
         this.UnstreamizationPerform_UpdateYellowDiamondGiftBagState_Perform(param1,param2,param3);
      }
   }
}

