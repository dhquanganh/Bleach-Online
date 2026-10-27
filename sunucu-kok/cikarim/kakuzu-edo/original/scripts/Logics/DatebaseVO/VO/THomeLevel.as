package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.*;
   import Foundation.Utilities.*;
   import Logics.DatebaseVO.*;
   import Logics.DatebaseVO.VO.Json.*;
   import flash.utils.*;
   import ghostcat.util.data.*;
   
   use namespace ResourcesSpace;
   
   public class THomeLevel extends TDatebaseVO
   {
      
      protected var FLevel:uint;
      
      protected var FName:String;
      
      protected var FQuality:uint;
      
      protected var FViewImgID:uint;
      
      protected var FMainImgID:uint;
      
      protected var FFloatingIslandPointLeftID:uint;
      
      protected var FFloatingIslandPointRightID:uint;
      
      protected var FUpgradeCondition:TFixedAward;
      
      protected var FAddLevelText:String;
      
      protected var FMaxGirlFriendLevel:uint;
      
      protected var FMyMonsterCount:uint;
      
      protected var FFriendMonsterCount:uint;
      
      protected var FQualityMonster:uint;
      
      protected var FLuckyCatCount:uint;
      
      protected var FGambleCount:uint;
      
      protected var FMaxMyGirlfriendInteractive:uint;
      
      protected var FGirlfriendInteractiveCount:uint;
      
      protected var FGirlfriendBeInteractiveCount:uint;
      
      public function THomeLevel()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:String = null;
         var _loc3_:Object = null;
         this.FLevel = param1.readInt();
         this.FName = TUtilityString.FetchUTF(param1);
         this.FQuality = param1.readInt();
         this.FViewImgID = param1.readUnsignedInt();
         this.FMainImgID = param1.readUnsignedInt();
         this.FFloatingIslandPointLeftID = param1.readUnsignedInt();
         this.FFloatingIslandPointRightID = param1.readUnsignedInt();
         _loc2_ = TUtilityString.FetchUTF(param1);
         _loc3_ = Json.decode(_loc2_);
         this.FUpgradeCondition = new TFixedAward(_loc3_[0]);
         this.FAddLevelText = TUtilityString.FetchUTF(param1);
         this.FMaxGirlFriendLevel = param1.readUnsignedInt();
         this.FMyMonsterCount = param1.readUnsignedInt();
         this.FFriendMonsterCount = param1.readUnsignedInt();
         this.FQualityMonster = param1.readUnsignedInt();
         this.FLuckyCatCount = param1.readUnsignedInt();
         this.FGambleCount = param1.readUnsignedInt();
         this.FMaxMyGirlfriendInteractive = param1.readUnsignedInt();
         this.FGirlfriendInteractiveCount = param1.readUnsignedInt();
         this.FGirlfriendBeInteractiveCount = param1.readUnsignedInt();
      }
      
      public function get Level() : uint
      {
         return this.FLevel;
      }
      
      public function get Name() : String
      {
         return this.FName;
      }
      
      public function get Quality() : uint
      {
         return this.FQuality;
      }
      
      public function get ViewImgID() : uint
      {
         return this.FViewImgID;
      }
      
      public function get MainImgID() : uint
      {
         return this.FMainImgID;
      }
      
      public function get FloatingIslandPointLeftID() : uint
      {
         return this.FFloatingIslandPointLeftID;
      }
      
      public function get FloatingIslandPointRightID() : uint
      {
         return this.FFloatingIslandPointRightID;
      }
      
      public function get UpgradeCondition() : TFixedAward
      {
         return this.FUpgradeCondition;
      }
      
      public function get AddLevelText() : String
      {
         return this.FAddLevelText;
      }
      
      public function get MaxGirlFriendLevel() : uint
      {
         return this.FMaxGirlFriendLevel;
      }
      
      public function get MyMonsterCount() : uint
      {
         return this.FMyMonsterCount;
      }
      
      public function get FriendMonsterCount() : uint
      {
         return this.FFriendMonsterCount;
      }
      
      public function get QualityMonster() : uint
      {
         return this.FQualityMonster;
      }
      
      public function get LuckyCatCount() : uint
      {
         return this.FLuckyCatCount;
      }
      
      public function get GambleCount() : uint
      {
         return this.FGambleCount;
      }
      
      public function get MaxMyGirlfriendInteractive() : uint
      {
         return this.FMaxMyGirlfriendInteractive;
      }
      
      public function get GirlfriendInteractiveCount() : uint
      {
         return this.FGirlfriendInteractiveCount;
      }
      
      public function get GirlfriendBeInteractiveCount() : uint
      {
         return this.FGirlfriendBeInteractiveCount;
      }
   }
}

