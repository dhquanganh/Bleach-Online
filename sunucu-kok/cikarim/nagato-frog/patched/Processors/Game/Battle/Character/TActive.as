package Processors.Game.Battle.Character
{
   import Foundation.Common.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Bins.*;
   import Foundation.Resources.Repositories.*;
   import Foundation.Resources.Textures.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.Battle.model.*;
   import Logics.Characters.*;
   import Logics.DatebaseVO.VO.*;
   import Processors.*;
   import Processors.Game.Battle.*;
   import Processors.Game.Battle.Effect.*;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   import flash.utils.*;
   import ghostcat.util.data.*;
   import ghostcat.util.easing.*;
   
   public class TActive extends TUIComponent
   {
      
      protected static const SIZE_FrameRatePerSecond:int = CONST_COMMON.SIZE_FrameRatePerSecond;
      
      public static const Role_BaseSpeed:int = 500;
      
      public static const TYPE_ACTIVE_NONE:int = 0;
      
      public static const TYPE_ACTIVE_FIGHT_IDLE:int = 1;
      
      public static const TYPE_ACTIVE_ATTACK:int = 2;
      
      public static const TYPE_ACTIVE_SKILL:int = 3;
      
      public static const TYPE_ACTIVE_ATTACKED:int = 4;
      
      public static const TYPE_ACTIVE_RUN:int = 5;
      
      public static const TYPE_ACTIVE_DODGE:int = 7;
      
      public static const TYPE_ACTIVE_GRIDFILE:int = 8;
      
      public static const TYPE_ACTIVE_DIE:int = 9;
      
      public static const TYPE_ACTIVE_DEADSKILL:int = 10;
      
      public static const TYPE_NONE:int = 0;
      
      public static const TYPE_HERO:int = 1;
      
      public static const TYPE_ENEMY:int = 2;
      
      public static const TYPE_KNIFE:int = 3;
      
      public static const EnemyConfig_StartId:uint = 12101000;
      
      public static const HeroConfig_StartId:uint = 11100000;
      
      public static const KnifeConfig_StartId:uint = 2000000;
      
      protected static const QUALITYCOLOR_INDEX:Vector.<uint> = CONST_COMMON.QUALITYCOLOR_INDEX;
      
      protected var FIdlePosition:Vector.<int>;
      
      protected var FId:uint;
      
      protected var FPainFinal:Boolean = false;
      
      protected var FResourcesId:uint;
      
      protected var FMechaBeast:Boolean = false;
      
      protected var FTextures:TResourceRepositoryTexture;
      
      protected var FCurSequence:TAnimationSequence;
      
      protected var FCurrentFrame:TAnimationFrame;
      
      protected var FBitmap:Bitmap;
      
      protected var FTickReference:int;
      
      protected var FIndex:int;
      
      protected var FCurrentRebirthSequence:TAnimationSequence;
      
      protected var FCurrentRebirthFrame:TAnimationFrame;
      
      protected var FRoleRebirthBitMap:Bitmap;
      
      protected var FTextureFightIdle:TTexture;
      
      protected var FTextureAttack:TTexture;
      
      protected var FTextureSkill:TTexture;
      
      protected var FTextureAttacked:TTexture;
      
      protected var FTextureRun:TTexture;
      
      protected var FDefaultRoleTexture:TTexture;
      
      protected var FFrameIndex:int;
      
      protected var FHpBar:MovieClip;
      
      protected var FShaderBmp:Bitmap;
      
      protected var FBgSprite:Sprite;
      
      protected var FEffectSprite:Sprite;
      
      protected var FHasTip:Boolean;
      
      protected var FTargets:Vector.<TRole>;
      
      protected var FResults:Vector.<TTargetInfo>;
      
      protected var FSkillId:int;
      
      protected var FSkilling:Boolean;
      
      protected var FCallBackDict:Dictionary;
      
      protected var FTimeDict:Dictionary;
      
      protected var FResourcesType:int;
      
      protected var FKnifeExpand:TKnifeExpand;
      
      protected var FEnemy:TEnemy;
      
      protected var FHero:TBaseHero;
      
      protected var FAttackEffect:Object;
      
      protected var FIsLeft:Boolean;
      
      protected var FIsDie:Boolean;
      
      protected var FShowName:Boolean;
      
      protected var FNameTextFiled:TextField;
      
      protected var FNameSprite:Sprite;
      
      protected var FNameTextFormat:TextFormat;
      
      protected var FBuffSprite:Sprite;
      
      protected var FIsAntiColorBlackWhite:Boolean;
      
      protected var FIsRedAntiColor:Boolean;
      
      protected var FIsShowHighLight:Boolean;
      
      protected var FRoleModelBins:TBins;
      
      protected var FBaseHeroBins:TBins;
      
      protected var FEnemyBins:TBins;
      
      protected var FKnifeBins:TBins;
      
      protected var FKnifeExpandBins:TBins;
      
      protected var FBounds:TBounds;
      
      protected var FCoordinate:TCoordinate;
      
      protected var FCursorHovering:Boolean;
      
      protected var FInitHpBarHeight:Boolean;
      
      protected var FRebirthNum:int;
      
      protected var FMainRebirthEffectBaseID:uint;
      
      protected var FHeroRebirthEffectBaseID:uint;
      
      public function TActive(param1:TUIComponent, param2:int, param3:Boolean = true, param4:Boolean = false, param5:int = 0)
      {
         super(param1);
         this.FRebirthNum = param5;
         this.FTextures = SResourcesCore.TexturesModel;
         this.FId = param2;
         this.FPainFinal = false;
         this.FResourcesType = this.CheckType();
         this.FIsDie = false;
         this.FShowName = param3;
         this.FHasTip = param4;
         this.FAttackEffect = {};
         this.FInitHpBarHeight = false;
         this.FSkilling = false;
         this.FBounds = new TBounds();
         this.FCoordinate = new TCoordinate();
         this.InitActive();
      }
      
      protected function CheckType() : uint
      {
         return this.FId > EnemyConfig_StartId ? uint(TYPE_ENEMY) : (this.FId > HeroConfig_StartId ? uint(TYPE_HERO) : (this.FId > KnifeConfig_StartId ? uint(TYPE_KNIFE) : uint(TYPE_NONE)));
      }
      
      protected function InitActive() : void
      {
         var _loc1_:TBins = null;
         var _loc2_:TConfigValue = null;
         var _loc3_:Vector.<uint> = null;
         this.FRoleModelBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_RoleModel);
         this.FBaseHeroBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_BaseHero);
         this.FEnemyBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_Enemy);
         this.FKnifeBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_Knife);
         this.FKnifeExpandBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_KnifeExpand);
         _loc1_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_ConfigValue);
         _loc2_ = _loc1_.GetDatebaseByIdentifier(CONST_CONFIGVALUE.Rebirth_RebirthEffectID) as TConfigValue;
         _loc3_ = _loc2_.Value as Vector.<uint>;
         this.FMainRebirthEffectBaseID = _loc3_[0];
         this.FHeroRebirthEffectBaseID = _loc3_[1];
         this.FCallBackDict = new Dictionary(true);
         this.FTimeDict = new Dictionary(true);
         this.FIsShowHighLight = false;
         this.FIndex = TYPE_ACTIVE_FIGHT_IDLE;
         this.GetAttackEffect();
         this.FBgSprite = new Sprite();
         this.FBgSprite.mouseEnabled = false;
         this.FBgSprite.mouseChildren = false;
         addChild(this.FBgSprite);
         this.FShaderBmp = new Bitmap();
         addChild(this.FShaderBmp);
         this.FBitmap = new Bitmap();
         addChild(this.FBitmap);
         this.FRoleRebirthBitMap = new Bitmap();
         addChild(this.FRoleRebirthBitMap);
         this.FNameSprite = new Sprite();
         addChild(this.FNameSprite);
         this.FNameSprite.mouseEnabled = false;
         this.FNameSprite.mouseChildren = false;
         this.FBuffSprite = new Sprite();
         addChild(this.FBuffSprite);
         this.FEffectSprite = new Sprite();
         addChild(this.FEffectSprite);
         this.FEffectSprite.mouseEnabled = false;
         this.FEffectSprite.mouseChildren = false;
         this.FResourcesId = this.GetResourceID(this.FId);
         this.FDefaultRoleTexture = SResourcesCore.TexturesLobby.GetTextureByIdentifier(CONST_LOBBY.RESOURCEID_Textures_DefaultRole);
         this.FCurSequence = this.FDefaultRoleTexture.GetAnimationSequenceByIndex(0);
         this.ReloadRole();
         this.LoadAutoSecondary();
         this.CheckName();
      }
      
      protected function LoadAutoSecondary() : void
      {
         var _loc1_:String = null;
         var _loc2_:int = 0;
         var _loc3_:TBaseHero = null;
         _loc1_ = "0x" + this.FResourcesId.toString(16);
         SResourcesCore.TexturesModel.LoadAutoSecondary(uint(_loc1_ + CONST_BATTLE.RESOURCE_ActiveType_FightIdle),this.CheckTexture);
         SResourcesCore.TexturesModel.LoadAutoSecondary(uint(_loc1_ + CONST_BATTLE.RESOURCE_ActiveType_Attack),this.CheckTexture);
         SResourcesCore.TexturesModel.LoadAutoSecondary(uint(_loc1_ + CONST_BATTLE.RESOURCE_ActiveType_Skill),this.CheckTexture);
         SResourcesCore.TexturesModel.LoadAutoSecondary(uint(_loc1_ + CONST_BATTLE.RESOURCE_ActiveType_Attacked),this.CheckTexture);
         if(this.FRebirthNum > 0)
         {
            _loc3_ = this.FBaseHeroBins.GetDatebaseByIdentifier(this.FId) as TBaseHero;
            _loc2_ = _loc3_.IsMain ? int(this.FMainRebirthEffectBaseID) : int(this.FHeroRebirthEffectBaseID);
            SResourcesCore.TexturesLobby.LoadAutoSecondary(_loc2_ + this.FRebirthNum,this.RebirthResArrive);
         }
      }
      
      protected function RebirthResArrive(param1:Object, param2:TTexture, param3:uint) : void
      {
         var _loc4_:BitmapData = null;
         this.FCurrentRebirthSequence = param2.GetAnimationSequenceByIndex(0);
         this.FCurrentRebirthFrame = this.FCurrentRebirthSequence.GetAnimationFrameByIndex(0);
         _loc4_ = this.FCurrentRebirthFrame.Surface;
         this.FRoleRebirthBitMap.bitmapData = this.FCurrentRebirthFrame.Surface;
      }
      
      protected function CheckName() : void
      {
         var _loc1_:THero = null;
         var _loc2_:uint = 0;
         var _loc3_:TKnife = null;
         var _loc4_:String = null;
         if(this.FShowName)
         {
            if(this.FNameTextFiled == null)
            {
               this.FNameTextFiled = new TextField();
               this.FNameSprite.addChild(this.FNameTextFiled);
               this.FNameTextFormat = new TextFormat();
               this.FNameTextFormat.size = 12;
               this.FNameTextFormat.align = TextFormatAlign.CENTER;
               this.FNameTextFiled.defaultTextFormat = this.FNameTextFormat;
               this.FNameTextFiled.width = 120;
               this.FNameTextFiled.height = 30;
               this.FNameTextFiled.x = -this.FNameTextFiled.width / 2;
               this.FNameTextFiled.mouseEnabled = false;
            }
            if(this.FHero != null)
            {
               if(this.FHero.IsMain)
               {
                  _loc1_ = SLogicsCore.Character.GetMainHero();
                  _loc4_ = _loc1_.Name;
                  _loc2_ = _loc1_.Quality;
               }
               else
               {
                  _loc4_ = this.FHero.Name;
                  _loc2_ = uint(this.FHero.Quality);
               }
               if(this.FRebirthNum > 0)
               {
                  this.FNameTextFiled.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_Rebirth_19),_loc4_,this.FRebirthNum);
               }
               else
               {
                  this.FNameTextFiled.text = _loc4_;
               }
            }
            else if(this.FEnemy != null)
            {
               this.FNameTextFiled.text = this.FEnemy.Name;
               _loc2_ = uint(this.FEnemy.Quality);
            }
            else if(this.FKnifeExpand != null)
            {
               _loc3_ = this.FKnifeBins.GetDatebaseByIdentifier(this.FKnifeExpand.RelationID) as TKnife;
               this.FNameTextFiled.text = _loc3_.Name;
               _loc2_ = 1;
            }
            else
            {
               this.FNameTextFiled.text = "传送门";
               _loc2_ = 1;
            }
            this.FNameTextFiled.textColor = QUALITYCOLOR_INDEX[_loc2_];
            this.FNameTextFiled.filters = [TUtilityFilter.NameFilters[_loc2_]];
            this.FNameTextFiled.visible = true;
         }
         else if(this.FNameTextFiled != null)
         {
            this.FNameTextFiled.visible = false;
         }
      }
      
      protected function IsMouseInBitmapRect() : Boolean
      {
         if(this.FBitmap.bitmapData == null)
         {
            return true;
         }
         if(mouseX < this.FBitmap.x + this.FBitmap.width && mouseX > this.FBitmap.x && mouseY < this.FBitmap.y + this.FBitmap.height && mouseY > this.FBitmap.y)
         {
            return true;
         }
         return false;
      }
      
      protected function GetResourceID(param1:int) : int
      {
         var _loc2_:TRoleModel = null;
         if(this.FResourcesType == TYPE_NONE)
         {
            return param1;
         }
         if(this.FResourcesType == TYPE_KNIFE)
         {
            _loc2_ = this.FRoleModelBins.GetDatebaseByIdentifier(this.FKnifeExpand.RelationID) as TRoleModel;
         }
         else
         {
            _loc2_ = this.FRoleModelBins.GetDatebaseByIdentifier(param1) as TRoleModel;
         }
         return _loc2_.Model;
      }
      
      protected function PlayRun() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:String = null;
         if(this.FIndex == TYPE_ACTIVE_RUN)
         {
            return;
         }
         this.FTickReference = 0;
         this.FFrameIndex = -1;
         this.FIndex = TYPE_ACTIVE_RUN;
         _loc1_ = Math.random() * this.FTextureRun.Count;
         if(this.FId == 11120950)
         {
            _loc1_ = uint(this.FMechaBeast && this.FTextureRun.Count > 1 ? 1 : 0);
         }
         this.FCurSequence = this.FTextureRun.GetAnimationSequenceByIndex(_loc1_);
         if(this.FTextureRun == this.FDefaultRoleTexture)
         {
            _loc2_ = "0x" + this.FResourcesId.toString(16);
            SResourcesCore.TexturesModel.LoadAutoSecondary(uint(_loc2_ + CONST_BATTLE.RESOURCE_ActiveType_Run),this.CheckTexture);
         }
      }
      
      protected function PlayFightIdle() : void
      {
         var _loc1_:uint = 0;
         this.FTickReference = 0;
         this.FFrameIndex = -1;
         this.FIndex = TYPE_ACTIVE_FIGHT_IDLE;
         _loc1_ = Math.random() * this.FTextureFightIdle.Count;
         if(this.FId == 11120930)
         {
            _loc1_ = uint(this.FPainFinal && this.FTextureFightIdle.Count > 1 ? 1 : 0);
         }
         if(this.FId == 11120950)
         {
            _loc1_ = uint(this.FMechaBeast && this.FTextureFightIdle.Count > 1 ? 1 : 0);
         }
         this.FCurSequence = this.FTextureFightIdle.GetAnimationSequenceByIndex(_loc1_);
      }
      
      protected function PlayAttack() : void
      {
         var _loc1_:uint = 0;
         this.FTickReference = 0;
         this.FFrameIndex = -1;
         this.FIndex = TYPE_ACTIVE_ATTACK;
         _loc1_ = Math.random() * this.FTextureAttack.Count;
         if(this.FId == 11120920 && this.FTextureAttack.Count >= 2)
         {
            _loc1_ = uint(this.FSkillId == 13120954 ? 1 : 0);
         }
         if(this.FId == 11120940 && this.FTextureAttack.Count >= 2)
         {
            _loc1_ = uint(this.FSkillId == 13121007 ? 1 : 0);
         }
         if(this.FId == 11120950 && this.FTextureAttack.Count >= 2)
         {
            _loc1_ = uint(this.FSkillId == 13121103 ? 1 : 0);
         }
         if(this.FId == 11120960)
         {
            _loc1_ = 0;
         }
         if(this.FId == 11120970)
         {
            _loc1_ = uint(this.FSkillId == 13121304 ? 1 : 0);
         }
         if(this.FId==11120990)_loc1_=uint(this.FSkillId==13121407?2:this.FSkillId==13121406?1:0);
         this.FCurSequence = this.FTextureAttack.GetAnimationSequenceByIndex(_loc1_);
      }
      
      protected function PlayAttacked() : void
      {
         var _loc1_:uint = 0;
         this.FTickReference = 0;
         this.FFrameIndex = -1;
         this.FIndex = TYPE_ACTIVE_ATTACKED;
         _loc1_ = Math.random() * this.FTextureAttacked.Count;
         if(this.FId == 11120950)
         {
            _loc1_ = uint(this.FMechaBeast && this.FTextureAttacked.Count > 1 ? 1 : 0);
         }
         this.FCurSequence = this.FTextureAttacked.GetAnimationSequenceByIndex(_loc1_);
      }
      
      protected function PlaySkill() : void
      {
         if(this.FId==11120990 && (this.FSkillId==13121402 || this.FSkillId==13121406 || this.FSkillId==13121407)){this.FCallBackDict[TYPE_ACTIVE_ATTACK]=this.FCallBackDict[TYPE_ACTIVE_SKILL];this.FTimeDict[TYPE_ACTIVE_ATTACK]=this.FTimeDict[TYPE_ACTIVE_SKILL];this.PlayAttack();return;}

         if(this.FId == 11120970 && (this.FSkillId == 13121303 || this.FSkillId == 13121304))
         {
            this.FCallBackDict[TYPE_ACTIVE_ATTACK] = this.FCallBackDict[TYPE_ACTIVE_SKILL];
            this.FTimeDict[TYPE_ACTIVE_ATTACK] = this.FTimeDict[TYPE_ACTIVE_SKILL];
            this.PlayAttack();
            return;
         }
         if((this.FId == 11120901 || this.FId == 11120902) && this.FSkillId == 13120903)
         {
            this.FCallBackDict[TYPE_ACTIVE_ATTACK] = this.FCallBackDict[TYPE_ACTIVE_SKILL];
            this.FTimeDict[TYPE_ACTIVE_ATTACK] = this.FTimeDict[TYPE_ACTIVE_SKILL];
            this.PlayAttack();
            return;
         }
         if(this.FId == 11120960 && this.FSkillId == 13121203)
         {
            this.FCallBackDict[TYPE_ACTIVE_ATTACK] = this.FCallBackDict[TYPE_ACTIVE_SKILL];
            this.FTimeDict[TYPE_ACTIVE_ATTACK] = this.FTimeDict[TYPE_ACTIVE_SKILL];
            this.PlayAttack();
            return;
         }
         if(this.FId == 11120950 && (this.FSkillId == 13121102 || this.FSkillId == 13121103))
         {
            this.FCallBackDict[TYPE_ACTIVE_ATTACK] = this.FCallBackDict[TYPE_ACTIVE_SKILL];
            this.FTimeDict[TYPE_ACTIVE_ATTACK] = this.FTimeDict[TYPE_ACTIVE_SKILL];
            this.PlayAttack();
            return;
         }
         if(this.FId == 11120940 && (this.FSkillId == 13121006 || this.FSkillId == 13121007))
         {
            this.FCallBackDict[TYPE_ACTIVE_ATTACK] = this.FCallBackDict[TYPE_ACTIVE_SKILL];
            this.FTimeDict[TYPE_ACTIVE_ATTACK] = this.FTimeDict[TYPE_ACTIVE_SKILL];
            this.PlayAttack();
            return;
         }
         var _loc1_:uint = 0;
         if(this.FId == 11120920 && (this.FSkillId == 13120953 || this.FSkillId == 13120954))
         {
            this.FCallBackDict[TYPE_ACTIVE_ATTACK] = this.FCallBackDict[TYPE_ACTIVE_SKILL];
            this.FTimeDict[TYPE_ACTIVE_ATTACK] = this.FTimeDict[TYPE_ACTIVE_SKILL];
            this.PlayAttack();
            return;
         }
         this.FTickReference = 0;
         this.FFrameIndex = -1;
         this.FIndex = TYPE_ACTIVE_SKILL;
         _loc1_ = Math.random() * this.FTextureSkill.Count;
         if((this.FId == 11120901 || this.FId == 11120902) && this.FTextureSkill.Count >= 3)
         {
            _loc1_ = uint(this.FSkillId == 13120902 ? 1 : (this.FSkillId == 13120904 ? 2 : 0));
         }
         if(this.FId == 11120903 && this.FTextureSkill.Count >= 5)
         {
            _loc1_ = uint(this.FSkillId == 13120912 ? 1 : (this.FSkillId == 13120914 ? 2 : (this.FSkillId == 13120915 ? 3 : (this.FSkillId == 13120916 ? 4 : 0))));
         }
         if(this.FId == 11120920 && this.FTextureSkill.Count >= 5)
         {
            _loc1_ = uint(this.FSkillId == 13120952 ? 1 : (this.FSkillId == 13120955 || this.FSkillId == 13120957 ? 2 : (this.FSkillId == 13120956 || this.FSkillId == 13120958 ? 3 : (this.FSkillId == 13120959 ? 4 : 0))));
         }
         if(this.FId == 11120930 && this.FTextureSkill.Count >= 7)
         {
            _loc1_ = uint(this.FSkillId == 13120972 || this.FSkillId == 13120973 ? 1 : (this.FSkillId == 13120975 ? 2 : (this.FSkillId == 13120976 ? 3 : (this.FSkillId == 13120977 ? 4 : (this.FSkillId == 13120978 ? 5 : (this.FSkillId == 13120979 ? 6 : 0))))));
         }
         if(this.FId == 11120940 && this.FTextureSkill.Count >= 8)
         {
            _loc1_ = uint(this.FSkillId == 13121002 ? 1 : (this.FSkillId == 13121003 ? 2 : (this.FSkillId == 13121004 ? 3 : (this.FSkillId == 13121005 ? 4 : (this.FSkillId == 13121008 ? 5 : (this.FSkillId == 13121009 ? 6 : (this.FSkillId == 13121010 ? 7 : 0)))))));
         }
         if(this.FId == 11120950 && this.FTextureSkill.Count >= 11)
         {
            _loc1_ = uint(this.FSkillId == 13121104 ? 1 : (this.FSkillId == 13121105 ? 2 : (this.FSkillId == 13121106 ? 3 : (this.FSkillId == 13121107 ? 4 : (this.FSkillId == 13121108 ? 5 : (this.FSkillId == 13121109 ? 6 : (this.FSkillId == 13121110 ? 7 : (this.FSkillId == 13121111 ? 8 : (this.FSkillId == 13121112 ? 9 : (this.FSkillId == 13121113 ? 10 : 0))))))))));
         }
         if(this.FId == 11120960 && this.FSkillId >= 13121201 && this.FSkillId <= 13121207)
         {
            _loc1_ = uint(this.FSkillId == 13121207 ? 5 : (this.FSkillId >= 13121204 ? this.FSkillId - 13121202 : this.FSkillId - 13121201));
         }
         if(this.FId == 11120970 && this.FSkillId >= 13121301 && this.FSkillId <= 13121309)
         {
            _loc1_ = uint(this.FSkillId <= 13121302 ? this.FSkillId - 13121301 : this.FSkillId - 13121303);
         }
         if(this.FId==11120990 && this.FSkillId>=13121401 && this.FSkillId<=13121403)_loc1_=uint(this.FSkillId==13121403?1:0);
         this.FCurSequence = this.FTextureSkill.GetAnimationSequenceByIndex(_loc1_);
      }
      
      protected function GetAttackEffect() : void
      {
         this.FHero = null;
         this.FEnemy = null;
         this.FKnifeExpand = null;
         if(this.FResourcesType == TYPE_HERO)
         {
            this.FHero = this.FBaseHeroBins.GetDatebaseByIdentifier(this.FId) as TBaseHero;
            this.FAttackEffect = Json.decode(this.FHero.AttackEffect);
         }
         else if(this.FResourcesType == TYPE_ENEMY)
         {
            this.FEnemy = this.FEnemyBins.GetDatebaseByIdentifier(this.FId) as TEnemy;
            this.FAttackEffect = Json.decode(this.FEnemy.Effects);
         }
         else if(this.FResourcesType == TYPE_KNIFE)
         {
            this.FKnifeExpand = this.FKnifeExpandBins.GetDatebaseByIdentifier(this.FId) as TKnifeExpand;
            this.FAttackEffect = Json.decode(this.FKnifeExpand.Effects);
         }
         else
         {
            this.FAttackEffect = {};
         }
         if(this.FAttackEffect == 0)
         {
            this.FAttackEffect = {};
         }
      }
      
      protected function GetTextureById(param1:uint) : TTexture
      {
         var _loc2_:TTexture = null;
         if(_loc2_ == null)
         {
            _loc2_ = this.FTextures.GetTextureByIdentifier(param1);
            if(_loc2_ == null)
            {
               _loc2_ = this.FDefaultRoleTexture;
               this.FTextures.LoadSecondary(param1);
            }
         }
         return _loc2_;
      }
      
      protected function LoadResources(param1:uint) : void
      {
         switch(param1)
         {
            case CONST_BATTLE.Public_Effect_Shadow:
               SResourcesCore.TexturesSkill.LoadAutoSecondary(CONST_BATTLE.Public_Effect_Shadow,this.AutoLoadCallBack);
         }
      }
      
      protected function AutoLoadCallBack(param1:Object, param2:TTexture, param3:uint) : void
      {
         var _loc4_:TAnimationSequence = null;
         var _loc5_:TBounds = null;
         var _loc6_:TCoordinate = null;
         switch(param3)
         {
            case CONST_BATTLE.Public_Effect_Shadow:
               _loc5_ = new TBounds();
               _loc6_ = new TCoordinate();
               _loc4_ = param2.GetAnimationSequenceByIndex(0);
               _loc4_.Evaluate(_loc6_,_loc5_);
               this.FShaderBmp.bitmapData = _loc4_.GetAnimationFrameByIndex(0).Surface;
               this.FShaderBmp.x = _loc5_.X;
               this.FShaderBmp.y = _loc5_.Y;
         }
         _loc5_ = null;
         _loc6_ = null;
      }
      
      public function get ResourcesId() : uint
      {
         return this.FResourcesId;
      }
      
      public function IsBaseHero() : Boolean
      {
         return this.FResourcesType == TYPE_HERO;
      }
      
      override public function get Cursor() : uint
      {
         if(this.FCursorHovering)
         {
            return CONST_CURSOR.CURSORID_Enemy;
         }
         return CONST_CURSOR.CURSORID_Default;
      }
      
      override public function get CursorDisplayObject() : TUIComponent
      {
         return this.Parent.Parent.Parent;
      }
      
      public function get RoleWidth() : Number
      {
         if(this.FBitmap.bitmapData != null)
         {
            return this.FBitmap.width;
         }
         return 0;
      }
      
      public function get RoleHeight() : Number
      {
         if(this.FBitmap.bitmapData != null)
         {
            return this.FBitmap.height;
         }
         return 0;
      }
      
      override public function set scaleX(param1:Number) : void
      {
         super.scaleX = param1;
         if(this.FNameSprite != null)
         {
            this.FNameSprite.scaleX = scaleX;
         }
      }
      
      public function get direction() : Boolean
      {
         return this.FIsLeft;
      }
      
      public function set direction(param1:Boolean) : void
      {
         this.FIsLeft = param1;
         this.scaleX = Math.abs(scaleX) * (param1 ? 1 : -1);
      }
      
      public function set PosX(param1:int) : void
      {
         if(x < param1)
         {
            this.scaleX = Math.abs(scaleX);
         }
         else if(x > param1)
         {
            this.scaleX = -Math.abs(scaleX);
         }
         x = param1;
      }
      
      public function get PosX() : int
      {
         return x;
      }
      
      public function set PosY(param1:int) : void
      {
         y = param1;
      }
      
      public function get PosY() : int
      {
         return y;
      }
      
      public function IsSkill(param1:int) : Boolean
      {
         if(this.FId==11120990 && param1>=13121401 && param1<=13121407)return param1==13121401 || param1==13121403;

         if(this.FId == 11120970 && param1 >= 13121301 && param1 <= 13121309)
         {
            return param1 != 13121303 && param1 != 13121304;
         }
         if((this.FId == 11120901 || this.FId == 11120902) && param1 >= 13120901 && param1 <= 13120904)
         {
            return param1 != 13120903;
         }
         if(this.FId == 11120960 && param1 >= 13121201 && param1 <= 13121207)
         {
            return param1 != 13121203;
         }
         if(this.FId == 11120950 && param1 >= 13121101 && param1 <= 13121113)
         {
            return param1 != 13121102 && param1 != 13121103;
         }
         if(this.FId == 11120940 && param1 >= 13121001 && param1 <= 13121010)
         {
            return param1 != 13121006 && param1 != 13121007;
         }
         if(this.FId == 11120930 && param1 >= 13120971 && param1 <= 13120979)
         {
            return param1 != 13120974;
         }
         if(this.FId == 11120920 && (param1 == 13120953 || param1 == 13120954))
         {
            return false;
         }
         var _loc2_:Boolean = false;
         var _loc3_:TSkillConfig = null;
         _loc2_ = false;
         if(param1 < 0)
         {
            return false;
         }
         _loc3_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_SkillConfig,param1) as TSkillConfig;
         if(_loc3_ != null)
         {
            if(this.FEnemy != null)
            {
               _loc2_ = this.FEnemy.Normal != _loc3_.SkillId;
            }
            else if(this.FHero != null)
            {
               _loc2_ = this.FHero.NormalAttack != _loc3_.SkillId;
            }
            else if(this.FKnifeExpand != null)
            {
               _loc2_ = this.FKnifeExpand.SkillID == _loc3_.SkillId;
            }
         }
         else
         {
            _loc2_ = false;
         }
         return _loc2_;
      }
      
      public function ActiveType(param1:int) : int
      {
         if(this.IsSkill(param1))
         {
            return TYPE_ACTIVE_SKILL;
         }
         if(param1 > 0)
         {
            return TYPE_ACTIVE_ATTACK;
         }
         if(param1 == -1)
         {
            return TYPE_ACTIVE_GRIDFILE;
         }
         if(param1 == -2)
         {
            return TYPE_ACTIVE_DEADSKILL;
         }
         return TYPE_ACTIVE_NONE;
      }
      
      public function get EffectSprite() : Sprite
      {
         return this.FEffectSprite;
      }
      
      public function get HasTip() : Boolean
      {
         return this.FHasTip;
      }
      
      public function set ShowHighLight(param1:Boolean) : void
      {
         if(this.FIsAntiColorBlackWhite || this.FIsRedAntiColor)
         {
            return;
         }
         if(this.FIsDie)
         {
            return;
         }
         if(this.FIsShowHighLight == param1)
         {
            return;
         }
         this.FIsShowHighLight = param1;
         this.FBitmap.filters = this.FIsShowHighLight ? [TUtilityFilter.highLightFilters] : [];
      }
      
      public function get KnifeData() : TKnifeExpand
      {
         return this.FKnifeExpand;
      }
      
      public function get EnemyData() : TEnemy
      {
         return this.FEnemy;
      }
      
      public function get HeroData() : TBaseHero
      {
         return this.FHero;
      }
      
      public function get Id() : int
      {
         return this.FId;
      }
      
      public function get Display() : DisplayObject
      {
         return this.FBitmap;
      }
      
      public function get SkillId() : int
      {
         return this.FSkillId;
      }
      
      public function get Skilling() : Boolean
      {
         return this.FSkilling;
      }
      
      public function get CursorHovering() : Boolean
      {
         return this.FCursorHovering;
      }
      
      public function set CursorHovering(param1:Boolean) : void
      {
         this.FCursorHovering = param1;
      }
      
      public function get IdlePositionX() : int
      {
         return this.FIdlePosition[0];
      }
      
      public function get IdlePositionY() : int
      {
         return this.FIdlePosition[1];
      }
      
      public function get BgSprite() : Sprite
      {
         return this.FBgSprite;
      }
      
      public function CheckDirection() : void
      {
      }
      
      public function MoveTo(param1:Function, param2:TCoordinate, param3:Number = 500) : void
      {
         var _loc4_:Number = Number(NaN);
         var _loc5_:Number = Number(NaN);
         var _loc6_:TCoordinate = null;
         _loc6_ = new TCoordinate();
         _loc6_.X = this.x;
         _loc6_.Y = this.y;
         TweenUtil.removeTween(this,false);
         if(param2.X == _loc6_.X && param2.Y == _loc6_.Y)
         {
            param1();
            return;
         }
         _loc4_ = TUtilityCartisian.CoordinateDistance(_loc6_,param2);
         _loc5_ = 1000 * _loc4_ / param3;
         TweenUtil.to(this,_loc5_ / TBattleHandle.PlaybackRate,{
            "PosX":param2.X,
            "PosY":param2.Y,
            "onComplete":param1
         });
      }
      
      public function ActivePlay(param1:int, param2:int = 0, param3:Vector.<TRole> = null, param4:Vector.<TTargetInfo> = null, param5:Function = null, param6:uint = 0, param7:Boolean = false) : void
      {
         if(this.FIsDie)
         {
            return;
         }
         this.FTargets = param3;
         this.FSkillId = param2;
         this.FSkilling = this.IsSkill(this.FSkillId);
         if(param1 == TYPE_ACTIVE_RUN)
         {
            this.PlayRun();
         }
         else if(param1 == TYPE_ACTIVE_FIGHT_IDLE)
         {
            this.PlayFightIdle();
            this.CheckDirection();
            if(param5 != null)
            {
               param5();
            }
         }
      }
      
      public function CheckTexture(param1:Object, param2:TTexture, param3:uint) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:String = null;
         _loc5_ = "0x" + this.FResourcesId.toString(16);
         if(param3 == uint(_loc5_ + CONST_BATTLE.RESOURCE_ActiveType_FightIdle))
         {
            this.FInitHpBarHeight = false;
            if(this.FIndex == TYPE_ACTIVE_FIGHT_IDLE)
            {
               this.FTextureFightIdle = param2;
               this.FCurSequence = this.FTextureFightIdle.GetAnimationSequenceByIndex(this.FId == 11120950 && this.FMechaBeast && this.FTextureFightIdle.Count > 1 ? 1 : 0);
               this.FTickReference = 0;
               this.FFrameIndex = -1;
            }
         }
         else if(param3 == uint(_loc5_ + CONST_BATTLE.RESOURCE_ActiveType_Attack))
         {
            this.FTextureAttack = param2;
         }
         else if(param3 == uint(_loc5_ + CONST_BATTLE.RESOURCE_ActiveType_Skill))
         {
            this.FTextureSkill = param2;
         }
         else if(param3 == uint(_loc5_ + CONST_BATTLE.RESOURCE_ActiveType_Attacked))
         {
            this.FTextureAttacked = param2;
         }
         else if(param3 == uint(_loc5_ + CONST_BATTLE.RESOURCE_ActiveType_Run))
         {
            this.FTextureRun = param2;
            if(this.FIndex == TYPE_ACTIVE_RUN)
            {
               this.FTextureRun = param2;
               this.FCurSequence = this.FTextureRun.GetAnimationSequenceByIndex(0);
               this.FTickReference = 0;
               this.FFrameIndex = -1;
            }
         }
      }
      
      public function UpdateActive() : void
      {
         var _loc1_:TAnimationSequence = null;
         var _loc2_:BitmapData = null;
         var _loc3_:Function = null;
         var _loc4_:uint = 0;
         if(stage == null)
         {
            return;
         }
         if(this.FShaderBmp.bitmapData == null)
         {
            this.LoadResources(CONST_BATTLE.Public_Effect_Shadow);
         }
         this.FCurrentFrame = this.FCurSequence.GetAnimationFrameByTick(this.FTickReference);
         if(this.FCurrentFrame != null)
         {
            _loc2_ = this.FCurrentFrame.Surface;
            if(this.FBitmap.bitmapData != _loc2_)
            {
               this.FBitmap.bitmapData = _loc2_;
               this.FBitmap.x = -this.FCurrentFrame.Pivot.X;
               this.FBitmap.y = -this.FCurrentFrame.Pivot.Y;
            }
         }
         if(this.FCurrentFrame == null)
         {
            _loc3_ = this.FCallBackDict[this.FIndex];
            if(_loc1_.Timing != 2)
            {
               this.PlayFightIdle();
               if(this.FIdlePosition != null)
               {
                  this.x = this.FIdlePosition[0];
                  this.y = this.FIdlePosition[1];
               }
            }
            if(_loc3_ != null)
            {
               _loc3_();
            }
         }
         this.FTickReference += SIZE_FrameRatePerSecond;
         if(this.FShowName)
         {
            this.FNameSprite.y = -this.RoleHeight - 12;
         }
      }
      
      public function CheckMouseInColor() : Boolean
      {
         var _loc1_:Boolean = false;
         if(this.FIsDie)
         {
            return false;
         }
         if(this.FBitmap.bitmapData == null)
         {
            return false;
         }
         if(this.IsMouseInBitmapRect())
         {
            _loc1_ = TUtilityBitmap.IsMouseOnNoAlphaPixel(this.FBitmap.bitmapData,mouseX - this.FBitmap.x,mouseY - this.FBitmap.y);
            if(_loc1_)
            {
               return true;
            }
            return false;
         }
         return false;
      }
      
      public function ReloadRole() : void
      {
         this.FTextureFightIdle = this.FDefaultRoleTexture;
         this.FTextureAttack = this.FDefaultRoleTexture;
         this.FTextureSkill = this.FDefaultRoleTexture;
         this.FTextureAttacked = this.FDefaultRoleTexture;
         this.FTextureRun = this.FDefaultRoleTexture;
      }
      
      public function Reset() : void
      {
         this.FMechaBeast = false;
         var _loc1_:String = null;
         this.FBitmap.bitmapData = null;
         this.FShaderBmp.bitmapData = null;
         this.FCurSequence = null;
         this.FCurrentFrame = null;
         this.FCurrentRebirthSequence = null;
         this.FCurrentRebirthFrame = null;
         this.FRoleRebirthBitMap.bitmapData = null;
         for(_loc1_ in this.FCallBackDict)
         {
            delete this.FCallBackDict[_loc1_];
         }
         this.FCallBackDict = null;
         for(_loc1_ in this.FTimeDict)
         {
            delete this.FTimeDict[_loc1_];
         }
         this.FTargets = null;
         this.FResults = null;
         this.FTextureFightIdle = null;
         this.FTextureAttack = null;
         this.FTextureSkill = null;
         this.FTextureAttacked = null;
         this.FTextureRun = null;
      }
      
      public function ResetActive(param1:TUIComponent, param2:uint, param3:Boolean = true, param4:Boolean = false, param5:int = 0) : void
      {
         var _loc6_:TResourceRepositoryTexture = null;
         this.FRebirthNum = param5;
         FParent = param1;
         if(param1 != null)
         {
            param1.addChild(this);
         }
         Visible = true;
         this.FId = param2;
         this.FPainFinal = false;
         this.FResourcesType = this.CheckType();
         this.FInitHpBarHeight = false;
         this.direction = true;
         this.FBitmap.bitmapData = null;
         this.FRoleRebirthBitMap.bitmapData = null;
         this.FCurrentRebirthSequence = null;
         this.GetAttackEffect();
         this.FCurSequence = this.FDefaultRoleTexture.GetAnimationSequenceByIndex(0);
         this.FShowName = param3;
         this.FHasTip = param4;
         this.FIsDie = false;
         this.FCallBackDict = new Dictionary(true);
         this.FIndex = TYPE_ACTIVE_FIGHT_IDLE;
         this.FTargets = null;
         this.FResourcesId = this.GetResourceID(this.FId);
         this.ReloadRole();
         this.LoadAutoSecondary();
         this.CheckName();
         this.ResetColor();
         x = 0;
         y = 0;
      }
      
      public function ResetColor() : void
      {
         this.FBitmap.filters = [];
         this.FShaderBmp.filters = [];
         this.FBuffSprite.filters = [];
         if(this.FHpBar)
         {
            this.FHpBar.filters = [];
         }
         this.FBgSprite.filters = [];
      }
      
      public function set AntiColorBlackWhite(param1:Boolean) : void
      {
         if(this.FIsDie)
         {
            return;
         }
         this.FIsAntiColorBlackWhite = param1;
         if(param1)
         {
            this.FBitmap.filters = [TUtilityFilter.AntiColorFilters,TUtilityFilter.rBlackFilters];
            this.FShaderBmp.filters = [TUtilityFilter.AntiColorFilters,TUtilityFilter.rBlackFilters];
            this.FBuffSprite.filters = [TUtilityFilter.AntiColorFilters,TUtilityFilter.rBlackFilters];
            if(this.FHpBar)
            {
               this.FHpBar.filters = [TUtilityFilter.AntiColorFilters,TUtilityFilter.rBlackFilters];
            }
            this.FBgSprite.filters = [TUtilityFilter.AntiColorFilters,TUtilityFilter.rBlackFilters];
         }
         else
         {
            this.FBitmap.filters = [];
            this.FShaderBmp.filters = [];
            this.FBuffSprite.filters = [];
            if(this.FHpBar)
            {
               this.FHpBar.filters = [];
            }
            this.FBgSprite.filters = [];
         }
      }
      
      public function set RedAntiColor(param1:Boolean) : void
      {
         if(this.FIsDie)
         {
            return;
         }
         this.FIsRedAntiColor = param1;
         if(param1)
         {
            this.FBitmap.filters = [TUtilityFilter.rBlackFilters,TUtilityFilter.RedAntiColorFilters];
            this.FShaderBmp.filters = [TUtilityFilter.rBlackFilters,TUtilityFilter.RedAntiColorFilters];
            this.FBuffSprite.filters = [TUtilityFilter.rBlackFilters,TUtilityFilter.RedAntiColorFilters];
            if(this.FHpBar)
            {
               this.FHpBar.filters = [TUtilityFilter.rBlackFilters,TUtilityFilter.RedAntiColorFilters];
            }
            this.FBgSprite.filters = [TUtilityFilter.rBlackFilters,TUtilityFilter.RedAntiColorFilters];
         }
         else
         {
            this.ResetColor();
         }
      }
   }
}

