package Processors.Game.Lobby.SpecialCombatPower
{
   import Foundation.Common.TBounds;
   import Foundation.Network.TPacket;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.TUIComponent;
   import Processors.Game.Lobby.Common.TLobbyParameters;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindows;
   import Resources.Constants.CONST_NETWORK;
   import Resources.Constants.CONST_SPECIALCOMBATPOWER;
   import flash.utils.ByteArray;
   
   public class TProcessorSpecialCombatPower extends TProcessorLobbyWindows
   {
      
      protected static const WINDOW_WIDTH:int = 1250;
      
      protected static const WINDOW_HEIGHT:int = 650;
      
      protected const WINDOW_PERSONINFO_WIDTH:int = 970;
      
      protected const WINDOW_PERSONINFO_HEIGHT:int = 565;
      
      protected const SET_WINDOW_POSX:int = 240;
      
      protected const SET_WINDOW_POSY:int = 50;
      
      protected var FProcessorWindowHeroSelect:TProcessorWindowHeroSelect;
      
      protected var FOnUpdateHerosBaseAttributeReq:Function;
      
      public function TProcessorSpecialCombatPower(param1:TUIComponent, param2:TLobbyParameters)
      {
         var _loc3_:TBounds = null;
         super(param1,param2);
         this.FProcessorWindowHeroSelect = new TProcessorWindowHeroSelect(this);
         this.FProcessorWindowHeroSelect.OnClose = this.CloseSubWindow;
         this.FProcessorWindowHeroSelect.OnUpdateHerosBaseAttributeReq = this.UpdateHerosBase;
      }
      
      protected function CloseSubWindow(param1:Object) : void
      {
         ProcessorClose();
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_SPECIALCOMBATPOWER.RESOURCESID_Swf_SpecialCombatPower);
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
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_HeroRecruit_DataRet,this.PerformPacket_SC_RecruitHero);
         super.PacketRegisterRoutines();
      }
      
      protected function PerformPacket_SC_RecruitHero(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _loc2_ = param1.Data;
         _loc3_ = int(_loc2_.readUnsignedInt());
         _loc4_ = int(_loc2_.readUnsignedInt());
         if(_loc3_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc3_);
            return;
         }
         this.FProcessorWindowHeroSelect.RefreshData(_loc4_);
      }
      
      protected function UpdateHerosBase(param1:int) : void
      {
         if(this.FOnUpdateHerosBaseAttributeReq != null)
         {
            this.FOnUpdateHerosBaseAttributeReq(this,param1);
         }
      }
      
      public function get OnUpdateHerosBaseAttributeReq() : Function
      {
         return this.FOnUpdateHerosBaseAttributeReq;
      }
      
      public function set OnUpdateHerosBaseAttributeReq(param1:Function) : void
      {
         this.FOnUpdateHerosBaseAttributeReq = param1;
      }
      
      override public function Mount(param1:ByteArray = null) : void
      {
         super.Mount(param1);
         if(!FIsResourcesLoadCompleted)
         {
            this.FProcessorWindowHeroSelect.Load();
            return;
         }
         this.FProcessorWindowHeroSelect.Show();
      }
      
      override public function Unmount() : void
      {
         super.Unmount();
      }
   }
}

