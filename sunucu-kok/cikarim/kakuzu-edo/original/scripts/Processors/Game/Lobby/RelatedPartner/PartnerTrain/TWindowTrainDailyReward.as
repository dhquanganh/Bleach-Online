package Processors.Game.Lobby.RelatedPartner.PartnerTrain
{
   import Components.Slots.TUISlot;
   import Components.Standard.TUIButton;
   import Foundation.Common.THint;
   import Foundation.Network.SNetworkCore;
   import Foundation.Network.TPacket;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityString;
   import Logics.BleachAgent.TBleachAgentData;
   import Logics.DatebaseVO.VO.*;
   import Logics.Inventories.TInventories;
   import Logics.Inventories.TInventory;
   import Logics.SLogicsCore;
   import Logics.Streamization.RelatedPartner.VO.TPartnerTrainHeroPointVO;
   import Processors.Game.Lobby.Jade.TJadeCommon;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Resources.Constants.*;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.utils.ByteArray;
   
   public class TWindowTrainDailyReward extends TWindowTrainBase
   {
      
      protected static const Daily_Num:int = CONST_RELATEDPARTNER.PartnerTrain_DailyReward_Num;
      
      protected var FBtnRewardView:TUIButton;
      
      protected var FBtnFree:TUIButton;
      
      protected var FBtnGold:TUIButton;
      
      protected var FTFFreeCount:TextField;
      
      protected var FTFGoldCount:TextField;
      
      protected var FTFDesc:TextField;
      
      protected var FHeroInfo:TPartnerTrainHeroPointVO;
      
      protected var FConfigValue:TConfigValue;
      
      protected var FVipConfig:TVipConfig;
      
      protected var FSlot:TUISlot;
      
      protected var FFreeCount:int;
      
      protected var FGoldCount:int;
      
      protected var FRewardTip:TItemTrainDailyTip;
      
      protected var FCurRewardIndex:int;
      
      protected var FHint:THint;
      
      protected var FGoldCost:int;
      
      protected var FBAData:TBleachAgentData;
      
      public function TWindowTrainDailyReward(param1:TUIComponent, param2:Sprite)
      {
         super(param1,param2);
         this.FBtnRewardView = new TUIButton();
         this.FBtnRewardView.Substrate = FMainUI["Btn_View"];
         this.FBtnRewardView.OnMove = this.BtnOnMove;
         this.FBtnRewardView.OnOut = this.BtnOnOut;
         this.FBtnFree = new TUIButton();
         this.FBtnFree.Substrate = FMainUI["Btn_Free"];
         this.FBtnFree.OnClick = this.BtnOnClick;
         this.FBtnGold = new TUIButton();
         this.FBtnGold.Substrate = FMainUI["Btn_Gold"];
         this.FBtnGold.OnClick = this.BtnOnClick;
         this.FBtnGold.OnMove = this.BtnOnMove;
         this.FBtnGold.OnOut = this.BtnOnOut;
         this.FTFFreeCount = FMainUI["TF_FreeCount"];
         this.FTFGoldCount = FMainUI["TF_GoldCount"];
         this.FTFDesc = FMainUI["TF_Reward"];
         this.FSlot = new TUISlot(this);
         this.FSlot.Resource = FMainUI["MC_Slot"];
         this.FSlot.OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FSlot.OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
         TJadeCommon.InitSlot(this.FSlot);
         this.FSlot.Init();
         this.FHint = new THint();
         this.FRewardTip = new TItemTrainDailyTip(FMainUI["MC_DailyTip"]);
         this.FRewardTip.Visible = false;
         this.FConfigValue = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.Related_AwardNum) as TConfigValue;
         this.FVipConfig = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_VipConfig,SLogicsCore.Character.VipLevel) as TVipConfig;
         this.FBAData = SLogicsCore.BleachAgentData;
      }
      
      protected function ReqGoldReward(param1:Object) : void
      {
         var _loc2_:TPacket = null;
         var _loc3_:ByteArray = null;
         var _loc4_:int = 0;
         if(param1 is int)
         {
            _loc4_ = CONST_RELATEDPARTNER.PartnerTrain_Type_Free;
         }
         else
         {
            _loc4_ = CONST_RELATEDPARTNER.PartnerTrain_Type_Gold;
         }
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Related_DailyTrainReq);
         _loc3_ = _loc2_.Data;
         _loc3_.writeUnsignedInt(_loc4_);
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
      }
      
      protected function BtnOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TUIButton = null;
         var _loc4_:int = 0;
         _loc3_ = param1 as TUIButton;
         switch(_loc3_)
         {
            case this.FBtnFree:
               _loc4_ = CONST_RELATEDPARTNER.PartnerTrain_Type_Free;
               this.ReqGoldReward(_loc4_);
               break;
            case this.FBtnGold:
               _loc4_ = CONST_RELATEDPARTNER.PartnerTrain_Type_Gold;
               if(this.FBAData.GetWelfareCountByType(this.FBAData.WelfareType_RelatedPartnerFreeCount) > 0)
               {
                  this.ReqGoldReward(null);
                  return;
               }
               if(SLogicsCore.Character.CreditGold < this.FGoldCost)
               {
                  SUtilityOverLayer.UIWindowRecharge.SetGoldNum(this.FGoldCost);
                  SUtilityOverLayer.UIWindowRecharge.Visible = true;
                  return;
               }
               SUtilityOverLayer.UIWindowConfirmation.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.SuperMarket_STRING_02),this.FGoldCost);
               SUtilityOverLayer.UIWindowConfirmation.OnOK = this.ReqGoldReward;
               SUtilityOverLayer.UIWindowConfirmation.Visible = true;
         }
      }
      
      protected function BtnOnMove(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TUIButton = null;
         _loc3_ = param1 as TUIButton;
         switch(_loc3_)
         {
            case this.FBtnGold:
               if(this.FHint.Caption != "")
               {
                  SUtilityOverLayer.UIComponentsHintOnOver(FParent,this.FHint);
               }
               break;
            case this.FBtnRewardView:
               this.FRewardTip.Visible = true;
         }
      }
      
      protected function BtnOnOut(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TUIButton = null;
         _loc3_ = param1 as TUIButton;
         switch(_loc3_)
         {
            case this.FBtnGold:
               SUtilityOverLayer.UIComponentsHintOnOut(FParent,this.FHint);
               break;
            case this.FBtnRewardView:
               this.FRewardTip.Visible = false;
         }
      }
      
      public function SetHeroInfo(param1:TPartnerTrainHeroPointVO) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TArticle = null;
         var _loc5_:TConfigValue = null;
         var _loc6_:TInventories = null;
         var _loc7_:TInventory = null;
         var _loc8_:int = 0;
         var _loc9_:Vector.<int> = null;
         var _loc10_:Boolean = false;
         var _loc11_:Vector.<int> = null;
         var _loc12_:Vector.<int> = null;
         this.FHeroInfo = param1;
         _loc5_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.Related_DailyItemId) as TConfigValue;
         _loc4_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_Article,int(_loc5_.Value)) as TArticle;
         this.FTFDesc.text = _loc4_.Name;
         _loc6_ = new TInventories();
         SToolReward.GetInventoryByID(_loc4_.Identifier,_loc6_);
         _loc7_ = _loc6_.GetInventoryByTempletID(_loc4_.Identifier);
         _loc8_ = this.FHeroInfo.GetStarCount();
         this.FCurRewardIndex = 0;
         _loc5_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.Related_DailyStarNum) as TConfigValue;
         _loc12_ = Vector.<int>(_loc5_.Value);
         _loc5_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.Related_DailyItemNum) as TConfigValue;
         _loc11_ = Vector.<int>(_loc5_.Value);
         _loc3_ = int(_loc11_.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(_loc8_ >= _loc12_[_loc2_])
            {
               this.FCurRewardIndex = _loc2_;
            }
            _loc2_++;
         }
         if(_loc8_ > 0)
         {
            this.FFreeCount = int(this.FConfigValue.Value) - this.FHeroInfo.FreeCount;
            this.FGoldCount = this.FVipConfig.RelatedDailyAward - this.FHeroInfo.GoldCount;
         }
         else
         {
            this.FFreeCount = 0;
            this.FGoldCount = 0;
         }
         this.FTFFreeCount.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_Related_03),this.FFreeCount);
         this.FTFGoldCount.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_Related_03),this.FGoldCount);
         _loc7_.Quantity = _loc11_[this.FCurRewardIndex];
         this.FSlot.Context = _loc7_;
         _loc5_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.Related_Train_Gold) as TConfigValue;
         _loc9_ = Vector.<int>(_loc5_.Value);
         if(this.FHeroInfo.GoldCount < _loc9_.length)
         {
            this.FGoldCost = _loc9_[this.FHeroInfo.GoldCount];
            if(this.FBAData.GetWelfareCountByType(this.FBAData.WelfareType_RelatedPartnerFreeCount) > 0)
            {
               this.FHint.Caption = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_BleachAgent_06);
            }
            else
            {
               this.FHint.Caption = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.SHORTCUTS_STRING_02),this.FGoldCost);
            }
         }
         else
         {
            this.FHint.Caption = "";
         }
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FRewardTip.Levels[_loc2_] = _loc12_[_loc2_];
            this.FRewardTip.AwardNames[_loc2_] = _loc4_.Name + " × " + _loc11_[_loc2_];
            _loc2_++;
         }
         this.FRewardTip.Render();
         _loc10_ = this.FRewardTip.Levels.length > 0 && _loc8_ >= this.FRewardTip.Levels[0];
         this.FBtnFree.Enabled = this.FFreeCount > 0 && _loc10_;
         this.FBtnGold.Enabled = this.FGoldCount > 0 && _loc10_;
      }
      
      public function Update() : void
      {
         this.FSlot.Update();
      }
   }
}

