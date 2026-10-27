package Processors.Game.Lobby.RelatedPartner.Component
{
   import Components.Standard.TUIButton;
   import Foundation.Resources.SResourcesCore;
   import Foundation.Utilities.TUtilityReflection;
   import Foundation.Utilities.TUtilityString;
   import Logics.Characters.THero;
   import Logics.DatebaseVO.VO.TBaseHero;
   import Logics.DatebaseVO.VO.TRelatedPartnerType;
   import Logics.RelatedPartner.TRelatedPartnerHeroSkill;
   import Logics.SLogicsCore;
   import Processors.Game.Lobby.RelatedPartner.TRelatedPartnerCommon;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Resources.Constants.CONST_COMMON;
   import Resources.Constants.CONST_DATEBASEVO;
   import Resources.Constants.CONST_RELATEDPARTNER;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.events.TextEvent;
   import flash.text.TextField;
   
   public class TRenderHeroSkill extends Sprite
   {
      
      protected var FMainUI:Sprite;
      
      protected var FBackground:MovieClip;
      
      protected var FTFName:TextField;
      
      protected var FTFProperty:TextField;
      
      protected var FTFCondition:TextField;
      
      protected var FTFMaxLvl:TextField;
      
      protected var FTFMaxProperty:TextField;
      
      protected var FIconStar:Sprite;
      
      protected var FIconUnlock:Sprite;
      
      protected var FIconActive:Sprite;
      
      protected var FBtnTrain:TUIButton;
      
      protected var FBtnBoard:TUIButton;
      
      protected var FBtnAssistance:TUIButton;
      
      protected var FBtnUpgrade:TUIButton;
      
      protected var FViewActive:Sprite;
      
      protected var FViewUnlock:Sprite;
      
      protected var FViewLock:Sprite;
      
      protected var FHeroSkill:TRelatedPartnerHeroSkill;
      
      protected var FTypeId:int;
      
      protected var FIsMain:Boolean;
      
      protected var FGotoUpgrade:Function;
      
      protected var FGotoPosition:Function;
      
      protected var FGotoAssistance:Function;
      
      protected var FGotoTrain:Function;
      
      protected var FGotoLink:Function;
      
      protected var FHintOver:Function;
      
      protected var FHintOut:Function;
      
      protected var FBgType:int;
      
      public function TRenderHeroSkill()
      {
         super();
      }
      
      protected function ViewLock() : void
      {
         this.FViewLock = this.FMainUI["MC_Lock"];
         this.FIconStar = this.FViewLock["Icon_Star"];
         this.FIconStar.addEventListener(MouseEvent.MOUSE_OVER,this.OnHintOver);
         this.FIconStar.addEventListener(MouseEvent.MOUSE_OUT,this.OnHintOut);
         this.FIconStar.buttonMode = true;
         this.FIconUnlock = this.FViewLock["Icon_Unlock"];
         this.FIconUnlock.addEventListener(MouseEvent.MOUSE_OVER,this.OnHintOver);
         this.FIconUnlock.addEventListener(MouseEvent.MOUSE_OUT,this.OnHintOut);
         this.FIconUnlock.buttonMode = true;
         this.FBtnTrain = new TUIButton();
         this.FBtnTrain.Substrate = this.FViewLock["Btn_Train"];
         this.FBtnTrain.OnClick = this.OnGotoTrain;
         this.FTFMaxLvl = this.FViewLock["TF_MaxLvl"];
         this.FTFMaxProperty = this.FViewLock["TF_MaxProperty"];
      }
      
      protected function ViewUnlock() : void
      {
         this.FViewUnlock = this.FMainUI["MC_Unlock"];
         this.FBtnBoard = new TUIButton();
         this.FBtnBoard.Substrate = this.FViewUnlock["Btn_Board"];
         this.FBtnBoard.OnClick = this.OnGotoPosition;
         this.FBtnAssistance = new TUIButton();
         this.FBtnAssistance.Substrate = this.FViewUnlock["Btn_Assistance"];
         this.FBtnAssistance.OnClick = this.OnGotoAssistance;
      }
      
      protected function ViewActive() : void
      {
         this.FViewActive = this.FMainUI["MC_Active"];
         this.FBtnUpgrade = new TUIButton();
         this.FBtnUpgrade.Substrate = this.FViewActive["Btn_Upgrade"];
         this.FBtnUpgrade.OnClick = this.OnGotoUpgrade;
         this.FBtnUpgrade.OnOver = this.OnUpgradeOver;
         this.FBtnUpgrade.OnOut = this.OnUpgradeOut;
         this.FIconActive = this.FViewActive["MC_Active"];
      }
      
      protected function RenderLock() : void
      {
         var _loc1_:TRelatedPartnerType = null;
         var _loc2_:String = null;
         this.FViewLock.visible = true;
         this.FTFName = this.FViewLock["TF_Name"];
         this.FTFProperty = this.FViewLock["TF_Property"];
         this.FTFCondition = this.FViewLock["TF_Condition"];
         this.FBackground.gotoAndStop(3);
         _loc1_ = this.FHeroSkill.Skills[this.FHeroSkill.Skills.length - 1];
         this.FTFMaxLvl.text = "Lv." + _loc1_.Level;
         this.FTFMaxProperty.text = TRelatedPartnerCommon.GetSkillDesc(_loc1_.Identifier);
      }
      
      protected function RenderUnLock() : void
      {
         this.FViewUnlock.visible = true;
         this.FTFName = this.FViewUnlock["TF_Name"];
         this.FTFProperty = this.FViewUnlock["TF_Property"];
         this.FTFCondition = this.FViewUnlock["TF_Condition"];
         this.FBackground.gotoAndStop(2);
      }
      
      protected function RenderActive() : void
      {
         this.FViewActive.visible = true;
         this.FTFName = this.FViewActive["TF_Name"];
         this.FTFProperty = this.FViewActive["TF_Property"];
         this.FTFCondition = this.FViewActive["TF_Condition"];
         this.FIconActive.visible = true;
         this.FBtnUpgrade.Visible = true;
         this.FBackground.gotoAndStop(1);
      }
      
      protected function Reset() : void
      {
         this.FViewActive.visible = false;
         this.FViewLock.visible = false;
         this.FViewUnlock.visible = false;
         if(this.FTFCondition != null)
         {
            this.FTFCondition.removeEventListener(TextEvent.LINK,this.OnConditionLink);
            this.FTFCondition.removeEventListener(MouseEvent.MOUSE_MOVE,this.OnHintOver);
            this.FTFCondition.removeEventListener(MouseEvent.MOUSE_OUT,this.OnHintOut);
         }
      }
      
      protected function OnGotoTrain(param1:Object, param2:MouseEvent) : void
      {
         this.FGotoTrain(this.FHeroSkill.Partner.ConditionPoint);
      }
      
      protected function OnGotoPosition(param1:Object, param2:MouseEvent) : void
      {
         this.FGotoPosition();
      }
      
      protected function OnGotoAssistance(param1:Object, param2:MouseEvent) : void
      {
         this.FGotoAssistance();
      }
      
      protected function OnGotoUpgrade(param1:Object, param2:MouseEvent) : void
      {
         this.FGotoUpgrade(this.FHeroSkill);
      }
      
      protected function OnHintOver(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Sprite = null;
         var _loc4_:TextField = null;
         _loc3_ = param1.target as Sprite;
         switch(_loc3_)
         {
            case this.FIconStar:
               _loc2_ = CONST_RELATEDPARTNER.HintType_Star;
               break;
            case this.FIconUnlock:
               _loc2_ = CONST_RELATEDPARTNER.HintType_Unlock;
               break;
            case this.FBtnUpgrade.Substrate:
               _loc2_ = CONST_RELATEDPARTNER.HintType_Property;
         }
         if(_loc3_ == null)
         {
            _loc4_ = param1.target as TextField;
            _loc2_ = CONST_RELATEDPARTNER.HintType_Heroname;
         }
         this.FHintOver(_loc2_,this.FHeroSkill);
      }
      
      protected function OnHintOut(param1:MouseEvent) : void
      {
         this.FHintOut();
      }
      
      protected function OnConditionLink(param1:TextEvent) : void
      {
         this.FGotoLink(param1.text);
      }
      
      protected function OnUpgradeOver(param1:Object, param2:MouseEvent) : void
      {
         this.OnHintOver(param2);
      }
      
      protected function OnUpgradeOut(param1:Object, param2:MouseEvent) : void
      {
         this.OnHintOut(param2);
      }
      
      public function get GotoUpgrade() : Function
      {
         return this.FGotoUpgrade;
      }
      
      public function set GotoUpgrade(param1:Function) : void
      {
         this.FGotoUpgrade = param1;
      }
      
      public function get GotoPosition() : Function
      {
         return this.FGotoPosition;
      }
      
      public function set GotoPosition(param1:Function) : void
      {
         this.FGotoPosition = param1;
      }
      
      public function get GotoAssistance() : Function
      {
         return this.FGotoAssistance;
      }
      
      public function set GotoAssistance(param1:Function) : void
      {
         this.FGotoAssistance = param1;
      }
      
      public function get GotoTrain() : Function
      {
         return this.FGotoTrain;
      }
      
      public function set GotoTrain(param1:Function) : void
      {
         this.FGotoTrain = param1;
      }
      
      public function get HintOver() : Function
      {
         return this.FHintOver;
      }
      
      public function set HintOver(param1:Function) : void
      {
         this.FHintOver = param1;
      }
      
      public function get HintOut() : Function
      {
         return this.FHintOut;
      }
      
      public function set HintOut(param1:Function) : void
      {
         this.FHintOut = param1;
      }
      
      public function get GotoLink() : Function
      {
         return this.FGotoLink;
      }
      
      public function set GotoLink(param1:Function) : void
      {
         this.FGotoLink = param1;
      }
      
      public function get BgType() : int
      {
         return this.FBgType;
      }
      
      public function set BgType(param1:int) : void
      {
         this.FBgType = param1;
      }
      
      public function get TypeId() : int
      {
         return this.FTypeId;
      }
      
      public function Init() : void
      {
         this.FMainUI = TUtilityReflection.CreateDisplayObjectInstance(CONST_RELATEDPARTNER.ResourceID_Item_DetailHeroSkill) as Sprite;
         addChild(this.FMainUI);
         if(this.FBgType == CONST_RELATEDPARTNER.BG_Detail)
         {
            this.FBackground = this.FMainUI["MC_Bg_0"];
            this.FMainUI["MC_Bg_1"].visible = false;
         }
         else
         {
            this.FBackground = this.FMainUI["MC_Bg_1"];
            this.FMainUI["MC_Bg_0"].visible = false;
         }
         this.ViewLock();
         this.ViewUnlock();
         this.ViewActive();
      }
      
      public function RenderMainHero(param1:TRelatedPartnerHeroSkill, param2:THero) : void
      {
         var _loc3_:TRelatedPartnerType = null;
         var _loc4_:TBaseHero = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         this.FIsMain = true;
         this.FHeroSkill = param1;
         this.Reset();
         this.RenderActive();
         if(param2 == null)
         {
            this.FIconActive.visible = false;
            this.FBtnUpgrade.Visible = false;
            this.FBackground.gotoAndStop(2);
         }
         _loc3_ = param1.CurSkill;
         _loc4_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_BaseHero,this.FHeroSkill.Partner.ConnectId) as TBaseHero;
         _loc5_ = "<font color=\'" + CONST_COMMON.TextColor[_loc4_.Quality] + "\'><u><a href=\'event:" + _loc4_.Source + "\'>" + _loc4_.Name + "</a></u></font>";
         this.FTFCondition.htmlText = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_Related_23),_loc5_);
         this.FTFCondition.addEventListener(TextEvent.LINK,this.OnConditionLink);
         this.FTFCondition.addEventListener(MouseEvent.MOUSE_MOVE,this.OnHintOver);
         this.FTFCondition.addEventListener(MouseEvent.MOUSE_OUT,this.OnHintOut);
         _loc6_ = TRelatedPartnerCommon.GetSkillDesc(_loc3_.Identifier);
         this.FTFName.text = _loc3_.Name + "Lv." + _loc3_.Level;
         this.FTFProperty.text = _loc6_;
         this.FTypeId = _loc3_.Type;
      }
      
      public function Render(param1:TRelatedPartnerHeroSkill) : void
      {
         var _loc2_:THero = null;
         var _loc3_:int = 0;
         var _loc4_:Boolean = false;
         var _loc5_:String = null;
         var _loc6_:TRelatedPartnerType = null;
         var _loc7_:TBaseHero = null;
         var _loc8_:String = null;
         this.FIsMain = false;
         this.FHeroSkill = param1;
         this.Reset();
         if(param1.SkillId == 0)
         {
            this.RenderLock();
            _loc6_ = param1.Skills[0];
         }
         else
         {
            _loc2_ = SLogicsCore.Character.Heros.GetHeroByIdentifier(param1.Partner.ConnectId);
            if(_loc2_ != null)
            {
               _loc3_ = int(_loc2_.RelatedPartnerPos);
               _loc4_ = _loc2_.Mounted || _loc3_ > 0;
            }
            if(_loc4_)
            {
               this.RenderActive();
            }
            else
            {
               this.RenderUnLock();
            }
            _loc6_ = param1.CurSkill;
         }
         _loc7_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_BaseHero,this.FHeroSkill.Partner.ConnectId) as TBaseHero;
         _loc8_ = "<font color=\'" + CONST_COMMON.TextColor[_loc7_.Quality] + "\'><u><a href=\'event:" + _loc7_.Source + "\'>" + _loc7_.Name + "</a></u></font>";
         this.FTFCondition.htmlText = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_Related_05),_loc8_);
         this.FTFCondition.addEventListener(TextEvent.LINK,this.OnConditionLink);
         this.FTFCondition.addEventListener(MouseEvent.MOUSE_MOVE,this.OnHintOver);
         this.FTFCondition.addEventListener(MouseEvent.MOUSE_OUT,this.OnHintOut);
         _loc5_ = TRelatedPartnerCommon.GetSkillDesc(_loc6_.Identifier);
         this.FTFName.text = _loc6_.Name + "Lv." + _loc6_.Level;
         this.FTFProperty.text = _loc5_;
         this.FTypeId = _loc6_.Type;
      }
      
      public function Update(param1:TRelatedPartnerHeroSkill) : void
      {
         var _loc2_:TBaseHero = null;
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:TRelatedPartnerType = null;
         this.FHeroSkill = param1;
         _loc5_ = this.FHeroSkill.CurSkill;
         _loc2_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_BaseHero,this.FHeroSkill.Partner.ConnectId) as TBaseHero;
         _loc3_ = "<font color=\'" + CONST_COMMON.TextColor[_loc2_.Quality] + "\'><u><a href=\'event:" + _loc2_.Source + "\'>" + _loc2_.Name + "</a></u></font>";
         if(this.FIsMain)
         {
            this.FTFCondition.htmlText = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_Related_23),_loc3_);
         }
         else
         {
            this.FTFCondition.htmlText = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_Related_05),_loc3_);
         }
         _loc4_ = TRelatedPartnerCommon.GetSkillDesc(_loc5_.Identifier);
         this.FTFName.text = _loc5_.Name + "Lv." + _loc5_.Level;
         this.FTFProperty.text = _loc4_;
      }
   }
}

