package Processors.Game.Lobby.VoidSoulWorld
{
   import Foundation.Utilities.TUtilityReflection;
   import Resources.Constants.CONST_COMMON;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public class TPlayerSprite extends Sprite
   {
      
      protected var FMainUI:MovieClip;
      
      protected var FKey:String;
      
      public function TPlayerSprite(param1:String)
      {
         super();
         this.FKey = param1;
      }
      
      public function get Key() : String
      {
         return this.FKey;
      }
      
      public function UIDispatch() : void
      {
         this.FMainUI = TUtilityReflection.CreateDisplayObjectInstance("Role_" + this.FKey) as MovieClip;
         addChild(this.FMainUI);
         this.Reset();
      }
      
      public function Reset() : void
      {
         this.FMainUI.stop();
         this.FMainUI.MC_Fighting.visible = false;
         this.FMainUI.MC_Fighting.stop();
      }
      
      public function SetName(param1:String, param2:uint) : void
      {
         this.FMainUI.TF_Name.text = param1;
         this.FMainUI.TF_Name.textColor = CONST_COMMON.QUALITYCOLOR_INDEX[param2];
      }
      
      public function Fighting() : void
      {
         this.FMainUI.MC_Fighting.visible = true;
         this.FMainUI.MC_Fighting.play();
      }
      
      public function Run() : void
      {
         this.FMainUI.play();
      }
   }
}

