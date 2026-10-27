package Processors.Game.Lobby.CrashJade
{
   import Components.ScrollBar.*;
   import Components.Slots.*;
   import Components.Standard.*;
   import Foundation.Common.*;
   import Foundation.Movements.*;
   import Foundation.Network.*;
   import Foundation.Queries.TQueryUInt;
   import Foundation.Resources.*;
   import Foundation.Timing.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.BleachAgent.TBleachAgentData;
   import Logics.CrashJade.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.Inventories.*;
   import Logics.Log.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Jade.*;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.EffectTextReward.*;
   import Processors.Game.Utilities.OverLayer.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   import ghostcat.util.data.*;
   
   public class TProcessorWindowMakeJade extends TProcessorLobbyWindow
   {
      
      protected static const BTN_NUM:int = 5;
      
      protected static const SLOT_NUM:int = 39;
      
      protected static const HighLevelPostion:int = 3;
      
      protected static const FlyBlankTime:int = 60;
      
      protected static const FlyTime:int = 500;
      
      protected static const BtnMakeJadeOneKey_X:int = 848;
      
      protected static const BtnMakeJadeOneKey_Y:int = 214;
      
      protected static const BtnEquipJade_X:int = 952;
      
      protected static const BtnEquipJade_Y:int = 214;
      
      protected static const FlyMode_OneKeyMakeJade:int = 0;
      
      protected static const FlyMode_SingleMakeJade:int = 1;
      
      protected static const FlyMode_OneKeyPickUp:int = 2;
      
      protected static const FlyMode_SinglePickUp:int = 3;
      
      protected var FMainUI:Sprite;
      
      protected var FButtons:Vector.<TUIButton>;
      
      protected var FEffects:Vector.<MovieClip>;
      
      protected var FHint:THint;
      
      protected var FBtnOpenDirect:TUIButton;
      
      protected var FTFLastTime:TextField;
      
      protected var FBtnAddTime:TUIButton;
      
      protected var FMakeJadeOneKey:TUIButton;
      
      protected var FBtnEquipJade:TUIButton;
      
      protected var FBtnPickUpOneKey:TUIButton;
      
      protected var FBtnSellOneKey:TUIButton;
      
      protected var FBtnClose:TUIButton;
      
      protected var FShopBtn:TUIButton;
      
      protected var FTFDes:TextField;
      
      protected var FTFSiliverCoin:TextField;
      
      protected var FTFGoldCoin:TextField;
      
      protected var FTFGiftCoin:TextField;
      
      protected var FTFChipNum:TextField;
      
      protected var FTFShopCoin:TextField;
      
      protected var FSlots:Vector.<TUISlot>;
      
      protected var FPickUpShort:Vector.<TUIButton>;
      
      protected var FSellShort:Vector.<TUIButton>;
      
      protected var FPickUpLong:Vector.<TUIButton>;
      
      protected var FSellLong:Vector.<TUIButton>;
      
      protected var FScroolBar:TScrollBar;
      
      protected var FFlyIndex:Vector.<int>;
      
      protected var FFlyStartTime:Vector.<uint>;
      
      protected var FMovementLinears:Vector.<TMovementLinear>;
      
      protected var FSlotX:Vector.<int>;
      
      protected var FSlotY:Vector.<int>;
      
      protected var FBtnMakeJadeX:Vector.<int>;
      
      protected var FBtnMakeJadeY:Vector.<int>;
      
      protected var FFlyMode:int;
      
      protected var FFlying:Boolean;
      
      protected var FFlyStartIndex:int;
      
      protected var FCurrentJadeNum:int;
      
      protected var FOpenHighLevelCost:Vector.<uint>;
      
      protected var FBuyMakeJadeTimeCost:Vector.<uint>;
      
      protected var FBuyTimeAboutVip:Vector.<uint>;
      
      protected var FInitialTime:int;
      
      protected var FOpenAward:Vector.<Object>;
      
      protected var FShowDirectlyOpen:Boolean = true;
      
      protected var FBAData:TBleachAgentData = SLogicsCore.BleachAgentData;
      
      protected var FCrashJadeData:TCrashJadeData;
      
      protected var FOnEquipJade:Function;
      
      protected var FOnClickBtnClose:Function;
      
      protected var FOnShop:Function;
      
      public function TProcessorWindowMakeJade(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:int = 0;
         var _loc2_:TUIButton = null;
         var _loc3_:TUISlot = null;
         var _loc4_:Sprite = null;
         var _loc5_:MovieClip = null;
         var _loc6_:TConfigValue = null;
         this.FMainUI = TUtilityReflection.CreateDisplayObjectInstance("MakeJadeUI") as Sprite;
         addChild(this.FMainUI);
         this.FButtons = new Vector.<TUIButton>();
         this.FEffects = new Vector.<MovieClip>();
         this.FBtnMakeJadeX = new Vector.<int>();
         this.FBtnMakeJadeY = new Vector.<int>();
         _loc1_ = 0;
         while(_loc1_ < BTN_NUM)
         {
            _loc5_ = this.FMainUI["Btn" + _loc1_];
            this.FBtnMakeJadeX.push(_loc5_.x);
            this.FBtnMakeJadeY.push(_loc5_.y);
            _loc5_ = _loc5_["Btn"];
            _loc2_ = new TUIButton();
            _loc2_.Substrate = _loc5_;
            _loc2_.OnClick = this.BtnMakeJadeOnClick;
            _loc2_.OnMove = this.BtnMakeJadeOnMove;
            _loc2_.OnOut = this.BtnOnOut;
            this.FButtons.push(_loc2_);
            this.FEffects.push(this.FMainUI["Effect" + _loc1_]);
            _loc1_++;
         }
         this.FTFDes = this.FMainUI["TFDes"];
         this.FBtnOpenDirect = new TUIButton();
         this.FBtnOpenDirect.Substrate = this.FMainUI["MC_RefreshBT"];
         this.FBtnOpenDirect.OnClick = this.BtnOpenDirectOnClick;
         this.FBtnOpenDirect.OnMove = this.BtnOpenDirectOnMove;
         this.FBtnOpenDirect.OnOut = this.BtnOnOut;
         this.FTFLastTime = this.FMainUI["LastTime"];
         this.FBtnAddTime = new TUIButton();
         this.FBtnAddTime.Substrate = this.FMainUI["BtnAddTime"];
         this.FBtnAddTime.OnClick = this.BtnBuyTimeOnClick;
         this.FBtnAddTime.OnMove = this.BtnBuyTimeOnMove;
         this.FBtnAddTime.OnOut = this.BtnOnOut;
         this.FMakeJadeOneKey = new TUIButton();
         this.FMakeJadeOneKey.Substrate = this.FMainUI["BtnOneKey"]["Btn"];
         this.FMakeJadeOneKey.OnClick = this.BtnMakeJadeOneKeyOnClick;
         this.FBtnEquipJade = new TUIButton();
         this.FBtnEquipJade.Substrate = this.FMainUI["BtnEquipJade"]["Btn"];
         this.FBtnEquipJade.OnClick = this.BtnEquipJadeOnClick;
         this.FBtnPickUpOneKey = new TUIButton();
         this.FBtnPickUpOneKey.Substrate = this.FMainUI["BtnPickUpOneKey"];
         this.FBtnPickUpOneKey.OnClick = this.BtnPickUpOneKeyOnClick;
         this.FBtnPickUpOneKey.OnMove = this.BtnPickUpOneKeyOnMove;
         this.FBtnPickUpOneKey.OnOut = this.BtnOnOut;
         this.FBtnSellOneKey = new TUIButton();
         this.FBtnSellOneKey.Substrate = this.FMainUI["BtnSellOneKey"];
         this.FBtnSellOneKey.OnClick = this.BtnSellOneKeyOnClick;
         this.FBtnSellOneKey.OnMove = this.BtnSellOneKeyOnMove;
         this.FBtnSellOneKey.OnOut = this.BtnOnOut;
         this.FBtnClose = new TUIButton();
         this.FBtnClose.Substrate = this.FMainUI["btn_close"];
         this.FBtnClose.OnClick = this.BtnCloseOnClick;
         this.FShopBtn = new TUIButton();
         this.FShopBtn.Substrate = this.FMainUI["Btn_Shop"];
         this.FShopBtn.OnClick = this.OnShopBtnClick;
         this.FTFSiliverCoin = this.FMainUI["SP_PanelCredits"]["TF_SilverCoin"];
         this.FTFGoldCoin = this.FMainUI["SP_PanelCredits"]["TF_Gold"];
         this.FTFGiftCoin = this.FMainUI["SP_PanelCredits"]["TF_GiftCertificate"];
         this.FTFChipNum = this.FMainUI["ChipNum"];
         this.FTFShopCoin = this.FMainUI["TF_ShopCoin"];
         this.FHint = new THint();
         this.FSlots = new Vector.<TUISlot>();
         this.FPickUpShort = new Vector.<TUIButton>();
         this.FSellShort = new Vector.<TUIButton>();
         this.FPickUpLong = new Vector.<TUIButton>();
         this.FSellLong = new Vector.<TUIButton>();
         this.FSlotX = new Vector.<int>();
         this.FSlotY = new Vector.<int>();
         _loc1_ = 0;
         while(_loc1_ < SLOT_NUM)
         {
            _loc4_ = this.FMainUI["Slot" + _loc1_];
            _loc3_ = new TUISlot(this);
            _loc3_.Resource = _loc4_;
            TJadeCommon.InitSlot(_loc3_);
            _loc3_.OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
            _loc3_.OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
            _loc3_.Init();
            _loc3_.OnQueryEdgeColor = this.SlotsOnQueryEdgeColor;
            this.FSlots.push(_loc3_);
            this.FSlotX.push(_loc4_.x);
            this.FSlotY.push(_loc4_.y);
            _loc2_ = new TUIButton();
            _loc2_.Substrate = _loc4_["PickUpShort"];
            _loc2_.OnClick = this.BtnPickUpShortOnClick;
            this.FPickUpShort.push(_loc2_);
            _loc2_ = new TUIButton();
            _loc2_.Substrate = _loc4_["SellShort"];
            _loc2_.OnClick = this.BtnSellShortOnClick;
            this.FSellShort.push(_loc2_);
            _loc2_ = new TUIButton();
            _loc2_.Substrate = _loc4_["PickUpLong"];
            _loc2_.OnClick = this.BtnPickUpLongOnClick;
            this.FPickUpLong.push(_loc2_);
            _loc2_ = new TUIButton();
            _loc2_.Substrate = _loc4_["SellLong"];
            _loc2_.OnClick = this.BtnSellLongOnClick;
            this.FSellLong.push(_loc2_);
            _loc1_++;
         }
         this.FFlyIndex = new Vector.<int>();
         this.FFlyStartTime = new Vector.<uint>();
         this.FMovementLinears = new Vector.<TMovementLinear>();
         _loc1_ = 0;
         while(_loc1_ < SLOT_NUM)
         {
            this.FMovementLinears.push(new TMovementLinear());
            this.FFlyStartTime.push(0);
            _loc1_++;
         }
         this.FScroolBar = new TScrollBar(this.FMainUI["Scrool"]["mc_list"],211);
         _loc6_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.CrashJade_JumpOpenCost) as TConfigValue;
         this.FOpenHighLevelCost = _loc6_.Value as Vector.<uint>;
         _loc6_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.CrashJade_MaxBuyNum) as TConfigValue;
         this.FBuyMakeJadeTimeCost = _loc6_.Value as Vector.<uint>;
         _loc6_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.CrashJade_LimitVip) as TConfigValue;
         this.FBuyTimeAboutVip = _loc6_.Value as Vector.<uint>;
         _loc6_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.CrashJade_OpenHighLevel) as TConfigValue;
         this.FInitialTime = _loc6_.Value as uint;
         _loc6_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.CrashedJade_OpenAward) as TConfigValue;
         this.FOpenAward = Vector.<Object>(_loc6_.Value);
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         super.ResourcesPerform_UILocations();
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(Visible)
         {
            this.UpdateAnimation();
            this.UpdateBackapackSlot();
         }
      }
      
      protected function RenderingBaseInfor() : void
      {
         var _loc1_:int = 0;
         var _loc2_:uint = 0;
         _loc1_ = 0;
         while(_loc1_ < BTN_NUM)
         {
            _loc2_ = uint(1 << _loc1_);
            this.FButtons[_loc1_].Enabled = (_loc2_ & this.FCrashJadeData.MakeJadeFlag) != 0;
            if(this.FButtons[_loc1_].Enabled)
            {
               this.FEffects[_loc1_].play();
               this.FEffects[_loc1_].visible = true;
            }
            else
            {
               this.FEffects[_loc1_].stop();
               this.FEffects[_loc1_].visible = false;
            }
            _loc1_++;
         }
         this.FTFLastTime.text = (this.FInitialTime * (this.FCrashJadeData.BuyTime + 1) - this.FCrashJadeData.MakeJadeTime).toString();
         _loc2_ = uint(1 << HighLevelPostion);
         this.FBtnOpenDirect.Enabled = (_loc2_ & this.FCrashJadeData.MakeJadeFlag) == 0;
         this.FTFSiliverCoin.text = SLogicsCore.Character.CreditSilverCoin.ToString();
         this.FTFGoldCoin.text = SLogicsCore.Character.CreditGold.toString();
         this.FTFGiftCoin.text = SLogicsCore.Character.CreditGiftCertificate.toString();
         this.FTFChipNum.text = this.FCrashJadeData.ChipNum.toString();
         this.FTFShopCoin.text = this.FCrashJadeData.ShopCoinCount.toString();
         this.FTFDes.text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_CrashJade_31);
      }
      
      protected function RenderingBackPack() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TCrashJade = null;
         var _loc4_:TUISlot = null;
         var _loc5_:TInventories = null;
         _loc5_ = SLogicsCore.Character.CrashJadeTemporary;
         _loc2_ = _loc5_.Count;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = _loc5_.GetInventoryByIndex(_loc1_) as TCrashJade;
            this.FSlots[_loc1_].Context = _loc3_;
            this.FSlots[_loc1_].TextureAdvancedEffect = SResourcesCore.TexturesLobby.GetTextureByIdentifier(_loc3_.EffectID);
            this.FSlots[_loc1_].Resource.visible = true;
            this.FSlots[_loc1_].Resource.x = this.FSlotX[_loc1_];
            this.FSlots[_loc1_].Resource.y = this.FSlotY[_loc1_];
            this.FPickUpShort[_loc1_].Visible = false;
            this.FSellShort[_loc1_].Visible = false;
            this.FPickUpLong[_loc1_].Visible = false;
            this.FSellLong[_loc1_].Visible = false;
            switch(_loc3_.Quality)
            {
               case CONST_CRASHJADE.QualityGray:
                  this.FSellLong[_loc1_].Visible = true;
                  break;
               case CONST_CRASHJADE.QualityRed:
                  this.FPickUpLong[_loc1_].Visible = true;
                  break;
               default:
                  this.FPickUpShort[_loc1_].Visible = true;
                  this.FSellShort[_loc1_].Visible = true;
            }
            _loc1_++;
         }
         _loc1_ = _loc1_;
         while(_loc1_ < SLOT_NUM)
         {
            this.FSlots[_loc1_].Resource.visible = false;
            this.FSlots[_loc1_].Context = null;
            _loc1_++;
         }
      }
      
      protected function RenderingLog(param1:Vector.<TLog>) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Sprite = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:TArticle = null;
         var _loc9_:Object = null;
         var _loc10_:TLog = null;
         this.FScroolBar.Clear();
         _loc3_ = int(param1.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = TUtilityReflection.CreateDisplayObjectInstance("CrashJadeLogItem") as Sprite;
            this.FScroolBar.AddItem(_loc4_);
            _loc10_ = param1[_loc2_];
            _loc9_ = Json.decode(_loc10_.Data);
            _loc5_ = _loc9_.cJadePos as int;
            _loc6_ = _loc9_.nJadeId as int;
            _loc7_ = _loc9_.nQuality as int;
            _loc8_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_Article,_loc6_) as TArticle;
            _loc4_["Lable"].htmlText = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_CrashJade_18),CONST_COMMON.TextColor[_loc7_],_loc10_.Name,_loc5_,CONST_COMMON.TextColor[_loc8_.Quality],_loc8_.Name);
            _loc2_++;
         }
      }
      
      protected function SetupFly(param1:int, param2:int = 0) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TInventories = null;
         var _loc7_:uint = 0;
         var _loc8_:TMovementLinear = null;
         _loc7_ = uint(STimingCore.TickCount);
         _loc6_ = SLogicsCore.Character.CrashJadeTemporary;
         this.FFlyMode = param1;
         this.FFlyIndex.length = 0;
         switch(param1)
         {
            case FlyMode_OneKeyMakeJade:
               _loc4_ = _loc6_.Count;
               _loc3_ = this.FCurrentJadeNum;
               while(_loc3_ < _loc4_)
               {
                  this.FFlyIndex.push(_loc3_);
                  _loc8_ = this.FMovementLinears[_loc3_];
                  _loc8_.SetupSegmentByDuration(this.FSlotX[_loc3_],this.FSlotY[_loc3_],BtnMakeJadeOneKey_X,BtnMakeJadeOneKey_Y,FlyTime);
                  this.FSlots[_loc3_].Resource.visible = false;
                  this.FFlyStartTime[_loc3_] = _loc7_;
                  _loc7_ += FlyBlankTime;
                  _loc3_++;
               }
               break;
            case FlyMode_SingleMakeJade:
               this.FFlyIndex.push(this.FCurrentJadeNum);
               _loc8_ = this.FMovementLinears[this.FCurrentJadeNum];
               _loc8_.SetupSegmentByDuration(this.FSlotX[this.FCurrentJadeNum],this.FSlotY[this.FCurrentJadeNum],this.FBtnMakeJadeX[param2],this.FBtnMakeJadeY[param2],FlyTime);
               this.FFlyStartTime[this.FCurrentJadeNum] = _loc7_;
               this.FSlots[this.FCurrentJadeNum].Resource.visible = false;
               break;
            case FlyMode_OneKeyPickUp:
               _loc4_ = int(this.FCrashJadeData.IDHigh.length);
               _loc3_ = 0;
               while(_loc3_ < _loc4_)
               {
                  _loc5_ = this.GetIndexByID(this.FCrashJadeData.IDHigh[_loc3_],this.FCrashJadeData.IDLow[_loc3_]);
                  this.FFlyIndex.push(_loc5_);
                  _loc8_ = this.FMovementLinears[_loc5_];
                  _loc8_.SetupSegmentByDuration(BtnEquipJade_X,BtnEquipJade_Y,this.FSlotX[_loc5_],this.FSlotY[_loc5_],FlyTime);
                  this.FFlyStartTime[_loc5_] = _loc7_;
                  _loc7_ += FlyBlankTime;
                  _loc3_++;
               }
               break;
            case FlyMode_SinglePickUp:
               this.FFlyIndex.push(param2);
               _loc8_ = this.FMovementLinears[param2];
               _loc8_.SetupSegmentByDuration(BtnEquipJade_X,BtnEquipJade_Y,this.FSlotX[param2],this.FSlotY[param2],FlyTime);
               this.FFlyStartTime[param2] = _loc7_;
         }
         this.FFlying = true;
      }
      
      protected function UpdateAnimation() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TMovementLinear = null;
         var _loc5_:uint = 0;
         var _loc6_:int = 0;
         if(!this.FFlying)
         {
            return;
         }
         _loc5_ = uint(STimingCore.TickCount);
         this.FFlying = false;
         _loc2_ = int(this.FFlyIndex.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FFlyIndex[_loc1_];
            _loc4_ = this.FMovementLinears[_loc3_];
            if(!_loc4_.MoveOver)
            {
               _loc6_ = _loc5_ - this.FFlyStartTime[_loc3_];
               if(_loc6_ >= 0)
               {
                  _loc4_.Move(_loc6_);
                  this.FSlots[_loc3_].Resource.x = _loc4_.X;
                  this.FSlots[_loc3_].Resource.y = _loc4_.Y;
                  this.FSlots[_loc3_].Resource.visible = true;
               }
               this.FFlying = true;
            }
            else if(this.FFlyMode == FlyMode_SinglePickUp || this.FFlyMode == FlyMode_OneKeyPickUp)
            {
               if(this.FSlots[_loc3_].Resource.visible)
               {
                  this.FSlots[_loc3_].Resource.visible = false;
               }
            }
            _loc1_++;
         }
         if(!this.FFlying)
         {
            this.RenderingBackPack();
            this.UnlockUI();
            this.FCurrentJadeNum = SLogicsCore.Character.CrashJadeTemporary.Count;
         }
      }
      
      protected function UpdateBackapackSlot() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TUISlot = null;
         var _loc4_:TInventories = null;
         _loc4_ = SLogicsCore.Character.CrashJadeTemporary;
         _loc2_ = _loc4_.Count;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FSlots[_loc1_];
            _loc3_.Update();
            _loc1_++;
         }
      }
      
      protected function GetIndexByID(param1:uint, param2:uint) : int
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:TInventory = null;
         var _loc6_:TInventories = null;
         _loc6_ = SLogicsCore.Character.CrashJadeTemporary;
         _loc4_ = _loc6_.Count;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc5_ = _loc6_.GetInventoryByIndex(_loc3_);
            if(_loc5_.Identifier0 == param1 && _loc5_.Identifier1 == param2)
            {
               return _loc3_;
            }
            _loc3_++;
         }
         return -1;
      }
      
      protected function OpenHighLevelMakeJadeReq(param1:Object) : void
      {
         var _loc2_:TPacket = null;
         if(this.FShowDirectlyOpen)
         {
            this.FShowDirectlyOpen = !SUtilityOverLayer.UIWindowConfirmation.IsSelected;
         }
         if(TProcessorCrashJade.Busy)
         {
            return;
         }
         TProcessorCrashJade.Busy = true;
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_CrashJade_OpenHighLevelReq);
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
      }
      
      protected function BuyMakeJadeTimeReq(param1:Object) : void
      {
         var _loc2_:TPacket = null;
         if(TProcessorCrashJade.Busy)
         {
            return;
         }
         TProcessorCrashJade.Busy = true;
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_CrashJade_BuyTimeReq);
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
      }
      
      protected function SlotsOnQueryEdgeColor(param1:Object, param2:Object, param3:TQueryUInt) : void
      {
         var _loc4_:TCrashJade = null;
         if(param2 is TCrashJade)
         {
            _loc4_ = param2 as TCrashJade;
            param3.Value = 1;
         }
      }
      
      protected function BtnMakeJadeOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:TPacket = null;
         var _loc5_:int = 0;
         var _loc6_:TCrashJadeKind = null;
         var _loc7_:int = 0;
         _loc3_ = this.FButtons.indexOf(param1 as TUIButton);
         _loc6_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_DailyCrashJadeKind,_loc3_ + 1) as TCrashJadeKind;
         _loc7_ = _loc6_.CostSiliver;
         if(_loc7_ > SLogicsCore.Character.CreditSilverCoin.ToNumber())
         {
            SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_CrashJade_23));
            return;
         }
         _loc5_ = this.FInitialTime * (this.FCrashJadeData.BuyTime + 1) - this.FCrashJadeData.MakeJadeTime;
         if(_loc5_ <= 0)
         {
            SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_CrashJade_21));
            return;
         }
         if(TProcessorCrashJade.Busy)
         {
            return;
         }
         TProcessorCrashJade.Busy = true;
         _loc4_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_CrashJade_MakeJadeReq);
         _loc4_.Data.writeByte(_loc3_ + 1);
         SNetworkCore.Transceiver.PacketTransmit(_loc4_);
      }
      
      protected function BtnMakeJadeOnMove(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:TCrashJadeKind = null;
         var _loc5_:int = 0;
         _loc3_ = this.FButtons.indexOf(param1 as TUIButton);
         _loc4_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_DailyCrashJadeKind,_loc3_ + 1) as TCrashJadeKind;
         _loc5_ = _loc4_.CostSiliver;
         this.FHint.Caption = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_CrashJade_15),_loc5_);
         SUtilityOverLayer.UIComponentsHintOnOver(this,this.FHint);
      }
      
      protected function BtnOnOut(param1:Object, param2:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOut(this,this.FHint);
      }
      
      protected function BtnOpenDirectOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         if(this.FBAData.GetWelfareCountByType(this.FBAData.WelfareType_JadeOpenFreeCount) > 0)
         {
            this.OpenHighLevelMakeJadeReq(null);
         }
         else if(!this.FShowDirectlyOpen)
         {
            this.OpenHighLevelMakeJadeReq(null);
         }
         else
         {
            _loc3_ = this.FCrashJadeData.HightLevelMakeJadeTime >= this.FOpenHighLevelCost.length ? int(this.FOpenHighLevelCost[this.FOpenHighLevelCost.length - 1]) : int(this.FOpenHighLevelCost[this.FCrashJadeData.HightLevelMakeJadeTime]);
            SUtilityOverLayer.UIWindowConfirmation.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_CrashJade_14),_loc3_);
            SUtilityOverLayer.UIWindowConfirmation.Visible = true;
            SUtilityOverLayer.UIWindowConfirmation.OnOK = this.OpenHighLevelMakeJadeReq;
            SUtilityOverLayer.UIWindowConfirmation.SetCheckBoxUsable(true);
         }
      }
      
      protected function BtnOpenDirectOnMove(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:String = null;
         _loc4_ = SToolReward.GetNameByTypeCode(this.FOpenAward[0].type,this.FOpenAward[0].code) + "x" + this.FOpenAward[0].amount;
         _loc5_ = SToolReward.GetNameByTypeCode(this.FOpenAward[1].type,this.FOpenAward[1].code) + "x" + this.FOpenAward[1].amount;
         if(this.FBAData.GetWelfareCountByType(this.FBAData.WelfareType_JadeOpenFreeCount) > 0)
         {
            this.FHint.Caption = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_BleachAgent_04),_loc4_,_loc5_);
         }
         else
         {
            _loc3_ = this.FCrashJadeData.HightLevelMakeJadeTime >= this.FOpenHighLevelCost.length ? int(this.FOpenHighLevelCost[this.FOpenHighLevelCost.length - 1]) : int(this.FOpenHighLevelCost[this.FCrashJadeData.HightLevelMakeJadeTime]);
            this.FHint.Caption = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_CrashJade_38),_loc3_,_loc4_,_loc5_);
         }
         SUtilityOverLayer.UIComponentsHintOnOver(this,this.FHint);
      }
      
      protected function BtnBuyTimeOnMove(param1:Object, param2:MouseEvent) : void
      {
         this.FHint.Caption = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_CrashJade_26),this.FInitialTime,this.FBuyTimeAboutVip[0],this.FBuyTimeAboutVip[1],this.FBuyTimeAboutVip[2],this.FBuyTimeAboutVip[3],this.FBuyTimeAboutVip[4],this.FBuyTimeAboutVip[5],this.FBuyTimeAboutVip[6],this.FBuyTimeAboutVip[7],this.FBuyTimeAboutVip[8],this.FBuyTimeAboutVip[9],this.FBuyTimeAboutVip[10]);
         SUtilityOverLayer.UIComponentsHintOnOver(this,this.FHint);
      }
      
      protected function BtnBuyTimeOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _loc3_ = int(this.FBuyTimeAboutVip[SLogicsCore.Character.VipLevel]);
         if(this.FCrashJadeData.BuyTime >= _loc3_)
         {
            SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_CrashJade_17));
            return;
         }
         _loc4_ = SLogicsCore.Character.CreditGiftCertificate + SLogicsCore.Character.CreditGold;
         if(this.FBuyMakeJadeTimeCost[this.FCrashJadeData.BuyTime] > _loc4_)
         {
            SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_CrashJade_24));
            return;
         }
         SUtilityOverLayer.UIWindowConfirmation.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_CrashJade_16),this.FBuyMakeJadeTimeCost[this.FCrashJadeData.BuyTime],this.FInitialTime);
         SUtilityOverLayer.UIWindowConfirmation.Visible = true;
         SUtilityOverLayer.UIWindowConfirmation.OnOK = this.BuyMakeJadeTimeReq;
         SUtilityOverLayer.UIWindowConfirmation.SetCheckBoxUsable(false);
      }
      
      protected function BtnMakeJadeOneKeyOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TPacket = null;
         var _loc4_:int = 0;
         _loc4_ = this.FInitialTime * (this.FCrashJadeData.BuyTime + 1) - this.FCrashJadeData.MakeJadeTime;
         if(_loc4_ <= 0)
         {
            SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_CrashJade_21));
            return;
         }
         if(SLogicsCore.Character.CrashJadeTemporary.Count == this.FSlots.length)
         {
            SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_CrashJade_36));
            return;
         }
         if(TProcessorCrashJade.Busy)
         {
            return;
         }
         TProcessorCrashJade.Busy = true;
         _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_CrashJade_MakeJadeOneKeyReq);
         SNetworkCore.Transceiver.PacketTransmit(_loc3_);
      }
      
      protected function BtnEquipJadeOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FOnEquipJade != null)
         {
            this.FOnEquipJade(this);
         }
      }
      
      protected function BtnPickUpOneKeyOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TPacket = null;
         if(TProcessorCrashJade.Busy)
         {
            return;
         }
         TProcessorCrashJade.Busy = true;
         _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_CrashJade_PickUpOneKeyReq);
         SNetworkCore.Transceiver.PacketTransmit(_loc3_);
      }
      
      protected function BtnPickUpOneKeyOnMove(param1:Object, param2:MouseEvent) : void
      {
         this.FHint.Caption = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_CrashJade_30);
         SUtilityOverLayer.UIComponentsHintOnOver(this,this.FHint);
      }
      
      protected function BtnSellOneKeyOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TPacket = null;
         if(TProcessorCrashJade.Busy)
         {
            return;
         }
         TProcessorCrashJade.Busy = true;
         _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_CrashJade_SellOneKeyReq);
         SNetworkCore.Transceiver.PacketTransmit(_loc3_);
      }
      
      protected function BtnSellOneKeyOnMove(param1:Object, param2:MouseEvent) : void
      {
         this.FHint.Caption = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_CrashJade_29);
         SUtilityOverLayer.UIComponentsHintOnOver(this,this.FHint);
      }
      
      protected function BtnCloseOnClick(param1:Object, param2:MouseEvent) : void
      {
         SUtilityOverLayer.UIWindowConfirmation.SetCheckBoxUsable(false);
         ProcessorWindowClose();
      }
      
      protected function OnShopBtnClick(param1:Object, param2:MouseEvent) : void
      {
         this.FOnShop();
      }
      
      protected function BtnPickOnMove(param1:Object, param2:MouseEvent) : void
      {
         this.FHint.Caption = "拾取";
         SUtilityOverLayer.UIComponentsHintOnOver(this,this.FHint);
      }
      
      protected function BtnPickOnOut(param1:Object, param2:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOut(this,this.FHint);
      }
      
      protected function BtnPickUpShortOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:TInventory = null;
         var _loc5_:TPacket = null;
         _loc3_ = this.FPickUpShort.indexOf(param1 as TUIButton);
         _loc4_ = SLogicsCore.Character.CrashJadeTemporary.GetInventoryByIndex(_loc3_);
         if(TProcessorCrashJade.Busy)
         {
            return;
         }
         TProcessorCrashJade.Busy = true;
         _loc5_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_CrashJade_PickUpReq);
         _loc5_.Data.writeUnsignedInt(_loc4_.Identifier0);
         _loc5_.Data.writeUnsignedInt(_loc4_.Identifier1);
         SNetworkCore.Transceiver.PacketTransmit(_loc5_);
      }
      
      protected function BtnSellShortOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:TInventory = null;
         var _loc5_:TPacket = null;
         _loc3_ = this.FSellShort.indexOf(param1 as TUIButton);
         _loc4_ = SLogicsCore.Character.CrashJadeTemporary.GetInventoryByIndex(_loc3_);
         if(TProcessorCrashJade.Busy)
         {
            return;
         }
         TProcessorCrashJade.Busy = true;
         _loc5_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_CrashJade_SellReq);
         _loc5_.Data.writeUnsignedInt(_loc4_.Identifier0);
         _loc5_.Data.writeUnsignedInt(_loc4_.Identifier1);
         SNetworkCore.Transceiver.PacketTransmit(_loc5_);
      }
      
      protected function BtnPickUpLongOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:TInventory = null;
         var _loc5_:TPacket = null;
         _loc3_ = this.FPickUpLong.indexOf(param1 as TUIButton);
         _loc4_ = SLogicsCore.Character.CrashJadeTemporary.GetInventoryByIndex(_loc3_);
         if(TProcessorCrashJade.Busy)
         {
            return;
         }
         TProcessorCrashJade.Busy = true;
         _loc5_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_CrashJade_PickUpReq);
         _loc5_.Data.writeUnsignedInt(_loc4_.Identifier0);
         _loc5_.Data.writeUnsignedInt(_loc4_.Identifier1);
         SNetworkCore.Transceiver.PacketTransmit(_loc5_);
      }
      
      protected function BtnSellLongOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:TInventory = null;
         var _loc5_:TPacket = null;
         var _loc6_:TInventories = null;
         _loc3_ = this.FSellLong.indexOf(param1 as TUIButton);
         _loc6_ = SLogicsCore.Character.CrashJadeTemporary;
         _loc4_ = SLogicsCore.Character.CrashJadeTemporary.GetInventoryByIndex(_loc3_);
         if(TProcessorCrashJade.Busy)
         {
            return;
         }
         TProcessorCrashJade.Busy = true;
         _loc5_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_CrashJade_SellReq);
         _loc5_.Data.writeUnsignedInt(_loc4_.Identifier0);
         _loc5_.Data.writeUnsignedInt(_loc4_.Identifier1);
         SNetworkCore.Transceiver.PacketTransmit(_loc5_);
      }
      
      public function LockUI() : void
      {
         this.FMainUI.mouseChildren = false;
         this.FMainUI.mouseEnabled = false;
      }
      
      public function UnlockUI() : void
      {
         this.FMainUI.mouseChildren = true;
         this.FMainUI.mouseEnabled = true;
      }
      
      public function set CrashJadeData(param1:TCrashJadeData) : void
      {
         this.FCrashJadeData = param1;
      }
      
      public function set OnEquipJade(param1:Function) : void
      {
         this.FOnEquipJade = param1;
      }
      
      public function set OnClickBtnClose(param1:Function) : void
      {
         this.FOnClickBtnClose = param1;
      }
      
      public function set OnShop(param1:Function) : void
      {
         this.FOnShop = param1;
      }
      
      public function Update() : void
      {
         this.RenderingBaseInfor();
         this.RenderingBackPack();
         this.FCurrentJadeNum = SLogicsCore.Character.CrashJadeTemporary.Count;
      }
      
      public function UpdateLastTime() : void
      {
         this.RenderingBaseInfor();
      }
      
      public function UpdateDirectOpen() : void
      {
         this.RenderingBaseInfor();
      }
      
      public function UpdateMakeJadeOneKey() : void
      {
         this.RenderingBackPack();
         this.RenderingBaseInfor();
         this.SetupFly(FlyMode_OneKeyMakeJade);
         this.FCurrentJadeNum = SLogicsCore.Character.CrashJadeTemporary.Count;
         this.LockUI();
      }
      
      public function UpdateMakeJadeSingle() : void
      {
         this.RenderingBaseInfor();
         this.RenderingBackPack();
         if(this.FCrashJadeData.BtnPosition.length != 0)
         {
            this.SetupFly(FlyMode_SingleMakeJade,this.FCrashJadeData.BtnPosition[0] - 1);
         }
         this.FCurrentJadeNum = SLogicsCore.Character.CrashJadeTemporary.Count;
      }
      
      public function UpdateSellJade() : void
      {
         this.RenderingBackPack();
         this.FCurrentJadeNum = SLogicsCore.Character.CrashJadeTemporary.Count;
      }
      
      public function UpdatePickUp() : void
      {
         this.SetupFly(FlyMode_OneKeyPickUp);
         if(this.FCrashJadeData.IDHigh.length > 1)
         {
            this.LockUI();
         }
      }
      
      public function UpdateLog(param1:Vector.<TLog>) : void
      {
         this.RenderingLog(param1);
      }
      
      protected function Reset() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc2_ = int(this.FSlots.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FSlots[_loc1_].Context = null;
            _loc1_++;
         }
         this.FScroolBar.ScrollToDown();
         this.UnlockUI();
      }
      
      public function ComposeNotify() : void
      {
         this.RenderingBaseInfor();
      }
      
      public function UnlockSlotNotify() : void
      {
         this.RenderingBaseInfor();
      }
   }
}

