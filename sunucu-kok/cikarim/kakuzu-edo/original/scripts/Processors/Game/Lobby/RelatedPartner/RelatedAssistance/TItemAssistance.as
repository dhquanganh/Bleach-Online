package Processors.Game.Lobby.RelatedPartner.RelatedAssistance
{
   import Components.Standard.TUIButton;
   import Foundation.Network.SNetworkCore;
   import Foundation.Network.TPacket;
   import Foundation.Resources.SResourcesCore;
   import Foundation.Resources.Textures.TTexture;
   import Foundation.Utilities.TUtilityString;
   import Logics.Characters.THero;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Resources.Constants.CONST_NETWORK;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.utils.ByteArray;
   
   public class TItemAssistance
   {
      
      protected var FMainUI:Sprite;
      
      protected var FTFForbid:TextField;
      
      protected var FMCForbid:Sprite;
      
      protected var FBtnMask:TUIButton;
      
      protected var FBtnDismount:TUIButton;
      
      protected var FTFLevel:TextField;
      
      protected var FMountPoint:Bitmap;
      
      protected var FMCLight:Sprite;
      
      protected var FForbidLevel:int;
      
      protected var FIsForbid:Boolean;
      
      protected var FPosition:int;
      
      protected var FHero:THero;
      
      protected var FOnAssistanceList:Function;
      
      protected var FOnOver:Function;
      
      protected var FOnOut:Function;
      
      public function TItemAssistance(param1:Sprite)
      {
         super();
         this.FMainUI = param1;
         this.FMCForbid = this.FMainUI["MC_Forbid"];
         this.FTFForbid = this.FMainUI["TF_Forbid"];
         this.FTFLevel = this.FMainUI["TF_Level"];
         this.FMCLight = this.FMainUI["MC_Light"];
         this.FMountPoint = new Bitmap();
         this.FMainUI["MountPoint"].addChild(this.FMountPoint);
         this.FMainUI["MountPoint"].addEventListener(MouseEvent.MOUSE_MOVE,this.OnHeadOver);
         this.FMainUI["MountPoint"].addEventListener(MouseEvent.MOUSE_OUT,this.OnHeadOut);
         this.FTFForbid.text = "";
         this.FMCForbid.visible = false;
         this.FMCLight.visible = false;
         this.FTFLevel.text = "";
         this.FTFForbid.mouseEnabled = false;
         this.FTFLevel.mouseEnabled = false;
         this.FBtnMask = new TUIButton();
         this.FBtnMask.Substrate = this.FMainUI["Mask"];
         this.FBtnMask.OnClick = this.MaskOnClick;
         this.FBtnDismount = new TUIButton();
         this.FBtnDismount.Substrate = this.FMainUI["Btn_Dismount"];
         this.FBtnDismount.OnClick = this.DismountOnClick;
      }
      
      protected function PicArrive(param1:Object, param2:TTexture, param3:uint) : void
      {
         this.FMountPoint.bitmapData = param2.GetAnimationSequenceByIndex(0).GetAnimationFrameByIndex(0).Surface;
      }
      
      protected function OnHeadOver(param1:MouseEvent) : void
      {
         this.FOnOver(this,this.FHero);
      }
      
      protected function OnHeadOut(param1:MouseEvent) : void
      {
         this.FOnOut(this);
      }
      
      protected function MaskOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FOnAssistanceList != null)
         {
            this.FOnAssistanceList(this.FPosition);
         }
      }
      
      protected function DismountOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TPacket = null;
         var _loc4_:ByteArray = null;
         _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Related_HeroHelpCancelReq);
         _loc4_ = _loc3_.Data;
         _loc4_.writeUnsignedInt(this.FPosition);
         SNetworkCore.Transceiver.PacketTransmit(_loc3_);
      }
      
      public function get ForbidLevel() : int
      {
         return this.FForbidLevel;
      }
      
      public function set ForbidLevel(param1:int) : void
      {
         this.FForbidLevel = param1;
         this.FMCForbid.visible = true;
         this.FTFForbid.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_CrashJade_07),this.FForbidLevel);
      }
      
      public function get IsForbid() : Boolean
      {
         return this.FIsForbid;
      }
      
      public function set IsForbid(param1:Boolean) : void
      {
         this.FIsForbid = param1;
      }
      
      public function get Position() : int
      {
         return this.FPosition;
      }
      
      public function set Position(param1:int) : void
      {
         this.FPosition = param1;
      }
      
      public function get OnAssistanceList() : Function
      {
         return this.FOnAssistanceList;
      }
      
      public function set OnAssistanceList(param1:Function) : void
      {
         this.FOnAssistanceList = param1;
      }
      
      public function get Hero() : THero
      {
         return this.FHero;
      }
      
      public function set Hero(param1:THero) : void
      {
         this.FHero = param1;
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
      
      public function Render() : void
      {
         if(this.FIsForbid)
         {
            this.FTFLevel.visible = false;
            this.FTFForbid.visible = true;
            this.FMCForbid.visible = true;
            this.FBtnMask.Visible = false;
            this.FMountPoint.visible = false;
            this.FBtnDismount.Visible = false;
            this.FMCLight.visible = false;
         }
         else if(this.FHero != null)
         {
            this.FTFLevel.visible = true;
            this.FTFForbid.visible = false;
            this.FMCForbid.visible = false;
            this.FBtnMask.Visible = false;
            this.FMountPoint.visible = true;
            this.FBtnDismount.Visible = true;
            this.FMCLight.visible = true;
            SResourcesCore.TexturesHeadIcon.LoadAutoSecondary(this.FHero.SmallID,this.PicArrive);
            this.FTFLevel.text = this.FHero.RebirthLevel + "";
         }
         else
         {
            this.FTFLevel.visible = false;
            this.FTFForbid.visible = false;
            this.FMCForbid.visible = false;
            this.FBtnMask.Visible = true;
            this.FMountPoint.visible = false;
            this.FBtnDismount.Visible = false;
            this.FMCLight.visible = false;
         }
      }
   }
}

