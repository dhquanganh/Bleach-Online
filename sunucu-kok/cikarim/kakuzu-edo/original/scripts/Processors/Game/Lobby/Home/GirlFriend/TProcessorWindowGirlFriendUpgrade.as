package Processors.Game.Lobby.Home.GirlFriend
{
   import Components.Slots.*;
   import Components.Standard.*;
   import Foundation.Network.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Textures.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.Home.*;
   import Logics.Home.GirlFriend.*;
   import Logics.Inventories.*;
   import Logics.Streamization.Home.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Jade.*;
   import Processors.Game.Lobby.Utilities.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class TProcessorWindowGirlFriendUpgrade extends TProcessorLobbyWindow
   {
      
      public static const WINDOW_WIDTH:int = 556;
      
      public static const WINDOW_HEIGHT:int = 384;
      
      public static const FrameIndex_Current:int = 1;
      
      public static const FrameIndex_Next:int = 2;
      
      public static const FrameIndex_NoNext:int = 3;
      
      protected var FGirlFriend:TGirlFriend;
      
      protected var FHome:THome;
      
      protected var FMainUI:MovieClip;
      
      protected var FTF_CurrentGirlLevel:TextField;
      
      protected var FMC_CurrentGirlPic:MovieClip;
      
      protected var FBitMapCurrentGirlPic:Bitmap;
      
      protected var FTF_CurrentGirlDesc:TextField;
      
      protected var FTF_NextGirlLevel:TextField;
      
      protected var FMC_NextGirlPic:MovieClip;
      
      protected var FBitMapNextGirlPic:Bitmap;
      
      protected var FTF_NextGirlDesc:TextField;
      
      protected var FGirlFlag:MovieClip;
      
      protected var FTF_HomeName:TextField;
      
      protected var FMC_UpgradeHomeName:MovieClip;
      
      protected var FTF_UpgradeHomeName:TextField;
      
      protected var FSlot:TUISlot;
      
      protected var FTF_UpgradeNum:TextField;
      
      protected var FBtn_Upgrade:TUIButton;
      
      protected var FNextGirlFriend:TGirlFriend;
      
      protected var FUnstreamizerGirlFriend:TUnstreamizerGirlFriend;
      
      protected var FBtn_Close:SimpleButton;
      
      protected var FHaveNextGirlFriend:Boolean;
      
      protected var FApplianceOnOver:Function;
      
      protected var FApplianceOnOut:Function;
      
      public function TProcessorWindowGirlFriendUpgrade(param1:TUIComponent)
      {
         super(param1);
         this.FHome = SLogicsCore.Home;
         this.FGirlFriend = this.FHome.GirlFriend;
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(this.Visible)
         {
            this.FSlot.Update();
         }
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         this.FMainUI = TUtilityReflection.CreateDisplayObjectInstance("UIUpgrade") as MovieClip;
         addChild(this.FMainUI);
         this.CurrentGirlUIDispatch();
         this.NextGirlUIDispatch();
         this.UpgradeStuffUIDispatch();
         TutorialSendComponent(CONST_FRESHGUIDE.MCID_GirlFreindUpgradeView,this);
         TutorialSendArrowParent(CONST_FRESHGUIDE.MCID_GirlFreindUpgradeView,FParent);
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         this.CurrentGirlUILocation();
         this.NextGirlUILocation();
         this.UpgradeStuffUILocation();
         super.ResourcesPerform_UILocations();
      }
      
      protected function CurrentGirlUIDispatch() : void
      {
         this.FMC_CurrentGirlPic = this.FMainUI["CurrentGirlPic"];
         this.FTF_CurrentGirlLevel = this.FMC_CurrentGirlPic["Girlevel"];
         this.FTF_CurrentGirlDesc = this.FMainUI["CurrentDesc"];
         this.FBitMapCurrentGirlPic = new Bitmap();
         this.FMC_CurrentGirlPic["MC_Image"].addChild(this.FBitMapCurrentGirlPic);
      }
      
      protected function CurrentGirlUILocation() : void
      {
      }
      
      protected function NextGirlUIDispatch() : void
      {
         this.FMC_NextGirlPic = this.FMainUI["NextGirlPic"];
         this.FTF_NextGirlLevel = this.FMC_NextGirlPic["Girlevel"];
         this.FTF_NextGirlDesc = this.FMainUI["NextDesc"];
         this.FBitMapNextGirlPic = new Bitmap();
         this.FMC_NextGirlPic["MC_Image"].addChild(this.FBitMapNextGirlPic);
         this.FGirlFlag = this.FMainUI["GirlFlag"];
      }
      
      protected function NextGirlUILocation() : void
      {
      }
      
      protected function UpgradeStuffUIDispatch() : void
      {
         this.FTF_HomeName = this.FMainUI["CurrentHomeName"];
         this.FTF_HomeName.textColor = CONST_COMMON.QUALITYCOLOR_INDEX[this.FHome.Quality];
         this.FMC_UpgradeHomeName = this.FMainUI["UpgradeNeed"];
         this.FTF_UpgradeHomeName = this.FMC_UpgradeHomeName["Lable"];
         this.FSlot = new TUISlot(this);
         this.FSlot.Resource = this.FMainUI["UpgradeArtical"];
         TJadeCommon.InitSlot(this.FSlot);
         this.FSlot.Init();
         this.FSlot.OnOver = this.SlotOnOver;
         this.FSlot.OnOut = this.SlotOnOut;
         this.FTF_UpgradeNum = this.FMainUI["TFNeedNum"];
         this.FBtn_Upgrade = new TUIButton();
         this.FBtn_Upgrade.Substrate = this.FMainUI["BtnUpgrade"];
         this.FBtn_Close = this.FMainUI["BTN_Close"];
         this.FNextGirlFriend = new TGirlFriend();
         this.FUnstreamizerGirlFriend = new TUnstreamizerGirlFriend();
      }
      
      protected function UpgradeStuffUILocation() : void
      {
         this.FBtn_Upgrade.OnClick = this.BtnUpgradeClicked;
         this.FBtn_Close.addEventListener(MouseEvent.CLICK,this.OnBtnCloseClick);
      }
      
      protected function Upgrade_Peform() : void
      {
         this.UpgradeCurrentGirlInfor();
         this.UpgradeNextGirlInfor();
         this.UpgradeStuffInfor();
      }
      
      protected function ResourceSendInterface(param1:Object, param2:TTexture, param3:uint) : void
      {
         if(param3 == this.FGirlFriend.ImageID)
         {
            this.FBitMapCurrentGirlPic.bitmapData = param2.GetAnimationSequenceByIndex(0).GetAnimationFrameByIndex(0).Surface;
         }
         else if(this.FNextGirlFriend != null && param3 == this.FNextGirlFriend.ImageID)
         {
            this.FBitMapNextGirlPic.bitmapData = param2.GetAnimationSequenceByIndex(0).GetAnimationFrameByIndex(0).Surface;
         }
      }
      
      protected function UpgradeCurrentGirlInfor() : void
      {
         this.FMC_CurrentGirlPic.gotoAndStop(1);
         this.FTF_CurrentGirlLevel.text = this.FGirlFriend.Name;
         this.FTF_CurrentGirlDesc.htmlText = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.GirlFriend_STRING_0),this.FGirlFriend.CanCommunicateTime.toString(),this.FGirlFriend.CanMakeTofuTime.toString(),this.FGirlFriend.MakeTofuAwardNum);
         this.FBitMapCurrentGirlPic.bitmapData = null;
         SResourcesCore.TexturesMiddlePic.LoadAutoSecondary(this.FGirlFriend.ImageID,this.ResourceSendInterface);
      }
      
      protected function UpgradeNextGirlInfor() : void
      {
         var _loc1_:THomeGirlFriend = null;
         this.FNextGirlFriend.ID = this.FGirlFriend.ID + 1;
         _loc1_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_HomeGirlFriend,this.FNextGirlFriend.ID) as THomeGirlFriend;
         if(_loc1_ == null)
         {
            this.FMC_NextGirlPic.visible = false;
            this.FTF_NextGirlLevel.text = "";
            this.FTF_NextGirlDesc.text = "";
            this.FMC_UpgradeHomeName.visible = false;
            this.FGirlFlag.gotoAndStop(FrameIndex_NoNext);
            this.FHaveNextGirlFriend = false;
         }
         else
         {
            this.FUnstreamizerGirlFriend.Unstreamization_GirlFriendByDatabase(this.FNextGirlFriend,null);
            this.FMC_NextGirlPic.visible = true;
            this.FMC_NextGirlPic.gotoAndStop(1);
            this.FTF_NextGirlLevel.text = this.FNextGirlFriend.Name;
            this.FTF_NextGirlDesc.htmlText = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.GirlFriend_STRING_0),this.FNextGirlFriend.CanCommunicateTime.toString(),this.FNextGirlFriend.CanMakeTofuTime.toString(),this.FGirlFriend.MakeTofuAwardNum);
            this.FBitMapNextGirlPic.bitmapData = null;
            SResourcesCore.TexturesMiddlePic.LoadAutoSecondary(this.FNextGirlFriend.ImageID,this.ResourceSendInterface);
            this.FGirlFlag.gotoAndStop(FrameIndex_Next);
            this.FHaveNextGirlFriend = true;
         }
      }
      
      protected function UpgradeStuffInfor() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Boolean = false;
         this.FTF_UpgradeHomeName.text = "";
         this.FSlot.Context = null;
         this.FTF_UpgradeNum.text = "";
         if(this.FHaveNextGirlFriend)
         {
            if(this.FGirlFriend.HomeLevelLimit > this.FHome.Level)
            {
               this.FTF_UpgradeHomeName.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.GirlFriend_STRING_3),this.FGirlFriend.HomeLevelLimitName);
               this.FMC_UpgradeHomeName.visible = true;
               _loc4_ = false;
            }
            else
            {
               this.FMC_UpgradeHomeName.visible = false;
               _loc4_ = true;
            }
            this.FSlot.Context = this.FGirlFriend.UpgradeInventories.GetInventoryByIndex(0);
            _loc3_ = int(SLogicsCore.Character.Appliances.GetCountByTempleteID(this.FGirlFriend.UpgradeArticalID));
            this.FTF_UpgradeNum.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.GirlFriend_STRING_1),_loc3_.toString(),this.FGirlFriend.UpgradeInventoryNum.toString());
            if(_loc3_ < this.FGirlFriend.UpgradeInventoryNum)
            {
               this.FTF_UpgradeNum.textColor = CONST_COMMON.TEXT_Red_Color;
               _loc4_ = false;
            }
            else
            {
               this.FTF_UpgradeNum.textColor = CONST_COMMON.TEXT_Green_Color;
            }
            this.FBtn_Upgrade.Enabled = _loc4_;
         }
         this.FTF_HomeName.text = this.FHome.Name;
      }
      
      protected function BtnUpgradeClicked(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TPacket = null;
         _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Home_GirlFriendUpgradeReq);
         SNetworkCore.Transceiver.PacketTransmit(_loc3_);
         TutorialNextStep(CONST_FRESHGUIDE.EVENTID_ClickGirlUpgradeBtn);
      }
      
      protected function OnBtnCloseClick(param1:MouseEvent) : void
      {
         ProcessorWindowClose();
         TutorialNextStep(CONST_FRESHGUIDE.EVENTID_ClickGirlUpgradeViewCloseBtn);
      }
      
      protected function SlotOnOver(param1:Object, param2:Object) : void
      {
         if(this.FApplianceOnOver != null)
         {
            this.FApplianceOnOver(this,param2 as TInventory);
         }
      }
      
      protected function SlotOnOut(param1:Object, param2:Object) : void
      {
         if(this.FApplianceOnOut != null)
         {
            this.FApplianceOnOut(this,param2 as TInventory);
         }
      }
      
      public function set ApplianceOnOver(param1:Function) : void
      {
         this.FApplianceOnOver = param1;
      }
      
      public function set ApplianceOnOut(param1:Function) : void
      {
         this.FApplianceOnOut = param1;
      }
      
      public function Update() : void
      {
         this.Upgrade_Peform();
      }
      
      public function Reset() : void
      {
         if(this.FBitMapCurrentGirlPic != null)
         {
            this.FBitMapCurrentGirlPic.bitmapData = null;
            this.FBitMapNextGirlPic.bitmapData = null;
         }
      }
   }
}

