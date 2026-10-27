package Processors.Game.Lobby.HeroCompanion.CardReforging
{
   import Components.Standard.TUIButton;
   import Components.Standard.TUIImage;
   import Foundation.Network.SNetworkCore;
   import Foundation.Network.TPacket;
   import Foundation.Resources.SResourcesCore;
   import Foundation.Resources.Textures.*;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.VO.TCompanionChip;
   import Logics.HeroCompanion.*;
   import Processors.Game.Lobby.HeroCompanion.Components.TCompanionChipItem;
   import Processors.Game.Lobby.HeroCompanion.TCompanionBaseView;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Resources.Constants.*;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.utils.ByteArray;
   
   public class TProcessorCompanionReforging extends TCompanionBaseView
   {
      
      protected var FChipPage:TCompanionPageChip;
      
      protected var FOrginChip:TCompanionChipItem;
      
      protected var FNewChip:TCompanionChipItem;
      
      protected var FTFOrgin:TextField;
      
      protected var FTFNew:TextField;
      
      protected var FTFTip:TextField;
      
      protected var FTFDesc:TextField;
      
      protected var FBtnReforging:TUIButton;
      
      protected var FEffect:MovieClip;
      
      protected var FCurChip:THeroCompanionChipData;
      
      protected var FIsDrag:Boolean;
      
      protected var FIsOnCard:Boolean;
      
      protected var FIsCardOut:Boolean;
      
      protected var FUIImage:TUIImage;
      
      protected var FReforgingCount:int;
      
      public function TProcessorCompanionReforging(param1:TUIComponent)
      {
         super(param1);
      }
      
      protected function SetChipData(param1:THeroCompanionChipData = null) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TCompanionChip = null;
         var _loc5_:THeroCompanionCardData = null;
         var _loc6_:THeroCompanionChipData = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:Boolean = false;
         var _loc11_:String = null;
         if(param1 == null || param1.Amount <= 0)
         {
            this.FOrginChip.Substrate.alpha = 0;
            this.FNewChip.Visible = false;
            this.FTFNew.text = "";
            this.FTFOrgin.text = "";
            this.FTFTip.text = "";
            this.FBtnReforging.Enabled = false;
            this.FEffect.visible = false;
            this.FEffect.stop();
            return;
         }
         this.FOrginChip.SetChipData(param1);
         _loc4_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_CompanionChip,param1.ChipId) as TCompanionChip;
         _loc7_ = -1;
         _loc3_ = int(_loc4_.ExchangeIds.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(this.FOrginChip.Data.Amount <= 0)
            {
               break;
            }
            _loc6_ = FData.GetChipByChipId(_loc4_.ExchangeIds[_loc2_]);
            _loc5_ = FData.CardDatas.GetCardByLastId(_loc6_.LastId);
            if(_loc5_.Level < _loc5_.Cards[_loc5_.Cards.length - 1].Level)
            {
               _loc7_ = _loc2_;
               break;
            }
            _loc2_++;
         }
         if(_loc7_ == -1 || _loc3_ == 0)
         {
            this.FNewChip.ClearData();
            this.FTFNew.text = "";
            this.FTFOrgin.htmlText = CONST_HEROCOMPANION.GetColorStringByCount("0",false);
            this.FTFTip.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_COMPANION_27));
            this.FBtnReforging.Enabled = false;
            this.FEffect.visible = false;
            this.FEffect.stop();
            return;
         }
         _loc8_ = param1.Amount;
         _loc9_ = _loc4_.NeedCounts[_loc7_];
         _loc10_ = _loc8_ >= _loc9_;
         this.FReforgingCount = _loc8_ / _loc9_;
         this.FTFOrgin.htmlText = CONST_HEROCOMPANION.GetColorStringByCount(_loc9_ * this.FReforgingCount + "",_loc10_);
         if(_loc10_)
         {
            this.FTFNew.htmlText = CONST_HEROCOMPANION.GetColorStringByCount(this.FReforgingCount + "",_loc10_);
            this.FBtnReforging.Enabled = true;
            this.FEffect.visible = true;
            this.FEffect.play();
         }
         else
         {
            this.FTFNew.htmlText = CONST_HEROCOMPANION.GetColorStringByCount("0",_loc10_);
            this.FBtnReforging.Enabled = false;
            this.FEffect.visible = false;
            this.FEffect.stop();
         }
         this.FNewChip.SetChipData(_loc6_);
         this.FTFTip.htmlText = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_COMPANION_26),_loc9_ * this.FReforgingCount,param1.ChipData.Name,this.FReforgingCount,_loc6_.ChipData.Name);
      }
      
      protected function DragOnEnd(param1:MouseEvent) : void
      {
         this.FUIImage.visible = false;
         if(!this.FIsDrag)
         {
            return;
         }
         this.FIsDrag = false;
         if(this.FIsCardOut)
         {
            this.FOrginChip.Substrate.alpha = 0;
            this.FIsCardOut = false;
            this.FCurChip = null;
            this.SetChipData();
         }
         else if(this.FIsOnCard)
         {
            this.FOrginChip.Substrate.alpha = 1;
            this.FIsOnCard = false;
            this.SetChipData(this.FCurChip);
         }
      }
      
      protected function OnOrginDown(param1:Object, param2:MouseEvent) : void
      {
         if(this.FOrginChip.Substrate.alpha == 0)
         {
            return;
         }
         this.FIsCardOut = true;
         this.ItemOnDown(this.FOrginChip.Data);
      }
      
      protected function ItemOnDown(param1:THeroCompanionChipData) : void
      {
         var _loc2_:int = 0;
         this.FIsDrag = true;
         this.FCurChip = param1;
         _loc2_ = this.FChipPage.ChipDatas.indexOf(param1);
         this.FUIImage.visible = true;
         this.FUIImage.Sequence = this.FChipPage.ChipVec[_loc2_].AnimationSequence;
         FUICore.MouseStartDrag(this.FUIImage,true);
      }
      
      protected function OnOver(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TCompanionChipItem = null;
         _loc3_ = param1 as TCompanionChipItem;
         if(_loc3_ == this.FOrginChip)
         {
            this.FIsOnCard = true;
         }
         if(_loc3_.Substrate.alpha == 0)
         {
            return;
         }
         FTipOnOver(_loc3_.Data);
      }
      
      protected function OnOut(param1:Object, param2:MouseEvent) : void
      {
         FTipOnOut();
      }
      
      protected function OnReforging(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TPacket = null;
         var _loc4_:ByteArray = null;
         _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Companion_ReforgingReq);
         _loc4_ = _loc3_.Data;
         _loc4_.writeUnsignedInt(this.FCurChip.LastId);
         SNetworkCore.Transceiver.PacketTransmit(_loc3_);
      }
      
      override public function UIDispatch(param1:Sprite) : void
      {
         super.UIDispatch(param1);
         this.FChipPage = new TCompanionPageChip(this,FMainUI["MC_List"]);
         this.FChipPage.ItemOnDown = this.ItemOnDown;
         this.FChipPage.ItemOnOver = this.OnOver;
         this.FChipPage.ItemOnOut = this.OnOut;
         this.FOrginChip = new TCompanionChipItem(FMainUI["MC_Card_0"]);
         this.FOrginChip.ItemOnMove = this.OnOver;
         this.FOrginChip.ItemOnOut = this.OnOut;
         this.FOrginChip.ItemOnDown = this.OnOrginDown;
         this.FOrginChip.Substrate.alpha = 0;
         this.FNewChip = new TCompanionChipItem(FMainUI["MC_Card_1"]);
         this.FNewChip.ItemOnMove = this.OnOver;
         this.FNewChip.ItemOnOut = this.OnOut;
         this.FNewChip.Visible = false;
         this.FEffect = FMainUI["Effect_Reforging"];
         this.FEffect.mouseChildren = false;
         this.FEffect.mouseEnabled = false;
         this.FEffect.visible = false;
         this.FTFOrgin = FMainUI["TF_Orgin"];
         this.FTFOrgin.text = "";
         this.FTFNew = FMainUI["TF_New"];
         this.FTFNew.text = "";
         this.FTFTip = FMainUI["TF_Tip"];
         this.FTFTip.text = "";
         this.FTFDesc = FMainUI["TF_Desc"];
         this.FTFDesc.text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_COMPANION_22);
         this.FBtnReforging = new TUIButton();
         this.FBtnReforging.Substrate = FMainUI["Btn_Reforging"];
         this.FBtnReforging.OnClick = this.OnReforging;
         this.FBtnReforging.Enabled = false;
         this.FEffect.visible = false;
         this.FEffect.stop();
         this.FUIImage = new TUIImage(FParent);
         this.FUIImage.mouseChildren = false;
         this.FUIImage.mouseEnabled = false;
         this.FUIImage.alpha = 0.6;
         this.FUIImage.SetRegistrationPoint(-24,-24);
         FUICore.UIStage.addEventListener(MouseEvent.MOUSE_UP,this.DragOnEnd);
      }
      
      override public function SetData(param1:THeroCompanionData) : void
      {
         var _loc2_:THeroCompanionChipData = null;
         super.SetData(param1);
         this.FChipPage.SetData(param1);
         if(this.FCurChip != null)
         {
            _loc2_ = FData.GetChipByChipId(this.FCurChip.ChipId);
            this.FOrginChip.SetChipData(_loc2_);
            this.SetChipData(_loc2_);
         }
      }
   }
}

