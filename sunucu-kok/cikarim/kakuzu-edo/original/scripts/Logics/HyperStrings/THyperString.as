package Logics.HyperStrings
{
   import Foundation.Common.Stubs.*;
   import Logics.HyperStrings.Elements.*;
   
   public class THyperString
   {
      
      protected var FStubReferences:TStubReferences;
      
      protected var FElements:Vector.<THyperStringElement>;
      
      public function THyperString()
      {
         super();
         this.FStubReferences = new TStubReferences(this);
         this.FElements = new Vector.<THyperStringElement>();
      }
      
      public function get StubReferences() : TStubReferences
      {
         return this.FStubReferences;
      }
      
      public function get Count() : int
      {
         return this.FElements.length;
      }
      
      public function GetElementByIndex(param1:int) : THyperStringElement
      {
         return this.FElements[param1];
      }
      
      public function Clear() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:THyperStringElement = null;
         _loc1_ = int(this.FElements.length);
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = this.FElements[_loc2_];
            _loc3_.StubReferences.Dereference(this);
            _loc2_++;
         }
         this.FElements.length = 0;
      }
      
      public function Add(param1:THyperStringElement) : void
      {
         param1.StubReferences.Reference(this);
         this.FElements.push(param1);
      }
      
      public function Insert(param1:int, param2:THyperStringElement) : void
      {
         param2.StubReferences.Reference(this);
         this.FElements.splice(param1,0,param2);
      }
      
      public function Delete(param1:int) : void
      {
         var _loc2_:THyperStringElement = null;
         if(param1 == 0)
         {
            _loc2_ = this.FElements.shift();
         }
         else
         {
            _loc2_ = this.FElements.splice(param1,1)[0];
         }
         _loc2_.StubReferences.Dereference(this);
      }
   }
}

