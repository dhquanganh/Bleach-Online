package Processors.Game.Lobby.Achievement
{
   import Components.Standard.TUIButton;
   import Foundation.Common.THint;
   import Foundation.Resources.SResourcesCore;
   import Foundation.Resources.Textures.TTexture;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityFilter;
   import Foundation.Utilities.TUtilityString;
   import Logics.Achievenment.TAchievementGroupInfor;
   import Logics.Achievenment.TAchievementInfor;
   import Logics.Achievenment.TAchievementSchedule;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class TProcessorWindowAchievementGroup extends TUIComponent
   {
      
      protected static const ConditionFormatString:String = "%0(%1/%2)\n";
      
      protected static const SLOTNUM:int = 6;
      
      protected var FMainUI:Sprite;
      
      protected var FTFGroupName:TextField;
      
      protected var FTFScheduel:TextField;
      
      protected var FScheduelBar:Sprite;
      
      protected var FBtnPageLeft:TUIButton;
      
      protected var FBtnPageRight:TUIButton;
      
      protected var FSlots:Vector.<Sprite>;
      
      protected var FMouseOverFlag:Vector.<MovieClip>;
      
      protected var FEffectComplete:Vector.<MovieClip>;
      
      protected var FNewFlag:Vector.<MovieClip>;
      
      protected var FFollowFlag:Vector.<Sprite>;
      
      protected var FPicMountPoint:Vector.<Bitmap>;
      
      protected var FStartIndex:int;
      
      protected var FEndIndex:int;
      
      protected var FToolHint:THint;
      
      protected var FTipFormatString:String;
      
      protected var FAchievementGroupInfor:TAchievementGroupInfor;
      
      protected var FOnHintOver:Function;
      
      protected var FOnHintOut:Function;
      
      protected var FOnAchievementClick:Function;
      
      public function TProcessorWindowAchievementGroup(param1:TUIComponent)
      {
         super(param1);
      }
      
      protected function UIDispatch(param1:Sprite) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Sprite = null;
         var _loc4_:MovieClip = null;
         var _loc5_:Bitmap = null;
         this.FMainUI = param1;
         this.FTFGroupName = this.FMainUI["Name"];
         this.FTFScheduel = this.FMainUI["Bar"]["Scheduel"];
         this.FScheduelBar = this.FMainUI["Bar"]["ScheduelBar"];
         this.FBtnPageLeft = new TUIButton();
         this.FBtnPageLeft.Substrate = this.FMainUI["PageLeft"];
         this.FBtnPageRight = new TUIButton();
         this.FBtnPageRight.Substrate = this.FMainUI["PageRight"];
         this.FSlots = new Vector.<Sprite>();
         this.FMouseOverFlag = new Vector.<MovieClip>();
         this.FEffectComplete = new Vector.<MovieClip>();
         this.FNewFlag = new Vector.<MovieClip>();
         this.FFollowFlag = new Vector.<Sprite>();
         this.FPicMountPoint = new Vector.<Bitmap>();
         _loc2_ = 0;
         while(_loc2_ < SLOTNUM)
         {
            _loc3_ = this.FMainUI["Slot" + _loc2_];
            _loc3_.mouseChildren = false;
            _loc3_.buttonMode = true;
            this.FSlots.push(_loc3_);
            this.FMouseOverFlag.push(_loc3_["MouseOverFlag"]);
            this.FEffectComplete.push(_loc3_["EffectComplete"]);
            this.FNewFlag.push(_loc3_["NewFlag"]);
            this.FFollowFlag.push(_loc3_["FllowFlag"]);
            _loc3_ = _loc3_["PicMountPoint"];
            _loc5_ = new Bitmap();
            _loc3_.addChild(_loc5_);
            this.FPicMountPoint.push(_loc5_);
            _loc2_++;
         }
         this.FToolHint = new THint();
      }
      
      protected function UILocation() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Sprite = null;
         this.FBtnPageLeft.OnClick = this.PageLeftOnClick;
         this.FBtnPageRight.OnClick = this.PageRightOnClick;
         _loc1_ = 0;
         while(_loc1_ < SLOTNUM)
         {
            _loc2_ = this.FSlots[_loc1_];
            _loc2_.addEventListener(MouseEvent.MOUSE_OVER,this.SlotOnMouseOver);
            _loc2_.addEventListener(MouseEvent.MOUSE_OUT,this.SlotOnMouseOut);
            _loc2_.addEventListener(MouseEvent.MOUSE_MOVE,this.SlotOnMouseMove);
            _loc2_.addEventListener(MouseEvent.CLICK,this.SlotOnMouseClick);
            _loc1_++;
         }
         this.FTipFormatString = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.Achievement_String_05);
      }
      
      protected function Update_Perform() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TAchievementInfor = null;
         var _loc4_:Number = NaN;
         this.FTFGroupName.text = this.FAchievementGroupInfor.GroupName;
         this.FTFScheduel.text = this.FAchievementGroupInfor.CurrentSchedule + "/" + this.FAchievementGroupInfor.TotalSchedule;
         _loc4_ = this.FAchievementGroupInfor.CurrentSchedule / this.FAchievementGroupInfor.TotalSchedule;
         _loc4_ = _loc4_ > 1 ? 1 : _loc4_;
         this.FScheduelBar.scaleX = _loc4_;
         _loc1_ = this.FStartIndex;
         while(_loc1_ < this.FEndIndex)
         {
            _loc3_ = this.FAchievementGroupInfor.AchievementInfors.GetAchievementByIndex(_loc1_);
            this.UpdateSlotsByIndex(_loc1_ - this.FStartIndex,_loc3_);
            _loc1_++;
         }
         this.ClearSlotsInfor(_loc1_,SLOTNUM);
      }
      
      protected function UpdateSlotsByIndex(param1:int, param2:TAchievementInfor) : void
      {
         this.FSlots[param1].visible = true;
         if(param2.IfComplete && !param2.IfGotReward)
         {
            this.FEffectComplete[param1].play();
            this.FEffectComplete[param1].visible = true;
         }
         else
         {
            this.FEffectComplete[param1].visible = false;
         }
         this.FNewFlag[param1].visible = param2.IfNew;
         param2.IfNew = false;
         this.FFollowFlag[param1].visible = param2.IfFollow;
         SResourcesCore.TexturesAchievementIcon.LoadAutoSecondary(param2.ID,this.PicArrive);
         if(param2.IfGotReward || param2.IfComplete)
         {
            this.FPicMountPoint[param1].filters = null;
         }
         else
         {
            this.FPicMountPoint[param1].filters = [TUtilityFilter.GaryColorFiltersTwo];
         }
      }
      
      protected function PicArrive(param1:Object, param2:TTexture, param3:int) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TAchievementInfor = null;
         _loc4_ = this.FStartIndex;
         while(_loc4_ < this.FEndIndex)
         {
            _loc6_ = this.FAchievementGroupInfor.AchievementInfors.GetAchievementByIndex(_loc4_);
            if(_loc6_.ID == param3)
            {
               this.FPicMountPoint[_loc4_ - this.FStartIndex].bitmapData = param2.GetAnimationSequenceByIndex(0).GetAnimationFrameByIndex(0).Surface;
            }
            _loc4_++;
         }
      }
      
      protected function ClearSlotsInfor(param1:int, param2:int) : void
      {
         var _loc3_:int = 0;
         _loc3_ = param1;
         while(_loc3_ < param2)
         {
            this.FMouseOverFlag[_loc3_].visible = false;
            this.FEffectComplete[_loc3_].stop();
            this.FEffectComplete[_loc3_].visible = false;
            this.FNewFlag[_loc3_].visible = false;
            this.FFollowFlag[_loc3_].visible = false;
            this.FPicMountPoint[_loc3_].bitmapData = null;
            this.FSlots[_loc3_].visible = false;
            this.FPicMountPoint[_loc3_].filters = null;
            _loc3_++;
         }
      }
      
      protected function VerificationIndex(param1:int) : Boolean
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Boolean = false;
         _loc4_ = false;
         _loc2_ = 0;
         _loc3_ = this.FAchievementGroupInfor.AchievementInfors.Count - SLOTNUM;
         _loc3_ = _loc3_ < 0 ? 0 : _loc3_;
         if(param1 <= _loc3_ && param1 >= _loc2_)
         {
            this.FStartIndex = param1;
            _loc4_ = true;
         }
         this.FEndIndex = this.FStartIndex + SLOTNUM;
         this.FEndIndex = this.FEndIndex > this.FAchievementGroupInfor.AchievementInfors.Count ? this.FAchievementGroupInfor.AchievementInfors.Count : this.FEndIndex;
         return _loc4_;
      }
      
      protected function UpdateBtn() : void
      {
         this.FBtnPageLeft.Enabled = this.FStartIndex > 0;
         this.FBtnPageRight.Enabled = this.FStartIndex + SLOTNUM < this.FAchievementGroupInfor.AchievementInfors.Count;
      }
      
      protected function PageLeftOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.VerificationIndex(this.FStartIndex - 1))
         {
            this.Update_Perform();
            this.UpdateBtn();
         }
      }
      
      protected function PageRightOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.VerificationIndex(this.FStartIndex + 1))
         {
            this.Update_Perform();
            this.UpdateBtn();
         }
      }
      
      protected function SlotOnMouseOver(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         _loc2_ = this.FSlots.indexOf(param1.currentTarget as Sprite);
         this.FMouseOverFlag[_loc2_].gotoAndPlay(1);
         this.FMouseOverFlag[_loc2_].visible = true;
      }
      
      protected function SlotOnMouseMove(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:TAchievementInfor = null;
         var _loc4_:String = null;
         var _loc5_:TAchievementSchedule = null;
         _loc2_ = this.FSlots.indexOf(param1.currentTarget as Sprite);
         _loc4_ = "";
         _loc3_ = this.FAchievementGroupInfor.AchievementInfors.GetAchievementByIndex(this.FStartIndex + _loc2_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_.AchievementSchedules.length)
         {
            _loc5_ = _loc3_.AchievementSchedules[_loc2_];
            _loc4_ += TUtilityString.Format(ConditionFormatString,_loc5_.ConditionStrings,_loc5_.CurrentSchedule,_loc5_.Value);
            _loc2_++;
         }
         this.FToolHint.Caption = TUtilityString.Format(this.FTipFormatString,_loc3_.Name,_loc4_);
         if(this.FOnHintOver != null)
         {
            this.FOnHintOver(this,this.FToolHint);
         }
      }
      
      protected function SlotOnMouseOut(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         _loc2_ = this.FSlots.indexOf(param1.currentTarget as Sprite);
         this.FMouseOverFlag[_loc2_].visible = false;
         if(this.FOnHintOut != null)
         {
            this.FOnHintOut(this,this.FToolHint);
         }
      }
      
      protected function SlotOnMouseClick(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:TAchievementInfor = null;
         _loc2_ = this.FSlots.indexOf(param1.currentTarget as Sprite);
         _loc3_ = this.FAchievementGroupInfor.AchievementInfors.GetAchievementByIndex(this.FStartIndex + _loc2_);
         if(this.FOnAchievementClick != null)
         {
            this.FOnAchievementClick(_loc3_);
         }
      }
      
      public function set AchievementGroupInfor(param1:TAchievementGroupInfor) : void
      {
         this.FAchievementGroupInfor = param1;
      }
      
      override public function set Visible(param1:Boolean) : void
      {
         super.Visible = param1;
         if(this.FMainUI != null)
         {
            this.FMainUI.visible = param1;
         }
      }
      
      public function set OnAchievementClick(param1:Function) : void
      {
         this.FOnAchievementClick = param1;
      }
      
      public function set OnHintOver(param1:Function) : void
      {
         this.FOnHintOver = param1;
      }
      
      public function set OnHintOut(param1:Function) : void
      {
         this.FOnHintOut = param1;
      }
      
      public function SendResource(param1:Sprite) : void
      {
         this.UIDispatch(param1);
         this.UILocation();
      }
      
      public function Update() : void
      {
         this.UpdateBtn();
         this.VerificationIndex(0);
         this.Update_Perform();
      }
      
      public function Reset() : void
      {
         this.ClearSlotsInfor(0,SLOTNUM);
         this.FStartIndex = 0;
      }
   }
}

