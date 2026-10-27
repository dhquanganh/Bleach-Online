package Processors.Game.Lobby.Components
{
   import Foundation.Common.*;
   import Foundation.Common.Integer.*;
   import Logics.*;
   import Logics.Characters.*;
   import Processors.Game.Common.Effects.Display.*;
   import Processors.Game.Lobby.Utilities.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class TUICredits
   {
      
      protected static const CAPACITY_Credits:int = CONST_CHARACTER.CAPACITY_Credits - 2;
      
      protected static const CREDITINDEX_Gold:int = CONST_CHARACTER.CREDITINDEX_Gold;
      
      protected static const CREDITINDEX_SilverCoin:int = CONST_CHARACTER.CREDITINDEX_SilverCoin;
      
      protected static const CREDITINDEX_GiftCertificate:int = CONST_CHARACTER.CREDITINDEX_GiftCertificate;
      
      protected var FCharacter:TCharacter;
      
      protected var FResource:Sprite;
      
      protected var FBtnRecharge:SimpleButton;
      
      protected var FBtnBleachAgent:SimpleButton;
      
      protected var FBtnAddSilverCoin:SimpleButton;
      
      protected var FHint:THint;
      
      protected var FSilverCoin:UInt64;
      
      protected var FTFCredits:Vector.<TextField>;
      
      protected var FEffectFlickerCredits:Vector.<TEffectBaseFlicker>;
      
      protected var FInitialization:Boolean;
      
      protected var FHintOnMove:Function;
      
      protected var FHintOnOut:Function;
      
      protected var FOnRecharge:Function;
      
      protected var FOnBleachAgent:Function;
      
      protected var FOnAddSilverCoin:Function;
      
      public function TUICredits()
      {
         super();
         this.FCharacter = SLogicsCore.Character;
         this.FSilverCoin = new UInt64();
         this.FTFCredits = new Vector.<TextField>(CAPACITY_Credits);
         this.FEffectFlickerCredits = new Vector.<TEffectBaseFlicker>(CAPACITY_Credits);
         this.FHint = new THint();
      }
      
      protected function Initialization() : void
      {
         var _loc1_:int = 0;
         var _loc2_:TEffectBaseFlicker = null;
         this.TFCreditSilverCoin = this.FResource[CONST_COMMON.RESOURCE_Link_TF_SilverCoin];
         this.TFCreditGold = this.FResource[CONST_COMMON.RESOURCE_Link_TF_Gold];
         this.TFCreditGiftCertificate = this.FResource[CONST_COMMON.RESOURCE_Link_TF_GiftCertificate];
         this.FBtnRecharge = this.FResource[CONST_COMMON.RESOURCE_Link_Btn_Recharge];
         if(this.FBtnRecharge != null)
         {
            this.FBtnRecharge.tabEnabled = false;
         }
         this.FBtnBleachAgent = this.FResource[CONST_COMMON.RESOURCE_Link_Btn_BleachAgent];
         if(this.FBtnBleachAgent != null)
         {
            this.FBtnBleachAgent.tabEnabled = false;
         }
         this.FBtnAddSilverCoin = this.FResource[CONST_COMMON.RESOURCE_Link_Btn_AddSilverCoin];
         if(this.FBtnAddSilverCoin != null)
         {
            this.FBtnAddSilverCoin.tabEnabled = false;
         }
         _loc1_ = 0;
         while(_loc1_ < CAPACITY_Credits)
         {
            _loc2_ = new TEffectBaseFlicker();
            this.FEffectFlickerCredits[_loc1_] = _loc2_;
            _loc1_++;
         }
         if(this.FBtnRecharge != null)
         {
            this.FBtnRecharge.addEventListener(MouseEvent.CLICK,this.BtnRechargeOnClick,false,0,true);
         }
         if(this.FBtnBleachAgent != null)
         {
            this.FBtnBleachAgent.addEventListener(MouseEvent.CLICK,this.BtnBleachAgentOnClick,false,0,true);
         }
         if(this.FBtnAddSilverCoin != null)
         {
            this.FBtnAddSilverCoin.addEventListener(MouseEvent.CLICK,this.BtnAddSilverCoinOnClick,false,0,true);
         }
         this.TFCreditSilverCoin.addEventListener(MouseEvent.MOUSE_MOVE,this.TF_CreditOnMove,false,0,true);
         this.TFCreditGold.addEventListener(MouseEvent.MOUSE_MOVE,this.TF_CreditOnMove,false,0,true);
         this.TFCreditGiftCertificate.addEventListener(MouseEvent.MOUSE_MOVE,this.TF_CreditOnMove,false,0,true);
         this.TFCreditSilverCoin.addEventListener(MouseEvent.MOUSE_OUT,this.TF_CreditOnOut,false,0,true);
         this.TFCreditGold.addEventListener(MouseEvent.MOUSE_OUT,this.TF_CreditOnOut,false,0,true);
         this.TFCreditGiftCertificate.addEventListener(MouseEvent.MOUSE_OUT,this.TF_CreditOnOut,false,0,true);
         this.FInitialization = true;
      }
      
      protected function GetSilverCoin() : String
      {
         var _loc1_:String = null;
         _loc1_ = "";
         if(this.FCharacter.CreditSilverCoin.ToNumber() > 10000)
         {
            _loc1_ = Math.floor(this.FCharacter.CreditSilverCoin.ToNumber() * 0.0001) + TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_Thousand);
         }
         else
         {
            _loc1_ = this.FCharacter.CreditSilverCoin.ToString();
         }
         return _loc1_;
      }
      
      protected function UpdatePanelCredits() : void
      {
         this.TFCreditSilverCoin.text = this.GetSilverCoin();
         this.TFCreditGold.text = this.FCharacter.CreditGold.toString();
         this.TFCreditGiftCertificate.text = this.FCharacter.CreditGiftCertificate.toString();
      }
      
      protected function UpdateCreditsEffect() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:uint = 0;
         var _loc4_:String = null;
         var _loc5_:UInt64 = null;
         var _loc6_:TEffectBaseFlicker = null;
         if(this.FInitialization)
         {
            _loc2_ = CAPACITY_Credits;
            _loc1_ = 0;
            while(_loc1_ < _loc2_)
            {
               _loc6_ = this.FEffectFlickerCredits[_loc1_];
               if(_loc1_ == CREDITINDEX_SilverCoin)
               {
                  _loc5_ = this.FSilverCoin;
                  if(_loc5_.ToNumber() != this.FCharacter.CreditSilverCoin.ToNumber() && _loc6_.IsRunOver)
                  {
                     this.TFCreditSilverCoin.text = this.GetSilverCoin();
                     _loc5_.High = this.FCharacter.CreditSilverCoin.High;
                     _loc5_.Low = this.FCharacter.CreditSilverCoin.Low;
                     _loc6_.SetParameters(this.GetTFCreditByIndex(_loc1_),4294936064);
                  }
               }
               else
               {
                  _loc3_ = parseInt(this.GetTFCreditByIndex(_loc1_).text);
                  if(_loc3_ != uint(this.FCharacter.GetCreditByIndex(_loc1_)) && _loc6_.IsRunOver)
                  {
                     this.GetTFCreditByIndex(_loc1_).text = (this.FCharacter.GetCreditByIndex(_loc1_) as uint).toString();
                     _loc6_.SetParameters(this.GetTFCreditByIndex(_loc1_),4294936064);
                  }
               }
               _loc1_++;
            }
            this.UpdateEffectsGlow();
         }
      }
      
      protected function UpdateEffectsGlow() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TEffectBaseFlicker = null;
         _loc2_ = int(this.FEffectFlickerCredits.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FEffectFlickerCredits[_loc1_];
            if(!_loc3_.IsRunOver)
            {
               _loc3_.Run();
            }
            _loc1_++;
         }
      }
      
      protected function BtnRechargeOnClick(param1:MouseEvent) : void
      {
         if(this.FOnRecharge != null)
         {
            this.FOnRecharge(this);
         }
      }
      
      protected function BtnBleachAgentOnClick(param1:MouseEvent) : void
      {
         if(this.FOnBleachAgent != null)
         {
            this.FOnBleachAgent();
         }
      }
      
      protected function BtnAddSilverCoinOnClick(param1:MouseEvent) : void
      {
         if(this.FOnAddSilverCoin != null)
         {
            this.FOnAddSilverCoin(this);
         }
      }
      
      protected function TF_CreditOnMove(param1:MouseEvent) : void
      {
         switch(param1.currentTarget)
         {
            case this.TFCreditSilverCoin:
               this.FHint.Caption = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ITEMNAME_Coin) + ":" + this.FCharacter.CreditSilverCoin.ToString();
               break;
            case this.TFCreditGold:
               this.FHint.Caption = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ITEMNAME_Gold) + ":" + this.FCharacter.CreditGold;
               break;
            case this.TFCreditGiftCertificate:
               this.FHint.Caption = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ITEMNAME_Vouchers) + ":" + this.FCharacter.CreditGiftCertificate;
         }
         if(this.FHintOnMove != null)
         {
            this.FHintOnMove(param1,this.FHint);
         }
      }
      
      protected function TF_CreditOnOut(param1:MouseEvent) : void
      {
         if(this.FHintOnOut != null)
         {
            this.FHintOnOut(param1,this.FHint);
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
      
      protected function GetTFCreditByIndex(param1:int) : TextField
      {
         return this.FTFCredits[param1];
      }
      
      protected function SetTFCreditByIndex(param1:int, param2:TextField) : void
      {
         this.FTFCredits[param1] = param2;
      }
      
      protected function get TFCreditGold() : TextField
      {
         return this.FTFCredits[CREDITINDEX_Gold] as TextField;
      }
      
      protected function set TFCreditGold(param1:TextField) : void
      {
         this.FTFCredits[CREDITINDEX_Gold] = param1;
      }
      
      protected function get TFCreditSilverCoin() : TextField
      {
         return this.FTFCredits[CREDITINDEX_SilverCoin] as TextField;
      }
      
      protected function set TFCreditSilverCoin(param1:TextField) : void
      {
         this.FTFCredits[CREDITINDEX_SilverCoin] = param1;
      }
      
      protected function get TFCreditGiftCertificate() : TextField
      {
         return this.FTFCredits[CREDITINDEX_GiftCertificate] as TextField;
      }
      
      protected function set TFCreditGiftCertificate(param1:TextField) : void
      {
         this.FTFCredits[CREDITINDEX_GiftCertificate] = param1;
      }
      
      public function set HintOnMove(param1:Function) : void
      {
         this.FHintOnMove = param1;
      }
      
      public function get HintOnMove() : Function
      {
         return this.FHintOnMove;
      }
      
      public function set HintOnOut(param1:Function) : void
      {
         this.FHintOnOut = param1;
      }
      
      public function get HintOnOut() : Function
      {
         return this.FHintOnOut;
      }
      
      public function get OnRecharge() : Function
      {
         return this.FOnRecharge;
      }
      
      public function set OnRecharge(param1:Function) : void
      {
         this.FOnRecharge = param1;
      }
      
      public function get OnAddSilverCoin() : Function
      {
         return this.FOnAddSilverCoin;
      }
      
      public function set OnAddSilverCoin(param1:Function) : void
      {
         this.FOnAddSilverCoin = param1;
      }
      
      public function set OnBleachAgent(param1:Function) : void
      {
         this.FOnBleachAgent = param1;
      }
      
      public function UpdatePanel() : void
      {
         this.UpdatePanelCredits();
      }
      
      public function UpdateEffect() : void
      {
         this.UpdateCreditsEffect();
      }
   }
}

