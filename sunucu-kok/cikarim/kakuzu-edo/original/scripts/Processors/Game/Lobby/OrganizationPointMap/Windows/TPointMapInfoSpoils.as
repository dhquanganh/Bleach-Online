package Processors.Game.Lobby.OrganizationPointMap.Windows
{
   import Components.ScrollBar.TScrollBar;
   import Components.Slots.TUISlot;
   import Components.Standard.TUIButton;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Logics.Inventories.TInventories;
   import Logics.Inventories.TInventory;
   import Logics.Organization.NewFeatures.TNewOrgData;
   import Logics.Organization.VO.TOrgSpoilsBarVO;
   import Logics.SLogicsCore;
   import Logics.Streamization.Organization.TUnstreamizerOrganizationNew;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import Processors.Game.Lobby.Jade.TJadeCommon;
   import Processors.Game.Utilities.EffectTextReward.*;
   import Processors.Game.Utilities.OverLayer.*;
   import Processors.Game.Windows.Information.TUIWindowConfirmation;
   import Resources.Constants.CONST_COMMON;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class TPointMapInfoSpoils extends TProcessorLobbyWindow
   {
      
      protected const MinScrollDistance:Number = 322;
      
      protected const ItemStamp:Number = 6;
      
      protected const SingleItemStamp:Number = 72;
      
      protected var FMainUI:MovieClip;
      
      protected var FData:TNewOrgData;
      
      protected var FScrollBar:TScrollBar;
      
      protected var FSlots:Vector.<TUISlot>;
      
      protected var FApplyListBtns:Vector.<TUIButton>;
      
      protected var FApplyBtns:Vector.<TUIButton>;
      
      protected var FText:Vector.<TextField>;
      
      protected var FCurrentApplyIndex:uint;
      
      protected var FOnOpenAppList:Function;
      
      protected var FUnstreamizerOrganizationNew:TUnstreamizerOrganizationNew;
      
      public function TPointMapInfoSpoils(param1:TUIComponent)
      {
         super(param1);
         this.FData = SLogicsCore.NewOrgData;
         this.FSlots = new Vector.<TUISlot>();
         this.FApplyListBtns = new Vector.<TUIButton>();
         this.FApplyBtns = new Vector.<TUIButton>();
         this.FText = new Vector.<TextField>();
      }
      
      override protected function LogicsPerform() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         super.LogicsPerform();
         if(Visible)
         {
            _loc2_ = this.FSlots.length;
            _loc1_ = 0;
            while(_loc1_ < _loc2_)
            {
               this.FSlots[_loc1_].Update();
               _loc1_++;
            }
         }
      }
      
      override public function set Visible(param1:Boolean) : void
      {
         super.Visible = param1;
         this.Update();
      }
      
      protected function OnCloseCall(param1:MouseEvent) : void
      {
         this.ResetSlots();
         ProcessorWindowClose();
      }
      
      protected function CreateItem() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:Vector.<TOrgSpoilsBarVO> = null;
         var _loc4_:TOrgSpoilsBarVO = null;
         var _loc5_:MovieClip = null;
         var _loc6_:TUISlot = null;
         var _loc7_:TInventories = null;
         var _loc8_:TInventory = null;
         var _loc9_:TUIButton = null;
         var _loc10_:TextField = null;
         _loc3_ = this.FData.CurrentCopy.SpoilsVOs;
         _loc2_ = _loc3_.length;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc4_ = _loc3_[_loc1_];
            _loc5_ = TUtilityReflection.CreateDisplayObjectInstance("MC_MapInfoSpoilsBar") as MovieClip;
            _loc6_ = new TUISlot(this);
            _loc6_.Resource = _loc5_["MC_Slot"];
            _loc6_.OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
            _loc6_.OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
            TJadeCommon.InitSlot(_loc6_);
            _loc6_.Init();
            _loc7_ = new TInventories();
            SToolReward.GetInventoryByID(CONST_COMMON.RewardIDToTemplateID(_loc4_.Type,_loc4_.Code),_loc7_);
            _loc8_ = _loc7_.GetInventoryByIndex(0);
            _loc8_.Quantity = _loc4_.Count;
            _loc6_.Context = _loc8_;
            this.FSlots.push(_loc6_);
            _loc9_ = new TUIButton();
            _loc9_.Substrate = _loc5_.Btn_ApplyList;
            _loc9_.OnClick = this.OnApplyListBtnClick;
            _loc9_.Enabled = _loc4_.AppCount != 0;
            _loc9_.Tag = _loc1_;
            this.FApplyListBtns.push(_loc9_);
            _loc9_ = new TUIButton();
            _loc9_.Substrate = _loc5_.Btn_Apply;
            _loc9_.OnClick = this.OnApplyBtnClick;
            _loc9_.Enabled = !_loc4_.IsApp;
            _loc9_.Tag = _loc1_;
            this.FApplyBtns.push(_loc9_);
            _loc10_ = _loc5_.TF_Info;
            if(_loc4_.IsApp)
            {
               _loc10_.text = this.FData.NewOrgSystemLanguage.GetStr19(_loc1_);
            }
            else if(_loc4_.AppCount == 0)
            {
               _loc10_.text = "";
            }
            else
            {
               _loc10_.text = this.FData.NewOrgSystemLanguage.GetStr18(_loc1_);
            }
            this.FText.push(_loc10_);
            this.FScrollBar.AddItem(_loc5_);
            _loc1_++;
         }
      }
      
      protected function ResetSlots() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         _loc2_ = this.FSlots.length;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FSlots[_loc1_].Dispose();
            _loc1_++;
         }
         this.FSlots.length = 0;
      }
      
      protected function OnApplyBtnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:Vector.<TOrgSpoilsBarVO> = null;
         var _loc6_:TOrgSpoilsBarVO = null;
         var _loc7_:TUIWindowConfirmation = null;
         var _loc8_:TUIButton = null;
         _loc8_ = param1 as TUIButton;
         this.FCurrentApplyIndex = _loc8_.Tag;
         if(this.FData.CurrentHaveApply)
         {
            _loc7_ = SUtilityOverLayer.UIWindowConfirmation;
            _loc7_.Text = this.FData.NewOrgSystemLanguage.GetStr33(this.FCurrentApplyIndex);
            _loc7_.OnOK = this.OnApplyOkCall;
            _loc7_.Visible = true;
            return;
         }
         this.FUnstreamizerOrganizationNew.ApplyReq(this.FCurrentApplyIndex);
      }
      
      protected function OnApplyOkCall(param1:Object) : void
      {
         this.FUnstreamizerOrganizationNew.ApplyReq(this.FCurrentApplyIndex);
      }
      
      protected function OnApplyListBtnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TUIButton = null;
         _loc3_ = param1 as TUIButton;
         if(this.FOnOpenAppList != null)
         {
            this.FOnOpenAppList(_loc3_.Tag);
         }
      }
      
      public function set OnOpenAppList(param1:Function) : void
      {
         this.FOnOpenAppList = param1;
      }
      
      public function set UnstreamizerOrganizationNew(param1:TUnstreamizerOrganizationNew) : void
      {
         this.FUnstreamizerOrganizationNew = param1;
      }
      
      public function UIDispatch() : void
      {
         this.FMainUI = TUtilityReflection.CreateDisplayObjectInstance("MC_PointMapInfoSpoils") as MovieClip;
         addChild(this.FMainUI);
         this.FMainUI.Btn_Close.addEventListener(MouseEvent.CLICK,this.OnCloseCall);
         this.FScrollBar = new TScrollBar(this.FMainUI["MC_Scene"],this.MinScrollDistance,false,this.ItemStamp,this.SingleItemStamp);
      }
      
      public function Update() : void
      {
         if(Visible && this.FData != null)
         {
            this.FApplyListBtns.length = 0;
            this.FApplyBtns.length = 0;
            this.FText.length = 0;
            this.ResetSlots();
            this.FScrollBar.Clear();
            this.CreateItem();
            this.FScrollBar.ScrollToUp();
            this.FScrollBar.Visible = true;
         }
      }
      
      public function UpdateItem() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:Vector.<TOrgSpoilsBarVO> = null;
         var _loc4_:TOrgSpoilsBarVO = null;
         var _loc5_:TUIButton = null;
         var _loc6_:TextField = null;
         if(Visible && this.FData != null)
         {
            _loc3_ = this.FData.CurrentCopy.SpoilsVOs;
            _loc2_ = _loc3_.length;
            _loc1_ = 0;
            while(_loc1_ < _loc2_)
            {
               _loc4_ = _loc3_[_loc1_];
               _loc5_ = this.FApplyListBtns[_loc1_];
               _loc5_.Enabled = _loc4_.AppCount != 0;
               _loc5_ = this.FApplyBtns[_loc1_];
               _loc5_.Enabled = !_loc4_.IsApp;
               _loc6_ = this.FText[_loc1_];
               if(_loc4_.IsApp)
               {
                  _loc6_.text = this.FData.NewOrgSystemLanguage.GetStr19(_loc1_);
               }
               else if(_loc4_.AppCount == 0)
               {
                  _loc6_.text = "";
               }
               else
               {
                  _loc6_.text = this.FData.NewOrgSystemLanguage.GetStr18(_loc1_);
               }
               _loc1_++;
            }
         }
      }
   }
}

