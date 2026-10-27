package Logics.GeneralStar
{
   import Foundation.Common.TEntity;
   import Logics.Spaces.LogicsSpace;
   
   use namespace LogicsSpace;
   
   public class TEsotericPoint extends TEntity
   {
      
      protected var FIsSkill:int;
      
      protected var FLevelLimit:int;
      
      protected var FPointName:String;
      
      protected var FNeedFetch:int;
      
      protected var FMapNum:int;
      
      protected var FPointIndex:int;
      
      protected var FType:Vector.<uint>;
      
      protected var FTarget:Vector.<uint>;
      
      protected var FValue:Vector.<Number>;
      
      protected var FDesc:String;
      
      public function TEsotericPoint(param1:uint)
      {
         super(param1);
      }
      
      LogicsSpace function Coerce(param1:uint) : void
      {
         FIdentifier = param1;
      }
      
      public function get IsSkill() : int
      {
         return this.FIsSkill;
      }
      
      public function set IsSkill(param1:int) : void
      {
         this.FIsSkill = param1;
      }
      
      public function get LevelLimit() : int
      {
         return this.FLevelLimit;
      }
      
      public function set LevelLimit(param1:int) : void
      {
         this.FLevelLimit = param1;
      }
      
      public function get PointName() : String
      {
         return this.FPointName;
      }
      
      public function set PointName(param1:String) : void
      {
         this.FPointName = param1;
      }
      
      public function get NeedFetch() : int
      {
         return this.FNeedFetch;
      }
      
      public function set NeedFetch(param1:int) : void
      {
         this.FNeedFetch = param1;
      }
      
      public function get Type() : Vector.<uint>
      {
         return this.FType;
      }
      
      public function set Type(param1:Vector.<uint>) : void
      {
         this.FType = param1;
      }
      
      public function get Target() : Vector.<uint>
      {
         return this.FTarget;
      }
      
      public function set Target(param1:Vector.<uint>) : void
      {
         this.FTarget = param1;
      }
      
      public function get Value() : Vector.<Number>
      {
         return this.FValue;
      }
      
      public function set Value(param1:Vector.<Number>) : void
      {
         this.FValue = param1;
      }
      
      public function get MapNum() : int
      {
         return this.FMapNum;
      }
      
      public function set MapNum(param1:int) : void
      {
         this.FMapNum = param1;
      }
      
      public function get PointIndex() : int
      {
         return this.FPointIndex;
      }
      
      public function set PointIndex(param1:int) : void
      {
         this.FPointIndex = param1;
      }
      
      public function get Desc() : String
      {
         return this.FDesc;
      }
      
      public function set Desc(param1:String) : void
      {
         this.FDesc = param1;
      }
   }
}

