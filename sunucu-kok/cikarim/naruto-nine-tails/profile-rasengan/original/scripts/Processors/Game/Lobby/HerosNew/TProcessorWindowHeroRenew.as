package Processors.Game.Lobby.HerosNew
{
   import Components.SelectBox.TSelectBoxSingle;
   import Components.Standard.TUIButton;
   import Foundation.Network.SNetworkCore;
   import Foundation.Network.TPacket;
   import Foundation.Resources.Bins.TBins;
   import Foundation.Resources.SResourcesCore;
   import Foundation.Resources.Textures.TTexture;
   import Foundation.Timing.STimingCore;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Foundation.Utilities.TUtilityString;
   import Logics.Characters.THero;
   import Logics.DatebaseVO.VO.THDPrivilegeLease;
   import Logics.DatebaseVO.VO.TTimeHero;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Resources.Constants.CONST_DATEBASEVO;
   import Resources.Constants.CONST_HEROS;
   import Resources.Constants.CONST_NETWORK;
   import Utilities.Timing.TUtilityTiming;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class TProcessorWindowHeroRenew extends TProcessorLobbyWindow
   {
      
      protected const CheckBox_Len:int = 4;
      
      protected const CONST_Day:int = 86400;
      
      protected var FHeroRenewUI:Sprite;
      
      protected var FBtnClose:TUIButton;
      
      protected var FCountDownTime:TextField;
      
      protected var FSelectBox:TSelectBoxSingle;
      
      protected var FBtnRenewHero:TUIButton;
      
      protected var FMCHead:Sprite;
      
      protected var FMC_BarSonGoldTF:TextField;
      
      protected var FMC_Bar:Sprite;
      
      protected var FBitmap:Bitmap;
      
      protected var FStatus_SelectBoxStart:int;
      
      protected var FTimeHeroBins:TBins;
      
      protected var FHDTimeHeroBins:TBins;
      
      protected var FSelectRenewHeroId:int;
      
      protected var FSelectBoxDayList:Vector.<TextField>;
      
      protected var FSelectBoxPriceList:Vector.<TextField>;
      
      protected var FHero:THero;
      
      protected var FIsBtnState:Boolean;
      
      public function TProcessorWindowHeroRenew(param1:TUIComponent)
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
         var _loc2_:int = 0;
         this.FSelectBoxDayList = new Vector.<TextField>();
         this.FSelectBoxPriceList = new Vector.<TextField>();
         this.FTimeHeroBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_TimeHero);
         this.FHDTimeHeroBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_PrivilegeLease);
         this.FHeroRenewUI = TUtilityReflection.CreateDisplayObjectInstance(CONST_HEROS.RESOURCE_ClassName_MC_HeroRenew) as Sprite;
         if(this.FHeroRenewUI == null)
         {
            super.ResourcesPerform_UIDispatch();
            return;
         }
         addChild(this.FHeroRenewUI);
         this.FBtnClose = new TUIButton();
         this.FBtnClose.Substrate = this.FHeroRenewUI["btn_close"];
         this.FBtnClose.OnClick = this.BtnCloseOnClick;
         this.FCountDownTime = this.FHeroRenewUI["TF_Time"];
         this.FSelectBox = new TSelectBoxSingle();
         _loc2_ = this.CheckBox_Len;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FSelectBox.SetTaskByIndex(_loc1_,this.FHeroRenewUI["MC_SelectBox_" + _loc1_]["MC_Button"]);
            _loc1_++;
         }
         this.FSelectBox.CallBackOnSelect = this.SelectBoxSingleOnClick;
         this.FSelectBox.Init();
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FHeroRenewUI["MC_SelectBox_" + _loc1_]["TF_Day"].text = "";
            this.FHeroRenewUI["MC_SelectBox_" + _loc1_]["TF_Gold"].text = "";
            this.FSelectBoxDayList.push(this.FHeroRenewUI["MC_SelectBox_" + _loc1_]["TF_Day"]);
            this.FSelectBoxPriceList.push(this.FHeroRenewUI["MC_SelectBox_" + _loc1_]["TF_Gold"]);
            _loc1_++;
         }
         this.FBtnRenewHero = new TUIButton();
         this.FBtnRenewHero.Substrate = this.FHeroRenewUI["MC_RenewHero"];
         this.FBtnRenewHero.Visible = false;
         this.FMCHead = this.FHeroRenewUI["MC_HeroHead"];
         this.FMCHead["mc_over"].visible = false;
         this.FMCHead.addEventListener(MouseEvent.MOUSE_OVER,this.HeroHeadOnOver);
         this.FMCHead.addEventListener(MouseEvent.MOUSE_OUT,this.HeroHeadOnOut);
         (this.FMCHead["mc_head"] as Sprite).buttonMode = true;
         this.FBitmap = new Bitmap();
         this.FMCHead["mc_head"].addChild(this.FBitmap);
         (this.FMCHead["mc_over"] as Sprite).visible = false;
         (this.FMCHead["mc_normal"] as Sprite).visible = true;
         this.FMC_Bar = this.FHeroRenewUI["MC_Bar"]["RedBar"];
         this.FMC_BarSonGoldTF = this.FHeroRenewUI["MC_Bar"]["TF_Gold"];
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         super.ResourcesPerform_UILocations();
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(!this.Visible)
         {
            return;
         }
         if(!this.FHero)
         {
            return;
         }
         this.SetTimeOrButtonState();
      }
      
      protected function SelectBoxSingleOnClick(param1:int, param2:int) : void
      {
         this.FStatus_SelectBoxStart = param2;
      }
      
      protected function SetCheckBoxMsg(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:THDPrivilegeLease = null;
         var _loc7_:TTimeHero = null;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         this.FSelectBox.UnselectAll();
         this.FSelectBox.SetSelectByIndex(0);
         _loc3_ = this.CheckBox_Len;
         _loc6_ = this.FHDTimeHeroBins.GetDatebaseByIndex(0) as THDPrivilegeLease;
         _loc7_ = this.FTimeHeroBins.GetDatebaseByIdentifier(param1) as TTimeHero;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(_loc2_ == 0)
            {
               _loc4_ = _loc7_.TimeList[_loc2_] / this.CONST_Day;
               _loc5_ = _loc7_.OneDayCost;
            }
            else if(_loc2_ == 1)
            {
               _loc4_ = _loc7_.TimeList[_loc2_] / this.CONST_Day;
               _loc5_ = _loc7_.ThreeDayCost;
            }
            else if(_loc2_ == 2)
            {
               _loc4_ = _loc7_.TimeList[_loc2_] / this.CONST_Day;
               _loc5_ = _loc7_.SevenDayCost;
            }
            else
            {
               _loc4_ = _loc7_.TimeList[_loc2_] / this.CONST_Day;
               _loc5_ = _loc7_.ForeverCost - this.FHero.HeroCostGold;
            }
            this.FSelectBoxPriceList[_loc2_].text = _loc5_.toString();
            if(_loc4_ == 0)
            {
               this.FSelectBoxDayList[_loc2_].text = _loc6_.PromptLists[0];
            }
            else
            {
               this.FSelectBoxDayList[_loc2_].text = TUtilityString.Format(_loc6_.PromptLists[1],_loc4_);
            }
            _loc2_++;
         }
         this.FMC_BarSonGoldTF.text = (_loc7_.ForeverCost - this.FHero.HeroCostGold).toString();
         _loc8_ = this.FHero.HeroCostGold / _loc7_.ForeverCost;
         this.FMC_Bar.scaleX = _loc8_;
         if(_loc7_.ForeverCost <= this.FHero.HeroCostGold)
         {
            this.FIsBtnState = false;
         }
         else
         {
            this.FIsBtnState = true;
         }
         this.SetTimeOrButtonState();
      }
      
      private function SetTimeOrButtonState() : void
      {
         var _loc1_:Number = NaN;
         _loc1_ = this.FHero.HeroOverTime - STimingCore.ServerTick;
         _loc1_ = _loc1_ < 0 ? 0 : _loc1_;
         this.FCountDownTime.text = TUtilityTiming.fomatTimeTwo(_loc1_);
         this.FBtnRenewHero.Visible = false;
      }
      
      protected function ShowHeroHeadRender(param1:int) : void
      {
         this.FBitmap.bitmapData = null;
         SResourcesCore.TexturesHeadIcon.LoadAutoSecondary(param1,this.GetBitmapData);
      }
      
      protected function GetBitmapData(param1:Object, param2:TTexture, param3:int) : void
      {
         var _loc4_:int = 0;
         this.FBitmap.bitmapData = param2.GetAnimationSequenceByIndex(0).GetAnimationFrameByIndex(0).Surface;
         _loc4_ = int(this.FHero.Profession);
         this.FMCHead["mc_militaryType"].gotoAndStop(TUtilityLobby.GetStandPositionWithProfession(_loc4_));
      }
      
      protected function BtnCloseOnClick(param1:Object, param2:MouseEvent) : void
      {
         this.FStatus_SelectBoxStart = 0;
         ProcessorWindowClose();
      }
      
      protected function RenewHeroOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TPacket = null;
         _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Heros_RenewHeroReq);
         _loc3_.Data.writeInt(this.FSelectRenewHeroId);
         _loc3_.Data.writeInt(this.FStatus_SelectBoxStart);
         SNetworkCore.Transceiver.PacketTransmit(_loc3_);
      }
      
      protected function HeroHeadOnOver(param1:MouseEvent) : void
      {
         (this.FMCHead["mc_over"] as Sprite).visible = true;
      }
      
      protected function HeroHeadOnOut(param1:MouseEvent) : void
      {
         (this.FMCHead["mc_over"] as Sprite).visible = false;
      }
      
      public function ShowViewInfo(param1:THero) : void
      {
         this.FHero = param1;
         this.FSelectRenewHeroId = this.FHero.Identifier;
         this.SetCheckBoxMsg(param1.Identifier);
         this.ShowHeroHeadRender(param1.SmallID);
      }
      
      public function RefreshView(param1:int) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:TTimeHero = null;
         var _loc4_:int = 0;
         var _loc5_:Number = NaN;
         if(param1 == this.FSelectRenewHeroId)
         {
            _loc3_ = this.FTimeHeroBins.GetDatebaseByIdentifier(param1) as TTimeHero;
            this.FMC_BarSonGoldTF.text = (_loc3_.ForeverCost - this.FHero.HeroCostGold).toString();
            _loc2_ = this.FHero.HeroCostGold / _loc3_.ForeverCost;
            this.FMC_Bar.scaleX = _loc2_;
            if(_loc3_.ForeverCost <= this.FHero.HeroCostGold)
            {
               this.FIsBtnState = false;
            }
            else
            {
               this.FIsBtnState = true;
            }
            this.SetTimeOrButtonState();
            _loc4_ = _loc3_.ForeverCost - this.FHero.HeroCostGold;
            _loc4_ = _loc4_ <= 0 ? 0 : _loc4_;
            this.FSelectBoxPriceList[this.FSelectBoxPriceList.length - 1].text = _loc4_.toString();
         }
      }
   }
}

