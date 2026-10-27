package Processors.Game.Lobby.ProfessionRefine.Component
{
   import Components.Slots.TUISlot;
   import Components.Standard.TUIButton;
   import Foundation.Network.SNetworkCore;
   import Foundation.Network.TPacket;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.VO.TProfessionRefineAVO;
   import Logics.Inventories.TInventories;
   import Logics.ProfessionRefine.TProfessionRefine;
   import Logics.SLogicsCore;
   import Processors.Game.ComponentNew.TUICustomComponent;
   import Processors.Game.ComponentNew.TUtilityMovieClip;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Processors.Game.Windows.Information.TUIWindowConfirmation;
   import Resources.Constants.CONST_COMMON;
   import Resources.Constants.CONST_LOBBY;
   import Resources.Constants.CONST_NETWORK;
   import Resources.Constants.CONST_ProfessionRefine;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import Utilities.UI.Windows.TUtilityUIWindow;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.utils.ByteArray;
   
   public class TUILevelupInfo extends TUICustomComponent
   {
      
      protected var FMCIcon:MovieClip;
      
      protected var FTFCurlevel:TextField;
      
      protected var FTFNextlevel:TextField;
      
      protected var FTFCurValueVec:Vector.<TextField>;
      
      protected var FTFNextValueVec:Vector.<TextField>;
      
      protected var FUISlot:TUISlot;
      
      protected var FTFCost:TextField;
      
      protected var FTFOwn:TextField;
      
      protected var FBtnLevelup:TUIButton;
      
      protected var FUIWindowConfirmationSell:TUIWindowConfirmation;
      
      public function TUILevelupInfo(param1:TUIComponent)
      {
         super();
         FParent = param1;
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TextField = null;
         this.FMCIcon = FResource["MC_HeroType"];
         this.FMCIcon.mouseChildren = false;
         this.FMCIcon.mouseEnabled = false;
         TUtilityMovieClip.StopMovieClipAction(this.FMCIcon);
         this.FTFCurlevel = FResource["TF_CurLevel"];
         this.FTFCurlevel.mouseEnabled = false;
         this.FTFNextlevel = FResource["TF_NextLevel"];
         this.FTFNextlevel.mouseEnabled = false;
         _loc2_ = GetUIComponentsCapacity(FResource,"TF_Cur_");
         this.FTFCurValueVec = new Vector.<TextField>(_loc2_);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = FResource["TF_Cur_" + _loc1_];
            _loc3_.mouseEnabled = false;
            this.FTFCurValueVec[_loc1_] = _loc3_;
            _loc1_++;
         }
         _loc2_ = GetUIComponentsCapacity(FResource,"TF_Next_");
         this.FTFNextValueVec = new Vector.<TextField>(_loc2_);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = FResource["TF_Next_" + _loc1_];
            _loc3_.mouseEnabled = false;
            this.FTFNextValueVec[_loc1_] = _loc3_;
            _loc1_++;
         }
         this.FUISlot = new TUISlot(FParent);
         this.FUISlot.Resource = FResource["SP_Slot"];
         this.FUISlot.SequenceDefaultIcon = SResourcesCore.TexturesLobby.GetAnimationSequenceByIdentifiers(CONST_LOBBY.RESOURCESID_Texture_SlotDefaultEffect,0);
         this.FUISlot.OnQuerySequenceContext = OnQuerySequenceContext;
         this.FUISlot.OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FUISlot.OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FUISlot.Init();
         this.FTFCost = FResource["TF_Cost"];
         this.FTFCost.mouseEnabled = false;
         this.FTFOwn = FResource["TF_Own"];
         this.FTFOwn.mouseEnabled = false;
         this.FBtnLevelup = new TUIButton();
         this.FBtnLevelup.Substrate = FResource["Btn_Level"];
         this.FBtnLevelup.OnClick = this.LevelupOnClick;
         this.FUIWindowConfirmationSell = new TUIWindowConfirmation(this.Parent.Parent);
         this.FUIWindowConfirmationSell.OnOK = this.LevelupOnOK;
         TUtilityUIWindow.SetupWindowConfirmation(this.FUIWindowConfirmationSell);
         this.FUIWindowConfirmationSell.SetCheckBoxUsable(false);
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function UpdateUI() : void
      {
         var _loc1_:TProfessionRefine = null;
         var _loc2_:TInventories = null;
         super.UpdateUI();
         _loc1_ = FUserData as TProfessionRefine;
         this.FMCIcon.gotoAndStop(_loc1_.HeroType);
         _loc2_ = new TInventories();
         SToolReward.GetInventoryByID(CONST_ProfessionRefine.BloodStoneId,_loc2_);
         this.FUISlot.Context = _loc2_.GetInventoryByIndex(0);
         this.UpdateInfo();
      }
      
      protected function UpdateInfo() : void
      {
         var _loc1_:TProfessionRefine = null;
         var _loc2_:TProfessionRefineAVO = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _loc1_ = FUserData as TProfessionRefine;
         this.FTFCurlevel.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TeamBattle_String_14),_loc1_.CurLevel) + (_loc1_.IsMax ? TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ProfessionRefine_SysText_01) : "");
         this.FTFNextlevel.text = _loc1_.IsMax ? "" : TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TeamBattle_String_14),_loc1_.CurLevel + 1);
         if(_loc1_.CurLevel > 0)
         {
            _loc2_ = _loc1_.CurLevelAVO;
            this.FTFCurValueVec[0].text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.KnifeOfKillSoul_STRING_8),(Number(_loc2_.PhyAtk) * 100).toFixed(1));
            this.FTFCurValueVec[1].text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.KnifeOfKillSoul_STRING_8),(Number(_loc2_.MagicAtk) * 100).toFixed(1));
            this.FTFCurValueVec[2].text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.KnifeOfKillSoul_STRING_8),(Number(_loc2_.PhyDef) * 100).toFixed(1));
            this.FTFCurValueVec[3].text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.KnifeOfKillSoul_STRING_8),(Number(_loc2_.MagicDef) * 100).toFixed(1));
            this.FTFCurValueVec[4].text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.KnifeOfKillSoul_STRING_8),(Number(_loc2_.Hp) * 100).toFixed(1));
            this.FTFCurValueVec[5].text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.KnifeOfKillSoul_STRING_8),(Number(_loc2_.Speed) * 100).toFixed(1));
         }
         else
         {
            this.FTFCurValueVec[0].text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.KnifeOfKillSoul_STRING_8),0);
            this.FTFCurValueVec[1].text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.KnifeOfKillSoul_STRING_8),0);
            this.FTFCurValueVec[2].text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.KnifeOfKillSoul_STRING_8),0);
            this.FTFCurValueVec[3].text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.KnifeOfKillSoul_STRING_8),0);
            this.FTFCurValueVec[4].text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.KnifeOfKillSoul_STRING_8),0);
            this.FTFCurValueVec[5].text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.KnifeOfKillSoul_STRING_8),0);
         }
         if(!_loc1_.IsMax)
         {
            _loc2_ = _loc1_.NextLevelAVO;
            this.FTFNextValueVec[0].text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.KnifeOfKillSoul_STRING_8),(Number(_loc2_.PhyAtk) * 100).toFixed(1));
            this.FTFNextValueVec[1].text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.KnifeOfKillSoul_STRING_8),(Number(_loc2_.MagicAtk) * 100).toFixed(1));
            this.FTFNextValueVec[2].text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.KnifeOfKillSoul_STRING_8),(Number(_loc2_.PhyDef) * 100).toFixed(1));
            this.FTFNextValueVec[3].text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.KnifeOfKillSoul_STRING_8),(Number(_loc2_.MagicDef) * 100).toFixed(1));
            this.FTFNextValueVec[4].text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.KnifeOfKillSoul_STRING_8),(Number(_loc2_.Hp) * 100).toFixed(1));
            this.FTFNextValueVec[5].text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.KnifeOfKillSoul_STRING_8),(Number(_loc2_.Speed) * 100).toFixed(1));
         }
         else
         {
            this.FTFNextValueVec[0].text = "";
            this.FTFNextValueVec[1].text = "";
            this.FTFNextValueVec[2].text = "";
            this.FTFNextValueVec[3].text = "";
            this.FTFNextValueVec[4].text = "";
            this.FTFNextValueVec[5].text = "";
         }
         _loc4_ = !_loc1_.IsMax ? _loc1_.NextLevelAVO.Cost : 0;
         this.FTFCost.text = _loc4_ + "";
         _loc3_ = int(SLogicsCore.Character.Appliances.GetInventoryAllNumByTempletID(CONST_ProfessionRefine.BloodStoneId));
         this.FTFOwn.text = _loc3_ + "";
         this.FTFOwn.textColor = _loc3_ >= _loc4_ ? CONST_COMMON.QUALITYCOLOR_Green : CONST_COMMON.QUALITYCOLOR_Red;
         this.FBtnLevelup.Enabled = !_loc1_.IsMax && _loc3_ >= _loc4_;
      }
      
      protected function LevelupOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TProfessionRefine = null;
         var _loc4_:Vector.<String> = null;
         _loc3_ = FUserData as TProfessionRefine;
         _loc4_ = TUtilityLobby.GetStringsByIdentifier(CONST_SYSTEMLANGUAGE.ProfessionRefine_SysText_02);
         this.FUIWindowConfirmationSell.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ProfessionRefine_SysText_03),_loc4_[_loc3_.HeroType - 1]);
         this.FUIWindowConfirmationSell.Visible = true;
      }
      
      protected function LevelupOnOK(param1:Object) : void
      {
         var _loc2_:TProfessionRefine = null;
         var _loc3_:TPacket = null;
         var _loc4_:ByteArray = null;
         _loc2_ = FUserData as TProfessionRefine;
         _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_ProfessionRefine_Levelup);
         _loc4_ = _loc3_.Data;
         _loc4_.writeInt(_loc2_.HeroType);
         SNetworkCore.Transceiver.PacketTransmit(_loc3_);
      }
      
      override public function Reset() : void
      {
         TUtilityMovieClip.StopMovieClipAction(this.FMCIcon);
         super.Reset();
      }
      
      public function LogicsPerform() : void
      {
         this.FUISlot.Update();
      }
      
      public function LevelupSuccess() : void
      {
         this.UpdateInfo();
      }
   }
}

