package Processors.Game.Battle.Character
{
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.Battle.*;
   import Logics.Battle.model.*;
   import Logics.DatebaseVO.VO.*;
   import Processors.Game.Battle.*;
   import Processors.Game.Battle.Effect.*;
   import Processors.Game.Battle.GoneWord.*;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.text.*;
   import ghostcat.util.easing.*;
   
   public class TBaseRole extends TActive
   {
      
      public static const INIT_HpBar_Y:Number = -100;
      
      protected static const QUALITYCOLOR_INDEX:Vector.<uint> = CONST_COMMON.QUALITYCOLOR_INDEX;
      
      protected var FInfo:TRoleBattleInfo;
      
      protected var FShowSpEffect:Boolean;
      
      protected var FWaitDie:Boolean;
      
      protected var FHp_Effect:Sprite;
      
      protected var FCurAnger:Number;
      
      protected var FCurHealth:Number;
      
      protected var FInitPos:uint;
      
      public function TBaseRole(param1:TUIComponent, param2:TRoleBattleInfo)
      {
         super(param1,param2.RoleId,false,true,param2.RebirthNum);
         this.FInfo = param2;
         this.FInitPos = this.Pos;
         this.InitBaseRole();
      }
      
      protected function InitBaseRole() : void
      {
         var _loc1_:String = null;
         var _loc2_:TKnife = null;
         FIdlePosition = new Vector.<int>(2);
         this.FWaitDie = false;
         if(FHpBar == null)
         {
            FHpBar = TUtilityReflection.CreateDisplayObjectInstance(CONST_BATTLE.RESOURCE_ClassName_HP_Bar) as MovieClip;
            addChild(FHpBar);
            this.FHp_Effect = new Sprite();
            FHpBar.addChildAt(this.FHp_Effect,1);
            this.FHp_Effect.graphics.beginFill(16711680,1);
            this.FHp_Effect.graphics.drawRect(0,0,FHpBar.mc_hp.width,FHpBar.mc_hp.height);
            this.FHp_Effect.graphics.endFill();
            this.FHp_Effect.x = FHpBar.mc_hp.x;
            this.FHp_Effect.y = FHpBar.mc_hp.y;
            FHpBar.y = INIT_HpBar_Y;
         }
         if(this.CharacterName != null && this.CharacterName != "")
         {
            _loc1_ = this.CharacterName;
         }
         else
         {
            if(FHero != null)
            {
               _loc1_ = FHero.Name;
            }
            else if(FEnemy != null)
            {
               _loc1_ = FEnemy.Name;
            }
            else if(FKnifeExpand != null)
            {
               _loc2_ = FKnifeBins.GetDatebaseByIdentifier(FKnifeExpand.RelationID) as TKnife;
               _loc1_ = _loc2_.Name;
            }
            else
            {
               _loc1_ = "";
            }
            this.FInfo.RoleName = _loc1_;
         }
         if(FRebirthNum > 0)
         {
            FHpBar.mc_name.tf_name.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_Rebirth_19),_loc1_,FRebirthNum);
         }
         else
         {
            FHpBar.mc_name.tf_name.text = _loc1_;
         }
         FHpBar.mc_name.tf_name.textColor = QUALITYCOLOR_INDEX[this.FInfo.Quality];
         FHpBar.mc_name.tf_name.filters = [TUtilityFilter.NameFilters[this.FInfo.Quality]];
         this.FShowSpEffect = false;
         this.CurAnger = this.FInfo.CurAnger;
         this.CurHealth = this.FInfo.CurHealth;
         this.CheckDirection();
         FHpBar.mc_hp.visible = Boolean(FResourcesType != TYPE_KNIFE);
         FHpBar.hp_bg.visible = Boolean(FResourcesType != TYPE_KNIFE);
      }
      
      protected function MoveOut(param1:DisplayObject) : void
      {
         var Remove:Function = null;
         var Tf:DisplayObject = param1;
         Remove = function():void
         {
            if(Boolean(Tf) && Boolean(Tf.parent))
            {
               Tf.parent.removeChild(Tf);
            }
         };
         TweenUtil.to(Tf,1000,{
            "y":Tf.y - 50,
            "onComplete":Remove
         });
      }
      
      protected function DisappearEffect(param1:DisplayObject, param2:uint) : void
      {
         TweenUtil.to(param1,param2,{"alpha":0});
      }
      
      public function get Camp() : int
      {
         return this.FInfo.Camp;
      }
      
      public function get Pos() : int
      {
         return this.FInfo.Pos;
      }
      
      public function set Pos(param1:int) : void
      {
         this.FInfo.Pos = param1;
      }
      
      public function get CharacterName() : String
      {
         return this.FInfo.RoleName;
      }
      
      override public function get Id() : int
      {
         return this.FInfo.RoleId;
      }
      
      public function get CurHealth() : Number
      {
         return this.FCurHealth;
      }
      
      public function set CurHealth(param1:Number) : void
      {
         this.FHp_Effect.alpha = 1;
         this.FHp_Effect.scaleX = FHpBar.mc_hp.scaleX;
         this.DisappearEffect(this.FHp_Effect,200);
         this.FCurHealth = param1;
         if(this.FCurHealth > this.TotleHealth)
         {
            this.FCurHealth = this.TotleHealth;
         }
         if(this.FCurHealth < 0)
         {
            this.FCurHealth = 0;
         }
         if(FHpBar)
         {
            FHpBar.mc_hp.scaleX = Math.max(Math.min(this.FCurHealth / this.TotleHealth,1),0);
         }
      }
      
      public function get CurHealthNoHurtNumber() : Number
      {
         return this.FCurHealth;
      }
      
      public function set CurHealthNoHurtNumber(param1:Number) : void
      {
         this.FHp_Effect.alpha = 1;
         this.FHp_Effect.scaleX = FHpBar.mc_hp.scaleX;
         this.DisappearEffect(this.FHp_Effect,200);
         this.FCurHealth = param1;
         if(this.FCurHealth > this.TotleHealth)
         {
            this.FCurHealth = this.TotleHealth;
         }
         if(this.FCurHealth < 0)
         {
            this.FCurHealth = 0;
         }
         if(FHpBar)
         {
            FHpBar.mc_hp.scaleX = Math.max(Math.min(this.FCurHealth / this.TotleHealth,1),0);
         }
      }
      
      public function get TotleHealth() : Number
      {
         return this.FInfo.TotleHealth;
      }
      
      public function get CurAnger() : Number
      {
         return this.FCurAnger;
      }
      
      public function set CurAnger(param1:Number) : void
      {
         if(param1 < 0)
         {
            param1 = 0;
         }
         this.FCurAnger = param1;
         if(this.FCurAnger > 500)
         {
            this.FCurAnger = 500;
         }
         if(this.FShowSpEffect && param1 < this.TotleAnger)
         {
            this.FShowSpEffect = false;
            TEffectControl.RemovePublicEffect(FBgSprite,CONST_BATTLE.Public_Effect_AngerRing);
         }
         if(!this.FShowSpEffect && param1 >= this.TotleAnger)
         {
            this.FShowSpEffect = true;
            TEffectControl.ShowPublicEffect(FBgSprite,CONST_BATTLE.Public_Effect_AngerRing);
         }
      }
      
      public function get TotleAnger() : int
      {
         return this.FInfo.TotleAnger;
      }
      
      public function get Level() : int
      {
         return this.FInfo.RoleLevel;
      }
      
      public function get SkillID() : int
      {
         return this.FInfo.SkillId;
      }
      
      public function get RoleInfo() : TRoleBattleInfo
      {
         return this.FInfo;
      }
      
      override public function Reset() : void
      {
         super.Reset();
         this.Pos = this.FInitPos;
         this.FInfo = null;
      }
      
      public function setActive(param1:TRoleBattleInfo) : void
      {
         this.FInfo = param1;
         this.InitBaseRole();
      }
      
      override public function CheckDirection() : void
      {
         if(this.Camp == 0)
         {
            scaleX = Math.abs(scaleX);
         }
         else if(this.Camp == 1)
         {
            scaleX = -Math.abs(scaleX);
         }
         FHpBar.scaleX = scaleX;
         if(FNameTextFiled != null)
         {
            FNameTextFiled.scaleX = scaleX;
         }
         if(FBuffSprite != null)
         {
            FBuffSprite.scaleX = scaleX;
         }
      }
      
      public function ResetBaseRole(param1:TUIComponent, param2:TRoleBattleInfo) : void
      {
         ResetActive(param1,param2.RoleId,false,true,param2.RebirthNum);
         this.FWaitDie = false;
         this.FInfo = param2;
         this.FInitPos = this.Pos;
         this.FShowSpEffect = false;
         FHpBar.y = INIT_HpBar_Y;
         TEffectControl.RemoveContainerEffect(this);
         TEffectControl.RemoveContainerPublicEffect(FBgSprite);
         this.InitBaseRole();
      }
   }
}

