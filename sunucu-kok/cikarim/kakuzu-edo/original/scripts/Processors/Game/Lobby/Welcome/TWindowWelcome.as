package Processors.Game.Lobby.Welcome
{
   import Components.Standard.TUIButton;
   import Foundation.Resources.SResourcesCore;
   import Foundation.Resources.Textures.TTexture;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Resources.Constants.CONST_FRESHGUIDE;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class TWindowWelcome extends TProcessorLobbyWindow
   {
      
      protected var FComponentNipGirl:TComponentNipGirl;
      
      protected var FMainUI:Sprite;
      
      protected var FMCWelcome:MovieClip;
      
      protected var FTFWelcome:TextField;
      
      protected var FMountPoint:Bitmap;
      
      protected var FBtnChangeClothes:TUIButton;
      
      protected var FOnChangeClothes:Function;
      
      public function TWindowWelcome(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         this.FMainUI = TUtilityReflection.CreateDisplayObjectInstance("UIWelcome") as Sprite;
         addChild(this.FMainUI);
         this.FMCWelcome = this.FMainUI["WelcomeEffect"];
         this.FTFWelcome = this.FMCWelcome["EffectInner"]["WelcomeTF"];
         this.FMountPoint = new Bitmap();
         this.FMainUI["MountPoint"].addChild(this.FMountPoint);
         this.FBtnChangeClothes = new TUIButton();
         this.FBtnChangeClothes.Substrate = this.FMainUI["Btn_ChangeClothes"];
         this.FBtnChangeClothes.OnClick = this.ChangeClothesOnClick;
         this.FComponentNipGirl = new TComponentNipGirl(this);
         TutorialSendComponent(CONST_FRESHGUIDE.MCID_ClickWelcome,this);
         TutorialSendArrowParent(CONST_FRESHGUIDE.MCID_ClickWelcome,this);
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         this.FTFWelcome.text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_Nip_04);
         super.ResourcesPerform_UILocations();
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(Visible && FIsResourcesLoadCompleted)
         {
            if(this.FMCWelcome.currentFrame == this.FMCWelcome.totalFrames)
            {
               this.FMCWelcome.stop();
            }
         }
      }
      
      protected function PicArrive(param1:Object, param2:TTexture, param3:uint) : void
      {
         this.FMountPoint.bitmapData = param2.GetAnimationSequenceByIndex(0).GetAnimationFrameByIndex(0).Surface;
      }
      
      protected function ChangeClothesOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FOnChangeClothes != null)
         {
            this.FOnChangeClothes(this);
         }
      }
      
      public function get OnChangeClothes() : Function
      {
         return this.FOnChangeClothes;
      }
      
      public function set OnChangeClothes(param1:Function) : void
      {
         this.FOnChangeClothes = param1;
      }
      
      public function Reset() : void
      {
         this.FComponentNipGirl.Reset();
      }
      
      public function Action() : void
      {
         this.FMCWelcome.gotoAndPlay(1);
         SResourcesCore.TexturesMiddlePic.LoadAutoSecondary(102030,this.PicArrive);
      }
   }
}

