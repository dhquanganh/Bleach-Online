package Processors.Game.Lobby.HellButterfly.Component
{
   import Components.Standard.*;
   import Externals.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Bins.*;
   import Foundation.UI.*;
   import Logics.*;
   import Logics.Agent.*;
   import Logics.Characters.*;
   import Logics.DatebaseVO.VO.*;
   import Processors.Game.Lobby.Utilities.*;
   import Processors.Game.Windows.*;
   import Resources.Constants.*;
   import Resources.Strings.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class TCollection extends TUIWindow
   {
      
      protected var FBT_Collection:TUIButton;
      
      protected var FTF_Level:TextField;
      
      protected var FMC_NoVIP:Sprite;
      
      protected var FNoVIPTF_Level:TextField;
      
      protected var FNoVIPTF_GainSilver:TextField;
      
      protected var FNoVIPTF_GainGiftCertificate:TextField;
      
      protected var FNoVIPTF_WillLevel:TextField;
      
      protected var FNoVIPTF_WillGainSilver:TextField;
      
      protected var FNoVIPTF_WillGainGiftCertificate:TextField;
      
      protected var FMC_VIP:Sprite;
      
      protected var FVIPTF_Level:TextField;
      
      protected var FVIPTF_GainSilver:TextField;
      
      protected var FVIPTF_GainGiftCertificate:TextField;
      
      protected var FTF_BeVip:TextField;
      
      protected var FCharacter:TCharacter;
      
      protected var FLevel:uint;
      
      protected var FButterflyFeeding:TBins;
      
      protected var FOnCollection:Function;
      
      public function TCollection(param1:TUIComponent)
      {
         super(param1);
         this.FCharacter = SLogicsCore.Character;
      }
      
      override protected function ConstructComponentButtons() : void
      {
         this.FBT_Collection = this.ConstructComponentButton("BT_Collection",null,this.CollectionOnClick,null);
      }
      
      protected function ConstructComponentButton(param1:String, param2:String, param3:Function, param4:String) : TUIButton
      {
         var _loc5_:TUIButton = null;
         _loc5_ = new TUIButton();
         _loc5_.Substrate = FResource[param1];
         _loc5_.OnClick = param3;
         return _loc5_;
      }
      
      override protected function ConstructComponentMovieClip() : void
      {
         this.FMC_NoVIP = FResource["MC_NoVIP"];
         this.FNoVIPTF_Level = this.FMC_NoVIP["TF_Level"];
         this.FNoVIPTF_GainSilver = this.FMC_NoVIP["TF_GainSilver"];
         this.FNoVIPTF_GainGiftCertificate = this.FMC_NoVIP["TF_GainGiftCertificate"];
         this.FNoVIPTF_WillLevel = this.FMC_NoVIP["TF_WillLevel"];
         this.FNoVIPTF_WillGainSilver = this.FMC_NoVIP["TF_WillGainSilver"];
         this.FNoVIPTF_WillGainGiftCertificate = this.FMC_NoVIP["TF_WillGainGiftCertificate"];
         this.FTF_BeVip = this.FMC_NoVIP["TF_BeVip"];
         this.FTF_BeVip.htmlText = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HELLBUTTERFLY_STRING_16);
         this.FMC_VIP = FResource["MC_VIP"];
         this.FVIPTF_Level = this.FMC_VIP["TF_Level"];
         this.FVIPTF_GainSilver = this.FMC_VIP["TF_GainSilver"];
         this.FVIPTF_GainGiftCertificate = this.FMC_VIP["TF_GainGiftCertificate"];
         this.FTF_Level = FResource["TF_Level"];
         this.FTF_BeVip.addEventListener(TextEvent.LINK,this.OnBeVip);
      }
      
      private function UpdateVip(param1:TButterflyFeeding) : void
      {
         var _loc2_:String = null;
         this.FVIPTF_Level.text = "Lv." + this.FLevel.toString();
         _loc2_ = TUtilityLobby.GetItemName(param1.ButterflyRewards.Type[0],param1.ButterflyRewards.Code[0]);
         this.FVIPTF_GainSilver.text = _loc2_ + param1.ButterflyRewards.Amount[0];
         _loc2_ = TUtilityLobby.GetItemName(param1.ButterflyRewards.Type[1],param1.ButterflyRewards.Code[1]);
         this.FVIPTF_GainGiftCertificate.text = _loc2_ + param1.ButterflyRewards.Amount[1];
      }
      
      private function UpdateNoVip(param1:TButterflyFeeding, param2:TButterflyFeeding) : void
      {
         var _loc3_:String = null;
         this.FNoVIPTF_Level.text = "Lv." + this.FLevel.toString();
         _loc3_ = TUtilityLobby.GetItemName(param1.ButterflyRewards.Type[0],param1.ButterflyRewards.Code[0]);
         this.FNoVIPTF_GainSilver.text = _loc3_ + param1.ButterflyRewards.Amount[0];
         this.FNoVIPTF_GainGiftCertificate.visible = false;
         this.FNoVIPTF_WillLevel.text = this.FLevel.toString();
         _loc3_ = TUtilityLobby.GetItemName(param2.ButterflyRewards.Type[0],param2.ButterflyRewards.Code[0]);
         this.FNoVIPTF_WillGainSilver.text = _loc3_ + param2.ButterflyRewards.Amount[0];
         _loc3_ = TUtilityLobby.GetItemName(param2.ButterflyRewards.Type[1],param2.ButterflyRewards.Code[1]);
         this.FNoVIPTF_WillGainGiftCertificate.text = _loc3_ + param2.ButterflyRewards.Amount[1];
      }
      
      private function CollectionOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FOnCollection != null)
         {
            this.FOnCollection();
         }
         TutorialNextStep(CONST_FRESHGUIDE.EVENTID_ClickCollectionSecondViewBtn);
      }
      
      private function OnBeVip(param1:TextEvent) : void
      {
         SExternalCore.NavigateToRechargeUrl(SParametersCore.PayUrl);
      }
      
      public function get OnCollection() : Function
      {
         return this.FOnCollection;
      }
      
      public function set OnCollection(param1:Function) : void
      {
         this.FOnCollection = param1;
      }
      
      public function UpdateCollection(param1:uint) : void
      {
         var _loc2_:TButterflyFeeding = null;
         var _loc3_:TButterflyFeeding = null;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         this.FLevel = param1;
         this.FTF_Level.text = "Lv." + this.FLevel.toString();
         if(this.FButterflyFeeding == null)
         {
            this.FButterflyFeeding = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_ButterflyFeeding);
         }
         _loc5_ = uint(this.FButterflyFeeding.Count);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc2_ = this.FButterflyFeeding.GetDatebaseByIndex(_loc4_) as TButterflyFeeding;
            if(_loc2_.VipLevel == this.FCharacter.VipLevel && _loc2_.PowderLevel == this.FLevel)
            {
               break;
            }
            _loc4_++;
         }
         _loc3_ = this.FButterflyFeeding.GetDatebaseByIndex(_loc4_ + 1) as TButterflyFeeding;
         if(this.FCharacter.VipLevel == 0)
         {
            this.UpdateNoVip(_loc2_,_loc3_);
            this.FMC_NoVIP.visible = true;
            this.FMC_VIP.visible = false;
         }
         else
         {
            this.UpdateVip(_loc2_);
            this.FMC_NoVIP.visible = false;
            this.FMC_VIP.visible = true;
         }
      }
   }
}

