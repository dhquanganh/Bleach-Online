package Logics.HDActivityMode
{
   import Foundation.Common.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Bins.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.Streamization.Inventories.*;
   import Resources.Constants.*;
   
   public class TActivityModes
   {
      
      protected var FActivityModes:Vector.<TActivityAtoms>;
      
      public function TActivityModes()
      {
         super();
         this.FActivityModes = new Vector.<TActivityAtoms>();
      }
      
      protected function SortMount(param1:TActivityAtoms, param2:TActivityAtoms) : int
      {
         if(param1.IconLocation < param2.IconLocation)
         {
            return -1;
         }
         return 1;
      }
      
      public function get Count() : int
      {
         return this.FActivityModes.length;
      }
      
      public function GetActivityAtomsByIndex(param1:int) : TActivityAtoms
      {
         return this.FActivityModes[param1];
      }
      
      public function GetActivityAtomsByActivityID(param1:uint) : TActivityAtoms
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TActivityAtoms = null;
         _loc3_ = int(this.FActivityModes.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = this.FActivityModes[_loc2_];
            if(_loc4_.ActivityID == param1)
            {
               return _loc4_;
            }
            _loc2_++;
         }
         return null;
      }
      
      public function GetActivityAtomsByIdentifier(param1:uint) : TActivityAtoms
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TActivityAtoms = null;
         _loc2_ = int(this.FActivityModes.length);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = this.FActivityModes[_loc3_];
            if(_loc4_.Identifier == param1)
            {
               return _loc4_;
            }
            _loc3_++;
         }
         return null;
      }
      
      public function Add(param1:TActivityAtoms) : void
      {
         this.FActivityModes.push(param1);
      }
      
      public function Delete(param1:int) : void
      {
         var _loc2_:TActivityAtoms = null;
         _loc2_ = this.FActivityModes[param1];
         this.FActivityModes.splice(param1,1);
      }
      
      public function DeleteByIdentifier(param1:uint) : void
      {
         var _loc2_:TActivityAtoms = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _loc3_ = 0;
         while(_loc3_ < this.FActivityModes.length)
         {
            if(param1 == this.FActivityModes[_loc3_].Identifier)
            {
               this.FActivityModes.splice(_loc3_,1);
            }
            _loc3_++;
         }
      }
      
      public function Clear() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc1_ = int(this.FActivityModes.length);
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            this.FActivityModes.pop();
            _loc2_++;
         }
         this.FActivityModes.length = 0;
      }
      
      public function Sort() : void
      {
      }
      
      public function GetActivityAtomsByMainType(param1:uint) : Vector.<TActivityAtoms>
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Vector.<TActivityAtoms> = null;
         var _loc5_:TActivityAtoms = null;
         _loc3_ = this.Count;
         _loc4_ = new Vector.<TActivityAtoms>();
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc5_ = this.GetActivityAtomsByIndex(_loc2_);
            if(param1 == _loc5_.MainType)
            {
               _loc4_.push(_loc5_);
            }
            _loc2_++;
         }
         return _loc4_;
      }
   }
}

