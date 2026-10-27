package Logics.Streamization.HyperStrings
{
   import Debugging.*;
   import Foundation.Utilities.*;
   import Logics.HyperStrings.*;
   import Logics.HyperStrings.Elements.*;
   import Logics.HyperStrings.RTTIs.*;
   import Logics.Streamization.HyperStrings.Common.*;
   import Logics.Streamization.HyperStrings.Elements.*;
   import Logics.Streamization.HyperStrings.RTTIs.*;
   import Resources.RTTIs.*;
   import flash.utils.*;
   
   public class TStreamizerHyperString extends TStreamizerHyperStringUnknown
   {
      
      protected static var FRTTIElement:TRTTIHyperStringElement;
      
      protected static var FRTTIStreamizer:TRTTIStreamizerHyperStringElement;
      
      protected static const ELEMENTCLASS_Text:uint = RTTI_HYPERSTRING.ELEMENTCLASS_Text;
      
      ConstructRTTIs();
      
      protected var FStreamizers:Vector.<TStreamizerHyperStringElement>;
      
      protected var FStreamElement:ByteArray;
      
      public function TStreamizerHyperString()
      {
         super();
         this.ConstructStreamizers();
         this.FStreamElement = new ByteArray();
      }
      
      protected static function ConstructRTTIs() : void
      {
         FRTTIElement = new TRTTIHyperStringElement();
         FRTTIStreamizer = new TRTTIStreamizerHyperStringElement();
      }
      
      protected function ConstructStreamizers() : void
      {
         var _loc1_:int = 0;
         _loc1_ = FRTTIStreamizer.Count;
         this.FStreamizers = new Vector.<TStreamizerHyperStringElement>(_loc1_);
      }
      
      protected function StreamizerByIdentifier(param1:uint) : TStreamizerHyperStringElement
      {
         var _loc2_:TStreamizerHyperStringElement = null;
         var _loc3_:int = 0;
         var _loc4_:Class = null;
         _loc3_ = FRTTIStreamizer.GetIndexByIdentifier(param1);
         if(_loc3_ < 0)
         {
            return null;
         }
         _loc2_ = this.FStreamizers[_loc3_];
         if(_loc2_ == null)
         {
            _loc4_ = FRTTIStreamizer.GetClassByIndex(_loc3_);
            _loc2_ = new _loc4_();
            this.FStreamizers[_loc3_] = _loc2_;
         }
         return _loc2_;
      }
      
      override protected function StreamizationPerform(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:THyperString = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:THyperStringElement = null;
         var _loc10_:Boolean = false;
         var _loc11_:int = 0;
         _loc4_ = param2 as THyperString;
         _loc5_ = int(param1.position);
         _loc11_ = 0;
         param1.writeByte(0);
         _loc7_ = _loc4_.Count;
         _loc8_ = 0;
         while(_loc8_ < _loc7_)
         {
            _loc9_ = _loc4_.GetElementByIndex(_loc8_);
            _loc10_ = this.StreamizationPerform_Element(param1,_loc9_,param3);
            if(_loc10_)
            {
               _loc11_++;
            }
            _loc8_++;
         }
         _loc6_ = int(param1.position);
         param1.position = _loc5_;
         param1.writeByte(_loc11_);
         param1.position = _loc6_;
      }
      
      protected function StreamizationPerform_Element(param1:ByteArray, param2:Object, param3:Object) : Boolean
      {
         var _loc4_:THyperStringElement = null;
         var _loc5_:int = 0;
         var _loc6_:uint = 0;
         var _loc7_:TStreamizerHyperStringElement = null;
         _loc4_ = param2 as THyperStringElement;
         _loc5_ = FRTTIElement.GetIndexByInstance(_loc4_);
         if(_loc5_ < 0)
         {
            return false;
         }
         _loc6_ = FRTTIElement.GetIdentifierByIndex(_loc5_);
         _loc7_ = this.StreamizerByIdentifier(_loc6_);
         if(_loc7_ == null)
         {
            return false;
         }
         this.FStreamElement.length = 0;
         _loc7_.Streamize(this.FStreamElement,_loc4_,param3);
         param1.writeByte(_loc6_);
         if(_loc6_ != ELEMENTCLASS_Text)
         {
            param1.writeShort(this.FStreamElement.length);
         }
         param1.writeBytes(this.FStreamElement);
         this.FStreamElement.clear();
         return true;
      }
   }
}

