package Processors.Accessories.ResourceManagement
{
   import Debugging.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Repositories.*;
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Timing.*;
   import Logics.*;
   import Resources.Constants.*;
   
   use namespace ResourcesSpace;
   
   public class TProcessorResourceManagement
   {
      
      protected static const SCENEPOSITION_MAINCITY:int = CONST_COMMON.SCENEPOSITION_MAINCITY;
      
      protected static const UNLOAD_COMMON_EFFECTS:Vector.<uint> = CONST_BATTLE.UNLOAD_COMMON_EFFECTS;
      
      protected static const TIME_INTERVAL_AUTORELEASING:int = 5 * 1000;
      
      protected var FRepositories:Vector.<TResourceRepository>;
      
      protected var FInterval:int;
      
      protected var FCurrentTick:int;
      
      protected var FNextTick:int;
      
      public function TProcessorResourceManagement()
      {
         super();
         this.ConstructRepositories();
         this.FInterval = 30000;
         this.FCurrentTick = STimingCore.TickCount;
         this.FNextTick = this.FCurrentTick + this.FInterval;
      }
      
      protected function ConstructRepositories() : void
      {
         this.FRepositories = new Vector.<TResourceRepository>();
         this.FRepositories.push(SResourcesCore.TexturesBackgroundIcon);
         this.FRepositories.push(SResourcesCore.TexturesBuffIcon);
         this.FRepositories.push(SResourcesCore.TexturesDailytaskPicture);
         this.FRepositories.push(SResourcesCore.TexturesHeadIcon);
         this.FRepositories.push(SResourcesCore.TexturesInventory);
         this.FRepositories.push(SResourcesCore.TexturesLargeIcon);
         this.FRepositories.push(SResourcesCore.TexturesMap);
         this.FRepositories.push(SResourcesCore.TexturesMiddlePic);
         this.FRepositories.push(SResourcesCore.TexturesPreview);
         this.FRepositories.push(SResourcesCore.TexturesSkillIcon);
         this.FRepositories.push(SResourcesCore.TexturesSmallIcon);
         this.FRepositories.push(SResourcesCore.TexturesVital);
         this.FRepositories.push(SResourcesCore.TexturesActivityBanner);
         this.FRepositories.push(SResourcesCore.TexturesAchievementIcon);
      }
      
      protected function Perform_AutoReleasing() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:* = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Vector.<uint> = null;
         var _loc7_:TResourceRepositoryTexture = null;
         _loc2_ = int(this.FRepositories.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc7_ = this.FRepositories[_loc1_] as TResourceRepositoryTexture;
            _loc6_ = _loc7_.KnownIdentifiers;
            _loc4_ = int(_loc6_.length);
            _loc3_ = int(_loc4_ - 1);
            while(_loc3_ >= 0)
            {
               _loc7_.DeleteByIdentifier(_loc6_[_loc3_]);
               _loc3_--;
            }
            _loc1_++;
         }
         _loc2_ = int(UNLOAD_COMMON_EFFECTS.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            SResourcesCore.TexturesSkill.DeleteByIdentifier(UNLOAD_COMMON_EFFECTS[_loc1_],true);
            _loc1_++;
         }
      }
      
      public function get Interval() : int
      {
         return this.FInterval;
      }
      
      public function set Interval(param1:int) : void
      {
         if(param1 < 0)
         {
            this.FInterval = 0;
         }
         else
         {
            this.FInterval = param1;
         }
      }
      
      public function Process() : void
      {
         this.FCurrentTick = STimingCore.TickCount;
         if(this.FCurrentTick >= this.FNextTick)
         {
            if(SLogicsCore.Character.RoleSencePosition == SCENEPOSITION_MAINCITY)
            {
               this.Perform_AutoReleasing();
               this.FNextTick += this.FInterval;
            }
            else
            {
               this.FNextTick += TIME_INTERVAL_AUTORELEASING;
            }
            if(this.FNextTick <= this.FCurrentTick)
            {
               this.FNextTick = this.FCurrentTick + this.FInterval;
            }
         }
      }
   }
}

