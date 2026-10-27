package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class THDBrushHappy extends THDActivityBase
   {
      
      protected var FItemIndexs:Vector.<uint>;
      
      protected var FItems:Vector.<Object>;
      
      protected var FRefresh:Vector.<uint>;
      
      protected var FDiscount:Vector.<Object>;
      
      protected var FReset:Object;
      
      protected var FGift:Vector.<Object>;
      
      protected var FGiftIndex:uint;
      
      protected var FRareGoods:uint;
      
      protected var FGiftDesc:String;
      
      public function THDBrushHappy()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         super.ResourcesSpace::ReadDataByStream(param1);
         this.FItemIndexs = Vector.<uint>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FItems = Vector.<Object>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FRefresh = Vector.<uint>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FDiscount = Vector.<Object>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FReset = Json.decode(TUtilityString.FetchUTF(param1));
         this.FGift = Vector.<Object>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FGiftIndex = param1.readUnsignedInt();
         this.FRareGoods = param1.readUnsignedInt();
         this.FGiftDesc = TUtilityString.FetchUTF(param1);
      }
      
      public function get ItemIndexs() : Vector.<uint>
      {
         return this.FItemIndexs;
      }
      
      public function get Items() : Vector.<Object>
      {
         return this.FItems;
      }
      
      public function get Refresh() : Vector.<uint>
      {
         return this.FRefresh;
      }
      
      public function get Discount() : Vector.<Object>
      {
         return this.FDiscount;
      }
      
      public function get Reset() : Object
      {
         return this.FReset;
      }
      
      public function get Gift() : Vector.<Object>
      {
         return this.FGift;
      }
      
      public function get GiftIndex() : uint
      {
         return this.FGiftIndex;
      }
      
      public function get RareGoods() : uint
      {
         return this.FRareGoods;
      }
      
      public function get GiftDesc() : String
      {
         return this.FGiftDesc;
      }
   }
}

