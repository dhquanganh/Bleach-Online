package Processors.Game.Lobby.HeroCompanion.CardEmploy.EmployEffect
{
   import Components.Standard.TUIButton;
   import Logics.DatebaseVO.VO.TCompanionCard;
   import Logics.HeroCompanion.THeroCompanionChipData;
   import Processors.Game.Lobby.HeroCompanion.Components.TCompanionCardItem;
   import Resources.Constants.CONST_COMMON;
   import flash.display.*;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.text.TextField;
   
   public class TCompanionBaseEffect
   {
      
      protected var FMainUI:MovieClip;
      
      protected var FTitle:MovieClip;
      
      protected var FInk:MovieClip;
      
      protected var FRewardUI:Sprite;
      
      protected var FBtnOk:TUIButton;
      
      protected var FTFDesc:TextField;
      
      protected var FCardVec:Vector.<TCompanionCard>;
      
      protected var FChipVec:Vector.<THeroCompanionChipData>;
      
      protected var FCardSourceX:int;
      
      protected var FCardSourceY:int;
      
      protected var FCardOriginX:int;
      
      protected var FCardOriginY:int;
      
      protected var FCardOffsetX:int;
      
      protected var FCardOffsetY:int;
      
      protected var FBigCardOffsetX:int;
      
      protected var FBigCardOffsetY:int;
      
      protected var FOnClose:Function;
      
      protected var FItemOnOver:Function;
      
      protected var FItemOnOut:Function;
      
      protected var FCardItem:TCompanionCardItem;
      
      protected var FEffect:MovieClip;
      
      public function TCompanionBaseEffect()
      {
         super();
      }
      
      protected function OnOkClick(param1:Object, param2:MouseEvent) : void
      {
         this.FOnClose();
      }
      
      protected function OnOut() : void
      {
         this.FItemOnOut();
      }
      
      protected function OnOver(param1:Object) : void
      {
         this.FItemOnOver(param1);
      }
      
      protected function MainPlayEnd() : void
      {
         this.FMainUI.stop();
         this.FBtnOk.Substrate.mouseEnabled = true;
      }
      
      public function get ItemOnOver() : Function
      {
         return this.FItemOnOver;
      }
      
      public function set ItemOnOver(param1:Function) : void
      {
         this.FItemOnOver = param1;
      }
      
      public function get ItemOnOut() : Function
      {
         return this.FItemOnOut;
      }
      
      public function set ItemOnOut(param1:Function) : void
      {
         this.FItemOnOut = param1;
      }
      
      public function get Visible() : Boolean
      {
         return this.FMainUI.visible;
      }
      
      public function set Visible(param1:Boolean) : void
      {
         this.FMainUI.visible = param1;
         if(param1)
         {
            this.FMainUI.gotoAndPlay(1);
            this.FBtnOk.Substrate.mouseEnabled = false;
            if(this.FInk != null)
            {
               this.FInk.gotoAndPlay(1);
            }
         }
      }
      
      public function get OnClose() : Function
      {
         return this.FOnClose;
      }
      
      public function set OnClose(param1:Function) : void
      {
         this.FOnClose = param1;
      }
      
      public function get CardItem() : TCompanionCardItem
      {
         return this.FCardItem;
      }
      
      public function set CardItem(param1:TCompanionCardItem) : void
      {
         this.FCardItem = param1;
      }
      
      public function get Effect() : MovieClip
      {
         return this.FEffect;
      }
      
      public function set Effect(param1:MovieClip) : void
      {
         this.FEffect = param1;
      }
      
      public function UIDispatch(param1:MovieClip) : void
      {
         var _loc2_:Point = null;
         var _loc3_:Point = null;
         var _loc4_:Point = null;
         this.FMainUI = param1;
         this.FMainUI.addFrameScript(this.FMainUI.totalFrames - 1,this.MainPlayEnd);
         this.FRewardUI = this.FMainUI["MC_Reward"];
         this.FTitle = this.FMainUI["MC_Title"];
         this.FInk = this.FMainUI["MC_Ink"];
         this.FTFDesc = this.FMainUI["MC_Ok"]["TF_Desc"];
         this.FBtnOk = new TUIButton();
         this.FBtnOk.Substrate = this.FMainUI["MC_Ok"]["Btn_OK"];
         this.FBtnOk.OnClick = this.OnOkClick;
         this.FCardItem.Substrate.mouseChildren = false;
         this.FCardItem.Substrate.mouseEnabled = false;
         _loc2_ = this.FMainUI.globalToLocal(new Point(CONST_COMMON.STAGE_Width,-this.FCardItem.Substrate.height));
         this.FCardSourceX = _loc2_.x;
         this.FCardSourceY = _loc2_.y;
         this.FCardOriginX = this.FCardItem.Substrate.x;
         this.FCardOriginY = this.FCardItem.Substrate.y;
         this.FCardOffsetX = this.FCardItem.Substrate.x - this.FCardOriginX;
         this.FCardOffsetY = this.FCardItem.Substrate.y - this.FCardOriginY;
         this.FBigCardOffsetX = this.FMainUI.x + this.FRewardUI.x;
         this.FBigCardOffsetY = this.FMainUI.y + this.FRewardUI.y;
         this.Visible = false;
      }
      
      public function SetData(param1:Vector.<TCompanionCard>, param2:Vector.<THeroCompanionChipData>) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         this.FCardVec = param1;
         this.FChipVec = param2;
         if(param1.length > 0)
         {
            this.FTitle.gotoAndStop(1);
         }
         else
         {
            _loc4_ = int(param2.length);
            _loc3_ = 0;
            while(_loc3_ < _loc4_)
            {
               if(param2[_loc3_].TypeId > 0)
               {
                  this.FTitle.gotoAndStop(1);
                  return;
               }
               _loc3_++;
            }
            this.FTitle.gotoAndStop(2);
         }
      }
      
      public function LogicsPerform() : void
      {
      }
   }
}

