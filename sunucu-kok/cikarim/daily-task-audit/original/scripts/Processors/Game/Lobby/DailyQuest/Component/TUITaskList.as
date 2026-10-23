package Processors.Game.Lobby.DailyQuest.Component
{
   import Foundation.Resources.SResourcesCore;
   import Foundation.Resources.Textures.TAnimationSequence;
   import Foundation.Resources.Textures.TTexture;
   import Foundation.UI.TUIComponent;
   import Logics.Dailytask.TDailytask;
   import Logics.Dailytask.TQuestDaily;
   import Logics.SLogicsCore;
   import Resources.Constants.CONST_DAILY_QUEST;
   import Resources.Constants.CONST_FRESHGUIDE;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class TUITaskList extends TUIComponent
   {
      
      protected static const MAX_COUNT:int = 5;
      
      protected var FScene:MovieClip;
      
      protected var FMC_BmpIcon:Sprite;
      
      protected var FMC_BmpIcons:Vector.<Bitmap>;
      
      protected var FIconIds:Vector.<uint>;
      
      protected var FMC_Tag:MovieClip;
      
      protected var FMC_SelectedBox:Sprite;
      
      protected var FMC_Bmp_IconHighLight:Sprite;
      
      protected var FTaskLists:Vector.<TQuestDaily>;
      
      protected var FDailytask:TDailytask;
      
      protected var FSeleceds:Vector.<Sprite>;
      
      protected var FTags:Vector.<MovieClip>;
      
      protected var FMCs:Vector.<Sprite>;
      
      protected var FOnTaskClick:Function;
      
      protected var FOnTaskOver:Function;
      
      protected var FOnTaskOut:Function;
      
      protected var FTutorialNextStep:Function;
      
      public function TUITaskList(param1:TUIComponent, param2:MovieClip)
      {
         super(param1);
         this.FScene = param2;
         this.FTaskLists = new Vector.<TQuestDaily>(MAX_COUNT);
         this.FMCs = new Vector.<Sprite>(MAX_COUNT);
         this.FMC_BmpIcons = new Vector.<Bitmap>(MAX_COUNT);
         this.FIconIds = new Vector.<uint>(MAX_COUNT);
         this.FDailytask = SLogicsCore.Character.DailyTask;
         this.InitTaskList();
      }
      
      protected function InitTaskList() : void
      {
         var _loc1_:int = 0;
         var _loc2_:MovieClip = null;
         var _loc3_:Bitmap = null;
         _loc1_ = 0;
         while(_loc1_ < MAX_COUNT)
         {
            _loc2_ = this.FScene[CONST_DAILY_QUEST.RESOURCE_Link_MC_RefreshTasks + _loc1_];
            _loc2_.buttonMode = true;
            this.FMC_BmpIcon = _loc2_[CONST_DAILY_QUEST.RESOURCE_Link_MC_Bmp_Icon];
            this.FMC_Tag = _loc2_[CONST_DAILY_QUEST.RESOURCE_Link_MC_Tag];
            this.FMC_Tag.visible = false;
            _loc3_ = new Bitmap();
            this.FMC_BmpIcons[_loc1_] = _loc3_;
            this.FMC_BmpIcon.addChild(_loc3_);
            this.FMC_SelectedBox = _loc2_[CONST_DAILY_QUEST.RESOURCE_Link_MC_SelectedBox];
            this.FMC_Bmp_IconHighLight = _loc2_[CONST_DAILY_QUEST.RESOURCE_Link_MC_Bmp_IconHighLight];
            _loc2_.addEventListener(MouseEvent.ROLL_OVER,this.OnOver);
            _loc2_.addEventListener(MouseEvent.ROLL_OUT,this.OnOut);
            _loc2_.addEventListener(MouseEvent.CLICK,this.OnClick);
            _loc2_.addEventListener(MouseEvent.MOUSE_MOVE,this.OnMove);
            this.FMC_Bmp_IconHighLight.visible = false;
            this.FMC_SelectedBox.visible = false;
            _loc2_["MC_Effect"].visible = false;
            this.FMCs[_loc1_] = _loc2_;
            _loc1_++;
         }
      }
      
      protected function AutoLoadCallBack(param1:Object, param2:TTexture, param3:uint) : void
      {
         var _loc4_:TAnimationSequence = null;
         var _loc5_:BitmapData = null;
         _loc4_ = param2.GetAnimationSequenceByIndex(0);
         _loc5_ = _loc4_.GetAnimationFrameByIndex(0).Surface;
         switch(param3)
         {
            case this.FIconIds[0]:
               this.FMC_BmpIcons[0].bitmapData = _loc5_;
               break;
            case this.FIconIds[1]:
               this.FMC_BmpIcons[1].bitmapData = _loc5_;
               break;
            case this.FIconIds[2]:
               this.FMC_BmpIcons[2].bitmapData = _loc5_;
               break;
            case this.FIconIds[3]:
               this.FMC_BmpIcons[3].bitmapData = _loc5_;
               break;
            case this.FIconIds[4]:
               this.FMC_BmpIcons[4].bitmapData = _loc5_;
         }
      }
      
      protected function OnOver(param1:MouseEvent) : void
      {
         param1.currentTarget.MC_Bmp_IconHighLight.visible = true;
         param1.currentTarget.mc_over.visible = true;
         param1.currentTarget.mc_over.gotoAndPlay(1);
      }
      
      protected function OnOut(param1:MouseEvent) : void
      {
         param1.currentTarget.MC_Bmp_IconHighLight.visible = false;
         param1.currentTarget.mc_over.visible = false;
         if(this.FOnTaskOut != null)
         {
            this.FOnTaskOut(this,this);
         }
      }
      
      protected function OnClick(param1:MouseEvent) : void
      {
         var _loc2_:uint = 0;
         _loc2_ = 0;
         while(_loc2_ < MAX_COUNT)
         {
            this.FMCs[_loc2_]["MC_SelectedBox"].visible = false;
            _loc2_++;
         }
         param1.currentTarget.MC_SelectedBox.visible = true;
         _loc2_ = this.FMCs.indexOf(param1.currentTarget);
         if(this.FOnTaskClick != null)
         {
            this.FOnTaskClick(_loc2_);
         }
         if(this.FTutorialNextStep != null)
         {
            this.FTutorialNextStep(CONST_FRESHGUIDE.EVENTID_ClickDailyTaskCard);
         }
      }
      
      protected function OnMove(param1:MouseEvent) : void
      {
         var _loc2_:uint = 0;
         _loc2_ = this.FMCs.indexOf(param1.currentTarget);
         if(_loc2_ < 0)
         {
            return;
         }
         if(this.FOnTaskOver != null)
         {
            this.FOnTaskOver(this,_loc2_);
         }
      }
      
      public function get OnTaskClick() : Function
      {
         return this.FOnTaskClick;
      }
      
      public function set OnTaskClick(param1:Function) : void
      {
         this.FOnTaskClick = param1;
      }
      
      public function get OnTaskOver() : Function
      {
         return this.FOnTaskOver;
      }
      
      public function set OnTaskOver(param1:Function) : void
      {
         this.FOnTaskOver = param1;
      }
      
      public function get OnTaskOut() : Function
      {
         return this.FOnTaskOut;
      }
      
      public function set OnTaskOut(param1:Function) : void
      {
         this.FOnTaskOut = param1;
      }
      
      public function set TutorialNextStep(param1:Function) : void
      {
         this.FTutorialNextStep = param1;
      }
      
      public function SetTag(param1:uint, param2:uint) : void
      {
         var _loc3_:int = 0;
         _loc3_ = 0;
         while(_loc3_ < MAX_COUNT)
         {
            this.FMCs[_loc3_]["MC_Tag"].visible = false;
            if(_loc3_ == param2)
            {
               this.FMCs[_loc3_]["MC_Tag"].gotoAndStop(param1);
               this.FMCs[_loc3_]["MC_Tag"].visible = true;
               this.FMCs[_loc3_]["MC_SelectedBox"].visible = true;
            }
            else
            {
               this.FMCs[_loc3_]["MC_SelectedBox"].visible = false;
            }
            _loc3_++;
         }
      }
      
      public function UpdataTaskList() : void
      {
         var _loc1_:int = 0;
         var _loc2_:MovieClip = null;
         var _loc3_:TQuestDaily = null;
         var _loc4_:uint = 0;
         _loc1_ = 0;
         while(_loc1_ < MAX_COUNT)
         {
            _loc3_ = this.FDailytask.GetTaskByIndex(_loc1_);
            _loc4_ = _loc3_.SmallPic;
            this.FIconIds[_loc1_] = _loc4_;
            _loc2_ = this.FScene[CONST_DAILY_QUEST.RESOURCE_Link_MC_RefreshTasks + _loc1_];
            SResourcesCore.TexturesDailytaskPicture.LoadAutoSecondary(_loc4_,this.AutoLoadCallBack);
            _loc1_++;
         }
      }
      
      public function SetEffect(param1:uint, param2:Boolean) : void
      {
         var _loc3_:uint = 0;
         _loc3_ = 0;
         while(_loc3_ < MAX_COUNT)
         {
            this.FMCs[_loc3_]["MC_Effect"].visible = false;
            _loc3_++;
         }
         if(param2)
         {
            this.FMCs[param1]["MC_Effect"].visible = true;
            this.FMCs[param1]["MC_Effect"].play();
         }
         else
         {
            this.FMCs[param1]["MC_Effect"].visible = false;
         }
      }
      
      public function ResetBmp() : void
      {
         var _loc1_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < MAX_COUNT)
         {
            this.FMC_BmpIcons[_loc1_].bitmapData = null;
            _loc1_++;
         }
      }
   }
}

