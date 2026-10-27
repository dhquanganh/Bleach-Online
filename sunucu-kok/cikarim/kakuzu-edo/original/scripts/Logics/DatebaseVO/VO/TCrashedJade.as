package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.TDatebaseVO;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class TCrashedJade extends TDatebaseVO
   {
      
      protected var FAddType:Vector.<int>;
      
      protected var FAddValue:Vector.<Number>;
      
      protected var FLevelExp:int;
      
      protected var FNextID:int;
      
      protected var FCrashedExp:int;
      
      protected var FEffectID:int;
      
      protected var FJadePower:int;
      
      protected var FAddValueTxt:Vector.<Number>;
      
      protected var FJadeTypeText:String;
      
      public function TCrashedJade()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         this.FAddType = Vector.<int>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FAddValue = Vector.<Number>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FLevelExp = param1.readInt();
         this.FNextID = param1.readInt();
         this.FCrashedExp = param1.readUnsignedInt();
         this.FEffectID = param1.readInt();
         this.FJadePower = param1.readInt();
         this.FAddValueTxt = Vector.<Number>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FJadeTypeText = TUtilityString.FetchUTF(param1);
      }
      
      public function get AddType() : Vector.<int>
      {
         return this.FAddType;
      }
      
      public function get AddValue() : Vector.<Number>
      {
         return this.FAddValue;
      }
      
      public function get LevelExp() : int
      {
         return this.FLevelExp;
      }
      
      public function get NextID() : int
      {
         return this.FNextID;
      }
      
      public function get CrashedExp() : int
      {
         return this.FCrashedExp;
      }
      
      public function get EffectID() : int
      {
         return this.FEffectID;
      }
      
      public function get JadePower() : int
      {
         return this.FJadePower;
      }
      
      public function get AddValueTxt() : Vector.<Number>
      {
         return this.FAddValueTxt;
      }
      
      public function get JadeTypeText() : String
      {
         return this.FJadeTypeText;
      }
   }
}

