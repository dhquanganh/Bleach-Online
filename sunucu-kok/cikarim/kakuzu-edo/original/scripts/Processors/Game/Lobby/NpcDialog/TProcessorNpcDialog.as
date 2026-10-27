package Processors.Game.Lobby.NpcDialog
{
   import Components.Slots.*;
   import Foundation.Common.*;
   import Foundation.Queries.Coordinate.*;
   import Foundation.Resources.*;
   import Foundation.Timing.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.Inventories.*;
   import Logics.Quests.*;
   import Processors.Game.Common.Effects.Texts.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Common.Map.SceneSprite.*;
   import Processors.Game.Lobby.Jade.*;
   import Processors.Game.Lobby.MainScene.Role.*;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Rendering.Overlayers.*;
   import Rendering.Overlayers.Inventories.*;
   import Resources.Constants.*;
   import Resources.Strings.*;
   import Utilities.UI.Overlayers.*;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.text.*;
   import flash.utils.*;
   
   public class TProcessorNpcDialog extends TProcessorLobbyWindows
   {
      
      protected static const MOTHERBOARD_HEIGHT:int = 273;
      
      protected static const MOTHERBOARD_WIDTH:int = 736;
      
      protected static const SHORTCUTNUM:uint = 5;
      
      protected static const SLOTNUM:uint = 6;
      
      protected static const Type_LargeIcon:int = 4;
      
      public static const CATEGORY_Equipment:uint = CONST_INVENTORY.CATEGORY_Equipment;
      
      public static const CATEGORY_Treasure:uint = CONST_INVENTORY.CATEGORY_Treasure;
      
      protected var FSence:Sprite;
      
      protected var FEffectCoordinateParameters:TEffectCoordinateParameters;
      
      protected var FQueryCoordinate:TQueryCoordinate;
      
      protected var FProcessorWindowNpc:TProcessorWindowNpc;
      
      protected var Bounds:TBounds;
      
      protected var FUINpc:TSceneSpriteMoudleInMapNpc;
      
      protected var FOpenNpcUserTypeWindow:Function;
      
      protected var FOnEffectAcquireInventory:Function;
      
      protected var FOnQueryShortcutCoordinate:Function;
      
      protected var FOpenDialog:Function;
      
      protected var FPlayingPlot:Boolean;
      
      public function TProcessorNpcDialog(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,param2);
         this.ConstructEffectParameters();
         this.FQueryCoordinate = new TQueryCoordinate();
         this.FProcessorWindowNpc = new TProcessorWindowNpc(this);
         this.FProcessorWindowNpc.SlotOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FProcessorWindowNpc.SlotOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FProcessorWindowNpc.OpenDialog = this.OnOpenDialogRequest;
      }
      
      protected function ConstructEffectParameters() : void
      {
         this.FEffectCoordinateParameters = new TEffectCoordinateParameters();
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(301989889);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:MovieClip = null;
         _loc1_ = TUtilityReflection.CreateDisplayObjectInstance("NewNPC_Dialog") as MovieClip;
         this.FProcessorWindowNpc.UIDispath(_loc1_);
         this.FProcessorWindowNpc.x = (CONST_COMMON.STAGE_Width - this.FProcessorWindowNpc.width) / 2;
         this.FProcessorWindowNpc.y = (CONST_COMMON.STAGE_Height - this.FProcessorWindowNpc.height) / 2;
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         this.FProcessorWindowNpc.UILocation();
         super.ResourcesPerform_UILocations();
      }
      
      protected function ProcessorEffectAcquireInventory(param1:Vector.<TUISlot>) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:uint = 0;
         var _loc5_:TUISlot = null;
         var _loc6_:Object = null;
         var _loc7_:TInventory = null;
         var _loc8_:TCoordinate = null;
         _loc3_ = int(param1.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc5_ = param1[_loc2_];
            _loc6_ = _loc5_.Context;
            if(_loc6_ == null)
            {
               break;
            }
            _loc7_ = _loc6_ as TInventory;
            switch(_loc7_.Category)
            {
               case CONST_INVENTORY.CATEGORY_Normal:
                  switch(_loc7_.CategorySecond)
                  {
                     case 300:
                        _loc4_ = CONST_SHORTCUTS.TYPE_MainFunction_TacticalDeployment;
                        break;
                     default:
                        _loc4_ = CONST_SHORTCUTS.TYPE_MainFunction_Backpack;
                  }
                  break;
               default:
                  _loc4_ = CONST_SHORTCUTS.TYPE_MainFunction_Backpack;
            }
            if(this.FOnQueryShortcutCoordinate != null)
            {
               this.FOnQueryShortcutCoordinate(this,_loc4_,this.FQueryCoordinate);
            }
            _loc8_ = TUtilityCartisian.GetScreenCoordinateByDisplayObject(_loc5_.Resource);
            _loc8_.X += 4;
            _loc8_.Y += 4;
            this.FEffectCoordinateParameters.CoordinateSource.Assign(_loc8_);
            this.FEffectCoordinateParameters.CoordinateDestination.Assign(this.FQueryCoordinate.Value);
            if(this.FOnEffectAcquireInventory != null)
            {
               this.FOnEffectAcquireInventory(this,_loc6_,this.FEffectCoordinateParameters);
            }
            _loc2_++;
         }
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
      }
      
      protected function QuestShortcutClicked(param1:MouseEvent) : void
      {
      }
      
      protected function ShortcutBackClick(param1:MouseEvent) : void
      {
         ProcessorClose();
      }
      
      protected function OnOpenDialogRequest(param1:TSceneSpriteMoudleInMapNpc) : void
      {
         if(!this.FPlayingPlot)
         {
            if(this.FOpenDialog != null)
            {
               this.FOpenDialog(param1);
            }
         }
      }
      
      override public function set OnClose(param1:Function) : void
      {
         super.OnClose = param1;
         this.FProcessorWindowNpc.OnClose = param1;
      }
      
      public function set UINpc(param1:TSceneSpriteMoudleInMapNpc) : void
      {
         this.FUINpc = param1;
      }
      
      public function set OpenNpcUserTypeWindow(param1:Function) : void
      {
         this.FOpenNpcUserTypeWindow = param1;
         this.FProcessorWindowNpc.ClickUserType = param1;
      }
      
      public function set OnEffectAcquireInventory(param1:Function) : void
      {
         this.FProcessorWindowNpc.OnEffectAcquireInventory = param1;
      }
      
      public function set OnQueryShortcutCoordinate(param1:Function) : void
      {
         this.FProcessorWindowNpc.OnQueryShortcutCoordinate = param1;
      }
      
      public function set OpenDialog(param1:Function) : void
      {
         this.FOpenDialog = param1;
      }
      
      override public function Mount(param1:ByteArray = null) : void
      {
         super.Mount(param1);
         if(!FIsResourcesLoadCompleted)
         {
            return;
         }
         this.FProcessorWindowNpc.ShowByNpc(this.FUINpc);
         if(this.FUINpc.Questes.Count != 0)
         {
            TutorialNextStep(CONST_FRESHGUIDE.EVENTID_OpenNpcDialog);
         }
         if(this.FUINpc.UserType == CONST_NPC.NPC_FUNCTION_PUB)
         {
            TutorialNextStep(CONST_FRESHGUIDE.EVENTID_OpenTavernNpc);
         }
         this.FProcessorWindowNpc.Visible = true;
      }
      
      override public function Unmount() : void
      {
         super.Unmount();
         this.FProcessorWindowNpc.Visible = false;
         TutorialNextStep(CONST_FRESHGUIDE.EVENTID_CloseNpcDialog);
         this.FProcessorWindowNpc.Reset();
      }
      
      public function QuestUpdate() : void
      {
         this.FProcessorWindowNpc.UpdateQuest();
      }
      
      public function PlotNotify(param1:Boolean) : void
      {
         this.FPlayingPlot = param1;
         if(this.FProcessorWindowNpc.visible)
         {
            this.visible = !param1;
         }
      }
   }
}

