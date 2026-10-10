package Processors.Game.Lobby.NightmareTrial.Windows
{
   import Components.Slots.TUISlot;
   import Components.Standard.TUIButton;
   import Foundation.Common.THint;
   import Foundation.Network.SNetworkCore;
   import Foundation.Network.TPacket;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Foundation.Utilities.TUtilityString;
   import Logics.BleachAgent.TBleachAgentData;
   import Logics.DatebaseVO.VO.TConfigValue;
   import Logics.Inventories.TInventories;
   import Logics.NightmareTrial.TNightmareTrialData;
   import Logics.NightmareTrial.VO.TNightmareTrialLevelVo;
   import Logics.SLogicsCore;
   import Processors.Game.Lobby.Jade.TJadeCommon;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Resources.Constants.CONST_DATEBASEVO;
   import Resources.Constants.CONST_NETWORK;
   import Resources.Constants.CONST_NIGHTMARETRIAL;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class TProcessorNightmareMapAward extends TUIComponent
   {
      
      public static const SlotNum:int = 4;
      
      private var FMainUI:Sprite;
      
      private var FInitBol:Boolean;
      
      private var FSlotAwardVec:Vector.<TUISlot>;
      
      private var FDropOutVec:Vector.<TUISlot>;
      
      private var FOnekeyBtn:TUIButton;
      
      private var FID:uint;
      
      private var FNightmareTrialLevelVo:TNightmareTrialLevelVo;
      
      private var FConfigValue:TConfigValue;
      
      private var FHint:THint;
      
      protected var FBleachAgentData:TBleachAgentData;
      
      protected var FData:TNightmareTrialData;
      
      public function TProcessorNightmareMapAward(param1:TUIComponent)
      {
         super(param1);
         this.FBleachAgentData = SLogicsCore.BleachAgentData;
      }
      
      public function UIDispatch() : void
      {
         var _loc1_:int = 0;
         if(this.FInitBol)
         {
            return;
         }
         this.FHint = new THint();
         this.FMainUI = TUtilityReflection.CreateDisplayObjectInstance("NightmarePassAward") as Sprite;
         addChild(this.FMainUI);
         this.FOnekeyBtn = new TUIButton();
         this.FOnekeyBtn.Substrate = this.FMainUI["Btn_OneKey"];
         this.FOnekeyBtn.OnClick = this.OnOnekeyClickFun;
         this.FOnekeyBtn.OnMove = this.OnSelectOverTips;
         this.FOnekeyBtn.OnOut = this.OnResetOutTips;
         this.FSlotAwardVec = new Vector.<TUISlot>();
         this.FDropOutVec = new Vector.<TUISlot>();
         this.CreateAwardSlot();
         this.CreateDropOutSlot();
         this.FInitBol = true;
      }
      
      private function CreateAwardSlot() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TUISlot = null;
         _loc2_ = SlotNum;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = new TUISlot(this);
            _loc3_.Resource = this.FMainUI["MC_Award" + _loc1_];
            _loc3_.OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
            _loc3_.OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
            TJadeCommon.InitSlot(_loc3_);
            _loc3_.Init();
            this.FSlotAwardVec[_loc1_] = _loc3_;
            _loc1_++;
         }
      }
      
      private function CreateDropOutSlot() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TUISlot = null;
         _loc2_ = SlotNum;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = new TUISlot(this);
            _loc3_.Resource = this.FMainUI["MC_DropOut" + _loc1_];
            _loc3_.OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
            _loc3_.OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
            TJadeCommon.InitSlot(_loc3_);
            _loc3_.Init();
            this.FDropOutVec[_loc1_] = _loc3_;
            _loc1_++;
         }
      }
      
      private function UpdateExtractSlots(param1:Vector.<TUISlot>) : void
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
      
      private function UpdateAward(param1:Vector.<TInventories>) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TUISlot = null;
         _loc3_ = int(param1.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = this.FSlotAwardVec[_loc2_];
            _loc4_.Context = null;
            _loc4_.Context = param1[_loc2_].GetInventoryByIndex(0);
            _loc2_++;
         }
      }
      
      private function UpdateDropOut(param1:Vector.<TInventories>) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TUISlot = null;
         _loc3_ = int(param1.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = this.FDropOutVec[_loc2_];
            _loc4_.Context = null;
            _loc4_.Context = param1[_loc2_].GetInventoryByIndex(0);
            _loc2_++;
         }
      }
      
      private function OnOnekeyClickFun(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:TPacket = null;
         var _loc5_:int = 0;
         var _loc6_:String = null;
         if(this.FConfigValue == null)
         {
            this.FConfigValue = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_NIGHTMARETRIAL.PointOneKeyLimit) as TConfigValue;
         }
         if(this.FNightmareTrialLevelVo.SelectInfoVo.PassAmount >= this.FConfigValue.Value)
         {
            _loc6_ = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_NIGHTMARETRIAL.NightmareTrial_OneKeyEventTip),this.FConfigValue.Value);
            SToolReward.ShowMessage(_loc6_);
            return;
         }
         _loc4_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PacketPerform_CS_NightmareTrial_OneKeyReq);
         _loc5_ = int(this.FID);
         _loc4_.Data.writeUnsignedInt(_loc5_);
         SNetworkCore.Transceiver.PacketTransmit(_loc4_);
      }
      
      protected function OnSelectOverTips(param1:Object, param2:MouseEvent) : void
      {
         if(this.FOnekeyBtn.Enabled)
         {
            this.FHint.Caption = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_NIGHTMARETRIAL.NightmareTrial_OneKeyNormalTip),this.FBleachAgentData.GetWelfareCountByType(this.FBleachAgentData.WelfareType_NightmareTrialRaidCount));
         }
         else
         {
            this.FHint.Caption = TUtilityLobby.GetStringByIdentifier(CONST_NIGHTMARETRIAL.NightmareTrial_OneKeyDisableTip);
         }
         SUtilityOverLayer.UIComponentsHintOnOver(this,this.FHint);
      }
      
      protected function OnResetOutTips(param1:Object, param2:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOut(this,this.FHint);
      }
      
      public function set Data(param1:TNightmareTrialData) : void
      {
         this.FData = param1;
      }
      
      public function get Data() : TNightmareTrialData
      {
         return this.FData;
      }
      
      public function LogicsPerform() : void
      {
         if(Visible)
         {
            this.UpdateExtractSlots(this.FDropOutVec);
            this.UpdateExtractSlots(this.FSlotAwardVec);
            this.UpdateOnekeyState();
         }
      }
      
      public function UpdateUI(param1:int, param2:int) : void
      {
         var _loc3_:TNightmareTrialLevelVo = null;
         var _loc4_:int = 0;
         this.FID = param1;
         _loc3_ = this.FData.GetNightmareTrialLevelVo(param1);
         _loc4_ = _loc3_.CityDifficultyIdVec.indexOf(param2);
         this.UpdateDropOut(_loc3_.SelectInfoVo.Inventories[_loc4_]);
         this.UpdateAward(_loc3_.SelectInfoVo.PassLevelInventories[_loc4_]);
         this.SetOneKeyState(param1,param2);
      }
      
      private function SetOneKeyState(param1:int, param2:int) : void
      {
         var _loc3_:TNightmareTrialLevelVo = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         _loc3_ = this.FData.GetNightmareTrialLevelVo(param1);
         this.FNightmareTrialLevelVo = _loc3_;
         if(_loc3_.SelectInfoVo.HistoryCityId == 0)
         {
            this.FOnekeyBtn.Enabled = false;
         }
         else
         {
            _loc5_ = _loc3_.CityDifficultyIdVec.indexOf(param2);
            _loc4_ = _loc3_.CityDifficultyIdVec.indexOf(_loc3_.SelectInfoVo.HistoryCityId);
            if(_loc4_ >= _loc5_)
            {
               this.FOnekeyBtn.Enabled = true;
            }
            else
            {
               this.FOnekeyBtn.Enabled = false;
            }
         }
         if(this.FOnekeyBtn.Enabled)
         {
            if(this.FBleachAgentData.GetWelfareCountByType(this.FBleachAgentData.WelfareType_NightmareTrialRaidCount) <= 0)
            {
               this.FOnekeyBtn.Enabled = false;
            }
         }
      }
      
      private function UpdateOnekeyState() : void
      {
      }
   }
}

