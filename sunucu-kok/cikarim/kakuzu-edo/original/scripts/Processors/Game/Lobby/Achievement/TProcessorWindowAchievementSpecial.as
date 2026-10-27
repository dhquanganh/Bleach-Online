package Processors.Game.Lobby.Achievement
{
   import Foundation.Common.THint;
   import Foundation.Resources.SResourcesCore;
   import Foundation.Resources.Textures.TTexture;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityFilter;
   import Foundation.Utilities.TUtilityString;
   import Logics.Achievenment.TAchievementClassInfor;
   import Logics.Achievenment.TAchievementGroupInfor;
   import Logics.Achievenment.TAchievementInfor;
   import Logics.Achievenment.TAchievementInfors;
   import Logics.Achievenment.TAchievementSchedule;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class TProcessorWindowAchievementSpecial extends TUIComponent
   {
      
      protected static const ConditionFormatString:String = "%0(%1/%2)\n";
      
      protected var SLOTNUM:int = 2;
      
      protected var FMainUI:Sprite;
      
      protected var FSlots:Vector.<Sprite>;
      
      protected var FMouseOverFlag:Vector.<MovieClip>;
      
      protected var FEffectComplete:Vector.<MovieClip>;
      
      protected var FFollowFlag:Vector.<Sprite>;
      
      protected var FPicMountPoint:Vector.<Bitmap>;
      
      protected var FStartIndex:int;
      
      protected var FEndIndex:int;
      
      protected var FAchievementInfors:TAchievementInfors;
      
      protected var FToolHint:THint;
      
      protected var FTipFormatString:String;
      
      protected var FAchievementClassInfor:TAchievementClassInfor;
      
      protected var FOnAchievementClick:Function;
      
      protected var FOnHintOver:Function;
      
      protected var FOnHintOut:Function;
      
      public function TProcessorWindowAchievementSpecial(param1:TUIComponent)
      {
         super(param1);
         this.FAchievementInfors = new TAchievementInfors();
      }
      
      protected function UIDispatch(param1:Sprite) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Sprite = null;
         var _loc4_:Bitmap = null;
         this.FMainUI = param1;
         this.FSlots = new Vector.<Sprite>();
         this.FMouseOverFlag = new Vector.<MovieClip>();
         this.FEffectComplete = new Vector.<MovieClip>();
         this.FFollowFlag = new Vector.<Sprite>();
         this.FPicMountPoint = new Vector.<Bitmap>();
         _loc2_ = 0;
         while(_loc2_ < this.SLOTNUM)
         {
            _loc3_ = this.FMainUI["Special" + _loc2_];
            _loc3_.mouseChildren = false;
            _loc3_.buttonMode = true;
            this.FSlots.push(_loc3_);
            this.FMouseOverFlag.push(_loc3_["MouseOverFlag"]);
            this.FEffectComplete.push(_loc3_["EffectComplete"]);
            this.FFollowFlag.push(_loc3_["FllowFlag"]);
            _loc3_ = _loc3_["PicMountPoint"];
            _loc4_ = new Bitmap();
            _loc3_.addChild(_loc4_);
            this.FPicMountPoint.push(_loc4_);
            _loc2_++;
         }
         this.FToolHint = new THint();
      }
      
      protected function UILocation() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Sprite = null;
         _loc1_ = 0;
         while(_loc1_ < this.SLOTNUM)
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
         this.FStartIndex = 0;
         this.FEndIndex = this.FAchievementInfors.Count;
         _loc1_ = this.FStartIndex;
         while(_loc1_ < this.FEndIndex)
         {
            _loc3_ = this.FAchievementInfors.GetAchievementByIndex(_loc1_);
            this.UpdateSlotsByIndex(_loc1_ - this.FStartIndex,_loc3_);
            _loc1_++;
         }
         this.ClearSlotsInfor(_loc1_,this.SLOTNUM);
      }
      
      protected function UpdateSlotsByIndex(param1:int, param2:TAchievementInfor) : void
      {
         if(param2.IfComplete && !param2.IfGotReward)
         {
            this.FEffectComplete[param1].play();
            this.FEffectComplete[param1].visible = true;
         }
         else
         {
            this.FEffectComplete[param1].visible = false;
         }
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
         this.FSlots[param1].visible = true;
      }
      
      protected function PicArrive(param1:Object, param2:TTexture, param3:int) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TAchievementInfor = null;
         _loc4_ = this.FStartIndex;
         while(_loc4_ < this.FEndIndex)
         {
            _loc6_ = this.FAchievementInfors.GetAchievementByIndex(_loc4_);
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
            this.FFollowFlag[_loc3_].visible = false;
            this.FPicMountPoint[_loc3_].bitmapData = null;
            this.FPicMountPoint[_loc3_].filters = null;
            this.FSlots[_loc3_].visible = false;
            _loc3_++;
         }
      }
      
      protected function GetAllAchievement() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:TAchievementGroupInfor = null;
         this.FAchievementInfors.Clear();
         _loc1_ = 0;
         while(_loc1_ < this.FAchievementClassInfor.AchivementGroups.length)
         {
            _loc5_ = this.FAchievementClassInfor.AchivementGroups[_loc1_];
            _loc2_ = 0;
            while(_loc2_ < _loc5_.AchievementInfors.Count)
            {
               this.FAchievementInfors.Add(_loc5_.AchievementInfors.GetAchievementByIndex(_loc2_));
               _loc2_++;
            }
            _loc1_++;
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
         _loc3_ = this.FAchievementInfors.GetAchievementByIndex(this.FStartIndex + _loc2_);
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
      
      protected function SlotOnMouseClick(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:TAchievementInfor = null;
         _loc2_ = this.FSlots.indexOf(param1.currentTarget as Sprite);
         _loc3_ = this.FAchievementInfors.GetAchievementByIndex(this.FStartIndex + _loc2_);
         if(this.FOnAchievementClick != null)
         {
            this.FOnAchievementClick(_loc3_);
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
      
      public function set AchievementClassInfor(param1:TAchievementClassInfor) : void
      {
         this.FAchievementClassInfor = param1;
         this.GetAllAchievement();
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
         this.Update_Perform();
      }
      
      public function Reset() : void
      {
         this.ClearSlotsInfor(0,this.SLOTNUM);
         this.FStartIndex = 0;
      }
   }
}

