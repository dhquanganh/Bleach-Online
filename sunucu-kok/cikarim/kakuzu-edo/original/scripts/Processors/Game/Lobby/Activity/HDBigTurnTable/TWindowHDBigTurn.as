package Processors.Game.Lobby.Activity.HDBigTurnTable
{
   import Components.ScrollBar.*;
   import Components.Slots.*;
   import Components.Standard.*;
   import Externals.SExternalCore;
   import Foundation.Resources.SResourcesCore;
   import Foundation.Timing.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.DatebaseVO.VO.Json.*;
   import Logics.HDActivityBigTurnTable.*;
   import Logics.HDActivityMode.*;
   import Logics.HDActivityOS.*;
   import Logics.Inventories.*;
   import Logics.KnifeOfKillSoul.*;
   import Logics.Log.*;
   import Processors.Game.Lobby.Activity.HDActivity.*;
   import Processors.Game.Lobby.Activity.HDChineseYear.Component.TKnifePop;
   import Processors.Game.Lobby.Common.Hero.*;
   import Processors.Game.Lobby.Jade.*;
   import Processors.Game.Lobby.Utilities.*;
   import Processors.Game.Utilities.EffectTextReward.*;
   import Processors.Game.Utilities.OverLayer.*;
   import Resources.Constants.*;
   import Utilities.Timing.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   import ghostcat.util.data.*;
   
   public class TWindowHDBigTurn extends TProcessorHDSingleWindowBase
   {
      
      protected static const OutterCircleSlotNum:int = 16;
      
      protected static const InnerCircleSlotNum:int = 6;
      
      protected static const TabIndexLuckyLottery:int = 0;
      
      protected static const TabIndexGoldLottery:int = 1;
      
      protected static const GoldLotterOne:int = 0;
      
      protected static const GoldLotterTen:int = 1;
      
      protected static const GoldLotterFifty:int = 2;
      
      protected static const SnakeLength:int = 1;
      
      protected static const AccelerationSpeed:int = 3;
      
      protected static const StartSpeed:int = 60;
      
      protected static const EndSpeed:int = 20;
      
      protected static const SnakeStateNone:int = 0;
      
      protected static const SnakeStateAddSpped:int = 1;
      
      protected static const SnakeStateSubSpeed:int = 2;
      
      protected static const SnakeStateLocate:int = 3;
      
      protected static const MAXGOODNUM:int = 4;
      
      protected var FActivityBigTurnTableData:TActivityBigTurnTableData;
      
      protected var FCurrentTabIndex:int;
      
      protected var FLotteryIndexStore:int;
      
      protected var FNotifyStore:Boolean;
      
      protected var FSnakeHeads:Vector.<int>;
      
      protected var TimeStore:int;
      
      protected var FCurrentSpeed:int;
      
      protected var FSpeedDirection:int;
      
      protected var FCurrentSnakeState:int;
      
      protected var FCurrentSelectBox:Vector.<Sprite>;
      
      protected var FCurrentHitBoxIndex:Vector.<int>;
      
      protected var FCurrentHitBoxState:Vector.<Boolean>;
      
      protected var FTab:TUITab;
      
      protected var FOutSlots:Vector.<TUISlot>;
      
      protected var FOutSelectBoxs:Vector.<Sprite>;
      
      protected var FOutEffectsBlue:Vector.<MovieClip>;
      
      protected var FOutEffectsRed:Vector.<MovieClip>;
      
      protected var FInnerSlots:Vector.<TUISlot>;
      
      protected var FInnerSelectBoxs:Vector.<Sprite>;
      
      protected var FInnerEffectsBlue:Vector.<MovieClip>;
      
      protected var FInnerEffectsRed:Vector.<MovieClip>;
      
      protected var FTFCongestName:TextField;
      
      protected var FTFCongestValue:TextField;
      
      protected var FTFLastTimes:TextField;
      
      protected var FBtnLotteryOne:TUIButton;
      
      protected var FBtnLotteryTen:TUIButton;
      
      protected var FBtnLotteryFifty:TUIButton;
      
      protected var FBtnLotteryMystery:TUIButton;
      
      protected var FScrollBar:TScrollBar;
      
      protected var FTFScore:TextField;
      
      protected var FSPActivityDes:Sprite;
      
      protected var FWindowShowHero:TProcessorWindowHeroDescription;
      
      protected var FKnifePop:TKnifePop;
      
      protected var FKnifeOfKillSoulData:TKnifeOfKillSoulData;
      
      protected var FBtnViewGoods:Vector.<TUIButton>;
      
      protected var FBtnGoodsBuy:Vector.<TUIButton>;
      
      protected var FTFGoodsCost:Vector.<TextField>;
      
      protected var FGoodsBuyFlags:Vector.<Sprite>;
      
      protected var FGoodsPreView:Vector.<TUIButton>;
      
      protected var FBtnJmpMall:TUIButton;
      
      protected var FWindowHDBigTurnMall:TWindowHDBigTurnMall;
      
      protected var FOnCreateKnifeOfKillSoulData:Function;
      
      protected var FOnLoadLog:Function;
      
      public function TWindowHDBigTurn(param1:TUIComponent)
      {
         super(param1);
         FSceneResourceName = CONST_ACTIVITY.RESOURCE_ClassName_ActivitySingleBigTurnTable;
         FActivityID = CONST_ACTIVITY_MODE.Activity_BigTurnTable;
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(!Visible)
         {
            return;
         }
         this.UpdateTime();
         this.UpdateSlots(this.FOutSlots);
         this.UpdateSlots(this.FInnerSlots);
         this.UpdateSnakeMove();
      }
      
      override protected function UpdateDataBase(param1:TActivityOSBase) : void
      {
         super.UpdateDataBase(param1);
         this.FActivityBigTurnTableData = param1 as TActivityBigTurnTableData;
         this.UpdateUI();
      }
      
      override public function InitWindow(param1:Sprite = null) : void
      {
         super.InitWindow(param1);
         this.UIDispatch_LotteryArea();
         this.UIDispatch_RankArea();
         this.UIDispatch_Mall();
      }
      
      protected function UIDispatch_LotteryArea() : void
      {
         var _loc1_:Sprite = null;
         var _loc2_:Sprite = null;
         var _loc3_:TUISlot = null;
         var _loc4_:int = 0;
         this.FOutSlots = new Vector.<TUISlot>();
         this.FOutSelectBoxs = new Vector.<Sprite>();
         this.FOutEffectsBlue = new Vector.<MovieClip>();
         this.FOutEffectsRed = new Vector.<MovieClip>();
         this.FInnerSlots = new Vector.<TUISlot>();
         this.FInnerSelectBoxs = new Vector.<Sprite>();
         this.FInnerEffectsBlue = new Vector.<MovieClip>();
         this.FInnerEffectsRed = new Vector.<MovieClip>();
         this.FTab = new TUITab(this);
         this.FTab.SetTabByIndex(FScene["Tab_LuckyLottery"],0);
         this.FTab.SetTabByIndex(FScene["Tab_GoldLottery"],1);
         this.FTab.OnSwitch = this.TabOnSwitch;
         this.FTab.Init();
         _loc1_ = FScene["OutterCircle"];
         _loc4_ = 0;
         while(_loc4_ < OutterCircleSlotNum)
         {
            _loc2_ = _loc1_["MC_Slot_" + _loc4_];
            _loc3_ = new TUISlot(this);
            _loc3_.Resource = _loc2_["MC_Slot"];
            TJadeCommon.InitSlot(_loc3_);
            _loc3_.OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
            _loc3_.OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
            _loc3_.Init();
            this.FOutSlots.push(_loc3_);
            this.FOutSelectBoxs.push(_loc2_["SelectBox"]);
            this.FOutSelectBoxs[_loc4_].visible = false;
            this.FOutSelectBoxs[_loc4_].mouseEnabled = false;
            this.FOutSelectBoxs[_loc4_].mouseChildren = false;
            this.FOutEffectsRed.push(_loc2_["Effect"]["EffectRed"]);
            this.FOutEffectsBlue.push(_loc2_["Effect"]["EffectBlue"]);
            this.FOutEffectsBlue[_loc4_].visible = false;
            this.FOutEffectsBlue[_loc4_].mouseEnabled = false;
            this.FOutEffectsBlue[_loc4_].mouseChildren = false;
            this.FOutEffectsRed[_loc4_].visible = false;
            this.FOutEffectsRed[_loc4_].mouseEnabled = false;
            this.FOutEffectsRed[_loc4_].mouseChildren = false;
            _loc4_++;
         }
         _loc1_ = FScene["InnerCircle"];
         _loc4_ = 0;
         while(_loc4_ < InnerCircleSlotNum)
         {
            _loc2_ = _loc1_["MC_Slot_" + _loc4_];
            _loc3_ = new TUISlot(this);
            _loc3_.Resource = _loc2_["MC_Slot"];
            TJadeCommon.InitSlot(_loc3_);
            _loc3_.OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
            _loc3_.OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
            _loc3_.Init();
            this.FInnerSlots.push(_loc3_);
            this.FInnerSelectBoxs.push(_loc2_["SelectBox"]);
            this.FInnerSelectBoxs[_loc4_].visible = false;
            this.FInnerSelectBoxs[_loc4_].mouseEnabled = false;
            this.FInnerSelectBoxs[_loc4_].mouseChildren = false;
            this.FInnerEffectsRed.push(_loc2_["Effect"]["EffectRed"]);
            this.FInnerEffectsBlue.push(_loc2_["Effect"]["EffectBlue"]);
            this.FInnerEffectsBlue[_loc4_].visible = false;
            this.FInnerEffectsBlue[_loc4_].mouseEnabled = false;
            this.FInnerEffectsBlue[_loc4_].mouseChildren = false;
            this.FInnerEffectsRed[_loc4_].visible = false;
            this.FInnerEffectsRed[_loc4_].mouseEnabled = false;
            this.FInnerEffectsRed[_loc4_].mouseChildren = false;
            _loc4_++;
         }
         this.FTFCongestName = _loc1_["CongestName"];
         this.FTFCongestValue = _loc1_["CongestValue"];
         this.FTFLastTimes = _loc1_["LastTimes"];
         this.FBtnLotteryMystery = new TUIButton();
         this.FBtnLotteryMystery.Substrate = _loc1_["Btn_Mystery"];
         this.FBtnLotteryMystery.OnClick = this.BtnLotteryMysteryOnClick;
         this.FBtnLotteryMystery.OnMove = this.BtnOnMove;
         this.FBtnLotteryMystery.OnOut = this.BtnOnOut;
         this.FBtnLotteryOne = new TUIButton();
         this.FBtnLotteryOne.Substrate = FScene["Btn_One"];
         this.FBtnLotteryOne.OnClick = this.BtnLotteryOneOnClick;
         this.FBtnLotteryOne.OnMove = this.BtnOnMove;
         this.FBtnLotteryOne.OnOut = this.BtnOnOut;
         this.FBtnLotteryTen = new TUIButton();
         this.FBtnLotteryTen.Substrate = FScene["Btn_Ten"];
         this.FBtnLotteryTen.OnClick = this.BtnLotteryTenOnClick;
         this.FBtnLotteryTen.OnMove = this.BtnOnMove;
         this.FBtnLotteryTen.OnOut = this.BtnOnOut;
         this.FBtnLotteryFifty = new TUIButton();
         this.FBtnLotteryFifty.Substrate = FScene["Btn_Fifty"];
         this.FBtnLotteryFifty.OnClick = this.BtnLotteryFiftyOnClick;
         this.FBtnLotteryFifty.OnMove = this.BtnOnMove;
         this.FBtnLotteryFifty.OnOut = this.BtnOnOut;
         this.FCurrentHitBoxIndex = new Vector.<int>();
         this.FCurrentHitBoxState = new Vector.<Boolean>();
         this.FSnakeHeads = new Vector.<int>();
      }
      
      protected function UIDispatch_RankArea() : void
      {
         this.FScrollBar = new TScrollBar(FScene["ScroolBarUI"],206,false);
      }
      
      protected function UIDispatch_Mall() : void
      {
         var _loc1_:Sprite = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TUIButton = null;
         var _loc5_:MovieClip = null;
         _loc1_ = FScene["Mall"];
         this.FTFScore = _loc1_["Score"];
         this.FBtnViewGoods = new Vector.<TUIButton>(MAXGOODNUM);
         this.FBtnGoodsBuy = new Vector.<TUIButton>(MAXGOODNUM);
         this.FTFGoodsCost = new Vector.<TextField>(MAXGOODNUM);
         this.FGoodsBuyFlags = new Vector.<Sprite>(MAXGOODNUM);
         this.FGoodsPreView = new Vector.<TUIButton>(MAXGOODNUM);
         _loc3_ = MAXGOODNUM;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc5_ = _loc1_["GoodsBtn" + _loc2_];
            if(_loc5_ != null)
            {
               _loc4_ = new TUIButton();
               _loc4_.Substrate = _loc5_;
               _loc4_.OnClick = this.BtnViewOnClick;
               this.FBtnViewGoods[_loc2_] = _loc4_;
            }
            _loc5_ = _loc1_["BtnBuy" + _loc2_];
            if(_loc5_ != null)
            {
               _loc4_ = new TUIButton();
               _loc4_.Substrate = _loc5_["Btn_Buy"];
               _loc4_.OnClick = this.BtnBuyOnClick;
               _loc4_.OnMove = this.BtnBuyOnOver;
               _loc4_.OnOut = this.BtnOnOut;
               this.FBtnGoodsBuy[_loc2_] = _loc4_;
               this.FTFGoodsCost[_loc2_] = _loc5_["TF_Cost"];
               this.FGoodsBuyFlags[_loc2_] = _loc5_["BuyFlag"];
            }
            _loc5_ = _loc1_["Btn_PreView" + _loc2_];
            if(_loc5_ != null)
            {
               _loc4_ = new TUIButton();
               _loc4_.Substrate = _loc5_;
               _loc4_.OnClick = this.BtnPreViewOnClick;
               this.FGoodsPreView[_loc2_] = _loc4_;
            }
            _loc2_++;
         }
         this.FBtnJmpMall = new TUIButton();
         this.FBtnJmpMall.Substrate = _loc1_["Btn_OK"];
         this.FBtnJmpMall.OnClick = this.BtnJmpMallOnClick;
         this.FSPActivityDes = FScene["MC_HDDesc"];
         this.FSPActivityDes.addEventListener(MouseEvent.MOUSE_MOVE,this.SPDesOnMouseMove);
         this.FSPActivityDes.addEventListener(MouseEvent.MOUSE_OUT,this.SPDesOnMouseOut);
         this.FWindowHDBigTurnMall = new TWindowHDBigTurnMall(this);
         this.FWindowHDBigTurnMall.OnBtnBuyOnClick = this.OnBtnBuyClick;
         this.FWindowHDBigTurnMall.OnShowHero = this.ProcessorShowHero;
         this.FWindowHDBigTurnMall.OnShowKnifeOfKillSoul = this.ProcessorShowKnifeOfKillSoul;
         this.FWindowHDBigTurnMall.OnHideHeroAndKnifeOfKillSoul = this.ProcessorHideHeroAndKnifeOfKillSoul;
         this.FWindowHDBigTurnMall.UIDispatch();
         this.FWindowHDBigTurnMall.X = FScene.x + (FScene.width - this.FWindowHDBigTurnMall.width) / 2;
         this.FWindowHDBigTurnMall.Y = FScene.y + (FScene.height - this.FWindowHDBigTurnMall.height) / 2;
         this.FWindowShowHero = new TProcessorWindowHeroDescription(FParent);
         this.FWindowShowHero.Perform_UIDispatch();
         this.FWindowShowHero.HintOnOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FWindowShowHero.HintOnOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FWindowShowHero.OnClose = this.BtnCloseShowHeroOnMouseClick;
         this.FKnifePop = new TKnifePop(this);
         this.FKnifePop.OnPopColse = this.BtnCloseShowHeroOnMouseClick;
         this.FKnifePop.UIDispatch();
         this.FKnifePop.X = FScene.x + (FScene.width - this.FKnifePop.Width) / 2;
         this.FKnifePop.Y = FScene.y + (FScene.height - this.FKnifePop.Height) / 2;
         this.FKnifePop.Visible = false;
      }
      
      override protected function UpdateUI() : void
      {
         super.UpdateUI();
         this.RenderLotteryArea();
         this.RenderMall();
         if(this.FWindowHDBigTurnMall.Visible)
         {
            this.FWindowHDBigTurnMall.Update();
         }
      }
      
      protected function RenderLotteryArea() : void
      {
         var _loc1_:TInventories = null;
         var _loc2_:Vector.<int> = null;
         var _loc3_:TInventories = null;
         var _loc4_:Vector.<int> = null;
         var _loc5_:TInventory = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         switch(this.FCurrentTabIndex)
         {
            case TabIndexLuckyLottery:
               _loc1_ = this.FActivityBigTurnTableData.BigTurnTableLuckyLotteryOutter.Inventories;
               _loc2_ = this.FActivityBigTurnTableData.BigTurnTableLuckyLotteryOutter.FlushVec;
               _loc3_ = this.FActivityBigTurnTableData.BigTurnTableLuckyLotteryInner.Inventories;
               _loc4_ = this.FActivityBigTurnTableData.BigTurnTableLuckyLotteryInner.FlushVec;
               this.FTFCongestName.text = this.FActivityBigTurnTableData.BigTurnTableLuckyPoint.Name;
               this.FTFCongestValue.text = this.FActivityBigTurnTableData.BigTurnTableLuckyPoint.Value.toString();
               this.FTFLastTimes.text = int(this.FActivityBigTurnTableData.BigTurnTableLuckyPoint.Value / this.FActivityBigTurnTableData.BigTurnTableLuckyLotteryInner.CostChip).toString();
               this.FBtnLotteryTen.Visible = false;
               this.FBtnLotteryFifty.Visible = false;
               this.FBtnLotteryOne.Caption = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_66);
               break;
            case TabIndexGoldLottery:
               _loc1_ = this.FActivityBigTurnTableData.BigTurnTableGoldLotteryOutter.Inventories;
               _loc2_ = this.FActivityBigTurnTableData.BigTurnTableGoldLotteryOutter.FlushVec;
               _loc3_ = this.FActivityBigTurnTableData.BigTurnTableGoldLotteryInner.Inventories;
               _loc4_ = this.FActivityBigTurnTableData.BigTurnTableGoldLotteryInner.FlushVec;
               this.FTFCongestValue.text = this.FActivityBigTurnTableData.BigTurnTableGoldPoint.Value.toString();
               this.FTFCongestName.text = this.FActivityBigTurnTableData.BigTurnTableGoldPoint.Name;
               this.FTFLastTimes.text = int(this.FActivityBigTurnTableData.BigTurnTableGoldPoint.Value / this.FActivityBigTurnTableData.BigTurnTableGoldLotteryInner.Cost).toString();
               this.FBtnLotteryTen.Visible = true;
               this.FBtnLotteryFifty.Visible = true;
               this.FBtnLotteryOne.Caption = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_66);
         }
         _loc7_ = _loc1_.Count;
         _loc6_ = 0;
         while(_loc6_ < _loc7_)
         {
            _loc5_ = _loc1_.GetInventoryByIndex(_loc6_);
            this.FOutSlots[_loc6_].Context = _loc5_;
            if(_loc2_[_loc6_] == 1)
            {
               this.FOutEffectsBlue[_loc6_].visible = true;
               this.FOutEffectsBlue[_loc6_].play();
            }
            else
            {
               this.FOutEffectsBlue[_loc6_].visible = false;
               this.FOutEffectsBlue[_loc6_].stop();
            }
            _loc6_++;
         }
         _loc7_ = _loc3_.Count;
         _loc6_ = 0;
         while(_loc6_ < _loc7_)
         {
            this.FInnerSlots[_loc6_].Context = _loc3_.GetInventoryByIndex(_loc6_);
            if(_loc4_[_loc6_] == 1)
            {
               this.FInnerEffectsRed[_loc6_].visible = true;
               this.FInnerEffectsRed[_loc6_].play();
            }
            else
            {
               this.FInnerEffectsRed[_loc6_].visible = false;
               this.FInnerEffectsRed[_loc6_].stop();
            }
            _loc6_++;
         }
      }
      
      protected function RenderRankArea(param1:Vector.<TLog>) : void
      {
         var _loc2_:* = 0;
         var _loc3_:int = 0;
         var _loc4_:TRewards = null;
         var _loc5_:Sprite = null;
         var _loc6_:TLog = null;
         var _loc7_:Object = null;
         var _loc8_:Vector.<Sprite> = null;
         var _loc9_:String = null;
         this.FScrollBar.Clear();
         _loc3_ = int(param1.length);
         _loc8_ = new Vector.<Sprite>();
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc6_ = param1[_loc2_];
            _loc7_ = Json.decode(_loc6_.Data);
            _loc5_ = TUtilityReflection.CreateDisplayObjectInstance("BigTurnTableRecordItem") as Sprite;
            _loc5_["TF"].text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_68),_loc6_.Name,SToolReward.GetNameByTypeCode(_loc7_.type,_loc7_.code),_loc7_.amount);
            _loc8_.push(_loc5_);
            _loc2_++;
         }
         _loc2_ = int(_loc3_ - 1);
         while(_loc2_ >= 0)
         {
            this.FScrollBar.AddItem(_loc8_[_loc2_]);
            _loc2_--;
         }
      }
      
      protected function RenderMall() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         this.FTFScore.text = this.FActivityBigTurnTableData.ScorePoint.Value.toString();
         _loc2_ = int(this.FActivityBigTurnTableData.BigTurnTableBuyHero.Cost.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            if(this.FTFGoodsCost[_loc1_] != null)
            {
               this.FTFGoodsCost[_loc1_].text = this.FActivityBigTurnTableData.BigTurnTableBuyHero.Cost[_loc1_].toString();
            }
            if(this.FBtnGoodsBuy[_loc1_] != null)
            {
               this.FBtnGoodsBuy[_loc1_].Visible = !this.FActivityBigTurnTableData.BigTurnTableBuyHero.IfBuyed[_loc1_];
            }
            if(this.FGoodsBuyFlags[_loc1_] != null)
            {
               this.FGoodsBuyFlags[_loc1_].visible = this.FActivityBigTurnTableData.BigTurnTableBuyHero.IfBuyed[_loc1_];
            }
            _loc1_++;
         }
      }
      
      protected function UpdateSlots(param1:Vector.<TUISlot>) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         _loc3_ = int(param1.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            param1[_loc2_].Update();
            _loc2_++;
         }
      }
      
      protected function UpdateTime() : void
      {
         var _loc1_:int = 0;
         if(this.FCurrentTabIndex == TabIndexLuckyLottery)
         {
            _loc1_ = this.FActivityBigTurnTableData.BigTurnTableLuckyLotteryOutter.TimeCountedDown - STimingCore.ServerTick + this.FActivityBigTurnTableData.BigTurnTableLuckyLotteryOutter.PreLotteryTime;
            if(_loc1_ > 0)
            {
               this.FBtnLotteryOne.Caption = TUtilityTiming.fomatTime(_loc1_);
            }
            else
            {
               this.FBtnLotteryOne.Caption = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_66);
            }
         }
      }
      
      protected function UpdateSnakeMove() : void
      {
         var _loc1_:int = 0;
         switch(this.FCurrentSnakeState)
         {
            case SnakeStateAddSpped:
               _loc1_ = STimingCore.TickCount - this.TimeStore;
               if(_loc1_ > this.FCurrentSpeed)
               {
                  this.SnakeHeadGoNextStep(this.FCurrentSelectBox);
                  this.DrawSnake(this.FCurrentSelectBox,SnakeLength);
                  this.FCurrentSpeed -= AccelerationSpeed;
                  if(this.FCurrentSpeed < EndSpeed)
                  {
                     this.FCurrentSpeed == EndSpeed;
                     this.FCurrentSnakeState = SnakeStateSubSpeed;
                  }
                  this.TimeStore = STimingCore.TickCount;
               }
               break;
            case SnakeStateSubSpeed:
               _loc1_ = STimingCore.TickCount - this.TimeStore;
               if(_loc1_ > this.FCurrentSpeed)
               {
                  this.SnakeHeadGoNextStep(this.FCurrentSelectBox);
                  this.DrawSnake(this.FCurrentSelectBox,SnakeLength);
                  this.FCurrentSpeed += AccelerationSpeed;
                  if(this.FCurrentSpeed > StartSpeed)
                  {
                     this.FCurrentSpeed == StartSpeed;
                     this.FCurrentSnakeState = SnakeStateLocate;
                  }
                  this.TimeStore = STimingCore.TickCount;
               }
               break;
            case SnakeStateLocate:
               _loc1_ = STimingCore.TickCount - this.TimeStore;
               if(!this.CheckIfNeedLoate())
               {
                  this.FCurrentSnakeState = SnakeStateNone;
                  this.ClearSnake(this.FCurrentSelectBox);
                  this.SnakeLocate(this.FCurrentSelectBox);
                  FScene.mouseChildren = true;
                  FScene.mouseEnabled = true;
                  return;
               }
               if(_loc1_ > this.FCurrentSpeed)
               {
                  this.SnakeHeadGoNextStep(this.FCurrentSelectBox);
                  this.DrawSnake(this.FCurrentSelectBox,1);
                  this.SnakeLocate(this.FCurrentSelectBox);
                  this.FCurrentSpeed += AccelerationSpeed;
                  this.TimeStore = STimingCore.TickCount;
               }
         }
      }
      
      protected function SnakeHeadGoNextStep(param1:Vector.<Sprite>) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _loc3_ = int(this.FSnakeHeads.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = this.FSnakeHeads[_loc2_];
            _loc4_ = (_loc4_ + 1) % param1.length;
            this.FSnakeHeads[_loc2_] = _loc4_;
            _loc2_++;
         }
      }
      
      protected function ClearSnake(param1:Vector.<Sprite>) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         _loc3_ = int(param1.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            param1[_loc2_].visible = false;
            _loc2_++;
         }
      }
      
      protected function DrawSnake(param1:Vector.<Sprite>, param2:int) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         this.ClearSnake(param1);
         _loc4_ = int(this.FSnakeHeads.length);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc5_ = this.FSnakeHeads[_loc3_];
            param1[_loc5_].visible = true;
            _loc7_ = param2;
            _loc6_ = 1;
            while(_loc6_ < _loc7_)
            {
               _loc5_ = this.GetSnakePositionBySnakeHead(param1,this.FSnakeHeads[_loc3_],_loc6_);
               param1[_loc5_].visible = true;
               _loc6_++;
            }
            _loc3_++;
         }
      }
      
      protected function GetSnakePositionBySnakeHead(param1:Vector.<Sprite>, param2:int, param3:int) : int
      {
         var _loc4_:int = 0;
         _loc4_ = param2 - param3;
         if(_loc4_ < 0)
         {
            _loc4_ = param1.length + _loc4_;
         }
         return _loc4_;
      }
      
      protected function SnakeLocate(param1:Vector.<Sprite>) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:Boolean = false;
         _loc3_ = int(this.FCurrentHitBoxIndex.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc6_ = this.FCurrentHitBoxIndex[_loc2_];
            _loc7_ = this.FCurrentHitBoxState[_loc2_];
            if(!_loc7_)
            {
               _loc5_ = int(this.FSnakeHeads.length);
               _loc4_ = 0;
               while(_loc4_ < _loc5_)
               {
                  if(_loc6_ == this.FSnakeHeads[_loc4_])
                  {
                     this.FCurrentHitBoxState[_loc2_] = true;
                     param1[_loc6_].visible = true;
                     break;
                  }
                  _loc4_++;
               }
            }
            else
            {
               param1[_loc6_].visible = true;
            }
            _loc2_++;
         }
      }
      
      protected function CheckIfNeedLoate() : Boolean
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc2_ = int(this.FCurrentHitBoxState.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            if(!this.FCurrentHitBoxState[_loc1_])
            {
               return true;
            }
            _loc1_++;
         }
         return false;
      }
      
      protected function LotteryRequst(param1:Object) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FLotteryIndexStore);
      }
      
      protected function TypeCodeToIndex(param1:int, param2:int, param3:TRewards) : int
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         _loc5_ = int(param3.Count);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            if(param3.Type[_loc4_] == param1 && param3.Code[_loc4_] == param2)
            {
               return _loc4_;
            }
            _loc4_++;
         }
         return -1;
      }
      
      override protected function Reset() : void
      {
         super.Reset();
      }
      
      protected function IfHero(param1:int) : Boolean
      {
         var _loc2_:TBaseHero = null;
         _loc2_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_BaseHero,param1) as TBaseHero;
         return _loc2_ != null;
      }
      
      protected function TabOnSwitch(param1:int) : void
      {
         this.FCurrentTabIndex = param1;
         this.UpdateUI();
      }
      
      protected function BtnLotteryMysteryOnClick(param1:Object, param2:MouseEvent) : void
      {
         switch(this.FCurrentTabIndex)
         {
            case TabIndexLuckyLottery:
               if(this.FActivityBigTurnTableData.BigTurnTableLuckyPoint.Value < this.FActivityBigTurnTableData.BigTurnTableLuckyLotteryInner.CostChip)
               {
                  SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_70));
                  return;
               }
               Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FActivityBigTurnTableData.BigTurnTableLuckyLotteryInner.Index);
               break;
            case TabIndexGoldLottery:
               if(this.FActivityBigTurnTableData.BigTurnTableGoldPoint.Value < this.FActivityBigTurnTableData.BigTurnTableGoldLotteryInner.Cost)
               {
                  SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_70));
                  return;
               }
               Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FActivityBigTurnTableData.BigTurnTableGoldLotteryInner.Index);
         }
         this.ClearSnake(this.FOutSelectBoxs);
         this.ClearSnake(this.FInnerSelectBoxs);
      }
      
      protected function BtnLotteryOneOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         switch(this.FCurrentTabIndex)
         {
            case TabIndexLuckyLottery:
               _loc3_ = this.FActivityBigTurnTableData.BigTurnTableLuckyLotteryOutter.TimeCountedDown - STimingCore.ServerTick + this.FActivityBigTurnTableData.BigTurnTableLuckyLotteryOutter.PreLotteryTime;
               if(_loc3_ > 0)
               {
                  SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_69));
                  return;
               }
               Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FActivityBigTurnTableData.BigTurnTableLuckyLotteryOutter.Index);
               break;
            case TabIndexGoldLottery:
               if(SLogicsCore.Character.CreditGold < this.FActivityBigTurnTableData.BigTurnTableGoldLotteryOutter.Cost[GoldLotterOne])
               {
                  SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_71));
                  return;
               }
               this.FLotteryIndexStore = this.FActivityBigTurnTableData.BigTurnTableGoldLotteryOutter.Index[GoldLotterOne];
               SUtilityOverLayer.UIWindowConfirmation.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_67),this.FActivityBigTurnTableData.BigTurnTableGoldLotteryOutter.Cost[GoldLotterOne],this.FActivityBigTurnTableData.BigTurnTableGoldLotteryOutter.Time[GoldLotterOne]);
               SUtilityOverLayer.UIWindowConfirmation.OnOK = this.LotteryRequst;
               SUtilityOverLayer.UIWindowConfirmation.Visible = true;
         }
         this.ClearSnake(this.FOutSelectBoxs);
         this.ClearSnake(this.FInnerSelectBoxs);
      }
      
      protected function BtnLotteryTenOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(SLogicsCore.Character.CreditGold < this.FActivityBigTurnTableData.BigTurnTableGoldLotteryOutter.Cost[GoldLotterTen])
         {
            SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_71));
            return;
         }
         this.FLotteryIndexStore = this.FActivityBigTurnTableData.BigTurnTableGoldLotteryOutter.Index[GoldLotterTen];
         SUtilityOverLayer.UIWindowConfirmation.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_67),this.FActivityBigTurnTableData.BigTurnTableGoldLotteryOutter.Cost[GoldLotterTen],this.FActivityBigTurnTableData.BigTurnTableGoldLotteryOutter.Time[GoldLotterTen]);
         SUtilityOverLayer.UIWindowConfirmation.OnOK = this.LotteryRequst;
         SUtilityOverLayer.UIWindowConfirmation.Visible = true;
         this.ClearSnake(this.FOutSelectBoxs);
         this.ClearSnake(this.FInnerSelectBoxs);
      }
      
      protected function BtnLotteryFiftyOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(SLogicsCore.Character.CreditGold < this.FActivityBigTurnTableData.BigTurnTableGoldLotteryOutter.Cost[GoldLotterFifty])
         {
            SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_71));
            return;
         }
         this.FLotteryIndexStore = this.FActivityBigTurnTableData.BigTurnTableGoldLotteryOutter.Index[GoldLotterFifty];
         SUtilityOverLayer.UIWindowConfirmation.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_67),this.FActivityBigTurnTableData.BigTurnTableGoldLotteryOutter.Cost[GoldLotterFifty],this.FActivityBigTurnTableData.BigTurnTableGoldLotteryOutter.Time[GoldLotterFifty]);
         SUtilityOverLayer.UIWindowConfirmation.OnOK = this.LotteryRequst;
         SUtilityOverLayer.UIWindowConfirmation.Visible = true;
         this.ClearSnake(this.FOutSelectBoxs);
         this.ClearSnake(this.FInnerSelectBoxs);
      }
      
      protected function BtnPreViewOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         _loc3_ = this.FGoodsPreView.indexOf(param1 as TUIButton);
         SExternalCore.NavigateToLinkUrl(this.FActivityBigTurnTableData.BigTurnTableBuyHero.FightReportAddr[_loc3_]);
      }
      
      protected function BtnViewOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TUIButton = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         _loc4_ = this.FBtnViewGoods.indexOf(param1 as TUIButton);
         _loc5_ = this.FActivityBigTurnTableData.ScorePoint.KnifeAndHeroID[_loc4_];
         if(this.IfHero(_loc5_))
         {
            this.ProcessorShowHero(this,_loc5_);
         }
         else
         {
            this.ProcessorShowKnifeOfKillSoul(this,_loc5_);
         }
         FScene.mouseChildren = false;
         FScene.mouseEnabled = false;
      }
      
      protected function ProcessorShowHero(param1:Object, param2:uint) : void
      {
         if(!this.FWindowShowHero.Visible)
         {
            this.FWindowShowHero.HeroID = param2;
            this.FWindowShowHero.Show();
         }
      }
      
      protected function ProcessorShowKnifeOfKillSoul(param1:Object, param2:uint) : void
      {
         if(!this.FKnifePop.Visible)
         {
            if(this.FOnCreateKnifeOfKillSoulData != null && this.FKnifeOfKillSoulData == null)
            {
               this.FKnifeOfKillSoulData = this.FOnCreateKnifeOfKillSoulData(param2);
            }
            this.FKnifePop.KnifeData = this.FKnifeOfKillSoulData;
            this.FKnifePop.Visible = true;
         }
      }
      
      protected function ProcessorHideHeroAndKnifeOfKillSoul(param1:Object) : void
      {
         this.BtnCloseShowHeroOnMouseClick(this);
      }
      
      protected function BtnJmpMallOnClick(param1:Object, param2:MouseEvent) : void
      {
         this.FWindowHDBigTurnMall.Init(this.FActivityBigTurnTableData);
         this.FWindowHDBigTurnMall.Visible = true;
      }
      
      protected function BtnOnMove(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TUIButton = null;
         _loc3_ = param1 as TUIButton;
         if(_loc3_ == this.FBtnLotteryOne)
         {
            if(this.FCurrentTabIndex == TabIndexLuckyLottery)
            {
               FHint.Caption = TUtilityString.Format(this.FActivityBigTurnTableData.BigTurnTableLuckyLotteryOutter.BtnDescription,this.FActivityBigTurnTableData.BigTurnTableLuckyLotteryOutter.ChipAmount[0],this.FActivityBigTurnTableData.BigTurnTableLuckyLotteryOutter.ChipAmount[1]);
            }
            else
            {
               FHint.Caption = TUtilityString.Format(this.FActivityBigTurnTableData.BigTurnTableGoldLotteryOutter.BtnDescription[0],this.FActivityBigTurnTableData.BigTurnTableGoldLotteryOutter.Cost[GoldLotterOne],this.FActivityBigTurnTableData.BigTurnTableGoldLotteryOutter.GoldScore[GoldLotterOne],this.FActivityBigTurnTableData.BigTurnTableGoldLotteryOutter.Score[GoldLotterOne]);
            }
         }
         else if(_loc3_ == this.FBtnLotteryTen)
         {
            FHint.Caption = TUtilityString.Format(this.FActivityBigTurnTableData.BigTurnTableGoldLotteryOutter.BtnDescription[GoldLotterTen],this.FActivityBigTurnTableData.BigTurnTableGoldLotteryOutter.Cost[GoldLotterTen],this.FActivityBigTurnTableData.BigTurnTableGoldLotteryOutter.GoldScore[GoldLotterTen],this.FActivityBigTurnTableData.BigTurnTableGoldLotteryOutter.Score[GoldLotterTen]);
         }
         else if(_loc3_ == this.FBtnLotteryFifty)
         {
            FHint.Caption = TUtilityString.Format(this.FActivityBigTurnTableData.BigTurnTableGoldLotteryOutter.BtnDescription[GoldLotterFifty],this.FActivityBigTurnTableData.BigTurnTableGoldLotteryOutter.Cost[GoldLotterFifty],this.FActivityBigTurnTableData.BigTurnTableGoldLotteryOutter.GoldScore[GoldLotterFifty],this.FActivityBigTurnTableData.BigTurnTableGoldLotteryOutter.Score[GoldLotterFifty]);
         }
         else if(_loc3_ == this.FBtnLotteryMystery)
         {
            if(this.FCurrentTabIndex == TabIndexLuckyLottery)
            {
               FHint.Caption = TUtilityString.Format(this.FActivityBigTurnTableData.BigTurnTableLuckyLotteryInner.BtnDescription,this.FActivityBigTurnTableData.BigTurnTableLuckyLotteryInner.CostChip);
            }
            else
            {
               FHint.Caption = TUtilityString.Format(this.FActivityBigTurnTableData.BigTurnTableGoldLotteryInner.BtnDescription,this.FActivityBigTurnTableData.BigTurnTableGoldLotteryInner.Cost);
            }
         }
         SUtilityOverLayer.UIComponentsHintOnOver(this,FHint);
      }
      
      protected function BtnOnOut(param1:Object, param2:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOut(this,FHint);
      }
      
      override protected function BtnCloseOnClick(param1:Object, param2:MouseEvent) : void
      {
         super.BtnCloseOnClick(param1,param2);
         if(FOnBtnCloseClick != null)
         {
            FOnBtnCloseClick(this);
         }
      }
      
      protected function OnBtnBuyClick(param1:Object, param2:int) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,param2);
      }
      
      protected function SPDesOnMouseMove(param1:MouseEvent) : void
      {
         FHint.Caption = FHDActivityConfig.Desc;
         SUtilityOverLayer.UIComponentsHintOnOver(this,FHint);
      }
      
      protected function SPDesOnMouseOut(param1:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOut(this,FHint);
      }
      
      protected function BtnCloseShowHeroOnMouseClick(param1:Object) : void
      {
         if(this.FWindowShowHero.Visible)
         {
            this.FWindowShowHero.Hide();
         }
         if(this.FKnifePop.Visible)
         {
            this.FKnifePop.Reset();
            this.FKnifeOfKillSoulData = null;
            this.FKnifePop.Visible = false;
         }
         FScene.mouseChildren = true;
         FScene.mouseEnabled = true;
         this.FWindowHDBigTurnMall.Resource.mouseChildren = true;
         this.FWindowHDBigTurnMall.Resource.mouseEnabled = true;
      }
      
      protected function LogArrive(param1:Vector.<TLog>) : void
      {
         this.RenderRankArea(param1);
      }
      
      protected function BtnBuyOnOver(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         _loc3_ = this.FBtnGoodsBuy.indexOf(param1 as TUIButton);
         FHint.Caption = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_74),this.FActivityBigTurnTableData.BigTurnTableBuyHero.Cost[_loc3_]);
         SUtilityOverLayer.UIComponentsHintOnOver(this,FHint);
      }
      
      protected function BtnBuyOnOut(param1:Object, param2:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOut(this,FHint);
      }
      
      protected function BtnBuyOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         _loc3_ = this.FBtnGoodsBuy.indexOf(param1 as TUIButton);
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FActivityBigTurnTableData.BigTurnTableBuyHero.Index[_loc3_]);
      }
      
      public function set OnCreateKnifeOfKillSoulData(param1:Function) : void
      {
         this.FOnCreateKnifeOfKillSoulData = param1;
      }
      
      public function set OnLoadLog(param1:Function) : void
      {
         this.FOnLoadLog = param1;
      }
      
      public function UpdateArrive(param1:int, param2:Vector.<int>) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:TRewards = null;
         var _loc6_:int = 0;
         if(param2 == null || param2.length == 0)
         {
            return;
         }
         this.FSnakeHeads.length = 0;
         this.FCurrentHitBoxIndex.length = 0;
         this.FCurrentHitBoxState.length = 0;
         this.FSnakeHeads.push(0);
         if(param1 == this.FActivityBigTurnTableData.BigTurnTableLuckyLotteryOutter.Index)
         {
            _loc5_ = this.FActivityBigTurnTableData.BigTurnTableLuckyLotteryOutter.Rewards;
            this.FCurrentSelectBox = this.FOutSelectBoxs;
         }
         else if(param1 == this.FActivityBigTurnTableData.BigTurnTableLuckyLotteryInner.Index)
         {
            _loc5_ = this.FActivityBigTurnTableData.BigTurnTableLuckyLotteryInner.Rewards;
            this.FCurrentSelectBox = this.FInnerSelectBoxs;
         }
         else if(param1 == this.FActivityBigTurnTableData.BigTurnTableGoldLotteryOutter.Index[GoldLotterOne])
         {
            _loc5_ = this.FActivityBigTurnTableData.BigTurnTableGoldLotteryOutter.Rewards;
            this.FCurrentSelectBox = this.FOutSelectBoxs;
         }
         else if(param1 == this.FActivityBigTurnTableData.BigTurnTableGoldLotteryOutter.Index[GoldLotterTen])
         {
            _loc5_ = this.FActivityBigTurnTableData.BigTurnTableGoldLotteryOutter.Rewards;
            this.FSnakeHeads.push(8);
            this.FCurrentSelectBox = this.FOutSelectBoxs;
         }
         else if(param1 == this.FActivityBigTurnTableData.BigTurnTableGoldLotteryOutter.Index[GoldLotterFifty])
         {
            _loc5_ = this.FActivityBigTurnTableData.BigTurnTableGoldLotteryOutter.Rewards;
            this.FSnakeHeads.push(4,8,12);
            this.FCurrentSelectBox = this.FOutSelectBoxs;
         }
         else
         {
            if(param1 != this.FActivityBigTurnTableData.BigTurnTableGoldLotteryInner.Index)
            {
               return;
            }
            _loc5_ = this.FActivityBigTurnTableData.BigTurnTableGoldLotteryInner.Rewards;
            this.FCurrentSelectBox = this.FInnerSelectBoxs;
         }
         _loc4_ = int(param2.length);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc6_ = this.TypeCodeToIndex(param2[_loc3_],param2[_loc3_ + 1],_loc5_);
            if(_loc6_ != -1)
            {
               this.FCurrentHitBoxIndex.push(_loc6_);
               this.FCurrentHitBoxState.push(false);
            }
            _loc3_ += 2;
         }
         this.FCurrentSnakeState = SnakeStateAddSpped;
         this.TimeStore = STimingCore.TickCount;
         this.FCurrentSpeed = StartSpeed;
         FScene.mouseChildren = false;
         FScene.mouseEnabled = false;
      }
      
      override public function Show(param1:TActivityAtoms = null, param2:THDActivityBase = null, param3:TActivityOSBase = null) : void
      {
         super.Show(param1,param2,param3);
         if(this.FOnLoadLog != null)
         {
            this.FOnLoadLog(CONST_LOG.LOGTYPE_BigTurnTable,this.LogArrive);
         }
      }
   }
}

