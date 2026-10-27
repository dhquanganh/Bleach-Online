package Logics.Characters
{
   import Foundation.Pools.TPoolAutomatic;
   import Logics.Spaces.LogicsSpace;
   
   use namespace LogicsSpace;
   
   public class TPoolCharacter extends TPoolAutomatic
   {
      
      protected var FIndexCharacter:int;
      
      protected var FIndexFriendDigest:int;
      
      protected var FIndexDigest:int;
      
      protected var FIndexRoleDigest:int;
      
      protected var FIndexHero:int;
      
      public function TPoolCharacter()
      {
         super();
      }
      
      override protected function RegisterClasses() : void
      {
         this.FIndexCharacter = RegisterClass(TCharacter,this.ReleasingPerform_Character);
         this.FIndexHero = RegisterClass(THero,this.ReleasingPerform_Hero);
         this.FIndexFriendDigest = RegisterClass(TFriendDigest,this.ReleasingPerform_FriendDigest);
         this.FIndexRoleDigest = RegisterClass(TRoleDigest,this.ReleasingPerform_Role);
         this.FIndexDigest = RegisterClass(TDigest,this.ReleasingPerform_Digest);
      }
      
      protected function ReleasingPerform_Character(param1:Object) : void
      {
         var _loc2_:TCharacter = null;
         _loc2_ = param1 as TCharacter;
         _loc2_.Reset();
      }
      
      protected function ReleasingPerform_Hero(param1:Object) : void
      {
         var _loc2_:THero = null;
         _loc2_ = param1 as THero;
         _loc2_.Reset();
      }
      
      protected function ReleasingPerform_FriendDigest(param1:Object) : void
      {
         var _loc2_:TFriendDigest = null;
         _loc2_ = param1 as TFriendDigest;
         _loc2_.Reset();
      }
      
      protected function ReleasingPerform_Role(param1:Object) : void
      {
         var _loc2_:TRoleDigest = null;
         _loc2_ = param1 as TRoleDigest;
         _loc2_.Reset();
      }
      
      protected function ReleasingPerform_Digest(param1:Object) : void
      {
         var _loc2_:TDigest = null;
         _loc2_ = param1 as TDigest;
         _loc2_.Reset();
      }
      
      public function Acquire(param1:uint = 0, param2:uint = 0) : TCharacter
      {
         var _loc3_:TCharacter = null;
         _loc3_ = InstanceAcquireByIndex(this.FIndexCharacter) as TCharacter;
         if(_loc3_ != null)
         {
            _loc3_.Coerce(param1,param2);
         }
         else
         {
            _loc3_ = new TCharacter(param1,param2);
         }
         FStubsReferences.push(_loc3_.StubReferences);
         return _loc3_;
      }
      
      public function AcquireHero(param1:uint = 0) : THero
      {
         var _loc2_:THero = null;
         _loc2_ = InstanceAcquireByIndex(this.FIndexHero) as THero;
         if(_loc2_ != null)
         {
            _loc2_.Coerce(param1);
         }
         else
         {
            _loc2_ = new THero(param1);
         }
         FStubsReferences.push(_loc2_.StubReferences);
         return _loc2_;
      }
      
      public function AcquireRoleDigest(param1:uint = 0, param2:uint = 0) : TRoleDigest
      {
         var _loc3_:TRoleDigest = null;
         _loc3_ = InstanceAcquireByIndex(this.FIndexRoleDigest) as TRoleDigest;
         if(_loc3_ != null)
         {
            _loc3_.Coerce(param1,param2);
         }
         else
         {
            _loc3_ = new TRoleDigest(param1,param2);
         }
         FStubsReferences.push(_loc3_.StubReferences);
         return _loc3_;
      }
      
      public function AcquireFriendDigest(param1:uint = 0, param2:uint = 0) : TFriendDigest
      {
         var _loc3_:TFriendDigest = null;
         _loc3_ = InstanceAcquireByIndex(this.FIndexFriendDigest) as TFriendDigest;
         if(_loc3_ != null)
         {
            _loc3_.Coerce(param1,param2);
         }
         else
         {
            _loc3_ = new TFriendDigest(param1,param2);
         }
         FStubsReferences.push(_loc3_.StubReferences);
         return _loc3_;
      }
      
      public function AcquireDigest(param1:uint = 0, param2:uint = 0) : TDigest
      {
         var _loc3_:TDigest = null;
         _loc3_ = InstanceAcquireByIndex(this.FIndexDigest) as TDigest;
         if(_loc3_ != null)
         {
            _loc3_.Coerce(param1,param2);
         }
         else
         {
            _loc3_ = new TDigest(param1,param2);
         }
         FStubsReferences.push(_loc3_.StubReferences);
         return _loc3_;
      }
   }
}

