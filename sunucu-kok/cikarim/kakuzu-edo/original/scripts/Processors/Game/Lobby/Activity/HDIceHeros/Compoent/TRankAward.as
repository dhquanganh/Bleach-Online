package Processors.Game.Lobby.Activity.HDIceHeros.Compoent
{
   import Foundation.Resources.Textures.TAnimationSequence;
   import Foundation.UI.TUIComponent;
   import Resources.Constants.CONST_ACTIVITY;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class TRankAward extends TUIComponent
   {
      
      protected static const TITLE_HEIGHT:uint = 58;
      
      protected var FSence:Sprite;
      
      protected var FTF_Rank:TextField;
      
      protected var FMC_Bag:Sprite;
      
      protected var FTitleAnimationSequence:TAnimationSequence;
      
      protected var FTitleID:uint;
      
      protected var FTimeStore:int;
      
      protected var FOnBagOver:Function;
      
      protected var FOnBagOut:Function;
      
      public function TRankAward(param1:TUIComponent, param2:Sprite)
      {
         super(param1);
         this.FSence = param2;
      }
      
      protected function RankAwardInit() : void
      {
         var _loc1_:Sprite = null;
         this.FTF_Rank = this.FSence[CONST_ACTIVITY.RESOURCE_Link_TF_Rank];
         this.FMC_Bag = this.FSence[CONST_ACTIVITY.RESOURCE_Link_MC_RedBag];
         this.FMC_Bag.addEventListener(MouseEvent.MOUSE_MOVE,this.BagOnMove);
         this.FMC_Bag.addEventListener(MouseEvent.MOUSE_OUT,this.BagOnOut);
      }
      
      private function BagOnOut(param1:MouseEvent) : void
      {
         if(this.FOnBagOut != null)
         {
            this.FOnBagOut(this);
         }
      }
      
      private function BagOnMove(param1:MouseEvent) : void
      {
         if(this.FOnBagOver != null)
         {
            this.FOnBagOver(this,Tag);
         }
      }
      
      protected function UpdateUI(param1:String) : void
      {
         this.FTF_Rank.text = param1;
      }
      
      public function get OnBagOver() : Function
      {
         return this.FOnBagOver;
      }
      
      public function set OnBagOver(param1:Function) : void
      {
         this.FOnBagOver = param1;
      }
      
      public function get OnBagOut() : Function
      {
         return this.FOnBagOut;
      }
      
      public function set OnBagOut(param1:Function) : void
      {
         this.FOnBagOut = param1;
      }
      
      public function Init() : void
      {
         this.RankAwardInit();
      }
      
      public function UpdateRankAwar(param1:String, param2:uint) : void
      {
         this.FTitleID = param2;
         this.UpdateUI(param1);
      }
      
      public function UpdatePerform() : void
      {
      }
      
      public function Reset() : void
      {
         this.FTitleAnimationSequence = null;
      }
   }
}

