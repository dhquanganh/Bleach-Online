package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.TDatebaseVO;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class TTavernGrade extends TDatebaseVO
   {
      
      protected var FLevel:uint;
      
      protected var FPage:uint;
      
      protected var FWineLvs:Vector.<int>;
      
      protected var FPayConfigsVect:Object;
      
      protected var FVipsVect:Object;
      
      protected var FPreview:uint;
      
      protected var FTips:String;
      
      protected var FIsTavern:uint;
      
      protected var FWineLv:String;
      
      protected var FPayConfigs:String;
      
      protected var FVips:String;
      
      public function TTavernGrade()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:String = null;
         this.FLevel = param1.readUnsignedInt();
         this.FPage = param1.readUnsignedInt();
         this.FWineLv = TUtilityString.FetchUTF(param1);
         this.FWineLvs = Vector.<int>(Json.decode(this.FWineLv).wineLv);
         this.FPayConfigs = TUtilityString.FetchUTF(param1);
         this.FPayConfigsVect = Json.decode(this.FPayConfigs);
         this.FVips = TUtilityString.FetchUTF(param1);
         this.FVipsVect = Json.decode(this.FVips);
         this.FPreview = param1.readUnsignedInt();
         this.FTips = TUtilityString.FetchUTF(param1);
         this.FIsTavern = param1.readUnsignedInt();
      }
      
      public function get Level() : uint
      {
         return this.FLevel;
      }
      
      public function get Page() : uint
      {
         return this.FPage;
      }
      
      public function get WineLvs() : Vector.<int>
      {
         return this.FWineLvs;
      }
      
      public function get PayConfigsVect() : Object
      {
         return this.FPayConfigsVect;
      }
      
      public function get VipsVect() : Object
      {
         return this.FVipsVect;
      }
      
      public function get Preview() : uint
      {
         return this.FPreview;
      }
      
      public function get Tips() : String
      {
         return this.FTips;
      }
      
      public function get IsTavern() : uint
      {
         return this.FIsTavern;
      }
      
      public function get WineLv() : String
      {
         return this.FWineLv;
      }
      
      public function get PayConfigs() : String
      {
         return this.FPayConfigs;
      }
      
      public function get Vips() : String
      {
         return this.FVips;
      }
   }
}

