package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class THDNewServerDraw extends THDActivityBase
   {
      
      protected var FRecharge:Object;
      
      protected var FGiftIndexs:Vector.<Object>;
      
      protected var FStudIndex:uint;
      
      protected var FDoubleIndex:Vector.<uint>;
      
      public function THDNewServerDraw()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         super.ResourcesSpace::ReadDataByStream(param1);
         this.FRecharge = Json.decode(TUtilityString.FetchUTF(param1));
         this.FGiftIndexs = Vector.<Object>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FStudIndex = param1.readUnsignedInt();
         this.FDoubleIndex = Vector.<uint>(Json.decode(TUtilityString.FetchUTF(param1)));
      }
      
      public function get Recharge() : Object
      {
         return this.FRecharge;
      }
      
      public function get GiftIndexs() : Vector.<Object>
      {
         return this.FGiftIndexs;
      }
      
      public function get StudIndex() : uint
      {
         return this.FStudIndex;
      }
      
      public function get DoubleIndex() : Vector.<uint>
      {
         return this.FDoubleIndex;
      }
   }
}

