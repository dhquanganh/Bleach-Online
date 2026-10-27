package Processors.Game.Lobby.GongFuFightWindow
{
   import Components.Standard.TUIButton;
   import Foundation.Network.SNetworkCore;
   import Foundation.Network.TPacket;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Foundation.Utilities.TUtilityString;
   import Logics.GongFuFight.TGongFuFightData;
   import Logics.GongFuFight.TGongFuFightPay;
   import Logics.GongFuFight.TGongFuFightPayRecord;
   import Logics.Inventories.TInventories;
   import Logics.Inventories.TInventory;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Resources.Constants.CONST_COMMON;
   import Resources.Constants.CONST_NETWORK;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class TWindowPay extends TProcessorLobbyWindow
   {
      
      protected static const TypeNum:int = 3;
      
      protected static const AwardDescription:String = "%0 * %1\n";
      
      protected static const RecordDescription:String = "%0 * %1  ";
      
      protected var FMainScene:Sprite;
      
      protected var FNameVec:Vector.<TextField>;
      
      protected var FAwardDesVec:Vector.<TextField>;
      
      protected var FTFCostVec:Vector.<TextField>;
      
      protected var FMCCostFlag:Vector.<MovieClip>;
      
      protected var FMCPayFlag:Vector.<Sprite>;
      
      protected var FBtnPayVec:Vector.<TUIButton>;
      
      protected var FTFPayRecord:TextField;
      
      protected var FPendantLeft:MovieClip;
      
      protected var FPendantRight:MovieClip;
      
      protected var FBtnClose:TUIButton;
      
      protected var FPayTypeName:Vector.<String>;
      
      protected var FGongFuFightData:TGongFuFightData;
      
      public function TWindowPay(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Sprite = null;
         var _loc3_:TUIButton = null;
         this.FMainScene = TUtilityReflection.CreateDisplayObjectInstance("GongFuPayUI") as Sprite;
         addChild(this.FMainScene);
         this.FNameVec = new Vector.<TextField>();
         this.FAwardDesVec = new Vector.<TextField>();
         this.FTFCostVec = new Vector.<TextField>();
         this.FMCCostFlag = new Vector.<MovieClip>();
         this.FMCPayFlag = new Vector.<Sprite>();
         this.FBtnPayVec = new Vector.<TUIButton>();
         _loc1_ = 0;
         while(_loc1_ < TypeNum)
         {
            _loc2_ = this.FMainScene["type" + _loc1_];
            this.FNameVec.push(_loc2_["Name"]);
            this.FAwardDesVec.push(_loc2_["AwardDes"]);
            this.FTFCostVec.push(_loc2_["cost"]);
            this.FMCCostFlag.push(_loc2_["CostFlag"]);
            this.FMCPayFlag.push(_loc2_["PayFlag"]);
            _loc3_ = new TUIButton();
            _loc3_.Substrate = _loc2_["Btn"];
            _loc3_.OnClick = this.BtnPayOnClick;
            this.FBtnPayVec.push(_loc3_);
            _loc1_++;
         }
         this.FTFPayRecord = this.FMainScene["RecordDes"];
         this.FPendantLeft = this.FMainScene["MC_Animation_0"];
         this.FPendantRight = this.FMainScene["MC_Animation_1"];
         this.FBtnClose = new TUIButton();
         this.FBtnClose.Substrate = this.FMainScene["Btn_Close"];
         this.FBtnClose.OnClick = this.BtnCloseOnClick;
         this.FPayTypeName = TUtilityLobby.GetStringsByIdentifier(CONST_SYSTEMLANGUAGE.STRING_GongFuGight_14);
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         super.ResourcesPerform_UILocations();
      }
      
      protected function RenderView(param1:TGongFuFightData) : void
      {
         var _loc2_:int = 0;
         var _loc3_:TGongFuFightPay = null;
         _loc2_ = 0;
         while(_loc2_ < TypeNum)
         {
            _loc3_ = param1.GongFuFightPayInfors[_loc2_];
            this.FNameVec[_loc2_].text = this.FPayTypeName[_loc2_];
            this.FNameVec[_loc2_].textColor = CONST_COMMON.QUALITYCOLOR_INDEX[_loc3_.GSPVPDailyAward.Quality];
            this.FAwardDesVec[_loc2_].text = this.GetRewardDescription(_loc3_.PayReward);
            this.FTFCostVec[_loc2_].text = _loc3_.GSPVPDailyAward.Cost.toString();
            this.FMCCostFlag[_loc2_].gotoAndStop(_loc3_.GSPVPDailyAward.CostType);
            if(param1.GongFuFightBaseInfor.ToastTimes == 1)
            {
               this.FMCPayFlag[_loc2_].visible = true;
               this.FBtnPayVec[_loc2_].Visible = false;
            }
            else
            {
               this.FMCPayFlag[_loc2_].visible = false;
               this.FBtnPayVec[_loc2_].Visible = true;
            }
            _loc2_++;
         }
         this.ShowPayRecord(param1);
      }
      
      protected function ShowPayRecord(param1:TGongFuFightData) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:TGongFuFightPayRecord = null;
         var _loc6_:TGongFuFightPay = null;
         var _loc7_:String = null;
         _loc7_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_GongFuGight_15);
         _loc4_ = "";
         _loc3_ = param1.GongFuPayEffectNum;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc5_ = param1.GongFuPayRecord[_loc2_];
            _loc6_ = this.GetGongFuFightPayByID(param1,_loc5_.PayID);
            _loc4_ += TUtilityString.Format(_loc7_,CONST_COMMON.TextColor[_loc5_.PayQuality],_loc5_.PlayerName,CONST_COMMON.TextColor[_loc6_.GSPVPDailyAward.Quality],this.FPayTypeName[_loc6_.GSPVPDailyAward.Type - 1],this.GetPayRecordDescription(param1,_loc2_));
            _loc2_++;
         }
         this.FTFPayRecord.htmlText = _loc4_;
      }
      
      protected function GetPayRecordDescription(param1:TGongFuFightData, param2:int) : String
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:TInventory = null;
         var _loc6_:TInventories = null;
         var _loc7_:String = null;
         var _loc8_:TGongFuFightPayRecord = null;
         _loc8_ = param1.GongFuPayRecord[param2];
         _loc4_ = int(param1.GongFuFightPayInfors.length);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            if(param1.GongFuFightPayInfors[_loc3_].GSPVPDailyAward.Identifier == _loc8_.PayID)
            {
               _loc6_ = param1.GongFuFightPayInfors[_loc3_].PayReward;
            }
            _loc3_++;
         }
         _loc7_ = "";
         _loc4_ = _loc6_.Count;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc5_ = _loc6_.GetInventoryByIndex(_loc3_);
            _loc7_ += TUtilityString.Format(RecordDescription,_loc5_.Name,_loc5_.Quantity);
            _loc3_++;
         }
         return _loc7_ + "\n";
      }
      
      protected function GetRewardDescription(param1:TInventories) : String
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TInventory = null;
         var _loc5_:String = null;
         _loc5_ = "";
         _loc3_ = param1.Count;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = param1.GetInventoryByIndex(_loc2_);
            _loc5_ += TUtilityString.Format(AwardDescription,_loc4_.Name,_loc4_.Quantity);
            _loc2_++;
         }
         return _loc5_.substr(0,_loc5_.length - 1);
      }
      
      protected function GetGongFuFightPayByID(param1:TGongFuFightData, param2:uint) : TGongFuFightPay
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:TGongFuFightPay = null;
         _loc4_ = int(param1.GongFuFightPayInfors.length);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc5_ = param1.GongFuFightPayInfors[_loc3_];
            if(_loc5_.GSPVPDailyAward.Identifier == param2)
            {
               return _loc5_;
            }
            _loc3_++;
         }
         return null;
      }
      
      protected function BtnPayOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:TPacket = null;
         _loc3_ = this.FBtnPayVec.indexOf(param1 as TUIButton);
         _loc4_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_GongFuFight_PayReq);
         _loc4_.Data.writeUnsignedInt(this.FGongFuFightData.GongFuFightPayInfors[_loc3_].GSPVPDailyAward.Identifier);
         SNetworkCore.Transceiver.PacketTransmit(_loc4_);
      }
      
      protected function BtnCloseOnClick(param1:Object, param2:MouseEvent) : void
      {
         ProcessorWindowClose();
         this.Reset();
      }
      
      public function Update(param1:TGongFuFightData) : void
      {
         this.FGongFuFightData = param1;
         this.FPendantLeft.gotoAndPlay(1);
         this.FPendantRight.gotoAndPlay(1);
         this.RenderView(param1);
      }
      
      public function Reset() : void
      {
         this.FPendantLeft.stop();
         this.FPendantLeft.stop();
         FOnClose = null;
      }
   }
}

