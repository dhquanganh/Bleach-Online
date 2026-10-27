package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.TDatebaseVO;
   import Logics.DatebaseVO.VO.Json.TTavernWarriorAwardSoul;
   import flash.utils.ByteArray;
   
   use namespace ResourcesSpace;
   
   public class TTavernWarrior extends TDatebaseVO
   {
      
      protected var FGrade:uint;
      
      protected var FAwardId:int;
      
      protected var FReturnType:uint;
      
      protected var FReturnValue:uint;
      
      protected var FRecruitSoul:int;
      
      protected var FRecruitName:String;
      
      protected var FWinDialogue:String;
      
      protected var FLoseDialogue:String;
      
      protected var FAwardsouls:TTavernWarriorAwardSoul;
      
      protected var FAwardsoul:String;
      
      public function TTavernWarrior()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:String = null;
         this.FGrade = param1.readUnsignedInt();
         this.FAwardId = param1.readUnsignedInt();
         this.FReturnType = param1.readUnsignedInt();
         this.FReturnValue = param1.readUnsignedInt();
         this.FRecruitSoul = param1.readUnsignedInt();
         this.FRecruitName = TUtilityString.FetchUTF(param1);
         this.FWinDialogue = TUtilityString.FetchUTF(param1);
         this.FLoseDialogue = TUtilityString.FetchUTF(param1);
         this.FAwardsoul = TUtilityString.FetchUTF(param1);
         this.FAwardsouls = new TTavernWarriorAwardSoul(this.FAwardsoul);
      }
      
      public function get Grade() : int
      {
         return this.FGrade;
      }
      
      public function get AwardId() : int
      {
         return this.FAwardId;
      }
      
      public function get ReturnType() : int
      {
         return this.FReturnType;
      }
      
      public function get ReturnValue() : int
      {
         return this.FReturnValue;
      }
      
      public function get RecruitSoul() : int
      {
         return this.FRecruitSoul;
      }
      
      public function get RecruitName() : String
      {
         return this.FRecruitName;
      }
      
      public function get WinDialogue() : String
      {
         return this.FWinDialogue;
      }
      
      public function get LoseDialogue() : String
      {
         return this.FLoseDialogue;
      }
      
      public function get Awardsouls() : TTavernWarriorAwardSoul
      {
         return this.FAwardsouls;
      }
      
      public function get Awardsoul() : String
      {
         return this.FAwardsoul;
      }
   }
}

