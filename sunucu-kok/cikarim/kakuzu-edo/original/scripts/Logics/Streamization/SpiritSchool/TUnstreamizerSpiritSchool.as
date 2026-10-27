package Logics.Streamization.SpiritSchool
{
   import Foundation.Resources.SResourcesCore;
   import Foundation.Streamization.TUnstreamizer;
   import Logics.DatebaseVO.VO.TSpiritSchoolExp;
   import Logics.SpiritSchool.TSpiritSchoolData;
   import Resources.Constants.CONST_DATEBASEVO;
   import flash.utils.ByteArray;
   
   public class TUnstreamizerSpiritSchool extends TUnstreamizer
   {
      
      public static const BASEID:uint = 18300000;
      
      public static const STATUS_DONE:int = -1;
      
      public static const STATUS_NOW:int = 1;
      
      public static const STATUS_NEXT:int = 0;
      
      protected var FNowLv:uint;
      
      public function TUnstreamizerSpiritSchool()
      {
         super();
      }
      
      private function UnstreamizationPerform_UpdateSpiritSchoolInfo(param1:Object, param2:Object) : void
      {
         var _loc3_:ByteArray = null;
         var _loc4_:TSpiritSchoolData = null;
         var _loc5_:TSpiritSchoolExp = null;
         var _loc6_:TSpiritSchoolExp = null;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         var _loc10_:uint = 0;
         var _loc11_:uint = 0;
         var _loc12_:uint = 0;
         var _loc13_:uint = 0;
         _loc3_ = param1 as ByteArray;
         _loc4_ = param2 as TSpiritSchoolData;
         _loc11_ = _loc3_.readUnsignedInt();
         _loc9_ = _loc3_.readUnsignedInt();
         _loc10_ = _loc3_.readUnsignedInt();
         _loc5_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_SpiritSchoolExp,_loc11_) as TSpiritSchoolExp;
         _loc6_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_SpiritSchoolExp,_loc11_ + 1) as TSpiritSchoolExp;
         _loc12_ = _loc5_.MonsterLevel + 1;
         _loc13_ = (_loc5_.MonsterId - BASEID) / 1000 - 1;
         if(_loc12_ == 500)
         {
            _loc8_ = _loc4_.SsItems.length;
            _loc7_ = 0;
            while(_loc7_ < _loc8_)
            {
               _loc4_.SsItems[_loc7_].EffectName = this.GetNameById(_loc7_);
               _loc4_.SsItems[_loc7_].AddValue = this.GetAddValueById(_loc7_,500);
               _loc4_.SsItems[_loc7_].AddValueNext = this.GetNextAddValueById(_loc7_,500);
               _loc4_.SsItems[_loc7_].NowLv = _loc12_;
               _loc4_.SsItems[_loc7_].NowExp = _loc5_.NeedExp;
               _loc4_.SsItems[_loc7_].ExpMax = _loc5_.NeedExp;
               _loc4_.SsItems[_loc7_].Status = STATUS_DONE;
               _loc7_++;
            }
            _loc4_.NowLv = _loc12_ - 1;
            _loc4_.IsOver = 1;
            return;
         }
         _loc4_.NowLv = _loc12_;
         this.FNowLv = _loc4_.NowLv;
         _loc4_.FreeNum = _loc10_;
         _loc8_ = _loc4_.SsItems.length;
         _loc7_ = 0;
         while(_loc7_ < _loc8_)
         {
            _loc4_.SsItems[_loc7_].EffectName = this.GetNameById(_loc7_);
            if(_loc7_ < _loc13_)
            {
               _loc4_.SsItems[_loc7_].AddValue = this.GetAddValueById(_loc7_,_loc12_);
               _loc4_.SsItems[_loc7_].AddValueNext = this.GetNextAddValueById(_loc7_,_loc12_);
               _loc4_.SsItems[_loc7_].NowLv = _loc12_;
               _loc4_.SsItems[_loc7_].NowExp = _loc5_.NeedExp;
               _loc4_.SsItems[_loc7_].ExpMax = _loc5_.NeedExp;
               _loc4_.SsItems[_loc7_].Status = STATUS_DONE;
            }
            if(_loc7_ == _loc13_)
            {
               _loc4_.SsItems[_loc7_].AddValue = this.GetAddValueById(_loc7_,_loc12_ - 1 > 0 ? uint(_loc12_ - 1) : 0);
               _loc4_.SsItems[_loc7_].AddValueNext = this.GetNextAddValueById(_loc7_,_loc12_ - 1 > 0 ? uint(_loc12_ - 1) : 0);
               _loc4_.SsItems[_loc7_].NowLv = _loc12_ - 1 > 0 ? uint(_loc12_ - 1) : 0;
               _loc4_.SsItems[_loc7_].NowExp = _loc9_;
               _loc4_.SsItems[_loc7_].ExpMax = _loc5_.NeedExp;
               _loc4_.SsItems[_loc7_].Status = STATUS_NOW;
            }
            if(_loc7_ > _loc13_)
            {
               _loc4_.SsItems[_loc7_].AddValue = this.GetAddValueById(_loc7_,_loc12_ - 1 > 0 ? uint(_loc12_ - 1) : 0);
               _loc4_.SsItems[_loc7_].AddValueNext = this.GetNextAddValueById(_loc7_,_loc12_ - 1 > 0 ? uint(_loc12_ - 1) : 0);
               _loc4_.SsItems[_loc7_].NowLv = _loc12_ - 1 > 0 ? uint(_loc12_ - 1) : 0;
               _loc4_.SsItems[_loc7_].NowExp = 0;
               _loc4_.SsItems[_loc7_].ExpMax = _loc5_.NeedExp;
               _loc4_.SsItems[_loc7_].Status = STATUS_NEXT;
            }
            _loc7_++;
         }
      }
      
      private function UnstreamizationPerform_UpdateAllItem(param1:Object, param2:Object) : void
      {
         var _loc3_:ByteArray = null;
         var _loc4_:TSpiritSchoolData = null;
         var _loc5_:TSpiritSchoolExp = null;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         var _loc10_:uint = 0;
         var _loc11_:uint = 0;
         var _loc12_:uint = 0;
         _loc3_ = param1 as ByteArray;
         _loc4_ = param2 as TSpiritSchoolData;
         _loc10_ = _loc3_.readUnsignedInt();
         _loc8_ = _loc3_.readUnsignedInt();
         _loc9_ = _loc3_.readUnsignedInt();
         _loc5_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_SpiritSchoolExp,_loc10_) as TSpiritSchoolExp;
         _loc11_ = _loc5_.MonsterLevel + 1;
         _loc12_ = (_loc5_.MonsterId - BASEID) / 1000 - 1;
         if(_loc11_ == 500)
         {
            _loc7_ = _loc4_.SsItems.length;
            _loc6_ = 0;
            while(_loc6_ < _loc7_)
            {
               _loc4_.SsItems[_loc6_].EffectName = this.GetNameById(_loc6_);
               _loc4_.SsItems[_loc6_].AddValue = this.GetAddValueById(_loc6_,500);
               _loc4_.SsItems[_loc6_].AddValueNext = this.GetNextAddValueById(_loc6_,500);
               _loc4_.SsItems[_loc6_].NowLv = _loc11_;
               _loc4_.SsItems[_loc6_].NowExp = _loc5_.NeedExp;
               _loc4_.SsItems[_loc6_].ExpMax = _loc5_.NeedExp;
               _loc4_.SsItems[_loc6_].Status = STATUS_DONE;
               _loc6_++;
            }
            _loc4_.NowLv = _loc11_ - 1;
            _loc4_.IsOver = 1;
            return;
         }
         _loc7_ = _loc4_.SsItems.length;
         _loc6_ = 0;
         while(_loc6_ < _loc7_)
         {
            _loc4_.SsItems[_loc6_].EffectName = this.GetNameById(_loc6_);
            if(_loc6_ < _loc12_)
            {
               _loc4_.SsItems[_loc6_].AddValue = this.GetAddValueById(_loc6_,_loc11_);
               _loc4_.SsItems[_loc6_].AddValueNext = this.GetNextAddValueById(_loc6_,_loc11_);
               _loc4_.SsItems[_loc6_].NowLv = _loc11_;
               _loc4_.SsItems[_loc6_].NowExp = _loc5_.NeedExp;
               _loc4_.SsItems[_loc6_].ExpMax = _loc5_.NeedExp;
               _loc4_.SsItems[_loc6_].Status = STATUS_DONE;
            }
            if(_loc6_ == _loc12_)
            {
               _loc4_.SsItems[_loc6_].AddValue = this.GetAddValueById(_loc6_,_loc11_ - 1 > 0 ? uint(_loc11_ - 1) : 0);
               _loc4_.SsItems[_loc6_].AddValueNext = this.GetNextAddValueById(_loc6_,_loc11_ - 1 > 0 ? uint(_loc11_ - 1) : 0);
               _loc4_.SsItems[_loc6_].NowLv = _loc11_ - 1 > 0 ? uint(_loc11_ - 1) : 0;
               _loc4_.SsItems[_loc6_].NowExp = _loc8_;
               _loc4_.SsItems[_loc6_].ExpMax = _loc5_.NeedExp;
               _loc4_.SsItems[_loc6_].Status = STATUS_NOW;
            }
            if(_loc6_ > _loc12_)
            {
               _loc4_.SsItems[_loc6_].AddValue = this.GetAddValueById(_loc6_,_loc11_ - 1 > 0 ? uint(_loc11_ - 1) : 0);
               _loc4_.SsItems[_loc6_].AddValueNext = this.GetNextAddValueById(_loc6_,_loc11_ - 1 > 0 ? uint(_loc11_ - 1) : 0);
               _loc4_.SsItems[_loc6_].NowLv = _loc11_ - 1 > 0 ? uint(_loc11_ - 1) : 0;
               _loc4_.SsItems[_loc6_].NowExp = 0;
               _loc4_.SsItems[_loc6_].ExpMax = _loc5_.NeedExp;
               _loc4_.SsItems[_loc6_].Status = STATUS_NEXT;
            }
            _loc6_++;
         }
         _loc4_.NowLv = _loc11_;
         this.FNowLv = _loc4_.NowLv;
         _loc4_.FreeNum = _loc9_;
      }
      
      protected function GetNameById(param1:uint) : String
      {
         var _loc2_:TSpiritSchoolExp = null;
         var _loc3_:uint = 0;
         _loc3_ = (param1 + 1) * 1000 + BASEID + 1;
         _loc2_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_SpiritSchoolExp,_loc3_) as TSpiritSchoolExp;
         return _loc2_.EffectName;
      }
      
      protected function GetAddValueById(param1:uint, param2:uint) : uint
      {
         var _loc3_:TSpiritSchoolExp = null;
         var _loc4_:uint = 0;
         _loc4_ = (param1 + 1) * 1000 + BASEID + param2 + 1;
         _loc3_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_SpiritSchoolExp,_loc4_) as TSpiritSchoolExp;
         return _loc3_.AddType;
      }
      
      protected function GetNextAddValueById(param1:uint, param2:uint) : uint
      {
         var _loc3_:TSpiritSchoolExp = null;
         var _loc4_:uint = 0;
         _loc4_ = (param1 + 1) * 1000 + BASEID + param2 + 2;
         _loc3_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_SpiritSchoolExp,_loc4_) as TSpiritSchoolExp;
         if(_loc3_ == null)
         {
            return 0;
         }
         return _loc3_.AddType;
      }
      
      protected function GetNext2AddValueById(param1:uint) : uint
      {
         var _loc2_:TSpiritSchoolExp = null;
         var _loc3_:uint = 0;
         _loc3_ = (param1 + 1) * 1000 + BASEID + this.FNowLv + 3;
         _loc2_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_SpiritSchoolExp,_loc3_) as TSpiritSchoolExp;
         if(_loc2_ == null)
         {
            return 0;
         }
         return _loc2_.AddType;
      }
      
      public function UnstreamizeUpdateSpiritSchoolInfo(param1:Object, param2:Object) : void
      {
         this.UnstreamizationPerform_UpdateSpiritSchoolInfo(param1,param2);
      }
      
      public function UnstreamizeUpdateAllItem(param1:Object, param2:Object) : void
      {
         this.UnstreamizationPerform_UpdateAllItem(param1,param2);
      }
   }
}

