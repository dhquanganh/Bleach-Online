package Logics.Rooms.Seat.Player.Hero
{
   import Foundation.Collections.*;
   
   public class TCollectionHero extends TCollectionInstance
   {
      
      protected var FValidated:Vector.<Boolean>;
      
      public function TCollectionHero(param1:int)
      {
         super(param1);
         this.FValidated = new Vector.<Boolean>(param1);
      }
      
      override protected function InstanceReplace(param1:int, param2:Object) : void
      {
         var _loc3_:Object = null;
         var _loc4_:THero = null;
         _loc3_ = FInstances[param1];
         if(_loc3_ != null)
         {
            _loc4_ = _loc3_ as THero;
            _loc4_ = null;
         }
         FInstances[param1] = param2;
      }
      
      public function GetHeroByIndex(param1:int) : THero
      {
         return FInstances[param1] as THero;
      }
      
      public function SetHeroByIndex(param1:int, param2:THero) : void
      {
         this.InstanceReplace(param1,param2);
      }
      
      public function GetValidatedByIndex(param1:int) : Boolean
      {
         return this.FValidated[param1];
      }
      
      public function SetValidatedByIndex(param1:int, param2:Boolean) : void
      {
         this.FValidated[param1] = param2;
      }
      
      override public function Clear() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc1_ = FCapacity;
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            this.InstanceReplace(_loc2_,null);
            this.FValidated[_loc2_] = false;
            _loc2_++;
         }
      }
      
      public function GetHeroByIdentifier(param1:uint) : THero
      {
         var _loc2_:int = 0;
         var _loc3_:THero = null;
         _loc2_ = 0;
         while(_loc2_ < FCapacity)
         {
            _loc3_ = FInstances[_loc2_] as THero;
            if(_loc3_ != null)
            {
               if(_loc3_.Identifier == param1)
               {
                  return _loc3_;
               }
            }
            _loc2_++;
         }
         return null;
      }
      
      public function GetIndexByIdentifier(param1:uint) : int
      {
         var _loc2_:int = 0;
         var _loc3_:THero = null;
         _loc2_ = 0;
         while(_loc2_ < FCapacity)
         {
            _loc3_ = FInstances[_loc2_] as THero;
            if(_loc3_ != null)
            {
               if(_loc3_.Identifier == param1)
               {
                  return _loc2_;
               }
            }
            _loc2_++;
         }
         return -1;
      }
      
      public function GetIndexByHero(param1:THero) : int
      {
         return FInstances.indexOf(param1);
      }
   }
}

