package Processors.Game.Lobby.GirlGame
{
   import Components.Standard.TUIButton;
   import Foundation.Common.THint;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Logics.GirlGame.TGirlInfor;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class TComponentClothes extends TUIComponent
   {
      
      protected static const MaxClothesSize:int = 6;
      
      protected var Mode_Explore:int = 0;
      
      protected var Mode_Enjoy:int = 1;
      
      protected var FMainUI:MovieClip;
      
      protected var FButtons:Vector.<TUIButton>;
      
      protected var FHint:THint;
      
      protected var FCurrentMode:int;
      
      protected var FOnBtnClick:Function;
      
      protected var FGirlInfor:TGirlInfor;
      
      public function TComponentClothes(param1:TUIComponent)
      {
         super(param1);
      }
      
      protected function UIDispatch() : void
      {
         var _loc1_:int = 0;
         var _loc2_:TUIButton = null;
         this.FMainUI = TUtilityReflection.CreateDisplayObjectInstance("ClothesArea") as MovieClip;
         addChild(this.FMainUI);
         this.FButtons = new Vector.<TUIButton>();
         _loc1_ = 0;
         while(_loc1_ < MaxClothesSize)
         {
            _loc2_ = new TUIButton();
            _loc2_.Substrate = this.FMainUI["Clothes" + _loc1_];
            _loc2_.OnClick = this.CallBack_BtnOnClick;
            _loc2_.OnMove = this.CallBack_BtnOnMove;
            _loc2_.OnOut = this.CallBack_BtnOnOut;
            this.FButtons.push(_loc2_);
            _loc1_++;
         }
         this.FHint = new THint();
      }
      
      protected function UILocation() : void
      {
      }
      
      protected function UpdateClothes() : void
      {
         var _loc1_:int = 0;
         switch(this.FCurrentMode)
         {
            case this.Mode_Enjoy:
               _loc1_ = this.FGirlInfor.ScheduleHistory - 1;
               this.UpdateButtonEnjoy(_loc1_);
               break;
            case this.Mode_Explore:
               _loc1_ = this.FGirlInfor.CurrentSchedule;
               this.UpdateButtonExplore(_loc1_);
         }
      }
      
      protected function UpdateButtonExplore(param1:int) : void
      {
         var _loc2_:* = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         _loc3_ = int(this.FGirlInfor.Clothes.length);
         _loc2_ = 0;
         while(_loc2_ < this.FButtons.length)
         {
            this.FButtons[_loc2_].Enabled = false;
            this.FButtons[_loc2_].Visible = _loc2_ < _loc3_;
            _loc2_++;
         }
         _loc2_ = _loc4_ = _loc3_ - 1;
         while(_loc2_ >= param1)
         {
            this.FButtons[_loc2_].Enabled = true;
            _loc2_--;
         }
      }
      
      protected function UpdateButtonEnjoy(param1:int) : void
      {
         var _loc2_:* = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         _loc5_ = int(this.FGirlInfor.Clothes.length);
         _loc2_ = 0;
         while(_loc2_ < this.FButtons.length)
         {
            this.FButtons[_loc2_].Enabled = false;
            this.FButtons[_loc2_].Visible = _loc2_ < _loc5_;
            _loc2_++;
         }
         _loc3_ = _loc5_ - 1;
         _loc2_ = _loc3_;
         while(_loc2_ >= param1)
         {
            this.FButtons[_loc2_].Enabled = true;
            _loc2_--;
         }
      }
      
      protected function CallBack_BtnOnMove(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         switch(this.FCurrentMode)
         {
            case this.Mode_Enjoy:
               break;
            case this.Mode_Explore:
               _loc3_ = this.FButtons.indexOf(param1 as TUIButton);
               this.FHint.Caption = this.FGirlInfor.Clothes[_loc3_].RewardString;
               SUtilityOverLayer.UIComponentsHintOnOver(this,this.FHint);
         }
      }
      
      protected function CallBack_BtnOnOut(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         switch(this.FCurrentMode)
         {
            case this.Mode_Enjoy:
               break;
            case this.Mode_Explore:
               SUtilityOverLayer.UIComponentsHintOnOut(this,this.FHint);
         }
      }
      
      protected function CallBack_BtnOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         switch(this.FCurrentMode)
         {
            case this.Mode_Enjoy:
               _loc3_ = this.FButtons.indexOf(param1 as TUIButton);
               this.FOnBtnClick(this.FGirlInfor,_loc3_);
               break;
            case this.Mode_Explore:
         }
      }
      
      public function set OnBtnClick(param1:Function) : void
      {
         this.FOnBtnClick = param1;
      }
      
      public function set GirlInfor(param1:TGirlInfor) : void
      {
         this.FGirlInfor = param1;
      }
      
      public function LoadResources() : void
      {
         this.UIDispatch();
         this.UILocation();
      }
      
      public function SetupMode(param1:int, param2:TGirlInfor) : void
      {
         this.FCurrentMode = param1;
         this.FGirlInfor = param2;
         this.UpdateClothes();
      }
      
      public function Update() : void
      {
         this.UpdateClothes();
      }
      
      public function ChangeGirl(param1:TGirlInfor) : void
      {
         this.FGirlInfor = param1;
         this.UpdateClothes();
      }
   }
}

