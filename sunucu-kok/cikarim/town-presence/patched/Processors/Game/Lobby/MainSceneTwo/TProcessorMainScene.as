package Processors.Game.Lobby.MainSceneTwo
{
   import Components.Controls.*;
   import Foundation.Common.*;
   import Foundation.Network.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Bins.*;
   import Foundation.Resources.Textures.*;
   import Foundation.Timing.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logging.*;
   import Logics.*;
   import Logics.Achievenment.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.Map.*;
   import Logics.Pet.TPetBase;
   import Logics.Streamization.Characters.*;
   import Processors.Game.Common.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Common.Map.DeepSort.*;
   import Processors.Game.Lobby.Common.Map.DrawMap.*;
   import Processors.Game.Lobby.Common.Map.HeadDecoration.*;
   import Processors.Game.Lobby.Common.Map.MapLoader.*;
   import Processors.Game.Lobby.Common.Map.MapWindowContorl.*;
   import Processors.Game.Lobby.Common.Map.SceneSprite.*;
   import Processors.Game.Lobby.Common.Map.SearchWay.*;
   import Processors.Game.Lobby.Common.Map.SpriteMountPoint.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.text.*;
   import flash.utils.*;
   
   public class TProcessorMainScene extends TProcessorLobbyPlate
   {
      
      protected static const BIRTH_RANDOMAREA:Vector.<int> = Vector.<int>([200,20,20,20]);
      
      protected var FMapParameter:TMapParameter;
      
      protected var FMapDrawer:TDrawMapTwo;
      
      protected var FMapdataLoader:IMapLoader;
      
      protected var FScreenControler:TMapWindowControl;
      
      protected var FMapDataLoadOver:Boolean;
      
      protected var FMapSpriteMountPoint:TSpriteMountPoint;
      
      protected var FSkySpriteMountPoint:TProcessorMountPoint;
      
      protected var FSpriteUpdate:TSpriteUpdate;
      
      protected var FDark:TDark;
      
      protected var FSearhWay:TSearchWayAStar;
      
      protected var FDeepSort:IDeepSort;
      
      protected var FNpcManager:TNpcManager;
      
      protected var FTargetNpc:TSceneSpriteMoudleInMapNpc;
      
      protected var FMainPlayerManager:TMainPlayerManager;
      
      protected var FPlayerManager:TPlayerManager;
      
      protected var FUserID:TEntity64;
      
      protected var FToolCoordinate:TCoordinate;
      
      protected var FEnvironmentManager:TEnvironmentManager;
      
      protected var FRoleEnterDoorID:int;
      
      protected var FRoleEnterCityMethod:int;
      
      protected var FInforText:TextField;
      
      protected var FCurrentMouseOverState:int;
      
      protected var FSpecialNpc:TSceneSpriteMoudleInMapNpc;
      
      protected var FTavernNpc:TSceneSpriteMoudleInMapNpc;
      
      protected var FAutoMoveToNpc:Boolean;
      
      protected var FUnityPool:Vector.<TSceneSpriteMoudleInMap>;
      
      protected var FInitialization:Boolean;
      
      protected var FOnOpenNpcDialog:Function;
      
      protected var FOnOpenWorldMap:Function;
      
      protected var FShowHeroContorlPanle:Function;
      
      protected var FHideHeroContorlPanle:Function;
      
      protected var FOnProcessorCheckPopTips:Function;
      
      protected var FOnAutoSearchWayEffect:Function;
      
      protected var FTF:TextField;
      
      public function TProcessorMainScene(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,param2);
         FResourcesState = RESOURCESSTATE_UIRequest;
      }
      
      protected function AddColorTransform() : void
      {
         this.transform.colorTransform = new ColorTransform(1.3,1.3,1.3,1,0,0,0,0);
         this.blendMode = BlendMode.ADD;
      }
      
      protected function BtnOnClick(param1:MouseEvent) : void
      {
         SResourcesCore.TexturesModel.LoadAutoSecondary(11200012,this.PicArrive);
      }
      
      protected function PicArrive(param1:Object, param2:TTexture, param3:uint) : void
      {
         TBitmapBinFile.CreateBinFileByTexture(param2,param3);
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_QUEST.RESOURCESID_QuestBadge);
         SResourcesCore.ResourceMap.LoadPrimary(10001);
         SResourcesCore.ResourceMap.LoadSecondary(10001);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         this.ConstructionComponent();
         FUICore.UIStage.addEventListener(MouseEvent.CLICK,this.HandleMouseClick);
         this.FInitialization = true;
         super.ResourcesPerform_UIDispatch();
      }
      
      protected function ConstructionComponent() : void
      {
         var _loc1_:TBounds = null;
         _loc1_ = new TBounds();
         _loc1_.X = 0;
         _loc1_.Y = 0;
         _loc1_.Width = CONST_COMMON.STAGE_Width;
         _loc1_.Height = CONST_COMMON.STAGE_Height;
         this.FMapParameter = new TMapParameter();
         this.FMapParameter.ScreenBounds = _loc1_;
         this.FUnityPool = new Vector.<TSceneSpriteMoudleInMap>();
         this.FMapDrawer = new TDrawMapTwo(this);
         this.FMapdataLoader = new TMapLoaderData();
         this.FMapSpriteMountPoint = new TMapSpriteMountPoint(this.FMapDrawer);
         this.FSkySpriteMountPoint = new TProcessorMountPoint(this.FMapDrawer);
         this.FSpriteUpdate = new TSpriteUpdate(this.FMapParameter);
         this.FSearhWay = new TSearchWayAStar();
         this.FDeepSort = new TDeepSortCombineSort();
         this.FDark = new TDark(this,this.FMapDrawer,this.FMapParameter);
         this.FDark.Load();
         this.FDark.CallBack = this.OnDartClick;
         this.FDark.visible = true;
         this.FNpcManager = new TNpcManager(this.FMapParameter);
         this.FNpcManager.FunOnNpcClicked = this.NpcClicked;
         this.FToolCoordinate = new TCoordinate();
         this.FMainPlayerManager = new TMainPlayerManager(this.FMapParameter);
         this.FPlayerManager = new TPlayerManager(this.FMapParameter);
         this.FPlayerManager.OnSearchWay = this.PlayerMove;
         this.FPlayerManager.FunOnClickPlayer = this.PlayerClicked;
         this.FPlayerManager.FunCreateRandomCoordinate = this.CreateCoordinateByBirthID;
         this.FEnvironmentManager = new TEnvironmentManager(this.FMapParameter);
      }
      
      override protected function PacketRegisterRoutines() : void
      {
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_LOBBY_Town_NewRoleNtf,this.PacketPerform_SC_TOWN_NewRole);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_LOBBY_Town_RoleMove,this.PacketPerform_SC_TOWN_RoleMove);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_LOBBY_Town_RemoveRole,this.PacketPerform_SC_RemoveTownRole);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_LOBBY_Town_UpdateRole,this.PacketPerform_UpdateTownRole);
      }
      
      protected function PacketPerform_SC_TOWN_NewRole(param1:TPacket) : void
      {
         if(!this.FMapDataLoadOver)return;
         this.FPlayerManager.AddPlayerByPacket(param1);
         this.FMapSpriteMountPoint.AddSpriteBatch(this.FPlayerManager.Players);
      }
      
      protected function PacketPerform_SC_TOWN_RoleMove(param1:TPacket) : void
      {
         if(!this.FMapDataLoadOver)return;
         this.FPlayerManager.MovePlayerByPacket(param1);
      }
      
      protected function PacketPerform_SC_RemoveTownRole(param1:TPacket) : void
      {
         if(!this.FMapDataLoadOver)return;
         this.FPlayerManager.DeletePlayerByPacket(param1);
      }
      
      protected function PacketPerform_UpdateTownRole(param1:TPacket) : void
      {
         if(!this.FMapDataLoadOver)return;
         var _loc2_:int = 0;
         _loc2_ = int(this.FPlayerManager.Players.length);
         this.FPlayerManager.UpdatePlayerByPacket(param1);
         if(this.FPlayerManager.Players.length > _loc2_)
         {
            this.FMapSpriteMountPoint.AddSpriteBatch(this.FPlayerManager.Players);
         }
      }
      
      protected function SendMainRolePositionToServer(param1:TCoordinate) : void
      {
         var _loc2_:TPacket = null;
         var _loc3_:ByteArray = null;
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_LOBBY_Town_Move);
         _loc3_ = _loc2_.Data;
         _loc3_.writeShort(param1.X);
         _loc3_.writeShort(param1.Y);
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
      }
      
      protected function SimulationTOWN_NewRole() : void
      {
         var _loc1_:TPacket = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_SC_LOBBY_Town_NewRoleNtf);
         _loc3_ = 50;
         _loc1_.Data.writeShort(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc1_.Data.writeUnsignedInt(0);
            _loc1_.Data.writeUnsignedInt(_loc2_ + 1);
            _loc1_.Data.writeUnsignedInt(11100001 + uint(Math.random() * 6));
            TUtilityString.FlushUTF(_loc1_.Data,"xingxingtie" + _loc2_);
            _loc1_.Data.writeUnsignedInt(uint(Math.random() * 36 + 40100001));
            _loc1_.Data.writeUnsignedInt(0);
            _loc1_.Data.writeUnsignedInt(1);
            _loc1_.Data.writeByte(1);
            _loc1_.Data.writeUnsignedInt(2000051);
            _loc1_.Data.writeUnsignedInt(0);
            _loc1_.Data.writeByte(2);
            _loc1_.Data.writeUnsignedInt(0);
            _loc2_++;
         }
         _loc1_.Data.position = 0;
         this.PacketPerform_SC_TOWN_NewRole(_loc1_);
      }
      
      protected function SimulationTOWN_NewRoleTwo() : void
      {
         var _loc1_:TTexture = null;
         var _loc2_:int = 0;
         var _loc3_:Bitmap = null;
         var _loc4_:BitmapData = null;
         var _loc5_:TextField = null;
         _loc1_ = SResourcesCore.TexturesLobby.GetTextureByIdentifier(CONST_LOBBY.RESOURCEID_Textures_DefaultRole);
         if(_loc1_ != null)
         {
            _loc4_ = _loc1_.GetAnimationSequenceByIndex(0).GetAnimationFrameByIndex(0).Surface;
         }
         _loc2_ = 0;
         while(_loc2_ < 100)
         {
            _loc3_ = new Bitmap(_loc4_);
            _loc5_ = new TextField();
            _loc5_.text = "hello";
            stage.addChild(_loc3_);
            stage.addChild(_loc5_);
            _loc5_.x = 400 + (Math.random() * 40 - 20);
            _loc5_.y = 400 + (Math.random() * 40 - 20);
            _loc3_.x = 400 + (Math.random() * 40 - 20);
            _loc3_.y = 400 + (Math.random() * 40 - 20);
            _loc2_++;
         }
      }
      
      protected function MainSceneInit_Perform() : void
      {
         this.FMainPlayerManager.CreateMainRole();
         this.UpdateQuality();
         this.UpdateMilitaryRank();
         this.FMapSpriteMountPoint.AddSprite(this.FMainPlayerManager.MainRole);
         this.UpdateKnifeOfKillSoul();
         this.UpdatePet();
         this.FMainPlayerManager.MainRole.OnArriveTargetPosition = this.OnArriveTargetPosition;
         this.FScreenControler = new TMapWindowControlCoordinate(this.FMainPlayerManager.MainRole.MapCoordinate,this.FMapParameter,this.FMapDrawer);
      }
      
      protected function IfCityDoor(param1:TSceneSpriteMoudleInMapNpc) : Boolean
      {
         return param1.UserType == CONST_NPC.NPC_FUNCTION_GATE;
      }
      
      protected function PlayerMove(param1:TSceneSpriteMoudleInMapCanRun, param2:int, param3:int) : TCoordinate
      {
         var _loc4_:int = 0;
         param1.RunPath.length = 0;
         this.FSearhWay.SearchWay(param1.MapCoordinate.X,param1.MapCoordinate.Y,param2,param3,param1.RunPath);
         _loc4_ = int(param1.RunPath.length);
         if(_loc4_ >= 2)
         {
            this.FToolCoordinate.X = param1.RunPath[_loc4_ - 2];
            this.FToolCoordinate.Y = param1.RunPath[_loc4_ - 1];
         }
         param1.StartRun();
         if(_loc4_ >= 2)
         {
            return this.FToolCoordinate;
         }
         return null;
      }
      
      protected function OpenNpcDialog(param1:TSceneSpriteMoudleInMapNpc) : void
      {
         if(this.FOnOpenNpcDialog != null)
         {
            this.FOnOpenNpcDialog(param1);
         }
      }
      
      protected function AddSpriteBatch(param1:DisplayObjectContainer, param2:Vector.<TSceneSpriteMoudleInMap>) : void
      {
         var _loc3_:int = 0;
         while(param1.numChildren > 0)
         {
            param1.removeChildAt(0);
         }
         _loc3_ = 0;
         while(_loc3_ < param2.length)
         {
            param1.addChildAt(param2[_loc3_],_loc3_);
            _loc3_++;
         }
      }
      
      protected function IfPlayAutoSearchWayEffect(param1:Boolean) : void
      {
         if(this.FOnAutoSearchWayEffect != null)
         {
            this.FOnAutoSearchWayEffect(this,param1);
         }
      }
      
      protected function MapDataLoadOver(param1:TMapData) : void
      {
         this.FMapParameter.MapData = param1;
         this.FMapDrawer.ChangeMap(param1);
         this.FMainPlayerManager.ReLocation();
         this.FSearhWay.MapPathData = param1;
         this.CreateCoordinateByBirthID(this.FMainPlayerManager.MainRole.BirthID,this.FMainPlayerManager.MainRole.MapCoordinate);
         this.FEnvironmentManager.InitSceneSprites();
         this.FMapSpriteMountPoint.AddSpriteBatch(this.FEnvironmentManager.SceneSprites);
         if(this.FMainPlayerManager.MainRole.KnifeOfKillSoul != null)
         {
            this.FMainPlayerManager.MainRole.KnifeOfKillSoul.MapCoordinate.Assign(this.FMainPlayerManager.MainRole.MapCoordinate);
         }
         this.FMapDataLoadOver = true;
         this.FPlayerManager.Clear();
         this.SendMainRolePositionToServer(this.FMainPlayerManager.MainRole.MapCoordinate);
         var presence:TPacket=SNetworkCore.PacketAcquire(0x01810302);
         SNetworkCore.Transceiver.PacketTransmit(presence);

      }
      
      protected function ChangeMap(param1:uint) : void
      {
         this.FMapDataLoadOver = false;
         this.FMapdataLoader.Load(param1,this.MapDataLoadOver);
      }
      
      protected function ProcessorEnterTown(param1:ByteArray) : void
      {
         var _loc2_:uint = 0;
         if(param1 != null)
         {
            param1.readUnsignedInt();
            _loc2_ = param1.readUnsignedInt();
            this.FMainPlayerManager.MainRole.BirthID = _loc2_;
            this.ChangeMap(10001);
            this.FPlayerManager.Clear();
            this.UpdateKnifeOfKillSoul();
            this.UpdatePet();
         }
         SLogicsCore.Character.RoleSencePosition = CONST_COMMON.SCENEPOSITION_MAINCITY;
      }
      
      protected function CheckEquipTitleTime() : void
      {
         var _loc1_:* = 0;
         var _loc2_:TTitles = null;
         var _loc3_:TTitle = null;
         var _loc4_:Boolean = false;
         _loc2_ = SLogicsCore.Character.CurrentEquipTitles;
         _loc1_ = 0;
         while(_loc1_ < _loc2_.Count)
         {
            _loc3_ = _loc2_.GetTitleByIndex(_loc1_);
            if(_loc3_.IfTimeLimit && STimingCore.ServerTick > _loc3_.TargetTime)
            {
               _loc2_.DeleteByIndex(_loc1_);
               _loc3_.IfOverTime = true;
               _loc1_--;
               _loc4_ = true;
            }
            _loc1_++;
         }
         if(_loc4_)
         {
            this.UpdateTitle();
         }
      }
      
      override protected function LogicsPerform() : void
      {
         var _loc1_:int = 0;
         super.LogicsPerform();
         if(!this.FInitialization)
         {
            return;
         }
         this.FMapdataLoader.Update();
         if(this.Visible && this.FMapDataLoadOver)
         {
            this.FScreenControler.Update();
            this.FUnityPool.length = 0;
            this.FSpriteUpdate.Sprites = this.FMainPlayerManager.MainRoles;
            this.FSpriteUpdate.Update();
            this.AddElementsInUnityPools(this.FMainPlayerManager.MainRoles);
            this.FSpriteUpdate.Sprites = this.FPlayerManager.Players;
            this.FSpriteUpdate.Update();
            this.AddElementsInUnityPools(this.FSpriteUpdate.SpritesCanShow);
            this.FSpriteUpdate.Sprites = this.FNpcManager.NpcsCanShow;
            this.FSpriteUpdate.Update();
            this.AddElementsInUnityPools(this.FNpcManager.NpcsCanShow);
            this.FSpriteUpdate.Sprites = this.FEnvironmentManager.SceneSprites;
            this.FSpriteUpdate.Update();
            this.AddElementsInUnityPools(this.FSpriteUpdate.SpritesCanShow);
            this.FDeepSort.DeepSort(this.FUnityPool);
            this.FMapSpriteMountPoint.Relocation(this.FUnityPool);
         }
      }
      
      override public function Mount(param1:ByteArray = null) : void
      {
         super.Mount();
         this.ProcessorEnterTown(param1);
         SLogicsCore.QuestAutoSearchWay.QuestEventNotify(CONST_QUESTAUTOSEARCHWAY.QuestEventType_EnterMainCity);
         MusicPlayNext(CONST_SIGNAL.SIGNALDESTINATION_SOUND,CONST_MUSIC.PLAY_SCENE_MainCity,SLogicsCore.Character.TownID);
         if(this.FOnProcessorCheckPopTips != null)
         {
            this.FOnProcessorCheckPopTips(this);
         }
         this.ShowAndHideMainSceneRoles(SLogicsCore.IsShowAllUser);
         if(FIsResourcesLoadCompleted)
         {
            if(!this.FAutoMoveToNpc)
            {
               this.FMainPlayerManager.MainRole.RoleDirection = CONST_MAP.DIRECTION_DOWN;
               this.FMainPlayerManager.MainRole.ChangeToStandBy();
            }
            if(this.FMainPlayerManager.MainRole.KnifeOfKillSoul != null)
            {
               this.FMainPlayerManager.MainRole.KnifeOfKillSoul.RoleDirection = CONST_MAP.DIRECTION_DOWN;
               this.FMainPlayerManager.MainRole.KnifeOfKillSoul.ChangeToStandBy();
            }
         }
      }
      
      override public function Unmount() : void
      {
         super.Unmount();
         this.IfPlayAutoSearchWayEffect(false);
         this.FMapDrawer.StopDraw();
      }
      
      protected function CreateCoordinateByBirthID(param1:int, param2:TCoordinate) : void
      {
         if(param1<0){param2.X=(uint(param1)>>>15)&32767;param2.Y=uint(param1)&32767;return;}

         var _loc3_:TMap = null;
         var _loc4_:TBins = null;
         var _loc5_:TSceneSpriteMoudleInMapNpc = null;
         var _loc6_:int = 0;
         if(param1 == 0)
         {
            param2.X = this.CreateRandomNumByArea(this.FMapParameter.MapData.BirthPlace_X - BIRTH_RANDOMAREA[0],this.FMapParameter.MapData.BirthPlace_X + BIRTH_RANDOMAREA[0]);
            param2.Y = this.CreateRandomNumByArea(this.FMapParameter.MapData.BirthPlace_Y - BIRTH_RANDOMAREA[0],this.FMapParameter.MapData.BirthPlace_Y + BIRTH_RANDOMAREA[0]);
         }
         else
         {
            _loc4_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_Map);
            _loc6_ = 0;
            while(_loc6_ < _loc4_.Count)
            {
               _loc3_ = _loc4_.GetDatebaseByIndex(_loc6_) as TMap;
               if(_loc3_.Type == param1)
               {
                  _loc5_ = this.FNpcManager.GetNpcByID(_loc3_.Identifier);
                  param2.X = this.CreateRandomNumByArea(_loc5_.TalkCoordinate.X - BIRTH_RANDOMAREA[param1],_loc5_.TalkCoordinate.X + BIRTH_RANDOMAREA[param1]);
                  param2.Y = this.CreateRandomNumByArea(_loc5_.TalkCoordinate.Y - BIRTH_RANDOMAREA[param1],_loc5_.TalkCoordinate.Y + BIRTH_RANDOMAREA[param1]);
               }
               _loc6_++;
            }
         }
      }
      
      protected function CreateRandomNumByArea(param1:int, param2:int) : int
      {
         return Math.random() * (param2 - param1) + param1;
      }
      
      protected function CreateTalkCooridinate(param1:TCoordinate, param2:TCoordinate) : void
      {
         param2.X = param1.X + this.CreateRandomNumByArea(-20,20);
         param2.Y = param1.Y + this.CreateRandomNumByArea(-20,20);
      }
      
      protected function AddElementsInUnityPools(param1:Object) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         _loc3_ = int(param1.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FUnityPool.push(param1[_loc2_]);
            _loc2_++;
         }
      }
      
      protected function GetMapCityByDoorID(param1:uint) : int
      {
         var _loc2_:TMap = null;
         _loc2_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_Map,param1) as TMap;
         if(_loc2_ == null)
         {
            return 0;
         }
         return _loc2_.Type;
      }
      
      protected function OnArriveTargetPosition() : void
      {
         var _loc1_:Boolean = false;
         if(this.FTargetNpc != null)
         {
            _loc1_ = this.IfCityDoor(this.FTargetNpc);
            if(_loc1_)
            {
               if(this.FOnOpenWorldMap != null && !this.FAutoMoveToNpc)
               {
                  this.FOnOpenWorldMap(this,true,this.GetMapCityByDoorID(this.FTargetNpc.RoleTempleteID));
               }
               SLogicsCore.QuestAutoSearchWay.QuestEventNotify(CONST_QUESTAUTOSEARCHWAY.QuestEventType_ArriveCityDoor);
            }
            else if(this.FOnOpenNpcDialog != null)
            {
               this.FOnOpenNpcDialog(this.FTargetNpc);
               this.FTargetNpc = null;
            }
         }
         else
         {
            this.SendMainRolePositionToServer(this.FMainPlayerManager.MainRole.MapCoordinate);
         }
         this.FAutoMoveToNpc = false;
         this.IfPlayAutoSearchWayEffect(false);
      }
      
      protected function OnDartClick(param1:int, param2:int) : void
      {
         var _loc3_:TSceneSpriteMoudleInMapCanRun = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         _loc3_ = this.FMainPlayerManager.MainRole;
         _loc4_ = param1 - (_loc3_.MapCoordinate.X - this.FMapParameter.ScreenBounds.X);
         _loc5_ = param2 - (_loc3_.MapCoordinate.Y - this.FMapParameter.ScreenBounds.Y);
         this.PlayerMove(_loc3_,_loc3_.MapCoordinate.X + _loc4_,_loc3_.MapCoordinate.Y + _loc5_);
         this.FTargetNpc = null;
         SLogicsCore.QuestAutoSearchWay.QuestEventNotify(CONST_QUESTAUTOSEARCHWAY.QuestEventType_NormalMove);
         this.HideAvater();
         this.IfPlayAutoSearchWayEffect(false);
      }
      
      protected function NpcClicked(param1:TSceneSpriteMoudleInMapNpc) : void
      {
         var _loc2_:int = 0;
         var _loc3_:TCoordinate = null;
         this.CreateTalkCooridinate(param1.TalkCoordinate,this.FToolCoordinate);
         _loc3_ = this.PlayerMove(this.FMainPlayerManager.MainRole,this.FToolCoordinate.X,this.FToolCoordinate.Y);
         if(_loc3_ != null)
         {
            this.SendMainRolePositionToServer(_loc3_);
         }
         this.FTargetNpc = param1;
         this.HideAvater();
         if(this.FTavernNpc == param1)
         {
            TutorialNextStep(CONST_FRESHGUIDE.EVENTID_TavernNpcClicked);
         }
         this.IfPlayAutoSearchWayEffect(true);
      }
      
      protected function HideAvater() : void
      {
         if(this.FHideHeroContorlPanle != null)
         {
            this.FHideHeroContorlPanle(this);
         }
      }
      
      protected function PlayerClicked(param1:TSceneSpriteMoudleInMapCanRunPlayer) : void
      {
         if(this.FShowHeroContorlPanle != null)
         {
            this.FShowHeroContorlPanle(this,param1);
         }
      }
      
      protected function HandleMouseClick(param1:MouseEvent) : void
      {
         if(!visible)
         {
            return;
         }
         if(this.FMainPlayerManager.MainRole != null)
         {
            this.FMainPlayerManager.MainRole.StopRun();
         }
         this.IfPlayAutoSearchWayEffect(false);
      }
      
      public function set OnOpenNpcDialog(param1:Function) : void
      {
         this.FOnOpenNpcDialog = param1;
      }
      
      public function set OnOpenWorldMap(param1:Function) : void
      {
         this.FOnOpenWorldMap = param1;
      }
      
      public function set ShowHeroContorlPanle(param1:Function) : void
      {
         this.FShowHeroContorlPanle = param1;
      }
      
      public function get HideHeroContorlPanle() : Function
      {
         return this.FHideHeroContorlPanle;
      }
      
      public function set HideHeroContorlPanle(param1:Function) : void
      {
         this.FHideHeroContorlPanle = param1;
      }
      
      public function set OnProcessorCheckPopTips(param1:Function) : void
      {
         this.FOnProcessorCheckPopTips = param1;
      }
      
      public function set OnAutoSearchWayEffect(param1:Function) : void
      {
         this.FOnAutoSearchWayEffect = param1;
      }
      
      public function MainSceneInit() : void
      {
         this.MainSceneInit_Perform();
         this.FNpcManager.InitAllNpc();
         this.FMapSpriteMountPoint.AddSpriteBatch(this.FNpcManager.Npcs);
         this.FSpecialNpc = this.FNpcManager.GetNpcByID(22100024);
         TutorialSendComponent(CONST_FRESHGUIDE.MCID_SpecialNpc,this.FSpecialNpc);
         TutorialSendArrowParent(CONST_FRESHGUIDE.MCID_SpecialNpc,this.FMapDrawer);
         this.FTavernNpc = this.FNpcManager.GetNpcByID(22100020);
         TutorialSendComponent(CONST_FRESHGUIDE.MCID_TavernNpc,this.FTavernNpc);
         TutorialSendArrowParent(CONST_FRESHGUIDE.MCID_TavernNpc,this.FMapDrawer);
      }
      
      public function QuestUpdate() : void
      {
         this.FNpcManager.UpdateQuest();
         this.FNpcManager.ShowNpcByCityID(23100001);
      }
      
      public function GotoNpc(param1:uint) : void
      {
         this.NpcClicked(this.FNpcManager.GetNpcByID(param1) as TSceneSpriteMoudleInMapNpc);
         this.FAutoMoveToNpc = true;
      }
      
      public function UpdatePet() : void
      {
         var _loc1_:TPetBase = null;
         if(this.FMainPlayerManager.MainRole.Pet != null)
         {
            SLogicsCore.PoolMap.Release(this.FMainPlayerManager.MainRole.Pet);
            this.FMainPlayerManager.MainRole.Pet.Release();
            this.FMainPlayerManager.DeleteRole(this.FMainPlayerManager.MainRole.Pet);
            this.FMainPlayerManager.MainRole.Pet = null;
         }
         _loc1_ = SLogicsCore.PetData.OwnMainPets.GetPetByIdentifier(SLogicsCore.Character.MainHero.MainPetID,0);
         if(_loc1_ != null)
         {
            this.FMainPlayerManager.MainRole.Pet = TUnstreamizerRoleCanControlTwo.CreatePet(_loc1_.ModelID,this.FMainPlayerManager.MainRole);
            this.FMainPlayerManager.MainRole.Pet.RoleDirection = CONST_MAP.DIRECTION_RIGHT;
            this.FMainPlayerManager.MainRole.Pet.ChangeToStandBy();
            this.FMainPlayerManager.MainRoles.push(this.FMainPlayerManager.MainRole.Pet);
            this.FMapSpriteMountPoint.AddSprite(this.FMainPlayerManager.MainRole.Pet);
            this.FMainPlayerManager.MainRole.Pet.SpriteClassID = CONST_MAP.SPRITE_SYSTEMID_MAINROLEPET;
         }
      }
      
      public function UpdateKnifeOfKillSoul() : void
      {
         if(this.FMainPlayerManager.MainRole.KnifeOfKillSoul != null)
         {
            SLogicsCore.PoolMap.Release(this.FMainPlayerManager.MainRole.KnifeOfKillSoul);
            this.FMainPlayerManager.MainRole.KnifeOfKillSoul.Release();
            this.FMainPlayerManager.DeleteRole(this.FMainPlayerManager.MainRole.KnifeOfKillSoul);
            this.FMainPlayerManager.MainRole.KnifeOfKillSoul = null;
         }
         if(SLogicsCore.Character.KnifeSoul.IfFight)
         {
            this.FMainPlayerManager.MainRole.KnifeOfKillSoul = TUnstreamizerRoleCanControlTwo.CreateKnifeOfKillSoul(SLogicsCore.Character.KnifeSoul.CurrentModuleID,this.FMainPlayerManager.MainRole);
            this.FMainPlayerManager.MainRole.KnifeOfKillSoul.RoleDirection = CONST_MAP.DIRECTION_DOWN;
            this.FMainPlayerManager.MainRole.KnifeOfKillSoul.ChangeToStandBy();
            this.FMainPlayerManager.MainRoles.push(this.FMainPlayerManager.MainRole.KnifeOfKillSoul);
            this.FMapSpriteMountPoint.AddSprite(this.FMainPlayerManager.MainRole.KnifeOfKillSoul);
            this.FMainPlayerManager.MainRole.KnifeOfKillSoul.SpriteClassID = CONST_MAP.SPRITE_SYSTEMID_MAINROLEPET;
         }
      }
      
      public function SetRoleEnterCityMethod(param1:int, param2:int) : void
      {
         this.FRoleEnterCityMethod = param1;
         this.FRoleEnterDoorID = param2;
      }
      
      public function UpdateQuality() : void
      {
         if(this.FMainPlayerManager.MainRole == null)
         {
            return;
         }
         this.FMainPlayerManager.MainRole.Quality = SLogicsCore.Character.Heros.GetHeroByIndex(0).Quality;
         this.FMainPlayerManager.MainRole.UpdateHeadDecoration();
      }
      
      public function UpdateMilitaryRank() : void
      {
         this.FMainPlayerManager.MainRole.MilitaryRank = SLogicsCore.Character.MilitaryRank;
         this.FMainPlayerManager.MainRole.UpdateHeadDecoration();
      }
      
      public function ShowAndHideMainSceneRoles(param1:Boolean) : void
      {
         if(param1)
         {
            this.FSpriteUpdate.HideSpriteBySpriteClassID(CONST_MAP.SPRITE_SYSTEMID_NONE);
         }
         else
         {
            this.FSpriteUpdate.HideSpriteBySpriteClassID(CONST_MAP.SPRITE_SYSTEMID_PLAYERS);
         }
      }
      
      public function UpdateTitle() : void
      {
         var _loc1_:int = 0;
         var _loc2_:TTitles = null;
         var _loc3_:TTitle = null;
         _loc2_ = SLogicsCore.Character.CurrentEquipTitles;
         this.FMainPlayerManager.MainRole.TitlesID.length = 0;
         _loc1_ = 0;
         while(_loc1_ < _loc2_.Count)
         {
            _loc3_ = _loc2_.GetTitleByIndex(_loc1_);
            this.FMainPlayerManager.MainRole.TitlesID.push(_loc3_.ID);
            _loc1_++;
         }
         this.FMainPlayerManager.MainRole.UpdateHeadDecoration();
      }
      
      public function UpdateBleachAgentIcon() : void
      {
         var _loc1_:Boolean = false;
         _loc1_ = Boolean(SLogicsCore.BleachAgentData.Open);
         if(Boolean(this.FMainPlayerManager) && Boolean(this.FMainPlayerManager.MainRole))
         {
            this.FMainPlayerManager.MainRole.OpenBleachAgent = _loc1_;
            this.FMainPlayerManager.MainRole.UpdateHeadDecoration();
         }
      }
      
      public function UpdateRebirthNum(param1:uint) : void
      {
         if(Boolean(this.FMainPlayerManager) && Boolean(this.FMainPlayerManager.MainRole))
         {
            this.FMainPlayerManager.MainRole.RebirthNum = param1;
            this.FMainPlayerManager.MainRole.UpdateData();
            this.FMainPlayerManager.MainRole.UpdateHeadDecoration();
         }
      }
      
      public function UpdateKingChallengeNpc(param1:String, param2:uint) : void
      {
         var _loc3_:TSceneSpriteMoudleInMapNpc = null;
         _loc3_ = this.FNpcManager.GetNpcByID(22100028);
         _loc3_.Name = param1;
         _loc3_.NpcStyleTextureID = param2;
         param2 = CONST_ROLE.GetModelIDByIndex(param2,CONST_ROLE.ROLE_SEQUENCEINDEX_NORMAL_STANDBY_Down);
         _loc3_.ChangeRoleMoudle(param2,-1);
         this.FNpcManager.InitAllNpc_Perform();
      }
   }
}

