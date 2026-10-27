package Logics.HyperStrings
{
   import Foundation.Pools.*;
   import Foundation.UI.*;
   import Logics.HyperStrings.Atoms.*;
   import Logics.HyperStrings.Elements.*;
   import Logics.HyperStrings.RTTIs.*;
   import Resources.RTTIs.*;
   
   public class TPoolHyperString extends TPoolAutomatic
   {
      
      protected static var FRTTIElement:TRTTIHyperStringElement;
      
      ConstructRTTIs();
      
      protected var FIndexHyperString:int;
      
      protected var FIndexAtomTextual:int;
      
      protected var FIndexAtomGraphical:int;
      
      protected var FIndexAtomMonolithic:int;
      
      protected var FIndicesElement:Vector.<int>;
      
      protected var FIndexElementLinkCharacter:int;
      
      protected var FIndexElementInventory:int;
      
      public function TPoolHyperString()
      {
         super();
      }
      
      protected static function ConstructRTTIs() : void
      {
         ConstructRTTIs_HyperStringElement();
      }
      
      protected static function ConstructRTTIs_HyperStringElement() : void
      {
         FRTTIElement = new TRTTIHyperStringElement();
      }
      
      override protected function RegisterClasses() : void
      {
         this.FIndexHyperString = RegisterClass(THyperString,this.ReleasingPerform_HyperString);
         this.RegisterClasses_HyperStringAtoms();
         this.RegisterClasses_HyperStringElements();
      }
      
      protected function RegisterClasses_HyperStringAtoms() : void
      {
         this.FIndexAtomTextual = RegisterClass(THyperStringAtomTextual,this.ReleasingPerform_HyperStringAtom);
         this.FIndexAtomGraphical = RegisterClass(THyperStringAtomGraphical,this.ReleasingPerform_HyperStringAtom);
         this.FIndexAtomMonolithic = RegisterClass(THyperStringAtomMonolithic,this.ReleasingPerform_HyperStringAtom);
      }
      
      protected function RegisterClasses_HyperStringElements() : void
      {
         this.RegisterClasses_HyperStringElementsRTTIed();
      }
      
      protected function RegisterClasses_HyperStringElementsRTTIed() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Class = null;
         var _loc4_:int = 0;
         _loc1_ = FRTTIElement.Count;
         this.FIndicesElement = new Vector.<int>(_loc1_);
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = FRTTIElement.GetClassByIndex(_loc2_);
            _loc4_ = RegisterClass(_loc3_,this.ReleasingPerform_HyperStringElement);
            this.FIndicesElement[_loc2_] = _loc4_;
            _loc2_++;
         }
      }
      
      protected function ReleasingPerform_HyperString(param1:Object) : void
      {
         var _loc2_:THyperString = null;
         _loc2_ = param1 as THyperString;
         _loc2_.Clear();
      }
      
      protected function ReleasingPerform_HyperStringAtom(param1:Object) : void
      {
         var _loc2_:THyperStringAtom = null;
         _loc2_ = param1 as THyperStringAtom;
         _loc2_.Reset();
      }
      
      protected function ReleasingPerform_HyperStringElement(param1:Object) : void
      {
         var _loc2_:THyperStringElement = null;
         _loc2_ = param1 as THyperStringElement;
         _loc2_.Reset();
      }
      
      public function AcquireHyperString() : THyperString
      {
         var _loc1_:THyperString = null;
         _loc1_ = InstanceAcquireByIndex(this.FIndexHyperString) as THyperString;
         if(_loc1_ == null)
         {
            _loc1_ = new THyperString();
         }
         FStubsReferences.push(_loc1_.StubReferences);
         return _loc1_;
      }
      
      public function AcquireAtomTextual(param1:TUIComponent) : THyperStringAtomTextual
      {
         var _loc2_:THyperStringAtomTextual = null;
         _loc2_ = InstanceAcquireByIndex(this.FIndexAtomTextual) as THyperStringAtomTextual;
         if(_loc2_ == null)
         {
            _loc2_ = new THyperStringAtomTextual(param1);
         }
         else
         {
            param1.addChild(_loc2_);
         }
         FStubsReferences.push(_loc2_.StubReferences);
         return _loc2_;
      }
      
      public function AcquireAtomGraphical(param1:TUIComponent) : THyperStringAtomGraphical
      {
         var _loc2_:THyperStringAtomGraphical = null;
         _loc2_ = InstanceAcquireByIndex(this.FIndexAtomGraphical) as THyperStringAtomGraphical;
         if(_loc2_ == null)
         {
            _loc2_ = new THyperStringAtomGraphical(param1);
         }
         else
         {
            param1.addChild(_loc2_);
         }
         FStubsReferences.push(_loc2_.StubReferences);
         return _loc2_;
      }
      
      public function AcquireAtomMonolithic(param1:TUIComponent) : THyperStringAtomMonolithic
      {
         var _loc2_:THyperStringAtomMonolithic = null;
         _loc2_ = InstanceAcquireByIndex(this.FIndexAtomMonolithic) as THyperStringAtomMonolithic;
         if(_loc2_ == null)
         {
            _loc2_ = new THyperStringAtomMonolithic(param1);
         }
         else
         {
            param1.addChild(_loc2_);
         }
         FStubsReferences.push(_loc2_.StubReferences);
         return _loc2_;
      }
      
      public function AcquireElementByIdentifier(param1:uint) : THyperStringElement
      {
         var _loc2_:THyperStringElement = null;
         var _loc3_:int = 0;
         var _loc4_:Class = null;
         var _loc5_:int = 0;
         _loc3_ = FRTTIElement.GetIndexByIdentifier(param1);
         if(_loc3_ < 0)
         {
            return null;
         }
         _loc5_ = this.FIndicesElement[_loc3_];
         _loc2_ = InstanceAcquireByIndex(_loc5_) as THyperStringElement;
         if(_loc2_ == null)
         {
            _loc4_ = FRTTIElement.GetClassByIndex(_loc3_);
            _loc2_ = new _loc4_();
         }
         FStubsReferences.push(_loc2_.StubReferences);
         return _loc2_;
      }
      
      public function AcquireElementText() : THyperStringElementText
      {
         var _loc1_:THyperStringElementText = null;
         return this.AcquireElementByIdentifier(RTTI_HYPERSTRING.ELEMENTCLASS_Text) as THyperStringElementText;
      }
      
      public function AcquireElementLinkCharacter() : THyperStringElementLinkCharacter
      {
         var _loc1_:THyperStringElementLinkCharacter = null;
         return this.AcquireElementByIdentifier(RTTI_HYPERSTRING.ELEMENTCLASS_LinkCharacter) as THyperStringElementLinkCharacter;
      }
      
      public function AcquireElementLinkEvent() : THyperStringElementLinkEvent
      {
         var _loc1_:THyperStringElementLinkEvent = null;
         return this.AcquireElementByIdentifier(RTTI_HYPERSTRING.ELEMENTCLASS_LinkEvent) as THyperStringElementLinkEvent;
      }
      
      public function AcquireElementLinkHero() : THyperStringElementLinkHero
      {
         var _loc1_:THyperStringElementLinkHero = null;
         return this.AcquireElementByIdentifier(RTTI_HYPERSTRING.ELEMENTCLASS_LinkHero) as THyperStringElementLinkHero;
      }
      
      public function AcquireElementLinkItem() : THyperStringElementLinkItem
      {
         var _loc1_:THyperStringElementLinkItem = null;
         return this.AcquireElementByIdentifier(RTTI_HYPERSTRING.ELEMENTCLASS_LinkItem) as THyperStringElementLinkItem;
      }
      
      public function AcquireElementLinkURL() : THyperStringElementLinkURL
      {
         var _loc1_:THyperStringElementLinkURL = null;
         return this.AcquireElementByIdentifier(RTTI_HYPERSTRING.ELEMENTCLASS_LinkURL) as THyperStringElementLinkURL;
      }
      
      public function AcquireElementIcon() : THyperStringElementIcon
      {
         var _loc1_:THyperStringElementIcon = null;
         return this.AcquireElementByIdentifier(RTTI_HYPERSTRING.ELEMENTCLASS_Icon) as THyperStringElementIcon;
      }
      
      public function AcquireElementInventory() : THyperStringElementInventory
      {
         var _loc1_:THyperStringElementInventory = null;
         return this.AcquireElementByIdentifier(RTTI_HYPERSTRING.ELEMENTCLASS_LinkInventory) as THyperStringElementInventory;
      }
   }
}

