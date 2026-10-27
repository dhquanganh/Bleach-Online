package Processors.Game.Lobby.Pet.PetHouse
{
   import Components.ComboBox.*;
   import Components.Standard.*;
   import Foundation.Common.*;
   import Foundation.Network.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Textures.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.Characters.*;
   import Logics.Pet.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Pet.PetHouse.Components.*;
   import Processors.Game.Lobby.Utilities.*;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Processors.Game.Utilities.OverLayer.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class TProcessorWindowPetHouse extends TProcessorLobbyWindow
   {
      
      protected static const RESOURCE_Link_MC_Item:String = CONST_HEROS.RESOURCE_Link_MC_Item;
      
      public static const CAPACITY_BASEATTRIBUTE:int = CONST_PET.CAPACITY_BASEATTRIBUTE;
      
      public static const CAPACITY_PVPATTRIBUTE:int = CONST_PET.CAPACITY_PVPATTRIBUTE;
      
      protected var SIZE_ComboboxHeight:Number = 83;
      
      protected var FPetData:TPetData;
      
      protected var MC_PetHouse:MovieClip;
      
      protected var FMC_PetInfo:MovieClip;
      
      protected var FMC_PetActivate:MovieClip;
      
      protected var FBtn_Close:SimpleButton;
      
      protected var FTF_PetName:TextField;
      
      protected var FTF_FeedPellet:TextField;
      
      protected var FMC_ComboBox:Sprite;
      
      protected var FComboBoxPet:TComboBox;
      
      protected var FItemList:Vector.<DisplayObject>;
      
      protected var FUIMainPetInfoCurrent:TUIMainPetInfo;
      
      protected var FUIMainPetInfoNext:TUIMainPetInfo;
      
      protected var FBtn_FeedOneKey:TUIButton;
      
      protected var FBtn_Feed:TUIButton;
      
      protected var FHint:THint;
      
      protected var FBmpPet:Bitmap;
      
      protected var FPetResourceID:uint;
      
      protected var FUIMainPetActivateBefore:TUIMainPetActivate;
      
      protected var FUIMainPetActivateAfter:TUIMainPetActivate;
      
      protected var FBtn_Activate:TUIButton;
      
      protected var FBtn_ActivateLine:TUIButton;
      
      protected var FBtn_WashPoint:TUIButton;
      
      protected var FTF_ActivateCondition:TextField;
      
      protected var FMC_ActivateEffect:MovieClip;
      
      protected var FBmpPetLeft:Bitmap;
      
      protected var FPetLeftResourceID:uint;
      
      protected var FBmpPetRight:Bitmap;
      
      protected var FPetRightResourceID:uint;
      
      protected var FTF_CurrentLeveL:TextField;
      
      protected var FTF_EXP:TextField;
      
      protected var FExpBar:Sprite;
      
      protected var FTabs:TUITab;
      
      protected var FTabIndex:uint;
      
      protected var FInitialization:Boolean;
      
      protected var FMainPetSelected:TMainPet;
      
      protected var FHintOnOver:Function;
      
      protected var FHintOnOut:Function;
      
      protected var FOnOpenActivateLine:Function;
      
      protected var FOnOpenActivateWashPoint:Function;
      
      public function TProcessorWindowPetHouse(param1:TUIComponent)
      {
         super(param1);
         this.FPetData = SLogicsCore.PetData;
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_PET.RESOURCESID_Swf_PetHouse);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:MovieClip = null;
         var _loc4_:Sprite = null;
         this.MC_PetHouse = TUtilityReflection.CreateDisplayObjectInstance(CONST_PET.RESOURCE_ClassName_MC_PetHouse) as MovieClip;
         addChild(this.MC_PetHouse);
         this.FMC_PetInfo = this.MC_PetHouse[CONST_PET.RESOURCE_Link_MC_PetInfo];
         this.FMC_ComboBox = this.FMC_PetInfo[CONST_PET.RESOURCE_Link_MC_ComboBox];
         this.FItemList = new Vector.<DisplayObject>();
         this.FComboBoxPet = new TComboBox(this,this.FMC_ComboBox,this.FItemList,this.SIZE_ComboboxHeight,this.ComboBoxOnSelect,false);
         this.FMC_PetActivate = this.MC_PetHouse[CONST_PET.RESOURCE_Link_MC_PetActivate];
         this.FMC_PetActivate.visible = false;
         this.FBtn_Close = this.MC_PetHouse["Board"]["Btn_Close"];
         this.FTabs = new TUITab(this);
         _loc2_ = CONST_PET.PETHOUSE_CAPACITY_TABS;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.MC_PetHouse[CONST_COMMON.RESOURCE_Link_MC_Tab + _loc1_];
            this.FTabs.SetTabByIndex(_loc3_,_loc1_);
            _loc1_++;
         }
         this.FTabs.OnSwitch = this.TabOnSwitch;
         this.FTabs.Init();
         _loc4_ = this.FMC_PetInfo[CONST_PET.RESOURCE_Link_SP_MountPoint];
         this.FBmpPet = new Bitmap();
         _loc4_.addChild(this.FBmpPet);
         this.FTF_PetName = this.FMC_PetInfo[CONST_PET.RESOURCE_Link_TF_PetName];
         this.FTF_FeedPellet = this.FMC_PetInfo[CONST_PET.RESOURCE_Link_TF_FeedPellet];
         this.FUIMainPetInfoCurrent = new TUIMainPetInfo();
         this.FUIMainPetInfoCurrent.Resource = this.FMC_PetInfo[CONST_PET.RESOURCE_Link_SP_CurrentAttribute];
         this.FUIMainPetInfoNext = new TUIMainPetInfo();
         this.FUIMainPetInfoNext.Resource = this.FMC_PetInfo[CONST_PET.RESOURCE_Link_SP_NextAttribute];
         _loc4_ = this.FMC_PetInfo["ExpBar"];
         this.FTF_CurrentLeveL = _loc4_["Level"];
         this.FTF_EXP = _loc4_["Exp"];
         this.FExpBar = _loc4_["YellowBar"]["YellowBarMask"];
         this.FBtn_FeedOneKey = new TUIButton();
         this.FBtn_FeedOneKey.Substrate = this.FMC_PetInfo[CONST_PET.RESOURCE_Link_Btn_FeedOneKey];
         this.FBtn_FeedOneKey.OnClick = this.BtnFeedOneKeyOnClick;
         this.FBtn_FeedOneKey.OnMove = this.ButtonOnMove;
         this.FBtn_FeedOneKey.OnOut = this.ButtonOnOut;
         this.FBtn_Feed = new TUIButton();
         this.FBtn_Feed.Substrate = this.FMC_PetInfo[CONST_PET.RESOURCE_Link_Btn_Feed];
         this.FBtn_Feed.OnClick = this.BtnFeedOnClick;
         this.FBtn_Feed.OnMove = this.ButtonOnMove;
         this.FBtn_Feed.OnOut = this.ButtonOnOut;
         this.FHint = new THint();
         this.FBtn_Activate = new TUIButton();
         this.FBtn_Activate.Substrate = this.FMC_PetActivate[CONST_PET.RESOURCE_Link_Btn_Activate];
         this.FBtn_Activate.OnClick = this.Btn_ActivateOnClick;
         this.FBtn_ActivateLine = new TUIButton();
         this.FBtn_ActivateLine.Substrate = this.FMC_PetActivate[CONST_PET.RESOURCE_Link_Btn_ActivateLine];
         this.FBtn_ActivateLine.OnClick = this.Btn_ActivateLineOnClick;
         this.FBtn_WashPoint = new TUIButton();
         this.FBtn_WashPoint.Substrate = this.FMC_PetActivate[CONST_PET.RESOURCE_Link_Btn_WashPoint];
         this.FBtn_WashPoint.OnClick = this.Btn_WashPointOnClick;
         this.FUIMainPetActivateBefore = new TUIMainPetActivate(this);
         this.FUIMainPetActivateBefore.Resource = this.FMC_PetActivate[CONST_PET.RESOURCE_Link_MC_ActivateBefore];
         _loc4_ = this.FUIMainPetActivateBefore.Resource[CONST_PET.RESOURCE_Link_SP_MountPoint];
         this.FBmpPetLeft = new Bitmap();
         _loc4_.addChild(this.FBmpPetLeft);
         this.FUIMainPetActivateAfter = new TUIMainPetActivate(this);
         this.FUIMainPetActivateAfter.Resource = this.FMC_PetActivate[CONST_PET.RESOURCE_Link_MC_ActivateAfter];
         _loc4_ = this.FUIMainPetActivateAfter.Resource[CONST_PET.RESOURCE_Link_SP_MountPoint];
         this.FBmpPetRight = new Bitmap();
         _loc4_.addChild(this.FBmpPetRight);
         this.FTF_ActivateCondition = this.FMC_PetActivate[CONST_PET.RESOURCE_Link_TF_ActivateCondition];
         this.FMC_ActivateEffect = this.FMC_PetActivate[CONST_PET.RESOURCE_Link_MC_ActivateEffect];
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         this.FBtn_Close.addEventListener(MouseEvent.CLICK,this.BtnCloseClick);
         this.FInitialization = true;
         this.Reset();
         super.ResourcesPerform_UILocations();
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(!this.Visible || !this.FInitialization)
         {
            return;
         }
         this.LogicsPerform_ActivateEffect();
      }
      
      protected function LogicsPerform_ActivateEffect() : void
      {
         if(this.FMC_ActivateEffect.currentFrame == this.FMC_ActivateEffect.totalFrames)
         {
            this.Update();
            this.FMC_ActivateEffect.gotoAndStop(1);
            this.FMC_ActivateEffect.visible = false;
         }
      }
      
      protected function ProcessorFeedReq(param1:uint) : void
      {
         var _loc2_:TPacket = null;
         if(this.FMainPetSelected.NextExperience == 0)
         {
            SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_PET_32));
            return;
         }
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Pet_MainPetFeedReq);
         _loc2_.Data.writeUnsignedInt(param1);
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
      }
      
      protected function AutoLoadCallBack(param1:Object, param2:TTexture, param3:uint) : void
      {
         var _loc4_:TAnimationSequence = null;
         switch(param3)
         {
            case this.FPetResourceID:
            case this.FPetLeftResourceID:
               if(this.FTabIndex == 0)
               {
                  _loc4_ = param2.GetAnimationSequenceByIndex(0);
                  this.FBmpPet.bitmapData = _loc4_.GetAnimationFrameByIndex(0).Surface;
               }
               else if(this.FTabIndex == 1)
               {
                  _loc4_ = param2.GetAnimationSequenceByIndex(0);
                  this.FBmpPetLeft.bitmapData = _loc4_.GetAnimationFrameByIndex(0).Surface;
               }
               break;
            case this.FPetRightResourceID:
               _loc4_ = param2.GetAnimationSequenceByIndex(0);
               this.FBmpPetRight.bitmapData = _loc4_.GetAnimationFrameByIndex(0).Surface;
         }
      }
      
      protected function BtnCloseClick(param1:MouseEvent) : void
      {
         ProcessorWindowClose();
         TutorialNextStep(CONST_FRESHGUIDE.EVENTID_ClosePetHouseWindow);
      }
      
      private function Btn_ActivateOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TPacket = null;
         if(this.FPetData.MainPetSelected != null)
         {
            _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Pet_MainPetRankUpReq);
            _loc3_.Data.writeUnsignedInt(this.FPetData.MainPetSelected.Identifier0);
            SNetworkCore.Transceiver.PacketTransmit(_loc3_);
         }
      }
      
      private function Btn_ActivateLineOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FOnOpenActivateLine != null)
         {
            this.FOnOpenActivateLine(this);
            TutorialNextStep(CONST_FRESHGUIDE.EVENTID_PetActiveLineBtn);
         }
      }
      
      private function Btn_WashPointOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FOnOpenActivateWashPoint != null)
         {
            this.FOnOpenActivateWashPoint(this);
         }
      }
      
      protected function TabOnSwitch(param1:Object) : void
      {
         var _loc2_:int = 0;
         _loc2_ = param1 as int;
         this.FMC_PetInfo.visible = false;
         this.FMC_PetActivate.visible = false;
         if(_loc2_ == 0)
         {
            this.FMC_PetInfo.visible = true;
         }
         else if(_loc2_ == 1)
         {
            this.FMC_PetActivate.visible = true;
            TutorialNextStep(CONST_FRESHGUIDE.EVENTID_PetActiveTab);
         }
         this.FTabIndex = _loc2_;
         this.Update();
      }
      
      protected function BtnFeedOneKeyOnClick(param1:Object, param2:MouseEvent) : void
      {
         this.ProcessorFeedReq(50);
      }
      
      protected function BtnFeedOnClick(param1:Object, param2:MouseEvent) : void
      {
         this.ProcessorFeedReq(1);
         TutorialNextStep(CONST_FRESHGUIDE.EVENTID_FeedPet);
      }
      
      protected function ButtonOnMove(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:uint = 0;
         switch(param1)
         {
            case this.FBtn_Feed:
               _loc3_ = CONST_SYSTEMLANGUAGE.STRING_PET_29;
               break;
            case this.FBtn_FeedOneKey:
               _loc3_ = CONST_SYSTEMLANGUAGE.STRING_PET_28;
         }
         this.FHint.Caption = TUtilityLobby.GetStringByIdentifier(_loc3_);
         SUtilityOverLayer.UIComponentsHintOnOver(this,this.FHint);
      }
      
      protected function ButtonOnOut(param1:Object, param2:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOut(this,this.FHint);
      }
      
      protected function ComboBoxOnSelect(param1:Object, param2:uint) : void
      {
         var _loc3_:TPacket = null;
         var _loc4_:TMainPet = null;
         var _loc5_:TMainPet = null;
         _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Pet_MainPetChangeReq);
         _loc4_ = this.FPetData.OwnMainPets.GetPetByIndex(param2) as TMainPet;
         _loc5_ = this.FPetData.OwnMainPets.GetPetByIdentifier(SLogicsCore.Character.GetMainHero().MainPetID,0) as TMainPet;
         if(_loc4_.Identifier0 != _loc5_.Identifier0)
         {
            _loc3_.Data.writeUnsignedInt(_loc4_.Identifier0);
            SNetworkCore.Transceiver.PacketTransmit(_loc3_);
            this.FMainPetSelected = _loc4_;
         }
      }
      
      protected function UpdatePetInfoImage() : void
      {
         var _loc1_:TMainPet = null;
         _loc1_ = this.FPetData.OwnMainPets.GetPetByIdentifier(SLogicsCore.Character.GetMainHero().MainPetID,0) as TMainPet;
         this.FPetResourceID = _loc1_.HeadIconID;
         SResourcesCore.TexturesLargeIcon.LoadAutoSecondary(this.FPetResourceID,this.AutoLoadCallBack);
      }
      
      protected function UpdatePetActivateInfoImage() : void
      {
         var _loc1_:TMainPet = null;
         _loc1_ = this.FPetData.OwnMainPets.GetPetByIdentifier(SLogicsCore.Character.GetMainHero().MainPetID,0) as TMainPet;
         this.FPetLeftResourceID = _loc1_.HeadIconID;
         SResourcesCore.TexturesLargeIcon.LoadAutoSecondary(this.FPetLeftResourceID,this.AutoLoadCallBack);
         _loc1_ = this.FPetData.MainPetSelected;
         if(_loc1_ != null)
         {
            this.FPetRightResourceID = _loc1_.HeadIconID;
            SResourcesCore.TexturesLargeIcon.LoadAutoSecondary(this.FPetRightResourceID,this.AutoLoadCallBack);
         }
      }
      
      public function set HintOnOver(param1:Function) : void
      {
         this.FHintOnOver = param1;
      }
      
      public function get HintOnOver() : Function
      {
         return this.FHintOnOver;
      }
      
      public function set HintOnOut(param1:Function) : void
      {
         this.FHintOnOut = param1;
      }
      
      public function get HintOnOut() : Function
      {
         return this.FHintOnOut;
      }
      
      public function get OnOpenActivateLine() : Function
      {
         return this.FOnOpenActivateLine;
      }
      
      public function set OnOpenActivateLine(param1:Function) : void
      {
         this.FOnOpenActivateLine = param1;
      }
      
      public function get OnOpenActivateWashPoint() : Function
      {
         return this.FOnOpenActivateWashPoint;
      }
      
      public function set OnOpenActivateWashPoint(param1:Function) : void
      {
         this.FOnOpenActivateWashPoint = param1;
      }
      
      public function Reset() : void
      {
         if(!this.FInitialization)
         {
            return;
         }
         this.FPetData.MainPetSelected = null;
         this.FTF_PetName.text = "";
         this.FTF_FeedPellet.text = "";
         this.FItemList.length = 0;
         this.FComboBoxPet.ResetList(this.FItemList);
         this.FTF_EXP.text = "";
         this.FTF_CurrentLeveL.text = "";
         this.FTF_ActivateCondition.text = "";
         this.FUIMainPetActivateAfter.Visible = false;
         this.FMC_ActivateEffect.stop();
         this.FMC_ActivateEffect.visible = false;
         this.FBtn_Activate.Enabled = false;
      }
      
      public function Update() : void
      {
         if(this.FTabIndex == 0)
         {
            this.UpdatePetInfo();
            this.UpdatePetInfoImage();
            this.UpdatePetList();
         }
         else if(this.FTabIndex == 1)
         {
            this.UpdatePetActivateInfo();
            this.UpdatePetActivateInfoImage();
         }
      }
      
      public function UpdatePetInfo() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:THero = null;
         var _loc4_:TMainPet = null;
         _loc3_ = SLogicsCore.Character.GetMainHero();
         _loc4_ = this.FPetData.OwnMainPets.GetPetByIdentifier(_loc3_.MainPetID,0) as TMainPet;
         this.FUIMainPetInfoCurrent.RenderUI(_loc4_.GetBaseAttributeByIndex,_loc4_.GetPvPAttributeByIndex);
         if(_loc4_.PetState == CONST_PET.PetState_HasNextLevel)
         {
            this.FUIMainPetInfoNext.RenderUI(_loc4_.GetNextBaseAttributeByIndex,_loc4_.GetNextPvPAttributeByIndex);
         }
         else
         {
            this.FUIMainPetInfoNext.Reset();
         }
         this.FTF_PetName.text = _loc4_.Name;
         this.FTF_FeedPellet.text = this.FPetData.MainPetItemNum.toString();
         this.FTF_CurrentLeveL.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HEROS_STRING_05),_loc4_.Level);
         this.FTF_EXP.text = TUtilityString.Format(CONST_COMMON.STRING_Capacity,_loc4_.Experience,_loc4_.NextExperience);
         this.FExpBar.scaleX = _loc4_.Experience / _loc4_.NextExperience;
         this.FMainPetSelected = _loc4_;
      }
      
      public function UpdatePetList() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:TMainPet = null;
         var _loc4_:MovieClip = null;
         var _loc5_:THero = null;
         var _loc6_:String = null;
         var _loc7_:int = 0;
         _loc5_ = SLogicsCore.Character.GetMainHero();
         this.FItemList.length = 0;
         _loc2_ = uint(this.FPetData.OwnMainPets.Count);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FPetData.OwnMainPets.GetPetByIndex(_loc1_) as TMainPet;
            _loc4_ = TUtilityReflection.CreateDisplayObjectInstance(RESOURCE_Link_MC_Item) as MovieClip;
            _loc4_.tf_into.text = _loc3_.Name;
            this.FItemList.push(_loc4_);
            if(_loc5_.MainPetID == _loc3_.Identifier0)
            {
               _loc6_ = _loc3_.Name;
               _loc7_ = int(_loc1_);
            }
            _loc1_++;
         }
         this.FComboBoxPet.ResetList(this.FItemList);
         this.FComboBoxPet.SetInfo(_loc6_);
      }
      
      public function UpdatePetActivateInfo() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:THero = null;
         var _loc4_:TMainPet = null;
         var _loc5_:TMainPet = null;
         var _loc6_:TMainPet = null;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:Boolean = false;
         var _loc10_:String = null;
         _loc3_ = SLogicsCore.Character.GetMainHero();
         _loc4_ = this.FPetData.OwnMainPets.GetPetByIdentifier(_loc3_.MainPetID,0) as TMainPet;
         this.FUIMainPetActivateBefore.Context = _loc4_;
         if(this.FPetData.MainPetSelected == null)
         {
            this.FUIMainPetActivateAfter.Visible = false;
            this.FBtn_Activate.Enabled = false;
            return;
         }
         _loc10_ = "";
         _loc6_ = null;
         if(this.FPetData.MainPetSelected != null)
         {
            _loc1_ = this.FPetData.MainPets.GetIndexByPetID(this.FPetData.MainPetSelected.TemplateID);
            _loc6_ = this.FPetData.MainPets.GetPetByIndex(_loc1_) as TMainPet;
         }
         this.FUIMainPetActivateAfter.Context = _loc6_;
         this.FUIMainPetActivateAfter.Visible = true;
         if(this.FPetData.MainPetSelected.PetRankUpCondition == null)
         {
            return;
         }
         _loc2_ = int(this.FPetData.MainPetSelected.PetRankUpCondition.PetIds.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc4_ = this.FPetData.MainPets.GetPetByIdentifier(this.FPetData.MainPetSelected.PetRankUpCondition.PetIds[_loc1_],0) as TMainPet;
            _loc10_ += _loc4_.Name;
            _loc10_ = _loc10_ + (TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_PET_16) + this.FPetData.MainPetSelected.PetRankUpCondition.Levels[_loc1_] + "\n");
            _loc1_++;
         }
         this.FTF_ActivateCondition.text = _loc10_;
         _loc9_ = true;
         _loc2_ = int(this.FPetData.MainPetSelected.PetRankUpCondition.PetIds.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc7_ = uint(this.FPetData.MainPetSelected.PetRankUpCondition.PetIds[_loc1_]);
            _loc8_ = uint(this.FPetData.MainPetSelected.PetRankUpCondition.Levels[_loc1_]);
            _loc5_ = this.FPetData.OwnMainPets.GetPetByIdentifier(_loc7_,0) as TMainPet;
            if(_loc5_ == null || _loc5_.Level < _loc8_)
            {
               _loc9_ = false;
               break;
            }
            _loc1_++;
         }
         this.FBtn_Activate.Enabled = _loc9_;
      }
      
      public function PlayActivateEffect() : void
      {
         this.FMC_ActivateEffect.play();
         this.FMC_ActivateEffect.visible = true;
      }
   }
}

