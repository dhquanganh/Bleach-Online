package Processors.Game.Lobby.TreasureMap
{
   import Foundation.Common.*;
   import Foundation.Network.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Bins.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.Characters.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.Inventories.*;
   import Logics.Purchases.*;
   import Logics.Streamization.TreasureMap.*;
   import Logics.TimeCoolDown.*;
   import Logics.TreasureMap.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.TreasureMap.Components.*;
   import Processors.Game.Lobby.Utilities.*;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Rendering.Overlayers.*;
   import Rendering.Overlayers.HelpTips.*;
   import Rendering.Overlayers.Hints.*;
   import Rendering.Overlayers.Inventories.*;
   import Resources.Constants.*;
   import Resources.Strings.*;
   import Utilities.UI.Overlayers.*;
   import flash.display.*;
   import flash.events.*;
   import flash.utils.*;
   
   import Foundation.Timing.STimingCore;
   import Processors.Game.Battle.TBattleHandle;
   import Logics.TreasureMap.TTreasureMapHero;
   public class TProcessorTreasureMap extends TProcessorLobbyPlate
   {
      
      protected static const TreasureBaseDataHeight:int = 240;
      
      protected static const SIZE_WINDOWEXCHANGE_WIDTH:uint = 570;
      
      protected static const SIZE_WINDOWEXCHANGE_HEIGHT:uint = 380;
      
      public static const CATEGORY_Equipment:uint = CONST_INVENTORY.CATEGORY_Equipment;
      
      public static const CATEGORY_Treasure:uint = CONST_INVENTORY.CATEGORY_Treasure;
      
      public static const INIT_DIGGING_ID:uint = 101;
      
      protected var FScene:MovieClip;
      
      protected var FIsInit:Boolean;
      
      protected var FTimeCoolDown:TTimeCoolDown;
      
      protected var FHint:THint;
      
      protected var FTreasureMapData:TTreasureMapData;
      
      protected var UnstreamizerTreasureMap:TUnstreamizerTreasureMap;
      
      protected var FProcessorWindowTreasureMap:TProcessorWindowTreasureMap;
      
      protected var FProcessorWindowMapSelect:TProcessorWindowMapSelect;
      
      protected var FProcessorWindowHeros:TProcessorWindowHeros;
      
      protected var FHeroTips:THeroTips;
      
      protected var FRewardTips:TRewardTips;
      
      protected var FProcessorWindowExchange:TProcessorWindowTreasureExchange;
      
      protected var FBoundsExchange:TBounds;
      
      protected var FCharacter:TCharacter;
      
      public static var SoulBusy:Boolean = false;
      protected var SoulNextCheck:Number = 0;
      protected var SoulNextPoll:Number = 0;
      protected var FDiggingBins:TBins;
      
      protected var FOnReturnTown:Function;
      
      protected var FOnSetBattleStatus:Function;
      
      protected var FOnSetBattlePacket:Function;
      
      protected var FOnInitBattle:Function;
      
      protected var FOnPurchase:Function;
      
      public function TProcessorTreasureMap(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,param2);
         this.FIsInit = false;
         this.FTimeCoolDown = new TTimeCoolDown(CONST_COMMON.TIME_COOLDOWN_TreasureMap);
         SLogicsCore.TimeCoolDowns.Add(this.FTimeCoolDown);
         this.FTreasureMapData = new TTreasureMapData();
         this.UnstreamizerTreasureMap = new TUnstreamizerTreasureMap();
         this.FHint = new THint();
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         this.CheckSoulCompletion();
         if(!this.Visible)
         {
            return;
         }
         if(this.FProcessorWindowTreasureMap != null && this.FProcessorWindowTreasureMap.Visible == true)
         {
            this.FProcessorWindowTreasureMap.UpdataColdDown();
            this.FProcessorWindowTreasureMap.UpdataEffect();
         }
         if(this.FProcessorWindowMapSelect != null && this.FProcessorWindowMapSelect.Visible == true)
         {
            this.FProcessorWindowMapSelect.UpdataBitmp();
         }
         if(this.FProcessorWindowHeros != null && this.FProcessorWindowHeros.Visible == true)
         {
            this.FProcessorWindowHeros.UpdataTimeLine();
         }
         if(this.FHeroTips != null && this.FHeroTips.Visible == true)
         {
            this.FHeroTips.UpdataColdDown();
            this.FHeroTips.CheckTipPoint();
         }
         if(this.FRewardTips != null && this.FRewardTips.Visible == true)
         {
            this.FRewardTips.CheckTipPoint();
         }
         if(this.FProcessorWindowHeros != null)
         {
            this.FProcessorWindowHeros.LogicsPerform();
         }
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_TREASUREMAP.RESOURCE_TREASUREMAP);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIWait() : void
      {
         if(SResourcesCore.LoadingPrimary)
         {
            return;
         }
         this.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         this.InitTreasureMap();
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function PacketRegisterRoutines() : void
      {
         FPacketRoutines.Register(0x01181f7f,this.SoulHistoryRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_TreasureMap_StartRet,this.PacketPerform_SC_TreasureMap_StartRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_TreasureMap_RefreshRet,this.PacketPerform_SC_TreasureMap_RefreshRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_TreasureMap_OpenMapRet,this.PacketPerform_SC_TreasureMap_OpenMapRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_TreasureMap_FastRet,this.PacketPerform_SC_TreasureMap_FastRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_TreasureMap_FightRet,this.PacketPerform_SC_TreasureMap_FightRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_TreasureMap_UpdataMapHero,this.PacketPerform_SC_TreasureMap_UpdataMapHero);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_TreasureMap_AddReportData,this.PacketPerform_SC_TreasureMap_AddReportData);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_TreasureMap_FightOk,this.PacketPerform_SC_TreasureMap_FightOk);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_TreasureMap_UpdataUserBaseInfo,this.PacketPerform_SC_TreasureMap_UpdataUserBaseInfo);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_TreasureMap_VipAddTimesRet,this.PacketPerform_SC_TreasureMap_VipAddTimesRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_TreasureMap_StarsNumRet,this.PacketPerform_SC_TreasureMap_StarsNumRet);
      }
      
      protected function PacketPerform_SC_Enter_TreasureMap(param1:ByteArray) : void
      {
         var _loc2_:uint = 0;
         _loc2_ = param1.readUnsignedInt();
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         this.UnstreamizerTreasureMap.Unstreamize(param1,this.FTreasureMapData,null);
         this.FIsInit = true;
         this.FProcessorWindowTreasureMap.SetTreasureMapData(this.FTreasureMapData);
         this.FProcessorWindowMapSelect.SetTreasureMapData(this.FTreasureMapData);
         this.FProcessorWindowHeros.SetTreasureMapData(this.FTreasureMapData);
         if(this.FProcessorWindowExchange != null)this.FProcessorWindowExchange.SetTreasureMapData(this.FTreasureMapData);
         this.FProcessorWindowExchange.SetTreasureMapData(this.FTreasureMapData);
      }
      
      protected function PacketPerform_SC_TreasureMap_StartRet(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:uint = 0;
         _loc2_ = param1.Data;
         SoulBusy = false;
         _loc3_ = _loc2_.readUnsignedInt();
         if(_loc3_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc3_);
            return;
         }
         this.FTreasureMapData.TreasureStatus = true;
         this.FTreasureMapData.CurEnterTimes += 1;
         --this.FTreasureMapData.TreasureTimes;
         this.UnstreamizerTreasureMap.UnstreamizeTreasureMapHero(_loc2_,this.FTreasureMapData.FightHeroList,null);
         this.FProcessorWindowTreasureMap.SetTreasureMapData(this.FTreasureMapData);
         this.FProcessorWindowMapSelect.SetTreasureMapData(this.FTreasureMapData);
         this.FProcessorWindowHeros.SetTreasureMapData(this.FTreasureMapData);
         if(this.FProcessorWindowExchange != null)this.FProcessorWindowExchange.SetTreasureMapData(this.FTreasureMapData);
      }
      
      protected function PacketPerform_SC_TreasureMap_RefreshRet(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:String = null;
         var _loc6_:TDigging = null;
         this.FProcessorWindowMapSelect.SetRefreshBt(true);
         _loc2_ = param1.Data;
         SoulBusy = false;
         _loc3_ = _loc2_.readUnsignedInt();
         if(_loc3_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc3_);
            return;
         }
         _loc4_ = _loc2_.readUnsignedInt();
         if(_loc4_ != this.FTreasureMapData.CurQuality)
         {
            _loc6_ = this.FDiggingBins.GetDatebaseByIdentifier(_loc4_) as TDigging;
            _loc5_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TREASUREMAP_STRING_06);
            _loc5_ = _loc5_.split("%name%").join(_loc6_.Name);
            EffectGenerateText(_loc5_);
         }
         else
         {
            _loc5_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TREASUREMAP_STRING_05);
            EffectGenerateText(_loc5_);
         }
         this.FTreasureMapData.CurQuality = _loc4_;
         this.FTreasureMapData.CurRefreshTimes += 1;
         this.FProcessorWindowTreasureMap.SetTreasureMapData(this.FTreasureMapData);
         this.FProcessorWindowMapSelect.SetTreasureMapData(this.FTreasureMapData);
      }
      
      protected function PacketPerform_SC_TreasureMap_OpenMapRet(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:String = null;
         var _loc6_:TDigging = null;
         _loc2_ = param1.Data;
         SoulBusy = false;
         _loc3_ = _loc2_.readUnsignedInt();
         if(_loc3_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc3_);
            return;
         }
         _loc4_ = _loc2_.readUnsignedInt();
         if(_loc4_ != this.FTreasureMapData.CurQuality)
         {
            _loc6_ = this.FDiggingBins.GetDatebaseByIdentifier(_loc4_) as TDigging;
            _loc5_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TREASUREMAP_STRING_06);
            _loc5_ = _loc5_.split("%name%").join(_loc6_.Name);
            EffectGenerateText(_loc5_);
         }
         else
         {
            _loc5_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TREASUREMAP_STRING_05);
            EffectGenerateText(_loc5_);
         }
         this.FTreasureMapData.CurQuality = _loc4_;
         this.FProcessorWindowMapSelect.SetTreasureMapData(this.FTreasureMapData);
      }
      
      protected function PacketPerform_SC_TreasureMap_FastRet(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:uint = 0;
         _loc2_ = param1.Data;
         SoulBusy = false;
         _loc3_ = _loc2_.readUnsignedInt();
         if(_loc3_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc3_);
            return;
         }
         this.FTreasureMapData.CurQuality = INIT_DIGGING_ID;
         this.FTreasureMapData.TreasureStatus = false;
         this.FTreasureMapData.CurRefreshTimes = 0;
         this.FProcessorWindowTreasureMap.SetTreasureMapData(this.FTreasureMapData);
         this.FProcessorWindowMapSelect.SetTreasureMapData(this.FTreasureMapData);
         this.FProcessorWindowHeros.SetTreasureMapData(this.FTreasureMapData);
         if(this.FProcessorWindowExchange != null)this.FProcessorWindowExchange.SetTreasureMapData(this.FTreasureMapData);
      }
      
      protected function PacketPerform_SC_TreasureMap_FightRet(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:uint = 0;
         _loc2_ = param1.Data;
         SoulBusy = false;
         _loc3_ = _loc2_.readUnsignedInt();
         if(_loc3_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc3_);
            return;
         }
         if(this.FOnSetBattlePacket != null)
         {
            this.FOnSetBattlePacket(this,param1);
         }
      }
      
      protected function PacketPerform_SC_TreasureMap_UpdataMapHero(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:uint = 0;
         var _loc4_:Boolean = false;
         _loc2_ = param1.Data;
         SoulBusy = false;
         _loc3_ = _loc2_.readUnsignedInt();
         if(_loc3_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc3_);
            return;
         }
         this.UnstreamizerTreasureMap.UnstreamizeTreasureMapHero(_loc2_,this.FTreasureMapData.FightHeroList,null);
         if(this.FProcessorWindowHeros == null)
         {
            return;
         }
         _loc4_ = this.FProcessorWindowHeros.SetTreasureMapData(this.FTreasureMapData);
         if(_loc4_)
         {
            this.FProcessorWindowMapSelect.SetTreasureMapData(this.FTreasureMapData);
            this.FProcessorWindowTreasureMap.SetTreasureMapData(this.FTreasureMapData);
         }
      }
      
      protected function PacketPerform_SC_TreasureMap_AddReportData(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         _loc2_ = param1.Data;
         this.UnstreamizerTreasureMap.UnstreamizeTreasureMapReport(_loc2_,this.FTreasureMapData.ReportList,null);
         if(this.FProcessorWindowTreasureMap == null)
         {
            return;
         }
         this.FProcessorWindowTreasureMap.SetTreasureMapData(this.FTreasureMapData);
      }
      
      protected function PacketPerform_SC_TreasureMap_FightOk(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:uint = 0;
         _loc2_ = param1.Data;
         SoulBusy = false;
         _loc3_ = _loc2_.readUnsignedInt();
         if(_loc3_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc3_);
            return;
         }
         TBattleHandle.IsInBattle=false;
         this.ProcessorSetBattleStatus(this,CONST_BATTLE.BattleType_TreasureMap,CONST_MUSIC.ID_SCENE_TreasureMap);
         if(this.FOnInitBattle != null)
         {
            this.FOnInitBattle(this);
         }
      }
      
      protected function PacketPerform_SC_TreasureMap_UpdataUserBaseInfo(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:uint = 0;
         _loc2_ = param1.Data;
         SoulBusy = false;
         _loc3_ = _loc2_.readUnsignedInt();
         if(_loc3_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc3_);
            return;
         }
         this.UnstreamizerTreasureMap.Unstreamize(_loc2_,this.FTreasureMapData,null);
         if(!FIsResourcesLoadCompleted)
         {
            return;
         }
         this.FProcessorWindowTreasureMap.SetTreasureMapData(this.FTreasureMapData);
         this.FProcessorWindowMapSelect.SetTreasureMapData(this.FTreasureMapData);
         this.FProcessorWindowHeros.SetTreasureMapData(this.FTreasureMapData);
         if(this.FProcessorWindowExchange != null)this.FProcessorWindowExchange.SetTreasureMapData(this.FTreasureMapData);
      }
      
      protected function PacketPerform_SC_TreasureMap_VipAddTimesRet(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:uint = 0;
         _loc2_ = param1.Data;
         SoulBusy = false;
         _loc3_ = _loc2_.readUnsignedInt();
         if(_loc3_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc3_);
            return;
         }
         FOnEffectText(this,TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TREASUREMAP_STRING_13));
         ++this.FTreasureMapData.VipBuyCount;
         ++this.FTreasureMapData.TreasureTimes;
         this.FProcessorWindowMapSelect.SetTreasureMapData(this.FTreasureMapData);
         this.FProcessorWindowTreasureMap.SetTreasureMapData(this.FTreasureMapData);
      }
      
      protected function PacketPerform_SC_TreasureMap_StarsNumRet(param1:TPacket) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:ByteArray = null;
         _loc4_ = param1.Data;
         _loc2_ = int(_loc4_.readUnsignedInt());
         _loc3_ = int(_loc4_.readUnsignedInt());
         this.UpDataAddTreasureStar(_loc2_,_loc3_);
      }
      
      protected function InitTreasureMap() : void
      {
         this.FDiggingBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_Digging);
         this.FCharacter = SLogicsCore.Character;
         this.FScene = TUtilityReflection.CreateDisplayObjectInstance(CONST_TREASUREMAP.RESOURCE_ClassName_MC_TreasureMap) as MovieClip;
         addChild(this.FScene);
         this.FScene.mc_autoPoint.Btn_Close.addEventListener(MouseEvent.CLICK,this.OnClose);
         this.FScene.mc_autoPoint.Btn_Help.addEventListener(MouseEvent.CLICK,this.OnHelp);
         this.FProcessorWindowTreasureMap = new TProcessorWindowTreasureMap(this,this.FScene);
         this.FProcessorWindowTreasureMap.OnEnterCity = this.FOnReturnTown;
         this.FProcessorWindowTreasureMap.OpenDigMap = this.OpenDigMap;
         this.FProcessorWindowTreasureMap.HintOnOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FProcessorWindowTreasureMap.HintOnOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FProcessorWindowTreasureMap.OnEffectText = EffectGenerateText;
         this.FProcessorWindowTreasureMap.OnApplianceOnOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FProcessorWindowTreasureMap.OnApplianceOnOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FProcessorWindowTreasureMap.TutorialNextStep = TutorialNextStep;
         this.FProcessorWindowTreasureMap.OnOpenWindowExchange = this.ProcessorOnShowWindowExchange;
         this.FProcessorWindowTreasureMap.OnShowHeros = this.ProcessorOnShowHeros;
         this.FProcessorWindowTreasureMap.OnRewardOver = this.OnRewardRollOver;
         this.FProcessorWindowTreasureMap.OnRewardOut = this.OnRewardRollOut;
         this.FProcessorWindowTreasureMap.OnHelpTipsOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FProcessorWindowTreasureMap.OnHelpTipsOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FProcessorWindowMapSelect = new TProcessorWindowMapSelect(this,this.FScene.mc_mapSelect);
         this.FProcessorWindowMapSelect.Visible = false;
         this.FProcessorWindowMapSelect.OnCanDig = this.OnCanDig;
         this.FProcessorWindowMapSelect.OpenGame = this.OpenGame;
         this.FProcessorWindowMapSelect.OnApplianceOnOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FProcessorWindowMapSelect.OnApplianceOnOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FProcessorWindowMapSelect.OnHintOnOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FProcessorWindowMapSelect.OnHintOnOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FProcessorWindowMapSelect.OnEffectText = ProcessorsOnEffectText;
         this.FProcessorWindowMapSelect.TutorialNextStep = TutorialNextStep;
         this.FProcessorWindowMapSelect.OnAwardOver = this.OnRewardRollOver;
         this.FProcessorWindowMapSelect.OnAwardOut = this.OnRewardRollOut;
         this.FProcessorWindowHeros = new TProcessorWindowHeros(this,this.FScene);
         this.FProcessorWindowHeros.OnHeroRollOver = this.OnHeroRollOver;
         this.FProcessorWindowHeros.OnHeroRollOut = this.OnHeroRollOut;
         this.FProcessorWindowHeros.OnEffectText = ProcessorsOnEffectText;
         this.FHeroTips = new THeroTips(this);
         this.FHeroTips.Visible = false;
         this.FRewardTips = new TRewardTips(this);
         this.FRewardTips.Visible = false;
         this.FProcessorWindowExchange = new TProcessorWindowTreasureExchange(this);
         this.FProcessorWindowExchange.OnEffectText = ProcessorsOnEffectText;
         this.FProcessorWindowExchange.OnItemSlotOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FProcessorWindowExchange.OnItemSlotOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FProcessorWindowExchange.OnClose = this.ProcessorOnHideWindowExchange;
         this.FProcessorWindowExchange.OnExchange = this.ProcessorOnExchange;
         this.FProcessorWindowExchange.Load();
         this.FBoundsExchange = new TBounds();
         this.FBoundsExchange.Width = SIZE_WINDOWEXCHANGE_WIDTH;
         this.FBoundsExchange.Height = SIZE_WINDOWEXCHANGE_HEIGHT;
         ComponentBoundsCenter(this.FProcessorWindowExchange,this.FBoundsExchange);
         this.FBoundsExchange = null;
      }
      
      override protected function ProcessorResize() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         _loc1_ = FUICore.StageWidth;
         _loc2_ = FUICore.StageHeight;
         if(this.FScene != null)
         {
         }
      }
      
      protected function EnterTreasureMap() : void
      {
         if(this.FScene == null)
         {
            return;
         }
         this.FProcessorWindowMapSelect.Visible = false;
         this.FHeroTips.Visible = false;
         this.FProcessorWindowExchange.Visible = false;
         this.FRewardTips.Visible = false;
         this.FProcessorWindowTreasureMap.SetTreasureMapData(this.FTreasureMapData);
         this.FProcessorWindowMapSelect.SetTreasureMapData(this.FTreasureMapData);
         this.FProcessorWindowHeros.SetTreasureMapData(this.FTreasureMapData);
         if(this.FProcessorWindowExchange != null)this.FProcessorWindowExchange.SetTreasureMapData(this.FTreasureMapData);
         SLogicsCore.Character.RoleSencePosition = CONST_COMMON.SCENEPOSITION_TREASUREMAP;
         this.ProcessorResize();
      }
      
      protected function OpenDigMap(param1:Object) : void
      {
         this.FProcessorWindowMapSelect.Visible = true;
      }
      
      protected function OnCanDig() : Boolean
      {
         return this.FProcessorWindowTreasureMap.CheckCanDigging();
      }
      
      protected function OpenGame() : void
      {
      }
      
      protected function ProcessorOnShowWindowExchange(param1:Object) : void
      {
         this.FProcessorWindowExchange.UpDateUI();
         this.FProcessorWindowExchange.Visible = true;
      }
      
      protected function ProcessorOnShowHeros(param1:Object) : void
      {
         this.FProcessorWindowHeros.FirstShowHeros();
      }
      
      protected function ProcessorOnHideWindowExchange(param1:Object) : void
      {
         this.FProcessorWindowExchange.Visible = false;
      }
      
      protected function ProcessorOnExchange(param1:Object, param2:TPurchaseRequest, param3:TPurchaseParameters) : void
      {
         if(this.FOnPurchase != null)
         {
            this.FOnPurchase(param1,param2,param3);
         }
      }
      
      protected function OnClose(param1:MouseEvent) : void
      {
         if(this.FOnReturnTown != null)
         {
            this.FOnReturnTown(this);
         }
      }
      
      protected function OnHelp(param1:MouseEvent) : void
      {
      }
      
      protected function ProcessorSetBattleStatus(param1:Object, param2:int, param3:int) : void
      {
         if(this.FOnSetBattleStatus != null)
         {
            this.FOnSetBattleStatus(param1,param2,param3);
         }
      }
      
      protected function OnHeroRollOver(param1:Object, param2:TTreasureMapHero) : void
      {
         this.FHeroTips.SetHeroData(param2);
         this.FHeroTips.Visible = true;
         if(param2.Identifier0 != this.FCharacter.Identifier0 || param2.Identifier1 != this.FCharacter.Identifier1)
         {
            FUICore.MouseCaptureSet(param1 as TUIComponent);
         }
      }
      
      protected function OnRewardRollOver(param1:Object, param2:TDigging) : void
      {
         this.FRewardTips.SetRewardData(param2);
         this.FRewardTips.Visible = true;
      }
      
      protected function OnHeroRollOut(param1:Object, param2:TTreasureMapHero) : void
      {
         if(param2.Identifier0 != this.FCharacter.Identifier0 || param2.Identifier1 != this.FCharacter.Identifier1)
         {
            FUICore.MouseCaptureRelease(param1 as TUIComponent);
         }
         this.FHeroTips.Visible = false;
      }
      
      protected function OnRewardRollOut(param1:Object) : void
      {
         this.FRewardTips.Visible = false;
      }
      
      protected function OnStartMovie(param1:Object) : void
      {
      }
      
      public function set OnReturnMainScene(param1:Function) : void
      {
         this.FOnReturnTown = param1;
      }
      
      public function get OnReturnMainScene() : Function
      {
         return this.FOnReturnTown;
      }
      
      public function set OnSetBattleStatus(param1:Function) : void
      {
         this.FOnSetBattleStatus = param1;
      }
      
      public function get OnSetBattleStatus() : Function
      {
         return this.FOnSetBattleStatus;
      }
      
      public function set OnSetBattlePacket(param1:Function) : void
      {
         this.FOnSetBattlePacket = param1;
      }
      
      public function get OnSetBattlePacket() : Function
      {
         return this.FOnSetBattlePacket;
      }
      
      public function set OnInitBattle(param1:Function) : void
      {
         this.FOnInitBattle = param1;
      }
      
      public function get OnInitBattle() : Function
      {
         return this.FOnInitBattle;
      }
      
      public function get OnPurchase() : Function
      {
         return this.FOnPurchase;
      }
      
      public function set OnPurchase(param1:Function) : void
      {
         this.FOnPurchase = param1;
      }
      
      override public function Mount(param1:ByteArray = null) : void
      {
         var _loc2_:TPacket = null;
         super.Mount();
         if(!FIsResourcesLoadCompleted)
         {
            return;
         }
         if(param1 != null)
         {
            this.PacketPerform_SC_Enter_TreasureMap(param1);
         }
         if(this.FIsInit == false)
         {
            _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Enter_TreasureMap);
            SNetworkCore.Transceiver.PacketTransmit(_loc2_);
         }
         else
         {
            this.EnterTreasureMap();
         }
         TutorialNextStep(CONST_FRESHGUIDE.EVENTID_OpenTreasureMap);
         this.FProcessorWindowTreasureMap.PlayMovie();
         MusicPlayNext(CONST_SIGNAL.SIGNALDESTINATION_SOUND,CONST_MUSIC.PLAY_SCENE_TreasureMap,CONST_MUSIC.ID_SCENE_TreasureMap,false);
      }
      
      override public function Unmount() : void
      {
         super.Unmount();
         if(this.FIsInit)
         {
            TutorialNextStep(CONST_FRESHGUIDE.EVENTID_CloseTreasureMap);
         }
         this.FProcessorWindowExchange.Visible = false;
         this.FProcessorWindowHeros.Unmount();
         this.FProcessorWindowMapSelect.Reset();
         this.FProcessorWindowTreasureMap.Reset();
         this.FProcessorWindowExchange.Reset();
      }
      
      public function RobberyResult(param1:Boolean = true) : void
      {
         this.FTreasureMapData.RobberyTimes += 1;
         if(!param1)
         {
            ProcessorsOnEffectText(this,TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TREASUREMAP_STRING_40));
         }
         else if(this.FTreasureMapData != null)
         {
         }
      }
      
      public function UpDataAddTreasureStar(param1:int, param2:int) : void
      {
         if(param1 == 8)
         {
            this.FTreasureMapData.BlueStar = param2;
         }
         else if(param1 == 9)
         {
            this.FTreasureMapData.RedStar = param2;
         }
         if(this.FProcessorWindowTreasureMap != null)
         {
            this.FProcessorWindowTreasureMap.SetTreasureMapData(this.FTreasureMapData);
         }
         if(this.FProcessorWindowExchange != null)
         {
            this.FProcessorWindowExchange.SetTreasureMapData(this.FTreasureMapData);
         }
      }
      protected function CheckSoulCompletion() : void
      {
         if(!Visible || !FIsResourcesLoadCompleted || this.FDiggingBins == null || SoulBusy)return;
         if(this.FTreasureMapData.TreasureStatus && STimingCore.ServerTick >= this.SoulNextCheck){
            var hero:TTreasureMapHero=this.FTreasureMapData.FightHeroList.GetMapHeroById(SLogicsCore.Character.Identifier0,SLogicsCore.Character.Identifier1) as TTreasureMapHero;
            var row:TDigging=hero!=null?this.FDiggingBins.GetDatebaseByIdentifier(hero.CurQuality) as TDigging:null;
            if(row!=null && hero.LastTime+row.Digtime <= STimingCore.ServerTick){
               SoulBusy=true;this.SoulNextCheck=STimingCore.ServerTick+5;
               var p:TPacket=SNetworkCore.PacketAcquire(0x01811f7e);SNetworkCore.Transceiver.PacketTransmit(p);return;
            }
         }
         if(STimingCore.ServerTick >= this.SoulNextPoll){
            SoulBusy=true;this.SoulNextPoll=STimingCore.ServerTick+15;
            var update:TPacket=SNetworkCore.PacketAcquire(0x01811f7d);SNetworkCore.Transceiver.PacketTransmit(update);
         }
      }
      protected function SoulHistoryRet(p:TPacket) : void
      {
         this.FTreasureMapData.ReportList.Clear();
         this.UnstreamizerTreasureMap.UnstreamizeTreasureMapReport(p.Data,this.FTreasureMapData.ReportList,null);
         if(this.FProcessorWindowTreasureMap != null)this.FProcessorWindowTreasureMap.SetTreasureMapData(this.FTreasureMapData);
      }
   }
}

