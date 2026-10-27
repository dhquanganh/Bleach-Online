package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.TDatebaseVO;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class TSingle extends TDatebaseVO
   {
      
      protected var FName:String;
      
      protected var FHard:String;
      
      protected var FDesc:String;
      
      protected var FLevel:int;
      
      protected var FStartId:uint;
      
      protected var FEndId:uint;
      
      protected var FBigImage:int;
      
      protected var FAwards:Vector.<int>;
      
      protected var FAward:String;
      
      public function TSingle()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:String = null;
         var _loc3_:Object = null;
         this.FName = TUtilityString.FetchUTF(param1);
         this.FHard = TUtilityString.FetchUTF(param1);
         this.FDesc = TUtilityString.FetchUTF(param1);
         this.FLevel = param1.readUnsignedInt();
         this.FStartId = param1.readUnsignedInt();
         this.FEndId = param1.readUnsignedInt();
         this.FBigImage = param1.readUnsignedInt();
         this.FAward = TUtilityString.FetchUTF(param1);
         _loc3_ = Json.decode(this.FAward);
         this.FAwards = Vector.<int>(_loc3_.award);
      }
      
      public function get Name() : String
      {
         return this.FName;
      }
      
      public function get Hard() : String
      {
         return this.FHard;
      }
      
      public function get Desc() : String
      {
         return this.FDesc;
      }
      
      public function get Level() : int
      {
         return this.FLevel;
      }
      
      public function get StartId() : uint
      {
         return this.FStartId;
      }
      
      public function get EndId() : uint
      {
         return this.FEndId;
      }
      
      public function get BigImage() : int
      {
         return this.FBigImage;
      }
      
      public function get Awards() : Vector.<int>
      {
         return this.FAwards;
      }
      
      public function get Award() : String
      {
         return this.FAward;
      }
   }
}

