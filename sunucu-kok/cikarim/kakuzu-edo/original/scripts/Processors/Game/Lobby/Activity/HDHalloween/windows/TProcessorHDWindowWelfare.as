package Processors.Game.Lobby.Activity.HDHalloween.windows
{
   import Components.Slots.TUISlot;
   import Components.Standard.*;
   import Externals.*;
   import Foundation.Resources.*;
   import Foundation.Timing.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.Agent.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.DatebaseVO.VO.Json.*;
   import Logics.HDActivityHalloween.TActivityHalloweenPayData;
   import Logics.HDActivityMode.*;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDActivitySoulBox.*;
   import Logics.Inventories.TInventories;
   import Logics.Streamization.HDActivityRecharge.*;
   import Processors.Game.Lobby.Activity.HDActivity.*;
   import Processors.Game.Lobby.Jade.TJadeCommon;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   import flash.utils.*;
   
   public class TProcessorHDWindowWelfare extends TUIComponent
   {
      
      protected static const DAYBAGPERDAY:uint = 3;
      
      protected static const PERSONALBAGNUM:uint = 5;
      
      protected static const RANDBAGNUM:uint = 6;
      
      protected var FMC_Scene:Sprite;
      
      protected var FBtn_GetPayBag:TUIButton;
      
      protected var FBtn_GetPay:TUIButton;
      
      protected var FBtn_BuyBag:TUIButton;
      
      protected var FBtn_GetPrise:TUIButton;
      
      protected var FSlots:Vector.<TUISlot>;
      
      protected var FSelectBox:Vector.<MovieClip>;
      
      protected var FSP_Finish1:Sprite;
      
      protected var FSP_Finish2:Sprite;
      
      protected var FMC_Effect_0:MovieClip;
      
      protected var FMC_Effect_1:MovieClip;
      
      protected var FBtn_Bag:TUIButton;
      
      protected var FTF_DayBuyNum:TextField;
      
      protected var FTF_DayOldPrice:TextField;
      
      protected var FTF_DayNowPrice:TextField;
      
      protected var FBtn_DayBuy:TUIButton;
      
      protected var FSP_DayAlreadyGet:Sprite;
      
      protected var FSP_Bag:TUIButton;
      
      protected var FTF_AllTotalNum:TextField;
      
      protected var FTF_AllNumCanGet:TextField;
      
      protected var FBtn_AllGet:TUIButton;
      
      protected var FSP_AllAlreadyGet:Sprite;
      
      protected var FBtn_PageLeft:TUIButton;
      
      protected var FBtn_PageRight:TUIButton;
      
      protected var FSP_AllBag:TUIButton;
      
      protected var FMC_AllBag:MovieClip;
      
      protected var FTF_PackageNum:TextField;
      
      protected var FTF_JoinNumVec:Vector.<TextField>;
      
      protected var FTF_PriceVec:Vector.<TextField>;
      
      protected var FBtn_PackageBuyVec:Vector.<TUIButton>;
      
      protected var FBtn_PackageGetVec:Vector.<TUIButton>;
      
      protected var FSP_PackageAlreadyGetVec:Vector.<Sprite>;
      
      protected var FSP_PackageBag:Vector.<TUIButton>;
      
      protected var CurPos:uint;
      
      protected var CurDay:uint;
      
      protected var FCurRandPos:uint;
      
      protected var FIsPlay:Boolean;
      
      protected var FIsPlayAnim:Boolean;
      
      protected var FIsGetRand:Boolean;
      
      protected var FSelectedPos:uint;
      
      protected var FHD_PayConfig:THDHalloweenPay;
      
      protected var FData_Pay:TActivityHalloweenPayData;
      
      protected var FAtoms:TActivityAtoms;
      
      protected var FOnGiftBoxMove:Function;
      
      protected var FOnGiftBoxOut:Function;
      
      protected var FActivityOperateReq:Function;
      
      public function TProcessorHDWindowWelfare(param1:TUIComponent, param2:Sprite)
      {
         super(param1);
         this.FHD_PayConfig = new THDHalloweenPay();
         this.CurPos = 0;
         this.CurDay = 0;
         this.FCurRandPos = 0;
         this.FIsPlay = false;
         this.FIsPlayAnim = false;
         this.FIsGetRand = false;
         this.FMC_Scene = param2;
         this.InitWindow();
      }
      
      protected function BuyBagRequest(param1:Object) : void
      {
         this.FActivityOperateReq(this.FAtoms.Identifier,SUtilityOverLayer.UIWindowConfirmation.Tag);
      }
      
      protected function InitWindow() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Sprite = null;
         var _loc4_:TUIButton = null;
         var _loc5_:TUISlot = null;
         this.FBtn_GetPayBag = new TUIButton();
         this.FBtn_GetPayBag.Substrate = this.FMC_Scene["MC_Barleft"]["MC_Bag"];
         this.FBtn_Bag = new TUIButton();
         this.FBtn_Bag.Substrate = this.FMC_Scene["MC_Barleft"]["Btn_Bag"];
         this.FBtn_Bag.Substrate.buttonMode = false;
         this.FBtn_Bag.OnMove = this.processorPayBagOnMove;
         this.FBtn_Bag.OnOut = this.processorPayBagOnMove;
         this.FBtn_GetPayBag.OnMove = this.processorPayBagOnMove;
         this.FBtn_GetPayBag.OnOut = this.processorPayBagOnMove;
         this.FBtn_GetPayBag.OnClick = this.ProcessorGetPayBag;
         this.FSP_Finish1 = this.FMC_Scene["MC_Barleft"]["MC_Finish_0"];
         this.FBtn_GetPay = new TUIButton();
         this.FBtn_GetPay.Substrate = this.FMC_Scene["MC_Barleft"]["Btn_OK"];
         this.FBtn_GetPay.OnClick = this.ProcessorGetPay;
         this.FSP_Finish2 = this.FMC_Scene["MC_Barleft"]["MC_Finish_1"];
         this.FSlots = new Vector.<TUISlot>(6);
         this.FSelectBox = new Vector.<MovieClip>(6);
         _loc2_ = 6;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc5_ = new TUISlot(this);
            _loc5_.Resource = this.FMC_Scene["MC_Barleft"]["MC_Slot_" + _loc1_]["Slot"];
            _loc5_.OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
            _loc5_.OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
            TJadeCommon.InitSlot(_loc5_);
            _loc5_.Init();
            this.FSlots[_loc1_] = _loc5_;
            this.FSelectBox[_loc1_] = this.FMC_Scene["MC_Barleft"]["MC_Slot_" + _loc1_]["SelectBox"];
            this.FSelectBox[_loc1_].mouseChildren = false;
            this.FSelectBox[_loc1_].mouseEnabled = false;
            _loc1_++;
         }
         this.FSP_Bag = new TUIButton();
         this.FSP_Bag.Substrate = this.FMC_Scene["MC_Barmid"]["MC_Bag"];
         this.FSP_Bag.Substrate.buttonMode = false;
         this.FSP_Bag.OnMove = this.processorDayBagOnMove;
         this.FSP_Bag.OnOut = this.processorDayBagOnMove;
         this.FTF_DayBuyNum = this.FMC_Scene["MC_Barmid"]["TF_CanBuy"];
         this.FTF_DayOldPrice = this.FMC_Scene["MC_Barmid"]["TF_OldPrice"];
         this.FTF_DayNowPrice = this.FMC_Scene["MC_Barmid"]["TF_NowPrice"];
         this.FBtn_DayBuy = new TUIButton();
         this.FBtn_DayBuy.Substrate = this.FMC_Scene["MC_Barmid"]["Btn_OK"];
         this.FBtn_DayBuy.OnClick = this.ProcessorDayBuy;
         this.FSP_DayAlreadyGet = this.FMC_Scene["MC_Barmid"]["MC_Finish"];
         this.FSP_AllBag = new TUIButton();
         this.FSP_AllBag.Substrate = this.FMC_Scene["MC_Barright"]["Btn_bag"];
         this.FSP_AllBag.OnMove = this.processorAllBagOnMove;
         this.FSP_AllBag.OnOut = this.processorAllBagOnMove;
         this.FSP_AllBag.Substrate.buttonMode = false;
         this.FMC_AllBag = this.FMC_Scene["MC_Barright"]["MC_bag"];
         this.FTF_AllTotalNum = this.FMC_Scene["MC_Barright"]["TF_TotalNum"];
         this.FTF_AllNumCanGet = this.FMC_Scene["MC_Barright"]["TF_NumCanGet"];
         this.FBtn_AllGet = new TUIButton();
         this.FBtn_AllGet.Substrate = this.FMC_Scene["MC_Barright"]["Btn_OK"];
         this.FBtn_AllGet.OnClick = this.ProcessorAllBuy;
         this.FSP_AllAlreadyGet = this.FMC_Scene["MC_Barright"]["MC_Finish"];
         this.FBtn_PageLeft = new TUIButton();
         this.FBtn_PageLeft.Substrate = this.FMC_Scene["MC_Barright"]["MC_PageLeft"];
         this.FBtn_PageLeft.OnClick = this.PrevPos;
         this.FBtn_PageRight = new TUIButton();
         this.FBtn_PageRight.Substrate = this.FMC_Scene["MC_Barright"]["MC_PageRight"];
         this.FBtn_PageRight.OnClick = this.NextPos;
         _loc2_ = int(PERSONALBAGNUM);
         this.FTF_PackageNum = new TextField();
         this.FTF_JoinNumVec = new Vector.<TextField>(_loc2_);
         this.FTF_PriceVec = new Vector.<TextField>(_loc2_);
         this.FBtn_PackageBuyVec = new Vector.<TUIButton>(_loc2_);
         this.FBtn_PackageGetVec = new Vector.<TUIButton>(_loc2_);
         this.FSP_PackageAlreadyGetVec = new Vector.<Sprite>(_loc2_);
         this.FSP_PackageBag = new Vector.<TUIButton>(_loc2_);
         this.FTF_PackageNum = this.FMC_Scene["MC_Barbottom"]["TF_PackageNum"];
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FTF_JoinNumVec[_loc1_] = this.FMC_Scene["MC_Barbottom"]["MC_Item_" + _loc1_]["TF_JoinNum"];
            this.FTF_PriceVec[_loc1_] = this.FMC_Scene["MC_Barbottom"]["MC_Item_" + _loc1_]["TF_Price"];
            _loc4_ = new TUIButton();
            _loc4_.Substrate = this.FMC_Scene["MC_Barbottom"]["MC_Item_" + _loc1_]["MC_Bag"];
            _loc4_.OnMove = this.processorRevBagOnMove;
            _loc4_.OnOut = this.processorRevBagOnMove;
            this.FSP_PackageBag[_loc1_] = _loc4_;
            _loc4_ = new TUIButton();
            _loc4_.Substrate = this.FMC_Scene["MC_Barbottom"]["MC_Item_" + _loc1_]["Btn_Buy"];
            _loc4_.OnClick = this.ProcessorPacketOnClick;
            this.FBtn_PackageBuyVec[_loc1_] = _loc4_;
            _loc4_ = new TUIButton();
            _loc4_.Substrate = this.FMC_Scene["MC_Barbottom"]["MC_Item_" + _loc1_]["Btn_Get"];
            _loc4_.OnClick = this.ProcessorPacketOnClick;
            this.FBtn_PackageGetVec[_loc1_] = _loc4_;
            this.FSP_PackageAlreadyGetVec[_loc1_] = this.FMC_Scene["MC_Barbottom"]["MC_Item_" + _loc1_]["MC_AlreadyGet"];
            _loc1_++;
         }
         this.FMC_Effect_0 = this.FMC_Scene["MC_Effect_1"];
         this.FMC_Effect_1 = this.FMC_Scene["MC_Barmid"]["MC_Effect_0"];
         if(this.FMC_Effect_0 != null)
         {
            this.FMC_Effect_0.play();
         }
         this.FMC_Effect_1.play();
      }
      
      protected function ProcessorAllBuy(param1:Object, param2:MouseEvent) : void
      {
         this.FActivityOperateReq(this.FAtoms.Identifier,this.FHD_PayConfig.AllServerBuyIndex[this.CurPos]);
      }
      
      protected function ProcessorPacketOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:uint = 0;
         _loc3_ = uint(param2.currentTarget.parent.name.split("_")[2]);
         if(this.FHD_PayConfig.PackageCond[_loc3_] > this.FData_Pay.RevBagNum)
         {
            SUtilityOverLayer.UIWindowConfirmation.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_06),this.FHD_PayConfig.PackageCost[_loc3_]);
            SUtilityOverLayer.UIWindowConfirmation.Visible = true;
            SUtilityOverLayer.UIWindowConfirmation.OnOK = this.BuyBagRequest;
            SUtilityOverLayer.UIWindowConfirmation.Tag = this.FHD_PayConfig.PackageIndex[_loc3_];
            return;
         }
         this.FActivityOperateReq(this.FAtoms.Identifier,this.FHD_PayConfig.PackageIndex[_loc3_]);
      }
      
      protected function ProcessorDayBuy(param1:Object, param2:MouseEvent) : void
      {
         SUtilityOverLayer.UIWindowConfirmation.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_06),this.FHD_PayConfig.LimitBuyNowPrice[this.FData_Pay.CurDay]);
         SUtilityOverLayer.UIWindowConfirmation.Visible = true;
         SUtilityOverLayer.UIWindowConfirmation.OnOK = this.BuyBagRequest;
         SUtilityOverLayer.UIWindowConfirmation.Tag = this.FHD_PayConfig.LimitBuyBtnIndex;
      }
      
      protected function ProcessorGetPayBag(param1:Object, param2:MouseEvent) : void
      {
         this.FActivityOperateReq(this.FAtoms.Identifier,this.FHD_PayConfig.PayIndex);
      }
      
      protected function ProcessorGetPay(param1:Object, param2:MouseEvent) : void
      {
         this.FIsPlay = true;
         this.FIsPlayAnim = true;
         this.FIsGetRand = true;
         this.FCurRandPos = 0;
      }
      
      private function processorAllBagOnMove(param1:Object, param2:MouseEvent) : void
      {
         if(param2.type == "mouseMove")
         {
            this.ShowTipOnMove(param1,this.FHD_PayConfig.AllServerBuyAwards[this.CurPos]);
         }
         else
         {
            this.HideTipOnOut(param1);
         }
      }
      
      protected function processorPayBagOnMove(param1:Object, param2:MouseEvent) : void
      {
         if(param2.type == "mouseMove")
         {
            this.ShowTipOnMove(param1,this.FHD_PayConfig.PayAwards[this.FData_Pay.CurDay]);
         }
         else
         {
            this.HideTipOnOut(param1);
         }
      }
      
      protected function processorRevBagOnMove(param1:Object, param2:MouseEvent) : void
      {
         if(param2.type == "mouseMove")
         {
            this.ShowTipOnMove(param1,this.FHD_PayConfig.PackageReceives[param2.currentTarget.parent.name.split("_")[2]]);
         }
         else
         {
            this.HideTipOnOut(param1);
         }
      }
      
      protected function processorDayBagOnMove(param1:Object, param2:MouseEvent) : void
      {
         if(param2.type == "mouseMove")
         {
            this.ShowTipOnMove(param1,this.FHD_PayConfig.LimitBuyAwards[this.FData_Pay.CurDay]);
         }
         else
         {
            this.HideTipOnOut(param1);
         }
      }
      
      protected function ShowTipOnMove(param1:Object, param2:uint) : void
      {
         var _loc3_:TInventories = null;
         _loc3_ = new TInventories();
         SToolReward.GetAwardsByAwardID(param2,_loc3_);
         if(this.FOnGiftBoxMove != null)
         {
            this.FOnGiftBoxMove(this,_loc3_);
         }
      }
      
      protected function HideTipOnOut(param1:Object) : void
      {
         if(this.FOnGiftBoxOut != null)
         {
            this.FOnGiftBoxOut(this);
         }
      }
      
      protected function PrevPos(param1:Object, param2:MouseEvent) : void
      {
         --this.CurPos;
         this.RenderRightBar();
      }
      
      protected function NextPos(param1:Object, param2:MouseEvent) : void
      {
         ++this.CurPos;
         this.RenderRightBar();
      }
      
      protected function RenderLeftBar() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TInventories = null;
         _loc3_ = this.FHD_PayConfig.FreeAwards[this.FData_Pay.CurDay];
         _loc2_ = _loc3_.Count;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FSlots[_loc1_].Context = _loc3_.GetInventoryByIndex(_loc1_);
            this.FSlots[_loc1_].Update();
            _loc1_++;
         }
         if(this.FData_Pay.PayBagStatus == 0)
         {
            this.FBtn_GetPayBag.Visible = true;
            this.FBtn_GetPayBag.Enabled = false;
            this.FSP_Finish2.visible = false;
         }
         else if(this.FData_Pay.PayBagStatus == -1)
         {
            this.FBtn_GetPayBag.Visible = false;
            this.FBtn_GetPayBag.Enabled = true;
            this.FSP_Finish2.visible = true;
         }
         else
         {
            this.FBtn_GetPayBag.Visible = true;
            this.FBtn_GetPayBag.Enabled = true;
            this.FSP_Finish2.visible = false;
         }
         if(this.FData_Pay.RandBagStatus == 0)
         {
            this.FBtn_GetPay.Visible = true;
            this.FBtn_GetPay.Enabled = false;
            this.FSP_Finish1.visible = false;
         }
         else if(this.FData_Pay.RandBagStatus == -1)
         {
            this.FBtn_GetPay.Visible = false;
            this.FBtn_GetPay.Enabled = true;
            this.FSP_Finish1.visible = true;
         }
         else
         {
            this.FBtn_GetPay.Visible = true;
            this.FBtn_GetPay.Enabled = true;
            this.FSP_Finish1.visible = false;
         }
      }
      
      protected function UpdatePropSlots() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc2_ = int(this.FSlots.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FSlots[_loc1_].Update();
            _loc1_++;
         }
      }
      
      protected function UpdateUI() : void
      {
         this.RenderLeftBar();
         this.RenderMidBar();
         this.RenderRightBar();
         this.RenderBottomBar();
      }
      
      protected function RenderBottomBar() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         this.FTF_PackageNum.text = this.FData_Pay.RevBagNum.toString();
         _loc2_ = int(PERSONALBAGNUM);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FTF_JoinNumVec[_loc1_].text = this.FHD_PayConfig.PackageCond[_loc1_].toString();
            this.FTF_PriceVec[_loc1_].text = this.FHD_PayConfig.PackageCost[_loc1_].toString();
            if(this.FHD_PayConfig.PackageCond[_loc1_] > this.FData_Pay.RevBagNum)
            {
               this.FBtn_PackageBuyVec[_loc1_].Visible = true;
               this.FBtn_PackageGetVec[_loc1_].Visible = false;
            }
            else
            {
               this.FBtn_PackageBuyVec[_loc1_].Visible = false;
               this.FBtn_PackageGetVec[_loc1_].Visible = true;
            }
            if(this.FData_Pay.RevBagStatus[_loc1_] == -1)
            {
               this.FSP_PackageAlreadyGetVec[_loc1_].visible = true;
               this.FBtn_PackageBuyVec[_loc1_].Visible = false;
               this.FBtn_PackageGetVec[_loc1_].Visible = false;
            }
            else
            {
               this.FSP_PackageAlreadyGetVec[_loc1_].visible = false;
            }
            _loc1_++;
         }
      }
      
      protected function RenderRightBar() : void
      {
         this.FBtn_PageLeft.Enabled = this.FBtn_PageRight.Enabled = true;
         if(this.CurPos == 0)
         {
            this.FBtn_PageLeft.Enabled = false;
         }
         if(this.CurPos == this.FHD_PayConfig.AllServerBuyIndex.length - 1)
         {
            this.FBtn_PageRight.Enabled = false;
         }
         this.FTF_AllTotalNum.text = this.FData_Pay.AllServerBagNum.toString();
         this.FTF_AllNumCanGet.text = this.FHD_PayConfig.AllServerBuyConds[this.CurPos].toString();
         if(this.FData_Pay.AllServerBagStatus[this.CurPos] != -1 && this.FData_Pay.AllServerBagNum >= this.FHD_PayConfig.AllServerBuyConds[this.CurPos])
         {
            this.FData_Pay.AllServerBagStatus[this.CurPos] = 1;
         }
         if(this.FData_Pay.AllServerBagStatus[this.CurPos] == -1)
         {
            this.FBtn_AllGet.Visible = false;
            this.FSP_AllAlreadyGet.visible = true;
         }
         if(this.FData_Pay.AllServerBagStatus[this.CurPos] == 0)
         {
            this.FBtn_AllGet.Visible = true;
            this.FBtn_AllGet.Enabled = false;
            this.FSP_AllAlreadyGet.visible = false;
         }
         if(this.FData_Pay.AllServerBagStatus[this.CurPos] == 1)
         {
            this.FBtn_AllGet.Visible = true;
            this.FBtn_AllGet.Enabled = true;
            this.FSP_AllAlreadyGet.visible = false;
         }
         this.FMC_AllBag.gotoAndStop(this.CurPos + 1);
      }
      
      protected function RenderMidBar() : void
      {
         this.FTF_DayBuyNum.text = (DAYBAGPERDAY - this.FData_Pay.DayBagStatus).toString();
         if(this.FData_Pay.DayBagStatus < DAYBAGPERDAY)
         {
            this.FBtn_DayBuy.Visible = true;
            this.FSP_DayAlreadyGet.visible = false;
         }
         else
         {
            this.FBtn_DayBuy.Visible = false;
            this.FSP_DayAlreadyGet.visible = true;
         }
         this.FTF_DayNowPrice.text = this.FHD_PayConfig.LimitBuyNowPrice[this.FData_Pay.CurDay].toString();
         this.FTF_DayOldPrice.text = this.FHD_PayConfig.LimitBuyOldPrice[this.FData_Pay.CurDay].toString();
      }
      
      protected function Reset() : void
      {
      }
      
      protected function ShowAni(param1:Boolean) : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         if(param1 == false)
         {
            return;
         }
         if(this.FCurRandPos >= RANDBAGNUM)
         {
            this.FIsPlayAnim = false;
            this.FActivityOperateReq(this.FAtoms.Identifier,this.FHD_PayConfig.GetPayIndex);
            return;
         }
         _loc2_ = this.FSelectBox[this.FCurRandPos];
         _loc2_.play();
         if(_loc2_.currentFrame == _loc2_.totalFrames && this.FCurRandPos < RANDBAGNUM)
         {
            ++this.FCurRandPos;
         }
      }
      
      public function set PayConfig(param1:THDHalloweenPay) : void
      {
         this.FHD_PayConfig = param1;
      }
      
      public function get OnGiftBoxMove() : Function
      {
         return this.FOnGiftBoxMove;
      }
      
      public function set OnGiftBoxMove(param1:Function) : void
      {
         this.FOnGiftBoxMove = param1;
      }
      
      public function get OnGiftBoxOut() : Function
      {
         return this.FOnGiftBoxOut;
      }
      
      public function set OnGiftBoxOut(param1:Function) : void
      {
         this.FOnGiftBoxOut = param1;
      }
      
      public function set Data_Pay(param1:TActivityHalloweenPayData) : void
      {
         this.FData_Pay = param1;
      }
      
      public function set ActivityOperateReq(param1:Function) : void
      {
         this.FActivityOperateReq = param1;
      }
      
      public function Show(param1:TActivityAtoms = null, param2:THDActivityBase = null, param3:TActivityOSBase = null) : void
      {
         this.FAtoms = param1 as TActivityAtoms;
         this.FHD_PayConfig = param2 as THDHalloweenPay;
         this.FData_Pay = param3 as TActivityHalloweenPayData;
         this.UpdateUI();
      }
      
      public function LogicsPerform() : void
      {
         if(this.visible)
         {
            this.UpdatePropSlots();
            if(!this.FIsPlayAnim)
            {
               return;
            }
            this.ShowAni(this.FIsPlay);
         }
      }
      
      public function OperateRet(param1:Vector.<TFixedAward>) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         if(this.FIsGetRand)
         {
            _loc4_ = param1[0].Code;
            this.FSelectedPos = this.FHD_PayConfig.FreeAwardsPos.indexOf(_loc4_,this.FData_Pay.CurDay * RANDBAGNUM) % RANDBAGNUM;
            if(this.FSelectedPos < 0 || this.FSelectedPos > RANDBAGNUM - 1)
            {
               this.FIsGetRand = false;
               return;
            }
            this.FSelectBox[this.FSelectedPos].gotoAndStop(2);
            this.FIsGetRand = false;
         }
      }
   }
}

