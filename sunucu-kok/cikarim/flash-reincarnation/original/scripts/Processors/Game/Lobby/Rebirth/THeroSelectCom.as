package Processors.Game.Lobby.Rebirth
{
   import Foundation.Resources.SResourcesCore;
   import Foundation.Resources.Textures.TTexture;
   import Foundation.UI.TUIComponent;
   import Logics.Characters.THero;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class THeroSelectCom extends TUIComponent
   {
      
      protected var FMainUI:MovieClip;
      
      protected var FHead:Bitmap;
      
      protected var FPropPowerCom:TPropPowerCom;
      
      protected var FAttackEffectCom:TAttackEffectCom;
      
      protected var FHero:THero;
      
      protected var FSelect:Function;
      
      public function THeroSelectCom(param1:TUIComponent)
      {
         super(param1);
      }
      
      protected function UpdateUI() : void
      {
         this.FMainUI.TF_Name.text = this.FHero.Name;
         this.FHead.bitmapData = null;
         SResourcesCore.TexturesHeadIcon.LoadAutoSecondary(this.FHero.SmallID,this.PicArrive);
         this.FMainUI.MC_Head.TF_RebirthCount.text = this.FHero.RebirthNum > 0 ? this.FHero.RebirthNum.toString() : "";
         this.FMainUI.MC_Head.TF_RebirthLevel.text = this.FHero.RebirthLevel.toString();
         this.FPropPowerCom.UpdateUI(this.FHero.PropPower,this.FHero.RebirthNum);
         this.FAttackEffectCom.UpdateUI(this.FHero.AttackEffect,this.FHero.RebirthNum);
      }
      
      protected function PicArrive(param1:Object, param2:TTexture, param3:uint) : void
      {
         this.FHead.bitmapData = param2.GetAnimationSequenceByIndex(0).GetAnimationFrameByIndex(0).Surface;
      }
      
      override public function set Visible(param1:Boolean) : void
      {
         super.Visible = param1;
         if(this.FMainUI != null)
         {
            this.FMainUI.visible = Visible;
         }
      }
      
      protected function OnClick(param1:MouseEvent) : void
      {
         this.FSelect(this.FHero);
      }
      
      public function set Hero(param1:THero) : void
      {
         this.FHero = param1;
         this.UpdateUI();
      }
      
      public function set Select(param1:Function) : void
      {
         this.FSelect = param1;
      }
      
      public function UIDispatch(param1:MovieClip) : void
      {
         this.FMainUI = param1;
         this.FHead = new Bitmap();
         this.FMainUI.MC_Head.MC_Bmp_Icon.addChild(this.FHead);
         this.FPropPowerCom = new TPropPowerCom(this);
         this.FPropPowerCom.UIDispatch(this.FMainUI.MC_PropPower);
         this.FAttackEffectCom = new TAttackEffectCom(this);
         this.FAttackEffectCom.UIDispatch(this.FMainUI.MC_AttackEffect);
         this.FMainUI.MC_Head.addEventListener(MouseEvent.CLICK,this.OnClick);
         this.FMainUI.MC_Head.buttonMode = true;
         this.FMainUI.MC_Head.TF_RebirthCount.mouseEnabled = false;
         this.FMainUI.MC_Head.TF_RebirthLevel.mouseEnabled = false;
      }
   }
}

