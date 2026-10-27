package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.TDatebaseVO;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class TRaidersDailyConfig extends TDatebaseVO
   {
      
      protected var FLevel:int;
      
      protected var FNextHard:uint;
      
      protected var FHeroVect:Vector.<int>;
      
      protected var FEnemyArmy:Vector.<uint>;
      
      protected var FRaiderAwards:Vector.<uint>;
      
      protected var FName:String;
      
      protected var FPicPath:int;
      
      protected var FBgPath:int;
      
      protected var FHeros:String;
      
      protected var FEnemyId:String;
      
      protected var FRaiderAward:String;
      
      public function TRaidersDailyConfig()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:String = null;
         var _loc3_:Object = null;
         var _loc4_:Array = null;
         this.FLevel = param1.readUnsignedInt();
         this.FNextHard = param1.readUnsignedInt();
         this.FHeros = TUtilityString.FetchUTF(param1);
         _loc3_ = Json.decode(this.FHeros);
         _loc4_ = _loc3_.hero;
         this.FHeroVect = Vector.<int>(_loc4_);
         this.FEnemyId = TUtilityString.FetchUTF(param1);
         _loc3_ = Json.decode(this.FEnemyId);
         _loc4_ = _loc3_.army;
         this.FEnemyArmy = Vector.<uint>(_loc4_);
         this.FRaiderAward = TUtilityString.FetchUTF(param1);
         _loc3_ = Json.decode(this.FRaiderAward);
         _loc4_ = _loc3_.award;
         this.FRaiderAwards = Vector.<uint>(_loc4_);
         this.FName = TUtilityString.FetchUTF(param1);
         this.FPicPath = param1.readUnsignedInt();
         this.FBgPath = param1.readUnsignedInt();
      }
      
      public function get Level() : int
      {
         return this.FLevel;
      }
      
      public function get NextHard() : uint
      {
         return this.FNextHard;
      }
      
      public function get HeroVect() : Vector.<int>
      {
         return this.FHeroVect;
      }
      
      public function get EnemyArmy() : Vector.<uint>
      {
         return this.FEnemyArmy;
      }
      
      public function get RaiderAwards() : Vector.<uint>
      {
         return this.FRaiderAwards;
      }
      
      public function get Name() : String
      {
         return this.FName;
      }
      
      public function get PicPath() : int
      {
         return this.FPicPath;
      }
      
      public function get EnemyId() : String
      {
         return this.FEnemyId;
      }
      
      public function get RaiderAward() : String
      {
         return this.FRaiderAward;
      }
      
      public function get Heros() : String
      {
         return this.FHeros;
      }
      
      public function get BgPath() : int
      {
         return this.FBgPath;
      }
   }
}

