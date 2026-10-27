package Processors.Game.Lobby.TeamBattle
{
   import Foundation.Common.*;
   import Foundation.Common.Integer.*;
   import Foundation.Resources.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.Characters.*;
   import Processors.Game.Common.Effects.Display.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Components.TUICredits;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Resources.Constants.*;
   import Resources.Strings.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class TProcessorWindowTeamBattle extends TProcessorLobbyWindow
   {
      
      protected var FCharacter:TCharacter;
      
      protected var FHint:THint;
      
      protected var FSP_TeamBattle:Sprite;
      
      protected var FSP_OnOff:Sprite;
      
      protected var FBtn_Close:SimpleButton;
      
      protected var FUICredits:TUICredits;
      
      protected var FInitialization:Boolean;
      
      public function TProcessorWindowTeamBattle(param1:TUIComponent)
      {
         super(param1);
         this.FHint = new THint();
         this.FCharacter = SLogicsCore.Character;
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_TEAMBATTLE.RESOURCESID_Swf_TeamBattle);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:int = 0;
         var _loc2_:MovieClip = null;
         this.FSP_TeamBattle = TUtilityReflection.CreateDisplayObjectInstance(CONST_TEAMBATTLE.RESOURCE_ClassName_SP_TeamBattle) as Sprite;
         addChild(this.FSP_TeamBattle);
         this.FSP_OnOff = this.FSP_TeamBattle[CONST_TEAMBATTLE.RESOURCE_Link_SP_OnOff];
         this.FBtn_Close = this.FSP_OnOff[CONST_COMMON.RESOURCE_Link_Btn_Close];
         this.FBtn_Close.tabEnabled = false;
         this.FUICredits = new TUICredits();
         this.FUICredits.Resource = this.FSP_TeamBattle[CONST_TEAMBATTLE.RESOURCE_Link_SP_PanelCredits];
         this.FUICredits.HintOnMove = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FUICredits.HintOnOut = SUtilityOverLayer.UIComponentsHintOnOut;
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         this.FBtn_Close.addEventListener(MouseEvent.CLICK,this.ButtonCloseOnClick,false,0,true);
         this.FInitialization = true;
         super.ResourcesPerform_UILocations();
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(this.Visible)
         {
            if(this.FInitialization)
            {
               this.FUICredits.UpdateEffect();
            }
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
         this.FSP_OnOff.x = _loc1_ - this.FSP_OnOff.width;
      }
      
      protected function ButtonCloseOnClick(param1:MouseEvent) : void
      {
         ProcessorWindowClose();
      }
      
      public function Reset() : void
      {
         if(!this.FInitialization)
         {
            return;
         }
      }
      
      public function Update() : void
      {
         this.ProcessorResize();
         this.FUICredits.UpdatePanel();
      }
   }
}

