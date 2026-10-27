package Processors.Game.Lobby.Pet
{
   import Foundation.Common.*;
   import Foundation.Network.*;
   import Foundation.Resources.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.DatebaseVO.VO.Json.*;
   import Logics.DatebaseVO.VO.TConfigValue;
   import Logics.Pet.*;
   import Logics.Pet.Gift.*;
   import Logics.Streamization.Pet.*;
   import Logics.TimeCoolDown.TTimeCoolDown;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Pet.PetHouse.*;
   import Processors.Game.Lobby.Pet.PetStudy.*;
   import Processors.Game.Lobby.Pet.PetTrain.*;
   import Processors.Game.Lobby.Utilities.*;
   import Processors.Game.Utilities.EffectTextReward.*;
   import Processors.Game.Utilities.OverLayer.*;
   import Rendering.Overlayers.*;
   import Rendering.Overlayers.Pet.*;
   import Rendering.Overlayers.Pet.Gift.*;
   import Resources.Constants.*;
   import Resources.Strings.*;
   import Utilities.UI.Overlayers.*;
   import flash.display.*;
   import flash.utils.*;
   
   public class TProcessorPet extends TProcessorLobbyPlate
   {
      
      protected var FPetData:TPetData;
      
      protected var FOverlayerPetGift:TOverlayerPetGift;
      
      protected var FOverlayerPet:TOverlayerPet;
      
      protected var FUnstreamizerPets:TUnstreamizerPets;
      
      protected var FUnstreamizerPetData:TUnstreamizerPetData;
      
      protected var FProcessorWindowPet:TProcessorWindowPet;
      
      protected var FProcessorPetHouse:TProcessorPetHouse;
      
      protected var FProcessorPetTrain:TProcessorPetTrain;
      
      protected var FProcessorPetStudy:TProcessorPetStudy;
      
      protected var FIsRankInfoInit:Boolean;
      
      protected var FOnEnterTown:Function;
      
      protected var FOnLoadLog:Function;
      
      public function TProcessorPet(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,param2);
         this.FProcessorWindowPet = new TProcessorWindowPet(this);
         this.FProcessorWindowPet.OnEffectText = ProcessorsOnEffectText;
         this.FProcessorWindowPet.OnClose = this.ProcessorWindowPetOnClose;
         this.FProcessorWindowPet.OnGiftOver = this.UIComponentsOnOver;
         this.FProcessorWindowPet.OnGiftOut = this.UIComponentsOnOut;
         this.FProcessorWindowPet.OnPetHouse = this.ProcessorOnPetHouse;
         this.FProcessorWindowPet.OnPetTrain = this.ProcessorOnPetTrain;
         this.FProcessorWindowPet.OnPetStudy = this.ProcessorOnPetStudy;
         this.FProcessorPetHouse = new TProcessorPetHouse(param2.MountPointWindow,param2);
         this.FProcessorPetHouse.Visible = false;
         this.FProcessorPetHouse.OnDialogMsg = ProcessorsOnDialogMsg;
         this.FProcessorPetHouse.OnEffectText = ProcessorsOnEffectText;
         this.FProcessorPetHouse.OnSlotOver = this.UIComponentsOnOver;
         this.FProcessorPetHouse.OnSlotOut = this.UIComponentsOnOut;
         this.FProcessorPetTrain = new TProcessorPetTrain(param2.MountPointWindow,param2);
         this.FProcessorPetTrain.Visible = false;
         this.FProcessorPetTrain.OnDialogMsg = ProcessorsOnDialogMsg;
         this.FProcessorPetTrain.OnEffectText = ProcessorsOnEffectText;
         this.FProcessorPetTrain.OnSlotOver = this.UIComponentsOnOver;
         this.FProcessorPetTrain.OnSlotOut = this.UIComponentsOnOut;
         this.FProcessorPetStudy = new TProcessorPetStudy(param2.MountPointWindow,param2);
         this.FProcessorPetStudy.Visible = false;
         this.FProcessorPetStudy.OnDialogMsg = ProcessorsOnDialogMsg;
         this.FProcessorPetStudy.OnEffectText = ProcessorsOnEffectText;
         this.FProcessorPetStudy.OnSlotOver = this.UIComponentsOnOver;
         this.FProcessorPetStudy.OnSlotOut = this.UIComponentsOnOut;
         this.FProcessorPetStudy.OnUpdateMainWindow = this.ProcessorUpdateMainWindow;
         this.FPetData = SLogicsCore.PetData;
         this.FUnstreamizerPets = new TUnstreamizerPets();
         this.FUnstreamizerPetData = new TUnstreamizerPetData();
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_PET.RESOURCESID_Swf_Pet);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:TConfigValue = null;
         this.FOverlayerPetGift = new TOverlayerPetGift(this);
         this.FOverlayerPetGift.Visible = false;
         TUtilityUIOverlayer.ResourcesDispatch(this.FOverlayerPetGift);
         this.FOverlayerPet = new TOverlayerPet(FParameters.MountPointWindow);
         this.FOverlayerPet.Visible = false;
         this.FOverlayerPet.Resource = TUtilityReflection.CreateDisplayObjectInstance("SP_PetTips") as Sprite;
         this.FOverlayerPet.ResourcesUpdate();
         TutorialSendComponent(CONST_FRESHGUIDE.MCID_PetHome,this);
         TutorialSendArrowParent(CONST_FRESHGUIDE.MCID_PetHome,this.parent.parent);
         _loc1_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.Pet_Buy_Interact) as TConfigValue;
         this.FPetData.FishAddCountCost = Vector.<int>(_loc1_.Value);
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function PacketRegisterRoutines() : void
      {
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Pet_InitInfoRet,this.PerformPacket_SC_Pet_InitInfoRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Pet_InteractRet,this.PerformPacket_SC_Pet_InteractRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Pet_InteractClearCDRet,this.PerformPacket_SC_Pet_InteractClearCDRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Pet_InteractBuyCountRet,this.PerformPacket_SC_Pet_InteractBuyCountRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Pet_GetPetBagRet,this.PerformPacket_SC_Pet_GetPetBagRet);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_PetHouse_Base,CONST_NETWORK.PACKETID_SC_PetHouse_End,this.PacketPerform_ProcessorPetHouse);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_PetTrain_Base,CONST_NETWORK.PACKETID_SC_PetTrain_End,this.PacketPerform_ProcessorPetTrain);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_PetStudy_Base,CONST_NETWORK.PACKETID_SC_PetStudy_End,this.PacketPerform_ProcessorPetStudy);
      }
      
      protected function PerformPacket_SC_Pet_InitInfoRet(param1:TPacket) : void
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
         this.FUnstreamizerPets.UnstreamizeMainPets(_loc3_,this.FPetData,null);
         this.FUnstreamizerPets.UnstreamizeVicePets(_loc3_,this.FPetData,null);
         this.FUnstreamizerPetData.UnstreamizationPerform_Gifts(null,this.FPetData,null);
         if(FIsResourcesLoadCompleted)
         {
            this.FProcessorWindowPet.UpdateGiftBag();
         }
      }
      
      protected function PerformPacket_SC_Pet_InteractRet(param1:TPacket) : void
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
         this.FUnstreamizerPetData.UnstreamizeFishCD(_loc3_,this.FPetData,null);
         SToolReward.ShowReward(_loc3_);
         ++this.FPetData.FishCount;
         this.FProcessorWindowPet.PlayEffectMCFishNet();
         this.FProcessorWindowPet.UpdateInteractUI();
      }
      
      protected function PerformPacket_SC_Pet_InteractClearCDRet(param1:TPacket) : void
      {
         var _loc2_:int = 0;
         var _loc3_:ByteArray = null;
         var _loc4_:TTimeCoolDown = null;
         _loc3_ = param1.Data;
         _loc2_ = int(_loc3_.readUnsignedInt());
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         this.FPetData.FishCD = 0;
         _loc4_ = SLogicsCore.TimeCoolDowns.GetTimeByIdentifier(CONST_COMMON.TIME_COOLDOWN_Pet_Fish);
         _loc4_.TimingTime = 0;
         this.FProcessorWindowPet.UpdateInteractUI();
         EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HOME_STRING_18));
      }
      
      protected function PerformPacket_SC_Pet_InteractBuyCountRet(param1:TPacket) : void
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
         EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_PET_04));
         ++this.FPetData.BuyFishCount;
         this.FProcessorWindowPet.UpdateInteractUI();
      }
      
      protected function PerformPacket_SC_Pet_GetPetBagRet(param1:TPacket) : void
      {
         var _loc2_:int = 0;
         var _loc3_:ByteArray = null;
         var _loc4_:int = 0;
         var _loc5_:TGift = null;
         var _loc6_:int = 0;
         _loc3_ = param1.Data;
         _loc2_ = int(_loc3_.readUnsignedInt());
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         _loc4_ = int(_loc3_.readUnsignedInt());
         _loc5_ = this.FPetData.Gifts.GetGiftByIdentifier(_loc4_);
         _loc6_ = int(this.FPetData.Gifts.GetIndexByGift(_loc5_));
         if(_loc6_ >= 0)
         {
            this.FPetData.SetPetBagMaskByIndex(_loc6_);
         }
         this.FUnstreamizerPetData.UnstreamizeGift(null,_loc5_,this.FPetData.GetPetBagMaskByIndex(_loc6_));
         SToolReward.ShowReward(_loc3_);
         this.FProcessorWindowPet.UpdateGiftBag();
      }
      
      protected function PacketPerform_ProcessorPetHouse(param1:TPacket) : void
      {
         this.FProcessorPetHouse.PacketProcess(param1);
      }
      
      protected function PacketPerform_ProcessorPetTrain(param1:TPacket) : void
      {
         this.FProcessorPetTrain.PacketProcess(param1);
      }
      
      protected function PacketPerform_ProcessorPetStudy(param1:TPacket) : void
      {
         this.FProcessorPetStudy.PacketProcess(param1);
      }
      
      protected function ProcessorPetInfoReq() : void
      {
         var _loc1_:TPacket = null;
         var _loc2_:ByteArray = null;
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Pet_InitInfoReq);
         SNetworkCore.Transceiver.PacketTransmit(_loc1_);
      }
      
      protected function ProcessorEnterPetReq() : void
      {
         var _loc1_:TPacket = null;
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Enter_Pet);
         SNetworkCore.Transceiver.PacketTransmit(_loc1_);
      }
      
      protected function ProcessorPetInfo(param1:ByteArray) : void
      {
         if(!this.FIsRankInfoInit)
         {
            this.FIsRankInfoInit = true;
            this.FUnstreamizerPets.UnstreamizeInitVicePetRankUp(null,this.FPetData,null);
            this.FUnstreamizerPets.UnstreamizeGenerateMainPets(null,this.FPetData,null);
            this.FUnstreamizerPets.UnstreamizeGenerateVicePets(null,this.FPetData,null);
         }
         this.FUnstreamizerPetData.Unstreamize(param1,this.FPetData,null);
      }
      
      protected function ProcessorUpdateMainWindow() : void
      {
         this.FProcessorWindowPet.UpdateInteractUI();
      }
      
      protected function ProcessorWindowPetOnClose(param1:Object) : void
      {
         if(this.FOnEnterTown != null)
         {
            this.FOnEnterTown(param1);
         }
      }
      
      protected function ProcessorOnPetHouse(param1:Object) : void
      {
         if(!this.FProcessorPetHouse.Visible)
         {
            this.FProcessorPetHouse.Mount();
         }
      }
      
      protected function ProcessorOnPetTrain(param1:Object) : void
      {
         if(!this.FProcessorPetTrain.Visible)
         {
            this.FProcessorPetTrain.Mount();
         }
      }
      
      protected function ProcessorOnPetStudy(param1:Object) : void
      {
         if(!this.FProcessorPetStudy.Visible)
         {
            this.FProcessorPetStudy.Mount();
         }
      }
      
      protected function UIComponentsOnOver(param1:Object, param2:Object) : void
      {
         var _loc3_:TOverlayer = null;
         if(param2 is TGift)
         {
            _loc3_ = this.FOverlayerPetGift;
         }
         else if(param2 is TPetBase)
         {
            _loc3_ = this.FOverlayerPet;
         }
         _loc3_.Context = param2;
         _loc3_.Render(FUICore.MouseCoordinate);
         _loc3_.Show();
      }
      
      protected function UIComponentsOnOut(param1:Object, param2:Object) : void
      {
         var _loc3_:TOverlayer = null;
         if(param2 is TGift)
         {
            _loc3_ = this.FOverlayerPetGift;
         }
         else if(param2 is TPetBase)
         {
            _loc3_ = this.FOverlayerPet;
         }
         else
         {
            _loc3_ = this.FOverlayerPet;
         }
         _loc3_.Context = null;
         _loc3_.Hide();
      }
      
      public function set OnEnterTown(param1:Function) : void
      {
         this.FOnEnterTown = param1;
      }
      
      public function set OnLoadLog(param1:Function) : void
      {
         this.FOnLoadLog = param1;
      }
      
      public function set OnUpdateHeroFightNum(param1:Function) : void
      {
         this.FProcessorPetHouse.OnUpdateHeroFightNum = param1;
      }
      
      override public function Mount(param1:ByteArray = null) : void
      {
         super.Mount();
         if(param1 != null)
         {
            this.ProcessorPetInfo(param1);
         }
         if(!FIsResourcesLoadCompleted)
         {
            this.FProcessorWindowPet.Load();
            return;
         }
         this.ProcessorPetInfoReq();
         this.FProcessorWindowPet.Update();
         this.FProcessorWindowPet.Visible = true;
         TutorialNextStep(CONST_FRESHGUIDE.EVENTID_OpenPetHome);
      }
      
      override public function Unmount() : void
      {
         super.Unmount();
         this.FPetData.Reset();
         this.FProcessorWindowPet.Reset();
         TutorialNextStep(CONST_FRESHGUIDE.EVENTID_ClosePetHome);
      }
      
      public function EnterPetReq() : void
      {
         this.ProcessorEnterPetReq();
      }
      
      public function UpdateCharacterBaseAttributeRet() : void
      {
         this.FProcessorPetStudy.UpdateCharacterBaseAttributeRet();
      }
   }
}

