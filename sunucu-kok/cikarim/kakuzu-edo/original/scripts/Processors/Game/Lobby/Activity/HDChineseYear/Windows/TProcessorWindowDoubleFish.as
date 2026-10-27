package Processors.Game.Lobby.Activity.HDChineseYear.Windows
{
   import Components.Standard.*;
   import Foundation.Resources.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.Characters.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.DatebaseVO.VO.Json.*;
   import Logics.HDActivityChineseYear.*;
   import Logics.HDActivityMode.*;
   import Logics.Inventories.*;
   import Logics.KnifeOfKillSoul.*;
   import Processors.Game.Lobby.Activity.HDActivity.*;
   import Processors.Game.Lobby.Activity.HDChineseYear.Component.*;
   import Processors.Game.Utilities.Common.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   import flash.utils.*;
   
   public class TProcessorWindowDoubleFish extends THDOSTabWindowBase
   {
      
      protected static const GIFT_NUM:uint = 6;
      
      protected static const RANK_WIDTH:uint = 608;
      
      protected static const RANK_HEIGHT:uint = 436;
      
      protected static const KNIFE_WIDTH:uint = 254;
      
      protected static const KNIFE_HEIGHT:uint = 435;
      
      protected static const COUNT_TF_Award:uint = 1;
      
      protected static const COUNT_Slot_Award:uint = 0;
      
      protected static const RANK_AWARD_NUM:uint = 6;
      
      protected var FFishBagItems:Vector.<TFishBag>;
      
      protected var FInventoriesList:Vector.<TInventories>;
      
      protected var FDoubleFishBin:THDDoubleFish;
      
      protected var FDoubleFishData:THDDoubleFishData;
      
      protected var FBT_Rank:TUIButton;
      
      protected var FBT_LookKnife:TUIButton;
      
      protected var FTF_CollectCount:TextField;
      
      protected var FMC_InnerTitle:MovieClip;
      
      protected var FWindowRank:TProcessorWindowDoubleFishRank;
      
      protected var FKnifePop:TKnifePop;
      
      protected var FLayer:Sprite;
      
      protected var FCharacter:TCharacter;
      
      protected var FKnifeOfKillSoulData:TKnifeOfKillSoulData;
      
      protected var FRankInventories:Vector.<TInventories>;
      
      protected var FGotIndex:uint;
      
      public function TProcessorWindowDoubleFish(param1:TUIComponent)
      {
         super(param1);
         FActivityID = CONST_ACTIVITY_MODE.Activity_DoubleFish;
         this.FFishBagItems = new Vector.<TFishBag>(GIFT_NUM);
         this.FInventoriesList = new Vector.<TInventories>(GIFT_NUM);
         this.FDoubleFishData = new THDDoubleFishData();
         this.FLayer = new Sprite();
         this.FCharacter = SLogicsCore.Character;
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         super.ResourcesPerform_UIRequest();
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_ACTIVITY.RESOURCESID_ActivityChineseYear);
      }
      
      override protected function LogicsPerform() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TFishBag = null;
         super.LogicsPerform();
         if(!Visible)
         {
            return;
         }
         _loc2_ = int(GIFT_NUM);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FFishBagItems[_loc1_];
            if(_loc3_ != null)
            {
               _loc3_.ClickEffectDisable();
            }
            _loc1_++;
         }
      }
      
      override protected function InitWindow() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TFishBag = null;
         var _loc4_:Sprite = null;
         FMC_Scene = TUtilityReflection.CreateDisplayObjectInstance(CONST_ACTIVITY.RESOURCE_ClassName_DoubleFish) as Sprite;
         addChild(FMC_Scene);
         super.InitWindow();
         this.FTF_CollectCount = FMC_Scene[CONST_ACTIVITY.RESOURCE_Link_TF_CollectCount];
         this.FMC_InnerTitle = FMC_Scene[CONST_ACTIVITY.RESOURCE_Link_MC_InnerTitle];
         this.FMC_InnerTitle.stop();
         this.FBT_Rank = new TUIButton();
         this.FBT_Rank.Substrate = FMC_Scene[CONST_ACTIVITY.RESOURCE_Link_MC_Rank];
         this.FBT_Rank.OnClick = this.RankOnClick;
         this.FBT_LookKnife = new TUIButton();
         this.FBT_LookKnife.Substrate = FMC_Scene[CONST_ACTIVITY.RESOURCE_Link_MC_LookDesc];
         this.FBT_LookKnife.OnClick = this.LookKnifeOnClick;
         _loc2_ = int(GIFT_NUM);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc4_ = FMC_Scene[CONST_ACTIVITY.RESOURCE_Link_MC_Gifts + _loc1_];
            _loc3_ = new TFishBag(this);
            _loc3_.Tag = _loc1_;
            _loc3_.OnBtnOkMove = this.GiftBoxOnMove;
            _loc3_.OnBtnOkOut = this.GiftBoxOnOut;
            _loc3_.OnBtnOkClick = this.BtnOKOnClick;
            _loc3_.Perform_UIDispatch(_loc4_,COUNT_TF_Award,COUNT_Slot_Award);
            this.FFishBagItems[_loc1_] = _loc3_;
            _loc1_++;
         }
         this.SetLayer();
         this.FWindowRank = new TProcessorWindowDoubleFishRank(this.Parent);
         this.FWindowRank.OnBagOut = ProcessorOnGiftBoxOut;
         this.FWindowRank.OnBagOver = this.RankAwardOnMove;
         this.FWindowRank.OnRankClose = this.WindowRankOnClose;
         this.FWindowRank.Init();
         this.FWindowRank.X = this.parent.x + (this.Width - RANK_WIDTH) / 2;
         this.FWindowRank.Y = this.parent.y + (this.Height - RANK_HEIGHT) / 2;
         this.FWindowRank.Visible = false;
         this.FKnifePop = new TKnifePop(this.Parent);
         this.FKnifePop.OnPopColse = this.KnifePopOnClose;
         this.FKnifePop.UIDispatch();
         this.FKnifePop.X = this.parent.x + (this.Width - KNIFE_WIDTH) / 2;
         this.FKnifePop.Y = this.parent.y + (this.Height - KNIFE_HEIGHT) / 2;
         this.FKnifePop.Visible = false;
      }
      
      protected function SetLayer() : void
      {
         this.FLayer.addChild(new Bitmap(SUtilityResource.BtmDataFullScreen));
         Parent.addChild(this.FLayer);
         this.FLayer.visible = false;
      }
      
      override protected function UpdateUIConfig() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Vector.<uint> = null;
         var _loc4_:uint = 0;
         super.UpdateUIConfig();
         this.FDoubleFishBin = FHDActivityConfig as THDDoubleFish;
         _loc3_ = new Vector.<uint>(GIFT_NUM);
         _loc2_ = int(GIFT_NUM);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_[_loc1_] = this.FDoubleFishBin.AwardList[_loc1_].Awards[0];
            _loc1_++;
         }
         this.FInventoriesList = ProcessorGetInventoriesVectByAwardID(_loc3_);
         _loc2_ = int(RANK_AWARD_NUM);
         _loc3_.length = RANK_AWARD_NUM;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_[_loc1_] = this.FDoubleFishBin.RankList[_loc1_].Awards[0];
            _loc1_++;
         }
         this.FRankInventories = ProcessorGetInventoriesVectByAwardID(_loc3_);
         this.FKnifeOfKillSoulData = this.FCharacter.KnifeOfKillSoul.GetByIndentifier(this.FDoubleFishBin.KnifeID);
         if(FActivityAtoms.TimeShowType == CONST_ACTIVITY_MODE.TYPE_TimeShowNormal)
         {
            ProcessorFormatActivityTime(FActivityAtoms.StartTime,FActivityAtoms.EndTime);
         }
         else if(FActivityAtoms.TimeShowType == CONST_ACTIVITY_MODE.TYPE_TimeShowFromNowON)
         {
            ProcessorFormatActivityTimeFromNowOn(FActivityAtoms.EndTime);
         }
         ProcessorFormatActivityCountDown(FActivityAtoms.EndTime);
      }
      
      override protected function UpdateUI() : void
      {
         super.UpdateUI();
         this.UpdateDoubleFish();
      }
      
      protected function UpdateDoubleFish() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:TFishBag = null;
         var _loc4_:THDBoxStateData = null;
         var _loc5_:TDoubleFishAward = null;
         var _loc6_:Vector.<String> = null;
         var _loc7_:uint = 0;
         this.FMC_InnerTitle.play();
         this.FTF_CollectCount.text = this.FDoubleFishData.CollectionCount.toString();
         _loc6_ = new Vector.<String>();
         _loc2_ = GIFT_NUM;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc6_.length = 0;
            _loc3_ = this.FFishBagItems[_loc1_];
            _loc4_ = this.FDoubleFishData.GetBoxByIndex(_loc1_);
            _loc5_ = this.FDoubleFishBin.AwardList[_loc1_];
            if(_loc1_ == 0)
            {
               _loc6_.push(_loc5_.Key.toString());
            }
            else
            {
               _loc7_ = this.CheckNeedNumber(_loc5_);
               _loc6_.push(_loc7_.toString());
            }
            _loc3_.UpDateUI(_loc1_,null,_loc6_);
            _loc3_.UpDateBtn(_loc4_.State);
            _loc1_++;
         }
      }
      
      protected function CheckNeedNumber(param1:TDoubleFishAward) : uint
      {
         var _loc2_:uint = 0;
         return uint(param1.Key + this.FDoubleFishBin.AddValue * this.FDoubleFishData.CurPage);
      }
      
      override protected function UpdateSCData(param1:ByteArray) : void
      {
         super.UpdateSCData(param1);
         if(FActivityAtoms.Identifier != FMemoryID)
         {
            FHDActivityConfig = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_HDDoubleFish,FActivityAtoms.ActivityNumber) as THDActivityBase;
         }
         this.FDoubleFishBin = FHDActivityConfig as THDDoubleFish;
         FActivityInitRetData = FUnstreamizerActivity.UnstreamizationPerform_Activity(param1,null);
         this.SetData(FActivityInitRetData,this.FDoubleFishData);
         if(Visible)
         {
            this.UpdateUI();
         }
         else
         {
            this.UpdataStatus(0,0,null);
         }
      }
      
      private function SetData(param1:TActivityInitRetData, param2:THDDoubleFishData) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:THDBoxStateData = null;
         var _loc6_:TActivityCrossServerRank = null;
         var _loc7_:Vector.<Object> = null;
         param2.MyRank = -1;
         param2.ClearRank();
         param2.BoxStateList = param1.AwardStates;
         param2.CurPage = param1.ParameterVec[1];
         param2.CollectionCount = param1.ParameterVec[0];
         _loc4_ = param1.AddtionalVecs[0].length;
         _loc7_ = param1.AddtionalVecs[0];
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc6_ = _loc7_[_loc3_] as TActivityCrossServerRank;
            if(_loc6_.HighID == this.FCharacter.Identifier0 && _loc6_.LowID == this.FCharacter.Identifier1)
            {
               param2.MyRank = _loc6_.Rank;
            }
            param2.AddRank(_loc6_);
            _loc3_++;
         }
         param2.RankSort();
      }
      
      override protected function Reset() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TFishBag = null;
         super.Reset();
         this.FWindowRank.Reset();
         this.FMC_InnerTitle.stop();
         _loc2_ = int(GIFT_NUM);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FFishBagItems[_loc1_];
            _loc3_.Reset();
            _loc1_++;
         }
         this.WindowRankOnClose(this);
         this.FKnifePop.Visible = false;
         this.FGotIndex = 0;
      }
      
      override protected function UpdataStatus(param1:uint, param2:int, param3:Vector.<int>) : void
      {
         var _loc4_:int = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:THDBoxStateData = null;
         _loc4_ = Activity_AlreadyReceive;
         _loc6_ = this.FDoubleFishData.BoxStateList.length;
         _loc5_ = 0;
         while(_loc5_ < _loc6_)
         {
            _loc7_ = this.FDoubleFishData.GetBoxByIndex(_loc5_);
            if(_loc7_.State >= Activity_CanReceive)
            {
               _loc4_ = Activity_CanReceive;
               break;
            }
            if(_loc7_.State == Activity_CanNotReceive)
            {
               _loc4_ = Activity_CanNotReceive;
            }
            _loc5_++;
         }
         if(FUpdateStatus != null)
         {
            FUpdateStatus(FActivityAtoms.Identifier,_loc4_);
         }
      }
      
      protected function CheckPage() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:THDBoxStateData = null;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:THDBoxStateData = null;
         var _loc7_:TDoubleFishAward = null;
         _loc2_ = GIFT_NUM;
         _loc1_ = 1;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FDoubleFishData.GetBoxByIndex(_loc1_);
            if(_loc3_.State == Activity_AlreadyReceive)
            {
               _loc4_++;
            }
            _loc1_++;
         }
         if(_loc4_ == GIFT_NUM - 1)
         {
            ++this.FDoubleFishData.CurPage;
            _loc2_ = GIFT_NUM;
            _loc1_ = 1;
            while(_loc1_ < _loc2_)
            {
               _loc3_ = this.FDoubleFishData.GetBoxByIndex(_loc1_);
               _loc6_ = this.FDoubleFishData.GetBoxByIndex(_loc1_);
               _loc7_ = this.FDoubleFishBin.AwardList[_loc1_];
               _loc5_ = this.CheckNeedNumber(_loc7_);
               if(_loc5_ < this.FDoubleFishData.CollectionCount)
               {
                  _loc6_.State = Activity_CanReceive;
               }
               else
               {
                  _loc6_.State = Activity_CanNotReceive;
               }
               _loc1_++;
            }
         }
      }
      
      protected function RankOnClick(param1:Object, param2:MouseEvent) : void
      {
         this.FLayer.visible = true;
         this.FWindowRank.UpdateRankUI(this.FDoubleFishBin,this.FDoubleFishData);
         this.FWindowRank.Visible = true;
      }
      
      protected function LookKnifeOnClick(param1:Object, param2:MouseEvent) : void
      {
         this.FLayer.visible = true;
         this.FKnifePop.KnifeData = this.FKnifeOfKillSoulData;
         this.FKnifePop.Visible = true;
      }
      
      protected function WindowRankOnClose(param1:Object) : void
      {
         this.FLayer.visible = false;
         this.FWindowRank.Visible = false;
      }
      
      protected function KnifePopOnClose(param1:Object) : void
      {
         this.FLayer.visible = false;
         this.FKnifePop.Visible = false;
      }
      
      protected function GiftBoxOnMove(param1:Object, param2:uint) : void
      {
         if(param2 != 0)
         {
            ProcessorOnGiftBoxMove(param1,this.FInventoriesList[param2]);
         }
      }
      
      protected function RankAwardOnMove(param1:Object, param2:uint) : void
      {
         ProcessorOnGiftBoxMove(param1,this.FRankInventories[param2]);
      }
      
      protected function GiftBoxOnOut(param1:Object, param2:uint) : void
      {
         ProcessorOnGiftBoxOut(param1);
      }
      
      override protected function BtnOKOnClick(param1:Object, param2:uint) : void
      {
         super.BtnOKOnClick(param1,param2);
         this.FGotIndex = param2;
      }
      
      override public function Show(param1:TActivityAtoms) : void
      {
         super.Show(param1);
         ActivityInitReq(param1.Identifier);
      }
      
      override public function ChangeActivityStatus(param1:TActivityAtoms, param2:TActAwardStatusInfo) : void
      {
         var _loc3_:THDBoxStateData = null;
         super.ChangeActivityStatus(param1,param2);
         if(this.FDoubleFishData.CountBoxStateList == 0)
         {
            ActivityInitReq(param1.Identifier);
            return;
         }
         _loc3_ = this.FDoubleFishData.GetBoxByIndex(param2.Index);
         _loc3_.State = param2.Status;
         if(Visible)
         {
            this.UpdateUI();
         }
         this.UpdataStatus(param2.Index,param2.Status,param2.Condition);
      }
      
      override public function ChangeValue(param1:TActivityAtoms, param2:Vector.<int>) : void
      {
         super.ChangeValue(param1,param2);
         this.FDoubleFishData.CollectionCount = param2[0];
         this.FDoubleFishData.CurPage = param2[1];
         if(this.Visible)
         {
            this.UpdateUI();
         }
      }
      
      override public function OperateRet() : void
      {
         super.OperateRet();
         if(this.FGotIndex != 0)
         {
            this.FFishBagItems[this.FGotIndex].ClickBackFun();
         }
         this.UpdateUI();
      }
   }
}

