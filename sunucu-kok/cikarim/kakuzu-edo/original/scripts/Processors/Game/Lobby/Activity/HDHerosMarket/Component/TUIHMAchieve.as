package Processors.Game.Lobby.Activity.HDHerosMarket.Component
{
   import Components.Standard.TUIButton;
   import Foundation.UI.TUIComponent;
   import Logics.DatebaseVO.VO.THDHerosMarket;
   import Logics.Inventories.TInventory;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class TUIHMAchieve extends TUIComponent
   {
      
      protected var FTF_Text:TextField;
      
      protected var FMC_Award:Sprite;
      
      protected var FMC_AlreadyGet:Sprite;
      
      protected var FBtn_Ok:TUIButton;
      
      protected var FIndex:uint;
      
      protected var FAward:TInventory;
      
      protected var FData:THDHerosMarket;
      
      protected var FStatus:int;
      
      protected var FFlag:uint;
      
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
      
      public function TUIHMAchieve(param1:TUIComponent)
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
         this.FBtn_Ok.Substrate = param1["Btn_OK"];
         this.FBtn_Ok.OnClick = this.OkOnClick;
         this.FTF_Text = param1["TF_text"];
         this.FMC_Award.addEventListener(MouseEvent.MOUSE_MOVE,this.AwardOnMove);
         this.FMC_Award.addEventListener(MouseEvent.MOUSE_OUT,this.AwardOnOut);
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
         if(this.FFlag == 0)
         {
            this.FTF_Text.text = this.FData.HerosAchieveTips[this.FIndex].toString();
         }
         else
         {
            this.FTF_Text.text = this.FData.KnifeAchieveTips[this.FIndex].toString();
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
      
      public function UpdateUI(param1:uint, param2:THDHerosMarket, param3:int, param4:uint) : void
      {
         this.FIndex = param1;
         this.FData = param2;
         this.FStatus = param3;
         this.FFlag = param4;
         this.Update();
      }
      
      public function Reset() : void
      {
      }
   }
}

