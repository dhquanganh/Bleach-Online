package Processors.Game.Lobby.Welcome
{
   import Components.Standard.TUIButton;
   import Foundation.Network.SNetworkCore;
   import Foundation.Network.TPacket;
   import Foundation.Resources.SResourcesCore;
   import Foundation.Resources.Textures.TTexture;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Resources.Constants.CONST_FRESHGUIDE;
   import Resources.Constants.CONST_NETWORK;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.utils.ByteArray;
   
   public class TWindowNip extends TProcessorLobbyWindow
   {
      
      protected static const FIDPrefix:int = 0;
      
      protected static const InitGirlID:uint = FIDPrefix + 102030;
      
      protected static const SelectBoxNum:int = 3;
      
      protected var FComponentNipGirl:TComponentNipGirl;
      
      protected var FPicMountPoint:Bitmap;
      
      protected var FMainUI:Sprite;
      
      protected var FBtnChangeClothes:TUIButton;
      
      protected var FClothesSelectButton:Vector.<TUIButton>;
      
      protected var FClothesUnselectButton:Vector.<TUIButton>;
      
      protected var FClotehsOrganNames:Vector.<TextField>;
      
      protected var FHairSelectButton:Vector.<TUIButton>;
      
      protected var FHairUnselectButton:Vector.<TUIButton>;
      
      protected var FHairOrganNames:Vector.<TextField>;
      
      protected var FEyesSelectButton:Vector.<TUIButton>;
      
      protected var FEyesUnselectButton:Vector.<TUIButton>;
      
      protected var FEyesOrganNames:Vector.<TextField>;
      
      protected var FOrgansID:Vector.<uint>;
      
      protected var FTextureID:uint;
      
      public function TWindowNip(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         this.FMainUI = TUtilityReflection.CreateDisplayObjectInstance("UINip") as Sprite;
         addChild(this.FMainUI);
         this.FComponentNipGirl = new TComponentNipGirl(this);
         this.FPicMountPoint = new Bitmap();
         this.FMainUI["PicMountPoint"].addChild(this.FPicMountPoint);
         this.FBtnChangeClothes = new TUIButton();
         this.FBtnChangeClothes.Substrate = this.FMainUI["Btn_Ensure"];
         this.FBtnChangeClothes.OnClick = this.BtnChangeClothesOnClick;
         this.CreateSelectBox();
         this.FOrgansID = new Vector.<uint>();
         super.ResourcesPerform_UIDispatch();
      }
      
      protected function CreateSelectBox() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Sprite = null;
         var _loc3_:TUIButton = null;
         this.FClothesSelectButton = new Vector.<TUIButton>();
         this.FClothesUnselectButton = new Vector.<TUIButton>();
         this.FClotehsOrganNames = new Vector.<TextField>();
         this.FHairSelectButton = new Vector.<TUIButton>();
         this.FHairUnselectButton = new Vector.<TUIButton>();
         this.FHairOrganNames = new Vector.<TextField>();
         this.FEyesSelectButton = new Vector.<TUIButton>();
         this.FEyesUnselectButton = new Vector.<TUIButton>();
         this.FEyesOrganNames = new Vector.<TextField>();
         _loc1_ = 0;
         while(_loc1_ < SelectBoxNum)
         {
            _loc2_ = this.FMainUI["Clothes" + _loc1_]["SelectBox"];
            _loc3_ = new TUIButton();
            _loc3_.Substrate = _loc2_["Selected"];
            this.FClothesSelectButton.push(_loc3_);
            _loc3_.OnClick = this.ClothesSelectBoxOnClick;
            _loc3_ = new TUIButton();
            _loc3_.Substrate = _loc2_["Unselected"];
            this.FClothesUnselectButton.push(_loc3_);
            _loc3_.OnClick = this.ClothesSelectBoxOnClick;
            this.FClotehsOrganNames.push(this.FMainUI["Clothes" + _loc1_]["OrganName"]);
            _loc2_ = this.FMainUI["Hair" + _loc1_]["SelectBox"];
            _loc3_ = new TUIButton();
            _loc3_.Substrate = _loc2_["Selected"];
            this.FHairSelectButton.push(_loc3_);
            _loc3_.OnClick = this.HairSelectBoxOnClick;
            _loc3_ = new TUIButton();
            _loc3_.Substrate = _loc2_["Unselected"];
            this.FHairUnselectButton.push(_loc3_);
            _loc3_.OnClick = this.HairSelectBoxOnClick;
            this.FHairOrganNames.push(this.FMainUI["Hair" + _loc1_]["OrganName"]);
            _loc2_ = this.FMainUI["Eye" + _loc1_]["SelectBox"];
            _loc3_ = new TUIButton();
            _loc3_.Substrate = _loc2_["Selected"];
            this.FEyesSelectButton.push(_loc3_);
            _loc3_.OnClick = this.EyesSelectBoxOnClick;
            _loc3_ = new TUIButton();
            _loc3_.Substrate = _loc2_["Unselected"];
            this.FEyesUnselectButton.push(_loc3_);
            _loc3_.OnClick = this.EyesSelectBoxOnClick;
            this.FEyesOrganNames.push(this.FMainUI["Eye" + _loc1_]["OrganName"]);
            _loc1_++;
         }
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         var _loc1_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < SelectBoxNum)
         {
            this.FClothesSelectButton[_loc1_];
            _loc1_++;
         }
         this.FlushTextField(this.FClotehsOrganNames,TUtilityLobby.GetStringsByIdentifier(CONST_SYSTEMLANGUAGE.STRING_Nip_01));
         this.FlushTextField(this.FHairOrganNames,TUtilityLobby.GetStringsByIdentifier(CONST_SYSTEMLANGUAGE.STRING_Nip_02));
         this.FlushTextField(this.FEyesOrganNames,TUtilityLobby.GetStringsByIdentifier(CONST_SYSTEMLANGUAGE.STRING_Nip_03));
         super.ResourcesPerform_UILocations();
      }
      
      protected function FlushTextField(param1:Vector.<TextField>, param2:Vector.<String>) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _loc4_ = int(param2.length);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            param1[_loc3_].text = param2[_loc3_];
            _loc3_++;
         }
      }
      
      protected function ClothesSelectBoxOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TUIButton = null;
         var _loc4_:int = 0;
         _loc3_ = param1 as TUIButton;
         if(_loc3_ == this.FClothesSelectButton[this.FOrgansID[0]])
         {
            return;
         }
         _loc4_ = this.FClothesUnselectButton.indexOf(_loc3_);
         this.FOrgansID.splice(0,1,_loc4_);
         this.SetOneGroupSelectedBox(_loc4_,this.FClothesSelectButton);
         this.FTextureID = this.CombineOrganIDToTexureID(this.FOrgansID);
         this.SetupPicID(this.FTextureID);
      }
      
      protected function HairSelectBoxOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TUIButton = null;
         var _loc4_:int = 0;
         _loc3_ = param1 as TUIButton;
         if(_loc3_ == this.FHairSelectButton[this.FOrgansID[1]])
         {
            return;
         }
         _loc4_ = this.FHairUnselectButton.indexOf(_loc3_);
         this.FOrgansID.splice(1,1,_loc4_);
         this.SetOneGroupSelectedBox(_loc4_,this.FHairSelectButton);
         this.FTextureID = this.CombineOrganIDToTexureID(this.FOrgansID);
         this.SetupPicID(this.FTextureID);
      }
      
      protected function EyesSelectBoxOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TUIButton = null;
         var _loc4_:int = 0;
         _loc3_ = param1 as TUIButton;
         if(_loc3_ == this.FEyesSelectButton[this.FOrgansID[2]])
         {
            return;
         }
         _loc4_ = this.FEyesUnselectButton.indexOf(_loc3_);
         this.FOrgansID.splice(2,1,_loc4_);
         this.SetOneGroupSelectedBox(_loc4_,this.FEyesSelectButton);
         this.FTextureID = this.CombineOrganIDToTexureID(this.FOrgansID);
         this.SetupPicID(this.FTextureID);
      }
      
      protected function SetupPicID(param1:uint) : void
      {
         SResourcesCore.TexturesMiddlePic.LoadAutoSecondary(param1,this.CallBack_PicArrive);
      }
      
      protected function CallBack_PicArrive(param1:Object, param2:TTexture, param3:uint) : void
      {
         if(this.FTextureID == param3)
         {
            this.FPicMountPoint.bitmapData = param2.GetAnimationSequenceByIndex(0).GetAnimationFrameByIndex(0).Surface;
         }
      }
      
      protected function SetSelectedBoxState(param1:Vector.<uint>) : void
      {
         this.SetOneGroupSelectedBox(param1[0],this.FClothesSelectButton);
         this.SetOneGroupSelectedBox(param1[1],this.FHairSelectButton);
         this.SetOneGroupSelectedBox(param1[2],this.FEyesSelectButton);
      }
      
      protected function SetOneGroupSelectedBox(param1:uint, param2:Vector.<TUIButton>) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _loc4_ = int(param2.length);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            param2[_loc3_].Visible = false;
            _loc3_++;
         }
         param2[param1].Visible = true;
      }
      
      protected function SeparateTextureIDToOrganID(param1:uint, param2:Vector.<uint>) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         this.FOrgansID.length = 0;
         _loc5_ = 1000000;
         while(_loc5_ != 1)
         {
            _loc4_ = param1 % _loc5_;
            _loc5_ /= 100;
            _loc3_ = param1 / _loc5_;
            this.FOrgansID.push(_loc3_ % 10);
            param1 = uint(_loc4_);
         }
      }
      
      protected function CombineOrganIDToTexureID(param1:Vector.<uint>) : uint
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         _loc4_ = uint(FIDPrefix);
         _loc5_ = 10000;
         _loc3_ = int(param1.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ += ((_loc2_ + 1) * 10 + param1[_loc2_]) * _loc5_;
            _loc5_ /= 100;
            _loc2_++;
         }
         return _loc4_;
      }
      
      protected function BtnChangeClothesOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TPacket = null;
         var _loc4_:ByteArray = null;
         var _loc5_:uint = 0;
         TutorialNextStep(CONST_FRESHGUIDE.EVENTID_ClickChangeClothesBtn);
         _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Welcome_NipReq);
         _loc4_ = _loc3_.Data;
         _loc5_ = this.CombineOrganIDToTexureID(this.FOrgansID);
         _loc4_.writeUnsignedInt(_loc5_);
         SNetworkCore.Transceiver.PacketTransmit(_loc3_);
      }
      
      public function InitNipGirl() : void
      {
         this.FTextureID = InitGirlID;
         this.SetupPicID(this.FTextureID);
         this.SeparateTextureIDToOrganID(InitGirlID,this.FOrgansID);
         this.SetSelectedBoxState(this.FOrgansID);
      }
   }
}

