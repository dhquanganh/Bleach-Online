package Processors.Game.Lobby.Activity.HDActivityEquipmentShop
{
   import Components.Standard.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.HDActivityEquipmentShop.*;
   import Logics.HDActivityOS.*;
   import Logics.Inventories.*;
   import Processors.Game.Lobby.Activity.HDActivity.*;
   import Processors.Game.Lobby.Activity.HDActivityEquipmentShop.Component.TUIActivityExchangeItem;
   import Processors.Game.Lobby.Utilities.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class TProcessorHDWindowExchange extends TProcessorHDSingleWindowBase
   {
      
      protected static const COUNT_ITEM_EXCHANGE:uint = 8;
      
      protected static const COUNT_TAB_EXCHANGE:uint = 3;
      
      protected static const COUNT_TF_Item:uint = 2;
      
      protected static const COUNT_MC_Item:uint = 1;
      
      protected static const COUNT_SLOT_Item:uint = 1;
      
      protected var FUITab:TUITab;
      
      protected var FMC_Chip:Sprite;
      
      protected var FTF_BlueChip:TextField;
      
      protected var FTF_RedChip:TextField;
      
      protected var FTF_PurpleChip:TextField;
      
      protected var FItems:Vector.<TUIActivityExchangeItem>;
      
      protected var FBtn_Enter:TUIButton;
      
      protected var FMC_HDDesc:Sprite;
      
      protected var FMC_Effect:MovieClip;
      
      protected var FBtn_EnterItem:TUIButton;
      
      protected var FMC_EnterItemEffect:MovieClip;
      
      protected var FTabIndex:int;
      
      protected var FCurBoxIndex:uint;
      
      protected var FHDEquipment:THDExchangeChip;
      
      protected var FDataEquipment:TActivitySingleEquipementShop;
      
      protected var FInventories:Vector.<TInventories>;
      
      protected var FOnBtnEnterClick:Function;
      
      public function TProcessorHDWindowExchange(param1:TUIComponent)
      {
         super(param1);
         FSceneResourceName = CONST_ACTIVITY.RESOURCE_ClassName_EquipmentShopExchange;
         this.FTabIndex = 0;
         this.FCurBoxIndex = 0;
         this.FHDEquipment = new THDExchangeChip();
         this.FDataEquipment = new TActivitySingleEquipementShop();
         this.FInventories = new Vector.<TInventories>();
      }
      
      override protected function LogicsPerform() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         super.LogicsPerform();
         if(this.FItems == null || this.FItems.length < 0)
         {
            return;
         }
         _loc2_ = int(COUNT_ITEM_EXCHANGE);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            if(this.FItems[_loc1_] != null)
            {
               this.FItems[_loc1_].UpDateSlot();
            }
            _loc1_++;
         }
      }
      
      override public function InitWindow(param1:Sprite = null) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TUIActivityExchangeItem = null;
         super.InitWindow(param1);
         this.FBtn_Enter = new TUIButton();
         this.FBtn_Enter.Substrate = FScene[CONST_ACTIVITY.RESOURCE_Link_BTN_OK];
         this.FBtn_Enter.OnClick = this.BtnEnterOnClick;
         this.FBtn_Enter.Enabled = true;
         _loc3_ = int(COUNT_TAB_EXCHANGE);
         this.FUITab = new TUITab(this);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FUITab.SetTabByIndex(FScene[CONST_ACTIVITY.RESOURCE_Link_BTN_Tabs + _loc2_],_loc2_);
            _loc2_++;
         }
         this.FUITab.OnSwitch = this.TabOnSwitch;
         this.FUITab.Init();
         this.FMC_Chip = FScene[CONST_ACTIVITY.RESOURCE_Link_MC_Chip];
         this.FTF_BlueChip = this.FMC_Chip[CONST_ACTIVITY.RESOURCE_Link_TF_BlueChip];
         this.FTF_BlueChip.mouseEnabled = false;
         this.FTF_RedChip = this.FMC_Chip[CONST_ACTIVITY.RESOURCE_Link_TF_RedChip];
         this.FTF_RedChip.mouseEnabled = false;
         this.FTF_PurpleChip = this.FMC_Chip[CONST_ACTIVITY.RESOURCE_Link_TF_PurpleChip];
         this.FTF_PurpleChip.mouseEnabled = false;
         _loc3_ = int(COUNT_ITEM_EXCHANGE);
         this.FItems = new Vector.<TUIActivityExchangeItem>(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = new TUIActivityExchangeItem(this);
            _loc4_.OnBtnOkClick = this.BtnOKOnClick;
            _loc4_.OnQuerySequenceContext = SlotsOnQuerySequenceContext;
            _loc4_.OnQuerySubscript = SlotsOnQuerySubscript;
            _loc4_.OnSlotsQueryEdgeColor = SlotsOnQueryEdgeColor;
            _loc4_.OnSlotOver = ProcessorOnSlotOver;
            _loc4_.OnSlotOut = ProcessorOnSlotOut;
            _loc4_.Perform_UIDispatch(_loc2_,FScene[CONST_ACTIVITY.RESOURCE_Link_MC_Slot + _loc2_],COUNT_TF_Item,COUNT_MC_Item,COUNT_SLOT_Item);
            this.FItems[_loc2_] = _loc4_;
            _loc2_++;
         }
         this.FMC_HDDesc = FScene[CONST_ACTIVITY.RESOURCE_Link_MC_HDDesc];
         this.FMC_HDDesc.addEventListener(MouseEvent.MOUSE_MOVE,this.DescOnOver);
         this.FMC_HDDesc.addEventListener(MouseEvent.MOUSE_OUT,this.DescOnOut);
         this.FMC_Effect = FScene[CONST_ACTIVITY.RESOURCE_Link_MC_List_MC_SingleEffect];
         this.FMC_Effect.stop();
         this.FBtn_EnterItem = new TUIButton();
         this.FBtn_EnterItem.Substrate = FScene[CONST_ACTIVITY.RESOURCE_Link_MC_List_Btn_EnterItem];
         this.FBtn_EnterItem.OnClick = this.BtnEnterItemOnClick;
         this.FMC_EnterItemEffect = FScene[CONST_ACTIVITY.RESOURCE_Link_MC_List_MC_EnterItemEffect];
         this.FMC_EnterItemEffect.mouseChildren = false;
         this.FMC_EnterItemEffect.mouseEnabled = false;
         this.FMC_EnterItemEffect.stop();
         this.ResetTextField();
      }
      
      override protected function UpdateDataBase(param1:TActivityOSBase) : void
      {
         super.UpdateDataBase(param1);
         this.FDataEquipment = param1 as TActivitySingleEquipementShop;
         this.UpdateUI();
      }
      
      override protected function UpdateUI() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Vector.<TExchange> = null;
         var _loc4_:Vector.<String> = null;
         var _loc5_:Vector.<int> = null;
         var _loc6_:Vector.<TInventories> = null;
         super.UpdateUI();
         _loc3_ = this.FDataEquipment.GetExchangeListByType(this.FTabIndex);
         _loc4_ = new Vector.<String>();
         _loc5_ = new Vector.<int>();
         _loc2_ = int(COUNT_ITEM_EXCHANGE);
         _loc6_ = this.GetInventoriesByItem();
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc4_.push(_loc3_[_loc1_].KeysAmount[0].toString());
            if(_loc3_[_loc1_].Limit == 0)
            {
               _loc4_.push("");
            }
            else
            {
               _loc4_.push(this.FDataEquipment.GetExchangeByUniqueIndex(_loc3_[_loc1_].Index).ExchangeCount + "/" + _loc3_[_loc1_].Limit.toString());
            }
            _loc5_.push(this.FTabIndex + 1);
            if(_loc1_ < _loc3_.length)
            {
               this.FItems[_loc1_].UpDateUI(_loc3_[_loc1_].Index,this.GetInventoriesByItem()[_loc1_],_loc4_,_loc5_);
               this.FItems[_loc1_].UpDateBtn(_loc3_[_loc1_].ExchangeStatus);
               this.FItems[_loc1_].Visible = true;
            }
            else
            {
               this.FItems[_loc1_].Clear();
               this.FItems[_loc1_].Visible = false;
            }
            _loc5_.length = 0;
            _loc4_.length = 0;
            _loc1_++;
         }
         this.FTF_BlueChip.text = this.FDataEquipment.ChipVect[0].Count.toString();
         this.FTF_RedChip.text = this.FDataEquipment.ChipVect[1].Count.toString();
         this.FTF_PurpleChip.text = this.FDataEquipment.ChipVect[2].Count.toString();
         this.UpdateUITab();
      }
      
      override protected function UpdateUIConfig() : void
      {
         super.UpdateUIConfig();
         this.FHDEquipment = FHDActivityConfig as THDExchangeChip;
         if(FActivityAtoms.TimeShowType == CONST_ACTIVITY_MODE.TYPE_TimeShowNormal)
         {
            ProcessorFormatActivityTime(FActivityAtoms.StartTime,FActivityAtoms.EndTime);
         }
         else if(FActivityAtoms.TimeShowType == CONST_ACTIVITY_MODE.TYPE_TimeShowFromNowON)
         {
            ProcessorFormatActivityTimeFromNowOn(FActivityAtoms.EndTime);
         }
         ProcessorFormatActivityCountDown(FActivityAtoms.EndTime);
         if(this.FMC_Effect != null)
         {
            this.FMC_Effect.play();
         }
         if(this.FMC_EnterItemEffect != null)
         {
            this.FMC_EnterItemEffect.play();
         }
      }
      
      override protected function Reset() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         super.Reset();
         _loc2_ = int(COUNT_ITEM_EXCHANGE);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FItems[_loc1_].Clear();
            _loc1_++;
         }
         this.ResetTextField();
         this.FMC_Effect.stop();
         this.FMC_EnterItemEffect.stop();
      }
      
      protected function UpdateUITab() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc2_ = int(COUNT_TAB_EXCHANGE);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FUITab.SetTabCaptionByIndex(this.FHDEquipment.ExchangeTypeVect[_loc1_].Name,_loc1_);
            _loc1_++;
         }
      }
      
      protected function GetInventoriesByItem() : Vector.<TInventories>
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Vector.<uint> = null;
         var _loc4_:Vector.<TExchange> = null;
         _loc4_ = this.FDataEquipment.GetExchangeListByType(this.FTabIndex);
         _loc2_ = int(_loc4_.length);
         _loc3_ = new Vector.<uint>(_loc2_);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_[_loc1_] = _loc4_[_loc1_].Awards[0];
            _loc1_++;
         }
         return ProcessorGetInventoriesVectByAwardID(_loc3_);
      }
      
      protected function ResetTextField() : void
      {
         this.FTF_BlueChip.text = "";
         this.FTF_RedChip.text = "";
         this.FTF_PurpleChip.text = "";
      }
      
      override protected function WindowInformationOnOK(param1:Object) : void
      {
         super.WindowInformationOnOK(param1);
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FCurBoxIndex,CONST_ACTIVITY_MODE.TYPE_Operate_Buy);
      }
      
      override protected function BtnOKOnClick(param1:Object, param2:uint) : void
      {
         var _loc3_:TExchange = null;
         var _loc4_:TChip = null;
         var _loc5_:int = 0;
         super.BtnOKOnClick(param1,param2);
         this.FCurBoxIndex = param2;
         _loc3_ = this.FDataEquipment.GetExchangeByUniqueIndex(param2);
         _loc4_ = this.FDataEquipment.GetChipByUniqueIndex(_loc3_.KeysChip[0].Index);
         if(_loc4_.Count < _loc3_.KeysAmount[0])
         {
            _loc5_ = (_loc3_.KeysAmount[0] - _loc4_.Count) * _loc4_.Need;
            if(FCharacter.CreditGold >= _loc5_)
            {
               FUIWindowConfirmation.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_35),_loc5_);
               FUIWindowConfirmation.OnOK = this.WindowInformationOnOK;
               FUIWindowConfirmation.OnCancel = WindowInformationOnCancel;
               FUIWindowConfirmation.Visible = true;
            }
            else
            {
               FUIWindowRecharge.Visible = true;
            }
         }
         else
         {
            Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,param2,CONST_ACTIVITY_MODE.TYPE_Operate_Buy);
         }
      }
      
      override protected function BtnCloseOnClick(param1:Object, param2:MouseEvent) : void
      {
         super.BtnCloseOnClick(param1,param2);
         if(FOnBtnCloseClick != null)
         {
            FOnBtnCloseClick();
         }
      }
      
      protected function BtnEnterOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FOnBtnEnterClick != null)
         {
            this.FOnBtnEnterClick(this,CONST_ACTIVITY_MODE.TYPE_EQUIPMENTSHOP_WindowGetChip);
         }
      }
      
      protected function BtnEnterItemOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FOnBtnEnterClick != null)
         {
            this.FOnBtnEnterClick(this,CONST_ACTIVITY_MODE.TYPE_EQUIPMENTSHOP_WindowExchangeItem);
         }
      }
      
      protected function TabOnSwitch(param1:Object) : void
      {
         this.FTabIndex = param1 as int;
         this.UpdateUI();
      }
      
      protected function DescOnOver(param1:MouseEvent) : void
      {
         FHint.Caption = this.FHDEquipment.Page1Desc;
         if(FOnHintOver != null)
         {
            FOnHintOver(this,FHint);
         }
      }
      
      protected function DescOnOut(param1:MouseEvent) : void
      {
         if(FOnHintOut != null)
         {
            FOnHintOut(this,FHint);
         }
      }
      
      public function get OnBtnEnterClick() : Function
      {
         return this.FOnBtnEnterClick;
      }
      
      public function set OnBtnEnterClick(param1:Function) : void
      {
         this.FOnBtnEnterClick = param1;
      }
   }
}

