package Processors.Game.Lobby.SevenKing
{
   import Components.Standard.TUIButton;
   import Foundation.Common.THint;
   import Foundation.Resources.Bins.TBins;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityString;
   import Logics.Characters.TCharacter;
   import Logics.DatebaseVO.VO.TSevenHeroSoul;
   import Logics.SLogicsCore;
   import Processors.Game.Common.Effects.Display.TEffectBaseFlicker;
   import Processors.Game.Lobby.Components.TUICredits;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Resources.Constants.CONST_CHARACTER;
   import Resources.Constants.CONST_COMMON;
   import Resources.Constants.CONST_DATEBASEVO;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class TProcessorWindowSevenKing extends TUIComponent
   {
      
      protected static const CONST_SOUL:int = CONST_COMMON.CAPACITY_KingSouls;
      
      protected static const CAPACITY_Credits:int = CONST_CHARACTER.CAPACITY_Credits - 2;
      
      protected static const CREDITINDEX_Gold:int = CONST_CHARACTER.CREDITINDEX_Gold;
      
      protected static const CREDITINDEX_SilverCoin:int = CONST_CHARACTER.CREDITINDEX_SilverCoin;
      
      protected static const CREDITINDEX_GiftCertificate:int = CONST_CHARACTER.CREDITINDEX_GiftCertificate;
      
      protected var FHelpTips:THint;
      
      protected var FHintSilverCoin:THint;
      
      protected var FScene:MovieClip;
      
      protected var FCharacter:TCharacter;
      
      protected var FUICredits:TUICredits;
      
      protected var FHeroSouls:Vector.<uint>;
      
      protected var FEffectFlickerSoul:Vector.<TEffectBaseFlicker>;
      
      protected var FSoulNumList:Vector.<TextField>;
      
      protected var FBT_ToStars:TUIButton;
      
      protected var FOnHelpTipsOver:Function;
      
      protected var FOnHelpTipsOut:Function;
      
      protected var FOnEnterCity:Function;
      
      protected var FUIComponentsOnOver:Function;
      
      protected var FUIComponentsOnOut:Function;
      
      protected var FOnToStars:Function;
      
      public function TProcessorWindowSevenKing(param1:TUIComponent, param2:MovieClip)
      {
         var _loc3_:uint = 0;
         var _loc4_:TEffectBaseFlicker = null;
         var _loc5_:uint = 0;
         var _loc6_:MovieClip = null;
         var _loc7_:TextField = null;
         super(param1);
         this.FHelpTips = new THint();
         this.FHintSilverCoin = new THint();
         this.FScene = param2;
         this.FCharacter = SLogicsCore.Character;
         this.FScene.mc_autoPoint.btn_close.addEventListener(MouseEvent.CLICK,this.OnCloseTavern);
         this.FScene.mc_autoPoint.btn_help.addEventListener(MouseEvent.MOUSE_MOVE,this.ButtonHelpOnOver,false,0,true);
         this.FScene.mc_autoPoint.btn_help.addEventListener(MouseEvent.MOUSE_OUT,this.ButtonHelpOnOut,false,0,true);
         this.FUICredits = new TUICredits();
         this.FUICredits.Resource = this.FScene.MC_PanelCredits;
         this.FUICredits.HintOnMove = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FUICredits.HintOnOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FHeroSouls = new Vector.<uint>(CONST_SOUL);
         this.FEffectFlickerSoul = new Vector.<TEffectBaseFlicker>(CONST_SOUL);
         _loc3_ = 0;
         while(_loc3_ < CONST_SOUL)
         {
            _loc4_ = new TEffectBaseFlicker();
            this.FEffectFlickerSoul[_loc3_] = _loc4_;
            _loc3_++;
         }
         this.FSoulNumList = new Vector.<TextField>(CONST_SOUL);
         _loc5_ = uint(CONST_SOUL);
         _loc3_ = 1;
         while(_loc3_ < _loc5_)
         {
            _loc7_ = this.FScene["tf_Soul_" + _loc3_];
            _loc7_.selectable = false;
            _loc7_.addEventListener(MouseEvent.MOUSE_MOVE,this.MCKingSoulOnOver,false,0,true);
            _loc7_.addEventListener(MouseEvent.MOUSE_OUT,this.MCKingSoulOnOut,false,0,true);
            this.FSoulNumList[_loc3_ - 1] = _loc7_;
            _loc3_++;
         }
         this.FScene["tf_Soul_0"].selectable = false;
         this.FScene["tf_Soul_0"].addEventListener(MouseEvent.MOUSE_MOVE,this.MCKingSoulOnOver,false,0,true);
         this.FScene["tf_Soul_0"].addEventListener(MouseEvent.MOUSE_OUT,this.MCKingSoulOnOut,false,0,true);
         this.FSoulNumList[_loc3_ - 1] = this.FScene["tf_Soul_0"];
         this.FBT_ToStars = new TUIButton();
         this.FBT_ToStars.Substrate = this.FScene["BT_ToStars"];
         this.FBT_ToStars.OnClick = this.StarsOnClick;
      }
      
      protected function LogicsPerform_SoulsEffect() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:uint = 0;
         var _loc4_:TEffectBaseFlicker = null;
         var _loc5_:uint = 0;
         _loc2_ = CONST_SOUL;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = parseInt(this.GetTFHeroSoulByIndex(_loc1_).text);
            _loc4_ = this.FEffectFlickerSoul[_loc1_];
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
         _loc2_ = int(this.FEffectFlickerSoul.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FEffectFlickerSoul[_loc1_];
            if(!_loc3_.IsRunOver)
            {
               _loc3_.Run();
            }
            _loc1_++;
         }
      }
      
      protected function GetTFHeroSoulByIndex(param1:uint) : TextField
      {
         return this.FScene["tf_Soul_" + param1];
      }
      
      override protected function ProcessorResize() : void
      {
         var _loc1_:uint = 0;
         _loc1_ = FUICore.StageWidth;
         if(this.FScene != null)
         {
            this.FScene.mc_autoPoint.x = _loc1_ - this.FScene.mc_autoPoint.width;
            this.FBT_ToStars.Substrate.x = _loc1_ - this.FBT_ToStars.Substrate.width;
         }
      }
      
      protected function StarsOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FOnToStars != null)
         {
            this.FOnToStars(this);
         }
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
            this.FHelpTips.Content = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HELPTIPS_SevenKing);
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
      
      protected function MCKingSoulOnOut(param1:MouseEvent) : void
      {
         if(this.FUIComponentsOnOut != null)
         {
            this.FUIComponentsOnOut(this);
         }
      }
      
      protected function MCKingSoulOnOver(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:uint = 0;
         var _loc4_:TSevenHeroSoul = null;
         var _loc5_:TextField = null;
         var _loc6_:TBins = null;
         _loc5_ = param1.currentTarget as TextField;
         _loc6_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_SevenHeroSoul) as TBins;
         _loc2_ = this.FSoulNumList.indexOf(_loc5_);
         _loc4_ = _loc6_.GetDatebaseByIndex(_loc2_) as TSevenHeroSoul;
         if(this.FUIComponentsOnOver != null)
         {
            this.FUIComponentsOnOver(this,_loc4_);
         }
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
      
      public function GetHeroSoulByIndex(param1:int) : uint
      {
         return this.FHeroSouls[param1];
      }
      
      public function SetHeroSoulByIndex(param1:int, param2:uint) : void
      {
         this.FHeroSouls[param1] = param2;
      }
      
      public function get UIComponentsOnOver() : Function
      {
         return this.FUIComponentsOnOver;
      }
      
      public function set UIComponentsOnOver(param1:Function) : void
      {
         this.FUIComponentsOnOver = param1;
      }
      
      public function get UIComponentsOnOut() : Function
      {
         return this.FUIComponentsOnOut;
      }
      
      public function set UIComponentsOnOut(param1:Function) : void
      {
         this.FUIComponentsOnOut = param1;
      }
      
      public function get OnToStars() : Function
      {
         return this.FOnToStars;
      }
      
      public function set OnToStars(param1:Function) : void
      {
         this.FOnToStars = param1;
      }
      
      public function UpdataEffect() : void
      {
         this.FUICredits.UpdateEffect();
         this.LogicsPerform_SoulsEffect();
      }
      
      public function UpdataPublicUI() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         this.FUICredits.UpdatePanel();
         _loc1_ = 0;
         while(_loc1_ < CONST_SOUL)
         {
            _loc2_ = this.FCharacter.GetKingSoulByIndex(_loc1_);
            this.FScene["tf_Soul_" + _loc1_].text = _loc2_;
            this.FHeroSouls[_loc1_] = _loc2_;
            _loc1_++;
         }
      }
   }
}

