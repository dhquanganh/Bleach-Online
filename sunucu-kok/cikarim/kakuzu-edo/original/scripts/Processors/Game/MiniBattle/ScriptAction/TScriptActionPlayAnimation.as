package Processors.Game.MiniBattle.ScriptAction
{
   import Processors.Game.MiniBattle.Mode.TFileScriptAction;
   import Resources.Constants.CONST_COMMON;
   import Resources.Constants.CONST_MAP;
   
   public class TScriptActionPlayAnimation extends TScriptAction
   {
      
      protected static const TargetType_Me:int = 0;
      
      protected static const TargetType_Enemy:int = 1;
      
      protected var AnimationType_Skill:int = 0;
      
      protected var FAnimationType:int;
      
      protected var FAnimationID:int;
      
      protected var FSequenceIndex:int;
      
      protected var FMountPointType:int;
      
      protected var FAddedTime:int;
      
      protected var FIfEvert:int;
      
      public function TScriptActionPlayAnimation()
      {
         super();
      }
      
      override public function Trigger() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         if(Boolean(this.FIfEvert) && FSoldierMe.Direction == CONST_MAP.DIRECTION_RIGHT)
         {
            _loc1_ = -1;
         }
         else if(!this.FIfEvert && FSoldierMe.Direction == CONST_MAP.DIRECTION_LEFT)
         {
            _loc1_ = -1;
         }
         else
         {
            _loc1_ = 1;
         }
         if(this.FMountPointType == TargetType_Me)
         {
            _loc6_ = 0;
         }
         else
         {
            _loc6_ = (FSoldierEnemyView.x - FSoldierMeView.x) / (this.FAddedTime + 1);
         }
         _loc3_ = FSoldierMeView.y;
         _loc2_ = FSoldierMeView.x + _loc6_;
         _loc4_ = 0;
         while(_loc4_ < this.FAddedTime)
         {
            PlayAnimation(this.FAnimationID,_loc2_,_loc3_,_loc1_,_loc5_,this.FAnimationType);
            _loc5_ += CONST_COMMON.SIZE_FrameRatePerSecond;
            _loc2_ += _loc6_;
            _loc4_++;
         }
         PlayAnimation(this.FAnimationID,_loc2_,_loc3_,_loc1_,_loc5_,this.FAnimationType);
      }
      
      override public function Init(param1:TFileScriptAction) : void
      {
         super.Init(param1);
         this.FAnimationType = param1.Next();
         this.FAnimationID = param1.Next();
         this.FSequenceIndex = param1.Next();
         this.FMountPointType = param1.Next();
         this.FAddedTime = param1.Next();
         this.FIfEvert = param1.Next();
      }
      
      override public function Reset() : void
      {
         super.Reset();
         this.FAnimationType = 0;
         this.FAnimationID = 0;
         this.FSequenceIndex = 0;
         this.FMountPointType = 0;
         this.FAddedTime = 0;
      }
   }
}

