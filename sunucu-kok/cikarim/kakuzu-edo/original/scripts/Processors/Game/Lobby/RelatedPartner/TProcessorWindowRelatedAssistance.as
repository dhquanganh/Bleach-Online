package Processors.Game.Lobby.RelatedPartner
{
   import Components.Standard.TUIButton;
   import Foundation.Common.THint;
   import Foundation.Network.*;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Logics.Characters.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.RelatedPartner.*;
   import Logics.SLogicsCore;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import Processors.Game.Lobby.RelatedPartner.RelatedAssistance.*;
   import Processors.Game.Lobby.TacticalDeployment.TProcessorTacticalDeployment;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.HyperLink.*;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Resources.Constants.*;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class TProcessorWindowRelatedAssistance extends TProcessorLobbyWindow
   {
      
      protected static const Assistance_Num:int = CONST_RELATEDPARTNER.RelatedAssistance_Num;
      
      protected static const Position_Num:int = CONST_RELATEDPARTNER.RelatedPosition_Num;
      
      protected static const Assistance_Hero_Num:int = CONST_RELATEDPARTNER.Assistance_Hero_Num;
      
      protected var FMainUI:Sprite;
      
      protected var FBtnClose:TUIButton;
      
      protected var FAssistanceItems:Vector.<TItemAssistance>;
      
      protected var FPositionItems:Vector.<TItemPosition>;
      
      protected var FBtnExchange:TUIButton;
      
      protected var FHeroDatas:TRelatedPartnerHeros;
      
      protected var FConfigVec:Vector.<int>;
      
      protected var FHeros:THeros;
      
      protected var FRelatedHeros:THeros;
      
      protected var FAssistanceTip:TAssistanceHeroTip;
      
      protected var FHint:THint;
      
      protected var FTFDesc:TextField;
      
      protected var FOnAssistanceList:Function;
      
      protected var FOnItemOver:Function;
      
      protected var FOnItemOut:Function;
      
      public function TProcessorWindowRelatedAssistance(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TItemAssistance = null;
         var _loc4_:TItemPosition = null;
         super.ResourcesPerform_UIDispatch();
         this.FMainUI = TUtilityReflection.CreateDisplayObjectInstance(CONST_RELATEDPARTNER.ResourceID_RelatedAssistance) as Sprite;
         addChild(this.FMainUI);
         this.FBtnClose = new TUIButton();
         this.FBtnClose.Substrate = this.FMainUI[CONST_COMMON.RESOURCE_Link_Btn_Close];
         this.FBtnClose.OnClick = this.BtnOnClose;
         this.FBtnExchange = new TUIButton();
         this.FBtnExchange.Substrate = this.FMainUI["Btn_Exchange"];
         this.FBtnExchange.OnClick = this.ExchangeOnClick;
         this.FAssistanceItems = new Vector.<TItemAssistance>();
         _loc1_ = 0;
         while(_loc1_ < Assistance_Num)
         {
            _loc3_ = new TItemAssistance(this.FMainUI["MC_Assistance_" + _loc1_]);
            _loc3_.OnAssistanceList = this.FOnAssistanceList;
            _loc3_.OnOver = this.AssistanceOnItemOver;
            _loc3_.OnOut = this.AssistanceOnItemOut;
            this.FAssistanceItems.push(_loc3_);
            _loc1_++;
         }
         this.FPositionItems = new Vector.<TItemPosition>();
         _loc1_ = 0;
         while(_loc1_ < Position_Num)
         {
            _loc4_ = new TItemPosition(this.FMainUI["MC_Heads_" + _loc1_]);
            _loc4_.OnOver = this.HeadOnOver;
            _loc4_.OnOut = this.HeadOnOut;
            _loc4_.OnHeroOver = this.HeroOnOver;
            _loc4_.OnHeroOut = this.HeroOnOut;
            this.FPositionItems.push(_loc4_);
            _loc1_++;
         }
         this.FTFDesc = this.FMainUI["TF_Desc"];
         this.FTFDesc.text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_Related_24);
         this.FAssistanceTip = new TAssistanceHeroTip(this);
         this.FHint = new THint();
         TRelatedPartnerCommon.InitSkillData();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         var _loc1_:TConfigValue = null;
         super.ResourcesPerform_UILocations();
         _loc1_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.Related_Open) as TConfigValue;
         this.FConfigVec = Vector.<int>(_loc1_.Value);
      }
      
      protected function RenderUI() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TRelatedPartnerHero = null;
         var _loc5_:THero = null;
         var _loc6_:int = 0;
         _loc3_ = int(SLogicsCore.Character.GetMainLevel());
         _loc2_ = Assistance_Num;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FAssistanceItems[_loc1_].ForbidLevel = this.FConfigVec[_loc1_];
            this.FAssistanceItems[_loc1_].IsForbid = _loc3_ < this.FConfigVec[_loc1_];
            this.FAssistanceItems[_loc1_].Position = _loc1_ + 1;
            this.FAssistanceItems[_loc1_].Hero = null;
            _loc1_++;
         }
         this.FRelatedHeros = TRelatedPartnerCommon.GetRelatedHeros();
         _loc2_ = this.FRelatedHeros.Count;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc5_ = this.FRelatedHeros.GetHeroByIndex(_loc1_);
            if(!_loc5_.IsMain && _loc5_.Mounted)
            {
               _loc4_ = this.FHeroDatas.GetHeroDataByIdentifier(_loc5_.Identifier);
               this.FPositionItems[_loc6_].Render(_loc4_);
               _loc6_++;
            }
            if(_loc5_.RelatedPartnerPos != 0)
            {
               this.FAssistanceItems[_loc5_.RelatedPartnerPos - 1].Hero = _loc5_;
            }
            _loc1_++;
         }
         _loc2_ = Assistance_Num;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FAssistanceItems[_loc1_].Render();
            _loc1_++;
         }
         _loc2_ = Position_Num;
         _loc1_ = _loc6_;
         while(_loc1_ < _loc2_)
         {
            this.FPositionItems[_loc1_].Render(null);
            _loc1_++;
         }
      }
      
      protected function UpdateScroll() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TRelatedPartnerHero = null;
         var _loc4_:THero = null;
         var _loc5_:int = 0;
         _loc2_ = this.FRelatedHeros.Count;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc4_ = this.FRelatedHeros.GetHeroByIndex(_loc1_);
            if(!_loc4_.IsMain && _loc4_.Mounted)
            {
               _loc3_ = this.FHeroDatas.GetHeroDataByIdentifier(_loc4_.Identifier);
               this.FPositionItems[_loc5_].Render(_loc3_);
               _loc5_++;
            }
            _loc1_++;
         }
      }
      
      protected function AssistanceOnItemOver(param1:Object, param2:THero) : void
      {
         this.OnItemOver(param1,param2);
      }
      
      protected function AssistanceOnItemOut(param1:Object) : void
      {
         this.OnItemOut(param1);
      }
      
      protected function BtnOnClose(param1:Object, param2:MouseEvent) : void
      {
         ProcessorWindowClose();
      }
      
      protected function ExchangeOnClick(param1:Object, param2:MouseEvent) : void
      {
         SUtilityHyperLink.ShortcutHyperlink(TUtilityHyperLink.HyperLink_TacticalDeployment);
         TUtilityLobby.SetReturnWindows(TProcessorTacticalDeployment,TUtilityHyperLink.HyperLink_RelatedPartner);
      }
      
      protected function HeadOnOver(param1:Object, param2:int) : void
      {
         this.FAssistanceTip.x = this.mouseX;
         this.FAssistanceTip.y = this.mouseY;
         this.FAssistanceTip.Show(param2);
      }
      
      protected function HeadOnOut(param1:Object) : void
      {
         this.FAssistanceTip.Hide();
      }
      
      protected function HeroOnOver(param1:Object, param2:int) : void
      {
         var _loc3_:TBaseHero = null;
         if(param2 == 0)
         {
            return;
         }
         _loc3_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_BaseHero,param2) as TBaseHero;
         this.FHint.Caption = _loc3_.Name;
         SUtilityOverLayer.UIComponentsHintOnOver(FUICore,this.FHint);
      }
      
      protected function HeroOnOut(param1:Object) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOut(FUICore,this.FHint);
      }
      
      public function get OnAssistanceList() : Function
      {
         return this.FOnAssistanceList;
      }
      
      public function set OnAssistanceList(param1:Function) : void
      {
         this.FOnAssistanceList = param1;
      }
      
      public function get OnItemOver() : Function
      {
         return this.FOnItemOver;
      }
      
      public function set OnItemOver(param1:Function) : void
      {
         this.FOnItemOver = param1;
      }
      
      public function get OnItemOut() : Function
      {
         return this.FOnItemOut;
      }
      
      public function set OnItemOut(param1:Function) : void
      {
         this.FOnItemOut = param1;
      }
      
      public function Render(param1:TRelatedPartnerHeros) : void
      {
         this.FHeroDatas = param1;
         this.FHeros = SLogicsCore.Character.Heros;
         this.RenderUI();
      }
      
      public function Update(param1:int, param2:int) : void
      {
         this.FHeros = SLogicsCore.Character.Heros;
         this.FAssistanceItems[param2 - 1].Hero = this.FHeros.GetHeroByIdentifier(param1);
         this.FAssistanceItems[param2 - 1].Render();
         this.UpdateScroll();
      }
   }
}

