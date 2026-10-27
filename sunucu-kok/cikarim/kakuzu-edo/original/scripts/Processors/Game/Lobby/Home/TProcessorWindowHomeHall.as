package Processors.Game.Lobby.Home
{
   import Components.Pages.*;
   import Components.Standard.*;
   import Foundation.Network.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Bins.*;
   import Foundation.Resources.Textures.TAnimationSequence;
   import Foundation.Resources.Textures.TTexture;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.Home.*;
   import Logics.Inventories.*;
   import Logics.Streamization.Home.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Resources.Constants.*;
   import Resources.Strings.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class TProcessorWindowHomeHall extends TProcessorLobbyWindow
   {
      
      public static const FRAME_Current:uint = CONST_HOMEHALL.FRAME_Current;
      
      public static const FRAME_Next:uint = CONST_HOMEHALL.FRAME_Next;
      
      public static const FRAME_None:uint = CONST_HOMEHALL.FRAME_None;
      
      protected var FUnstreamizerHome:TUnstreamizerHome;
      
      protected var FHome:THome;
      
      protected var FHomeUpgrade:THome;
      
      protected var FAppliances:TInventories;
      
      protected var FHomes:Vector.<THome>;
      
      protected var FBtn_Close:SimpleButton;
      
      protected var FBtnUpgrade:TUIButton;
      
      protected var FSP_CurViewImagePoint:Sprite;
      
      protected var FBitmapCurViewImage:Bitmap;
      
      protected var FSP_CurLabel:Sprite;
      
      protected var FMC_CurLevelTitle:MovieClip;
      
      protected var FTF_CurLevelTitle:TextField;
      
      protected var FTF_CurDesc:TextField;
      
      protected var FTF_CurUpgradeConditions1:TextField;
      
      protected var FTF_CurUpgradeConditions2:TextField;
      
      protected var FSP_NextViewImagePoint:Sprite;
      
      protected var FBitmapNextViewImage:Bitmap;
      
      protected var FSP_NextLabel:Sprite;
      
      protected var FMC_NextLevelTitle:MovieClip;
      
      protected var FTF_NextLevelTitle:TextField;
      
      protected var FTF_NextDesc:TextField;
      
      protected var FTF_NextUpgradeConditions1:TextField;
      
      protected var FTF_NextUpgradeConditions2:TextField;
      
      protected var FMC_Effects:Vector.<MovieClip>;
      
      protected var FUIPageFriend:TUIPage;
      
      protected var FPageIndex:int;
      
      protected var FIsUpgrade:Boolean;
      
      protected var FCurViewImageID:uint;
      
      protected var FNextViewImageID:uint;
      
      public function TProcessorWindowHomeHall(param1:TUIComponent)
      {
         super(param1);
         this.FUnstreamizerHome = new TUnstreamizerHome();
         this.FHome = SLogicsCore.Home;
         this.FHomeUpgrade = new THome();
         this.FAppliances = SLogicsCore.Character.Appliances;
         this.FBitmapCurViewImage = new Bitmap();
         this.FBitmapNextViewImage = new Bitmap();
         this.FPageIndex = 0;
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_HOMEHALL.RESOURCESID_Swf_HomeHall);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:MovieClip = null;
         var _loc4_:Sprite = null;
         var _loc5_:TBins = null;
         var _loc6_:THome = null;
         _loc5_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_HomeLevel);
         _loc2_ = _loc5_.Count;
         this.FHomes = new Vector.<THome>(_loc2_);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc6_ = new THome();
            this.FUnstreamizerHome.UnstreamizeGenerateHome(null,_loc6_,_loc1_ + 1);
            this.FHomes[_loc1_] = _loc6_;
            _loc1_++;
         }
         _loc4_ = TUtilityReflection.CreateDisplayObjectInstance(CONST_HOMEHALL.RESOURCE_ClassName_MC_HomeHall) as Sprite;
         addChild(_loc4_);
         this.FBtn_Close = _loc4_[CONST_COMMON.RESOURCE_Link_Btn_Close];
         this.FBtn_Close.tabEnabled = false;
         this.FBtnUpgrade = new TUIButton();
         this.FBtnUpgrade.Substrate = _loc4_[CONST_HOMEHALL.RESOURCE_Link_Btn_Upgrade];
         this.FBtnUpgrade.OnClick = this.BtnUpgradeOnClick;
         this.FBtnUpgrade.Enabled = false;
         _loc3_ = _loc4_[CONST_HOMEHALL.RESOURCE_Link_SP_CurHomePanel];
         this.FSP_CurViewImagePoint = _loc3_[CONST_HOMEHALL.RESOURCE_Link_SP_ViewImagePoint];
         this.FSP_CurViewImagePoint.addChild(this.FBitmapCurViewImage);
         this.FSP_CurLabel = _loc3_[CONST_HOMEHALL.RESOURCE_Link_SP_Label];
         this.FMC_CurLevelTitle = _loc3_[CONST_HOMEHALL.RESOURCE_Link_MC_LevelTitle];
         this.FTF_CurLevelTitle = this.FMC_CurLevelTitle[CONST_HOMEHALL.RESOURCE_Link_TF_LevelTitle];
         this.FTF_CurDesc = _loc3_[CONST_HOMEHALL.RESOURCE_Link_TF_Desc];
         this.FTF_CurDesc.wordWrap = true;
         this.FTF_CurDesc.multiline = true;
         this.FTF_CurUpgradeConditions1 = _loc3_[CONST_HOMEHALL.RESOURCE_Link_TF_UpgradeConditions1];
         this.FTF_CurUpgradeConditions2 = _loc3_[CONST_HOMEHALL.RESOURCE_Link_TF_UpgradeConditions2];
         _loc3_ = _loc4_[CONST_HOMEHALL.RESOURCE_Link_SP_NextHomePanel];
         this.FSP_NextViewImagePoint = _loc3_[CONST_HOMEHALL.RESOURCE_Link_SP_ViewImagePoint];
         this.FSP_NextViewImagePoint.addChild(this.FBitmapNextViewImage);
         this.FSP_NextLabel = _loc3_[CONST_HOMEHALL.RESOURCE_Link_SP_Label];
         this.FMC_NextLevelTitle = _loc3_[CONST_HOMEHALL.RESOURCE_Link_MC_LevelTitle];
         this.FTF_NextLevelTitle = this.FMC_NextLevelTitle[CONST_HOMEHALL.RESOURCE_Link_TF_LevelTitle];
         this.FTF_NextDesc = _loc3_[CONST_HOMEHALL.RESOURCE_Link_TF_Desc];
         this.FTF_NextDesc.wordWrap = true;
         this.FTF_NextDesc.multiline = true;
         this.FTF_NextUpgradeConditions1 = _loc3_[CONST_HOMEHALL.RESOURCE_Link_TF_UpgradeConditions1];
         this.FTF_NextUpgradeConditions2 = _loc3_[CONST_HOMEHALL.RESOURCE_Link_TF_UpgradeConditions2];
         _loc2_ = int(CONST_HOMEHALL.CAPACITY_MC_Effects);
         this.FMC_Effects = new Vector.<MovieClip>(_loc2_);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = _loc4_[CONST_HOMEHALL.RESOURCE_Link_MC_Effect + _loc1_];
            _loc3_.stop();
            this.FMC_Effects[_loc1_] = _loc3_;
            _loc1_++;
         }
         this.FUIPageFriend = new TUIPage(this);
         _loc3_ = _loc4_[CONST_HOMEHALL.RESOURCE_Link_MC_PageLeft];
         this.FUIPageFriend.ButtonPrevious.Substrate = _loc3_;
         _loc3_ = _loc4_[CONST_HOMEHALL.RESOURCE_Link_MC_PageRight];
         this.FUIPageFriend.ButtonNext.Substrate = _loc3_;
         this.FUIPageFriend.LabelPage = _loc4_[CONST_HOMEHALL.RESOURCE_Link_TF_Page];
         this.FUIPageFriend.LabelPage.text = "0/0";
         this.FUIPageFriend.PageSize = CONST_HOMEHALL.CAPACITY_MC_Items;
         this.FUIPageFriend.Init();
         this.FUIPageFriend.OnChangePage = this.PageOnChange;
         TutorialSendComponent(CONST_FRESHGUIDE.MCID_HomeUpgradeView,this);
         TutorialSendArrowParent(CONST_FRESHGUIDE.MCID_HomeUpgradeView,FParent);
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         this.FBtn_Close.addEventListener(MouseEvent.CLICK,this.ButtonCloseOnClick,false,0,true);
         super.ResourcesPerform_UILocations();
      }
      
      protected function UpdateUpgradeUIPage() : void
      {
         if(this.FHome.Level == this.FHomes.length)
         {
            this.FPageIndex = this.FHome.Level - 2;
         }
         else
         {
            this.FPageIndex = this.FHome.Level - 1;
         }
         if(this.FPageIndex < 0)
         {
            this.FPageIndex = 0;
         }
         this.FUIPageFriend.TotalQuantity = this.FHomes.length - 1;
         this.FUIPageFriend.PageIndex = this.FPageIndex;
         this.FUIPageFriend.Update();
      }
      
      protected function UpdatePanelHomeHall() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:MovieClip = null;
         var _loc4_:TAppliance = null;
         var _loc5_:TAppliance = null;
         var _loc6_:uint = 0;
         var _loc7_:THome = null;
         var _loc8_:TBins = null;
         _loc2_ = int(this.FMC_Effects.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FMC_Effects[_loc1_];
            _loc3_.play();
            _loc1_++;
         }
         this.FIsUpgrade = false;
         _loc8_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_HomeLevel);
         if(this.FHome.Level < _loc8_.Count)
         {
            this.FUnstreamizerHome.UnstreamizeGenerateHome(null,this.FHomeUpgrade,this.FHome.Level + 1);
            _loc5_ = this.FHomeUpgrade.Appliance;
            _loc6_ = this.FHomeUpgrade.Appliance.Quantity;
            _loc2_ = this.FAppliances.Count;
            _loc1_ = 0;
            while(_loc1_ < _loc2_)
            {
               _loc4_ = this.FAppliances.GetInventoryByIndex(_loc1_) as TAppliance;
               if(_loc4_.IDTemplate == _loc5_.IDTemplate && _loc4_.Quantity >= _loc6_)
               {
                  this.FIsUpgrade = true;
                  break;
               }
               _loc1_++;
            }
         }
         this.FBtnUpgrade.Enabled = this.FIsUpgrade;
      }
      
      protected function UpdatePanelUpgrade() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:THome = null;
         var _loc3_:THome = null;
         var _loc4_:THome = null;
         var _loc5_:uint = 0;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:uint = 0;
         _loc1_ = uint(this.FPageIndex);
         _loc5_ = this.FHome.Level - 1;
         if(_loc1_ + 1 >= this.FHomes.length)
         {
            _loc2_ = this.FHomes[_loc1_ - 1];
            _loc3_ = this.FHomes[_loc1_];
         }
         else
         {
            _loc2_ = this.FHomes[_loc1_];
            _loc3_ = this.FHomes[_loc1_ + 1];
         }
         this.FCurViewImageID = _loc2_.ViewImageID;
         this.LoadViewImage(this.FCurViewImageID);
         this.FNextViewImageID = _loc3_.ViewImageID;
         this.LoadViewImage(this.FNextViewImageID);
         this.FSP_CurLabel.visible = false;
         this.FSP_NextLabel.visible = false;
         if(_loc1_ < _loc5_ && _loc1_ + 1 == _loc5_)
         {
            this.FSP_NextLabel.visible = true;
            this.FMC_CurLevelTitle.gotoAndStop(FRAME_None);
            this.FMC_NextLevelTitle.gotoAndStop(FRAME_Current);
         }
         else if(_loc5_ == _loc1_)
         {
            this.FSP_CurLabel.visible = true;
            this.FMC_CurLevelTitle.gotoAndStop(FRAME_Current);
            this.FMC_NextLevelTitle.gotoAndStop(FRAME_Next);
         }
         else
         {
            this.FMC_CurLevelTitle.gotoAndStop(FRAME_None);
            this.FMC_NextLevelTitle.gotoAndStop(FRAME_None);
         }
         this.FTF_CurLevelTitle.textColor = CONST_COMMON.QUALITYCOLOR_INDEX[_loc2_.Level + 1];
         this.FTF_CurLevelTitle.text = _loc2_.Name;
         this.FTF_CurDesc.htmlText = _loc2_.Desc;
         if(_loc2_.Level == 1)
         {
            this.FTF_CurUpgradeConditions1.htmlText = "";
            this.FTF_CurUpgradeConditions2.text = "";
         }
         else
         {
            _loc6_ = CONST_COMMON.TextColor[_loc2_.Appliance.Quality];
            _loc8_ = uint(this.FAppliances.GetCountByTempleteID(_loc2_.Appliance.IDTemplate));
            if(_loc8_ >= _loc2_.Appliance.Quantity)
            {
               _loc7_ = CONST_COMMON.HTMLCOLOR_Green;
            }
            else
            {
               _loc7_ = CONST_COMMON.HTMLCOLOR_Red;
            }
            this.FTF_CurUpgradeConditions1.htmlText = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HOME_STRING_33),_loc6_,_loc2_.Appliance.Name,_loc2_.Appliance.Quantity,_loc7_,_loc8_);
            _loc4_ = this.FHomes[_loc2_.Level - 2];
            _loc7_ = CONST_COMMON.TextColor[_loc4_.Level + 1];
            this.FTF_CurUpgradeConditions2.htmlText = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HOME_STRING_34),_loc7_,_loc4_.Name);
         }
         this.FTF_NextLevelTitle.textColor = CONST_COMMON.QUALITYCOLOR_INDEX[_loc3_.Level + 1];
         this.FTF_NextLevelTitle.text = _loc3_.Name;
         this.FTF_NextDesc.htmlText = _loc3_.Desc;
         _loc6_ = CONST_COMMON.TextColor[_loc3_.Appliance.Quality];
         _loc8_ = uint(this.FAppliances.GetCountByTempleteID(_loc3_.Appliance.IDTemplate));
         if(_loc8_ >= _loc3_.Appliance.Quantity)
         {
            _loc7_ = CONST_COMMON.HTMLCOLOR_Green;
         }
         else
         {
            _loc7_ = CONST_COMMON.HTMLCOLOR_Red;
         }
         this.FTF_NextUpgradeConditions1.htmlText = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HOME_STRING_33),_loc6_,_loc3_.Appliance.Name,_loc3_.Appliance.Quantity,_loc7_,_loc8_);
         _loc4_ = this.FHomes[_loc3_.Level - 2];
         _loc7_ = CONST_COMMON.TextColor[_loc4_.Level + 1];
         this.FTF_NextUpgradeConditions2.htmlText = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HOME_STRING_34),_loc7_,_loc4_.Name);
      }
      
      protected function LoadViewImage(param1:uint) : void
      {
         SResourcesCore.TexturesMiddlePic.LoadAutoSecondary(param1,this.AutoLoadCallBack);
      }
      
      protected function ButtonCloseOnClick(param1:MouseEvent) : void
      {
         ProcessorWindowClose();
      }
      
      protected function BtnUpgradeOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TPacket = null;
         _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Home_HomeUpgradeReq);
         SNetworkCore.Transceiver.PacketTransmit(_loc3_);
         TutorialNextStep(CONST_FRESHGUIDE.EVENTID_ClickHomeUpgradeBtn);
      }
      
      protected function PageOnChange(param1:Object, param2:int) : void
      {
         this.FPageIndex = param2;
         this.UpdatePanelUpgrade();
      }
      
      protected function AutoLoadCallBack(param1:Object, param2:TTexture, param3:uint) : void
      {
         var _loc4_:TAnimationSequence = null;
         var _loc5_:BitmapData = null;
         switch(param3)
         {
            case this.FCurViewImageID:
               _loc4_ = param2.GetAnimationSequenceByIndex(0);
               _loc5_ = _loc4_.GetAnimationFrameByIndex(0).Surface;
               this.FBitmapCurViewImage.bitmapData = _loc5_;
               break;
            case this.FNextViewImageID:
               _loc4_ = param2.GetAnimationSequenceByIndex(0);
               _loc5_ = _loc4_.GetAnimationFrameByIndex(0).Surface;
               this.FBitmapNextViewImage.bitmapData = _loc5_;
         }
      }
      
      public function Reset() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:MovieClip = null;
         _loc2_ = int(this.FMC_Effects.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FMC_Effects[_loc1_];
            _loc3_.stop();
            _loc1_++;
         }
         this.FBitmapCurViewImage.bitmapData = null;
         this.FBitmapNextViewImage.bitmapData = null;
      }
      
      public function Update() : void
      {
         this.UpdateUpgradeUIPage();
         this.UpdatePanelHomeHall();
         this.UpdatePanelUpgrade();
      }
   }
}

