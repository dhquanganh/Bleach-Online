package Processors.Game.Lobby.OfficeLady
{
   import Components.Standard.*;
   import Foundation.Common.*;
   import Foundation.Network.*;
   import Foundation.Resources.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.Achievenment.*;
   import Logics.Characters.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.Streamization.Characters.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Utilities.*;
   import Processors.Game.Utilities.HyperLink.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class TProcessorWindowOfficeLady extends TProcessorLobbyWindow
   {
      
      protected static const BaseAttributesIndexs:Vector.<int> = Vector.<int>([CONST_COMMON.BASEATTRIBUTEINDEX_Power,CONST_COMMON.BASEATTRIBUTEINDEX_Intelligence,CONST_COMMON.BASEATTRIBUTEINDEX_Agile,CONST_COMMON.BASEATTRIBUTEINDEX_Life]);
      
      protected static const ConditionNum:int = 3;
      
      protected static const ScheduleFormat:String = "(%0/%1)";
      
      protected var FMainUI:Sprite;
      
      protected var FBtn_Close:SimpleButton;
      
      protected var FBtn_GotOfficeLady:TUIButton;
      
      protected var FGirlPic:MovieClip;
      
      protected var FUnstreamizerCharacter:TUnstreamizerCharacter;
      
      protected var FHeros:THeros;
      
      protected var FAttributesTextField:Vector.<TextField>;
      
      protected var FAttributesRateTextField:Vector.<TextField>;
      
      protected var FMouseOverFlag:Vector.<MovieClip>;
      
      protected var FConditionTag:Vector.<MovieClip>;
      
      protected var FAlreadyCompleteTag:Vector.<Sprite>;
      
      protected var FSkill:TextField;
      
      protected var FHeroDescription:TextField;
      
      protected var FTalent:TextField;
      
      protected var FHint:THint;
      
      protected var FAchievement:TAchievementInfor;
      
      protected var FHeroID:int;
      
      protected var FOnHintOver:Function;
      
      protected var FOnHintOut:Function;
      
      public function TProcessorWindowOfficeLady(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Sprite = null;
         var _loc3_:MovieClip = null;
         this.FMainUI = TUtilityReflection.CreateDisplayObjectInstance("OfficeLadyUI") as Sprite;
         addChild(this.FMainUI);
         this.FBtn_Close = this.FMainUI["Board"]["BtnClose"];
         this.FBtn_GotOfficeLady = new TUIButton();
         this.FBtn_GotOfficeLady.Substrate = this.FMainUI["GotLady"];
         this.FGirlPic = this.FMainUI["Girl"];
         this.CreateHero();
         this.FAttributesTextField = new Vector.<TextField>();
         this.FAttributesRateTextField = new Vector.<TextField>();
         this.FConditionTag = new Vector.<MovieClip>();
         this.FAlreadyCompleteTag = new Vector.<Sprite>();
         this.FMouseOverFlag = new Vector.<MovieClip>();
         _loc1_ = 0;
         while(_loc1_ < BaseAttributesIndexs.length)
         {
            this.FAttributesTextField.push(this.FMainUI["Attribute" + _loc1_]);
            this.FAttributesRateTextField.push(this.FMainUI["Rate" + _loc1_]);
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < ConditionNum)
         {
            _loc3_ = this.FMainUI["Condition" + _loc1_];
            this.FConditionTag.push(_loc3_);
            this.FAlreadyCompleteTag.push(_loc3_["CompleteTag"]);
            this.FMouseOverFlag.push(_loc3_["MouseOverFlag"]);
            _loc1_++;
         }
         this.FSkill = this.FMainUI["Skill"];
         this.FHeroDescription = this.FMainUI["Description"];
         this.FTalent = this.FMainUI["Talent"];
         this.FHint = new THint();
         this.FAchievement = SLogicsCore.Character.AchievementData.GetAchievementByID(CONST_OFFICELADY.OfficeLadyAchievementID);
         super.ResourcesPerform_UIDispatch();
      }
      
      protected function CreateHero() : void
      {
         var _loc1_:Vector.<uint> = null;
         this.FUnstreamizerCharacter = new TUnstreamizerCharacter();
         this.FHeros = new THeros();
         this.FHeroID = 11120002;
         _loc1_ = new Vector.<uint>();
         _loc1_.push(this.FHeroID);
         this.FUnstreamizerCharacter.UnstreamizeGenerateHerosByIdentifiers(null,this.FHeros,_loc1_);
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Sprite = null;
         var _loc3_:MovieClip = null;
         this.FBtn_Close.addEventListener(MouseEvent.CLICK,this.OnCloseClick);
         _loc1_ = 0;
         while(_loc1_ < ConditionNum)
         {
            _loc3_ = this.FConditionTag[_loc1_];
            _loc3_.mouseChildren = false;
            _loc3_.addEventListener(MouseEvent.MOUSE_MOVE,this.OnMouseOver);
            _loc3_.addEventListener(MouseEvent.MOUSE_OUT,this.OnMouseOut);
            _loc3_.buttonMode = true;
            _loc3_.addEventListener(MouseEvent.CLICK,this.OnBtnClick);
            _loc1_++;
         }
         this.FBtn_GotOfficeLady.OnClick = this.OnBtnGotLadyClick;
         this.FTalent.addEventListener(MouseEvent.MOUSE_MOVE,this.OnTalentMouseOver);
         this.FTalent.addEventListener(MouseEvent.MOUSE_OUT,this.OnNormalMouseOut);
         this.FSkill.addEventListener(MouseEvent.MOUSE_MOVE,this.OnSkillMouseOver);
         this.FSkill.addEventListener(MouseEvent.MOUSE_OUT,this.OnNormalMouseOut);
         super.ResourcesPerform_UILocations();
      }
      
      protected function Update_Perform() : void
      {
         var _loc1_:int = 0;
         var _loc2_:THero = null;
         var _loc3_:TBaseHero = null;
         var _loc4_:String = null;
         if(!FIsResourcesLoadCompleted)
         {
            return;
         }
         this.FGirlPic.play();
         _loc2_ = this.FHeros.GetHeroByIndex(0);
         _loc3_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_BaseHero,this.FHeroID) as TBaseHero;
         _loc4_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.Achievement_String_01);
         _loc1_ = 0;
         while(_loc1_ < BaseAttributesIndexs.length)
         {
            this.FAttributesTextField[_loc1_].text = "+" + _loc2_.GetBaseAttributeByIndex(BaseAttributesIndexs[_loc1_]);
            this.FAttributesRateTextField[_loc1_].text = _loc4_ + _loc2_.GetFirstAttributeRateByIndex(BaseAttributesIndexs[_loc1_]);
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < ConditionNum)
         {
            if(this.FAchievement.AchievementSchedules[_loc1_].Complete)
            {
               this.FConditionTag[_loc1_].gotoAndStop(1);
               this.FAlreadyCompleteTag[_loc1_].visible = true;
            }
            else
            {
               this.FConditionTag[_loc1_].gotoAndStop(2);
               this.FAlreadyCompleteTag[_loc1_].visible = false;
            }
            this.FConditionTag[_loc1_].mouseChildren = false;
            _loc1_++;
         }
         this.FSkill.text = _loc2_.Skill.Name;
         this.FHeroDescription.text = _loc3_.Desc;
         this.FTalent.text = _loc2_.TalentName;
         this.FBtn_GotOfficeLady.Enabled = !this.FAchievement.IfGotReward;
      }
      
      protected function OnCloseClick(param1:MouseEvent) : void
      {
         ProcessorWindowClose();
      }
      
      protected function OnBtnClick(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         _loc2_ = this.FConditionTag.indexOf(param1.currentTarget as Sprite);
         switch(_loc2_)
         {
            case 0:
               SUtilityHyperLink.ShortcutHyperlink(TUtilityHyperLink.HyperLink_SuperMarket);
               break;
            case 1:
               SUtilityHyperLink.ShortcutHyperlink(TUtilityHyperLink.HyperLink_Tavern);
         }
      }
      
      protected function OnSkillMouseOver(param1:MouseEvent) : void
      {
         if(this.FOnHintOver != null)
         {
            this.FHint.Caption = this.FHeros.GetHeroByIndex(0).Skill.Description;
            this.FOnHintOver(this,this.FHint);
         }
      }
      
      protected function OnMouseOver(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:TAchievementSchedule = null;
         _loc2_ = this.FConditionTag.indexOf(param1.currentTarget as Sprite);
         _loc3_ = this.FAchievement.AchievementSchedules[_loc2_];
         this.FMouseOverFlag[_loc2_].gotoAndPlay(1);
         this.FMouseOverFlag[_loc2_].visible = true;
         if(this.FOnHintOver != null)
         {
            if(_loc3_.Complete)
            {
               this.FHint.Caption = _loc3_.ConditionStrings;
            }
            else
            {
               this.FHint.Caption = _loc3_.ConditionStrings + TUtilityString.Format(ScheduleFormat,_loc3_.CurrentSchedule,_loc3_.Value);
            }
            this.FOnHintOver(this,this.FHint);
         }
      }
      
      protected function OnTalentMouseOver(param1:MouseEvent) : void
      {
         if(this.FOnHintOver != null)
         {
            this.FHint.Caption = this.FHeros.GetHeroByIndex(0).TalentDesc;
            this.FOnHintOver(this,this.FHint);
         }
      }
      
      protected function OnNormalMouseOut(param1:MouseEvent) : void
      {
         if(this.FOnHintOut != null)
         {
            this.FOnHintOut(this,this.FHint);
         }
      }
      
      protected function OnMouseOut(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         _loc2_ = this.FConditionTag.indexOf(param1.currentTarget as Sprite);
         this.FMouseOverFlag[_loc2_].visible = false;
         if(this.FOnHintOut != null)
         {
            this.FOnHintOut(this,this.FHint);
         }
      }
      
      protected function OnBtnGotLadyClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TPacket = null;
         if(!this.FAchievement.IfComplete)
         {
            EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.Achievement_String_03));
            return;
         }
         _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_AchievementRewardReq);
         _loc3_.Data.writeUnsignedInt(CONST_OFFICELADY.OfficeLadyAchievementID);
         SNetworkCore.Transceiver.PacketTransmit(_loc3_);
      }
      
      public function set OnHintOver(param1:Function) : void
      {
         this.FOnHintOver = param1;
      }
      
      public function set OnHintOut(param1:Function) : void
      {
         this.FOnHintOut = param1;
      }
      
      public function Update() : void
      {
         this.Update_Perform();
      }
      
      public function Reset() : void
      {
         this.FGirlPic.stop();
      }
   }
}

