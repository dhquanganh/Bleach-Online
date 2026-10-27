package Processors.Game.Lobby.Activity.HDActivityEquipmentShop
{
   import Components.Standard.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Bins.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.DatebaseVO.VO.Json.*;
   import Logics.HDActivityEquipmentShop.*;
   import Logics.HDActivityOS.*;
   import Logics.Inventories.*;
   import Processors.Game.Lobby.Activity.HDActivity.*;
   import Processors.Game.Lobby.Activity.HDActivityOS.Component.*;
   import Processors.Game.Lobby.Utilities.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class TProcessorHDWindowGetChip extends TProcessorHDSingleWindowBase
   {
      
      protected static const COUNT_LIST_CHIP:uint = 3;
      
      protected static const COUNT_SLOT_CHIP:uint = 3;
      
      protected static const COUNT_TF_CHIP:uint = 2;
      
      protected var FMC_Chip:Sprite;
      
      protected var FTF_BlueChip:TextField;
      
      protected var FTF_RedChip:TextField;
      
      protected var FTF_PurpleChip:TextField;
      
      protected var FMC_Blue:Sprite;
      
      protected var FMC_Red:Sprite;
      
      protected var FMC_Purple:Sprite;
      
      protected var FBlueChipLists:Vector.<TUIActivityOSAwardList>;
      
      protected var FRedChipLists:Vector.<TUIActivityOSAwardList>;
      
      protected var FPurpleChipLists:Vector.<TUIActivityOSAwardList>;
      
      protected var FBtn_GetChip:TUIButton;
      
      protected var FTF_Count:TextField;
      
      protected var FTF_PageDesc:TextField;
      
      protected var FConfigValueBin:TBins;
      
      protected var FFixedAwards:Vector.<Object>;
      
      protected var FBuyBoxIndex:uint;
      
      protected var FDataEquipment:TActivitySingleEquipementShop;
      
      protected var FHDEquipment:THDExchangeChip;
      
      public function TProcessorHDWindowGetChip(param1:TUIComponent)
      {
         super(param1);
         FSceneResourceName = CONST_ACTIVITY.RESOURCE_ClassName_EquipmentShopGetScore;
         this.FBuyBoxIndex = 0;
         this.FDataEquipment = new TActivitySingleEquipementShop();
         this.FHDEquipment = new THDExchangeChip();
         this.FFixedAwards = new Vector.<Object>();
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
      }
      
      override public function InitWindow(param1:Sprite = null) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TUIActivityOSAwardList = null;
         super.InitWindow(param1);
         this.FBtn_GetChip = new TUIButton();
         this.FBtn_GetChip.Substrate = FScene[CONST_ACTIVITY.RESOURCE_Link_BTN_OK];
         this.FBtn_GetChip.OnClick = this.BtnGetOnClick;
         this.FBtn_GetChip.OnMove = this.BtnGetOnOver;
         this.FBtn_GetChip.OnOut = this.BtnGetOnOut;
         this.FBtn_GetChip.Enabled = false;
         this.FMC_Blue = FScene[CONST_ACTIVITY.RESOURCE_Link_MC_List_BlueChip];
         this.FMC_Red = FScene[CONST_ACTIVITY.RESOURCE_Link_MC_List_RedChip];
         this.FMC_Purple = FScene[CONST_ACTIVITY.RESOURCE_Link_MC_List_PurpleChip];
         _loc3_ = int(COUNT_SLOT_CHIP);
         this.FBlueChipLists = new Vector.<TUIActivityOSAwardList>(_loc3_);
         this.FRedChipLists = new Vector.<TUIActivityOSAwardList>(_loc3_);
         this.FPurpleChipLists = new Vector.<TUIActivityOSAwardList>(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = new TUIActivityOSAwardList(this);
            _loc4_.OnBtnOkClick = this.BtnOKOnClick;
            _loc4_.OnSceneOver = this.ItemSceneOnOver;
            _loc4_.OnSceneOut = this.ItemSceneOnOut;
            _loc4_.Perform_UIDispatch(this.FMC_Blue[CONST_ACTIVITY.RESOURCE_Link_MC_Slot + _loc2_],COUNT_TF_CHIP,0,false);
            this.FBlueChipLists[_loc2_] = _loc4_;
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = new TUIActivityOSAwardList(this);
            _loc4_.OnBtnOkClick = this.BtnOKOnClick;
            _loc4_.OnSceneOver = this.ItemSceneOnOver;
            _loc4_.OnSceneOut = this.ItemSceneOnOut;
            _loc4_.Perform_UIDispatch(this.FMC_Red[CONST_ACTIVITY.RESOURCE_Link_MC_Slot + _loc2_],COUNT_TF_CHIP,0,false);
            this.FRedChipLists[_loc2_] = _loc4_;
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = new TUIActivityOSAwardList(this);
            _loc4_.OnBtnOkClick = this.BtnOKOnClick;
            _loc4_.OnSceneOver = this.ItemSceneOnOver;
            _loc4_.OnSceneOut = this.ItemSceneOnOut;
            _loc4_.Perform_UIDispatch(this.FMC_Purple[CONST_ACTIVITY.RESOURCE_Link_MC_Slot + _loc2_],COUNT_TF_CHIP,0,false);
            this.FPurpleChipLists[_loc2_] = _loc4_;
            _loc2_++;
         }
         this.FMC_Chip = FScene[CONST_ACTIVITY.RESOURCE_Link_MC_Chip];
         this.FTF_BlueChip = this.FMC_Chip[CONST_ACTIVITY.RESOURCE_Link_TF_BlueChip];
         this.FTF_BlueChip.mouseEnabled = false;
         this.FTF_RedChip = this.FMC_Chip[CONST_ACTIVITY.RESOURCE_Link_TF_RedChip];
         this.FTF_RedChip.mouseEnabled = false;
         this.FTF_PurpleChip = this.FMC_Chip[CONST_ACTIVITY.RESOURCE_Link_TF_PurpleChip];
         this.FTF_PurpleChip.mouseEnabled = false;
         this.FTF_Count = FScene[CONST_ACTIVITY.RESOURCE_Link_TF_Count];
         this.FTF_Count.mouseEnabled = false;
         this.FTF_PageDesc = FScene[CONST_ACTIVITY.RESOURCE_Link_TF_Desc];
         this.FTF_PageDesc.mouseEnabled = false;
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
         var _loc3_:Vector.<String> = null;
         var _loc4_:Vector.<TBuyBox> = null;
         var _loc5_:Vector.<TChip> = null;
         super.UpdateUI();
         _loc3_ = new Vector.<String>();
         _loc5_ = this.FDataEquipment.ChipVect;
         _loc4_ = this.FDataEquipment.GetBuyBoxListByChipUniqueIndex(_loc5_[0].Index);
         _loc2_ = int(COUNT_SLOT_CHIP);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_.push("Lv." + (_loc1_ + 1));
            _loc3_.push(_loc4_[_loc1_].Need.toString());
            this.FBlueChipLists[_loc1_].UpDateUI(_loc4_[_loc1_].Index,null,_loc3_);
            this.FBlueChipLists[_loc1_].UpDateBtn(CONST_ACTIVITY_MODE.Activity_CanReceive);
            this.FRedChipLists[_loc1_].UpDateUI(_loc4_[_loc1_].Index,null,_loc3_);
            this.FRedChipLists[_loc1_].UpDateBtn(CONST_ACTIVITY_MODE.Activity_CanReceive);
            _loc3_.length = 0;
            _loc1_++;
         }
         _loc4_ = this.FDataEquipment.GetBuyBoxListByChipUniqueIndex(_loc5_[1].Index);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_.push("Lv." + (_loc1_ + 1));
            _loc3_.push(_loc4_[_loc1_].Need.toString());
            this.FRedChipLists[_loc1_].UpDateUI(_loc4_[_loc1_].Index,null,_loc3_);
            this.FRedChipLists[_loc1_].UpDateBtn(CONST_ACTIVITY_MODE.Activity_CanReceive);
            _loc3_.length = 0;
            _loc1_++;
         }
         _loc4_ = this.FDataEquipment.GetBuyBoxListByChipUniqueIndex(_loc5_[2].Index);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_.push("Lv." + (_loc1_ + 1));
            _loc3_.push(_loc4_[_loc1_].Need.toString());
            this.FPurpleChipLists[_loc1_].UpDateUI(_loc4_[_loc1_].Index,null,_loc3_);
            this.FPurpleChipLists[_loc1_].UpDateBtn(CONST_ACTIVITY_MODE.Activity_CanReceive);
            _loc3_.length = 0;
            _loc1_++;
         }
         this.FTF_BlueChip.text = this.FDataEquipment.ChipVect[0].Count.toString();
         this.FTF_RedChip.text = this.FDataEquipment.ChipVect[1].Count.toString();
         this.FTF_PurpleChip.text = this.FDataEquipment.ChipVect[2].Count.toString();
         this.FTF_Count.text = this.FDataEquipment.FreeDrawVect[0].Count.toString();
         if(this.FDataEquipment.FreeDrawVect[0].Status == CONST_ACTIVITY_MODE.Activity_CanReceive)
         {
            this.FBtn_GetChip.Enabled = true;
         }
         else
         {
            this.FBtn_GetChip.Enabled = false;
         }
      }
      
      override protected function UpdateUIConfig() : void
      {
         var _loc1_:TConfigValue = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Array = null;
         super.UpdateUIConfig();
         this.FHDEquipment = FHDActivityConfig as THDExchangeChip;
         this.FTF_PageDesc.text = this.FHDEquipment.Page2Desc;
         if(this.FConfigValueBin == null)
         {
            this.FConfigValueBin = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_ConfigValue);
         }
         _loc1_ = this.FConfigValueBin.GetDatebaseByIdentifier(CONST_CONFIGVALUE.HD_ExchangeChip) as TConfigValue;
         this.FFixedAwards = _loc1_.Value as Vector.<Object>;
      }
      
      override protected function Reset() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         super.Reset();
         this.ResetTextField();
         _loc2_ = int(COUNT_LIST_CHIP);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FBlueChipLists[_loc1_].Clear();
            this.FRedChipLists[_loc1_].Clear();
            this.FPurpleChipLists[_loc1_].Clear();
            _loc1_++;
         }
      }
      
      protected function ResetTextField() : void
      {
         this.FTF_BlueChip.text = "";
         this.FTF_RedChip.text = "";
         this.FTF_PurpleChip.text = "";
         this.FTF_Count.text = "";
         this.FTF_PageDesc.text = "";
      }
      
      protected function GetInventoriesByUniqueIndex(param1:uint) : TInventories
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Vector.<uint> = null;
         var _loc7_:TBuyBox = null;
         var _loc8_:TFixedAward = null;
         var _loc9_:Vector.<TFixedAward> = null;
         _loc3_ = int(this.FFixedAwards.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(this.FFixedAwards[_loc2_].index == param1)
            {
               _loc5_ = int(this.FFixedAwards[_loc2_].fixed.length);
               _loc9_ = new Vector.<TFixedAward>(_loc5_);
               _loc4_ = 0;
               while(_loc4_ < _loc5_)
               {
                  _loc8_ = new TFixedAward(this.FFixedAwards[_loc2_].fixed[_loc4_]);
                  _loc9_[_loc4_] = _loc8_;
                  _loc4_++;
               }
               return ProcessorGetInventories(0,_loc9_);
            }
            _loc2_++;
         }
         return null;
      }
      
      protected function GetChipAwardsByUniqueIndex(param1:uint) : Vector.<String>
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TBuyBox = null;
         var _loc5_:Vector.<String> = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:TRateData = null;
         _loc4_ = this.FDataEquipment.GetBuyBoxByUniqueIndex(param1);
         _loc7_ = _loc4_.Chip.Name;
         _loc3_ = int(_loc4_.RateData.length);
         _loc8_ = _loc9_ = int(_loc4_.RateData[0].Amount);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc10_ = _loc4_.RateData[_loc2_];
            if(_loc10_.Amount < _loc8_)
            {
               _loc8_ = int(_loc10_.Amount);
            }
            if(_loc10_.Amount > _loc9_)
            {
               _loc9_ = int(_loc10_.Amount);
            }
            _loc2_++;
         }
         _loc6_ = _loc7_ + "  " + _loc8_ + "-" + _loc9_;
         _loc5_ = new Vector.<String>();
         _loc5_.push(TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_03),CONST_COMMON.HTMLCOLOR_White,_loc6_));
         return _loc5_;
      }
      
      override protected function WindowInformationOnOK(param1:Object) : void
      {
         super.WindowInformationOnOK(param1);
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,FBoxIndex,CONST_ACTIVITY_MODE.Activity_CanReceive);
      }
      
      override protected function WindowInformationOnCancel(param1:Object) : void
      {
         super.WindowInformationOnCancel(param1);
      }
      
      override protected function BtnOKOnClick(param1:Object, param2:uint) : void
      {
         super.BtnOKOnClick(param1,param2);
         FBoxIndex = param2;
         if(FCharacter.CreditGold >= this.FDataEquipment.GetBuyBoxByUniqueIndex(FBoxIndex).Need)
         {
            FUIWindowConfirmation.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_06),this.FDataEquipment.GetBuyBoxByUniqueIndex(FBoxIndex).Need);
            FUIWindowConfirmation.OnOK = this.WindowInformationOnOK;
            FUIWindowConfirmation.OnCancel = this.WindowInformationOnCancel;
            FUIWindowConfirmation.Visible = true;
         }
         else
         {
            FUIWindowRecharge.Visible = true;
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
      
      protected function BtnGetOnClick(param1:Object, param2:MouseEvent) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FDataEquipment.FreeDrawVect[0].Index,CONST_ACTIVITY_MODE.Activity_CanReceive);
      }
      
      protected function ItemSceneOnOver(param1:Object, param2:uint) : void
      {
         var _loc3_:TInventories = null;
         var _loc4_:Vector.<String> = null;
         _loc3_ = this.GetInventoriesByUniqueIndex(param2);
         _loc4_ = this.GetChipAwardsByUniqueIndex(param2);
         if(FOnGiftBoxMove != null)
         {
            FOnGiftBoxMove(this,_loc3_,_loc4_);
         }
      }
      
      protected function ItemSceneOnOut(param1:Object, param2:uint) : void
      {
         if(FOnGiftBoxOut != null)
         {
            FOnGiftBoxOut(this);
         }
      }
      
      protected function BtnGetOnOver(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc6_:TChip = null;
         _loc5_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_10) + "\n";
         _loc4_ = int(this.FDataEquipment.FreeDrawVect[0].Chips.length);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc5_ += this.FDataEquipment.FreeDrawVect[0].Chips[_loc3_].Name + "*" + this.FDataEquipment.FreeDrawVect[0].Amount.toString() + "\n";
            _loc3_++;
         }
         FHint.Caption = _loc5_;
         if(FOnHintOver != null)
         {
            FOnHintOver(this,FHint);
         }
      }
      
      protected function BtnGetOnOut(param1:Object, param2:MouseEvent) : void
      {
         if(FOnHintOut != null)
         {
            FOnHintOut(this,FHint);
         }
      }
   }
}

