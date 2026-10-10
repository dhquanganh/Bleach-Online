package Processors.Game.Lobby.GongFuFight.MainUIComponent
{
   import Foundation.Resources.SResourcesCore;
   import Foundation.Resources.Textures.TTexture;
   import Logics.DatebaseVO.VO.TRoleModel;
   import Resources.Constants.CONST_DATEBASEVO;
   import flash.display.Bitmap;
   import Logics.GongFuFight.TGongFuFightPlayerInfor;
   import Resources.Constants.CONST_GONGFUFIGHT;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class TBeyondLevelPlayerHeadItem
   {
      
      protected var FTFLevel:TextField;
      
      protected var FTFName:TextField;
      
      protected var FKilledFlag:Sprite;
      
      protected var FMouseOverUI:Sprite;
      
      protected var FSelectBox:Sprite;
      
      protected var FHeadPicture:MovieClip;
      protected var FDynamicHead:Bitmap;
      protected var FHeadSize:Number;
      
      protected var FOnMove:Function;
      
      protected var FOnOut:Function;
      
      protected var FOnClick:Function;
      
      protected var FGongFuFightPlayerInfor:TGongFuFightPlayerInfor;
      
      public function TBeyondLevelPlayerHeadItem()
      {
         super();
      }
      
      public function UIDispatch(param1:Sprite) : void
      {
         this.FTFLevel = param1["Level"];
         this.FTFName = param1["Name"];
         this.FKilledFlag = param1["KilledFlag"];
         this.FMouseOverUI = param1["MouseOverUI"];
         this.FHeadPicture = param1["HeadPic"];
         this.FHeadSize = this.FHeadPicture.width;
         this.FDynamicHead = new Bitmap();
         this.FDynamicHead.x = this.FHeadPicture.x;
         this.FDynamicHead.y = this.FHeadPicture.y;
         param1.addChildAt(this.FDynamicHead,param1.getChildIndex(this.FHeadPicture));
         this.FHeadPicture.visible = false;
         this.FSelectBox = param1["SelectBox"];
         this.FSelectBox.visible = false;
         param1.buttonMode = true;
         param1.addEventListener(MouseEvent.CLICK,this.ItemOnMouseClick);
         param1.addEventListener(MouseEvent.MOUSE_OVER,this.ItemOnMouseOver);
         param1.addEventListener(MouseEvent.MOUSE_OUT,this.ItemOnMouseOut);
      }
      
      protected function RenderView(param1:TGongFuFightPlayerInfor) : void
      {
         this.FTFLevel.text = "LV." + param1.PlayerLevel.toString();
         this.FTFName.text = param1.PlayerName;
         this.FDynamicHead.bitmapData = null;
         var model:TRoleModel = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_RoleModel,param1.PlayerMainHeroID) as TRoleModel;
         if(model != null) SResourcesCore.TexturesHeadIcon.LoadAutoSecondary(model.RoleHead,this.HeadArrive);
         this.FKilledFlag.visible = param1.State == CONST_GONGFUFIGHT.PlayerState_Killed;
      }
      
      protected function HeadArrive(context:Object, texture:TTexture, id:uint) : void
      {
         if(this.FGongFuFightPlayerInfor == null || texture == null) return;
         var model:TRoleModel = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_RoleModel,this.FGongFuFightPlayerInfor.PlayerMainHeroID) as TRoleModel;
         if(model == null || model.RoleHead != id) return;
         this.FDynamicHead.bitmapData = texture.GetAnimationSequenceByIndex(0).GetAnimationFrameByIndex(0).Surface;
         this.FDynamicHead.smoothing = true;
         if(this.FHeadSize > 0) { this.FDynamicHead.width = this.FHeadSize; this.FDynamicHead.height = this.FHeadSize; }
      }

      protected function ItemOnMouseClick(param1:MouseEvent) : void
      {
         if(this.FOnClick != null)
         {
            this.FOnClick(this,this.FGongFuFightPlayerInfor);
         }
         this.FSelectBox.visible = true;
      }
      
      protected function ItemOnMouseOver(param1:MouseEvent) : void
      {
         if(this.FOnMove != null)
         {
            this.FOnMove(this,this.FGongFuFightPlayerInfor);
         }
         this.FMouseOverUI.visible = true;
      }
      
      protected function ItemOnMouseOut(param1:MouseEvent) : void
      {
         if(this.FOnOut != null)
         {
            this.FOnOut(this,this.FGongFuFightPlayerInfor);
         }
         this.FMouseOverUI.visible = false;
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
   }
}

