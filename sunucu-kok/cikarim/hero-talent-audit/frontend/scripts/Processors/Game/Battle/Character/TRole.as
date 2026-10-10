package Processors.Game.Battle.Character
{
   import Foundation.Common.TBounds;
   import Foundation.Common.TCoordinate;
   import Foundation.Resources.*;
   import Foundation.Resources.Bins.TBins;
   import Foundation.Resources.Textures.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.Battle.*;
   import Logics.Battle.model.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.SLogicsCore;
   import Processors.Game.Battle.*;
   import Processors.Game.Battle.Effect.*;
   import Processors.Game.Battle.GoneWord.TGoneWord;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   import flash.utils.*;
   import ghostcat.util.easing.Expo;
   import ghostcat.util.easing.TweenUtil;
   
   public class TRole extends TBaseRole
   {
      
      protected static const SIZE_FrameRatePerSecond:int = CONST_COMMON.SIZE_FrameRatePerSecond;
      
      public static const CONST_BUFF_Const:int = 7;
      
      public static const CONST_BUFF_Width:Number = 22;
      
      public static const CONST_BUFF_Height:Number = 22;
      
      public static const CONST_BUFF_StampX_Left:int = -50;
      
      public static const CONST_BUFF_StampX_Right:int = 50;
      
      public static const CONST_BUFF_StampY:Number = -130;
      
      protected var FWaitNextCommand:Boolean;
      
      protected var FStatusGridFile:Boolean;
      
      protected var FSkillBins:TBins;
      
      protected var FBuffBins:TBins;
      
      protected var FHideFrame:int;
      
      protected var FBattleStage:TBattleStage;
      
      protected var FBuffIdVect:Vector.<uint>;
      
      protected var FBuffTurnVect:Vector.<uint>;
      
      protected var FBuffSpriteVect:Vector.<Sprite>;
      
      protected var FIsNewBuffVect:Vector.<Boolean>;
      
      protected var FStatusGoneWordDict:Dictionary;
      
      protected var FHasGiddy:Boolean;
      
      protected var FGiddySequence:TAnimationSequence;
      
      protected var FGiddyBitmap:Bitmap;
      
      protected var FShieldBlood:Number;
      
      protected var FShieldBitmap:Bitmap;
      
      protected var FShieldSequence:TAnimationSequence;
      
      protected var FHasFrozen:Boolean;
      
      protected var FFrozenBitmap:Bitmap;
      
      protected var FFrozenSequence:TAnimationSequence;
      
      protected var FOnEffectEnd:Function;
      
      protected var FTextFunction:Function;
      
      protected var FActiveCallBack:Function;
      
      protected var FActiveTime:uint;
      
      protected var FOnBuffMouseMove:Function;
      
      protected var FOnBuffMouseRollOut:Function;
      
      protected var FOnBigSkill:Function;
      
      public function TRole(param1:TUIComponent, param2:TRoleBattleInfo, param3:TBattleStage, param4:Function = null)
      {
         super(param1,param2);
         this.FBattleStage = param3;
         this.FTextFunction = param4;
         this.FStatusGoneWordDict = new Dictionary();
         this.FSkillBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_SkillConfig);
         this.FBuffBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_BuffEffect);
         this.FBuffIdVect = new Vector.<uint>();
         this.FBuffTurnVect = new Vector.<uint>();
         this.FBuffSpriteVect = new Vector.<Sprite>();
         this.FIsNewBuffVect = new Vector.<Boolean>();
         this.FGiddyBitmap = new Bitmap();
         addChild(this.FGiddyBitmap);
         this.FShieldBitmap = new Bitmap();
         this.FShieldBitmap.visible = false;
         addChild(this.FShieldBitmap);
         this.FFrozenBitmap = new Bitmap();
         addChild(this.FFrozenBitmap);
         this.InitCharacter();
         this.LoadResources(CONST_BATTLE.Public_Effect_Giddy);
         this.LoadResources(CONST_BATTLE.Public_Effect_Shield);
         this.CheckDirection();
         this.FShieldBlood = 0;
      }
      
      protected function InitCharacter() : void
      {
         this.FWaitNextCommand = false;
         FIsAntiColorBlackWhite = false;
         FIsRedAntiColor = false;
         this.FStatusGridFile = false;
         this.FHideFrame = -1;
         if(FResourcesType != TYPE_KNIFE)
         {
            this.SetPosition(SBattleConfig.GetPostionByCamyPos(Camp,Pos,SBattleConfig.Type_PostionX),SBattleConfig.GetPostionByCamyPos(Camp,Pos,SBattleConfig.Type_PostionY));
         }
      }
      
      override protected function LoadResources(param1:uint) : void
      {
         super.LoadResources(param1);
         switch(param1)
         {
            case CONST_BATTLE.Public_Effect_Giddy:
               SResourcesCore.TexturesSkill.LoadAutoSecondary(CONST_BATTLE.Public_Effect_Giddy,this.AutoLoadCallBack);
               break;
            case CONST_BATTLE.Public_Effect_Shield:
               SResourcesCore.TexturesSkill.LoadAutoSecondary(CONST_BATTLE.Public_Effect_Shield,this.AutoLoadCallBack);
               break;
            case CONST_BATTLE.Public_Effect_Frozen:
               SResourcesCore.TexturesSkill.LoadAutoSecondary(CONST_BATTLE.Public_Effect_Frozen,this.AutoLoadCallBack);
         }
      }
      
      override protected function AutoLoadCallBack(param1:Object, param2:TTexture, param3:uint) : void
      {
         var _loc4_:TAnimationSequence = null;
         var _loc5_:TBounds = null;
         var _loc6_:TCoordinate = null;
         super.AutoLoadCallBack(param1,param2,param3);
         _loc5_ = new TBounds();
         _loc6_ = new TCoordinate();
         switch(param3)
         {
            case CONST_BATTLE.Public_Effect_Giddy:
               _loc4_ = param2.GetAnimationSequenceByIndex(0);
               _loc4_.Evaluate(_loc6_,_loc5_);
               this.FGiddyBitmap.bitmapData = _loc4_.GetAnimationFrameByIndex(0).Surface;
               this.FGiddyBitmap.x = _loc5_.X;
               this.FGiddyBitmap.y = _loc5_.Y;
               this.FGiddySequence = _loc4_;
               break;
            case CONST_BATTLE.Public_Effect_Shield:
               _loc4_ = param2.GetAnimationSequenceByIndex(0);
               _loc4_.Evaluate(_loc6_,_loc5_);
               this.FShieldBitmap.bitmapData = _loc4_.GetAnimationFrameByIndex(0).Surface;
               this.FShieldBitmap.x = _loc5_.X;
               this.FShieldBitmap.y = _loc5_.Y;
               this.FShieldSequence = _loc4_;
               break;
            case CONST_BATTLE.Public_Effect_Frozen:
               _loc4_ = param2.GetAnimationSequenceByIndex(0);
               _loc4_.Evaluate(_loc6_,_loc5_);
               this.FFrozenBitmap.bitmapData = _loc4_.GetAnimationFrameByIndex(0).Surface;
               this.FFrozenBitmap.x = _loc5_.X;
               this.FFrozenBitmap.y = _loc5_.Y;
               this.FFrozenSequence = _loc4_;
         }
         _loc5_ = null;
         _loc6_ = null;
      }
      
      protected function PlayShowUI(param1:int) : void
      {
         var SkillName:String;
         var Skill:TSkillConfig = null;
         var ShowUIEnd:Function = null;
         var ExpandFilter:Function = null;
         var SkillId:int = param1;
         ShowUIEnd = function():void
         {
            DelStatus(CONST_BATTLE.TEXT_FIGHT_STATUS_OtherTurn,CONST_BATTLE.TEXT_FIGHT_STATUS_Punch);
            FSkillId = Skill.SkillId;
            PlaySkill();
         };
         ExpandFilter = function():void
         {
            FBitmap.filters = [];
         };
         if(stage == null)
         {
            return;
         }
         SkillName = "";
         if(FEnemy != null)
         {
            Skill = this.FSkillBins.GetDatebaseByIdentifier(SkillId) as TSkillConfig;
            if(!FEnemy.IsBoss)
            {
               ShowUIEnd();
               return;
            }
         }
         else
         {
            if(FHero == null)
            {
               Skill = this.FSkillBins.GetDatebaseByIdentifier(SkillId) as TSkillConfig;
               ShowUIEnd();
               return;
            }
            Skill = this.FSkillBins.GetDatebaseByIdentifier(SkillId) as TSkillConfig;
         }
         SkillName = Skill.Name;
         FBitmap.filters = TUtilityFilter.SKILL_FILTERS;
         setTimeout(ExpandFilter,100);
         TEffectControl.ShowEffect(this,CONST_BATTLE.Public_Effect_Effect);
         if(this.FOnBigSkill != null)
         {
            this.FOnBigSkill(this,FResourcesId,Camp,SkillName,ShowUIEnd);
         }
      }
      
      protected function ShowGridFile() : void
      {
         var _loc1_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < FTargets.length)
         {
            if(FResults[_loc1_].CMD != 0)
            {
               TEffectControl.ShowPublicEffect(FTargets[_loc1_],CONST_BATTLE.Public_Effect_Daoguang,0,0,this.EndGridFile);
               FTargets[_loc1_].ActivePlay(TYPE_ACTIVE_ATTACKED);
               FTargets[_loc1_].ChangeHP(FResults[_loc1_].ResultInfo.HurtHp);
               if(this.FTextFunction != null)
               {
                  this.FTextFunction(TBattleStage.TYPETEXT_Float,FTargets[_loc1_].Camp == 0 ? -1 : 1,FTargets[_loc1_].x,FTargets[_loc1_].y - FTargets[_loc1_].RoleHeight,int(FResults[_loc1_].ResultInfo.HurtHp));
               }
            }
            _loc1_++;
         }
      }
      
      protected function EndGridFile() : void
      {
         var _loc1_:Function = null;
         var _loc2_:uint = 0;
         this.FStatusGridFile = false;
         FBitmap.visible = true;
         _loc1_ = FCallBackDict[TYPE_ACTIVE_GRIDFILE];
         _loc2_ = uint(FTimeDict[TYPE_ACTIVE_GRIDFILE]);
         if(_loc1_ != null)
         {
            _loc1_(_loc2_);
         }
      }
      
      protected function GetSameBuffIndex(param1:Vector.<uint>, param2:int) : Vector.<int>
      {
         var _loc3_:int = 0;
         var _loc4_:Vector.<int> = null;
         var _loc5_:TBuffEffect = null;
         var _loc6_:TBuffEffect = null;
         _loc4_ = new Vector.<int>();
         _loc6_ = this.FBuffBins.GetDatebaseByIdentifier(param2) as TBuffEffect;
         _loc4_.push(_loc6_.Weight);
         _loc3_ = 0;
         while(_loc3_ < param1.length)
         {
            _loc5_ = this.FBuffBins.GetDatebaseByIdentifier(param1[_loc3_]) as TBuffEffect;
            if(_loc5_.BuffType == _loc6_.BuffType && this.GetAlterSame(_loc5_.AlterVect,_loc6_.AlterVect) && _loc5_.Buffkey == _loc6_.Buffkey)
            {
               _loc4_.push(_loc3_);
               _loc4_.push(_loc5_.Weight);
            }
            _loc3_++;
         }
         return _loc4_;
      }
      
      protected function DelSameTypeBuffIndex(param1:uint) : void
      {
         var _loc2_:* = 0;
         var _loc3_:TBuffEffect = null;
         _loc2_ = 0;
         while(_loc2_ < this.FBuffIdVect.length)
         {
            _loc3_ = this.FBuffBins.GetDatebaseByIdentifier(this.FBuffIdVect[_loc2_]) as TBuffEffect;
            if(_loc3_ != null)
            {
               if(param1 == _loc3_.BuffType)
               {
                  this.DelBuffs(_loc3_.Identifier);
                  _loc2_--;
               }
            }
            _loc2_++;
         }
      }
      
      protected function GetAlterSame(param1:Vector.<uint>, param2:Vector.<uint>) : Boolean
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         _loc3_ = 0;
         while(_loc3_ < param1.length)
         {
            _loc5_ = param2.indexOf(param1[_loc3_]);
            if(_loc5_ >= 0)
            {
               return true;
            }
            _loc3_++;
         }
         return false;
      }
      
      protected function DelBuffs(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Sprite = null;
         _loc2_ = this.FBuffIdVect.indexOf(param1);
         if(_loc2_ >= 0)
         {
            this.FBuffIdVect.splice(_loc2_,1);
            this.FBuffTurnVect.splice(_loc2_,1);
            _loc3_ = this.FBuffSpriteVect[_loc2_];
            this.FBuffSpriteVect.splice(_loc2_,1);
            this.FIsNewBuffVect.splice(_loc2_,1);
            this.SaveBitmapSprite(_loc3_);
         }
      }
      
      protected function DelBuffByIndex(param1:int) : void
      {
         var _loc2_:Sprite = null;
         if(param1 >= 0 && param1 < this.FBuffIdVect.length)
         {
            this.FBuffIdVect.splice(param1,1);
            this.FBuffTurnVect.splice(param1,1);
            _loc2_ = this.FBuffSpriteVect[param1];
            this.FBuffSpriteVect.splice(param1,1);
            this.FIsNewBuffVect.splice(param1,1);
            this.SaveBitmapSprite(_loc2_);
         }
      }
      
      protected function CheckBuffContinued(param1:uint, param2:int) : Boolean
      {
         var _loc3_:TBuffEffect = null;
         _loc3_ = this.FBuffBins.GetDatebaseByIdentifier(param1) as TBuffEffect;
         if(_loc3_ != null)
         {
            if(_loc3_.Continued == param2)
            {
               return true;
            }
         }
         return false;
      }
      
      protected function SaveBitmapSprite(param1:Sprite) : void
      {
         if(param1)
         {
            if(param1.hasEventListener(MouseEvent.MOUSE_MOVE))
            {
               param1.removeEventListener(MouseEvent.MOUSE_MOVE,this.OnMouseMove);
            }
            if(param1.hasEventListener(MouseEvent.ROLL_OUT))
            {
               param1.removeEventListener(MouseEvent.ROLL_OUT,this.OnRollOut);
            }
         }
         TPoolBitmap.SaveBitmapSprite(param1);
      }
      
      public function ChangeHP(param1:Number) : void
      {
         if(param1 < 0)
         {
            CurHealth -= param1;
         }
         else
         {
            this.FShieldBlood -= param1;
            if(this.FShieldBlood < 0)
            {
               CurHealth += this.FShieldBlood;
               this.FShieldBlood = 0;
               if(this.FShieldBitmap.visible != false)
               {
                  this.FShieldBitmap.visible = false;
               }
            }
         }
      }
      
      protected function OnMouseMove(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:TBuffEffect = null;
         _loc4_ = this.FBuffSpriteVect.indexOf(param1.target);
         if(_loc4_ < 0)
         {
            return;
         }
         _loc2_ = int(this.FBuffIdVect[_loc4_]);
         _loc3_ = int(this.FBuffTurnVect[_loc4_]);
         _loc5_ = this.FBuffBins.GetDatebaseByIdentifier(_loc2_) as TBuffEffect;
         if(this.FOnBuffMouseMove != null)
         {
            this.FOnBuffMouseMove(this,_loc5_.Name,_loc3_,_loc5_.Description);
         }
      }
      
      protected function OnRollOut(param1:MouseEvent) : void
      {
         if(this.FOnBuffMouseRollOut != null)
         {
            this.FOnBuffMouseRollOut(this);
         }
      }
      
      public function get BattleStage() : TBattleStage
      {
         return this.FBattleStage;
      }
      
      public function get OnEffectEnd() : Function
      {
         return this.FOnEffectEnd;
      }
      
      public function set OnEffectEnd(param1:Function) : void
      {
         this.FOnEffectEnd = param1;
      }
      
      public function get OnBuffMouseMove() : Function
      {
         return this.FOnBuffMouseMove;
      }
      
      public function set OnBuffMouseMove(param1:Function) : void
      {
         this.FOnBuffMouseMove = param1;
      }
      
      public function get OnBuffMouseRollOut() : Function
      {
         return this.FOnBuffMouseRollOut;
      }
      
      public function set OnBuffMouseRollOut(param1:Function) : void
      {
         this.FOnBuffMouseRollOut = param1;
      }
      
      public function get OnBigSkill() : Function
      {
         return this.FOnBigSkill;
      }
      
      public function set OnBigSkill(param1:Function) : void
      {
         this.FOnBigSkill = param1;
      }
      
      public function get SoundId() : uint
      {
         if(FEnemy != null)
         {
            return FEnemy.Sound;
         }
         if(FHero != null)
         {
            return FHero.Sound;
         }
         return 0;
      }
      
      override public function Reset() : void
      {
         var _loc1_:Sprite = null;
         super.Reset();
         while(this.FBuffSpriteVect.length)
         {
            _loc1_ = this.FBuffSpriteVect.pop();
            this.SaveBitmapSprite(_loc1_);
         }
         this.FBuffIdVect.length = 0;
         this.FBuffTurnVect.length = 0;
         this.FBuffSpriteVect.length = 0;
         this.FIsNewBuffVect.length = 0;
         this.FBuffIdVect.length = 0;
         this.FBuffTurnVect.length = 0;
         this.FBuffSpriteVect.length = 0;
         this.FIsNewBuffVect.length = 0;
         this.FBattleStage = null;
         this.FTextFunction = null;
         FShaderBmp.visible = true;
         FHpBar.visible = true;
         FBuffSprite.visible = true;
         this.alpha = 1;
         FBitmap.filters = [];
         this.filters = [];
         FSkillId = 0;
         AntiColorBlackWhite = false;
         FBitmap.visible = true;
         TweenUtil.removeTween(this,false);
         this.DelStatus(CONST_BATTLE.TEXT_FIGHT_STATUS_OtherTurn);
      }
      
      override public function ActivePlay(param1:int, param2:int = 0, param3:Vector.<TRole> = null, param4:Vector.<TTargetInfo> = null, param5:Function = null, param6:uint = 0, param7:Boolean = false) : void
      {
         var EndShake:Function;
         var EndDie:Function;
         var Index:uint = 0;
         var DeadSkillEffectId:uint = 0;
         var StampAnger:int = 0;
         var Type:int = param1;
         var SkillId:int = param2;
         var Target:Vector.<TRole> = param3;
         var Results:Vector.<TTargetInfo> = param4;
         var Callback:Function = param5;
         var Time:uint = param6;
         var NoTextEffect:Boolean = param7;
         super.ActivePlay(Type,SkillId,Target,Results,Callback,Time);
         if(Type == TYPE_ACTIVE_DEADSKILL && Target != null)
         {
            if(this.FTextFunction != null)
            {
               this.FTextFunction(TBattleStage.TYPETEXT_Float,Camp == 0 ? -1 : 1,x,y - RoleHeight,0,false,CONST_BATTLE.TEXT_FIGHT_STATUS_DeadSkill);
            }
            Index = 0;
            while(Index < Target.length)
            {
               if(Results[Index].CMD != TTargetInfo.CMD_NONE)
               {
                  if(Target[Index].Camp == Camp)
                  {
                     DeadSkillEffectId = uint(CONST_BATTLE.Public_Effect_DeadSkillEffect_Friend);
                  }
                  else
                  {
                     DeadSkillEffectId = uint(CONST_BATTLE.Public_Effect_DeadSkillEffect_Enemy);
                  }
                  Target[Index].AddEffect({
                     "target":2,
                     "effectId":DeadSkillEffectId,
                     "anmyhp":{
                        "1":100,
                        "checkDie":1
                     },
                     "friendhp":{"1":100}
                  },this,Vector.<TRole>([Target[Index]]),Vector.<TTargetInfo>([Results[Index]]));
               }
               if(Results[Index].ResultInfo.CMD == TTargetInfo.CMD_ATTACKEX)
               {
                  if(Results[Index].ResultInfo.HurtAnger > 0)
                  {
                     StampAnger = Math.min(Results[Index].ResultInfo.HurtAnger,Target[Index].CurAnger);
                  }
                  else
                  {
                     StampAnger = Results[Index].ResultInfo.HurtAnger;
                  }
                  Target[Index].AddAngerTextEffect(-StampAnger);
               }
               Target[Index].CurAnger -= Results[Index].ResultInfo.HurtAnger;
               Index++;
            }
            if(Callback != null)
            {
               Callback(Time);
            }
            return;
         }
         if(FIsDie)
         {
            if(Callback != null)
            {
               Callback(0);
            }
            return;
         }
         FSkillId = SkillId;
         FTargets = Target;
         FResults = Results;
         FSkilling = IsSkill(FSkillId);
         if(Type == TYPE_ACTIVE_FIGHT_IDLE)
         {
            PlayFightIdle();
            this.CheckDirection();
         }
         else if(Type == TYPE_ACTIVE_ATTACK)
         {
            this.DelStatus(CONST_BATTLE.TEXT_FIGHT_STATUS_OtherTurn,CONST_BATTLE.TEXT_FIGHT_STATUS_Punch);
            GetAttackEffect();
            FCallBackDict[TYPE_ACTIVE_ATTACK] = Callback;
            FTimeDict[TYPE_ACTIVE_ATTACK] = Time;
            PlayAttack();
         }
         else if(Type == TYPE_ACTIVE_ATTACKED)
         {
            FCallBackDict[TYPE_ACTIVE_ATTACKED] = Callback;
            FTimeDict[TYPE_ACTIVE_ATTACKED] = Time;
            PlayAttacked();
         }
         else if(Type == TYPE_ACTIVE_SKILL)
         {
            GetAttackEffect();
            FCallBackDict[TYPE_ACTIVE_SKILL] = Callback;
            FTimeDict[TYPE_ACTIVE_SKILL] = Time;
            FSkillId = 0;
            this.PlayShowUI(SkillId);
         }
         else if(Type == TYPE_ACTIVE_DODGE)
         {
            EndShake = function():void
            {
               if(Callback != null)
               {
                  Callback(Time);
               }
            };
            if(!NoTextEffect)
            {
               TEffectControl.Retreat(this);
               FCallBackDict[TYPE_ACTIVE_DODGE] = Callback;
               FTimeDict[TYPE_ACTIVE_DODGE] = Time;
               if(this.FTextFunction != null)
               {
                  this.FTextFunction(TBattleStage.TYPETEXT_Float,Camp == 0 ? -1 : 1,x,y - RoleHeight,0,false,CONST_BATTLE.TEXT_FIGHT_STATUS_Miss);
               }
            }
            else
            {
               EndShake();
            }
         }
         else if(Type == TYPE_ACTIVE_GRIDFILE)
         {
            if(this.FStatusGridFile)
            {
               return;
            }
            this.FStatusGridFile = true;
            FCallBackDict[TYPE_ACTIVE_GRIDFILE] = Callback;
            FTimeDict[TYPE_ACTIVE_GRIDFILE] = Time;
            if(this.FTextFunction != null)
            {
               this.FTextFunction(TBattleStage.TYPETEXT_Float,Camp == 0 ? -1 : 1,x,y - RoleHeight,0,false,CONST_BATTLE.TEXT_FIGHT_STATUS_Counterattack);
            }
            TEffectControl.ShowPublicEffect(FEffectSprite,CONST_BATTLE.Public_Effect_Stakes,0,0,this.ShowGridFile);
         }
         else if(Type == TYPE_ACTIVE_DIE)
         {
            EndDie = function():void
            {
               if(!FIsDie)
               {
                  return;
               }
               if(Callback != null)
               {
                  Callback(Time);
               }
            };
            FIsDie = true;
            FShaderBmp.visible = false;
            FHpBar.visible = false;
            FBuffSprite.visible = false;
            this.FHideFrame = 0;
            FBitmap.bitmapData = FBitmap.bitmapData.clone();
            FBitmap.filters = [TUtilityFilter.rBlackFilters];
            FCallBackDict[TYPE_ACTIVE_DIE] = Callback;
            FTimeDict[TYPE_ACTIVE_DIE] = Time;
            if(Camp == 0)
            {
               TweenUtil.to(this,1000,{
                  "x":this.x - 20,
                  "filters":[TUtilityFilter.ActiveDie],
                  "alpha":0,
                  "ease":Expo.easeOut,
                  "onComplete":EndDie
               });
            }
            else
            {
               TweenUtil.to(this,1000,{
                  "x":this.x + 20,
                  "filters":[TUtilityFilter.ActiveDie],
                  "alpha":0,
                  "ease":Expo.easeOut,
                  "onComplete":EndDie
               });
            }
         }
      }
      
      public function SetPosition(param1:Number, param2:Number) : void
      {
         FIdlePosition[0] = param1;
         FIdlePosition[1] = param2;
         this.x = param1;
         this.y = param2;
      }
      
      public function OnNextCommand(param1:int = 0) : void
      {
         if(this.FOnEffectEnd != null)
         {
            if(param1 > 0)
            {
               setTimeout(this.FOnEffectEnd,param1);
            }
            else
            {
               this.FOnEffectEnd();
            }
         }
      }
      
      public function CheckTextEffect(param1:TTargetInfo) : void
      {
         if(param1.TargetStatus & CONST_BATTLE.ActiveType_NoAddAnger)
         {
            param1.TargetStatus -= CONST_BATTLE.ActiveType_NoAddAnger;
            this.AddTextEffect(CONST_BATTLE.ActiveType_NoAddAnger);
         }
         if(param1.TargetStatus & CONST_BATTLE.ActiveType_NoSkill)
         {
            param1.TargetStatus -= CONST_BATTLE.ActiveType_NoSkill;
            this.AddTextEffect(CONST_BATTLE.ActiveType_NoSkill);
         }
         if(param1.TargetStatus & CONST_BATTLE.ActiveType_NoAddHp)
         {
            param1.TargetStatus -= CONST_BATTLE.ActiveType_NoAddHp;
            this.AddTextEffect(CONST_BATTLE.ActiveType_NoAddHp);
         }
         if(param1.TargetStatus & CONST_BATTLE.ActiveType_NoAttack)
         {
            param1.TargetStatus -= CONST_BATTLE.ActiveType_NoAttack;
            this.AddTextEffect(CONST_BATTLE.ActiveType_NoAttack);
         }
         if(param1.TargetStatus & CONST_BATTLE.ActiveType_BeStone)
         {
            param1.TargetStatus -= CONST_BATTLE.ActiveType_BeStone;
            this.AddTextEffect(CONST_BATTLE.ActiveType_BeStone);
         }
         if(param1.TargetStatus & CONST_BATTLE.ActiveType_Nothingness)
         {
            param1.TargetStatus -= CONST_BATTLE.ActiveType_Nothingness;
            this.AddTextEffect(CONST_BATTLE.ActiveType_Nothingness);
         }
         if(param1.TargetStatus & CONST_BATTLE.ActiveType_AllMiss)
         {
            param1.TargetStatus -= CONST_BATTLE.ActiveType_AllMiss;
            this.AddTextEffect(CONST_BATTLE.ActiveType_AllMiss);
         }
         if(param1.TargetStatus & CONST_BATTLE.ActiveType_Confusion)
         {
            param1.TargetStatus -= CONST_BATTLE.ActiveType_Confusion;
            this.AddTextEffect(CONST_BATTLE.ActiveType_Confusion);
         }
         if(param1.TargetStatus & CONST_BATTLE.ActiveType_ImmNoAnger)
         {
            param1.TargetStatus -= CONST_BATTLE.ActiveType_ImmNoAnger;
            this.AddTextEffect(CONST_BATTLE.ActiveType_ImmNoAnger);
         }
         if(param1.TargetStatus & CONST_BATTLE.ActiveType_ImmNoSkill)
         {
            param1.TargetStatus -= CONST_BATTLE.ActiveType_ImmNoSkill;
            this.AddTextEffect(CONST_BATTLE.ActiveType_ImmNoSkill);
         }
         if(param1.TargetStatus & CONST_BATTLE.ActiveType_ImmNoHeal)
         {
            param1.TargetStatus -= CONST_BATTLE.ActiveType_ImmNoHeal;
            this.AddTextEffect(CONST_BATTLE.ActiveType_ImmNoHeal);
         }
         if(param1.TargetStatus & CONST_BATTLE.ActiveType_ImmStone)
         {
            param1.TargetStatus -= CONST_BATTLE.ActiveType_ImmStone;
            this.AddTextEffect(CONST_BATTLE.ActiveType_ImmStone);
         }
         if(param1.TargetStatus & CONST_BATTLE.ActiveType_ImmFake)
         {
            param1.TargetStatus -= CONST_BATTLE.ActiveType_ImmFake;
            this.AddTextEffect(CONST_BATTLE.ActiveType_ImmFake);
         }
         if(param1.TargetStatus & CONST_BATTLE.ActiveType_ImmNoAttack)
         {
            param1.TargetStatus -= CONST_BATTLE.ActiveType_ImmNoAttack;
            this.AddTextEffect(CONST_BATTLE.ActiveType_ImmNoAttack);
         }
         if(param1.TargetStatus & CONST_BATTLE.ActiveType_ImmConfusion)
         {
            param1.TargetStatus -= CONST_BATTLE.ActiveType_ImmConfusion;
            this.AddTextEffect(CONST_BATTLE.ActiveType_ImmConfusion);
         }
         if(param1.TargetStatus & CONST_BATTLE.ActiveType_ImmAllMiss)
         {
            param1.TargetStatus -= CONST_BATTLE.ActiveType_ImmAllMiss;
            this.AddTextEffect(CONST_BATTLE.ActiveType_ImmAllMiss);
         }
         if(param1.TargetStatus & CONST_BATTLE.ActiveType_ImmMutilate)
         {
            param1.TargetStatus -= CONST_BATTLE.ActiveType_ImmMutilate;
            this.AddTextEffect(CONST_BATTLE.ActiveType_ImmMutilate);
         }
      }
      
      public function PassiveSkillPlay(param1:Vector.<TRole>, param2:Vector.<TTargetInfo>, param3:uint) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:TTargetInfo = null;
         var _loc6_:TRole = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         _loc4_ = 0;
         while(_loc4_ < param1.length)
         {
            _loc6_ = param1[_loc4_];
            _loc5_ = param2[_loc4_];
            _loc6_.CheckTextEffect(_loc5_);
            if(_loc5_.CMD == TTargetInfo.CMD_ATTRBUFF || _loc5_.CMD == TTargetInfo.CMD_HURTBUFF || _loc5_.CMD == TTargetInfo.CMD_CONTROLBUFF)
            {
               this.AddBuffs(this,param2);
            }
            else
            {
               _loc7_ = _loc5_.ResultInfo.HurtHp;
               _loc8_ = _loc5_.ResultInfo.HurtAnger;
               if(_loc6_.Camp == Camp || _loc7_ < 0)
               {
                  _loc6_.ChangeHP(_loc7_);
                  if(this.FTextFunction != null)
                  {
                     this.FTextFunction(TBattleStage.TYPETEXT_Float,_loc6_.Camp == 0 ? -1 : 1,_loc6_.x,_loc6_.y - _loc6_.RoleHeight,"+" + int(Math.abs(_loc7_)),false);
                  }
               }
               else if(_loc7_ != 0)
               {
                  _loc6_.ChangeHP(_loc7_);
                  _loc6_.ActivePlay(TActive.TYPE_ACTIVE_ATTACKED,0,null,Vector.<TTargetInfo>([_loc5_]));
                  if(this.FTextFunction != null)
                  {
                     this.FTextFunction(TBattleStage.TYPETEXT_Float,_loc6_.Camp == 0 ? -1 : 1,_loc6_.x,_loc6_.y - _loc6_.RoleHeight,String(int(_loc7_)),false);
                  }
               }
               if(_loc8_ != 0)
               {
                  if(_loc5_.CMD == TTargetInfo.CMD_ATTACKEX)
                  {
                     if(_loc8_ > 0)
                     {
                        _loc9_ = Math.min(_loc8_,_loc6_.CurAnger);
                     }
                     else
                     {
                        _loc9_ = _loc8_;
                     }
                     _loc6_.AddAngerTextEffect(-_loc9_);
                  }
                  _loc6_.CurAnger -= _loc8_;
               }
            }
            _loc4_++;
         }
         this.OnNextCommand(param3);
      }
      
      public function RoundSkill(param1:Vector.<TTargetInfo>, param2:Vector.<TRole>) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:TRole = null;
         var _loc5_:int = 0;
         if(param1 != null)
         {
            _loc3_ = 0;
            while(_loc3_ < param1.length)
            {
               _loc4_ = param2[_loc3_];
               _loc5_ = param1[_loc3_].ResultInfo.HurtHp;
               _loc4_.CurHealth -= _loc5_;
               if(this.FTextFunction != null)
               {
                  if(_loc5_ < 0)
                  {
                     this.FTextFunction(TBattleStage.TYPETEXT_Float,_loc4_.Camp == 0 ? -1 : 1,_loc4_.x,_loc4_.y - _loc4_.RoleHeight,"+" + int(Math.abs(_loc5_)),false);
                  }
                  else
                  {
                     this.FTextFunction(TBattleStage.TYPETEXT_Float,_loc4_.Camp == 0 ? -1 : 1,_loc4_.x,_loc4_.y - _loc4_.RoleHeight,String(int(_loc5_)));
                  }
               }
               if(_loc4_.CurHealth < 0)
               {
                  _loc4_.CheckDie();
               }
               _loc3_++;
            }
         }
      }
      
      public function CommandPlay(param1:int, param2:Vector.<TRole>, param3:Vector.<TTargetInfo>, param4:uint) : void
      {
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         if(param1 == 0)
         {
            _loc6_ = param3.length;
            _loc5_ = 0;
            while(_loc5_ < _loc6_)
            {
               param2[_loc5_].CheckTextEffect(param3[_loc5_]);
               _loc5_++;
            }
            this.OnNextCommand(param4);
         }
         else
         {
            this.ActivePlay(ActiveType(param1),param1,param2,param3,this.OnNextCommand,param4);
         }
      }
      
      public function AddTextEffect(param1:int) : void
      {
         var _loc2_:TGoneWord = null;
         if(this.FTextFunction != null)
         {
            if(param1 & CONST_BATTLE.ActiveType_Help)
            {
               this.FTextFunction(TBattleStage.TYPETEXT_Stand,0,this.x,this.y - this.RoleHeight,"0",false,CONST_BATTLE.TEXT_FIGHT_STATUS_Help);
            }
            if(param1 & CONST_BATTLE.ActiveType_Punch)
            {
               if(param1 & CONST_BATTLE.ActiveType_Hit)
               {
                  _loc2_ = this.FTextFunction(TBattleStage.TYPETEXT_Hold,0,this.x,this.y - this.RoleHeight,"0",false,CONST_BATTLE.TEXT_FIGHT_STATUS_OtherTurn);
                  this.DelStatus(CONST_BATTLE.TEXT_FIGHT_STATUS_OtherTurn);
                  this.FStatusGoneWordDict[CONST_BATTLE.TEXT_FIGHT_STATUS_OtherTurn] = _loc2_;
               }
               else
               {
                  this.FTextFunction(TBattleStage.TYPETEXT_Float,0,this.x,this.y - this.RoleHeight,"0",false,CONST_BATTLE.TEXT_FIGHT_STATUS_OtherTurnLost);
               }
            }
            if(param1 & CONST_BATTLE.ActiveType_ImmCtrl)
            {
               this.FTextFunction(TBattleStage.TYPETEXT_Stand,0,this.x,this.y - this.RoleHeight,"0",false,CONST_BATTLE.TEXT_FIGHT_STATUS_Lost);
            }
            if(param1 & CONST_BATTLE.ActiveType_ImmCalm)
            {
               this.FTextFunction(TBattleStage.TYPETEXT_Stand,0,this.x,this.y - this.RoleHeight,"0",false,CONST_BATTLE.TEXT_FIGHT_STATUS_Lost);
            }
            if(param1 & CONST_BATTLE.ActiveType_NoAddAnger)
            {
               this.FTextFunction(TBattleStage.TYPETEXT_Float,0,this.x,this.y - this.RoleHeight,"0",false,CONST_BATTLE.TEXT_FIGHT_STATUS_NoAddAnger);
            }
            if(param1 & CONST_BATTLE.ActiveType_NoSkill)
            {
               this.FTextFunction(TBattleStage.TYPETEXT_Float,0,this.x,this.y - this.RoleHeight,"0",false,CONST_BATTLE.TEXT_FIGHT_STATUS_NoSkill);
            }
            if(param1 & CONST_BATTLE.ActiveType_NoAddHp)
            {
               this.FTextFunction(TBattleStage.TYPETEXT_Float,0,this.x,this.y - this.RoleHeight,"0",false,CONST_BATTLE.TEXT_FIGHT_STATUS_NoAddHp);
            }
            if(param1 & CONST_BATTLE.ActiveType_NoAttack)
            {
               this.FTextFunction(TBattleStage.TYPETEXT_Float,0,this.x,this.y - this.RoleHeight,"0",false,CONST_BATTLE.TEXT_FIGHT_STATUS_NoAttack);
            }
            if(param1 & CONST_BATTLE.ActiveType_BeStone)
            {
               this.FTextFunction(TBattleStage.TYPETEXT_Float,0,this.x,this.y - this.RoleHeight,"0",false,CONST_BATTLE.TEXT_FIGHT_STATUS_BeStone);
            }
            if(param1 & CONST_BATTLE.ActiveType_Nothingness)
            {
               this.FTextFunction(TBattleStage.TYPETEXT_Float,0,this.x,this.y - this.RoleHeight,"0",false,CONST_BATTLE.TEXT_FIGHT_STATUS_Nothingness);
            }
            if(param1 & CONST_BATTLE.ActiveType_AllMiss)
            {
               this.FTextFunction(TBattleStage.TYPETEXT_Float,0,this.x,this.y - this.RoleHeight,"0",false,CONST_BATTLE.TEXT_FIGHT_STATUS_AllMiss);
            }
            if(param1 & CONST_BATTLE.ActiveType_Confusion)
            {
               this.FTextFunction(TBattleStage.TYPETEXT_Float,0,this.x,this.y - this.RoleHeight,"0",false,CONST_BATTLE.TEXT_FIGHT_STATUS_Confusion);
            }
            if(param1 & CONST_BATTLE.ActiveType_ImmNoAnger)
            {
               this.FTextFunction(TBattleStage.TYPETEXT_Float,0,this.x,this.y - this.RoleHeight,"0",false,CONST_BATTLE.TEXT_FIGHT_STATUS_ImmNoAnger);
            }
            if(param1 & CONST_BATTLE.ActiveType_ImmNoSkill)
            {
               this.FTextFunction(TBattleStage.TYPETEXT_Float,0,this.x,this.y - this.RoleHeight,"0",false,CONST_BATTLE.TEXT_FIGHT_STATUS_ImmNoSkill);
            }
            if(param1 & CONST_BATTLE.ActiveType_ImmNoHeal)
            {
               this.FTextFunction(TBattleStage.TYPETEXT_Float,0,this.x,this.y - this.RoleHeight,"0",false,CONST_BATTLE.TEXT_FIGHT_STATUS_ImmNoHeal);
            }
            if(param1 & CONST_BATTLE.ActiveType_ImmStone)
            {
               this.FTextFunction(TBattleStage.TYPETEXT_Float,0,this.x,this.y - this.RoleHeight,"0",false,CONST_BATTLE.TEXT_FIGHT_STATUS_ImmStone);
            }
            if(param1 & CONST_BATTLE.ActiveType_ImmFake)
            {
               this.FTextFunction(TBattleStage.TYPETEXT_Float,0,this.x,this.y - this.RoleHeight,"0",false,CONST_BATTLE.TEXT_FIGHT_STATUS_ImmFake);
            }
            if(param1 & CONST_BATTLE.ActiveType_ImmNoAttack)
            {
               this.FTextFunction(TBattleStage.TYPETEXT_Float,0,this.x,this.y - this.RoleHeight,"0",false,CONST_BATTLE.TEXT_FIGHT_STATUS_ImmNoAttack);
            }
            if(param1 & CONST_BATTLE.ActiveType_ImmConfusion)
            {
               this.FTextFunction(TBattleStage.TYPETEXT_Float,0,this.x,this.y - this.RoleHeight,"0",false,CONST_BATTLE.TEXT_FIGHT_STATUS_ImmConfusion);
            }
            if(param1 & CONST_BATTLE.ActiveType_ImmAllMiss)
            {
               this.FTextFunction(TBattleStage.TYPETEXT_Float,0,this.x,this.y - this.RoleHeight,"0",false,CONST_BATTLE.TEXT_FIGHT_STATUS_ImmConfusion);
            }
            if(param1 & CONST_BATTLE.ActiveType_ImmMutilate)
            {
               this.FTextFunction(TBattleStage.TYPETEXT_Float,0,this.x,this.y - this.RoleHeight,"0",false,CONST_BATTLE.TEXT_FIGHT_STATUS_ImmMutilate);
            }
            if(param1 & CONST_BATTLE.ActiveType_Ice)
            {
               this.FTextFunction(TBattleStage.TYPETEXT_Float,0,this.x,this.y - this.RoleHeight,"0",false,CONST_BATTLE.TEXT_FIGHT_STATUS_Ice);
            }
            if(param1 & CONST_BATTLE.ActiveType_Invincible)
            {
               this.FTextFunction(TBattleStage.TYPETEXT_Float,0,this.x,this.y - Math.min(this.RoleHeight,180),"0",false,CONST_BATTLE.TEXT_FIGHT_STATUS_Invincible);
            }
            if(param1 & CONST_BATTLE.ActiveType_BeatBack)
            {
               this.FTextFunction(TBattleStage.TYPETEXT_Float,0,this.x,this.y - Math.min(this.RoleHeight,180),"0",false,CONST_BATTLE.TEXT_FIGHT_STATUS_BeatBack);
            }
         }
      }
      
      public function AddAngerTextEffect(param1:int) : void
      {
         if(this.FTextFunction != null)
         {
            this.FTextFunction(TBattleStage.TYPETEXT_UpNumber,Camp == 0 ? -1 : 1,x - 50,y - RoleHeight - 50,(param1 > 0 ? "+" : "") + param1,false,0,param1 > 0 ? 4278309631 : 4290728191,param1 > 0 ? 4278265408 : 4281008199);
         }
      }
      
      public function AddEffect(param1:Object, param2:TRole, param3:Vector.<TRole> = null, param4:Vector.<TTargetInfo> = null, param5:Number = 0, param6:Number = 0) : void
      {
         TEffectControl.ShowEffect(this,param1.effectId,param1,param2,this,param3,param4,param5,param6,0,0,this.FTextFunction);
      }
      
      override public function UpdateActive() : void
      {
         var _loc1_:Object = null;
         var _loc2_:Object = null;
         var _loc3_:int = 0;
         var _loc4_:TAnimationFrame = null;
         var _loc5_:BitmapData = null;
         var _loc6_:TRole = null;
         var _loc7_:Number = NaN;
         var _loc8_:Boolean = false;
         var _loc9_:Number = NaN;
         var _loc10_:Boolean = false;
         var _loc11_:Vector.<TRole> = null;
         var _loc12_:Vector.<TTargetInfo> = null;
         var _loc13_:int = 0;
         if(stage == null)
         {
            return;
         }
         if(FIsDie)
         {
            return;
         }
         if(FIsAntiColorBlackWhite || FIsRedAntiColor)
         {
            return;
         }
         if(FShaderBmp.bitmapData == null)
         {
            this.LoadResources(CONST_BATTLE.Public_Effect_Shadow);
         }
         _loc4_ = FCurSequence.GetAnimationFrameByTick(FTickReference);
         if(FDefaultRoleTexture.GetAnimationSequenceByIndex(0) == FCurSequence)
         {
            ++FFrameIndex;
            _loc10_ = true;
            FShaderBmp.visible = false;
         }
         else
         {
            FFrameIndex = FCurSequence.Index;
            _loc10_ = false;
            FShaderBmp.visible = true;
         }
         _loc1_ = FAttackEffect[FSkillId];
         if(_loc1_ != null)
         {
            if(_loc1_.appendEffect != null)
            {
               _loc2_ = _loc1_.appendEffect[FFrameIndex];
               if(_loc2_ != null)
               {
                  if(_loc2_.target == 1)
                  {
                     this.AddEffect(_loc2_,this,FTargets,FResults,FBitmap.x,FBitmap.y);
                  }
                  else if(_loc2_.target == 2)
                  {
                     if(FTargets != null)
                     {
                        _loc3_ = 0;
                        for(; _loc3_ < FTargets.length; _loc3_++)
                        {
                           if(this == FTargets[_loc3_])
                           {
                              if(FSkilling)
                              {
                                 if(FResults[_loc3_].ResultInfo.HurtAnger > 0)
                                 {
                                    continue;
                                 }
                              }
                              else if(FResults[_loc3_].ResultInfo.HurtAnger < 0)
                              {
                                 continue;
                              }
                           }
                           if(CONST_BATTLE.HasEnemy(FTargets,Camp))
                           {
                              if(FTargets[_loc3_].Camp != Camp)
                              {
                                 FTargets[_loc3_].AddEffect(TEffectControl.CopyObject(_loc2_),this,Vector.<TRole>([FTargets[_loc3_]]),Vector.<TTargetInfo>([FResults[_loc3_]]),FBitmap.x,FBitmap.y);
                                 if(FResults[_loc3_].ResultInfo.HurtAnger > 0)
                                 {
                                    FTargets[_loc3_].AddEffect({
                                       "target":2,
                                       "effectId":CONST_BATTLE.Public_Effect_DecAngle
                                    },this,Vector.<TRole>([FTargets[_loc3_]]),Vector.<TTargetInfo>([FResults[_loc3_]]),FBitmap.x,FBitmap.y);
                                 }
                              }
                              else
                              {
                                 if(FResults[_loc3_].ResultInfo.HurtHp > 0)
                                 {
                                    FTargets[_loc3_].AddEffect(TEffectControl.CopyObject(_loc2_),this,Vector.<TRole>([FTargets[_loc3_]]),Vector.<TTargetInfo>([FResults[_loc3_]]),FBitmap.x,FBitmap.y);
                                 }
                                 if(FResults[_loc3_].ResultInfo.HurtAnger < 0 && FResults[_loc3_].AngerGaining < 100)
                                 {
                                    FTargets[_loc3_].AddEffect({
                                       "target":2,
                                       "effectId":CONST_BATTLE.Public_Effect_AddAngle
                                    },this,Vector.<TRole>([FTargets[_loc3_]]),Vector.<TTargetInfo>([FResults[_loc3_]]),FBitmap.x,FBitmap.y);
                                    FResults[_loc3_].AngerGaining = 100;
                                 }
                              }
                           }
                           else
                           {
                              FTargets[_loc3_].AddEffect(TEffectControl.CopyObject(_loc2_),this,Vector.<TRole>([FTargets[_loc3_]]),Vector.<TTargetInfo>([FResults[_loc3_]]),FBitmap.x,FBitmap.y);
                           }
                        }
                     }
                  }
                  else if(_loc2_.target == 3)
                  {
                     TEffectControl.ShowEffect(Parent,_loc2_.effectId,_loc2_,this,this,FTargets,FResults,0,0,this.x,this.y,null,0,0,0,Camp == 0 ? 1 : -1,Parent.getChildIndex(this));
                  }
                  else if(_loc2_.target == 4)
                  {
                     if(Camp == 0)
                     {
                        TEffectControl.ShowEffect(this.FBattleStage,_loc2_.effectId,_loc2_,this,this,FTargets,FResults,0,0,CONST_COMMON.STAGE_Width,0,this.FTextFunction,0,0,0,-1);
                     }
                     else
                     {
                        TEffectControl.ShowEffect(this.FBattleStage,_loc2_.effectId,_loc2_,this,this,FTargets,FResults,0,0,0,0,this.FTextFunction,0,0,0,1);
                     }
                  }
                  else if(_loc2_.target == 5)
                  {
                     if(Camp == 0)
                     {
                        TEffectControl.ShowEffect(this.FBattleStage,_loc2_.effectId,_loc2_,this,this,FTargets,FResults,0,0,SBattleConfig.GetPostionByCamyPos(0,6,SBattleConfig.Type_PostionX),SBattleConfig.GetPostionByCamyPos(0,6,SBattleConfig.Type_PostionY),this.FTextFunction);
                     }
                     else
                     {
                        TEffectControl.ShowEffect(this.FBattleStage,_loc2_.effectId,_loc2_,this,this,FTargets,FResults,0,0,SBattleConfig.GetPostionByCamyPos(1,6,SBattleConfig.Type_PostionX),SBattleConfig.GetPostionByCamyPos(1,6,SBattleConfig.Type_PostionY),this.FTextFunction);
                     }
                  }
                  else if(_loc2_.target == 7)
                  {
                     if(FTargets != null)
                     {
                        _loc3_ = 0;
                        for(; _loc3_ < FTargets.length; _loc3_++)
                        {
                           if(this == FTargets[_loc3_])
                           {
                              if(int(FResults[_loc3_].ResultInfo.HurtHp) == 0)
                              {
                                 continue;
                              }
                           }
                           if(FTargets[_loc3_].Camp == Camp)
                           {
                              FTargets[_loc3_].AddEffect(_loc2_,this,FTargets,FResults,FBitmap.x,FBitmap.y);
                           }
                        }
                     }
                  }
                  else if(_loc2_.target == 8)
                  {
                     this.BattleStage.ShowWhiteSprite();
                  }
                  else if(_loc2_.target == 9)
                  {
                     if(Camp == 0)
                     {
                        TEffectControl.ShowEffect(this.FBattleStage,_loc2_.effectId,_loc2_,this,this,FTargets,FResults,0,0,CONST_COMMON.STAGE_Width / 2,CONST_COMMON.STAGE_Height / 3 * 2,this.FTextFunction,40,0,600);
                     }
                     else
                     {
                        TEffectControl.ShowEffect(this.FBattleStage,_loc2_.effectId,_loc2_,this,this,FTargets,FResults,0,0,CONST_COMMON.STAGE_Width / 2,CONST_COMMON.STAGE_Height / 3 * 2,this.FTextFunction,-40,0,600);
                     }
                  }
                  else if(_loc2_.target == 10)
                  {
                     TEffectControl.ShowEffect(this.FBattleStage,_loc2_.effectId,_loc2_,this,this,FTargets,FResults,0,0,this.x,this.y,this.FTextFunction,0,0,0,this.Camp == 0 ? 1 : -1);
                  }
                  else if(_loc2_.target == 11)
                  {
                     if(Camp == 0)
                     {
                        TEffectControl.ShowEffect(this.FBattleStage,_loc2_.effectId,_loc2_,this,this,FTargets,FResults,0,0,SBattleConfig.GetPostionByCamyPos(1,6,SBattleConfig.Type_PostionX),SBattleConfig.GetPostionByCamyPos(1,6,SBattleConfig.Type_PostionY),this.FTextFunction,0,0,0,-1);
                     }
                     else
                     {
                        TEffectControl.ShowEffect(this.FBattleStage,_loc2_.effectId,_loc2_,this,this,FTargets,FResults,0,0,SBattleConfig.GetPostionByCamyPos(0,6,SBattleConfig.Type_PostionX),SBattleConfig.GetPostionByCamyPos(0,6,SBattleConfig.Type_PostionY),this.FTextFunction,0,0,0,1);
                     }
                  }
                  else if(_loc2_.target == 12)
                  {
                     if(FTargets != null)
                     {
                        _loc11_ = new Vector.<TRole>();
                        _loc12_ = new Vector.<TTargetInfo>();
                        _loc11_.push(this);
                        _loc3_ = 0;
                        while(_loc3_ < FTargets.length)
                        {
                           if(FResults[_loc3_].TargetStatus & CONST_BATTLE.ActiveType_TargetEffect)
                           {
                              FResults[_loc3_].TargetStatus -= CONST_BATTLE.ActiveType_TargetEffect;
                              _loc11_.push(FTargets[_loc3_]);
                              _loc12_.push(FResults[_loc3_]);
                           }
                           _loc3_++;
                        }
                        if(_loc11_.length >= 2)
                        {
                           TEffectControl.ShowSpecialChainEffect(this.FBattleStage,_loc2_.effectId,_loc2_,_loc11_,_loc12_,this.FTextFunction);
                        }
                     }
                  }
                  FAttackEffect[FSkillId].appendEffect[FFrameIndex] = null;
               }
            }
            if(_loc1_.blackwhite)
            {
               if(_loc1_.blackwhite[FFrameIndex] != null)
               {
                  this.FBattleStage.AntiColorBlackWhite(this,Boolean(_loc1_.blackwhite[FFrameIndex]));
               }
            }
            if(_loc1_.red)
            {
               if(_loc1_.red[FFrameIndex] != null)
               {
                  this.FBattleStage.RedAntiColor(this,Boolean(_loc1_.red[FFrameIndex]));
               }
            }
            if(_loc1_.ChgBg)
            {
               if(_loc1_.ChgBg[FFrameIndex] != null)
               {
                  this.FBattleStage.ChangeBg(this,_loc1_.ChgBg[FFrameIndex]);
               }
            }
            if(_loc1_.FullScreenGradient)
            {
               if(_loc1_.FullScreenGradient[FFrameIndex] != null)
               {
                  this.FBattleStage.FSG(this,uint(_loc1_.FullScreenGradient[FFrameIndex].color),_loc1_.FullScreenGradient[FFrameIndex].time,_loc1_.FullScreenGradient[FFrameIndex].alpha);
                  _loc1_.FullScreenGradient[FFrameIndex] = null;
               }
            }
            if(_loc1_.voice != null)
            {
               if(_loc1_.voice[FFrameIndex] != null)
               {
                  SLogicsCore.SignalPost(CONST_SIGNAL.SIGNALDESTINATION_SOUND,CONST_MUSIC.PLAY_SOUND_EFFECT,_loc1_.voice[FFrameIndex],true);
                  _loc1_.voice[FFrameIndex] = null;
               }
            }
            if(FTargets != null)
            {
               _loc3_ = 0;
               while(_loc3_ < FTargets.length)
               {
                  _loc6_ = FTargets[_loc3_];
                  _loc8_ = Boolean((FResults[_loc3_].TargetStatus & CONST_BATTLE.ActiveType_Crit) != 0);
                  _loc6_.CheckTextEffect(FResults[_loc3_]);
                  if(_loc6_.Camp == Camp)
                  {
                     if(Boolean(_loc1_.friendhp) && Boolean(_loc1_.friendhp[FFrameIndex] != null) && FResults[_loc3_].HealthGaining < 100)
                     {
                        _loc7_ = FResults[_loc3_].ResultInfo.HurtHp * _loc1_.friendhp[FFrameIndex] / 100;
                        _loc6_.ChangeHP(_loc7_);
                        if(_loc7_ != 0)
                        {
                           FResults[_loc3_].HealthGaining += _loc1_.friendhp[FFrameIndex];
                        }
                        if(this.FTextFunction != null)
                        {
                           this.FTextFunction(TBattleStage.TYPETEXT_Float,_loc6_.Camp == 0 ? -1 : 1,_loc6_.x,_loc6_.y - _loc6_.RoleHeight,"+" + int(Math.abs(_loc7_)),_loc8_);
                        }
                     }
                  }
                  else if(Boolean(_loc1_.anmyhp) && _loc1_.anmyhp[FFrameIndex] != null)
                  {
                     _loc7_ = FResults[_loc3_].ResultInfo.HurtHp * _loc1_.anmyhp[FFrameIndex] / 100;
                     if(FResults[_loc3_].TargetStatus & CONST_BATTLE.ActiveType_Hit)
                     {
                        if(FResults[_loc3_].TargetStatus & CONST_BATTLE.ActiveType_Help)
                        {
                           FResults[_loc3_].TargetStatus -= CONST_BATTLE.ActiveType_Help;
                           _loc6_.AddTextEffect(CONST_BATTLE.ActiveType_Help);
                        }
                        if(FResults[_loc3_].TargetStatus & CONST_BATTLE.ActiveType_ImmCtrl)
                        {
                           FResults[_loc3_].TargetStatus -= CONST_BATTLE.ActiveType_ImmCtrl;
                           _loc6_.AddTextEffect(CONST_BATTLE.ActiveType_ImmCtrl);
                        }
                        if(FResults[_loc3_].TargetStatus & CONST_BATTLE.ActiveType_ImmCalm)
                        {
                           FResults[_loc3_].TargetStatus -= CONST_BATTLE.ActiveType_ImmCalm;
                           _loc6_.AddTextEffect(CONST_BATTLE.ActiveType_ImmCalm);
                        }
                        if(_loc7_ != 0)
                        {
                           _loc6_.ChangeHP(_loc7_);
                           _loc6_.ActivePlay(TActive.TYPE_ACTIVE_ATTACKED,0,null,Vector.<TTargetInfo>([FResults[_loc3_]]));
                           if(FResults[_loc3_].TargetStatus & CONST_BATTLE.ActiveType_Block)
                           {
                              TEffectControl.ShowPublicEffect(_loc6_,CONST_BATTLE.Public_Effect_Smoke,0,0);
                           }
                           if(this.FTextFunction != null)
                           {
                              this.FTextFunction(TBattleStage.TYPETEXT_Float,_loc6_.Camp == 0 ? -1 : 1,_loc6_.x,_loc6_.y - _loc6_.RoleHeight,String(int(_loc7_)),_loc8_,FResults[_loc3_].TargetStatus & CONST_BATTLE.ActiveType_Block ? CONST_BATTLE.TEXT_FIGHT_STATUS_Block : 0);
                           }
                        }
                        if(Boolean(_loc1_.anmyhp.checkDie) && !(FResults[_loc3_].TargetStatus & CONST_BATTLE.ActiveType_Block))
                        {
                           _loc6_.CheckDie();
                        }
                     }
                     else if(Boolean(FResults[_loc3_].TargetStatus & CONST_BATTLE.ActiveType_ImmCtrl) || Boolean(FResults[_loc3_].TargetStatus & CONST_BATTLE.ActiveType_ImmCalm))
                     {
                        if(this.FTextFunction != null)
                        {
                           this.FTextFunction(TBattleStage.TYPETEXT_Float,_loc6_.Camp == 0 ? -1 : 1,_loc6_.x,_loc6_.y - _loc6_.RoleHeight,0,false,CONST_BATTLE.TEXT_FIGHT_STATUS_Lost);
                        }
                     }
                     else if(!(FResults[_loc3_].TargetStatus & CONST_BATTLE.ActiveType_Punch))
                     {
                        _loc6_.ActivePlay(TActive.TYPE_ACTIVE_DODGE,0,null,null,null,0,Boolean(FResults[_loc3_].CMD == 0));
                     }
                     if(this.FBattleStage.IsCrit)
                     {
                        this.FBattleStage.IsCrit = false;
                        this.FBattleStage.CriticalUI();
                     }
                  }
                  _loc3_++;
               }
            }
            if(Boolean(_loc1_.anmyhp) && _loc1_.anmyhp[FFrameIndex] != null)
            {
               _loc1_.anmyhp[FFrameIndex] = null;
            }
            if(Boolean(_loc1_.friendhp) && _loc1_.friendhp[FFrameIndex] != null)
            {
               _loc1_.friendhp[FFrameIndex] = null;
            }
         }
         if(_loc4_ == null || _loc10_ && FFrameIndex > 40)
         {
            this.FActiveCallBack = FCallBackDict[FIndex];
            this.FActiveTime = FTimeDict[FIndex];
            PlayFightIdle();
            if(FTargets != null)
            {
               _loc3_ = 0;
               for(; _loc3_ < FTargets.length; _loc3_++)
               {
                  if(this == FTargets[_loc3_])
                  {
                     if(FSkilling)
                     {
                        if(FResults[_loc3_].ResultInfo.HurtAnger > 0)
                        {
                           continue;
                        }
                     }
                     else if(FResults[_loc3_].ResultInfo.HurtAnger < 0)
                     {
                        continue;
                     }
                  }
                  if(CONST_BATTLE.HasEnemy(FTargets,Camp))
                  {
                     if(FTargets[_loc3_].Camp == Camp)
                     {
                        if(FResults[_loc3_].ResultInfo.HurtHp < 0 && FResults[_loc3_].HealthGaining < 100)
                        {
                           FTargets[_loc3_].AddEffect({
                              "target":2,
                              "effectId":CONST_BATTLE.Public_Effect_AddHp,
                              "friendhp":{"0":100}
                           },this,Vector.<TRole>([FTargets[_loc3_]]),Vector.<TTargetInfo>([FResults[_loc3_]]),FBitmap.x,FBitmap.y);
                        }
                     }
                  }
               }
            }
            if(FIdlePosition != null)
            {
               this.x = FIdlePosition[0];
               this.y = FIdlePosition[1];
            }
            FSkillId = 0;
            this.FWaitNextCommand = true;
         }
         else
         {
            _loc5_ = _loc4_.Surface;
            if(FBitmap.bitmapData != _loc5_ && !this.FHasFrozen)
            {
               FBitmap.bitmapData = _loc5_;
               FBitmap.x = -_loc4_.Pivot.X;
               FBitmap.y = -_loc4_.Pivot.Y;
               if(!FInitHpBarHeight && FIndex == TYPE_ACTIVE_FIGHT_IDLE)
               {
                  FInitHpBarHeight = true;
                  FHpBar.y = -(this.Height * 0.85 - (this.Height - this.FCurSequence.GetAnimationFrameByIndex(0).Pivot.Y) / 3);
               }
               if(this.FHideFrame >= 0 && this.FHideFrame != FFrameIndex)
               {
                  this.FHideFrame = -1;
                  FShaderBmp.visible = true;
                  FHpBar.visible = true;
                  FBuffSprite.visible = true;
               }
               if(FAttackEffect[FSkillId] != null && FAttackEffect[FSkillId].newPoint != null)
               {
                  _loc2_ = FAttackEffect[FSkillId].newPoint[FFrameIndex];
                  if(_loc2_ != null)
                  {
                     if(_loc2_.target == 2)
                     {
                        _loc9_ = Camp == 0 ? -100 : 100;
                        this.x = _loc2_.newPointX ? Number(_loc2_.newPointX) : CONST_BATTLE.AverageX(FTargets,Camp) + _loc9_;
                        this.y = _loc2_.newPointY ? Number(_loc2_.newPointY) : CONST_BATTLE.AverageY(FTargets,Camp);
                        this.FHideFrame = FFrameIndex;
                        FShaderBmp.visible = false;
                        FHpBar.visible = false;
                        FBuffSprite.visible = false;
                        FAttackEffect[FSkillId].newPoint[FFrameIndex] = null;
                     }
                  }
               }
               if(FAttackEffect[FSkillId] != null && FAttackEffect[FSkillId].runPoint != null)
               {
                  _loc2_ = FAttackEffect[FSkillId].runPoint[FFrameIndex];
                  if(_loc2_ != null)
                  {
                     _loc9_ = Camp == 0 ? -100 : 100;
                     TweenUtil.to(this,200,{
                        "PosX":CONST_BATTLE.AverageX(FTargets,Camp) + _loc9_,
                        "PosY":CONST_BATTLE.AverageY(FTargets,Camp)
                     });
                     FAttackEffect[FSkillId].runPoint[FFrameIndex] = null;
                  }
               }
               if(FAttackEffect[FSkillId] != null && FAttackEffect[FSkillId].backPoint != null)
               {
                  _loc2_ = FAttackEffect[FSkillId].backPoint[FFrameIndex];
                  if(_loc2_ != null)
                  {
                     this.FightMoveBack();
                     FAttackEffect[FSkillId].backPoint[FFrameIndex] = null;
                  }
               }
            }
         }
         if(FCurrentRebirthSequence != null)
         {
            FCurrentRebirthFrame = FCurrentRebirthSequence.GetAnimationFrameByTick(FTickReference);
            if(FCurrentRebirthFrame != null)
            {
               if(FRoleRebirthBitMap.bitmapData != FCurrentRebirthFrame.Surface)
               {
                  FRoleRebirthBitMap.bitmapData = FCurrentRebirthFrame.Surface;
                  FRoleRebirthBitMap.x = -FCurrentRebirthFrame.Pivot.X;
                  FRoleRebirthBitMap.y = -FCurrentRebirthFrame.Pivot.Y;
               }
            }
         }
         if(FWaitDie)
         {
            if(FIndex == TYPE_ACTIVE_ATTACKED && (_loc4_ == null || _loc10_ && FFrameIndex > 10) || FIndex != TYPE_ACTIVE_ATTACKED)
            {
               FWaitDie = false;
               this.ActivePlay(TActive.TYPE_ACTIVE_DIE);
            }
         }
         if(this.FWaitNextCommand)
         {
            if(TEffectControl.EffectCount <= 0)
            {
               this.FWaitNextCommand = false;
               if(FTargets != null)
               {
                  _loc3_ = 0;
                  while(_loc3_ < FTargets.length)
                  {
                     if(FResults[_loc3_].ResultInfo.CMD == TTargetInfo.CMD_ATTACKEX)
                     {
                        if(FResults[_loc3_].ResultInfo.HurtAnger > 0)
                        {
                           _loc13_ = Math.min(FResults[_loc3_].ResultInfo.HurtAnger,FTargets[_loc3_].CurAnger);
                        }
                        else
                        {
                           _loc13_ = FResults[_loc3_].ResultInfo.HurtAnger;
                        }
                        FTargets[_loc3_].AddAngerTextEffect(-_loc13_);
                     }
                     FTargets[_loc3_].CurAnger -= FResults[_loc3_].ResultInfo.HurtAnger;
                     _loc3_++;
                  }
               }
               if(this.FActiveCallBack != null)
               {
                  this.FActiveCallBack(this.FActiveTime);
               }
            }
         }
         FTickReference += SIZE_FrameRatePerSecond;
         if(this.FHasGiddy)
         {
            if(this.FGiddySequence == null)
            {
               this.LoadResources(CONST_BATTLE.Public_Effect_Giddy);
               return;
            }
            if(!this.FGiddyBitmap.visible)
            {
               this.FGiddyBitmap.visible = true;
            }
            if(this.FGiddySequence != null)
            {
               _loc4_ = this.FGiddySequence.GetAnimationFrameByTick(FTickReference);
            }
            if(_loc4_ != null)
            {
               _loc5_ = _loc4_.Surface;
               if(this.FGiddyBitmap.bitmapData != _loc5_)
               {
                  this.FGiddyBitmap.bitmapData = _loc5_;
                  this.FGiddyBitmap.y = -RoleHeight;
               }
            }
         }
         else
         {
            this.FGiddyBitmap.visible = false;
         }
         if(this.FShieldBitmap.visible)
         {
            if(this.FShieldSequence != null)
            {
               _loc4_ = this.FShieldSequence.GetAnimationFrameByTick(FTickReference);
               this.FShieldBitmap.bitmapData = _loc4_.Surface;
            }
         }
         if(this.FHasFrozen)
         {
            if(this.FFrozenSequence == null)
            {
               this.LoadResources(CONST_BATTLE.Public_Effect_Frozen);
               return;
            }
            if(!this.FFrozenBitmap.visible)
            {
               this.FFrozenBitmap.visible = true;
            }
            if(this.FFrozenSequence != null)
            {
               _loc4_ = this.FFrozenSequence.GetAnimationFrameByTick(FTickReference);
            }
            if(_loc4_ != null)
            {
               _loc5_ = _loc4_.Surface;
               if(this.FFrozenBitmap.bitmapData != _loc5_)
               {
                  this.FFrozenBitmap.bitmapData = _loc5_;
               }
            }
         }
         else
         {
            this.FFrozenBitmap.visible = false;
         }
      }
      
      public function AddBuffs(param1:TRole, param2:Vector.<TTargetInfo>) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Vector.<int> = null;
         var _loc7_:int = 0;
         var _loc8_:uint = 0;
         var _loc9_:Sprite = null;
         var _loc10_:int = 0;
         var _loc11_:Boolean = false;
         var _loc12_:Vector.<int> = null;
         if(param2 == null)
         {
            return;
         }
         _loc12_ = new Vector.<int>();
         _loc3_ = 0;
         for(; _loc3_ < param2.length; _loc3_++)
         {
            if(param2[_loc3_].TargetCamp == Camp && param2[_loc3_].TargetPos == Pos)
            {
               _loc7_ = param2[_loc3_].ResultInfo.BuffId;
               _loc8_ = uint(param2[_loc3_].ResultInfo.BuffTurn);
               _loc11_ = false;
               if(_loc7_ > 0 && _loc8_ != 0)
               {
                  if(this.FBuffBins.GetDatebaseByIdentifier(_loc7_) != null)
                  {
                     _loc6_ = this.GetSameBuffIndex(this.FBuffIdVect,_loc7_);
                     if(_loc6_.length <= 1)
                     {
                        this.FBuffIdVect.push(_loc7_);
                        this.FBuffTurnVect.push(_loc8_);
                        _loc9_ = TPoolBitmap.GetBitmapSprite();
                        _loc9_.addEventListener(MouseEvent.MOUSE_MOVE,this.OnMouseMove);
                        _loc9_.addEventListener(MouseEvent.ROLL_OUT,this.OnRollOut);
                        _loc9_.mouseEnabled = true;
                        FBuffSprite.addChild(_loc9_);
                        this.FBuffSpriteVect.push(_loc9_);
                        this.FIsNewBuffVect.push(Boolean(param1 == this));
                        continue;
                     }
                     _loc10_ = _loc6_[0];
                     _loc4_ = 0;
                     while(_loc4_ < _loc6_.length - 1)
                     {
                        _loc5_ = _loc6_[1 + _loc4_];
                        if(_loc10_ >= _loc6_[1 + _loc4_ + 1])
                        {
                           if(!_loc11_)
                           {
                              _loc11_ = true;
                              this.FBuffIdVect[_loc5_] = _loc7_;
                              this.FBuffTurnVect[_loc5_] = _loc8_;
                              this.FIsNewBuffVect[_loc5_] = Boolean(param1 == this);
                           }
                           else
                           {
                              _loc12_.push(_loc5_);
                           }
                        }
                        _loc4_ += 2;
                     }
                  }
               }
               else
               {
                  this.DelSameTypeBuffIndex(_loc8_);
               }
            }
            this.CheckTextEffect(param2[_loc3_]);
         }
         _loc3_ = 0;
         while(_loc3_ < _loc12_.length)
         {
            _loc5_ = _loc12_[_loc3_];
            this.DelBuffs(this.FBuffIdVect[_loc5_]);
            _loc3_++;
         }
      }
      
      public function CheckBuffsHurt(param1:Vector.<TTargetInfo>) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TTargetInfo = null;
         _loc2_ = 0;
         while(_loc2_ < param1.length)
         {
            _loc4_ = param1[_loc2_];
            _loc3_ = this.FBuffIdVect.indexOf(_loc4_.ResultInfo.BuffId);
            if(_loc3_ >= 0)
            {
               if(_loc4_.ResultInfo.HurtHp != 0)
               {
                  this.ChangeHP(_loc4_.ResultInfo.HurtHp);
                  if(this.FTextFunction != null)
                  {
                     if(_loc4_.ResultInfo.HurtHp < 0)
                     {
                        this.FTextFunction(TBattleStage.TYPETEXT_Float,Camp == 0 ? -1 : 1,this.x,this.y - this.RoleHeight,"+" + int(Math.abs(_loc4_.ResultInfo.HurtHp)),false,CONST_BATTLE.GetBuffSkillIndex(_loc4_.ResultInfo.BuffId));
                     }
                     else
                     {
                        this.FTextFunction(TBattleStage.TYPETEXT_Float,Camp == 0 ? -1 : 1,this.x,this.y - this.RoleHeight,int(_loc4_.ResultInfo.HurtHp),false,CONST_BATTLE.GetBuffSkillIndex(_loc4_.ResultInfo.BuffId));
                     }
                  }
                  this.CheckDie();
               }
               if(_loc4_.ResultInfo.HurtAnger != 0)
               {
                  CurAnger -= _loc4_.ResultInfo.HurtAnger;
               }
            }
            _loc2_++;
         }
      }
      
      public function CheckBuffs(param1:int = 0) : void
      {
         var _loc2_:* = 0;
         var _loc3_:Boolean = false;
         _loc2_ = 0;
         while(_loc2_ < this.FBuffTurnVect.length)
         {
            if(this.CheckBuffContinued(this.FBuffIdVect[_loc2_],param1))
            {
               _loc3_ = this.FIsNewBuffVect[_loc2_];
               if(_loc3_)
               {
                  this.FIsNewBuffVect[_loc2_] = false;
               }
               else
               {
                  --this.FBuffTurnVect[_loc2_];
                  if(this.FBuffTurnVect[_loc2_] <= 0)
                  {
                     this.DelBuffByIndex(_loc2_);
                     _loc2_--;
                  }
               }
            }
            _loc2_++;
         }
      }
      
      public function ChgNewBuffs() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Boolean = false;
         _loc1_ = 0;
         while(_loc1_ < this.FBuffTurnVect.length)
         {
            this.FIsNewBuffVect[_loc1_] = false;
            _loc1_++;
         }
      }
      
      public function CheckBuffUI() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Sprite = null;
         var _loc4_:Bitmap = null;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:TBuffEffect = null;
         var _loc8_:TTexture = null;
         var _loc9_:TAnimationSequence = null;
         this.FHasGiddy = false;
         this.FHasFrozen = false;
         _loc1_ = 0;
         while(_loc1_ < this.FBuffIdVect.length)
         {
            _loc2_ = int(this.FBuffIdVect[_loc1_]);
            _loc3_ = this.FBuffSpriteVect[_loc1_];
            if(Camp == 0)
            {
               _loc5_ = CONST_BUFF_StampX_Left + int(_loc1_ / CONST_BUFF_Const) * CONST_BUFF_Width;
               _loc6_ = CONST_BUFF_StampY + int(_loc1_ % CONST_BUFF_Const) * CONST_BUFF_Height;
            }
            else
            {
               _loc5_ = CONST_BUFF_StampX_Right + int(_loc1_ / CONST_BUFF_Const) * CONST_BUFF_Width - CONST_BUFF_Width;
               _loc6_ = CONST_BUFF_StampY + int(_loc1_ % CONST_BUFF_Const) * CONST_BUFF_Height;
            }
            _loc7_ = this.FBuffBins.GetDatebaseByIdentifier(_loc2_) as TBuffEffect;
            _loc3_.x = _loc5_;
            _loc3_.y = _loc6_;
            _loc4_ = _loc3_.getChildAt(0) as Bitmap;
            _loc8_ = SResourcesCore.TexturesBuffIcon.GetTextureByIdentifier(_loc7_.IconUrl);
            if(_loc8_ != null)
            {
               _loc9_ = SResourcesCore.TexturesBuffIcon.GetAnimationSequenceByIdentifiers(_loc7_.IconUrl,0);
               _loc4_.bitmapData = _loc9_.GetAnimationFrameByIndex(0).Surface;
            }
            else
            {
               SResourcesCore.TexturesBuffIcon.LoadSecondary(_loc7_.IconUrl);
            }
            if(_loc7_.IconUrl == 13500031)
            {
               this.FHasGiddy = true;
            }
            if(_loc7_.IconUrl == 13500050)
            {
               this.FHasFrozen = true;
            }
            _loc1_++;
         }
      }
      
      public function CheckDie() : void
      {
         if(CurHealth < 1)
         {
            FWaitDie = true;
         }
      }
      
      public function ChgPosition(param1:Vector.<TTargetInfo>) : void
      {
         var _loc2_:TTargetInfo = null;
         var _loc3_:uint = 0;
         _loc2_ = param1[0];
         _loc3_ = uint(_loc2_.ResultInfo.BuffTurn);
         this.SetPosition(SBattleConfig.GetPostionByCamyPos(Camp,_loc3_,SBattleConfig.Type_PostionX),SBattleConfig.GetPostionByCamyPos(Camp,_loc3_,SBattleConfig.Type_PostionY));
         Pos = _loc3_;
      }
      
      public function AddStatus(param1:TTargetInfo) : void
      {
         var _loc2_:int = 0;
         if(param1 != null)
         {
            if(param1.TargetStatus & CONST_BATTLE.ActiveType_Punch)
            {
               this.AddTextEffect(param1.TargetStatus);
            }
         }
      }
      
      public function DelStatus(param1:int, param2:int = -1) : Boolean
      {
         var _loc3_:TGoneWord = null;
         _loc3_ = this.FStatusGoneWordDict[param1];
         if(_loc3_ != null)
         {
            if(param2 >= 0)
            {
               this.FTextFunction(TBattleStage.TYPETEXT_Float,0,this.x,this.y - this.RoleHeight,"0",false,param2);
            }
            _loc3_.SaveSelf();
            this.FStatusGoneWordDict[param1] = null;
            return true;
         }
         return false;
      }
      
      public function FightMoveBack() : void
      {
         TweenUtil.to(this,200,{
            "x":FIdlePosition[0],
            "y":FIdlePosition[1]
         });
      }
      
      public function ShieldOP(param1:TTargetInfo) : void
      {
         var _loc2_:Boolean = false;
         this.FShieldBlood = param1.ResultInfo.BuffTurn;
         _loc2_ = this.FShieldBlood > 0;
         if(this.FShieldBitmap.visible != _loc2_)
         {
            this.FShieldBitmap.visible = _loc2_;
         }
      }
      
      override public function CheckDirection() : void
      {
         super.CheckDirection();
      }
      
      public function ResetRole(param1:TUIComponent, param2:TRoleBattleInfo, param3:TBattleStage, param4:Function = null) : void
      {
         ResetBaseRole(param1,param2);
         this.FBattleStage = param3;
         this.FTextFunction = param4;
         this.FShieldBlood = 0;
         this.FShieldBitmap.visible = false;
         this.FShieldBitmap.bitmapData = null;
         this.FHasGiddy = false;
         this.FHasFrozen = false;
         this.InitCharacter();
      }
      
      public function AddTextEffectByCMD(param1:TTargetInfo) : void
      {
         var _loc2_:int = 0;
         if(this.FTextFunction != null)
         {
            _loc2_ = CONST_BATTLE.TEXT_TYPES.indexOf(param1.ResultInfo.BuffId);
            if(_loc2_ != -1)
            {
               this.FTextFunction(TBattleStage.TYPETEXT_Float,Camp == 0 ? -1 : 1,x,y - RoleHeight,0,false,CONST_BATTLE.TEXT_TYPES_TO_TEXTSTATUS[_loc2_]);
            }
         }
      }
   }
}

