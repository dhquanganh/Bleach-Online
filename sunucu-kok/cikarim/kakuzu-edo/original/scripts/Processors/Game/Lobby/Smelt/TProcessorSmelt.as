package Processors.Game.Lobby.Smelt
{
   import Foundation.Network.TPacket;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.TUIComponent;
   import Logics.Characters.THero;
   import Logics.SLogicsCore;
   import Logics.Streamization.Smelt.TUnstreamizerSmelt;
   import Processors.Game.Lobby.Common.TLobbyParameters;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindows;
   import Processors.Game.Lobby.RelatedPartner.TRelatedPartnerCommon;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Resources.Constants.CONST_NETWORK;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.utils.ByteArray;
   
   public class TProcessorSmelt extends TProcessorLobbyWindows
   {
      
      protected const RESOURCESID_Swf:uint = 1056964608;
      
      protected var FMainWin:TProcessorSmeltMainWin;
      
      protected var FUnstreamizer:TUnstreamizerSmelt;
      
      protected var FUpdateRebirthNum:Function;
      
      private var FOnUpdateHeroPower:Function;
      
      public function TProcessorSmelt(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,param2);
         this.FMainWin = new TProcessorSmeltMainWin(this);
         this.FMainWin.OnClose = this.ShutDownWindows;
         this.FMainWin.Visible = false;
         this.FUnstreamizer = new TUnstreamizerSmelt();
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(this.RESOURCESID_Swf);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function PacketRegisterRoutines() : void
      {
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Smelt_ResetRet,this.PacketPerform_SC_ResetRet);
      }
      
      protected function PacketPerform_SC_ResetRet(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:Object = null;
         var _loc5_:THero = null;
         _loc2_ = param1.Data.readUnsignedInt();
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         _loc4_ = this.FUnstreamizer.ResetRet(param1.Data);
         if(_loc4_.Type == TUnstreamizerSmelt.Type_Rebirth)
         {
            _loc5_ = SLogicsCore.Character.Heros.GetHeroByIdentifier(_loc4_.HeroID);
            if(_loc5_.IsMain)
            {
               this.FUpdateRebirthNum(_loc5_.RebirthNum);
            }
         }
         if(_loc4_.Type == TUnstreamizerSmelt.Type_KnifeOfKillSoul)
         {
            this.FMainWin.UpdateUI(false,true);
         }
         else
         {
            this.FMainWin.UpdateUI(true);
         }
         SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_Smelt_12));
         SToolReward.ShowReward(param1.Data);
         if(this.FOnUpdateHeroPower != null)
         {
            this.FOnUpdateHeroPower(this);
         }
      }
      
      protected function ShutDownWindows(param1:Object) : void
      {
         ProcessorClose();
      }
      
      public function set UpdateRebirthNum(param1:Function) : void
      {
         this.FUpdateRebirthNum = param1;
      }
      
      public function get OnUpdateHeroPower() : Function
      {
         return this.FOnUpdateHeroPower;
      }
      
      public function set OnUpdateHeroPower(param1:Function) : void
      {
         this.FOnUpdateHeroPower = param1;
      }
      
      override public function Mount(param1:ByteArray = null) : void
      {
         super.Mount(param1);
         if(!FIsResourcesLoadCompleted)
         {
            this.FMainWin.Load();
            TRelatedPartnerCommon.InitSkillData();
            TRelatedPartnerCommon.SkillInfoReq();
            return;
         }
         this.FMainWin.Visible = true;
         this.FMainWin.UpdateUI(true);
      }
   }
}

