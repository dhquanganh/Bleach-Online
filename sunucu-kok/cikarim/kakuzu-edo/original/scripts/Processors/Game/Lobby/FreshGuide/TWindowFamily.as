package Processors.Game.Lobby.FreshGuide
{
   import Components.Standard.TUIButton;
   import Foundation.Network.SNetworkCore;
   import Foundation.Network.TPacket;
   import Foundation.Resources.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.DatebaseVO.VO.TConfigValue;
   import Logics.Inventories.TInventories;
   import Logics.Streamization.Inventories.TUnstreamizerInventoryReference;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Processors.Game.Windows.Information.TUIWindowConfirmation;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   
   public class TWindowFamily extends TProcessorLobbyWindow
   {
      
      protected var FBtn_Joins:Vector.<TUIButton>;
      
      protected var FBtnEffect:Vector.<MovieClip>;
      
      protected var FRecommandFlag:Vector.<Sprite>;
      
      protected var FRecommandAwardBox:Vector.<MovieClip>;
      
      protected var FPromotWindow:TUIWindowConfirmation;
      
      protected var FSelectFamilyID:int;
      
      protected var FResourceComplete:Boolean;
      
      protected var FRecommandFamily:int;
      
      protected var FAwardInventories:TInventories;
      
      protected var FUnstreamizerInventoryReference:TUnstreamizerInventoryReference;
      
      protected var FOnClickBtn:Function;
      
      public function TWindowFamily(param1:TUIComponent)
      {
         super(param1);
         this.FRecommandFamily = 0;
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_FRESHGUIDE.RESOURCESID_FreshGuide_Family);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:Sprite = null;
         var _loc2_:int = 0;
         var _loc3_:TUIButton = null;
         var _loc4_:MovieClip = null;
         _loc1_ = TUtilityReflection.CreateDisplayObjectInstance("Family") as MovieClip;
         this.addChild(_loc1_);
         this.FBtn_Joins = new Vector.<TUIButton>();
         this.FBtnEffect = new Vector.<MovieClip>();
         this.FRecommandFlag = new Vector.<Sprite>();
         this.FRecommandAwardBox = new Vector.<MovieClip>();
         _loc2_ = 0;
         while(_loc2_ < 3)
         {
            _loc4_ = _loc1_["BTN_Join" + (_loc2_ + 1)];
            _loc3_ = new TUIButton();
            _loc3_.Substrate = _loc4_;
            _loc3_.OnClick = this.OnMouseClick;
            _loc3_.OnOver = this.OnMouseOver;
            _loc3_.OnOut = this.OnMouseOut;
            this.FBtn_Joins.push(_loc3_);
            _loc4_ = _loc1_["Effect" + (_loc2_ + 1)];
            _loc4_.visible = false;
            this.FBtnEffect.push(_loc4_);
            _loc4_ = _loc1_["Recommand" + (_loc2_ + 1)];
            _loc4_.visible = false;
            this.FRecommandFlag.push(_loc4_);
            _loc4_ = _loc4_["AwardBox"];
            _loc4_.addEventListener(MouseEvent.MOUSE_MOVE,this.AwardBoxOnMouseMove);
            _loc4_.addEventListener(MouseEvent.MOUSE_OVER,this.AwardBoxOnMouseOver);
            _loc4_.addEventListener(MouseEvent.MOUSE_OUT,this.AwardBoxOnMouseOut);
            this.FRecommandAwardBox.push(_loc4_);
            _loc2_++;
         }
         if(this.FRecommandFamily != 0)
         {
            this.FRecommandFlag[this.FRecommandFamily - 1].visible = true;
         }
         this.ConstructAwardInventory();
         this.FPromotWindow = SUtilityOverLayer.UIWindowConfirmation;
         TutorialSendComponent(CONST_FRESHGUIDE.MCID_FamilyView,this);
         TutorialSendArrowParent(CONST_FRESHGUIDE.MCID_FamilyView,FParent);
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         this.x = (CONST_COMMON.STAGE_Width - this.width) / 2;
         this.y = (CONST_COMMON.STAGE_Height - this.height) / 2;
         this.FResourceComplete = true;
         super.ResourcesPerform_UILocations();
      }
      
      protected function ConstructAwardInventory() : void
      {
         var _loc1_:Vector.<uint> = null;
         var _loc2_:int = 0;
         var _loc3_:TConfigValue = null;
         this.FUnstreamizerInventoryReference = new TUnstreamizerInventoryReference();
         _loc3_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_FRESHGUIDE.ConfigValueID_FamilyAward) as TConfigValue;
         _loc2_ = _loc3_.Value as int;
         _loc1_ = new Vector.<uint>();
         _loc1_.push(_loc2_);
         this.FAwardInventories = new TInventories();
         this.FUnstreamizerInventoryReference.UnstreamizeGenerateInventoriesByIdentifiers(null,this.FAwardInventories,_loc1_);
      }
      
      private function OnMouseOver(param1:Object, param2:Event) : void
      {
         var _loc3_:int = 0;
         _loc3_ = this.FBtn_Joins.indexOf(param1 as TUIButton);
         this.FBtnEffect[_loc3_].gotoAndPlay(0);
         this.FBtnEffect[_loc3_].visible = true;
      }
      
      private function OnMouseOut(param1:Object, param2:Event) : void
      {
         var _loc3_:int = 0;
         _loc3_ = this.FBtn_Joins.indexOf(param1 as TUIButton);
         this.FBtnEffect[_loc3_].visible = false;
      }
      
      private function OnMouseClick(param1:Object, param2:Event) : void
      {
         var _loc3_:int = 0;
         _loc3_ = this.FBtn_Joins.indexOf(param1 as TUIButton);
         this.FSelectFamilyID = _loc3_ + 1;
         this.FPromotWindow.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.FreshGuide_STRING_0),TUtilityLobby.GetFamilyNameByIndex(this.FSelectFamilyID));
         this.FPromotWindow.OnOK = this.PromotWindowOk;
         this.FPromotWindow.Visible = true;
      }
      
      protected function PromotWindowOk(param1:Object) : void
      {
         var _loc2_:TPacket = null;
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_FreshGuide_FamilyReq);
         _loc2_.Data.writeByte(this.FSelectFamilyID);
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
         visible = false;
         TutorialNextStep(CONST_FRESHGUIDE.EVENTID_SelectFamily);
         if(this.FOnClickBtn != null)
         {
            this.FOnClickBtn(this);
         }
      }
      
      protected function AwardBoxOnMouseMove(param1:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOver(this,this.FAwardInventories.GetInventoryByIndex(0));
      }
      
      protected function AwardBoxOnMouseOut(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:MovieClip = null;
         _loc3_ = param1.currentTarget as MovieClip;
         _loc2_ = this.FRecommandAwardBox.indexOf(_loc3_);
         _loc3_.gotoAndStop(1);
         SUtilityOverLayer.UIComponentsHintOnOut(this,this.FAwardInventories.GetInventoryByIndex(0));
      }
      
      protected function AwardBoxOnMouseOver(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:MovieClip = null;
         _loc3_ = param1.currentTarget as MovieClip;
         _loc2_ = this.FRecommandAwardBox.indexOf(_loc3_);
         _loc3_.gotoAndStop(2);
      }
      
      public function set OnClickBtn(param1:Function) : void
      {
         this.FOnClickBtn = param1;
      }
      
      public function UpdateFamily() : void
      {
         var _loc1_:String = null;
         _loc1_ = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.FreshGuide_STRING_1),TUtilityLobby.GetFamilyNameByIndex(this.FSelectFamilyID));
         EffectGenerateText(_loc1_);
      }
      
      public function SetRecommandFaimly(param1:int) : void
      {
         this.FRecommandFamily = param1;
         if(this.FResourceComplete)
         {
            this.FRecommandFlag[this.FRecommandFamily - 1].visible = true;
         }
      }
   }
}

