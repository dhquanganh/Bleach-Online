package Processors.Game.Lobby.Pet.Components
{
   import Components.Standard.*;
   import Foundation.UI.*;
   import Logics.Pet.Gift.*;
   import Processors.Game.Lobby.Utilities.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class TUIItemGift extends TUIComponent
   {
      
      protected var FTF_Name:TextField;
      
      protected var FBtn_Get:TUIButton;
      
      protected var FInitialization:Boolean;
      
      protected var FResource:Sprite;
      
      protected var FContext:TGift;
      
      protected var FOnClick:Function;
      
      protected var FOnOver:Function;
      
      protected var FOnOut:Function;
      
      public function TUIItemGift(param1:TUIComponent)
      {
         super(param1);
      }
      
      protected function Initialization() : void
      {
         this.FResource.mouseEnabled = false;
         this.FTF_Name = this.FResource[CONST_PET.RESOURCE_Link_TF_Name];
         this.FBtn_Get = new TUIButton();
         this.FBtn_Get.Substrate = this.FResource[CONST_PET.RESOURCE_Link_Btn_Get];
         this.FBtn_Get.OnClick = this.BtnGetOnClick;
         this.Reset();
         this.FInitialization = true;
      }
      
      protected function UpdateUIItemGift() : void
      {
         if(this.FResource == null)
         {
            return;
         }
         this.FTF_Name.text = this.FContext.Name;
         this.FBtn_Get.Enabled = !this.FContext.Status && this.FContext.IsUserLevel && this.FContext.IsMainPetStage && this.FContext.IsVicePetNum;
         if(this.FContext.Status)
         {
            this.FBtn_Get.Caption = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_PET_07);
         }
         else
         {
            this.FBtn_Get.Caption = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_PET_08);
         }
      }
      
      protected function addEventListenerUI() : void
      {
         if(this.FResource == null)
         {
            return;
         }
         this.FTF_Name.addEventListener(MouseEvent.MOUSE_MOVE,this.TF_NameOnMove,false,0,true);
         this.FTF_Name.addEventListener(MouseEvent.MOUSE_OUT,this.TF_NameOnOut,false,0,true);
      }
      
      protected function RemoveEventListenerUI() : void
      {
         if(this.FResource == null)
         {
            return;
         }
         this.FTF_Name.removeEventListener(MouseEvent.MOUSE_MOVE,this.TF_NameOnMove);
         this.FTF_Name.removeEventListener(MouseEvent.MOUSE_OUT,this.TF_NameOnOut);
      }
      
      protected function BtnGetOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FOnClick != null)
         {
            this.FOnClick(this,this.FContext);
         }
      }
      
      protected function TF_NameOnMove(param1:MouseEvent) : void
      {
         if(this.FOnOver != null)
         {
            this.FOnOver(this,this.FContext);
         }
      }
      
      protected function TF_NameOnOut(param1:MouseEvent) : void
      {
         if(this.FOnOut != null)
         {
            this.FOnOut(this,this.FContext);
         }
      }
      
      public function get Resource() : Sprite
      {
         return this.FResource;
      }
      
      public function set Resource(param1:Sprite) : void
      {
         if(param1 == null)
         {
            return;
         }
         if(param1 != this.FResource)
         {
            this.FResource = param1;
         }
         if(!this.FInitialization)
         {
            this.Initialization();
         }
      }
      
      public function get OnClick() : Function
      {
         return this.FOnClick;
      }
      
      public function set OnClick(param1:Function) : void
      {
         this.FOnClick = param1;
      }
      
      public function get OnOver() : Function
      {
         return this.FOnOver;
      }
      
      public function set OnOver(param1:Function) : void
      {
         this.FOnOver = param1;
      }
      
      public function get OnOut() : Function
      {
         return this.FOnOut;
      }
      
      public function set OnOut(param1:Function) : void
      {
         this.FOnOut = param1;
      }
      
      override public function set Visible(param1:Boolean) : void
      {
         super.Visible = param1;
         if(!this.FInitialization)
         {
            return;
         }
         this.FResource.visible = param1;
      }
      
      public function get Context() : TGift
      {
         return this.FContext;
      }
      
      public function set Context(param1:TGift) : void
      {
         this.Reset();
         this.FContext = param1;
         if(param1 != null)
         {
            this.UpdateUIItemGift();
            this.addEventListenerUI();
         }
         else
         {
            this.RemoveEventListenerUI();
         }
      }
      
      public function Reset() : void
      {
         if(this.FResource == null)
         {
            return;
         }
         this.FTF_Name.text = "";
      }
   }
}

