package Processors.Game.Battle
{
   import Components.Standard.*;
   import Foundation.Common.*;
   import Foundation.Network.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Bins.*;
   import Foundation.Resources.Textures.TAnimationSequence;
   import Foundation.Resources.Textures.TTexture;
   import Foundation.Sound.SSoundPlayer;
   import Foundation.Timing.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.Affairs.*;
   import Logics.Battle.*;
   import Logics.Battle.model.*;
   import Logics.ChatOptions.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.Inventories.*;
   import Logics.Items.*;
   import Logics.KnifeOfKillSoul.*;
   import Logics.Streamization.Battle.*;
   import Logics.Streamization.Items.*;
   import Logics.Vip.*;
   import Processors.Game.*;
   import Processors.Game.Battle.Character.*;
   import Processors.Game.Battle.Effect.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.TacticalDeployment.Components.*;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Plot.*;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Rendering.Overlayers.*;
   import Rendering.Overlayers.Hints.*;
   import Rendering.Overlayers.Inventories.*;
   import Resources.Constants.*;
   import Resources.Strings.*;
   import Utilities.UI.Overlayers.*;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.Rectangle;
   import flash.net.*;
   import flash.system.*;
   import flash.text.*;
   import flash.utils.*;
   import ghostcat.util.data.*;
   import ghostcat.util.easing.*;
   
   public class TBattleHandle extends TProcessorGame
   {
      
      private static var FPlaybackStage:Stage;
      
      protected static var FAutoCloseBattle:Boolean;
      
      private static var FPlaybackRate:int = 1;
      
      private static var FPlaybackActive:Boolean = false;
      
      private static var FPlaybackBaseFps:Number = 30;
      
      private static var FPlaybackClock:Number = 0;
      
      private static var FPlaybackReal:int = 0;
      
      private static var FPlaybackTasks:Object = {};
      
      private static var FPlaybackTaskId:uint = 0;
      
      protected static const AFFAIRID_TimingWaitStartBattle:uint = 1;
      
      protected static const TIME_STARTBATTLE_PERIOD:int = 500;
      
      protected static const SIZE_HEIGHT_BattleReady:int = 118;
      
      protected static const SIZE_WIDTH_Win:int = 684;
      
      protected static const SIZE_HEIGHT_Win:int = 204;
      
      protected static const SIZE_WIDTH_WinOrg:int = 684;
      
      protected static const SIZE_HEIGHT_WinOrg:int = 227;
      
      protected static const SIZE_WIDTH_Lost:int = 684;
      
      protected static const SIZE_HEIGHT_Lost:int = 204;
      
      protected static const SIZE_WIDTH_Result:int = 684;
      
      protected static const SIZE_HEIGHT_Result:int = 123;
      
      protected static const SIZE_WIDTH_Statistics:int = 564;
      
      protected static const SIZE_HEIGHT_Statistics:int = 608;
      
      protected static const MAINROLE_StartID:uint = 11100001;
      
      protected static const MAINROLE_EndID:uint = 11100006;
      
      protected static const HEROENEMY_DividingID:uint = 12101000;
      
      protected static const FRMAE_INDEX_START:int = 1;
      
      protected static const CATEGORY_Normal:uint = CONST_INVENTORY.CATEGORY_Normal;
      
      protected static const CATEGORY_Equipment:uint = CONST_INVENTORY.CATEGORY_Equipment;
      
      protected static const CATEGORY_Gem:uint = CONST_INVENTORY.CATEGORY_Gem;
      
      protected static const CATEGORY_Treasure:uint = CONST_INVENTORY.CATEGORY_Treasure;
      
      protected static const CATEGORY_Material:uint = CONST_INVENTORY.CATEGORY_Material;
      
      protected static const ENTER_TYPE_NODAL:int = CONST_BATTLE.BattleType_Nodal;
      
      protected static const ENTER_TYPE_CAMP:int = CONST_BATTLE.BattleType_Camp;
      
      protected static const ENTER_TYPE_KILLHERO:int = CONST_BATTLE.BattleType_KillHero;
      
      protected static const ENTER_TYPE_ARENA:int = CONST_BATTLE.BattleType_Arena;
      
      protected static const ENTER_TYPE_VOIDSOULWORLD:int = CONST_BATTLE.BattleType_VoidSoulWorld;
      
      protected static const ENTER_TYPE_TREASUREMAP:int = CONST_BATTLE.BattleType_TreasureMap;
      
      protected static const ENTER_TYPE_FIGHTPET:int = CONST_BATTLE.BattleType_FightPet;
      
      protected static const ENTER_TYPE_CITYDEFEND:int = CONST_BATTLE.BattleType_CityDefend;
      
      protected static const ENTER_TYPE_ORGANIZATIONWAR:int = CONST_BATTLE.BattleType_OrganizationWar;
      
      protected static const ENTER_TYPE_SLAVE:int = CONST_BATTLE.BattleType_Slave;
      
      protected static const ENTER_TYPE_SOULMONSTER:int = CONST_BATTLE.BattleType_SoulMonster;
      
      protected static const ENTER_TYPE_TRAITORATTACK:int = CONST_BATTLE.BattleType_TraitorAttack;
      
      protected static const ENTER_TYPE_SEVENKING:int = CONST_BATTLE.BattleType_SevenKing;
      
      protected static const ENTER_TYPE_SKYTOWERPVE:int = CONST_BATTLE.BattleType_SkyTowerPVE;
      
      protected static const ENTER_TYPE_SKYTOWERPVP:int = CONST_BATTLE.BattleType_SkyTowerPVP;
      
      protected static const ENTER_TYPE_GONGFUFIGHT:int = CONST_BATTLE.BattleType_GongFuFight;
      
      protected static const ENTER_TYPE_HEROCHANGE:int = CONST_BATTLE.BattleType_HeroChange;
      
      protected static const ENTER_TYPE_VAINTRAVEL:int = CONST_BATTLE.BattleType_VainTravel;
      
      protected static const ENTER_TYPE_ORGSINGLE:int = CONST_BATTLE.BattleType_OrgSingle;
      
      protected static const ENTER_TYPE_ORGGROUP:int = CONST_BATTLE.BattleType_OrgGroup;
      
      protected static const ENTER_TYPE_RELATEDPARTNER:int = CONST_BATTLE.BattleType_RelatedPartner;
      
      protected static const ENTER_TYPE_NIGHTMARETRIAL:int = CONST_BATTLE.BattleType_NightmareTrial;
      
      protected static const ENTER_TYPE_EXPDUPLICATE:int = CONST_BATTLE.BattleType_ExpDuplicate;
      
      protected static const ENTER_TYPE_REPLAY:int = CONST_BATTLE.BattleType_Replay;
      
      protected static const ENTER_TYPE_VIDEO:int = CONST_BATTLE.BattleType_Video;
      
      protected static const PLAY_SCENE_Nodal:uint = CONST_MUSIC.PLAY_SCENE_Nodal;
      
      protected static const PLAY_SCENE_Campaign:uint = CONST_MUSIC.PLAY_SCENE_Campaign;
      
      protected static const PLAY_SCENE_KillHeros:uint = CONST_MUSIC.PLAY_SCENE_KillHeros;
      
      protected static const PLAY_SCENE_Arena:uint = CONST_MUSIC.PLAY_SCENE_Arena;
      
      protected static const PLAY_SCENE_FightPet:uint = CONST_MUSIC.PLAY_SCENE_FightPet;
      
      protected static const PLAY_SCENE_OrganizationalWar:uint = CONST_MUSIC.PLAY_SCENE_OrganizationalWar;
      
      protected static const PLAY_SCENE_TraitorAttack:uint = CONST_MUSIC.PLAY_SCENE_TraitorAttack;
      
      protected static const PLAY_SCENE_TreasureMap:uint = CONST_MUSIC.PLAY_SCENE_TreasureMap;
      
      protected static const PLAY_SCENE_CityDefend:uint = CONST_MUSIC.PLAY_SCENE_CityDefend;
      
      protected static const PLAY_SCENE_Slave:uint = CONST_MUSIC.PLAY_SCENE_Slave;
      
      protected static const PLAY_SCENE_HomeMonster:uint = CONST_MUSIC.PLAY_SCENE_HomeMonster;
      
      protected static const PLAY_SCENE_SkyTower:uint = CONST_MUSIC.PLAY_SCENE_SkyTower;
      
      protected static const PLAY_SCENE_GongFuFight:uint = CONST_MUSIC.PLAY_SCENE_GongFuFight;
      
      public static var IsInBattle:Boolean = false;
      
      private var FPlaybackButton:Sprite;
      
      private var FPlaybackLabel:TextField;
      
      private var FPlaybackNativeControl:TUIButton;
      
      protected var FVoidPreviousDepth:int = -1;
      
      protected var FKnifeOfKillSoulInforTip:TKnifeInforTip;
      
      protected var FRoleModelBins:TBins;
      
      protected var FEnemyBins:TBins;
      
      protected var FBaseHeroBins:TBins;
      
      protected var FSkillConfigBins:TBins;
      
      protected var FKnifeExpand:TBins;
      
      protected var FUnstreamizerRewards:TUnstreamizerRewards;
      
      protected var FUnstreamizerBattleRepot:TUnstreamizerBattleRepot;
      
      protected var FUnstreamizerStatistics:TUnstreamizerBattleStatistics;
      
      protected var FProcessorBattleLoading:TProcessorBattleLoading;
      
      protected var FProcessorWindowWin:TProcessorWindowWin;
      
      protected var FProcessorWindowWinOrg:TProcessorWindowWinOrg;
      
      protected var FProcessorWindowLost:TProcessorWindowLost;
      
      protected var FProcessorWindowReward:TProcessorWindowReward;
      
      protected var FProcessorWindowStatistics:TProcessorWindowStatistics;
      
      protected var FVipData:TVip;
      
      protected var FReward:TItems;
      
      protected var FBattleStage:TBattleStage;
      
      protected var FMC_BattleReady:MovieClip;
      
      protected var FSP_Skip:Sprite;
      
      protected var FBT_Skip:TUIButton;
      
      protected var FSP_BloodBuffer:Sprite;
      
      protected var FBattleInfo:TBattleInfo;
      
      protected var FStatisticsInfo:TStatisticsInfo;
      
      protected var FBattleBgId:uint;
      
      protected var FBattleBg:Bitmap;
      
      protected var FNewBgId:uint;
      
      protected var FChgBattleBg:Bitmap;
      
      protected var FEnterType:int;
      
      protected var FEnterId:int;
      
      protected var FIsWin:Boolean;
      
      protected var FReportData:ByteArray;
      
      protected var FIsReplay:Boolean;
      
      protected var FReportType:String;
      
      protected var FModelVect:Vector.<int>;
      
      protected var FDeketModelVect:Vector.<int>;
      
      protected var FDeketModelRunVect:Vector.<int>;
      
      protected var FLargeVect:Vector.<int>;
      
      protected var FSkillVect:Vector.<int>;
      
      protected var FDeketSkillVect:Vector.<int>;
      
      protected var FBackgroundVect:Vector.<int>;
      
      protected var FUseSkillList:Vector.<uint>;
      
      protected var FIsCanSkip:Boolean;
      
      protected var FSkipHint:THint;
      
      protected var FTickStartBattle:int;
      
      protected var FIsInitialization:Boolean;
      
      protected var FStartFightSoundId:uint;
      
      protected var FOnCheckPlot:Function;
      
      protected var FOnErrorText:Function;
      
      protected var FOnBattleShowChat:Function;
      
      protected var FOnBattleReturn:Function;
      
      public function TBattleHandle(param1:TUIComponent)
      {
         super(param1);
         this.InitBattleHandle();
         this.FReward = new TItems();
         this.FUnstreamizerRewards = new TUnstreamizerRewards();
         this.FUnstreamizerStatistics = new TUnstreamizerBattleStatistics();
         this.FBattleInfo = new TBattleInfo();
         this.FModelVect = new Vector.<int>();
         this.FDeketModelVect = new Vector.<int>();
         this.FDeketModelRunVect = new Vector.<int>();
         this.FLargeVect = new Vector.<int>();
         this.FSkillVect = new Vector.<int>();
         this.FDeketSkillVect = new Vector.<int>();
         this.FBackgroundVect = new Vector.<int>();
         this.FUseSkillList = new Vector.<uint>();
         this.FSkipHint = new THint();
         this.FStatisticsInfo = new TStatisticsInfo();
         this.FIsWin = true;
         this.FIsInitialization = false;
      }
      
      public static function get PlaybackRate() : int
      {
         return FPlaybackRate;
      }
      
      public static function get PlaybackTime() : int
      {
         return int(FPlaybackClock + (getTimer() - FPlaybackReal) * FPlaybackRate);
      }
      
      private static function SetPlaybackRate(value:int) : void
      {
         FPlaybackClock = PlaybackTime;
         FPlaybackReal = getTimer();
         FPlaybackRate = FPlaybackActive && value == 2 ? 2 : 1;
         if(FPlaybackStage != null)
         {
            FPlaybackStage.frameRate = FPlaybackBaseFps * FPlaybackRate;
         }
      }
      
      public static function PlaybackTimeout(callback:Function, delay:Number, ... args) : uint
      {
         if(!FPlaybackActive)
         {
            return 0;
         }
         var id:uint = ++FPlaybackTaskId;
         FPlaybackTasks[id] = {
            "due":PlaybackTime + Math.max(0,delay),
            "callback":callback,
            "args":args
         };
         return id;
      }
      
      public static function ClearPlaybackTimeout(id:uint) : void
      {
         delete FPlaybackTasks[id];
      }
      
      private static function PulsePlaybackTimers() : void
      {
         if(!FPlaybackActive)
         {
            return;
         }
         var now:int = PlaybackTime;
         var ready:Array = [];
         for(var id:String in FPlaybackTasks)
         {
            if(FPlaybackTasks[id].due <= now)
            {
               ready.push({
                  "id":uint(id),
                  "due":FPlaybackTasks[id].due
               });
            }
         }
         ready.sortOn(["due","id"],[Array.NUMERIC,Array.NUMERIC]);
         for each(var entry:Object in ready)
         {
            var key:uint = uint(entry.id);
            var task:Object = FPlaybackTasks[key];
            if(task != null)
            {
               delete FPlaybackTasks[key];
               task.callback.apply(null,task.args);
            }
         }
      }
      
      public static function AutoCloseBattle(param1:Boolean) : void
      {
         FAutoCloseBattle = param1;
      }
      
      private function FindPlaybackCaption(node:DisplayObjectContainer) : TextField
      {
         var i:int = 0;
         while(i < node.numChildren)
         {
            var child:DisplayObject = node.getChildAt(i);
            if(child is TextField)
            {
               return child as TextField;
            }
            if(child is DisplayObjectContainer)
            {
               var field:TextField = FindPlaybackCaption(child as DisplayObjectContainer);
               if(field != null)
               {
                  return field;
               }
            }
            i++;
         }
         return null;
      }
      
      private function RefreshPlaybackCaption(event:MouseEvent) : void
      {
         UpdatePlaybackButton();
      }
      
      private function PlaybackNativeClick(sender:Object, event:MouseEvent = null) : void
      {
         if(event != null)
         {
            TogglePlaybackSpeed(event);
         }
      }
      
      private function CreatePlaybackButton() : void
      {
         if(FPlaybackButton != null)
         {
            return;
         }
         FPlaybackButton = TUtilityReflection.CreateDisplayObjectInstance(CONST_BATTLE.RESOURCE_ClassName_BTN_Skip) as Sprite;
         if(FPlaybackButton == null)
         {
            return;
         }
         FPlaybackButton.name = "battlePlaybackSpeed";
         FPlaybackNativeControl = new TUIButton();
         FPlaybackNativeControl.Substrate = FPlaybackButton[CONST_BATTLE.RESOURCE_Link_MC_ButtonSkipBattle] as MovieClip;
         FPlaybackNativeControl.IsFilter = true;
         FPlaybackNativeControl.OnClick = PlaybackNativeClick;
         FPlaybackNativeControl.Enabled = true;
         var clip:MovieClip = FPlaybackNativeControl.Substrate;
         clip.addEventListener(MouseEvent.MOUSE_OVER,RefreshPlaybackCaption);
         clip.addEventListener(MouseEvent.MOUSE_OUT,RefreshPlaybackCaption);
         clip.addEventListener(MouseEvent.MOUSE_DOWN,RefreshPlaybackCaption);
         clip.addEventListener(MouseEvent.MOUSE_UP,RefreshPlaybackCaption);
         addChild(FPlaybackButton);
         addEventListener(Event.REMOVED_FROM_STAGE,PlaybackRemoved);
         UpdatePlaybackButton();
      }
      
      private function UpdatePlaybackButton() : void
      {
         if(FPlaybackButton == null || FSP_Skip == null)
         {
            return;
         }
         var bounds:Rectangle = FSP_Skip.getBounds(this);
         var skin:Rectangle = FPlaybackButton.getBounds(FPlaybackButton);
         FPlaybackButton.x = bounds.right + 8 - skin.x;
         FPlaybackButton.y = bounds.y - skin.y;
         FPlaybackButton.visible = FPlaybackActive && this.Visible && FSP_Skip.visible;
         FPlaybackLabel = FindPlaybackCaption(FPlaybackNativeControl.Substrate);
         if(FPlaybackLabel != null)
         {
            FPlaybackLabel.text = "x" + FPlaybackRate;
         }
      }
      
      private function StartPlaybackSpeed() : void
      {
         StopPlaybackSpeed();
         FPlaybackStage = stage;
         if(stage != null)
         {
            FPlaybackBaseFps = stage.frameRate;
         }
         FPlaybackActive = true;
         SetPlaybackRate(1);
         UpdatePlaybackButton();
      }
      
      private function StopPlaybackSpeed() : void
      {
         SetPlaybackRate(1);
         FPlaybackActive = false;
         FPlaybackStage = null;
         FPlaybackTasks = {};
         if(FPlaybackButton != null)
         {
            FPlaybackButton.visible = false;
         }
      }
      
      private function TogglePlaybackSpeed(event:MouseEvent) : void
      {
         if(!FPlaybackActive || !this.Visible || !FSP_Skip.visible)
         {
            return;
         }
         event.stopPropagation();
         SetPlaybackRate(FPlaybackRate == 1 ? 2 : 1);
         UpdatePlaybackButton();
      }
      
      private function PlaybackRemoved(event:Event) : void
      {
         if(event.target == this)
         {
            StopPlaybackSpeed();
         }
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfBattle.LoadPrimary(CONST_BATTLE.RESOURCE_Battle);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:TConfigValue = null;
         if(!this.FIsInitialization)
         {
            this.FVipData = SLogicsCore.Character.VipData;
            this.FProcessorWindowReward = new TProcessorWindowReward(this);
            this.FProcessorWindowReward.OnBattleTurnBack = this.ProcessorOnBattleTurnBack;
            this.FProcessorWindowReward.OnBattleReplay = this.ProcessorOnBattleReplay;
            this.FProcessorWindowReward.StatisticsCallBack = this.ProcessorOnBattleStatistics;
            this.FProcessorWindowReward.HintOnMove = SUtilityOverLayer.UIComponentsHintOnOver;
            this.FProcessorWindowReward.HintOnOut = SUtilityOverLayer.UIComponentsHintOnOut;
            this.FProcessorWindowReward.x = (CONST_COMMON.STAGE_Width - SIZE_WIDTH_Result) / 2;
            this.FProcessorWindowReward.y = (CONST_COMMON.STAGE_Height - SIZE_HEIGHT_Result) / 2;
            this.FProcessorWindowWin = new TProcessorWindowWin(this);
            this.FProcessorWindowWin.ClickCallBack = this.ProcessorOnBattleTurnBack;
            this.FProcessorWindowWin.SlotsOnMove = SUtilityOverLayer.UIComponentsHintOnOver;
            this.FProcessorWindowWin.SlotsOnOut = SUtilityOverLayer.UIComponentsHintOnOut;
            this.FProcessorWindowWin.ReplayCallBack = this.ProcessorOnBattleReplay;
            this.FProcessorWindowWin.StatisticsCallBack = this.ProcessorOnBattleStatistics;
            this.FProcessorWindowWin.HintOnMove = SUtilityOverLayer.UIComponentsHintOnOver;
            this.FProcessorWindowWin.HintOnOut = SUtilityOverLayer.UIComponentsHintOnOut;
            this.FProcessorWindowWin.Setup();
            this.FProcessorWindowWin.x = (CONST_COMMON.STAGE_Width - SIZE_WIDTH_Win) / 2;
            this.FProcessorWindowWin.y = (CONST_COMMON.STAGE_Height - SIZE_HEIGHT_Win) / 2;
            this.FProcessorWindowStatistics = new TProcessorWindowStatistics(this);
            this.FProcessorWindowStatistics.x = (CONST_COMMON.STAGE_Width - SIZE_WIDTH_Statistics) / 2;
            this.FProcessorWindowStatistics.y = (CONST_COMMON.STAGE_Height - SIZE_HEIGHT_Statistics) / 2;
            this.FProcessorWindowWinOrg = new TProcessorWindowWinOrg(this);
            this.FProcessorWindowWinOrg.ClickCallBack = this.ProcessorOnBattleTurnBack;
            this.FProcessorWindowWinOrg.SlotsOnMove = SUtilityOverLayer.UIComponentsHintOnOver;
            this.FProcessorWindowWinOrg.SlotsOnOut = SUtilityOverLayer.UIComponentsHintOnOut;
            this.FProcessorWindowWinOrg.ReplayCallBack = this.ProcessorOnBattleReplay;
            this.FProcessorWindowWinOrg.HintOnMove = SUtilityOverLayer.UIComponentsHintOnOver;
            this.FProcessorWindowWinOrg.HintOnOut = SUtilityOverLayer.UIComponentsHintOnOut;
            this.FProcessorWindowWinOrg.Setup();
            this.FProcessorWindowWinOrg.x = (CONST_COMMON.STAGE_Width - SIZE_WIDTH_WinOrg) / 2;
            this.FProcessorWindowWinOrg.y = (CONST_COMMON.STAGE_Height - SIZE_HEIGHT_WinOrg) / 2;
            this.FProcessorWindowLost = new TProcessorWindowLost(this);
            this.FProcessorWindowLost.ClickCallBack = this.ProcessorOnBattleTurnBack;
            this.FProcessorWindowLost.ReplayCallBack = this.ProcessorOnBattleReplay;
            this.FProcessorWindowLost.StatisticsCallBack = this.ProcessorOnBattleStatistics;
            this.FProcessorWindowLost.HintOnMove = SUtilityOverLayer.UIComponentsHintOnOver;
            this.FProcessorWindowLost.HintOnOut = SUtilityOverLayer.UIComponentsHintOnOut;
            this.FProcessorWindowLost.x = (CONST_COMMON.STAGE_Width - SIZE_WIDTH_Lost) / 2;
            this.FProcessorWindowLost.y = (CONST_COMMON.STAGE_Height - SIZE_HEIGHT_Lost) / 2;
            this.FKnifeOfKillSoulInforTip = new TKnifeInforTip(FParent);
            this.FKnifeOfKillSoulInforTip.Type = TKnifeInforTip.TYPE_TIPS_BATTLE;
            this.FKnifeOfKillSoulInforTip.Visible = false;
            this.FKnifeOfKillSoulInforTip.UIDispatch();
            this.FKnifeOfKillSoulInforTip.UILocation();
            this.FSP_Skip = TUtilityReflection.CreateDisplayObjectInstance(CONST_BATTLE.RESOURCE_ClassName_BTN_Skip) as Sprite;
            this.FSP_Skip.visible = false;
            this.FBT_Skip = new TUIButton();
            this.FBT_Skip.Substrate = this.FSP_Skip[CONST_BATTLE.RESOURCE_Link_MC_ButtonSkipBattle];
            this.FBT_Skip.OnClick = this.ButtonSkipOnClick;
            this.FBT_Skip.OnMove = this.ButtonSkipOnRoll;
            this.FBT_Skip.OnOut = this.ButtonSkipOnRoll;
            this.FBT_Skip.IsFilter = true;
            this.FBT_Skip.Enabled = false;
            addChild(this.FSP_Skip);
            this.FSP_Skip.x = (CONST_COMMON.STAGE_Width - this.FSP_Skip.width) / 2;
            this.FSP_Skip.y = FUICore.StageHeight - 18 - this.FSP_Skip.height / 2;
            this.FIsCanSkip = false;
            CreatePlaybackButton();
            this.FSP_BloodBuffer = TUtilityReflection.CreateDisplayObjectInstance("BloodBuffer") as Sprite;
            if(this.FSP_BloodBuffer != null)
            {
               this.FSP_BloodBuffer.addEventListener(MouseEvent.MOUSE_MOVE,this.BloodBufferOnMouseMove);
               this.FSP_BloodBuffer.addEventListener(MouseEvent.MOUSE_OUT,this.BloodBufferOnMouseOut);
               addChild(this.FSP_BloodBuffer);
               this.FSP_BloodBuffer.x = (CONST_COMMON.STAGE_Width - this.FSP_BloodBuffer.width) / 2;
               this.FSP_BloodBuffer.y = this.FSP_Skip.y - 10 - this.FSP_BloodBuffer.height / 2;
               this.FSP_BloodBuffer.visible = false;
            }
            _loc1_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.Sound_StartFightMusic) as TConfigValue;
            this.FStartFightSoundId = _loc1_.Value as uint;
         }
         this.FIsInitialization = true;
         SLogicsCore.SignalPost(CONST_SIGNAL.SIGNALDESTINATION_LobbyTutorial,CONST_FRESHGUIDE.ObjectID_Component,CONST_FRESHGUIDE.MCID_GetRewardView,this);
         SLogicsCore.SignalPost(CONST_SIGNAL.SIGNALDESTINATION_LobbyTutorial,CONST_FRESHGUIDE.ObjectID_ArrowParent,CONST_FRESHGUIDE.MCID_GetRewardView,FParent.parent);
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function AffairRegisterRoutines() : void
      {
         super.AffairRegisterRoutines();
         FAffairRoutines.Register(AFFAIRID_TimingWaitStartBattle,this.AffairPerform_TimingWaitStartBattle);
      }
      
      protected function AffairPerform_TimingWaitStartBattle(param1:TAffair) : void
      {
         var _loc2_:Boolean = false;
         _loc2_ = this.PerformAffair_TimingWaitStartBattle();
         if(_loc2_)
         {
            param1.PostProcess = TAffair.POSTPROCESS_Pend;
         }
         else
         {
            param1.PostProcess = TAffair.POSTPROCESS_Remove;
         }
      }
      
      protected function PerformAffair_TimingWaitStartBattle() : Boolean
      {
         var _loc1_:int = 0;
         _loc1_ = int(STimingCore.TickCount);
         if(_loc1_ - this.FTickStartBattle > TIME_STARTBATTLE_PERIOD)
         {
            if(!this.FMC_BattleReady.isPlaying)
            {
               this.FMC_BattleReady.play();
               if(this.FStartFightSoundId != 0)
               {
                  SLogicsCore.SignalPost(CONST_SIGNAL.SIGNALDESTINATION_SOUND,CONST_MUSIC.PLAY_SOUND_EFFECT,this.FStartFightSoundId,true);
               }
            }
            return false;
         }
         return true;
      }
      
      override protected function LogicsPerform() : void
      {
         PulsePlaybackTimers();
         UpdatePlaybackButton();
         super.LogicsPerform();
         if(!this.Visible)
         {
            return;
         }
         if(this.FProcessorWindowWin != null && this.FProcessorWindowWin.Visible)
         {
            this.FProcessorWindowWin.UpdataSlot();
         }
         if(this.FProcessorWindowWinOrg != null && this.FProcessorWindowWinOrg.Visible)
         {
            this.FProcessorWindowWinOrg.UpdataSlot();
         }
         if(this.FMC_BattleReady != null && this.FMC_BattleReady.visible)
         {
            if(this.FMC_BattleReady.currentFrame == this.FMC_BattleReady.totalFrames - 15)
            {
               this.FBT_Skip.Enabled = this.FIsCanSkip;
               if(FAutoCloseBattle && this.FIsCanSkip)
               {
                  this.ButtonSkipOnClick(this);
               }
               this.FBattleStage.StartBattle();
            }
            else if(this.FMC_BattleReady.currentFrame == this.FMC_BattleReady.totalFrames)
            {
               this.FMC_BattleReady.gotoAndStop(FRMAE_INDEX_START);
               this.FMC_BattleReady.stop();
               this.FMC_BattleReady.visible = false;
            }
         }
         TEffectControl.UpdataRoleEffect();
         TEffectControl.UpdataPublicEffect();
         TEffectControl.UpdataSpecialChainEffect();
         if(this.FKnifeOfKillSoulInforTip != null && this.FKnifeOfKillSoulInforTip.Visible)
         {
            this.FKnifeOfKillSoulInforTip.UpdatePosition();
         }
      }
      
      override protected function PacketRegisterRoutines() : void
      {
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Battle_StartReportDataReq,this.PacketPerform_SC_BattleStartReportData);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_SingleBattleResult,this.PacketPerform_SC_SingleBattleResult);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_BattleStatistics,this.PacketPerform_SC_StatisticsRet);
      }
      
      protected function VoidTrace(stage:String, message:String = "") : void
      {
         if(this.FEnterType != ENTER_TYPE_VOIDSOULWORLD && this.FEnterType != ENTER_TYPE_CITYDEFEND)
         {
            return;
         }
         var p:TPacket = SNetworkCore.PacketAcquire(25293569);
         p.Data.writeUTF((this.FEnterType == ENTER_TYPE_CITYDEFEND ? "Protect " : "") + stage + " " + message);
         SNetworkCore.Transceiver.PacketTransmit(p);
      }
      
      protected function PacketPerform_SC_BattleStartReportData(param1:TPacket) : void
      {
         this.VoidTrace("report","visible=" + this.Visible + " blocked=" + TBattleHandle.IsInBattle);
         if(TBattleHandle.IsInBattle)
         {
            return;
         }
         try
         {
            this.FReportData = param1.Data;
            this.FUnstreamizerBattleRepot.Unstreamize(this.FReportData,this.FBattleInfo,null);
            this.FIsReplay = false;
            if(this.FEnterType == ENTER_TYPE_CITYDEFEND)
            {
               TBattleHandle.IsInBattle = true;
            }
            this.VoidTrace("decoded");
            this.CheckUseSkill();
            this.VoidTrace("skills-checked");
            this.CheckResources();
            this.VoidTrace("resources-requested");
         }
         catch(e:Error)
         {
            if(this.FEnterType == ENTER_TYPE_CITYDEFEND)
            {
               TBattleHandle.IsInBattle = false;
            }
            this.VoidTrace("report-error",e.errorID + " " + e.message + " " + e.getStackTrace());
            if(this.FOnErrorText != null)
            {
               this.FOnErrorText(this,(this.FEnterType == ENTER_TYPE_CITYDEFEND ? "Protect Seireitei: " : "Void: ") + e.message);
            }
         }
      }
      
      protected function PacketPerform_SC_SingleBattleResult(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:uint = 0;
         _loc2_ = param1.Data;
         _loc3_ = uint(_loc2_.readInt());
         if(_loc3_ != 0)
         {
            return;
         }
         this.FIsWin = _loc2_.readByte() > 0;
         this.FReward.Clear();
         this.FUnstreamizerRewards.Unstreamize(_loc2_,this.FReward,null);
      }
      
      protected function PacketPerform_SC_StatisticsRet(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:uint = 0;
         _loc2_ = param1.Data;
         this.FStatisticsInfo.Clear();
         this.FUnstreamizerStatistics.Unstreamize(_loc2_,this.FStatisticsInfo,null);
         this.FProcessorWindowStatistics.UpdateData(this.FStatisticsInfo);
         this.FProcessorWindowStatistics.Visible = true;
      }
      
      protected function InitBattleHandle() : void
      {
         this.FBattleBg = new Bitmap();
         addChild(this.FBattleBg);
         this.FBattleBg.visible = false;
         this.FChgBattleBg = new Bitmap();
         addChild(this.FChgBattleBg);
         this.FChgBattleBg.visible = false;
         this.FUnstreamizerBattleRepot = new TUnstreamizerBattleRepot();
         this.FProcessorBattleLoading = new TProcessorBattleLoading(this);
         addChild(this.FProcessorBattleLoading);
         this.FProcessorBattleLoading.OnLoadingCompleted = this.ProcessorOnLoadingCompleted;
         this.FProcessorBattleLoading.OnShowBattle = this.ProcessorOnShowBattle;
         this.FProcessorBattleLoading.OnCloseLoad = this.ProcessorOnCloseLoad;
         this.FProcessorBattleLoading.Load();
         this.FProcessorBattleLoading.mouseChildren = false;
         this.FProcessorBattleLoading.mouseEnabled = false;
         this.FProcessorBattleLoading.Visible = false;
      }
      
      protected function LoadBattleBackgroundResource(param1:uint) : void
      {
         SResourcesCore.TexturesBackgroundIcon.LoadAutoSecondary(param1,this.AutoLoadCallBack);
      }
      
      protected function AutoLoadCallBack(param1:Object, param2:TTexture, param3:uint) : void
      {
         var _loc4_:TAnimationSequence = null;
         switch(param3)
         {
            case this.FBattleBgId:
               _loc4_ = param2.GetAnimationSequenceByIndex(0);
               this.FBattleBg.bitmapData = _loc4_.GetAnimationFrameByIndex(0).Surface;
               break;
            case this.FNewBgId:
               _loc4_ = param2.GetAnimationSequenceByIndex(0);
               this.FChgBattleBg.bitmapData = _loc4_.GetAnimationFrameByIndex(0).Surface;
         }
      }
      
      protected function CheckEffect(param1:uint, param2:Object, param3:Vector.<int>, param4:Vector.<int>) : void
      {
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:Object = null;
         var _loc9_:Object = null;
         var _loc10_:uint = 0;
         if(param1 != 0 && this.FUseSkillList.indexOf(param1) < 0)
         {
            return;
         }
         _loc9_ = param2.ChgBg;
         for(_loc7_ in _loc9_)
         {
            _loc10_ = uint(_loc9_[_loc7_]);
            if(_loc10_ != 0)
            {
               if(param4.indexOf(_loc10_) < 0)
               {
                  param4.push(_loc10_);
               }
            }
         }
         _loc8_ = param2.appendEffect;
         if(_loc8_ != null)
         {
            for(_loc6_ in _loc8_)
            {
               _loc10_ = uint(_loc8_[_loc6_].effectId);
               if(_loc10_ != 0)
               {
                  if(param3.indexOf(_loc10_) < 0)
                  {
                     param3.push(_loc10_);
                  }
               }
               _loc10_ = uint(_loc8_[_loc6_].AttackedEffectId);
               if(_loc10_ != 0)
               {
                  if(param3.indexOf(_loc10_) < 0)
                  {
                     param3.push(_loc10_);
                  }
               }
               _loc9_ = _loc8_[_loc6_].ChgBg;
               for(_loc7_ in _loc9_)
               {
                  _loc10_ = uint(_loc9_[_loc7_]);
                  if(_loc10_ != 0)
                  {
                     if(param4.indexOf(_loc10_) < 0)
                     {
                        param4.push(_loc10_);
                     }
                  }
               }
               this.CheckEffect(0,_loc8_[_loc6_],param3,param4);
            }
         }
      }
      
      protected function TestResources(param1:String) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Vector.<TRoleBattleInfo> = null;
         var _loc4_:TRoleBattleInfo = null;
         var _loc5_:TBaseHero = null;
         var _loc6_:TEnemy = null;
         var _loc7_:Object = null;
         var _loc8_:String = null;
         var _loc9_:TRoleModel = null;
         var _loc10_:TKnifeExpand = null;
         this.FModelVect = new Vector.<int>();
         this.FDeketModelVect = new Vector.<int>();
         this.FLargeVect = new Vector.<int>();
         this.FSkillVect = new Vector.<int>();
         if(this.FRoleModelBins == null)
         {
            this.FRoleModelBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_RoleModel);
         }
         if(this.FEnemyBins == null)
         {
            this.FEnemyBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_Enemy);
         }
         if(this.FBaseHeroBins == null)
         {
            this.FBaseHeroBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_BaseHero);
         }
         if(this.FKnifeExpand == null)
         {
            this.FKnifeExpand = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_KnifeExpand);
         }
         _loc3_ = this.FBattleInfo.PlayerInfo_1.RoleBattleInfos;
         _loc2_ = 0;
         while(_loc2_ < _loc3_.length)
         {
            _loc4_ = _loc3_[_loc2_];
            _loc9_ = this.FRoleModelBins.GetDatebaseByIdentifier(_loc4_.RoleId) as TRoleModel;
            this.FModelVect.push(_loc9_.Model);
            if(_loc4_.RoleId > HEROENEMY_DividingID)
            {
               _loc6_ = this.FEnemyBins.GetDatebaseByIdentifier(_loc4_.RoleId) as TEnemy;
               _loc6_.Effects = param1;
               _loc7_ = Json.decode(_loc6_.Effects);
            }
            else
            {
               _loc5_ = this.FBaseHeroBins.GetDatebaseByIdentifier(_loc4_.RoleId) as TBaseHero;
               _loc5_.AttackEffect = param1;
               _loc7_ = Json.decode(_loc5_.AttackEffect);
            }
            if(_loc7_ != 0)
            {
               for(_loc8_ in _loc7_)
               {
                  this.CheckEffect(int(_loc8_),_loc7_[_loc8_],this.FSkillVect,this.FBackgroundVect);
               }
            }
            _loc2_++;
         }
         _loc3_ = this.FBattleInfo.PlayerInfo_2.RoleBattleInfos;
         _loc2_ = 0;
         while(_loc2_ < _loc3_.length)
         {
            _loc4_ = _loc3_[_loc2_];
            _loc9_ = this.FRoleModelBins.GetDatebaseByIdentifier(_loc4_.RoleId) as TRoleModel;
            this.FModelVect.push(_loc9_.Model);
            this.FLargeVect.push(_loc9_.RoleHead);
            if(_loc4_.RoleId > HEROENEMY_DividingID)
            {
               _loc6_ = this.FEnemyBins.GetDatebaseByIdentifier(_loc4_.RoleId) as TEnemy;
               _loc6_.Effects = param1;
               _loc7_ = Json.decode(_loc6_.Effects);
            }
            else
            {
               _loc5_ = this.FBaseHeroBins.GetDatebaseByIdentifier(_loc4_.RoleId) as TBaseHero;
               _loc5_.AttackEffect = param1;
               _loc7_ = Json.decode(_loc5_.AttackEffect);
            }
            if(_loc7_ != 0)
            {
               for(_loc8_ in _loc7_)
               {
                  this.CheckEffect(int(_loc8_),_loc7_[_loc8_],this.FSkillVect,this.FBackgroundVect);
               }
            }
            _loc2_++;
         }
         if(this.FBattleInfo.PlayerInfo_1.KnifeOfKillSoulID != 0)
         {
            _loc10_ = this.FKnifeExpand.GetDatebaseByIdentifier(this.FBattleInfo.PlayerInfo_1.KnifeOfKillSoulID) as TKnifeExpand;
            _loc7_ = Json.decode(_loc10_.Effects);
            this.CheckEffect(_loc10_.SkillID,_loc7_[_loc10_.SkillID],this.FSkillVect,this.FBackgroundVect);
         }
         if(this.FBattleInfo.PlayerInfo_2.KnifeOfKillSoulID != 0)
         {
            _loc10_ = this.FKnifeExpand.GetDatebaseByIdentifier(this.FBattleInfo.PlayerInfo_2.KnifeOfKillSoulID) as TKnifeExpand;
            _loc7_ = Json.decode(_loc10_.Effects);
            this.CheckEffect(_loc10_.SkillID,_loc7_[_loc10_.SkillID],this.FSkillVect,this.FBackgroundVect);
         }
         this.ProcessorLoadResources();
      }
      
      protected function CheckUseSkill() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:Vector.<TTurnInfo> = null;
         var _loc4_:Vector.<TActiveInfo> = null;
         var _loc5_:uint = 0;
         var _loc6_:TSkillConfig = null;
         var _loc7_:uint = 0;
         if(this.FSkillConfigBins == null)
         {
            this.FSkillConfigBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_SkillConfig);
         }
         _loc3_ = this.FBattleInfo.TurnInfos;
         _loc1_ = 0;
         while(_loc1_ < _loc3_.length)
         {
            _loc4_ = _loc3_[_loc1_].ActiveInfos;
            _loc2_ = 0;
            while(_loc2_ < _loc4_.length)
            {
               _loc5_ = uint(_loc4_[_loc2_].SkillEffectId);
               _loc6_ = this.FSkillConfigBins.GetDatebaseByIdentifier(_loc5_) as TSkillConfig;
               if(_loc6_ != null)
               {
                  _loc7_ = _loc6_.SkillId;
                  if(this.FUseSkillList.indexOf(_loc7_) < 0)
                  {
                     this.FUseSkillList.push(_loc7_);
                  }
               }
               _loc2_++;
            }
            _loc1_++;
         }
      }
      
      protected function CheckResources() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Vector.<TRoleBattleInfo> = null;
         var _loc3_:TRoleBattleInfo = null;
         var _loc4_:TBaseHero = null;
         var _loc5_:TEnemy = null;
         var _loc6_:Object = null;
         var _loc7_:Object = null;
         var _loc8_:TRoleModel = null;
         var _loc9_:Boolean = false;
         var _loc10_:uint = 0;
         var _loc11_:uint = 0;
         var _loc12_:TSkillConfig = null;
         var _loc13_:TKnifeExpand = null;
         if(this.FRoleModelBins == null)
         {
            this.FRoleModelBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_RoleModel);
         }
         if(this.FEnemyBins == null)
         {
            this.FEnemyBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_Enemy);
         }
         if(this.FBaseHeroBins == null)
         {
            this.FBaseHeroBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_BaseHero);
         }
         if(this.FSkillConfigBins == null)
         {
            this.FSkillConfigBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_SkillConfig);
         }
         if(this.FKnifeExpand == null)
         {
            this.FKnifeExpand = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_KnifeExpand);
         }
         _loc2_ = this.FBattleInfo.PlayerInfo_1.RoleBattleInfos;
         _loc1_ = 0;
         while(_loc1_ < _loc2_.length)
         {
            _loc9_ = true;
            _loc3_ = _loc2_[_loc1_];
            _loc8_ = this.FRoleModelBins.GetDatebaseByIdentifier(_loc3_.RoleId) as TRoleModel;
            this.FModelVect.push(_loc8_.Model);
            if(_loc3_.RoleId > HEROENEMY_DividingID)
            {
               _loc5_ = this.FEnemyBins.GetDatebaseByIdentifier(_loc3_.RoleId) as TEnemy;
               _loc7_ = Json.decode(_loc5_.Effects);
               _loc10_ = uint(_loc5_.Normal);
               _loc11_ = uint(_loc5_.Skill);
               if(!_loc5_.IsBoss)
               {
                  _loc9_ = false;
               }
            }
            else
            {
               _loc4_ = this.FBaseHeroBins.GetDatebaseByIdentifier(_loc3_.RoleId) as TBaseHero;
               _loc7_ = Json.decode(_loc4_.AttackEffect);
               _loc10_ = uint(_loc4_.NormalAttack);
               _loc11_ = uint(_loc3_.SkillId);
            }
            _loc12_ = this.FSkillConfigBins.GetDatebaseByIdentifier(_loc11_) as TSkillConfig;
            _loc11_ = _loc12_.SkillId;
            if(_loc9_)
            {
               if(this.FLargeVect.indexOf(_loc8_.RoleHead) < 0)
               {
                  this.FLargeVect.push(_loc8_.RoleHead);
               }
            }
            _loc6_ = _loc7_[_loc10_];
            if(_loc6_ == null)
            {
               if(this.FOnErrorText != null)
               {
                  this.FOnErrorText(this,"HeroId: " + _loc3_.RoleId + "\nAttackId: " + _loc10_ + "  not exist!!!");
               }
               return;
            }
            this.CheckEffect(0,_loc7_[_loc10_],this.FSkillVect,this.FBackgroundVect);
            _loc6_ = _loc7_[_loc11_];
            if(_loc6_ == null)
            {
               if(this.FOnErrorText != null)
               {
                  this.FOnErrorText(this,"HeroId: " + _loc3_.RoleId + "\nSkillId: " + _loc11_ + "  not exist!!!");
               }
               return;
            }
            this.CheckEffect(_loc11_,_loc7_[_loc11_],this.FSkillVect,this.FBackgroundVect);
            _loc1_++;
         }
         _loc2_ = this.FBattleInfo.PlayerInfo_2.RoleBattleInfos;
         _loc1_ = 0;
         while(_loc1_ < _loc2_.length)
         {
            _loc9_ = true;
            _loc3_ = _loc2_[_loc1_];
            _loc8_ = this.FRoleModelBins.GetDatebaseByIdentifier(_loc3_.RoleId) as TRoleModel;
            this.FModelVect.push(_loc8_.Model);
            if(_loc3_.RoleId > HEROENEMY_DividingID)
            {
               _loc5_ = this.FEnemyBins.GetDatebaseByIdentifier(_loc3_.RoleId) as TEnemy;
               _loc7_ = Json.decode(_loc5_.Effects);
               _loc10_ = uint(_loc5_.Normal);
               _loc11_ = uint(_loc5_.Skill);
               if(!_loc5_.IsBoss)
               {
                  _loc9_ = false;
               }
            }
            else
            {
               _loc4_ = this.FBaseHeroBins.GetDatebaseByIdentifier(_loc3_.RoleId) as TBaseHero;
               _loc7_ = Json.decode(_loc4_.AttackEffect);
               _loc10_ = uint(_loc4_.NormalAttack);
               _loc11_ = uint(_loc3_.SkillId);
            }
            _loc12_ = this.FSkillConfigBins.GetDatebaseByIdentifier(_loc11_) as TSkillConfig;
            _loc11_ = _loc12_.SkillId;
            if(_loc9_)
            {
               if(this.FLargeVect.indexOf(_loc8_.RoleHead) < 0)
               {
                  this.FLargeVect.push(_loc8_.RoleHead);
               }
            }
            _loc6_ = _loc7_[_loc10_];
            if(_loc6_ == null)
            {
               if(this.FOnErrorText != null)
               {
                  this.FOnErrorText(this,"HeroId: " + _loc3_.RoleId + "\nAttackId: " + _loc10_ + "  not exist!!!");
               }
               return;
            }
            this.CheckEffect(0,_loc7_[_loc10_],this.FSkillVect,this.FBackgroundVect);
            _loc6_ = _loc7_[_loc11_];
            if(_loc6_ == null)
            {
               if(this.FOnErrorText != null)
               {
                  this.FOnErrorText(this,"HeroId: " + _loc3_.RoleId + "\nSkillId: " + _loc11_ + "  not exist!!!");
               }
               return;
            }
            this.CheckEffect(_loc11_,_loc7_[_loc11_],this.FSkillVect,this.FBackgroundVect);
            _loc1_++;
         }
         if(this.FBattleInfo.PlayerInfo_1.KnifeOfKillSoulID != 0)
         {
            _loc13_ = this.FKnifeExpand.GetDatebaseByIdentifier(this.FBattleInfo.PlayerInfo_1.KnifeOfKillSoulID) as TKnifeExpand;
            _loc7_ = Json.decode(_loc13_.Effects);
            this.CheckEffect(_loc13_.SkillID,_loc7_[_loc13_.SkillID],this.FSkillVect,this.FBackgroundVect);
         }
         if(this.FBattleInfo.PlayerInfo_2.KnifeOfKillSoulID != 0)
         {
            _loc13_ = this.FKnifeExpand.GetDatebaseByIdentifier(this.FBattleInfo.PlayerInfo_2.KnifeOfKillSoulID) as TKnifeExpand;
            _loc7_ = Json.decode(_loc13_.Effects);
            this.CheckEffect(_loc13_.SkillID,_loc7_[_loc13_.SkillID],this.FSkillVect,this.FBackgroundVect);
         }
         this.ProcessorStartBattleLoad();
         this.ProcessorLoadResources();
         this.ProcessorLoadBattleBackgroundResources(this.FEnterType);
         this.FUseSkillList.length = 0;
      }
      
      protected function ProcessorStartBattleLoad() : void
      {
         if(!this.FIsReplay || this.FEnterType == ENTER_TYPE_VIDEO)
         {
            // Mount the native battle resource screen before requesting combat assets.
            // On the first fight the stage has not been constructed yet.
            addChild(this.FProcessorBattleLoading);
            this.FProcessorBattleLoading.StartPlayerLoad();
            this.FProcessorBattleLoading.Visible = true;
         }
         else
         {
            this.ProcessorOnLoadingCompleted(null);
            this.ProcessorOnCloseLoad(null);
         }
      }
      
      protected function ProcessorLoadResources() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Vector.<uint> = null;
         var _loc3_:String = null;
         if(!this.FIsInitialization)
         {
            SResourcesCore.TexturesSwfBattle.LoadPrimary(CONST_BATTLE.RESOURCE_Battle);
         }
         _loc2_ = CONST_BATTLE.COMMON_EffectVect;
         SResourcesCore.TexturesSkill.LoadPrimary(CONST_BATTLE.Public_Effect_AngerRing);
         SResourcesCore.TexturesSkill.LoadPrimary(CONST_BATTLE.BattlePetEffectId);
         _loc1_ = 0;
         while(_loc1_ < _loc2_.length)
         {
            SResourcesCore.TexturesSkill.LoadPrimary(_loc2_[_loc1_]);
            _loc1_++;
         }
         if(this.FEnterType == ENTER_TYPE_NODAL && this.FEnterId == 15101001 && SLogicsCore.Nodal.GetMissionStarByID(15101001) <= 0)
         {
            _loc1_ = 0;
            while(_loc1_ < this.FModelVect.length)
            {
               _loc3_ = "0x" + this.FModelVect[_loc1_].toString(16);
               SResourcesCore.TexturesModel.LoadPrimary(uint(_loc3_ + CONST_BATTLE.RESOURCE_ActiveType_FightIdle));
               SResourcesCore.TexturesModel.LoadPrimary(uint(_loc3_ + CONST_BATTLE.RESOURCE_ActiveType_Attack));
               SResourcesCore.TexturesModel.LoadPrimary(uint(_loc3_ + CONST_BATTLE.RESOURCE_ActiveType_Skill));
               SResourcesCore.TexturesModel.LoadPrimary(uint(_loc3_ + CONST_BATTLE.RESOURCE_ActiveType_Attacked));
               SResourcesCore.TexturesModel.LoadPrimary(uint(_loc3_ + CONST_BATTLE.RESOURCE_ActiveType_Run));
               _loc1_++;
            }
            _loc1_ = 0;
            while(_loc1_ < this.FLargeVect.length)
            {
               SResourcesCore.TexturesLargeIcon.LoadPrimary(this.FLargeVect[_loc1_]);
               _loc1_++;
            }
            _loc1_ = 0;
            while(_loc1_ < this.FSkillVect.length)
            {
               SResourcesCore.TexturesSkill.LoadPrimary(this.FSkillVect[_loc1_]);
               _loc1_++;
            }
            _loc1_ = 0;
            while(_loc1_ < this.FBackgroundVect.length)
            {
               SResourcesCore.TexturesBackgroundIcon.LoadPrimary(this.FBackgroundVect[_loc1_]);
               _loc1_++;
            }
         }
         else
         {
            if(this.FEnterType == ENTER_TYPE_CITYDEFEND || this.FEnterType == ENTER_TYPE_REPLAY || this.FEnterType == ENTER_TYPE_VIDEO)
            {
               SResourcesCore.TexturesSkill.LoadSecondary(CONST_BATTLE.Effect_CITYDEFEND_BOOM);
            }
            _loc1_ = 0;
            while(_loc1_ < this.FModelVect.length)
            {
               _loc3_ = "0x" + this.FModelVect[_loc1_].toString(16);
               SResourcesCore.TexturesModel.LoadPrimary(uint(_loc3_ + CONST_BATTLE.RESOURCE_ActiveType_FightIdle));
               _loc1_++;
            }
            _loc1_ = 0;
            while(_loc1_ < this.FLargeVect.length)
            {
               SResourcesCore.TexturesLargeIcon.LoadSecondary(this.FLargeVect[_loc1_]);
               _loc1_++;
            }
            _loc1_ = 0;
            while(_loc1_ < this.FSkillVect.length)
            {
               SResourcesCore.TexturesSkill.LoadPrimary(this.FSkillVect[_loc1_]);
               _loc1_++;
            }
            _loc1_ = 0;
            while(_loc1_ < this.FBackgroundVect.length)
            {
               SResourcesCore.TexturesBackgroundIcon.LoadPrimary(this.FBackgroundVect[_loc1_]);
               _loc1_++;
            }
         }
         this.Load();
      }
      
      protected function ProcessorLoadBattleBackgroundResources(param1:uint = 0) : void
      {
         var _loc2_:int = 0;
         var _loc3_:uint = 0;
         var _loc4_:TBlockPoint = null;
         var _loc5_:TSinglePointPath = null;
         var _loc6_:TTemplePoint = null;
         var _loc7_:TRaidersDailyConfig = null;
         var _loc8_:TChangeHeroPoint = null;
         switch(param1)
         {
            case ENTER_TYPE_NODAL:
               _loc4_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_BlockPoint,this.FEnterId) as TBlockPoint;
               _loc3_ = uint(_loc4_.BattleScene);
               this.FBattleBgId = _loc3_;
               break;
            case ENTER_TYPE_CAMP:
               _loc5_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_SinglePointPath,this.FEnterId) as TSinglePointPath;
               _loc3_ = uint(_loc5_.BattleScene);
               this.FBattleBgId = _loc3_;
               break;
            case ENTER_TYPE_KILLHERO:
               _loc7_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_RaidersDailyConfig,this.FEnterId) as TRaidersDailyConfig;
               _loc3_ = uint(_loc7_.PicPath);
               this.FBattleBgId = _loc3_;
               break;
            case ENTER_TYPE_SKYTOWERPVE:
            case ENTER_TYPE_SKYTOWERPVP:
               _loc6_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_TemplePoint,this.FEnterId) as TTemplePoint;
               _loc3_ = _loc6_.BattleScene;
               this.FBattleBgId = _loc3_;
               break;
            case ENTER_TYPE_ARENA:
            case ENTER_TYPE_VOIDSOULWORLD:
            case ENTER_TYPE_TREASUREMAP:
            case ENTER_TYPE_CITYDEFEND:
            case ENTER_TYPE_SLAVE:
            case ENTER_TYPE_SOULMONSTER:
            case ENTER_TYPE_SEVENKING:
            case ENTER_TYPE_REPLAY:
            case ENTER_TYPE_VIDEO:
            case ENTER_TYPE_GONGFUFIGHT:
            case ENTER_TYPE_VAINTRAVEL:
            case ENTER_TYPE_RELATEDPARTNER:
            case ENTER_TYPE_NIGHTMARETRIAL:
            case ENTER_TYPE_EXPDUPLICATE:
               _loc3_ = uint(CONST_BATTLE.BATTLE_ARENA_BackGround_ID);
               this.FBattleBgId = _loc3_;
               break;
            case ENTER_TYPE_HEROCHANGE:
               _loc8_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ChangeHeroPoint,this.FEnterId) as TChangeHeroPoint;
               _loc3_ = uint(_loc8_.BattleScene);
               this.FBattleBgId = _loc3_;
               break;
            case ENTER_TYPE_ORGSINGLE:
            case ENTER_TYPE_ORGGROUP:
               _loc3_ = uint(SLogicsCore.NewOrgData.CurrentPoint.PointInfo.BattleScene);
               this.FBattleBgId = _loc3_;
               break;
            default:
               this.FChgBattleBg.bitmapData = null;
               _loc3_ = this.FNewBgId;
         }
         if(_loc3_ != 0)
         {
            this.LoadBattleBackgroundResource(_loc3_);
            _loc2_ = this.FBackgroundVect.indexOf(_loc3_);
            if(_loc2_ < 0)
            {
               this.FBackgroundVect.push(_loc3_);
            }
         }
      }
      
      protected function ProcessorOnLoadingCompleted(param1:Object) : void
      {
         var _loc2_:int = 0;
         this.VoidTrace("loading-completed");
         this.ProcessorBattleInfo();
         switch(this.FEnterType)
         {
            case ENTER_TYPE_NODAL:
               _loc2_ = int(PLAY_SCENE_Nodal);
               this.Skip = this.FVipData.SkipBlock;
               break;
            case ENTER_TYPE_CAMP:
               _loc2_ = int(PLAY_SCENE_Campaign);
               this.Skip = this.FVipData.SkipBlock;
               break;
            case ENTER_TYPE_KILLHERO:
               _loc2_ = int(PLAY_SCENE_KillHeros);
               this.Skip = this.FVipData.SkipChargeFight;
               break;
            case ENTER_TYPE_ARENA:
               _loc2_ = int(PLAY_SCENE_Arena);
               this.Skip = this.FVipData.ArenaSkip;
               break;
            case ENTER_TYPE_VOIDSOULWORLD:
               _loc2_ = int(PLAY_SCENE_OrganizationalWar);
               this.Skip = this.FVipData.ArenaSkip;
               break;
            case ENTER_TYPE_TREASUREMAP:
               _loc2_ = int(PLAY_SCENE_TreasureMap);
               this.Skip = this.FVipData.ArenaSkip;
               break;
            case ENTER_TYPE_CITYDEFEND:
               _loc2_ = int(PLAY_SCENE_CityDefend);
               this.Skip = this.FVipData.ArenaSkip;
               break;
            case ENTER_TYPE_FIGHTPET:
               _loc2_ = int(PLAY_SCENE_FightPet);
               this.Skip = this.FVipData.ArenaSkip;
               break;
            case ENTER_TYPE_SLAVE:
               _loc2_ = int(PLAY_SCENE_Slave);
               this.Skip = this.FVipData.ArenaSkip;
               break;
            case ENTER_TYPE_SOULMONSTER:
               _loc2_ = int(PLAY_SCENE_HomeMonster);
               this.Skip = this.FVipData.ArenaSkip;
               break;
            case ENTER_TYPE_TRAITORATTACK:
               _loc2_ = int(PLAY_SCENE_TraitorAttack);
               this.Skip = this.FVipData.ArenaSkip;
               break;
            case ENTER_TYPE_SEVENKING:
               _loc2_ = int(PLAY_SCENE_TraitorAttack);
               this.Skip = this.FVipData.SkipSevenHeroFight;
               break;
            case ENTER_TYPE_SKYTOWERPVE:
            case ENTER_TYPE_SKYTOWERPVP:
               _loc2_ = int(PLAY_SCENE_SkyTower);
               this.Skip = this.FVipData.ArenaSkip;
               break;
            case ENTER_TYPE_GONGFUFIGHT:
               _loc2_ = int(PLAY_SCENE_GongFuFight);
               this.Skip = this.FVipData.ArenaSkip;
               break;
            case ENTER_TYPE_HEROCHANGE:
            case ENTER_TYPE_RELATEDPARTNER:
            case ENTER_TYPE_NIGHTMARETRIAL:
               _loc2_ = int(PLAY_SCENE_Campaign);
               this.Skip = this.FVipData.SkipBlock;
               break;
            case ENTER_TYPE_VAINTRAVEL:
               _loc2_ = int(PLAY_SCENE_Campaign);
               this.Skip = this.FVipData.ArenaSkip;
               break;
            case ENTER_TYPE_REPLAY:
            case ENTER_TYPE_VIDEO:
               this.FIsCanSkip = true;
               break;
            case ENTER_TYPE_ORGSINGLE:
            case ENTER_TYPE_ORGGROUP:
            case ENTER_TYPE_EXPDUPLICATE:
               _loc2_ = int(PLAY_SCENE_Campaign);
               this.Skip = this.FVipData.SkipBlock;
         }
         SLogicsCore.SignalPost(CONST_SIGNAL.SIGNALDESTINATION_SOUND,_loc2_,this.FEnterId,true);
         this.FBattleBg.visible = true;
         this.FChgBattleBg.visible = true;
         this.FBattleStage.Visible = true;
         this.FProcessorBattleLoading.EndPlayerLoad();
      }
      
      protected function ProcessorOnShowBattle(param1:Object) : void
      {
         this.FProcessorBattleLoading.PlayLoadedEffect();
      }
      
      protected function ProcessorOnCloseLoad(param1:Object) : void
      {
         StartPlaybackSpeed();
         this.FMC_BattleReady.visible = true;
         this.FSP_Skip.visible = true;
         this.FProcessorBattleLoading.Visible = false;
         if(this.FSP_BloodBuffer != null)
         {
            this.FSP_BloodBuffer.visible = this.FBattleInfo.PlayerInfo_1.BloodAddRate != 0;
         }
         this.FProcessorBattleLoading.Reset();
         if(this.FOnBattleShowChat != null)
         {
            this.FOnBattleShowChat(this);
         }
         this.FTickStartBattle = STimingCore.TickCount;
         FAffairGenerator.Generate(AFFAIRID_TimingWaitStartBattle);
      }
      
      protected function CriticalUI() : void
      {
         TEffectControl.MakeCritical(this);
      }
      
      override public function ProcessorsResize() : void
      {
         UpdatePlaybackButton();
         var _loc1_:uint = 0;
         if(this.FSP_Skip != null)
         {
            _loc1_ = FUICore.StageHeight;
            this.FSP_Skip.y = _loc1_ - 18 - this.FSP_Skip.height / 2;
            if(this.FSP_BloodBuffer != null)
            {
               this.FSP_BloodBuffer.y = this.FSP_Skip.y - 10 - this.FSP_BloodBuffer.height / 2;
            }
         }
      }
      
      protected function ProcessorBattleInfo() : void
      {
         if(this.FBattleStage == null)
         {
            this.FBattleStage = new TBattleStage(this);
            this.FBattleStage.CriticalUI = this.CriticalUI;
            this.FBattleStage.OnChangeBg = this.ProcessorOnChangeBg;
            this.FBattleStage.OnAntiColorBlackWhiteBg = this.OnAntiColorBlackWhiteBg;
            this.FBattleStage.OnRedAntiColorBg = this.OnRedAntiColor;
            this.FBattleStage.OnEndBattle = this.ProcessorOnBattleEnd;
            this.FBattleStage.HintOnMove = SUtilityOverLayer.UIComponentsHintOnOver;
            this.FBattleStage.HintOnOut = SUtilityOverLayer.UIComponentsHintOnOut;
            this.FBattleStage.KnifeOfKillSoulOnMove = this.UIComponentsKnifeOfKillSoulOnMove;
            this.FBattleStage.KnifeOfKillSoulOnOut = this.UIComponentsKnifeOfKillSoulOnOut;
            addChild(this.FBattleStage);
            addChild(this.FProcessorWindowWin);
            addChild(this.FProcessorWindowWinOrg);
            addChild(this.FProcessorWindowLost);
            addChild(this.FProcessorWindowReward);
            addChild(this.FProcessorWindowStatistics);
            this.FMC_BattleReady = TUtilityReflection.CreateDisplayObjectInstance(CONST_BATTLE.RESOURCE_Link_MC_BattleReady) as MovieClip;
            addChild(this.FMC_BattleReady);
            this.FMC_BattleReady.mouseChildren = false;
            this.FMC_BattleReady.mouseEnabled = false;
            this.FMC_BattleReady.visible = false;
            this.FMC_BattleReady.x = 0;
            this.FMC_BattleReady.y = (CONST_COMMON.STAGE_Height - SIZE_HEIGHT_BattleReady) / 2;
            addChild(this.FProcessorBattleLoading);
         }
         this.VoidTrace("stage-created");
         this.FBattleStage.CreditCommandList(this.FBattleInfo,this.FEnterType);
         this.VoidTrace("stage-credited");
      }
      
      protected function ProcessorOnBattleReplay(param1:Object) : void
      {
         if(this.FBattleInfo == null)
         {
            return;
         }
         this.FIsReplay = true;
         this.FBattleStage.Reset();
         TEffectControl.RemoveAllEffect();
         TEffectControl.RemoveAllSpecialChainEffect();
         TEffectControl.Reset();
         this.FBattleInfo.FillData();
         this.CheckUseSkill();
         this.CheckResources();
      }
      
      protected function ProcessorOnBattleStatistics(param1:Object) : void
      {
         var _loc2_:TPacket = null;
         var _loc3_:ByteArray = null;
         if(this.FEnterType == ENTER_TYPE_RELATEDPARTNER || this.FEnterType == ENTER_TYPE_NIGHTMARETRIAL)
         {
            _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_BattleStatistics);
            _loc3_ = _loc2_.Data;
            SNetworkCore.Transceiver.PacketTransmit(_loc2_);
         }
      }
      
      protected function ProcessorOnChangeBg(param1:Object, param2:uint) : void
      {
         if(param2 == 0)
         {
            TweenUtil.to(this.FChgBattleBg,300,{"alpha":0});
            TweenUtil.to(this.FBattleBg,300,{"alpha":1});
         }
         else
         {
            TweenUtil.to(this.FChgBattleBg,300,{"alpha":1});
            TweenUtil.to(this.FBattleBg,300,{"alpha":0});
         }
         this.FNewBgId = param2;
         this.ProcessorLoadBattleBackgroundResources();
      }
      
      protected function OnAntiColorBlackWhiteBg(param1:Object, param2:Boolean) : void
      {
         if(param2)
         {
            this.FBattleBg.filters = [TUtilityFilter.AntiColorFilters,TUtilityFilter.rBlackFilters];
         }
         else
         {
            this.FBattleBg.filters = [];
         }
      }
      
      protected function OnRedAntiColor(param1:Object, param2:Boolean) : void
      {
         if(param2)
         {
            this.FBattleBg.filters = [TUtilityFilter.rBlackFilters,TUtilityFilter.RedAntiColorFilters];
         }
         else
         {
            this.FBattleBg.filters = [];
         }
      }
      
      protected function ProcessorOnBattleEnd(param1:Object) : void
      {
         StopPlaybackSpeed();
         this.FSP_Skip.visible = false;
         if(this.FIsWin)
         {
            if(this.FReward.ItemIDs.length <= 0)
            {
               this.FProcessorWindowReward.Visible = true;
               this.FProcessorWindowReward.SetWindow(this.FReward,true,this.FEnterType != 0,this.FEnterType != 0,this.FEnterType,FAutoCloseBattle);
               if(this.FEnterType != ENTER_TYPE_REPLAY && this.FEnterType != ENTER_TYPE_VIDEO)
               {
                  SLogicsCore.SinalPostFreshGuide(CONST_FRESHGUIDE.EVENTID_PickUpViewOpen);
               }
               if(this.FEnterType == ENTER_TYPE_RELATEDPARTNER || this.FEnterType == ENTER_TYPE_NIGHTMARETRIAL)
               {
                  this.FProcessorWindowReward.StatisticsBtnEnabled = true;
               }
               else
               {
                  this.FProcessorWindowReward.StatisticsBtnEnabled = false;
               }
            }
            else if(this.FEnterType == ENTER_TYPE_ORGGROUP)
            {
               this.FProcessorWindowWinOrg.Visible = true;
               this.FProcessorWindowWinOrg.SetWindow(this.FReward,this.FEnterType != 0,this.FEnterType != 0);
            }
            else
            {
               this.FProcessorWindowWin.Visible = true;
               this.FProcessorWindowWin.SetWindow(this.FReward,this.FEnterType != 0,this.FEnterType != 0,FAutoCloseBattle);
               if(this.FEnterType == ENTER_TYPE_RELATEDPARTNER || this.FEnterType == ENTER_TYPE_NIGHTMARETRIAL)
               {
                  this.FProcessorWindowWin.StatisticsBtnEnabled = true;
               }
               else
               {
                  this.FProcessorWindowWin.StatisticsBtnEnabled = false;
               }
            }
         }
         else if(this.FReward.Items.length > 0)
         {
            this.FProcessorWindowReward.Visible = true;
            this.FProcessorWindowReward.SetWindow(this.FReward,false,this.FEnterType != 0,this.FEnterType != 0,this.FEnterType,FAutoCloseBattle);
            if(this.FEnterType == ENTER_TYPE_RELATEDPARTNER || this.FEnterType == ENTER_TYPE_NIGHTMARETRIAL)
            {
               this.FProcessorWindowReward.StatisticsBtnEnabled = true;
            }
            else
            {
               this.FProcessorWindowReward.StatisticsBtnEnabled = false;
            }
         }
         else
         {
            this.FProcessorWindowLost.Visible = true;
            this.FProcessorWindowLost.SetWindow(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_BATTLE_02),this.FEnterType != 0,this.FEnterType != 0,FAutoCloseBattle);
            if(this.FEnterType == ENTER_TYPE_RELATEDPARTNER || this.FEnterType == ENTER_TYPE_NIGHTMARETRIAL)
            {
               this.FProcessorWindowLost.StatisticsBtnEnabled = true;
            }
            else
            {
               this.FProcessorWindowLost.StatisticsBtnEnabled = false;
            }
         }
         FAutoCloseBattle = false;
      }
      
      protected function ProcessorOnBattleTurnBack(param1:Object = null) : void
      {
         this.Reset();
         switch(this.FEnterType)
         {
            case ENTER_TYPE_NODAL:
            case ENTER_TYPE_CAMP:
            case ENTER_TYPE_KILLHERO:
            case ENTER_TYPE_ARENA:
            case ENTER_TYPE_VOIDSOULWORLD:
            case ENTER_TYPE_TREASUREMAP:
            case ENTER_TYPE_SLAVE:
            case ENTER_TYPE_SOULMONSTER:
            case ENTER_TYPE_SEVENKING:
            case ENTER_TYPE_SKYTOWERPVE:
            case ENTER_TYPE_SKYTOWERPVP:
            case ENTER_TYPE_GONGFUFIGHT:
            case ENTER_TYPE_HEROCHANGE:
            case ENTER_TYPE_ORGSINGLE:
            case ENTER_TYPE_ORGGROUP:
            case ENTER_TYPE_RELATEDPARTNER:
            case ENTER_TYPE_NIGHTMARETRIAL:
            case ENTER_TYPE_EXPDUPLICATE:
               this.ProcessorUnLoadResources();
               this.ProcessorUnLoadModelResources();
               this.ProcessorUnLoadModelRunResources();
               this.ProcessorUnLoadSkillResources();
               break;
            case ENTER_TYPE_CITYDEFEND:
               this.ProcessorUnLoadResources();
               this.ProcessorUnLoadModelResources();
               this.ProcessorUnLoadSkillResources();
               break;
            default:
               this.ProcessorUnLoadResources();
         }
         if(this.FOnBattleReturn != null)
         {
            this.FOnBattleReturn(this,this.FEnterType,this.FEnterId,this.FIsWin);
         }
      }
      
      protected function ButtonSkipOnClick(param1:Object, param2:MouseEvent = null) : void
      {
         StopPlaybackSpeed();
         this.FBattleStage.ProcessorBattleSkip();
         if(this.FMC_BattleReady.isPlaying)
         {
            this.FMC_BattleReady.gotoAndStop(FRMAE_INDEX_START);
            this.FMC_BattleReady.stop();
            this.FMC_BattleReady.visible = false;
         }
         SSoundPlayer.Stop();
         this.FSP_Skip.visible = false;
      }
      
      protected function ButtonSkipOnRoll(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:String = null;
         var _loc4_:uint = 0;
         if(param2.type == MouseEvent.MOUSE_MOVE)
         {
            if(this.FBT_Skip.Enabled || this.FIsCanSkip)
            {
               return;
            }
            _loc3_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.COMMON_OPENVIPTIP);
            switch(this.FEnterType)
            {
               case ENTER_TYPE_NODAL:
                  _loc4_ = uint(this.FVipData.VipOpenLevel_SkipBlock);
                  break;
               case ENTER_TYPE_CAMP:
                  _loc4_ = uint(this.FVipData.VipOpenLevel_SkipBlock);
                  break;
               case ENTER_TYPE_KILLHERO:
                  _loc4_ = uint(this.FVipData.VipOpenLevel_SkipChargeFight);
                  break;
               case ENTER_TYPE_ARENA:
                  _loc4_ = uint(this.FVipData.VipOpenLevel_ArenaSkip);
                  break;
               case ENTER_TYPE_TREASUREMAP:
                  _loc4_ = uint(this.FVipData.VipOpenLevel_ArenaSkip);
                  break;
               case ENTER_TYPE_TRAITORATTACK:
                  _loc4_ = uint(this.FVipData.VipOpenLevel_ArenaSkip);
                  break;
               case ENTER_TYPE_SLAVE:
                  _loc4_ = uint(this.FVipData.VipOpenLevel_ArenaSkip);
                  break;
               case ENTER_TYPE_SOULMONSTER:
                  _loc4_ = uint(this.FVipData.VipOpenLevel_ArenaSkip);
                  break;
               case ENTER_TYPE_SEVENKING:
                  _loc4_ = uint(this.FVipData.VipOpenLevel_SkipSevenHeroFight);
                  break;
               case ENTER_TYPE_SKYTOWERPVE:
               case ENTER_TYPE_SKYTOWERPVP:
                  _loc4_ = uint(this.FVipData.VipOpenLevel_ArenaSkip);
                  break;
               case ENTER_TYPE_GONGFUFIGHT:
                  _loc4_ = uint(this.FVipData.VipOpenLevel_ArenaSkip);
                  break;
               case ENTER_TYPE_HEROCHANGE:
               case ENTER_TYPE_RELATEDPARTNER:
               case ENTER_TYPE_NIGHTMARETRIAL:
                  _loc4_ = uint(this.FVipData.VipOpenLevel_SkipBlock);
                  break;
               case ENTER_TYPE_VAINTRAVEL:
                  _loc4_ = uint(this.FVipData.VipOpenLevel_SkipBlock);
                  break;
               case ENTER_TYPE_ORGSINGLE:
                  _loc4_ = uint(this.FVipData.VipOpenLevel_SkipBlock);
                  break;
               case ENTER_TYPE_ORGGROUP:
               case ENTER_TYPE_REPLAY:
               case ENTER_TYPE_VIDEO:
            }
            _loc3_ = TUtilityString.Format(_loc3_,_loc4_);
            this.FSkipHint.Caption = _loc3_;
            SUtilityOverLayer.UIComponentsHintOnOver(this,this.FSkipHint);
         }
         else if(param2.type == MouseEvent.MOUSE_OUT)
         {
            SUtilityOverLayer.UIComponentsHintOnOut(this,this.FSkipHint);
         }
      }
      
      protected function BloodBufferOnMouseMove(param1:MouseEvent) : void
      {
         this.FSkipHint.Caption = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_BATTLE_14),this.FBattleInfo.PlayerInfo_1.BloodAddRate);
         SUtilityOverLayer.UIComponentsHintOnOver(this,this.FSkipHint);
      }
      
      protected function BloodBufferOnMouseOut(param1:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOut(this,this.FSkipHint);
      }
      
      protected function UIComponentsKnifeOfKillSoulOnMove(param1:Object, param2:Object) : void
      {
         var _loc3_:TKnifeOfKillSoulData = null;
         if(param2 != null)
         {
            _loc3_ = param2 as TKnifeOfKillSoulData;
            this.FKnifeOfKillSoulInforTip.KnifeData = _loc3_;
            this.FKnifeOfKillSoulInforTip.Visible = true;
         }
      }
      
      protected function UIComponentsKnifeOfKillSoulOnOut(param1:Object) : void
      {
         if(this.FKnifeOfKillSoulInforTip.Visible)
         {
            this.FKnifeOfKillSoulInforTip.Visible = false;
         }
      }
      
      override public function set Visible(param1:Boolean) : void
      {
         if(!param1)
         {
            StopPlaybackSpeed();
         }
         super.Visible = param1;
         if(this.parent != null)
         {
            if(param1 && this.FEnterType == ENTER_TYPE_VOIDSOULWORLD)
            {
               if(this.FVoidPreviousDepth < 0)
               {
                  this.FVoidPreviousDepth = this.parent.getChildIndex(this);
               }
               this.parent.setChildIndex(this,this.parent.numChildren - 1);
            }
            else if(!param1 && this.FVoidPreviousDepth >= 0)
            {
               this.parent.setChildIndex(this,Math.min(this.FVoidPreviousDepth,this.parent.numChildren - 1));
               this.FVoidPreviousDepth = -1;
            }
         }
         if(this.FProcessorBattleLoading)
         {
            this.FProcessorBattleLoading.Visible = param1;
         }
      }
      
      public function get Active() : Boolean
      {
         return this.Visible;
      }
      
      public function get Loading() : Boolean
      {
         var _loc1_:Boolean = false;
         _loc1_ = false;
         if(this.FProcessorBattleLoading != null)
         {
            _loc1_ = this.FProcessorBattleLoading.StatusLoading;
         }
         return _loc1_;
      }
      
      public function get OnBattleShowChat() : Function
      {
         return this.FOnBattleShowChat;
      }
      
      public function set OnBattleShowChat(param1:Function) : void
      {
         this.FOnBattleShowChat = param1;
      }
      
      public function get OnBattleReturn() : Function
      {
         return this.FOnBattleReturn;
      }
      
      public function set OnBattleReturn(param1:Function) : void
      {
         this.FOnBattleReturn = param1;
      }
      
      public function get OnCheckPlot() : Function
      {
         return this.FOnCheckPlot;
      }
      
      public function set OnCheckPlot(param1:Function) : void
      {
         this.FOnCheckPlot = param1;
      }
      
      public function get OnErrorText() : Function
      {
         return this.FOnErrorText;
      }
      
      public function set OnErrorText(param1:Function) : void
      {
         this.FOnErrorText = param1;
      }
      
      public function get IsReplay() : Boolean
      {
         return this.FIsReplay;
      }
      
      public function get Skip() : Boolean
      {
         return this.FIsCanSkip;
      }
      
      public function set Skip(param1:Boolean) : void
      {
         if(this.FIsCanSkip != param1)
         {
            this.FIsCanSkip = param1;
         }
      }
      
      public function SetStatusType(param1:int, param2:int) : void
      {
         if(param1 == ENTER_TYPE_VOIDSOULWORLD)
         {
            TBattleHandle.IsInBattle = false;
         }
         this.FEnterType = param1;
         this.FEnterId = param2;
      }
      
      public function SetBattlePacket(param1:Object, param2:TPacket) : void
      {
         var _loc3_:ByteArray = null;
         var _loc4_:ByteArray = null;
         this.PacketPerform_SC_SingleBattleResult(param2);
         _loc3_ = param2.Data;
         _loc4_ = new ByteArray();
         _loc3_.readBytes(_loc4_,0,_loc3_.length - _loc3_.position);
         this.FReportData = _loc4_;
         this.FUnstreamizerBattleRepot.Unstreamize(this.FReportData,this.FBattleInfo,null);
         this.FIsReplay = false;
         this.CheckUseSkill();
         this.CheckResources();
         this.FProcessorWindowWin.Visible = false;
         this.FProcessorWindowWinOrg.Visible = false;
         this.FProcessorWindowLost.Visible = false;
         this.FProcessorWindowReward.Visible = false;
      }
      
      public function Reset() : void
      {
         StopPlaybackSpeed();
         this.FBattleBgId = 0;
         this.FNewBgId = 0;
         this.FBattleStage.Reset();
         this.FBattleBg.filters = [];
         if(this.FBattleBg.bitmapData != null)
         {
            this.FBattleBg.bitmapData = null;
         }
         if(this.FChgBattleBg.bitmapData != null)
         {
            this.FChgBattleBg.bitmapData = null;
         }
         TEffectControl.Reset();
         this.FReward.Clear();
         this.FBattleInfo.Reset();
         this.FReportType = null;
         if(this.FReportData != null)
         {
            this.FReportData.clear();
            this.FReportData = null;
         }
         this.FBT_Skip.Enabled = false;
         this.FBattleBg.visible = false;
         this.FChgBattleBg.visible = false;
         this.FBattleStage.Visible = false;
         TBattleHandle.IsInBattle = false;
      }
      
      public function ProcessorUnLoadModelResources() : void
      {
         var _loc1_:int = 0;
         var _loc2_:String = null;
         if(this.FDeketModelVect == null)
         {
            return;
         }
         if(TBattleHandle.IsInBattle)
         {
            return;
         }
         _loc1_ = 0;
         while(_loc1_ < this.FDeketModelVect.length)
         {
            _loc2_ = "0x" + this.FDeketModelVect[_loc1_].toString(16);
            SResourcesCore.TexturesModel.DeleteByIdentifier(uint(_loc2_ + CONST_BATTLE.RESOURCE_ActiveType_FightIdle),true);
            SResourcesCore.TexturesModel.DeleteByIdentifier(uint(_loc2_ + CONST_BATTLE.RESOURCE_ActiveType_Attack),true);
            SResourcesCore.TexturesModel.DeleteByIdentifier(uint(_loc2_ + CONST_BATTLE.RESOURCE_ActiveType_Skill),true);
            SResourcesCore.TexturesModel.DeleteByIdentifier(uint(_loc2_ + CONST_BATTLE.RESOURCE_ActiveType_Attacked),true);
            _loc1_++;
         }
         this.FDeketModelVect.length = 0;
      }
      
      public function ProcessorUnLoadModelRunResources() : void
      {
         var _loc1_:int = 0;
         var _loc2_:String = null;
         if(this.FDeketModelRunVect == null)
         {
            return;
         }
         if(TBattleHandle.IsInBattle)
         {
            return;
         }
         _loc1_ = 0;
         while(_loc1_ < this.FDeketModelRunVect.length)
         {
            _loc2_ = "0x" + this.FDeketModelRunVect[_loc1_].toString(16);
            SResourcesCore.TexturesModel.DeleteByIdentifier(uint(_loc2_ + CONST_BATTLE.RESOURCE_ActiveType_Run),true);
            _loc1_++;
         }
         this.FDeketModelRunVect.length = 0;
      }
      
      public function ProcessorUnLoadSkillResources() : void
      {
         var _loc1_:int = 0;
         var _loc2_:String = null;
         if(this.FDeketSkillVect == null)
         {
            return;
         }
         if(TBattleHandle.IsInBattle)
         {
            return;
         }
         _loc1_ = 0;
         while(_loc1_ < this.FDeketSkillVect.length)
         {
            SResourcesCore.TexturesSkill.DeleteByIdentifier(this.FDeketSkillVect[_loc1_],true);
            _loc1_++;
         }
         this.FDeketSkillVect.length = 0;
      }
      
      public function ProcessorUnLoadResources() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Bitmap = null;
         var _loc3_:uint = 0;
         var _loc4_:Vector.<uint> = null;
         TEffectControl.RemoveAllEffect();
         TEffectControl.RemoveAllSpecialChainEffect();
         if(this.FModelVect != null)
         {
            _loc1_ = 0;
            while(_loc1_ < this.FModelVect.length)
            {
               _loc3_ = uint(this.FModelVect[_loc1_]);
               if(this.FDeketModelVect.indexOf(_loc3_) < 0)
               {
                  this.FDeketModelVect.push(this.FModelVect[_loc1_]);
                  this.FDeketModelRunVect.push(this.FModelVect[_loc1_]);
               }
               _loc1_++;
            }
            this.FModelVect.length = 0;
         }
         if(this.FLargeVect != null)
         {
            _loc1_ = 0;
            while(_loc1_ < this.FLargeVect.length)
            {
               SResourcesCore.TexturesLargeIcon.DeleteByIdentifier(this.FLargeVect[_loc1_],true);
               _loc1_++;
            }
            this.FLargeVect.length = 0;
         }
         if(this.FSkillVect != null)
         {
            _loc1_ = 0;
            while(_loc1_ < this.FSkillVect.length)
            {
               _loc3_ = uint(this.FSkillVect[_loc1_]);
               if(this.FDeketSkillVect.indexOf(_loc3_) < 0)
               {
                  this.FDeketSkillVect.push(this.FSkillVect[_loc1_]);
               }
               _loc1_++;
            }
            this.FSkillVect.length = 0;
         }
         if(this.FBackgroundVect != null)
         {
            _loc1_ = 0;
            while(_loc1_ < this.FBackgroundVect.length)
            {
               SResourcesCore.TexturesBackgroundIcon.DeleteByIdentifier(this.FBackgroundVect[_loc1_],true);
               _loc1_++;
            }
            this.FBackgroundVect.length = 0;
         }
      }
      
      public function SetBattleBackground(param1:Object, param2:Object) : void
      {
         this.OnAntiColorBlackWhiteBg(this,false);
         if(param2 != null && param2 is BitmapData)
         {
            this.FBattleBg.bitmapData = param2 as BitmapData;
         }
      }
      
      public function SetBattleView(param1:ByteArray) : void
      {
         this.FBattleInfo = new TBattleInfo();
         this.FUnstreamizerBattleRepot.Unstreamize(param1,this.FBattleInfo,null);
         this.FIsReplay = true;
         this.CheckUseSkill();
         this.CheckResources();
      }
      
      public function SetTestId(param1:uint, param2:String, param3:uint, param4:String, param5:String) : void
      {
         var _loc6_:TRoleBattleInfo = null;
         var _loc7_:TBaseHero = null;
         var _loc8_:TTurnInfo = null;
         var _loc9_:TActiveInfo = null;
         var _loc10_:TTargetInfo = null;
         var _loc11_:TResultInfo = null;
         var _loc12_:uint = 0;
         var _loc13_:uint = 0;
         var _loc14_:TBaseHero = null;
         var _loc15_:TEnemy = null;
         var _loc16_:int = 0;
         var _loc17_:Object = null;
         var _loc18_:String = null;
         var _loc19_:* = 0;
         var _loc20_:TKnifeExpand = null;
         if(param5 != "" && param5 != "{}")
         {
            this.FBattleInfo.SetDataByStr(param5);
            this.CheckUseSkill();
            this.CheckResources();
            return;
         }
         if(param2 == "" || param2 == "{}")
         {
            _loc16_ = param1 > HEROENEMY_DividingID ? TActive.TYPE_ENEMY : TActive.TYPE_HERO;
            if(_loc16_ == TActive.TYPE_HERO)
            {
               _loc14_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_BaseHero,param1) as TBaseHero;
               if(_loc14_ == null)
               {
                  if(this.FOnErrorText != null)
                  {
                     this.FOnErrorText("Id 异常");
                  }
                  return;
               }
               _loc17_ = Json.decode(_loc14_.AttackEffect);
            }
            if(_loc16_ == TActive.TYPE_ENEMY)
            {
               _loc15_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_Enemy,param1) as TEnemy;
               if(_loc15_ == null)
               {
                  if(this.FOnErrorText != null)
                  {
                     this.FOnErrorText("Id 异常");
                  }
                  return;
               }
               _loc17_ = Json.decode(_loc15_.Effects);
            }
         }
         else
         {
            _loc17_ = Json.decode(param2);
         }
         _loc19_ = 0;
         for(_loc18_ in _loc17_)
         {
            if(++_loc19_ == 1)
            {
               _loc12_ = uint(int(_loc18_));
            }
            else if(_loc19_ == 2)
            {
               _loc13_ = uint(int(_loc18_));
            }
         }
         this.FBattleInfo.TotleTurn = 1;
         this.FBattleInfo.PlayerInfo_1.KnifeOfKillSoulID = param3;
         this.FBattleInfo.PlayerInfo_1.Camp = 0;
         _loc6_ = new TRoleBattleInfo(0);
         _loc6_.CurAnger = 50;
         _loc6_.CurHealth = 5000;
         _loc6_.TotleHealth = 5000;
         _loc6_.Pos = 6;
         _loc6_.RoleId = param1;
         _loc6_.RoleLevel = 5;
         _loc6_.SkillId = _loc13_;
         this.FBattleInfo.PlayerInfo_1.RoleBattleInfos.push(_loc6_);
         this.FBattleInfo.PlayerInfo_2.Camp = 1;
         _loc6_ = new TRoleBattleInfo(1);
         _loc6_.CurAnger = 50;
         _loc6_.CurHealth = 5000;
         _loc6_.TotleHealth = 5000;
         _loc6_.Pos = 6;
         _loc6_.RoleId = 11100002;
         _loc6_.RoleLevel = 5;
         _loc6_.SkillId = 13100114;
         this.FBattleInfo.PlayerInfo_2.RoleBattleInfos.push(_loc6_);
         _loc8_ = new TTurnInfo();
         _loc8_.ActiveCount = 3;
         _loc8_.CurTurn = 1;
         _loc9_ = new TActiveInfo(1);
         _loc9_.ActiveCamp = 0;
         _loc9_.ActivePos = 6;
         _loc9_.SkillEffectId = _loc12_;
         _loc9_.TargetCount = 2;
         _loc10_ = new TTargetInfo(1);
         _loc10_.CMD = TTargetInfo.CMD_ATTACKEX;
         _loc10_.TargetCamp = 1;
         _loc10_.TargetPos = 6;
         _loc10_.TargetStatus = CONST_BATTLE.ActiveType_Hit;
         _loc10_.ResultInfo.CMD = _loc10_.CMD;
         _loc10_.ResultInfo.HurtHp = 1234;
         _loc10_.ResultInfo.HurtAnger = 10;
         _loc10_.ResultInfo.BuffId = 0;
         _loc10_.ResultInfo.BuffTurn = 0;
         _loc9_.TargetInfos.push(_loc10_);
         _loc10_ = new TTargetInfo(2);
         _loc10_.CMD = TTargetInfo.CMD_ATTACKEX;
         _loc10_.TargetCamp = 0;
         _loc10_.TargetPos = 6;
         _loc10_.TargetStatus = CONST_BATTLE.ActiveType_Hit;
         _loc10_.ResultInfo.CMD = _loc10_.CMD;
         _loc10_.ResultInfo.HurtHp = 0;
         _loc10_.ResultInfo.HurtAnger = -50;
         _loc10_.ResultInfo.BuffId = 0;
         _loc10_.ResultInfo.BuffTurn = 0;
         _loc9_.TargetInfos.push(_loc10_);
         _loc8_.ActiveInfos.push(_loc9_);
         _loc9_ = new TActiveInfo(2);
         _loc9_.ActiveCamp = 1;
         _loc9_.ActivePos = 6;
         _loc9_.SkillEffectId = 13100113;
         _loc9_.TargetCount = 2;
         _loc10_ = new TTargetInfo(1);
         _loc10_.CMD = TTargetInfo.CMD_ATTACKEX;
         _loc10_.TargetCamp = 0;
         _loc10_.TargetPos = 6;
         _loc10_.TargetStatus = CONST_BATTLE.ActiveType_Hit;
         _loc10_.ResultInfo.CMD = _loc10_.CMD;
         _loc10_.ResultInfo.HurtHp = 90;
         _loc10_.ResultInfo.HurtAnger = 20;
         _loc10_.ResultInfo.BuffId = 0;
         _loc10_.ResultInfo.BuffTurn = 0;
         _loc9_.TargetInfos.push(_loc10_);
         _loc10_ = new TTargetInfo(2);
         _loc10_.CMD = TTargetInfo.CMD_ATTACKEX;
         _loc10_.TargetCamp = 1;
         _loc10_.TargetPos = 6;
         _loc10_.TargetStatus = CONST_BATTLE.ActiveType_Hit;
         _loc10_.ResultInfo.CMD = _loc10_.CMD;
         _loc10_.ResultInfo.HurtHp = 0;
         _loc10_.ResultInfo.HurtAnger = -50;
         _loc10_.ResultInfo.BuffId = 0;
         _loc10_.ResultInfo.BuffTurn = 0;
         _loc9_.TargetInfos.push(_loc10_);
         _loc8_.ActiveInfos.push(_loc9_);
         _loc9_ = new TActiveInfo(3);
         _loc9_.ActiveCamp = 0;
         _loc9_.ActivePos = 6;
         _loc9_.SkillEffectId = _loc13_;
         _loc9_.TargetCount = 1;
         _loc10_ = new TTargetInfo(1);
         _loc10_.CMD = TTargetInfo.CMD_ATTACKEX;
         _loc10_.TargetCamp = 1;
         _loc10_.TargetPos = 6;
         _loc10_.TargetStatus = CONST_BATTLE.ActiveType_Hit + CONST_BATTLE.ActiveType_Crit;
         _loc10_.ResultInfo.CMD = _loc10_.CMD;
         _loc10_.ResultInfo.HurtHp = 5678;
         _loc10_.ResultInfo.HurtAnger = 10;
         _loc10_.ResultInfo.BuffId = 0;
         _loc10_.ResultInfo.BuffTurn = 0;
         _loc9_.TargetInfos.push(_loc10_);
         _loc8_.ActiveInfos.push(_loc9_);
         if(param3 != 0)
         {
            _loc8_.ActiveCount = 4;
            _loc20_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_KnifeExpand,param3) as TKnifeExpand;
            _loc9_ = new TActiveInfo(4);
            _loc9_.ActiveCamp = 0;
            _loc9_.ActivePos = 100;
            _loc9_.SkillEffectId = _loc20_.SkillID;
            _loc9_.TargetCount = 1;
            _loc10_ = new TTargetInfo(1);
            _loc10_.CMD = TTargetInfo.CMD_ATTACK;
            _loc10_.TargetCamp = 1;
            _loc10_.TargetPos = 6;
            _loc10_.TargetStatus = CONST_BATTLE.ActiveType_Hit + CONST_BATTLE.ActiveType_Crit;
            _loc10_.ResultInfo.CMD = _loc10_.CMD;
            _loc10_.ResultInfo.HurtHp = 180;
            _loc10_.ResultInfo.HurtAnger = 0;
            _loc10_.ResultInfo.BuffId = 0;
            _loc10_.ResultInfo.BuffTurn = 0;
            _loc9_.TargetInfos.push(_loc10_);
            _loc8_.ActiveInfos.push(_loc9_);
         }
         this.FBattleInfo.TurnInfos.push(_loc8_);
         if(param4 != null && param4 != "{}")
         {
            _loc20_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_KnifeExpand,param3) as TKnifeExpand;
            _loc20_.Effects = param4;
         }
         if(param2 == "" || param2 == "{}")
         {
            this.CheckUseSkill();
            this.CheckResources();
         }
         else
         {
            this.TestResources(param2);
         }
      }
   }
}

