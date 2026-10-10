package Processors.Game.Lobby.Tavern
{
   import Foundation.Common.*;
   import Foundation.Common.Integer.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.Characters.*;
   import Processors.Game.Common.Effects.Display.*;
   import Processors.Game.Lobby.Components.TUICredits;
   import Processors.Game.Lobby.Utilities.*;
   import Processors.Game.Utilities.HyperLink.*;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Resources.Constants.*;
   import Resources.Strings.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class TProcessorWindowTavern extends TUIComponent
   {
      
      public static const CAPACITY_HeroSouls:int = CONST_CHARACTER.CAPACITY_HeroSouls;
      
      public static const HEROSOULINDEX_BlueSoul:int = CONST_CHARACTER.HEROSOULINDEX_BlueSoul;
      
      public static const HEROSOULINDEX_PurpleSoul:int = CONST_CHARACTER.HEROSOULINDEX_PurpleSoul;
      
      public static const HEROSOULINDEX_GoldSoul:int = CONST_CHARACTER.HEROSOULINDEX_GoldSoul;
      
      public static const HEROSOULINDEX_OrangeSoul:int = CONST_CHARACTER.HEROSOULINDEX_OrangeSoul;
      
      protected var FHelpTips:THint;
      
      protected var FScene:MovieClip;
      
      protected var FCharacter:TCharacter;
      
      protected var FUICredits:TUICredits;
      
      protected var FHeroSouls:Vector.<uint>;
      
      protected var FEffectFlickerHeroSouls:Vector.<TEffectBaseFlicker>;
      
      protected var FOnHelpTipsOver:Function;
      
      protected var FOnHelpTipsOut:Function;
      
      protected var FOnEnterCity:Function;
      
      public function TProcessorWindowTavern(param1:TUIComponent, param2:MovieClip)
      {
         var _loc3_:uint = 0;
         var _loc4_:TEffectBaseFlicker = null;
         super(param1);
         this.FHelpTips = new THint();
         this.FScene = param2;
         this.FCharacter = SLogicsCore.Character;
         this.FScene.btn_close.addEventListener(MouseEvent.CLICK,this.OnCloseTavern);
         this.FScene.btn_help.addEventListener(MouseEvent.MOUSE_MOVE,this.ButtonHelpOnOver,false,0,true);
         this.FScene.btn_help.addEventListener(MouseEvent.MOUSE_OUT,this.ButtonHelpOnOut,false,0,true);
         this.FUICredits = new TUICredits();
         this.FUICredits.Resource = this.FScene.MC_PanelCredits;
         this.FUICredits.HintOnMove = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FUICredits.HintOnOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FUICredits.OnAddSilverCoin = this.UICreditsOnAddSilverCoin;
         this.FHeroSouls = new Vector.<uint>(CAPACITY_HeroSouls);
         this.FEffectFlickerHeroSouls = new Vector.<TEffectBaseFlicker>(CAPACITY_HeroSouls);
         _loc3_ = 0;
         while(_loc3_ < CAPACITY_HeroSouls)
         {
            _loc4_ = new TEffectBaseFlicker();
            this.FEffectFlickerHeroSouls[_loc3_] = _loc4_;
            _loc3_++;
         }
      }
      
      protected function LogicsPerform_SoulsEffect() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:uint = 0;
         var _loc4_:TEffectBaseFlicker = null;
         var _loc5_:uint = 0;
         _loc2_ = CAPACITY_HeroSouls;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = parseInt(this.GetTFHeroSoulByIndex(_loc1_).text);
            _loc4_ = this.FEffectFlickerHeroSouls[_loc1_];
            if(_loc3_ != this.GetHeroSoulByIndex(_loc1_) && _loc4_.IsRunOver)
            {
               _loc4_.SetParameters(this.GetTFHeroSoulByIndex(_loc1_));
            }
            _loc5_ = Math.ceil(Math.abs(this.GetHeroSoulByIndex(_loc1_) - _loc3_) / 2);
            if(_loc3_ > this.GetHeroSoulByIndex(_loc1_))
            {
               _loc3_ -= _loc5_;
            }
            else if(_loc3_ < this.GetHeroSoulByIndex(_loc1_))
            {
               _loc3_ += _loc5_;
            }
            this.GetTFHeroSoulByIndex(_loc1_).text = _loc3_.toString();
            _loc1_++;
         }
         this.UpdateEffectsGlow();
      }
      
      protected function UpdateEffectsGlow() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TEffectBaseFlicker = null;
         _loc2_ = int(this.FEffectFlickerHeroSouls.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FEffectFlickerHeroSouls[_loc1_];
            if(!_loc3_.IsRunOver)
            {
               _loc3_.Run();
            }
            _loc1_++;
         }
      }
      
      protected function GetTFHeroSoulByIndex(param1:uint) : TextField
      {
         switch(param1)
         {
            case HEROSOULINDEX_BlueSoul:
               return this.FScene.tf_blueSoul;
            case HEROSOULINDEX_PurpleSoul:
               return this.FScene.tf_purpleSoul;
            case HEROSOULINDEX_GoldSoul:
               return this.FScene.tf_goldSoul;
            case HEROSOULINDEX_OrangeSoul:
               return this.FScene.tf_orangeSoul;
            default:
               return null;
         }
      }
      
      override protected function ProcessorResize() : void
      {
         var _loc1_:uint = 0;
         _loc1_ = FUICore.StageWidth;
         if(this.FScene != null)
         {
            this.FScene.btn_close.x = _loc1_ - this.FScene.btn_close.width;
            this.FScene.btn_help.x = _loc1_ - this.FScene.btn_close.width - this.FScene.btn_help.width;
         }
      }
      
      protected function UICreditsOnAddSilverCoin(param1:Object) : void
      {
         SUtilityHyperLink.ShortcutHyperlink(TUtilityHyperLink.HyperLink_HellButterfly);
      }
      
      protected function OnCloseTavern(param1:MouseEvent) : void
      {
         if(this.FOnEnterCity != null)
         {
            this.FOnEnterCity(this);
         }
      }
      
      protected function ButtonHelpOnOver(param1:MouseEvent) : void
      {
         if(TUtilityString.Empty(this.FHelpTips.Content))
         {
            this.FHelpTips.Content = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HELPTIPS_Tavern);
         }
         if(this.FOnHelpTipsOver != null)
         {
            this.FOnHelpTipsOver(this,this.FHelpTips);
         }
      }
      
      protected function ButtonHelpOnOut(param1:MouseEvent) : void
      {
         if(this.FOnHelpTipsOut != null)
         {
            this.FOnHelpTipsOut(this,this.FHelpTips);
         }
      }
      
      public function GetHeroSoulByIndex(param1:int) : uint
      {
         return this.FHeroSouls[param1];
      }
      
      public function SetHeroSoulByIndex(param1:int, param2:uint) : void
      {
         this.FHeroSouls[param1] = param2;
      }
      
      override public function set Visible(param1:Boolean) : void
      {
         if(this.FScene == null)
         {
            return;
         }
         this.FScene.visible = param1;
      }
      
      override public function get Visible() : Boolean
      {
         if(this.FScene == null)
         {
            return false;
         }
         return this.FScene.visible;
      }
      
      public function get OnHelpTipsOver() : Function
      {
         return this.FOnHelpTipsOver;
      }
      
      public function set OnHelpTipsOver(param1:Function) : void
      {
         this.FOnHelpTipsOver = param1;
      }
      
      public function get OnHelpTipsOut() : Function
      {
         return this.FOnHelpTipsOut;
      }
      
      public function set OnHelpTipsOut(param1:Function) : void
      {
         this.FOnHelpTipsOut = param1;
      }
      
      public function set OnEnterCity(param1:Function) : void
      {
         this.FOnEnterCity = param1;
      }
      
      public function get OnEnterCity() : Function
      {
         return this.FOnEnterCity;
      }
      
      public function UpdataEffect() : void
      {
         this.FUICredits.UpdateEffect();
         this.LogicsPerform_SoulsEffect();
      }
      
      public function UpdataPublicUI() : void
      {
         this.FUICredits.UpdatePanel();
         this.FScene.tf_blueSoul.text = this.FCharacter.HeroSoulBlueSoul.toString();
         this.FScene.tf_purpleSoul.text = this.FCharacter.HeroSoulPurpleSoul.toString();
         this.FScene.tf_goldSoul.text = this.FCharacter.HeroSoulGoldSoul.toString();
         this.FScene.tf_orangeSoul.text = this.FCharacter.HeroSoulOrangeSoul.toString();
         this.FHeroSouls[0] = this.FCharacter.HeroSoulBlueSoul;
         this.FHeroSouls[1] = this.FCharacter.HeroSoulPurpleSoul;
         this.FHeroSouls[2] = this.FCharacter.HeroSoulGoldSoul;
         this.FHeroSouls[3] = this.FCharacter.HeroSoulOrangeSoul;
      }
      
      public function MoraLog(param1:int, param2:int) : void
      {
         this.FScene.tf_moraLog.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TAVERN_STRING_10),param1,TUtilityLobby.GetColorNameByIndex(param2));
      }
      
      public function EnableBtn(param1:Boolean) : void
      {
         this.FScene.mouseEnabled = param1;
         this.FScene.mouseChildren = param1;
      }
   }
}

