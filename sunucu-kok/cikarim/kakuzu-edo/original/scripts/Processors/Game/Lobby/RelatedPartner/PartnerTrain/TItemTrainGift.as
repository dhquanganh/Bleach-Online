package Processors.Game.Lobby.RelatedPartner.PartnerTrain
{
   import Components.Standard.TUIButton;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class TItemTrainGift
   {
      
      protected var FMainUI:Sprite;
      
      protected var FMCGet:Sprite;
      
      protected var FBtnGift:TUIButton;
      
      protected var FTFCount:TextField;
      
      protected var FStarOnClick:Function;
      
      protected var FStarOnMove:Function;
      
      protected var FStarOnOut:Function;
      
      protected var FStarIndex:int;
      
      public function TItemTrainGift(param1:Sprite)
      {
         super();
         this.FMainUI = param1;
         this.FMCGet = this.FMainUI["MC_Get"];
         this.FMCGet.visible = false;
         this.FTFCount = this.FMainUI["TF_Count"];
         this.FBtnGift = new TUIButton();
         this.FBtnGift.Substrate = this.FMainUI["MC_Gift"];
         this.FBtnGift.OnClick = this.BtnOnClick;
         this.FBtnGift.OnMove = this.BtnOnMouseEvent;
         this.FBtnGift.OnOut = this.BtnOnMouseEvent;
      }
      
      protected function BtnOnMouseEvent(param1:Object, param2:MouseEvent) : void
      {
         switch(param2.type)
         {
            case MouseEvent.MOUSE_MOVE:
               if(this.FStarOnMove != null)
               {
                  this.FStarOnMove(this.FStarIndex);
               }
               break;
            case MouseEvent.MOUSE_OUT:
               if(this.FStarOnOut != null)
               {
                  this.FStarOnOut(this.FStarIndex);
               }
         }
      }
      
      protected function BtnOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FMCGet.visible)
         {
            return;
         }
         if(this.FStarOnClick != null)
         {
            this.FStarOnClick(this.FStarIndex);
         }
      }
      
      public function get StarOnClick() : Function
      {
         return this.FStarOnClick;
      }
      
      public function set StarOnClick(param1:Function) : void
      {
         this.FStarOnClick = param1;
      }
      
      public function get StarOnMove() : Function
      {
         return this.FStarOnMove;
      }
      
      public function set StarOnMove(param1:Function) : void
      {
         this.FStarOnMove = param1;
      }
      
      public function get StarOnOut() : Function
      {
         return this.FStarOnOut;
      }
      
      public function set StarOnOut(param1:Function) : void
      {
         this.FStarOnOut = param1;
      }
      
      public function get StarIndex() : int
      {
         return this.FStarIndex;
      }
      
      public function set StarIndex(param1:int) : void
      {
         this.FStarIndex = param1;
      }
      
      public function SetStatus(param1:Boolean) : void
      {
         this.FMCGet.visible = param1;
      }
      
      public function SetEnabled(param1:Boolean) : void
      {
         this.FBtnGift.Enabled = param1;
      }
      
      public function SetStarCount(param1:int) : void
      {
         this.FTFCount.text = param1 + "";
      }
   }
}

