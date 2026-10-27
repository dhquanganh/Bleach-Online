package Processors.Game.Lobby.SkyTower.Components
{
   import Components.Standard.*;
   import Foundation.Common.*;
   import Foundation.Queries.Textures.*;
   import Foundation.Resources.Textures.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.Rooms.Seat.Player.*;
   import Logics.SkyTower.TTower;
   import Processors.Game.Lobby.Components.*;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Resources.Constants.*;
   import Resources.Strings.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class TUITower extends TUIComponent
   {
      
      protected static const FRAME_Enabled:uint = 1;
      
      protected static const FRAME_UnEnabled:uint = 2;
      
      protected var FTF_Level:TextField;
      
      protected var FTF_Name:TextField;
      
      protected var FMC_Name:MovieClip;
      
      protected var FBtn_EnterPve:TUIButton;
      
      protected var FSP_Lock:Sprite;
      
      protected var FMC_Effect:MovieClip;
      
      protected var FSP_Top:Sprite;
      
      protected var FResource:MovieClip;
      
      protected var FContext:TTower;
      
      protected var FOnEnterPve:Function;
      
      public function TUITower(param1:TUIComponent)
      {
         super(param1);
      }
      
      protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Sprite = null;
         var _loc3_:Sprite = null;
         if(this.FResource == null)
         {
            return;
         }
         this.FResource.mouseEnabled = false;
         this.FSP_Top = this.FResource[CONST_SKYTOWER.RESOURCE_Link_SP_Tower_Top];
         this.FMC_Effect = this.FResource[CONST_SKYTOWER.RESOURCE_Link_MC_Tower_Effect];
         this.FMC_Name = this.FResource[CONST_SKYTOWER.RESOURCE_Link_MC_TowerIDs];
         _loc2_ = this.FResource[CONST_SKYTOWER.RESOURCE_Link_SP_TowerInfo];
         _loc2_.mouseEnabled = false;
         _loc3_ = _loc2_[CONST_SKYTOWER.RESOURCE_Link_SP_TowerTitle];
         this.FTF_Name = _loc3_[CONST_SKYTOWER.RESOURCE_Link_TF_TowerTitle_01];
         this.FTF_Level = _loc3_[CONST_SKYTOWER.RESOURCE_Link_TF_TowerTitle_02];
         this.FSP_Lock = _loc2_[CONST_SKYTOWER.RESOURCE_Link_SP_Lock];
         this.FBtn_EnterPve = new TUIButton();
         this.FBtn_EnterPve.Substrate = _loc2_[CONST_SKYTOWER.RESOURCE_Link_Btn_Pve];
         this.Reset();
      }
      
      protected function addEventListenerPlayer() : void
      {
         if(this.FResource == null)
         {
            return;
         }
         this.FBtn_EnterPve.OnClick = this.Btn_EnterPveOnClick;
      }
      
      protected function RemoveEventListenerPlayer() : void
      {
         if(this.FResource == null)
         {
            return;
         }
         this.FBtn_EnterPve.OnClick = null;
      }
      
      protected function UpdateUITower() : void
      {
         var _loc1_:MovieClip = null;
         var _loc2_:uint = 0;
         if(this.FResource == null)
         {
            return;
         }
         if(this.FContext.Tag % 4 == 0 || this.FContext.Tag == CONST_SKYTOWER.CAPACITY_TOWERS)
         {
            this.FSP_Top.visible = true;
            this.FMC_Effect.play();
            this.FMC_Effect.visible = true;
         }
         if(this.Tag == 0 && this.FContext.IsUnlock || this.FContext.Identifier == this.Tag)
         {
            this.FResource.gotoAndStop(FRAME_Enabled);
            this.FBtn_EnterPve.Visible = true;
            this.FSP_Lock.visible = false;
         }
         this.FMC_Name.gotoAndStop(this.FContext.Tag % CONST_SKYTOWER.CAPACITY_TOWERS);
         if(this.FContext.Tag == CONST_SKYTOWER.CAPACITY_TOWERS)
         {
            this.FMC_Name.gotoAndStop(this.FContext.Tag);
         }
         this.FTF_Name.text = this.FContext.Name;
         this.FTF_Level.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_SkyTower_01),this.FContext.OpenLevel);
      }
      
      protected function Btn_EnterPveOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FOnEnterPve != null)
         {
            this.FOnEnterPve(this,this.FContext);
         }
      }
      
      public function get Resource() : MovieClip
      {
         return this.FResource;
      }
      
      public function set Resource(param1:MovieClip) : void
      {
         this.FResource = param1;
      }
      
      public function get Context() : TTower
      {
         return this.FContext;
      }
      
      public function set Context(param1:TTower) : void
      {
         this.Reset();
         if(this.FContext == null && param1 != null)
         {
            this.addEventListenerPlayer();
         }
         else if(param1 == null)
         {
            this.RemoveEventListenerPlayer();
         }
         this.FContext = param1;
         if(param1 != null)
         {
            this.UpdateUITower();
         }
      }
      
      public function get OnEnterPve() : Function
      {
         return this.FOnEnterPve;
      }
      
      public function set OnEnterPve(param1:Function) : void
      {
         this.FOnEnterPve = param1;
      }
      
      override public function set Visible(param1:Boolean) : void
      {
         super.Visible = param1;
         if(this.FResource != null)
         {
            this.FResource.visible = param1;
         }
      }
      
      public function Perform_UIDispatch() : void
      {
         this.ResourcesPerform_UIDispatch();
      }
      
      override public function Dispose() : void
      {
         this.FBtn_EnterPve.Dispose();
         this.FBtn_EnterPve = null;
         this.FTF_Level = null;
         this.FTF_Name = null;
         this.FMC_Name.stop();
         this.FMC_Name = null;
         this.FSP_Lock = null;
         this.FMC_Effect.stop();
         this.FMC_Effect = null;
         this.FSP_Top = null;
         this.FResource.stop();
         this.FResource = null;
         this.FContext = null;
         this.FOnEnterPve = null;
         if(this.Parent != null)
         {
            this.Parent.removeChild(this);
         }
      }
      
      public function Reset() : void
      {
         this.FResource.gotoAndStop(FRAME_UnEnabled);
         this.FMC_Name.stop();
         this.FMC_Effect.stop();
         this.FMC_Effect.visible = false;
         this.FSP_Top.visible = false;
         this.FSP_Lock.visible = true;
         this.FBtn_EnterPve.Visible = false;
      }
   }
}

