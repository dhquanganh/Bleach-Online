package Processors.Game.Lobby.Home.GirlFriend
{
   import Foundation.Common.*;
   import Foundation.Network.*;
   import Foundation.Queries.Coordinate.TQueryCoordinate;
   import Foundation.Resources.*;
   import Foundation.Timing.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.Home.*;
   import Logics.Home.GirlFriend.*;
   import Logics.Inventories.*;
   import Logics.Streamization.Home.*;
   import Logics.Streamization.Inventories.TUnstreamizerInventoryReference;
   import Logics.TimeCoolDown.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Utilities.*;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Rendering.Overlayers.Hints.*;
   import Rendering.Overlayers.Inventories.*;
   import Resources.Constants.*;
   import Resources.Strings.*;
   import Utilities.UI.Overlayers.*;
   import flash.utils.*;
   
   public class TProcessorGirlFriend extends TProcessorLobbyWindows
   {
      
      public static const WINDOWID_GIRLFRIEND_BASEINFOR:int = 0;
      
      public static const WINDOWID_GIRLFRIEND_UPGRADE:int = 1;
      
      public static const TABID_GIRLFRIEND_BASEINFOR:int = 0;
      
      public static const TABID_GIRLFRIEND_MAKETOFU:int = 1;
      
      public static const TABID_GIRLFRIEND_COMMUNICATE:int = 2;
      
      public static const RewardID:int = 14100074;
      
      protected var FGirlFriend:TGirlFriend;
      
      protected var FHome:THome;
      
      protected var FWindowGirlFriendMainBoard:TProcessorWindowGirlFriendMainBoard;
      
      protected var FBaseInforBounds:TBounds;
      
      protected var FWindowConstrcutGirlFriendUpgrade:TProcessorWindowGirlFriendUpgrade;
      
      protected var FUpgradeBounds:TBounds;
      
      protected var FWaitForOpenWindowID:int;
      
      protected var FWaitForOpenTabID:int;
      
      protected var FUnstreamizerGirlFriend:TUnstreamizerGirlFriend;
      
      protected var FRewardNeedPlayEffect:TInventory;
      
      protected var FUnstreamizerInventoryReference:TUnstreamizerInventoryReference;
      
      protected var FInventories:TInventories;
      
      protected var FQueryCoordinate:TQueryCoordinate;
      
      protected var FCoordinateSource:TCoordinate;
      
      protected var FCoordinateDestination:TCoordinate;
      
      protected var FOnUpdateGirlFriend:Function;
      
      protected var FOnEffectAcquireInventory:Function;
      
      protected var FOnQueryCoordinateSource:Function;
      
      protected var FOnQueryCoordinateDestination:Function;
      
      public function TProcessorGirlFriend(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,param2);
         this.FHome = SLogicsCore.Home;
         this.FGirlFriend = this.FHome.GirlFriend;
         this.PreConstruct();
      }
      
      protected function PreConstruct() : void
      {
         this.ConstructGirlFriendMainBoardWindow();
         this.ConstrcutGirlFriendUpgradeWindow();
         this.FUnstreamizerGirlFriend = new TUnstreamizerGirlFriend();
         this.FUnstreamizerInventoryReference = new TUnstreamizerInventoryReference();
         this.FInventories = new TInventories();
         this.FQueryCoordinate = new TQueryCoordinate();
         this.FCoordinateSource = new TCoordinate();
         this.FCoordinateDestination = new TCoordinate();
      }
      
      protected function ConstructGirlFriendMainBoardWindow() : void
      {
         this.FWindowGirlFriendMainBoard = new TProcessorWindowGirlFriendMainBoard(FParent);
         this.FWindowGirlFriendMainBoard.OnClose = this.ProcessorGirlFriendMainBoardOnClose;
         this.FWindowGirlFriendMainBoard.FunOnShowUpgradeGirlWindow = this.OnOpenUpgradeWindow;
         this.FWindowGirlFriendMainBoard.OnEffectText = ProcessorsOnEffectText;
         this.FWindowGirlFriendMainBoard.OnHtmlEffectText = ProcessorsOnEffectHtmlText;
         this.FWindowGirlFriendMainBoard.HitMouseMove = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FWindowGirlFriendMainBoard.HitMouseOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FWindowGirlFriendMainBoard.PlayRewardEffect = this.PlayRewardEffect;
         this.FBaseInforBounds = new TBounds();
         this.FBaseInforBounds.Width = TProcessorWindowGirlFriendMainBoard.WINDOW_WIDTH;
         this.FBaseInforBounds.Height = TProcessorWindowGirlFriendMainBoard.WINDOW_HEIGHT;
         ComponentBoundsCenter(this.FWindowGirlFriendMainBoard,this.FBaseInforBounds);
         this.FBaseInforBounds = null;
      }
      
      protected function ConstrcutGirlFriendUpgradeWindow() : void
      {
         this.FWindowConstrcutGirlFriendUpgrade = new TProcessorWindowGirlFriendUpgrade(this);
         this.FWindowConstrcutGirlFriendUpgrade.OnClose = this.ProcessorGirlFriendUpgradeOnClose;
         this.FWindowConstrcutGirlFriendUpgrade.OnEffectText = ProcessorsOnEffectText;
         this.FWindowConstrcutGirlFriendUpgrade.ApplianceOnOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FWindowConstrcutGirlFriendUpgrade.ApplianceOnOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FUpgradeBounds = new TBounds();
         this.FUpgradeBounds.Width = TProcessorWindowGirlFriendUpgrade.WINDOW_WIDTH;
         this.FUpgradeBounds.Height = TProcessorWindowGirlFriendUpgrade.WINDOW_HEIGHT;
         ComponentBoundsCenter(this.FWindowConstrcutGirlFriendUpgrade,this.FUpgradeBounds);
         this.FUpgradeBounds = null;
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_GIRLFRIEND.RESOURCESID_Swf_GirlFriend);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:Vector.<uint> = null;
         _loc1_ = new Vector.<uint>();
         _loc1_.push(RewardID);
         this.FUnstreamizerInventoryReference.UnstreamizeGenerateInventoriesByIdentifiers(null,this.FInventories,_loc1_);
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         super.ResourcesPerform_UILocations();
      }
      
      override protected function PacketRegisterRoutines() : void
      {
         super.PacketRegisterRoutines();
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Home_GirlFriendBaseInforRet,this.PerformPacket_SC_BaseInfor);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Home_GirlFriendUpgradeRet,this.PerformPacket_SC_GirlFriendUpgradeRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Home_GirlFriendMakeTofu,this.PerformPacket_SC_GirlFriendMakeTofuRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Home_GirlFriendClearMakeTofuCD,this.PerformPacket_SC_GirlFriendClearMakeTofuCDRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Home_GirlFriendSpriteCommnicate,this.PerformPacket_SC_GirlFriendSpriteCommnicateRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Home_GirlFriendClearSpriteCommnicateCD,this.PerformPacket_SC_GirlFriendClearSpriteCommnicateCDRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Home_GirlFriendTeaseRet,this.PerformPacket_SC_GirlFriendTeaseRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Home_GirlOtherFriendTeaseRet,this.PerformPacket_SC_GirlOtherFriendTeaseRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Home_GirlFriendChangeShapeRet,this.PerformPacket_SC_GirlFriendChangeShapeRet);
      }
      
      protected function PerformPacket_SC_BaseInfor(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:int = 0;
         var _loc4_:TTimeCoolDown = null;
         _loc2_ = param1.Data;
         _loc3_ = int(_loc2_.readUnsignedInt());
         if(_loc3_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc3_);
            return;
         }
         this.FGirlFriend.GirlFriendTopLevelID = _loc2_.readUnsignedInt();
         this.FGirlFriend.CurrentChangeShapeGirlID = _loc2_.readUnsignedInt();
         this.FGirlFriend.ID = this.FGirlFriend.GirlFriendTopLevelID;
         this.FUnstreamizerGirlFriend.Unstreamization_GirlFriendByDatabase(this.FGirlFriend,null);
         this.FGirlFriend.CurrentCostMakeTofuTime = _loc2_.readUnsignedInt();
         _loc4_ = SLogicsCore.TimeCoolDowns.GetTimeByIdentifier(CONST_COMMON.TIME_COOLDOWN_Home_MakeTofu);
         this.SetColdDownTime(_loc4_,param1.Data.readUnsignedInt(),this.FGirlFriend.MakeTofuCDTime);
         this.FGirlFriend.CurrentSpriteCommunicateTime = _loc2_.readUnsignedInt();
         _loc4_ = SLogicsCore.TimeCoolDowns.GetTimeByIdentifier(CONST_COMMON.TIME_COOLDOWN_Home_SpriteCommunicate);
         this.SetColdDownTime(_loc4_,param1.Data.readUnsignedInt(),this.FGirlFriend.SpriteCommunicateCDTime);
         this.FGirlFriend.TeaseScore = _loc2_.readUnsignedInt();
         this.FGirlFriend.FriendTeaseType = _loc2_.readByte();
         this.FGirlFriend.FriendTeaseTime = _loc2_.readUnsignedInt();
         this.FGirlFriend.CurrentTeaseTime = _loc2_.readUnsignedInt();
         this.FGirlFriend.MyTeaseTime = _loc2_.readUnsignedInt();
         this.FGirlFriend.LoadComplete = true;
         if(this.FOnUpdateGirlFriend != null)
         {
            this.FOnUpdateGirlFriend(this);
         }
         if(visible)
         {
            this.OpenWindow();
         }
      }
      
      protected function PerformPacket_SC_GirlFriendUpgradeRet(param1:TPacket) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         _loc3_ = int(param1.Data.readUnsignedInt());
         if(_loc3_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc3_);
            return;
         }
         this.FGirlFriend.GirlFriendTopLevelID = param1.Data.readUnsignedInt();
         this.FGirlFriend.ID = this.FGirlFriend.GirlFriendTopLevelID;
         this.FGirlFriend.CurrentChangeShapeGirlID = param1.Data.readUnsignedInt();
         this.FUnstreamizerGirlFriend.Unstreamization_GirlFriendByDatabase(this.FGirlFriend,null);
         if(visible)
         {
            EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.GirlFriend_STRING_13));
            this.UpdateComponent();
         }
         if(this.FOnUpdateGirlFriend != null)
         {
            this.FOnUpdateGirlFriend(this);
         }
      }
      
      protected function PerformPacket_SC_GirlFriendMakeTofuRet(param1:TPacket) : void
      {
         var _loc2_:int = 0;
         var _loc3_:TTimeCoolDown = null;
         var _loc4_:uint = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:String = null;
         var _loc8_:TArticle = null;
         _loc2_ = int(param1.Data.readUnsignedInt());
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         _loc3_ = SLogicsCore.TimeCoolDowns.GetTimeByIdentifier(CONST_COMMON.TIME_COOLDOWN_Home_MakeTofu);
         this.FGirlFriend.CurrentCostMakeTofuTime = param1.Data.readUnsignedInt();
         this.SetColdDownTime(_loc3_,param1.Data.readUnsignedInt(),this.FGirlFriend.MakeTofuCDTime);
         param1.Data.readUnsignedShort();
         _loc5_ = param1.Data.readShort();
         _loc6_ = int(param1.Data.readUnsignedInt());
         _loc4_ = param1.Data.readUnsignedInt();
         _loc7_ = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.GirlFriend_STRING_14),TUtilityLobby.GetItemName(_loc5_,_loc6_),_loc4_.toString());
         if(visible)
         {
            this.FGirlFriend.NeedPlayMakeTofuEffect = true;
            EffectGenerateText(_loc7_);
            this.UpdateComponent();
         }
         if(this.FOnUpdateGirlFriend != null)
         {
            this.FOnUpdateGirlFriend(this);
         }
      }
      
      protected function PerformPacket_SC_GirlFriendClearMakeTofuCDRet(param1:TPacket) : void
      {
         var _loc2_:int = 0;
         var _loc3_:TTimeCoolDown = null;
         _loc2_ = int(param1.Data.readUnsignedInt());
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         _loc3_ = SLogicsCore.TimeCoolDowns.GetTimeByIdentifier(CONST_COMMON.TIME_COOLDOWN_Home_MakeTofu);
         _loc3_.TimingTime = 0;
         if(visible)
         {
            EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.GirlFriend_STRING_6));
            this.UpdateComponent();
         }
      }
      
      protected function PerformPacket_SC_GirlFriendSpriteCommnicateRet(param1:TPacket) : void
      {
         var _loc2_:int = 0;
         var _loc3_:ByteArray = null;
         var _loc4_:TTimeCoolDown = null;
         var _loc5_:TCoordinate = null;
         _loc3_ = param1.Data;
         _loc2_ = int(param1.Data.readUnsignedInt());
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         _loc4_ = SLogicsCore.TimeCoolDowns.GetTimeByIdentifier(CONST_COMMON.TIME_COOLDOWN_Home_SpriteCommunicate);
         this.FGirlFriend.CurrentSpriteCommunicateTime = _loc3_.readUnsignedInt();
         this.SetColdDownTime(_loc4_,param1.Data.readUnsignedInt(),this.FGirlFriend.SpriteCommunicateCDTime);
         this.FGirlFriend.GirlMood = param1.Data.readUnsignedInt();
         param1.Data.readUnsignedShort();
         param1.Data.readShort();
         this.FGirlFriend.SpriteCommunicateAwardID = param1.Data.readUnsignedInt();
         this.FGirlFriend.SpriteCommunicateAwardNum = param1.Data.readUnsignedInt();
         this.ConstructRewardInventory();
         _loc5_ = TUtilityCartisian.GetScreenCoordinateByDisplayObject(this.FWindowGirlFriendMainBoard.GetMovieClipByMood(this.FGirlFriend.GirlMood));
         this.FCoordinateSource.Assign(_loc5_);
         this.FQueryCoordinate.Value.Reset();
         if(this.FOnQueryCoordinateDestination != null)
         {
            this.FOnQueryCoordinateDestination(this,this.FQueryCoordinate);
         }
         this.FCoordinateDestination.Assign(this.FQueryCoordinate.Value);
         if(Visible)
         {
            this.UpdateComponent();
         }
         if(this.FOnUpdateGirlFriend != null)
         {
            this.FOnUpdateGirlFriend(this);
         }
      }
      
      protected function PerformPacket_SC_GirlFriendClearSpriteCommnicateCDRet(param1:TPacket) : void
      {
         var _loc2_:int = 0;
         var _loc3_:TTimeCoolDown = null;
         _loc2_ = int(param1.Data.readUnsignedInt());
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         _loc3_ = SLogicsCore.TimeCoolDowns.GetTimeByIdentifier(CONST_COMMON.TIME_COOLDOWN_Home_SpriteCommunicate);
         _loc3_.TimingTime = 0;
         if(visible)
         {
            EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.GirlFriend_STRING_9));
            this.UpdateComponent();
         }
      }
      
      protected function PerformPacket_SC_GirlFriendTeaseRet(param1:TPacket) : void
      {
         var _loc2_:int = 0;
         var _loc3_:String = null;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:TArticle = null;
         _loc2_ = int(param1.Data.readUnsignedInt());
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         _loc4_ = this.FGirlFriend.TeaseScore;
         this.FGirlFriend.TeaseScore = param1.Data.readUnsignedInt();
         this.FGirlFriend.MyTeaseTime = param1.Data.readUnsignedInt();
         this.FGirlFriend.CurrentTeaseTime = param1.Data.readUnsignedInt();
         param1.Data.readShort();
         param1.Data.readShort();
         _loc5_ = param1.Data.readUnsignedInt();
         _loc6_ = param1.Data.readUnsignedInt();
         _loc7_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_Article,_loc5_) as TArticle;
         _loc3_ = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.GirlFriend_STRING_16),(this.FGirlFriend.TeaseScore - _loc4_).toString(),_loc7_.Name,_loc6_.toString());
         EffectGenerateText(_loc3_);
         this.ConstructRewardInventory();
         this.FQueryCoordinate.Value.Reset();
         if(this.FOnQueryCoordinateSource != null)
         {
            this.FOnQueryCoordinateSource(this,this.FQueryCoordinate);
         }
         this.FCoordinateSource.Assign(this.FQueryCoordinate.Value);
         this.FQueryCoordinate.Value.Reset();
         if(this.FOnQueryCoordinateDestination != null)
         {
            this.FOnQueryCoordinateDestination(this,this.FQueryCoordinate);
         }
         this.FCoordinateDestination.Assign(this.FQueryCoordinate.Value);
         this.PlayRewardEffect();
         if(this.FOnUpdateGirlFriend != null)
         {
            this.FOnUpdateGirlFriend(this);
         }
      }
      
      protected function PerformPacket_SC_GirlOtherFriendTeaseRet(param1:TPacket) : void
      {
         this.FGirlFriend.FriendTeaseType = param1.Data.readByte();
         this.FGirlFriend.FriendTeaseTime = param1.Data.readUnsignedInt();
         this.FGirlFriend.TeaseScore = param1.Data.readUnsignedInt();
         if(this.FOnUpdateGirlFriend != null)
         {
            this.FOnUpdateGirlFriend(this);
         }
         if(visible)
         {
            this.UpdateComponent();
         }
      }
      
      protected function PerformPacket_SC_GirlFriendChangeShapeRet(param1:TPacket) : void
      {
         var _loc2_:int = 0;
         _loc2_ = int(param1.Data.readUnsignedInt());
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         this.FGirlFriend.CurrentChangeShapeGirlID = param1.Data.readUnsignedInt();
         this.FUnstreamizerGirlFriend.Unstreamization_GirlFriendByDatabase(this.FGirlFriend,null);
         if(visible)
         {
            EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.GirlFriend_STRING_17));
            this.UpdateComponent();
         }
         if(this.FOnUpdateGirlFriend != null)
         {
            this.FOnUpdateGirlFriend(this);
         }
      }
      
      protected function RequestGirlFriendInfor() : void
      {
         var _loc1_:TPacket = null;
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Home_GirlFriendBaseInforReq);
         SNetworkCore.Transceiver.PacketTransmit(_loc1_);
      }
      
      protected function ConstructRewardInventory() : void
      {
         var _loc1_:Vector.<uint> = null;
         if(this.FInventories.Count == 0)
         {
            _loc1_ = new Vector.<uint>();
            _loc1_.push(RewardID);
            this.FUnstreamizerInventoryReference.UnstreamizeGenerateInventoriesByIdentifiers(null,this.FInventories,_loc1_);
         }
      }
      
      protected function SetColdDownTime(param1:TTimeCoolDown, param2:uint, param3:uint) : void
      {
         var _loc4_:uint = 0;
         _loc4_ = STimingCore.ServerTick - param2;
         _loc4_ = param3 - _loc4_;
         _loc4_ = _loc4_ < 0 ? 0 : _loc4_;
         param1.TimingTime = _loc4_;
      }
      
      protected function LoadComponentResouce() : void
      {
         this.FWindowGirlFriendMainBoard.Load();
         this.FWindowConstrcutGirlFriendUpgrade.Load();
      }
      
      protected function SetupOpenWindowID(param1:ByteArray) : void
      {
         if(param1 != null)
         {
            this.FWaitForOpenWindowID = param1.readInt();
            if(this.FWaitForOpenWindowID == TProcessorGirlFriend.WINDOWID_GIRLFRIEND_BASEINFOR)
            {
               this.FWaitForOpenTabID = param1.readInt();
            }
         }
      }
      
      protected function OpenWindow() : void
      {
         switch(this.FWaitForOpenWindowID)
         {
            case WINDOWID_GIRLFRIEND_BASEINFOR:
               this.FWindowGirlFriendMainBoard.SwithTagManual(this.FWaitForOpenTabID);
               this.FWindowGirlFriendMainBoard.Update();
               BarrierActuate(this.FWindowGirlFriendMainBoard);
               this.FWindowGirlFriendMainBoard.visible = true;
               break;
            case WINDOWID_GIRLFRIEND_UPGRADE:
               this.FWindowConstrcutGirlFriendUpgrade.Update();
               BarrierActuate(this.FWindowConstrcutGirlFriendUpgrade);
               this.FWindowConstrcutGirlFriendUpgrade.visible = true;
         }
      }
      
      protected function UpdateComponent() : void
      {
         this.FWindowGirlFriendMainBoard.Update();
         this.FWindowConstrcutGirlFriendUpgrade.Update();
      }
      
      protected function PlayRewardEffect() : void
      {
         if(this.FOnEffectAcquireInventory != null)
         {
            this.FOnEffectAcquireInventory(this,this.FInventories.GetInventoryByIndex(0),this.FCoordinateSource,this.FCoordinateDestination);
         }
      }
      
      protected function ProcessorGirlFriendUpgradeOnClose(param1:Object) : void
      {
         BarrierDeactuate(this.FWindowConstrcutGirlFriendUpgrade);
      }
      
      protected function ProcessorGirlFriendMainBoardOnClose(param1:Object) : void
      {
         BarrierDeactuate(this.FWindowGirlFriendMainBoard);
      }
      
      protected function OnOpenUpgradeWindow(param1:Object) : void
      {
         this.FWaitForOpenWindowID = WINDOWID_GIRLFRIEND_UPGRADE;
         this.OpenWindow();
      }
      
      public function get OnUpdateGirlFriend() : Function
      {
         return this.FOnUpdateGirlFriend;
      }
      
      public function set OnUpdateGirlFriend(param1:Function) : void
      {
         this.FOnUpdateGirlFriend = param1;
      }
      
      public function set OnEffectAcquireInventory(param1:Function) : void
      {
         this.FOnEffectAcquireInventory = param1;
      }
      
      public function get OnQueryCoordinateSource() : Function
      {
         return this.FOnQueryCoordinateSource;
      }
      
      public function set OnQueryCoordinateSource(param1:Function) : void
      {
         this.FOnQueryCoordinateSource = param1;
      }
      
      public function get OnQueryCoordinateDestination() : Function
      {
         return this.FOnQueryCoordinateDestination;
      }
      
      public function set OnQueryCoordinateDestination(param1:Function) : void
      {
         this.FOnQueryCoordinateDestination = param1;
      }
      
      override public function Mount(param1:ByteArray = null) : void
      {
         super.Mount(param1);
         this.SetupOpenWindowID(param1);
         if(!FIsResourcesLoadCompleted)
         {
            this.LoadComponentResouce();
            return;
         }
         if(this.FGirlFriend.LoadComplete)
         {
            this.OpenWindow();
         }
         else
         {
            this.RequestGirlFriendInfor();
         }
      }
      
      public function RequestGirlBaseInfor() : void
      {
         if(!this.FGirlFriend.LoadComplete)
         {
            this.RequestGirlFriendInfor();
         }
      }
      
      public function Update() : void
      {
         this.UpdateComponent();
         if(this.FOnUpdateGirlFriend != null)
         {
            this.FOnUpdateGirlFriend(this);
         }
      }
      
      public function Reset() : void
      {
         if(!FIsResourcesLoadCompleted)
         {
            return;
         }
         this.FWindowConstrcutGirlFriendUpgrade.Reset();
         this.FWindowGirlFriendMainBoard.Reset();
      }
   }
}

