package Processors.Game.Lobby.Welcome
{
   import Foundation.Common.TBounds;
   import Foundation.Network.TPacket;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.TUIComponent;
   import Logics.SLogicsCore;
   import Processors.Game.Lobby.Common.TLobbyParameters;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindows;
   import Resources.Constants.CONST_FRESHGUIDE;
   import Resources.Constants.CONST_NETWORK;
   import Resources.Constants.CONST_WELCOME;
   import flash.utils.ByteArray;
   
   public class TProcessorWelcome extends TProcessorLobbyWindows
   {
      
      protected static const WINDOWWELCOME_WIDTH:int = 527;
      
      protected static const WINDOWWELCOME_HEIGHT:int = 464;
      
      protected var FWindowWelcome:TWindowWelcome;
      
      protected var FBoundsWelcome:TBounds;
      
      protected var FWindowNip:TWindowNip;
      
      protected var FBoundsNip:TBounds;
      
      protected var FOnChangeClothesComplete:Function;
      
      public function TProcessorWelcome(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,param2);
         this.FWindowWelcome = new TWindowWelcome(this);
         this.FWindowWelcome.OnChangeClothes = this.CallBack_GotoNipWindow;
         this.FBoundsWelcome = new TBounds();
         this.FBoundsWelcome.Width = WINDOWWELCOME_WIDTH;
         this.FBoundsWelcome.Height = WINDOWWELCOME_HEIGHT;
         ComponentBoundsCenter(this.FWindowWelcome,this.FBoundsWelcome);
         this.FWindowNip = new TWindowNip(this);
         this.FBoundsNip = new TBounds();
         this.FBoundsNip.Width = WINDOWWELCOME_WIDTH;
         this.FBoundsNip.Height = WINDOWWELCOME_HEIGHT;
         ComponentBoundsCenter(this.FWindowNip,this.FBoundsNip);
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_WELCOME.RESOURCESID_Swf_Welcome);
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
         super.PacketRegisterRoutines();
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Welcome_NipRet,this.PerformPacket_SC_NipRet);
      }
      
      protected function PerformPacket_SC_NipRet(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         _loc2_ = param1.Data.readUnsignedInt();
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         SLogicsCore.Character.GirlClothesID = param1.Data.readUnsignedInt();
         ProcessorClose();
         if(this.FOnChangeClothesComplete != null)
         {
            this.FOnChangeClothesComplete(this);
         }
      }
      
      protected function CallBack_GotoNipWindow(param1:Object) : void
      {
         this.FWindowWelcome.Visible = Visible;
         TutorialNextStep(CONST_FRESHGUIDE.EVENTID_ClickWelcomeBtn);
         this.FWindowNip.InitNipGirl();
         this.FWindowNip.Visible = true;
      }
      
      public function set OnChangeClothesComplete(param1:Function) : void
      {
         this.FOnChangeClothesComplete = param1;
      }
      
      override public function Mount(param1:ByteArray = null) : void
      {
         super.Mount(param1);
         if(!FIsResourcesLoadCompleted)
         {
            this.FWindowWelcome.Load();
            this.FWindowNip.Load();
            return;
         }
         this.FWindowWelcome.Visible = true;
         this.FWindowWelcome.Action();
      }
      
      override public function Unmount() : void
      {
         super.Unmount();
      }
   }
}

