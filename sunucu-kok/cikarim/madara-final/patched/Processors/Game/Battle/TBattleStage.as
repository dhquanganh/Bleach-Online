package Processors.Game.Battle
{
   import Components.Controls.*;
   import Debugging.*;
   import Foundation.Common.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Bins.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.Battle.*;
   import Logics.Battle.model.*;
   import Logics.Characters.*;
   import Logics.DatebaseVO.VO.*;
   import Processors.*;
   import Processors.Game.Battle.Character.*;
   import Processors.Game.Battle.Components.*;
   import Processors.Game.Battle.Effect.*;
   import Processors.Game.Battle.GoneWord.*;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Resources.Constants.*;
   import Resources.Strings.*;
   import flash.desktop.*;
   import flash.display.*;
   import flash.events.*;
   import flash.utils.*;
   import ghostcat.util.easing.TweenUtil;
   
   public class TBattleStage extends TProcessor
   {
      
      protected static const KEY_QUOTE:uint = CONST_KEYCODE.KEY_QUOTE;
      
      protected static const RESOURCESSTATE_Request:int = 0;
      
      protected static const RESOURCESSTATE_Wait:int = 1;
      
      protected static const RESOURCESSTATE_Dispatch:int = 2;
      
      public static const TYPETEXT_Float:int = 1;
      
      public static const TYPETEXT_Up:int = 2;
      
      public static const TYPETEXT_Down:int = 3;
      
      public static const TYPETEXT_Stand:int = 4;
      
      public static const TYPETEXT_Hold:int = 5;
      
      public static const TYPETEXT_UpNumber:int = 6;
      
      public static const Pet_1_Point_X:Number = 140;
      
      public static const Pet_1_Point_Y:Number = 370;
      
      public static var Pet_2_Point_X:Number = 1110;
      
      public static var Pet_2_Point_Y:Number = 370;
      
      public static const BOOM_POS:uint = 99;
      
      public static const PET_POS:uint = 100;
      
      public static const BOOM_EFFECT_ID:uint = 13620044;
      
      protected static const ENTER_TYPE_ARENA:int = CONST_BATTLE.BattleType_Arena;
      
      protected static const ENTER_TYPE_FightPet:int = CONST_BATTLE.BattleType_FightPet;
      
      protected static const ENTER_TYPE_CityDefend:int = CONST_BATTLE.BattleType_CityDefend;
      
      protected static const ENTER_TYPE_OrganizationWar:int = CONST_BATTLE.BattleType_OrganizationWar;
      
      protected static const ENTER_TYPE_TraitorAttack:int = CONST_BATTLE.BattleType_TraitorAttack;
      
      protected static const ENTER_TYPE_Slave:int = CONST_BATTLE.BattleType_Slave;
      
      protected static const ENTER_TYPE_TeamBattlePVE:int = CONST_BATTLE.BattleType_TeamBattlePVE;
      
      public static const ENTER_TYPE_TeamBattlePVP:int = CONST_BATTLE.BattleType_TeamBattlePVP;
      
      public static const ENTER_TYPE_SkyTowerPVE:int = CONST_BATTLE.BattleType_SkyTowerPVE;
      
      public static const ENTER_TYPE_SkyTowerPVP:int = CONST_BATTLE.BattleType_SkyTowerPVP;
      
      public static const ENTER_TYPE_GongFuFight:int = CONST_BATTLE.BattleType_GongFuFight;
      
      protected static const ENTER_TYPE_Video:int = CONST_BATTLE.BattleType_Video;
      
      protected var FBattleHandle:TBattleHandle;
      
      protected var FChain:TChain;
      
      protected var FBigSkills:TBigSkills;
      
      protected var FBattleFiled:TUIComponent;
      
      protected var FPlayerRoleMgr:Vector.<TRole>;
      
      protected var FPlayerPetMgr:Vector.<TRole>;
      
      protected var FPlayerRole_0:Dictionary;
      
      protected var FPlayerRole_1:Dictionary;
      
      protected var FMounts_0:TRole;
      
      protected var FMounts_1:TRole;
      
      protected var FCommandList:Vector.<Object>;
      
      private var FDamageFloatLayer:Sprite;
      
      protected var FEffectSprite:Sprite;
      
      protected var FEndStatues:Boolean;
      
      protected var FIsCrit:Boolean;
      
      protected var FTipsScene:MovieClip;
      
      protected var FTalentBins:TBins;
      
      protected var FSkillBins:TBins;
      
      protected var FKnifeBins:TBins;
      
      protected var FWhiteSprite:Sprite;
      
      protected var FBuffTips:MovieClip;
      
      protected var FHintBtn:THint;
      
      protected var FIsHadBoom:Boolean;
      
      protected var FIsBuffTip:Boolean;
      
      protected var FTF_FightStatus:Vector.<String>;
      
      protected var FConfusionRole:TRole;
      
      protected var FColorSprite:Sprite;
      
      protected var FBattleInfo:TBattleInfo;
      
      protected var FCriticalUI:Function;
      
      protected var FOnChangeBg:Function;
      
      protected var FOnAntiColorBlackWhiteBg:Function;
      
      protected var FOnRedAntiColorBg:Function;
      
      protected var FOnEndBattle:Function;
      
      protected var FHintOnMove:Function;
      
      protected var FHintOnOut:Function;
      
      protected var FKnifeOfKillSoulOnMove:Function;
      
      protected var FKnifeOfKillSoulOnOut:Function;
      
      public function TBattleStage(param1:TUIComponent)
      {
         var _loc2_:int = 0;
         super(param1);
         this.FBattleHandle = param1 as TBattleHandle;
         this.FHintBtn = new THint();
         this.InitBattleStage();
         Pet_2_Point_X -= _loc2_;
         this.FChain = new TChain(this);
         this.FChain.KnifeOfKillSoulOnMove = this.ProcessorKnifeOfKillSoulOnMove;
         this.FChain.KnifeOfKillSoulOnOut = this.ProcessorKnifeOfKillSoulOnOut;
         this.FChain.OnHintMove = this.ProcessorOnHitMove;
         this.FChain.OnHintOut = this.ProcessorOnHitOut;
         this.FBigSkills = new TBigSkills(this);
         this.FIsBuffTip = false;
      }
      
      protected function InitBattleStage() : void
      {
         this.FPlayerRoleMgr = new Vector.<TRole>();
         this.FPlayerPetMgr = new Vector.<TRole>();
         this.FCommandList = new Vector.<Object>();
         this.FPlayerRole_0 = new Dictionary(true);
         this.FPlayerRole_1 = new Dictionary(true);
         this.FBattleFiled = new TUIComponent(this);
         this.FEffectSprite = new Sprite();
         addChild(this.FEffectSprite);
         this.FTalentBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_HeroTalent);
         this.FSkillBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_SkillConfig);
         this.FKnifeBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_Knife);
         this.FTF_FightStatus = TUtilityLobby.GetStringsByIdentifier(CONST_SYSTEMLANGUAGE.STRING_BATTLE_13);
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(!this.Visible)
         {
            return;
         }
         this.CheckMouseIn();
         this.RoleUpdata();
      }
      
      protected function CheckMouseIn() : void
      {
         var _loc1_:int = 0;
         var _loc2_:TRole = null;
         var _loc3_:Array = new Array();
         var _loc4_:Array = new Array();
         _loc1_ = 0;
         while(_loc1_ < this.FPlayerRoleMgr.length)
         {
            _loc2_ = this.FPlayerRoleMgr[_loc1_];
            if(_loc2_.CheckMouseInColor())
            {
               _loc3_.push(_loc2_);
            }
            else
            {
               _loc4_.push(_loc2_);
            }
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < _loc4_.length)
         {
            _loc2_ = _loc4_[_loc1_];
            _loc2_.ShowHighLight = false;
            _loc1_++;
         }
         if(_loc3_.length <= 0)
         {
            this.HideTips();
            return;
         }
         _loc3_.sort(this.ZBuffer,Array.NUMERIC | Array.DESCENDING);
         if(!this.FIsBuffTip && _loc3_.length > 0)
         {
            _loc2_ = _loc3_[0];
            _loc2_.ShowHighLight = true;
            this.ShowTips(_loc2_);
         }
         else
         {
            this.HideTips();
         }
         _loc1_ = 1;
         while(_loc1_ < _loc3_.length)
         {
            _loc2_ = _loc3_[_loc1_];
            _loc2_.ShowHighLight = false;
            _loc1_++;
         }
         _loc3_.length = 0;
         _loc4_.length = 0;
         _loc3_ = null;
         _loc4_ = null;
      }
      
      protected function ShowTips(param1:TRole) : void
      {
         var _loc2_:THeroTalent = null;
         var _loc3_:TSkillConfig = null;
         var _loc4_:THero = null;
         var _loc5_:int = 0;
         if(this.FTipsScene == null)
         {
            this.FTipsScene = TUtilityReflection.CreateDisplayObjectInstance(CONST_BATTLE.RESOURCE_ClassName_BattleTip) as MovieClip;
            addChild(this.FTipsScene);
         }
         if(param1.HeroData != null)
         {
            this.FTipsScene.tf_name.text = param1.CharacterName;
            this.FTipsScene.tf_level.text = "LV." + param1.Level;
            this.FTipsScene.tf_type.text = TUtilityLobby.GetProfessionByIndex(param1.HeroData.Profession);
            _loc2_ = this.FTalentBins.GetDatebaseByIdentifier(param1.HeroData.Talent) as THeroTalent;
            this.FTipsScene.tf_talent.text = _loc2_.TalentName;
         }
         else if(param1.EnemyData != null)
         {
            this.FTipsScene.tf_name.text = param1.EnemyData.Name;
            this.FTipsScene.tf_level.text = "LV." + param1.Level;
            this.FTipsScene.tf_type.text = TUtilityLobby.GetProfessionByIndex(param1.EnemyData.Profession);
            _loc2_ = this.FTalentBins.GetDatebaseByIdentifier(param1.EnemyData.TalentId) as THeroTalent;
            if(_loc2_ != null)
            {
               this.FTipsScene.tf_talent.text = _loc2_.TalentName;
            }
            else
            {
               this.FTipsScene.tf_talent.text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.COMMON_NONE);
            }
         }
         if(param1.Camp == 0)
         {
            _loc5_ = this.FBattleInfo.GetRole1SkillById(param1.Id);
         }
         else
         {
            _loc5_ = this.FBattleInfo.GetRole2SkillById(param1.Id);
         }
         _loc3_ = this.FSkillBins.GetDatebaseByIdentifier(_loc5_) as TSkillConfig;
         this.FTipsScene.tf_skill.text = _loc3_.Name;
         this.FTipsScene.tf_hp.text = Math.floor(param1.CurHealth).toFixed(0) + "/" + param1.TotleHealth.toFixed(0);
         this.FTipsScene.mc_hp.scaleX = Math.min(param1.CurHealth / param1.TotleHealth,1);
         this.FTipsScene.tf_sp.text = param1.CurAnger + "/" + param1.TotleAnger;
         this.FTipsScene.mc_sp.scaleX = Math.min(param1.CurAnger / param1.TotleAnger,1);
         this.FTipsScene.visible = true;
         this.FTipsScene.x = mouseX + 15;
         this.FTipsScene.y = mouseY;
      }
      
      protected function HideTips() : void
      {
         if(this.FTipsScene != null && this.FTipsScene.visible)
         {
            this.FTipsScene.visible = false;
         }
      }
      
      protected function ZBuffer(param1:TRole, param2:TRole) : int
      {
         if(param1.PosY - param2.PosY != 0)
         {
            return (param1.PosY - param2.PosY) * 10000;
         }
         if(this.stage != null)
         {
            if(param2.PosX < stage.width / 2 && param1.PosX < stage.width / 2)
            {
               return param2.PosX - param1.PosX;
            }
            if(param2.PosX >= stage.width / 2 && param1.PosX >= stage.width / 2)
            {
               return param1.PosX - param2.PosX;
            }
            return param1.PosX - param2.PosX;
         }
         return 0;
      }
      
      protected function ZBufferSort() : void
      {
         var _loc1_:int = 0;
         var _loc2_:TRole = null;
         this.FPlayerRoleMgr.sort(this.ZBuffer);
         _loc1_ = 0;
         while(_loc1_ < this.FPlayerRoleMgr.length)
         {
            _loc2_ = this.FPlayerRoleMgr[_loc1_];
            if(_loc2_ != null && _loc2_.parent != null && _loc2_.Parent.getChildAt(_loc1_) != _loc2_)
            {
               _loc2_.Parent.setChildIndex(_loc2_,_loc1_);
            }
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < this.FPlayerPetMgr.length)
         {
            _loc2_ = this.FPlayerPetMgr[_loc1_];
            if(_loc2_ != null && _loc2_.parent != null)
            {
               _loc2_.Parent.addChildAt(_loc2_,0);
            }
            _loc1_++;
         }
      }
      
      protected function RoleUpdata() : void
      {
         var _loc1_:int = 0;
         var _loc2_:TRole = null;
         _loc1_ = 0;
         while(_loc1_ < this.FPlayerRoleMgr.length)
         {
            _loc2_ = this.FPlayerRoleMgr[_loc1_];
            if(_loc2_ != null)
            {
               _loc2_.UpdateActive();
               _loc2_.CheckBuffUI();
            }
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < this.FPlayerPetMgr.length)
         {
            _loc2_ = this.FPlayerPetMgr[_loc1_];
            if(_loc2_ != null)
            {
               _loc2_.UpdateActive();
            }
            _loc1_++;
         }
         if(this.FConfusionRole != null)
         {
            this.FConfusionRole.UpdateActive();
         }
      }
      
      protected function MakeCommandList(param1:int, param2:Vector.<TTurnInfo>) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:TTurnInfo = null;
         var _loc9_:TActiveInfo = null;
         var _loc10_:TActiveInfo = null;
         var _loc11_:TActiveInfo = null;
         var _loc12_:TTargetInfo = null;
         var _loc13_:TTargetInfo = null;
         var _loc14_:TTargetInfo = null;
         var _loc15_:TRole = null;
         var _loc16_:TRole = null;
         var _loc17_:Vector.<TTargetInfo> = null;
         var _loc18_:Dictionary = null;
         var _loc19_:Dictionary = null;
         var _loc20_:Dictionary = null;
         var _loc21_:Dictionary = null;
         var _loc22_:Boolean = false;
         var _loc23_:Boolean = false;
         var _loc24_:Boolean = false;
         var _loc25_:Vector.<TActiveInfo> = null;
         var _loc26_:Vector.<TActiveInfo> = null;
         var _loc27_:Vector.<TActiveInfo> = null;
         var _loc28_:Vector.<TActiveInfo> = null;
         var _loc29_:Vector.<TRole> = null;
         var _loc30_:Object = null;
         var _loc31_:TActiveInfo = null;
         var _loc32_:Vector.<TRole> = null;
         var _loc33_:uint = 0;
         _loc25_ = new Vector.<TActiveInfo>();
         _loc26_ = new Vector.<TActiveInfo>();
         _loc27_ = new Vector.<TActiveInfo>();
         _loc28_ = new Vector.<TActiveInfo>();
         this.FIsHadBoom = false;
         _loc3_ = 0;
         while(_loc3_ < param1)
         {
            _loc30_ = {
               "checkTurn":1,
               "turnNumber":_loc3_
            };
            this.FCommandList.push(_loc30_);
            _loc8_ = param2[_loc3_];
            _loc4_ = 0;
            while(_loc4_ < _loc8_.ActiveCount)
            {
               _loc25_.length = 0;
               _loc26_.length = 0;
               _loc27_.length = 0;
               _loc28_.length = 0;
               _loc23_ = false;
               _loc24_ = false;
               _loc22_ = false;
               _loc9_ = _loc8_.ActiveInfos[_loc4_];
               if(_loc9_.ActivePos == BOOM_POS)
               {
                  this.FIsHadBoom = true;
                  _loc15_ = null;
               }
               else if(_loc9_.ActivePos == PET_POS)
               {
                  _loc15_ = this["FMounts_" + _loc9_.ActiveCamp];
               }
               else
               {
                  _loc15_ = this["FPlayerRole_" + _loc9_.ActiveCamp][_loc9_.ActivePos];
               }
               if(!this.FIsHadBoom && _loc15_ == null)
               {
                  return;
               }
               _loc18_ = new Dictionary(true);
               _loc19_ = new Dictionary(true);
               _loc17_ = _loc9_.TargetInfos;
               _loc6_ = 0;
               while(_loc6_ < _loc17_.length)
               {
                  _loc12_ = _loc17_[_loc6_];
                  if(_loc12_.TargetPos == PET_POS)
                  {
                     _loc16_ = this["FMounts_" + _loc12_.TargetCamp];
                  }
                  else
                  {
                     _loc16_ = this["FPlayerRole_" + _loc12_.TargetCamp][_loc12_.TargetPos];
                  }
                  if(_loc16_ == null)
                  {
                     return;
                  }
                  if(_loc12_.TargetStatus & CONST_BATTLE.ActiveType_Crit)
                  {
                     _loc22_ = true;
                  }
                  if(_loc12_.TargetStatus & CONST_BATTLE.ActiveType_Block)
                  {
                     _loc23_ = true;
                  }
                  if(_loc12_.TargetStatus & CONST_BATTLE.ActiveType_Confusion)
                  {
                     _loc24_ = true;
                  }
                  if(_loc12_.CMD != TTargetInfo.CMD_ATTACKEX && _loc12_.CMD != TTargetInfo.CMD_NONE)
                  {
                     if(_loc18_[_loc12_.CMD] == null)
                     {
                        _loc18_[_loc12_.CMD] = new Vector.<TRole>();
                        _loc19_[_loc12_.CMD] = new Vector.<TTargetInfo>();
                     }
                     _loc18_[_loc12_.CMD].push(_loc16_);
                     _loc19_[_loc12_.CMD].push(_loc12_);
                  }
                  else
                  {
                     if(_loc18_[TTargetInfo.CMD_ATTACK] == null)
                     {
                        _loc18_[TTargetInfo.CMD_ATTACK] = new Vector.<TRole>();
                        _loc19_[TTargetInfo.CMD_ATTACK] = new Vector.<TTargetInfo>();
                     }
                     _loc18_[TTargetInfo.CMD_ATTACK].push(_loc16_);
                     _loc19_[TTargetInfo.CMD_ATTACK].push(_loc12_);
                  }
                  _loc6_++;
               }
               _loc5_ = _loc4_ + 1;
               while(_loc5_ < _loc8_.ActiveCount)
               {
                  _loc10_ = _loc8_.ActiveInfos[_loc5_];
                  if(_loc10_.ActiveType == CONST_BATTLE.Active_Block)
                  {
                     _loc4_++;
                     _loc25_.push(_loc10_);
                  }
                  else if(_loc10_.ActiveType == CONST_BATTLE.Active_PassiveSkill)
                  {
                     _loc4_++;
                     _loc26_.push(_loc10_);
                  }
                  else if(_loc10_.ActiveType == CONST_BATTLE.Active_DiedSkill)
                  {
                     _loc4_++;
                     _loc27_.push(_loc10_);
                  }
                  else
                  {
                     if(_loc10_.ActiveType != CONST_BATTLE.Active_RoundSkill)
                     {
                        break;
                     }
                     _loc4_++;
                     _loc28_.push(_loc10_);
                  }
                  _loc5_++;
               }
               if(_loc18_[TTargetInfo.CMD_SHIELD] != null)
               {
                  _loc30_ = {
                     "shield":_loc15_,
                     "target":_loc18_[TTargetInfo.CMD_SHIELD],
                     "result":_loc19_[TTargetInfo.CMD_SHIELD]
                  };
                  this.FCommandList.push(_loc30_);
               }
               if(_loc18_[TTargetInfo.CMD_HURTBUFF] != null)
               {
                  _loc30_ = {
                     "play":_loc15_,
                     "checkBuffHurt":1,
                     "result":_loc19_[TTargetInfo.CMD_HURTBUFF]
                  };
                  this.FCommandList.push(_loc30_);
               }
               if(_loc18_[TTargetInfo.CMD_STATUS] != null)
               {
                  _loc30_ = {
                     "addStatus":1,
                     "target":_loc18_[TTargetInfo.CMD_STATUS],
                     "result":_loc19_[TTargetInfo.CMD_STATUS]
                  };
                  this.FCommandList.push(_loc30_);
               }
               if(_loc9_.ActivePos == PET_POS)
               {
                  _loc30_ = {
                     "play":_loc15_,
                     "skillEffect":1
                  };
                  this.FCommandList.push(_loc30_);
               }
               if(_loc24_)
               {
                  _loc30_ = {
                     "confusionPlay":_loc15_,
                     "hasEnemy":this.HasEnemy(_loc15_.Camp,_loc18_[TTargetInfo.CMD_ATTACK]),
                     "skillid":_loc9_.SkillEffectId,
                     "target":_loc18_[TTargetInfo.CMD_ATTACK],
                     "result":_loc19_[TTargetInfo.CMD_ATTACK],
                     "time":200,
                     "crit":_loc22_
                  };
                  this.FCommandList.push(_loc30_);
               }
               else
               {
                  _loc30_ = {
                     "play":_loc15_,
                     "skillid":_loc9_.SkillEffectId,
                     "target":_loc18_[TTargetInfo.CMD_ATTACK],
                     "result":_loc19_[TTargetInfo.CMD_ATTACK],
                     "time":200,
                     "crit":_loc22_
                  };
                  this.FCommandList.push(_loc30_);
               }
               if(_loc18_[TTargetInfo.CMD_FLOAT] != null)
               {
                  _loc6_ = 0;
                  while(_loc6_ < _loc18_[TTargetInfo.CMD_FLOAT].length)
                  {
                     _loc12_ = _loc19_[TTargetInfo.CMD_FLOAT][_loc6_];
                     _loc16_ = this["FPlayerRole_" + _loc12_.TargetCamp][_loc12_.TargetPos];
                     if(_loc16_ == null)
                     {
                        return;
                     }
                     _loc30_ = {
                        "play":_loc16_,
                        "cmdFloat":1,
                        "result":_loc12_
                     };
                     this.FCommandList.push(_loc30_);
                     _loc6_++;
                  }
               }
               if(_loc18_[TTargetInfo.CMD_ATTRBUFF] != null)
               {
                  _loc6_ = 0;
                  while(_loc6_ < _loc18_[TTargetInfo.CMD_ATTRBUFF].length)
                  {
                     _loc12_ = _loc19_[TTargetInfo.CMD_ATTRBUFF][_loc6_];
                     _loc16_ = this["FPlayerRole_" + _loc12_.TargetCamp][_loc12_.TargetPos];
                     if(_loc16_ == null)
                     {
                        return;
                     }
                     _loc30_ = {
                        "Source":_loc15_,
                        "play":_loc16_,
                        "addBuff":1,
                        "result":Vector.<TTargetInfo>([_loc12_])
                     };
                     this.FCommandList.push(_loc30_);
                     _loc6_++;
                  }
               }
               if(!this.FIsHadBoom)
               {
                  _loc30_ = {
                     "play":_loc15_,
                     "checkBuff":2
                  };
                  this.FCommandList.push(_loc30_);
               }
               if(_loc18_[TTargetInfo.CMD_CONTROLBUFF] != null)
               {
                  _loc6_ = 0;
                  while(_loc6_ < _loc18_[TTargetInfo.CMD_CONTROLBUFF].length)
                  {
                     _loc12_ = _loc19_[TTargetInfo.CMD_CONTROLBUFF][_loc6_];
                     _loc16_ = this["FPlayerRole_" + _loc12_.TargetCamp][_loc12_.TargetPos];
                     if(_loc16_ == null)
                     {
                        return;
                     }
                     _loc30_ = {
                        "Source":_loc15_,
                        "play":_loc16_,
                        "addBuff":1,
                        "result":Vector.<TTargetInfo>([_loc12_])
                     };
                     this.FCommandList.push(_loc30_);
                     _loc6_++;
                  }
               }
               if(_loc18_[TTargetInfo.CMD_POSITION] != null)
               {
                  _loc6_ = 0;
                  while(_loc6_ < _loc18_[TTargetInfo.CMD_POSITION].length)
                  {
                     _loc12_ = _loc19_[TTargetInfo.CMD_POSITION][_loc6_];
                     _loc16_ = this["FPlayerRole_" + _loc12_.TargetCamp][_loc12_.TargetPos];
                     if(_loc16_ == null)
                     {
                        return;
                     }
                     _loc30_ = {
                        "play":_loc16_,
                        "chgPosition":1,
                        "result":Vector.<TTargetInfo>([_loc12_])
                     };
                     this.FCommandList.push(_loc30_);
                     _loc6_++;
                  }
               }
               if(_loc26_.length > 0)
               {
                  _loc7_ = 0;
                  while(_loc7_ < _loc26_.length)
                  {
                     _loc29_ = new Vector.<TRole>();
                     _loc10_ = _loc26_[_loc7_];
                     _loc20_ = new Dictionary(true);
                     _loc21_ = new Dictionary(true);
                     _loc6_ = 0;
                     while(_loc6_ < _loc10_.TargetInfos.length)
                     {
                        _loc12_ = _loc10_.TargetInfos[_loc6_];
                        _loc16_ = this["FPlayerRole_" + _loc12_.TargetCamp][_loc12_.TargetPos];
                        if(_loc16_ != null)
                        {
                           _loc29_.push(_loc16_);
                           if(_loc12_.CMD == TTargetInfo.CMD_SHIELD)
                           {
                              if(_loc20_[_loc12_.CMD] == null)
                              {
                                 _loc20_[_loc12_.CMD] = new Vector.<TRole>();
                                 _loc21_[_loc12_.CMD] = new Vector.<TTargetInfo>();
                              }
                              _loc20_[_loc12_.CMD].push(_loc16_);
                              _loc21_[_loc12_.CMD].push(_loc12_);
                           }
                        }
                        _loc6_++;
                     }
                     _loc30_ = {
                        "play":_loc15_,
                        "PassiveSkill":1,
                        "target":_loc29_,
                        "result":_loc26_[_loc7_].TargetInfos,
                        "time":50
                     };
                     this.FCommandList.push(_loc30_);
                     if(_loc20_[TTargetInfo.CMD_SHIELD] != null)
                     {
                        _loc30_ = {
                           "shield":_loc15_,
                           "target":_loc20_[TTargetInfo.CMD_SHIELD],
                           "result":_loc21_[TTargetInfo.CMD_SHIELD]
                        };
                        this.FCommandList.push(_loc30_);
                     }
                     _loc7_++;
                  }
               }
               if(_loc27_.length > 0)
               {
                  this.MakeDeadSkillCommandList(_loc27_,_loc17_);
               }
               if(_loc23_)
               {
                  _loc6_ = 0;
                  for(; _loc6_ < _loc18_[TTargetInfo.CMD_ATTACK].length; _loc6_++)
                  {
                     _loc12_ = _loc19_[TTargetInfo.CMD_ATTACK][_loc6_];
                     _loc16_ = this["FPlayerRole_" + _loc12_.TargetCamp][_loc12_.TargetPos];
                     if(_loc12_.TargetStatus & CONST_BATTLE.ActiveType_Block)
                     {
                        if(!(_loc12_.TargetStatus & CONST_BATTLE.ActiveType_Died))
                        {
                           _loc11_ = this.GetActiveInfo(_loc12_.TargetCamp,_loc12_.TargetPos,_loc25_);
                           if(_loc11_ == null)
                           {
                              break;
                           }
                           if(_loc11_.TargetCount < 1)
                           {
                              continue;
                           }
                           _loc30_ = {
                              "play":_loc16_,
                              "skillid":-1,
                              "target":Vector.<TRole>([_loc15_,_loc15_]),
                              "result":_loc11_.TargetInfos,
                              "time":200
                           };
                           this.FCommandList.push(_loc30_);
                        }
                        _loc30_ = {
                           "play":_loc16_,
                           "checkDie":1
                        };
                        this.FCommandList.push(_loc30_);
                        if(_loc27_.length > 0 && _loc11_ != null)
                        {
                           this.MakeDeadSkillCommandList(_loc27_,_loc11_.TargetInfos);
                        }
                     }
                  }
                  _loc30_ = {
                     "play":_loc15_,
                     "checkDie":1
                  };
                  this.FCommandList.push(_loc30_);
               }
               if(_loc28_.length > 0)
               {
                  _loc6_ = 0;
                  while(_loc6_ < _loc28_.length)
                  {
                     _loc31_ = _loc28_[_loc6_];
                     _loc32_ = new Vector.<TRole>();
                     _loc33_ = 0;
                     while(_loc33_ < _loc31_.TargetInfos.length)
                     {
                        _loc12_ = _loc31_.TargetInfos[_loc33_];
                        _loc32_.push(this["FPlayerRole_" + _loc12_.TargetCamp][_loc12_.TargetPos]);
                        _loc33_++;
                     }
                     _loc16_ = this["FPlayerRole_" + _loc31_.ActiveCamp][_loc31_.ActivePos];
                     _loc30_ = {
                        "role":_loc16_,
                        "roundSkillActive":1,
                        "result":_loc31_.TargetInfos,
                        "targetRole":_loc32_
                     };
                     this.FCommandList.push(_loc30_);
                     _loc6_++;
                  }
               }
               if(!this.FIsHadBoom)
               {
                  _loc30_ = {
                     "play":_loc15_,
                     "checkBuff":1
                  };
                  this.FCommandList.push(_loc30_);
               }
               _loc4_++;
            }
            _loc30_ = {"chgNewBuffs":1};
            this.FCommandList.push(_loc30_);
            _loc3_++;
         }
      }
      
      protected function GetActiveInfo(param1:uint, param2:uint, param3:Vector.<TActiveInfo>) : TActiveInfo
      {
         var _loc4_:uint = 0;
         var _loc5_:TActiveInfo = null;
         if(param3 == null)
         {
            return null;
         }
         _loc4_ = 0;
         while(_loc4_ < param3.length)
         {
            _loc5_ = param3[_loc4_];
            if(_loc5_.ActiveCamp == param1 && _loc5_.ActivePos == param2)
            {
               return _loc5_;
            }
            _loc4_++;
         }
         return null;
      }
      
      protected function MakeDeadSkillCommandList(param1:Vector.<TActiveInfo>, param2:Vector.<TTargetInfo>) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:TTargetInfo = null;
         var _loc8_:TTargetInfo = null;
         var _loc9_:TTargetInfo = null;
         var _loc10_:TActiveInfo = null;
         var _loc11_:Vector.<TRole> = null;
         var _loc12_:TActiveInfo = null;
         var _loc13_:TRole = null;
         var _loc14_:TRole = null;
         var _loc15_:TRole = null;
         var _loc16_:Object = null;
         _loc4_ = 0;
         while(_loc4_ < param2.length)
         {
            _loc11_ = new Vector.<TRole>();
            _loc12_ = null;
            _loc7_ = param2[_loc4_];
            if(_loc7_.TargetStatus & CONST_BATTLE.ActiveType_Died)
            {
               _loc6_ = 0;
               while(_loc6_ < param1.length)
               {
                  _loc10_ = param1[_loc6_];
                  if(_loc7_.TargetCamp == _loc10_.ActiveCamp && _loc7_.TargetPos == _loc10_.ActivePos)
                  {
                     _loc12_ = _loc10_;
                     break;
                  }
                  _loc6_++;
               }
            }
            if(_loc12_ != null)
            {
               _loc13_ = this["FPlayerRole_" + _loc12_.ActiveCamp][_loc12_.ActivePos];
               if(_loc13_ != null)
               {
                  _loc3_ = 0;
                  while(_loc3_ < _loc12_.TargetInfos.length)
                  {
                     _loc9_ = _loc12_.TargetInfos[_loc3_];
                     _loc14_ = this["FPlayerRole_" + _loc9_.TargetCamp][_loc9_.TargetPos];
                     _loc11_.push(_loc14_);
                     _loc3_++;
                  }
                  _loc16_ = {
                     "play":_loc13_,
                     "skillid":-2,
                     "target":_loc11_,
                     "result":_loc12_.TargetInfos,
                     "time":200
                  };
                  this.FCommandList.push(_loc16_);
                  _loc5_ = 0;
                  while(_loc5_ < _loc12_.TargetInfos.length)
                  {
                     _loc8_ = _loc12_.TargetInfos[_loc5_];
                     if(_loc8_.CMD == TTargetInfo.CMD_CONTROLBUFF || _loc8_.CMD == TTargetInfo.CMD_ATTRBUFF)
                     {
                        _loc15_ = this["FPlayerRole_" + _loc8_.TargetCamp][_loc8_.TargetPos];
                        if(_loc15_ != null)
                        {
                           _loc16_ = {
                              "Source":_loc13_,
                              "play":_loc15_,
                              "addBuff":1,
                              "result":Vector.<TTargetInfo>([_loc8_])
                           };
                           this.FCommandList.push(_loc16_);
                        }
                     }
                     _loc5_++;
                  }
                  if(param1.length > 0)
                  {
                     this.MakeDeadSkillCommandList(param1,_loc12_.TargetInfos);
                  }
               }
            }
            _loc4_++;
         }
      }
      
      protected function HasEnemy(param1:uint, param2:Vector.<TRole>) : Boolean
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         _loc4_ = param2.length;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            if(param2[_loc3_].Camp != param1)
            {
               return true;
            }
            _loc3_++;
         }
         return false;
      }
      
      private function DamageFloatHost() : Sprite
      {
         if(FDamageFloatLayer == null)
         {
            FDamageFloatLayer = new Sprite();
            FDamageFloatLayer.name = "battleDamageFloatLayer";
            FDamageFloatLayer.mouseEnabled = false;
            FDamageFloatLayer.mouseChildren = false;
            addChild(FDamageFloatLayer);
            addEventListener(Event.ENTER_FRAME,KeepDamageFloatsOnTop,false,0,true);
            addEventListener(Event.RENDER,KeepDamageFloatsOnTop,false,0,true);
         }
         KeepDamageFloatsOnTop();
         return FDamageFloatLayer;
      }
      
      private function KeepDamageFloatsOnTop(event:Event = null) : void
      {
         if(FDamageFloatLayer == null || FDamageFloatLayer.parent != this)
         {
            return;
         }
         if(getChildIndex(FDamageFloatLayer) != numChildren - 1)
         {
            setChildIndex(FDamageFloatLayer,numChildren - 1);
         }
         if(stage != null && event != null && event.type == Event.ENTER_FRAME)
         {
            stage.invalidate();
         }
      }
      
      private function ResetDamageFloats() : void
      {
         removeEventListener(Event.ENTER_FRAME,KeepDamageFloatsOnTop);
         removeEventListener(Event.RENDER,KeepDamageFloatsOnTop);
         if(FDamageFloatLayer != null && FDamageFloatLayer.parent != null)
         {
            FDamageFloatLayer.parent.removeChild(FDamageFloatLayer);
         }
         FDamageFloatLayer = null;
      }
      
      protected function SetFloatText(param1:int, param2:Number, param3:Number, param4:String, param5:Boolean = false, param6:int = 0) : TGoneWord
      {
         var _loc7_:TGoneWord = null;
         var _loc8_:TGoneWord = null;
         var _loc9_:Number = Number(NaN);
         var _loc10_:Number = Number(NaN);
         var _loc11_:Number = Number(NaN);
         var _loc12_:Number = Number(NaN);
         var _loc13_:Number = Number(NaN);
         param3 += 30;
         _loc9_ = Math.PI / 3 + (Math.random() - 0.5) * Math.PI / 3;
         _loc10_ = 20 * Math.sin(_loc9_) * param1;
         _loc11_ = -20 * Math.cos(_loc9_);
         _loc12_ = 0;
         _loc13_ = 0;
         if(int(param4) != 0)
         {
            if(param4.indexOf("+") >= 0)
            {
               _loc7_ = TPoolEffectGoneWord.GetGoneWord();
               this.DamageFloatHost().addChild(_loc7_);
               _loc7_.SetGoneWord(param2 + _loc12_,param3,param4,_loc10_,_loc11_,param5 ? 62 : 36,CONST_BATTLE.TEXT_Add_Color,CONST_BATTLE.TEXT_Add_FilterColor,CONST_FONTLIBRARY.FONT_NAME_Bleach_UI_01);
            }
            else if(param5)
            {
               _loc7_ = TPoolEffectGoneWord.GetGoneWordWithBg();
               this.DamageFloatHost().addChild(_loc7_);
               _loc7_.SetGoneWordWithBg(param2 + _loc12_,param3,param4,_loc10_,_loc11_,62,CONST_FONTLIBRARY.FONT_NAME_Bleach_UI_02);
            }
            else
            {
               _loc7_ = TPoolEffectGoneWord.GetGoneWord();
               this.DamageFloatHost().addChild(_loc7_);
               _loc7_.SetGoneWord(param2 + _loc12_,param3,param4,_loc10_,_loc11_,36,CONST_BATTLE.TEXT_Dec_Color,CONST_BATTLE.TEXT_Dec_FilterColor,CONST_FONTLIBRARY.FONT_NAME_Bleach_UI_01);
            }
            _loc12_ = _loc7_.EffectWidth;
            _loc13_ = _loc7_.EffectHeight;
         }
         if(param6 > 0)
         {
            _loc8_ = TPoolEffectGoneWord.GetGoneWord();
            this.DamageFloatHost().addChild(_loc8_);
            _loc8_.SetGoneWord(param2 + _loc12_,param3 + (_loc13_ - 26) / 2,this.FTF_FightStatus[param6],_loc10_,_loc11_,param5 ? 34 : 20,CONST_BATTLE.GetColorIndex(param6),CONST_BATTLE.GetFilterColorIndex(param6),param5 ? CONST_FONTLIBRARY.FONT_NAME_Bleach_UI_02 : CONST_FONTLIBRARY.FONT_NAME_Bleach_UI_01);
            _loc12_ += _loc8_.EffectWidth;
         }
         if(param1 == -1)
         {
            if(_loc7_)
            {
               _loc7_.x -= _loc12_;
            }
            if(_loc8_)
            {
               _loc8_.x -= _loc12_;
            }
         }
         if(_loc7_)
         {
            _loc7_.StartFloat();
         }
         if(_loc8_)
         {
            _loc8_.StartFloat();
         }
         return null;
      }
      
      protected function SetStandText(param1:Number, param2:Number, param3:int) : TGoneWord
      {
         var _loc4_:TGoneWord = null;
         if(param3 < 0 || param3 >= this.FTF_FightStatus.length)
         {
            return null;
         }
         _loc4_ = TPoolEffectGoneWord.GetGoneWordWithBg();
         this.FEffectSprite.addChild(_loc4_);
         _loc4_.SetGoneWordWithBg(param1,param2,this.FTF_FightStatus[param3],0,0,32);
         _loc4_.StartStand();
         return _loc4_;
      }
      
      protected function SetHoldText(param1:Number, param2:Number, param3:int) : TGoneWord
      {
         var _loc4_:TGoneWord = null;
         if(param3 < 0 || param3 >= this.FTF_FightStatus.length)
         {
            return null;
         }
         _loc4_ = TPoolEffectGoneWord.GetGoneWordWithBg();
         this.FEffectSprite.addChild(_loc4_);
         _loc4_.SetGoneWordWithBg(param1,param2,this.FTF_FightStatus[param3],0,0,34);
         return _loc4_;
      }
      
      protected function SetUpText(param1:Number, param2:Number, param3:int) : TGoneWord
      {
         var _loc4_:TGoneWord = null;
         if(param3 < 0 || param3 >= this.FTF_FightStatus.length)
         {
            return null;
         }
         _loc4_ = TPoolEffectGoneWord.GetGoneWordWithBg();
         this.FEffectSprite.addChild(_loc4_);
         _loc4_.SetGoneWordWithBg(param1,param2,this.FTF_FightStatus[param3]);
         _loc4_.StartUp();
         return _loc4_;
      }
      
      protected function SetUpTextNumber(param1:Number, param2:Number, param3:String, param4:uint, param5:uint = 0) : TGoneWord
      {
         var _loc6_:TGoneWord = null;
         if(param3 == null || param3.length <= 0)
         {
            return null;
         }
         _loc6_ = TPoolEffectGoneWord.GetGoneWord();
         this.FEffectSprite.addChild(_loc6_);
         _loc6_.SetGoneWord(param1,param2,param3,0,0,24,param4,param5,CONST_FONTLIBRARY.FONT_NAME_Bleach_UI_01);
         _loc6_.StartUp();
         return _loc6_;
      }
      
      protected function SetDownText(param1:Number, param2:Number, param3:int) : TGoneWord
      {
         var _loc4_:TGoneWord = null;
         if(param3 < 0 || param3 >= this.FTF_FightStatus.length)
         {
            return null;
         }
         _loc4_ = TPoolEffectGoneWord.GetGoneWordWithBg();
         this.FEffectSprite.addChild(_loc4_);
         _loc4_.SetGoneWordWithBg(param1,param2,this.FTF_FightStatus[param3]);
         _loc4_.StartDown();
         return _loc4_;
      }
      
      protected function NextCommand() : void
      {
         var ConfusionAttack:Function;
         var crowRole:TRole;
         var Index:int = 0;
         var Source:TRole = null;
         var Role:TRole = null;
         var CommandObj:Object = null;
         var TargetVect:Vector.<TRole> = null;
         var ResultVect:Vector.<TTargetInfo> = null;
         var RoleBattleInfo:TRoleBattleInfo = null;
         var RoleCamp:int = 0;
         if(this.FEndStatues)
         {
            return;
         }
         if(this.FConfusionRole != null)
         {
            this.FConfusionRole.Visible = false;
         }
         if(this.FCommandList.length <= 0)
         {
            TBattleHandle.PlaybackTimeout(this.ProcessorBattleSkip,1000);
            return;
         }
         CommandObj = this.FCommandList.shift();
         if(CommandObj)
         {
            if(CommandObj.cmdFloat == 1 && Boolean(CommandObj.play))
            {
               Role = CommandObj.play;
               Role.AddTextEffectByCMD(CommandObj.result);
               this.NextCommand();
            }
            else if(CommandObj.checkBuff == 1 && Boolean(CommandObj.play))
            {
               Role = CommandObj.play;
               Role.CheckBuffs(0);
               this.NextCommand();
            }
            else if(CommandObj.checkBuff == 2 && Boolean(CommandObj.play))
            {
               Role = CommandObj.play;
               Role.CheckBuffs(1);
               this.NextCommand();
            }
            else if(CommandObj.chgNewBuffs == 1)
            {
               Index = 0;
               while(Index < this.FPlayerRoleMgr.length)
               {
                  Role = this.FPlayerRoleMgr[Index];
                  Role.ChgNewBuffs();
                  Index++;
               }
               this.NextCommand();
            }
            else if(Boolean(CommandObj.checkBuffHurt) && Boolean(CommandObj.play))
            {
               Role = CommandObj.play;
               Role.CheckBuffsHurt(CommandObj.result);
               TBattleHandle.PlaybackTimeout(this.NextCommand,200);
            }
            else if(Boolean(CommandObj.addBuff) && Boolean(CommandObj.play))
            {
               Source = CommandObj.Source;
               Role = CommandObj.play;
               Role.AddBuffs(Source,CommandObj.result);
               TBattleHandle.PlaybackTimeout(this.NextCommand,50);
            }
            else if(Boolean(CommandObj.checkDie) && Boolean(CommandObj.play))
            {
               Role = CommandObj.play;
               Role.CheckDie();
               TBattleHandle.PlaybackTimeout(this.NextCommand,200);
            }
            else if(Boolean(CommandObj.chgPosition) && Boolean(CommandObj.play))
            {
               Role = CommandObj.play;
               Role.ChgPosition(CommandObj.result);
               this.ZBufferSort();
               this.NextCommand();
            }
            else if(CommandObj.addStatus)
            {
               TargetVect = CommandObj.target;
               ResultVect = CommandObj.result;
               Index = 0;
               while(Index < TargetVect.length)
               {
                  TargetVect[Index].AddStatus(ResultVect[Index]);
                  Index++;
               }
               this.NextCommand();
            }
            else if(CommandObj.skillEffect)
            {
               Role = CommandObj.play;
               TEffectControl.ShowPublicEffect(Role,CONST_BATTLE.Public_Effect_KniftEffect,0,0,this.NextCommand);
            }
            else if(CommandObj.PassiveSkill)
            {
               Role = CommandObj.play;
               Role.PassiveSkillPlay(CommandObj.target,CommandObj.result,CommandObj.time);
            }
            else if(CommandObj.confusionPlay)
            {
               ConfusionAttack = function():void
               {
                  FConfusionRole.CommandPlay(CommandObj.skillid,CommandObj.target,CommandObj.result,CommandObj.time);
               };
               Role = CommandObj.confusionPlay;
               if(!CommandObj.hasEnemy)
               {
                  RoleCamp = (Role.RoleInfo.Camp + 1) % 2;
               }
               else
               {
                  RoleCamp = Role.RoleInfo.Camp;
               }
               RoleBattleInfo = Role.RoleInfo.Clone(RoleCamp);
               if(this.FConfusionRole == null)
               {
                  this.FConfusionRole = TPoolRole.GetRole(this.FBattleFiled,RoleBattleInfo,this);
                  this.FConfusionRole.OnEffectEnd = this.NextCommand;
                  this.FConfusionRole.Visible = true;
               }
               else
               {
                  this.FConfusionRole.ResetRole(this.FBattleFiled,RoleBattleInfo,this);
                  this.FConfusionRole.Visible = true;
               }
               this.FConfusionRole.SetPosition(CONST_COMMON.STAGE_Width / 2,SBattleConfig.GetPostionByCamyPos(0,1,SBattleConfig.Type_PostionY));
               TBattleHandle.PlaybackTimeout(ConfusionAttack,500);
            }
            else if(CommandObj.play)
            {
               this.FIsCrit = CommandObj.crit;
               Role = CommandObj.play;
               Role.OnBigSkill = this.ProcessorOnBigSkillPlay;
               Role.CommandPlay(CommandObj.skillid,CommandObj.target,CommandObj.result,CommandObj.time);
            }
            else if(CommandObj.checkTurn)
            {
               if(this.FChain != null)
               {
                  for each(crowRole in this.FPlayerRoleMgr)
                  {
                     if(crowRole != null)
                     {
                        crowRole.ClearItachiCrowClone();
                     }
                  }
                  this.FChain.UpdateRemainNum(CommandObj.turnNumber);
               }
               this.NextCommand();
            }
            else if(CommandObj.roundSkillActive)
            {
               Role = CommandObj.role;
               Role.RoundSkill(CommandObj.result,CommandObj.targetRole);
               TBattleHandle.PlaybackTimeout(this.NextCommand,200);
            }
            else if(CommandObj.shield)
            {
               TargetVect = CommandObj.target;
               ResultVect = CommandObj.result;
               Index = 0;
               while(Index < TargetVect.length)
               {
                  TargetVect[Index].ShieldOP(ResultVect[Index]);
                  Index++;
               }
               this.NextCommand();
            }
            else if(this.FIsHadBoom)
            {
               TargetVect = CommandObj.target;
               ResultVect = CommandObj.result;
               Index = 0;
               while(Index < TargetVect.length)
               {
                  Role = TargetVect[Index];
                  TEffectControl.ShowEffect(Role,BOOM_EFFECT_ID,{
                     "target":1,
                     "anmyhp":{
                        "3":100,
                        "checkDie":1
                     }
                  },null,null,Vector.<TRole>([Role]),Vector.<TTargetInfo>([ResultVect[Index]]),0,0,0,0,this.SetEffectText,0,0,0,-1);
                  Index++;
               }
               TBattleHandle.PlaybackTimeout(this.NextCommand,1500);
            }
            else
            {
               this.NextCommand();
            }
         }
      }
      
      protected function ProcessorOnBigSkillPlay(param1:TRole, param2:uint, param3:int, param4:String, param5:Function = null) : void
      {
         this.FBigSkills.PlayBigSkill(param1,param2,param3,param4,param5);
         this.FBigSkills.Visible = true;
         if(param1.SoundId != 0)
         {
            SLogicsCore.SignalPost(CONST_SIGNAL.SIGNALDESTINATION_SOUND,CONST_MUSIC.PLAY_SOUND_EFFECT,param1.SoundId,true);
         }
      }
      
      protected function EndBigEffect(param1:DisplayObjectContainer) : void
      {
         if(param1 != null && param1 is Bitmap)
         {
            TPoolBitmap.SaveBitmap(param1 as Bitmap);
         }
      }
      
      protected function SetEffectText(param1:int, param2:int = 0, param3:Number = 0, param4:Number = 0, param5:String = "0", param6:Boolean = false, param7:int = 0, param8:uint = 16777215, param9:uint = 0) : TGoneWord
      {
         if(param1 == TYPETEXT_Float)
         {
            this.SetFloatText(param2,param3,param4,param5,param6,param7);
         }
         else if(param1 == TYPETEXT_Up)
         {
            this.SetUpText(param3,param4,param7);
         }
         else if(param1 == TYPETEXT_Down)
         {
            this.SetDownText(param3,param4,param7);
         }
         else if(param1 == TYPETEXT_Stand)
         {
            this.SetStandText(param3,param4,param7);
         }
         else
         {
            if(param1 == TYPETEXT_Hold)
            {
               return this.SetHoldText(param3,param4,param7);
            }
            if(param1 == TYPETEXT_UpNumber)
            {
               return this.SetUpTextNumber(param3,param4,param5,param8,param9);
            }
         }
         return null;
      }
      
      protected function ProcessorCopyBattleInfo() : void
      {
         if(this.FBattleInfo != null)
         {
            Clipboard.generalClipboard.setData(ClipboardFormats.TEXT_FORMAT,this.FBattleInfo.toString());
         }
      }
      
      protected function AddUIStageOnKeyDown() : void
      {
         FUICore.UIStage.addEventListener(KeyboardEvent.KEY_DOWN,this.UIStageOnKeyDown);
      }
      
      protected function RemoveUIStageOnKeyDown() : void
      {
         FUICore.UIStage.removeEventListener(KeyboardEvent.KEY_DOWN,this.UIStageOnKeyDown);
      }
      
      protected function OnBuffMouseMove(param1:Object, param2:String, param3:String, param4:String) : void
      {
         if(this.FBuffTips == null)
         {
            this.FBuffTips = TUtilityReflection.CreateDisplayObjectInstance(CONST_BATTLE.RESOURCE_ClassName_BuffTip) as MovieClip;
            this.FEffectSprite.addChild(this.FBuffTips);
         }
         this.FBuffTips.tf_buffName.text = param2;
         this.FBuffTips.tf_buffTurn.text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_BATTLE_10) + param3;
         this.FBuffTips.tf_buffDesc.text = param4;
         this.FBuffTips.x = mouseX + 15;
         this.FBuffTips.y = mouseY;
         this.FBuffTips.visible = true;
         this.FIsBuffTip = true;
      }
      
      protected function OnBuffMouseRollOut(param1:Object) : void
      {
         if(this.FBuffTips != null)
         {
            this.FBuffTips.visible = false;
         }
         this.FIsBuffTip = false;
      }
      
      protected function OnPetRoll(param1:MouseEvent) : void
      {
         var _loc2_:TRole = null;
         var _loc3_:TKnife = null;
         if(param1.type == MouseEvent.MOUSE_MOVE)
         {
            _loc2_ = param1.currentTarget as TRole;
            _loc3_ = this.FKnifeBins.GetDatebaseByIdentifier(_loc2_.KnifeData.RelationID) as TKnife;
            this.FHintBtn.Caption = _loc3_.Name + " " + TUtilityLobby.GetStringsByIdentifier(CONST_SYSTEMLANGUAGE.STRING_BATTLE_11)[_loc2_.KnifeData.Level];
            if(this.FHintOnMove != null)
            {
               this.FHintOnMove(this,this.FHintBtn);
            }
         }
         else if(param1.type == MouseEvent.ROLL_OUT)
         {
            if(this.FHintOnOut != null)
            {
               this.FHintOnOut(this,this.FHintBtn);
            }
         }
      }
      
      protected function ProcessorOnHitMove(param1:Object, param2:THint) : void
      {
         if(this.FHintOnMove != null)
         {
            this.FHintOnMove(this,param2);
         }
      }
      
      protected function ProcessorOnHitOut(param1:Object, param2:THint) : void
      {
         if(this.FHintOnOut != null)
         {
            this.FHintOnOut(this,param2);
         }
      }
      
      protected function ProcessorKnifeOfKillSoulOnMove(param1:Object, param2:Object) : void
      {
         if(this.FKnifeOfKillSoulOnMove != null)
         {
            this.FKnifeOfKillSoulOnMove(this,param2);
         }
      }
      
      protected function ProcessorKnifeOfKillSoulOnOut(param1:Object) : void
      {
         if(this.FKnifeOfKillSoulOnOut != null)
         {
            this.FKnifeOfKillSoulOnOut(this);
         }
      }
      
      protected function UIStageOnKeyDown(param1:KeyboardEvent) : void
      {
         var _loc2_:uint = 0;
         if(param1.ctrlKey && param1.altKey && param1.keyCode == KEY_QUOTE)
         {
            this.ProcessorCopyBattleInfo();
         }
      }
      
      public function set CriticalUI(param1:Function) : void
      {
         this.FCriticalUI = param1;
      }
      
      public function get CriticalUI() : Function
      {
         return this.FCriticalUI;
      }
      
      public function set OnChangeBg(param1:Function) : void
      {
         this.FOnChangeBg = param1;
      }
      
      public function get OnChangeBg() : Function
      {
         return this.FOnChangeBg;
      }
      
      public function set OnAntiColorBlackWhiteBg(param1:Function) : void
      {
         this.FOnAntiColorBlackWhiteBg = param1;
      }
      
      public function get OnAntiColorBlackWhiteBg() : Function
      {
         return this.FOnAntiColorBlackWhiteBg;
      }
      
      public function set OnRedAntiColorBg(param1:Function) : void
      {
         this.FOnRedAntiColorBg = param1;
      }
      
      public function get OnRedAntiColorBg() : Function
      {
         return this.FOnRedAntiColorBg;
      }
      
      public function get EffectSprite() : Sprite
      {
         return this.FEffectSprite;
      }
      
      public function get EndStatues() : Boolean
      {
         return this.FEndStatues;
      }
      
      public function get IsCrit() : Boolean
      {
         return this.FIsCrit;
      }
      
      public function set IsCrit(param1:Boolean) : void
      {
         this.FIsCrit = param1;
      }
      
      public function set OnEndBattle(param1:Function) : void
      {
         this.FOnEndBattle = param1;
      }
      
      public function set HintOnMove(param1:Function) : void
      {
         this.FHintOnMove = param1;
      }
      
      public function get HintOnMove() : Function
      {
         return this.FHintOnMove;
      }
      
      public function set HintOnOut(param1:Function) : void
      {
         this.FHintOnOut = param1;
      }
      
      public function get HintOnOut() : Function
      {
         return this.FHintOnOut;
      }
      
      public function get KnifeOfKillSoulOnMove() : Function
      {
         return this.FKnifeOfKillSoulOnMove;
      }
      
      public function set KnifeOfKillSoulOnMove(param1:Function) : void
      {
         this.FKnifeOfKillSoulOnMove = param1;
      }
      
      public function get KnifeOfKillSoulOnOut() : Function
      {
         return this.FKnifeOfKillSoulOnOut;
      }
      
      public function set KnifeOfKillSoulOnOut(param1:Function) : void
      {
         this.FKnifeOfKillSoulOnOut = param1;
      }
      
      public function ProcessorBattleSkip() : void
      {
         if(this.FEndStatues)
         {
            return;
         }
         this.FEndStatues = true;
         this.FBigSkills.SetStatues(true);
         this.FChain.Visible = false;
         this.FChain.Reset();
         if(this.FOnEndBattle != null)
         {
            this.FOnEndBattle(this);
         }
      }
      
      public function SetBattle(param1:TGroupRoleInfo, param2:TGroupRoleInfo) : void
      {
         var _loc3_:int = 0;
         var _loc4_:TRole = null;
         var _loc5_:TRoleBattleInfo = null;
         if(param1 == null || param2 == null || param1.RoleCount <= 0 || param2.RoleCount <= 0)
         {
            return;
         }
         if(param1.KnifeOfKillSoulID != 0)
         {
            _loc5_ = new TRoleBattleInfo(0);
            _loc5_.RoleId = param1.KnifeOfKillSoulID;
            this.FMounts_0 = TPoolRole.GetRole(this.FBattleFiled,_loc5_,this);
            this.FMounts_0.OnEffectEnd = this.NextCommand;
            this.FMounts_0.SetPosition(Pet_1_Point_X,Pet_1_Point_Y);
            this.FMounts_0.direction = true;
            this.FPlayerPetMgr.push(this.FMounts_0);
            this.FMounts_0.addEventListener(MouseEvent.MOUSE_MOVE,this.OnPetRoll,false,0,true);
            this.FMounts_0.addEventListener(MouseEvent.ROLL_OUT,this.OnPetRoll,false,0,true);
            TEffectControl.ShowPublicEffect(this.FMounts_0.BgSprite,CONST_BATTLE.BattlePetEffectId);
         }
         if(param2.KnifeOfKillSoulID != 0)
         {
            _loc5_ = new TRoleBattleInfo(1);
            _loc5_.RoleId = param2.KnifeOfKillSoulID;
            this.FMounts_1 = TPoolRole.GetRole(this.FBattleFiled,_loc5_,this);
            this.FMounts_1.OnEffectEnd = this.NextCommand;
            this.FMounts_1.SetPosition(Pet_2_Point_X,Pet_2_Point_Y);
            this.FMounts_1.direction = false;
            this.FPlayerPetMgr.push(this.FMounts_1);
            this.FMounts_1.addEventListener(MouseEvent.MOUSE_MOVE,this.OnPetRoll);
            this.FMounts_1.addEventListener(MouseEvent.ROLL_OUT,this.OnPetRoll);
            TEffectControl.ShowPublicEffect(this.FMounts_1.BgSprite,CONST_BATTLE.BattlePetEffectId);
         }
         _loc3_ = 0;
         while(_loc3_ < param1.RoleCount)
         {
            if(param1.RoleBattleInfos[_loc3_].CurHealth > 0 || (param1.RoleBattleInfos[_loc3_].RoleId == 11120993 || (param1.RoleBattleInfos[_loc3_].RoleId == 11120998 || param1.RoleBattleInfos[_loc3_].RoleId == 11121002) || param1.RoleBattleInfos[_loc3_].RoleId == 11120996))
            {
               _loc4_ = TPoolRole.GetRole(this.FBattleFiled,param1.RoleBattleInfos[_loc3_],this,this.SetEffectText);
               _loc4_.PrepareBattleRole();
               _loc4_.OnEffectEnd = this.NextCommand;
               _loc4_.OnBuffMouseMove = this.OnBuffMouseMove;
               _loc4_.OnBuffMouseRollOut = this.OnBuffMouseRollOut;
               this.FPlayerRole_0[_loc4_.Pos] = _loc4_;
               this.FPlayerRoleMgr.push(_loc4_);
            }
            _loc3_++;
         }
         _loc3_ = 0;
         while(_loc3_ < param2.RoleCount)
         {
            if(param2.RoleBattleInfos[_loc3_].CurHealth > 0 || (param2.RoleBattleInfos[_loc3_].RoleId == 11120993 || (param2.RoleBattleInfos[_loc3_].RoleId == 11120998 || param2.RoleBattleInfos[_loc3_].RoleId == 11121002) || param2.RoleBattleInfos[_loc3_].RoleId == 11120996))
            {
               _loc4_ = TPoolRole.GetRole(this.FBattleFiled,param2.RoleBattleInfos[_loc3_],this,this.SetEffectText);
               _loc4_.PrepareBattleRole();
               _loc4_.OnEffectEnd = this.NextCommand;
               _loc4_.OnBuffMouseMove = this.OnBuffMouseMove;
               _loc4_.OnBuffMouseRollOut = this.OnBuffMouseRollOut;
               this.FPlayerRole_1[_loc4_.Pos] = _loc4_;
               this.FPlayerRoleMgr.push(_loc4_);
            }
            _loc3_++;
         }
         this.ZBufferSort();
      }
      
      public function CreditCommandList(param1:TBattleInfo, param2:int) : void
      {
         this.FEndStatues = false;
         if(this.FBigSkills != null)
         {
            this.FBigSkills.SetStatues(false);
         }
         this.FBattleInfo = param1;
         this.SetBattle(param1.PlayerInfo_1,param1.PlayerInfo_2);
         this.MakeCommandList(param1.TotleTurn,param1.TurnInfos);
         this.FChain.SetKnifeOfKillSoulData(param1.PlayerInfo_1.KnifeOfKillSoulID,param1.PlayerInfo_2.KnifeOfKillSoulID);
         switch(param2)
         {
            case ENTER_TYPE_ARENA:
            case ENTER_TYPE_FightPet:
            case ENTER_TYPE_CityDefend:
            case ENTER_TYPE_OrganizationWar:
            case ENTER_TYPE_TraitorAttack:
            case ENTER_TYPE_Slave:
            case ENTER_TYPE_SkyTowerPVP:
            case ENTER_TYPE_GongFuFight:
            case ENTER_TYPE_Video:
               this.FChain.SetKnifeSoulData(param1.PlayerInfo_1.KnifeSoulID,param1.PlayerInfo_2.KnifeSoulID);
         }
         this.FChain.Visible = true;
         if(this.FBuffTips != null)
         {
            this.FBuffTips.visible = false;
         }
      }
      
      public function StartBattle() : void
      {
         this.NextCommand();
         this.AddUIStageOnKeyDown();
      }
      
      public function Reset() : void
      {
         ResetDamageFloats();
         var battleRasterHosts:Array = [this,this.FBattleFiled];
         for each(var battleRasterHost:DisplayObjectContainer in battleRasterHosts)
         {
            if(battleRasterHost != null)
            {
               var battleRasterIndex:int = battleRasterHost.numChildren - 1;
               while(battleRasterIndex >= 0)
               {
                  if(battleRasterHost.getChildAt(battleRasterIndex).name == "obitoSkillVfx" || battleRasterHost.getChildAt(battleRasterIndex).name.indexOf("obitoStatus_") == 0 || (battleRasterHost.getChildAt(battleRasterIndex).name == "hashiramaSkillVfx" || (battleRasterHost.getChildAt(battleRasterIndex).name == "mechaSkillVfx" || (battleRasterHost.getChildAt(battleRasterIndex).name == "tsunadeSkillVfx" || (battleRasterHost.getChildAt(battleRasterIndex).name == "nineTailsSkillVfx" || (battleRasterHost.getChildAt(battleRasterIndex).name == "tobiWarSkillVfx" || (battleRasterHost.getChildAt(battleRasterIndex).name == "kakuzuEdoSkillVfx" || battleRasterHost.getChildAt(battleRasterIndex).name == "madaraFinalSkillVfx")))) || battleRasterHost.getChildAt(battleRasterIndex).name == "gaaraSkillVfx" || battleRasterHost.getChildAt(battleRasterIndex).name == "nagatoSkillVfx" || (battleRasterHost.getChildAt(battleRasterIndex).name == "itachiSkillVfx" || battleRasterHost.getChildAt(battleRasterIndex).name == "sasukeSkillVfx")) || battleRasterHost.getChildAt(battleRasterIndex).name.indexOf("hashiramaStatus_") == 0 || battleRasterHost
                  .getChildAt(battleRasterIndex).name == "painSkillVfx" || battleRasterHost.getChildAt(battleRasterIndex).name.indexOf("painStatus_") == 0))
                  {
                     battleRasterHost.removeChildAt(battleRasterIndex);
                  }
                  battleRasterIndex--;
               }
            }
         }
         if(this.FBattleFiled != null)
         {
         }
         var _loc1_:int = 0;
         var _loc2_:TRole = null;
         var jiraiyaBackdrop:DisplayObject = getChildByName("jiraiyaEsophagusBackdrop");
         if(jiraiyaBackdrop != null)
         {
            removeChild(jiraiyaBackdrop);
         }
         this.RemoveUIStageOnKeyDown();
         while(this.FPlayerRoleMgr.length)
         {
            _loc2_ = this.FPlayerRoleMgr.pop();
            if(_loc2_ != null)
            {
               _loc2_.OnEffectEnd = null;
               _loc2_.OnBuffMouseMove = null;
               _loc2_.OnBuffMouseRollOut = null;
               TPoolRole.SaveRole(_loc2_);
            }
         }
         while(this.FPlayerPetMgr.length)
         {
            _loc2_ = this.FPlayerPetMgr.pop();
            _loc2_.removeEventListener(MouseEvent.MOUSE_MOVE,this.OnPetRoll);
            _loc2_.removeEventListener(MouseEvent.ROLL_OUT,this.OnPetRoll);
            TEffectControl.RemovePublicEffect(_loc2_,CONST_BATTLE.BattlePetEffectId);
            if(_loc2_ != null)
            {
               TPoolRole.SaveRole(_loc2_);
            }
         }
         this.FBigSkills.Reset();
         this.FCommandList.length = 0;
         this.FPlayerRoleMgr.length = 0;
         this.FPlayerPetMgr.length = 0;
         this.FPlayerRole_0 = new Dictionary(true);
         this.FPlayerRole_1 = new Dictionary(true);
         this.FMounts_0 = null;
         this.FMounts_1 = null;
         this.FIsBuffTip = false;
      }
      
      public function ShowWhiteSprite() : void
      {
         var HideWhiteSprite:Function = null;
         HideWhiteSprite = function():void
         {
            FWhiteSprite.visible = false;
         };
         if(this.FWhiteSprite == null)
         {
            this.FWhiteSprite = new Sprite();
            this.FWhiteSprite.graphics.beginFill(16777215);
            this.FWhiteSprite.graphics.drawRect(0,0,1250,650);
            this.FWhiteSprite.graphics.endFill();
         }
         addChild(this.FWhiteSprite);
         this.FWhiteSprite.visible = true;
         TBattleHandle.PlaybackTimeout(HideWhiteSprite,70);
      }
      
      public function ChangeBg(param1:Object, param2:uint) : void
      {
         if(this.FOnChangeBg != null)
         {
            this.FOnChangeBg(param1,param2);
         }
      }
      
      public function AntiColorBlackWhite(param1:TRole, param2:Boolean) : void
      {
         var _loc3_:int = 0;
         var _loc4_:TRole = null;
         _loc3_ = 0;
         while(_loc3_ < this.FPlayerRoleMgr.length)
         {
            _loc4_ = this.FPlayerRoleMgr[_loc3_];
            if(param2)
            {
               if(_loc4_ != param1)
               {
                  _loc4_.AntiColorBlackWhite = true;
               }
            }
            else
            {
               _loc4_.AntiColorBlackWhite = false;
            }
            _loc3_++;
         }
         _loc3_ = 0;
         while(_loc3_ < this.FPlayerPetMgr.length)
         {
            _loc4_ = this.FPlayerPetMgr[_loc3_];
            _loc4_.AntiColorBlackWhite = param2;
            _loc3_++;
         }
         if(this.FOnAntiColorBlackWhiteBg != null)
         {
            this.FOnAntiColorBlackWhiteBg(this,param2);
         }
      }
      
      public function RedAntiColor(param1:TRole, param2:Boolean) : void
      {
         var _loc3_:int = 0;
         var _loc4_:TRole = null;
         _loc3_ = 0;
         while(_loc3_ < this.FPlayerRoleMgr.length)
         {
            _loc4_ = this.FPlayerRoleMgr[_loc3_];
            if(param2)
            {
               if(_loc4_ != param1)
               {
                  _loc4_.RedAntiColor = true;
               }
            }
            else
            {
               _loc4_.RedAntiColor = false;
            }
            _loc3_++;
         }
         _loc3_ = 0;
         while(_loc3_ < this.FPlayerPetMgr.length)
         {
            _loc4_ = this.FPlayerPetMgr[_loc3_];
            _loc4_.RedAntiColor = param2;
            _loc3_++;
         }
         if(this.FOnRedAntiColorBg != null)
         {
            this.FOnRedAntiColorBg(this,param2);
         }
      }
      
      public function FSG(param1:Object, param2:uint, param3:uint, param4:Number) : void
      {
         var ClearID:uint = 0;
         var LineTimeOver:Function = null;
         var HideFullScreenGradientSprite:Function = null;
         var Sender:Object = param1;
         var Color:uint = param2;
         var LineTime:uint = param3;
         var Alpha:Number = param4;
         LineTimeOver = function():void
         {
            TBattleHandle.ClearPlaybackTimeout(ClearID);
            TweenUtil.to(FColorSprite,300 / TBattleHandle.PlaybackRate,{
               "alpha":0,
               "onComplete":HideFullScreenGradientSprite
            });
         };
         HideFullScreenGradientSprite = function():void
         {
            FColorSprite.visible = false;
         };
         if(this.FColorSprite == null)
         {
            this.FColorSprite = new Sprite();
         }
         this.FColorSprite.graphics.clear();
         this.FColorSprite.graphics.beginFill(Color);
         this.FColorSprite.graphics.drawRect(0,0,1250,650);
         this.FColorSprite.graphics.endFill();
         addChild(this.FColorSprite);
         this.FColorSprite.visible = true;
         this.FColorSprite.alpha = Alpha;
         ClearID = TBattleHandle.PlaybackTimeout(LineTimeOver,LineTime);
      }
   }
}

