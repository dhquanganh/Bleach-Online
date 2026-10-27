package Processors.Game.Lobby.Activity.HDCircleTrial.windows
{
   import Components.ScrollBar.TScrollBar;
   import Components.Slots.TUISlot;
   import Components.Standard.TUIButton;
   import Foundation.Common.THint;
   import Foundation.Queries.Textures.TQueryAnimationSequence;
   import Foundation.Resources.Bins.TBins;
   import Foundation.Resources.Repositories.TResourceRepositoryTexture;
   import Foundation.Resources.SResourcesCore;
   import Foundation.Resources.Textures.TTexture;
   import Foundation.Timing.STimingCore;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityFilter;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.VO.Json.TRewards;
   import Logics.DatebaseVO.VO.TBaseHero;
   import Logics.DatebaseVO.VO.TRoleModel;
   import Logics.HDActivityCircleTrial.TActivityCircleHeroData;
   import Logics.HDIceHeros.TActivityIHAward;
   import Logics.Inventories.TInventories;
   import Logics.KnifeOfKillSoul.TKnifeOfKillSoulData;
   import Logics.Log.TLog;
   import Logics.Map.TMoudleInfor;
   import Logics.SLogicsCore;
   import Processors.Game.Lobby.Activity.HDChineseYear.Component.TKnifePop;
   import Processors.Game.Lobby.Activity.HDGeneralSell.Compoent.TUIIceHeroPlayer;
   import Processors.Game.Lobby.Common.Hero.TProcessorWindowHeroDescription;
   import Processors.Game.Lobby.Common.Map.SceneSprite.TSceneSpriteMoudle;
   import Processors.Game.Lobby.Jade.TJadeCommon;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Processors.Game.Utilities.HyperLink.SUtilityHyperLink;
   import Processors.Game.Utilities.HyperLink.TUtilityHyperLink;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Processors.Game.Windows.Information.TUIWindowConfirmation;
   import Resources.Constants.*;
   import Utilities.Timing.*;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.utils.setTimeout;
   import ghostcat.util.data.Json;
   import ghostcat.util.easing.TweenUtil;
   
   public class TProcessorWindowHDTrialExchange extends TUIComponent
   {
      
      protected static const OutterCircleSlotNum:int = 12;
      
      protected static const DebrisAwardCount:int = 5;
      
      protected static const ExtractCount:int = 4;
      
      protected static const TenCount:int = 10;
      
      protected static const FiftyCount:int = 50;
      
      protected static const Fpercent:Number = 100;
      
      protected static const Filters:Array = [TUtilityFilter.highLightFilters];
      
      protected static const DelayTimes:int = 1000;
      
      protected static const TabIndexLuckyLottery:int = 0;
      
      protected static const TabIndexGoldLottery:int = 1;
      
      protected static const KNIFE_WIDTH:uint = 254;
      
      protected static const KNIFE_HEIGHT:uint = 435;
      
      protected static const SnakeLength:int = 1;
      
      protected static const AccelerationSpeed:int = 3;
      
      protected static const StartSpeed:int = 60;
      
      protected static const EndSpeed:int = 20;
      
      protected static const SnakeStateNone:int = 0;
      
      protected static const SnakeStateAddSpped:int = 1;
      
      protected static const SnakeStateSubSpeed:int = 2;
      
      protected static const SnakeStateLocate:int = 3;
      
      protected var FSnakeHeads:Vector.<int>;
      
      protected var TimeStore:int;
      
      protected var FCurrentSpeed:int;
      
      protected var FSpeedDirection:int;
      
      protected var FCurrentSnakeState:int;
      
      protected var FCurrentSelectBox:Vector.<Sprite>;
      
      protected var FCurrentHitBoxIndex:Vector.<int>;
      
      protected var FCurrentHitBoxState:Vector.<Boolean>;
      
      protected var FOutSlots:Vector.<TUISlot>;
      
      protected var FOutSelectBoxs:Vector.<Sprite>;
      
      protected var FOutDebrisVec:Vector.<Sprite>;
      
      protected var FTFLastTimes:TextField;
      
      protected var FBtnLotteryOne:TUIButton;
      
      protected var FBtnLotteryTen:TUIButton;
      
      protected var FBtnLotteryFifty:TUIButton;
      
      protected var FTotalExtractTimes:TextField;
      
      protected var FScrollBar:TScrollBar;
      
      protected var FScene:Sprite;
      
      protected var FShowExtractRecordTF:TextField;
      
      protected var FTaskFinishSp:Sprite;
      
      protected var FTaskDescribeTF:TextField;
      
      protected var FProgressTF:TextField;
      
      protected var FFinishConditionTF:TextField;
      
      protected var FGotoTaskBtn:TUIButton;
      
      protected var FRefreshTaskBtn:TUIButton;
      
      protected var FRechargeNeedTF:TextField;
      
      protected var FRechargeCurTF:TextField;
      
      protected var FGiftBtn:TUIButton;
      
      protected var FMC_HeroNameTF:TextField;
      
      protected var FMC_MountPoint:Sprite;
      
      protected var FMC_AlreadyGet:Sprite;
      
      protected var FMC_NeedDebrisTF:TextField;
      
      protected var FMC_CurDebrisTF:TextField;
      
      protected var FMC_RightNowExchangeBtn:TUIButton;
      
      protected var UIIceHeroPlayer:TUIIceHeroPlayer;
      
      protected var FRoleModelIDs:Vector.<uint>;
      
      protected var FHeroData:TActivityIHAward;
      
      protected var FKnifePop:TKnifePop;
      
      protected var FMC_KnifeInfo:Sprite;
      
      protected var FKnifeOfKillSoulData:TKnifeOfKillSoulData;
      
      protected var FDebrisList:Vector.<TUIButton>;
      
      protected var FDebrisValueTFList:Vector.<TextField>;
      
      protected var FDebrisGetStateSPVec:Vector.<Sprite>;
      
      protected var FGiftList:Vector.<TUIButton>;
      
      protected var FGiftTFList:Vector.<TextField>;
      
      protected var FGiftFinishSPList:Vector.<Sprite>;
      
      protected var FGiftTips:Vector.<TUIButton>;
      
      protected var FBins:TBins;
      
      protected var FRoleMoudles:Vector.<TSceneSpriteMoudle>;
      
      protected var FQueryModel:TMoudleInfor;
      
      protected var FHint:THint;
      
      protected var FShowAwardRecordTF:TextField;
      
      protected var FWindowShowHero:TProcessorWindowHeroDescription;
      
      protected var FIsExtractOver:Boolean = true;
      
      protected var FIndex:int;
      
      protected var FActivityCircleHeroData:TActivityCircleHeroData;
      
      protected var FGiftMoveFun:Function;
      
      protected var FGiftOutFun:Function;
      
      protected var FSendData:Function;
      
      protected var FOnLoadLog:Function;
      
      protected var FOnCreateKnifeOfKillSoulData:Function;
      
      public function TProcessorWindowHDTrialExchange(param1:TUIComponent, param2:Sprite)
      {
         super(param1);
         this.FScene = param2;
         this.FBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_BaseHero);
         this.FRoleMoudles = new Vector.<TSceneSpriteMoudle>();
         this.FQueryModel = new TMoudleInfor();
         this.FHint = new THint();
         this.FWindowShowHero = new TProcessorWindowHeroDescription(this.Parent);
         this.FWindowShowHero.Perform_UIDispatch();
         this.FWindowShowHero.HintOnOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FWindowShowHero.HintOnOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FWindowShowHero.OnClose = this.BtnCloseLukiaWindowOnMouseClick;
         this.UIIceHeroPlayer = new TUIIceHeroPlayer(this);
         this.UIIceHeroPlayer.OnBtnOKClick = this.ProcessorHeroBtnOKOnClick;
         this.UIIceHeroPlayer.OnShowHeroClick = this.ProcessorShowHeroOnClick;
         this.UIIceHeroPlayer.SequenceDefaultRole = SResourcesCore.TexturesLobby.GetAnimationSequenceByIdentifiers(CONST_LOBBY.RESOURCEID_Textures_DefaultRole,0);
         this.UIIceHeroPlayer.OnQuerySequenceContext = this.HeroOnQuerySequenceContext;
         this.UIIceHeroPlayer.Perform_UIDispatch(this.FScene["MC_Hero"]);
         this.FRoleModelIDs = new Vector.<uint>();
         this.FHeroData = new TActivityIHAward(0);
         this.FKnifePop = new TKnifePop(this);
         this.FKnifePop.OnPopColse = this.KnifePopOnClose;
         this.FKnifePop.UIDispatch();
         this.FKnifePop.X = (this.Width - KNIFE_WIDTH) / 2 + this.width;
         this.FKnifePop.Y = (this.Height - KNIFE_HEIGHT) / 2;
         this.FKnifePop.Visible = false;
         this.InitWindow();
      }
      
      protected function InitWindow() : void
      {
         this.UIDispatch_LotteryArea();
         this.UIDispatch_RankArea();
         this.UIDispatch_Task();
         this.UIDispatch_Recharge();
         this.UIDispatch_Hero();
         this.UIDispatch_DebrisGift();
      }
      
      protected function UIDispatch_LotteryArea() : void
      {
         var _loc1_:Sprite = null;
         var _loc2_:Sprite = null;
         var _loc3_:TUISlot = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TUIButton = null;
         var _loc7_:TUIButton = null;
         var _loc8_:Sprite = null;
         this.FOutSlots = new Vector.<TUISlot>();
         this.FOutSelectBoxs = new Vector.<Sprite>();
         this.FOutDebrisVec = new Vector.<Sprite>();
         this.FGiftList = new Vector.<TUIButton>();
         this.FGiftTFList = new Vector.<TextField>();
         this.FGiftFinishSPList = new Vector.<Sprite>();
         this.FGiftTips = new Vector.<TUIButton>();
         _loc4_ = 0;
         while(_loc4_ < OutterCircleSlotNum)
         {
            _loc2_ = this.FScene["Item" + _loc4_];
            _loc3_ = new TUISlot(this);
            _loc3_.Resource = _loc2_["Slot"];
            TJadeCommon.InitSlot(_loc3_);
            _loc3_.OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
            _loc3_.OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
            _loc3_.Init();
            this.FOutSlots.push(_loc3_);
            this.FOutSelectBoxs.push(_loc2_["SelectBox"]);
            this.FOutSelectBoxs[_loc4_].visible = false;
            this.FOutSelectBoxs[_loc4_].mouseEnabled = false;
            this.FOutSelectBoxs[_loc4_].mouseChildren = false;
            this.FOutDebrisVec.push(_loc2_["MC_Debris"]);
            this.FOutDebrisVec[_loc4_].visible = false;
            _loc4_++;
         }
         this.FTFLastTimes = this.FScene["TF_ExtractTime"];
         this.FTotalExtractTimes = this.FScene["TF_TotalExtractTimes"];
         this.FBtnLotteryOne = new TUIButton();
         this.FBtnLotteryOne.Substrate = this.FScene["Btn_ExtractOne"];
         this.FBtnLotteryOne.OnClick = this.BtnLotteryOneOnClick;
         this.FBtnLotteryOne.OnMove = this.BtnOnMove;
         this.FBtnLotteryOne.OnOut = this.BtnOnOut;
         this.FBtnLotteryTen = new TUIButton();
         this.FBtnLotteryTen.Substrate = this.FScene["Btn_ExtractTen"];
         this.FBtnLotteryTen.OnClick = this.BtnLotteryTenOnClick;
         this.FBtnLotteryTen.OnMove = this.BtnOnMove;
         this.FBtnLotteryTen.OnOut = this.BtnOnOut;
         this.FBtnLotteryFifty = new TUIButton();
         this.FBtnLotteryFifty.Substrate = this.FScene["Btn_ExtractFifty"];
         this.FBtnLotteryFifty.OnClick = this.BtnLotteryFiftyOnClick;
         this.FBtnLotteryFifty.OnMove = this.BtnOnMove;
         this.FBtnLotteryFifty.OnOut = this.BtnOnOut;
         this.FCurrentHitBoxIndex = new Vector.<int>();
         this.FCurrentHitBoxState = new Vector.<Boolean>();
         this.FSnakeHeads = new Vector.<int>();
         _loc5_ = ExtractCount;
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc6_ = new TUIButton();
            _loc1_ = this.FScene["ItemAward" + _loc4_];
            _loc6_.Substrate = _loc1_["MC_Gift"];
            _loc6_.OnMove = this.GiftBagOnMove;
            _loc6_.OnOut = this.GiftBagOnOut;
            _loc6_.OnClick = this.GetAwardOnClick;
            this.FGiftList.push(_loc6_);
            this.FGiftTFList.push(_loc1_["TF_ExtractValue"]);
            this.FGiftFinishSPList.push(_loc1_["MC_Finish"]);
            _loc7_ = new TUIButton();
            _loc7_.Substrate = this.FScene["MC_Tips" + _loc4_];
            _loc7_.OnMove = this.OverDebrisTips;
            _loc7_.OnOut = this.BtnOnOut;
            this.FGiftTips.push(_loc7_);
            _loc4_++;
         }
      }
      
      protected function UIDispatch_RankArea() : void
      {
         this.FShowAwardRecordTF = this.FScene["MC_InfoList"]["TF_GetAwardRecord"];
      }
      
      protected function UIDispatch_Task() : void
      {
         var _loc1_:Sprite = null;
         _loc1_ = this.FScene["MC_Task"];
         this.FTaskFinishSp = _loc1_["MC_ItemOK"];
         this.FTaskDescribeTF = _loc1_["TF_Describe"];
         this.FProgressTF = _loc1_["TF_Progress"];
         this.FFinishConditionTF = _loc1_["TF_FinishGetPrompt"];
         this.FGotoTaskBtn = new TUIButton();
         this.FGotoTaskBtn.Substrate = _loc1_["Btn_Go"];
         this.FGotoTaskBtn.OnClick = this.GotoTaskOnClick;
         this.FRefreshTaskBtn = new TUIButton();
         this.FRefreshTaskBtn.Substrate = _loc1_["Btn_Refresh"];
         this.FRefreshTaskBtn.OnClick = this.UpdataTaskOnClick;
         this.FRefreshTaskBtn.OnMove = this.BtnOnMove;
         this.FRefreshTaskBtn.OnOut = this.BtnOnOut;
      }
      
      protected function UIDispatch_Recharge() : void
      {
         var _loc1_:Sprite = null;
         _loc1_ = this.FScene["MC_Recharge"];
         this.FRechargeNeedTF = _loc1_["TF_RechargeValue"];
         this.FRechargeCurTF = _loc1_["TF_CurValue"];
         this.FGiftBtn = new TUIButton();
         this.FGiftBtn.Substrate = _loc1_["MC_Gift"];
         this.FGiftBtn.OnClick = this.GetRechargeGiftOnClick;
         this.FGiftBtn.OnMove = this.RechargeGiftBagOnMove;
         this.FGiftBtn.OnOut = this.GiftBagOnOut;
      }
      
      protected function UIDispatch_Hero() : void
      {
         var _loc1_:TSceneSpriteMoudle = null;
         var _loc2_:Sprite = null;
         _loc2_ = this.FScene["MC_Hero"];
         this.FMC_HeroNameTF = _loc2_["TF_HeroName"];
         this.FMC_MountPoint = _loc2_["MC_MountPoint"];
         this.FMC_AlreadyGet = _loc2_["MC_AlreadyGet"];
         this.FMC_NeedDebrisTF = _loc2_["TF_OpenCondition"];
         this.FMC_CurDebrisTF = _loc2_["TF_Debris"];
         this.FMC_RightNowExchangeBtn = new TUIButton();
         this.FMC_RightNowExchangeBtn.Substrate = _loc2_["Btn_OK"];
         this.FMC_RightNowExchangeBtn.OnClick = this.ExchangeHeroOnClick;
         this.FMC_RightNowExchangeBtn.OnMove = this.BtnOnMove;
         this.FMC_RightNowExchangeBtn.OnOut = this.BtnOnOut;
         this.FMC_MountPoint.addEventListener(MouseEvent.MOUSE_OVER,this.HeroOnMouseOver);
         this.FMC_MountPoint.addEventListener(MouseEvent.MOUSE_OUT,this.HeroOnMouseOut);
         this.FMC_MountPoint.addEventListener(MouseEvent.CLICK,this.HitHeroClickHandler);
         _loc1_ = new TSceneSpriteMoudle();
         this.FRoleMoudles.push(_loc1_);
      }
      
      protected function UIDispatch_DebrisGift() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TUIButton = null;
         var _loc4_:TextField = null;
         var _loc5_:Sprite = null;
         this.FDebrisList = new Vector.<TUIButton>();
         this.FDebrisValueTFList = new Vector.<TextField>();
         this.FDebrisGetStateSPVec = new Vector.<Sprite>();
         _loc2_ = DebrisAwardCount;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = new TUIButton();
            _loc3_.Substrate = this.FScene["MC_ExchangItem" + _loc1_]["MC_ExchangBtn"];
            _loc3_.OnMove = this.DebrisBagOnMove;
            _loc3_.OnOut = this.GiftBagOnOut;
            _loc3_.OnClick = this.GetDebrisAwardOnClick;
            this.FDebrisList.push(_loc3_);
            _loc4_ = this.FScene["MC_ExchangItem" + _loc1_]["TF_ExchangValue"];
            this.FDebrisValueTFList.push(_loc4_);
            _loc5_ = this.FScene["MC_ExchangItem" + _loc1_]["MC_Finish"];
            this.FDebrisGetStateSPVec.push(_loc5_);
            _loc1_++;
         }
      }
      
      protected function UpdateUI() : void
      {
         this.UpdateCurHero();
         this.RefreshRecharge();
         this.RefreshTask();
         this.RenderShowExtractList();
         this.RenderHeroModel();
         this.RefreshDebrisGift();
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
      
      protected function RefreshRecharge() : void
      {
         this.FRechargeCurTF.text = this.FActivityCircleHeroData.CurRechargeValue.toString();
         this.FRechargeNeedTF.text = this.FActivityCircleHeroData.NeedRechargeValue.toString();
         if(this.FActivityCircleHeroData.RechargeGiftState == -1)
         {
            this.FGiftBtn.Enabled = false;
         }
         else
         {
            this.FGiftBtn.Enabled = true;
         }
      }
      
      protected function RefreshTask() : void
      {
         this.FTaskDescribeTF.text = this.FActivityCircleHeroData.TaskVo.TaskDescribeStr;
         this.FProgressTF.text = this.FActivityCircleHeroData.TaskVo.CurrentTimes + "/" + this.FActivityCircleHeroData.TaskVo.TotalTimes;
         if(this.FActivityCircleHeroData.TaskVo.CurrentTimes >= this.FActivityCircleHeroData.TaskVo.TotalTimes)
         {
            this.FTaskFinishSp.visible = true;
         }
         else
         {
            this.FTaskFinishSp.visible = false;
         }
         this.FFinishConditionTF.text = this.FActivityCircleHeroData.TaskVo.AwardDescribeStr;
      }
      
      protected function RenderShowExtractList() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TInventories = null;
         _loc2_ = int(this.FActivityCircleHeroData.ExtractInventories.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FActivityCircleHeroData.ExtractInventories[_loc1_];
            if(_loc3_ != null)
            {
               this.FOutSlots[_loc1_].Context = null;
               this.FOutSlots[_loc1_].Context = _loc3_.GetInventoryByIndex(0);
            }
            else
            {
               this.FOutDebrisVec[_loc1_].visible = true;
            }
            _loc1_++;
         }
         this.FTFLastTimes.text = this.FActivityCircleHeroData.FreeTimes.toString();
         this.FTotalExtractTimes.text = this.FActivityCircleHeroData.ExtractTotalTimes.toString();
         _loc2_ = int(this.FActivityCircleHeroData.ExtractAwardVec.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FGiftTFList[_loc1_].text = this.FActivityCircleHeroData.ExtractAwardVec[_loc1_].TotalTimes.toString();
            this.FGiftFinishSPList[_loc1_].visible = this.FActivityCircleHeroData.ExtractAwardVec[_loc1_].GetDebrisState == -1 ? true : false;
            _loc1_++;
         }
      }
      
      protected function RenderHeroModel() : void
      {
         var _loc1_:int = 0;
         var _loc2_:TSceneSpriteMoudle = null;
         var _loc3_:TBaseHero = null;
         if(this.FActivityCircleHeroData.CurrentDebris >= this.FActivityCircleHeroData.CircleHeroConfig.NeedDebrisAmount)
         {
            this.FMC_RightNowExchangeBtn.Caption = this.FActivityCircleHeroData.CircleHeroConfig.ExchangePrompt;
         }
         else
         {
            this.FMC_RightNowExchangeBtn.Caption = this.FActivityCircleHeroData.CircleHeroConfig.AddChipPrompt;
         }
         if(this.FActivityCircleHeroData.HeroState == -1)
         {
            this.FMC_AlreadyGet.visible = true;
            this.FMC_RightNowExchangeBtn.Caption = this.FActivityCircleHeroData.CircleHeroConfig.ExchangePrompt;
            this.FMC_RightNowExchangeBtn.Enabled = false;
         }
         else
         {
            this.FMC_AlreadyGet.visible = false;
            this.FMC_RightNowExchangeBtn.Enabled = true;
         }
         this.FMC_NeedDebrisTF.text = this.FActivityCircleHeroData.CircleHeroConfig.NeedDebrisAmount.toString();
         this.FMC_CurDebrisTF.text = this.FActivityCircleHeroData.CurrentDebris.toString();
         this.FHeroData.Status = this.FActivityCircleHeroData.HeroState < 0 ? this.FActivityCircleHeroData.HeroState : 1;
      }
      
      protected function RefreshDebrisGift() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc2_ = int(this.FActivityCircleHeroData.DebrisGiftVec.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FDebrisValueTFList[_loc1_].text = this.FActivityCircleHeroData.DebrisGiftVec[_loc1_].TotalTimes.toString();
            if(this.FActivityCircleHeroData.DebrisGiftVec[_loc1_].GetDebrisState == -1)
            {
               this.FDebrisGetStateSPVec[_loc1_].visible = true;
            }
            else
            {
               this.FDebrisGetStateSPVec[_loc1_].visible = false;
            }
            _loc1_++;
         }
      }
      
      protected function UpdateRoleModel() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc2_ = int(this.FRoleMoudles.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            if(this.FRoleMoudles[_loc1_].TextrueID != 0)
            {
               this.FRoleMoudles[_loc1_].UpdateView();
            }
            _loc1_++;
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
                  this.SnakeHeadGoNextStep(this.FOutSelectBoxs);
                  this.DrawSnake(this.FOutSelectBoxs,SnakeLength);
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
                  this.SnakeHeadGoNextStep(this.FOutSelectBoxs);
                  this.DrawSnake(this.FOutSelectBoxs,SnakeLength);
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
                  this.ClearSnake(this.FOutSelectBoxs);
                  this.SnakeLocate(this.FOutSelectBoxs);
                  this.FScene.mouseChildren = true;
                  this.FScene.mouseEnabled = true;
                  return;
               }
               if(_loc1_ > this.FCurrentSpeed)
               {
                  this.SnakeHeadGoNextStep(this.FOutSelectBoxs);
                  this.DrawSnake(this.FOutSelectBoxs,1);
                  this.SnakeLocate(this.FOutSelectBoxs);
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
      
      protected function MoreExtractAnima() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Sprite = null;
         _loc2_ = int(this.FOutSelectBoxs.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FOutSelectBoxs[_loc1_];
            _loc3_.visible = true;
            _loc3_.alpha = 1;
            TweenUtil.to(_loc3_,800,{"alpha":0});
            _loc1_++;
         }
      }
      
      protected function SendServiceData(param1:int = 0) : void
      {
         if(param1 != 0)
         {
            this.FIndex = param1;
         }
         if(this.FSendData != null)
         {
            this.FSendData(this.FIndex);
         }
      }
      
      protected function LogArrive(param1:Vector.<TLog>) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TRewards = null;
         var _loc5_:TLog = null;
         var _loc6_:Object = null;
         var _loc7_:Vector.<String> = null;
         var _loc8_:String = null;
         var _loc9_:String = null;
         _loc3_ = int(param1.length);
         _loc7_ = new Vector.<String>();
         _loc9_ = "";
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc5_ = param1[_loc2_];
            _loc8_ = "";
            _loc6_ = Json.decode(_loc5_.Data);
            _loc8_ = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_68),"",SToolReward.GetNameByTypeCode(_loc6_.type,_loc6_.code),_loc6_.amount);
            _loc9_ += _loc8_ + "\n";
            _loc2_++;
         }
         this.FShowAwardRecordTF.text = _loc9_;
      }
      
      protected function ClearSelectBox() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc2_ = int(this.FOutSelectBoxs.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FOutSelectBoxs[_loc1_].alpha = 1;
            _loc1_++;
         }
      }
      
      protected function UpdateCurHero() : void
      {
         this.FHeroData.HeroType = this.FActivityCircleHeroData.CircleHeroConfig.HeroType;
         this.FHeroData.HeroID = this.FActivityCircleHeroData.CircleHeroConfig.HeroId;
         this.FHeroData.Condition = this.FActivityCircleHeroData.CircleHeroConfig.NeedDebrisAmount;
         this.UIIceHeroPlayer.UpdateUI(this.FHeroData,SLogicsCore.Character.CreditGold,TUIIceHeroPlayer.BuyType_Gold);
      }
      
      protected function UpdateTaskRequest(param1:Object) : void
      {
         var _loc2_:int = 0;
         _loc2_ = this.FActivityCircleHeroData.CircleHeroConfig.RefreshTaskIndex;
         this.SendServiceData(_loc2_);
      }
      
      protected function BtnLotteryOneRequest(param1:Object) : void
      {
         var Index:int = 0;
         var Sender:Object = param1;
         Index = this.FActivityCircleHeroData.CircleHeroConfig.ExtractOneIndex;
         if(this.FActivityCircleHeroData.FreeTimes <= 0 && SLogicsCore.Character.CreditGold < this.FActivityCircleHeroData.CircleHeroConfig.ExtractCost)
         {
            SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.NOTENOUGH_Gold));
            return;
         }
         if(this.FIsExtractOver)
         {
            this.FIsExtractOver = false;
            this.FSnakeHeads.length = 0;
            this.FSnakeHeads.push(0);
            this.FCurrentSnakeState = SnakeStateAddSpped;
            this.ClearSelectBox();
            setTimeout(function DelayExtactFun():void
            {
               SendServiceData(Index);
            },DelayTimes);
         }
      }
      
      protected function BtnLotteryTenRequest(param1:Object) : void
      {
         var _loc2_:int = 0;
         _loc2_ = this.FActivityCircleHeroData.CircleHeroConfig.ExtractTenIndex;
         if(this.FIsExtractOver)
         {
            this.SendServiceData(_loc2_);
         }
      }
      
      protected function BtnLotteryFiftyRequest(param1:Object) : void
      {
         var _loc2_:int = 0;
         _loc2_ = this.FActivityCircleHeroData.CircleHeroConfig.ExtractFiftyIndex;
         if(this.FIsExtractOver)
         {
            this.SendServiceData(_loc2_);
         }
      }
      
      protected function BtnLotteryOneOnClick(param1:Object, param2:MouseEvent) : void
      {
         SUtilityOverLayer.UIWindowConfirmation.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_06),this.FActivityCircleHeroData.CircleHeroConfig.ExtractCost);
         SUtilityOverLayer.UIWindowConfirmation.OnOK = this.BtnLotteryOneRequest;
         SUtilityOverLayer.UIWindowConfirmation.Visible = true;
      }
      
      protected function BtnLotteryTenOnClick(param1:Object, param2:MouseEvent) : void
      {
         SUtilityOverLayer.UIWindowConfirmation.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_06),this.FActivityCircleHeroData.CircleHeroConfig.ExtractCost * 10);
         SUtilityOverLayer.UIWindowConfirmation.OnOK = this.BtnLotteryTenRequest;
         SUtilityOverLayer.UIWindowConfirmation.Visible = true;
      }
      
      protected function BtnLotteryFiftyOnClick(param1:Object, param2:MouseEvent) : void
      {
         SUtilityOverLayer.UIWindowConfirmation.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_06),this.FActivityCircleHeroData.CircleHeroConfig.ExtractCost * 50);
         SUtilityOverLayer.UIWindowConfirmation.OnOK = this.BtnLotteryFiftyRequest;
         SUtilityOverLayer.UIWindowConfirmation.Visible = true;
      }
      
      protected function BtnCloseOnClick(param1:Object, param2:MouseEvent) : void
      {
      }
      
      protected function ExchangeHeroOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         if(this.FActivityCircleHeroData.CircleHeroConfig.NeedDebrisAmount > this.FActivityCircleHeroData.CurrentDebris && this.FActivityCircleHeroData.HeroState != -1)
         {
            _loc3_ = this.FActivityCircleHeroData.CircleHeroConfig.AddChipIndex;
         }
         else
         {
            _loc3_ = this.FActivityCircleHeroData.CircleHeroConfig.ExchangeHeroIndex;
         }
         this.SendServiceData(_loc3_);
      }
      
      protected function GiftBagOnMove(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         _loc3_ = this.FGiftList.indexOf(param1 as TUIButton);
         if(this.FGiftMoveFun != null)
         {
            this.FGiftMoveFun(this.FActivityCircleHeroData.ExtractAwardVec[_loc3_].Inventories);
         }
      }
      
      protected function RechargeGiftBagOnMove(param1:Object, param2:MouseEvent) : void
      {
         if(this.FGiftMoveFun != null)
         {
            this.FGiftMoveFun(this.FActivityCircleHeroData.RechargeInventories);
         }
      }
      
      protected function GiftBagOnOut(param1:Object, param2:MouseEvent) : void
      {
         if(this.FGiftOutFun != null)
         {
            this.FGiftOutFun();
         }
      }
      
      protected function GetAwardOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _loc3_ = this.FGiftList.indexOf(param1 as TUIButton);
         _loc4_ = this.FActivityCircleHeroData.ExtractAwardVec[_loc3_].Index;
         this.SendServiceData(_loc4_);
      }
      
      protected function DebrisBagOnMove(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         _loc3_ = this.FDebrisList.indexOf(param1 as TUIButton);
         if(this.FGiftMoveFun != null)
         {
            this.FGiftMoveFun(this.FActivityCircleHeroData.DebrisGiftVec[_loc3_].Inventories);
         }
      }
      
      protected function GetDebrisAwardOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:TUIWindowConfirmation = null;
         var _loc8_:int = 0;
         _loc3_ = this.FDebrisList.indexOf(param1 as TUIButton);
         _loc4_ = this.FActivityCircleHeroData.DebrisGiftVec[_loc3_].Index;
         _loc6_ = this.FActivityCircleHeroData.DebrisGiftVec[_loc3_].TotalTimes;
         _loc5_ = this.FActivityCircleHeroData.CurrentDebris;
         this.FIndex = _loc4_;
         if(_loc5_ >= _loc6_)
         {
            this.SendServiceData(_loc4_);
         }
         else
         {
            _loc8_ = (_loc6_ - _loc5_) * this.FActivityCircleHeroData.CircleHeroConfig.ChipMoney;
            _loc7_ = SUtilityOverLayer.UIWindowConfirmation;
            _loc7_.Text = TUtilityString.Format(this.FActivityCircleHeroData.CircleHeroConfig.PopUpPrompt,_loc8_);
            _loc7_.OnOK = this.SendServiceData;
            _loc7_.Visible = true;
         }
      }
      
      protected function GotoTaskOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         _loc3_ = this.FActivityCircleHeroData.TaskVo.GotoModuleId;
         SUtilityHyperLink.ShortcutHyperlink(_loc3_);
         if(_loc3_ == TUtilityHyperLink.HyperLink_ReturnCity)
         {
         }
      }
      
      protected function UpdataTaskOnClick(param1:Object, param2:MouseEvent) : void
      {
         SUtilityOverLayer.UIWindowConfirmation.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_06),this.FActivityCircleHeroData.CircleHeroConfig.RefreshTaskCost);
         SUtilityOverLayer.UIWindowConfirmation.OnOK = this.UpdateTaskRequest;
         SUtilityOverLayer.UIWindowConfirmation.Visible = true;
      }
      
      protected function GetRechargeGiftOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         _loc3_ = this.FActivityCircleHeroData.CircleHeroConfig.RechargeGiftIndex;
         this.SendServiceData(_loc3_);
      }
      
      protected function BtnOnMove(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TUIButton = null;
         var _loc4_:String = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         _loc3_ = param1 as TUIButton;
         if(_loc3_ == this.FBtnLotteryOne)
         {
            this.FHint.Caption = this.GetCurSpeedGold(1,Fpercent);
         }
         else if(_loc3_ == this.FBtnLotteryTen)
         {
            this.FHint.Caption = this.GetCurSpeedGold(TenCount,this.FActivityCircleHeroData.CircleHeroConfig.Discount);
         }
         else if(_loc3_ == this.FBtnLotteryFifty)
         {
            this.FHint.Caption = this.GetCurSpeedGold(FiftyCount,this.FActivityCircleHeroData.CircleHeroConfig.Discount);
         }
         else if(_loc3_ == this.FRefreshTaskBtn)
         {
            _loc4_ = TUtilityString.Format(this.FActivityCircleHeroData.CircleHeroConfig.SpeedPrompt,this.FActivityCircleHeroData.CircleHeroConfig.RefreshTaskCost);
            this.FHint.Caption = _loc4_;
         }
         else if(_loc3_ == this.FMC_RightNowExchangeBtn)
         {
            if(this.FActivityCircleHeroData.CurrentDebris >= this.FActivityCircleHeroData.CircleHeroConfig.NeedDebrisAmount || this.FActivityCircleHeroData.HeroState == -1)
            {
               return;
            }
            _loc6_ = this.FActivityCircleHeroData.CurrentDebris;
            _loc7_ = this.FActivityCircleHeroData.CircleHeroConfig.NeedDebrisAmount;
            _loc5_ = (_loc7_ - _loc6_) * this.FActivityCircleHeroData.CircleHeroConfig.ChipMoney;
            _loc4_ = TUtilityString.Format(this.FActivityCircleHeroData.CircleHeroConfig.PopUpPrompt,_loc5_);
            this.FHint.Caption = _loc4_;
         }
         SUtilityOverLayer.UIComponentsHintOnOver(this,this.FHint);
      }
      
      private function GetCurSpeedGold(param1:int, param2:Number) : String
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         _loc3_ = this.FActivityCircleHeroData.FreeTimes - param1;
         if(_loc3_ >= 0)
         {
            _loc4_ = 0;
         }
         else
         {
            _loc4_ = Math.abs(_loc3_) * this.FActivityCircleHeroData.CircleHeroConfig.ExtractCost * param2 / 100;
         }
         return TUtilityString.Format(this.FActivityCircleHeroData.CircleHeroConfig.SpeedPrompt,_loc4_);
      }
      
      protected function BtnOnOut(param1:Object, param2:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOut(this,this.FHint);
      }
      
      protected function BtnCloseLukiaWindowOnMouseClick(param1:Object) : void
      {
         this.FWindowShowHero.Hide();
      }
      
      protected function HeroOnMouseOver(param1:MouseEvent) : void
      {
         this.FMC_MountPoint.filters = Filters;
      }
      
      protected function HeroOnMouseOut(param1:MouseEvent) : void
      {
         this.FMC_MountPoint.filters = null;
      }
      
      protected function HitHeroClickHandler(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
      }
      
      protected function ProcessorHeroBtnOKOnClick(param1:Object, param2:uint) : void
      {
      }
      
      protected function ProcessorShowHeroOnClick(param1:Object, param2:TActivityIHAward) : void
      {
         if(param2.HeroType == 1)
         {
            this.FWindowShowHero.HeroID = param2.HeroID;
            this.FWindowShowHero.Show();
         }
         if(param2.HeroType == 2)
         {
            this.FKnifeOfKillSoulData = this.FOnCreateKnifeOfKillSoulData(param2.HeroID);
            this.FKnifePop.KnifeData = this.FKnifeOfKillSoulData;
            this.FKnifePop.Visible = true;
         }
      }
      
      protected function HeroOnQuerySequenceContext(param1:Object, param2:Object, param3:TQueryAnimationSequence, param4:uint = 0) : void
      {
         var _loc5_:uint = 0;
         var _loc6_:TResourceRepositoryTexture = null;
         var _loc7_:TTexture = null;
         var _loc8_:TRoleModel = null;
         var _loc9_:uint = 0;
         _loc5_ = param2 as uint;
         _loc6_ = SResourcesCore.TexturesModel;
         _loc8_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_RoleModel,_loc5_) as TRoleModel;
         if(_loc8_ == null)
         {
            return;
         }
         _loc9_ = (_loc8_.Model << 8) + CONST_ROLE.ROLE_SEQUENCEINDEX_Showcase;
         _loc7_ = _loc6_.GetTextureByIdentifier(_loc9_);
         if(_loc7_ != null)
         {
            param3.Value = _loc7_.GetAnimationSequenceByIndex(0);
         }
         else
         {
            _loc6_.LoadSecondary(_loc9_);
         }
         this.SetRoleModelID(_loc9_);
      }
      
      protected function SetRoleModelID(param1:uint) : void
      {
         var _loc2_:int = 0;
         _loc2_ = this.FRoleModelIDs.indexOf(param1);
         if(_loc2_ < 0)
         {
            this.FRoleModelIDs.push(param1);
         }
      }
      
      protected function KnifePopOnClose(param1:Object) : void
      {
         this.FKnifePop.Visible = false;
      }
      
      protected function OverDebrisTips(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:String = null;
         _loc3_ = this.FGiftTips.indexOf(param1);
         _loc4_ = TUtilityString.Format(this.FActivityCircleHeroData.CircleHeroConfig.DebrisTipsPrompt,this.FActivityCircleHeroData.CircleHeroConfig.ExtrctDebrisValueVect[_loc3_]);
         this.FHint.Caption = _loc4_;
         SUtilityOverLayer.UIComponentsHintOnOver(this,this.FHint);
      }
      
      public function set ActivityCircleHeroData(param1:TActivityCircleHeroData) : void
      {
         this.FActivityCircleHeroData = param1;
      }
      
      public function get GiftMoveFun() : Function
      {
         return this.FGiftMoveFun;
      }
      
      public function set GiftMoveFun(param1:Function) : void
      {
         this.FGiftMoveFun = param1;
      }
      
      public function get GiftOutFun() : Function
      {
         return this.FGiftOutFun;
      }
      
      public function set GiftOutFun(param1:Function) : void
      {
         this.FGiftOutFun = param1;
      }
      
      public function get SendData() : Function
      {
         return this.FSendData;
      }
      
      public function set SendData(param1:Function) : void
      {
         this.FSendData = param1;
      }
      
      public function set OnLoadLog(param1:Function) : void
      {
         this.FOnLoadLog = param1;
      }
      
      public function set OnCreateKnifeOfKillSoulData(param1:Function) : void
      {
         this.FOnCreateKnifeOfKillSoulData = param1;
      }
      
      public function ShowView() : void
      {
         this.FIsExtractOver = true;
         this.UpdateUI();
         if(this.FOnLoadLog != null)
         {
            this.FOnLoadLog(CONST_LOG.LOGTYPE_CircleHero,this.LogArrive);
         }
      }
      
      public function UpdateArrive(param1:int, param2:int) : void
      {
         var _loc3_:Sprite = null;
         if(this.FActivityCircleHeroData == null)
         {
            return;
         }
         if(this.FActivityCircleHeroData.CircleHeroConfig.ExtractOneIndex == param1)
         {
            this.FIsExtractOver = true;
            this.FCurrentSnakeState = 0;
            this.TimeStore = STimingCore.TickCount;
            this.FCurrentSpeed = StartSpeed;
            _loc3_ = this.FOutSelectBoxs[param2];
            if(_loc3_ != null)
            {
               this.ClearSnake(this.FOutSelectBoxs);
               _loc3_.visible = true;
            }
         }
         else if(this.FActivityCircleHeroData.CircleHeroConfig.ExtractTenIndex == param1 || this.FActivityCircleHeroData.CircleHeroConfig.ExtractFiftyIndex == param1)
         {
            this.MoreExtractAnima();
         }
      }
      
      public function LogicsPerform() : void
      {
         if(!Visible)
         {
            return;
         }
         this.UpdateSlots(this.FOutSlots);
         this.UpdateRoleModel();
         this.UpdateSnakeMove();
         this.UIIceHeroPlayer.UpdateUIHero();
      }
   }
}

