package Processors.Game.Lobby.Activity.HDTreasurehunt.TUIComponent
{
   import Components.ComboBox.TComboBox;
   import Components.Slots.TUISlot;
   import Components.Standard.TUIButton;
   import Foundation.Network.SNetworkCore;
   import Foundation.Network.TPacket;
   import Foundation.UI.TUIComponent;
   import Logics.HDTreasureHunt.TTreasureHunt;
   import Processors.Game.Lobby.Jade.TJadeCommon;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Resources.Constants.CONST_NETWORK;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class TUIBlock extends TUIComponent
   {
      
      protected var FMainUI:MovieClip;
      
      protected var FBtn_Choose:TUIButton;
      
      protected var FBtn_Begin:TUIButton;
      
      protected var FBtn_FreeGet:TUIButton;
      
      protected var FBtn_GoldGet:TUIButton;
      
      protected var FLevelComboBox:TComboBox;
      
      protected var FLevelList:Vector.<DisplayObject>;
      
      protected var FSlot:TUISlot;
      
      protected var FUIndex:uint;
      
      protected var FItemIndex:int;
      
      protected var FLevelIndex:uint;
      
      protected var FCurStatus:String;
      
      protected var FComboInit:Boolean;
      
      protected var FOpenChooseWin:Function;
      
      protected var FData:TTreasureHunt;
      
      public function TUIBlock(param1:TUIComponent)
      {
         super(param1);
      }
      
      protected function OnLevelSelect(param1:Object, param2:int) : void
      {
         this.FLevelIndex = param2;
      }
      
      protected function ProcessorOpenWin(param1:Object, param2:MouseEvent) : void
      {
         this.FOpenChooseWin(this.FUIndex);
      }
      
      protected function ProcessorBegin(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:Vector.<int> = null;
         _loc5_ = new Vector.<int>(3);
         _loc5_[0] = this.FUIndex + 1;
         _loc5_[1] = this.FData.Config.Items[this.FItemIndex + 4 * this.FUIndex].awardId;
         _loc5_[2] = this.FData.Config.Events[this.FLevelIndex + 3 * this.FUIndex].id;
         this.Perform_CS_ActivityOperateReq(this.FData.ActivityID,this.FData.Config.StartIndex,0,_loc5_);
      }
      
      protected function ProcessorFreeGet(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:Vector.<int> = null;
         _loc3_ = new Vector.<int>(1);
         _loc3_[0] = 0;
         this.Perform_CS_ActivityOperateReq(this.FData.ActivityID,this.FData.Config.FinishIndex,0,_loc3_);
      }
      
      protected function ProcessorGoldGet(param1:Object, param2:MouseEvent) : void
      {
         TUtilityLobby.GoldBuy(this.FData.Config.Golds[this.FUIndex],this.ProcessorGoldConfirmGet);
      }
      
      protected function ProcessorGoldConfirmGet(param1:Object) : void
      {
         var _loc2_:Vector.<int> = null;
         _loc2_ = new Vector.<int>(1);
         _loc2_[0] = 1;
         this.Perform_CS_ActivityOperateReq(this.FData.ActivityID,this.FData.Config.FinishIndex,0,_loc2_);
      }
      
      protected function Perform_CS_ActivityOperateReq(param1:uint, param2:uint, param3:uint = 0, param4:Vector.<int> = null) : void
      {
         var _loc5_:TPacket = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         if(param1 <= 0)
         {
            return;
         }
         _loc5_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Activity_OperateReq);
         _loc5_.Data.writeUnsignedInt(param1);
         _loc5_.Data.writeUnsignedInt(param2);
         if(param4 != null)
         {
            _loc7_ = int(param4.length);
            _loc5_.Data.writeShort(_loc7_);
            _loc6_ = 0;
            while(_loc6_ < _loc7_)
            {
               _loc5_.Data.writeInt(param4[_loc6_]);
               _loc6_++;
            }
         }
         SNetworkCore.Transceiver.PacketTransmit(_loc5_);
      }
      
      public function UpDateUI() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         if(this.FItemIndex != -1)
         {
            this.FSlot.Context = this.FData.Invs.GetInventoryByIndex(this.FUIndex * 4 + this.FItemIndex);
            if(this.FCurStatus != "false")
            {
               this.FBtn_Begin.Enabled = true;
            }
         }
         else
         {
            this.FSlot.Context = null;
            this.FBtn_Begin.Enabled = false;
         }
      }
      
      public function LogicsPerform() : void
      {
         this.FSlot.Update();
      }
      
      public function UIDispatch(param1:MovieClip, param2:uint) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         this.FMainUI = param1;
         this.FUIndex = param2;
         this.FBtn_Choose = new TUIButton();
         this.FBtn_Choose.Substrate = this.FMainUI["Btn_Choose"];
         this.FBtn_Choose.OnClick = this.ProcessorOpenWin;
         this.FBtn_Begin = new TUIButton();
         this.FBtn_Begin.Substrate = this.FMainUI["Btn_Begin"];
         this.FBtn_Begin.OnClick = this.ProcessorBegin;
         this.FBtn_FreeGet = new TUIButton();
         this.FBtn_FreeGet.Substrate = this.FMainUI["Btn_FreeGet"];
         this.FBtn_FreeGet.OnClick = this.ProcessorFreeGet;
         this.FBtn_GoldGet = new TUIButton();
         this.FBtn_GoldGet.Substrate = this.FMainUI["Btn_GoldGet"];
         this.FBtn_GoldGet.OnClick = this.ProcessorGoldGet;
         this.FSlot = new TUISlot(this);
         this.FSlot.Resource = param1["Slot"];
         this.FSlot.OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FSlot.OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
         TJadeCommon.InitSlot(this.FSlot);
         this.FSlot.Init();
      }
      
      public function SetData(param1:TTreasureHunt, param2:int) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:TextField = null;
         var _loc6_:MovieClip = null;
         this.FData = param1;
         this.FItemIndex = param2;
         if(this.FComboInit == false)
         {
            this.FLevelList = new Vector.<DisplayObject>();
            _loc4_ = 3;
            _loc3_ = 0;
            while(_loc3_ < _loc4_)
            {
               this.FMainUI["MC_ComboBox"]["mc_list"]["text_" + _loc3_]["tf_into"].text = this.FData.Config.Events[_loc3_ + this.FUIndex * 3].time + TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TYPE_TIME_Hour) + " " + this.FData.Config.Events[_loc3_ + this.FUIndex * 3].cost + TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ITEMNAME_Coin);
               this.FLevelList[_loc3_] = this.FMainUI["MC_ComboBox"]["mc_list"]["text_" + _loc3_];
               _loc3_++;
            }
            this.FLevelComboBox = new TComboBox(this,this.FMainUI["MC_ComboBox"],this.FLevelList,100,this.OnLevelSelect);
            this.FComboInit = true;
         }
         this.UpDateUI();
      }
      
      public function set OpenChooseWin(param1:Function) : void
      {
         this.FOpenChooseWin = param1;
      }
      
      public function Status(param1:String) : void
      {
         switch(param1)
         {
            case "false":
               if(this.FCurStatus != "false")
               {
                  this.FBtn_Choose.Enabled = false;
                  this.FBtn_Begin.Enabled = false;
                  this.FBtn_FreeGet.Enabled = false;
                  this.FBtn_GoldGet.Enabled = false;
                  if(this.FData != null && this.FData.CurMap != this.FUIndex + 1)
                  {
                     this.FSlot.Context = null;
                  }
                  this.FCurStatus = "false";
               }
               break;
            case "true":
               if(this.FCurStatus != "true")
               {
                  this.FBtn_Choose.Enabled = true;
                  this.FBtn_FreeGet.Enabled = false;
                  this.FBtn_GoldGet.Enabled = false;
                  this.FSlot.Context = null;
                  this.FCurStatus = "true";
               }
               break;
            case "ready":
               if(this.FCurStatus != "ready")
               {
                  this.FBtn_Choose.Enabled = false;
                  this.FBtn_Begin.Enabled = false;
                  this.FBtn_FreeGet.Enabled = true;
                  this.FBtn_GoldGet.Enabled = true;
                  this.FCurStatus = "ready";
               }
         }
      }
   }
}

