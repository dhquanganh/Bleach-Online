package Processors.Game.Lobby.Activity.HDChess.Component
{
   import Components.Standard.TUIButton;
   import Foundation.UI.TUIComponent;
   import Logics.HDChess.TActivityChessAward;
   import Logics.Inventories.TInventory;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class TUIAchieveItem extends TUIComponent
   {
      
      protected var FMC_Dices:Vector.<MovieClip>;
      
      protected var FMC_Award:MovieClip;
      
      protected var FMC_AlreadyGet:MovieClip;
      
      protected var FBtn_Ok:TUIButton;
      
      protected var FIndex:uint;
      
      protected var FAward:TInventory;
      
      protected var FData:TActivityChessAward;
      
      protected var FStatus:int;
      
      protected var FOnSlotOver:Function;
      
      protected var FOnSlotOut:Function;
      
      protected var FOnQuerySequenceContext:Function;
      
      protected var FOnQuerySubscript:Function;
      
      protected var FOnBtnOkClick:Function;
      
      protected var FOnBtnOkOut:Function;
      
      protected var FOnBtnOkMove:Function;
      
      protected var FOnHintOver:Function;
      
      protected var FOnHintOut:Function;
      
      protected var FOnEffectText:Function;
      
      public function TUIAchieveItem(param1:TUIComponent)
      {
         super(param1);
      }
      
      protected function Resources_UIDispatch(param1:Sprite) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         addChild(param1);
         this.FMC_Award = param1["MC_Award"];
         this.FMC_AlreadyGet = param1["MC_AlreadyGet"];
         this.FBtn_Ok = new TUIButton();
         this.FBtn_Ok.Substrate = param1["Btn_Ok"];
         this.FBtn_Ok.OnClick = this.OkOnClick;
         this.FMC_Award.addEventListener(MouseEvent.MOUSE_MOVE,this.AwardOnMove);
         this.FMC_Award.addEventListener(MouseEvent.MOUSE_OUT,this.AwardOnOut);
         _loc3_ = 3;
         this.FMC_Dices = new Vector.<MovieClip>(3);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FMC_Dices[_loc2_] = param1["MC_Dice_" + _loc2_];
            _loc2_++;
         }
      }
      
      protected function OkOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FOnBtnOkClick != null)
         {
            this.FOnBtnOkClick(this,this.FIndex);
         }
      }
      
      protected function Update() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         _loc2_ = 3;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FMC_Dices[_loc1_]["MC_DicePic"].gotoAndStop(this.FData.Condition[_loc1_]);
            _loc1_++;
         }
         if(this.FStatus > 0)
         {
            this.FBtn_Ok.Visible = true;
            this.FBtn_Ok.Enabled = true;
            this.FMC_AlreadyGet.visible = false;
         }
         if(this.FStatus == 0)
         {
            this.FBtn_Ok.Visible = true;
            this.FBtn_Ok.Enabled = false;
            this.FMC_AlreadyGet.visible = false;
         }
         if(this.FStatus < 0)
         {
            this.FBtn_Ok.Visible = false;
            this.FBtn_Ok.Enabled = true;
            this.FMC_AlreadyGet.visible = true;
         }
      }
      
      protected function AwardOnMove(param1:MouseEvent) : void
      {
         if(this.FOnSlotOver != null)
         {
            this.FOnSlotOver(this,this.FIndex);
         }
      }
      
      protected function AwardOnOut(param1:MouseEvent) : void
      {
         if(this.FOnSlotOut != null)
         {
            this.FOnSlotOut(this);
         }
      }
      
      public function get OnQuerySequenceContext() : Function
      {
         return this.FOnQuerySequenceContext;
      }
      
      public function set OnQuerySequenceContext(param1:Function) : void
      {
         this.FOnQuerySequenceContext = param1;
      }
      
      public function get OnSlotOver() : Function
      {
         return this.FOnSlotOver;
      }
      
      public function set OnSlotOver(param1:Function) : void
      {
         this.FOnSlotOver = param1;
      }
      
      public function get OnSlotOut() : Function
      {
         return this.FOnSlotOut;
      }
      
      public function set OnSlotOut(param1:Function) : void
      {
         this.FOnSlotOut = param1;
      }
      
      public function get OnQuerySubscript() : Function
      {
         return this.FOnQuerySubscript;
      }
      
      public function set OnQuerySubscript(param1:Function) : void
      {
         this.FOnQuerySubscript = param1;
      }
      
      public function get OnBtnOkClick() : Function
      {
         return this.FOnBtnOkClick;
      }
      
      public function set OnBtnOkClick(param1:Function) : void
      {
         this.FOnBtnOkClick = param1;
      }
      
      public function get OnBtnOkOut() : Function
      {
         return this.FOnBtnOkOut;
      }
      
      public function set OnBtnOkOut(param1:Function) : void
      {
         this.FOnBtnOkOut = param1;
      }
      
      public function get OnBtnOkMove() : Function
      {
         return this.FOnBtnOkMove;
      }
      
      public function set OnBtnOkMove(param1:Function) : void
      {
         this.FOnBtnOkMove = param1;
      }
      
      public function get OnEffectText() : Function
      {
         return this.FOnEffectText;
      }
      
      public function set OnEffectText(param1:Function) : void
      {
         this.FOnEffectText = param1;
      }
      
      public function Perform_UIDispatch(param1:Sprite) : void
      {
         this.Resources_UIDispatch(param1);
      }
      
      public function UpdateUI(param1:uint, param2:TInventory, param3:TActivityChessAward, param4:int) : void
      {
         this.FIndex = param1;
         this.FAward = param2;
         this.FData = param3;
         this.FStatus = param4;
         this.Update();
      }
      
      public function Reset() : void
      {
      }
   }
}

