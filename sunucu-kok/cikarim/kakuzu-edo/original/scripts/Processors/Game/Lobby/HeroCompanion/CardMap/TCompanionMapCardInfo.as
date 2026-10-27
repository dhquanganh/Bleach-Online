package Processors.Game.Lobby.HeroCompanion.CardMap
{
   import Components.Standard.TUIButton;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.*;
   import Logics.DatebaseVO.VO.TCompanionCard;
   import Logics.HeroCompanion.THeroCompanionCardData;
   import Logics.HeroCompanion.THeroCompanionData;
   import Processors.Game.Lobby.HeroCompanion.Components.*;
   import Processors.Game.Lobby.HeroCompanion.TCompanionBaseView;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.Common.SUtilityResource;
   import Resources.Constants.*;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.text.TextField;
   
   public class TCompanionMapCardInfo extends TCompanionBaseView
   {
      
      protected const SpaceY:int = 10;
      
      protected var FBtnClose:TUIButton;
      
      protected var FCardItem:TCompanionMapItem;
      
      protected var FTFDesc:TextField;
      
      protected var FBitMap:Bitmap;
      
      protected var FCardData:TCompanionCard;
      
      protected var FIsOwn:Boolean;
      
      protected var FlastId:int;
      
      protected var FDesc0:TCompanionCardDesc;
      
      protected var FDesc1:TCompanionCardDesc;
      
      protected var FCardOnEmploy:Function;
      
      protected var FCardOnUpgrade:Function;
      
      public function TCompanionMapCardInfo(param1:TUIComponent)
      {
         super(param1);
      }
      
      protected function GetLastCardId(param1:int) : int
      {
         var _loc2_:TCompanionCard = null;
         _loc2_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_CompanionCard,param1) as TCompanionCard;
         if(_loc2_.NextId == 0)
         {
            return param1;
         }
         return this.GetLastCardId(_loc2_.NextId);
      }
      
      private function WindowOnClose(param1:Object, param2:MouseEvent) : void
      {
         ProcessorWindowClose();
         this.FDesc0.Clear();
         this.FDesc1.Clear();
      }
      
      protected function OnEmploy(param1:Object, param2:Object) : void
      {
         this.FCardOnEmploy(this.FCardItem,param2);
      }
      
      protected function OnUpgrate(param1:Object, param2:Object) : void
      {
         this.FCardOnUpgrade(this.FCardItem,param2);
      }
      
      public function get CardOnEmploy() : Function
      {
         return this.FCardOnEmploy;
      }
      
      public function set CardOnEmploy(param1:Function) : void
      {
         this.FCardOnEmploy = param1;
      }
      
      public function get CardOnUpgrade() : Function
      {
         return this.FCardOnUpgrade;
      }
      
      public function set CardOnUpgrade(param1:Function) : void
      {
         this.FCardOnUpgrade = param1;
      }
      
      public function set EffectVec(param1:Vector.<MovieClip>) : void
      {
         this.FCardItem.EffectVec = param1;
      }
      
      override public function UIDispatch(param1:Sprite) : void
      {
         var _loc2_:Point = null;
         super.UIDispatch(param1);
         this.FBtnClose = new TUIButton();
         this.FBtnClose.Substrate = FMainUI["Btn_Close"];
         this.FBtnClose.OnClick = this.WindowOnClose;
         this.FCardItem = new TCompanionMapItem(FMainUI["MC_Item"]);
         this.FCardItem.CardOnEmploy = this.OnEmploy;
         this.FCardItem.CardOnUpgrade = this.OnUpgrate;
         this.FTFDesc = FMainUI["TF_Desc"];
         _loc2_ = FMainUI.parent.localToGlobal(new Point(FMainUI.x,FMainUI.y));
         this.FBitMap = new Bitmap();
         this.FBitMap.bitmapData = SUtilityResource.BtmDataFullScreen;
         FMainUI.addChildAt(this.FBitMap,0);
         this.FBitMap.y = -_loc2_.y;
         this.FBitMap.x = -_loc2_.x;
         this.FDesc0 = new TCompanionCardDesc(FMainUI["MC_Desc_0"]);
         this.FDesc1 = new TCompanionCardDesc(FMainUI["MC_Desc_1"]);
      }
      
      public function SetInfoData(param1:THeroCompanionCardData) : void
      {
         this.FCardData = param1.GetCurCard();
         this.FIsOwn = param1.Level > 0;
         this.FlastId = this.GetLastCardId(this.FCardData.Identifier);
      }
      
      override public function SetData(param1:THeroCompanionData) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:THeroCompanionCardData = null;
         var _loc6_:TCompanionCard = null;
         super.SetData(param1);
         if(Visible && this.FlastId != 0)
         {
            _loc5_ = FData.CardDatas.GetCardByLastId(this.FlastId);
            if(_loc5_.GetCurCard().NextId == 0)
            {
               this.FTFDesc.text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_COMPANION_24);
            }
            else
            {
               this.FTFDesc.text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_COMPANION_28);
            }
            this.FCardItem.SetData(FData.CardDatas.GetCardByLastId(this.FlastId),FData.GetChipByChipId(this.FCardData.ChipId),_loc5_.Level > 0);
            this.FDesc0.SetData(_loc5_.GetCurCard());
            this.FTFDesc.y = this.FDesc0.Y + this.FDesc0.Height + this.SpaceY;
            if(_loc5_.Level < 1)
            {
               _loc6_ = _loc5_.GetCardByLevel(2);
            }
            else
            {
               _loc6_ = _loc5_.GetCardByLevel(_loc5_.Level + 1);
            }
            if(_loc6_ == null)
            {
               this.FDesc1.Visible = false;
            }
            else
            {
               this.FDesc1.Visible = true;
               this.FDesc1.SetData(_loc6_);
               this.FDesc1.Y = this.FTFDesc.y + this.FTFDesc.height + this.SpaceY;
            }
         }
      }
      
      public function PlayEffects() : void
      {
         this.FCardItem.ItemType = CONST_HEROCOMPANION.Big_Star;
         this.FCardItem.PlayEffects();
      }
   }
}

