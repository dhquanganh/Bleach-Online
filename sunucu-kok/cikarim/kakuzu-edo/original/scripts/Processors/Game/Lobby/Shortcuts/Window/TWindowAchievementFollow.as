package Processors.Game.Lobby.Shortcuts.Window
{
   import Foundation.Common.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Textures.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.Achievenment.*;
   import Processors.Game.Lobby.Utilities.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class TWindowAchievementFollow extends TUIComponent
   {
      
      protected static const ConditionFormatString:String = "%0(%1/%2)\n";
      
      protected var FScene:Sprite;
      
      protected var FTFName:TextField;
      
      protected var FTFSchedule:TextField;
      
      protected var FScheduleBar:Sprite;
      
      protected var FPicMountPoint:Bitmap;
      
      protected var FWidth:int;
      
      protected var FIsInitialization:Boolean;
      
      protected var FToolHint:THint;
      
      protected var FTipFormatString:String;
      
      protected var FIfSceneSetVisible:Boolean;
      
      protected var FAchievementFollow:TAchievementInfor;
      
      protected var FOnClickAchievement:Function;
      
      protected var FHintOnOver:Function;
      
      protected var FHintOnOut:Function;
      
      public function TWindowAchievementFollow(param1:TUIComponent)
      {
         super(param1);
      }
      
      protected function Resources_UIDispatch() : void
      {
         this.FScene = TUtilityReflection.CreateDisplayObjectInstance("AchievementFollow") as Sprite;
         addChild(this.FScene);
         this.FScene.buttonMode = true;
         this.FScene.mouseChildren = false;
         this.FTFName = this.FScene["AchievementName"];
         this.FTFSchedule = this.FScene["BarLable"];
         this.FScheduleBar = this.FScene["ScheduleBar"]["Schedule"];
         this.FPicMountPoint = new Bitmap();
         this.FScene["PicMountPoint"].addChild(this.FPicMountPoint);
         this.FToolHint = new THint();
      }
      
      protected function Resources_UILocation() : void
      {
         this.FScene.addEventListener(MouseEvent.MOUSE_MOVE,this.SceneOnMouseOver);
         this.FScene.addEventListener(MouseEvent.MOUSE_OUT,this.SceneOnMouseOut);
         this.FScene.addEventListener(MouseEvent.CLICK,this.SceneOnMouseClick);
         this.FScene.visible = false;
         this.FTipFormatString = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.Achievement_String_05);
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
            this.FWidth = this.width;
         }
         else
         {
            this.FWidth = 0;
         }
      }
      
      protected function Update() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(this.FAchievementFollow == null)
         {
            this.FScene.visible = false;
            return;
         }
         this.FScene.visible = true;
         this.FTFName.text = this.FAchievementFollow.Name;
         this.FScene.visible = this.FIfSceneSetVisible && this.FAchievementFollow != null;
         SResourcesCore.TexturesAchievementIcon.LoadAutoSecondary(this.FAchievementFollow.FollowPic,this.CallBack_PicArrive);
         _loc3_ = 0;
         while(_loc3_ < this.FAchievementFollow.AchievementSchedules.length)
         {
            if(this.FAchievementFollow.AchievementSchedules[_loc3_].Complete)
            {
               _loc2_++;
            }
            _loc3_++;
         }
         this.FTFSchedule.text = _loc2_ + "/" + this.FAchievementFollow.AchievementSchedules.length;
         _loc1_ = _loc2_ / this.FAchievementFollow.AchievementSchedules.length;
         _loc1_ = _loc1_ > 1 ? 1 : _loc1_;
         this.FScheduleBar.scaleX = _loc1_;
      }
      
      protected function CallBack_PicArrive(param1:Object, param2:TTexture, param3:uint) : void
      {
         if(param3 == this.FAchievementFollow.FollowPic)
         {
            this.FPicMountPoint.bitmapData = param2.GetAnimationSequenceByIndex(0).GetAnimationFrameByIndex(0).Surface;
         }
      }
      
      protected function SceneOnMouseOver(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:String = null;
         var _loc4_:TAchievementSchedule = null;
         _loc3_ = "";
         _loc2_ = 0;
         while(_loc2_ < this.FAchievementFollow.AchievementSchedules.length)
         {
            _loc4_ = this.FAchievementFollow.AchievementSchedules[_loc2_];
            _loc3_ += TUtilityString.Format(ConditionFormatString,_loc4_.ConditionStrings,_loc4_.CurrentSchedule,_loc4_.Value);
            _loc2_++;
         }
         this.FToolHint.Caption = TUtilityString.Format(this.FTipFormatString,this.FAchievementFollow.Name,_loc3_);
         if(this.FHintOnOver != null)
         {
            this.FHintOnOver(this,this.FToolHint);
         }
      }
      
      protected function SceneOnMouseOut(param1:MouseEvent) : void
      {
         if(this.FHintOnOut != null)
         {
            this.FHintOnOut(this,this.FToolHint);
         }
      }
      
      protected function SceneOnMouseClick(param1:MouseEvent) : void
      {
         if(this.FOnClickAchievement != null)
         {
            this.FOnClickAchievement(this.FAchievementFollow,CONST_SHORTCUTS.TYPE_QuestGuide_Achievement);
         }
      }
      
      public function set HintOnOver(param1:Function) : void
      {
         this.FHintOnOver = param1;
      }
      
      public function set HintOnOut(param1:Function) : void
      {
         this.FHintOnOut = param1;
      }
      
      public function set OnClickAchievement(param1:Function) : void
      {
         this.FOnClickAchievement = param1;
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
      
      public function FollowAchievement(param1:TAchievementInfor) : void
      {
         this.FAchievementFollow = param1;
         this.Update();
      }
      
      public function SetupShortcutsShow(param1:int, param2:int) : void
      {
         if(!this.FIsInitialization)
         {
            return;
         }
         this.FScene.visible = this.FAchievementFollow != null;
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

