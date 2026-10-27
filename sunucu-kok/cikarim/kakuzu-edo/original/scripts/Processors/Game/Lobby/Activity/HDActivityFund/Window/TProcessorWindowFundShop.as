package Processors.Game.Lobby.Activity.HDActivityFund.Window
{
   import Foundation.Resources.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.Characters.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.DatebaseVO.VO.Json.*;
   import Logics.HDActivityFund.*;
   import Logics.HDActivityMode.*;
   import Logics.Inventories.*;
   import Logics.Streamization.HDActivitFund.*;
   import Processors.Game.Lobby.Activity.HDActivity.THDOSTabWindowBase;
   import Processors.Game.Lobby.Activity.HDActivityFund.Component.TFundShopItem;
   import Processors.Game.Lobby.Utilities.*;
   import Processors.Game.Utilities.OverLayer.*;
   import Processors.Game.Windows.Information.*;
   import Resources.Constants.*;
   import Utilities.UI.Windows.*;
   import flash.display.*;
   import flash.text.*;
   import flash.utils.*;
   
   public class TProcessorWindowFundShop extends THDOSTabWindowBase
   {
      
      protected static const BOX_NUM:uint = 5;
      
      protected static const NOBUYINDEX:int = -1;
      
      protected var FFundShopBin:THDGrowFundShop;
      
      protected var FFundShopData:THDFundShopData;
      
      protected var FUnstreamizerActivityFund:TUnstreamizerActivityFund;
      
      protected var FGoodsList:Vector.<TFundShopItem>;
      
      protected var FUIWindowConfirmation:TUIWindowConfirmation;
      
      protected var FUIWindowRecharge:TUIWindowRecharge;
      
      protected var FAwardIndex:int;
      
      protected var FSP_UnBuy:Sprite;
      
      protected var FSP_AlreadyBuy:Sprite;
      
      protected var FAlreadyBuyItem:TFundShopItem;
      
      protected var FTF_ItemDesc:TextField;
      
      protected var FMC_Box:MovieClip;
      
      protected var FCharacter:TCharacter;
      
      public function TProcessorWindowFundShop(param1:TUIComponent)
      {
         super(param1);
         FActivityID = CONST_ACTIVITY_MODE.Activity_FundShop;
         this.FFundShopData = new THDFundShopData();
         this.FUnstreamizerActivityFund = new TUnstreamizerActivityFund();
         this.FGoodsList = new Vector.<TFundShopItem>(BOX_NUM);
         this.FAwardIndex = -1;
         this.FCharacter = SLogicsCore.Character;
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         super.ResourcesPerform_UIRequest();
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_ACTIVITY.RESOURCESID_ActivityFund);
      }
      
      override protected function InitWindow() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Sprite = null;
         var _loc4_:TFundShopItem = null;
         var _loc5_:Sprite = null;
         FMC_Scene = TUtilityReflection.CreateDisplayObjectInstance(CONST_ACTIVITY.RESOURCE_ClassName_FundShop) as Sprite;
         addChild(FMC_Scene);
         super.InitWindow();
         _loc3_ = FMC_Scene[CONST_ACTIVITY.RESOURCE_Link_MC_Award];
         this.FSP_UnBuy = _loc3_[CONST_ACTIVITY.RESOURCE_Link_MC_List];
         _loc2_ = int(BOX_NUM);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc5_ = this.FSP_UnBuy[CONST_ACTIVITY.RESOURCE_Link_MC_GoodsList + _loc1_];
            _loc4_ = new TFundShopItem(this,_loc5_);
            _loc4_.OnBuyItem = this.ProcessorOnBuyItem;
            _loc4_.Init(_loc1_);
            this.FGoodsList[_loc1_] = _loc4_;
            _loc1_++;
         }
         this.FSP_AlreadyBuy = _loc3_[CONST_ACTIVITY.RESOURCE_Link_MC_Desc];
         _loc5_ = this.FSP_AlreadyBuy[CONST_ACTIVITY.RESOURCE_Link_MC_Goods];
         this.FAlreadyBuyItem = new TFundShopItem(this,_loc5_);
         this.FAlreadyBuyItem.Init(0);
         this.FTF_ItemDesc = this.FSP_AlreadyBuy[CONST_ACTIVITY.RESOURCE_Link_TF_Desc];
         this.FMC_Box = this.FSP_AlreadyBuy[CONST_ACTIVITY.RESOURCE_Link_MC_Box];
         this.FUIWindowConfirmation = SUtilityOverLayer.UIWindowConfirmation;
         this.FUIWindowRecharge = SUtilityOverLayer.UIWindowRecharge;
      }
      
      protected function WindowInformationOnOK(param1:Object) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FAwardIndex);
         this.FAwardIndex = -1;
      }
      
      protected function WindowInformationOnCancel(param1:Object) : void
      {
         this.FAwardIndex = -1;
      }
      
      override protected function UpdateUIConfig() : void
      {
         super.UpdateUIConfig();
         this.FFundShopBin = FHDActivityConfig as THDGrowFundShop;
         ProcessorFormatActivityTime(FActivityAtoms.StartTime,FActivityAtoms.EndTime);
      }
      
      override protected function UpdateUI() : void
      {
         super.UpdateUI();
         this.UpdateFundShop();
      }
      
      private function UpdateFundShop() : void
      {
         var _loc1_:int = 0;
         var _loc2_:TInventories = null;
         var _loc3_:TFundShopAward = null;
         var _loc4_:String = null;
         var _loc5_:uint = 0;
         _loc1_ = this.FFundShopData.BuyIndex;
         if(_loc1_ == NOBUYINDEX)
         {
            this.FSP_UnBuy.visible = true;
            this.FSP_AlreadyBuy.visible = false;
            this.UpdateUnBuy();
         }
         else
         {
            this.FSP_UnBuy.visible = false;
            this.FSP_AlreadyBuy.visible = true;
            _loc3_ = this.FFundShopData.GetAwardByIndex(_loc1_);
            this.FAlreadyBuyItem.ItemData = _loc3_;
            _loc2_ = ProcessorGetInventories(_loc3_.AwardIDs[0]);
            this.FAlreadyBuyItem.UpdateDesc(_loc2_);
            this.FMC_Box.gotoAndStop(_loc1_ + 1);
            _loc4_ = this.FFundShopBin.Tip;
            _loc5_ = _loc3_.ReturnMoney;
            this.FTF_ItemDesc.text = TUtilityString.Format(_loc4_,_loc5_);
         }
      }
      
      protected function UpdateUnBuy() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:TInventories = null;
         var _loc4_:TFundShopAward = null;
         var _loc5_:TFundShopItem = null;
         _loc2_ = BOX_NUM;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc5_ = this.FGoodsList[_loc1_];
            _loc4_ = this.FFundShopData.GetAwardByIndex(_loc1_);
            _loc5_.ItemData = _loc4_;
            _loc3_ = ProcessorGetInventories(_loc4_.AwardIDs[0]);
            _loc5_.UpdateDesc(_loc3_);
            _loc1_++;
         }
      }
      
      override protected function Reset() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         super.Reset();
      }
      
      override protected function UpdataStatus(param1:uint, param2:int, param3:Vector.<int>) : void
      {
         var _loc4_:int = 0;
         var _loc5_:uint = 0;
         var _loc6_:TFundShopAward = null;
         _loc4_ = Activity_CanNotReceive;
         if(FUpdateStatus != null)
         {
            FUpdateStatus(FActivityAtoms.Identifier,_loc4_);
         }
      }
      
      override protected function UpdateSCData(param1:ByteArray) : void
      {
         super.UpdateSCData(param1);
         if(FActivityAtoms.Identifier != FMemoryID)
         {
            FHDActivityConfig = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_HDGrowFundShop,FActivityAtoms.ActivityNumber) as THDActivityBase;
         }
         this.FFundShopBin = FHDActivityConfig as THDGrowFundShop;
         FActivityInitRetData = FUnstreamizerActivity.UnstreamizationPerform_Activity(param1,null);
         this.FFundShopData.BuyIndex = FActivityInitRetData.ParameterVec[0];
         this.FUnstreamizerActivityFund.UnstreamizeUpdateFundShop(this.FFundShopData,this.FFundShopBin);
         if(Visible)
         {
            this.UpdateUI();
         }
      }
      
      protected function ProcessorOnBuyItem(param1:Object, param2:uint) : void
      {
         var _loc3_:TFundShopAward = null;
         var _loc4_:uint = 0;
         this.FAwardIndex = param2;
         _loc3_ = this.FFundShopData.GetAwardByIndex(this.FAwardIndex);
         _loc4_ = this.FCharacter.CreditGold;
         if(_loc4_ >= _loc3_.NeedGold)
         {
            this.FUIWindowConfirmation.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_06),_loc3_.NeedGold);
            this.FUIWindowConfirmation.OnOK = this.WindowInformationOnOK;
            this.FUIWindowConfirmation.OnCancel = this.WindowInformationOnCancel;
            this.FUIWindowConfirmation.Visible = true;
         }
         else
         {
            this.FUIWindowRecharge.SetGoldNum(_loc3_.NeedGold);
            this.FUIWindowRecharge.Visible = true;
         }
      }
      
      override public function Show(param1:TActivityAtoms) : void
      {
         super.Show(param1);
         ActivityInitReq(param1.Identifier);
      }
      
      override public function ChangeActivityStatus(param1:TActivityAtoms, param2:TActAwardStatusInfo) : void
      {
         super.ChangeActivityStatus(param1,param2);
         this.FFundShopData.BuyIndex = param2.Index;
         UpdateDataBase(this.FFundShopData);
         this.UpdataStatus(param2.Index,param2.Status,param2.Condition);
      }
   }
}

