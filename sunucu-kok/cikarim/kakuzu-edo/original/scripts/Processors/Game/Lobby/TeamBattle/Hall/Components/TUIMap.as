package Processors.Game.Lobby.TeamBattle.Hall.Components
{
   import Foundation.Resources.*;
   import Foundation.Resources.Textures.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.TeamBattle.*;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Resources.Constants.*;
   import Resources.Strings.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class TUIMap extends TUIComponent
   {
      
      protected var FTeamBattle:TTeamBattle;
      
      protected var FTF_Title:TextField;
      
      protected var FTF_Level:TextField;
      
      protected var FSP_UnlockLevel:Sprite;
      
      protected var FMC_HighLight:MovieClip;
      
      protected var FSP_ImagePoint:Sprite;
      
      protected var FBmpIcon:Bitmap;
      
      protected var FResource:MovieClip;
      
      protected var FContext:TLeagueMapPve;
      
      protected var FOnClick:Function;
      
      protected var FOnOver:Function;
      
      protected var FOnOut:Function;
      
      public function TUIMap(param1:TUIComponent)
      {
         super(param1);
         this.FTeamBattle = SLogicsCore.TeamBattle;
      }
      
      protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:Sprite = null;
         this.FResource.mouseChildren = false;
         _loc1_ = this.FResource[CONST_TEAMBATTLE.RESOURCE_Link_SP_TitlePVE];
         this.FTF_Title = _loc1_[CONST_TEAMBATTLE.RESOURCE_Link_TF_Title];
         this.FTF_Level = _loc1_[CONST_TEAMBATTLE.RESOURCE_Link_TF_Level];
         this.FSP_UnlockLevel = this.FResource[CONST_TEAMBATTLE.RESOURCE_Link_SP_UnlockLevel];
         this.FMC_HighLight = this.FResource[CONST_TEAMBATTLE.RESOURCE_Link_MC_HighLight];
         this.FSP_ImagePoint = this.FResource[CONST_TEAMBATTLE.RESOURCE_Link_SP_ImagePoint];
         this.FBmpIcon = new Bitmap();
         this.FSP_ImagePoint.addChild(this.FBmpIcon);
         this.Reset();
      }
      
      protected function addEventListenerMap() : void
      {
         this.FResource.mouseEnabled = true;
         this.FResource.addEventListener(MouseEvent.CLICK,this.MapOnClick,false,0,true);
         this.FResource.addEventListener(MouseEvent.MOUSE_MOVE,this.MapOnOver,false,0,true);
         this.FResource.addEventListener(MouseEvent.MOUSE_OUT,this.MapOnOut,false,0,true);
      }
      
      protected function RemoveEventListenerMap() : void
      {
         this.FResource.mouseEnabled = false;
         this.FResource.removeEventListener(MouseEvent.CLICK,this.MapOnClick);
         this.FResource.removeEventListener(MouseEvent.MOUSE_MOVE,this.MapOnOver);
         this.FResource.removeEventListener(MouseEvent.MOUSE_OUT,this.MapOnOut);
      }
      
      protected function UpdateUIMap() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:TModel = null;
         _loc2_ = uint(this.FContext.Identifier);
         if(_loc2_ % 2 == 0)
         {
            _loc1_ = CONST_TEAMBATTLE.COLOR_PVE_HARD;
         }
         else
         {
            _loc1_ = CONST_TEAMBATTLE.COLOR_PVE_NORMAL;
         }
         this.FTF_Title.text = this.FContext.Name;
         this.FTF_Title.textColor = _loc1_;
         this.FTF_Level.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TeamBattle_String_10),this.FContext.SuitableLevel);
         _loc3_ = this.FTeamBattle.PVEModels.GetModelByIdentifier(_loc2_);
         if(_loc2_ > this.FTeamBattle.CurPveModelID || !_loc3_.IsUnlock)
         {
            this.FSP_UnlockLevel.visible = true;
            this.FResource.buttonMode = false;
         }
         else
         {
            this.FSP_UnlockLevel.visible = false;
            this.FResource.buttonMode = true;
         }
         this.FMC_HighLight.gotoAndStop(1);
         this.FMC_HighLight.visible = true;
         SResourcesCore.TexturesMiddlePic.LoadAutoSecondary(this.FContext.ImageID,this.AutoLoadCallBack);
      }
      
      protected function AutoLoadCallBack(param1:Object, param2:TTexture, param3:uint) : void
      {
         var _loc4_:TAnimationSequence = null;
         _loc4_ = param2.GetAnimationSequenceByIndex(0);
         this.FBmpIcon.bitmapData = _loc4_.GetAnimationFrameByIndex(0).Surface;
      }
      
      protected function MapOnClick(param1:MouseEvent) : void
      {
         var _loc2_:TModel = null;
         _loc2_ = this.FTeamBattle.PVEModels.GetModelByIdentifier(this.FContext.Identifier);
         if(this.FContext.Identifier > this.FTeamBattle.CurPveModelID || !_loc2_.IsUnlock)
         {
            return;
         }
         if(this.FOnClick != null)
         {
            this.FOnClick(this,this.FContext);
         }
         this.FMC_HighLight.play();
      }
      
      protected function MapOnOver(param1:MouseEvent) : void
      {
         if(this.FOnOver != null)
         {
            this.FOnOver(this,this.FContext);
         }
      }
      
      protected function MapOnOut(param1:MouseEvent) : void
      {
         if(this.FOnOut != null)
         {
            this.FOnOut(this,this.FContext);
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
      
      public function get Context() : TLeagueMapPve
      {
         return this.FContext;
      }
      
      public function set Context(param1:TLeagueMapPve) : void
      {
         this.Reset();
         if(this.FContext == null && param1 != null)
         {
            this.addEventListenerMap();
         }
         else if(param1 == null)
         {
            this.RemoveEventListenerMap();
         }
         this.FContext = param1;
         if(param1 != null)
         {
            this.UpdateUIMap();
         }
      }
      
      override public function set Visible(param1:Boolean) : void
      {
         super.Visible = param1;
         if(this.FResource != null)
         {
            this.FResource.visible = param1;
         }
      }
      
      public function get OnClick() : Function
      {
         return this.FOnClick;
      }
      
      public function set OnClick(param1:Function) : void
      {
         this.FOnClick = param1;
      }
      
      public function get OnOver() : Function
      {
         return this.FOnOver;
      }
      
      public function set OnOver(param1:Function) : void
      {
         this.FOnOver = param1;
      }
      
      public function get OnOut() : Function
      {
         return this.FOnOut;
      }
      
      public function set OnOut(param1:Function) : void
      {
         this.FOnOut = param1;
      }
      
      public function Perform_UIDispatch() : void
      {
         this.ResourcesPerform_UIDispatch();
      }
      
      public function ShowHighLight() : void
      {
         if(this.FMC_HighLight != null)
         {
            this.FMC_HighLight.play();
         }
      }
      
      public function HideHighLight() : void
      {
         if(this.FMC_HighLight != null)
         {
            this.FMC_HighLight.gotoAndStop(1);
         }
      }
      
      public function Reset() : void
      {
         this.FTF_Title.text = "";
         this.FTF_Level.text = "";
         this.FSP_UnlockLevel.visible = false;
         this.FResource.buttonMode = false;
         this.FResource.mouseEnabled = false;
         this.FMC_HighLight.visible = false;
         if(this.FBmpIcon != null && this.FBmpIcon.bitmapData != null)
         {
            this.FBmpIcon.bitmapData = null;
         }
      }
   }
}

