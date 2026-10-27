package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.TDatebaseVO;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class TKnifeStrengthen extends TDatebaseVO
   {
      
      protected var FEffectID:Vector.<int>;
      
      protected var FHeros:Vector.<int>;
      
      protected var FAttribute:Vector.<Object>;
      
      public function TKnifeStrengthen()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         this.FEffectID = Vector.<int>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FHeros = Vector.<int>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FAttribute = Vector.<Object>(Json.decode(TUtilityString.FetchUTF(param1)));
      }
      
      public function get Heros() : Vector.<int>
      {
         return this.FHeros;
      }
      
      public function get Attribute() : Vector.<Object>
      {
         return this.FAttribute;
      }
      
      public function get EffectID() : Vector.<int>
      {
         return this.FEffectID;
      }
   }
}

