package Processors.Game.Lobby.Activity.KnifeHeroCollect.Windows
{
   import Components.Pages.TUIPage;
   import Components.Slots.TUISlot;
   import Components.Standard.TUIButton;
   import Components.Standard.TUITab;
   import Externals.SExternalCore;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityFilter;
   import Foundation.Utilities.TUtilityString;
   import Logics.Characters.TCharacter;
   import Logics.Characters.THero;
   import Logics.DatebaseVO.VO.THDKnifeHeroCollect;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDKnifeHeroCollect.TKnifeHeroCollectData;
   import Logics.Inventories.TInventories;
   import Logics.Inventories.TInventory;
   import Logics.KnifeOfKillSoul.TKnifeOfKillSoulData;
   import Logics.SLogicsCore;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDSingleWindowBase;
   import Processors.Game.Lobby.Activity.HDNewYearSheep.HDWindow.TShowAwardUI;
   import Processors.Game.Lobby.Jade.TJadeCommon;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Rendering.Overlayers.HDGiftBox.TOverlayerGiftBox;
   import Resources.Constants.CONST_KNIFEOFKILLSOUL;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.utils.Dictionary;
   
   public class TProcessorKnifeHeroCollectView extends TProcessorHDSingleWindowBase
   {
      
      protected const MainTabType_Knife:uint = 0;
      
      protected const MainTabType_Hero:uint = 1;
      
      protected const MinorType_Knife:uint = 77;
      
      protected const MinorType_Hero:uint = 300;
      
      protected const SubTabItemCount:uint = 8;
      
      protected const RewardPanelItemCount:uint = 3;
      
      protected const SlotsConst:Vector.<uint> = Vector.<uint>([3,4,5]);
      
      protected var FData:TKnifeHeroCollectData;
      
      protected var FMainTab:TUITab;
      
      protected var FSubTab:TUITab;
      
      protected var FConditionPage:TUIPage;
      
      protected var FRewardPage:TUIPage;
      
      protected var FShowAwardUI:Vector.<TShowAwardUI>;
      
      protected var FGetBtns:Vector.<TUIButton>;
      
      protected var FFightBtns:Vector.<TUIButton>;
      
      protected var FSlots:Vector.<Vector.<Vector.<TUISlot>>>;
      
      protected var FMainTabIndex:uint;
      
      protected var FSubTabIndex:uint;
      
      protected var FConditionPageIndex:uint;
      
      protected var FRewardPageIndex:uint;
      
      protected var FInit:Boolean = true;
      
      public function TProcessorKnifeHeroCollectView(param1:TUIComponent)
      {
         super(param1);
      }
      
      protected function LocalToGlobal_ConditionPage(param1:uint) : uint
      {
         return this.FConditionPageIndex * this.SubTabItemCount + param1;
      }
      
      protected function LocalToGlobal_RewardPage(param1:uint) : uint
      {
         return this.FRewardPageIndex * this.RewardPanelItemCount + param1;
      }
      
      protected function GetAwardIndex(param1:uint) : uint
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         _loc2_ = this.LocalToGlobal_ConditionPage(this.FSubTabIndex);
         _loc3_ = this.LocalToGlobal_RewardPage(param1);
         return (_loc2_ + 1) * THDKnifeHeroCollect.MaxAwardCount + _loc3_;
      }
      
      override protected function Reset() : void
      {
      }
      
      override protected function UpdateUIConfig() : void
      {
         super.UpdateUIConfig();
         if(FActivityAtoms != null)
         {
            ProcessorFormatActivityTimeFromNowOn(FActivityAtoms.EndTime);
            ProcessorFormatActivityCountDown(FActivityAtoms.EndTime);
         }
      }
      
      override protected function UpdateDataBase(param1:TActivityOSBase) : void
      {
         this.FData = param1 as TKnifeHeroCollectData;
         if(this.FInit)
         {
            this.FConditionPage.SetupPage(this.FData.Config.ConsumeGold.length,0);
            this.FInit = false;
         }
         this.UpdateWinUI();
      }
      
      override protected function LogicsPerform() : void
      {
         var _loc1_:Vector.<Vector.<TUISlot>> = null;
         var _loc2_:Vector.<TUISlot> = null;
         var _loc3_:TUISlot = null;
         super.LogicsPerform();
         if(!this.Visible)
         {
            return;
         }
         for each(_loc1_ in this.FSlots)
         {
            for each(_loc2_ in _loc1_)
            {
               for each(_loc3_ in _loc2_)
               {
                  _loc3_.Update();
               }
            }
         }
      }
      
      protected function UpdateWinUI() : void
      {
         var _loc1_:MovieClip = null;
         var _loc2_:MovieClip = null;
         var _loc3_:uint = 0;
         var _loc4_:String = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:Vector.<Object> = null;
         var _loc10_:Dictionary = null;
         var _loc11_:Object = null;
         var _loc12_:String = null;
         var _loc13_:String = null;
         var _loc14_:uint = 0;
         var _loc15_:Dictionary = null;
         var _loc16_:Array = null;
         var _loc17_:Dictionary = null;
         var _loc18_:TInventories = null;
         var _loc19_:Boolean = false;
         var _loc20_:Boolean = false;
         var _loc21_:Boolean = false;
         var _loc22_:Vector.<Object> = null;
         var _loc23_:uint = 0;
         var _loc24_:Array = null;
         var _loc25_:int = 0;
         var _loc26_:Vector.<Vector.<TUISlot>> = null;
         var _loc27_:uint = 0;
         if(this.FMainTabIndex == this.MainTabType_Knife)
         {
            _loc9_ = this.FData.Config.ConsumeGold;
            _loc14_ = this.FData.CurConsumeGold;
            _loc10_ = this.FData.Config.KnifeAwardDict;
            _loc15_ = this.FData.Config.KnifeConditionDict;
            _loc17_ = this.FData.KnifeInventoriesDict;
            _loc22_ = this.FData.Config.ConsumeGold;
            _loc23_ = this.FData.CurConsumeGold;
            _loc24_ = this.FData.ConsumeGoldState;
         }
         else
         {
            _loc9_ = this.FData.Config.RechargeGold;
            _loc14_ = this.FData.CurRechargeGold;
            _loc10_ = this.FData.Config.HeroAwardDict;
            _loc15_ = this.FData.Config.HeroConditionDict;
            _loc17_ = this.FData.HeroInventoriesDict;
            _loc22_ = this.FData.Config.RechargeGold;
            _loc23_ = this.FData.CurRechargeGold;
            _loc24_ = this.FData.RechargeGoldState;
         }
         _loc12_ = this.FData.Config.Language.condition[this.FMainTabIndex];
         _loc13_ = this.FData.Config.Language.total[this.FMainTabIndex];
         _loc8_ = _loc9_.length;
         _loc3_ = 0;
         while(_loc3_ < this.SubTabItemCount)
         {
            _loc6_ = this.LocalToGlobal_ConditionPage(_loc3_);
            if(_loc6_ < _loc8_)
            {
               _loc5_ = uint(_loc9_[_loc6_].condition);
               _loc4_ = TUtilityString.Format(_loc12_,_loc5_);
               this.FSubTab.SetTabCaptionByIndex(_loc4_,_loc3_);
               this.FSubTab.SetTabShowByIndex(_loc3_);
               _loc1_ = this.FSubTab.GetTabByIndex(_loc3_);
               if(_loc23_ >= _loc22_[_loc6_].condition)
               {
                  _loc1_.filters = [];
               }
               else
               {
                  _loc1_.filters = [TUtilityFilter.gBlackFilters];
               }
            }
            else
            {
               this.FSubTab.SetTabHideByIndex(_loc3_);
            }
            _loc3_++;
         }
         FScene["TF_TotalDesc"].text = _loc13_;
         FScene["TF_TotalGold"].text = _loc14_.toString();
         _loc1_ = FScene["MC_RewardPanel"];
         _loc3_ = 0;
         while(_loc3_ < this.RewardPanelItemCount)
         {
            _loc2_ = _loc1_["MC_Reawrd_" + _loc3_];
            _loc7_ = this.LocalToGlobal_RewardPage(_loc3_);
            _loc27_ = this.GetAwardIndex(_loc3_);
            _loc11_ = _loc10_[_loc27_];
            if(_loc11_ != null)
            {
               _loc6_ = this.LocalToGlobal_ConditionPage(this.FSubTabIndex);
               _loc2_.visible = true;
               _loc16_ = _loc15_[_loc27_];
               _loc18_ = _loc17_[_loc27_];
               _loc26_ = this.FSlots[_loc3_];
               _loc20_ = this.UpdateSlot(_loc2_,_loc26_,_loc16_,_loc18_);
               _loc11_ = _loc10_[_loc27_];
               _loc19_ = _loc23_ >= _loc22_[_loc6_].condition;
               _loc25_ = int(_loc24_[_loc6_]);
               _loc21_ = Boolean(_loc25_ >> _loc7_ & 1);
               this.UpdateShowAwardUI(_loc3_,_loc11_,_loc20_,_loc19_,_loc21_);
            }
            else
            {
               _loc2_.visible = false;
            }
            _loc3_++;
         }
      }
      
      protected function UpdateSlot(param1:MovieClip, param2:Vector.<Vector.<TUISlot>>, param3:Array, param4:TInventories) : Boolean
      {
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:MovieClip = null;
         var _loc8_:Vector.<TUISlot> = null;
         var _loc9_:TUISlot = null;
         var _loc10_:Boolean = false;
         var _loc11_:uint = 0;
         var _loc12_:TInventory = null;
         _loc6_ = this.SlotsConst.length;
         _loc5_ = 0;
         while(_loc5_ < _loc6_)
         {
            _loc7_ = param1["SlotList_" + _loc5_];
            _loc7_.visible = false;
            _loc5_++;
         }
         _loc5_ = this.SlotsConst.indexOf(param4.Count);
         _loc7_ = param1["SlotList_" + _loc5_];
         _loc7_.visible = true;
         _loc8_ = param2[_loc5_];
         _loc6_ = uint(param4.Count);
         _loc5_ = 0;
         while(_loc5_ < _loc6_)
         {
            _loc9_ = _loc8_[_loc5_];
            _loc12_ = param4.GetInventoryByIndex(_loc5_);
            _loc9_.Context = _loc12_;
            _loc10_ = this.HaveArticle(param3[_loc5_].useID,_loc12_);
            _loc9_.SetDefaultFilters(!_loc10_);
            if(_loc10_)
            {
               _loc11_++;
            }
            _loc5_++;
         }
         return _loc11_ == _loc6_;
      }
      
      protected function UpdateShowAwardUI(param1:uint, param2:Object, param3:Boolean, param4:Boolean, param5:Boolean) : void
      {
         var _loc6_:TShowAwardUI = null;
         var _loc7_:TUIButton = null;
         var _loc8_:TUIButton = null;
         var _loc9_:MovieClip = null;
         _loc6_ = this.FShowAwardUI[param1];
         _loc7_ = this.FGetBtns[param1];
         _loc8_ = this.FFightBtns[param1];
         _loc9_ = FScene["MC_RewardPanel"]["MC_Reawrd_" + param1].MC_ShowAwardUI.MC_Receive;
         _loc6_.SetData(param2.showType,param2.awardID,param2.showID,TOverlayerGiftBox.TYPE_ALL);
         if(param5)
         {
            _loc7_.Enabled = false;
            _loc9_.visible = true;
         }
         else
         {
            if(param3 && param4)
            {
               _loc7_.Enabled = true;
            }
            else
            {
               _loc7_.Enabled = false;
            }
            _loc9_.visible = false;
         }
         _loc8_.Visible = param2.fightReportAddr != "";
      }
      
      protected function HaveArticle(param1:uint, param2:TInventory) : Boolean
      {
         var _loc3_:TCharacter = null;
         var _loc4_:Boolean = false;
         var _loc5_:TKnifeOfKillSoulData = null;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:THero = null;
         _loc3_ = SLogicsCore.Character;
         if(_loc3_.Appliances.GetInventoryByTempletID(param2.IDTemplate) != null)
         {
            return true;
         }
         if(_loc3_.TemporaryInventories.GetInventoryByTempletID(param2.IDTemplate) != null)
         {
            return true;
         }
         if(param2.CategorySecond != this.MinorType_Knife)
         {
            _loc6_ = uint(_loc3_.Heros.Count);
            _loc7_ = 0;
            while(true)
            {
               if(_loc7_ < _loc6_)
               {
                  _loc8_ = _loc3_.Heros.GetHeroByIndex(_loc7_);
                  if(_loc8_.ModelID == param1)
                  {
                     break;
                  }
                  _loc7_++;
                  continue;
               }
            }
            return true;
         }
         _loc6_ = uint(_loc3_.KnifeOfKillSoul.Count);
         _loc7_ = 0;
         while(_loc7_ < _loc6_)
         {
            _loc5_ = _loc3_.KnifeOfKillSoul.GetByIndex(_loc7_);
            if(_loc5_.RelationID == param1 && _loc5_.CurrentState == CONST_KNIFEOFKILLSOUL.KNIFESTATE_UNLOCK)
            {
               return true;
            }
            _loc7_++;
         }
         return false;
      }
      
      protected function OnSwitchMainTab(param1:int) : void
      {
         this.FMainTabIndex = param1;
         this.FConditionPageIndex = 0;
         this.FRewardPageIndex = 0;
         this.FConditionPage.SetupPage(this.FConditionPage.TotalQuantity,this.FConditionPageIndex);
         this.FRewardPage.SetupPage(this.FRewardPage.TotalQuantity,this.FRewardPageIndex);
         this.FSubTabIndex = 0;
         this.FSubTab.TabIndex = this.FSubTabIndex;
         this.UpdateWinUI();
      }
      
      protected function OnSwitchSubTab(param1:int) : void
      {
         this.FSubTabIndex = param1;
         this.UpdateWinUI();
      }
      
      protected function ConditionPageOnSwitch(param1:Object, param2:int) : void
      {
         this.FSubTabIndex = 0;
         this.FSubTab.TabIndex = this.FSubTabIndex;
         this.FConditionPageIndex = param2;
         this.UpdateWinUI();
      }
      
      protected function RewardPageOnSwitch(param1:Object, param2:int) : void
      {
         this.FRewardPageIndex = param2;
         this.UpdateWinUI();
      }
      
      protected function OnGetBtnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:Vector.<Object> = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         if(this.FMainTabIndex == this.MainTabType_Knife)
         {
            _loc4_ = this.FData.Config.ConsumeGold;
         }
         else
         {
            _loc4_ = this.FData.Config.RechargeGold;
         }
         _loc3_ = this.LocalToGlobal_ConditionPage(this.FSubTabIndex);
         _loc5_ = uint(_loc4_[_loc3_].index);
         _loc6_ = this.LocalToGlobal_RewardPage(param1.Tag);
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,_loc5_,0,Vector.<int>([_loc6_]));
      }
      
      protected function OnFightBtnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:Dictionary = null;
         var _loc4_:String = null;
         if(this.FMainTabIndex == this.MainTabType_Knife)
         {
            _loc3_ = this.FData.Config.KnifeAwardDict;
         }
         else
         {
            _loc3_ = this.FData.Config.HeroAwardDict;
         }
         _loc4_ = _loc3_[this.GetAwardIndex(param1.Tag)].fightReportAddr;
         SExternalCore.NavigateToLinkUrl(_loc4_);
      }
      
      override public function InitWindow(param1:Sprite = null) : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:MovieClip = null;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:Vector.<Vector.<TUISlot>> = null;
         var _loc10_:Vector.<TUISlot> = null;
         var _loc11_:TUISlot = null;
         var _loc12_:TShowAwardUI = null;
         var _loc13_:TUIButton = null;
         super.InitWindow(param1);
         this.FMainTab = new TUITab(this);
         this.FSubTab = new TUITab(this);
         this.FConditionPage = new TUIPage(this);
         this.FRewardPage = new TUIPage(this);
         this.FShowAwardUI = new Vector.<TShowAwardUI>();
         this.FGetBtns = new Vector.<TUIButton>();
         this.FFightBtns = new Vector.<TUIButton>();
         this.FSlots = new Vector.<Vector.<Vector.<TUISlot>>>();
         _loc2_ = FScene["MC_MainTab"];
         this.FMainTab.SetTabByIndex(_loc2_.MC_Tab_0,this.MainTabType_Knife);
         this.FMainTab.SetTabByIndex(_loc2_.MC_Tab_1,this.MainTabType_Hero);
         this.FMainTab.OnSwitch = this.OnSwitchMainTab;
         this.FMainTab.Init();
         _loc2_ = FScene["MC_SubTab"];
         _loc4_ = 0;
         while(_loc4_ < this.SubTabItemCount)
         {
            this.FSubTab.SetTabByIndex(_loc2_["MC_Tab_" + _loc4_],_loc4_);
            _loc4_++;
         }
         this.FSubTab.OnSwitch = this.OnSwitchSubTab;
         this.FSubTab.Init();
         _loc2_ = FScene["MC_SubTab"];
         this.FConditionPage.ButtonNext.Substrate = _loc2_.MC_PageRight;
         this.FConditionPage.ButtonPrevious.Substrate = _loc2_.MC_PageLeft;
         this.FConditionPage.LabelPage = _loc2_.TF_Page;
         this.FConditionPage.PageSize = this.SubTabItemCount;
         this.FConditionPage.OnChangePage = this.ConditionPageOnSwitch;
         this.FConditionPage.Init();
         this.FConditionPage.Update();
         _loc2_ = FScene["MC_RewardPanel"];
         this.FRewardPage.ButtonNext.Substrate = _loc2_.MC_PageRight;
         this.FRewardPage.ButtonPrevious.Substrate = _loc2_.MC_PageLeft;
         this.FRewardPage.LabelPage = _loc2_.TF_Page;
         this.FRewardPage.PageSize = this.RewardPanelItemCount;
         this.FRewardPage.OnChangePage = this.RewardPageOnSwitch;
         this.FRewardPage.Init();
         this.FRewardPage.Update();
         _loc4_ = 0;
         while(_loc4_ < this.RewardPanelItemCount)
         {
            _loc3_ = _loc2_["MC_Reawrd_" + _loc4_]["MC_ShowAwardUI"];
            _loc12_ = new TShowAwardUI(this);
            _loc12_.UIDispatch(_loc3_);
            this.FShowAwardUI[_loc4_] = _loc12_;
            _loc13_ = new TUIButton();
            _loc13_.Substrate = _loc3_.Btn_Get;
            _loc13_.OnClick = this.OnGetBtnClick;
            _loc13_.Tag = _loc4_;
            this.FGetBtns[_loc4_] = _loc13_;
            _loc13_ = new TUIButton();
            _loc13_.Substrate = _loc3_.Btn_FightReport;
            _loc13_.OnClick = this.OnFightBtnClick;
            _loc13_.Tag = _loc4_;
            this.FFightBtns[_loc4_] = _loc13_;
            _loc4_++;
         }
         this.FSlots = new Vector.<Vector.<Vector.<TUISlot>>>();
         _loc7_ = this.SlotsConst.length;
         _loc4_ = 0;
         while(_loc4_ < this.RewardPanelItemCount)
         {
            _loc9_ = new Vector.<Vector.<TUISlot>>();
            this.FSlots[_loc4_] = _loc9_;
            _loc5_ = 0;
            while(_loc5_ < _loc7_)
            {
               _loc10_ = new Vector.<TUISlot>();
               _loc9_[_loc5_] = _loc10_;
               _loc8_ = this.SlotsConst[_loc5_];
               _loc6_ = 0;
               while(_loc6_ < _loc8_)
               {
                  _loc3_ = _loc2_["MC_Reawrd_" + _loc4_]["SlotList_" + _loc5_]["Slot_" + _loc6_];
                  _loc11_ = new TUISlot(this);
                  _loc11_.Resource = _loc3_;
                  _loc11_.OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
                  _loc11_.OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
                  TJadeCommon.InitSlot(_loc11_);
                  _loc11_.OnQuerySubscript = null;
                  _loc11_.Init();
                  _loc10_[_loc6_] = _loc11_;
                  _loc6_++;
               }
               _loc5_++;
            }
            _loc4_++;
         }
      }
   }
}

