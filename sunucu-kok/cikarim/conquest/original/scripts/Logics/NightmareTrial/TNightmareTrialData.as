package Logics.NightmareTrial
{
   import Logics.NightmareTrial.VO.TNightmareTrialLevelVo;
   import flash.utils.*;
   
   public class TNightmareTrialData
   {
      
      private var FNightmareTrialLevelVec:Vector.<TNightmareTrialLevelVo>;
      
      public function TNightmareTrialData()
      {
         super();
         this.FNightmareTrialLevelVec = new Vector.<TNightmareTrialLevelVo>();
      }
      
      public function set NightmareTrialLevelVec(param1:Vector.<TNightmareTrialLevelVo>) : void
      {
         this.FNightmareTrialLevelVec = param1;
      }
      
      public function get NightmareTrialLevelVec() : Vector.<TNightmareTrialLevelVo>
      {
         return this.FNightmareTrialLevelVec;
      }
      
      public function GetNightmareTrialLevelVo(param1:int) : TNightmareTrialLevelVo
      {
         var _loc2_:TNightmareTrialLevelVo = null;
         for each(_loc2_ in this.FNightmareTrialLevelVec)
         {
            if(_loc2_.Id == param1)
            {
               break;
            }
         }
         return _loc2_;
      }
   }
}

