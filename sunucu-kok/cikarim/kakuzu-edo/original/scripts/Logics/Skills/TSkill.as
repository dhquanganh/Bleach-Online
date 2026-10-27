package Logics.Skills
{
   import Foundation.Common.Stubs.TStubReferences;
   import Foundation.Common.TEntity;
   import Logics.DatebaseVO.VO.Json.TFixedAward;
   import Logics.Spaces.LogicsSpace;
   
   use namespace LogicsSpace;
   
   public class TSkill extends TEntity
   {
      
      protected var FStubReferences:TStubReferences;
      
      protected var FIDTexture:uint;
      
      protected var FName:String;
      
      protected var FDescription:String;
      
      protected var FMounted:Boolean;
      
      protected var FSort:uint;
      
      protected var FLevel:uint;
      
      protected var FIsUnlock:Boolean;
      
      protected var FNextID:uint;
      
      protected var FSkillID:uint;
      
      protected var FNeedItem:TFixedAward;
      
      public function TSkill(param1:uint)
      {
         super(param1);
         this.FStubReferences = new TStubReferences(this);
      }
      
      LogicsSpace function Coerce(param1:uint) : void
      {
         FIdentifier = param1;
      }
      
      public function get StubReferences() : TStubReferences
      {
         return this.FStubReferences;
      }
      
      public function get IDTexture() : uint
      {
         return this.FIDTexture;
      }
      
      public function set IDTexture(param1:uint) : void
      {
         this.FIDTexture = param1;
      }
      
      public function get Name() : String
      {
         return this.FName;
      }
      
      public function set Name(param1:String) : void
      {
         this.FName = param1;
      }
      
      public function get Description() : String
      {
         return this.FDescription;
      }
      
      public function set Description(param1:String) : void
      {
         this.FDescription = param1;
      }
      
      public function get Mounted() : Boolean
      {
         return this.FMounted;
      }
      
      public function set Mounted(param1:Boolean) : void
      {
         this.FMounted = param1;
      }
      
      public function get Sort() : uint
      {
         return this.FSort;
      }
      
      public function set Sort(param1:uint) : void
      {
         this.FSort = param1;
      }
      
      public function get Level() : uint
      {
         return this.FLevel;
      }
      
      public function set Level(param1:uint) : void
      {
         this.FLevel = param1;
      }
      
      public function get IsUnlock() : Boolean
      {
         return this.FIsUnlock;
      }
      
      public function set IsUnlock(param1:Boolean) : void
      {
         this.FIsUnlock = param1;
      }
      
      public function get NextID() : uint
      {
         return this.FNextID;
      }
      
      public function set NextID(param1:uint) : void
      {
         this.FNextID = param1;
      }
      
      public function get NeedItem() : TFixedAward
      {
         return this.FNeedItem;
      }
      
      public function set NeedItem(param1:TFixedAward) : void
      {
         this.FNeedItem = param1;
      }
      
      public function get SkillID() : uint
      {
         return this.FSkillID;
      }
      
      public function set SkillID(param1:uint) : void
      {
         this.FSkillID = param1;
      }
   }
}

