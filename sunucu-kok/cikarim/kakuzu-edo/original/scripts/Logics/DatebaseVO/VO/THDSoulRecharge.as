package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class THDSoulRecharge extends THDActivityBase
   {
      
      protected var FRecharge:Vector.<Object>;
      
      public function THDSoulRecharge()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         super.ResourcesSpace::ReadDataByStream(param1);
         this.FRecharge = Vector.<Object>(Json.decode(TUtilityString.FetchUTF(param1)));
      }
      
      public function get Recharge() : Vector.<Object>
      {
         return this.FRecharge;
      }
   }
}

