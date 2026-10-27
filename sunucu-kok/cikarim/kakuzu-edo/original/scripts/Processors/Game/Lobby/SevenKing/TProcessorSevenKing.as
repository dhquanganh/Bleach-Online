package Processors.Game.Lobby.SevenKing
{
   import Foundation.Common.*;
   import Foundation.Network.*;
   import Foundation.Resources.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.Characters.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.SevenKing.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Rendering.Overlayers.*;
   import Rendering.Overlayers.HelpTips.*;
   import Rendering.Overlayers.Hints.*;
   import Rendering.Overlayers.NijiaStar.*;
   import Resources.Constants.CONST_BATTLE;
   import Resources.Constants.CONST_COMMON;
   import Resources.Constants.CONST_NETWORK;
   import Resources.Constants.CONST_SEVENKING;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import Resources.Strings.*;
   import Utilities.UI.Overlayers.*;
   import flash.display.*;
   import flash.utils.*;
   import ghostcat.util.data.*;
   
   public class TProcessorSevenKing extends TProcessorLobbyPlate
   {
      
      protected var FScene:MovieClip;
      
      protected var FProcessorWindowSevenKing:TProcessorWindowSevenKing;
      
      protected var FProcessorWindowHeroSelect:TProcessorWindowHeroSelect;
      
      protected var FProcessorWindowFightResult:TProcessorWindowFightResult;
      
      protected var FProcessorWindowSevenHeroList:TProcessorWindowSevenHeroList;
      
      protected var FMountPointWindow:TUIComponent;
      
      protected var FOverLayerKingSoul:TOverLayerKingSoul;
      
      protected var FSevenKingData:TSevenKingData;
      
      protected var FCharacter:TCharacter;
      
      protected var FSevenHeroArmy:TSevenHeroArmy;
      
      protected var FBattleBack:Boolean;
      
      protected var FOnReturnTown:Function;
      
      protected var FOnInitBattle:Function;
      
      protected var FOnSetBattleStatus:Function;
      
      protected var FOnToStarsMap:Function;
      
      public function TProcessorSevenKing(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,param2);
         this.FSevenKingData = new TSevenKingData();
         this.FCharacter = SLogicsCore.Character;
         this.FMountPointWindow = param2.MountPointWindow;
         this.FBattleBack = false;
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_SEVENKING.RESOURCESID_SEVENKING);
         SResourcesCore.TexturesSwfCommon.LoadPrimary(CONST_COMMON.RESOURCESID_SwfCommon_Common);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         this.FScene = TUtilityReflection.CreateDisplayObjectInstance(CONST_SEVENKING.RESOURCESID_CLASSNAME_SevenKing) as MovieClip;
         addChild(this.FScene);
         this.FProcessorWindowSevenKing = new TProcessorWindowSevenKing(this,this.FScene.mc_publicBox);
         this.FProcessorWindowSevenKing.OnHelpTipsOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FProcessorWindowSevenKing.OnHelpTipsOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FProcessorWindowSevenKing.OnEnterCity = this.OnCloseTavern;
         this.FProcessorWindowSevenKing.UIComponentsOnOver = this.UIComponentsOverlayerOnOver;
         this.FProcessorWindowSevenKing.UIComponentsOnOut = this.UIComponentsOverlayerOnOut;
         this.FProcessorWindowSevenKing.OnToStars = this.OnToStars;
         this.FProcessorWindowSevenHeroList = new TProcessorWindowSevenHeroList(this,this.FScene.MC_Heros,this.FSevenKingData);
         this.FProcessorWindowSevenHeroList.SelectHeroFight = this.SelectHeroFight;
         this.FProcessorWindowSevenHeroList.UIComponentsOnOver = this.UIComponentsOverlayerOnOver;
         this.FProcessorWindowSevenHeroList.UIComponentsOnOut = this.UIComponentsOverlayerOnOut;
         this.FProcessorWindowSevenHeroList.UIHintOnOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FProcessorWindowSevenHeroList.UIHintOnOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FProcessorWindowSevenHeroList.OnEffectText = this.TextOnEffect;
         this.FProcessorWindowSevenHeroList.HeroListInit();
         this.FProcessorWindowHeroSelect = new TProcessorWindowHeroSelect(this,this.FSevenKingData);
         this.FProcessorWindowHeroSelect.Visible = false;
         this.FProcessorWindowFightResult = new TProcessorWindowFightResult(this);
         this.FProcessorWindowFightResult.Visible = false;
         this.FProcessorWindowFightResult.ChangeHero = this.ProcessorChangeHero;
         this.FOverLayerKingSoul = new TOverLayerKingSoul(this.FMountPointWindow);
         this.FOverLayerKingSoul.visible = false;
         TUtilityUIOverlayer.ResourcesDispatch(this.FOverLayerKingSoul);
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(!this.Visible)
         {
            return;
         }
         if(this.FProcessorWindowSevenKing != null)
         {
            this.FProcessorWindowSevenKing.UpdataEffect();
         }
         if(this.FProcessorWindowHeroSelect != null && this.FProcessorWindowHeroSelect.Visible == true)
         {
            this.FProcessorWindowHeroSelect.ShowHeroHead();
         }
         if(this.FProcessorWindowSevenHeroList != null)
         {
            this.FProcessorWindowSevenHeroList.UpdateHero();
         }
      }
      
      protected function EnterSevenKing() : void
      {
         this.FProcessorWindowSevenKing.UpdataPublicUI();
         this.FProcessorWindowSevenHeroList.UpdateUI();
         this.FProcessorWindowHeroSelect.Visible = false;
         this.FProcessorWindowFightResult.Visible = false;
      }
      
      protected function SelectHeroFight(param1:Object, param2:TSevenHeroArmy) : void
      {
         this.FSevenHeroArmy = param2;
         this.FProcessorWindowHeroSelect.SetHeroFight(param2);
         this.FProcessorWindowHeroSelect.Visible = true;
         this.FProcessorWindowHeroSelect.ReportReq();
      }
      
      protected function ProcessorChangeHero(param1:Object) : void
      {
         this.FProcessorWindowHeroSelect.SetHeroFight(this.FSevenHeroArmy);
         this.FProcessorWindowHeroSelect.Visible = true;
      }
      
      override protected function PacketRegisterRoutines() : void
      {
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_SevenKing_FightRet,this.PacketPerform_SC_FightRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_SevenKing_RespectRet,this.PacketPerform_SC_RespectRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_SevenKing_ReportRet,this.PacketPerform_SC_ReportRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_SevenKing_ResetNotify,this.PacketPerform_SC_ResetNotif);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_SevenKing_ReportNotify,this.PacketPerform_SC_ReportNotify);
      }
      
      protected function PacketPerform_SC_Enter_SevenKing(param1:ByteArray) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         this.FSevenKingData.CurBattleTimes = param1.readUnsignedShort();
         this.FSevenKingData.CurProgressFlag = param1.readUnsignedInt();
         _loc3_ = param1.readUnsignedShort();
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FSevenKingData.RespectInfo[_loc2_ + 1] = param1.readUnsignedByte();
            _loc2_++;
         }
         _loc3_ = param1.readUnsignedShort();
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FCharacter.SetKingSoulByIndex(_loc2_,param1.readUnsignedInt());
            _loc2_++;
         }
         this.FCharacter.RoleSencePosition = CONST_COMMON.SCENEPOSITION_SEVENKING;
      }
      
      protected function PacketPerform_SC_FightRet(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:uint = 0;
         var _loc4_:Boolean = false;
         var _loc5_:Boolean = false;
         var _loc6_:Object = null;
         var _loc7_:uint = 0;
         var _loc8_:String = null;
         _loc2_ = param1.Data;
         _loc3_ = _loc2_.readUnsignedInt();
         if(_loc3_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc3_);
            return;
         }
         if(this.FOnSetBattleStatus != null)
         {
            this.FOnSetBattleStatus(this,CONST_BATTLE.BattleType_SevenKing,0);
         }
         if(this.FOnInitBattle != null)
         {
            this.FOnInitBattle(this);
         }
         ++this.FSevenKingData.CurBattleTimes;
         _loc4_ = Boolean(_loc2_.readUnsignedByte());
         _loc5_ = Boolean(_loc2_.readUnsignedByte());
         this.FProcessorWindowFightResult.SetResult(_loc4_,_loc5_,this.FSevenHeroArmy);
         this.FProcessorWindowFightResult.Visible = true;
         if(_loc4_ && !_loc5_)
         {
            _loc6_ = Json.decode(this.FSevenHeroArmy.ManyWinReward);
            _loc7_ = this.FCharacter.GetKingSoulByIndex(_loc6_[0].code - 12);
            this.FProcessorWindowSevenKing.SetHeroSoulByIndex(_loc6_[0].code - 12,_loc7_ + _loc6_[0].amount);
            this.FCharacter.SetKingSoulByIndex(_loc6_[0].code - 12,_loc7_ + _loc6_[0].amount);
            ++this.FSevenKingData.CurProgressFlag;
            this.FProcessorWindowSevenHeroList.UpdatePillarState();
            _loc8_ = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.SEVENHERO_STRING_11),TUtilityLobby.GetItemName(_loc6_[0].type,_loc6_[0].code),_loc6_[0].amount);
            EffectGenerateText(_loc8_);
         }
      }
      
      protected function PacketPerform_SC_RespectRet(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:String = null;
         var _loc8_:Boolean = false;
         _loc2_ = param1.Data;
         _loc3_ = _loc2_.readUnsignedInt();
         if(_loc3_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc3_);
            return;
         }
         _loc4_ = _loc2_.readUnsignedInt();
         _loc5_ = _loc2_.readUnsignedInt();
         _loc6_ = _loc2_.readUnsignedInt();
         _loc8_ = Boolean(_loc2_.readUnsignedByte());
         this.FSevenKingData.RespectInfo[this.FProcessorWindowSevenHeroList.SelectKingIndex + 1] += this.FProcessorWindowSevenHeroList.RespectCount;
         this.FProcessorWindowSevenKing.SetHeroSoulByIndex(_loc4_ % 10,this.FCharacter.GetKingSoulByIndex(_loc4_ % 10) + _loc5_);
         this.FCharacter.SetKingSoulByIndex(_loc4_ % 10,this.FCharacter.GetKingSoulByIndex(_loc4_ % 10) + _loc5_);
         this.FProcessorWindowSevenHeroList.UpdatePillarState();
         SUtilityOverLayer.HideTip();
         if(_loc8_)
         {
            if(_loc6_ != 0)
            {
               _loc7_ = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.SEVENHERO_STRING_10),_loc6_,TUtilityLobby.GetStringsByIdentifier(CONST_SYSTEMLANGUAGE.STRINGS_KINGSOUL)[_loc4_ % 10 - 1],_loc5_);
            }
            else
            {
               _loc7_ = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.SEVENHERO_STRING_09),TUtilityLobby.GetStringsByIdentifier(CONST_SYSTEMLANGUAGE.STRINGS_KINGSOUL)[_loc4_ % 10 - 1],_loc5_);
            }
         }
         else if(_loc6_ != 0)
         {
            _loc7_ = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.SEVENHERO_STRING_08),TUtilityLobby.GetStringsByIdentifier(CONST_SYSTEMLANGUAGE.STRINGS_KINGSOUL)[_loc4_ % 10 - 1],_loc5_);
         }
         else
         {
            _loc7_ = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.SEVENHERO_STRING_07),TUtilityLobby.GetStringsByIdentifier(CONST_SYSTEMLANGUAGE.STRINGS_KINGSOUL)[_loc4_ % 10 - 1],_loc5_);
         }
         EffectGenerateText(_loc7_);
      }
      
      protected function PacketPerform_SC_ReportRet(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:ByteArray = null;
         var _loc4_:uint = 0;
         _loc3_ = param1.Data;
         _loc4_ = _loc3_.readUnsignedShort();
         _loc2_ = 0;
         while(_loc2_ < _loc4_)
         {
            this.FSevenKingData.ReportUserName[_loc2_] = TUtilityString.FetchUTF(_loc3_);
            this.FSevenKingData.ReportID[_loc2_] = TUtilityString.FetchUTF(_loc3_);
            _loc2_++;
         }
         this.FProcessorWindowHeroSelect.UpdataReport();
      }
      
      protected function PacketPerform_SC_ResetNotif(param1:TPacket) : void
      {
         this.FSevenKingData.Reset();
         if(this.Visible)
         {
            this.FProcessorWindowSevenHeroList.UpdateUI();
         }
      }
      
      protected function PacketPerform_SC_ReportNotify(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:uint = 0;
         var _loc4_:String = null;
         var _loc5_:String = null;
         _loc2_ = param1.Data;
         _loc3_ = _loc2_.readUnsignedByte();
         _loc4_ = TUtilityString.FetchUTF(_loc2_);
         _loc5_ = TUtilityString.FetchUTF(_loc2_);
         this.FSevenKingData.ReportUserName[_loc3_ - 1] = _loc4_;
         this.FSevenKingData.ReportID[_loc3_ - 1] = _loc5_;
         if(this.Visible)
         {
            this.FProcessorWindowHeroSelect.UpdataReport();
         }
      }
      
      protected function TextOnEffect(param1:Object, param2:String) : void
      {
         EffectGenerateText(param2);
      }
      
      protected function OnCloseTavern(param1:Object) : void
      {
         if(this.FOnReturnTown != null)
         {
            this.FOnReturnTown(param1);
         }
      }
      
      protected function UIComponentsOverlayerOnOver(param1:Object, param2:Object) : void
      {
         var _loc3_:TOverlayer = null;
         var _loc4_:TSevenHeroDailyAward = null;
         var _loc5_:TSevenHeroSoul = null;
         _loc3_ = this.FOverLayerKingSoul;
         if(param2 is TSevenHeroDailyAward)
         {
            _loc4_ = param2 as TSevenHeroDailyAward;
            _loc3_.Context = _loc4_;
         }
         else if(param2 is TSevenHeroSoul)
         {
            _loc5_ = param2 as TSevenHeroSoul;
            _loc3_.Context = _loc5_;
         }
         _loc3_ = this.FOverLayerKingSoul;
         if(_loc3_ != null)
         {
            _loc3_.Render(FUICore.MouseCoordinate);
            _loc3_.CoordinateOverlay.X -= _loc3_.BoundsSubstrate.Width + 20;
            _loc3_.Show();
         }
      }
      
      protected function UIComponentsOverlayerOnOut(param1:Object) : void
      {
         var _loc2_:TOverlayer = null;
         _loc2_ = this.FOverLayerKingSoul;
         if(_loc2_ != null)
         {
            _loc2_.Hide();
         }
      }
      
      protected function OnToStars(param1:Object) : void
      {
         if(this.FOnToStarsMap != null)
         {
            this.FOnToStarsMap(this);
         }
      }
      
      protected function PacketPerform_CS_Enter_SevenKing() : void
      {
         var _loc1_:TPacket = null;
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Enter_SevenKing);
         SNetworkCore.Transceiver.PacketTransmit(_loc1_);
      }
      
      public function get OnReturnTown() : Function
      {
         return this.FOnReturnTown;
      }
      
      public function set OnReturnTown(param1:Function) : void
      {
         this.FOnReturnTown = param1;
      }
      
      public function get OnInitBattle() : Function
      {
         return this.FOnInitBattle;
      }
      
      public function set OnInitBattle(param1:Function) : void
      {
         this.FOnInitBattle = param1;
      }
      
      public function get OnSetBattleStatus() : Function
      {
         return this.FOnSetBattleStatus;
      }
      
      public function set OnSetBattleStatus(param1:Function) : void
      {
         this.FOnSetBattleStatus = param1;
      }
      
      public function set BattleBack(param1:Boolean) : void
      {
         this.FBattleBack = param1;
      }
      
      public function get BattleBack() : Boolean
      {
         return this.FBattleBack;
      }
      
      public function get OnToStarsMap() : Function
      {
         return this.FOnToStarsMap;
      }
      
      public function set OnToStarsMap(param1:Function) : void
      {
         this.FOnToStarsMap = param1;
      }
      
      override public function Mount(param1:ByteArray = null) : void
      {
         super.Mount();
         if(param1 != null)
         {
            this.PacketPerform_SC_Enter_SevenKing(param1);
         }
         if(this.FBattleBack)
         {
            this.FBattleBack = false;
            this.FProcessorWindowSevenKing.UpdataPublicUI();
            this.FProcessorWindowSevenHeroList.UpdateUI();
            return;
         }
         if(!FIsResourcesLoadCompleted)
         {
            return;
         }
         this.EnterSevenKing();
         this.FCharacter.RoleSencePosition = CONST_COMMON.SCENEPOSITION_SEVENKING;
      }
      
      override public function Unmount() : void
      {
         super.Unmount();
         this.FProcessorWindowSevenHeroList.Reset();
         this.FProcessorWindowHeroSelect.Reset();
      }
      
      public function EnterReq() : void
      {
         this.PacketPerform_CS_Enter_SevenKing();
      }
   }
}

