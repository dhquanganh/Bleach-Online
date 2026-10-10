package Processors.Game.Lobby.NightmareTrial.Windows
{
   import Components.Slots.TUISlot;
   import Components.Standard.TUIButton;
   import Foundation.Common.THint;
   import Foundation.Network.SNetworkCore;
   import Foundation.Network.TPacket;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityString;
   import Logics.NightmareTrial.TNightmareTrialData;
   import Logics.NightmareTrial.VO.TNightmareTrialLevelVo;
   import Processors.Game.Lobby.Jade.TJadeCommon;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.Common.SUtilityResource;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Resources.Constants.CONST_NETWORK;
   import Resources.Constants.CONST_NIGHTMARETRIAL;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class TSelectInfoView extends TUIComponent
   {
      
      public static const SlotCount:uint = 4;
      
      private var FMC_Scene:Sprite;
      
      private var FTitleTF:TextField;
      
      private var FNameTF:TextField;
      
      private var FDescTF:TextField;
      
      private var FSlotVec:Vector.<Vector.<TUISlot>>;
      
      private var FNormalSlotVec:Vector.<TUISlot>;
      
      private var FHardSlotVec:Vector.<TUISlot>;
      
      private var FNightmareSlotVec:Vector.<TUISlot>;
      
      private var FDeadSlotVec:Vector.<TUISlot>;
      
      private var FScanResetTF:TextField;
      
      private var FResetBtn:TUIButton;
      
      private var FNormalBtn:TUIButton;
      
      private var FHardBtn:TUIButton;
      
      private var FNightmareBtn:TUIButton;
      
      private var FDeadBtn:TUIButton;
      
      private var FBtnTypeVec:Vector.<TUIButton>;
      
      private var FHint:THint;
      
      private var FNightmareTrialLevelVo:TNightmareTrialLevelVo;
      
      private var FBackSp:Sprite;
      
      private var FCloseBtn:TUIButton;
      
      private var FData:TNightmareTrialData;
      
      private var FOpenMapInfoFun:Function;
      
      public function TSelectInfoView(param1:TUIComponent, param2:Sprite)
      {
         super(param1);
         this.FMC_Scene = param2;
         this.addChild(this.FMC_Scene);
         this.Visible = false;
         this.InitWindow();
      }
      
      protected function InitWindow() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Sprite = null;
         var _loc4_:TUISlot = null;
         this.FTitleTF = this.FMC_Scene["TF_Title"];
         this.FNameTF = this.FMC_Scene["TF_Name"];
         this.FDescTF = this.FMC_Scene["TF_Desc"];
         this.FNormalSlotVec = new Vector.<TUISlot>();
         this.FHardSlotVec = new Vector.<TUISlot>();
         this.FNightmareSlotVec = new Vector.<TUISlot>();
         this.FDeadSlotVec = new Vector.<TUISlot>();
         this.FSlotVec = new Vector.<Vector.<TUISlot>>();
         _loc2_ = int(SlotCount);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FMC_Scene["MC_Normal"];
            _loc4_ = new TUISlot(this);
            _loc4_.Resource = _loc3_["MC_Slot" + _loc1_];
            _loc4_.OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
            _loc4_.OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
            TJadeCommon.InitSlot(_loc4_);
            _loc4_.Init();
            this.FNormalSlotVec[_loc1_] = _loc4_;
            _loc3_ = this.FMC_Scene["MC_Hard"];
            _loc4_ = new TUISlot(this);
            _loc4_.Resource = _loc3_["MC_Slot" + _loc1_];
            _loc4_.OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
            _loc4_.OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
            TJadeCommon.InitSlot(_loc4_);
            _loc4_.Init();
            this.FHardSlotVec[_loc1_] = _loc4_;
            _loc3_ = this.FMC_Scene["MC_Nightmare"];
            _loc4_ = new TUISlot(this);
            _loc4_.Resource = _loc3_["MC_Slot" + _loc1_];
            _loc4_.OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
            _loc4_.OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
            TJadeCommon.InitSlot(_loc4_);
            _loc4_.Init();
            this.FNightmareSlotVec[_loc1_] = _loc4_;
            _loc3_ = this.FMC_Scene["MC_Dead"];
            _loc4_ = new TUISlot(this);
            _loc4_.Resource = _loc3_["MC_Slot" + _loc1_];
            _loc4_.OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
            _loc4_.OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
            TJadeCommon.InitSlot(_loc4_);
            _loc4_.Init();
            this.FDeadSlotVec[_loc1_] = _loc4_;
            _loc1_++;
         }
         this.FSlotVec.push(this.FNormalSlotVec);
         this.FSlotVec.push(this.FHardSlotVec);
         this.FSlotVec.push(this.FNightmareSlotVec);
         this.FSlotVec.push(this.FDeadSlotVec);
         this.FBtnTypeVec = new Vector.<TUIButton>();
         this.FScanResetTF = this.FMC_Scene["TF_Reset"];
         this.FResetBtn = new TUIButton();
         this.FResetBtn.Substrate = this.FMC_Scene["Btn_Reset"];
         this.FResetBtn.OnMove = this.OnResetOverTips;
         this.FResetBtn.OnOut = this.OnResetOutTips;
         this.FResetBtn.OnClick = this.OnReset;
         this.FCloseBtn = new TUIButton();
         this.FCloseBtn.Substrate = this.FMC_Scene["Btn_Close"];
         this.FCloseBtn.OnClick = this.OnCloseSelectView;
         this.FNormalBtn = new TUIButton();
         this.FNormalBtn.Substrate = this.FMC_Scene["BtnNormal"];
         this.FNormalBtn.OnClick = this.OnSelectNormal;
         this.FBtnTypeVec.push(this.FNormalBtn);
         this.FHardBtn = new TUIButton();
         this.FHardBtn.Substrate = this.FMC_Scene["BtnHard"];
         this.FHardBtn.OnClick = this.OnSelectHard;
         this.FHardBtn.OnMove = this.OnSelectOverTips;
         this.FHardBtn.OnOut = this.OnResetOutTips;
         this.FBtnTypeVec.push(this.FHardBtn);
         this.FNightmareBtn = new TUIButton();
         this.FNightmareBtn.Substrate = this.FMC_Scene["Btn_Nightmare"];
         this.FNightmareBtn.OnClick = this.OnSelectNightmare;
         this.FNightmareBtn.OnMove = this.OnSelectOverTips;
         this.FNightmareBtn.OnOut = this.OnResetOutTips;
         this.FBtnTypeVec.push(this.FNightmareBtn);
         this.FDeadBtn = new TUIButton();
         this.FDeadBtn.Substrate = this.FMC_Scene["BtnDead"];
         this.FDeadBtn.OnClick = this.OnSelectDead;
         this.FDeadBtn.OnMove = this.OnSelectOverTips;
         this.FDeadBtn.OnOut = this.OnResetOutTips;
         this.FBtnTypeVec.push(this.FDeadBtn);
         this.FHint = new THint();
         this.FBackSp = new Sprite();
         this.FBackSp.addChild(new Bitmap(SUtilityResource.BtmDataFullScreen));
         this.FBackSp.x = -FParent.X;
         this.FBackSp.y = -FParent.Y;
         this.addChildAt(this.FBackSp,0);
      }
      
      private function UpdateUI() : void
      {
         this.RefreshSlotInfo();
         this.RefreshBaseInfo();
      }
      
      private function RefreshSlotInfo() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:TUISlot = null;
         _loc2_ = int(SlotCount);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc4_ = int(this.FNightmareTrialLevelVo.SelectInfoVo.Inventories[_loc1_].length);
            _loc3_ = 0;
            while(_loc3_ < _loc4_)
            {
               _loc5_ = this.FSlotVec[_loc1_][_loc3_];
               _loc5_.Context = null;
               _loc5_.Context = this.FNightmareTrialLevelVo.SelectInfoVo.Inventories[_loc1_][_loc3_].GetInventoryByIndex(0);
               _loc3_++;
            }
            _loc1_++;
         }
      }
      
      private function RefreshBaseInfo() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         this.FScanResetTF.text = this.FNightmareTrialLevelVo.SelectInfoVo.ResetTimes.toString();
         this.FResetBtn.Enabled = this.FNightmareTrialLevelVo.SelectInfoVo.ResetTimes > 0;
         if(this.FNightmareTrialLevelVo.SelectInfoVo.CurrentCityId == 0)
         {
            this.SetBtnState(false);
            _loc2_ = int(this.FNightmareTrialLevelVo.CityDifficultyIdVec.length);
            _loc3_ = this.FNightmareTrialLevelVo.CityDifficultyIdVec.indexOf(this.FNightmareTrialLevelVo.SelectInfoVo.HistoryCityId) + 1;
            _loc1_ = 0;
            while(_loc1_ < _loc2_)
            {
               if(_loc1_ <= _loc3_)
               {
                  this.FBtnTypeVec[_loc1_].Enabled = true;
               }
               _loc1_++;
            }
         }
         else
         {
            this.SetBtnState(false);
            _loc2_ = int(this.FNightmareTrialLevelVo.CityDifficultyIdVec.length);
            _loc1_ = 0;
            while(_loc1_ < _loc2_)
            {
               if(this.FNightmareTrialLevelVo.CityDifficultyIdVec[_loc1_] == this.FNightmareTrialLevelVo.SelectInfoVo.CurrentCityId)
               {
                  this.FBtnTypeVec[_loc1_].Enabled = true;
                  break;
               }
               _loc1_++;
            }
         }
         this.FNameTF.text = this.FNightmareTrialLevelVo.Name;
         this.FDescTF.text = this.FNightmareTrialLevelVo.TxtWordDesc;
         this.FTitleTF.text = this.FNightmareTrialLevelVo.TitleName;
      }
      
      private function SetBtnState(param1:Boolean) : void
      {
         this.FNormalBtn.Enabled = param1;
         this.FHardBtn.Enabled = param1;
         this.FNightmareBtn.Enabled = param1;
         this.FDeadBtn.Enabled = param1;
      }
      
      private function UpdateExtractSlots() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _loc2_ = int(SlotCount);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc4_ = int(SlotCount);
            _loc3_ = 0;
            while(_loc3_ < _loc4_)
            {
               this.FSlotVec[_loc1_][_loc3_].Update();
               _loc3_++;
            }
            _loc1_++;
         }
      }
      
      protected function UIWindowConfirmationOnOK(param1:Object) : void
      {
         var _loc2_:TPacket = null;
         var _loc3_:int = 0;
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PacketPerform_CS_NightmareTrial_ResetReq);
         _loc3_ = this.FNightmareTrialLevelVo.Id;
         _loc2_.Data.writeUnsignedInt(_loc3_);
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
      }
      
      protected function OnReset(param1:Object, param2:MouseEvent) : void
      {
         SUtilityOverLayer.UIWindowConfirmation.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_NIGHTMARETRIAL.SYSTEMLANGUAGE_RESETInfoID),this.FNightmareTrialLevelVo.SelectInfoVo.ResetGold);
         SUtilityOverLayer.UIWindowConfirmation.Visible = true;
         SUtilityOverLayer.UIWindowConfirmation.OnOK = this.UIWindowConfirmationOnOK;
      }
      
      protected function OnCloseSelectView(param1:Object, param2:MouseEvent) : void
      {
         this.Visible = false;
      }
      
      protected function OnSelectNormal(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         _loc3_ = this.FBtnTypeVec.indexOf(param1 as TUIButton);
         this.OpenMapPointView(_loc3_);
      }
      
      protected function OnSelectHard(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         _loc3_ = this.FBtnTypeVec.indexOf(param1 as TUIButton);
         this.OpenMapPointView(_loc3_);
      }
      
      protected function OnSelectNightmare(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         _loc3_ = this.FBtnTypeVec.indexOf(param1 as TUIButton);
         this.OpenMapPointView(_loc3_);
      }
      
      protected function OnSelectDead(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         _loc3_ = this.FBtnTypeVec.indexOf(param1 as TUIButton);
         this.OpenMapPointView(_loc3_);
      }
      
      private function OpenMapPointView(param1:int) : void
      {
         if(this.FNightmareTrialLevelVo.SelectInfoVo.CurrentCityId == 0)
         {
            SUtilityOverLayer.UIWindowConfirmation.Text = TUtilityLobby.GetStringByIdentifier(CONST_NIGHTMARETRIAL.SYSTEMLANGUAGE_SelectCity_TIPSID);
            SUtilityOverLayer.UIWindowConfirmation.Visible = true;
            SUtilityOverLayer.UIWindowConfirmation.Tag = param1;
            SUtilityOverLayer.UIWindowConfirmation.OnOK = this.ConfirmPromptOK;
         }
         else if(this.FOpenMapInfoFun != null)
         {
            this.FOpenMapInfoFun(this.FNightmareTrialLevelVo.Id,this.FNightmareTrialLevelVo.CityDifficultyIdVec[param1]);
         }
      }
      
      protected function OnResetOverTips(param1:Object, param2:MouseEvent) : void
      {
         if(this.FNightmareTrialLevelVo.SelectInfoVo.ResetTimes == 0)
         {
            this.FHint.Caption = "";
         }
         else
         {
            this.FHint.Caption = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_NIGHTMARETRIAL.SYSTEMLANGUAGE_RESET_TIPSID),this.FNightmareTrialLevelVo.SelectInfoVo.ResetGold);
         }
         SUtilityOverLayer.UIComponentsHintOnOver(this,this.FHint);
      }
      
      protected function OnSelectOverTips(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         _loc3_ = this.FBtnTypeVec.indexOf(param1 as TUIButton);
         if(this.FBtnTypeVec[_loc3_].Enabled)
         {
            this.FHint.Caption = "";
         }
         else
         {
            this.FHint.Caption = TUtilityLobby.GetStringByIdentifier(CONST_NIGHTMARETRIAL.SelectLevelVec[_loc3_]);
         }
         SUtilityOverLayer.UIComponentsHintOnOver(this,this.FHint);
      }
      
      protected function OnResetOutTips(param1:Object, param2:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOut(this,this.FHint);
      }
      
      private function ConfirmPromptOK(param1:Object) : void
      {
         var _loc2_:TPacket = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _loc3_ = this.FNightmareTrialLevelVo.Id;
         _loc4_ = this.FNightmareTrialLevelVo.CityDifficultyIdVec[SUtilityOverLayer.UIWindowConfirmation.Tag];
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PacketPerform_CS_NightmareTrial_CitySelectReq);
         _loc2_.Data.writeUnsignedInt(_loc3_);
         _loc2_.Data.writeUnsignedInt(_loc4_);
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
      }
      
      public function set Data(param1:TNightmareTrialData) : void
      {
         this.FData = param1;
      }
      
      public function get Data() : TNightmareTrialData
      {
         return this.FData;
      }
      
      public function set OpenMapInfoFun(param1:Function) : void
      {
         this.FOpenMapInfoFun = param1;
      }
      
      public function get OpenMapInfoFun() : Function
      {
         return this.FOpenMapInfoFun;
      }
      
      public function ShowView(param1:int) : void
      {
         this.Visible = true;
         this.FNightmareTrialLevelVo = this.FData.NightmareTrialLevelVec[param1];
         this.UpdateUI();
      }
      
      public function LogicsPerform_EnterFrame() : void
      {
         if(this.Visible)
         {
            this.UpdateExtractSlots();
         }
      }
   }
}

