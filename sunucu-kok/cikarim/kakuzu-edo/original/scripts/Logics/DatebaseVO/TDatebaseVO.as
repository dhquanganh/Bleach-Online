package Logics.DatebaseVO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import flash.utils.ByteArray;
   
   use namespace ResourcesSpace;
   
   public class TDatebaseVO
   {
      
      protected var FIdentifier:int;
      
      protected var FResourceID:uint;
      
      public function TDatebaseVO()
      {
         super();
      }
      
      ResourcesSpace function Coerce(param1:uint) : void
      {
         this.FIdentifier = param1;
      }
      
      ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
      }
      
      public function get Identifier() : int
      {
         return this.FIdentifier;
      }
      
      public function get ResourceID() : uint
      {
         return this.FResourceID;
      }
      
      public function set ResourceID(param1:uint) : void
      {
         this.FResourceID = param1;
      }
      
      public function Clear() : void
      {
      }
   }
}

