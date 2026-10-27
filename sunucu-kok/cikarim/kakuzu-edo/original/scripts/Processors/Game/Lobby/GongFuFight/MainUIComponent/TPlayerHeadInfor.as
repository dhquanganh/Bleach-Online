package Processors.Game.Lobby.GongFuFight.MainUIComponent
{
   import Foundation.Resources.SResourcesCore;
   import Foundation.Resources.Textures.TTexture;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.VO.TRoleModel;
   import Logics.GongFuFight.TGongFuFightPlayerInfor;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Resources.Constants.CONST_DATEBASEVO;
   import Resources.Constants.CONST_GONGFUFIGHT;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class TPlayerHeadInfor
   {
      
      protected var FMask:Sprite;
      
      protected var FTFLevel:TextField;
      
      protected var FTFName:TextField;
      
      protected var FKilledFlag:Sprite;
      
      protected var FSelectBox:Sprite;
      
      protected var FMountPoint:Bitmap;
      
      protected var FOnMove:Function;
      
      protected var FOnOut:Function;
      
      protected var FOnClick:Function;
      
      protected var FGongFuFightPlayerInfor:TGongFuFightPlayerInfor;
      
      public function TPlayerHeadInfor()
      {
         super();
      }
      
      public function UIDispatch(param1:Sprite) : void
      {
         this.FMask = param1["Mask"];
         this.FTFLevel = param1["Level"];
         this.FTFName = param1["Name"];
         this.FKilledFlag = param1["KilledFlag"];
         this.FSelectBox = param1["SelectBox"];
         this.FMountPoint = new Bitmap();
         param1["Icon"].addChild(this.FMountPoint);
         this.FSelectBox.visible = false;
         param1.addEventListener(MouseEvent.MOUSE_MOVE,this.HeadOnMove);
         param1.addEventListener(MouseEvent.MOUSE_OUT,this.HeadOnOut);
         param1.addEventListener(MouseEvent.CLICK,this.HeadOnClick);
         param1.buttonMode = true;
      }
      
      protected function RenderView(param1:TGongFuFightPlayerInfor) : void
      {
         var _loc2_:TRoleModel = null;
         var _loc3_:String = null;
         _loc3_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_GongFuGight_22);
         this.FTFLevel.text = TUtilityString.Format(_loc3_,param1.PlayerLevel);
         this.FTFName.text = param1.PlayerName;
         _loc2_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_RoleModel,param1.PlayerMainHeroID) as TRoleModel;
         SResourcesCore.TexturesHeadIcon.LoadAutoSecondary(_loc2_.RoleHead,this.PicArrive);
         switch(param1.State)
         {
            case CONST_GONGFUFIGHT.PlayerState_CanChallenge:
               this.FKilledFlag.visible = false;
               this.FMask.visible = false;
               break;
            case CONST_GONGFUFIGHT.PlayerState_Killed:
               this.FKilledFlag.visible = true;
               this.FMask.visible = false;
               break;
            case CONST_GONGFUFIGHT.PlayerState_Safe:
               this.FKilledFlag.visible = false;
               this.FMask.visible = true;
         }
      }
      
      protected function PicArrive(param1:Object, param2:TTexture, param3:uint) : void
      {
         this.FMountPoint.bitmapData = param2.GetAnimationSequenceByIndex(0).GetAnimationFrameByIndex(0).Surface;
      }
      
      protected function HeadOnMove(param1:MouseEvent) : void
      {
         if(this.FGongFuFightPlayerInfor == null || this.FGongFuFightPlayerInfor.State == CONST_GONGFUFIGHT.PlayerState_Killed)
         {
            return;
         }
         if(this.FOnMove != null)
         {
            this.FOnMove(this,this.FGongFuFightPlayerInfor);
         }
      }
      
      protected function HeadOnOut(param1:MouseEvent) : void
      {
         if(this.FGongFuFightPlayerInfor == null || this.FGongFuFightPlayerInfor.State == CONST_GONGFUFIGHT.PlayerState_Killed)
         {
            return;
         }
         if(this.FOnOut != null)
         {
            this.FOnOut(this,this.FGongFuFightPlayerInfor);
         }
      }
      
      protected function HeadOnClick(param1:MouseEvent) : void
      {
         if(this.FGongFuFightPlayerInfor == null || this.FGongFuFightPlayerInfor.State != CONST_GONGFUFIGHT.PlayerState_CanChallenge)
         {
            return;
         }
         if(this.FOnClick != null)
         {
            this.FOnClick(this,this.FGongFuFightPlayerInfor);
         }
         this.FSelectBox.visible = true;
      }
      
      public function set OnMove(param1:Function) : void
      {
         this.FOnMove = param1;
      }
      
      public function set OnOut(param1:Function) : void
      {
         this.FOnOut = param1;
      }
      
      public function set OnClick(param1:Function) : void
      {
         this.FOnClick = param1;
      }
      
      public function CancleSelectState() : void
      {
         this.FSelectBox.visible = false;
      }
      
      public function Update(param1:TGongFuFightPlayerInfor) : void
      {
         this.FGongFuFightPlayerInfor = param1;
         this.RenderView(param1);
      }
      
      public function Reset() : void
      {
         this.FMountPoint.bitmapData = null;
      }
   }
}

