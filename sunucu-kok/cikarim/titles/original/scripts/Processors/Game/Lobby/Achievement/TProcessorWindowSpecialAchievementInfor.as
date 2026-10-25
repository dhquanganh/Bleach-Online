package Processors.Game.Lobby.Achievement
{
   import Components.Slots.TUISlot;
   import Components.Standard.TUIButton;
   import Foundation.Network.SNetworkCore;
   import Foundation.Network.TPacket;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Foundation.Utilities.TUtilityString;
   import Logics.Achievenment.TAchievementInfor;
   import Logics.Achievenment.TAchievementSchedule;
   import Logics.DatebaseVO.VO.TKnife;
   import Logics.Inventories.TInventory;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import Processors.Game.Lobby.Jade.TJadeCommon;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Resources.Constants.CONST_ACHIEVEMENT;
   import Resources.Constants.CONST_COMMON;
   import Resources.Constants.CONST_NETWORK;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.utils.ByteArray;
   
   public class TProcessorWindowSpecialAchievementInfor extends TProcessorLobbyWindow
   {
      
      protected static const FormatString:String = "%0<font color=\'%1\'>(%2/%3)</font>\n";
      
      protected static const SLOTNUM:int = 1;
      
      protected static const SLOTSTARTX:Vector.<int> = Vector.<int>([283]);
      
      protected static const SlotBlank:int = 56;
      
      protected var FTF_Name:TextField;
      
      protected var FTF_Schedule:TextField;
      
      protected var FSlots:Vector.<TUISlot>;
      
      protected var FTFKnifeName:TextField;
      
      protected var FFollowField:Sprite;
      
      protected var FSelectFollowBox:SimpleButton;
      
      protected var FCancleFollowBox:SimpleButton;
      
      protected var FKnifePic:MovieClip;
      
      protected var FKnifeName:TextField;
      
      protected var FKnifeNameField:Sprite;
      
      protected var FBtn_Close:SimpleButton;
      
      protected var FBtn_GetReward:TUIButton;
      
      protected var FAlreadyReciveFlag:Sprite;
      
      protected var FAchievementInfor:TAchievementInfor;
      
      protected var FInventoryMouseOver:Function;
      
      protected var FInventoryMouseOut:Function;
      
      protected var FCurrentMode:int;
      
      public function TProcessorWindowSpecialAchievementInfor(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(Visible)
         {
            this.UpdateSlot();
         }
      }
      
      protected function UIDispatch() : void
      {
         var _loc1_:Sprite = null;
         var _loc2_:MovieClip = null;
         var _loc3_:int = 0;
         var _loc4_:TUISlot = null;
         _loc1_ = TUtilityReflection.CreateDisplayObjectInstance("SepcialAchInfor") as Sprite;
         addChild(_loc1_);
         this.FFollowField = _loc1_["FollowAch"];
         this.FKnifeNameField = _loc1_["KnifeNameField"];
         this.FTF_Schedule = _loc1_["TF_Schedule"];
         _loc2_ = _loc1_["FollowAch"]["MC_CheckBox"];
         this.FSelectFollowBox = _loc2_["Btn_CheckBoxTrue"];
         this.FCancleFollowBox = _loc2_["Btn_CheckBoxFalse"];
         this.FBtn_Close = _loc1_["Board"]["Btn_Close"];
         this.FTF_Name = _loc1_["Board"]["Name"];
         this.FBtn_GetReward = new TUIButton();
         this.FBtn_GetReward.Substrate = _loc1_["GetReward"];
         this.FBtn_GetReward.OnClick = this.BtnGetRewardOnClick;
         this.FAlreadyReciveFlag = _loc1_["AlreadyRecive"];
         this.FAlreadyReciveFlag.visible = false;
         this.FKnifePic = _loc1_["KnifePic"];
         this.FKnifeName = _loc1_["KnifeNameField"]["KnifeName"];
         this.FSlots = new Vector.<TUISlot>();
         _loc3_ = 0;
         while(_loc3_ < SLOTNUM)
         {
            _loc4_ = new TUISlot(this);
            _loc4_.Resource = _loc1_["Slot" + _loc3_];
            _loc4_.OnOver = this.FInventoryMouseOver;
            _loc4_.OnOut = this.FInventoryMouseOut;
            TJadeCommon.InitSlot(_loc4_);
            _loc4_.Init();
            this.FSlots.push(_loc4_);
            _loc3_++;
         }
      }
      
      protected function UILocation() : void
      {
         this.FBtn_Close.addEventListener(MouseEvent.CLICK,this.BtnCloseOnClick);
         this.FSelectFollowBox.addEventListener(MouseEvent.CLICK,this.BtnSelectFollowOnClick);
         this.FCancleFollowBox.addEventListener(MouseEvent.CLICK,this.BtnCancleFollowOnClick);
      }
      
      protected function ShowAchievementInfor_Perform(param1:TAchievementInfor) : void
      {
         var _loc2_:int = 0;
         var _loc3_:TAchievementSchedule = null;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:int = 0;
         var _loc7_:TInventory = null;
         var _loc8_:TKnife = null;
         this.FTF_Name.text = param1.Name;
         this.FSelectFollowBox.visible = param1.IfFollow;
         this.FCancleFollowBox.visible = !param1.IfFollow;
         this.FFollowField.visible = false;
         this.FKnifeNameField.visible = this.FCurrentMode == CONST_ACHIEVEMENT.WINDOWMODE_SHOWME;
         this.FBtn_GetReward.Visible = this.FCurrentMode == CONST_ACHIEVEMENT.WINDOWMODE_SHOWME && !param1.IfGotReward && param1.IfComplete;
         this.FAlreadyReciveFlag.visible = this.FCurrentMode == CONST_ACHIEVEMENT.WINDOWMODE_SHOWME && param1.IfGotReward;
         _loc4_ = "";
         _loc2_ = 0;
         while(_loc2_ < param1.AchievementSchedules.length)
         {
            _loc3_ = param1.AchievementSchedules[_loc2_];
            if(_loc3_.CurrentSchedule >= _loc3_.Value)
            {
               _loc5_ = CONST_COMMON.HTMLCOLOR_Green;
            }
            else
            {
               _loc5_ = CONST_COMMON.HTMLCOLOR_Red;
            }
            _loc4_ += TUtilityString.Format(FormatString,_loc3_.ConditionStrings,_loc5_,_loc3_.CurrentSchedule,_loc3_.Value);
            _loc2_++;
         }
         this.FTF_Schedule.htmlText = _loc4_;
         _loc6_ = SLOTSTARTX[this.FAchievementInfor.Rewards.Count - 1];
         _loc2_ = 0;
         while(_loc2_ < this.FAchievementInfor.Rewards.Count)
         {
            this.FSlots[_loc2_].Context = this.FAchievementInfor.Rewards.GetInventoryByIndex(_loc2_);
            this.FSlots[_loc2_].Resource.x = _loc6_;
            this.FSlots[_loc2_].Resource.visible = true;
            _loc6_ += SlotBlank;
            _loc2_++;
         }
         while(_loc2_ < SLOTNUM)
         {
            this.FSlots[_loc2_].Resource.visible = false;
            _loc2_++;
         }
         _loc7_ = this.FAchievementInfor.Rewards.GetInventoryByIndex(0);
         this.FKnifePic.gotoAndStop("Knife" + _loc7_.IDTemplate);
         this.FKnifeName.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.Achievement_String_07),_loc7_.Name.substring(0,_loc7_.Name.length - 2));
      }
      
      protected function UpdateSlot() : void
      {
         var _loc1_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < this.FAchievementInfor.Rewards.Count)
         {
            this.FSlots[_loc1_].Update();
            _loc1_++;
         }
      }
      
      protected function BtnCloseOnClick(param1:MouseEvent) : void
      {
         if(FOnClose != null)
         {
            FOnClose(this.FAchievementInfor);
         }
      }
      
      protected function BtnSelectFollowOnClick(param1:MouseEvent) : void
      {
         this.FAchievementInfor.IfFollow = false;
         this.FSelectFollowBox.visible = false;
         this.FCancleFollowBox.visible = true;
      }
      
      protected function BtnCancleFollowOnClick(param1:MouseEvent) : void
      {
         this.FAchievementInfor.IfFollow = true;
         this.FSelectFollowBox.visible = true;
         this.FCancleFollowBox.visible = false;
      }
      
      protected function BtnGetRewardOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TPacket = null;
         var _loc4_:ByteArray = null;
         _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_AchievementRewardReq);
         _loc3_.Data.writeUnsignedInt(this.FAchievementInfor.ID);
         SNetworkCore.Transceiver.PacketTransmit(_loc3_);
         this.FBtn_GetReward.Visible = false;
         this.FFollowField.visible = false;
         this.FAchievementInfor.IfFollow = false;
      }
      
      public function set InventoryMouseOver(param1:Function) : void
      {
         this.FInventoryMouseOver = param1;
      }
      
      public function set InventoryMouseOut(param1:Function) : void
      {
         this.FInventoryMouseOut = param1;
      }
      
      public function set Mode(param1:int) : void
      {
         this.FCurrentMode = param1;
      }
      
      public function ShowAchievementInfor(param1:TAchievementInfor = null) : void
      {
         if(param1 != null)
         {
            this.FAchievementInfor = param1;
         }
         this.ShowAchievementInfor_Perform(this.FAchievementInfor);
      }
      
      public function Init() : void
      {
         this.UIDispatch();
         this.UILocation();
      }
      
      public function Reset() : void
      {
         var _loc1_:int = 0;
         if(this.FAchievementInfor == null)
         {
            return;
         }
         _loc1_ = 0;
         while(_loc1_ < this.FAchievementInfor.Rewards.Count)
         {
            this.FSlots[_loc1_].Context = null;
            _loc1_++;
         }
      }
   }
}

