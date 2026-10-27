package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.TDatebaseVO;
   import Logics.DatebaseVO.VO.Json.*;
   import Processors.Game.Common.Effects.ListAutoScroll.IListAutoScrollDataRender;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class TCompanionCard extends TDatebaseVO implements IListAutoScrollDataRender
   {
      
      protected var FName:String;
      
      protected var FLevel:int;
      
      protected var FBeginStar:int;
      
      protected var FChipId:int;
      
      protected var FChipCount:int;
      
      protected var FExchangeCount:int;
      
      protected var FBaseProperties:Vector.<TCompanionProperty>;
      
      protected var FLeaderProperties:Vector.<TCompanionProperty>;
      
      protected var FTeamworkId:int;
      
      protected var FTeamProperties:Vector.<TCompanionProperty>;
      
      protected var FPicture:int;
      
      protected var FBigPicture:int;
      
      protected var FQuality:int;
      
      protected var FNextId:int;
      
      public function TCompanionCard()
      {
         super();
         this.FBaseProperties = new Vector.<TCompanionProperty>();
         this.FLeaderProperties = new Vector.<TCompanionProperty>();
         this.FTeamProperties = new Vector.<TCompanionProperty>();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:String = null;
         var _loc3_:Object = null;
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         this.FName = TUtilityString.FetchUTF(param1);
         this.FLevel = param1.readUnsignedInt();
         this.FBeginStar = param1.readUnsignedInt();
         this.FChipId = param1.readUnsignedInt();
         this.FChipCount = param1.readUnsignedInt();
         this.FExchangeCount = param1.readUnsignedInt();
         _loc2_ = TUtilityString.FetchUTF(param1);
         _loc4_ = Json.decode(_loc2_) as Array;
         _loc5_ = 0;
         while(_loc5_ < _loc4_.length)
         {
            this.FBaseProperties.push(new TCompanionProperty(_loc4_[_loc5_]));
            _loc5_++;
         }
         _loc2_ = TUtilityString.FetchUTF(param1);
         _loc4_ = Json.decode(_loc2_) as Array;
         _loc5_ = 0;
         while(_loc5_ < _loc4_.length)
         {
            this.FLeaderProperties.push(new TCompanionProperty(_loc4_[_loc5_]));
            _loc5_++;
         }
         this.FTeamworkId = param1.readUnsignedInt();
         _loc2_ = TUtilityString.FetchUTF(param1);
         _loc4_ = Json.decode(_loc2_) as Array;
         _loc5_ = 0;
         while(_loc5_ < _loc4_.length)
         {
            this.FTeamProperties.push(new TCompanionProperty(_loc4_[_loc5_]));
            _loc5_++;
         }
         this.FPicture = param1.readUnsignedInt();
         this.FBigPicture = param1.readUnsignedInt();
         this.FQuality = param1.readUnsignedInt();
         this.FNextId = param1.readUnsignedInt();
      }
      
      public function get Name() : String
      {
         return this.FName;
      }
      
      public function get Level() : int
      {
         return this.FLevel;
      }
      
      public function get ChipId() : int
      {
         return this.FChipId;
      }
      
      public function get ChipCount() : int
      {
         return this.FChipCount;
      }
      
      public function get ExchangeCount() : int
      {
         return this.FExchangeCount;
      }
      
      public function get BaseProperties() : Vector.<TCompanionProperty>
      {
         return this.FBaseProperties;
      }
      
      public function get LeaderProperties() : Vector.<TCompanionProperty>
      {
         return this.FLeaderProperties;
      }
      
      public function get TeamworkId() : int
      {
         return this.FTeamworkId;
      }
      
      public function get TeamProperties() : Vector.<TCompanionProperty>
      {
         return this.FTeamProperties;
      }
      
      public function get Picture() : int
      {
         return this.FPicture;
      }
      
      public function get Quality() : int
      {
         return this.FQuality;
      }
      
      public function get NextId() : int
      {
         return this.FNextId;
      }
      
      public function get BeginStar() : int
      {
         return this.FBeginStar;
      }
      
      public function set BeginStar(param1:int) : void
      {
         this.FBeginStar = param1;
      }
      
      public function get BigPicture() : int
      {
         return this.FBigPicture;
      }
   }
}

