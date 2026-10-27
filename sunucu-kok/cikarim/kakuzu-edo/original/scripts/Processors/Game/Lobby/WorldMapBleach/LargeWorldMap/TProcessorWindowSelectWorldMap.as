package Processors.Game.Lobby.WorldMapBleach.LargeWorldMap
{
   import Foundation.Resources.Bins.TBins;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TGameUtil;
   import Foundation.Utilities.TUtilityReflection;
   import Logics.Characters.TCharacter;
   import Logics.DatebaseVO.VO.TMap;
   import Logics.SLogicsCore;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import Resources.Constants.CONST_COMMON;
   import Resources.Constants.CONST_DATEBASEVO;
   import Resources.Constants.CONST_WORLDMAP;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   
   public class TProcessorWindowSelectWorldMap extends TProcessorLobbyWindow
   {
      
      protected static const MAPTYPE_Human:uint = CONST_WORLDMAP.MAPTYPE_Human;
      
      protected static const MAPTYPE_HuecoMundo:uint = CONST_WORLDMAP.MAPTYPE_HuecoMundo;
      
      protected static const MAPTYPE_Soul:uint = CONST_WORLDMAP.MAPTYPE_Soul;
      
      protected static const MAX_MAP_COUNT:uint = 3;
      
      protected static const MAX_Wheel_COUNT:uint = 5;
      
      protected var FMC:MovieClip;
      
      protected var FBtn_GotoHumanWorld:MovieClip;
      
      protected var FBtn_GotoSoulWorld:MovieClip;
      
      protected var FBtn_GotoHuecoMundoWorld:MovieClip;
      
      protected var FBtn_Close:SimpleButton;
      
      protected var FMapBins:TBins;
      
      protected var FMC_Wheel:String;
      
      protected var FMCWheelVect:Vector.<MovieClip>;
      
      protected var FMapType:uint;
      
      protected var FCharacter:TCharacter;
      
      protected var FIsInit:Boolean;
      
      protected var FOnWorldMapEnter:Function;
      
      protected var FOnReturnHome:Function;
      
      public function TProcessorWindowSelectWorldMap(param1:TUIComponent)
      {
         super(param1);
         this.FMapType = 1;
         this.FCharacter = SLogicsCore.Character;
         this.FIsInit = false;
         this.FMCWheelVect = new Vector.<MovieClip>();
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
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:MovieClip = null;
         this.FMC = TUtilityReflection.CreateDisplayObjectInstance(CONST_WORLDMAP.RESOURCE_ClassName_SelectWorldMap) as MovieClip;
         addChild(this.FMC);
         this.FBtn_Close = this.FMC[CONST_COMMON.RESOURCE_Link_Btn_Close];
         this.FBtn_GotoHumanWorld = this.FMC[CONST_WORLDMAP.RESOURCE_Link_Btn_GotoHumanWorld];
         this.FBtn_GotoSoulWorld = this.FMC[CONST_WORLDMAP.RESOURCE_Link_Btn_GotoSoulWorld];
         this.FBtn_GotoHuecoMundoWorld = this.FMC[CONST_WORLDMAP.RESOURCE_Link_Btn_GotoHuecoMundoWorld];
         this.FMC_Wheel = CONST_WORLDMAP.RESOURCE_Link_MC_Wheel;
         _loc1_ = int(MAX_Wheel_COUNT);
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = this.FMC[this.FMC_Wheel + _loc2_];
            _loc3_.gotoAndPlay(1);
            this.FMCWheelVect[_loc2_] = _loc3_;
            _loc2_++;
         }
         this.FBtn_GotoHumanWorld.addEventListener(MouseEvent.CLICK,this.OnGotoWorldMap,false,0,true);
         this.FBtn_GotoHuecoMundoWorld.addEventListener(MouseEvent.CLICK,this.OnGotoWorldMap,false,0,true);
         this.FBtn_GotoSoulWorld.addEventListener(MouseEvent.CLICK,this.OnGotoWorldMap,false,0,true);
         this.FBtn_Close.addEventListener(MouseEvent.CLICK,this.OnWindowClose,false,0,true);
         this.FIsInit = true;
         super.ResourcesPerform_UIDispatch();
      }
      
      protected function CheckBtnStatus() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TMap = null;
         var _loc4_:int = 0;
         if(this.FMapBins == null)
         {
            this.FMapBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_Map);
         }
         _loc2_ = int(MAX_MAP_COUNT);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FMapBins.GetDatebaseByIndex(_loc1_) as TMap;
            _loc4_ = _loc3_.OpenTask;
            if(_loc3_.Type == MAPTYPE_Human)
            {
               if(_loc4_ == 0 || this.FCharacter.MainQuestComplete.GetQuestByIdentifier(_loc4_) != null)
               {
                  TGameUtil.setButtonMode(this.FBtn_GotoHumanWorld,true);
               }
               else
               {
                  TGameUtil.setButtonMode(this.FBtn_GotoHumanWorld,false);
               }
            }
            else if(_loc3_.Type == MAPTYPE_Soul)
            {
               if(_loc4_ == 0 || this.FCharacter.MainQuestComplete.GetQuestByIdentifier(_loc4_) != null)
               {
                  TGameUtil.setButtonMode(this.FBtn_GotoSoulWorld,true);
               }
               else
               {
                  TGameUtil.setButtonMode(this.FBtn_GotoSoulWorld,false);
               }
            }
            else if(_loc3_.Type == MAPTYPE_HuecoMundo)
            {
               if(_loc4_ == 0 || this.FCharacter.MainQuestComplete.GetQuestByIdentifier(_loc4_) != null)
               {
                  TGameUtil.setButtonMode(this.FBtn_GotoHuecoMundoWorld,true);
               }
               else
               {
                  TGameUtil.setButtonMode(this.FBtn_GotoHuecoMundoWorld,false);
               }
            }
            _loc1_++;
         }
      }
      
      protected function OnGotoWorldMap(param1:MouseEvent) : void
      {
         var _loc2_:String = null;
         if(Boolean(param1.currentTarget) && param1.currentTarget.buttonMode == false)
         {
            return;
         }
         _loc2_ = param1.currentTarget.name;
         switch(_loc2_)
         {
            case CONST_WORLDMAP.RESOURCE_Link_Btn_GotoHumanWorld:
               this.FMapType = MAPTYPE_Human;
               break;
            case CONST_WORLDMAP.RESOURCE_Link_Btn_GotoSoulWorld:
               this.FMapType = MAPTYPE_Soul;
               break;
            case CONST_WORLDMAP.RESOURCE_Link_Btn_GotoHuecoMundoWorld:
               this.FMapType = MAPTYPE_HuecoMundo;
         }
         if(this.FOnWorldMapEnter != null)
         {
            this.FOnWorldMapEnter(this.FMapType);
         }
      }
      
      protected function ProcessorWheelPlayMc(param1:Boolean) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         _loc2_ = int(MAX_Wheel_COUNT);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            if(param1)
            {
               this.FMCWheelVect[_loc3_].play();
            }
            else
            {
               this.FMCWheelVect[_loc3_].stop();
            }
            _loc3_++;
         }
      }
      
      protected function OnWindowClose(param1:MouseEvent) : void
      {
         if(this.FOnReturnHome != null)
         {
            this.FOnReturnHome(this);
         }
      }
      
      override public function get Visible() : Boolean
      {
         return super.Visible;
      }
      
      override public function set Visible(param1:Boolean) : void
      {
         super.Visible = param1;
         if(param1 == true && this.FIsInit)
         {
            this.CheckBtnStatus();
         }
         if(this.FMCWheelVect != null && this.FMCWheelVect.length > 0)
         {
            this.ProcessorWheelPlayMc(param1);
         }
      }
      
      public function get OnWorldMapEnter() : Function
      {
         return this.FOnWorldMapEnter;
      }
      
      public function set OnWorldMapEnter(param1:Function) : void
      {
         this.FOnWorldMapEnter = param1;
      }
      
      public function get OnReturnHome() : Function
      {
         return this.FOnReturnHome;
      }
      
      public function set OnReturnHome(param1:Function) : void
      {
         this.FOnReturnHome = param1;
      }
      
      public function Reset() : void
      {
         var _loc1_:int = 0;
         if(this.FMCWheelVect != null)
         {
            _loc1_ = 0;
            while(_loc1_ < this.FMCWheelVect.length)
            {
               this.FMCWheelVect[_loc1_].stop();
               _loc1_++;
            }
         }
      }
   }
}

