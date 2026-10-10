package Processors.Game.Lobby.Effects
{
   import Foundation.Common.*;
   import Foundation.Fonts.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Repositories.*;
   import Foundation.Resources.Spaces.*;
   import Foundation.Resources.Textures.*;
   import Foundation.Timing.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.Affairs.*;
   import Logics.Inventories.*;
   import Logics.Skills.*;
   import Processors.Game.Common.Effects.*;
   import Processors.Game.Common.Effects.Animations.*;
   import Processors.Game.Common.Effects.Ballistics.*;
   import Processors.Game.Common.Effects.Common.*;
   import Processors.Game.Common.Effects.Texts.*;
   import Resources.Constants.*;
   
   use namespace ResourcesSpace;
   
   public class TProcessorLobbyEffect extends TProcessorEffect
   {
      
      protected static const COORDINATE_TextX:int = CONST_COMMON.STAGE_Width / 2;
      
      protected static const COORDINATE_TextY:int = 300;
      
      protected static const COORDINATE_EffectX:int = CONST_COMMON.STAGE_Width / 2;
      
      protected static const COORDINATE_EffectY:int = 150;
      
      protected static const COORDINATE_BallisticX:int = CONST_COMMON.STAGE_Width / 2;
      
      protected static const COORDINATE_BallisticY:int = 300;
      
      protected static const COORDINATE_UserLevelUpY:int = 150;
      
      protected static const CAPACITY_ParallelOutputRows:uint = CONST_EFFECT.CAPACITY_ParallelOutputRows;
      
      protected static const CAPACITY_SoulClass:int = CONST_EFFECT.CAPACITY_SoulClass;
      
      protected static const CAPACITY_SugarClass:int = CONST_EFFECT.CAPACITY_SUGARCLASS;
      
      protected static const COLOR_EffectText:uint = 4294952980;
      
      protected static const AFFAIRID_ImportUserLevelUp:uint = 16777216;
      
      protected static const AFFAIRID_ImportAutomaticallyFind:uint = 33554432;
      
      protected static const AFFAIRID_ImportAcceptTask:uint = 50331648;
      
      protected static const AFFAIRID_ImportCompleteTask:uint = 67108864;
      
      protected static const TIME_UserLevelUp_SustainTicksOffset:uint = 1600;
      
      protected static const TIME_UserAcceptTask_SustainTicksOffset:uint = 1000;
      
      protected static const TIME_UserCompleteTask_SustainTicksOffset:uint = 1000;
      
      protected static const SEQUENCEID_Default:uint = CONST_COMMON.SEQUENCEID_Default;
      
      protected static const XMAS_GREEN:uint = 0;
      
      protected static const XMAS_BLUE:uint = 1;
      
      protected static const XMAS_PURPLE:uint = 2;
      
      protected static const XMAS_YELLOW:uint = 3;
      
      protected static const XMAS_RED:uint = 4;
      
      protected var FLayerText:TEffectLayer;
      
      protected var FLayerBallistic:TEffectLayer;
      
      protected var FTextParameters:TEffectTextParameters;
      
      protected var FEffectCoordinateParameters:TEffectCoordinateParameters;
      
      protected var FCoordinateText:TCoordinate;
      
      protected var FCoordinateScene:TCoordinate;
      
      protected var FCoordinateSource:TCoordinate;
      
      protected var FCoordinateBallistic:TCoordinate;
      
      protected var FBoundsLocating:TBounds;
      
      protected var FResourcesTexturesBallisticSilverCoin:TTexture;
      
      protected var FResourcesTexturesBallisticSoul:Vector.<TTexture>;
      
      protected var FResourcesTexturesBallisticSugar:Vector.<TTexture>;
      
      protected var FEffectBallisticIntervalIndex:int;
      
      protected var FCoordinateBallisticDestination:TCoordinate;
      
      protected var FResourcesTexturesBallisticAcquireInventory:TTexture;
      
      protected var FCoordinateBallisticAcquireInventoryDestination:TCoordinate;
      
      protected var FSequenceUserLevelUp:TAnimationSequence;
      
      protected var FSequenceAutomaticallyFind:TAnimationSequence;
      
      protected var FSequenceAcceptTask:TAnimationSequence;
      
      protected var FSequenceCompleteTask:TAnimationSequence;
      
      protected var FAcquireInventories:Vector.<Object>;
      
      protected var FEffectsParameters:Vector.<TEffectCoordinateParameters>;
      
      protected var FEffectHeight:int;
      
      public function TProcessorLobbyEffect(param1:TUIComponent)
      {
         super(param1);
         this.ConstructEffectFields();
         this.ConstructEffectParameters();
         this.ConstructResourcesContainers();
         this.FCoordinateText = new TCoordinate();
         this.FCoordinateScene = new TCoordinate();
         this.FCoordinateSource = new TCoordinate();
         this.FCoordinateBallistic = new TCoordinate();
         this.FBoundsLocating = new TBounds();
         this.FCoordinateBallisticDestination = new TCoordinate();
         this.FAcquireInventories = new Vector.<Object>();
         this.FEffectsParameters = new Vector.<TEffectCoordinateParameters>();
         this.mouseEnabled = false;
         this.mouseChildren = false;
      }
      
      override protected function ConstructEffectLayers() : void
      {
         super.ConstructEffectLayers();
         this.FLayerText = ConstructEffectLayer();
         this.FLayerBallistic = ConstructEffectLayer();
      }
      
      protected function ConstructEffectFields() : void
      {
         this.ConstructEffectFields_Text();
      }
      
      protected function ConstructEffectParameters() : void
      {
         this.FEffectCoordinateParameters = new TEffectCoordinateParameters();
         this.FEffectCoordinateParameters.IsShakeEffect = true;
      }
      
      protected function ConstructEffectFields_Text() : void
      {
         var _loc1_:TFontEffect = null;
         this.FTextParameters = new TEffectTextParameters();
         this.FTextParameters.Font.Color = COLOR_EffectText;
         SFontCore.FontSelect(this.FTextParameters.Font,CONST_EFFECT.TEXT_DEFAULT_FontSetName,CONST_EFFECT.TEXT_DEFAULT_FontSetSize,CONST_EFFECT.TEXT_DEFAULT_FontSetBold);
      }
      
      protected function ConstructResourcesContainers() : void
      {
         this.FResourcesTexturesBallisticSoul = new Vector.<TTexture>(CAPACITY_SoulClass);
         this.FResourcesTexturesBallisticSugar = new Vector.<TTexture>(CAPACITY_SugarClass);
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesLobby.LoadSecondary(CONST_LOBBY.TEXTUREID_EffectUserLevelUp);
         SResourcesCore.TexturesLobby.LoadSecondary(CONST_LOBBY.TEXTUREID_EffectAutomaticallyFind);
         SResourcesCore.TexturesLobby.LoadSecondary(CONST_LOBBY.TEXTUREID_EffectAcceptTask);
         SResourcesCore.TexturesLobby.LoadSecondary(CONST_LOBBY.TEXTUREID_EffectCompleteTask);
         SResourcesCore.TexturesLobby.LoadSecondary(CONST_LOBBY.TEXTUREID_EFFECT_BALLISTIC_SilverCoin);
         SResourcesCore.TexturesLobby.LoadSecondary(CONST_LOBBY.TEXTUREID_EFFECT_BALLISTIC_BlueSoul);
         SResourcesCore.TexturesLobby.LoadSecondary(CONST_LOBBY.TEXTUREID_EFFECT_BALLISTIC_PurpleSoul);
         SResourcesCore.TexturesLobby.LoadSecondary(CONST_LOBBY.TEXTUREID_EFFECT_BALLISTIC_GoldSoul);
         SResourcesCore.TexturesLobby.LoadSecondary(CONST_LOBBY.TEXTUREID_EFFECT_BALLISTIC_AcquireInventory);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIWait() : void
      {
         if(SResourcesCore.TexturesLobby.LoadingSecondary)
         {
            return;
         }
         super.ResourcesPerform_UIWait();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:TResourceRepositoryTexture = null;
         _loc1_ = SResourcesCore.TexturesLobby;
         this.FSequenceUserLevelUp = _loc1_.GetAnimationSequenceByIdentifiers(CONST_LOBBY.TEXTUREID_EffectUserLevelUp,SEQUENCEID_Default);
         this.FSequenceAutomaticallyFind = _loc1_.GetAnimationSequenceByIdentifiers(CONST_LOBBY.TEXTUREID_EffectAutomaticallyFind,SEQUENCEID_Default);
         this.FSequenceAcceptTask = _loc1_.GetAnimationSequenceByIdentifiers(CONST_LOBBY.TEXTUREID_EffectAcceptTask,SEQUENCEID_Default);
         this.FSequenceCompleteTask = _loc1_.GetAnimationSequenceByIdentifiers(CONST_LOBBY.TEXTUREID_EffectCompleteTask,SEQUENCEID_Default);
         this.FResourcesTexturesBallisticSilverCoin = _loc1_.GetTextureByIdentifier(CONST_LOBBY.TEXTUREID_EFFECT_BALLISTIC_SilverCoin);
         this.ResourceSetDispatch_Ballistic();
         super.ResourcesPerform_UIDispatch();
      }
      
      protected function ResourceSetDispatch_Ballistic() : void
      {
         var _loc1_:TResourceRepositoryTexture = null;
         var _loc2_:TTexture = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         _loc1_ = SResourcesCore.TexturesLobby;
         _loc6_ = CONST_LOBBY.TEXTUREID_EFFECT_BALLISTIC_BlueSoul;
         _loc3_ = CAPACITY_SoulClass;
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            this.FResourcesTexturesBallisticSoul[_loc4_] = _loc1_.GetTextureByIdentifier(_loc6_ + _loc4_);
            _loc4_++;
         }
         this.FResourcesTexturesBallisticAcquireInventory = _loc1_.GetTextureByIdentifier(CONST_LOBBY.TEXTUREID_EFFECT_BALLISTIC_AcquireInventory);
      }
      
      override protected function AffairRegisterRoutines() : void
      {
         super.AffairRegisterRoutines();
         FAffairRoutines.Register(AFFAIRID_ImportUserLevelUp,this.AffairPerform_ImportUserLevelUp);
         FAffairRoutines.Register(AFFAIRID_ImportAutomaticallyFind,this.AffairPerform_ImportAutomaticallyFind);
         FAffairRoutines.Register(AFFAIRID_ImportAcceptTask,this.AffairPerform_ImportAcceptTask);
         FAffairRoutines.Register(AFFAIRID_ImportCompleteTask,this.AffairPerform_ImportCompleteTask);
      }
      
      protected function AffairPerform_ImportUserLevelUp(param1:TAffair) : void
      {
         this.ImportingPerform_UserLevelUp();
      }
      
      protected function AffairPerform_ImportAutomaticallyFind(param1:TAffair) : void
      {
         this.ImportingPerform_AutomaticallyFind();
      }
      
      protected function AffairPerform_ImportAcceptTask(param1:TAffair) : void
      {
         this.ImportingPerform_AcceptTask();
      }
      
      protected function AffairPerform_ImportCompleteTask(param1:TAffair) : void
      {
         this.ImportingPerform_CompleteTask();
      }
      
      protected function ImportingPerform_Text(param1:String, param2:TEffectTextParameters = null, param3:TEffectCoordinateParameters = null) : void
      {
         var _loc4_:* = 0;
         var _loc5_:int = 0;
         var _loc6_:TEffectTextLinearCrossfade = null;
         var _loc7_:TEffect = null;
         this.FCoordinateText.X = COORDINATE_TextX;
         this.FCoordinateText.Y = COORDINATE_TextY;
         _loc6_ = FPoolEffect.AcquireTextLinearCrossfade(this);
         if(param2 != null)
         {
            _loc6_.SetupResources(param1,param2);
         }
         else
         {
            _loc6_.SetupResources(param1,this.FTextParameters);
         }
         if(param3 != null)
         {
            this.FEffectCoordinateParameters.Assign(param3);
            this.FCoordinateText.X = param3.X;
            this.FCoordinateText.Y = param3.Y;
         }
         else
         {
            this.FEffectCoordinateParameters.Reset();
         }
         _loc5_ = this.FLayerText.Count;
         this.FEffectHeight = 0;
         if(this.FLayerText.Count > 0)
         {
            _loc4_ = int(_loc5_ - 1);
            while(_loc4_ >= 0)
            {
               _loc7_ = this.FLayerText.GetEffectByIndex(_loc4_) as TEffect;
               if(!_loc7_.IsParallelOutput)
               {
                  break;
               }
               if(_loc5_ - _loc4_ > CAPACITY_ParallelOutputRows)
               {
                  _loc7_.TerminateMovement();
               }
               else
               {
                  this.FEffectHeight += IEffectText(_loc7_).TextHeight / 2;
                  _loc7_.SourceY = this.FCoordinateText.Y - this.FEffectHeight - IEffectText(_loc6_).TextHeight / 2;
                  this.FEffectHeight += IEffectText(_loc7_).TextHeight / 2;
               }
               _loc4_--;
            }
         }
         _loc6_.SetupMovement(this.FCoordinateText,STimingCore.TickCount,this.FEffectCoordinateParameters.FadeInTicks,this.FEffectCoordinateParameters.FadeOutTicks,this.FEffectCoordinateParameters.SustainTicks,this.FEffectCoordinateParameters.VelocityX,this.FEffectCoordinateParameters.VelocityY,this.FEffectCoordinateParameters.PauseTicks,this.FEffectCoordinateParameters.PauseSustainTicks,this.FEffectCoordinateParameters.IsShakeEffect,this.FEffectCoordinateParameters.IsScale,this.FEffectCoordinateParameters.IsParallelOutput);
         this.FLayerText.Add(_loc6_);
      }
      
      protected function ImportingPerform_HtmlText(param1:String, param2:TEffectCoordinateParameters = null) : void
      {
         var _loc3_:* = 0;
         var _loc4_:int = 0;
         var _loc5_:TEffectHtmlTextLinearCrossfade = null;
         var _loc6_:TEffect = null;
         this.FCoordinateText.X = COORDINATE_TextX;
         this.FCoordinateText.Y = COORDINATE_TextY;
         _loc5_ = FPoolEffect.AcquireHtmlTextLinearCrossfade(this);
         _loc5_.SetupResources(param1);
         if(param2 != null)
         {
            this.FEffectCoordinateParameters.Assign(param2);
            this.FCoordinateText.X = param2.X;
            this.FCoordinateText.Y = param2.Y;
         }
         else
         {
            this.FEffectCoordinateParameters.Reset();
         }
         _loc4_ = this.FLayerText.Count;
         this.FEffectHeight = 0;
         if(this.FLayerText.Count > 0)
         {
            _loc3_ = int(_loc4_ - 1);
            while(_loc3_ >= 0)
            {
               _loc6_ = this.FLayerText.GetEffectByIndex(_loc3_) as TEffect;
               if(!_loc6_.IsParallelOutput)
               {
                  break;
               }
               if(_loc4_ - _loc3_ > CAPACITY_ParallelOutputRows)
               {
                  _loc6_.TerminateMovement();
               }
               else
               {
                  this.FEffectHeight += IEffectText(_loc6_).TextHeight / 2;
                  _loc6_.SourceY = this.FCoordinateText.Y - this.FEffectHeight - IEffectText(_loc5_).TextHeight / 2;
                  this.FEffectHeight += IEffectText(_loc6_).TextHeight / 2;
               }
               _loc3_--;
            }
         }
         _loc5_.SetupMovement(this.FCoordinateText,STimingCore.TickCount,this.FEffectCoordinateParameters.FadeInTicks,this.FEffectCoordinateParameters.FadeOutTicks,this.FEffectCoordinateParameters.SustainTicks,this.FEffectCoordinateParameters.VelocityX,this.FEffectCoordinateParameters.VelocityY,this.FEffectCoordinateParameters.PauseTicks,this.FEffectCoordinateParameters.PauseSustainTicks,this.FEffectCoordinateParameters.IsShakeEffect,this.FEffectCoordinateParameters.IsScale,this.FEffectCoordinateParameters.IsParallelOutput);
         this.FLayerText.Add(_loc5_);
      }
      
      protected function ImportingPerform_UserLevelUp() : void
      {
         var _loc1_:TEffectAnimationLinearCrossfade = null;
         this.FCoordinateScene.X = COORDINATE_EffectX;
         this.FCoordinateScene.Y = COORDINATE_UserLevelUpY;
         _loc1_ = FPoolEffect.AcquireAnimationLinearCrossfade(this);
         _loc1_.SetupResources(this.FSequenceUserLevelUp);
         _loc1_.SetupMovement(this.FCoordinateScene,STimingCore.TickCount,this.FEffectCoordinateParameters.FadeInTicks,this.FEffectCoordinateParameters.FadeOutTicks,this.FEffectCoordinateParameters.SustainTicks + TIME_UserLevelUp_SustainTicksOffset,this.FEffectCoordinateParameters.VelocityX,0,this.FEffectCoordinateParameters.PauseTicks,this.FEffectCoordinateParameters.PauseSustainTicks,this.FEffectCoordinateParameters.IsScale);
         FLayerBase.Add(_loc1_);
      }
      
      protected function ImportingPerform_AutomaticallyFind() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:TEffectAnimationLinear = null;
         _loc1_ = this.IsRunVerificationAutomaticallyFind();
         if(_loc1_)
         {
            return;
         }
         this.FCoordinateScene.X = COORDINATE_EffectX;
         this.FCoordinateScene.Y = COORDINATE_EffectY;
         _loc2_ = FPoolEffect.AcquireAnimationLinear(this);
         _loc2_.Tag = AFFAIRID_ImportAutomaticallyFind;
         _loc2_.SetupResources(this.FSequenceAutomaticallyFind);
         _loc2_.SetupMovement(this.FCoordinateScene,STimingCore.TickCount,int.MAX_VALUE,0,0,0,0);
         FLayerBase.Add(_loc2_);
      }
      
      protected function ImportingPerform_AcceptTask() : void
      {
         var _loc1_:TEffectAnimationLinearCrossfade = null;
         this.FCoordinateScene.X = COORDINATE_EffectX;
         this.FCoordinateScene.Y = COORDINATE_EffectY;
         _loc1_ = FPoolEffect.AcquireAnimationLinearCrossfade(this);
         _loc1_.SetupResources(this.FSequenceAcceptTask);
         _loc1_.SetupMovement(this.FCoordinateScene,STimingCore.TickCount,this.FEffectCoordinateParameters.FadeInTicks,this.FEffectCoordinateParameters.FadeOutTicks,this.FEffectCoordinateParameters.SustainTicks + TIME_UserAcceptTask_SustainTicksOffset,this.FEffectCoordinateParameters.VelocityX,0,this.FEffectCoordinateParameters.PauseTicks,this.FEffectCoordinateParameters.PauseSustainTicks,this.FEffectCoordinateParameters.IsScale);
         FLayerBase.Add(_loc1_);
      }
      
      protected function ImportingPerform_CompleteTask() : void
      {
         var _loc1_:TEffectAnimationLinearCrossfade = null;
         this.FCoordinateScene.X = COORDINATE_EffectX;
         this.FCoordinateScene.Y = COORDINATE_EffectY;
         _loc1_ = FPoolEffect.AcquireAnimationLinearCrossfade(this);
         _loc1_.SetupResources(this.FSequenceCompleteTask);
         _loc1_.SetupMovement(this.FCoordinateScene,STimingCore.TickCount,this.FEffectCoordinateParameters.FadeInTicks,this.FEffectCoordinateParameters.FadeOutTicks,this.FEffectCoordinateParameters.SustainTicks + TIME_UserCompleteTask_SustainTicksOffset,this.FEffectCoordinateParameters.VelocityX,0,this.FEffectCoordinateParameters.PauseTicks,this.FEffectCoordinateParameters.PauseSustainTicks,this.FEffectCoordinateParameters.IsScale);
         FLayerBase.Add(_loc1_);
      }
      
      protected function ImportingPerform_SilverCoinStride(param1:uint, param2:TEffectCoordinateParameters) : void
      {
         var _loc3_:int = 0;
         _loc3_ = 0;
         while(_loc3_ < param1)
         {
            this.ImportingPerform_SilverCoinStrideStep(param2);
            _loc3_++;
         }
      }
      
      protected function ImportingPerform_SilverCoinStrideStep(param1:TEffectCoordinateParameters = null) : void
      {
         if(param1 != null)
         {
            this.FCoordinateBallistic.Assign(param1.CoordinateSource);
         }
         else
         {
            this.FCoordinateBallistic.X = COORDINATE_BallisticX;
            this.FCoordinateBallistic.Y = COORDINATE_BallisticY;
         }
         this.EffectingPerform_SilverCoinBallistic(this.FCoordinateBallistic);
      }
      
      protected function EffectingPerform_SilverCoinBallistic(param1:TCoordinate) : void
      {
         var _loc2_:TEffectPuzzleBallistic = null;
         var _loc3_:int = 0;
         var _loc4_:TTexture = null;
         var _loc5_:Number = NaN;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         _loc4_ = this.FResourcesTexturesBallisticSilverCoin;
         if(_loc4_ == null)
         {
            return;
         }
         this.EffectSilverCoinBallisticFlushDestination(this.FCoordinateBallisticDestination);
         _loc5_ = TUtilityCartisian.CoordinateDistance(this.FCoordinateBallisticDestination,param1);
         _loc6_ = CONST_EFFECT.EFFECT_BALLISTIC_TickBase + CONST_EFFECT.EFFECT_BALLISTIC_TickCoefficient * _loc5_;
         _loc7_ = this.FEffectBallisticIntervalIndex * CONST_EFFECT.EFFECT_BALLISTIC_TickInterval + CONST_EFFECT.EFFECT_BALLISTIC_LuckyCat_TickInterval;
         _loc2_ = FPoolEffect.AcquirePuzzleBallistic(this);
         _loc2_.SetupResources(_loc4_);
         _loc2_.SetupMovement(this.FCoordinateBallisticDestination,param1,STimingCore.TickCount + _loc7_,_loc6_,CONST_EFFECT.EFFECT_BALLISTIC_VelocityX + TUtilityMath.RandomRange(0,250,true),CONST_EFFECT.EFFECT_BALLISTIC_VelocityY + TUtilityMath.RandomRange(-200,200,true));
         this.FLayerBallistic.Add(_loc2_);
         ++this.FEffectBallisticIntervalIndex;
         if(this.FEffectBallisticIntervalIndex >= 4)
         {
            this.FEffectBallisticIntervalIndex = 0;
         }
      }
      
      protected function EffectSilverCoinBallisticFlushDestination(param1:TCoordinate) : void
      {
         this.FBoundsLocating.X = 20;
         this.FBoundsLocating.Y = 20;
         this.FBoundsLocating.Width = 20;
         this.FBoundsLocating.Height = 18;
         param1.X = TUtilityMath.RandomRange(this.FBoundsLocating.X,this.FBoundsLocating.XEnd);
         param1.Y = TUtilityMath.RandomRange(this.FBoundsLocating.Y,this.FBoundsLocating.YEnd);
      }
      
      protected function ImportingPerform_SoulStride(param1:uint, param2:uint, param3:TEffectCoordinateParameters) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         _loc5_ = int(param2);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            this.ImportingPerform_SoulStrideStep(param1,param3);
            _loc4_++;
         }
      }
      
      protected function ImportingPerform_SoulStrideStep(param1:uint, param2:TEffectCoordinateParameters = null) : void
      {
         if(param2 != null)
         {
            this.FCoordinateBallistic.Assign(param2.CoordinateDestination);
         }
         else
         {
            this.FCoordinateBallistic.X = COORDINATE_BallisticX;
            this.FCoordinateBallistic.Y = COORDINATE_BallisticY;
         }
         this.EffectingPerform_SoulBallistic(this.FCoordinateBallistic,param1);
      }
      
      protected function EffectingPerform_SoulBallistic(param1:TCoordinate, param2:uint) : void
      {
         var _loc3_:TEffectPuzzleBallistic = null;
         var _loc4_:int = 0;
         var _loc5_:TTexture = null;
         var _loc6_:Number = NaN;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         _loc5_ = this.FResourcesTexturesBallisticSoul[param2];
         if(_loc5_ == null)
         {
            return;
         }
         this.EffectSoulBallisticFlushDestination(this.FCoordinateBallisticDestination,param2);
         _loc6_ = TUtilityCartisian.CoordinateDistance(this.FCoordinateBallisticDestination,param1);
         _loc7_ = CONST_EFFECT.EFFECT_BALLISTIC_TickBase + CONST_EFFECT.EFFECT_BALLISTIC_TickCoefficient * _loc6_;
         _loc8_ = this.FEffectBallisticIntervalIndex * CONST_EFFECT.EFFECT_BALLISTIC_TickInterval;
         _loc3_ = FPoolEffect.AcquirePuzzleBallistic(this);
         _loc3_.SetupResources(_loc5_);
         _loc3_.SetupMovement(this.FCoordinateBallisticDestination,param1,STimingCore.TickCount + _loc8_,_loc7_,CONST_EFFECT.EFFECT_BALLISTIC_VelocityX + TUtilityMath.RandomRange(0,250,true),CONST_EFFECT.EFFECT_BALLISTIC_VelocityY + TUtilityMath.RandomRange(-200,200,true));
         this.FLayerBallistic.Add(_loc3_);
         ++this.FEffectBallisticIntervalIndex;
         if(this.FEffectBallisticIntervalIndex >= 4)
         {
            this.FEffectBallisticIntervalIndex = 0;
         }
      }
      
      protected function EffectSoulBallisticIndexBySoulClass(param1:uint) : int
      {
         switch(param1)
         {
            case CONST_EFFECT.SOULCLASS_BlueSoul:
            case CONST_EFFECT.SOULCLASS_PurpleSoul:
            case CONST_EFFECT.SOULCLASS_GoldSoul:
            case CONST_EFFECT.SOULCLASS_OrangeSoul:
               return param1;
            default:
               return param1;
         }
      }
      
      protected function EffectSoulBallisticFlushDestination(param1:TCoordinate, param2:uint) : void
      {
         var _loc3_:uint = 0;
         switch(param2)
         {
            case 0:
               this.FBoundsLocating.Y = 60;
               break;
            case 1:
               this.FBoundsLocating.Y = 95;
               break;
            case 2:
               this.FBoundsLocating.Y = 128;
         }
         this.FBoundsLocating.X = 20;
         this.FBoundsLocating.Width = 15;
         this.FBoundsLocating.Height = 20;
         param1.X = TUtilityMath.RandomRange(this.FBoundsLocating.X,this.FBoundsLocating.XEnd);
         param1.Y = TUtilityMath.RandomRange(this.FBoundsLocating.Y,this.FBoundsLocating.YEnd);
      }
      
      protected function IsRunVerificationAutomaticallyFind() : Boolean
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Boolean = false;
         var _loc4_:TEffect = null;
         _loc3_ = false;
         _loc2_ = FLayerBase.Count;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc4_ = FLayerBase.GetEffectByIndex(_loc1_);
            if(_loc4_.Tag == AFFAIRID_ImportAutomaticallyFind)
            {
               _loc3_ = true;
               break;
            }
            _loc1_++;
         }
         return _loc3_;
      }
      
      protected function ImportingPerform_AcquireInventory(param1:Object, param2:TEffectCoordinateParameters = null) : void
      {
         var _loc3_:TEffectCoordinateParameters = null;
         _loc3_ = new TEffectCoordinateParameters();
         _loc3_.Assign(param2);
         this.FAcquireInventories.push(param1);
         this.FEffectsParameters.push(_loc3_);
      }
      
      protected function EffectingPerform_AcquireInventory(param1:TTexture, param2:TEffectCoordinateParameters) : void
      {
         var _loc3_:TEffectPuzzleBallistic = null;
         var _loc4_:int = 0;
         var _loc5_:TTexture = null;
         var _loc6_:TAnimationSequence = null;
         var _loc7_:TAnimationSequence = null;
         var _loc8_:TAnimationSequence = null;
         var _loc9_:Number = NaN;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         if(this.FResourcesTexturesBallisticAcquireInventory == null)
         {
            return;
         }
         _loc6_ = this.FResourcesTexturesBallisticAcquireInventory.GetAnimationSequenceByIndex(0);
         _loc7_ = new TAnimationSequence(1);
         _loc7_.FrameAppend(param1.GetAnimationSequenceByIndex(0).GetAnimationFrameByIndex(0));
         _loc8_ = this.FResourcesTexturesBallisticAcquireInventory.GetAnimationSequenceByIndex(2);
         _loc5_ = new TTexture(0);
         _loc5_.SequenceAppend(_loc6_);
         _loc5_.SequenceAppend(_loc7_);
         _loc5_.SequenceAppend(_loc8_);
         _loc9_ = TUtilityCartisian.CoordinateDistance(param2.CoordinateDestination,param2.CoordinateSource);
         _loc10_ = CONST_EFFECT.EFFECT_BALLISTIC_TickBase + CONST_EFFECT.EFFECT_BALLISTIC_TickCoefficient * _loc9_;
         _loc11_ = CONST_EFFECT.EFFECT_BALLISTIC_AcquireInventory_TickInterval;
         _loc3_ = FPoolEffect.AcquirePuzzleBallistic(this);
         _loc3_.SetupResources(_loc5_);
         _loc3_.SetupMovement(param2.CoordinateDestination,param2.CoordinateSource,STimingCore.TickCount + _loc11_,_loc10_,CONST_EFFECT.EFFECT_BALLISTIC_VelocityX + TUtilityMath.RandomRange(-50,50,true),CONST_EFFECT.EFFECT_BALLISTIC_VelocityY + TUtilityMath.RandomRange(0,50,true));
         this.FLayerBallistic.Add(_loc3_);
      }
      
      protected function DeleteEffectByAffairID(param1:uint) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TEffect = null;
         _loc3_ = FLayerBase.Count;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = FLayerBase.GetEffectByIndex(_loc2_);
            if(_loc4_.Tag == param1)
            {
               FLayerBase.Delete(_loc2_);
               break;
            }
            _loc2_++;
         }
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         this.LogicsPerform_AcquireInventory();
      }
      
      protected function LogicsPerform_AcquireInventory() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Object = null;
         var _loc4_:TTexture = null;
         var _loc5_:TEffectCoordinateParameters = null;
         _loc2_ = int(this.FAcquireInventories.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FAcquireInventories[_loc1_];
            _loc4_ = this.GetTextureByContext(_loc3_);
            if(_loc4_ != null)
            {
               _loc5_ = this.FEffectsParameters[_loc1_];
               this.EffectingPerform_AcquireInventory(_loc4_,_loc5_);
               this.FAcquireInventories.splice(_loc1_,1);
               this.FEffectsParameters.splice(_loc1_,1);
               break;
            }
            _loc1_++;
         }
      }
      
      protected function GetTextureByContext(param1:Object) : TTexture
      {
         var _loc2_:TResourceRepositoryTexture = null;
         var _loc3_:TTexture = null;
         var _loc4_:TInventory = null;
         var _loc5_:TSkill = null;
         var _loc6_:uint = 0;
         var _loc7_:TTexture = null;
         _loc7_ = null;
         if(param1 is TInventory)
         {
            _loc4_ = param1 as TInventory;
            _loc2_ = SResourcesCore.TexturesInventory;
            _loc6_ = _loc4_.IDTexture;
         }
         else if(param1 is TSkill)
         {
            _loc5_ = param1 as TSkill;
            _loc2_ = SResourcesCore.TexturesSkillIcon;
            _loc6_ = _loc5_.IDTexture;
         }
         _loc3_ = _loc2_.GetTextureByIdentifier(_loc6_);
         if(_loc3_ != null)
         {
            _loc7_ = _loc3_;
         }
         else
         {
            _loc2_.LoadSecondary(_loc6_);
         }
         return _loc7_;
      }
      
      public function ImportText(param1:String, param2:TEffectTextParameters = null, param3:TEffectCoordinateParameters = null) : void
      {
         this.ImportingPerform_Text(param1,param2,param3);
      }
      
      public function ImportHtmlText(param1:String, param2:TEffectCoordinateParameters = null) : void
      {
         this.ImportingPerform_HtmlText(param1,param2);
      }
      
      public function ImportUserLevelUp() : void
      {
         FAffairGenerator.Generate(AFFAIRID_ImportUserLevelUp);
      }
      
      public function ImportUserAutomaticallyFind(param1:Boolean = true) : void
      {
         if(param1)
         {
            FAffairGenerator.Generate(AFFAIRID_ImportAutomaticallyFind);
         }
         else
         {
            FAffairs.DeleteByIdentifier(AFFAIRID_ImportAutomaticallyFind);
            this.DeleteEffectByAffairID(AFFAIRID_ImportAutomaticallyFind);
         }
      }
      
      public function ImportUserAcceptTask() : void
      {
         FAffairGenerator.Generate(AFFAIRID_ImportAcceptTask);
      }
      
      public function ImportUserCompleteTask() : void
      {
         FAffairGenerator.Generate(AFFAIRID_ImportCompleteTask);
      }
      
      public function ImportSilverCoin(param1:uint, param2:TEffectCoordinateParameters) : void
      {
         this.ImportingPerform_SilverCoinStride(param1,param2);
      }
      
      public function ImportSoul(param1:uint, param2:uint, param3:TEffectCoordinateParameters) : void
      {
         this.ImportingPerform_SoulStride(param1,param2,param3);
      }
      
      public function ImportAcquireInventory(param1:Object, param2:TEffectCoordinateParameters = null) : void
      {
         this.ImportingPerform_AcquireInventory(param1,param2);
      }
      
      public function ImportSugar(param1:uint, param2:uint, param3:TEffectCoordinateParameters) : void
      {
      }
   }
}

