package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.TDatebaseVO;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class TBlockPoint extends TDatebaseVO
   {
      
      protected var FName:String;
      
      protected var FCoordinate:String;
      
      protected var FCoordinateVect:Vector.<Number>;
      
      protected var FCampaign:uint;
      
      protected var FLast:int;
      
      protected var FIsBoss:int;
      
      protected var FShowPrev:int;
      
      protected var FSpirit:int;
      
      protected var FLevel:int;
      
      protected var FNextPoint:int;
      
      protected var FArmys:Vector.<uint>;
      
      protected var FArmy:String;
      
      protected var FRoleModel:int;
      
      protected var FStartAward:int;
      
      protected var FShowRateAward:String;
      
      protected var FShowRateAwardVect:Vector.<uint>;
      
      protected var FPopTipIds:Vector.<Array>;
      
      protected var FPop:String;
      
      protected var FBattleScene:int;
      
      protected var FGuidePoint:Vector.<Array>;
      
      public function TBlockPoint()
      {
         super();
         this.FShowRateAwardVect = new Vector.<uint>();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Array = null;
         var _loc5_:Object = null;
         var _loc6_:Vector.<int> = null;
         var _loc7_:String = null;
         this.FName = TUtilityString.FetchUTF(param1);
         this.FCoordinate = TUtilityString.FetchUTF(param1);
         _loc5_ = Json.decode(this.FCoordinate);
         this.FCoordinateVect = Vector.<Number>(_loc5_.coordinate);
         this.FSpirit = param1.readUnsignedInt();
         this.FCampaign = param1.readUnsignedInt();
         this.FLast = param1.readUnsignedInt();
         this.FIsBoss = param1.readUnsignedInt();
         this.FShowPrev = param1.readUnsignedInt();
         this.FNextPoint = param1.readUnsignedInt();
         this.FLevel = param1.readUnsignedInt();
         this.FArmy = TUtilityString.FetchUTF(param1);
         _loc5_ = Json.decode(this.FArmy);
         this.FArmys = Vector.<uint>(_loc5_.army);
         this.FRoleModel = param1.readUnsignedInt();
         this.FStartAward = param1.readUnsignedInt();
         this.FShowRateAward = TUtilityString.FetchUTF(param1);
         _loc4_ = Json.decode(this.FShowRateAward);
         _loc3_ = int(_loc4_.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FShowRateAwardVect.push(_loc4_[_loc2_]);
            _loc2_++;
         }
         this.FPop = TUtilityString.FetchUTF(param1);
         _loc4_ = Json.decode(this.FPop);
         this.FPopTipIds = Vector.<Array>(_loc4_);
         this.FBattleScene = param1.readUnsignedInt();
         _loc7_ = TUtilityString.FetchUTF(param1);
         _loc4_ = Json.decode(_loc7_);
         this.FGuidePoint = Vector.<Array>(_loc4_);
      }
      
      public function get Name() : String
      {
         return this.FName;
      }
      
      public function get Last() : int
      {
         return this.FLast;
      }
      
      public function get Campaign() : uint
      {
         return this.FCampaign;
      }
      
      public function get Level() : int
      {
         return this.FLevel;
      }
      
      public function get NextPoint() : int
      {
         return this.FNextPoint;
      }
      
      public function get PopTipIds() : Vector.<Array>
      {
         return this.FPopTipIds;
      }
      
      public function get Armys() : Vector.<uint>
      {
         return this.FArmys;
      }
      
      public function get Army() : String
      {
         return this.FArmy;
      }
      
      public function get Pop() : String
      {
         return this.FPop;
      }
      
      public function get Coordinate() : String
      {
         return this.FCoordinate;
      }
      
      public function get CoordinateVect() : Vector.<Number>
      {
         return this.FCoordinateVect;
      }
      
      public function get IsBoss() : int
      {
         return this.FIsBoss;
      }
      
      public function get ShowPrev() : int
      {
         return this.FShowPrev;
      }
      
      public function get Spirit() : int
      {
         return this.FSpirit;
      }
      
      public function get RoleModel() : int
      {
         return this.FRoleModel;
      }
      
      public function get StartAward() : int
      {
         return this.FStartAward;
      }
      
      public function get ShowRateAward() : String
      {
         return this.FShowRateAward;
      }
      
      public function get ShowRateAwardVect() : Vector.<uint>
      {
         return this.FShowRateAwardVect;
      }
      
      public function get BattleScene() : int
      {
         return this.FBattleScene;
      }
      
      public function get GuidePoint() : Vector.<Array>
      {
         return this.FGuidePoint;
      }
   }
}

