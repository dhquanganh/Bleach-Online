package Processors.Game.Lobby.TeamBattle.Hall.Components
{
   import Foundation.Resources.*;
   import Foundation.Resources.Textures.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.Rooms.*;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Resources.Constants.*;
   import Resources.Strings.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class TUIRoom extends TUIComponent
   {
      
      public static const STRING_Capacity:String = CONST_COMMON.STRING_Capacity;
      
      protected static const FRAME_PVE_Normal:uint = CONST_TEAMBATTLE.FRAME_PVE_Normal;
      
      protected static const FRAME_PVE_Hard:uint = CONST_TEAMBATTLE.FRAME_PVE_Hard;
      
      protected static const FRAME_PVP:uint = CONST_TEAMBATTLE.FRAME_PVP;
      
      protected static const MODE_TEAMBATTLE_PVP:uint = CONST_TEAMBATTLE.MODE_TEAMBATTLE_PVP;
      
      protected static const MODE_TEAMBATTLE_PVE:uint = CONST_TEAMBATTLE.MODE_TEAMBATTLE_PVE;
      
      protected var FTF_RoomID:TextField;
      
      protected var FSP_Password:Sprite;
      
      protected var FTF_Caption:TextField;
      
      protected var FTF_SuitableLevel:TextField;
      
      protected var FSP_Fighting:Sprite;
      
      protected var FTF_RoomName:TextField;
      
      protected var FTF_RoomCapacity:TextField;
      
      protected var FMC_HighLight:MovieClip;
      
      protected var FSP_ImagePoint:Sprite;
      
      protected var FBmpIcon:Bitmap;
      
      protected var FResource:MovieClip;
      
      protected var FContext:TRoomDigest;
      
      protected var FOnClick:Function;
      
      public function TUIRoom(param1:TUIComponent)
      {
         super(param1);
      }
      
      protected function ResourcesPerform_UIDispatch() : void
      {
         this.FResource.mouseChildren = false;
         this.FResource.buttonMode = true;
         this.FTF_RoomID = this.FResource[CONST_TEAMBATTLE.RESOURCE_Link_TF_RoomID];
         this.FSP_Password = this.FResource[CONST_TEAMBATTLE.RESOURCE_Link_SP_Password];
         this.FTF_Caption = this.FResource[CONST_TEAMBATTLE.RESOURCE_Link_TF_Caption];
         this.FTF_SuitableLevel = this.FResource[CONST_TEAMBATTLE.RESOURCE_Link_TF_OpenLevel];
         this.FSP_Fighting = this.FResource[CONST_TEAMBATTLE.RESOURCE_Link_SP_Fighting];
         this.FTF_RoomName = this.FResource[CONST_TEAMBATTLE.RESOURCE_Link_TF_RoomName];
         this.FTF_RoomCapacity = this.FResource[CONST_TEAMBATTLE.RESOURCE_Link_TF_RoomCapacity];
         this.FMC_HighLight = this.FResource[CONST_TEAMBATTLE.RESOURCE_Link_MC_HighLight];
         this.FSP_ImagePoint = this.FResource[CONST_TEAMBATTLE.RESOURCE_Link_SP_ImagePoint];
         this.FBmpIcon = new Bitmap();
         this.FSP_ImagePoint.addChild(this.FBmpIcon);
      }
      
      protected function addEventListenerRoom() : void
      {
         this.FResource.mouseEnabled = true;
         this.FResource.addEventListener(MouseEvent.CLICK,this.RoomOnClick,false,0,true);
         this.FResource.addEventListener(MouseEvent.MOUSE_OVER,this.RoomOnOver,false,0,true);
         this.FResource.addEventListener(MouseEvent.MOUSE_OUT,this.RoomOnOut,false,0,true);
      }
      
      protected function RemoveEventListenerRoom() : void
      {
         this.FResource.mouseEnabled = false;
         this.FResource.removeEventListener(MouseEvent.CLICK,this.RoomOnClick);
         this.FResource.removeEventListener(MouseEvent.MOUSE_OVER,this.RoomOnOver);
         this.FResource.removeEventListener(MouseEvent.MOUSE_OUT,this.RoomOnOut);
      }
      
      protected function UpdateUIRoom() : void
      {
         this.FTF_RoomID.text = this.FContext.Identifier.toString();
         this.FSP_Password.visible = this.FContext.Passworded;
         this.FSP_Fighting.visible = this.FContext.IsFighting;
         this.FTF_RoomName.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TeamBattle_String_17),this.FContext.Name);
         this.FTF_RoomCapacity.text = TUtilityString.Format(STRING_Capacity,this.FContext.PlayerCount,this.FContext.PlayerCapacity);
         if(this.FContext.ModeType == MODE_TEAMBATTLE_PVE)
         {
            if(this.FContext.ModelID % 2 == 0)
            {
               this.FResource.gotoAndStop(FRAME_PVE_Hard);
            }
            else
            {
               this.FResource.gotoAndStop(FRAME_PVE_Normal);
            }
            this.FTF_Caption.text = this.FContext.ModelName;
            this.FTF_SuitableLevel.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TeamBattle_String_10),this.FContext.SuitableLevel);
         }
         else if(this.FContext.ModeType == MODE_TEAMBATTLE_PVP)
         {
            this.FResource.gotoAndStop(FRAME_PVP);
            this.FTF_Caption.text = this.FContext.ModelName;
            this.FTF_SuitableLevel.text = "";
         }
         this.FMC_HighLight.gotoAndStop(1);
         this.FMC_HighLight.visible = true;
         SResourcesCore.TexturesMiddlePic.LoadAutoSecondary(this.FContext.ResourceID,this.AutoLoadCallBack);
      }
      
      protected function AutoLoadCallBack(param1:Object, param2:TTexture, param3:uint) : void
      {
         var _loc4_:TAnimationSequence = null;
         _loc4_ = param2.GetAnimationSequenceByIndex(0);
         this.FBmpIcon.bitmapData = _loc4_.GetAnimationFrameByIndex(0).Surface;
      }
      
      protected function RoomOnClick(param1:MouseEvent) : void
      {
         if(this.FOnClick != null)
         {
            this.FOnClick(this,this.FContext);
         }
      }
      
      protected function RoomOnOver(param1:MouseEvent) : void
      {
         this.FMC_HighLight.play();
      }
      
      protected function RoomOnOut(param1:MouseEvent) : void
      {
         this.FMC_HighLight.gotoAndStop(1);
      }
      
      public function get Resource() : MovieClip
      {
         return this.FResource;
      }
      
      public function set Resource(param1:MovieClip) : void
      {
         this.FResource = param1;
      }
      
      public function get Context() : TRoomDigest
      {
         return this.FContext;
      }
      
      public function set Context(param1:TRoomDigest) : void
      {
         this.Reset();
         if(this.FContext == null && param1 != null)
         {
            this.addEventListenerRoom();
         }
         else if(param1 == null)
         {
            this.RemoveEventListenerRoom();
         }
         this.FContext = param1;
         if(param1 != null)
         {
            this.UpdateUIRoom();
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
      
      public function Reset() : void
      {
         this.FTF_RoomID.text = "";
         this.FTF_Caption.text = "";
         this.FTF_SuitableLevel.text = "";
         this.FTF_RoomName.text = "";
         this.FTF_RoomCapacity.text = "";
         this.FSP_Password.visible = false;
         this.FSP_Fighting.visible = false;
         this.FMC_HighLight.visible = false;
         if(this.FBmpIcon != null && this.FBmpIcon.bitmapData != null)
         {
            this.FBmpIcon.bitmapData = null;
         }
      }
   }
}

