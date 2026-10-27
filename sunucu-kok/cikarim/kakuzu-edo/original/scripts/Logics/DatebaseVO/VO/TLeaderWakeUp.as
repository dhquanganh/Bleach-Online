package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.TDatebaseVO;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class TLeaderWakeUp extends TDatebaseVO
   {
      
      protected var FUpID:int;
      
      protected var FNextID:int;
      
      protected var FPosEquip:int;
      
      protected var FWakeStage:int;
      
      protected var FQuality:int;
      
      protected var FMaxStr:int;
      
      protected var FUpLevel:int;
      
      protected var FStrengthenPrice:Vector.<Object>;
      
      protected var FUpLevelPrice:Vector.<Object>;
      
      protected var FEquipAttr:Vector.<Object>;
      
      protected var FValueStr:int;
      
      protected var FStrengthenPriceStr:String;
      
      protected var FUpLevelPriceStr:String;
      
      public function TLeaderWakeUp()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         this.FUpID = param1.readUnsignedInt();
         this.FNextID = param1.readUnsignedInt();
         this.FPosEquip = param1.readUnsignedInt();
         this.FWakeStage = param1.readUnsignedInt();
         this.FQuality = param1.readUnsignedInt();
         this.FMaxStr = param1.readUnsignedInt();
         this.FUpLevel = param1.readUnsignedInt();
         this.FStrengthenPriceStr = TUtilityString.FetchUTF(param1);
         this.FUpLevelPriceStr = TUtilityString.FetchUTF(param1);
         this.FStrengthenPrice = Vector.<Object>(Json.decode(this.FStrengthenPriceStr));
         this.FUpLevelPrice = Vector.<Object>(Json.decode(this.FUpLevelPriceStr));
         this.FEquipAttr = Vector.<Object>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FValueStr = param1.readUnsignedInt();
      }
      
      public function get PosEquip() : int
      {
         return this.FPosEquip;
      }
      
      public function get WakeStage() : int
      {
         return this.FWakeStage;
      }
      
      public function get Quality() : int
      {
         return this.FQuality;
      }
      
      public function get MaxStr() : int
      {
         return this.FMaxStr;
      }
      
      public function get UpLevel() : int
      {
         return this.FUpLevel;
      }
      
      public function get StrengthenPrice() : Vector.<Object>
      {
         return this.FStrengthenPrice;
      }
      
      public function get UpLevelPrice() : Vector.<Object>
      {
         return this.FUpLevelPrice;
      }
      
      public function get EquipAttr() : Vector.<Object>
      {
         return this.FEquipAttr;
      }
      
      public function get ValueStr() : int
      {
         return this.FValueStr;
      }
      
      public function get NextID() : int
      {
         return this.FNextID;
      }
      
      public function get UpID() : int
      {
         return this.FUpID;
      }
      
      public function get StrengthenPriceStr() : String
      {
         return this.FStrengthenPriceStr;
      }
      
      public function get UpLevelPriceStr() : String
      {
         return this.FUpLevelPriceStr;
      }
   }
}

