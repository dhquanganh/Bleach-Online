package Processors.Game.Lobby.RelatedPartner.Component
{
   import Components.Standard.TUIButton;
   import Foundation.Network.SNetworkCore;
   import Foundation.Network.TPacket;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Logics.DatebaseVO.VO.TArticle;
   import Logics.DatebaseVO.VO.TRelatedPartnerType;
   import Logics.RelatedPartner.TRelatedPartnerHeroSkill;
   import Logics.SLogicsCore;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import Processors.Game.Lobby.RelatedPartner.TRelatedPartnerCommon;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.Common.SUtilityResource;
   import Resources.Constants.CONST_COMMON;
   import Resources.Constants.CONST_DATEBASEVO;
   import Resources.Constants.CONST_NETWORK;
   import Resources.Constants.CONST_RELATEDPARTNER;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.text.TextField;
   import flash.utils.ByteArray;
   
   public class TRelatedPropertyTip extends TProcessorLobbyWindow
   {
      
      protected var FMainUI:Sprite;
      
      protected var FIsInit:Boolean;
      
      protected var FChipCount:int;
      
      protected var FBmp:Bitmap;
      
      protected var FTFName:TextField;
      
      protected var FTFLevelup:TextField;
      
      protected var FTFCurProp:TextField;
      
      protected var FTFNextProp:TextField;
      
      protected var FTFConsume:TextField;
      
      protected var FBtnUpgrade:TUIButton;
      
      protected var FHeroSkill:TRelatedPartnerHeroSkill;
      
      protected var FCurSkillId:int;
      
      protected var FBtnClose:TUIButton;
      
      public function TRelatedPropertyTip(param1:TUIComponent)
      {
         super(param1);
      }
      
      protected function InitView() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Point = null;
         this.FMainUI = TUtilityReflection.CreateDisplayObjectInstance(CONST_RELATEDPARTNER.ResourceID_PropertyTip) as Sprite;
         addChild(this.FMainUI);
         this.FBmp = new Bitmap();
         this.FBmp.bitmapData = SUtilityResource.BtmDataFullScreen;
         this.FBtnClose = new TUIButton();
         this.FBtnClose.Substrate = this.FMainUI["Btn_Close"];
         this.FBtnClose.OnClick = this.OnBtnClose;
         _loc2_ = this.localToGlobal(new Point());
         this.FBmp.x = -_loc2_.x;
         this.FBmp.y = -_loc2_.y;
         this.FMainUI.addChildAt(this.FBmp,0);
         this.FTFName = this.FMainUI["TF_Name"];
         this.FTFLevelup = this.FMainUI["TF_Level"];
         this.FTFCurProp = this.FMainUI["TF_CurProp"];
         this.FTFNextProp = this.FMainUI["TF_NextProp"];
         this.FTFConsume = this.FMainUI["TF_Consume"];
         this.FBtnUpgrade = new TUIButton();
         this.FBtnUpgrade.Substrate = this.FMainUI["Btn_Upgrade"];
      }
      
      protected function OnBtnClose(param1:Object, param2:MouseEvent) : void
      {
         this.Visible = false;
         this.FMainUI.removeEventListener(MouseEvent.CLICK,this.OnStageClick);
      }
      
      protected function OnStageClick(param1:MouseEvent) : void
      {
         var _loc2_:Sprite = null;
         var _loc3_:TPacket = null;
         var _loc4_:ByteArray = null;
         if(param1.target == this.FBtnUpgrade.Substrate)
         {
            _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Related_LevelupReq);
            _loc4_ = _loc3_.Data;
            _loc4_.writeUnsignedInt(this.FHeroSkill.Partner.HeroId);
            _loc4_.writeUnsignedInt(this.FCurSkillId);
            SNetworkCore.Transceiver.PacketTransmit(_loc3_);
            return;
         }
         this.Visible = false;
         this.FMainUI.removeEventListener(MouseEvent.CLICK,this.OnStageClick);
      }
      
      public function Show() : void
      {
         if(!this.FIsInit)
         {
            this.InitView();
            this.FIsInit = true;
         }
         if(!this.FMainUI.hasEventListener(MouseEvent.CLICK))
         {
            this.FMainUI.addEventListener(MouseEvent.CLICK,this.OnStageClick);
         }
         this.Visible = true;
      }
      
      public function Render(param1:TRelatedPartnerHeroSkill) : void
      {
         var _loc2_:int = 0;
         var _loc3_:String = null;
         var _loc4_:TRelatedPartnerType = null;
         var _loc5_:TArticle = null;
         var _loc6_:String = null;
         this.FHeroSkill = param1;
         this.FChipCount = SLogicsCore.Character.Appliances.GetCountByTempleteID(TRelatedPartnerCommon.ChipId);
         _loc5_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_Article,TRelatedPartnerCommon.ChipId) as TArticle;
         _loc6_ = _loc5_.Name;
         if(this.FHeroSkill.CurSkill == null)
         {
            _loc4_ = this.FHeroSkill.Skills[0];
         }
         else
         {
            _loc4_ = this.FHeroSkill.CurSkill;
         }
         this.FTFName.text = _loc4_.Name;
         _loc2_ = this.FHeroSkill.Skills.indexOf(_loc4_);
         if(_loc2_ < this.FHeroSkill.Skills.length - 1)
         {
            this.FTFLevelup.text = _loc4_.Level + " -> " + this.FHeroSkill.Skills[_loc2_ + 1].Level;
            this.FTFNextProp.text = TRelatedPartnerCommon.GetSkillDesc(this.FHeroSkill.Skills[_loc2_ + 1].Identifier);
            this.FTFConsume.htmlText = _loc6_ + "  " + TUtilityLobby.GetColorStringByCount(this.FChipCount,_loc4_.MaterialCount,this.FChipCount + "/" + _loc4_.MaterialCount);
         }
         else
         {
            _loc3_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.KnifeSoul_STRING_1);
            this.FTFLevelup.text = _loc4_.Level + " -> " + _loc3_;
            this.FTFNextProp.htmlText = "<font color=\'" + CONST_COMMON.HTMLCOLOR_Red + "\'>" + _loc3_ + "</font>";
            this.FTFConsume.htmlText = _loc6_ + "  " + "<font color=\'" + CONST_COMMON.HTMLCOLOR_Green + "\'>0/0</font>";
         }
         this.FTFCurProp.text = TRelatedPartnerCommon.GetSkillDesc(_loc4_.Identifier);
         this.FCurSkillId = _loc4_.Identifier;
      }
   }
}

