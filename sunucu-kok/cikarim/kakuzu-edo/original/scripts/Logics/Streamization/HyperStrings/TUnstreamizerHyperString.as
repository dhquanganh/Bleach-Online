package Logics.Streamization.HyperStrings
{
   import Debugging.*;
   import Logics.HyperStrings.*;
   import Logics.HyperStrings.Elements.*;
   import Logics.HyperStrings.RTTIs.*;
   import Logics.Streamization.HyperStrings.Common.*;
   import Logics.Streamization.HyperStrings.Elements.*;
   import Logics.Streamization.HyperStrings.RTTIs.*;
   import Resources.RTTIs.*;
   import flash.utils.*;
   
   public class TUnstreamizerHyperString extends TUnstreamizerHyperStringUnknown
   {
      
      protected static var FRTTIUnstreamizer:TRTTIUnstreamizerHyperStringElement;
      
      protected static const ELEMENTCLASS_Text:uint = RTTI_HYPERSTRING.ELEMENTCLASS_Text;
      
      ConstructRTTIs();
      
      protected var FUnstreamizers:Vector.<TUnstreamizerHyperStringElement>;
      
      public function TUnstreamizerHyperString()
      {
         super();
         this.ConstructUnstreamizers();
      }
      
      protected static function ConstructRTTIs() : void
      {
         FRTTIUnstreamizer = new TRTTIUnstreamizerHyperStringElement();
      }
      
      protected function ConstructUnstreamizers() : void
      {
         var _loc1_:int = 0;
         _loc1_ = FRTTIUnstreamizer.Count;
         this.FUnstreamizers = new Vector.<TUnstreamizerHyperStringElement>(_loc1_);
      }
      
      protected function UnstreamizerByIdentifier(param1:uint) : TUnstreamizerHyperStringElement
      {
         var _loc2_:TUnstreamizerHyperStringElement = null;
         var _loc3_:int = 0;
         var _loc4_:Class = null;
         _loc3_ = FRTTIUnstreamizer.GetIndexByIdentifier(param1);
         if(_loc3_ < 0)
         {
            return null;
         }
         _loc2_ = this.FUnstreamizers[_loc3_];
         if(_loc2_ == null)
         {
            _loc4_ = FRTTIUnstreamizer.GetClassByIndex(_loc3_);
            _loc2_ = new _loc4_();
            this.FUnstreamizers[_loc3_] = _loc2_;
         }
         return _loc2_;
      }
      
      override protected function UnstreamizationPerform(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:THyperString = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         _loc4_ = param2 as THyperString;
         _loc4_.Clear();
         _loc5_ = param1.readByte();
         _loc6_ = 0;
         while(_loc6_ < _loc5_)
         {
            this.UnstreamizationPerform_Element(param1,_loc4_,param3);
            _loc6_++;
         }
      }
      
      private function UnstreamizationPerform_Element(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:THyperString = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:TUnstreamizerHyperStringElement = null;
         var _loc8_:THyperStringElement = null;
         _loc5_ = param1.readUnsignedByte();
         if(_loc5_ != ELEMENTCLASS_Text)
         {
            _loc6_ = param1.readUnsignedShort();
         }
         _loc7_ = this.UnstreamizerByIdentifier(_loc5_);
         if(_loc7_ == null)
         {
            param1.position += _loc6_;
            return;
         }
         _loc8_ = FPoolHyperString.AcquireElementByIdentifier(_loc5_);
         if(_loc8_ == null)
         {
            param1.position += _loc6_;
            return;
         }
         _loc4_ = param2 as THyperString;
         _loc7_.Unstreamize(param1,_loc8_,param3);
         _loc4_.Add(_loc8_);
      }
      
      public function GetIconElementByID(param1:uint) : THyperStringElement
      {
         return FPoolHyperString.AcquireElementByIdentifier(param1);
      }
   }
}

