package Processors.Game.Lobby.Organization
{
   import Components.Standard.TUIButton;
   import Foundation.Network.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Bins.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.Signals.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Utilities.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   import flash.utils.*;
   
   public class TProcessorWindowOrgDonate extends TProcessorLobbyWindow
   {
      
      protected static const KEY_COUNTER_OrgDailyDonate:Vector.<uint> = CONST_COUNTER.KEY_COUNTER_OrgDailyDonate;
      
      protected static const KEY_OrgDailyDonate:uint = CONST_COUNTER.KEY_OrgDailyDonate;
      
      protected var FMC:Sprite;
      
      protected var FTF_Exploit:TextField;
      
      protected var FTF_Money:TextField;
      
      protected var FTF_DonateMoney:TextField;
      
      protected var FTF_DonateGold:TextField;
      
      protected var FTF_Limit:TextField;
      
      protected var FBtn_DonateMoney:TUIButton;
      
      protected var FBtn_DonateGold:TUIButton;
      
      protected var FBtn_Close:SimpleButton;
      
      protected var FData_Exploit:uint;
      
      protected var FData_OrgMoney:int;
      
      protected var FData_Limit:uint;
      
      protected var FLimitMoney:uint;
      
      protected var FDonateGold:uint;
      
      protected var FDonateMoney:uint;
      
      protected var FOrgDevotionBin:TBins;
      
      public function TProcessorWindowOrgDonate(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_ORGANIZATION.RESOURCESID_Swf_OrganizationMain);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         this.FMC = TUtilityReflection.CreateDisplayObjectInstance(CONST_ORGANIZATION.RESOURCE_ClassName_MC_OrgDonate) as Sprite;
         addChild(this.FMC);
         this.FTF_Exploit = this.FMC[CONST_ORGANIZATION.RESOURCE_Link_TF_Exploit];
         this.FTF_Money = this.FMC[CONST_ORGANIZATION.RESOURCE_Link_TF_Money];
         this.FTF_DonateMoney = this.FMC[CONST_ORGANIZATION.RESOURCE_Link_TF_DonateMoney];
         this.FTF_DonateGold = this.FMC[CONST_ORGANIZATION.RESOURCE_Link_TF_DonateGold];
         this.FBtn_DonateMoney = new TUIButton();
         this.FBtn_DonateMoney.Substrate = this.FMC[CONST_ORGANIZATION.RESOURCE_Link_Btn_DonateMoney];
         this.FBtn_DonateMoney.OnClick = this.OnBtnDonateMoneyClick;
         this.FBtn_DonateGold = new TUIButton();
         this.FBtn_DonateGold.Substrate = this.FMC[CONST_ORGANIZATION.RESOURCE_Link_Btn_DonateGold];
         this.FBtn_DonateGold.OnClick = this.OnBtnDonateGoldClick;
         this.FBtn_Close = this.FMC[CONST_COMMON.RESOURCE_Link_Btn_Close];
         this.FTF_Limit = this.FMC["TF_Limit"];
         this.FTF_DonateMoney.text = "1";
         this.FTF_DonateGold.text = "1";
         this.FTF_DonateMoney.restrict = "0-9";
         this.FTF_DonateGold.restrict = "0-9";
         this.FTF_DonateMoney.addEventListener(Event.CHANGE,this.OnChangeText_Money);
         this.FTF_DonateGold.addEventListener(Event.CHANGE,this.OnChangeText_Gold);
         this.FOrgDevotionBin = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_OrganizationDevotion);
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         this.FBtn_Close.addEventListener(MouseEvent.CLICK,OnClose);
         this.FTF_DonateGold.addEventListener(Event.CHANGE,this.OnChangeText_Gold);
         this.FTF_DonateMoney.addEventListener(Event.CHANGE,this.OnChangeText_Money);
         super.ResourcesPerform_UILocations();
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         this.LogicsPerform_Signals();
      }
      
      protected function UpdateUI() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:TOrganizationDevotion = null;
         var _loc3_:uint = 0;
         _loc1_ = uint(SLogicsCore.Character.GetMainRebirthLevel());
         _loc2_ = this.FOrgDevotionBin.GetDatebaseByIndex(_loc1_ - 1) as TOrganizationDevotion;
         _loc3_ = _loc2_.DevotionSivMax;
         this.FTF_Exploit.text = String(this.FData_Exploit);
         this.FTF_Money.text = String(this.FData_OrgMoney);
         this.FLimitMoney = _loc3_ - this.FData_Limit;
         if(this.FLimitMoney <= 0)
         {
            this.FLimitMoney = 0;
         }
         this.FLimitMoney = uint(this.FLimitMoney);
         this.FTF_Limit.text = String(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ORGANIZATION_STRING_58) + this.FLimitMoney);
      }
      
      protected function PerformPacket_CS_UpdateCounterReq() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Vector.<uint> = null;
         var _loc3_:int = 0;
         _loc1_ = int(KEY_COUNTER_OrgDailyDonate.length);
         _loc2_ = new Vector.<uint>(_loc1_);
         _loc3_ = 0;
         while(_loc3_ < _loc1_)
         {
            _loc2_[_loc3_] = KEY_COUNTER_OrgDailyDonate[_loc3_];
            SLogicsCore.SignalPost(CONST_SIGNAL.SIGNALDESTINATION_COUNTER_OrgDailyDonate_Req,0,0,_loc2_);
            _loc3_++;
         }
      }
      
      protected function LogicsPerform_Signals() : void
      {
         var _loc1_:TSignal = null;
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         _loc1_ = SLogicsCore.SignalRetrieve(CONST_SIGNAL.SIGNALDESTINATION_COUNTER_OrgDailyDonate_Ret);
         if(_loc1_ == null)
         {
            return;
         }
         _loc2_ = _loc1_.Identifier;
         _loc3_ = uint(_loc1_.Value);
         switch(_loc2_)
         {
            case KEY_OrgDailyDonate:
               this.FData_Limit = _loc3_;
               this.UpdateUI();
         }
      }
      
      protected function OnBtnDonateMoneyClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TPacket = null;
         var _loc4_:ByteArray = null;
         this.FDonateMoney = uint(this.FTF_DonateMoney.text);
         if(this.FDonateMoney * 1000 > SLogicsCore.Character.CreditSilverCoin.ToNumber())
         {
            FOnEffectText(this,TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ORGANIZATION_STRING_60));
            return;
         }
         _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Organization_DonateReq);
         _loc4_ = _loc3_.Data;
         _loc4_.writeUnsignedInt(0);
         _loc4_.writeUnsignedInt(this.FDonateMoney);
         SNetworkCore.Transceiver.PacketTransmit(_loc3_);
         this.OnChangeText_Money(this);
      }
      
      protected function OnBtnDonateGoldClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TPacket = null;
         var _loc4_:ByteArray = null;
         this.FDonateGold = uint(this.FTF_DonateGold.text);
         if(this.FDonateGold > SLogicsCore.Character.CreditGold)
         {
            FOnEffectText(this,TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ORGANIZATION_STRING_59));
            return;
         }
         _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Organization_DonateReq);
         _loc4_ = _loc3_.Data;
         _loc4_.writeUnsignedInt(this.FDonateGold);
         _loc4_.writeUnsignedInt(0);
         SNetworkCore.Transceiver.PacketTransmit(_loc3_);
         this.OnChangeText_Gold(this);
      }
      
      protected function OnChangeText_Gold(param1:Object) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         _loc3_ = uint(this.FTF_DonateGold.text);
         _loc2_ = uint(SLogicsCore.Character.CreditGold);
         if(_loc3_ > _loc2_)
         {
            if(_loc2_ <= 0)
            {
               this.FTF_DonateGold.text = "1";
            }
            else
            {
               this.FTF_DonateGold.text = _loc2_.toString();
            }
         }
         if(_loc3_ <= 0)
         {
            this.FTF_DonateGold.text = "1";
         }
         this.FDonateGold = uint(this.FTF_DonateGold.text);
      }
      
      protected function OnChangeText_Money(param1:Object) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         _loc2_ = uint(this.FTF_DonateMoney.text);
         this.FTF_DonateMoney.text = _loc2_.toString();
         _loc3_ = _loc2_ * 1000;
         _loc4_ = Math.min(this.FLimitMoney,SLogicsCore.Character.CreditSilverCoin.ToNumber());
         if(_loc3_ > _loc4_)
         {
            if(_loc4_ <= 0)
            {
               this.FTF_DonateMoney.text = "1";
            }
            else
            {
               this.FTF_DonateMoney.text = String(Math.floor(_loc4_ / 1000));
            }
         }
         if(_loc3_ <= 0)
         {
            this.FTF_DonateMoney.text = "1";
         }
         if(uint(this.FTF_DonateMoney.text) <= 0)
         {
            this.FTF_DonateMoney.text = "1";
         }
         this.FDonateMoney = uint(this.FTF_DonateGold.text);
      }
      
      public function UpData(param1:uint, param2:int) : void
      {
         this.PerformPacket_CS_UpdateCounterReq();
         this.FData_Exploit = param1;
         this.FData_OrgMoney = param2;
      }
      
      public function UpDateUI() : void
      {
         this.UpdateUI();
      }
   }
}

