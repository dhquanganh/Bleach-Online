package Processors.Game.Lobby.Pet
{
   import Components.Pages.*;
   import Components.Standard.*;
   import Foundation.Common.*;
   import Foundation.Common.Integer.*;
   import Foundation.Network.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Bins.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.Characters.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.Pet.*;
   import Logics.Pet.Gift.*;
   import Logics.TimeCoolDown.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Components.*;
   import Processors.Game.Lobby.Pet.Components.*;
   import Processors.Game.Lobby.Utilities.*;
   import Processors.Game.Utilities.HyperLink.*;
   import Processors.Game.Utilities.OverLayer.*;
   import Processors.Game.Windows.Information.*;
   import Resources.Constants.*;
   import Resources.Strings.*;
   import Utilities.Timing.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class TProcessorWindowPet extends TProcessorLobbyWindow
   {
      
      private static const FRAMEINDEX_TITLE_SHOW:uint = 9;
      
      private static const FRAMEINDEX_TITLE_HIDE:uint = 10;
      
      public static const CAPACITY_MC_Items:uint = CONST_PET.CAPACITY_MC_Items;
      
      protected static const FRAME_OpenEnd:uint = CONST_PET.FRAME_OpenEnd;
      
      protected static const FRAME_CloseEnd:uint = CONST_PET.FRAME_CloseEnd;
      
      protected var FUIWindowConfirmationClearCD:TUIWindowConfirmation;
      
      protected var FPetData:TPetData;
      
      protected var FHint:THint;
      
      protected var FBtns:Sprite;
      
      protected var FBtn_Close:SimpleButton;
      
      protected var FBtn_Help:SimpleButton;
      
      protected var FBtn_Return:TUIButton;
      
      protected var FConfigValueBin:TBins;
      
      protected var FMC_Title:MovieClip;
      
      protected var FMC_Tags:MovieClip;
      
      protected var FMCPanelShortcuts:MovieClip;
      
      protected var FMC_PanelHouse:MovieClip;
      
      protected var FBtn_PannelHouse:TUIButton;
      
      protected var FBtn_PanelStudy:TUIButton;
      
      protected var FBtn_PanelTrain:TUIButton;
      
      protected var FUICredits:TUICredits;
      
      protected var FTFInteractiveCount:TextField;
      
      protected var FTFTrainCount:TextField;
      
      protected var FTFCarryCount:TextField;
      
      protected var FMC_PetHouse:MovieClip;
      
      protected var FBtn_PetHouse:SimpleButton;
      
      protected var FMC_PetHouseEffect:MovieClip;
      
      protected var FBtn_PetTrain:SimpleButton;
      
      protected var FSP_PetStudy:Sprite;
      
      protected var FBtn_PetStudy:SimpleButton;
      
      protected var FMC_PetStudyEffect:MovieClip;
      
      protected var FBtn_PetInteract:SimpleButton;
      
      protected var FMC_PetInteractEffect:MovieClip;
      
      protected var FMC_FishNet:MovieClip;
      
      protected var FSP_PetInteractPopTip:Sprite;
      
      protected var FTF_CDTime:TextField;
      
      protected var FTF_Count:TextField;
      
      protected var FBtn_ClearCD:TUIButton;
      
      protected var FBtn_AddCount:TUIButton;
      
      protected var FFishNetCount:int;
      
      protected var FMCPetGift:Sprite;
      
      protected var FBtnCloseList:TUIButton;
      
      protected var FBtnOpenList:TUIButton;
      
      protected var FMCPetGiftList:MovieClip;
      
      protected var FSPetGiftList:Sprite;
      
      protected var FItemGifts:Vector.<TUIItemGift>;
      
      protected var FUIPagePet:TUIPage;
      
      protected var FTimeCoolDownFish:TTimeCoolDown;
      
      protected var FPageIndex:int;
      
      protected var FInitialization:Boolean;
      
      protected var FOnPetHouse:Function;
      
      protected var FOnPetTrain:Function;
      
      protected var FOnPetStudy:Function;
      
      protected var FOnGiftOver:Function;
      
      protected var FOnGiftOut:Function;
      
      public function TProcessorWindowPet(param1:TUIComponent)
      {
         super(param1);
         this.FPetData = SLogicsCore.PetData;
         this.FTimeCoolDownFish = new TTimeCoolDown(CONST_COMMON.TIME_COOLDOWN_Pet_Fish);
         SLogicsCore.TimeCoolDowns.Add(this.FTimeCoolDownFish);
         this.FHint = new THint();
         this.FInitialization = false;
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:Sprite = null;
         var _loc4_:MovieClip = null;
         var _loc5_:TUIItemGift = null;
         var _loc6_:TextField = null;
         var _loc7_:Sprite = null;
         _loc3_ = TUtilityReflection.CreateDisplayObjectInstance(CONST_PET.RESOURCE_ClassName_MC_Pet) as Sprite;
         addChild(_loc3_);
         this.FBtns = _loc3_[CONST_PET.RESOURCE_Link_Btns];
         this.FBtn_Close = this.FBtns[CONST_COMMON.RESOURCE_Link_Btn_Close];
         this.FBtn_Close.tabEnabled = false;
         this.FBtn_Help = this.FBtns[CONST_COMMON.RESOURCE_Link_Btn_Help];
         this.FBtn_Help.tabEnabled = false;
         this.FMC_Title = TUtilityReflection.CreateDisplayObjectInstance(CONST_PET.RESOURCE_ClassName_MC_Title) as MovieClip;
         addChild(this.FMC_Title);
         this.FMC_Title.mouseEnabled = false;
         this.FMC_Title.mouseChildren = false;
         this.FMC_Title.visible = false;
         this.FMC_Tags = this.FMC_Title[CONST_PET.RESOURCE_Link_MC_MC_Tags];
         this.FMCPanelShortcuts = _loc3_[CONST_PET.RESOURCE_Link_MC_PanelShortcuts];
         this.FMC_PanelHouse = this.FMCPanelShortcuts[CONST_PET.RESOURCE_Link_MC_PanelHouse];
         this.FBtn_PannelHouse = new TUIButton();
         this.FBtn_PannelHouse.Substrate = this.FMC_PanelHouse["Btn_PannelHouse"];
         this.FBtn_PannelHouse.OnClick = this.PanelBtnClick;
         this.FBtn_PanelStudy = new TUIButton();
         this.FBtn_PanelStudy.Substrate = this.FMCPanelShortcuts[CONST_PET.RESOURCE_Link_Btn_PanelStudy];
         this.FBtn_PanelStudy.OnClick = this.PanelBtnClick;
         this.FBtn_PanelTrain = new TUIButton();
         this.FBtn_PanelTrain.Substrate = this.FMCPanelShortcuts[CONST_PET.RESOURCE_Link_Btn_PanelTrain];
         this.FBtn_PanelTrain.OnClick = this.PanelBtnClick;
         this.FUICredits = new TUICredits();
         this.FUICredits.Resource = _loc3_[CONST_PET.RESOURCE_Link_MC_PanelCredits];
         this.FUICredits.HintOnMove = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FUICredits.HintOnOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FUICredits.OnAddSilverCoin = this.UICreditsOnAddSilverCoin;
         _loc4_ = _loc3_[CONST_PET.RESOURCE_Link_MC_PanelInteractiveInfo];
         this.FTFInteractiveCount = _loc4_[CONST_PET.RESOURCE_Link_TF_InteractiveCount];
         this.FTFTrainCount = _loc4_[CONST_PET.RESOURCE_Link_TF_TrainCount];
         this.FTFCarryCount = _loc4_[CONST_PET.RESOURCE_Link_TF_CarryCount];
         this.FMC_PetHouse = _loc3_[CONST_PET.RESOURCE_Link_MC_PetHouse];
         this.FBtn_PetHouse = this.FMC_PetHouse[CONST_PET.RESOURCE_Link_Btn_PetHouse];
         this.FMC_PetHouseEffect = this.FMC_PetHouse[CONST_PET.RESOURCE_Link_MC_PetHouseEffect];
         this.FMC_PetHouseEffect.mouseEnabled = false;
         this.FMC_PetHouseEffect.mouseChildren = false;
         this.FBtn_PetTrain = _loc3_[CONST_PET.RESOURCE_Link_Btn_PetTrain];
         this.FSP_PetStudy = _loc3_[CONST_PET.RESOURCE_Link_SP_PetStudy];
         this.FBtn_PetStudy = this.FSP_PetStudy[CONST_PET.RESOURCE_Link_Btn_PetStudy];
         this.FMC_PetStudyEffect = this.FSP_PetStudy[CONST_PET.RESOURCE_Link_MC_PetStudyEffect];
         this.FMC_PetStudyEffect.mouseChildren = false;
         this.FMC_PetStudyEffect.mouseEnabled = false;
         _loc7_ = _loc3_[CONST_PET.RESOURCE_Link_SP_PetInteract];
         this.FBtn_PetInteract = _loc7_[CONST_PET.RESOURCE_Link_Btn_PetInteract];
         this.FMC_PetInteractEffect = _loc7_[CONST_PET.RESOURCE_Link_MC_PetInteractEffect];
         this.FMC_PetInteractEffect.mouseChildren = false;
         this.FMC_PetInteractEffect.mouseEnabled = false;
         this.FMC_FishNet = _loc3_[CONST_PET.RESOURCE_Link_MC_FishNet];
         this.FMC_FishNet.visible = false;
         this.FSP_PetInteractPopTip = _loc3_[CONST_PET.RESOURCE_Link_SP_PetInteractPopTip];
         this.FTF_CDTime = this.FSP_PetInteractPopTip[CONST_PET.RESOURCE_Link_TF_CDTime];
         this.FTF_Count = this.FSP_PetInteractPopTip[CONST_PET.RESOURCE_Link_TF_Count];
         this.FBtn_ClearCD = new TUIButton();
         this.FBtn_ClearCD.Substrate = this.FSP_PetInteractPopTip[CONST_PET.RESOURCE_Link_Btn_ClearCD];
         this.FBtn_ClearCD.OnClick = this.ButtonClearCDOnClick;
         this.FBtn_AddCount = new TUIButton();
         this.FBtn_AddCount.Substrate = this.FSP_PetInteractPopTip[CONST_PET.RESOURCE_Link_Btn_AddCount];
         this.FBtn_AddCount.OnClick = this.BtnAddCountOnClick;
         this.FBtn_AddCount.OnOver = this.BtnAddOnOver;
         this.FBtn_AddCount.OnOut = this.BtnAddOnOut;
         this.FBtn_AddCount.IsFilter = true;
         this.FUIWindowConfirmationClearCD = SUtilityOverLayer.UIWindowConfirmation;
         this.FMCPetGift = _loc3_[CONST_PET.RESOURCE_Link_MC_PetGift];
         this.FMCPetGiftList = _loc3_[CONST_PET.RESOURCE_Link_MC_PetGiftList];
         this.FSPetGiftList = this.FMCPetGiftList[CONST_PET.RESOURCE_Link_S_PetGiftList];
         this.FItemGifts = new Vector.<TUIItemGift>(CAPACITY_MC_Items);
         _loc2_ = CAPACITY_MC_Items;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc5_ = new TUIItemGift(this);
            _loc5_.Resource = this.FSPetGiftList[CONST_PET.RESOURCE_Link_MC_Item_ + _loc1_];
            _loc5_.OnClick = this.BtnGetGiftOnClick;
            _loc5_.OnOver = this.ItemPetGiftOnOver;
            _loc5_.OnOut = this.ItemPetGiftOnOut;
            _loc5_.Context = null;
            _loc5_.Visible = false;
            this.FItemGifts[_loc1_] = _loc5_;
            _loc1_++;
         }
         this.FUIPagePet = new TUIPage(this);
         _loc4_ = this.FSPetGiftList[CONST_PET.RESOURCE_Link_MC_PageLeft];
         this.FUIPagePet.ButtonPrevious.Substrate = _loc4_;
         _loc4_ = this.FSPetGiftList[CONST_PET.RESOURCE_Link_MC_PageRight];
         this.FUIPagePet.ButtonNext.Substrate = _loc4_;
         _loc6_ = this.FSPetGiftList[CONST_PET.RESOURCE_Link_TF_Page];
         this.FUIPagePet.LabelPage = _loc6_;
         _loc6_.text = "0/0";
         this.FUIPagePet.PageSize = CAPACITY_MC_Items;
         this.FUIPagePet.Init();
         this.FUIPagePet.OnChangePage = this.PageOnChange;
         this.FBtnCloseList = new TUIButton();
         this.FBtnCloseList.Substrate = this.FMCPetGift[CONST_PET.RESOURCE_Link_Btn_CloseList];
         this.FBtnCloseList.OnClick = this.BtnCloseListOnClick;
         this.FBtnCloseList.Visible = false;
         this.FBtnOpenList = new TUIButton();
         this.FBtnOpenList.Substrate = this.FMCPetGift[CONST_PET.RESOURCE_Link_Btn_OpenList];
         this.FBtnOpenList.OnClick = this.BtnOpenListOnClick;
         this.FBtn_Return = new TUIButton();
         this.FBtn_Return.Substrate = _loc3_[CONST_PET.RESOURCE_Link_Btn_Return];
         this.FBtn_Return.OnClick = this.ButtonReturnOnClick;
         this.FConfigValueBin = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_ConfigValue);
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         this.FBtn_Close.addEventListener(MouseEvent.CLICK,this.ButtonCloseOnClick,false,0,true);
         this.FBtn_PetInteract.addEventListener(MouseEvent.CLICK,this.BtnPetOnClick,false,0,true);
         this.FBtn_PetHouse.addEventListener(MouseEvent.CLICK,this.BtnPetOnClick,false,0,true);
         this.FBtn_PetTrain.addEventListener(MouseEvent.CLICK,this.BtnPetOnClick,false,0,true);
         this.FBtn_PetStudy.addEventListener(MouseEvent.CLICK,this.BtnPetOnClick,false,0,true);
         this.FMC_PetHouse.addEventListener(MouseEvent.MOUSE_OVER,this.TitleOnOver,false,0,true);
         this.FBtn_PetStudy.addEventListener(MouseEvent.MOUSE_OVER,this.TitleOnOver,false,0,true);
         this.FBtn_PetTrain.addEventListener(MouseEvent.MOUSE_OVER,this.TitleOnOver,false,0,true);
         this.FMC_PetHouse.addEventListener(MouseEvent.MOUSE_OUT,this.TitleOnOut,false,0,true);
         this.FBtn_PetStudy.addEventListener(MouseEvent.MOUSE_OUT,this.TitleOnOut,false,0,true);
         this.FBtn_PetTrain.addEventListener(MouseEvent.MOUSE_OUT,this.TitleOnOut,false,0,true);
         this.Reset();
         this.FInitialization = true;
         super.ResourcesPerform_UILocations();
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(this.FInitialization)
         {
            if(this.visible)
            {
               this.LogicsPerform_ShortcutsStatus();
               this.LogicsPerform_FishNetEffect();
               this.LogicPerform_TitleEffect();
               this.LogicPerform_InteractCD();
               this.FUICredits.UpdateEffect();
            }
            this.LogicsPerform_GiftEffect();
         }
      }
      
      protected function LogicsPerform_ShortcutsStatus() : void
      {
         var _loc1_:MovieClip = null;
         if(this.FMCPanelShortcuts.currentFrame == this.FMCPanelShortcuts.totalFrames)
         {
            _loc1_ = this.FMCPanelShortcuts[CONST_PET.RESOURCE_Link_MC_PanelHouseLight];
            _loc1_.mouseEnabled = false;
            _loc1_.mouseChildren = false;
         }
      }
      
      protected function LogicsPerform_FishNetEffect() : void
      {
         if(this.FFishNetCount <= 0)
         {
            return;
         }
         if(this.FMC_FishNet.currentFrame == 1)
         {
            this.FMC_FishNet.visible = true;
            this.FMC_FishNet.play();
         }
         if(this.FMC_FishNet.currentFrame == this.FMC_FishNet.totalFrames)
         {
            this.FMC_FishNet.gotoAndStop(1);
            --this.FFishNetCount;
            this.FMC_FishNet.visible = false;
         }
      }
      
      protected function LogicsPerform_GiftEffect() : void
      {
         if(this.FMCPetGiftList.currentFrame != 1 && this.FMCPetGiftList.currentFrame != FRAME_OpenEnd + 1)
         {
            this.FMCPetGift.x = this.FMCPetGiftList.x + this.FSPetGiftList.x - 27;
            this.FMCPetGift.y = this.FMCPetGiftList.y - this.FSPetGiftList.y + 200;
         }
         if(this.FMCPetGiftList.currentFrame == FRAME_OpenEnd)
         {
            this.FMCPetGiftList.gotoAndStop(FRAME_OpenEnd + 1);
         }
         if(this.FMCPetGiftList.currentFrame == FRAME_CloseEnd)
         {
            this.FMCPetGiftList.gotoAndStop(1);
         }
      }
      
      protected function LogicPerform_TitleEffect() : void
      {
         if(this.FMC_Title.currentFrame == FRAMEINDEX_TITLE_SHOW)
         {
            this.FMC_Title.gotoAndStop(FRAMEINDEX_TITLE_HIDE);
         }
         if(this.FMC_Title.currentFrame == this.FMC_Title.totalFrames)
         {
            this.FMC_Title.gotoAndStop(1);
            this.FMC_Title.visible = false;
         }
      }
      
      protected function LogicPerform_InteractCD() : void
      {
         var _loc1_:String = null;
         var _loc2_:uint = 0;
         _loc2_ = this.FTimeCoolDownFish.TimingTime;
         this.FPetData.FishCDTime = _loc2_;
         if(_loc2_ > 0)
         {
            if(this.FPetData.FishCount < this.FPetData.CurrentBuyFishCountLimit)
            {
               _loc1_ = TUtilityTiming.fomatTime(_loc2_);
            }
         }
         else if(this.FPetData.FishCD > 0)
         {
            if(this.FPetData.FishCount < this.FPetData.CurrentBuyFishCountLimit)
            {
               _loc1_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_PET_06);
               if(this.FBtn_ClearCD.Enabled)
               {
                  this.FBtn_ClearCD.Enabled = false;
               }
            }
            else
            {
               _loc1_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_PET_05);
            }
            this.FPetData.FishCD = 0;
         }
         if(!TUtilityString.Empty(_loc1_))
         {
            this.FTF_CDTime.text = _loc1_;
         }
      }
      
      protected function ProcessorPetInteractReq() : void
      {
         var _loc1_:TPacket = null;
         if(this.FPetData.FishCD > 0)
         {
            return;
         }
         if(this.FPetData.FishCount >= this.FPetData.CurrentBuyFishCountLimit)
         {
            return;
         }
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Pet_InteractReq);
         SNetworkCore.Transceiver.PacketTransmit(_loc1_);
      }
      
      override protected function ProcessorResize() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         if(!this.FInitialization || !this.Visible)
         {
            return;
         }
         _loc1_ = FUICore.StageWidth;
         _loc2_ = FUICore.StageHeight;
         this.FBtns.x = _loc1_ - this.FBtns.width;
         this.FBtn_Return.X = _loc1_ - this.FBtn_Return.Width - 4;
         this.FBtn_Return.Y = _loc2_ - this.FBtn_Return.Height - 4;
         this.FMCPanelShortcuts.y = _loc2_ - this.FMCPanelShortcuts.height + 2;
         this.FMCPetGiftList.x = _loc1_ - 15;
         this.FMCPetGiftList.y = _loc2_ - this.FMCPetGiftList.height - 48;
         this.FMCPetGift.x = this.FMCPetGiftList.x + this.FSPetGiftList.x - 27;
         this.FMCPetGift.y = this.FMCPetGiftList.y - this.FSPetGiftList.y + 200;
      }
      
      protected function AddCountReq(param1:Object) : void
      {
         var _loc2_:TPacket = null;
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Pet_InteractBuyCountReq);
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
      }
      
      protected function ButtonReturnOnClick(param1:Object, param2:MouseEvent) : void
      {
         ProcessorWindowClose();
      }
      
      protected function ButtonCloseOnClick(param1:MouseEvent) : void
      {
         ProcessorWindowClose();
      }
      
      protected function UICreditsOnAddSilverCoin(param1:Object) : void
      {
         SUtilityHyperLink.ShortcutHyperlink(TUtilityHyperLink.HyperLink_HellButterfly);
      }
      
      protected function BtnPetOnClick(param1:MouseEvent) : void
      {
         var _loc2_:SimpleButton = null;
         _loc2_ = param1.currentTarget as SimpleButton;
         switch(_loc2_)
         {
            case this.FBtn_PetInteract:
               this.ProcessorPetInteractReq();
               TutorialNextStep(CONST_FRESHGUIDE.EVENTID_PetInteractive);
               break;
            case this.FBtn_PetHouse:
               if(this.FOnPetHouse != null)
               {
                  this.FOnPetHouse(this);
                  TutorialNextStep(CONST_FRESHGUIDE.EVENTID_EnterPetHome);
               }
               break;
            case this.FBtn_PetTrain:
               if(this.FOnPetTrain != null)
               {
                  this.FOnPetTrain(this);
               }
               break;
            case this.FBtn_PetStudy:
               if(this.FOnPetStudy != null)
               {
                  this.FOnPetStudy(this);
                  TutorialNextStep(CONST_FRESHGUIDE.EVENTID_OpenStudyHome);
               }
         }
      }
      
      protected function PanelBtnClick(param1:Object, param2:MouseEvent) : void
      {
         if(param1 == null)
         {
            return;
         }
         switch(param1)
         {
            case this.FBtn_PannelHouse:
               if(this.FOnPetHouse != null)
               {
                  this.FOnPetHouse(this);
               }
               break;
            case this.FBtn_PanelStudy:
               if(this.FOnPetStudy != null)
               {
                  this.FOnPetStudy(this);
               }
               break;
            case this.FBtn_PanelTrain:
               if(this.FOnPetTrain != null)
               {
                  this.FOnPetTrain(this);
               }
         }
      }
      
      protected function TitleOnOver(param1:MouseEvent) : void
      {
         var _loc2_:Object = null;
         var _loc3_:uint = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         _loc2_ = param1.currentTarget as DisplayObject;
         switch(_loc2_)
         {
            case this.FMC_PetHouse:
               _loc3_ = 1;
               _loc4_ = this.FMC_PetHouse.x + this.FMC_PetHouse.width / 2 - this.FMC_Title.width / 2;
               _loc5_ = this.FMC_PetHouse.y + this.FMC_PetHouse.height / 2 - this.FMC_Title.height / 2 - 55;
               break;
            case this.FBtn_PetStudy:
               _loc3_ = 2;
               _loc4_ = this.FSP_PetStudy.x + this.FSP_PetStudy.width / 2 - this.FMC_Title.width / 2 - 35;
               _loc5_ = this.FSP_PetStudy.y + this.FSP_PetStudy.height / 2 - this.FMC_Title.height / 2 - 25 - 45;
               break;
            case this.FBtn_PetTrain:
               _loc3_ = 3;
               _loc4_ = this.FBtn_PetTrain.x + this.FBtn_PetTrain.width / 2 - this.FMC_Title.width / 2;
               _loc5_ = this.FBtn_PetTrain.y + this.FBtn_PetTrain.height / 2 - this.FMC_Title.height / 2 - 25;
         }
         this.FMC_Title.gotoAndStop(1);
         this.FMC_Tags.gotoAndStop(_loc3_);
         this.FMC_Title.x = _loc4_;
         this.FMC_Title.y = _loc5_;
         this.FMC_Title.play();
         this.FMC_Title.visible = true;
      }
      
      protected function TitleOnOut(param1:MouseEvent) : void
      {
         this.FMC_Title.gotoAndStop(FRAMEINDEX_TITLE_HIDE);
         this.FMC_Title.play();
      }
      
      protected function ButtonClearCDOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TConfigValue = null;
         var _loc4_:uint = 0;
         _loc3_ = this.FConfigValueBin.GetDatebaseByIdentifier(CONST_CONFIGVALUE.Pet_CD_Gold) as TConfigValue;
         _loc4_ = uint(_loc3_.Value) * Math.ceil(this.FPetData.FishCDTime / 60);
         this.FUIWindowConfirmationClearCD.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HOME_STRING_16),_loc4_);
         this.FUIWindowConfirmationClearCD.OnOK = this.WindowConfirmationClearCDOnOK;
         this.FUIWindowConfirmationClearCD.Visible = true;
      }
      
      protected function BtnAddOnOver(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc6_:TConfigValue = null;
         var _loc7_:TBins = null;
         var _loc8_:TVipConfig = null;
         var _loc9_:String = null;
         _loc6_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.Pet_BuyInteract_Num) as TConfigValue;
         _loc9_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_PET_34);
         _loc5_ = TUtilityString.Format(_loc9_,0,_loc6_.Value as uint);
         _loc7_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_VipConfig);
         _loc4_ = 10;
         _loc3_ = 1;
         while(_loc3_ <= _loc4_)
         {
            _loc8_ = _loc7_.GetDatebaseByIdentifier(_loc3_) as TVipConfig;
            _loc5_ += "\r";
            _loc5_ = _loc5_ + TUtilityString.Format(_loc9_,_loc3_,_loc8_.PetInteractionCount);
            _loc3_++;
         }
         this.FHint.Caption = _loc5_;
         SUtilityOverLayer.UIComponentsHintOnOver(this,this.FHint);
      }
      
      protected function BtnAddOnOut(param1:Object, param2:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOut(this,this.FHint);
      }
      
      protected function BtnAddCountOnClick(param1:Object, param2:MouseEvent) : void
      {
         SUtilityOverLayer.UIWindowConfirmation.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_06),this.FPetData.FishAddCountCost[this.FPetData.BuyFishCount]);
         SUtilityOverLayer.UIWindowConfirmation.Visible = true;
         SUtilityOverLayer.UIWindowConfirmation.OnOK = this.AddCountReq;
      }
      
      protected function WindowConfirmationClearCDOnOK(param1:Object) : void
      {
         var _loc2_:TPacket = null;
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Pet_InteractClearCDReq);
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
      }
      
      protected function BtnCloseListOnClick(param1:Object, param2:MouseEvent) : void
      {
         this.FBtnCloseList.Visible = false;
         this.FBtnOpenList.Visible = true;
         this.FMCPetGiftList.play();
      }
      
      protected function BtnOpenListOnClick(param1:Object, param2:MouseEvent) : void
      {
         this.FBtnCloseList.Visible = true;
         this.FBtnOpenList.Visible = false;
         this.FMCPetGiftList.gotoAndStop(1);
         this.FMCPetGiftList.play();
         TutorialNextStep(CONST_FRESHGUIDE.EVENTID_OpenGiftWindow);
      }
      
      protected function BtnGetGiftOnClick(param1:Object, param2:TGift) : void
      {
         var _loc3_:TPacket = null;
         _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Pet_GetPetBagReq);
         _loc3_.Data.writeUnsignedInt(param2.Identifier);
         SNetworkCore.Transceiver.PacketTransmit(_loc3_);
         TutorialNextStep(CONST_FRESHGUIDE.EVENTID_ReciveGift);
      }
      
      protected function ItemPetGiftOnOver(param1:Object, param2:TGift) : void
      {
         if(this.FOnGiftOver != null)
         {
            this.FOnGiftOver(param1,param2);
         }
      }
      
      protected function ItemPetGiftOnOut(param1:Object, param2:TGift) : void
      {
         if(this.FOnGiftOut != null)
         {
            this.FOnGiftOut(param1,param2);
         }
      }
      
      protected function UpdatePetUIPage() : void
      {
         this.FUIPagePet.TotalQuantity = this.FPetData.Gifts.Count;
         this.FUIPagePet.PageIndex = this.FPageIndex;
         this.FUIPagePet.Update();
      }
      
      protected function PageOnChange(param1:Object, param2:int) : void
      {
         this.FPageIndex = param2;
         this.UpdatePanelGift();
      }
      
      protected function UpdatePanelGift() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:TUIItemGift = null;
         _loc4_ = this.FPageIndex;
         _loc2_ = int(CAPACITY_MC_Items);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc5_ = this.FItemGifts[_loc1_];
            _loc5_.Context = null;
            _loc5_.Visible = false;
            _loc1_++;
         }
         _loc2_ = this.FPetData.Gifts.Count;
         if(_loc2_ <= 0)
         {
            return;
         }
         _loc3_ = _loc4_ * CAPACITY_MC_Items;
         _loc1_ = 0;
         while(_loc1_ < CAPACITY_MC_Items)
         {
            if(_loc1_ + _loc3_ >= _loc2_)
            {
               break;
            }
            _loc5_ = this.FItemGifts[_loc1_];
            _loc5_.Context = this.FPetData.Gifts.GetGiftByIndex(_loc1_ + _loc3_);
            _loc5_.Visible = true;
            _loc1_++;
         }
      }
      
      public function get OnPetHouse() : Function
      {
         return this.FOnPetHouse;
      }
      
      public function set OnPetHouse(param1:Function) : void
      {
         this.FOnPetHouse = param1;
      }
      
      public function get OnPetTrain() : Function
      {
         return this.FOnPetTrain;
      }
      
      public function set OnPetTrain(param1:Function) : void
      {
         this.FOnPetTrain = param1;
      }
      
      public function get OnPetStudy() : Function
      {
         return this.FOnPetStudy;
      }
      
      public function set OnPetStudy(param1:Function) : void
      {
         this.FOnPetStudy = param1;
      }
      
      public function get OnGiftOver() : Function
      {
         return this.FOnGiftOver;
      }
      
      public function set OnGiftOver(param1:Function) : void
      {
         this.FOnGiftOver = param1;
      }
      
      public function get OnGiftOut() : Function
      {
         return this.FOnGiftOut;
      }
      
      public function set OnGiftOut(param1:Function) : void
      {
         this.FOnGiftOut = param1;
      }
      
      public function Reset() : void
      {
         if(!this.FInitialization)
         {
            return;
         }
         this.FMC_FishNet.stop();
         this.FMC_PetHouseEffect.stop();
         this.FMC_PetStudyEffect.stop();
         this.FMC_PetInteractEffect.stop();
         this.FTFTrainCount.text = "";
         this.FTFCarryCount.text = "";
         this.FTFInteractiveCount.text = "";
      }
      
      public function Update() : void
      {
         this.UpdatePetUI();
         this.FUICredits.UpdatePanel();
         this.UpdateInteractUI();
         this.PlayPanelShortcuts();
         this.UpdateGiftBag();
         this.UpdatePanelGift();
         this.UpdatePetUIPage();
         this.ProcessorResize();
      }
      
      public function UpdatePetUI() : void
      {
         this.FMC_PetHouseEffect.play();
         this.FMC_PetStudyEffect.play();
         this.FMC_PetInteractEffect.play();
      }
      
      public function UpdateInteractUI() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:String = null;
         var _loc3_:Boolean = false;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         _loc2_ = TUtilityString.Format(CONST_COMMON.STRING_Capacity,this.FPetData.FishCount,this.FPetData.CurrentBuyFishCountLimit);
         this.FTFInteractiveCount.text = _loc2_;
         this.FTF_Count.text = _loc2_;
         this.FTFTrainCount.text = TUtilityString.Format(CONST_COMMON.STRING_Capacity,this.FPetData.TrainDatas.GetUseSlots(),this.FPetData.CurrentVicePetTrainSlotCount);
         this.FTFCarryCount.text = TUtilityString.Format(CONST_COMMON.STRING_Capacity,this.FPetData.OwnVicePets.Count,this.FPetData.CurrentPetCapacity + this.FPetData.BuyVicePetStorageSlotCount);
         if(this.FTimeCoolDownFish.TimingTime <= 0)
         {
            this.FTimeCoolDownFish.TimingTime = this.FPetData.FishCD;
         }
         _loc4_ = this.FTimeCoolDownFish.TimingTime;
         if(_loc4_ > 0)
         {
            if(this.FPetData.FishCount >= this.FPetData.CurrentBuyFishCountLimit)
            {
               _loc5_ = 16711680;
               _loc1_ = CONST_SYSTEMLANGUAGE.STRING_PET_05;
            }
            else
            {
               _loc5_ = 65280;
            }
         }
         else if(this.FPetData.FishCount < this.FPetData.CurrentBuyFishCountLimit)
         {
            _loc5_ = 65280;
            _loc1_ = CONST_SYSTEMLANGUAGE.STRING_PET_06;
         }
         else
         {
            _loc5_ = 16711680;
            _loc1_ = CONST_SYSTEMLANGUAGE.STRING_PET_05;
         }
         this.FTF_CDTime.text = TUtilityLobby.GetStringByIdentifier(_loc1_);
         this.FTF_CDTime.textColor = _loc5_;
         _loc3_ = _loc4_ > 0 && this.FPetData.FishCount < this.FPetData.CurrentBuyFishCountLimit;
         this.FBtn_ClearCD.Enabled = _loc3_;
         this.FBtn_AddCount.Enabled = this.FPetData.BuyFishCount < this.FPetData.BuyFishCountLimit;
      }
      
      public function PlayPanelShortcuts() : void
      {
         this.FMCPanelShortcuts.play();
      }
      
      public function UpdateGiftBag() : void
      {
         this.UpdatePanelGift();
      }
      
      public function PlayEffectMCFishNet() : void
      {
         ++this.FFishNetCount;
      }
   }
}

