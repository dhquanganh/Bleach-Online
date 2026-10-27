package Processors.Game.Lobby.TeamBattle.Room.Components
{
   import Foundation.Resources.*;
   import Foundation.Resources.Textures.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.Rooms.Seat.Player.*;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Resources.Constants.*;
   import Resources.Strings.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class TUIPlayerSmall extends TUIComponent
   {
      
      protected static const FRAME_TARGET_ONESELF:uint = 1;
      
      protected static const FRAME_TARGET_OTHER:uint = 2;
      
      protected var FSP_HeroIcon:Sprite;
      
      protected var FBmpHeroIcon:Bitmap;
      
      protected var FTF_Nickname:TextField;
      
      protected var FTF_Level:TextField;
      
      protected var FTF_FightingPower:TextField;
      
      protected var FSP_TeamLeader:Sprite;
      
      protected var FMC_HighLightA:MovieClip;
      
      protected var FMC_HighLightB:MovieClip;
      
      protected var FResource:Sprite;
      
      protected var FContext:TPlayerRoomDigest;
      
      protected var FOnQuerySequenceContext:Function;
      
      protected var FOnMove:Function;
      
      protected var FOnOut:Function;
      
      public function TUIPlayerSmall(param1:TUIComponent)
      {
         super(param1);
      }
      
      protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:Sprite = null;
         _loc1_ = this.FResource[CONST_TEAMBATTLE.RESOURCE_Link_SP_PlayerInfo];
         this.FSP_HeroIcon = _loc1_[CONST_TEAMBATTLE.RESOURCE_Link_SP_HeroIcon];
         this.FBmpHeroIcon = new Bitmap();
         this.FSP_HeroIcon.addChild(this.FBmpHeroIcon);
         this.FTF_Nickname = _loc1_[CONST_TEAMBATTLE.RESOURCE_Link_TF_Nickname];
         this.FTF_Level = _loc1_[CONST_TEAMBATTLE.RESOURCE_Link_TF_Level];
         this.FTF_FightingPower = _loc1_[CONST_TEAMBATTLE.RESOURCE_Link_TF_FightingPower];
         this.FSP_TeamLeader = _loc1_[CONST_TEAMBATTLE.RESOURCE_Link_SP_TeamLeader];
         this.FMC_HighLightA = this.FResource[CONST_TEAMBATTLE.RESOURCE_Link_MC_HighLightA];
         this.FMC_HighLightB = this.FResource[CONST_TEAMBATTLE.RESOURCE_Link_MC_HighLightB];
         this.FMC_HighLightA.stop();
         this.FMC_HighLightB.stop();
         this.Reset();
      }
      
      protected function addEventListenerPlayer() : void
      {
         this.FResource.addEventListener(MouseEvent.MOUSE_OVER,this.UIPlayerOnOver,false,0,true);
         this.FResource.addEventListener(MouseEvent.MOUSE_OUT,this.UIPlayerOnOut,false,0,true);
         this.FSP_HeroIcon.addEventListener(MouseEvent.MOUSE_MOVE,this.SP_HeroIconOnMove,false,0,true);
         this.FSP_HeroIcon.addEventListener(MouseEvent.MOUSE_OUT,this.SP_HeroIconOnOut,false,0,true);
      }
      
      protected function RemoveEventListenerPlayer() : void
      {
         this.FSP_HeroIcon.removeEventListener(MouseEvent.MOUSE_MOVE,this.SP_HeroIconOnMove);
         this.FSP_HeroIcon.removeEventListener(MouseEvent.MOUSE_OUT,this.SP_HeroIconOnOut);
      }
      
      protected function UpdateUIPlayerSmall() : void
      {
         if(this.FContext.SeatIndex == this.FContext.RoomOwnerIndex)
         {
            this.FSP_TeamLeader.visible = true;
         }
         this.FTF_Nickname.text = this.FContext.Nickname;
         this.FTF_Level.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TeamBattle_String_14),this.FContext.Level);
         this.FTF_FightingPower.text = this.FContext.FightingPower.toString();
         SResourcesCore.TexturesHeadIcon.LoadAutoSecondary(this.FContext.RoleHeadID,this.AutoLoadCallBack);
      }
      
      protected function AutoLoadCallBack(param1:Object, param2:TTexture, param3:uint) : void
      {
         var _loc4_:TAnimationSequence = null;
         _loc4_ = param2.GetAnimationSequenceByIndex(0);
         this.FBmpHeroIcon.bitmapData = _loc4_.GetAnimationFrameByIndex(0).Surface;
      }
      
      protected function SP_HeroIconOnMove(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         if(this.FContext.OneselfSeatIndex == this.FContext.SeatIndex)
         {
            return;
         }
         if(this.FOnMove != null)
         {
            this.FOnMove(this,this.FContext);
         }
      }
      
      protected function SP_HeroIconOnOut(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         if(this.FContext.OneselfSeatIndex == this.FContext.SeatIndex)
         {
            return;
         }
         if(this.FOnOut != null)
         {
            this.FOnOut(this,this.FContext);
         }
      }
      
      protected function UIPlayerOnOver(param1:MouseEvent) : void
      {
         if(this.FContext != null)
         {
            this.FMC_HighLightA.gotoAndStop(2);
         }
         else
         {
            this.FMC_HighLightB.gotoAndStop(2);
         }
      }
      
      protected function UIPlayerOnOut(param1:MouseEvent) : void
      {
         this.FMC_HighLightA.gotoAndStop(1);
         this.FMC_HighLightB.gotoAndStop(1);
      }
      
      public function get Resource() : Sprite
      {
         return this.FResource;
      }
      
      public function set Resource(param1:Sprite) : void
      {
         this.FResource = param1;
      }
      
      public function get Context() : TPlayerRoomDigest
      {
         return this.FContext;
      }
      
      public function set Context(param1:TPlayerRoomDigest) : void
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
            this.UpdateUIPlayerSmall();
         }
      }
      
      public function get OnMove() : Function
      {
         return this.FOnMove;
      }
      
      public function set OnMove(param1:Function) : void
      {
         this.FOnMove = param1;
      }
      
      public function get OnOut() : Function
      {
         return this.FOnOut;
      }
      
      public function set OnOut(param1:Function) : void
      {
         this.FOnOut = param1;
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
         this.FTF_Level.text = "";
         this.FTF_Nickname.text = "";
         this.FTF_FightingPower.text = "";
         this.FBmpHeroIcon.bitmapData = null;
         this.FSP_TeamLeader.visible = false;
      }
   }
}

