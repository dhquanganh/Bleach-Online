package Processors.Game.Lobby.ChangePlayerInfo
{
   import Foundation.Common.TBounds;
   import Foundation.Network.TPacket;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.TUIComponent;
   import Processors.Game.Lobby.Common.TLobbyParameters;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindows;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Resources.Constants.CONST_NETWORK;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.utils.ByteArray;
   
   public class TProcessorChangeInfo extends TProcessorLobbyWindows
   {
      
      public static const SIZE_Width:uint = 478;
      
      public static const SIZE_Height:uint = 321;
      
      protected const RESOURCESID_SwfCountry:uint = 905969664;
      
      protected const RESOURCESID_SwfName:uint = 973078528;
      
      protected var FCountryWin:TProcessorWindowChangeCountry;
      
      protected var FNameWin:TProcessorWindowChangeName;
      
      protected var FBounds:TBounds;
      
      protected var FStream:ByteArray;
      
      public function TProcessorChangeInfo(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,param2);
         this.FStream = new ByteArray();
         this.FCountryWin = new TProcessorWindowChangeCountry(this);
         this.FCountryWin.OnClose = this.ShutDownWindows;
         this.FCountryWin.OnEffectText = ProcessorsOnEffectText;
         this.FCountryWin.Visible = false;
         this.FBounds = new TBounds();
         this.FBounds.Width = SIZE_Width;
         this.FBounds.Height = SIZE_Height;
         ComponentBoundsCenter(this.FCountryWin,this.FBounds);
         this.FBounds = null;
         this.FNameWin = new TProcessorWindowChangeName(this);
         this.FNameWin.OnClose = this.ShutDownWindows;
         this.FNameWin.OnEffectText = ProcessorsOnEffectText;
         this.FNameWin.Visible = false;
         this.FBounds = new TBounds();
         this.FBounds.Width = SIZE_Width;
         this.FBounds.Height = SIZE_Height;
         ComponentBoundsCenter(this.FNameWin,this.FBounds);
         this.FBounds = null;
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(this.RESOURCESID_SwfCountry);
         SResourcesCore.TexturesSwfLobby.LoadPrimary(this.RESOURCESID_SwfName);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function PacketRegisterRoutines() : void
      {
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_ChangeInfo_ChangeNameRet,this.PacketPerform_SC_ChangeNameRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_ChangeInfo_ChangeCountryRet,this.PacketPerform_SC_ChangeCountryRet);
      }
      
      private function PacketPerform_SC_ChangeNameRet(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:ByteArray = null;
         var _loc4_:String = null;
         _loc3_ = param1.Data;
         _loc2_ = _loc3_.readUnsignedInt();
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         _loc4_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ChangeInfo_02);
         EffectGenerateText(_loc4_);
         this.FNameWin.Close();
      }
      
      private function PacketPerform_SC_ChangeCountryRet(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:ByteArray = null;
         var _loc4_:String = null;
         var _loc5_:uint = 0;
         _loc3_ = param1.Data;
         _loc2_ = _loc3_.readUnsignedInt();
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         _loc5_ = uint(_loc3_.readByte());
         this.FCountryWin.Country = _loc5_;
         _loc4_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ChangeInfo_02);
         EffectGenerateText(_loc4_);
         this.FCountryWin.Close();
      }
      
      protected function ShutDownWindows(param1:Object) : void
      {
         ProcessorClose();
      }
      
      override public function Mount(param1:ByteArray = null) : void
      {
         super.Mount(param1);
         if(param1 != null)
         {
            this.FStream = param1;
         }
         if(!FIsResourcesLoadCompleted)
         {
            this.FNameWin.Load();
            this.FCountryWin.Load();
            return;
         }
         if(this.FStream.readUnsignedInt() == 0)
         {
            this.FNameWin.Visible = true;
         }
         else
         {
            this.FCountryWin.UpdateBtn();
            this.FCountryWin.Visible = true;
         }
      }
   }
}

