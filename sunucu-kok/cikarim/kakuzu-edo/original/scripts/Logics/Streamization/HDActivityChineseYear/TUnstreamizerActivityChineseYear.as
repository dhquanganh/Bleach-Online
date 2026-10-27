package Logics.Streamization.HDActivityChineseYear
{
   import Foundation.Streamization.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.HDActivityChineseYear.*;
   import Logics.HDActivityChineseYear.ActivityLukia.*;
   import Logics.HDActivityMode.*;
   
   public class TUnstreamizerActivityChineseYear extends TUnstreamizer
   {
      
      public function TUnstreamizerActivityChineseYear()
      {
         super();
      }
      
      protected function UnstreamizationPerform_UpdateChineseYearSignIn(param1:Object, param2:Object, param3:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TActivityChineseYearSignIn = null;
         var _loc7_:THDChineseYearSignIn = null;
         var _loc8_:TActivityInitRetData = null;
         var _loc9_:Vector.<THDBoxStateData> = null;
         _loc8_ = param1 as TActivityInitRetData;
         _loc6_ = param2 as TActivityChineseYearSignIn;
         _loc7_ = param3 as THDChineseYearSignIn;
         _loc5_ = int(_loc7_.DateSigns.length);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc6_.Add(_loc7_.DateSigns[_loc4_]);
            _loc4_++;
         }
         _loc9_ = _loc8_.AwardStates;
         _loc5_ = int(_loc9_.length);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc6_.SetSignStatusByUniqueIndex(_loc9_[_loc4_].BoxIndex,_loc9_[_loc4_].State);
            _loc4_++;
         }
      }
      
      protected function UnstreamizationPerform_UpdateChineseYearLukia(param1:Object, param2:Object, param3:Object) : void
      {
         var _loc4_:TActivityInitRetData = null;
         var _loc5_:TActivityLukiaTotalInfor = null;
         var _loc6_:THDChineseYearLukia = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:Vector.<THDBoxStateData> = null;
         _loc4_ = param1 as TActivityInitRetData;
         _loc5_ = param2 as TActivityLukiaTotalInfor;
         _loc6_ = param3 as THDChineseYearLukia;
         _loc5_.ActivitySuperBag = _loc6_.ActivitySuperBag;
         _loc5_.ActivityNiceBag = _loc6_.ActivityNiceBag;
         _loc5_.ActivityExchangeBag = _loc6_.ActivityExchangeBag;
         _loc5_.ActivityLukia = _loc6_.ActivityLukia;
         _loc5_.ActivityLukiaChip = _loc6_.ActivityLukiaChip;
         _loc9_ = _loc4_.AwardStates;
         _loc8_ = int(_loc9_.length);
         _loc7_ = 0;
         while(_loc7_ < _loc8_)
         {
            _loc5_.FlushActivityData(_loc9_[_loc7_].BoxIndex,_loc9_[_loc7_].State);
            _loc7_++;
         }
         _loc9_ = _loc4_.BuyStates;
         _loc8_ = int(_loc9_.length);
         _loc7_ = 0;
         while(_loc7_ < _loc8_)
         {
            _loc5_.FlushActivityData(_loc9_[_loc7_].BoxIndex,_loc9_[_loc7_].State);
            _loc7_++;
         }
         _loc9_ = _loc4_.ShowOnlyStates;
         _loc8_ = int(_loc9_.length);
         _loc7_ = 0;
         while(_loc7_ < _loc8_)
         {
            _loc5_.FlushActivityData(_loc9_[_loc7_].BoxIndex,_loc9_[_loc7_].State);
            _loc7_++;
         }
      }
      
      protected function UnstreamizationPerform_UpdateChineseYearLion(param1:Object, param2:Object, param3:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TActivityChineseYearLion = null;
         var _loc7_:THDNewYearEgg = null;
         var _loc8_:TActivityInitRetData = null;
         var _loc9_:Vector.<THDBoxStateData> = null;
         var _loc10_:Vector.<THDBoxStateData> = null;
         _loc8_ = param1 as TActivityInitRetData;
         _loc6_ = param2 as TActivityChineseYearLion;
         _loc7_ = param3 as THDNewYearEgg;
         _loc5_ = int(_loc7_.LionList.length);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc6_.Add(_loc7_.LionList[_loc4_]);
            _loc4_++;
         }
         _loc9_ = _loc8_.AwardStates;
         _loc5_ = int(_loc9_.length);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc6_.SetAwardStatusByUniqueIndex(_loc9_[_loc4_].BoxIndex,_loc9_[_loc4_].State);
            _loc4_++;
         }
         _loc10_ = _loc8_.BuyStates;
         _loc5_ = int(_loc10_.length);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc6_.SetAwardStatusByUniqueIndex(_loc10_[_loc4_].BoxIndex,_loc10_[_loc4_].State);
            _loc4_++;
         }
         _loc6_.CurDay = _loc8_.ParameterVec[0];
      }
      
      public function UnstreamizeUpdateChineseYearSignIn(param1:Object, param2:Object, param3:Object) : void
      {
         this.UnstreamizationPerform_UpdateChineseYearSignIn(param1,param2,param3);
      }
      
      public function UnstreamizeUpdateChineseYearLukia(param1:Object, param2:Object, param3:Object) : void
      {
         this.UnstreamizationPerform_UpdateChineseYearLukia(param1,param2,param3);
      }
      
      public function UnstreamizeUpdateChineseYearLion(param1:Object, param2:Object, param3:Object) : void
      {
         this.UnstreamizationPerform_UpdateChineseYearLion(param1,param2,param3);
      }
   }
}

