package Processors.Game.Lobby.HeroChange
{
   import Foundation.Common.*;
   import Foundation.Network.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Bins.*;
   import Foundation.UI.*;
   import Logics.*;
   import Logics.Characters.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.HeroChange.*;
   import Logics.Inventories.*;
   import Logics.Streamization.Characters.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.EffectTextReward.*;
   import Resources.Constants.*;
   import Resources.Strings.*;
   import flash.utils.*;
   import ghostcat.util.data.Json;
   
   public class TProcessorHeroChange extends TProcessorLobbyWindows
   {
      
      protected static var WINDOW_WIDTH:int = 823;
      
      protected static var WINDOW_HEIGTH:int = 528;
      
      protected var FBounds:TBounds;
      
      protected var FProcessorWindowHeroChangeMainUI:TProcessorWindowHeroChangeMainUI;
      
      protected var FUnstreamizerCharacter:TUnstreamizerCharacter;
      
      protected var FHeros:THeros;
      
      protected var FHeroChangeData:THeroChangeData;
      
      protected var FHeroChangeVec:Vector.<THeroChange>;
      
      protected var FOnInitBattle:Function;
      
      protected var FOnSetBattleStatus:Function;
      
      public function TProcessorHeroChange(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,param2);
         this.FBounds = new TBounds();
         this.FBounds.Width = WINDOW_WIDTH;
         this.FBounds.Height = WINDOW_HEIGTH;
         this.FUnstreamizerCharacter = new TUnstreamizerCharacter();
         this.FHeroChangeData = SLogicsCore.HeroChangeData;
         this.FProcessorWindowHeroChangeMainUI = new TProcessorWindowHeroChangeMainUI(this);
         this.FProcessorWindowHeroChangeMainUI.HeroChangeData = this.FHeroChangeData;
         this.FProcessorWindowHeroChangeMainUI.OnClose = this.ShutDownWindows;
         this.FHeroChangeVec = new Vector.<THeroChange>();
         ComponentBoundsCenter(this.FProcessorWindowHeroChangeMainUI,this.FBounds);
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_HEROCHANGE.RESOURCESID_HEROCHANGE);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:TInventories = null;
         _loc1_ = new TInventories();
         _loc1_.Clear();
         SToolReward.GetInventoryByID(CONST_HEROCHANGE.NormalPillID,_loc1_);
         this.FHeroChangeData.NormalSoulPillInventory = _loc1_.GetInventoryByIndex(0);
         this.FHeroChangeData.NormalSoulPillInventory.StubReferences.Reference(this.FHeroChangeData);
         _loc1_.Clear();
         SToolReward.GetInventoryByID(CONST_HEROCHANGE.GradePillID,_loc1_);
         this.FHeroChangeData.GradeSoulPillInventory = _loc1_.GetInventoryByIndex(0);
         this.FHeroChangeData.GradeSoulPillInventory.StubReferences.Reference(this.FHeroChangeData);
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         super.ResourcesPerform_UILocations();
      }
      
      override protected function PacketRegisterRoutines() : void
      {
         FPacketRoutines.Register(18378622,this.StarInfoRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_HeroChange_InforRet,this.PacketPerform_HeroChange_InforRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_HeroChange_ChangeRet,this.PacketPerform_HeroChange_ChangeRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_HeroChange_MakePillRet,this.PacketPerform_HeroChange_MakePillRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_HeroChange_ExchangePillRet,this.PacketPerform_HeroChange_ExchangePillRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_HeroChange_UpdateCommonMaterial,this.PacketPerform_HeroChange_UpdateCommonMaterial);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_HeroChange_UpdateSpecilMaterial,this.PacketPerform_HeroChange_UpdateSpecilMaterial);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_HeroChange_BuyIntoTimeRet,this.PacketPerform_HeroChange_BuyIntoTimeRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_HeroChange_ResetRet,this.PacketPerform_HeroChange_ResetRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_HeroChange_ReliveRet,this.PacketPerform_HeroChange_ReliveRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_HeroChange_FightRet,this.PacketPerform_HeroChange_FightRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_HeroChange_OneKeyRet,this.PacketPerform_HeroChange_OneKeyRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_HeroChange_AdvanceRefresh,this.PacketPerform_HeroChange_AdvanceRefreshRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_HeroChange_AdvanceReturn,this.PacketPerform_HeroChange_AdvanceReturnRet);
      }
      
      protected function PacketPerform_HeroChange_InforRet(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:THeroChange = null;
         var _loc6_:uint = 0;
         var _loc7_:int = 0;
         _loc2_ = param1.Data;
         this.FHeroChangeData.PowerfulChip = _loc2_.readUnsignedInt();
         this.FHeroChangeData.NormalSoulPillNum = _loc2_.readUnsignedInt();
         this.FHeroChangeData.GradeSoulPillNum = _loc2_.readUnsignedInt();
         this.FHeroChangeData.FightTime = _loc2_.readUnsignedInt();
         this.FHeroChangeData.BuyTime = _loc2_.readUnsignedInt();
         _loc3_ = _loc2_.readShort();
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            _loc6_ = _loc2_.readUnsignedInt();
            this.FHeroChangeVec.length = 0;
            this.FHeroChangeData.GetHeroChangeByChipID(_loc6_,this.FHeroChangeVec);
            this.SetHeroChipNum(this.FHeroChangeVec,_loc2_.readUnsignedInt());
            _loc4_++;
         }
         _loc3_ = _loc2_.readShort();
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            _loc7_ = _loc2_.readInt();
            _loc5_ = this.FHeroChangeData.GetHeroChangeByCityID(_loc7_);
            _loc5_.CurrentResetTime = _loc2_.readInt();
            _loc5_.CurrentMonsterNum = _loc2_.readInt();
            _loc5_.CurrentReliveTime = _loc2_.readInt();
            _loc5_.CurrentDieTime = _loc2_.readInt();
            _loc5_.HighestRecord = _loc2_.readInt();
            _loc4_++;
         }
         this.FHeroChangeData.Init = true;
         if(Visible)
         {
            this.FProcessorWindowHeroChangeMainUI.Show();
         }
      }
      
      protected function PacketPerform_HeroChange_ChangeRet(param1:TPacket) : void
      {
         var _loc2_:int = 0;
         var _loc3_:uint = 0;
         var _loc4_:THeroChange = null;
         var _loc5_:THero = null;
         _loc2_ = param1.Data.readInt();
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         _loc3_ = param1.Data.readUnsignedInt();
         _loc4_ = this.FHeroChangeData.GetHeroChangeByHeroID(_loc3_);
         _loc4_.Hero.ChangeSchedule = param1.Data.readUnsignedInt();
         _loc5_ = SLogicsCore.Character.Heros.GetHeroByIdentifier(_loc3_);
         if(_loc5_ != null)
         {
            _loc5_.ChangeSchedule = _loc4_.Hero.ChangeSchedule;
         }
         this.FProcessorWindowHeroChangeMainUI.ChangeNotify();
         EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_HeroChange_01));
      }
      
      protected function PacketPerform_HeroChange_MakePillRet(param1:TPacket) : void
      {
         var _loc2_:int = 0;
         _loc2_ = param1.Data.readInt();
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         SToolReward.ShowReward(param1.Data);
         this.FProcessorWindowHeroChangeMainUI.MakePillNotify();
      }
      
      protected function PacketPerform_HeroChange_ExchangePillRet(param1:TPacket) : void
      {
         var _loc2_:int = 0;
         _loc2_ = param1.Data.readInt();
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         this.FProcessorWindowHeroChangeMainUI.ExchangePillNotify();
         EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_HeroChange_02));
      }
      
      protected function PacketPerform_HeroChange_UpdateCommonMaterial(param1:TPacket) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         _loc2_ = int(param1.Data.readUnsignedInt());
         _loc3_ = int(param1.Data.readUnsignedInt());
         switch(_loc2_)
         {
            case CONST_HEROCHANGE.CHIPTYPE_PowerfulChip:
               this.FHeroChangeData.PowerfulChip = _loc3_;
               break;
            case CONST_HEROCHANGE.CHIPTYPE_NormalPill:
               this.FHeroChangeData.NormalSoulPillNum = _loc3_;
               break;
            case CONST_HEROCHANGE.CHIPTYPE_GradePill:
               this.FHeroChangeData.GradeSoulPillNum = _loc3_;
         }
         this.FProcessorWindowHeroChangeMainUI.CommonMaterialUpdateNotify();
      }
      
      protected function PacketPerform_HeroChange_UpdateSpecilMaterial(param1:TPacket) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:THeroChange = null;
         _loc2_ = int(param1.Data.readUnsignedInt());
         _loc3_ = int(param1.Data.readUnsignedInt());
         this.FHeroChangeVec.length = 0;
         this.FHeroChangeData.GetHeroChangeByChipID(_loc2_,this.FHeroChangeVec);
         this.SetHeroChipNum(this.FHeroChangeVec,_loc3_);
         this.FProcessorWindowHeroChangeMainUI.GradeMaterialUpdateNotify();
      }
      
      protected function PacketPerform_HeroChange_BuyIntoTimeRet(param1:TPacket) : void
      {
         var _loc2_:int = 0;
         _loc2_ = param1.Data.readInt();
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         ++this.FHeroChangeData.BuyTime;
         this.FProcessorWindowHeroChangeMainUI.BuyTimeNotify();
         EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_HeroChange_03));
      }
      
      protected function PacketPerform_HeroChange_ResetRet(param1:TPacket) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:THeroChange = null;
         _loc2_ = param1.Data.readInt();
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         _loc3_ = param1.Data.readInt();
         _loc4_ = this.FHeroChangeData.GetHeroChangeByHeroID(_loc3_);
         ++_loc4_.CurrentResetTime;
         _loc4_.CurrentMonsterNum = 0;
         EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_HeroChange_04));
      }
      
      protected function PacketPerform_HeroChange_ReliveRet(param1:TPacket) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:THeroChange = null;
         _loc2_ = param1.Data.readInt();
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         _loc3_ = param1.Data.readInt();
         _loc4_ = this.FHeroChangeData.GetHeroChangeByHeroID(_loc3_);
         ++_loc4_.CurrentReliveTime;
         this.FProcessorWindowHeroChangeMainUI.ReliveNotify();
         EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_HeroChange_05));
      }
      
      protected function PacketPerform_HeroChange_FightRet(param1:TPacket) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:THeroChange = null;
         _loc2_ = param1.Data.readInt();
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         if(this.FOnSetBattleStatus != null)
         {
            this.FOnSetBattleStatus(this,CONST_BATTLE.BattleType_HeroChange,this.FHeroChangeData.CurrentBattleID);
         }
         if(this.FOnInitBattle != null)
         {
            this.FOnInitBattle(this);
         }
         _loc3_ = param1.Data.readInt();
         _loc4_ = this.FHeroChangeData.GetHeroChangeByHeroID(_loc3_);
         this.FHeroChangeData.FightTime = param1.Data.readInt();
      }
      
      protected function PacketPerform_HeroChange_OneKeyRet(param1:TPacket) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:THeroChange = null;
         var _loc5_:int = 0;
         _loc2_ = param1.Data.readInt();
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         _loc3_ = param1.Data.readInt();
         _loc4_ = this.FHeroChangeData.GetHeroChangeByHeroID(_loc3_);
         _loc5_ = _loc4_.HighestRecord;
         _loc4_.CurrentMonsterNum = _loc5_;
         this.FHeroChangeData.FightTime = param1.Data.readInt();
         SToolReward.ShowReward(param1.Data);
         this.FProcessorWindowHeroChangeMainUI.OneKeyFightNotify();
      }
      
      protected function PacketPerform_HeroChange_AdvanceRefreshRet(param1:TPacket) : void
      {
         var _loc2_:int = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:Vector.<int> = null;
         _loc2_ = param1.Data.readInt();
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         _loc3_ = param1.Data.readUnsignedInt();
         _loc4_ = param1.Data.readUnsignedInt();
         _loc5_ = param1.Data.readUnsignedInt();
         _loc6_ = param1.Data.readUnsignedInt();
         _loc7_ = new Vector.<int>(2);
         _loc7_[0] = _loc5_;
         _loc7_[1] = _loc6_;
         SLogicsCore.Character.Heros.GetHeroByIdentifier(_loc3_).AdvanceChanges[_loc4_ - 1] = _loc7_;
         this.FProcessorWindowHeroChangeMainUI.ChangeNotify();
      }
      
      protected function PacketPerform_HeroChange_AdvanceReturnRet(param1:TPacket) : void
      {
         var _loc2_:int = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         _loc2_ = param1.Data.readInt();
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         _loc3_ = param1.Data.readUnsignedInt();
         _loc4_ = param1.Data.readUnsignedInt();
         SLogicsCore.Character.Heros.GetHeroByIdentifier(_loc3_).AdvanceChanges[_loc4_ - 1] = null;
         this.FProcessorWindowHeroChangeMainUI.ChangeNotify();
      }
      
      public function ConstructHeroChange() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Vector.<uint> = null;
         var _loc6_:TBins = null;
         var _loc7_:Vector.<THeroChange> = null;
         var _loc8_:THeroChange = null;
         var _loc9_:THeroChangeAttr = null;
         var _loc10_:THero = null;
         var _loc11_:THeros = null;
         var _loc12_:TCity = null;
         var _loc13_:THeroChangeData = null;
         var _loc14_:TChangeHeroPoint = null;
         _loc13_ = SLogicsCore.HeroChangeData;
         this.FHeros = new THeros();
         _loc6_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_HeroChangeAttr);
         _loc5_ = new Vector.<uint>();
         _loc11_ = SLogicsCore.Character.Heros;
         _loc2_ = _loc6_.Count;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc9_ = _loc6_.GetDatebaseByIndex(_loc1_) as THeroChangeAttr;
            if(!_loc9_.IsOpen && _loc9_.CityID == 0)
            {
               _loc1_++;
            }
            else
            {
               _loc8_ = new THeroChange();
               _loc5_.length = 0;
               this.FHeros.Clear();
               _loc5_.push(_loc9_.Identifier);
               this.FUnstreamizerCharacter.UnstreamizeGenerateHerosByIdentifiers(null,this.FHeros,_loc5_);
               _loc8_.Hero = this.FHeros.GetHeroByIndex(0);
               _loc8_.Hero.StubReferences.Reference(_loc8_);
               _loc8_.HeroChangeAttr = _loc9_;
               _loc4_ = int(_loc8_.HeroChangeAttr.HeroStar.length);
               _loc3_ = 0;
               while(_loc3_ < _loc4_)
               {
                  _loc8_.PartnerChanges.push(SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_PartnerChange,_loc8_.HeroChangeAttr.HeroStar[_loc3_]));
                  _loc3_++;
               }
               _loc12_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_City,_loc8_.HeroChangeAttr.CityID) as TCity;
               _loc4_ = _loc12_.Last - _loc12_.Start + 1;
               _loc3_ = 0;
               while(_loc3_ < _loc4_)
               {
                  _loc14_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ChangeHeroPoint,_loc12_.Start + _loc3_) as TChangeHeroPoint;
                  if(_loc14_ == null)
                  {
                  }
                  _loc8_.ChangeHeroPoints.push(_loc14_);
                  _loc3_++;
               }
               _loc10_ = _loc11_.GetHeroByIdentifier(_loc8_.Hero.Identifier);
               if(_loc10_ != null)
               {
                  _loc8_.Hero.ChangeSchedule = _loc10_.ChangeSchedule;
               }
               _loc7_ = this.FHeroChangeData.AllHeroRegistry.GetInstanceByIdentifier(_loc9_.TabIndex) as Vector.<THeroChange>;
               if(_loc7_ == null)
               {
                  _loc7_ = new Vector.<THeroChange>();
                  _loc13_.AllHeroRegistry.Register(_loc9_.TabIndex,_loc7_);
               }
               _loc7_.push(_loc8_);
               _loc1_++;
            }
         }
      }
      
      protected function ReqBaseInfor() : void
      {
         var _loc1_:TPacket = null;
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_HeroChange_InforReq);
         SNetworkCore.Transceiver.PacketTransmit(_loc1_);
      }
      
      protected function SortHeroMethod(param1:THeroChange, param2:THeroChange) : int
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:THeros = null;
         _loc5_ = SLogicsCore.Character.Heros;
         if(_loc5_.GetHeroByIdentifier(param1.Hero.Identifier) != null)
         {
            _loc3_ = uint(param1.Hero.Identifier >> 1);
         }
         else
         {
            _loc3_ = param1.Hero.Identifier;
         }
         if(_loc5_.GetHeroByIdentifier(param2.Hero.Identifier) != null)
         {
            _loc4_ = uint(param2.Hero.Identifier >> 1);
         }
         else
         {
            _loc4_ = param2.Hero.Identifier;
         }
         if(_loc3_ < _loc4_)
         {
            return -1;
         }
         if(_loc3_ > _loc4_)
         {
            return 1;
         }
         return 0;
      }
      
      protected function SortHeros() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Vector.<THeroChange> = null;
         _loc2_ = this.FHeroChangeData.AllHeroRegistry.Count;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FHeroChangeData.AllHeroRegistry.GetInstanceByIndex(_loc1_) as Vector.<THeroChange>;
            _loc3_.sort(this.SortHeroMethod);
            _loc1_++;
         }
      }
      
      protected function SetHeroChipNum(param1:Vector.<THeroChange>, param2:int) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _loc4_ = int(param1.length);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            param1[_loc3_].HeroChipNum = param2;
            _loc3_++;
         }
      }
      
      protected function ShutDownWindows(param1:Object) : void
      {
         ProcessorClose();
      }
      
      public function set OnInitBattle(param1:Function) : void
      {
         this.FOnInitBattle = param1;
      }
      
      public function set OnSetBattleStatus(param1:Function) : void
      {
         this.FOnSetBattleStatus = param1;
      }
      
      override public function Mount(param1:ByteArray = null) : void
      {
         super.Mount(param1);
         if(!FIsResourcesLoadCompleted)
         {
            this.FProcessorWindowHeroChangeMainUI.Load();
            return;
         }
         this.SortHeros();
         if(this.FHeroChangeData.Init)
         {
            if(!this.FProcessorWindowHeroChangeMainUI.Visible)
            {
               this.FProcessorWindowHeroChangeMainUI.Show();
            }
         }
         else
         {
            this.ReqBaseInfor();
         }
      }
      
      override public function Unmount() : void
      {
         super.Unmount();
      }
      
      public function BattleResult(param1:Boolean) : void
      {
         var _loc2_:THeroChange = null;
         _loc2_ = this.FHeroChangeData.GetHeroChangeByHeroID(this.FHeroChangeData.CurrentBattleHeroID);
         if(param1)
         {
            ++_loc2_.CurrentMonsterNum;
            if(_loc2_.HighestRecord < _loc2_.CurrentMonsterNum)
            {
               _loc2_.HighestRecord = _loc2_.CurrentMonsterNum;
            }
         }
         else
         {
            ++_loc2_.CurrentDieTime;
         }
         this.FProcessorWindowHeroChangeMainUI.FightNotify();
      }
      
      protected function StarInfoRet(p:TPacket) : void
      {
         var data:Object = Json.decode(p.Data.readUTF());
         TProcessorWindowHeroChangeMainUI.StarData = data;
         TProcessorWindowHeroChangeMainUI.StarCounts = data.stars;
         TProcessorWindowHeroChangeMainUI.StarPending = false;
         TProcessorWindowHeroChangeMainUI.StarRequested = true;
         this.FProcessorWindowHeroChangeMainUI.StarStateUpdated();
         if(int(data.error) != 0)
         {
            EffectGenerateTextByErrorCode(int(data.error));
         }
      }
   }
}

