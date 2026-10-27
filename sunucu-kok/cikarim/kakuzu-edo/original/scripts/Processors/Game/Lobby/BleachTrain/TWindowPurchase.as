package Processors.Game.Lobby.BleachTrain
{
   import Components.Standard.TUIButton;
   import Foundation.Resources.SResourcesCore;
   import Foundation.Resources.Textures.TTexture;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class TWindowPurchase extends TProcessorLobbyWindow
   {
      
      protected var FMainScene:Sprite;
      
      protected var FMountPoint:Bitmap;
      
      protected var FTFOriginalPrice:TextField;
      
      protected var FTFNowPrice:TextField;
      
      protected var FBtnBuy:TUIButton;
      
      protected var FBtnCancle:TUIButton;
      
      protected var FOnHideWindow:Function;
      
      protected var FOnBuyBtnClick:Function;
      
      protected var FGroupID:uint;
      
      protected var FBagIndex:uint;
      
      public function TWindowPurchase(param1:TUIComponent)
      {
         super(param1);
      }
      
      public function UIDispatch() : void
      {
         var _loc1_:Bitmap = null;
         this.FMainScene = TUtilityReflection.CreateDisplayObjectInstance("BleachTrainPurchase") as Sprite;
         addChild(this.FMainScene);
         this.FMountPoint = new Bitmap();
         this.FMainScene["MC_Slot"]["MC_Bmp_Icon"].addChild(this.FMountPoint);
         this.FTFOriginalPrice = this.FMainScene["MC_Price"]["TF_OriginalPrice"];
         this.FTFNowPrice = this.FMainScene["MC_Price"]["TF_NowPrice"];
         this.FBtnBuy = new TUIButton();
         this.FBtnBuy.Substrate = this.FMainScene["BTN_Confirm"];
         this.FBtnBuy.OnClick = this.BtnBuyOnMouseClick;
         this.FBtnCancle = new TUIButton();
         this.FBtnCancle.Substrate = this.FMainScene["BTN_Cancel"];
         this.FBtnCancle.OnClick = this.BtnCancleOnMouseClick;
      }
      
      protected function PicArrive(param1:Object, param2:TTexture, param3:uint) : void
      {
         this.FMountPoint.bitmapData = param2.GetAnimationSequenceByIndex(0).GetAnimationFrameByIndex(0).Surface;
      }
      
      protected function BtnBuyOnMouseClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FOnBuyBtnClick != null)
         {
            this.FOnBuyBtnClick(this.FGroupID,this.FBagIndex);
         }
         if(this.FOnHideWindow != null)
         {
            this.FOnHideWindow(this);
         }
         this.Visible = false;
      }
      
      protected function BtnCancleOnMouseClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FOnHideWindow != null)
         {
            this.FOnHideWindow(this);
         }
         this.Visible = false;
      }
      
      public function set OnBuyBtnClick(param1:Function) : void
      {
         this.FOnBuyBtnClick = param1;
      }
      
      public function set OnHideWindow(param1:Function) : void
      {
         this.FOnHideWindow = param1;
      }
      
      public function Show(param1:int, param2:int, param3:int, param4:uint, param5:uint) : void
      {
         this.FGroupID = param4;
         this.FBagIndex = param5;
         SResourcesCore.TexturesInventory.LoadAutoSecondary(param1,this.PicArrive);
         this.FTFOriginalPrice.text = param2.toString();
         this.FTFNowPrice.text = param3.toString();
         this.Visible = true;
      }
   }
}

