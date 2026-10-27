package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.TDatebaseVO;
   import flash.utils.ByteArray;
   
   use namespace ResourcesSpace;
   
   public class TEquipGenerate extends TDatebaseVO
   {
      
      protected static const SYMBOLA:String = "|";
      
      protected static const SYMBOLB:String = "_";
      
      protected var FOpenLevel:int;
      
      protected var FCost:int;
      
      protected var FDatum:String;
      
      protected var FMaterials:Vector.<int>;
      
      protected var FQuantitys:Vector.<int>;
      
      public function TEquipGenerate()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         this.FOpenLevel = param1.readUnsignedInt();
         this.FCost = param1.readUnsignedInt();
         this.FDatum = TUtilityString.FetchUTF(param1);
         _loc4_ = 0;
         _loc3_ = this.FDatum.length;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(this.FDatum.charAt(_loc2_) == SYMBOLA)
            {
               _loc4_++;
            }
            _loc2_++;
         }
         _loc3_ = _loc4_ + 1;
         this.FMaterials = new Vector.<int>(_loc3_);
         this.FQuantitys = new Vector.<int>(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc5_ = this.FDatum.split(SYMBOLA)[_loc2_];
            this.FMaterials[_loc2_] = _loc5_.split(SYMBOLB)[0];
            this.FQuantitys[_loc2_] = _loc5_.split(SYMBOLB)[1];
            _loc2_++;
         }
      }
      
      public function get OpenLevel() : int
      {
         return this.FOpenLevel;
      }
      
      public function get Cost() : int
      {
         return this.FCost;
      }
      
      public function get Materials() : Vector.<int>
      {
         return this.FMaterials;
      }
      
      public function get Quantitys() : Vector.<int>
      {
         return this.FQuantitys;
      }
      
      public function get Datum() : String
      {
         return this.FDatum;
      }
   }
}

