package Logics.Streamization.Quest
{
   import Foundation.Streamization.TUnstreamizer;
   import Logics.Quests.TPoolQuest;
   import Logics.Spaces.LogicsSpace;
   
   use namespace LogicsSpace;
   
   public class TUnstreamizerQuestUnknown extends TUnstreamizer
   {
      
      protected static var FPoolQuest:TPoolQuest;
      
      public function TUnstreamizerQuestUnknown()
      {
         super();
      }
      
      LogicsSpace static function PoolsSetup(param1:TPoolQuest) : void
      {
         FPoolQuest = param1;
      }
   }
}

