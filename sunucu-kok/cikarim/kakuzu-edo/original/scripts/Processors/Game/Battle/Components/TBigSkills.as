package Processors.Game.Battle.Components
{
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Processors.Game.Battle.Character.TRole;
   import Resources.Constants.CONST_BATTLE;
   import flash.display.Sprite;
   
   public class TBigSkills extends TUIComponent
   {
      
      protected static const EFFECT_NUMBER:uint = 2;
      
      public static const LEFT_EFFECT:uint = 0;
      
      public static const RIGHT_EFFECT:uint = 1;
      
      protected var FTBigSkills:Vector.<TBigSkill>;
      
      protected var FScene:Sprite;
      
      public function TBigSkills(param1:TUIComponent)
      {
         super(param1);
         this.FTBigSkills = new Vector.<TBigSkill>(EFFECT_NUMBER);
         this.visible = false;
         this.BigSkillInit();
      }
      
      private function BigSkillInit() : void
      {
         var _loc1_:TBigSkill = null;
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:Sprite = null;
         if(this.FScene == null)
         {
            this.FScene = TUtilityReflection.CreateDisplayObjectInstance(CONST_BATTLE.RESOURCE_ClassName_MC_SkillEffect) as Sprite;
            addChild(this.FScene);
            _loc3_ = EFFECT_NUMBER;
            _loc2_ = 0;
            while(_loc2_ < _loc3_)
            {
               _loc4_ = this.FScene[CONST_BATTLE.RESOURCE_Link_MC_Effects + _loc2_];
               _loc1_ = new TBigSkill(this,_loc4_);
               _loc1_.mouseChildren = false;
               _loc1_.mouseEnabled = false;
               _loc1_.SetEffectVisible = false;
               this.FTBigSkills[_loc2_] = _loc1_;
               _loc2_++;
            }
         }
      }
      
      public function Reset() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         _loc2_ = EFFECT_NUMBER;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FTBigSkills[_loc1_].Reset();
            _loc1_++;
         }
      }
      
      public function PlayBigSkill(param1:TRole, param2:uint, param3:int, param4:String, param5:Function = null) : void
      {
         var _loc6_:TBigSkill = null;
         _loc6_ = this.FTBigSkills[param3];
         if(param1 == null)
         {
            _loc6_.SetEffectVisible = false;
            this.parent.visible = false;
            this.FScene.visible = false;
            return;
         }
         _loc6_.SetSkillName = param4;
         _loc6_.SetEffectVisible = true;
         this.FScene.visible = true;
         _loc6_.SetBigIcon(param1,param2,param5);
      }
      
      public function SetStatues(param1:Boolean) : void
      {
         var _loc2_:uint = 0;
         if(this.FTBigSkills != null)
         {
            _loc2_ = 0;
            while(_loc2_ < this.FTBigSkills.length)
            {
               this.FTBigSkills[_loc2_].SetStatues(param1);
               _loc2_++;
            }
         }
      }
   }
}

