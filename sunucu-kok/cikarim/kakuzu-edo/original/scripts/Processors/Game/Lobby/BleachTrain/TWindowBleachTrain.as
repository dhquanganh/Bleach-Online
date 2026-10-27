package Processors.Game.Lobby.BleachTrain
{
   import Components.Pages.TUIPage;
   import Components.Slots.TUISlot;
   import Components.Standard.TUIButton;
   import Components.Standard.TUITab;
   import Foundation.Network.SNetworkCore;
   import Foundation.Network.TPacket;
   import Foundation.Resources.SResourcesCore;
   import Foundation.Resources.Textures.TTexture;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityFilter;
   import Foundation.Utilities.TUtilityReflection;
   import Foundation.Utilities.TUtilityString;
   import Logics.BleachTrain.TBleachTrainData;
   import Logics.BleachTrain.TBleachTrainDatas;
   import Logics.BleachTrain.TBleachTrainVipBag;
   import Logics.SLogicsCore;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import Processors.Game.Lobby.Jade.TJadeCommon;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.HyperLink.SUtilityHyperLink;
   import Processors.Game.Utilities.HyperLink.TUtilityHyperLink;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Resources.Constants.CONST_NETWORK;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class TWindowBleachTrain extends TProcessorLobbyWindow
   {
      
      protected static const ItemFrameIndex_Complete:int = 3;
      
      protected static const ItemFrameIndex_NotComplete:int = 2;
      
      protected static const ItemFrameIndex_NotOpen:int = 1;
      
      protected const TABNUM:int = 3;
      
      protected const TRAINITEMNUM:int = 4;
      
      protected const FormatSchedule:String = "%0(%1/%2)";
      
      protected var FMainScene:Sprite;
      
      protected var FBtnClose:TUIButton;
      
      protected var FUITab:TUITab;
      
      protected var FCurrentTabIndex:int;
      
      protected var FTrainItem:Vector.<MovieClip>;
      
      protected var FTrainItemMountPoint:Vector.<Bitmap>;
      
      protected var FTrainItemName:Vector.<TextField>;
      
      protected var FTrainItemDescription:Vector.<TextField>;
      
      protected var FTrainItemCanReciveFlag:Vector.<MovieClip>;
      
      protected var FTrainItemSelectBox:Vector.<MovieClip>;
      
      protected var FCurrentPageIndex:int;
      
      protected var FCurrentBleachTrainInforVec:Vector.<TBleachTrainData>;
      
      protected var FUIPage:TUIPage;
      
      protected var FCurrentSelectItemIndex:int;
      
      protected var FTrainName:TextField;
      
      protected var FTrainGoal:TextField;
      
      protected var FBtnJmp:TUIButton;
      
      protected var FRewardMCOne:Sprite;
      
      protected var FSlotNormal:TUISlot;
      
      protected var FNormalRecive:TUIButton;
      
      protected var FSlotVip:TUISlot;
      
      protected var FVipRecive:TUIButton;
      
      protected var FVipReciveCondition:TextField;
      
      protected var FBtnBecomeVip:TUIButton;
      
      protected var FRewardMCTwo:Sprite;
      
      protected var FSlotVipTwo:TUISlot;
      
      protected var FVipReciveTwo:TUIButton;
      
      protected var FWindowVipBag:TWindowVipBag;
      
      protected var FWindowPurchase:TWindowPurchase;
      
      protected var FBleachTrainDatas:TBleachTrainDatas;
      
      public function TWindowBleachTrain(param1:TUIComponent)
      {
         super(param1);
         this.FWindowVipBag = new TWindowVipBag(this);
         this.FWindowVipBag.OnBuyBtnClick = this.VipBagOnClick;
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         this.FMainScene = TUtilityReflection.CreateDisplayObjectInstance("BleachTrainUI") as Sprite;
         addChild(this.FMainScene);
         this.FBtnClose = new TUIButton();
         this.FBtnClose.Substrate = this.FMainScene["BT_Close"];
         this.FBtnClose.OnClick = this.BtnCloseOnMouseClick;
         this.FWindowVipBag.UIDispatch(this.FMainScene);
         this.TrainListUIDispatch();
         this.TrainInforUIDispatch();
         this.TrainRewardUIDispatch();
         this.FWindowPurchase = new TWindowPurchase(this);
         this.FWindowPurchase.OnBuyBtnClick = this.WindowPurchaseOnBuyGoods;
         this.FWindowPurchase.OnHideWindow = this.WindowPurchaseOnHideWindow;
         this.FWindowPurchase.UIDispatch();
         this.FWindowPurchase.X = (this.width - this.FWindowPurchase.width) / 2;
         this.FWindowPurchase.Y = (this.height - this.FWindowPurchase.height) / 2;
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
            this.FSlotNormal.Update();
            this.FSlotVip.Update();
            this.FSlotVipTwo.Update();
         }
      }
      
      protected function TrainListUIDispatch() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Sprite = null;
         var _loc3_:Bitmap = null;
         this.FUITab = new TUITab(this);
         _loc1_ = 0;
         while(_loc1_ < this.TABNUM)
         {
            this.FUITab.SetTabByIndex(this.FMainScene["Tab_" + _loc1_],_loc1_);
            _loc1_++;
         }
         this.FUITab.OnSwitch = this.SwitchTab;
         this.FUITab.Init();
         this.FTrainItem = new Vector.<MovieClip>();
         this.FTrainItemMountPoint = new Vector.<Bitmap>();
         this.FTrainItemName = new Vector.<TextField>();
         this.FTrainItemDescription = new Vector.<TextField>();
         this.FTrainItemCanReciveFlag = new Vector.<MovieClip>();
         this.FTrainItemSelectBox = new Vector.<MovieClip>();
         _loc1_ = 0;
         while(_loc1_ < this.TRAINITEMNUM)
         {
            _loc2_ = this.FMainScene["TrainItem" + _loc1_];
            this.FTrainItem.push(_loc2_);
            _loc2_.addEventListener(MouseEvent.CLICK,this.TrainItemOnMouseClick);
            _loc2_.buttonMode = true;
            _loc3_ = new Bitmap();
            _loc2_["MountPoint"].addChild(_loc3_);
            this.FTrainItemMountPoint.push(_loc3_);
            this.FTrainItemName.push(_loc2_["Name"]);
            this.FTrainItemDescription.push(_loc2_["Description"]["Lable"]);
            this.FTrainItemCanReciveFlag.push(_loc2_["CanReciveFlag"]);
            this.FTrainItemSelectBox.push(_loc2_["SelectBox"]);
            _loc1_++;
         }
         this.FUIPage = new TUIPage(this);
         this.FUIPage.ButtonPrevious.Substrate = this.FMainScene["ReelLeft"];
         this.FUIPage.ButtonNext.Substrate = this.FMainScene["ReelRight"];
         this.FUIPage.LabelPage = this.FMainScene["ReelName"];
         this.FUIPage.PageSize = this.TRAINITEMNUM;
         this.FUIPage.OnChangePage = this.CallBack_ChangePage;
      }
      
      protected function TrainInforUIDispatch() : void
      {
         this.FTrainName = this.FMainScene["TrainName"];
         this.FTrainGoal = this.FMainScene["Goal"];
         this.FBtnJmp = new TUIButton();
         this.FBtnJmp.Substrate = this.FMainScene["Btn_Jmp"];
         this.FBtnJmp.OnClick = this.BtnJmpOnMouseClick;
      }
      
      protected function TrainRewardUIDispatch() : void
      {
         this.FRewardMCOne = this.FMainScene["AwardMode1"];
         this.FSlotNormal = new TUISlot(this);
         this.FSlotNormal.Resource = this.FRewardMCOne["SlotNormal"];
         TJadeCommon.InitSlot(this.FSlotNormal);
         this.FSlotNormal.OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FSlotNormal.OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FSlotNormal.Init();
         this.FNormalRecive = new TUIButton();
         this.FNormalRecive.Substrate = this.FRewardMCOne["Btn_ReciveNormal"];
         this.FNormalRecive.OnClick = this.BtnReciveOnMouseClick;
         this.FSlotVip = new TUISlot(this);
         this.FSlotVip.Resource = this.FRewardMCOne["SlotVip"];
         TJadeCommon.InitSlot(this.FSlotVip);
         this.FSlotVip.OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FSlotVip.OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FSlotVip.Init();
         this.FVipRecive = new TUIButton();
         this.FVipRecive.Substrate = this.FRewardMCOne["Btn_ReciveVip"];
         this.FVipRecive.OnClick = this.BtnReciveOnMouseClick;
         this.FVipReciveCondition = this.FRewardMCOne["VipOpenConditon"];
         this.FBtnBecomeVip = new TUIButton();
         this.FBtnBecomeVip.Substrate = this.FRewardMCOne["Btn_Vip"];
         this.FBtnBecomeVip.OnClick = this.BtnVipOnMouseClick;
         this.FRewardMCTwo = this.FMainScene["AwardMode2"];
         this.FSlotVipTwo = new TUISlot(this);
         this.FSlotVipTwo.Resource = this.FRewardMCTwo["SlotVip"];
         TJadeCommon.InitSlot(this.FSlotVipTwo);
         this.FSlotVipTwo.OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FSlotVipTwo.OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FSlotVipTwo.Init();
         this.FVipReciveTwo = new TUIButton();
         this.FVipReciveTwo.Substrate = this.FRewardMCTwo["Btn_ReciveVip"];
         this.FVipReciveTwo.OnClick = this.BtnReciveOnMouseClick;
      }
      
      protected function InitTrainList() : void
      {
         var _loc1_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < this.TABNUM)
         {
            this.FUITab.SetTabCaptionByIndex(this.FBleachTrainDatas.TabNames[_loc1_],_loc1_);
            _loc1_++;
         }
      }
      
      protected function SetupPage(param1:int, param2:int) : void
      {
         this.FCurrentPageIndex = param2;
         this.FUIPage.TotalQuantity = param1;
         this.FUIPage.Update();
         this.FUIPage.PageIndex = param2;
      }
      
      protected function UpdateTrainList() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Sprite = null;
         var _loc3_:Bitmap = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:TBleachTrainData = null;
         _loc4_ = this.FCurrentPageIndex * this.TRAINITEMNUM;
         _loc5_ = _loc4_ + this.TRAINITEMNUM;
         _loc5_ = _loc5_ > this.FCurrentBleachTrainInforVec.length ? int(this.FCurrentBleachTrainInforVec.length) : _loc5_;
         _loc1_ = _loc4_;
         while(_loc1_ < _loc5_)
         {
            _loc7_ = this.FCurrentBleachTrainInforVec[_loc1_];
            _loc6_ = _loc1_ - _loc4_;
            this.FTrainItem[_loc6_].visible = true;
            this.FTrainItemName[_loc6_].text = _loc7_.GrowRoadTask.Name;
            this.FTrainItemSelectBox[_loc6_].visible = false;
            if(_loc7_.IfOpen)
            {
               this.FTrainItemDescription[_loc6_].text = _loc7_.GrowRoadTask.DescriptionSimple;
            }
            else if(_loc7_.GrowRoadTask.TaskLocked == "")
            {
               this.FTrainItemDescription[_loc6_].text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_BleachTrain_05),_loc7_.GrowRoadTask.Accept);
            }
            else
            {
               this.FTrainItemDescription[_loc6_].text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_BleachTrain_04),_loc7_.GrowRoadTask.Accept,_loc7_.GrowRoadTask.TaskLocked);
            }
            SResourcesCore.TexturesInventory.LoadAutoSecondary(_loc7_.GrowRoadTask.IocnID,this.PicArrive);
            this.FTrainItemMountPoint[_loc6_].bitmapData = null;
            if(_loc7_.IfCanGotReward)
            {
               this.FTrainItemCanReciveFlag[_loc6_].visible = true;
               this.FTrainItemCanReciveFlag[_loc6_].play();
            }
            else
            {
               this.FTrainItemCanReciveFlag[_loc6_].visible = false;
            }
            if(!_loc7_.IfOpen)
            {
               this.FTrainItem[_loc6_].gotoAndStop(ItemFrameIndex_NotOpen);
            }
            else if(_loc7_.IfGotReward)
            {
               this.FTrainItem[_loc6_].gotoAndStop(ItemFrameIndex_Complete);
            }
            else
            {
               this.FTrainItem[_loc6_].gotoAndStop(ItemFrameIndex_NotComplete);
            }
            _loc1_++;
         }
         _loc1_ = _loc5_ - _loc4_;
         while(_loc1_ < this.TRAINITEMNUM)
         {
            this.FTrainItem[_loc1_].visible = false;
            _loc1_++;
         }
      }
      
      protected function PicArrive(param1:Object, param2:TTexture, param3:uint) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:TBleachTrainData = null;
         _loc4_ = this.FCurrentPageIndex * this.TRAINITEMNUM;
         _loc5_ = _loc4_ + this.TRAINITEMNUM;
         _loc5_ = _loc5_ > this.FCurrentBleachTrainInforVec.length ? int(this.FCurrentBleachTrainInforVec.length) : _loc5_;
         _loc6_ = _loc4_;
         while(_loc6_ < _loc5_)
         {
            _loc8_ = this.FCurrentBleachTrainInforVec[_loc6_];
            _loc7_ = _loc6_ - _loc4_;
            if(_loc8_.GrowRoadTask.IocnID == param3)
            {
               this.FTrainItemMountPoint[_loc7_].bitmapData = param2.GetAnimationSequenceByIndex(0).GetAnimationFrameByIndex(0).Surface;
            }
            _loc6_++;
         }
      }
      
      protected function TrainInforIndexByItemIndex(param1:int) : int
      {
         return this.FCurrentPageIndex * this.TRAINITEMNUM + param1;
      }
      
      protected function GetNeedShowTabIndex() : int
      {
         var _loc1_:* = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _loc3_ = int(SLogicsCore.Character.GetMainLevel());
         _loc2_ = int(this.FBleachTrainDatas.LevelNeed.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            if(this.FBleachTrainDatas.LevelNeed[_loc1_] >= _loc3_)
            {
               break;
            }
            _loc1_++;
         }
         if(_loc1_ == _loc2_)
         {
            _loc1_--;
         }
         _loc4_ = _loc1_;
         _loc1_ = 0;
         while(_loc1_ <= _loc4_)
         {
            this.FUITab.SetTabEnabledByIndex(_loc1_,true);
            _loc1_++;
         }
         _loc1_ = int(_loc4_ + 1);
         while(_loc1_ < this.TABNUM)
         {
            this.FUITab.SetTabEnabledByIndex(_loc1_,false);
            _loc1_++;
         }
         return _loc4_;
      }
      
      protected function TrainListSortCompareMethod(param1:TBleachTrainData, param2:TBleachTrainData) : int
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         _loc3_ = uint(param1.GrowRoadTask.Accept);
         if(!param1.IfGotReward && param1.IfOpen && !param1.IfCanGotReward)
         {
            _loc3_ += 1000;
         }
         else if(!param1.IfOpen)
         {
            _loc3_ += 10000;
         }
         else if(param1.IfGotReward)
         {
            _loc3_ += 100000;
         }
         _loc4_ = uint(param2.GrowRoadTask.Accept);
         if(!param2.IfGotReward && param2.IfOpen && !param2.IfCanGotReward)
         {
            _loc4_ += 1000;
         }
         else if(!param2.IfOpen)
         {
            _loc4_ += 10000;
         }
         else if(param2.IfGotReward)
         {
            _loc4_ += 100000;
         }
         if(_loc3_ < _loc4_)
         {
            return -1;
         }
         if(_loc3_ > _loc4_)
         {
            return 1;
         }
         if(param1.GrowRoadTask.Identifier < param2.GrowRoadTask.Identifier)
         {
            return -1;
         }
         if(param1.GrowRoadTask.Identifier > param2.GrowRoadTask.Identifier)
         {
            return 1;
         }
         return 0;
      }
      
      protected function UpdateTrainInfor(param1:int) : void
      {
         var _loc2_:TBleachTrainData = null;
         _loc2_ = this.FCurrentBleachTrainInforVec[param1];
         this.FTrainName.text = _loc2_.GrowRoadTask.Name;
         this.FTrainGoal.text = TUtilityString.Format(this.FormatSchedule,_loc2_.GrowRoadTask.TaskTarget,_loc2_.CurrentScheduel,_loc2_.GrowRoadTask.AllNumber);
         this.FBtnJmp.Visible = _loc2_.GrowRoadTask.IsGoto != 0;
      }
      
      protected function SelectItemListByItemIndex(param1:int) : void
      {
         this.FTrainItemSelectBox[this.FCurrentSelectItemIndex].visible = false;
         this.FTrainItemSelectBox[param1].visible = true;
         this.FCurrentSelectItemIndex = param1;
         this.UpdateTrainInfor(this.TrainInforIndexByItemIndex(param1));
      }
      
      protected function UpdateReward(param1:int) : void
      {
         var _loc2_:TBleachTrainData = null;
         var _loc3_:Boolean = false;
         _loc2_ = this.FCurrentBleachTrainInforVec[param1];
         _loc3_ = SLogicsCore.Character.VipLevel >= _loc2_.GrowRoadTask.VipNeed;
         this.FRewardMCOne.visible = !_loc3_;
         this.FRewardMCTwo.visible = _loc3_;
         if(this.FRewardMCOne.visible)
         {
            this.FSlotNormal.Context = _loc2_.Rewards.GetInventoryByIndex(TBleachTrainData.NormalRewardIndex);
            this.FSlotVip.Context = _loc2_.Rewards.GetInventoryByIndex(TBleachTrainData.VipRewardIndex);
            this.FVipRecive.Visible = false;
            this.FNormalRecive.Visible = _loc2_.IfCanGotReward || _loc2_.IfGotReward;
            this.FVipReciveCondition.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_BleachTrain_01),_loc2_.GrowRoadTask.VipNeed);
            this.FNormalRecive.Enabled = !_loc2_.IfGotReward;
         }
         else if(this.FRewardMCTwo.visible)
         {
            this.FSlotVipTwo.Context = _loc2_.Rewards.GetInventoryByIndex(TBleachTrainData.VipRewardIndex);
            this.FVipReciveTwo.Visible = _loc2_.IfCanGotReward || _loc2_.IfGotReward;
            this.FVipReciveTwo.Enabled = !_loc2_.IfGotReward;
         }
      }
      
      protected function CallBack_ChangePage(param1:Object, param2:int) : void
      {
         this.FCurrentPageIndex = param2;
         this.UpdateTrainList();
         this.SelectItemListByItemIndex(0);
         this.UpdateReward(this.TrainInforIndexByItemIndex(0));
      }
      
      protected function SwitchTab(param1:int) : void
      {
         this.FCurrentTabIndex = param1;
         this.FCurrentBleachTrainInforVec = this.FBleachTrainDatas.BleachTrainDatas[param1];
         this.FCurrentBleachTrainInforVec.sort(this.TrainListSortCompareMethod);
         this.FCurrentPageIndex = 0;
         this.SetupPage(this.FCurrentBleachTrainInforVec.length,0);
         this.UpdateTrainList();
         this.SelectItemListByItemIndex(0);
         this.UpdateReward(0);
         this.FWindowVipBag.ShowViewByVipBags(this.FBleachTrainDatas.VipBags[param1],this.FBleachTrainDatas.BagGroupID[param1]);
      }
      
      protected function TrainItemOnMouseClick(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         _loc2_ = this.FTrainItem.indexOf(param1.currentTarget as Sprite);
         this.SelectItemListByItemIndex(_loc2_);
         this.UpdateReward(this.TrainInforIndexByItemIndex(_loc2_));
      }
      
      protected function BtnReciveOnMouseClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:TPacket = null;
         _loc3_ = this.TrainInforIndexByItemIndex(this.FCurrentSelectItemIndex);
         _loc4_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_BleachTrainGetReward_Req);
         _loc4_.Data.writeUnsignedInt(this.FCurrentBleachTrainInforVec[_loc3_].GrowRoadTask.Identifier);
         SNetworkCore.Transceiver.PacketTransmit(_loc4_);
      }
      
      protected function BtnVipOnMouseClick(param1:Object, param2:MouseEvent) : void
      {
         SUtilityHyperLink.ShortcutHyperlink(TUtilityHyperLink.HyperLink_VIP);
      }
      
      protected function BtnJmpOnMouseClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:TBleachTrainData = null;
         _loc3_ = this.TrainInforIndexByItemIndex(this.FCurrentSelectItemIndex);
         _loc4_ = this.FCurrentBleachTrainInforVec[_loc3_];
         ProcessorWindowClose();
         SUtilityHyperLink.ShortcutHyperlink(_loc4_.GrowRoadTask.IsGoto);
      }
      
      protected function BtnCloseOnMouseClick(param1:Object, param2:MouseEvent) : void
      {
         ProcessorWindowClose();
      }
      
      protected function VipBagOnClick(param1:Object, param2:int, param3:int, param4:int, param5:uint, param6:uint) : void
      {
         this.FWindowPurchase.Show(param2,param3,param4,param5,param6);
         this.FMainScene.filters = [TUtilityFilter.GaryColorFiltersMask];
         this.FMainScene.mouseChildren = false;
         this.FMainScene.mouseEnabled = false;
      }
      
      protected function WindowPurchaseOnHideWindow(param1:Object) : void
      {
         this.FMainScene.filters = null;
         this.FMainScene.mouseChildren = true;
         this.FMainScene.mouseEnabled = true;
      }
      
      protected function WindowPurchaseOnBuyGoods(param1:uint, param2:uint) : void
      {
         var _loc3_:TPacket = null;
         _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_BleachTrainVipBag_Req);
         _loc3_.Data.writeUnsignedInt(param1);
         _loc3_.Data.writeUnsignedInt(param2);
         SNetworkCore.Transceiver.PacketTransmit(_loc3_);
      }
      
      public function set BleachTrainDatas(param1:TBleachTrainDatas) : void
      {
         this.FBleachTrainDatas = param1;
      }
      
      public function InitView() : void
      {
         this.InitTrainList();
         this.FUITab.SwithTagManual(this.GetNeedShowTabIndex());
         this.SelectItemListByItemIndex(0);
         this.UpdateReward(0);
      }
      
      public function Reset() : void
      {
         this.FUITab.SwithTagManual(0);
         this.FWindowVipBag.Reset();
      }
      
      override public function Load() : void
      {
         super.Load();
         this.FWindowVipBag.Load();
      }
      
      public function VipBagBuyedNotify(param1:uint, param2:uint) : void
      {
         var _loc3_:int = 0;
         var _loc4_:TBleachTrainVipBag = null;
         _loc3_ = this.FBleachTrainDatas.BagGroupID.indexOf(param1);
         _loc4_ = this.FBleachTrainDatas.VipBags[_loc3_][param2];
         _loc4_.IfSelled = true;
         if(_loc3_ == this.FCurrentTabIndex)
         {
            this.FWindowVipBag.ShowViewByVipBags(this.FBleachTrainDatas.VipBags[_loc3_],param1);
         }
      }
      
      public function Update() : void
      {
         this.SwitchTab(this.FCurrentTabIndex);
      }
   }
}

