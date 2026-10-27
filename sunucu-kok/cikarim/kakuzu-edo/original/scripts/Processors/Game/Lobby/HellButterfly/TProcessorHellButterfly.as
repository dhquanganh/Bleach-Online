package Processors.Game.Lobby.HellButterfly
{
   import Components.Standard.*;
   import Foundation.Common.*;
   import Foundation.Network.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Bins.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.Characters.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.HellButterfly.*;
   import Logics.Streamization.HellButterfly.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Utilities.*;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Rendering.Overlayers.Hints.*;
   import Resources.Constants.*;
   import Resources.Strings.*;
   import Utilities.UI.Overlayers.*;
   import flash.events.*;
   import flash.utils.*;
   
   public class TProcessorHellButterfly extends TProcessorLobbyWindows
   {
      
      protected static const SIZE_WIDTH_HellButterfly:int = 658;
      
      protected static const SIZE_HEIGHT_HellButterfly:int = 396;
      
      protected static const SIZE_WIDTH_CLOSEFRIEND:int = 410;
      
      protected static const SIZE_HEIGHT_CLOSEFRIEND:int = 396;
      
      protected static const EAT_ONCE:uint = 0;
      
      protected static const EAT_FRIEND:uint = 1;
      
      protected static const EAT_FAMILY:uint = 2;
      
      protected static const COMMUNICATION_ONCE:uint = 0;
      
      protected static const COMMUNICATION_BATCH:uint = 1;
      
      protected static const LIMIT_COUNT:uint = 3;
      
      protected static const FRIEND_TYPE:uint = 1;
      
      protected var FProcessorWindowHellButterfly:TProcessorWindowHellButterfly;
      
      protected var FBoundsHellButterfly:TBounds;
      
      protected var FBoundsCloseFriend:TBounds;
      
      protected var FCharacter:TCharacter;
      
      protected var FHellButterflyData:THellButterfly;
      
      protected var FFriendDigests:TFriendDigests;
      
      protected var FSameOrganization:TFriendDigests;
      
      protected var FUnstreamizerHellButterfly:TUnstreamizerHellButterfly;
      
      protected var FIsInitialization:Boolean = true;
      
      protected var FButterflyFeeding:TBins;
      
      public function TProcessorHellButterfly(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,param2);
         this.FProcessorWindowHellButterfly = new TProcessorWindowHellButterfly(this);
         this.FProcessorWindowHellButterfly.OnClose = this.ProcessorOnClose;
         this.FProcessorWindowHellButterfly.OnEffectText = ProcessorsOnEffectText;
         this.FProcessorWindowHellButterfly.OnCommunication = this.OnCommunication;
         this.FProcessorWindowHellButterfly.OnEat = this.OnEat;
         this.FProcessorWindowHellButterfly.OnCollection = this.OnCollection;
         this.FProcessorWindowHellButterfly.OnEnterFriend = this.BaseDataReq;
         this.FProcessorWindowHellButterfly.OnBackMyself = this.OnBackMyself;
         this.FProcessorWindowHellButterfly.OnSetScence = this.ShowScence;
         this.FProcessorWindowHellButterfly.OnBTMove = this.OnBTMove;
         this.FProcessorWindowHellButterfly.OnBTOut = this.OnBTOut;
         this.FBoundsHellButterfly = new TBounds();
         this.FBoundsHellButterfly.Width = SIZE_WIDTH_HellButterfly;
         this.FBoundsHellButterfly.Height = SIZE_HEIGHT_HellButterfly;
         this.FBoundsCloseFriend = new TBounds();
         this.FBoundsCloseFriend.Width = SIZE_WIDTH_CLOSEFRIEND;
         this.FBoundsCloseFriend.Height = SIZE_HEIGHT_CLOSEFRIEND;
         this.ShowScence(true);
         this.FSameOrganization = this.FProcessorWindowHellButterfly.SameOrganizationFriendDigests;
         this.FCharacter = SLogicsCore.Character;
         this.FHellButterflyData = SLogicsCore.HellButterfly;
         this.FFriendDigests = new TFriendDigests();
         this.FUnstreamizerHellButterfly = new TUnstreamizerHellButterfly();
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_HELLBUTTERFLY.RESOURCESID_HELLBUTTERFLY);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         super.ResourcesPerform_UILocations();
      }
      
      override protected function PacketRegisterRoutines() : void
      {
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_HellButterfly_BaseDataRet,this.PerformPacket_SC_HellButterfly_BaseDataRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_HellButterfly_EatRet,this.PerformPacket_SC_HellButterfly_EatRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_HellButterfly_ExchangeRet,this.PerformPacket_SC_HellButterfly_ExchangeRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_HellButterfly_HellPowderRewardRet,this.PerformPacket_SC_HellButterfly_HellPowderRewardRet);
      }
      
      private function ShowScence(param1:Boolean) : void
      {
         if(param1)
         {
            ComponentBoundsCenter(this.FProcessorWindowHellButterfly,this.FBoundsHellButterfly);
         }
         else
         {
            ComponentBoundsCenter(this.FProcessorWindowHellButterfly,this.FBoundsCloseFriend);
         }
      }
      
      private function PerformPacket_SC_HellButterfly_HellPowderRewardRet(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:ByteArray = null;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:TButterflyFeeding = null;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         this.FProcessorWindowHellButterfly.SetBTState(true);
         _loc3_ = param1.Data;
         _loc2_ = _loc3_.readUnsignedInt();
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         if(this.FButterflyFeeding == null)
         {
            this.FButterflyFeeding = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_ButterflyFeeding);
         }
         _loc7_ = uint(this.FButterflyFeeding.Count);
         _loc8_ = 0;
         while(_loc8_ < _loc7_)
         {
            _loc6_ = this.FButterflyFeeding.GetDatebaseByIndex(_loc8_) as TButterflyFeeding;
            if(_loc6_.VipLevel == this.FCharacter.VipLevel && _loc6_.PowderLevel == this.FHellButterflyData.CollectionLevel)
            {
               break;
            }
            _loc8_++;
         }
         _loc4_ = TUtilityLobby.GetItemName(_loc6_.ButterflyRewards.Type[0],_loc6_.ButterflyRewards.Code[0]);
         _loc4_ = _loc4_ + "+" + _loc6_.ButterflyRewards.Amount[0];
         if(this.FCharacter.VipLevel != 0)
         {
            _loc5_ = TUtilityLobby.GetItemName(_loc6_.ButterflyRewards.Type[1],_loc6_.ButterflyRewards.Code[1]);
            _loc4_ += "\n" + _loc5_ + "+" + _loc6_.ButterflyRewards.Amount[1];
         }
         EffectGenerateText(_loc4_);
         this.FProcessorWindowHellButterfly.UpdateFeeding();
      }
      
      private function PerformPacket_SC_HellButterfly_EatRet(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:ByteArray = null;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:String = null;
         var _loc9_:TFriendDigest = null;
         var _loc10_:uint = 0;
         var _loc11_:uint = 0;
         var _loc12_:uint = 0;
         var _loc13_:uint = 0;
         var _loc14_:Boolean = false;
         this.FProcessorWindowHellButterfly.SetBTState(true);
         _loc3_ = param1.Data;
         _loc2_ = _loc3_.readUnsignedInt();
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         _loc10_ = _loc3_.readUnsignedInt();
         _loc11_ = _loc3_.readUnsignedInt();
         if(_loc10_ == this.FCharacter.Identifier0 && _loc11_ == this.FCharacter.Identifier1)
         {
            _loc14_ = true;
         }
         else
         {
            _loc14_ = false;
         }
         _loc4_ = _loc3_.readUnsignedByte();
         _loc5_ = _loc3_.readUnsignedInt();
         if(_loc4_ == EAT_ONCE)
         {
            this.FHellButterflyData.CurExp = _loc3_.readUnsignedInt();
            this.FHellButterflyData.Level = _loc3_.readUnsignedByte();
            _loc7_ = _loc3_.readUnsignedInt();
         }
         else
         {
            _loc13_ = _loc3_.readUnsignedInt();
         }
         if(_loc4_ == EAT_ONCE)
         {
            if(this.FHellButterflyData.IsMyself)
            {
               _loc8_ = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HELLBUTTERFLY_STRING_12),_loc5_,_loc7_);
               --this.FHellButterflyData.EatCount;
            }
            else
            {
               if(_loc5_ != 0)
               {
                  _loc8_ = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HELLBUTTERFLY_STRING_13),_loc5_);
               }
               else
               {
                  _loc8_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HELLBUTTERFLY_STRING_23);
               }
               _loc9_ = this.FFriendDigests.GetDigestByIdentifier(_loc10_,_loc11_);
               _loc9_.SendGoodOrNot = true;
            }
         }
         else
         {
            if(_loc4_ == EAT_FRIEND)
            {
               _loc6_ = uint(this.FFriendDigests.Count);
               _loc12_ = 0;
               while(_loc12_ < _loc6_)
               {
                  _loc9_ = this.FFriendDigests.GetDigestByIndex(_loc12_);
                  _loc9_.SendGoodOrNot = true;
                  _loc12_++;
               }
            }
            else if(_loc4_ == EAT_FAMILY)
            {
               _loc6_ = uint(this.FSameOrganization.Count);
               _loc12_ = 0;
               while(_loc12_ < _loc6_)
               {
                  _loc9_ = this.FSameOrganization.GetDigestByIndex(_loc12_);
                  _loc9_.SendGoodOrNot = true;
                  _loc12_++;
               }
            }
            if(_loc5_ == 0)
            {
               _loc8_ = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HELLBUTTERFLY_STRING_15),_loc13_);
            }
            else
            {
               _loc8_ = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HELLBUTTERFLY_STRING_14),_loc13_,_loc5_);
            }
            if(!this.FHellButterflyData.IsMyself)
            {
               this.BaseDataReq(this.FHellButterflyData.NowIdentifier0,this.FHellButterflyData.NowIdentifier1);
            }
         }
         this.FProcessorWindowHellButterfly.UpdateEat(_loc4_,_loc14_);
         EffectGenerateText(_loc8_);
      }
      
      private function PerformPacket_SC_HellButterfly_ExchangeRet(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:ByteArray = null;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:String = null;
         this.FProcessorWindowHellButterfly.SetBTState(true);
         _loc3_ = param1.Data;
         _loc2_ = _loc3_.readUnsignedInt();
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         _loc4_ = _loc3_.readUnsignedByte();
         _loc5_ = _loc3_.readUnsignedInt();
         _loc6_ = _loc3_.readUnsignedInt();
         this.FProcessorWindowHellButterfly.UpdateCurCount(_loc4_);
         if(_loc4_ == COMMUNICATION_ONCE)
         {
            _loc7_ = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HELLBUTTERFLY_STRING_10),_loc5_);
         }
         else
         {
            _loc7_ = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HELLBUTTERFLY_STRING_11),_loc6_,_loc5_);
         }
         EffectGenerateText(_loc7_);
      }
      
      private function PerformPacket_SC_HellButterfly_BaseDataRet(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:ByteArray = null;
         this.FProcessorWindowHellButterfly.SetBTState(true);
         _loc3_ = param1.Data;
         _loc2_ = _loc3_.readUnsignedInt();
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         this.FUnstreamizerHellButterfly.Unstreamize(_loc3_,this.FHellButterflyData,this.FFriendDigests);
         this.FProcessorWindowHellButterfly.Init(this.FFriendDigests);
      }
      
      protected function ProcessorOnClose(param1:Object) : void
      {
         ProcessorClose();
      }
      
      private function SetFriends() : void
      {
         var _loc1_:TFriendDigest = null;
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         this.FFriendDigests.Clear();
         _loc3_ = uint(SLogicsCore.Friends.Count);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc1_ = SLogicsCore.Friends.GetDigestByIndex(_loc2_);
            if(_loc1_.Type == FRIEND_TYPE)
            {
               this.FFriendDigests.Add(_loc1_);
            }
            _loc2_++;
         }
         this.FFriendDigests.SortLevel();
      }
      
      private function OnBackMyself(param1:uint, param2:uint) : void
      {
         this.BaseDataReq(param1,param2);
      }
      
      private function BaseDataReq(param1:uint, param2:uint) : void
      {
         var _loc3_:TPacket = null;
         var _loc4_:ByteArray = null;
         _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_HellButterfly_BaseDataReq);
         _loc4_ = _loc3_.Data;
         _loc4_.writeUnsignedInt(param1);
         _loc4_.writeUnsignedInt(param2);
         SNetworkCore.Transceiver.PacketTransmit(_loc3_);
         this.FProcessorWindowHellButterfly.SetBTState(false);
      }
      
      private function OnCommunication(param1:int) : void
      {
         var _loc2_:TPacket = null;
         var _loc3_:ByteArray = null;
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_HellButterfly_ExchangeReq);
         _loc3_ = _loc2_.Data;
         _loc3_.writeByte(param1);
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
         this.FProcessorWindowHellButterfly.SetBTState(false);
      }
      
      private function OnEat(param1:uint, param2:uint, param3:uint) : void
      {
         var _loc4_:TPacket = null;
         var _loc5_:ByteArray = null;
         _loc4_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_HellButterfly_EatReq);
         _loc5_ = _loc4_.Data;
         _loc5_.writeByte(param1);
         _loc5_.writeUnsignedInt(param2);
         _loc5_.writeUnsignedInt(param3);
         SNetworkCore.Transceiver.PacketTransmit(_loc4_);
         this.FProcessorWindowHellButterfly.SetBTState(false);
      }
      
      private function OnCollection() : void
      {
         var _loc1_:TPacket = null;
         var _loc2_:ByteArray = null;
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_HellButterfly_HellPowderRewardReq);
         SNetworkCore.Transceiver.PacketTransmit(_loc1_);
         this.FProcessorWindowHellButterfly.SetBTState(false);
      }
      
      private function OnBTMove(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TUIButton = null;
         _loc3_ = param1 as TUIButton;
         SUtilityOverLayer.UIComponentsHintOnOver(this,_loc3_.Hint);
      }
      
      private function OnBTOut(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TUIButton = null;
         _loc3_ = param1 as TUIButton;
         SUtilityOverLayer.UIComponentsHintOnOut(this,_loc3_.Hint);
      }
      
      override public function Mount(param1:ByteArray = null) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TFriendDigest = null;
         var _loc5_:uint = 0;
         super.Mount();
         if(!FIsResourcesLoadCompleted)
         {
            this.FProcessorWindowHellButterfly.Load();
            return;
         }
         this.SetFriends();
         this.BaseDataReq(this.FCharacter.Identifier0,this.FCharacter.Identifier1);
         this.FProcessorWindowHellButterfly.Visible = true;
         this.FProcessorWindowHellButterfly.PlayEffect(true);
         TutorialNextStep(CONST_FRESHGUIDE.EVENTID_OpenHellBufferFly);
      }
      
      override public function Unmount() : void
      {
         this.FFriendDigests.Clear();
         this.FProcessorWindowHellButterfly.Reset();
         this.FProcessorWindowHellButterfly.PlayEffect(false);
         TutorialNextStep(CONST_FRESHGUIDE.EVENTID_CloseHellBufferFly);
      }
   }
}

