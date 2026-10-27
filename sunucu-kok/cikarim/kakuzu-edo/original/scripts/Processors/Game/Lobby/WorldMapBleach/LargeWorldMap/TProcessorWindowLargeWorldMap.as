package Processors.Game.Lobby.WorldMapBleach.LargeWorldMap
{
   import Debugging.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Bins.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.Campaign.*;
   import Logics.Characters.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.Items.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Utilities.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   import flash.filters.*;
   import flash.text.*;
   import flash.utils.*;
   
   public class TProcessorWindowLargeWorldMap extends TProcessorLobbyWindow
   {
      
      protected static const MAPTYPE_Human:uint = CONST_WORLDMAP.MAPTYPE_Human;
      
      protected static const MAPTYPE_HuecoMundo:uint = CONST_WORLDMAP.MAPTYPE_HuecoMundo;
      
      protected static const MAPTYPE_Soul:uint = CONST_WORLDMAP.MAPTYPE_Soul;
      
      protected static const MAPID_Human:uint = CONST_WORLDMAP.MAPID_Human;
      
      protected static const MAPID_HuecoMundo:uint = CONST_WORLDMAP.MAPID_HuecoMundo;
      
      protected static const MAPID_Soul:uint = CONST_WORLDMAP.MAPID_Soul;
      
      protected static const BARRIERTYPE_City:uint = CONST_WORLDMAP.BARRIERTYPE_City;
      
      protected static const BARRIERTYPE_Barrier:uint = CONST_WORLDMAP.BARRIERTYPE_Barrier;
      
      protected static const BARRIERTYPE_Instance:uint = CONST_WORLDMAP.BARRIERTYPE_Instance;
      
      protected static const Stamp_BarrierId:uint = 1;
      
      protected static const Stamp_InstanceId:uint = 1;
      
      protected static const Stamp_CityId:uint = 100000;
      
      protected static const COUNT_Movie:uint = 6;
      
      protected static const SELECT_NONE:int = 0;
      
      protected static const SELECT_HOME:int = 1;
      
      protected static const SELECT_CITY:int = 2;
      
      protected static const SELECT_CAMPAIGN:int = 3;
      
      public static var LevelFilters:GlowFilter = new GlowFilter(0,1,4,4,5);
      
      protected static const HomeVect:Vector.<int> = Vector.<int>([23200001,23300001,23400001]);
      
      protected static const MAX_MAP_COUNT:int = 3;
      
      protected var FMC_WorldMap:Sprite;
      
      protected var FMC_WorldMapBg:MovieClip;
      
      protected var FBtn_GotoHumanWorld:MovieClip;
      
      protected var FBtn_GotoSoulWorld:MovieClip;
      
      protected var FBtn_GotoHuecoMundoWorld:MovieClip;
      
      protected var FTF_Title:TextField;
      
      protected var FMC_Title:MovieClip;
      
      protected var FMC_City:MovieClip;
      
      protected var FMC_Role:MovieClip;
      
      protected var FBtn_Close:SimpleButton;
      
      protected var FCityBins:TBins;
      
      protected var FSingleBins:TBins;
      
      protected var FSinglePointPath:TBins;
      
      protected var FBlockPointBins:TBins;
      
      protected var FEnemyArmyBins:TBins;
      
      protected var FEnemyBins:TBins;
      
      protected var FMapBins:TBins;
      
      protected var FIsInit:Boolean;
      
      protected var FMapType:uint;
      
      protected var FNodalModel:TNodal;
      
      protected var FIsRoleFirstShow:Boolean;
      
      protected var FTargetCityId:uint;
      
      protected var FTargetNodalId:uint;
      
      protected var FTimerID:uint;
      
      protected var FSelectStatus:uint;
      
      protected var FPoolCampaign:TPoolCampaign;
      
      protected var FPoolItem:TPoolItem;
      
      protected var FCharacter:TCharacter;
      
      protected var FOnBarrierEnter:Function;
      
      protected var FOnReturnHomeScene:Function;
      
      protected var FOnUpdataNodalModel:Function;
      
      public function TProcessorWindowLargeWorldMap(param1:TUIComponent)
      {
         super(param1);
         this.FMapType = MAPTYPE_Human;
         this.FPoolCampaign = SLogicsCore.PoolCampaign;
         this.FPoolItem = SLogicsCore.PoolItem;
         this.FCharacter = SLogicsCore.Character;
         this.FIsInit = false;
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_WORLDMAP.RESOURCESID_WorldMap);
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
         this.FMapBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_Map);
         this.InitWorldMap();
         TutorialSendArrowParent(CONST_FRESHGUIDE.MCID_WorldMap,this.parent);
         TutorialSendComponent(CONST_FRESHGUIDE.MCID_WorldMap,this);
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         super.ResourcesPerform_UILocations();
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
      }
      
      protected function InitWorldMap() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:MovieClip = null;
         var _loc4_:TextField = null;
         var _loc5_:TBins = null;
         var _loc6_:TCity = null;
         this.FMC_WorldMap = TUtilityReflection.CreateDisplayObjectInstance(CONST_WORLDMAP.RESOURCE_ClassName_WorldMap) as MovieClip;
         addChild(this.FMC_WorldMap);
         this.FMC_WorldMapBg = this.FMC_WorldMap[CONST_WORLDMAP.RESOURCE_Link_MC_WorldMapBg];
         this.FMC_City = this.FMC_WorldMap[CONST_WORLDMAP.RESOURCE_Link_MC_City];
         this.FMC_Role = this.FMC_City[CONST_WORLDMAP.RESOURCE_Link_MC_Role];
         this.FMC_Title = this.FMC_WorldMap[CONST_WORLDMAP.RESOURCE_Link_MC_Title];
         this.FBtn_GotoHumanWorld = this.FMC_WorldMap[CONST_WORLDMAP.RESOURCE_Link_Btn_GotoHumanWorld];
         this.FBtn_GotoSoulWorld = this.FMC_WorldMap[CONST_WORLDMAP.RESOURCE_Link_Btn_GotoSoulWorld];
         this.FBtn_GotoHuecoMundoWorld = this.FMC_WorldMap[CONST_WORLDMAP.RESOURCE_Link_Btn_GotoHuecoMundoWorld];
         this.FBtn_Close = this.FMC_WorldMap[CONST_COMMON.RESOURCE_Link_Btn_Close];
         _loc5_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_City);
         _loc2_ = _loc5_.Count;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc6_ = _loc5_.GetDatebaseByIndex(_loc1_) as TCity;
            if(_loc6_.Type == CONST_WORLDMAP.BARRIERTYPE_City)
            {
               _loc3_ = this.FMC_City["home_" + _loc6_.Identifier];
               if(_loc3_ != null)
               {
                  _loc3_.visible = true;
                  TGameUtil.setButtonMode(_loc3_,true);
                  _loc3_.addEventListener(MouseEvent.CLICK,this.OnBarrierClickHandler);
               }
            }
            else if(_loc6_.Type == CONST_WORLDMAP.BARRIERTYPE_Barrier)
            {
               _loc3_ = this.FMC_City["city_" + _loc6_.Identifier];
               TGameUtil.setButtonMode(_loc3_,true);
               if(_loc3_ != null)
               {
                  _loc3_.visible = false;
                  _loc3_.addEventListener(MouseEvent.CLICK,this.OnBarrierClickHandler);
                  this.MakeTextField(_loc3_,_loc6_.Identifier,BARRIERTYPE_Barrier);
               }
            }
            else if(_loc6_.Type == CONST_WORLDMAP.BARRIERTYPE_Instance)
            {
               _loc3_ = this.FMC_City["camp_" + _loc6_.Identifier];
               TGameUtil.setButtonMode(_loc3_,true);
               if(_loc3_ != null)
               {
                  _loc3_.visible = false;
                  _loc3_.addEventListener(MouseEvent.CLICK,this.OnBarrierClickHandler);
                  this.MakeTextField(_loc3_,_loc6_.Identifier,BARRIERTYPE_Instance);
               }
            }
            _loc1_++;
         }
         this.FBtn_Close.addEventListener(MouseEvent.CLICK,this.OnCloseWorldMap,false,0,true);
         TGameUtil.setButtonMode(this.FBtn_GotoHumanWorld,true);
         TGameUtil.setButtonMode(this.FBtn_GotoSoulWorld,true);
         TGameUtil.setButtonMode(this.FBtn_GotoHuecoMundoWorld,true);
         this.FBtn_GotoHumanWorld.addEventListener(MouseEvent.CLICK,this.OnGotoWorldMapHandler,false,0,true);
         this.FBtn_GotoSoulWorld.addEventListener(MouseEvent.CLICK,this.OnGotoWorldMapHandler,false,0,true);
         this.FBtn_GotoHuecoMundoWorld.addEventListener(MouseEvent.CLICK,this.OnGotoWorldMapHandler,false,0,true);
         this.FMC_Role.mouseChildren = this.FMC_Role.mouseEnabled = false;
         this.FMC_Role.gotoAndPlay(1);
         this.FMC_Role.addEventListener(Event.COMPLETE,this.PlayComplete,false,0,true);
      }
      
      protected function UpdateGotoBtn(param1:uint) : Boolean
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:TMap = null;
         var _loc6_:Boolean = false;
         _loc6_ = false;
         _loc5_ = this.FMapBins.GetDatebaseByIdentifier(param1) as TMap;
         _loc4_ = _loc5_.OpenTask;
         if(_loc4_ == 0 || this.FCharacter.MainQuestComplete.GetQuestByIdentifier(_loc4_) != null)
         {
            _loc6_ = true;
         }
         else
         {
            _loc6_ = false;
         }
         return _loc6_;
      }
      
      protected function SwitchOnWorldMap() : void
      {
         if(this.FMC_Title == null)
         {
            return;
         }
         if(this.FMapType == MAPTYPE_Human)
         {
            this.FMC_Title.gotoAndStop(MAPTYPE_Human);
            this.FMC_City.x = 22;
            this.FMC_WorldMapBg.x = 22;
         }
         else if(this.FMapType == MAPTYPE_Soul)
         {
            this.FMC_Title.gotoAndStop(MAPTYPE_Soul);
            this.FMC_City.x = -904;
            this.FMC_WorldMapBg.x = -904;
         }
         else if(this.FMapType == MAPTYPE_HuecoMundo)
         {
            this.FMC_Title.gotoAndStop(MAPTYPE_HuecoMundo);
            this.FMC_City.x = -1830;
            this.FMC_WorldMapBg.x = -1830;
         }
      }
      
      protected function MakeTextField(param1:MovieClip, param2:int, param3:uint) : void
      {
         var _loc4_:TextField = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:TBlockPoint = null;
         var _loc8_:TBlockPoint = null;
         var _loc9_:TCity = null;
         var _loc10_:TSingle = null;
         var _loc11_:String = null;
         var _loc12_:int = 0;
         if(param3 == BARRIERTYPE_Barrier)
         {
            _loc9_ = this.FCityBins.GetDatebaseByIdentifier(param2) as TCity;
            _loc7_ = this.FBlockPointBins.GetDatebaseByIdentifier(_loc9_.Start) as TBlockPoint;
            _loc8_ = this.FBlockPointBins.GetDatebaseByIdentifier(_loc9_.Last) as TBlockPoint;
            _loc5_ = uint(_loc7_.Level);
            _loc6_ = uint(_loc8_.Level);
            if(param1 != null)
            {
               param1["TF_Lv"].text = "(Lv." + _loc5_ + "~" + _loc6_ + ")";
            }
         }
         if(param3 == BARRIERTYPE_Instance)
         {
            _loc9_ = this.FCityBins.GetDatebaseByIdentifier(param2) as TCity;
            _loc12_ = _loc9_.Start;
            _loc10_ = this.FSingleBins.GetDatebaseByIdentifier(_loc12_) as TSingle;
            _loc5_ = uint(_loc10_.Level);
            if(param1 != null)
            {
               param1["TF_Lv"].text = "(Lv." + _loc5_ + ")";
            }
         }
      }
      
      protected function PlayComplete(param1:Event) : void
      {
         var _loc2_:TCity = null;
         var _loc3_:int = 0;
         if(this.FIsRoleFirstShow)
         {
            this.FIsRoleFirstShow = false;
            return;
         }
         clearTimeout(this.FTimerID);
         if(this.FSelectStatus == SELECT_CITY)
         {
            if(this.FTargetNodalId == 0)
            {
               this.FTargetNodalId = this.FNodalModel.CurMissionID;
            }
            if(this.FTargetNodalId > this.FNodalModel.CurMissionID)
            {
               this.FTargetNodalId = this.FNodalModel.CurMissionID;
            }
            if(this.FOnBarrierEnter != null)
            {
               this.FOnBarrierEnter(this,this.FTargetCityId,CONST_BATTLE.BattleType_Nodal);
            }
         }
         else if(this.FSelectStatus == SELECT_HOME)
         {
            if(this.FOnReturnHomeScene != null)
            {
               if(this.FTargetCityId == 23100001)
               {
                  this.FOnReturnHomeScene(this,0,0);
               }
               else
               {
                  _loc2_ = this.FCityBins.GetDatebaseByIdentifier(this.FTargetCityId) as TCity;
                  this.FOnReturnHomeScene(this,0,_loc2_.Map);
               }
            }
         }
         else if(this.FSelectStatus == SELECT_CAMPAIGN)
         {
            this.MakeCampData(this.FTargetCityId);
            if(this.FOnBarrierEnter != null)
            {
               this.FOnBarrierEnter(this,this.FTargetCityId,CONST_BATTLE.BattleType_Camp);
            }
            TutorialNextStep(CONST_FRESHGUIDE.EVENTID_ClickInstanceIcon);
         }
         this.FSelectStatus = 0;
         this.FTargetCityId = 0;
         this.FTargetNodalId = 0;
      }
      
      protected function SetGoto() : void
      {
         if(this.FSelectStatus == SELECT_HOME)
         {
            if(this.FMC_City["home_" + this.FTargetCityId] != null)
            {
               this.FMC_Role.gotoAndPlay(1);
               this.SetFormatMCRole(this.FMC_City["home_" + this.FTargetCityId]);
            }
         }
         else if(this.FSelectStatus == SELECT_CAMPAIGN)
         {
            if(this.FMC_City["camp_" + this.FTargetCityId] != null)
            {
               this.FMC_Role.gotoAndPlay(1);
               this.SetFormatMCRole(this.FMC_City["camp_" + this.FTargetCityId]);
            }
         }
         else if(this.FSelectStatus == SELECT_CITY)
         {
            if(this.FMC_City["city_" + this.FTargetCityId] != null)
            {
               this.FMC_Role.gotoAndPlay(1);
               this.SetFormatMCRole(this.FMC_City["city_" + this.FTargetCityId]);
            }
         }
         this.FIsRoleFirstShow = false;
      }
      
      protected function UpdataMapUI() : void
      {
         var _loc1_:int = 0;
         var _loc2_:MovieClip = null;
         var _loc3_:TBlockPoint = null;
         var _loc4_:TCity = null;
         this.CheckOpenNodalCamp();
         _loc3_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_BlockPoint,this.FNodalModel.CurMissionID) as TBlockPoint;
         _loc1_ = int(CONST_WORLDMAP.Start_BarrierId);
         while(_loc1_ <= _loc3_.Campaign)
         {
            _loc2_ = this.FMC_City["city_" + _loc1_];
            if(_loc2_ != null)
            {
               _loc4_ = this.FCityBins.GetDatebaseByIdentifier(_loc1_) as TCity;
               _loc2_.visible = true;
            }
            _loc1_++;
         }
         this.CheckShowIcon();
      }
      
      protected function PlayMovie(param1:Boolean = true) : void
      {
      }
      
      protected function CheckOpenNodalCamp() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:TBlockPoint = null;
         var _loc3_:TBlockPoint = null;
         var _loc4_:uint = 0;
         var _loc5_:Boolean = false;
         if(!this.FIsInit)
         {
            return;
         }
         _loc5_ = false;
         if(this.FNodalModel.GetMissionStarByID(this.FNodalModel.CurMissionID) > 0)
         {
            _loc2_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_BlockPoint,this.FNodalModel.CurMissionID) as TBlockPoint;
            _loc4_ = uint(_loc2_.NextPoint);
            _loc3_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_BlockPoint,_loc4_) as TBlockPoint;
            if(_loc3_ != null)
            {
               if(this.FCharacter.GetMainLevel() >= _loc3_.Level)
               {
                  if(this.FNodalModel.CurMissionID != _loc4_)
                  {
                     this.FNodalModel.CurMissionID = _loc4_;
                     _loc5_ = true;
                  }
               }
            }
         }
         _loc1_ = this.CheckLevelUpOpenNormalCamp();
         if(_loc1_ != 0)
         {
            this.MakeCampData(_loc1_);
            _loc5_ = true;
         }
         if(_loc5_)
         {
            this.UpdataMapUI();
         }
      }
      
      protected function CheckShowIcon() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:int = 0;
         var _loc3_:DisplayObject = null;
         var _loc4_:TCampaign = null;
         var _loc5_:TCity = null;
         var _loc6_:TSingle = null;
         _loc2_ = this.FCityBins.Count;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc5_ = this.FCityBins.GetDatebaseByIndex(_loc1_) as TCity;
            if(_loc5_.Type == CONST_WORLDMAP.BARRIERTYPE_Instance)
            {
               _loc6_ = this.FSingleBins.GetDatebaseByIdentifier(_loc5_.Start) as TSingle;
               if(_loc6_.Level <= this.FCharacter.GetMainLevel())
               {
                  _loc4_ = this.FNodalModel.GetCampaignByIndex(_loc5_.Identifier);
                  if(_loc4_ == null)
                  {
                     this.MakeCampData(_loc5_.Identifier);
                  }
                  this.FMC_City["camp_" + _loc5_.Identifier].visible = true;
               }
               else
               {
                  this.FMC_City["camp_" + _loc5_.Identifier].visible = false;
               }
            }
            _loc1_++;
         }
      }
      
      protected function CheckLevelUpOpenNormalCamp() : uint
      {
         var _loc1_:TCity = null;
         var _loc2_:TSingle = null;
         var _loc3_:int = 0;
         _loc3_ = this.FNodalModel.GetCampaignMaxId() + 1;
         _loc1_ = this.FCityBins.GetDatebaseByIdentifier(_loc3_) as TCity;
         if(_loc1_ == null)
         {
            return null;
         }
         _loc2_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_Single,_loc1_.Start) as TSingle;
         if(Boolean(_loc2_) && _loc2_.Level <= this.FCharacter.GetMainLevel())
         {
            return _loc3_;
         }
         return 0;
      }
      
      protected function SetFormatCitySign(param1:MovieClip) : void
      {
      }
      
      protected function SetFormatMCRole(param1:MovieClip) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         if(param1 == null)
         {
            return;
         }
         _loc6_ = this.FMC_Role.width;
         _loc7_ = this.FMC_Role.height;
         _loc4_ = param1.x;
         _loc5_ = param1.y;
         _loc2_ = param1.width;
         _loc3_ = param1.height;
         this.FMC_Role.x = _loc4_;
         this.FMC_Role.y = _loc5_;
      }
      
      protected function SetTaskMovie(param1:int) : void
      {
         var _loc2_:TBlockPoint = null;
         var _loc3_:int = 0;
         if(this.FBlockPointBins == null)
         {
            return;
         }
         _loc2_ = this.FBlockPointBins.GetDatebaseByIdentifier(param1) as TBlockPoint;
         if(_loc2_ == null)
         {
            return;
         }
         _loc3_ = int(_loc2_.Campaign);
         this.FSelectStatus = SELECT_CITY;
         this.FTargetCityId = _loc3_;
         this.SetGoto();
      }
      
      protected function MakeCampData(param1:int) : void
      {
         var _loc2_:TSinglePointPath = null;
         var _loc3_:TCity = null;
         var _loc4_:TCampaign = null;
         var _loc5_:TSingle = null;
         var _loc6_:TItem = null;
         var _loc7_:uint = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         if(this.FNodalModel.GetCampaignById(param1) != null)
         {
            return;
         }
         _loc3_ = this.FCityBins.GetDatebaseByIdentifier(param1) as TCity;
         _loc4_ = this.FPoolCampaign.AcquireCampaign(param1);
         _loc4_.Diffculty = -1;
         _loc4_.LayerIndex = 0;
         _loc4_.EnemyIndex = 0;
         _loc4_.EnterCount = 0;
         _loc4_.ResetCount = 1;
         _loc7_ = uint(_loc3_.Start);
         _loc5_ = this.FSingleBins.GetDatebaseByIdentifier(_loc7_) as TSingle;
         _loc8_ = int(_loc5_.Awards.length);
         _loc4_.OpenLevel = _loc5_.Level;
         _loc9_ = 0;
         while(_loc9_ < _loc8_)
         {
            if(_loc4_.NormalDropItems.GetItemById(_loc5_.Awards[_loc9_]) == null)
            {
               _loc6_ = this.FPoolItem.AcquireItem();
               _loc6_.Type = 1;
               _loc6_.ID = _loc5_.Awards[_loc9_];
               _loc6_.Count = 1;
               _loc4_.NormalDropItems.Add(_loc6_);
            }
            _loc9_++;
         }
         _loc9_ = int(_loc5_.StartId);
         while(_loc9_ <= _loc5_.EndId)
         {
            _loc2_ = this.FSinglePointPath.GetDatebaseByIdentifier(_loc9_) as TSinglePointPath;
            if(_loc4_.GetEnemyByIndex(TCampaign.Type_Noraml,_loc2_.Armys) <= 0)
            {
               _loc4_.NormalEnemy.push(_loc2_.Armys);
            }
            _loc9_++;
         }
         _loc4_.NormalCampId = _loc7_;
         _loc7_ = uint(_loc3_.Last);
         _loc5_ = this.FSingleBins.GetDatebaseByIdentifier(_loc7_) as TSingle;
         _loc8_ = int(_loc5_.Awards.length);
         _loc9_ = 0;
         while(_loc9_ < _loc8_)
         {
            if(_loc4_.HardDropItems.GetItemById(_loc5_.Awards[_loc9_]) == null)
            {
               _loc6_ = this.FPoolItem.AcquireItem();
               _loc6_.Type = 1;
               _loc6_.ID = _loc5_.Awards[_loc9_];
               _loc6_.Count = 1;
               _loc4_.HardDropItems.Add(_loc6_);
            }
            _loc9_++;
         }
         _loc9_ = int(_loc5_.StartId);
         while(_loc9_ <= _loc5_.EndId)
         {
            _loc2_ = this.FSinglePointPath.GetDatebaseByIdentifier(_loc9_) as TSinglePointPath;
            if(_loc4_.GetEnemyByIndex(TCampaign.Type_Hard,_loc2_.Armys) <= 0)
            {
               _loc4_.HardEnemy.push(_loc2_.Armys);
            }
            _loc9_++;
         }
         _loc4_.HardCampId = _loc7_;
         _loc4_.IsInit = true;
         this.FNodalModel.AddCampaign(_loc4_);
         if(this.FOnUpdataNodalModel != null)
         {
            this.FOnUpdataNodalModel(this,this.FNodalModel);
         }
      }
      
      protected function OnBarrierClickHandler(param1:MouseEvent) : void
      {
         var _loc2_:String = null;
         _loc2_ = String(param1.currentTarget.name).slice(0,4);
         if(_loc2_ == "city")
         {
            this.FSelectStatus = SELECT_CITY;
         }
         else if(_loc2_ == "camp")
         {
            this.FSelectStatus = SELECT_CAMPAIGN;
         }
         else if(_loc2_ == "home")
         {
            this.FSelectStatus = SELECT_HOME;
         }
         this.FTargetCityId = int(String(param1.currentTarget.name).slice(5));
         this.FMC_Role.gotoAndPlay(1);
         this.SetFormatMCRole(param1.currentTarget as MovieClip);
      }
      
      protected function OnCloseWorldMap(param1:MouseEvent) : void
      {
         if(this.FOnReturnHomeScene != null)
         {
            this.FOnReturnHomeScene(this);
         }
      }
      
      protected function OnGotoWorldMapHandler(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:TMap = null;
         var _loc4_:uint = 0;
         var _loc5_:Boolean = false;
         switch(param1.currentTarget.name)
         {
            case "Btn_GotoHumanWorld":
               _loc4_ = MAPID_Human;
               _loc5_ = this.UpdateGotoBtn(_loc4_);
               if(_loc5_)
               {
                  this.FMapType = MAPTYPE_Human;
                  break;
               }
               if(FOnEffectText != null)
               {
                  FOnEffectText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.WORLDMAP_STRING_16));
               }
               return;
               break;
            case "Btn_GotoSoulWorld":
               _loc4_ = MAPID_Soul;
               _loc5_ = this.UpdateGotoBtn(_loc4_);
               if(_loc5_)
               {
                  this.FMapType = MAPTYPE_Soul;
                  break;
               }
               if(FOnEffectText != null)
               {
                  FOnEffectText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.WORLDMAP_STRING_16));
               }
               return;
               break;
            case "Btn_GotoHuecoMundoWorld":
               _loc4_ = MAPID_HuecoMundo;
               _loc5_ = this.UpdateGotoBtn(_loc4_);
               if(_loc5_)
               {
                  this.FMapType = MAPTYPE_HuecoMundo;
                  break;
               }
               if(FOnEffectText != null)
               {
                  FOnEffectText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.WORLDMAP_STRING_16));
               }
               return;
         }
         this.SwitchOnWorldMap();
      }
      
      public function get OnBarrierEnter() : Function
      {
         return this.FOnBarrierEnter;
      }
      
      public function set OnBarrierEnter(param1:Function) : void
      {
         this.FOnBarrierEnter = param1;
      }
      
      public function get OnReturnHomeScene() : Function
      {
         return this.FOnReturnHomeScene;
      }
      
      public function set OnReturnHomeScene(param1:Function) : void
      {
         this.FOnReturnHomeScene = param1;
      }
      
      public function get OnUpdataNodalModel() : Function
      {
         return this.FOnUpdataNodalModel;
      }
      
      public function set OnUpdataNodalModel(param1:Function) : void
      {
         this.FOnUpdataNodalModel = param1;
      }
      
      public function OpenWorldMap(param1:uint, param2:int = 0) : void
      {
         this.FMapType = param1;
         this.UpdataMapUI();
         this.SwitchOnWorldMap();
         if(param2 > 0)
         {
            this.SetTaskMovie(param2);
         }
      }
      
      public function UpDataWorldMap(param1:TNodal) : void
      {
         this.FIsInit = true;
         this.FNodalModel = param1;
         this.FIsInit = true;
         if(this.FTargetCityId == 0 && this.FMC_City != null)
         {
            this.FTargetCityId = this.FCharacter.TownID;
            this.SetFormatMCRole(this.FMC_City["home_" + this.FTargetCityId]);
         }
         clearTimeout(this.FTimerID);
         this.FTimerID = setTimeout(this.SetGoto,1000);
         if(this.FMC_Role)
         {
            this.FMC_Role.MC_GateFire.gotoAndPlay(1);
         }
         this.UpdataMapUI();
      }
      
      public function Reset() : void
      {
         if(this.FMC_Role)
         {
            this.FMC_Role.MC_GateFire.stop();
         }
      }
   }
}

