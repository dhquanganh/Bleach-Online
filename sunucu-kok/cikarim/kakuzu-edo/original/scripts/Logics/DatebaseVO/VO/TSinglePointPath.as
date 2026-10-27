package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.TDatebaseVO;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class TSinglePointPath extends TDatebaseVO
   {
      
      protected var FName:String;
      
      protected var FArmys:Vector.<uint>;
      
      protected var FShowRateAward:String;
      
      protected var FShowRateAwardVect:Vector.<uint>;
      
      protected var FNextPoint:int;
      
      protected var FCoordinate:String;
      
      protected var FCoordinateVect:Vector.<Number>;
      
      protected var FRoleModel:int;
      
      protected var FArmy:String;
      
      protected var FBattleScene:int;
      
      protected var FGuidePoint:Vector.<Array>;
      
      public function TSinglePointPath()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:Object = null;
         var _loc6_:Array = null;
         var _loc7_:String = null;
         this.FName = TUtilityString.FetchUTF(param1);
         this.FArmy = TUtilityString.FetchUTF(param1);
         _loc5_ = Json.decode(this.FArmy);
         _loc6_ = _loc5_.army;
         this.FArmys = Vector.<uint>(_loc6_);
         this.FRoleModel = param1.readUnsignedInt();
         this.FShowRateAward = TUtilityString.FetchUTF(param1);
         _loc5_ = Json.decode(this.FShowRateAward);
         _loc6_ = _loc5_ as Array;
         _loc3_ = int(_loc6_.length);
         this.FShowRateAwardVect = new Vector.<uint>(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FShowRateAwardVect[_loc2_] = _loc6_[_loc2_] as uint;
            _loc2_++;
         }
         this.FNextPoint = param1.readUnsignedInt();
         this.FCoordinate = TUtilityString.FetchUTF(param1);
         _loc5_ = Json.decode(this.FCoordinate);
         _loc6_ = _loc5_.coordinate;
         _loc3_ = int(_loc6_.length);
         this.FCoordinateVect = new Vector.<Number>(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FCoordinateVect[_loc2_] = _loc6_[_loc2_] as Number;
            _loc2_++;
         }
         this.FBattleScene = param1.readUnsignedInt();
         _loc7_ = TUtilityString.FetchUTF(param1);
         _loc6_ = Json.decode(_loc7_);
         this.FGuidePoint = Vector.<Array>(_loc6_);
      }
      
      public function get Armys() : Vector.<uint>
      {
         return this.FArmys;
      }
      
      public function get Army() : String
      {
         return this.FArmy;
      }
      
      public function get ShowRateAward() : String
      {
         return this.FShowRateAward;
      }
      
      public function get ShowRateAwardVect() : Vector.<uint>
      {
         return this.FShowRateAwardVect;
      }
      
      public function get NextPoint() : int
      {
         return this.FNextPoint;
      }
      
      public function get Coordinate() : String
      {
         return this.FCoordinate;
      }
      
      public function get RoleModel() : int
      {
         return this.FRoleModel;
      }
      
      public function get CoordinateVect() : Vector.<Number>
      {
         return this.FCoordinateVect;
      }
      
      public function get BattleScene() : int
      {
         return this.FBattleScene;
      }
      
      public function get GuidePoint() : Vector.<Array>
      {
         return this.FGuidePoint;
      }
      
      public function get Name() : String
      {
         return this.FName;
      }
   }
}

