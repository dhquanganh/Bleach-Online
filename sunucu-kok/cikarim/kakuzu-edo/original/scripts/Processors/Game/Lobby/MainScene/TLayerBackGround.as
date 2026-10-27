package Processors.Game.Lobby.MainScene
{
   import Foundation.Resources.*;
   import Foundation.Resources.Textures.*;
   import Foundation.UI.*;
   import Logics.*;
   import Processors.*;
   import Processors.Game.Lobby.MainScene.Role.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.geom.*;
   
   public class TLayerBackGround extends TProcessor
   {
      
      protected static const ScreenWidth:Number = CONST_COMMON.STAGE_Width;
      
      protected static const ScreenHeight:Number = CONST_COMMON.STAGE_Height;
      
      public static const LOADTYPE_Primary:uint = 0;
      
      public static const LOADTYPE_Secondary:uint = 1;
      
      protected static const MAPSTATE_NORMAL:int = 0;
      
      protected static const MAPSTATE_SMALL:int = 1;
      
      protected static const PAINTSTATE_NONE:int = -1;
      
      protected static const PAINTSTATE_NORMAL:int = 0;
      
      protected static const PAINTSTATE_SMALL:int = 1;
      
      protected static const FBG1ToBG3:Number = 0.25;
      
      protected static const FBG2ToBG3:Number = 0.5;
      
      protected static const BGSmallWidthToBGBigWidth:Number = 0.1;
      
      protected static const MAP_WIDTH:int = 2500;
      
      protected static const MAP_HEIGHT:int = 650;
      
      protected static const MatrixScaleX:int = 10;
      
      protected static const MatrixScaleY:int = 10;
      
      protected static const SMALLMAP_BITMAPDATA_WIDHT:int = 125;
      
      protected static const SMALLMAP_BITMAPDATA_HEIGHT:int = 65;
      
      protected static const CitysID:Vector.<int> = Vector.<int>([23100001,23200001]);
      
      protected var FBitmapData1:BitmapData;
      
      protected var FBitmapData2:BitmapData;
      
      protected var FBitmapData3:BitmapData;
      
      protected var FCurrentSceneID:int;
      
      protected var FCurrentMapState:int;
      
      protected var FCurrentPaintingState:int;
      
      protected var FBackGroundBitmap:Bitmap;
      
      protected var FBackGroundBitmapData:BitmapData;
      
      protected var FBackGroundSmallBitmapData:BitmapData;
      
      protected var FRect:Rectangle;
      
      protected var FClipRect:Rectangle;
      
      protected var FPoint:Point;
      
      protected var FMapWidth:int;
      
      protected var FMapLoadOver:Boolean;
      
      protected var FScreenMapXStore:Number;
      
      protected var FRoleControlWidth:int;
      
      protected var FMatrix:Matrix;
      
      protected var FBG3ToBG3:Number;
      
      protected var FIsNeedSmallPic:Boolean;
      
      protected var FLoading:Boolean;
      
      protected var FScreenRole:IRole;
      
      protected var FLoadType:uint;
      
      protected var FOnLoadCompleted:Function;
      
      public function TLayerBackGround(param1:TUIComponent)
      {
         super(param1);
         this.FBackGroundBitmapData = new BitmapData(CONST_COMMON.STAGE_Width,CONST_COMMON.STAGE_Height,true,0);
         this.FBackGroundSmallBitmapData = new BitmapData(SMALLMAP_BITMAPDATA_WIDHT,SMALLMAP_BITMAPDATA_HEIGHT);
         this.FBackGroundBitmap = new Bitmap(this.FBackGroundBitmapData);
         this.addChild(this.FBackGroundBitmap);
         this.FRect = new Rectangle();
         this.FRect.y = 0;
         this.FPoint = new Point(0,0);
         this.FRoleControlWidth = 0;
         this.FMatrix = new Matrix();
         this.FMatrix.scale(MatrixScaleX,MatrixScaleY);
         this.FClipRect = new Rectangle();
         this.FLoadType = LOADTYPE_Primary;
         this.FIsNeedSmallPic = false;
         FResourcesState = RESOURCESSTATE_Ready;
      }
      
      override protected function ResourcesPerform_UIWait() : void
      {
      }
      
      protected function ResourcesLoading() : void
      {
         switch(this.FCurrentMapState)
         {
            case MAPSTATE_SMALL:
               SResourcesCore.TexturesPreview.LoadPrimary(this.FCurrentSceneID);
               break;
            case MAPSTATE_NORMAL:
               this.ResourceBackgroundIconLoader(this.FLoadType,this.FCurrentSceneID);
         }
         this.ResourcesCheck();
      }
      
      protected function ResourceBackgroundIconLoader(param1:uint, param2:uint) : void
      {
         switch(param1)
         {
            case LOADTYPE_Primary:
               SResourcesCore.TexturesBackgroundIcon.LoadPrimary(param2);
               break;
            default:
               SResourcesCore.TexturesBackgroundIcon.LoadSecondary(param2);
         }
      }
      
      protected function ResourcesCheck() : void
      {
         var _loc1_:TAnimationSequence = null;
         var _loc2_:TTexture = null;
         switch(this.FCurrentMapState)
         {
            case MAPSTATE_SMALL:
               _loc2_ = SResourcesCore.TexturesPreview.GetTextureByIdentifier(this.FCurrentSceneID);
               if(_loc2_ == null)
               {
                  return;
               }
               _loc1_ = _loc2_.GetAnimationSequenceByIndex(0);
               this.FBitmapData3 = _loc1_.GetAnimationFrameByIndex(0).Surface;
               this.FRect.width = SMALLMAP_BITMAPDATA_WIDHT;
               this.FRect.height = SMALLMAP_BITMAPDATA_HEIGHT;
               this.FCurrentPaintingState = PAINTSTATE_SMALL;
               break;
            case MAPSTATE_NORMAL:
               _loc2_ = SResourcesCore.TexturesBackgroundIcon.GetTextureByIdentifier(this.FCurrentSceneID);
               if(_loc2_ == null)
               {
                  return;
               }
               _loc1_ = _loc2_.GetAnimationSequenceByIndex(CONST_MainScene.BACKGROUND3_SEQUENCEID);
               this.FBitmapData3 = _loc1_.GetAnimationFrameByIndex(0).Surface;
               _loc1_ = _loc2_.GetAnimationSequenceByIndex(CONST_MainScene.BACKGROUND2_SEQUENCEID);
               this.FBitmapData2 = _loc1_.GetAnimationFrameByIndex(0).Surface;
               _loc1_ = _loc2_.GetAnimationSequenceByIndex(CONST_MainScene.BACKGROUND1_SEQUENCEID);
               this.FBitmapData1 = _loc1_.GetAnimationFrameByIndex(0).Surface;
               this.FRect.height = CONST_COMMON.STAGE_Height;
               this.FRect.width = CONST_COMMON.STAGE_Width;
               this.FCurrentPaintingState = PAINTSTATE_NORMAL;
         }
         this.FMapLoadOver = true;
         this.FScreenMapXStore = -1;
         this.FollowUpRole();
         this.FBackGroundBitmap.bitmapData = this.FBackGroundBitmapData;
         if(this.FOnLoadCompleted != null)
         {
            this.FOnLoadCompleted(this);
         }
         super.ResourcesPerform_UIDispatch();
         switch(this.FCurrentMapState)
         {
            case MAPSTATE_SMALL:
               this.FCurrentMapState = MAPSTATE_NORMAL;
               break;
            case MAPSTATE_NORMAL:
               this.FLoading = false;
         }
      }
      
      protected function FollowUpRole() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         _loc2_ = MAP_WIDTH;
         _loc1_ = this.FScreenRole.MapX - ScreenWidth / 2;
         if(this.FRoleControlWidth != 0)
         {
            if(_loc1_ < 0)
            {
               _loc1_ = 0;
            }
            else if(_loc1_ > this.FRoleControlWidth - ScreenWidth)
            {
               _loc1_ = this.FRoleControlWidth - ScreenWidth;
            }
         }
         else if(_loc1_ < 0)
         {
            _loc1_ = 0;
         }
         else if(_loc1_ > _loc2_ - ScreenWidth)
         {
            _loc1_ = _loc2_ - ScreenWidth;
         }
         this.MoveBackGroundByScreenPosition(_loc1_);
         SLogicsCore.ScreenMapX = _loc1_;
      }
      
      protected function MoveBackGroundByScreenPosition(param1:Number) : void
      {
         if(int(this.FScreenMapXStore) == int(param1))
         {
            return;
         }
         switch(this.FCurrentPaintingState)
         {
            case PAINTSTATE_SMALL:
               this.FRect.x = BGSmallWidthToBGBigWidth * param1;
               this.FBackGroundSmallBitmapData.lock();
               this.FBackGroundSmallBitmapData.copyPixels(this.FBitmapData3,this.FRect,this.FPoint,null,null,true);
               this.FBackGroundSmallBitmapData.unlock();
               this.FBackGroundBitmapData.draw(this.FBackGroundSmallBitmapData,this.FMatrix);
               break;
            case PAINTSTATE_NORMAL:
               this.FRect.x = FBG1ToBG3 * param1;
               this.FBackGroundBitmapData.lock();
               this.FBackGroundBitmapData.copyPixels(this.FBitmapData1,this.FRect,this.FPoint,null,null,true);
               this.FRect.x = FBG2ToBG3 * param1;
               this.FBackGroundBitmapData.copyPixels(this.FBitmapData2,this.FRect,this.FPoint,null,null,true);
               this.FRect.x = param1;
               this.FBackGroundBitmapData.copyPixels(this.FBitmapData3,this.FRect,this.FPoint,null,null,true);
               this.FBackGroundBitmapData.unlock();
         }
         this.FScreenMapXStore = param1;
      }
      
      protected function UnLoadBackGroundBySceneID(param1:uint) : void
      {
         SResourcesCore.TexturesBackgroundIcon.DeleteByIdentifier(param1);
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(this.FLoading)
         {
            this.ResourcesLoading();
         }
      }
      
      protected function IfCityID(param1:int) : Boolean
      {
         var _loc2_:int = 0;
         var _loc3_:Vector.<int> = null;
         _loc3_ = CitysID;
         _loc2_ = 0;
         while(_loc2_ < _loc3_.length)
         {
            if(_loc3_[_loc2_] == param1)
            {
               return true;
            }
            _loc2_++;
         }
         return false;
      }
      
      public function set ScreenRole(param1:IRole) : void
      {
         this.FScreenRole = param1;
      }
      
      public function get OnLoadCompleted() : Function
      {
         return this.FOnLoadCompleted;
      }
      
      public function set OnLoadCompleted(param1:Function) : void
      {
         this.FOnLoadCompleted = param1;
      }
      
      public function get RoleControlWidth() : int
      {
         return this.FRoleControlWidth;
      }
      
      public function set RoleControlWidth(param1:int) : void
      {
         this.FRoleControlWidth = param1;
      }
      
      public function get IsNeedSmallPic() : Boolean
      {
         return this.FIsNeedSmallPic;
      }
      
      public function set IsNeedSmallPic(param1:Boolean) : void
      {
         this.FIsNeedSmallPic = param1;
      }
      
      public function get LoadType() : uint
      {
         return this.FLoadType;
      }
      
      public function set LoadType(param1:uint) : void
      {
         this.FLoadType = param1;
      }
      
      public function Update() : void
      {
         if(this.FScreenRole != null && this.FMapLoadOver)
         {
            this.FollowUpRole();
         }
         this.visible = true;
      }
      
      public function SwitchScene(param1:uint) : void
      {
         var _loc2_:Boolean = false;
         if(this.FCurrentSceneID == param1)
         {
            if(this.FOnLoadCompleted != null)
            {
               this.FOnLoadCompleted(this);
            }
            return;
         }
         this.FBitmapData1 = null;
         this.FBitmapData2 = null;
         this.FBitmapData3 = null;
         this.FMapLoadOver = false;
         if(this.FCurrentSceneID != 0)
         {
            _loc2_ = this.IfCityID(this.FCurrentSceneID);
            if(!_loc2_)
            {
               this.UnLoadBackGroundBySceneID(this.FCurrentSceneID);
            }
            else
            {
               this.FIsNeedSmallPic = true;
            }
         }
         this.FCurrentSceneID = param1;
         this.FCurrentPaintingState = PAINTSTATE_NONE;
         if(this.FIsNeedSmallPic)
         {
            this.FCurrentMapState = MAPSTATE_SMALL;
         }
         else
         {
            this.FCurrentMapState = MAPSTATE_NORMAL;
         }
         if(this.FCurrentSceneID != 0)
         {
            this.FBackGroundBitmap.bitmapData = null;
            this.FLoading = true;
         }
      }
   }
}

