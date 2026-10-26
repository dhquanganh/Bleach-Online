package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.*;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.*;
   import flash.utils.*;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class TBaseEquip extends TDatebaseVO
   {
      
      protected var FDressProfessions:Vector.<int>;
      
      protected var FMainType:Vector.<int>;
      
      protected var FMainValue:Vector.<int>;
      
      protected var FMainAdditionalType:int;
      
      protected var FMaxAdditionalCount:int;
      
      protected var FHoleCount:int;
      
      protected var FSuitId:int;
      
      protected var FSkillRevise:int;
      
      protected var FEdgeColor:uint;
      
      protected var FFlushSpiritCoefficient:Number;
      
      protected var FDrillHoleNum:uint;
      
      protected var FDressProfession:String;
      
      public function TBaseEquip()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Array = null;
         var _loc5_:String = null;
         this.FDressProfession = TUtilityString.FetchUTF(param1);
         _loc4_ = this.FDressProfession.split("_");
         _loc3_ = int(_loc4_.length);
         this.FDressProfessions = new Vector.<int>(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FDressProfessions[_loc2_] = _loc4_[_loc2_];
            _loc2_++;
         }
         _loc5_ = TUtilityString.FetchUTF(param1);
         this.FMainType = Vector.<int>(Json.decode(_loc5_));
         _loc5_ = TUtilityString.FetchUTF(param1);
         this.FMainValue = Vector.<int>(Json.decode(_loc5_));
         this.FMainAdditionalType = param1.readUnsignedInt();
         this.FMaxAdditionalCount = param1.readInt();
         this.FHoleCount = param1.readInt();
         this.FSuitId = param1.readUnsignedInt();
         this.FSkillRevise = param1.readUnsignedInt();
         this.FEdgeColor = param1.readUnsignedInt();
         this.FFlushSpiritCoefficient = param1.readFloat();
         this.FDrillHoleNum = param1.readUnsignedInt();
      }
      
      public function get DressProfession() : String
      {
         return this.FDressProfession;
      }
      
      public function get DressProfessions() : Vector.<int>
      {
         return this.FDressProfessions;
      }
      
      public function get MainType() : Vector.<int>
      {
         return this.FMainType;
      }
      
      public function get MainValue() : Vector.<int>
      {
         return this.FMainValue;
      }
      
      public function get MainAdditionalType() : int
      {
         return this.FMainAdditionalType;
      }
      
      public function get MaxAdditionalCount() : int
      {
         return this.FMaxAdditionalCount;
      }
      
      public function get HoleCount() : int
      {
         return this.FHoleCount;
      }
      
      public function get SuitId() : int
      {
         return this.FSuitId;
      }
      
      public function get SkillRevise() : int
      {
         return this.FSkillRevise;
      }
      
      public function get EdgeColor() : uint
      {
         return this.FEdgeColor;
      }
      
      public function get FlushSpiritCoefficient() : Number
      {
         return this.FFlushSpiritCoefficient;
      }
      
      public function get DrillHoleNum() : uint
      {
         return this.FDrillHoleNum;
      }
   }
}

