package Processors.Game.Lobby.NightmareTrial
{
   import Components.Standard.*;
   import Foundation.Common.*;
   import Foundation.Network.*;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.Campaign.*;
   import Logics.Characters.THero;
   import Logics.Characters.THeros;
   import Logics.DatebaseVO.VO.TArticle;
   import Logics.DatebaseVO.VO.TEnemy;
   import Logics.DatebaseVO.VO.TNightmareTrialPointConfig;
   import Logics.Map.*;
   import Logics.NightmareTrial.TNightmareTrialData;
   import Logics.NightmareTrial.VO.TNightmareTrialLevelVo;
   import Logics.NightmareTrial.VO.TNightmareTrialPointVo;
   import Logics.Streamization.NightmareTrial.TUnstreamizerNightmareTrial;
   import Logics.Streamization.Organization.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Common.Map.DeepSort.*;
   import Processors.Game.Lobby.Common.Map.DrawMap.*;
   import Processors.Game.Lobby.Common.Map.MapLoader.*;
   import Processors.Game.Lobby.Common.Map.MapWindowContorl.*;
   import Processors.Game.Lobby.Common.Map.MouseEventHander.*;
   import Processors.Game.Lobby.Common.Map.SceneSprite.*;
   import Processors.Game.Lobby.Common.Map.SpriteMountPoint.*;
   import Processors.Game.Lobby.MainSceneTwo.*;
   import Processors.Game.Lobby.NightmareTrial.Windows.TProcessorNightmareMapAward;
   import Processors.Game.Lobby.NightmareTrial.Windows.TViewCampReadyInfo;
   import Processors.Game.Lobby.Utilities.*;
   import Processors.Game.Lobby.WorldMapBleach.MonsterMap.*;
   import Processors.Game.Utilities.Common.*;
   import Processors.Game.Utilities.EffectTextReward.*;
   import Processors.Game.Utilities.HyperLink.*;
   import Processors.Game.Utilities.OverLayer.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   import flash.utils.*;
   
   public class TProcessorNightmareTrialMap extends TProcessorLobbyPlate
   {
      
      protected static const SIZE_WindowBarrierChoose_Width:Number = 670;
      
      protected static const SIZE_WindowBarrierChoose_Height:Number = 527;
      
      protected static const SOULSTAR_TabIndex:uint = 1;
      
      protected static const SOULSTAR_BaseID:uint = 0;
      
      protected var FMC_Title:Sprite;
      
      protected var FTF_MainTitle:TextField;
      
      protected var FMC_Back:MovieClip;
      
      protected var FProcessorWindowBarrierChoose:TViewCampReadyInfo;
      
      protected var FProcessorWindowPassAward:TProcessorNightmareMapAward;
      
      protected var FNodalModel:TNodal;
      
      protected var FBoundsWindowBarrierChoose:TBounds;
      
      protected var FLayerMask:Sprite;
      
      protected var FMapDrawer:TDrawMapTwo;
      
      protected var FMapdataLoader:IMapLoader;
      
      protected var FScreenControler:TMapWindowControl;
      
      protected var FScreenBounds:TBounds;
      
      protected var FMapSpriteMountPoint:TMonsterMountPoint;
      
      protected var FSpriteUpdateInMap:TSpriteUpdate;
      
      protected var FScreenArean:TBounds;
      
      protected var FMapParameter:TMapParameter;
      
      protected var FDeepSort:IDeepSort;
      
      protected var FMapLoadOver:Boolean;
      
      protected var FInitialization:Boolean;
      
      protected var FHanderMonster:TMouseEventHanderMonster;
      
      protected var FMapSprites:Vector.<TSceneSpriteMoudleInMap>;
      
      protected var FPoint:Vector.<TSceneSpriteMoudleInMap>;
      
      protected var FData:TNightmareTrialData;
      
      protected var FUnstreamizerTrial:TUnstreamizerNightmareTrial;
      
      protected var FHint:THint;
      
      protected var FIsBattle:Boolean;
      
      protected var FID:int;
      
      protected var FCityID:int;
      
      protected var FNightmarePointVo:TNightmareTrialPointVo;
      
      protected var FOnSetBattleStatus:Function;
      
      protected var FOnInitBattle:Function;
      
      protected var FBattleType:int;
      
      protected var FOnShowHeroDescription:Function;
      
      public function TProcessorNightmareTrialMap(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,param2);
         this.FData = SLogicsCore.NightmareTrialData;
         this.FHint = new THint();
         this.FUnstreamizerTrial = new TUnstreamizerNightmareTrial(this.FData);
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(!this.FInitialization)
         {
            return;
         }
         this.FMapdataLoader.Update();
         if(!Visible || !this.FMapLoadOver)
         {
            return;
         }
         this.FScreenControler.Update();
         this.FSpriteUpdateInMap.Update();
         this.FMapSpriteMountPoint.Relocation(this.FSpriteUpdateInMap.SpritesCanShow);
         if(this.FProcessorWindowPassAward != null)
         {
            this.FProcessorWindowPassAward.LogicsPerform();
         }
      }
      
      override protected function ProcessorResize() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         if(!this.FInitialization || !this.Visible)
         {
            return;
         }
         _loc1_ = FUICore.StageWidth;
         _loc2_ = FUICore.StageHeight;
         this.FMapParameter.ScreenBounds.Width = _loc1_;
         this.FMapParameter.ScreenBounds.Height = _loc2_;
         this.FScreenControler.Modify();
      }
      
      override protected function PacketRegisterRoutines() : void
      {
         FPacketRoutines.Register(CONST_NETWORK.PacketPerform_SC_NightmareTrial_AttackRet,this.PacketPerform_NightmareTrialMap_AttackRet);
         FPacketRoutines.Register(CONST_NETWORK.PacketPerform_SC_NightmareTrial_SkillRet,this.PacketPerform_NightmareTrialMap_SkillInfoRet);
         FPacketRoutines.Register(CONST_NETWORK.PacketPerform_SC_NightmareTrial_UpdateRet,this.PacketPerform_NightmareTrialMap_UpdateRet);
         FPacketRoutines.Register(CONST_NETWORK.PacketPerform_SC_NightmareTrial_OneKeyRet,this.PacketPerform_NightmareTrialMap_OneKeyRet);
      }
      
      protected function PacketPerform_NightmareTrialMap_AttackRet(param1:TPacket) : void
      {
         if(this.PacketReqSuc(param1))
         {
            this.FUnstreamizerTrial.NightmareAttack_Ret(param1.Data);
            if(this.FOnSetBattleStatus != null) this.FOnSetBattleStatus(this,this.FBattleType,0);
            SLogicsCore.IsInBattle = false;
            if(this.FOnInitBattle != null)
            {
               this.FOnInitBattle(this);
            }
         }
         else
         {
            SLogicsCore.IsInBattle = false;
            this.FProcessorWindowBarrierChoose.Show(this.FNightmarePointVo,this.FData.GetNightmareTrialLevelVo(this.FID).SelectInfoVo.SkillInfoStr,this.FID);
            this.FProcessorWindowBarrierChoose.Visible = true;
         }
      }
      
      protected function PacketPerform_NightmareTrialMap_UpdateRet(param1:TPacket) : void
      {
         this.FUnstreamizerTrial.NightmarePointInfo_Ret(param1.Data);
         this.UpDatePointState();
      }
      
      protected function PacketPerform_NightmareTrialMap_OneKeyRet(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:String = null;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:TArticle = null;
         if(this.PacketReqSuc(param1))
         {
            this.FUnstreamizerTrial.NightmarePointInfo_Ret(param1.Data);
            this.UpDatePointState();
            _loc3_ = uint(param1.Data.readShort());
            _loc5_ = "";
            _loc4_ = 0;
            while(_loc4_ < _loc3_)
            {
               _loc6_ = uint(param1.Data.readShort());
               _loc7_ = param1.Data.readUnsignedInt();
               _loc8_ = param1.Data.readUnsignedInt();
               _loc2_ = CONST_COMMON.RewardIDToTemplateID(_loc6_,_loc7_);
               _loc9_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_Article,_loc2_) as TArticle;
               _loc5_ += _loc9_.Name + "*" + _loc8_ + "\n";
               _loc4_++;
            }
            if(_loc3_ != 0)
            {
               SToolReward.ShowMessage(_loc5_);
            }
            if(param1.Data.bytesAvailable >= 4) TUnstreamizerNightmareTrial.SweepRemaining[this.FID] = param1.Data.readUnsignedInt();
            this.FProcessorWindowPassAward.RefreshSweepState();

         }
      }
      
      private function UpDatePointState() : void
      {
         var _loc1_:TSceneSpriteMoudleInMapMonster = null;
         var _loc2_:Vector.<TNightmareTrialPointVo> = null;
         var _loc3_:TNightmareTrialPointVo = null;
         var _loc4_:TNightmareTrialLevelVo = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:int = 0;
         if(Visible)
         {
            _loc4_ = this.FData.GetNightmareTrialLevelVo(this.FID);
            _loc9_ = _loc4_.CityDifficultyIdVec.indexOf(this.FCityID);
            _loc2_ = _loc4_.SelectInfoVo.NightmareTrialPointVec[_loc9_];
            _loc6_ = _loc2_.length;
            _loc7_ = this.FPoint.length;
            _loc5_ = 0;
            while(_loc5_ < _loc6_)
            {
               _loc8_ = _loc7_ + _loc5_;
               _loc1_ = this.FMapSprites[_loc8_] as TSceneSpriteMoudleInMapMonster;
               _loc3_ = _loc2_[_loc5_];
               this.SetMonsterState(_loc1_,_loc3_.State);
               _loc5_++;
            }
         }
      }
      
      protected function PacketPerform_NightmareTrialMap_SkillInfoRet(param1:TPacket) : void
      {
         if(this.PacketReqSuc(param1))
         {
            this.FUnstreamizerTrial.NightmareSkill_Ret(param1.Data);
            this.ShowAttakView();
         }
      }
      
      protected function ConstructComponent() : void
      {
         this.FMapParameter = new TMapParameter();
         this.FScreenArean = new TBounds();
         this.FScreenArean.X = 0;
         this.FScreenArean.Y = 0;
         this.FScreenArean.Width = CONST_COMMON.STAGE_Width;
         this.FScreenArean.Height = CONST_COMMON.STAGE_Height;
         this.FMapParameter.ScreenBounds = this.FScreenArean;
         this.FMapDrawer = new TDrawMapTwo(this);
         this.FMapdataLoader = new TMapLoaderData();
         this.FScreenControler = new TMapWindowControlMouse(this.FMapDrawer,FUICore,this.FMapParameter,this.FMapDrawer);
         this.FMapSpriteMountPoint = new TMonsterMountPoint(this.FMapDrawer);
         this.FMapSprites = new Vector.<TSceneSpriteMoudleInMap>();
         this.FPoint = new Vector.<TSceneSpriteMoudleInMap>();
         this.FSpriteUpdateInMap = new TSpriteUpdate(this.FMapParameter);
         this.FSpriteUpdateInMap.Sprites = this.FMapSprites;
         this.FDeepSort = new TDeepSortCombineSort();
         this.FProcessorWindowPassAward = new TProcessorNightmareMapAward(this);
         this.FProcessorWindowPassAward.UIDispatch();
         this.FProcessorWindowBarrierChoose = new TViewCampReadyInfo(this);
         this.FProcessorWindowBarrierChoose.OnSetBattleStatus = this.ProcessorOnSetBattleStatus;
         this.FProcessorWindowBarrierChoose.SwitchFunction = this.ProcessorOnSwitchFunction;
         this.FProcessorWindowBarrierChoose.Load();
         this.FLayerMask = new Sprite();
         this.FLayerMask.addChild(new Bitmap(SUtilityResource.BtmDataFullScreen));
         this.FLayerMask.visible = false;
         addChild(this.FLayerMask);
         this.FNodalModel = SLogicsCore.Nodal;
         this.FBoundsWindowBarrierChoose = new TBounds();
         this.FBoundsWindowBarrierChoose.Width = SIZE_WindowBarrierChoose_Width;
         this.FBoundsWindowBarrierChoose.Height = SIZE_WindowBarrierChoose_Height;
         ComponentBoundsCenter(this.FProcessorWindowBarrierChoose,this.FBoundsWindowBarrierChoose);
         this.FBoundsWindowBarrierChoose = null;
      }
      
      protected function CreateMonsters() : void
      {
         var _loc1_:Vector.<TNightmareTrialPointVo> = null;
         var _loc2_:TNightmareTrialPointVo = null;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:TSceneSpriteMoudleInMapMonster = null;
         var _loc8_:TSceneSpriteMoudleInMapGuidePoint = null;
         var _loc9_:Array = null;
         var _loc10_:TNightmareTrialLevelVo = null;
         var _loc11_:int = 0;
         _loc10_ = this.FData.GetNightmareTrialLevelVo(this.FID);
         _loc11_ = _loc10_.CityDifficultyIdVec.indexOf(this.FCityID);
         _loc1_ = _loc10_.SelectInfoVo.NightmareTrialPointVec[_loc11_];
         _loc5_ = _loc1_.length;
         _loc3_ = 0;
         while(_loc3_ < _loc5_)
         {
            _loc7_ = SLogicsCore.PoolMap.AcquireMonster();
            _loc2_ = _loc1_[_loc3_];
            _loc7_.RoleTempleteID = _loc2_.RoleTempleteID;
            _loc7_.MouduleID = _loc2_.NightmareTrialPointInfo.RoleModel;
            _loc7_.MapCoordinate.X = _loc2_.NightmareTrialPointInfo.Coordinate.coordinate[0];
            _loc7_.MapCoordinate.Y = _loc2_.NightmareTrialPointInfo.Coordinate.coordinate[1];
            _loc7_.Name = _loc2_.NightmareTrialPointInfo.NameDesc;
            _loc7_.MapParameter = this.FMapParameter;
            _loc7_.UpdateHeadDecoration();
            this.FMapSprites.push(_loc7_);
            this.SetMonsterState(_loc7_,_loc2_.State);
            _loc9_ = _loc2_.NightmareTrialPointInfo.ToTarget;
            _loc6_ = _loc9_.length;
            _loc4_ = 0;
            while(_loc4_ < _loc6_)
            {
               _loc8_ = SLogicsCore.PoolMap.AcquireMonsterGuidePoint();
               _loc8_.MapCoordinate.X = _loc9_[_loc4_][0];
               _loc8_.MapCoordinate.Y = _loc9_[_loc4_][1];
               _loc8_.MapParameter = this.FMapParameter;
               _loc8_.gotoAndLastFrame();
               this.FPoint.push(_loc8_);
               _loc4_++;
            }
            _loc3_++;
         }
         _loc5_ = this.FPoint.length;
         _loc3_ = 0;
         while(_loc3_ < _loc5_)
         {
            this.FMapSprites.splice(0,0,this.FPoint[_loc3_]);
            _loc3_++;
         }
         this.FMapSpriteMountPoint.AddSpriteBatch(this.FMapSprites);
      }
      
      protected function OnMonsterClick(param1:TSceneSpriteMoudleInMapMonster) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Vector.<TNightmareTrialPointVo> = null;
         var _loc6_:TNightmareTrialPointVo = null;
         var _loc7_:TPacket = null;
         var _loc8_:String = null;
         var _loc9_:int = 0;
         var _loc10_:Array = null;
         _loc2_ = this.FData.GetNightmareTrialLevelVo(this.FID).CityDifficultyIdVec.indexOf(this.FCityID);
         _loc5_ = this.FData.GetNightmareTrialLevelVo(this.FID).SelectInfoVo.NightmareTrialPointVec[_loc2_];
         _loc4_ = int(_loc5_.length);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc6_ = _loc5_[_loc3_];
            if(param1.RoleTempleteID == _loc6_.RoleTempleteID)
            {
               this.FNightmarePointVo = _loc6_;
               break;
            }
            _loc3_++;
         }
         _loc10_ = this.JudageHelpHero(_loc6_.NightmareTrialPointInfo);
         if(_loc10_[0])
         {
            _loc9_ = CONST_NIGHTMARETRIAL.HeroPositionVec.indexOf(_loc6_.NightmareTrialPointInfo.HelpHeroPos);
            _loc8_ = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_NIGHTMARETRIAL.NightmareTrial_PositionConflict),_loc10_[1],TUtilityLobby.GetStringByIdentifier(CONST_NIGHTMARETRIAL.PositionDescIDVec[_loc9_]));
            SToolReward.ShowMessage(_loc8_);
            return;
         }
         _loc7_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PacketPerform_CS_NightmareTrial_SkillReq);
         _loc7_.Data.writeUnsignedInt(this.FID);
         _loc7_.Data.writeUnsignedInt(CONST_NIGHTMARETRIAL.Auto_Request);
         SNetworkCore.Transceiver.PacketTransmit(_loc7_);
      }
      
      private function JudageHelpHero(param1:TNightmareTrialPointConfig) : Array
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TEnemy = null;
         var _loc5_:THeros = null;
         var _loc6_:THero = null;
         var _loc7_:String = null;
         var _loc8_:Boolean = false;
         var _loc9_:Array = null;
         _loc9_ = new Array(2);
         if(param1.HelpHeroPos == 0)
         {
            _loc8_ = false;
            _loc9_.push(_loc8_);
            _loc7_ = "";
            _loc9_.push(_loc7_);
            return _loc9_;
         }
         _loc4_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_Enemy).GetDatebaseByIdentifier(param1.HelpHeroId) as TEnemy;
         _loc7_ = _loc4_.Name;
         _loc9_[1] = _loc7_;
         _loc5_ = SLogicsCore.Character.Heros;
         _loc3_ = _loc5_.Count;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc6_ = _loc5_.GetHeroByIndex(_loc2_);
            if(_loc6_.FightPosition == param1.HelpHeroPos)
            {
               _loc8_ = true;
               break;
            }
            _loc8_ = false;
            _loc2_++;
         }
         _loc9_[0] = _loc8_;
         return _loc9_;
      }
      
      protected function SetMonsterState(param1:TSceneSpriteMoudleInMapMonster, param2:int) : void
      {
         param1.filters = null;
         param1.MouseEventHander = null;
         param1.MonsterState = 0;
         param1.ChangeRoleMoudle(param1.MouduleID,1);
         param1.UpdateHeadDecoration();
         param1.HP_Visible = false;
         if((param2 & TNightmareTrialPointVo.EFFECT_MOUSE) != 0)
         {
            param1.MouseEventHander = this.FHanderMonster;
         }
         if((param2 & TNightmareTrialPointVo.EFFECT_GRAY) != 0)
         {
            param1.filters = [TUtilityFilter.GaryColorFiltersTwo];
         }
         if((param2 & TNightmareTrialPointVo.EFFECT_KNIFE) != 0)
         {
            param1.MouseEventHander = this.FHanderMonster;
            param1.MonsterState = CONST_WORLDMAP.MonsterState_Latest;
         }
         if((param2 & TNightmareTrialPointVo.EFFECT_DEATH) != 0)
         {
            param1.MonsterState = CONST_WORLDMAP.MonsterState_Dead;
         }
      }
      
      protected function Release() : void
      {
         if(this.FPoint != null)
         {
            this.FPoint.length = 0;
         }
         if(this.FMapSprites != null)
         {
            this.FMapSprites.forEach(this.ClearMapSprite);
            this.FMapSprites.length = 0;
         }
         if(this.FMapDrawer != null)
         {
            this.FMapDrawer.StopDraw();
         }
      }
      
      protected function ClearMapSprite(param1:TSceneSpriteMoudleInMap, param2:int, param3:Vector.<TSceneSpriteMoudleInMap>) : void
      {
         SLogicsCore.PoolMap.Release(param1);
         param1.Release();
         param1.visible = false;
      }
      
      protected function UpdateUI() : void
      {
      }
      
      protected function LoadMapDataOver(param1:TMapData) : void
      {
         this.FMapParameter.MapData = param1;
         this.FMapDrawer.ChangeMap(param1);
         this.FMapLoadOver = true;
      }
      
      protected function ProcessorOnSetBattleStatus(param1:Object, param2:uint, param3:uint) : void
      {
         if(this.FOnSetBattleStatus != null)
         {
            this.FOnSetBattleStatus(param1,param2,param3);
         }
      }
      
      protected function ProcessorOnSwitchFunction() : void
      {
      }
      
      protected function PacketReqSuc(param1:TPacket) : Boolean
      {
         var _loc2_:int = 0;
         _loc2_ = param1.Data.readInt();
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return false;
         }
         return true;
      }
      
      public function set OnSetBattleStatus(param1:Function) : void
      {
         this.FOnSetBattleStatus = param1;
      }
      
      override public function set Visible(param1:Boolean) : void
      {
         super.Visible = param1;
         this.Update();
      }
      
      public function set OnInitBattle(param1:Function) : void
      {
         this.FOnInitBattle = param1;
      }
      
      public function set BattleType(param1:int) : void
      {
         this.FBattleType = param1;
      }
      
      public function get IsBattle() : Boolean
      {
         return this.FIsBattle;
      }
      
      public function set OnShowHeroDescription(param1:Function) : void
      {
         this.FOnShowHeroDescription = param1;
      }
      
      public function UIDispatch(param1:int, param2:int) : void
      {
         this.FID = param1;
         this.FCityID = param2;
         if(this.FInitialization)
         {
            return;
         }
         this.FMC_Title = TUtilityReflection.CreateDisplayObjectInstance(CONST_CAMPAIGN.RESOURCE_ClassName_MC_MapTitle) as Sprite;
         this.addChild(this.FMC_Title);
         this.FMC_Title.x = (CONST_COMMON.STAGE_Width - this.FMC_Title.width) / 2;
         this.FMC_Title.y = 0;
         this.FMC_Title.mouseChildren = false;
         this.FMC_Title.mouseEnabled = false;
         this.FTF_MainTitle = this.FMC_Title[CONST_WORLDMAP.RESOURCE_Link_TF_Title];
         this.FTF_MainTitle.mouseEnabled = false;
         this.FTF_MainTitle.text = "";
         this.ConstructComponent();
         this.FHanderMonster = new TMouseEventHanderMonster();
         this.FHanderMonster.Callback = this.OnMonsterClick;
         this.FInitialization = true;
      }
      
      public function Update() : void
      {
         if(Visible && this.FData != null)
         {
            this.Release();
            this.FScreenControler.Modify();
            this.FMapLoadOver = false;
            this.FMapdataLoader.Load(this.FData.GetNightmareTrialLevelVo(this.FID).CityDifficlutyIconVec[this.FData.GetNightmareTrialLevelVo(this.FID).CityDifficultyIdVec.indexOf(this.FCityID)],this.LoadMapDataOver);
            this.CreateMonsters();
         }
      }
      
      override public function Mount(param1:ByteArray = null) : void
      {
         var _loc2_:int = 0;
         _loc2_ = int(CONST_MUSIC.PLAY_SCENE_Campaign);
         MusicPlayNext(CONST_SIGNAL.SIGNALDESTINATION_SOUND,_loc2_,this.FCityID,false);
         super.Mount(param1);
         this.FIsBattle = false;
      }
      
      override public function Unmount() : void
      {
         super.Unmount();
         this.Release();
      }
      
      public function ProcessorChangePosition(param1:Object) : void
      {
         if(this.FProcessorWindowBarrierChoose != null)
         {
            if(this.FProcessorWindowBarrierChoose.Visible)
            {
               this.FProcessorWindowBarrierChoose.ProcessorChangePosition();
            }
         }
      }
      
      private function ShowAttakView() : void
      {
         this.FProcessorWindowBarrierChoose.Data = this.FData;
         this.FProcessorWindowBarrierChoose.Show(this.FNightmarePointVo,this.FData.GetNightmareTrialLevelVo(this.FID).SelectInfoVo.SkillInfoStr,this.FID);
         this.FProcessorWindowBarrierChoose.Visible = true;
      }
      
      public function ShowPassAward() : void
      {
         this.FProcessorWindowPassAward.Data = this.FData;
         this.FProcessorWindowPassAward.UpdateUI(this.FID,this.FCityID);
      }
   }
}

