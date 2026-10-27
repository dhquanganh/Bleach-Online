package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.TDatebaseVO;
   import Logics.DatebaseVO.VO.Json.TFixedAward;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class TSoulSkill extends TDatebaseVO
   {
      
      protected var FSkillLv:int;
      
      protected var FNextSkillId:int;
      
      protected var FSoulSkillNeedItem:TFixedAward;
      
      public function TSoulSkill()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:String = null;
         var _loc3_:Object = null;
         this.FSkillLv = param1.readUnsignedInt();
         this.FNextSkillId = param1.readUnsignedInt();
         _loc2_ = TUtilityString.FetchUTF(param1);
         _loc3_ = Json.decode(_loc2_);
         this.FSoulSkillNeedItem = new TFixedAward(_loc3_);
      }
      
      public function get SkillLv() : int
      {
         return this.FSkillLv;
      }
      
      public function get NextSkillId() : int
      {
         return this.FNextSkillId;
      }
      
      public function get SoulSkillNeedItem() : TFixedAward
      {
         return this.FSoulSkillNeedItem;
      }
   }
}

