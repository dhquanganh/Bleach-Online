package Processors.Game.Lobby.Pet.PetHouse
{
   import Foundation.Common.TBounds;
   import Foundation.Network.TPacket;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.VO.TConfigValue;
   import Logics.Pet.TMainPet;
   import Logics.Pet.TPetData;
   import Logics.SLogicsCore;
   import Logics.Streamization.Pet.TUnstreamizerPet;
   import Processors.Game.Lobby.Common.TLobbyParameters;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindows;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Resources.Constants.CONST_NETWORK;
   import Resources.Constants.CONST_PET;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.utils.ByteArray;
   
   public class TProcessorPetHouse extends TProcessorLobbyWindows
   {
      
      protected static const SIZE_WindowPetHouse_Width:uint = 783;
      
      protected static const SIZE_WindowPetHouse_Height:uint = 503;
      
      protected static const SIZE_WindowPetActivateLine_Width:uint = 538;
      
      protected static const SIZE_WindowPetActivateLine_Height:uint = 560;
      
      protected static const SIZE_WindowPetActivateWashPoint_Width:uint = 538;
      
      protected static const SIZE_WindowPetActivateWashPoint_Height:uint = 560;
      
      protected var FPetData:TPetData;
      
      protected var FUnstreamizerPet:TUnstreamizerPet;
      
      protected var FProcessorWindowPetHouse:TProcessorWindowPetHouse;
      
      protected var FProcessorWindowPetActivateLine:TProcessorWindowPetActivateLine;
      
      protected var FProcessorWindowPetActivateWashPoint:TProcessorWindowPetActivateWashPoint;
      
      protected var FOnSlotOver:Function;
      
      protected var FOnSlotOut:Function;
      
      protected var FOnUpdateHeroFightNum:Function;
      
      public function TProcessorPetHouse(param1:TUIComponent, param2:TLobbyParameters)
      {
         var _loc3_:TBounds = null;
         super(param1,param2);
         this.FPetData = SLogicsCore.PetData;
         this.FUnstreamizerPet = new TUnstreamizerPet();
         this.FProcessorWindowPetHouse = new TProcessorWindowPetHouse(param1);
         this.FProcessorWindowPetHouse.Visible = false;
         this.FProcessorWindowPetHouse.OnClose = this.ProcessorWindowClose;
         this.FProcessorWindowPetHouse.OnEffectText = ProcessorsOnEffectText;
         this.FProcessorWindowPetHouse.HintOnOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FProcessorWindowPetHouse.HintOnOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FProcessorWindowPetHouse.OnOpenActivateLine = this.ProcessorWindowOnOpenActivateLine;
         this.FProcessorWindowPetHouse.OnOpenActivateWashPoint = this.ProcessorWindowOnOpenActivateWashPoint;
         _loc3_ = new TBounds();
         _loc3_.Width = SIZE_WindowPetHouse_Width;
         _loc3_.Height = SIZE_WindowPetHouse_Height;
         ComponentBoundsCenter(this.FProcessorWindowPetHouse,_loc3_);
         this.FProcessorWindowPetHouse.X += 100;
         this.FProcessorWindowPetActivateLine = new TProcessorWindowPetActivateLine(param1);
         this.FProcessorWindowPetActivateLine.OnClose = this.ProcessorWindowOnClose;
         this.FProcessorWindowPetActivateLine.OnSlotOver = this.ProcessorOnSlotOver;
         this.FProcessorWindowPetActivateLine.OnSlotOut = this.ProcessorOnSlotOut;
         _loc3_ = new TBounds();
         _loc3_.X = this.FProcessorWindowPetActivateLine.X;
         _loc3_.Y = this.FProcessorWindowPetActivateLine.Y;
         _loc3_.Width = SIZE_WindowPetActivateLine_Width;
         _loc3_.Height = SIZE_WindowPetActivateLine_Height;
         ComponentBoundsCenter(this.FProcessorWindowPetActivateLine,_loc3_);
         this.FProcessorWindowPetActivateWashPoint = new TProcessorWindowPetActivateWashPoint(param1);
         this.FProcessorWindowPetActivateWashPoint.OnClose = this.ProcessorWindowOnClose;
         this.FProcessorWindowPetActivateWashPoint.OnSlotOver = this.ProcessorOnSlotOver;
         this.FProcessorWindowPetActivateWashPoint.OnSlotOut = this.ProcessorOnSlotOut;
         _loc3_ = new TBounds();
         _loc3_.X = this.FProcessorWindowPetActivateWashPoint.X;
         _loc3_.Y = this.FProcessorWindowPetActivateWashPoint.Y;
         _loc3_.Width = SIZE_WindowPetActivateWashPoint_Width;
         _loc3_.Height = SIZE_WindowPetActivateWashPoint_Height;
         ComponentBoundsCenter(this.FProcessorWindowPetActivateWashPoint,_loc3_);
         _loc3_ = null;
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_PET.RESOURCESID_Swf_PetHouse);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
      }
      
      override protected function PacketRegisterRoutines() : void
      {
         super.PacketRegisterRoutines();
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Pet_MainPetFeedRet,this.PerformPacket_SC_Pet_MainPetFeedRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Pet_MainPetRankUpRet,this.PerformPacket_SC_Pet_MainPetRankUpRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Pet_MainPetDelRet,this.PerformPacket_SC_Pet_MainPetDelRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Pet_MainPetChangeRet,this.PerformPacket_SC_Pet_MainPetChangeRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Pet_NotiyPetItemRet,this.PerformPacket_SC_Pet_NotiyPetItemRet);
      }
      
      protected function PerformPacket_SC_Pet_MainPetFeedRet(param1:TPacket) : void
      {
         var _loc2_:int = 0;
         var _loc3_:ByteArray = null;
         var _loc4_:TMainPet = null;
         var _loc5_:uint = 0;
         _loc3_ = param1.Data;
         _loc2_ = int(_loc3_.readUnsignedInt());
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         _loc4_ = this.FPetData.OwnMainPets.GetPetByIdentifier(_loc3_.readUnsignedInt(),0) as TMainPet;
         _loc5_ = _loc4_.Level;
         _loc4_.Level = _loc3_.readUnsignedInt();
         _loc4_.Experience = _loc3_.readUnsignedInt();
         if(_loc4_.Level > _loc5_)
         {
            this.FUnstreamizerPet.UnstreamizeMainPet(_loc3_,_loc4_,null);
         }
         this.FProcessorWindowPetHouse.UpdatePetInfo();
      }
      
      protected function PerformPacket_SC_Pet_MainPetRankUpRet(param1:TPacket) : void
      {
         var _loc2_:int = 0;
         var _loc3_:ByteArray = null;
         var _loc4_:uint = 0;
         var _loc5_:TMainPet = null;
         _loc3_ = param1.Data;
         _loc2_ = int(_loc3_.readUnsignedInt());
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         this.FPetData.MainPetSelected = null;
         _loc4_ = _loc3_.readUnsignedInt();
         _loc5_ = SLogicsCore.PoolPet.AcquireMainPet(_loc4_);
         _loc5_.TemplateID = _loc4_;
         _loc5_.Level = 1;
         this.FUnstreamizerPet.UnstreamizeMainPet(null,_loc5_,null);
         this.FPetData.OwnMainPets.Add(_loc5_);
         this.FPetData.OwnMainPets.Sort();
         this.FProcessorWindowPetHouse.PlayActivateEffect();
         this.FProcessorWindowPetHouse.UpdatePetActivateInfo();
      }
      
      protected function PerformPacket_SC_Pet_MainPetDelRet(param1:TPacket) : void
      {
         var _loc2_:int = 0;
         var _loc3_:ByteArray = null;
         var _loc4_:int = 0;
         var _loc5_:TPacket = null;
         var _loc6_:TConfigValue = null;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         var _loc10_:TMainPet = null;
         _loc3_ = param1.Data;
         _loc2_ = int(_loc3_.readUnsignedInt());
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         _loc10_ = this.FPetData.OwnMainPets.GetPetByIdentifier(_loc3_.readUnsignedInt(),0) as TMainPet;
         this.FPetData.OwnMainPets.Delete(_loc10_);
         this.FPetData.MainPetSelected = null;
         _loc9_ = _loc3_.readUnsignedInt();
         EffectGenerateText(TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_PET_17),_loc9_));
         this.FProcessorWindowPetActivateWashPoint.Reset();
         this.FProcessorWindowPetActivateWashPoint.Update();
      }
      
      protected function PerformPacket_SC_Pet_MainPetChangeRet(param1:TPacket) : void
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
         SLogicsCore.Character.GetMainHero().MainPetID = _loc3_.readUnsignedInt();
         if(this.FProcessorWindowPetHouse.Visible)
         {
            this.FProcessorWindowPetHouse.Update();
         }
         if(this.FOnUpdateHeroFightNum != null)
         {
            this.FOnUpdateHeroFightNum(this);
         }
      }
      
      protected function PerformPacket_SC_Pet_NotiyPetItemRet(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         _loc2_ = param1.Data;
         this.FPetData.MainPetItemNum = _loc2_.readUnsignedInt();
         if(this.FProcessorWindowPetHouse.Visible)
         {
            this.FProcessorWindowPetHouse.UpdatePetInfo();
         }
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
      
      protected function ProcessorWindowClose(param1:Object) : void
      {
         BarrierDeactuateWindows(param1);
         this.Unmount();
      }
      
      public function ProcessorWindowOnClose(param1:Object) : void
      {
         this.FProcessorWindowPetActivateLine.Reset();
         this.FProcessorWindowPetActivateWashPoint.Reset();
         this.FProcessorWindowPetHouse.Update();
         this.FProcessorWindowPetHouse.Visible = true;
      }
      
      public function ProcessorWindowOnOpenActivateLine(param1:Object) : void
      {
         this.FProcessorWindowPetActivateLine.Update();
         this.FProcessorWindowPetHouse.Visible = false;
         this.FProcessorWindowPetActivateLine.Visible = true;
      }
      
      public function ProcessorWindowOnOpenActivateWashPoint(param1:Object) : void
      {
         this.FProcessorWindowPetActivateWashPoint.Reset();
         this.FPetData.MainPetSelected = null;
         this.FProcessorWindowPetActivateWashPoint.Update();
         this.FProcessorWindowPetHouse.Visible = false;
         this.FProcessorWindowPetActivateWashPoint.Visible = true;
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
      
      public function set OnUpdateHeroFightNum(param1:Function) : void
      {
         this.FOnUpdateHeroFightNum = param1;
      }
      
      override public function Mount(param1:ByteArray = null) : void
      {
         super.Mount(param1);
         if(!FIsResourcesLoadCompleted)
         {
            this.FProcessorWindowPetHouse.Load();
            this.FProcessorWindowPetActivateLine.Load();
            this.FProcessorWindowPetActivateWashPoint.Load();
            return;
         }
         BarrierActuateWindows(this.FProcessorWindowPetHouse);
         this.FProcessorWindowPetHouse.Update();
         this.FProcessorWindowPetHouse.Visible = true;
      }
      
      override public function Unmount() : void
      {
         super.Unmount();
         this.FProcessorWindowPetHouse.Reset();
         this.FProcessorWindowPetHouse.Visible = false;
         this.FProcessorWindowPetActivateLine.Visible = false;
         this.FProcessorWindowPetActivateWashPoint.Visible = false;
      }
      
      public function Reset() : void
      {
      }
   }
}

