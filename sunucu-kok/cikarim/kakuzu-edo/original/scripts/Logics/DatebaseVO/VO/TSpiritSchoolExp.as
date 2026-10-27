package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.TDatebaseVO;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class TSpiritSchoolExp extends TDatebaseVO
   {
      
      protected var FMonsterId:uint;
      
      protected var FName:String;
      
      protected var FEffectName:String;
      
      protected var FMonsterLevel:uint;
      
      protected var FNeedExp:uint;
      
      protected var FAddType:uint;
      
      public function TSpiritSchoolExp()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:String = null;
         this.FMonsterId = param1.readUnsignedInt();
         this.FName = TUtilityString.FetchUTF(param1);
         this.FEffectName = TUtilityString.FetchUTF(param1);
         this.FMonsterLevel = param1.readUnsignedInt();
         this.FNeedExp = param1.readUnsignedInt();
         _loc2_ = TUtilityString.FetchUTF(param1);
         this.FAddType = Json.decode(_loc2_).addValue;
      }
      
      public function get MonsterId() : uint
      {
         return this.FMonsterId;
      }
      
      public function get Name() : String
      {
         return this.FName;
      }
      
      public function get EffectName() : String
      {
         return this.FEffectName;
      }
      
      public function get MonsterLevel() : uint
      {
         return this.FMonsterLevel;
      }
      
      public function get NeedExp() : uint
      {
         return this.FNeedExp;
      }
      
      public function get AddType() : uint
      {
         return this.FAddType;
      }
   }
}

