package Processors.Game.Lobby.HeroCompanion.CardEmploy.EmployEffect
{
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Logics.DatebaseVO.VO.TCompanionCard;
   import Logics.HeroCompanion.THeroCompanionChipData;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import Processors.Game.Lobby.HeroCompanion.Components.TCompanionCardItem;
   import Resources.Constants.CONST_HEROCOMPANION;
   import flash.display.MovieClip;
   
   public class TCompanionEmployResult extends TProcessorLobbyWindow
   {
      
      protected var FMainUI:MovieClip;
      
      protected var FEffectTen:TCompanionEffectTen;
      
      protected var FEffectOne:TCompanionEffectOne;
      
      protected var FCardItem:TCompanionCardItem;
      
      protected var FEffect:MovieClip;
      
      protected var FTipOnOver:Function;
      
      protected var FTipOnOut:Function;
      
      public function TCompanionEmployResult(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         super.ResourcesPerform_UIDispatch();
         this.FMainUI = TUtilityReflection.CreateDisplayObjectInstance(CONST_HEROCOMPANION.ResourceID_EmployResult) as MovieClip;
         addChild(this.FMainUI);
         this.InitWindow();
      }
      
      protected function InitWindow() : void
      {
         this.FCardItem = new TCompanionCardItem(this.FMainUI["MC_Card"]);
         this.FEffect = this.FMainUI["MC_Effect"];
         this.FEffect.visible = false;
         this.FEffectTen = new TCompanionEffectTen();
         this.FEffectTen.OnClose = ProcessorWindowClose;
         this.FEffectTen.ItemOnOver = this.OnOver;
         this.FEffectTen.ItemOnOut = this.OnOut;
         this.FEffectTen.CardItem = this.FCardItem;
         this.FEffectTen.Effect = this.FEffect;
         this.FEffectTen.UIDispatch(this.FMainUI["MC_PlayTen"]);
         this.FEffectOne = new TCompanionEffectOne();
         this.FEffectOne.OnClose = ProcessorWindowClose;
         this.FEffectOne.ItemOnOver = this.OnOver;
         this.FEffectOne.ItemOnOut = this.OnOut;
         this.FEffectOne.CardItem = this.FCardItem;
         this.FEffectOne.Effect = this.FEffect;
         this.FEffectOne.UIDispatch(this.FMainUI["MC_PlayOne"]);
      }
      
      protected function OnOut() : void
      {
         this.FTipOnOut();
      }
      
      protected function OnOver(param1:Object) : void
      {
         this.FTipOnOver(param1);
      }
      
      public function get TipOnOver() : Function
      {
         return this.FTipOnOver;
      }
      
      public function set TipOnOver(param1:Function) : void
      {
         this.FTipOnOver = param1;
      }
      
      public function get TipOnOut() : Function
      {
         return this.FTipOnOut;
      }
      
      public function set TipOnOut(param1:Function) : void
      {
         this.FTipOnOut = param1;
      }
      
      public function Show(param1:Vector.<TCompanionCard>, param2:Vector.<THeroCompanionChipData>) : void
      {
         Visible = true;
         this.FMainUI.gotoAndPlay(1);
         if(param1.length + param2.length <= 1)
         {
            this.FEffectTen.Visible = false;
            this.FEffectOne.Visible = true;
            this.FEffectOne.SetData(param1,param2);
         }
         else
         {
            this.FEffectOne.Visible = false;
            this.FEffectTen.Visible = true;
            this.FEffectTen.SetData(param1,param2);
         }
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(!Visible)
         {
            return;
         }
         if(this.FEffectTen.Visible)
         {
            this.FEffectTen.LogicsPerform();
         }
         else if(this.FEffectOne.Visible)
         {
            this.FEffectOne.LogicsPerform();
         }
      }
   }
}

