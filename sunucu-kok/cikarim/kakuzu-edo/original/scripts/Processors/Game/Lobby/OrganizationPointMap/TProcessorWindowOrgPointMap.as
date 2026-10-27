package Processors.Game.Lobby.OrganizationPointMap
{
   import Components.Standard.*;
   import Foundation.Common.*;
   import Foundation.Network.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.Campaign.*;
   import Logics.Map.*;
   import Logics.Organization.NewFeatures.*;
   import Logics.Organization.VO.*;
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
   import Processors.Game.Lobby.OrganizationPointMap.Component.*;
   import Processors.Game.Lobby.OrganizationPointMap.Windows.TPointMapInfoMainUI;
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
   
   public class TProcessorWindowOrgPointMap extends TProcessorLobbyPlate
   {
      
      protected static const SIZE_WindowBarrierChoose_Width:Number = 670;
      
      protected static const SIZE_WindowBarrierChoose_Height:Number = 527;
      
      protected static const SIZE_WindowAutoBattle_Width:Number = 280;
      
      protected static const SIZE_WindowAutoBattle_Height:Number = 163;
      
      protected static const SOULSTAR_TabIndex:uint = 1;
      
      protected static const SOULSTAR_BaseID:uint = 0;
      
      protected var FMC_Title:Sprite;
      
      protected var FTF_MainTitle:TextField;
      
      protected var FMC_Back:MovieClip;
      
      protected var FProcessorWindowBarrierChoose:TProcessorWindowBarrierChoose;
      
      protected var FComAutoBattleWin:TComAutoBattleWin;
      
      protected var FNodalModel:TNodal;
      
      protected var FBoundsWindowBarrierChoose:TBounds;
      
      protected var FBoundsWindowAutoBattle:TBounds;
      
      protected var FLayerMask:Sprite;
      
      protected var FPointMapInfoMainUI:TPointMapInfoMainUI;
      
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
      
      protected var FOrgCopyMapBack:TUIButton;
      
      protected var FData:TNewOrgData;
      
      protected var FUnstreamizerOrganizationNew:TUnstreamizerOrganizationNew;
      
      protected var FHint:THint;
      
      protected var FIsBattle:Boolean;
      
      protected var FOnSetBattleStatus:Function;
      
      protected var FOnInitBattle:Function;
      
      protected var FBattleType:int;
      
      public function TProcessorWindowOrgPointMap(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,param2);
         this.FData = SLogicsCore.NewOrgData;
         this.FUnstreamizerOrganizationNew = new TUnstreamizerOrganizationNew(this.FData);
         this.FHint = new THint();
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
         FPacketRoutines.Register(CONST_NETWORK.PacketPerform_OrgPointMap_SingleChallengeRet,this.PacketPerform_OrgPointMap_SingleChallengeRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_OrgPointMap_PointRefreshRet,this.PacketPerform_OrgPointMap_PointRefreshRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_OrgPointMap_AutoFightRet,this.PacketPerform_OrgPointMap_AutoFightRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_OrgPointMap_GroupChallengeRet,this.PacketPerform_OrgPointMap_GroupChallengeRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_OrgPointMap_UpDateRet,this.PacketPerform_OrgPointMap_UpDateRet);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_PointMapInfoUI_Base,CONST_NETWORK.PACKETID_SC_PointMapInfoUI_End,this.PacketPerform_ProcessorWindows);
      }
      
      protected function PacketPerform_OrgPointMap_SingleChallengeRet(param1:TPacket) : void
      {
         if(this.PacketReqSuc(param1))
         {
            if(this.FOnInitBattle != null)
            {
               this.FUnstreamizerOrganizationNew.SingleChallengeRet(param1.Data);
               this.FOnInitBattle(this);
            }
         }
      }
      
      protected function PacketPerform_OrgPointMap_PointRefreshRet(param1:TPacket) : void
      {
         if(this.PacketReqSuc(param1))
         {
            SToolReward.ShowMessage(this.FData.NewOrgSystemLanguage.GetStr5());
            this.FUnstreamizerOrganizationNew.PointRefreshRet(param1.Data);
            if(this.FProcessorWindowBarrierChoose.Visible)
            {
               this.FProcessorWindowBarrierChoose.UpDateUI();
            }
            this.OnResetPointMoveCall(this.FProcessorWindowBarrierChoose);
         }
      }
      
      protected function PacketPerform_OrgPointMap_AutoFightRet(param1:TPacket) : void
      {
         var _loc2_:String = null;
         if(this.PacketReqSuc(param1))
         {
            _loc2_ = this.FUnstreamizerOrganizationNew.AutoFightRet(param1.Data);
            if(_loc2_ != "")
            {
               EffectGenerateText(_loc2_);
            }
            if(this.FProcessorWindowBarrierChoose.Visible)
            {
               this.FProcessorWindowBarrierChoose.UpDateUI();
            }
            this.FComAutoBattleWin.Show(this.FData.GetCurrentPointMaxCount());
         }
      }
      
      protected function PacketPerform_OrgPointMap_GroupChallengeRet(param1:TPacket) : void
      {
         if(this.PacketReqSuc(param1))
         {
            if(this.FOnInitBattle != null)
            {
               this.FUnstreamizerOrganizationNew.GroupChallengeRet(param1.Data);
               this.FIsBattle = true;
               this.FOnInitBattle(this);
            }
         }
      }
      
      protected function PacketPerform_OrgPointMap_UpDateRet(param1:TPacket) : void
      {
         if(this.PacketReqSuc(param1))
         {
            this.FUnstreamizerOrganizationNew.UpDateRet(param1.Data);
            this.UpDatePointState();
         }
      }
      
      protected function PacketPerform_ProcessorWindows(param1:TPacket) : void
      {
         this.FPointMapInfoMainUI.PacketProcess(param1);
      }
      
      protected function UpDatePointState() : void
      {
         var _loc1_:TSceneSpriteMoudleInMapMonster = null;
         var _loc2_:Vector.<TPointInfoVO> = null;
         var _loc3_:TPointInfoVO = null;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         if(Visible)
         {
            _loc2_ = this.FData.CurrentCopy.PointInfoVOs;
            _loc5_ = _loc2_.length;
            _loc6_ = this.FPoint.length;
            _loc4_ = 0;
            while(_loc4_ < _loc5_)
            {
               _loc7_ = _loc6_ + _loc4_;
               _loc1_ = this.FMapSprites[_loc7_] as TSceneSpriteMoudleInMapMonster;
               _loc3_ = _loc2_[_loc4_];
               _loc1_.ChangeBlood(_loc3_.HP / TPointInfoVO.MAXHP);
               this.SetMonsterState(_loc1_,_loc3_.State);
               _loc4_++;
            }
            if(this.FProcessorWindowBarrierChoose.Visible)
            {
               if(this.FData.CurrentPoint.HP == 0)
               {
                  this.FProcessorWindowBarrierChoose.Visible = false;
               }
               else
               {
                  this.FProcessorWindowBarrierChoose.UpDateUI();
               }
            }
         }
      }
      
      protected function ConstructComponent() : void
      {
         var _loc1_:MovieClip = null;
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
         this.FProcessorWindowBarrierChoose = new TProcessorWindowBarrierChoose(this);
         this.FProcessorWindowBarrierChoose.OnChangeTeammate = this.ProcessorOnChangeTeammate;
         this.FProcessorWindowBarrierChoose.OnChangeSkill = this.ProcessorOnChangeSkill;
         this.FProcessorWindowBarrierChoose.OnAutoBattle = this.OnAutoBattleOpen;
         this.FProcessorWindowBarrierChoose.OnBattle = this.ProcessorOnBattle;
         this.FProcessorWindowBarrierChoose.OnSetBattleStatus = this.ProcessorOnSetBattleStatus;
         this.FProcessorWindowBarrierChoose.OnReset = this.ProcessorOnReset;
         this.FProcessorWindowBarrierChoose.OnResetMoveCall = this.OnResetPointMoveCall;
         this.FProcessorWindowBarrierChoose.OnResetOutCall = this.OnResetPointOutCall;
         this.FProcessorWindowBarrierChoose.OnOverLayOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FProcessorWindowBarrierChoose.OnOverLayOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FProcessorWindowBarrierChoose.HintOnOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FProcessorWindowBarrierChoose.HintOnOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FProcessorWindowBarrierChoose.OnEffectText = ProcessorsOnEffectText;
         this.FProcessorWindowBarrierChoose.Load();
         this.FPointMapInfoMainUI = new TPointMapInfoMainUI(this);
         this.FPointMapInfoMainUI.EffectGenerateTextByErrorCode = EffectGenerateTextByErrorCode;
         this.FPointMapInfoMainUI.UnstreamizerOrganizationNew = this.FUnstreamizerOrganizationNew;
         this.FPointMapInfoMainUI.UIDispatch();
         this.FLayerMask = new Sprite();
         this.FLayerMask.addChild(new Bitmap(SUtilityResource.BtmDataFullScreen));
         this.FLayerMask.visible = false;
         addChild(this.FLayerMask);
         _loc1_ = TUtilityReflection.CreateDisplayObjectInstance("MC_AutoBattleWin") as MovieClip;
         this.FComAutoBattleWin = new TComAutoBattleWin(this);
         this.FComAutoBattleWin.Visible = false;
         this.FComAutoBattleWin.UIDispatch(_loc1_);
         this.FComAutoBattleWin.OnAutoBattle = this.OnAutoBattleStart;
         this.FComAutoBattleWin.OnClickCloseCall = this.OnAutoBattleClose;
         this.FNodalModel = SLogicsCore.Nodal;
         this.FBoundsWindowBarrierChoose = new TBounds();
         this.FBoundsWindowBarrierChoose.Width = SIZE_WindowBarrierChoose_Width;
         this.FBoundsWindowBarrierChoose.Height = SIZE_WindowBarrierChoose_Height;
         ComponentBoundsCenter(this.FProcessorWindowBarrierChoose,this.FBoundsWindowBarrierChoose);
         this.FBoundsWindowBarrierChoose = null;
         this.FBoundsWindowAutoBattle = new TBounds();
         this.FBoundsWindowAutoBattle.Width = SIZE_WindowAutoBattle_Width;
         this.FBoundsWindowAutoBattle.Height = SIZE_WindowAutoBattle_Height;
         ComponentBoundsCenter(this.FComAutoBattleWin,this.FBoundsWindowAutoBattle);
         this.FBoundsWindowAutoBattle = null;
      }
      
      protected function CreateMonsters() : void
      {
         var _loc1_:Vector.<TPointInfoVO> = null;
         var _loc2_:TPointInfoVO = null;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:TSceneSpriteMoudleInMapMonster = null;
         var _loc8_:TSceneSpriteMoudleInMapGuidePoint = null;
         var _loc9_:Array = null;
         _loc1_ = this.FData.CurrentCopy.PointInfoVOs;
         _loc5_ = _loc1_.length;
         _loc3_ = 0;
         while(_loc3_ < _loc5_)
         {
            _loc7_ = SLogicsCore.PoolMap.AcquireMonster();
            _loc2_ = _loc1_[_loc3_];
            _loc7_.RoleTempleteID = _loc2_.RoleTempleteID;
            _loc7_.MouduleID = _loc2_.PointInfo.RoleModel;
            _loc7_.MapCoordinate.X = _loc2_.PointInfo.Coordinate.coordinate[0];
            _loc7_.MapCoordinate.Y = _loc2_.PointInfo.Coordinate.coordinate[1];
            _loc7_.Name = _loc2_.PointInfo.Name;
            _loc7_.MapParameter = this.FMapParameter;
            _loc7_.UpdateHeadDecoration();
            _loc7_.ChangeBlood(_loc2_.HP / TPointInfoVO.MAXHP);
            this.FMapSprites.push(_loc7_);
            this.SetMonsterState(_loc7_,_loc2_.State);
            _loc9_ = _loc2_.PointInfo.ToTarget;
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
         this.FData.SelectPoint(param1.RoleTempleteID);
         this.FProcessorWindowBarrierChoose.UpDataBarrierChoose(this,this.FNodalModel,this.FBattleType,this.FData.CurrentCopy.City.Identifier,param1.RoleTempleteID);
         this.FProcessorWindowBarrierChoose.Visible = true;
         this.FProcessorWindowBarrierChoose.Mount();
         this.FComAutoBattleWin.Visible = false;
      }
      
      protected function ProcessorOnReset() : void
      {
         var _loc1_:TPacket = null;
         var _loc2_:ByteArray = null;
         var _loc3_:String = null;
         if(!this.FData.CurrentPointAllowReset())
         {
            if(this.FData.CurrentPointReaminReset() <= 0)
            {
               _loc3_ = this.FData.NewOrgSystemLanguage.GetStr2();
            }
            else
            {
               _loc3_ = this.FData.NewOrgSystemLanguage.GetStr3();
            }
            SToolReward.ShowMessage(_loc3_);
            return;
         }
         this.FUnstreamizerOrganizationNew.PointRefreshReq();
      }
      
      protected function OnResetPointMoveCall(param1:Object) : void
      {
         this.FHint.Caption = this.FData.NewOrgSystemLanguage.GetStr4();
         SUtilityOverLayer.UIComponentsHintOnOver(param1,this.FHint);
      }
      
      protected function OnResetPointOutCall(param1:Object) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOut(param1,this.FHint);
      }
      
      protected function SetMonsterState(param1:TSceneSpriteMoudleInMapMonster, param2:int) : void
      {
         param1.filters = null;
         param1.MouseEventHander = null;
         param1.MonsterState = 0;
         param1.ChangeRoleMoudle(param1.MouduleID,1);
         param1.UpdateHeadDecoration();
         param1.HP_Visible = this.FBattleType == CONST_BATTLE.BattleType_OrgGroup;
         if((param2 & TPointInfoVO.EFFECT_MOUSE) != 0)
         {
            param1.MouseEventHander = this.FHanderMonster;
         }
         if((param2 & TPointInfoVO.EFFECT_GRAY) != 0)
         {
            param1.filters = [TUtilityFilter.GaryColorFiltersTwo];
         }
         if((param2 & TPointInfoVO.EFFECT_KNIFE) != 0)
         {
            param1.MonsterState = CONST_WORLDMAP.MonsterState_Latest;
         }
         if((param2 & TPointInfoVO.EFFECT_DEATH) != 0)
         {
            param1.MonsterState = CONST_WORLDMAP.MonsterState_Dead;
            param1.HP_Visible = false;
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
         this.FTF_MainTitle.text = this.FData.CurrentCopy.City.Name;
         this.FProcessorWindowBarrierChoose.Visible = false;
         this.FComAutoBattleWin.Visible = false;
         this.FLayerMask.visible = false;
         this.FPointMapInfoMainUI.Reset();
         if(this.FBattleType == CONST_BATTLE.BattleType_OrgGroup)
         {
            this.FPointMapInfoMainUI.UpdateRemain();
            this.FPointMapInfoMainUI.Visible = true;
         }
         else
         {
            this.FPointMapInfoMainUI.Visible = false;
         }
      }
      
      protected function LoadMapDataOver(param1:TMapData) : void
      {
         this.FMapParameter.MapData = param1;
         this.FMapDrawer.ChangeMap(param1);
         this.FMapLoadOver = true;
      }
      
      protected function ProcessorOnChangeTeammate(param1:Object) : void
      {
         SUtilityHyperLink.ShortcutHyperlink(TUtilityHyperLink.HyperLink_TacticalDeployment);
      }
      
      protected function ProcessorOnChangeSkill(param1:Object) : void
      {
         SUtilityHyperLink.ShortcutHyperlink(TUtilityHyperLink.HyperLink_Star,SOULSTAR_TabIndex,SOULSTAR_BaseID);
      }
      
      protected function OnAutoBattleOpen(param1:Object, param2:TNodalAutoMonsterInfo) : void
      {
         this.FComAutoBattleWin.Show(this.FData.GetCurrentPointMaxCount());
         this.FLayerMask.visible = true;
      }
      
      protected function OnAutoBattleStart(param1:uint) : void
      {
         if(param1 == 0)
         {
            return;
         }
         this.FUnstreamizerOrganizationNew.AutoFightReq(param1);
      }
      
      protected function OnAutoBattleClose() : void
      {
         this.FComAutoBattleWin.Visible = false;
         this.FLayerMask.visible = false;
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
         var _loc3_:String = null;
         var _loc4_:TPacket = null;
         if(this.FBattleType == CONST_BATTLE.BattleType_OrgGroup)
         {
            if(this.FData.GetCopyRemainFight(this.FData.CurrentCopy) == 0)
            {
               SToolReward.ShowMessage(this.FData.NewOrgSystemLanguage.GetStr0());
               return;
            }
            this.FUnstreamizerOrganizationNew.GroupChallengeReq();
         }
         else
         {
            if(this.FData.GetCurrentPointMaxCount() == 0)
            {
               if(this.FData.GetCurrentPointRemainFight() == 0)
               {
                  _loc3_ = this.FData.NewOrgSystemLanguage.GetStr0();
               }
               else
               {
                  _loc3_ = this.FData.NewOrgSystemLanguage.GetStr1();
               }
               SToolReward.ShowMessage(_loc3_);
               return;
            }
            this.FUnstreamizerOrganizationNew.SingleChallengeReq();
         }
         this.FProcessorWindowBarrierChoose.Visible = false;
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
      
      public function UIDispatch() : void
      {
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
            this.FMapdataLoader.Load(this.FData.CurrentCopy.City.Icon,this.LoadMapDataOver);
            this.CreateMonsters();
            this.UpdateUI();
         }
      }
      
      public function ProcessorChangePosition(param1:Object) : void
      {
         if(!Visible)
         {
            return;
         }
         if(this.FProcessorWindowBarrierChoose.Visible)
         {
            this.FProcessorWindowBarrierChoose.UpDateUI();
         }
      }
      
      public function BattleReturn(param1:int, param2:int, param3:Boolean) : void
      {
         this.FData.BattleReturn(param1,param2,param3);
         this.Update();
      }
      
      override public function Mount(param1:ByteArray = null) : void
      {
         var _loc2_:int = 0;
         _loc2_ = int(CONST_MUSIC.PLAY_SCENE_Campaign);
         MusicPlayNext(CONST_SIGNAL.SIGNALDESTINATION_SOUND,_loc2_,this.FData.CurrentCopy.City.Identifier,false);
         super.Mount(param1);
         this.FIsBattle = false;
      }
      
      override public function Unmount() : void
      {
         super.Unmount();
         this.Release();
         if(this.FBattleType == CONST_BATTLE.BattleType_OrgGroup && !this.FIsBattle)
         {
            this.FUnstreamizerOrganizationNew.QuitMapReq();
         }
      }
   }
}

