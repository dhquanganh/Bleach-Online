package Processors.Game.Lobby.WorldMapBleach.MonsterMap
{
   import Foundation.Common.*;
   import Foundation.Network.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Bins.*;
   import Foundation.UI.*;
   import Logics.*;
   import Logics.Campaign.*;
   import Logics.Characters.*;
   import Logics.ChatOptions.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.Inventories.*;
   import Logics.Items.*;
   import Logics.Quests.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Quests.QuestNew.*;
   import Processors.Game.Lobby.Utilities.*;
   import Processors.Game.Plot.*;
   import Processors.Game.Utilities.HyperLink.*;
   import Processors.Game.Utilities.OverLayer.*;
   import Rendering.Overlayers.Hints.*;
   import Rendering.Overlayers.Inventories.*;
   import Resources.Constants.*;
   import Utilities.UI.Overlayers.*;
   import flash.utils.*;
   
   public class TProcessorMonsterMap extends TProcessorLobbyPlate
   {
      
      protected static const SIZE_WindowMonster_Width:Number = 1250;
      
      protected static const SIZE_WindowMonster_Height:Number = 650;
      
      protected static const SIZE_WindowBarrierChoose_Width:Number = 594;
      
      protected static const SIZE_WindowBarrierChoose_Height:Number = 520;
      
      protected static const SIZE_WindowPassBoss_Width:Number = 1250;
      
      protected static const SIZE_WindowPassBoss_Height:Number = 650;
      
      public static const ENTER_TYPE_NODAL:int = CONST_BATTLE.BattleType_Nodal;
      
      public static const ENTER_TYPE_CAMP:int = CONST_BATTLE.BattleType_Camp;
      
      public static const ENTER_TYPE_TRIALS:int = CONST_BATTLE.BattleType_KillHero;
      
      public static const SEARCHWAYID_CLICKQUESTGUIDE:int = 5;
      
      protected static const SOULSTAR_TabIndex:uint = 1;
      
      protected static const SOULSTAR_BaseID:uint = 0;
      
      protected var FProcessorWindowMonsterMap:TProcessorWindowMonsterMap;
      
      protected var FProcessorWindowBarrierChoose:TProcessorWindowBarrierChoose;
      
      protected var FProcessorWindowPassBoss:TProcessorWindowPassBoss;
      
      protected var FProcessorWindowPassInstance:TProcessorWindowPassInstance;
      
      protected var FBoundsWindowMonster:TBounds;
      
      protected var FBoundsWindowBarrierChoose:TBounds;
      
      protected var FBoundsWindowPassBoss:TBounds;
      
      protected var FBoundsWindowPassNodal:TBounds;
      
      protected var FIsInit:Boolean;
      
      protected var FIsPass:Boolean;
      
      protected var FIsShowPassBoss:Boolean;
      
      protected var FIsShowPassNodal:Boolean;
      
      protected var FIsShowNewMonster:Boolean;
      
      protected var FIsInstanceShowMonster:Boolean;
      
      protected var FNodalModel:TNodal;
      
      protected var FCharacter:TCharacter;
      
      protected var FPoolItem:TPoolItem;
      
      protected var FPoolCampaign:TPoolCampaign;
      
      protected var FBattleType:int;
      
      protected var FCityID:int;
      
      protected var FBarrierID:int;
      
      protected var FSingleID:int;
      
      protected var FMonsterVect:Vector.<int>;
      
      protected var FNewMonsterVect:Vector.<int>;
      
      protected var FNewMonsterID:int;
      
      protected var FInstanceDiff:int;
      
      protected var FCityBins:TBins;
      
      protected var FSingleBins:TBins;
      
      protected var FSinglePointPath:TBins;
      
      protected var FBlockPointBins:TBins;
      
      protected var FEnemyArmyBins:TBins;
      
      protected var FEnemyBins:TBins;
      
      protected var FMainQuest:TQuest;
      
      protected var FMainQuestStatus:int;
      
      protected var FIsBoss:Boolean;
      
      protected var FLostPopTipsId:Vector.<Array>;
      
      protected var FOnBackLargeWorldMap:Function;
      
      protected var FOnSetBattleStatus:Function;
      
      protected var FOnProcessorCheckPlot:Function;
      
      protected var FOnCheckTask:Function;
      
      protected var FOnOpenSkill:Function;
      
      protected var FOnAutoBattle:Function;
      
      protected var FOnPassInstanceAutoBattle:Function;
      
      protected var FOnMonsterMainUISet:Function;
      
      protected var FOnAddPopTips:Function;
      
      public function TProcessorMonsterMap(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,param2);
         this.FProcessorWindowMonsterMap = new TProcessorWindowMonsterMap(this);
         this.FProcessorWindowMonsterMap.MonsterClicked = this.ProcessorOnMonsterEnter;
         this.FProcessorWindowMonsterMap.OnBackWorldMap = this.ProcessorOnBackWorldMap;
         this.FProcessorWindowBarrierChoose = new TProcessorWindowBarrierChoose(this);
         this.FProcessorWindowBarrierChoose.OnChangeTeammate = this.ProcessorOnChangeTeammate;
         this.FProcessorWindowBarrierChoose.OnChangeSkill = this.ProcessorOnChangeSkill;
         this.FProcessorWindowBarrierChoose.OnAutoBattle = this.ProcessorOnAutoBattle;
         this.FProcessorWindowBarrierChoose.OnBattle = this.ProcessorOnBattle;
         this.FProcessorWindowBarrierChoose.OnSetBattleStatus = this.ProcessorOnSetBattleStatus;
         this.FProcessorWindowBarrierChoose.OnOverLayOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FProcessorWindowBarrierChoose.OnOverLayOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FProcessorWindowBarrierChoose.HintOnOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FProcessorWindowBarrierChoose.HintOnOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FProcessorWindowBarrierChoose.OnEffectText = ProcessorsOnEffectText;
         this.FProcessorWindowPassBoss = new TProcessorWindowPassBoss(this,false);
         this.FProcessorWindowPassBoss.OnEffectText = ProcessorsOnEffectText;
         this.FProcessorWindowPassBoss.OnOverLayOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FProcessorWindowPassBoss.OnOverLayOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FProcessorWindowPassInstance = new TProcessorWindowPassInstance(this,false);
         this.FProcessorWindowPassInstance.OnEffectText = ProcessorsOnEffectText;
         this.FProcessorWindowPassInstance.OnOverLayOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FProcessorWindowPassInstance.OnOverLayOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FBoundsWindowBarrierChoose = new TBounds();
         this.FBoundsWindowBarrierChoose.Width = SIZE_WindowBarrierChoose_Width;
         this.FBoundsWindowBarrierChoose.Height = SIZE_WindowBarrierChoose_Height;
         ComponentBoundsCenter(this.FProcessorWindowBarrierChoose,this.FBoundsWindowBarrierChoose);
         this.FBoundsWindowBarrierChoose = null;
         this.FBoundsWindowPassBoss = new TBounds();
         this.FBoundsWindowPassBoss.Width = SIZE_WindowPassBoss_Width;
         this.FBoundsWindowPassBoss.Height = SIZE_WindowPassBoss_Height;
         ComponentBoundsCenter(this.FProcessorWindowPassBoss,this.FBoundsWindowPassBoss);
         this.FBoundsWindowPassBoss = null;
         this.FBoundsWindowPassNodal = new TBounds();
         this.FBoundsWindowPassNodal.Width = SIZE_WindowPassBoss_Width;
         this.FBoundsWindowPassNodal.Height = SIZE_WindowPassBoss_Height;
         ComponentBoundsCenter(this.FProcessorWindowPassInstance,this.FBoundsWindowPassNodal);
         this.FBoundsWindowPassNodal = null;
         this.FNodalModel = SLogicsCore.Nodal;
         this.FCharacter = SLogicsCore.Character;
         this.FPoolItem = SLogicsCore.PoolItem;
         this.FPoolCampaign = SLogicsCore.PoolCampaign;
         this.FMonsterVect = new Vector.<int>();
         this.FNewMonsterVect = new Vector.<int>();
         this.FInstanceDiff = -1;
         this.FIsPass = false;
         this.FIsShowPassBoss = false;
         this.FIsShowPassNodal = false;
         this.FIsShowNewMonster = false;
         this.FIsInstanceShowMonster = false;
         this.FMainQuestStatus = 0;
         this.FIsBoss = false;
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_WORLDMAP.RESOURCESID_MonsterMap);
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
         this.FCityBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_City);
         this.FSingleBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_Single);
         this.FSinglePointPath = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_SinglePointPath);
         this.FBlockPointBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_BlockPoint);
         this.FEnemyArmyBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_EnemyArmy);
         this.FEnemyBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_Enemy);
         this.FProcessorWindowBarrierChoose.OnAddPopTips = this.FOnAddPopTips;
         this.FProcessorWindowMonsterMap.UIDispatch();
         TutorialSendComponent(CONST_FRESHGUIDE.MCID_BattleView,this);
         TutorialSendArrowParent(CONST_FRESHGUIDE.MCID_BattleView,FParent);
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function PacketRegisterRoutines() : void
      {
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_LOBBY_Hurdle_Assessment,this.PacketPerform_SC_StarInfo);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_LOBBY_Hurdle_QueryChestRet,this.PacketPerform_SC_PassNodalWindow);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_LOBBY_Hurdle_ReceiveChestRet,this.PacketPerform_SC_PassNodalWindow);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_LOBBY_Hurdle_MoveToNextLayerRet,this.PacketPerform_SC_MoveToNextLayerRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_LOBBY_Hurdle_FightOk,this.PacketPerform_SC_FightOk);
         super.PacketRegisterRoutines();
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(!this.Visible)
         {
            return;
         }
         if(this.FProcessorWindowPassBoss != null && this.FProcessorWindowPassBoss.Visible == true)
         {
            this.FProcessorWindowPassBoss.UpdataSlot();
            this.FProcessorWindowPassBoss.LogicsPerform_PlayerRole();
         }
         if(this.FProcessorWindowPassInstance != null && this.FProcessorWindowPassInstance.Visible == true)
         {
            this.FProcessorWindowPassInstance.UpdataSlot();
            this.FProcessorWindowPassInstance.LogicsPerform_PlayerRole();
         }
      }
      
      protected function PacketPerform_SC_StarInfo(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TCity = null;
         var _loc7_:TBlockPoint = null;
         var _loc8_:TSinglePointPath = null;
         var _loc9_:ByteArray = null;
         var _loc10_:TQuestInfor = null;
         var _loc11_:Boolean = false;
         _loc9_ = param1.Data;
         _loc2_ = _loc9_.readUnsignedInt();
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         _loc3_ = int(_loc9_.readUnsignedInt());
         _loc4_ = int(_loc9_.readUnsignedInt());
         _loc5_ = int(_loc9_.readUnsignedByte());
         _loc11_ = false;
         this.FBarrierID = _loc4_;
         if(this.FOnCheckTask != null)
         {
            this.FOnCheckTask(_loc4_,1);
         }
         if(this.FCityBins == null)
         {
            this.FCityBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_City);
         }
         _loc6_ = this.FCityBins.GetDatebaseByIdentifier(_loc3_) as TCity;
         if(_loc6_.Type == ENTER_TYPE_NODAL)
         {
            if(this.FBlockPointBins == null)
            {
               this.FBlockPointBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_BlockPoint);
            }
            _loc7_ = this.FBlockPointBins.GetDatebaseByIdentifier(_loc4_) as TBlockPoint;
            if(this.FNodalModel.GetMissionStarByID(_loc4_) <= 0)
            {
               _loc11_ = true;
            }
            this.FNodalModel.SetMissionStarByID(_loc4_,_loc5_);
            if(_loc11_)
            {
               this.FNodalModel.CurMissionID = _loc7_.NextPoint;
            }
            this.FIsShowNewMonster = false;
            _loc10_ = new TQuestInfor();
            _loc10_.InforID = CONST_QUEST.QUEST_INFOR_KILLMONSTER;
            _loc10_.InforArray.push(_loc4_);
            _loc10_.InforArray.push(1);
            SLogicsCore.SignalPost(CONST_SIGNAL.SIGNALDESTINATION_QUEST,0,0,_loc10_);
            this.FIsBoss = Boolean(_loc7_.IsBoss);
            if(!this.FIsBoss)
            {
               return;
            }
            this.FProcessorWindowPassBoss.SetPassBossWindow(_loc6_.Type,_loc4_,_loc5_,this.ReturnMonsterMapScene);
         }
         else if(_loc6_.Type == ENTER_TYPE_CAMP)
         {
            if(this.FSinglePointPath == null)
            {
               this.FSinglePointPath = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_SinglePointPath);
            }
            if(this.FProcessorWindowPassInstance != null)
            {
               this.FProcessorWindowPassInstance.SetPassInstanceWindow(_loc6_.Type,_loc4_,_loc5_,this.EnterCityScene);
            }
            this.FNodalModel.SetCampStarByID(_loc4_,_loc5_);
            this.FIsPass = true;
         }
      }
      
      protected function PacketPerform_SC_PassNodalWindow(param1:TPacket) : void
      {
         if(this.FIsShowPassNodal || this.FIsShowPassBoss)
         {
            if(this.FBattleType == ENTER_TYPE_NODAL)
            {
               if(this.FProcessorWindowPassBoss != null)
               {
                  this.FProcessorWindowPassBoss.PacketProcess(param1);
               }
            }
            else if(this.FBattleType == ENTER_TYPE_CAMP)
            {
               if(this.FProcessorWindowPassInstance != null)
               {
                  this.FProcessorWindowPassInstance.PacketProcess(param1);
               }
            }
         }
         else if(this.FOnPassInstanceAutoBattle != null)
         {
            this.FOnPassInstanceAutoBattle(this,param1);
         }
      }
      
      protected function PacketPerform_SC_MoveToNextLayerRet(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:uint = 0;
         var _loc4_:int = 0;
         var _loc5_:Vector.<int> = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         _loc2_ = param1.Data;
         _loc3_ = _loc2_.readUnsignedInt();
         if(_loc3_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc3_);
            return;
         }
         _loc7_ = int(_loc2_.readUnsignedInt());
         _loc6_ = int(_loc2_.readUnsignedInt());
         this.FCityID = _loc7_;
         this.FSingleID = _loc6_;
         if(this.FNodalModel == null)
         {
            this.FNodalModel = SLogicsCore.Nodal;
         }
         if(this.FNodalModel.GetCampaignById(_loc7_) != null && _loc6_ > 0)
         {
            this.FNodalModel.GetCampaignById(_loc7_).SetBattleID(_loc6_);
            _loc4_ = this.FNodalModel.GetCampaignById(_loc7_).GetCurBattleID(_loc6_);
         }
         if(_loc4_ > 0)
         {
            _loc5_ = this.GetMonsterVect();
            if(this.FProcessorWindowMonsterMap.Visible)
            {
               this.FProcessorWindowMonsterMap.SwitchMonsterMap(_loc7_,_loc5_,ENTER_TYPE_CAMP,_loc4_);
            }
         }
      }
      
      protected function PacketPerform_SC_FightOk(param1:TPacket) : void
      {
      }
      
      protected function ReturnMonsterMapScene(param1:Object) : void
      {
         if(this.FOnMonsterMainUISet != null)
         {
            this.FOnMonsterMainUISet(this,true);
         }
         this.FIsShowPassBoss = false;
         this.FProcessorWindowPassBoss.Visible = false;
         if(this.FIsBoss)
         {
            this.ProcessorCheckTask();
         }
      }
      
      protected function EnterCityScene(param1:Object) : void
      {
         var _loc2_:TPacket = null;
         var _loc3_:ByteArray = null;
         this.FProcessorWindowPassInstance.Visible = false;
         this.FIsShowPassNodal = false;
         this.FIsPass = false;
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_LOBBY_Enter_Town);
         _loc3_ = _loc2_.Data;
         _loc3_.writeUnsignedInt(23100001);
         _loc3_.writeUnsignedInt(0);
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
      }
      
      protected function GetMonsterVect() : Vector.<int>
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Vector.<int> = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TSingle = null;
         var _loc7_:TCity = null;
         var _loc8_:TBlockPoint = null;
         var _loc9_:Boolean = false;
         _loc3_ = new Vector.<int>();
         _loc9_ = false;
         this.FNewMonsterID = 0;
         if(this.FSingleBins == null)
         {
            this.FSingleBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_Single);
         }
         if(this.FBattleType == CONST_BATTLE.BattleType_Nodal)
         {
            _loc7_ = this.FCityBins.GetDatebaseByIdentifier(this.FCityID) as TCity;
            if(_loc7_ != null)
            {
               _loc4_ = _loc7_.Start;
               _loc5_ = _loc7_.Last;
               _loc1_ = _loc4_;
               while(_loc1_ <= _loc5_)
               {
                  _loc8_ = this.FBlockPointBins.GetDatebaseByIdentifier(_loc1_) as TBlockPoint;
                  if(_loc8_.ShowPrev == 0)
                  {
                     if(this.FCharacter.GetMainLevel() + 1 >= _loc8_.Level)
                     {
                        _loc3_.push(_loc1_);
                        if(this.FNewMonsterVect.indexOf(_loc1_) == -1 && !_loc9_ && this.FNodalModel.GetMissionStarByID(_loc8_.Identifier) <= 0)
                        {
                           this.FNewMonsterID = _loc1_;
                           _loc9_ = true;
                        }
                     }
                  }
                  else if(this.FNodalModel.CurMissionID > _loc8_.ShowPrev)
                  {
                     if(this.FCharacter.GetMainLevel() + 1 >= _loc8_.Level)
                     {
                        _loc3_.push(_loc1_);
                        if(this.FNewMonsterVect.indexOf(_loc1_) == -1 && !_loc9_ && this.FNodalModel.GetMissionStarByID(_loc8_.Identifier) <= 0)
                        {
                           this.FNewMonsterID = _loc1_;
                           _loc9_ = true;
                        }
                     }
                  }
                  _loc1_++;
               }
            }
            else
            {
               _loc4_ = 0;
               _loc5_ = 0;
            }
         }
         else if(this.FBattleType == CONST_BATTLE.BattleType_Camp)
         {
            _loc6_ = this.FSingleBins.GetDatebaseByIdentifier(this.FSingleID) as TSingle;
            if(_loc6_ != null)
            {
               _loc4_ = int(_loc6_.StartId);
               _loc5_ = int(_loc6_.EndId);
               _loc1_ = _loc4_;
               while(_loc1_ <= _loc5_)
               {
                  _loc3_.push(_loc1_);
                  _loc1_++;
               }
            }
            else
            {
               _loc4_ = 0;
               _loc5_ = 0;
            }
         }
         this.FNewMonsterVect = _loc3_;
         return _loc3_;
      }
      
      protected function ProcessorCheckTask() : void
      {
         if(this.FCharacter.MainQuestsAlreadyAccept.Count <= 0)
         {
            return;
         }
         this.FMainQuest = this.FCharacter.MainQuestsAlreadyAccept.GetQuestByIndex(0);
         if(this.FMainQuest.TaskState == 2 && this.FMainQuestStatus == 1)
         {
            if(FOnEffectText != null)
            {
               FOnEffectText(this,TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.WORLDMAP_STRING_11));
            }
            SLogicsCore.QuestAutoSearchWay.AutoSearyWay(this.FMainQuest);
            this.FMainQuestStatus = 0;
         }
      }
      
      override protected function ProcessorResize() : void
      {
         var _loc1_:uint = 0;
         if(this.FProcessorWindowBarrierChoose == null)
         {
            return;
         }
         _loc1_ = FUICore.StageHeight;
         this.FProcessorWindowBarrierChoose.Y = (_loc1_ - SIZE_WindowBarrierChoose_Height) / 2;
      }
      
      protected function ProcessorOnMonsterEnter(param1:Object, param2:int) : void
      {
         var _loc3_:TSinglePointPath = null;
         var _loc4_:int = 0;
         if(this.FBattleType == ENTER_TYPE_NODAL)
         {
            if(param2 > this.FNodalModel.CurMissionID)
            {
               if(FOnEffectText != null)
               {
                  FOnEffectText(this,TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.WORLDMAP_STRING_09));
               }
               return;
            }
         }
         else if(this.FBattleType == ENTER_TYPE_CAMP)
         {
            _loc4_ = this.FNodalModel.GetCampaignById(this.FCityID).GetCurBattleID(this.FSingleID);
            if(param2 != _loc4_)
            {
               if(FOnEffectText != null)
               {
                  FOnEffectText(this,TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.WORLDMAP_STRING_10));
               }
               return;
            }
         }
         this.FProcessorWindowBarrierChoose.UpDataBarrierChoose(param1,this.FNodalModel,this.FBattleType,this.FCityID,param2);
         this.FProcessorWindowBarrierChoose.Visible = true;
         this.FProcessorWindowBarrierChoose.Mount();
      }
      
      protected function ProcessorOnBackWorldMap(param1:Object) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:TCity = null;
         _loc3_ = this.FCityBins.GetDatebaseByIdentifier(this.FCityID) as TCity;
         _loc2_ = uint(_loc3_.Map);
         if(this.FOnBackLargeWorldMap != null)
         {
            this.FOnBackLargeWorldMap(this,_loc2_);
         }
      }
      
      protected function ProcessorOnChangeTeammate(param1:Object) : void
      {
         SUtilityHyperLink.ShortcutHyperlink(TUtilityHyperLink.HyperLink_TacticalDeployment);
      }
      
      protected function ProcessorOnChangeSkill(param1:Object) : void
      {
         SUtilityHyperLink.ShortcutHyperlink(TUtilityHyperLink.HyperLink_Star,SOULSTAR_TabIndex,SOULSTAR_BaseID);
      }
      
      protected function ProcessorOnAutoBattle(param1:Object, param2:TNodalAutoMonsterInfo) : void
      {
         if(this.FOnAutoBattle != null)
         {
            this.FOnAutoBattle(param1,param2);
         }
      }
      
      protected function ProcessorOnSetBattleStatus(param1:Object, param2:uint, param3:uint) : void
      {
         if(this.FOnSetBattleStatus != null)
         {
            this.FOnSetBattleStatus(param1,param2,param3);
         }
      }
      
      protected function ProcessorOnBattle(param1:Object, param2:int) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:TPacket = null;
         var _loc5_:ByteArray = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         _loc6_ = this.FCityID;
         if(this.FBattleType == CONST_BATTLE.BattleType_Nodal)
         {
            _loc7_ = param2;
         }
         else if(this.FBattleType == CONST_BATTLE.BattleType_Camp)
         {
            _loc7_ = this.FSingleID;
         }
         _loc4_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Enter_Hurdle);
         _loc5_ = _loc4_.Data;
         _loc5_.writeInt(_loc6_);
         _loc5_.writeInt(_loc7_);
         SNetworkCore.Transceiver.PacketTransmit(_loc4_);
      }
      
      protected function ShowPassBossWindow(param1:Object = null) : void
      {
         var _loc2_:TBlockPoint = null;
         if(this.FBlockPointBins == null)
         {
            this.FBlockPointBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_BlockPoint);
         }
         _loc2_ = this.FBlockPointBins.GetDatebaseByIdentifier(this.FBarrierID) as TBlockPoint;
         if(_loc2_ == null)
         {
            return;
         }
         if(_loc2_.IsBoss == 0)
         {
            return;
         }
         if(this.FProcessorWindowPassBoss != null)
         {
            if(this.FOnMonsterMainUISet != null)
            {
               this.FOnMonsterMainUISet(this,false);
            }
            this.FProcessorWindowPassBoss.ShowWindows();
            this.FProcessorWindowPassBoss.Visible = true;
            this.FIsShowPassBoss = true;
         }
      }
      
      protected function ShowPassNodalWindow(param1:Object = null) : void
      {
         var _loc2_:TSingle = null;
         if(!this.FIsPass)
         {
            return;
         }
         if(this.FSingleBins == null)
         {
            this.FSingleBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_Single);
         }
         _loc2_ = this.FSingleBins.GetDatebaseByIdentifier(this.FBarrierID) as TSingle;
         if(_loc2_ == null)
         {
            return;
         }
         if(this.FProcessorWindowPassInstance != null)
         {
            if(this.FOnMonsterMainUISet != null)
            {
               this.FOnMonsterMainUISet(this,false);
            }
            this.FProcessorWindowPassInstance.ShowWindows();
            this.FIsShowPassNodal = true;
         }
      }
      
      protected function CheckPopTip() : void
      {
         if(this.FBattleType == ENTER_TYPE_NODAL)
         {
            if(this.FLostPopTipsId.length > 0)
            {
               if(this.FOnAddPopTips != null)
               {
                  this.FOnAddPopTips(this,this.FLostPopTipsId[0][0]);
               }
            }
         }
      }
      
      public function get OnBackLargeWorldMap() : Function
      {
         return this.FOnBackLargeWorldMap;
      }
      
      public function set OnBackLargeWorldMap(param1:Function) : void
      {
         this.FOnBackLargeWorldMap = param1;
      }
      
      public function get OnSetBattleStatus() : Function
      {
         return this.FOnSetBattleStatus;
      }
      
      public function set OnSetBattleStatus(param1:Function) : void
      {
         this.FOnSetBattleStatus = param1;
      }
      
      public function get OnProcessorCheckPlot() : Function
      {
         return this.FOnProcessorCheckPlot;
      }
      
      public function set OnProcessorCheckPlot(param1:Function) : void
      {
         this.FOnProcessorCheckPlot = param1;
      }
      
      public function get OnCheckTask() : Function
      {
         return this.FOnCheckTask;
      }
      
      public function set OnCheckTask(param1:Function) : void
      {
         this.FOnCheckTask = param1;
      }
      
      public function get OnOpenSkill() : Function
      {
         return this.FOnOpenSkill;
      }
      
      public function set OnOpenSkill(param1:Function) : void
      {
         this.FOnOpenSkill = param1;
      }
      
      public function get OnAutoBattle() : Function
      {
         return this.FOnAutoBattle;
      }
      
      public function set OnAutoBattle(param1:Function) : void
      {
         this.FOnAutoBattle = param1;
      }
      
      public function get OnPassInstanceAutoBattle() : Function
      {
         return this.FOnPassInstanceAutoBattle;
      }
      
      public function set OnPassInstanceAutoBattle(param1:Function) : void
      {
         this.FOnPassInstanceAutoBattle = param1;
      }
      
      public function get OnMonsterMainUISet() : Function
      {
         return this.FOnMonsterMainUISet;
      }
      
      public function set OnMonsterMainUISet(param1:Function) : void
      {
         this.FOnMonsterMainUISet = param1;
      }
      
      public function get OnAddPopTips() : Function
      {
         return this.FOnAddPopTips;
      }
      
      public function set OnAddPopTips(param1:Function) : void
      {
         this.FOnAddPopTips = param1;
      }
      
      override public function Mount(param1:ByteArray = null) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TBlockPoint = null;
         super.Mount(param1);
         if(!FIsResourcesLoadCompleted)
         {
            this.FProcessorWindowMonsterMap.Load();
            this.FProcessorWindowBarrierChoose.Load();
            this.FProcessorWindowPassBoss.Load();
            return;
         }
         if(this.FIsInit)
         {
            return;
         }
         this.FProcessorWindowMonsterMap.Visible = true;
         this.FMonsterVect = this.GetMonsterVect();
         if(this.FBattleType == ENTER_TYPE_NODAL)
         {
            _loc3_ = int(CONST_MUSIC.PLAY_SCENE_MonsterMap);
            if(this.FNewMonsterID > 0 && !this.FIsShowNewMonster)
            {
               this.FProcessorWindowMonsterMap.SwitchMonsterMap(this.FCityID,this.FMonsterVect,this.FBattleType,this.FNodalModel.CurMissionID,this.FNewMonsterID);
               this.FIsShowNewMonster = true;
            }
            else
            {
               this.FProcessorWindowMonsterMap.SwitchMonsterMap(this.FCityID,this.FMonsterVect,this.FBattleType,this.FNodalModel.CurMissionID);
            }
            if(this.FCharacter.MainQuestsAlreadyAccept.Count > 0)
            {
               this.FMainQuest = this.FCharacter.MainQuestsAlreadyAccept.GetQuestByIndex(0);
               if(this.FMainQuest.TaskState == 1)
               {
                  this.FMainQuestStatus = 1;
               }
            }
            if(this.FOnProcessorCheckPlot != null)
            {
               this.FOnProcessorCheckPlot(this,TProcessorPlot.PLOT_TYPE_Nodal,TProcessorPlot.PLOT_POS_Befor,this.FCityID);
            }
            if(this.FBlockPointBins != null)
            {
               _loc4_ = this.FBlockPointBins.GetDatebaseByIdentifier(this.FNodalModel.CurMissionID) as TBlockPoint;
               this.FLostPopTipsId = _loc4_ ? _loc4_.PopTipIds : null;
            }
         }
         else if(this.FBattleType == ENTER_TYPE_CAMP)
         {
            _loc3_ = int(CONST_MUSIC.PLAY_SCENE_Campaign);
            _loc2_ = this.FNodalModel.GetCampaignById(this.FCityID).GetCurBattleID(this.FSingleID);
            if(!this.FIsInstanceShowMonster)
            {
               this.FProcessorWindowMonsterMap.SwitchMonsterMap(this.FCityID,this.FMonsterVect,this.FBattleType,_loc2_,_loc2_);
               this.FIsInstanceShowMonster = true;
            }
            else
            {
               this.FProcessorWindowMonsterMap.SwitchMonsterMap(this.FCityID,this.FMonsterVect,this.FBattleType,_loc2_);
            }
         }
         this.ProcessorResize();
         this.FProcessorWindowBarrierChoose.Visible = false;
         this.FProcessorWindowPassBoss.Visible = false;
         this.FProcessorWindowPassInstance.Visible = false;
         SLogicsCore.Character.RoleSencePosition = CONST_COMMON.SCENEPOSITION_MONSTERMAP;
         MusicPlayNext(CONST_SIGNAL.SIGNALDESTINATION_SOUND,_loc3_,this.FCityID,false);
         this.FIsInit = true;
      }
      
      override public function Unmount() : void
      {
         super.Unmount();
         this.FProcessorWindowMonsterMap.Visible = false;
         this.FProcessorWindowBarrierChoose.Visible = false;
         this.FProcessorWindowPassBoss.Visible = false;
         this.FProcessorWindowPassInstance.Visible = false;
         this.FIsInit = false;
         this.FIsShowNewMonster = false;
         this.FProcessorWindowBarrierChoose.Reset();
         this.FProcessorWindowPassBoss.Reset();
         this.FProcessorWindowPassInstance.Reset();
      }
      
      override public function ChatOptionsSetup(param1:TChatOptions) : void
      {
      }
      
      public function TurnBackMonsterMap(param1:Object, param2:int, param3:Boolean) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TSingle = null;
         var _loc7_:int = 0;
         var _loc8_:TBlockPoint = null;
         if(this.FBattleType == ENTER_TYPE_NODAL)
         {
            if(param3)
            {
               if(this.FBlockPointBins == null)
               {
                  this.FBlockPointBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_BlockPoint);
               }
               _loc8_ = this.FBlockPointBins.GetDatebaseByIdentifier(param2) as TBlockPoint;
               if(_loc8_.Last == 1)
               {
                  if(FOnEffectText != null)
                  {
                     FOnEffectText(this,TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.WORLDMAP_STRING_02));
                  }
               }
               if(!this.FIsBoss)
               {
                  this.ProcessorCheckTask();
               }
            }
            else
            {
               this.CheckPopTip();
            }
            if(this.FOnProcessorCheckPlot != null && param3)
            {
               this.FOnProcessorCheckPlot(this,TProcessorPlot.PLOT_TYPE_Nodal,TProcessorPlot.PLOT_POS_End,this.FCityID,this.ShowPassBossWindow);
               return;
            }
         }
         else if(this.FBattleType == ENTER_TYPE_CAMP)
         {
            _loc7_ = this.FNodalModel.GetCampaignById(this.FCityID).Diffculty;
            _loc4_ = this.FNodalModel.GetCampMaxLayerIndex(this.FSingleID);
            _loc5_ = this.FNodalModel.GetCampaignById(this.FCityID).LayerIndex;
            if(_loc4_ > this.FNodalModel.GetCampaignById(this.FCityID).GetMaxEnemyCount(_loc7_))
            {
               _loc4_ = this.FNodalModel.GetCampaignById(this.FCityID).GetMaxEnemyCount(_loc7_);
            }
            if(_loc5_ >= _loc4_ - 1)
            {
               _loc5_ = _loc4_;
               this.ShowPassNodalWindow();
            }
            return;
         }
      }
      
      public function SetData(param1:Object, param2:TNodal, param3:int, param4:int, param5:int = 0) : void
      {
         if(this.FCityID != param3)
         {
            this.FIsInstanceShowMonster = false;
            this.FIsShowNewMonster = false;
         }
         this.FNodalModel = param2;
         this.FCityID = param3;
         this.FBattleType = param4;
         this.FSingleID = param5;
      }
      
      public function ProcessorChangePosition(param1:Object) : void
      {
         if(this.FProcessorWindowBarrierChoose.Visible)
         {
            this.FProcessorWindowBarrierChoose.UpDateUI();
         }
      }
      
      public function CheckBattleType(param1:int) : Boolean
      {
         var _loc2_:TBlockPoint = null;
         var _loc3_:Boolean = false;
         _loc3_ = false;
         if(this.FBlockPointBins == null)
         {
            return _loc3_;
         }
         _loc2_ = this.FBlockPointBins.GetDatebaseByIdentifier(param1) as TBlockPoint;
         if(_loc2_ == null)
         {
            return _loc3_;
         }
         if(this.FCityID == _loc2_.Campaign)
         {
            _loc3_ = true;
         }
         return _loc3_;
      }
      
      public function TurnBackTownSceneNtf() : void
      {
         this.FProcessorWindowMonsterMap.Release();
         this.ProcessorOnBackWorldMap(this);
         TutorialNextStep(CONST_FRESHGUIDE.EVENTID_MonsterMapClose);
      }
      
      public function UpdateQuest() : void
      {
         this.FProcessorWindowMonsterMap.UpdateQuest();
      }
      
      public function FlashCurrentQuestMonster(param1:int) : void
      {
         this.FProcessorWindowMonsterMap.FlashCurrentQuestMonster(param1);
      }
   }
}

