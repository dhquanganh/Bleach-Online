package Processors.Game.Lobby.Activity.HDActivityEquipmentShop
{
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.HDActivityEquipmentShop.*;
   import Logics.HDActivityOS.*;
   import Processors.Game.Lobby.Activity.HDActivity.*;
   import Processors.Game.Lobby.Activity.HDActivityEquipmentShop.Component.TUIActivityExchangeItem;
   import Processors.Game.Lobby.Utilities.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class TProcessorHDWindowExchangeItem extends TProcessorHDSingleWindowBase
   {
      
      protected static const COUNT_MC_ITEM:uint = 9;
      
      protected static const COUNT_TF_ITEM:uint = 2;
      
      protected static const COUNT_MOVIE_ITEM:uint = 1;
      
      protected static const COUNT_SLOT_ITEM:uint = 1;
      
      protected static const INDEX_TYPE_EXCHANGE:uint = 3;
      
      protected var FItems:Vector.<TUIActivityExchangeItem>;
      
      protected var FTF_BlueChip:TextField;
      
      protected var FTF_RedChip:TextField;
      
      protected var FTF_PurpleChip:TextField;
      
      protected var FCurBoxIndex:int;
      
      protected var FHDEquipment:THDExchangeChip;
      
      protected var FDataEquipment:TActivitySingleEquipementShop;
      
      protected var FExchangeType:uint;
      
      protected var FExchangeList:Vector.<TExchange>;
      
      protected var FInitWindow:Boolean;
      
      public function TProcessorHDWindowExchangeItem(param1:TUIComponent)
      {
         super(param1);
         FSceneResourceName = CONST_ACTIVITY.RESOURCE_ClassName_EquipmentShopExchangeItem;
         this.FCurBoxIndex = 0;
         this.FHDEquipment = new THDExchangeChip();
         this.FDataEquipment = new TActivitySingleEquipementShop();
         this.FInitWindow = false;
      }
      
      override protected function LogicsPerform() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         super.LogicsPerform();
         if(!this.FInitWindow)
         {
            return;
         }
         _loc2_ = int(this.FItems.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FItems[_loc1_].UpDateSlot();
            _loc1_++;
         }
      }
      
      override public function InitWindow(param1:Sprite = null) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TUIActivityExchangeItem = null;
         var _loc5_:Sprite = null;
         super.InitWindow();
         _loc3_ = int(COUNT_MC_ITEM);
         this.FItems = new Vector.<TUIActivityExchangeItem>(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = new TUIActivityExchangeItem(this);
            _loc4_.OnBtnOkClick = this.BtnOKOnClick;
            _loc4_.OnSlotOver = ProcessorOnSlotOver;
            _loc4_.OnSlotOut = ProcessorOnSlotOut;
            _loc4_.OnQuerySequenceContext = SlotsOnQuerySequenceContext;
            _loc4_.OnQuerySubscript = SlotsOnQuerySubscript;
            _loc4_.Perform_UIDispatch(_loc2_,FScene[CONST_ACTIVITY.RESOURCE_Link_MC_Slot + _loc2_],COUNT_TF_ITEM,COUNT_MOVIE_ITEM,COUNT_SLOT_ITEM);
            this.FItems[_loc2_] = _loc4_;
            _loc2_++;
         }
         _loc5_ = FScene[CONST_ACTIVITY.RESOURCE_Link_MC_Chip];
         _loc5_.mouseChildren = false;
         _loc5_.mouseEnabled = false;
         this.FTF_BlueChip = _loc5_[CONST_ACTIVITY.RESOURCE_Link_TF_BlueChip];
         this.FTF_BlueChip.mouseEnabled = false;
         this.FTF_RedChip = _loc5_[CONST_ACTIVITY.RESOURCE_Link_TF_RedChip];
         this.FTF_RedChip.mouseEnabled = false;
         this.FTF_PurpleChip = _loc5_[CONST_ACTIVITY.RESOURCE_Link_TF_PurpleChip];
         this.FTF_PurpleChip.mouseEnabled = false;
         this.ResetTextField();
         this.FInitWindow = true;
      }
      
      override protected function UpdateDataBase(param1:TActivityOSBase) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Vector.<uint> = null;
         super.UpdateDataBase(param1);
         this.FDataEquipment = param1 as TActivitySingleEquipementShop;
         this.FExchangeList = this.FDataEquipment.GetExchangeListByType(this.FExchangeType);
         _loc3_ = int(this.FExchangeList.length);
         _loc4_ = new Vector.<uint>(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_[_loc2_] = this.FExchangeList[_loc2_].Awards[0];
            _loc2_++;
         }
         FInventoriesVect = ProcessorGetInventoriesVectByAwardID(_loc4_);
         this.UpdateUI();
      }
      
      override protected function UpdateUI() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Vector.<String> = null;
         var _loc4_:Vector.<int> = null;
         super.UpdateUI();
         _loc2_ = int(this.FItems.length);
         _loc3_ = new Vector.<String>(COUNT_TF_ITEM);
         _loc4_ = new Vector.<int>(COUNT_MOVIE_ITEM);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            if(_loc1_ < 3)
            {
               _loc4_[0] = 1;
            }
            else if(_loc1_ < 6)
            {
               _loc4_[0] = 2;
            }
            else
            {
               _loc4_[0] = 3;
            }
            _loc3_[0] = this.FExchangeList[_loc1_].KeysAmount[0].toString();
            if(this.FExchangeList[_loc1_].Limit == 0)
            {
               _loc3_[1] = "";
            }
            else
            {
               _loc3_[1] = this.FExchangeList[_loc1_].ExchangeCount.toString() + "/" + this.FExchangeList[_loc1_].Limit.toString();
            }
            this.FItems[_loc1_].UpDateUI(_loc1_,FInventoriesVect[_loc1_],_loc3_,_loc4_);
            this.FItems[_loc1_].UpDateBtn(this.FExchangeList[_loc1_].ExchangeStatus);
            _loc1_++;
         }
         this.FTF_BlueChip.text = this.FDataEquipment.ChipVect[0].Count.toString();
         this.FTF_RedChip.text = this.FDataEquipment.ChipVect[1].Count.toString();
         this.FTF_PurpleChip.text = this.FDataEquipment.ChipVect[2].Count.toString();
      }
      
      override protected function UpdateUIConfig() : void
      {
         super.UpdateUIConfig();
         this.FHDEquipment = FHDActivityConfig as THDExchangeChip;
         this.FExchangeType = this.FHDEquipment.ExchangeTypeVect[INDEX_TYPE_EXCHANGE].Type;
      }
      
      override protected function Reset() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         super.Reset();
         if(!this.FInitWindow)
         {
            return;
         }
         _loc2_ = int(this.FItems.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FItems[_loc1_].Clear();
            _loc1_++;
         }
         this.ResetTextField();
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
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FExchangeList[this.FCurBoxIndex].Index,CONST_ACTIVITY_MODE.TYPE_Operate_Buy);
      }
      
      override protected function BtnOKOnClick(param1:Object, param2:uint) : void
      {
         var _loc3_:TExchange = null;
         var _loc4_:TChip = null;
         var _loc5_:int = 0;
         super.BtnOKOnClick(param1,param2);
         this.FCurBoxIndex = param2;
         _loc3_ = this.FExchangeList[param2];
         _loc4_ = this.FDataEquipment.GetChipByUniqueIndex(_loc3_.KeysChip[0].Index);
         if(_loc4_.Count < _loc3_.KeysAmount[0])
         {
            _loc5_ = (_loc3_.KeysAmount[0] - _loc4_.Count) * _loc4_.Need;
            if(FCharacter.CreditGold >= _loc5_)
            {
               FUIWindowConfirmation.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_35),_loc5_);
               FUIWindowConfirmation.OnOK = this.WindowInformationOnOK;
               FUIWindowConfirmation.Visible = true;
            }
            else
            {
               FUIWindowRecharge.Visible = true;
            }
         }
         else
         {
            Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,_loc3_.Index,CONST_ACTIVITY_MODE.TYPE_Operate_Buy);
         }
      }
      
      override protected function BtnCloseOnClick(param1:Object, param2:MouseEvent) : void
      {
         super.BtnCloseOnClick(param1,param2);
         if(FOnBtnCloseClick != null)
         {
            FOnBtnCloseClick(this,CONST_ACTIVITY_MODE.TYPE_EQUIPMENTSHOP_WindowExchange);
         }
      }
   }
}

