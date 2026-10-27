package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.TDatebaseVO;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class TPetLevelUp extends TDatebaseVO
   {
      
      protected var FPetId:uint;
      
      protected var FIsMaxLevel:uint;
      
      protected var FLevel:uint;
      
      protected var FName:String;
      
      protected var FStarLevel:Vector.<int>;
      
      protected var FAttributes:Vector.<int>;
      
      protected var FGrowRates:Vector.<Number>;
      
      protected var FNeedExp:uint;
      
      protected var FTotalExp:uint;
      
      protected var FQuality:uint;
      
      protected var FPetResourceID:uint;
      
      protected var FSourcePet:uint;
      
      public function TPetLevelUp()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:Array = null;
         this.FPetId = param1.readUnsignedInt();
         this.FIsMaxLevel = param1.readUnsignedInt();
         this.FLevel = param1.readUnsignedInt();
         this.FName = TUtilityString.FetchUTF(param1);
         _loc4_ = TUtilityString.FetchUTF(param1);
         _loc5_ = Json.decode(_loc4_);
         this.FStarLevel = Vector.<int>(_loc5_);
         _loc4_ = TUtilityString.FetchUTF(param1);
         _loc5_ = Json.decode(_loc4_);
         _loc3_ = int(_loc5_.length);
         this.FAttributes = new Vector.<int>(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FAttributes[_loc2_] = _loc5_[_loc2_];
            _loc2_++;
         }
         _loc4_ = TUtilityString.FetchUTF(param1);
         _loc5_ = Json.decode(_loc4_);
         _loc3_ = int(_loc5_.length);
         if(_loc3_ != 0)
         {
            this.FGrowRates = new Vector.<Number>(_loc3_);
            _loc2_ = 0;
            while(_loc2_ < _loc3_)
            {
               this.FGrowRates[_loc2_] = _loc5_[_loc2_];
               _loc2_++;
            }
         }
         this.FNeedExp = param1.readUnsignedInt();
         this.FTotalExp = param1.readUnsignedInt();
         this.FQuality = param1.readUnsignedInt();
         this.FPetResourceID = param1.readUnsignedInt();
         this.FSourcePet = param1.readUnsignedInt();
      }
      
      public function get PetId() : uint
      {
         return this.FPetId;
      }
      
      public function get IsMaxLevel() : uint
      {
         return this.FIsMaxLevel;
      }
      
      public function get Level() : uint
      {
         return this.FLevel;
      }
      
      public function get StarLevel() : Vector.<int>
      {
         return this.FStarLevel;
      }
      
      public function get Name() : String
      {
         return this.FName;
      }
      
      public function get Attributes() : Vector.<int>
      {
         return this.FAttributes;
      }
      
      public function get GrowRates() : Vector.<Number>
      {
         return this.FGrowRates;
      }
      
      public function get NeedExp() : uint
      {
         return this.FNeedExp;
      }
      
      public function get TotalExpp() : uint
      {
         return this.FTotalExp;
      }
      
      public function get Quality() : uint
      {
         return this.FQuality;
      }
      
      public function get PetResourceID() : uint
      {
         return this.FPetResourceID;
      }
      
      public function get SourcePet() : uint
      {
         return this.FSourcePet;
      }
   }
}

