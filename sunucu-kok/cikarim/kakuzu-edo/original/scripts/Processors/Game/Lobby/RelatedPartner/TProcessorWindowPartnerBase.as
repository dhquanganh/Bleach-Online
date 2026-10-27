package Processors.Game.Lobby.RelatedPartner
{
   import Components.ScrollBar.TScrollBar;
   import Foundation.UI.TUIComponent;
   import Logics.Characters.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.RelatedPartner.TRelatedPartnerHeroSkill;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import Processors.Game.Lobby.RelatedPartner.Component.TRenderHeroSkill;
   import Resources.Constants.*;
   import flash.display.Sprite;
   
   public class TProcessorWindowPartnerBase extends TProcessorLobbyWindow
   {
      
      protected static const BG_Detail:int = CONST_RELATEDPARTNER.BG_Detail;
      
      protected static const BG_Hero:int = CONST_RELATEDPARTNER.BG_Hero;
      
      protected var FScrollBar:TScrollBar;
      
      protected var FMCAlert:Sprite;
      
      protected var FGotoUpgrade:Function;
      
      protected var FGotoPosition:Function;
      
      protected var FGotoAssistance:Function;
      
      protected var FGotoTrain:Function;
      
      protected var FGotoLink:Function;
      
      protected var FHintOver:Function;
      
      protected var FHintOut:Function;
      
      public function TProcessorWindowPartnerBase(param1:TUIComponent)
      {
         super(param1);
      }
      
      protected function UpdateHeroRender(param1:TRelatedPartnerHeroSkill) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TRenderHeroSkill = null;
         _loc3_ = int(this.FScrollBar.Items.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc6_ = this.FScrollBar.Items[_loc2_] as TRenderHeroSkill;
            if(_loc6_.TypeId == param1.Partner.Type)
            {
               _loc6_.Update(param1);
               break;
            }
            _loc2_++;
         }
      }
      
      protected function OnGotoTrain(param1:int) : void
      {
         this.FGotoTrain(param1);
      }
      
      protected function OnGotoPosition() : void
      {
         this.FGotoPosition();
      }
      
      protected function OnGotoAssistance() : void
      {
         this.FGotoAssistance();
      }
      
      protected function OnGotoUpgrade(param1:TRelatedPartnerHeroSkill) : void
      {
         this.FGotoUpgrade(param1);
      }
      
      protected function OnGotoLink(param1:String) : void
      {
         this.FGotoLink(param1);
      }
      
      protected function OnHintOver(param1:int, param2:TRelatedPartnerHeroSkill) : void
      {
         this.FHintOver(param1,param2);
      }
      
      protected function OnHintOut() : void
      {
         this.FHintOut();
      }
      
      public function get GotoUpgrade() : Function
      {
         return this.FGotoUpgrade;
      }
      
      public function set GotoUpgrade(param1:Function) : void
      {
         this.FGotoUpgrade = param1;
      }
      
      public function get GotoPosition() : Function
      {
         return this.FGotoPosition;
      }
      
      public function set GotoPosition(param1:Function) : void
      {
         this.FGotoPosition = param1;
      }
      
      public function get GotoAssistance() : Function
      {
         return this.FGotoAssistance;
      }
      
      public function set GotoAssistance(param1:Function) : void
      {
         this.FGotoAssistance = param1;
      }
      
      public function get GotoTrain() : Function
      {
         return this.FGotoTrain;
      }
      
      public function set GotoTrain(param1:Function) : void
      {
         this.FGotoTrain = param1;
      }
      
      public function get IconOver() : Function
      {
         return this.FHintOver;
      }
      
      public function set IconOver(param1:Function) : void
      {
         this.FHintOver = param1;
      }
      
      public function get IconOut() : Function
      {
         return this.FHintOut;
      }
      
      public function set IconOut(param1:Function) : void
      {
         this.FHintOut = param1;
      }
      
      public function get GotoLink() : Function
      {
         return this.FGotoLink;
      }
      
      public function set GotoLink(param1:Function) : void
      {
         this.FGotoLink = param1;
      }
   }
}

