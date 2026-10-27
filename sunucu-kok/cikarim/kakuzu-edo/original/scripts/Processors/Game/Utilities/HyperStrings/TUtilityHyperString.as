package Processors.Game.Utilities.HyperStrings
{
   import Foundation.Utilities.TUtilityRTTI;
   import Logics.HyperStrings.Elements.THyperStringElement;
   import Logics.HyperStrings.Elements.THyperStringElementIcon;
   import Logics.HyperStrings.Elements.THyperStringElementInventory;
   import Logics.HyperStrings.Elements.THyperStringElementLinkCharacter;
   import Logics.HyperStrings.Elements.THyperStringElementLinkEvent;
   import Logics.HyperStrings.Elements.THyperStringElementLinkHero;
   import Logics.HyperStrings.Elements.THyperStringElementLinkItem;
   import Logics.HyperStrings.Elements.THyperStringElementLinkURL;
   import Logics.HyperStrings.Elements.THyperStringElementText;
   import Logics.HyperStrings.THyperString;
   import Logics.HyperStrings.TPoolHyperString;
   import Logics.SLogicsCore;
   
   public class TUtilityHyperString
   {
      
      protected var FPoolHyperString:TPoolHyperString;
      
      public function TUtilityHyperString()
      {
         super();
         this.FPoolHyperString = SLogicsCore.PoolHyperString;
      }
      
      protected function HyperStringElementsAssign(param1:THyperString, param2:THyperString) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:THyperStringElement = null;
         var _loc6_:THyperStringElement = null;
         param2.Clear();
         _loc4_ = param1.Count;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc5_ = param1.GetElementByIndex(_loc3_);
            _loc6_ = this.HyperStringElementAssign(_loc5_);
            if(_loc6_ != null)
            {
               param2.Add(_loc6_);
            }
            _loc3_++;
         }
      }
      
      protected function HyperStringElementAssign(param1:THyperStringElement) : THyperStringElement
      {
         var _loc2_:Class = null;
         var _loc3_:THyperStringElement = null;
         _loc2_ = TUtilityRTTI.GetClassByInstance(param1);
         switch(_loc2_)
         {
            case THyperStringElementText:
               _loc3_ = this.FPoolHyperString.AcquireElementText();
               break;
            case THyperStringElementIcon:
               _loc3_ = this.FPoolHyperString.AcquireElementIcon();
               break;
            case THyperStringElementLinkItem:
               break;
            case THyperStringElementLinkCharacter:
               _loc3_ = this.FPoolHyperString.AcquireElementLinkCharacter();
               break;
            case THyperStringElementLinkURL:
            case THyperStringElementInventory:
            case THyperStringElementLinkHero:
            case THyperStringElementLinkEvent:
         }
         if(_loc3_ != null)
         {
            param1.FlushElement(_loc3_);
         }
         return _loc3_;
      }
      
      public function CopyHyperString(param1:THyperString, param2:THyperString) : void
      {
         this.HyperStringElementsAssign(param1,param2);
      }
      
      public function CloneHyperString(param1:THyperStringElement) : THyperStringElement
      {
         return this.HyperStringElementAssign(param1);
      }
   }
}

