package Logics.NightmareTrial.VO
{
   public class TNightmareTrialEnemyVo
   {
      
      protected var FTemplateIds:Vector.<uint>;
      
      protected var FFightPoses:Vector.<uint>;
      
      protected var FLevels:Vector.<uint>;
      
      public function TNightmareTrialEnemyVo()
      {
         super();
         this.FTemplateIds = new Vector.<uint>();
         this.FFightPoses = new Vector.<uint>();
         this.FLevels = new Vector.<uint>();
      }
      
      public function get TemplateIds() : Vector.<uint>
      {
         return this.FTemplateIds;
      }
      
      public function set TemplateIds(param1:Vector.<uint>) : void
      {
         this.FTemplateIds = param1;
      }
      
      public function get FightPoses() : Vector.<uint>
      {
         return this.FFightPoses;
      }
      
      public function set FightPoses(param1:Vector.<uint>) : void
      {
         this.FFightPoses = param1;
      }
      
      public function get Levels() : Vector.<uint>
      {
         return this.FLevels;
      }
      
      public function set Levels(param1:Vector.<uint>) : void
      {
         this.FLevels = param1;
      }
   }
}

