package Processors.Game.Lobby.ProfessionRefine
{
   import Foundation.Common.TBounds;
   import Foundation.Network.SNetworkCore;
   import Foundation.Network.TPacket;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.TUIComponent;
   import Logics.Characters.THero;
   import Logics.ProfessionRefine.TProfessionRefineList;
   import Logics.ProfessionRefine.Unstreamizer.SUnstreamizerProfessionRefine;
   import Logics.SLogicsCore;
   import Processors.Game.Lobby.Common.TLobbyParameters;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindows;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Resources.Constants.CONST_NETWORK;
   import Resources.Constants.CONST_ProfessionRefine;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.utils.ByteArray;
   
   public class TUIProcessorProfessionRefine extends TProcessorLobbyWindows
   {
      
      protected static const SIZE_Window_Width:uint = 685;
      
      protected static const SIZE_Window_Height:uint = 477;
      
      protected var FUIProcessorWindowProfessionRefine:TUIProcessorWindowProfessionRefine;
      
      protected var FDailyBounds:TBounds;
      
      protected var FProfessionRefineList:TProfessionRefineList;
      
      protected var FUpdateHeroPower:Function;
      
      public function TUIProcessorProfessionRefine(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,param2);
         this.FUIProcessorWindowProfessionRefine = new TUIProcessorWindowProfessionRefine(this);
         this.FUIProcessorWindowProfessionRefine.OnClose = this.ProcessorOnClose;
         this.FDailyBounds = new TBounds();
         this.FDailyBounds.Width = SIZE_Window_Width;
         this.FDailyBounds.Height = SIZE_Window_Height;
         this.FDailyBounds.X = this.FUIProcessorWindowProfessionRefine.X;
         this.FDailyBounds.Y = this.FUIProcessorWindowProfessionRefine.Y;
         ComponentBoundsCenter(this.FUIProcessorWindowProfessionRefine,this.FDailyBounds);
         this.FProfessionRefineList = SLogicsCore.ProfessionRefineList;
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_ProfessionRefine.RESOURCESID_Swf_ProfessionRefine);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function PacketRegisterRoutines() : void
      {
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_ProfessionRefine_Info,this.PacketPerform_SC_Info);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_ProfessionRefine_Mall,this.PacketPerform_SC_Mall);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_ProfessionRefine_Levelup,this.PacketPerform_SC_Levelup);
         super.PacketRegisterRoutines();
      }
      
      protected function ProcessorOnClose(param1:Object) : void
      {
         ProcessorClose();
      }
      
      protected function PacketPerform_SC_Info(param1:TPacket) : void
      {
         SUnstreamizerProfessionRefine.UnstreamizationPerform_Info(param1.Data,this.FProfessionRefineList,null);
         if(this.FUIProcessorWindowProfessionRefine.Visible)
         {
            this.FUIProcessorWindowProfessionRefine.Update();
         }
      }
      
      protected function PacketPerform_SC_Mall(param1:TPacket) : void
      {
         var _loc2_:int = 0;
         var _loc3_:ByteArray = null;
         _loc3_ = param1.Data;
         this.FProfessionRefineList.Pending = false;
         _loc2_ = int(_loc3_.readUnsignedInt());
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ProfessionRefine_SysText_05));
         if(this.FUIProcessorWindowProfessionRefine.Visible)
         {
            this.FUIProcessorWindowProfessionRefine.MallSuccess();
         }
      }
      
      protected function PacketPerform_SC_Levelup(param1:TPacket) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:ByteArray = null;
         var _loc6_:Object = null;
         var _loc7_:THero = null;
         _loc6_ = new Object();
         _loc5_ = param1.Data;
         this.FProfessionRefineList.Pending = false;
         _loc4_ = int(_loc5_.readUnsignedInt());
         if(_loc4_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc4_);
            return;
         }
         SUnstreamizerProfessionRefine.UnstreamizationPerform_Levelup(_loc5_,this.FProfessionRefineList,_loc6_);
         EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ProfessionRefine_SysText_06));
         if(this.FUIProcessorWindowProfessionRefine.Visible)
         {
            this.FUIProcessorWindowProfessionRefine.LevelupSuccess(_loc6_.HeroType);
         }
         if(this.FUpdateHeroPower != null)
         {
            _loc3_ = int(SLogicsCore.Character.Heros.Count);
            _loc2_ = 0;
            while(_loc2_ < _loc3_)
            {
               _loc7_ = SLogicsCore.Character.Heros.GetHeroByIndex(_loc2_);
               if(_loc7_.Profession == _loc6_.HeroType)
               {
                  this.FUpdateHeroPower(this,_loc7_.Identifier,false);
               }
               _loc2_++;
            }
         }
         _loc6_ = null;
      }
      
      protected function RequestInfo() : void
      {
         var _loc1_:TPacket = null;
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_ProfessionRefine_Info);
         SNetworkCore.Transceiver.PacketTransmit(_loc1_);
      }
      
      public function set UpdateHeroPower(param1:Function) : void
      {
         this.FUpdateHeroPower = param1;
      }
      
      override public function Mount(param1:ByteArray = null) : void
      {
         super.Mount(param1);
         if(!FIsResourcesLoadCompleted)
         {
            this.FUIProcessorWindowProfessionRefine.Load();
            return;
         }
         this.RequestInfo();
         if(param1 != null)
         {
            this.FUIProcessorWindowProfessionRefine.SetTabIndex(param1.readUnsignedInt());
         }
         this.FUIProcessorWindowProfessionRefine.Show();
      }
      
      override public function Unmount() : void
      {
         super.Unmount();
         this.FUIProcessorWindowProfessionRefine.Hide();
      }
   }
}

