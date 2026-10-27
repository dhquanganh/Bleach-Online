package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.TDatebaseVO;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class THomeGirlFriend extends TDatebaseVO
   {
      
      protected var FImageID:uint;
      
      protected var FLevel:int;
      
      protected var FName:String;
      
      protected var FLevelUpArticalID:int;
      
      protected var FLevelUpArticalNum:int;
      
      protected var FDescription:String;
      
      protected var FHomeLevelLimit:int;
      
      protected var FMackTofuNum:int;
      
      protected var FMackTofuCDTime:int;
      
      protected var FMakeTofuAwardNum:int;
      
      protected var FSpriteCommunicateNum:int;
      
      protected var FNomalSpriteCommunicateCost:int;
      
      protected var FGoldSpriteCommunicateCost:int;
      
      protected var FSpriteCommunicateCDTime:int;
      
      public function THomeGirlFriend()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:String = null;
         var _loc3_:Object = null;
         this.FImageID = param1.readUnsignedInt();
         this.FLevel = param1.readInt();
         this.FName = TUtilityString.FetchUTF(param1);
         _loc2_ = TUtilityString.FetchUTF(param1);
         _loc3_ = Json.decode(_loc2_);
         if(_loc3_.length != 0)
         {
            this.FLevelUpArticalID = _loc3_[0].code;
            this.FLevelUpArticalNum = _loc3_[0].amount;
         }
         this.FDescription = TUtilityString.FetchUTF(param1);
         this.FHomeLevelLimit = param1.readInt();
         this.FMackTofuNum = param1.readInt();
         this.FMackTofuCDTime = param1.readInt();
         _loc2_ = TUtilityString.FetchUTF(param1);
         _loc3_ = Json.decode(_loc2_);
         this.FMakeTofuAwardNum = _loc3_[0].amount;
         this.FSpriteCommunicateNum = param1.readInt();
         _loc2_ = TUtilityString.FetchUTF(param1);
         _loc3_ = Json.decode(_loc2_);
         this.FNomalSpriteCommunicateCost = _loc3_[0].amount;
         _loc2_ = TUtilityString.FetchUTF(param1);
         _loc3_ = Json.decode(_loc2_);
         this.FGoldSpriteCommunicateCost = _loc3_[0].amount;
         this.FSpriteCommunicateCDTime = param1.readInt();
      }
      
      public function get ImageID() : uint
      {
         return this.FImageID;
      }
      
      public function get Level() : int
      {
         return this.FLevel;
      }
      
      public function get Name() : String
      {
         return this.FName;
      }
      
      public function get LevelUpArticalID() : int
      {
         return this.FLevelUpArticalID;
      }
      
      public function get LevelUpArticalNum() : int
      {
         return this.FLevelUpArticalNum;
      }
      
      public function get Description() : String
      {
         return this.FDescription;
      }
      
      public function get HomeLevelLimit() : int
      {
         return this.FHomeLevelLimit;
      }
      
      public function get MackTofuNum() : int
      {
         return this.FMackTofuNum;
      }
      
      public function get MackTofuCDTime() : int
      {
         return this.FMackTofuCDTime;
      }
      
      public function get SpriteCommunicateNum() : int
      {
         return this.FSpriteCommunicateNum;
      }
      
      public function get NomalSpriteCommunicateCost() : int
      {
         return this.FNomalSpriteCommunicateCost;
      }
      
      public function get GoldSpriteCommunicateCost() : int
      {
         return this.FGoldSpriteCommunicateCost;
      }
      
      public function get SpriteCommunicateCDTime() : int
      {
         return this.FSpriteCommunicateCDTime;
      }
      
      public function get MakeTofuAwardNum() : int
      {
         return this.FMakeTofuAwardNum;
      }
   }
}

