package Processors.Game.Lobby.WorldMapBleach.MonsterMap
{
   import Foundation.Common.*;
   import Foundation.Resources.*;
   import Foundation.UI.*;
   import Foundation.Utilities.TUtilityReflection;
   import Logics.DatebaseVO.VO.*;
   import Logics.Map.*;
   import Processors.Game.Common.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Common.Map.DeepSort.IDeepSort;
   import Processors.Game.Lobby.Common.Map.DeepSort.TDeepSortCombineSort;
   import Processors.Game.Lobby.Common.Map.DrawMap.*;
   import Processors.Game.Lobby.Common.Map.MapLoader.*;
   import Processors.Game.Lobby.Common.Map.MapWindowContorl.*;
   import Processors.Game.Lobby.Common.Map.SceneSprite.*;
   import Processors.Game.Lobby.Common.Map.SpriteMountPoint.TMonsterMountPoint;
   import Processors.Game.Lobby.MainSceneTwo.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.TextField;
   
   public class TProcessorWindowMonsterMap extends TProcessorLobbyWindow
   {
      
      protected static const STAGE_WIDTH:uint = CONST_COMMON.STAGE_Width;
      
      protected static const STAGE_HEIGHT:uint = CONST_COMMON.STAGE_Height;
      
      protected var FMonsterFlashEffectID:int = 13610101;
      
      protected var FMC_Title:Sprite;
      
      protected var FTF_MainTitle:TextField;
      
      protected var FMapDrawer:TDrawMapTwo;
      
      protected var FMapdataLoader:IMapLoader;
      
      protected var FScreenControler:TMapWindowControl;
      
      protected var FScreenBounds:TBounds;
      
      protected var FMapSpriteMountPoint:TMonsterMountPoint;
      
      protected var FSpriteUpdateInMap:TSpriteUpdate;
      
      protected var FMonsterFlashMC:MovieClip;
      
      protected var FMonsterManager:TMonsterManager;
      
      protected var FScreenArean:TBounds;
      
      protected var FBattleType:int;
      
      protected var FMapParameter:TMapParameter;
      
      protected var FDeepSort:IDeepSort;
      
      protected var FMapLoadOver:Boolean;
      
      protected var FCityVO:TCity;
      
      protected var FInitialization:Boolean;
      
      protected var FMonsterClicked:Function;
      
      protected var FOnBackWorldMap:Function;
      
      public function TProcessorWindowMonsterMap(param1:TUIComponent)
      {
         super(param1);
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
         this.FSpriteUpdateInMap.Sprites = this.FMonsterManager.Monsters;
         this.FSpriteUpdateInMap.Update();
         this.FDeepSort.DeepSort(this.FSpriteUpdateInMap.SpritesCanShow);
         this.FMapSpriteMountPoint.Relocation(this.FSpriteUpdateInMap.SpritesCanShow);
         if(this.FMonsterFlashMC != null)
         {
            if(this.FMonsterFlashMC.currentFrame == this.FMonsterFlashMC.totalFrames)
            {
               this.FMonsterFlashMC.visible = false;
               this.FMonsterFlashMC.stop();
            }
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
         this.FSpriteUpdateInMap = new TSpriteUpdate(this.FMapParameter);
         this.FMonsterManager = new TMonsterManager(this.FMapParameter);
         this.FMonsterManager.OnMonsterClicked = this.OnMonsterClicked;
         this.FDeepSort = new TDeepSortCombineSort();
      }
      
      protected function LoadMapDataOver(param1:TMapData) : void
      {
         this.FMapParameter.MapData = param1;
         this.FMapDrawer.ChangeMap(param1);
         this.FMapLoadOver = true;
      }
      
      protected function Release_Perform() : void
      {
         if(this.FMonsterManager != null)
         {
            this.FMonsterManager.ClearMonster();
         }
      }
      
      protected function LoadMonsterEffectMC() : void
      {
         if(this.FMonsterFlashMC == null)
         {
            this.FMonsterFlashMC = TUtilityReflection.CreateDisplayObjectInstance("GuideEffect") as MovieClip;
         }
      }
      
      protected function UpdateTitle() : void
      {
         if(this.FTF_MainTitle == null)
         {
            return;
         }
         if(this.FCityVO != null)
         {
            this.FTF_MainTitle.text = this.FCityVO.Name.toString();
         }
         else
         {
            this.FTF_MainTitle.text = "";
         }
      }
      
      protected function OnBtnClose(param1:MouseEvent = null) : void
      {
         this.Release();
         if(this.FOnBackWorldMap != null)
         {
            this.FOnBackWorldMap(this);
         }
      }
      
      protected function OnMonsterClicked(param1:TSceneSpriteMoudleInMapMonster) : void
      {
         if(this.FMonsterClicked != null)
         {
            TutorialNextStep(param1.RoleTempleteID);
            this.FMonsterClicked(this,param1.RoleTempleteID);
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
      
      protected function MonsterFlashEffectPlayComplete(param1:Event) : void
      {
         this.FMonsterFlashMC.parent.removeChild(this.FMonsterFlashMC);
         this.FMonsterFlashMC.visible = false;
      }
      
      public function set MonsterClicked(param1:Function) : void
      {
         this.FMonsterClicked = param1;
      }
      
      public function set OnBackWorldMap(param1:Function) : void
      {
         this.FOnBackWorldMap = param1;
      }
      
      public function SwitchMonsterMap(param1:int, param2:Vector.<int>, param3:uint, param4:uint, param5:uint = 0) : void
      {
         var _loc6_:uint = 0;
         var _loc7_:int = 0;
         this.LoadMonsterEffectMC();
         this.Release();
         this.FScreenControler.Modify();
         this.FCityVO = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_City,param1) as TCity;
         _loc6_ = uint(this.FCityVO.Icon);
         this.FMapLoadOver = false;
         this.FMapdataLoader.Load(_loc6_,this.LoadMapDataOver);
         this.FMonsterManager.CreateMonster(param2,this.FScreenArean);
         this.FMapSpriteMountPoint.AddSpriteBatch(this.FMonsterManager.Monsters);
         this.FMonsterManager.SetLastMonster(param4,param3 == CONST_BATTLE.BattleType_Camp);
         if(param5 != 0)
         {
            this.FMonsterManager.SetLastShowMonster(param5);
         }
         else
         {
            this.FMonsterManager.SetLastShowMonster(99999999);
         }
         this.FBattleType = param3;
         if(param3 == CONST_BATTLE.BattleType_Camp)
         {
            TutorialNextStep(CONST_FRESHGUIDE.EVENTID_EnterInstanceMonsterMap);
         }
         else
         {
            TutorialNextStep(CONST_FRESHGUIDE.EVENTID_MonsterMapOpen);
         }
         this.UpdateTitle();
      }
      
      public function UIDispatch() : void
      {
         this.ConstructComponent();
         this.FMC_Title = TUtilityReflection.CreateDisplayObjectInstance(CONST_CAMPAIGN.RESOURCE_ClassName_MC_MapTitle) as Sprite;
         this.addChild(this.FMC_Title);
         this.FMC_Title.x = (STAGE_WIDTH - this.FMC_Title.width) / 2;
         this.FMC_Title.y = 0;
         this.FMC_Title.mouseChildren = false;
         this.FMC_Title.mouseEnabled = false;
         this.FTF_MainTitle = this.FMC_Title[CONST_WORLDMAP.RESOURCE_Link_TF_Title];
         this.FTF_MainTitle.mouseEnabled = false;
         this.FTF_MainTitle.text = "";
         this.FInitialization = true;
      }
      
      public function Release() : void
      {
         this.Release_Perform();
         this.FMapDrawer.StopDraw();
         this.FScreenControler.Release();
      }
      
      public function UpdateQuest() : void
      {
         if(this.FMonsterManager != null)
         {
            this.FMonsterManager.UpdateQuest();
         }
      }
      
      public function FlashCurrentQuestMonster(param1:int) : void
      {
         var _loc2_:TSceneSpriteMoudleInMap = null;
         _loc2_ = this.FMonsterManager.GetMonsterByID(param1);
         if(_loc2_ != null)
         {
            _loc2_.addChild(this.FMonsterFlashMC);
            this.FMonsterFlashMC.visible = true;
            this.FMonsterFlashMC.play();
         }
      }
   }
}

