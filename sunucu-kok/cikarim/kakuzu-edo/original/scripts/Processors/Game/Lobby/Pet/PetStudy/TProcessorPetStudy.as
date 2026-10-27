package Processors.Game.Lobby.Pet.PetStudy
{
   import Foundation.Common.*;
   import Foundation.Network.*;
   import Foundation.Resources.*;
   import Foundation.UI.*;
   import Foundation.Utilities.TUtilityString;
   import Logics.*;
   import Logics.Characters.*;
   import Logics.Pet.*;
   import Logics.Streamization.Pet.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Processors.Game.Utilities.OverLayer.*;
   import Resources.Constants.*;
   import Resources.Strings.*;
   import flash.utils.*;
   
   public class TProcessorPetStudy extends TProcessorLobbyWindows
   {
      
      protected static const SIZE_WindowPetStudy_Width:uint = 644;
      
      protected static const SIZE_WindowPetStudy_Height:uint = 511;
      
      protected static const INDEX_WINDOW_PET_CARRY:uint = CONST_PET.INDEX_WINDOW_PET_CARRY;
      
      protected static const INDEX_WINDOW_PET_EXTENDS:uint = CONST_PET.INDEX_WINDOW_PET_EXTENDS;
      
      protected static const INDEX_WINDOW_PET_COMPOSITE:uint = CONST_PET.INDEX_WINDOW_PET_COMPOSITE;
      
      protected static const INDEX_WINDOW_PET_ADVANCE:uint = CONST_PET.INDEX_WINDOW_PET_ADVANCE;
      
      protected static const INDEX_WINDOW_PET_STORE:uint = CONST_PET.INDEX_WINDOW_PET_STORE;
      
      protected static const INDEX_WINDOW_PET_WASH:uint = CONST_PET.INDEX_WINDOW_PET_WASH;
      
      protected var FUnstreamizerPet:TUnstreamizerPet;
      
      protected var FPetData:TPetData;
      
      protected var FProcessorWindowPetStudy:TProcessorWindowPetStudy;
      
      protected var FProcessorWindowPetCarry:TProcessorWindowPetCarry;
      
      protected var FProcessorWindowPetInherit:TProcessorWindowPetInherit;
      
      protected var FProcessorWindowPetComposite:TProcessorWindowPetComposite;
      
      protected var FProcessorWindowPetAdvance:TProcessorWindowPetAdvance;
      
      protected var FProcessorWindowPetStore:TProcessorWindowPetStore;
      
      protected var FProcessorWindowPetWash:TProcessorWindowPetWash;
      
      protected var FProcessorLobbyWindows:Vector.<TProcessorLobbyWindow>;
      
      protected var FVicePetRankUpInfos:Vector.<TVicePetRankUpInfo>;
      
      protected var FOnSlotOver:Function;
      
      protected var FOnSlotOut:Function;
      
      protected var FOnUpdateMainWindow:Function;
      
      public function TProcessorPetStudy(param1:TUIComponent, param2:TLobbyParameters)
      {
         var _loc3_:TBounds = null;
         super(param1,param2);
         this.FPetData = SLogicsCore.PetData;
         this.FProcessorWindowPetStudy = new TProcessorWindowPetStudy(param1);
         this.FProcessorWindowPetStudy.Visible = false;
         this.FProcessorWindowPetStudy.OnClose = this.ProcessorWindowClose;
         this.FProcessorWindowPetStudy.OnEffectText = ProcessorsOnEffectText;
         this.FProcessorWindowPetStudy.OnOpenPetStudy = this.ProcessorOnOpenPetStudy;
         _loc3_ = new TBounds();
         _loc3_.Width = SIZE_WindowPetStudy_Width;
         _loc3_.Height = SIZE_WindowPetStudy_Height;
         ComponentBoundsCenter(this.FProcessorWindowPetStudy,_loc3_);
         _loc3_ = null;
         this.FProcessorWindowPetCarry = new TProcessorWindowPetCarry(this);
         this.FProcessorWindowPetCarry.OnEffectText = ProcessorsOnEffectText;
         this.FProcessorWindowPetCarry.OnSlotOver = this.ProcessorOnSlotOver;
         this.FProcessorWindowPetCarry.OnSlotOut = this.ProcessorOnSlotOut;
         this.FProcessorWindowPetInherit = new TProcessorWindowPetInherit(this);
         this.FProcessorWindowPetInherit.OnEffectText = ProcessorsOnEffectText;
         this.FProcessorWindowPetInherit.OnSlotOver = this.ProcessorOnSlotOver;
         this.FProcessorWindowPetInherit.OnSlotOut = this.ProcessorOnSlotOut;
         this.FProcessorWindowPetComposite = new TProcessorWindowPetComposite(this);
         this.FProcessorWindowPetComposite.OnEffectText = ProcessorsOnEffectText;
         this.FProcessorWindowPetComposite.OnSlotOver = this.ProcessorOnSlotOver;
         this.FProcessorWindowPetComposite.OnSlotOut = this.ProcessorOnSlotOut;
         this.FProcessorWindowPetAdvance = new TProcessorWindowPetAdvance(this);
         this.FProcessorWindowPetAdvance.OnEffectText = ProcessorsOnEffectText;
         this.FProcessorWindowPetAdvance.OnSlotOver = this.ProcessorOnSlotOver;
         this.FProcessorWindowPetAdvance.OnSlotOut = this.ProcessorOnSlotOut;
         this.FProcessorWindowPetStore = new TProcessorWindowPetStore(this);
         this.FProcessorWindowPetStore.OnEffectText = ProcessorsOnEffectText;
         this.FProcessorWindowPetStore.OnSlotOver = this.ProcessorOnSlotOver;
         this.FProcessorWindowPetStore.OnSlotOut = this.ProcessorOnSlotOut;
         this.FProcessorWindowPetWash = new TProcessorWindowPetWash(this);
         this.FProcessorWindowPetWash.OnEffectText = ProcessorsOnEffectText;
         this.FProcessorWindowPetWash.OnSlotOver = this.ProcessorOnSlotOver;
         this.FProcessorWindowPetWash.OnSlotOut = this.ProcessorOnSlotOut;
         this.FUnstreamizerPet = new TUnstreamizerPet();
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_PET.RESOURCESID_Swf_PetStudy);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         var _loc1_:int = 0;
         this.FProcessorLobbyWindows = this.FProcessorWindowPetStudy.ProcessorLobbyWindows;
         this.FProcessorWindowPetStudy.SetProcessorLobbyWindowsByIndex(this.FProcessorWindowPetCarry,INDEX_WINDOW_PET_CARRY);
         this.FProcessorWindowPetStudy.SetProcessorLobbyWindowsByIndex(this.FProcessorWindowPetInherit,INDEX_WINDOW_PET_EXTENDS);
         this.FProcessorWindowPetStudy.SetProcessorLobbyWindowsByIndex(this.FProcessorWindowPetComposite,INDEX_WINDOW_PET_COMPOSITE);
         this.FProcessorWindowPetStudy.SetProcessorLobbyWindowsByIndex(this.FProcessorWindowPetAdvance,INDEX_WINDOW_PET_ADVANCE);
         this.FProcessorWindowPetStudy.SetProcessorLobbyWindowsByIndex(this.FProcessorWindowPetStore,INDEX_WINDOW_PET_STORE);
         this.FProcessorWindowPetStudy.SetProcessorLobbyWindowsByIndex(this.FProcessorWindowPetWash,INDEX_WINDOW_PET_WASH);
         super.ResourcesPerform_UILocations();
      }
      
      override protected function PacketRegisterRoutines() : void
      {
         super.PacketRegisterRoutines();
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Pet_VicePetMakeRet,this.PerformPacket_SC_Pet_VicePetMakeRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Pet_VicePetEquipRet,this.PerformPacket_SC_Pet_VicePetEquipRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Pet_VicePetUnEquipRet,this.PerformPacket_SC_Pet_VicePetUnEquipRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Pet_VicePetDelRet,this.PerformPacket_SC_Pet_VicePetDelRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Pet_VicePetInheritRet,this.PerformPacket_SC_Pet_VicePetInheritRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Pet_VicePetRankUpRet,this.PerformPacket_SC_Pet_VicePetRankUpRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Pet_StoreExtendRet,this.PerformPacket_SC_Pet_StoreExtendRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Pet_ExpPoolExtendRet,this.PerformPacket_SC_Pet_ExpPoolExtendRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Pet_VicePetWashExpRet,this.PerformPacket_SC_Pet_VicePetWashExpRet);
      }
      
      protected function PerformPacket_SC_Pet_VicePetMakeRet(param1:TPacket) : void
      {
         var _loc2_:int = 0;
         var _loc3_:ByteArray = null;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:TVicePet = null;
         _loc3_ = param1.Data;
         _loc2_ = int(_loc3_.readUnsignedInt());
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         _loc4_ = _loc3_.readUnsignedInt();
         _loc5_ = _loc3_.readUnsignedInt();
         _loc6_ = _loc3_.readUnsignedInt();
         _loc7_ = SLogicsCore.PoolPet.AcquireVicePet(_loc4_,_loc5_);
         _loc7_.TemplateID = _loc6_;
         _loc7_.Level = 1;
         this.FUnstreamizerPet.UnstreamizeVicePet(null,_loc7_,null);
         this.FPetData.OwnVicePets.Add(_loc7_);
         this.FPetData.OwnVicePets.Sort();
         this.FProcessorWindowPetComposite.PlayActivateEffect();
         EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_PET_09));
      }
      
      protected function PerformPacket_SC_Pet_VicePetEquipRet(param1:TPacket) : void
      {
         var _loc2_:int = 0;
         var _loc3_:ByteArray = null;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:THero = null;
         _loc3_ = param1.Data;
         _loc2_ = int(_loc3_.readUnsignedInt());
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         _loc5_ = _loc3_.readUnsignedInt();
         _loc6_ = _loc3_.readUnsignedInt();
         _loc4_ = _loc3_.readUnsignedInt();
         _loc7_ = SLogicsCore.Character.Heros.GetHeroByIdentifier(_loc4_);
         _loc7_.VicePetHighID = _loc5_;
         _loc7_.VicePetLowID = _loc6_;
         this.FProcessorWindowPetCarry.UpdatePetCarryOperator();
         EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_PET_10));
      }
      
      protected function PerformPacket_SC_Pet_VicePetUnEquipRet(param1:TPacket) : void
      {
         var _loc2_:int = 0;
         var _loc3_:ByteArray = null;
         var _loc4_:THero = null;
         var _loc5_:uint = 0;
         _loc3_ = param1.Data;
         _loc2_ = int(_loc3_.readUnsignedInt());
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         _loc5_ = _loc3_.readUnsignedInt();
         _loc4_ = SLogicsCore.Character.Heros.GetHeroByIdentifier(_loc5_);
         _loc4_.VicePetHighID = 0;
         _loc4_.VicePetLowID = 0;
         this.FProcessorWindowPetCarry.Update();
         EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_PET_11));
      }
      
      protected function PerformPacket_SC_Pet_VicePetDelRet(param1:TPacket) : void
      {
         var _loc2_:int = 0;
         var _loc3_:ByteArray = null;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         _loc3_ = param1.Data;
         _loc2_ = int(_loc3_.readUnsignedInt());
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         _loc4_ = _loc3_.readUnsignedInt();
         _loc5_ = _loc3_.readUnsignedInt();
         this.FPetData.OwnVicePets.DeletePetByIdentifier(_loc4_,_loc5_);
         this.FProcessorWindowPetStore.Update();
         EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_PET_12));
      }
      
      protected function PerformPacket_SC_Pet_VicePetInheritRet(param1:TPacket) : void
      {
         var _loc2_:int = 0;
         var _loc3_:ByteArray = null;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:TPetBase = null;
         var _loc7_:TPetBase = null;
         _loc3_ = param1.Data;
         _loc2_ = int(_loc3_.readUnsignedInt());
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         _loc4_ = _loc3_.readUnsignedInt();
         _loc5_ = _loc3_.readUnsignedInt();
         _loc6_ = this.FPetData.OwnVicePets.GetPetByIdentifier(_loc4_,_loc5_);
         _loc6_.Level = _loc3_.readUnsignedInt();
         _loc6_.Experience = _loc3_.readUnsignedInt();
         _loc6_.TemplateID = _loc3_.readUnsignedInt();
         this.FPetData.InheritPoolExp = _loc3_.readUnsignedInt();
         this.FUnstreamizerPet.UnstreamizeVicePet(null,_loc6_,null);
         this.FProcessorWindowPetInherit.Update();
         this.FProcessorWindowPetInherit.PlayInheritEffect();
      }
      
      protected function PerformPacket_SC_Pet_VicePetRankUpRet(param1:TPacket) : void
      {
         var _loc2_:int = 0;
         var _loc3_:ByteArray = null;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:TPetBase = null;
         _loc3_ = param1.Data;
         _loc2_ = int(_loc3_.readUnsignedInt());
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         _loc4_ = _loc3_.readUnsignedInt();
         _loc5_ = _loc3_.readUnsignedInt();
         _loc6_ = this.FPetData.OwnVicePets.GetPetByIdentifier(_loc4_,_loc5_);
         _loc6_.TemplateID = _loc3_.readUnsignedInt();
         this.FUnstreamizerPet.UnstreamizeVicePet(null,_loc6_,null);
         this.FProcessorWindowPetAdvance.PlayActivateEffect();
         this.FProcessorWindowPetAdvance.Reset(false);
         this.FProcessorWindowPetAdvance.Update();
         EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_PET_14));
      }
      
      protected function PerformPacket_SC_Pet_StoreExtendRet(param1:TPacket) : void
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
         this.FPetData.BuyVicePetStorageSlotCount = _loc3_.readUnsignedInt();
         this.FProcessorWindowPetStore.Update();
         if(this.FOnUpdateMainWindow != null)
         {
            this.FOnUpdateMainWindow();
         }
         EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_PET_21));
      }
      
      protected function PerformPacket_SC_Pet_ExpPoolExtendRet(param1:TPacket) : void
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
         this.FPetData.InheritExtendTimes = _loc3_.readUnsignedInt();
         this.FProcessorWindowPetWash.Update();
         this.FProcessorWindowPetInherit.Update();
      }
      
      protected function PerformPacket_SC_Pet_VicePetWashExpRet(param1:TPacket) : void
      {
         var _loc2_:int = 0;
         var _loc3_:ByteArray = null;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:TPetBase = null;
         _loc3_ = param1.Data;
         _loc2_ = int(_loc3_.readUnsignedInt());
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         _loc4_ = _loc3_.readUnsignedInt();
         _loc5_ = _loc3_.readUnsignedInt();
         _loc6_ = this.FPetData.OwnVicePets.GetPetByIdentifier(_loc4_,_loc5_);
         _loc6_.TemplateID = _loc3_.readUnsignedInt();
         this.FPetData.InheritPoolExp = _loc3_.readUnsignedInt();
         SToolReward.ShowMessage(TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_PET_48),_loc3_.readUnsignedInt()));
         SToolReward.ShowReward(_loc3_);
         _loc6_.Experience = 0;
         _loc6_.Level = 1;
         this.FUnstreamizerPet.UnstreamizeVicePet(null,_loc6_,null);
         this.FProcessorWindowPetWash.Update();
         this.FProcessorWindowPetWash.PlayInheritEffect();
      }
      
      protected function ProcessorWindowClose(param1:Object) : void
      {
         BarrierDeactuateWindows(param1);
         this.Unmount();
      }
      
      private function ProcessorOnOpenPetStudy(param1:Object, param2:int, param3:int) : void
      {
         var _loc4_:* = undefined;
         _loc4_ = this.FProcessorLobbyWindows[param3];
         _loc4_.Reset();
         _loc4_.Visible = false;
         _loc4_ = this.FProcessorLobbyWindows[param2];
         _loc4_.Update();
         _loc4_.Visible = true;
      }
      
      protected function ProcessorOnSlotOver(param1:Object, param2:Object) : void
      {
         if(this.FOnSlotOver != null)
         {
            this.FOnSlotOver(param1,param2);
         }
      }
      
      protected function ProcessorOnSlotOut(param1:Object, param2:Object) : void
      {
         if(this.FOnSlotOut != null)
         {
            this.FOnSlotOut(param1,param2);
         }
      }
      
      public function get OnSlotOver() : Function
      {
         return this.FOnSlotOver;
      }
      
      public function set OnSlotOver(param1:Function) : void
      {
         this.FOnSlotOver = param1;
      }
      
      public function get OnSlotOut() : Function
      {
         return this.FOnSlotOut;
      }
      
      public function set OnSlotOut(param1:Function) : void
      {
         this.FOnSlotOut = param1;
      }
      
      public function get OnUpdateMainWindow() : Function
      {
         return this.FOnUpdateMainWindow;
      }
      
      public function set OnUpdateMainWindow(param1:Function) : void
      {
         this.FOnUpdateMainWindow = param1;
      }
      
      override public function Mount(param1:ByteArray = null) : void
      {
         super.Mount(param1);
         if(!FIsResourcesLoadCompleted)
         {
            this.FProcessorWindowPetStudy.Load();
            this.FProcessorWindowPetCarry.Load();
            this.FProcessorWindowPetInherit.Load();
            this.FProcessorWindowPetComposite.Load();
            this.FProcessorWindowPetAdvance.Load();
            this.FProcessorWindowPetStore.Load();
            this.FProcessorWindowPetWash.Load();
            return;
         }
         BarrierActuateWindows(this.FProcessorWindowPetStudy);
         this.FProcessorWindowPetStudy.Update();
         this.FProcessorWindowPetStudy.Visible = true;
      }
      
      override public function Unmount() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:* = undefined;
         super.Unmount();
         this.FProcessorWindowPetStudy.Reset();
         this.FProcessorWindowPetStudy.Visible = false;
         _loc2_ = int(this.FProcessorLobbyWindows.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FProcessorLobbyWindows[_loc1_];
            _loc3_.Reset();
            _loc1_++;
         }
      }
      
      public function UpdateCharacterBaseAttributeRet() : void
      {
         if(this.FProcessorWindowPetCarry.Visible)
         {
            this.FProcessorWindowPetCarry.UpdateUIPetCarry();
         }
      }
   }
}

