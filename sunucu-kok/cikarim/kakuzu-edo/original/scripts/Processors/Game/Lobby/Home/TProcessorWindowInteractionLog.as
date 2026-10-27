package Processors.Game.Lobby.Home
{
   import Components.Standard.*;
   import Foundation.Network.*;
   import Foundation.Resources.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.InteractionLog.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Home.Component.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   import flash.utils.*;
   
   public class TProcessorWindowInteractionLog extends TProcessorLobbyWindow
   {
      
      protected static const CAPACITY_InteractionLog_Items:uint = CONST_HOME.CAPACITY_InteractionLog_Items;
      
      public static const TAB_InteractionLog_Monster:uint = CONST_HOME.TAB_InteractionLog_Monster;
      
      public static const TAB_InteractionLog_GirlFriend:uint = CONST_HOME.TAB_InteractionLog_GirlFriend;
      
      protected var FInteractionLogMonster:TInteractionLogs;
      
      protected var FInteractionLogGirlFriend:TInteractionLogs;
      
      protected var FBtn_Close:SimpleButton;
      
      protected var FUITabInteractionLog:TUITab;
      
      protected var FItemLogs:Vector.<TItemLog>;
      
      protected var FTabInteractionLogIndex:uint;
      
      protected var FIsMonsterRequested:Boolean;
      
      protected var FIsGirlFriendRequested:Boolean;
      
      protected var FIsInitialization:Boolean;
      
      protected var FOnVisit:Function;
      
      public function TProcessorWindowInteractionLog(param1:TUIComponent)
      {
         super(param1);
         this.FInteractionLogMonster = SLogicsCore.Home.InteractionLogMonster;
         this.FInteractionLogGirlFriend = SLogicsCore.Home.InteractionLogGirlFriend;
         this.FTabInteractionLogIndex = 0;
         this.FIsMonsterRequested = false;
         this.FIsGirlFriendRequested = false;
         this.FIsInitialization = false;
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_HOME.RESOURCESID_Swf_Home);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:MovieClip = null;
         var _loc4_:Sprite = null;
         var _loc5_:TItemLog = null;
         _loc4_ = TUtilityReflection.CreateDisplayObjectInstance(CONST_HOME.RESOURCE_ClassName_MC_InteractionLog) as Sprite;
         addChild(_loc4_);
         this.FBtn_Close = _loc4_[CONST_COMMON.RESOURCE_Link_Btn_Close];
         this.FBtn_Close.tabEnabled = false;
         this.FUITabInteractionLog = new TUITab(this);
         _loc3_ = _loc4_[CONST_HOME.RESOURCE_Link_Btn_TabMonster];
         _loc3_.mouseChildren = false;
         (_loc3_.getChildAt(1) as TextField).mouseEnabled = false;
         this.FUITabInteractionLog.SetTabByIndex(_loc3_,0);
         _loc3_ = _loc4_[CONST_HOME.RESOURCE_Link_Btn_TabGirlFriend];
         _loc3_.mouseChildren = false;
         (_loc3_.getChildAt(1) as TextField).mouseEnabled = false;
         this.FUITabInteractionLog.SetTabByIndex(_loc3_,1);
         this.FUITabInteractionLog.OnSwitch = this.TabInteractionLogOnSwitch;
         this.FUITabInteractionLog.Init();
         _loc2_ = int(CAPACITY_InteractionLog_Items);
         this.FItemLogs = new Vector.<TItemLog>(_loc2_);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc5_ = new TItemLog(this);
            _loc5_.Resource = _loc4_[CONST_HOME.RESOURCE_Link_Item + _loc1_];
            _loc5_.OnClick = this.ItemLogOnClick;
            _loc5_.Visible = false;
            this.FItemLogs[_loc1_] = _loc5_;
            _loc1_++;
         }
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         this.FBtn_Close.addEventListener(MouseEvent.CLICK,this.ButtonCloseOnClick,false,0,true);
         this.FIsInitialization = true;
         super.ResourcesPerform_UILocations();
      }
      
      protected function UpdateInteractionLogs() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TItemLog = null;
         var _loc4_:uint = 0;
         var _loc5_:TInteractionLog = null;
         var _loc6_:TInteractionLogs = null;
         switch(this.FTabInteractionLogIndex)
         {
            case TAB_InteractionLog_Monster:
               _loc6_ = this.FInteractionLogMonster;
               break;
            case TAB_InteractionLog_GirlFriend:
               _loc6_ = this.FInteractionLogGirlFriend;
         }
         _loc4_ = uint(_loc6_.Count);
         _loc2_ = int(CAPACITY_InteractionLog_Items);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FItemLogs[_loc1_];
            _loc3_.Context = null;
            _loc3_.Visible = false;
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            if(_loc1_ >= _loc4_)
            {
               break;
            }
            _loc5_ = _loc6_.GetInteractionLogByIndex(_loc1_);
            _loc3_ = this.FItemLogs[_loc1_];
            _loc3_.Context = _loc5_;
            _loc3_.Visible = true;
            _loc1_++;
         }
      }
      
      protected function ButtonCloseOnClick(param1:MouseEvent) : void
      {
         ProcessorWindowClose();
      }
      
      protected function TabInteractionLogOnSwitch(param1:Object) : void
      {
         this.FTabInteractionLogIndex = param1 as int;
         this.RequestInteractionLog();
         this.UpdateInteractionLogs();
      }
      
      protected function ItemLogOnClick(param1:Object, param2:TInteractionLog) : void
      {
         var _loc3_:String = null;
         if(this.FOnVisit != null)
         {
            this.FOnVisit(this,param2.Identifier0,param2.Identifier1);
         }
         ProcessorWindowClose();
      }
      
      public function get OnVisit() : Function
      {
         return this.FOnVisit;
      }
      
      public function set OnVisit(param1:Function) : void
      {
         this.FOnVisit = param1;
      }
      
      public function RequestInteractionLog() : void
      {
         var _loc1_:ByteArray = null;
         var _loc2_:TPacket = null;
         var _loc3_:Boolean = false;
         switch(this.FTabInteractionLogIndex)
         {
            case TAB_InteractionLog_Monster:
               _loc3_ = this.FIsMonsterRequested;
               this.FIsMonsterRequested = true;
               break;
            case TAB_InteractionLog_GirlFriend:
               _loc3_ = this.FIsGirlFriendRequested;
               this.FIsGirlFriendRequested = true;
         }
         if(!_loc3_)
         {
            _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Home_InteractiveRecordReq);
            _loc1_ = _loc2_.Data;
            _loc1_.writeByte(this.FTabInteractionLogIndex);
            SNetworkCore.Transceiver.PacketTransmit(_loc2_);
         }
      }
      
      public function Update() : void
      {
         this.UpdateInteractionLogs();
      }
   }
}

