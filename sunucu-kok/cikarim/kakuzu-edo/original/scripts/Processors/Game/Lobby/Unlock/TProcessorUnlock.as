package Processors.Game.Lobby.Unlock
{
   import Foundation.Common.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Bins.*;
   import Foundation.Timing.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.Affairs.*;
   import Logics.Agent.SParametersCore;
   import Logics.Characters.*;
   import Logics.Quests.*;
   import Logics.Spaces.LogicsSpace;
   import Logics.Streamization.Unlock.*;
   import Logics.Unlocks.*;
   import Processors.Game.Lobby.Common.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.text.*;
   import flash.utils.*;
   import ghostcat.operation.*;
   import ghostcat.util.easing.*;
   
   use namespace LogicsSpace;
   
   public class TProcessorUnlock extends TProcessorLobbyModule
   {
      
      protected static const AFFAIRID_UnlockStart:uint = 267387120;
      
      protected static const SIZE_ICON_SUBSTRATE_WIDTH:uint = 87;
      
      protected static const SIZE_ICON_SUBSTRATE_HEIGHT:uint = 75;
      
      protected static const SCENEPOSITION_MAINCITY:int = CONST_COMMON.SCENEPOSITION_MAINCITY;
      
      protected static const PLOT_MODE_None:int = CONST_PLOT.PLOT_MODE_None;
      
      protected static const POSITION_SecondaryFunction:uint = CONST_SHORTCUTS.POSITION_SecondaryFunction;
      
      protected static const POSITION_SecondaryFunctionA:uint = CONST_SHORTCUTS.POSITION_SecondaryFunctionA;
      
      protected static const POSITION_SecondaryFunctionB:uint = CONST_SHORTCUTS.POSITION_SecondaryFunctionB;
      
      protected static const POSITION_SecondaryFunctionC:uint = CONST_SHORTCUTS.POSITION_SecondaryFunctionC;
      
      protected static const POSITION_SecondaryFunctionD:uint = CONST_SHORTCUTS.POSITION_SecondaryFunctionD;
      
      protected static const POSITION_MainFunction:uint = CONST_SHORTCUTS.POSITION_MainFunction;
      
      protected static const POSITION_MainFunction_Special:uint = CONST_SHORTCUTS.POSITION_MainFunction_Special;
      
      protected static const UNLOCK_CONDITION_UNLOCKED:uint = CONST_UNLOCK.UNLOCK_CONDITION_UNLOCKED;
      
      protected static const UNLOCK_CONDITION_QUEST_COMPLETED:uint = CONST_UNLOCK.UNLOCK_CONDITION_QUEST_COMPLETED;
      
      protected static const UNLOCK_CONDITION_LEVEL:uint = CONST_UNLOCK.UNLOCK_CONDITION_LEVEL;
      
      protected static const UNLOCK_CONDITION_QUEST_ACCEPT:uint = CONST_UNLOCK.UNLOCK_CONDITION_QUEST_ACCEPT;
      
      protected static const UNLOCK_CONDITION_GOLDDIAMON:uint = CONST_UNLOCK.UNLOCK_CONDITION_GOLDDIAMON;
      
      protected static const UNLOCK_CONDITION_TXHZ:uint = CONST_UNLOCK.UNLOCK_CONDITION_TXHZ;
      
      protected static const RESOURCE_ClassName_SecondaryFunction_Btns:Vector.<String> = CONST_SHORTCUTS.RESOURCE_ClassName_SecondaryFunction_Btns;
      
      protected static const RESOURCE_ClassName_SecondaryFunctionA_Btns:Vector.<String> = CONST_SHORTCUTS.RESOURCE_ClassName_SecondaryFunctionA_Btns;
      
      protected static const RESOURCE_ClassName_SecondaryFunctionB_Btns:Vector.<String> = CONST_SHORTCUTS.RESOURCE_ClassName_SecondaryFunctionB_Btns;
      
      protected static const RESOURCE_ClassName_SecondaryFunctionC_Btns:Vector.<String> = CONST_SHORTCUTS.RESOURCE_ClassName_SecondaryFunctionC_Btns;
      
      protected static const RESOURCE_ClassName_SecondaryFunctionD_Btns:Vector.<String> = CONST_SHORTCUTS.RESOURCE_ClassName_SecondaryFunctionD_Btns;
      
      protected static const RESOURCE_ClassName_Function_Btns:Vector.<String> = CONST_SHORTCUTS.RESOURCE_ClassName_Function_Btns;
      
      protected static const RESOURCE_ClassName_Function_Special_Btns:Vector.<String> = CONST_SHORTCUTS.RESOURCE_ClassName_Function_Special_Btns;
      
      protected var FUnstreamizerUnlocks:TUnstreamizerUnlocks;
      
      protected var FUnlocks:TUnlocks;
      
      protected var FChracter:TCharacter;
      
      protected var FUnlockEffects:Vector.<RepeatOper>;
      
      protected var FUnlockSteps:Vector.<Function>;
      
      protected var FTweenOperStartFadeIn:TweenOper;
      
      protected var FTweenOperStartFadeOut:TweenOper;
      
      protected var FTweenOperEffectFadeIn:TweenOper;
      
      protected var FTweenOperEffectFadeOut:TweenOper;
      
      protected var FTweenOperStopFadeIn:TweenOper;
      
      protected var FTweenOperStopFadeOut:TweenOper;
      
      protected var FTweenOperEndFadeIn:TweenOper;
      
      protected var FTweenOperEndFadeOut:TweenOper;
      
      protected var FTweenOperMoveIn:TweenOper;
      
      protected var FTweenOperMoveOut:TweenOper;
      
      protected var FRepeatOper:RepeatOper;
      
      protected var FMC_Unlock:Sprite;
      
      protected var FMC_UnlockEffect:MovieClip;
      
      protected var FTF_Desc:TextField;
      
      protected var FMC_MountPointActivity:Sprite;
      
      protected var FMC_MountPointFunction:Sprite;
      
      protected var FMC_Substrate:MovieClip;
      
      protected var FMC_MountPointIcon:Sprite;
      
      protected var FBitmapIcon:Bitmap;
      
      protected var FMC_Icon:Sprite;
      
      protected var FUnlock:TUnlock;
      
      protected var FButton:SimpleButton;
      
      protected var FBounds:TBounds;
      
      protected var FCoordinate:TCoordinate;
      
      protected var FUnlockActivityIndex:int;
      
      protected var FUnlockFunctionIndex:int;
      
      protected var FIsUnlockCompleted:Boolean;
      
      protected var FIsFirst:Boolean;
      
      protected var FIsStartStep:Boolean;
      
      protected var FIsCheckUnlockState:Boolean;
      
      protected var FIsUnlockResidual:Boolean;
      
      protected var FNextTick:uint;
      
      protected var FOnUpdateShortcutsState:Function;
      
      protected var FOnUnlockingNotification:Function;
      
      protected var FOnUnlockedNotification:Function;
      
      public function TProcessorUnlock(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,param2);
         this.FUnstreamizerUnlocks = new TUnstreamizerUnlocks();
         this.FUnlocks = SLogicsCore.Unlocks;
         this.FUnlockEffects = new Vector.<RepeatOper>();
         this.FUnlockSteps = new Vector.<Function>();
         this.FChracter = SLogicsCore.Character;
         this.FBitmapIcon = new Bitmap();
         this.FCoordinate = new TCoordinate();
         mouseEnabled = false;
         this.FIsUnlockCompleted = false;
         this.FIsFirst = true;
         this.FIsCheckUnlockState = false;
         this.FIsUnlockResidual = true;
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_UNLOCK.TEXTURESID_UNLOCK);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:MovieClip = null;
         this.FUnstreamizerUnlocks.Unstreamize(null,this.FUnlocks,null);
         this.FMC_Unlock = TUtilityReflection.CreateDisplayObjectInstance(CONST_UNLOCK.RESOURCE_ClassName_MC_Unlock) as Sprite;
         addChild(this.FMC_Unlock);
         this.FMC_UnlockEffect = this.FMC_Unlock[CONST_UNLOCK.RESOURCE_Link_MC_UnlockEffect];
         _loc1_ = this.FMC_UnlockEffect[CONST_UNLOCK.RESOURCE_Link_MC_Desc];
         this.FTF_Desc = _loc1_[CONST_UNLOCK.RESOURCE_Link_TF_Desc];
         this.FMC_Substrate = this.FMC_UnlockEffect[CONST_UNLOCK.RESOURCE_Link_MC_Substrate];
         this.FMC_MountPointActivity = this.FMC_Substrate[CONST_UNLOCK.RESOURCE_Link_MC_MountPointActivity];
         this.FMC_MountPointFunction = this.FMC_Substrate[CONST_UNLOCK.RESOURCE_Link_MC_MountPointFunction];
         this.FMC_Substrate.visible = false;
         this.ConstructTweens();
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         this.FMC_Unlock.x = (CONST_COMMON.STAGE_Width - this.FMC_Unlock.width) / 2;
         this.FMC_Unlock.y = (CONST_COMMON.STAGE_Height - this.FMC_Unlock.height) / 2;
         super.ResourcesPerform_UILocations();
      }
      
      protected function ConstructTweens() : void
      {
         this.FRepeatOper = new RepeatOper();
         this.FTweenOperStartFadeIn = new TweenOper();
         this.FTweenOperStartFadeOut = new TweenOper();
         this.FTweenOperEffectFadeIn = new TweenOper();
         this.FTweenOperEffectFadeOut = new TweenOper();
         this.FTweenOperStopFadeIn = new TweenOper();
         this.FTweenOperStopFadeOut = new TweenOper();
         this.FTweenOperEndFadeIn = new TweenOper();
         this.FTweenOperEndFadeOut = new TweenOper();
         this.FTweenOperMoveIn = new TweenOper();
         this.FTweenOperMoveOut = new TweenOper();
         this.FTweenOperStartFadeIn.duration = 10;
         this.FTweenOperStartFadeOut.duration = 250;
         this.FTweenOperEffectFadeIn.duration = 1000;
         this.FTweenOperEffectFadeOut.duration = 10;
         this.FTweenOperStopFadeIn.duration = 350;
         this.FTweenOperStopFadeOut.duration = 650;
         this.FTweenOperEndFadeIn.duration = 10;
         this.FTweenOperEndFadeOut.duration = 600;
         this.FTweenOperMoveIn.duration = 10;
         this.FTweenOperMoveOut.duration = 750;
         this.FRepeatOper.loop = 1;
         this.FRepeatOper.children = [this.FTweenOperStartFadeIn,this.FTweenOperStartFadeOut,this.FTweenOperEffectFadeIn,this.FTweenOperEffectFadeOut,this.FTweenOperStopFadeIn,this.FTweenOperStopFadeOut,this.FTweenOperEndFadeIn,this.FTweenOperEndFadeOut,this.FTweenOperMoveIn,this.FTweenOperMoveOut];
      }
      
      override protected function LogicsPerform() : void
      {
         var _loc1_:int = 0;
         super.LogicsPerform();
         _loc1_ = int(STimingCore.TickCount);
         if(_loc1_ > this.FNextTick)
         {
            if(this.FIsUnlockResidual)
            {
               this.LogicsPerform_CheckUnlock();
               this.LogicsPerform_UnlockStep();
               this.LogicsPerform_UnlockEffect();
            }
            this.FNextTick += 100;
         }
      }
      
      override protected function AffairRegisterRoutines() : void
      {
         super.AffairRegisterRoutines();
         FAffairRoutines.Register(AFFAIRID_UnlockStart,this.AffairPerform_UnlockStart);
      }
      
      protected function LogicsPerform_CheckUnlock() : void
      {
         if(this.FIsCheckUnlockState)
         {
            this.FIsUnlockCompleted = this.ProcessorUnlockState();
            if(this.FIsUnlockCompleted)
            {
               this.FUnlockSteps.push(this.ProcessorUnlockStep);
            }
         }
      }
      
      protected function LogicsPerform_UnlockStep() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:Function = null;
         _loc1_ = this.CheckUnlockState();
         if(!_loc1_)
         {
            return;
         }
         if(this.FUnlockSteps.length != 0)
         {
            _loc2_ = this.FUnlockSteps.pop();
            _loc2_();
         }
      }
      
      protected function LogicsPerform_UnlockEffect() : void
      {
         var _loc1_:RepeatOper = null;
         if(this.FUnlockEffects.length != 0)
         {
            _loc1_ = this.FUnlockEffects.pop();
            _loc1_.execute();
         }
      }
      
      protected function ProcessorUnlockState() : Boolean
      {
         return this.CheckShortcutsUnlockState();
      }
      
      protected function CheckShortcutsUnlockState() : Boolean
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TUnlock = null;
         var _loc4_:Boolean = false;
         var _loc5_:TQuest = null;
         var _loc6_:int = 0;
         var _loc7_:Boolean = false;
         _loc7_ = false;
         _loc2_ = this.FUnlocks.Count;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FUnlocks.GetUnlockByIndex(_loc1_);
            if(!(_loc3_.UnlockState != TUnlock.UNLOCKSTATE_Unlock || _loc3_.UnlockState == TUnlock.UNLOCKSTATE_ForcedOff))
            {
               _loc4_ = false;
               if(this.CheckShortcutsUnlockStateSecond(_loc3_))
               {
                  switch(_loc3_.ConditiontType)
                  {
                     case UNLOCK_CONDITION_UNLOCKED:
                        _loc4_ = true;
                        break;
                     case UNLOCK_CONDITION_QUEST_ACCEPT:
                        _loc5_ = this.GetQuestAlreadyAcceptByID(_loc3_.ConditiontValue);
                        if(_loc5_ != null)
                        {
                           if(_loc3_.ConditiontValue == _loc5_.Identifier)
                           {
                              _loc4_ = true;
                              break;
                           }
                        }
                     case UNLOCK_CONDITION_QUEST_COMPLETED:
                        _loc5_ = this.GetQuestCompleteByID(_loc3_.ConditiontValue);
                        if(_loc5_ != null)
                        {
                           if(_loc3_.ConditiontValue == _loc5_.Identifier)
                           {
                              _loc4_ = true;
                           }
                        }
                        break;
                     case UNLOCK_CONDITION_LEVEL:
                        _loc6_ = int(this.FChracter.GetMainLevel());
                        if(_loc6_ >= _loc3_.ConditiontValue)
                        {
                           _loc4_ = true;
                        }
                        break;
                     case UNLOCK_CONDITION_GOLDDIAMON:
                        _loc4_ = Boolean(SParametersCore.IfBaiDuGame);
                        break;
                     case UNLOCK_CONDITION_TXHZ:
                        _loc4_ = Boolean(SParametersCore.IfTXGame);
                  }
                  if(_loc4_)
                  {
                     _loc7_ = _loc4_;
                     if(!this.FIsFirst)
                     {
                        _loc3_.UnlockState = TUnlock.UNLOCKSTATE_Unlocking;
                        break;
                     }
                     _loc3_.UnlockState = TUnlock.UNLOCKSTATE_Unlocked;
                  }
               }
            }
            _loc1_++;
         }
         return _loc7_;
      }
      
      protected function CheckShortcutsUnlockStateSecond(param1:TUnlock) : Boolean
      {
         if(param1.Position == CONST_SHORTCUTS.POSITION_SecondaryFunction && param1.Index == CONST_SHORTCUTS.TYPE_SecondaryFunction_ExportPlayer)
         {
            if(!SParametersCore.ShowOW)
            {
               return false;
            }
         }
         return true;
      }
      
      protected function ProcessorUnlockStep() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TUnlock = null;
         _loc2_ = this.FUnlocks.Count;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FUnlocks.GetUnlockByIndex(_loc1_);
            if(_loc3_.UnlockState == TUnlock.UNLOCKSTATE_Unlocking)
            {
               _loc3_.UnlockState = TUnlock.UNLOCKSTATE_Unlocked;
               if(!(_loc3_.Position != POSITION_SecondaryFunction && _loc3_.Position != POSITION_SecondaryFunctionA && _loc3_.Position != POSITION_SecondaryFunctionB && _loc3_.Position != POSITION_SecondaryFunctionC && _loc3_.Position != POSITION_MainFunction && _loc3_.Position != POSITION_MainFunction_Special))
               {
                  this.FUnlock = _loc3_;
                  if(this.FOnUnlockingNotification != null)
                  {
                     this.FOnUnlockingNotification(this,_loc3_);
                  }
                  this.FIsStartStep = true;
                  break;
               }
               if(this.FOnUpdateShortcutsState != null)
               {
                  this.FOnUpdateShortcutsState(this,this.FUnlocks);
               }
            }
            _loc1_++;
         }
      }
      
      protected function ProcessorCheckUnlockResidual() : Boolean
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Boolean = false;
         var _loc4_:TUnlock = null;
         _loc3_ = false;
         _loc2_ = this.FUnlocks.Count;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc4_ = this.FUnlocks.GetUnlockByIndex(_loc1_);
            if(_loc4_.UnlockState == TUnlock.UNLOCKSTATE_Unlock)
            {
               _loc3_ = true;
               break;
            }
            _loc1_++;
         }
         return _loc3_;
      }
      
      protected function ProcessorUnlockResponse(param1:TBounds, param2:Object) : void
      {
         var _loc3_:String = null;
         this.FBounds = param1;
         this.FButton = param2 as SimpleButton;
         switch(this.FUnlock.Position)
         {
            case POSITION_SecondaryFunction:
               _loc3_ = RESOURCE_ClassName_SecondaryFunction_Btns[this.FUnlock.Index];
               this.FMC_MountPointIcon = this.FMC_MountPointActivity;
               this.FBounds.X -= this.FButton.width;
               break;
            case POSITION_SecondaryFunctionA:
               _loc3_ = RESOURCE_ClassName_SecondaryFunctionA_Btns[this.FUnlock.Index];
               this.FMC_MountPointIcon = this.FMC_MountPointActivity;
               break;
            case POSITION_SecondaryFunctionB:
               _loc3_ = RESOURCE_ClassName_SecondaryFunctionB_Btns[this.FUnlock.Index];
               this.FMC_MountPointIcon = this.FMC_MountPointActivity;
               break;
            case POSITION_SecondaryFunctionC:
               _loc3_ = RESOURCE_ClassName_SecondaryFunctionC_Btns[this.FUnlock.Index];
               this.FMC_MountPointIcon = this.FMC_MountPointActivity;
               break;
            case POSITION_SecondaryFunctionD:
               _loc3_ = RESOURCE_ClassName_SecondaryFunctionD_Btns[this.FUnlock.Index];
               this.FMC_MountPointIcon = this.FMC_MountPointActivity;
               break;
            case POSITION_MainFunction:
               _loc3_ = RESOURCE_ClassName_Function_Btns[this.FUnlock.Index];
               this.FMC_MountPointIcon = this.FMC_MountPointFunction;
               break;
            case POSITION_MainFunction_Special:
               _loc3_ = RESOURCE_ClassName_Function_Special_Btns[this.FUnlock.Index];
               this.FMC_MountPointIcon = this.FMC_MountPointFunction;
         }
         this.FBitmapIcon.bitmapData = TUtilityReflection.CreateBitmapDataByDisplayObject(_loc3_);
         this.FMC_MountPointIcon.x = (SIZE_ICON_SUBSTRATE_WIDTH - this.FBitmapIcon.bitmapData.width) / 2 + 2;
         this.FMC_MountPointIcon.y = (SIZE_ICON_SUBSTRATE_HEIGHT - this.FBitmapIcon.bitmapData.height) / 2 + 2;
         this.FMC_Icon = TUtilityReflection.CreateDisplayObjectInstance(_loc3_) as Sprite;
         this.FMC_Icon.visible = false;
         addChild(this.FMC_Icon);
         this.FCoordinate = TUtilityCartisian.GetScreenCoordinateByDisplayObject(this.FMC_MountPointIcon);
         this.FMC_Icon.x = this.FCoordinate.X + 1;
         this.FMC_Icon.y = this.FCoordinate.Y + 1;
         this.FTF_Desc.text = this.FUnlock.Desc;
         FAffairGenerator.Generate(AFFAIRID_UnlockStart);
         this.SetTweens();
         this.PlayEffects(true);
         this.FUnlockEffects.push(this.FRepeatOper);
      }
      
      protected function SetTweens() : void
      {
         this.FTweenOperStartFadeIn.target = this.FMC_Unlock;
         this.FTweenOperStartFadeIn.params = {"alpha":0};
         this.FTweenOperStartFadeOut.target = this.FMC_Unlock;
         this.FTweenOperStartFadeOut.params = {"alpha":1};
         this.FTweenOperEffectFadeIn.target = this.FMC_UnlockEffect;
         this.FTweenOperEffectFadeIn.params = {"onStartHandler":this.PerformTweenOperEffectOnStart};
         this.FTweenOperEffectFadeOut.target = this.FMC_UnlockEffect;
         this.FTweenOperEffectFadeOut.params = {"onCompleteHandler":this.PerformTweenOperEffectOnComplete};
         this.FTweenOperStopFadeIn.target = this.FMC_Unlock;
         this.FTweenOperStopFadeIn.params = {};
         this.FTweenOperStopFadeOut.target = this.FMC_Unlock;
         this.FTweenOperStopFadeOut.params = {};
         this.FTweenOperEndFadeIn.target = this.FMC_Unlock;
         this.FTweenOperEndFadeIn.params = {"alpha":1};
         this.FTweenOperEndFadeOut.target = this.FMC_Unlock;
         this.FTweenOperEndFadeOut.params = {
            "alpha":0,
            "onCompleteHandler":this.PerformTweenOperEndOnComplete
         };
         this.FTweenOperMoveIn.target = this.FMC_Icon;
         this.FTweenOperMoveIn.params = {
            "x":this.FMC_Icon.x,
            "y":this.FMC_Icon.y,
            "ease":Cubic.easeIn,
            "onCompleteHandler":this.PerformTweenOperMoveInOnComplete
         };
         this.FTweenOperMoveOut.target = this.FMC_Icon;
         this.FTweenOperMoveOut.params = {
            "x":this.FBounds.X,
            "y":this.FBounds.Y,
            "ease":Cubic.easeOut,
            "onCompleteHandler":this.PerformTweenOperMoveOutOnComplete
         };
      }
      
      protected function PerformTweenOperEffectOnStart(param1:TweenEvent) : void
      {
         this.FMC_MountPointIcon.addChild(this.FBitmapIcon);
         this.FMC_Substrate.visible = true;
         this.FMC_UnlockEffect.play();
         this.FMC_Substrate.play();
      }
      
      protected function PerformTweenOperEffectOnComplete(param1:TweenEvent) : void
      {
         this.FMC_Icon.visible = true;
         this.FMC_Substrate.stop();
      }
      
      protected function PerformTweenOperEndOnComplete(param1:TweenEvent) : void
      {
         this.FMC_MountPointIcon.removeChild(this.FBitmapIcon);
         this.FBitmapIcon.bitmapData.dispose();
         this.FBitmapIcon.bitmapData = null;
         this.FMC_Substrate.visible = false;
      }
      
      protected function PerformTweenOperMoveInOnComplete(param1:TweenEvent) : void
      {
         TutorialNextStep((this.FUnlock.Position * 10000 + this.FUnlock.Index) * 10);
      }
      
      protected function PerformTweenOperMoveOutOnComplete(param1:TweenEvent) : void
      {
         TutorialNextStep(this.FUnlock.Position * 10000 + this.FUnlock.Index);
      }
      
      protected function AffairPerform_UnlockStart(param1:TAffair) : void
      {
         var _loc2_:Boolean = false;
         _loc2_ = this.AffairPerformUnlockStart();
         if(_loc2_)
         {
            param1.PostProcess = TAffair.POSTPROCESS_Pend;
         }
         else
         {
            param1.PostProcess = TAffair.POSTPROCESS_Remove;
         }
      }
      
      protected function AffairPerformUnlockStart() : Boolean
      {
         var _loc1_:Boolean = false;
         this.FCoordinate.X = this.FMC_Icon.x;
         this.FCoordinate.Y = this.FMC_Icon.y;
         _loc1_ = TUtilityCartisian.BoundsContainsCoordinate(this.FBounds,this.FCoordinate);
         if(_loc1_)
         {
            this.PlayEffects(false);
            this.FButton.alpha = 1;
            this.FButton = null;
            removeChild(this.FMC_Icon);
            this.FMC_Icon.removeChildren();
            this.FMC_Icon = null;
            this.FIsUnlockResidual = this.ProcessorCheckUnlockResidual();
            if(!this.FIsUnlockResidual)
            {
               this.Dispose();
            }
            this.FIsStartStep = false;
            return false;
         }
         return true;
      }
      
      protected function PlayEffects(param1:Boolean = true) : void
      {
         if(param1)
         {
            if(!Visible)
            {
               BarrierActuate(this);
               Visible = param1;
            }
         }
         else if(Visible)
         {
            BarrierDeactuate(this);
            this.FMC_UnlockEffect.gotoAndStop(1);
            Visible = param1;
         }
      }
      
      protected function ProcessorUnlockCheckShortcutsState() : void
      {
         this.ProcessorUnlockState();
         if(this.FOnUpdateShortcutsState != null)
         {
            this.FOnUpdateShortcutsState(this,this.FUnlocks);
         }
         if(this.FIsFirst)
         {
            this.FIsFirst = false;
         }
      }
      
      protected function CheckUnlockState() : Boolean
      {
         var _loc1_:Boolean = false;
         _loc1_ = true;
         if(this.FIsStartStep)
         {
            _loc1_ = false;
         }
         if(this.FChracter.RoleSencePosition != SCENEPOSITION_MAINCITY)
         {
            _loc1_ = false;
         }
         if(SLogicsCore.PlayPlotState != PLOT_MODE_None)
         {
            _loc1_ = false;
         }
         return _loc1_;
      }
      
      protected function GetQuestAlreadyAcceptByID(param1:uint) : TQuest
      {
         var _loc2_:TQuest = null;
         _loc2_ = this.FChracter.MainQuestsAlreadyAccept.GetQuestByIdentifier(param1);
         if(_loc2_ == null)
         {
            _loc2_ = this.FChracter.SubQuestsAlreadyAccept.GetQuestByIdentifier(param1);
         }
         return _loc2_;
      }
      
      protected function GetQuestCompleteByID(param1:uint) : TQuest
      {
         var _loc2_:TQuest = null;
         _loc2_ = this.FChracter.MainQuestComplete.GetQuestByIdentifier(param1);
         if(_loc2_ == null)
         {
            _loc2_ = this.FChracter.SubQuestComplete.GetQuestByIdentifier(param1);
         }
         return _loc2_;
      }
      
      public function get OnUpdateShortcutsState() : Function
      {
         return this.FOnUpdateShortcutsState;
      }
      
      public function set OnUpdateShortcutsState(param1:Function) : void
      {
         this.FOnUpdateShortcutsState = param1;
      }
      
      public function get OnUnlockingNotification() : Function
      {
         return this.FOnUnlockingNotification;
      }
      
      public function set OnUnlockingNotification(param1:Function) : void
      {
         this.FOnUnlockingNotification = param1;
      }
      
      public function get OnUnlockedNotification() : Function
      {
         return this.FOnUnlockedNotification;
      }
      
      public function set OnUnlockedNotification(param1:Function) : void
      {
         this.FOnUnlockedNotification = param1;
      }
      
      override public function Mount(param1:ByteArray = null) : void
      {
         super.Mount();
         if(!FIsResourcesLoadCompleted)
         {
            return;
         }
      }
      
      override public function Dispose() : void
      {
         this.FTweenOperStartFadeIn = null;
         this.FTweenOperStartFadeOut = null;
         this.FTweenOperStopFadeIn = null;
         this.FTweenOperStopFadeOut = null;
         this.FTweenOperEndFadeIn = null;
         this.FTweenOperEndFadeOut = null;
         this.FTweenOperMoveIn = null;
         this.FTweenOperMoveOut = null;
         this.FRepeatOper.children.length = 0;
         this.FRepeatOper = null;
         removeChild(this.FMC_Unlock);
         this.FMC_Unlock = null;
         this.FTF_Desc = null;
         this.FMC_MountPointActivity = null;
         this.FMC_MountPointFunction = null;
         this.FMC_Substrate = null;
      }
      
      public function CheckUnlockShortcutsState() : void
      {
         this.ProcessorUnlockCheckShortcutsState();
         this.FIsCheckUnlockState = true;
      }
      
      public function UnlockResponse(param1:Object, param2:TBounds, param3:Object) : void
      {
         this.ProcessorUnlockResponse(param2,param3);
      }
      
      public function ShutdownFunction(param1:int, param2:int) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:TUnlock = null;
         _loc4_ = this.FUnlocks.Count;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc5_ = this.FUnlocks.GetUnlockByIndex(_loc3_);
            if(_loc5_.Position == param1 && _loc5_.Index == param2)
            {
               _loc5_.UnlockState = TUnlock.UNLOCKSTATE_ForcedOff;
            }
            _loc3_++;
         }
         if(this.FOnUpdateShortcutsState != null)
         {
            this.FOnUpdateShortcutsState(this,this.FUnlocks);
         }
      }
      
      public function OpenCrashJadeTest() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TUnlock = null;
         _loc2_ = this.FUnlocks.Count;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FUnlocks.GetUnlockByIndex(_loc1_);
            if(_loc3_.Position == 1 && _loc3_.Index == 13)
            {
               _loc3_.UnlockState = TUnlock.UNLOCKSTATE_Unlocked;
            }
            _loc1_++;
         }
         if(this.FOnUpdateShortcutsState != null)
         {
            this.FOnUpdateShortcutsState(this,this.FUnlocks);
         }
      }
   }
}

