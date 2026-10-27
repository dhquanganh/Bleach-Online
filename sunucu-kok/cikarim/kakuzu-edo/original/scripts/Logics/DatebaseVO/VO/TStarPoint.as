package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.TDatebaseVO;
   import Logics.DatebaseVO.VO.Json.TStarPointAddType;
   import flash.utils.ByteArray;
   
   use namespace ResourcesSpace;
   
   public class TStarPoint extends TDatebaseVO
   {
      
      protected var FMapId:int;
      
      protected var FIndex:int;
      
      protected var FIsSkill:int;
      
      protected var FAddType:String;
      
      protected var FNeedFetch:int;
      
      protected var FName:String;
      
      protected var FDesc:String;
      
      protected var FServenStarLevelLimit:int;
      
      protected var FStarPointAddType:TStarPointAddType;
      
      public function TStarPoint()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         this.FMapId = param1.readUnsignedInt();
         this.FIndex = param1.readUnsignedInt();
         this.FIsSkill = param1.readUnsignedInt();
         this.FAddType = TUtilityString.FetchUTF(param1);
         this.FNeedFetch = param1.readUnsignedInt();
         this.FName = TUtilityString.FetchUTF(param1);
         this.FDesc = TUtilityString.FetchUTF(param1);
         this.FServenStarLevelLimit = param1.readUnsignedInt();
         this.FStarPointAddType = new TStarPointAddType(this.FAddType);
      }
      
      public function get MapId() : int
      {
         return this.FMapId;
      }
      
      public function get Index() : int
      {
         return this.FIndex;
      }
      
      public function get IsSkill() : int
      {
         return this.FIsSkill;
      }
      
      public function get AddType() : String
      {
         return this.FAddType;
      }
      
      public function get NeedFetch() : int
      {
         return this.FNeedFetch;
      }
      
      public function get Name() : String
      {
         return this.FName;
      }
      
      public function get Desc() : String
      {
         return this.FDesc;
      }
      
      public function get ServenStarLevelLimit() : int
      {
         return this.FServenStarLevelLimit;
      }
      
      public function get StarPointAddType() : TStarPointAddType
      {
         return this.FStarPointAddType;
      }
   }
}

