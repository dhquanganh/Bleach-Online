package Processors.Game.Lobby.Rebirth
{
   import Foundation.Network.TPacket;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityString;
   import Logics.Characters.THero;
   import Logics.Rebirth.TRebirthData;
   import Logics.SLogicsCore;
   import Logics.Streamization.Rebirth.TUnstreamizerRebirth;
   import Processors.Game.Lobby.Common.TLobbyParameters;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindows;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Resources.Constants.CONST_NETWORK;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.utils.ByteArray;
   
   public class TProcessorRebirth extends TProcessorLobbyWindows
   {
      
      protected const RESOURCESID_Swf:uint = 1006632960;
      
      protected var FMainWin:TProcessorWindowRebirthMain;
      
      protected var FUnstreamizer:TUnstreamizerRebirth;
      
      protected var FData:TRebirthData;
      
      protected var FInited:Boolean;
      
      protected var FOnUserUpdateBaseInfo:Function;
      
      protected var FOnUpdateHeroPower:Function;
      
      protected var FUpdateRebirthNum:Function;
      
      public function TProcessorRebirth(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,param2);
         this.FMainWin = new TProcessorWindowRebirthMain(this);
         this.FMainWin.OnClose = this.ShutDownWindows;
         this.FMainWin.Visible = false;
         this.FData = SLogicsCore.RebirthData;
         this.FUnstreamizer = new TUnstreamizerRebirth(this.FData);
         this.FInited = false;
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(this.RESOURCESID_Swf);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function PacketRegisterRoutines() : void
      {
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Rebirth_RebirthRet,this.PacketPerform_SC_RebirthRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Rebirth_ResetRet,this.PacketPerform_SC_ResetRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Rebirth_GetExpBookRet,this.PacketPerform_SC_GetExpBookRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Rebirth_InitRet,this.PacketPerform_SC_InitRet);
      }
      
      protected function PacketPerform_SC_RebirthRet(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:int = 0;
         var _loc4_:THero = null;
         _loc2_ = param1.Data.readUnsignedInt();
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         _loc3_ = this.FUnstreamizer.RebirthRet(param1.Data);
         this.FMainWin.UpdateUI();
         this.ProcessorOnUserUpdateBaseInfo();
         this.ProcessorUpdateHeroPower(_loc3_);
         _loc4_ = SLogicsCore.Character.Heros.GetHeroByIdentifier(_loc3_);
         if(_loc4_.IsMain)
         {
            this.FUpdateRebirthNum(_loc4_.RebirthNum);
         }
      }
      
      protected function PacketPerform_SC_ResetRet(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:Object = null;
         var _loc4_:String = null;
         var _loc5_:THero = null;
         _loc2_ = param1.Data.readUnsignedInt();
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         _loc3_ = this.FUnstreamizer.ResetRet(param1.Data);
         this.FMainWin.UpdateUI();
         _loc4_ = "";
         _loc5_ = SLogicsCore.Character.Heros.GetHeroByIdentifier(_loc3_.HeroID);
         if(_loc3_.Attr == 1)
         {
            _loc4_ += TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_Rebirth_24),TUtilityLobby.GetStringsByIdentifier(CONST_SYSTEMLANGUAGE.STRING_Rebirth_14)[_loc5_.PropPower - 1]);
         }
         if(_loc3_.Effect == 1)
         {
            if(_loc4_ != "")
            {
               _loc4_ += "\n";
            }
            _loc4_ += TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_Rebirth_25),TUtilityLobby.GetStringsByIdentifier(CONST_SYSTEMLANGUAGE.STRING_Rebirth_12)[_loc5_.AttackEffect - 1]);
         }
         SToolReward.ShowMessage(_loc4_);
      }
      
      protected function PacketPerform_SC_GetExpBookRet(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:int = 0;
         var _loc4_:uint = 0;
         _loc2_ = param1.Data.readUnsignedInt();
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         _loc3_ = this.FUnstreamizer.GetExpBookRet(param1.Data);
         this.FMainWin.UpdateUI();
         if(_loc3_ == 1)
         {
            _loc4_ = CONST_SYSTEMLANGUAGE.STRING_Rebirth_21;
         }
         else
         {
            _loc4_ = CONST_SYSTEMLANGUAGE.STRING_Rebirth_22;
         }
         SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(_loc4_));
      }
      
      protected function PacketPerform_SC_InitRet(param1:TPacket) : void
      {
         this.FUnstreamizer.InitRet(param1.Data);
         this.FMainWin.Visible = true;
         this.FMainWin.UpdateUI();
         this.FInited = true;
      }
      
      protected function ProcessorOnUserUpdateBaseInfo() : void
      {
         if(this.FOnUserUpdateBaseInfo != null)
         {
            this.FOnUserUpdateBaseInfo(this);
         }
      }
      
      protected function ProcessorUpdateHeroPower(param1:uint) : void
      {
         if(this.FOnUpdateHeroPower != null)
         {
            this.FOnUpdateHeroPower(this,param1);
         }
      }
      
      protected function ShutDownWindows(param1:Object) : void
      {
         ProcessorClose();
      }
      
      public function set OnUserUpdateBaseInfo(param1:Function) : void
      {
         this.FOnUserUpdateBaseInfo = param1;
      }
      
      public function set OnUpdateHeroPower(param1:Function) : void
      {
         this.FOnUpdateHeroPower = param1;
      }
      
      public function set UpdateRebirthNum(param1:Function) : void
      {
         this.FUpdateRebirthNum = param1;
      }
      
      override public function Mount(param1:ByteArray = null) : void
      {
         super.Mount(param1);
         if(this.FMainWin != null)
         {
            this.FMainWin.Reset();
         }
         if(!FIsResourcesLoadCompleted)
         {
            this.FMainWin.Load();
            return;
         }
         if(this.FInited)
         {
            this.FMainWin.Visible = true;
            this.FMainWin.UpdateUI();
         }
         else
         {
            this.FUnstreamizer.InitReq();
         }
      }
      
      override public function Unmount() : void
      {
         super.Unmount();
      }
   }
}

