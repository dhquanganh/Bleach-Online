package Processors.Game.Lobby.Home
{
   import Foundation.Common.*;
   import Foundation.Network.*;
   import Foundation.Queries.Coordinate.*;
   import Foundation.Resources.*;
   import Foundation.Timing.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.Characters.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.Home.*;
   import Logics.Home.HomeSoul.*;
   import Logics.Home.LuckyCat.*;
   import Logics.InteractionLog.*;
   import Logics.Inventories.*;
   import Logics.Spaces.LogicsSpace;
   import Logics.Streamization.Home.*;
   import Logics.Streamization.InteractionLog.*;
   import Logics.Streamization.Inventories.*;
   import Logics.TimeCoolDown.*;
   import Processors.Game.Common.Effects.Texts.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Home.GirlFriend.*;
   import Processors.Game.Lobby.Utilities.*;
   import Processors.Game.Utilities.HyperLink.*;
   import Processors.Game.Utilities.OverLayer.*;
   import Processors.Game.Windows.Information.*;
   import Rendering.Overlayers.*;
   import Rendering.Overlayers.Hints.*;
   import Rendering.Overlayers.Home.*;
   import Resources.Constants.*;
   import Resources.Strings.*;
   import Utilities.UI.Overlayers.*;
   import Utilities.UI.Windows.*;
   import flash.events.*;
   import flash.utils.*;
   
   use namespace LogicsSpace;
   
   public class TProcessorHome extends TProcessorLobbyPlate
   {
      
      protected static const SIZE_WindowHomeHall_Width:uint = 491;
      
      protected static const SIZE_WindowHomeHall_Height:uint = 503;
      
      protected static const SIZE_WindowInteractionLog_Width:uint = 615;
      
      protected static const SIZE_WindowInteractionLog_Height:uint = 397;
      
      protected static const COORDINATE_MONSTER_X:int = 640;
      
      protected static const COORDINATE_MONSTER_Y:int = 340;
      
      public static const TAB_InteractionLog_Monster:uint = CONST_HOME.TAB_InteractionLog_Monster;
      
      public static const TAB_InteractionLog_GirlFriend:uint = CONST_HOME.TAB_InteractionLog_GirlFriend;
      
      protected static const CAPACITY_InteractionLog_Items:uint = CONST_HOME.CAPACITY_InteractionLog_Items;
      
      protected var FUIWindowConfirmation:TUIWindowConfirmation;
      
      protected var FUnstreamizerHome:TUnstreamizerHome;
      
      protected var FUnstreamizerInteractionLog:TUnstreamizerInteractionLog;
      
      protected var FUnstreamizerInteractionLogs:TUnstreamizerInteractionLogs;
      
      protected var FCharacter:TCharacter;
      
      protected var FProcessorWindowHome:TProcessorWindowHome;
      
      protected var FProcessorWindowHomeHall:TProcessorWindowHomeHall;
      
      protected var FProcessorWindowInteractionLog:TProcessorWindowInteractionLog;
      
      protected var FProcessorGirlFriend:TProcessorGirlFriend;
      
      protected var FOverlayerLuckyCat:TOverlayerLuckyCat;
      
      protected var FOverlayerHomeSoul:TOverlayerHomeMonsterSoul;
      
      protected var FOverlayerHomeInteractive:TOverlayerHomeInteractive;
      
      protected var FHome:THome;
      
      protected var FHomeFriend:THome;
      
      protected var FFriendDigests:TFriendDigests;
      
      protected var FFriendDigest:TFriendDigest;
      
      protected var FBoundsHome:TBounds;
      
      protected var FHomeType:uint;
      
      protected var FIdentifier0:uint;
      
      protected var FIdentifier1:uint;
      
      protected var FIsFirst:Boolean;
      
      protected var FUnstreamizerInventoryReference:TUnstreamizerInventoryReference;
      
      protected var FEffectCoordinateParameters:TEffectCoordinateParameters;
      
      protected var FQueryCoordinate:TQueryCoordinate;
      
      protected var FCoordinateSource:TCoordinate;
      
      protected var FCoordinateDestination:TCoordinate;
      
      protected var FInventories:TInventories;
      
      protected var FParameter:int;
      
      protected var FOnEnterTown:Function;
      
      protected var FOnSetBattleStatus:Function;
      
      protected var FOnEnterBattle:Function;
      
      protected var FOnHomeResetNtf:Function;
      
      protected var FOnAddFriend:Function;
      
      protected var FOnEffectSilverCoin:Function;
      
      protected var FOnEffectAcquireInventory:Function;
      
      public function TProcessorHome(param1:TUIComponent, param2:TLobbyParameters)
      {
         var _loc3_:TUIComponent = null;
         super(param1,param2);
         _loc3_ = param2.MountPointWindow;
         this.FUnstreamizerInteractionLog = new TUnstreamizerInteractionLog();
         this.FUnstreamizerInteractionLogs = new TUnstreamizerInteractionLogs();
         this.FProcessorWindowHome = new TProcessorWindowHome(this);
         this.FProcessorWindowHome.OnClose = this.ProcessorWindowHomeOnClose;
         this.FProcessorWindowHome.OnEffectText = ProcessorsOnEffectText;
         this.FProcessorWindowHome.HintOnMove = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FProcessorWindowHome.HintOnOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FProcessorWindowHome.OnVisit = this.ProcessorEnterHomeReq;
         this.FProcessorWindowHome.OnHomeHall = this.ProcessorOnHomeHall;
         this.FProcessorWindowHome.OnMonster = this.ProcessorOnMonster;
         this.FProcessorWindowHome.OnClearCD = this.ProcessorOnClearCD;
         this.FProcessorWindowHome.OnLuckyCat = this.ProcessorOnLuckyCat;
         this.FProcessorWindowHome.OverlayOnMove = this.UIComponentOnOverlayOnMove;
         this.FProcessorWindowHome.OverlayOnOut = this.UIComponentOnOverlayOnOut;
         this.FProcessorWindowHome.OnClickOpenGirlFriend = this.OpenGirlFriendWindow;
         this.FProcessorWindowHome.OnClickUpgradeGirlFriend = this.OpenGirlFriendUpgradeWindow;
         this.FProcessorWindowHome.OnInteractionLog = this.ProcessorOnInteractionLog;
         this.FProcessorWindowHome.OnEffectSilverCoin = this.ProcessorOnEffectSilverCoin;
         this.FProcessorWindowHomeHall = new TProcessorWindowHomeHall(_loc3_);
         this.FProcessorWindowHomeHall.OnClose = this.ProcessorWindowHomeHallOnClose;
         this.FProcessorWindowInteractionLog = new TProcessorWindowInteractionLog(_loc3_);
         this.FProcessorWindowInteractionLog.OnClose = this.ProcessorWindowInteractionLogOnClose;
         this.FProcessorWindowInteractionLog.OnVisit = this.ProcessorEnterHomeReq;
         this.FProcessorGirlFriend = new TProcessorGirlFriend(_loc3_,param2);
         this.FProcessorGirlFriend.Visible = false;
         this.FProcessorGirlFriend.OnEffectText = ProcessorsOnEffectText;
         this.FProcessorGirlFriend.OnEffectHtmlText = ProcessorsOnEffectHtmlText;
         this.FProcessorGirlFriend.OnUpdateGirlFriend = this.ProcessorOnUpdateGirlFriend;
         this.FProcessorGirlFriend.OnQueryCoordinateSource = this.ProcessorOnQueryGirlfriendInteractiveCoordinate;
         this.FProcessorGirlFriend.OnQueryCoordinateDestination = this.ProcessorOnQueryCoordinateDestination;
         this.FProcessorGirlFriend.OnEffectAcquireInventory = this.ProcessorOnEffectAcquireInventory;
         this.FBoundsHome = new TBounds();
         this.FBoundsHome.Width = SIZE_WindowHomeHall_Width;
         this.FBoundsHome.Height = SIZE_WindowHomeHall_Height;
         ComponentBoundsCenter(this.FProcessorWindowHomeHall,this.FBoundsHome);
         this.FBoundsHome.Width = SIZE_WindowInteractionLog_Width;
         this.FBoundsHome.Height = SIZE_WindowInteractionLog_Height;
         ComponentBoundsCenter(this.FProcessorWindowInteractionLog,this.FBoundsHome);
         this.FBoundsHome = null;
         this.FFriendDigest = new TFriendDigest(0,0);
         this.FHome = SLogicsCore.Home;
         this.FHomeFriend = SLogicsCore.HomeFriend;
         this.FFriendDigests = SLogicsCore.Friends;
         this.FCharacter = SLogicsCore.Character;
         this.FUnstreamizerHome = new TUnstreamizerHome();
         this.FParameter = -1;
         this.FIsFirst = false;
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_HOME.RESOURCESID_Swf_Home);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         this.FEffectCoordinateParameters = new TEffectCoordinateParameters();
         this.FQueryCoordinate = new TQueryCoordinate();
         this.FCoordinateSource = new TCoordinate();
         this.FCoordinateDestination = new TCoordinate();
         this.FOverlayerLuckyCat = new TOverlayerLuckyCat(this);
         this.FOverlayerLuckyCat.Visible = false;
         this.FOverlayerHomeSoul = new TOverlayerHomeMonsterSoul(this);
         this.FOverlayerHomeSoul.Visible = false;
         this.FOverlayerHomeInteractive = new TOverlayerHomeInteractive(this);
         this.FOverlayerHomeInteractive.Visible = false;
         this.FUnstreamizerInventoryReference = new TUnstreamizerInventoryReference();
         this.FInventories = new TInventories();
         this.FUIWindowConfirmation = SUtilityOverLayer.UIWindowConfirmation;
         TUtilityUIOverlayer.ResourcesDispatch(this.FOverlayerLuckyCat);
         TUtilityUIOverlayer.ResourcesDispatch(this.FOverlayerHomeSoul);
         TUtilityUIOverlayer.ResourcesDispatch(this.FOverlayerHomeInteractive);
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         super.ResourcesPerform_UILocations();
      }
      
      override protected function PacketRegisterRoutines() : void
      {
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Home_HomeUpgradeRet,this.PerformPacket_SC_Home_HomeUpgradeRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Home_HomeResetNtf,this.PerformPacket_SC_Home_HomeResetNtf);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Home_InteractiveRecordRet,this.PerformPacket_SC_Home_InteractiveRecordRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Home_MyMonsterBeBeatenCountNtf,this.PerformPacket_SC_Home_MyMonsterBeBeatenCountNtf);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Home_InteractiveRecordNtf,this.PerformPacket_SC_Home_InteractiveRecordNtf);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_Home_GirlFriendBaseInforRet,CONST_NETWORK.PACKETID_SC_Home_GirlFriendChangeShapeRet,this.PerformPacket_SC_Home_GirlFriend);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Home_LuckyCatRet,this.PerformPacket_SC_Home_LuckyCatRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Home_ClearLuckyCatRet,this.PerformPacket_SC_Home_ClearLuckyCatRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Home_HZRet,this.PerformPacket_SC_Home_HZRet);
      }
      
      protected function PerformPacket_SC_Home_HomeUpgradeRet(param1:TPacket) : void
      {
         var _loc2_:int = 0;
         var _loc3_:ByteArray = null;
         _loc3_ = param1.Data;
         _loc2_ = int(_loc3_.readUnsignedInt());
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         ++this.FHome.Level;
         this.FUnstreamizerHome.UnstreamizeHomeByDatabase(this.FHome);
         this.FProcessorWindowHome.UpdateHomeUpgrade();
         this.FProcessorWindowHomeHall.Update();
      }
      
      protected function PerformPacket_SC_Home_HomeResetNtf(param1:TPacket) : void
      {
         var _loc2_:TTimeCoolDown = null;
         this.FHome.MyMonsterBeBeatenCount = 0;
         this.FHome.MyMonsterCount = 0;
         this.FHome.FriendMonsterCount = 0;
         this.FHome.LuckyCatCount = 0;
         this.FHome.LuckyCatCD = 0;
         this.FHome.GirlFriend.MyTeaseTime = 0;
         this.FHome.GirlFriend.CurrentTeaseTime = 0;
         this.FHome.GirlFriend.CurrentSpriteCommunicateTime = 0;
         this.FHome.GirlFriend.CurrentCostMakeTofuTime = 0;
         _loc2_ = SLogicsCore.TimeCoolDowns.GetTimeByIdentifier(CONST_COMMON.TIME_COOLDOWN_Home_MakeTofu);
         _loc2_.TimingTime = 0;
         _loc2_ = SLogicsCore.TimeCoolDowns.GetTimeByIdentifier(CONST_COMMON.TIME_COOLDOWN_Home_SpriteCommunicate);
         _loc2_.TimingTime = 0;
         if(this.FProcessorGirlFriend.Visible)
         {
            this.FProcessorGirlFriend.Update();
         }
         if(this.FOnHomeResetNtf != null)
         {
            this.FOnHomeResetNtf(this);
         }
      }
      
      protected function PerformPacket_SC_Home_InteractiveRecordRet(param1:TPacket) : void
      {
         var _loc2_:int = 0;
         var _loc3_:ByteArray = null;
         var _loc4_:uint = 0;
         var _loc5_:TInteractionLogs = null;
         _loc3_ = param1.Data;
         _loc2_ = int(_loc3_.readUnsignedInt());
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         _loc4_ = _loc3_.readUnsignedByte();
         switch(_loc4_)
         {
            case TAB_InteractionLog_Monster:
               _loc5_ = this.FHome.InteractionLogMonster;
               break;
            case TAB_InteractionLog_GirlFriend:
               _loc5_ = this.FHome.InteractionLogGirlFriend;
         }
         this.FUnstreamizerInteractionLogs.Unstreamize(_loc3_,_loc5_,CAPACITY_InteractionLog_Items);
         if(this.FProcessorWindowInteractionLog.Visible)
         {
            this.FProcessorWindowInteractionLog.Update();
         }
      }
      
      protected function PerformPacket_SC_Home_MyMonsterBeBeatenCountNtf(param1:TPacket) : void
      {
         var _loc2_:int = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:ByteArray = null;
         _loc5_ = param1.Data;
         _loc3_ = _loc5_.readUnsignedInt();
         _loc4_ = _loc5_.readUnsignedInt();
         if(_loc3_ == this.FCharacter.Identifier0 && _loc3_ == this.FCharacter.Identifier1)
         {
            this.FHome.MyMonsterBeBeatenCount = _loc5_.readUnsignedByte();
         }
         else
         {
            this.FHomeFriend.MyMonsterBeBeatenCount = _loc5_.readUnsignedByte();
         }
         if(this.FProcessorWindowHome.Visible)
         {
            this.FProcessorWindowHome.UpdateMonster();
         }
      }
      
      protected function PerformPacket_SC_Home_InteractiveRecordNtf(param1:TPacket) : void
      {
         var _loc2_:* = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:ByteArray = null;
         var _loc6_:uint = 0;
         var _loc7_:TInteractionLog = null;
         var _loc8_:TInteractionLogs = null;
         _loc5_ = param1.Data;
         _loc6_ = _loc5_.readUnsignedByte();
         switch(_loc6_)
         {
            case TAB_InteractionLog_Monster:
               _loc8_ = this.FHome.InteractionLogMonster;
               break;
            case TAB_InteractionLog_GirlFriend:
               _loc8_ = this.FHome.InteractionLogGirlFriend;
         }
         _loc7_ = SLogicsCore.PoolInteractionLog.Acquire();
         this.FUnstreamizerInteractionLog.Unstreamize(_loc5_,_loc7_,null);
         _loc8_.Add(_loc7_);
         _loc8_.Sort();
         _loc3_ = _loc8_.Count;
         _loc2_ = int(_loc3_ - 1);
         while(_loc2_ >= 0)
         {
            if(_loc2_ < CAPACITY_InteractionLog_Items)
            {
               break;
            }
            _loc8_.DeleteInteractionLogByIndex(_loc2_);
            _loc2_--;
         }
         if(this.FProcessorWindowInteractionLog.Visible)
         {
            this.FProcessorWindowInteractionLog.Update();
         }
      }
      
      protected function PerformPacket_SC_Home_GirlFriend(param1:TPacket) : void
      {
         this.FProcessorGirlFriend.PacketProcess(param1);
      }
      
      protected function PerformPacket_SC_Home_LuckyCatRet(param1:TPacket) : void
      {
         var _loc2_:int = 0;
         var _loc3_:ByteArray = null;
         var _loc4_:TConfigValue = null;
         var _loc5_:THomeFortune = null;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         _loc3_ = param1.Data;
         _loc2_ = int(_loc3_.readUnsignedInt());
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         ++this.FHome.LuckyCatCount;
         _loc7_ = _loc3_.readUnsignedInt();
         this.FHome.LuckyCatCD = _loc7_ - STimingCore.ServerTick;
         _loc4_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.LUCKYCAT_LIMIT_CD) as TConfigValue;
         _loc7_ = _loc4_.Value as uint;
         if(this.FHome.LuckyCatCD >= _loc7_)
         {
            this.FHome.LuckyCatCDLimit = true;
         }
         this.FProcessorWindowHome.PlayEffectLuckyCat();
         this.FProcessorWindowHome.UpdateLuckyCat();
         _loc5_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_HomeFortune,this.FCharacter.GetMainRebirthLevel()) as THomeFortune;
         _loc6_ = _loc5_.BaseMoney;
         EffectGenerateText(TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HOME_STRING_17),_loc6_));
      }
      
      protected function PerformPacket_SC_Home_ClearLuckyCatRet(param1:TPacket) : void
      {
         var _loc2_:int = 0;
         var _loc3_:ByteArray = null;
         _loc3_ = param1.Data;
         _loc2_ = int(_loc3_.readUnsignedInt());
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         this.FHome.LuckyCatCD = 0;
         this.FHome.LuckyCatCDLimit = false;
         this.FProcessorWindowHome.UpdateLuckyCat();
         EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HOME_STRING_18));
      }
      
      protected function PerformPacket_SC_Home_HZRet(param1:TPacket) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:ByteArray = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:Vector.<uint> = null;
         var _loc12_:Vector.<int> = null;
         var _loc13_:String = null;
         var _loc14_:uint = 0;
         var _loc15_:String = null;
         var _loc16_:int = 0;
         var _loc17_:int = 0;
         var _loc18_:TConfigValue = null;
         var _loc19_:int = 0;
         var _loc20_:TInventory = null;
         var _loc21_:uint = 0;
         _loc5_ = param1.Data;
         _loc4_ = int(_loc5_.readUnsignedInt());
         if(_loc4_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc4_);
            return;
         }
         _loc6_ = int(_loc5_.readUnsignedByte());
         _loc7_ = int(_loc5_.readUnsignedInt());
         _loc8_ = int(_loc5_.readUnsignedInt());
         if(_loc6_ == CONST_HOME.TYPE_AKeyMonster)
         {
            _loc11_ = new Vector.<uint>();
            _loc12_ = new Vector.<int>();
            _loc2_ = _loc5_.readShort();
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               _loc9_ = int(uint(_loc5_.readShort()));
               _loc10_ = int(uint(_loc5_.readUnsignedInt()));
               _loc12_.push(_loc5_.readUnsignedInt());
               _loc14_ = CONST_COMMON.RewardIDToTemplateID(_loc9_,_loc10_);
               if(_loc14_ > 0)
               {
                  _loc11_.push(_loc14_);
               }
               else
               {
                  _loc11_.push(_loc10_);
               }
               _loc3_++;
            }
            this.FInventories.Clear();
            if(_loc11_.length > 0)
            {
               this.FUnstreamizerInventoryReference.UnstreamizeGenerateInventoriesByIdentifiers(null,this.FInventories,_loc11_);
            }
            _loc16_ = int(_loc5_.readUnsignedByte());
            _loc17_ = int(_loc5_.readUnsignedByte());
         }
         if(_loc6_ == CONST_HOME.TYPE_SingleMonster)
         {
            if(this.FOnSetBattleStatus != null)
            {
               this.FOnSetBattleStatus(this,CONST_BATTLE.BattleType_SoulMonster,CONST_MUSIC.ID_SCENE_HomeMonster);
            }
            if(this.FOnEnterBattle != null)
            {
               this.FOnEnterBattle(this);
            }
            if(_loc7_ == this.FCharacter.Identifier0 && _loc8_ == this.FCharacter.Identifier1)
            {
               ++this.FHome.MyMonsterCount;
            }
            else
            {
               ++this.FHome.FriendMonsterCount;
            }
            this.FProcessorWindowHome.UpdateMonsterPanel();
         }
         else if(_loc6_ == CONST_HOME.TYPE_AKeyMonster)
         {
            _loc21_ = _loc16_ - this.FHome.MyMonsterCount + (_loc17_ - this.FHome.FriendMonsterCount);
            this.FHome.MyMonsterCount = _loc16_;
            this.FHome.FriendMonsterCount = _loc17_;
            _loc18_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_HOME.ONE_KEY_SOUL) as TConfigValue;
            _loc19_ = int(_loc18_.Value.value);
            _loc13_ = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HOME_STRING_23),_loc21_,_loc21_ * _loc19_) + "\n";
            this.FQueryCoordinate.Value.Reset();
            this.ProcessorOnQueryMonsterCoordinate(this.FQueryCoordinate);
            this.FCoordinateSource.Assign(this.FQueryCoordinate.Value);
            this.FQueryCoordinate.Value.Reset();
            this.ProcessorOnQueryCoordinateDestination(this,this.FQueryCoordinate);
            this.FCoordinateDestination.Assign(this.FQueryCoordinate.Value);
            _loc2_ = this.FInventories.Count;
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               _loc20_ = this.FInventories.GetInventoryByIndex(_loc3_);
               _loc13_ += _loc20_.Name + "*" + _loc12_[_loc3_] + "\n";
               this.ProcessorOnEffectAcquireInventory(this,_loc20_,this.FCoordinateSource,this.FCoordinateDestination);
               _loc3_++;
            }
            if(FOnEffectText != null)
            {
               FOnEffectText(this,_loc13_);
            }
            this.FProcessorWindowHome.UpdateMonsterPanel();
         }
      }
      
      protected function ProcessorHomeInfo(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         var _loc3_:THome = null;
         if(param1 == null)
         {
            return;
         }
         this.ProcessorLoadGirlFriend();
         _loc3_ = this.GetHomeByType(this.FHomeType);
         this.FUnstreamizerHome.Unstreamize(param1,_loc3_,null);
      }
      
      protected function ProcessorLoadGirlFriend() : void
      {
         this.FProcessorGirlFriend.RequestGirlBaseInfor();
      }
      
      protected function ProcessorOnQueryGirlfriendInteractiveCoordinate(param1:Object, param2:TQueryCoordinate) : void
      {
         this.FProcessorWindowHome.QueryGirlfriendInteractiveCoordinate(param2);
      }
      
      protected function ProcessorOnQueryMonsterCoordinate(param1:TQueryCoordinate) : void
      {
         this.FProcessorWindowHome.QueryMonsterCoordinate(param1);
      }
      
      protected function ProcessorOnQueryCoordinateDestination(param1:Object, param2:TQueryCoordinate) : void
      {
         this.FProcessorWindowHome.QueryCoordinateDestination(param2);
      }
      
      protected function ProcessorOnEffectAcquireInventory(param1:Object, param2:Object, param3:TCoordinate, param4:TCoordinate) : void
      {
         if(this.FEffectCoordinateParameters == null)
         {
            return;
         }
         this.FEffectCoordinateParameters.CoordinateSource.Assign(param3);
         this.FEffectCoordinateParameters.CoordinateDestination.Assign(param4);
         if(this.FOnEffectAcquireInventory != null)
         {
            this.FOnEffectAcquireInventory(param1,param2,this.FEffectCoordinateParameters);
         }
      }
      
      protected function ProcessorEnterHomeReq(param1:Object, param2:uint, param3:uint) : void
      {
         var _loc4_:TPacket = null;
         var _loc5_:ByteArray = null;
         var _loc6_:Boolean = false;
         var _loc7_:TFriendDigest = null;
         this.SetHomeType(param2,param3);
         _loc6_ = this.IsMyHome(param2,param3);
         if(!_loc6_)
         {
            _loc7_ = this.FFriendDigests.GetDigestByIdentifier(param2,param3);
            if(_loc7_ == null)
            {
               this.FFriendDigest.Coerce(param2,param3);
               this.FFriendDigest.Tag = CONST_FRIEND.TYPE_Whitelist_Add;
               this.FUIWindowConfirmation.Text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HOME_STRING_32);
               this.FUIWindowConfirmation.OnOK = this.WindowConfirmationOnOK;
               this.FUIWindowConfirmation.Visible = true;
               return;
            }
         }
         _loc4_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Enter_Home);
         _loc5_ = _loc4_.Data;
         _loc5_.writeUnsignedInt(param2);
         _loc5_.writeUnsignedInt(param3);
         SNetworkCore.Transceiver.PacketTransmit(_loc4_);
         this.FIdentifier0 = param2;
         this.FIdentifier1 = param3;
      }
      
      protected function ProcessorBattleOnHomeSoulReq(param1:int, param2:uint, param3:uint) : void
      {
         var _loc4_:TPacket = null;
         var _loc5_:ByteArray = null;
         _loc4_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Home_HZReq);
         _loc5_ = _loc4_.Data;
         _loc5_.writeByte(param1);
         _loc5_.writeUnsignedInt(param2);
         _loc5_.writeUnsignedInt(param3);
         SNetworkCore.Transceiver.PacketTransmit(_loc4_);
      }
      
      protected function ProcessorParameter() : void
      {
         if(this.FParameter < 0)
         {
            return;
         }
         switch(this.FParameter)
         {
            case CONST_SHORTCUTS.TYPE_Home_HellButterfly:
               SUtilityHyperLink.ShortcutHyperlink(TUtilityHyperLink.HyperLink_HellButterfly);
               break;
            case CONST_SHORTCUTS.TYPE_Home_Slave:
               SUtilityHyperLink.ShortcutHyperlink(TUtilityHyperLink.HyperLink_Slave);
         }
         this.FParameter = -1;
      }
      
      protected function ProcessorOnEffectSilverCoin(param1:Object, param2:TCoordinate) : void
      {
         var _loc3_:int = 0;
         var _loc4_:uint = 0;
         if(this.FOnEffectSilverCoin != null)
         {
            this.FEffectCoordinateParameters.CoordinateSource.Assign(param2);
            _loc3_ = this.FHome.Level * 2 + 1;
            _loc4_ = TUtilityMath.RandomRange(_loc3_,_loc3_ + 5);
            this.FOnEffectSilverCoin(this,_loc4_,this.FEffectCoordinateParameters);
         }
      }
      
      protected function SetHomeType(param1:uint, param2:uint) : void
      {
         if(param1 == this.FCharacter.Identifier0 && param2 == this.FCharacter.Identifier1)
         {
            this.FHomeType = CONST_HOME.TYPE_HOME_MySelf;
         }
         else
         {
            this.FHomeType = CONST_HOME.TYPE_HOME_Friend;
         }
      }
      
      protected function IsMyHome(param1:uint, param2:uint) : Boolean
      {
         var _loc3_:Boolean = false;
         if(param1 == this.FCharacter.Identifier0 && param2 == this.FCharacter.Identifier1)
         {
            _loc3_ = true;
         }
         else
         {
            _loc3_ = false;
         }
         return _loc3_;
      }
      
      protected function GetHomeByType(param1:uint) : THome
      {
         var _loc2_:THome = null;
         switch(param1)
         {
            case CONST_HOME.TYPE_HOME_MySelf:
               _loc2_ = this.FHome;
               break;
            default:
               _loc2_ = this.FHomeFriend;
         }
         return _loc2_;
      }
      
      protected function ProcessorWindowHomeOnClose(param1:Object) : void
      {
         this.FIdentifier0 = this.FCharacter.Identifier0;
         this.FIdentifier1 = this.FCharacter.Identifier1;
         if(this.FOnEnterTown != null)
         {
            this.FOnEnterTown(param1);
         }
      }
      
      protected function ProcessorWindowHomeHallOnClose(param1:Object) : void
      {
         BarrierDeactuate(this.FProcessorWindowHomeHall);
         this.FProcessorWindowHomeHall.Reset();
         TutorialNextStep(CONST_FRESHGUIDE.EVENTID_CloseHomeUpgradeView);
      }
      
      protected function ProcessorWindowInteractionLogOnClose(param1:Object) : void
      {
         BarrierDeactuate(this.FProcessorWindowInteractionLog);
      }
      
      protected function UIComponentOnOverlayOnOut(param1:Object, param2:Object) : void
      {
         var _loc3_:TLuckyCat = null;
         var _loc4_:THomeSoul = null;
         var _loc5_:TOverlayer = null;
         if(param2 == null)
         {
            return;
         }
         if(param2 is TLuckyCat)
         {
            _loc5_ = this.FOverlayerLuckyCat;
         }
         else if(param2 is THomeSoul)
         {
            _loc5_ = this.FOverlayerHomeSoul;
         }
         else if(param2 is THome)
         {
            _loc5_ = this.FOverlayerHomeInteractive;
         }
         _loc5_.Hide();
      }
      
      protected function UIComponentOnOverlayOnMove(param1:Object, param2:Object) : void
      {
         var _loc3_:THome = null;
         var _loc4_:TLuckyCat = null;
         var _loc5_:THomeSoul = null;
         var _loc6_:TOverlayer = null;
         if(param2 == null)
         {
            return;
         }
         if(param2 is TLuckyCat)
         {
            _loc6_ = this.FOverlayerLuckyCat;
         }
         else if(param2 is THomeSoul)
         {
            _loc6_ = this.FOverlayerHomeSoul;
         }
         else if(param2 is THome)
         {
            _loc6_ = this.FOverlayerHomeInteractive;
         }
         _loc6_.Context = param2;
         _loc6_.Render(FUICore.MouseCoordinate);
         _loc6_.Show();
      }
      
      protected function ProcessorOnHomeHall(param1:Object) : void
      {
         BarrierActuate(this.FProcessorWindowHomeHall);
         this.FProcessorWindowHomeHall.Update();
         this.FProcessorWindowHomeHall.Visible = true;
         TutorialNextStep(CONST_FRESHGUIDE.EVENTID_OpenHomeUpgradeView);
      }
      
      protected function ProcessorOnMonster(param1:Object, param2:uint) : void
      {
         var _loc3_:THome = null;
         var _loc4_:int = 0;
         var _loc5_:THome = null;
         _loc3_ = this.GetHomeByType(this.FHomeType);
         if(param2 == CONST_HOME.TYPE_SingleMonster)
         {
            _loc4_ = 0;
         }
         else if(param2 == CONST_HOME.TYPE_AKeyMonster)
         {
            _loc4_ = 1;
         }
         this.ProcessorBattleOnHomeSoulReq(_loc4_,_loc3_.Identifier0,_loc3_.Identifier1);
      }
      
      protected function ProcessorOnUpdateGirlFriend(param1:Object) : void
      {
         if(this.FProcessorWindowHome.Visible)
         {
            this.FProcessorWindowHome.UpdateGirlFriend();
         }
      }
      
      protected function ProcessorOnClearCD(param1:Object) : void
      {
         var _loc2_:TPacket = null;
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Home_ClearLuckyCatReq);
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
      }
      
      protected function ProcessorOnLuckyCat(param1:Object) : void
      {
         var _loc2_:TPacket = null;
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Home_LuckyCatReq);
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
      }
      
      protected function OpenGirlFriendWindow(param1:Object, param2:int = 0) : void
      {
         var _loc3_:ByteArray = null;
         _loc3_ = new ByteArray();
         _loc3_.writeInt(TProcessorGirlFriend.WINDOWID_GIRLFRIEND_BASEINFOR);
         _loc3_.writeInt(param2);
         _loc3_.position = 0;
         this.FProcessorGirlFriend.Mount(_loc3_);
         this.FProcessorGirlFriend.visible = true;
      }
      
      protected function OpenGirlFriendUpgradeWindow(param1:Object) : void
      {
         var _loc2_:ByteArray = null;
         _loc2_ = new ByteArray();
         _loc2_.writeInt(TProcessorGirlFriend.WINDOWID_GIRLFRIEND_UPGRADE);
         _loc2_.position = 0;
         this.FProcessorGirlFriend.Mount(_loc2_);
         this.FProcessorGirlFriend.visible = true;
      }
      
      protected function ProcessorOnInteractionLog(param1:Object) : void
      {
         this.FProcessorWindowInteractionLog.RequestInteractionLog();
         this.FProcessorWindowInteractionLog.Update();
         BarrierActuate(this.FProcessorWindowInteractionLog);
         this.FProcessorWindowInteractionLog.Visible = true;
      }
      
      protected function WindowConfirmationOnOK(param1:Object) : void
      {
         if(this.FOnAddFriend != null)
         {
            this.FOnAddFriend(this,this.FFriendDigest.Tag,this.FFriendDigest);
         }
      }
      
      public function set OnEnterTown(param1:Function) : void
      {
         this.FOnEnterTown = param1;
      }
      
      public function get OnEnterTown() : Function
      {
         return this.FOnEnterTown;
      }
      
      public function get OnSetBattleStatus() : Function
      {
         return this.FOnSetBattleStatus;
      }
      
      public function set OnSetBattleStatus(param1:Function) : void
      {
         this.FOnSetBattleStatus = param1;
      }
      
      public function get OnEnterBattle() : Function
      {
         return this.FOnEnterBattle;
      }
      
      public function set OnEnterBattle(param1:Function) : void
      {
         this.FOnEnterBattle = param1;
      }
      
      public function get OnHomeResetNtf() : Function
      {
         return this.FOnHomeResetNtf;
      }
      
      public function set OnHomeResetNtf(param1:Function) : void
      {
         this.FOnHomeResetNtf = param1;
      }
      
      public function get OnAddFriend() : Function
      {
         return this.FOnAddFriend;
      }
      
      public function set OnAddFriend(param1:Function) : void
      {
         this.FOnAddFriend = param1;
      }
      
      public function get OnEffectSilverCoin() : Function
      {
         return this.FOnEffectSilverCoin;
      }
      
      public function set OnEffectSilverCoin(param1:Function) : void
      {
         this.FOnEffectSilverCoin = param1;
      }
      
      public function get OnEffectAcquireInventory() : Function
      {
         return this.FOnEffectAcquireInventory;
      }
      
      public function set OnEffectAcquireInventory(param1:Function) : void
      {
         this.FOnEffectAcquireInventory = param1;
      }
      
      override public function Mount(param1:ByteArray = null) : void
      {
         super.Mount();
         if(param1 != null)
         {
            this.ProcessorHomeInfo(param1);
         }
         if(!FIsResourcesLoadCompleted)
         {
            this.FProcessorWindowHome.Load();
            this.FProcessorWindowHomeHall.Load();
            this.FProcessorWindowInteractionLog.Load();
            return;
         }
         this.FProcessorWindowHome.Update(this.FHomeType);
         this.FProcessorWindowHome.Visible = true;
         this.ProcessorParameter();
         MusicPlayNext(CONST_SIGNAL.SIGNALDESTINATION_SOUND,CONST_MUSIC.PLAY_SCENE_HomeMonster,CONST_MUSIC.ID_SCENE_HomeMonster,false);
         TutorialNextStep(CONST_FRESHGUIDE.EVENTID_OpenHome);
         this.FCharacter.RoleSencePosition = CONST_COMMON.SCENEPOSITION_HOME;
      }
      
      override public function Unmount() : void
      {
         this.FProcessorWindowHome.Reset();
         this.FProcessorGirlFriend.Reset();
         super.Unmount();
         TutorialNextStep(CONST_FRESHGUIDE.EVENTID_CloseHome);
      }
      
      public function EnterHomeReq(param1:ByteArray) : void
      {
         if(param1 != null)
         {
            this.FParameter = param1.readUnsignedInt();
         }
         if(!this.FIsFirst)
         {
            this.FIdentifier0 = this.FCharacter.Identifier0;
            this.FIdentifier1 = this.FCharacter.Identifier1;
            this.FIsFirst = true;
         }
         this.ProcessorEnterHomeReq(this,this.FIdentifier0,this.FIdentifier1);
      }
      
      public function ProcessFriendNtf(param1:Object, param2:Object) : void
      {
         var _loc3_:TFriendDigest = null;
         _loc3_ = param2 as TFriendDigest;
         if(this.FFriendDigest.Identifier0 == _loc3_.Identifier0 && this.FFriendDigest.Identifier1 == _loc3_.Identifier1)
         {
            this.ProcessorEnterHomeReq(this,this.FFriendDigest.Identifier0,this.FFriendDigest.Identifier1);
            this.FFriendDigest.Reset();
         }
      }
      
      public function OpenGirlWindowByTabIndex(param1:int) : void
      {
         this.OpenGirlFriendWindow(this,param1);
      }
   }
}

