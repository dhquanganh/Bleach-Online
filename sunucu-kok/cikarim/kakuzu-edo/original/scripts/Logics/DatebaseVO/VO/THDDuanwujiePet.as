package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class THDDuanwujiePet extends THDActivityBase
   {
      
      protected var FFund:Vector.<Object>;
      
      protected var FFundGift:Object;
      
      protected var FZongziId:uint;
      
      protected var FServerZongziId:uint;
      
      protected var FPet:Object;
      
      protected var FZongZiGift:Object;
      
      protected var FMall:Vector.<Object>;
      
      protected var FText:String;
      
      public function THDDuanwujiePet()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:Object = null;
         super.ResourcesSpace::ReadDataByStream(param1);
         this.FFund = Vector.<Object>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FFundGift = Json.decode(TUtilityString.FetchUTF(param1));
         this.FZongziId = param1.readUnsignedInt();
         this.FServerZongziId = param1.readUnsignedInt();
         this.FPet = Json.decode(TUtilityString.FetchUTF(param1));
         this.FZongZiGift = Json.decode(TUtilityString.FetchUTF(param1));
         this.FMall = Vector.<Object>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FText = param1.readUTF();
      }
      
      public function get Fund() : Vector.<Object>
      {
         return this.FFund;
      }
      
      public function get FundGift() : Object
      {
         return this.FFundGift;
      }
      
      public function get ZongziId() : uint
      {
         return this.FZongziId;
      }
      
      public function get ServerZongziId() : uint
      {
         return this.FServerZongziId;
      }
      
      public function get Pet() : Object
      {
         return this.FPet;
      }
      
      public function get ZongZiGift() : Object
      {
         return this.FZongZiGift;
      }
      
      public function get Mall() : Vector.<Object>
      {
         return this.FMall;
      }
      
      public function get Text() : String
      {
         this.FText = this.FText.replace("\"","");
         this.FText = this.FText.replace("\"","");
         return this.FText;
      }
   }
}

