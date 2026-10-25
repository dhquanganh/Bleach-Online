package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.TDatebaseVO;
   import Logics.DatebaseVO.VO.Json.TFixedAward;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class TLeagueMapPve extends TDatebaseVO
   {
      
      protected var FName:String;
      
      protected var FDesc:String;
      
      protected var FSortIndex:uint;
      
      protected var FOpenLevel:uint;
      
      protected var FRecommendLevel:uint;
      
      protected var FSuitableLevel:String;
      
      protected var FMapID:uint;
      
      protected var FImageID:uint;
      
      protected var FAwards:Vector.<uint>;
      
      protected var FFriendBuff:TFixedAward;
      
      protected var FOrganizationBuff:TFixedAward;
      
      protected var FAddInfor:Vector.<int>;
      
      public function TLeagueMapPve()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:Array = null;
         var _loc6_:String = null;
         var _loc7_:Object = null;
         this.FName = TUtilityString.FetchUTF(param1);
         this.FDesc = TUtilityString.FetchUTF(param1);
         this.FSortIndex = param1.readInt();
         this.FOpenLevel = param1.readInt();
         this.FRecommendLevel = param1.readInt();
         _loc4_ = TUtilityString.FetchUTF(param1);
         _loc5_ = _loc4_.split("-");
         this.FSuitableLevel = _loc5_[0] + "~" + _loc5_[1];
         this.FMapID = param1.readUnsignedInt();
         this.FImageID = param1.readUnsignedInt();
         _loc4_ = TUtilityString.FetchUTF(param1);
         _loc5_ = Json.decode(_loc4_);
         _loc3_ = int(_loc5_.length);
         this.FAwards = new Vector.<uint>(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FAwards[_loc2_] = _loc5_[_loc2_];
            _loc2_++;
         }
         _loc6_ = TUtilityString.FetchUTF(param1);
         _loc7_ = Json.decode(_loc6_);
         this.FFriendBuff = new TFixedAward(_loc7_[0]);
         _loc6_ = TUtilityString.FetchUTF(param1);
         _loc7_ = Json.decode(_loc6_);
         this.FOrganizationBuff = new TFixedAward(_loc7_[0]);
         _loc6_ = TUtilityString.FetchUTF(param1);
         _loc5_ = Json.decode(_loc6_);
         this.FAddInfor = Vector.<int>(_loc5_);
      }
      
      public function get Name() : String
      {
         return this.FName;
      }
      
      public function get Desc() : String
      {
         return this.FDesc;
      }
      
      public function get SortIndex() : uint
      {
         return this.FSortIndex;
      }
      
      public function get OpenLevel() : uint
      {
         return this.FOpenLevel;
      }
      
      public function get RecommendLevel() : uint
      {
         return this.FRecommendLevel;
      }
      
      public function get SuitableLevel() : String
      {
         return this.FSuitableLevel;
      }
      
      public function get MapID() : uint
      {
         return this.FMapID;
      }
      
      public function get ImageID() : uint
      {
         return this.FImageID;
      }
      
      public function get Awards() : Vector.<uint>
      {
         return this.FAwards;
      }
      
      public function get FriendBuff() : TFixedAward
      {
         return this.FFriendBuff;
      }
      
      public function get OrganizationBuff() : TFixedAward
      {
         return this.FOrganizationBuff;
      }
      
      public function get AddInfor() : Vector.<int>
      {
         return this.FAddInfor;
      }
   }
}

