package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class THDNewYear2016Fund extends THDActivityBase
   {
      
      protected var FSpringFund:Vector.<Object>;
      
      protected var FRedBag:Vector.<Object>;
      
      protected var FReChargeIndex:uint;
      
      public function THDNewYear2016Fund()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         super.ResourcesSpace::ReadDataByStream(param1);
         this.FSpringFund = Vector.<Object>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FRedBag = Vector.<Object>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FReChargeIndex = param1.readUnsignedInt();
      }
      
      public function get SpringFund() : Vector.<Object>
      {
         return this.FSpringFund;
      }
      
      public function get RedBag() : Vector.<Object>
      {
         return this.FRedBag;
      }
      
      public function get ReChargeIndex() : uint
      {
         return this.FReChargeIndex;
      }
   }
}

