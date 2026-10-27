package Processors.Game.Lobby.Shortcuts.Window
{
   import Components.Standard.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Textures.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.Achievenment.*;
   import Logics.BleachTrain.*;
   import Processors.Game.Lobby.Utilities.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class TWindowBleachTrainFollow extends TUIComponent
   {
      
      protected const OFFONTotalTime:int = 1000;
      
      protected const Speed:int = 30;
      
      protected var FScene:MovieClip;
      
      protected var FTFName:TextField;
      
      protected var FTFDescription:TextField;
      
      protected var FPicMountPoint:Bitmap;
      
      protected var FBtnClose:TUIButton;
      
      protected var FBtnOpen:TUIButton;
      
      protected var FWidth:int;
      
      protected var FIsInitialization:Boolean;
      
      protected var FIfSceneSetVisible:Boolean;
      
      protected var FCurrentMoveTime:int;
      
      protected var FSpeed:int;
      
      protected var FResourceID:int;
      
      protected var FBleachTrainData:TBleachTrainData;
      
      protected var FOnClickTrainData:Function;
      
      public function TWindowBleachTrainFollow(param1:TUIComponent)
      {
         super(param1);
      }
      
      protected function Resources_UIDispatch() : void
      {
         this.FScene = TUtilityReflection.CreateDisplayObjectInstance("BleachTrainFollowUI") as MovieClip;
         addChild(this.FScene);
         this.FScene.buttonMode = true;
         this.FTFName = this.FScene["Name"];
         this.FTFDescription = this.FScene["Description"];
         this.FBtnOpen = new TUIButton();
         this.FBtnOpen.Substrate = this.FScene["OpnBtn"];
         this.FBtnOpen.OnClick = this.BtnOpenOnMouseClick;
         this.FBtnOpen.StopPropagation();
         this.FBtnClose = new TUIButton();
         this.FBtnClose.Substrate = this.FScene["CloseBtn"];
         this.FBtnClose.OnClick = this.BtnCloseOnMouseClick;
         this.FBtnClose.StopPropagation();
         this.FPicMountPoint = new Bitmap();
         this.FScene["PicMountPoint"].addChild(this.FPicMountPoint);
      }
      
      protected function Resources_UILocation() : void
      {
         this.FScene.addEventListener(MouseEvent.CLICK,this.SceneOnMouseClick);
         this.FScene.visible = false;
         this.FIsInitialization = true;
      }
      
      protected function UpdateBounds() : void
      {
         if(!this.FIsInitialization)
         {
            return;
         }
         if(this.FIsInitialization)
         {
            this.FWidth = this.width - this.GetIndentationWidth();
         }
         else
         {
            this.FWidth = 0;
         }
      }
      
      protected function GetIndentationWidth() : int
      {
         if(this.FSpeed != 0)
         {
            this.FCurrentMoveTime += this.FSpeed;
            if(this.FCurrentMoveTime > this.OFFONTotalTime)
            {
               this.FCurrentMoveTime = this.OFFONTotalTime;
               this.FSpeed = 0;
               if(this.FPicMountPoint.bitmapData != null)
               {
                  this.FPicMountPoint.bitmapData = null;
               }
            }
            else if(this.FCurrentMoveTime < 0)
            {
               this.FCurrentMoveTime = 0;
               this.FSpeed = 0;
            }
         }
         return (this.FScene.width - 30) * (this.FCurrentMoveTime / this.OFFONTotalTime);
      }
      
      protected function Update() : void
      {
         var _loc1_:int = 0;
         if(this.FBleachTrainData == null)
         {
            this.FScene.visible = false;
            return;
         }
         if(!this.FIfSceneSetVisible)
         {
            this.FScene.visible = false;
         }
         if(this.FBleachTrainData.IfOpen)
         {
            this.FScene.gotoAndStop(1);
            this.FTFDescription.text = this.FBleachTrainData.GrowRoadTask.DescriptionSimple;
         }
         else
         {
            this.FScene.gotoAndStop(2);
            if(this.FBleachTrainData.GrowRoadTask.TaskLocked == "")
            {
               this.FTFDescription.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_BleachTrain_05),this.FBleachTrainData.GrowRoadTask.Accept);
            }
            else
            {
               this.FTFDescription.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_BleachTrain_04),this.FBleachTrainData.GrowRoadTask.Accept,this.FBleachTrainData.GrowRoadTask.TaskLocked);
            }
         }
         this.FTFName.text = this.FBleachTrainData.GrowRoadTask.Name;
         this.FScene.visible = this.FIfSceneSetVisible && this.FBleachTrainData != null;
         this.FResourceID = this.FBleachTrainData.GrowRoadTask.IocnID;
         SResourcesCore.TexturesInventory.LoadAutoSecondary(this.FResourceID,this.CallBack_PicArrive);
      }
      
      protected function CallBack_PicArrive(param1:Object, param2:TTexture, param3:uint) : void
      {
         if(param3 == this.FBleachTrainData.GrowRoadTask.IocnID)
         {
            this.FPicMountPoint.bitmapData = param2.GetAnimationSequenceByIndex(0).GetAnimationFrameByIndex(0).Surface;
         }
      }
      
      protected function BtnOpenOnMouseClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FSpeed == 0)
         {
            this.FCurrentMoveTime = this.OFFONTotalTime;
            this.FSpeed = -this.Speed;
            this.FBtnClose.Visible = true;
         }
         SResourcesCore.TexturesInventory.LoadAutoSecondary(this.FResourceID,this.CallBack_PicArrive);
      }
      
      protected function BtnCloseOnMouseClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FSpeed == 0)
         {
            this.FCurrentMoveTime = 0;
            this.FSpeed = this.Speed;
            this.FBtnClose.Visible = false;
         }
      }
      
      protected function SceneOnMouseClick(param1:MouseEvent) : void
      {
         if(this.FOnClickTrainData != null)
         {
            this.FOnClickTrainData(this,CONST_SHORTCUTS.TYPE_SecondaryFunctionC_BleachTrain,CONST_SHORTCUTS.POSITION_SecondaryFunctionC);
         }
      }
      
      public function set OnClickTrainData(param1:Function) : void
      {
         this.FOnClickTrainData = param1;
      }
      
      public function get ShortcutWidth() : int
      {
         this.UpdateBounds();
         return this.FWidth;
      }
      
      public function Perform_UIDispatch() : void
      {
         this.Resources_UIDispatch();
         this.Resources_UILocation();
      }
      
      public function FollowBelachTrain(param1:TBleachTrainData) : void
      {
         this.FBleachTrainData = param1;
         this.Update();
      }
      
      public function SetupShortcutsShow(param1:int, param2:int) : void
      {
         if(!this.FIsInitialization)
         {
            return;
         }
         this.FScene.visible = this.FBleachTrainData != null;
      }
      
      public function HideAllShortcuts() : void
      {
         if(!this.FIsInitialization)
         {
            return;
         }
         this.FScene.visible = false;
      }
   }
}

