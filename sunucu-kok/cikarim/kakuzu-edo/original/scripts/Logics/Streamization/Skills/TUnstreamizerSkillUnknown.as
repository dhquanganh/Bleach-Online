package Logics.Streamization.Skills
{
   import Foundation.Streamization.TUnstreamizer;
   import Logics.Skills.TPoolSkill;
   import Logics.Spaces.LogicsSpace;
   
   use namespace LogicsSpace;
   
   public class TUnstreamizerSkillUnknown extends TUnstreamizer
   {
      
      protected static var FPoolSkill:TPoolSkill;
      
      public function TUnstreamizerSkillUnknown()
      {
         super();
      }
      
      LogicsSpace static function PoolsSetup(param1:TPoolSkill) : void
      {
         FPoolSkill = param1;
      }
   }
}

