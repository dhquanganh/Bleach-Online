package Processors.Game.Lobby.HeroCompanion.Components
{
   import Components.Standard.TUIButton;
   import Foundation.Common.THint;
   import Foundation.UI.*;
   import Foundation.Utilities.TUtilityReflection;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.VO.TCompanionCard;
   import Logics.HeroCompanion.THeroCompanionCardData;
   import Logics.HeroCompanion.THeroCompanionChipData;
   import Processors.Game.Common.Effects.ListScroller.*;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Resources.Constants.CONST_HEROCOMPANION;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.utils.setTimeout;
   
   public class TCompanionMapItem extends Sprite implements IListItemScrollerRender
   {
      
      protected var FMainUI:Sprite;
      
      protected var FCardItem:TCompanionCardItem;
      
      protected var FTFCount:TextField;
      
      protected var FBtnEmploy:TUIButton;
      
      protected var FBtnUpgrate:TUIButton;
      
      protected var FEffectEmploy:MovieClip;
      
      protected var FEffectUpgrate:MovieClip;
      
      protected var FCardData:THeroCompanionCardData;
      
      protected var FCurCard:TCompanionCard;
      
      protected var FHint:THint;
      
      protected var FLastHint:THint;
      
      protected var FIsLast:Boolean;
      
      protected var FEffectVec:Vector.<MovieClip>;
      
      protected var FItemType:int;
      
      protected var FTipOnOver:Function;
      
      protected var FTipOnOut:Function;
      
      protected var FOnClick:Function;
      
      protected var FCardOnEmploy:Function;
      
      protected var FCardOnUpgrade:Function;
      
      protected var FUICore:TUIComponent;
      
      public function TCompanionMapItem(param1:Sprite = null)
      {
         super();
         if(param1 == null)
         {
            this.FMainUI = TUtilityReflection.CreateDisplayObjectInstance(CONST_HEROCOMPANION.ResourceID_CompanionMapCard) as Sprite;
            addChild(this.FMainUI);
         }
         else
         {
            this.FMainUI = param1;
         }
         this.FCardItem = new TCompanionCardItem(this.FMainUI["MC_Card"]);
         this.FCardItem.ItemOnMove = this.OnOver;
         this.FCardItem.ItemOnOut = this.OnOut;
         this.FCardItem.ItemOnDown = this.OnItemClick;
         this.FTFCount = this.FMainUI["TF_ChipCount"];
         this.FBtnEmploy = new TUIButton();
         this.FBtnEmploy.Substrate = this.FMainUI["Btn_Employ"];
         this.FBtnEmploy.OnClick = this.OnEmploy;
         this.FEffectEmploy = this.FMainUI["Effect_Compose"];
         this.FEffectEmploy.mouseEnabled = false;
         this.FEffectEmploy.mouseChildren = false;
         this.FBtnUpgrate = new TUIButton();
         this.FBtnUpgrate.Substrate = this.FMainUI["Btn_Upgrate"];
         this.FBtnUpgrate.OnClick = this.OnUpgrate;
         this.FBtnUpgrate.OnOver = this.UpgrateOnOver;
         this.FBtnUpgrate.OnOut = this.UpgrateOnOut;
         this.FEffectUpgrate = this.FMainUI["Effect_Upgrate"];
         this.FEffectUpgrate.mouseEnabled = false;
         this.FEffectUpgrate.mouseChildren = false;
         this.FHint = new THint();
         this.FHint.Caption = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_COMPANION_20);
         this.FLastHint = new THint();
         this.FLastHint.Caption = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_COMPANION_24);
         this.FTFCount.addEventListener(MouseEvent.MOUSE_MOVE,this.HintOnOver);
         this.FTFCount.addEventListener(MouseEvent.MOUSE_OUT,this.HintOnOut);
         this.FItemType = CONST_HEROCOMPANION.Little_Star;
      }
      
      protected function AddStarEffect() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:MovieClip = null;
         _loc2_ = this.FCardData.Level - this.FEffectVec.length;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = TUtilityReflection.CreateDisplayObjectInstance(CONST_HEROCOMPANION.ResourceID_StarEffect) as MovieClip;
            this.FEffectVec.push(_loc3_);
            _loc1_++;
         }
         if(_loc3_ == null)
         {
            return;
         }
         _loc3_.addFrameScript(_loc3_.totalFrames - 1,this.StarPlayEnd);
      }
      
      protected function StarPlayEnd() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc2_ = int(this.FEffectVec.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FEffectVec[_loc1_].visible = false;
            this.FEffectVec[_loc1_].stop();
            _loc1_++;
         }
      }
      
      protected function PlayStarEffect(param1:int, param2:int) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         if(param1 < param2)
         {
            if(this.FItemType == CONST_HEROCOMPANION.Little_Star)
            {
               _loc3_ = -CONST_HEROCOMPANION.Star_OffsetX;
               _loc4_ = -CONST_HEROCOMPANION.Star_OffsetY;
               _loc5_ = CONST_HEROCOMPANION.Little_Star_Space;
            }
            else
            {
               _loc3_ = -CONST_HEROCOMPANION.BigStar_OffsetX;
               _loc4_ = -CONST_HEROCOMPANION.BigStar_OffsetY;
               _loc5_ = CONST_HEROCOMPANION.Big_Star_Space;
            }
            this.FMainUI.addChild(this.FEffectVec[param1]);
            this.FEffectVec[param1].x = _loc3_;
            this.FEffectVec[param1].y = _loc4_ + _loc5_ * param1;
            this.FEffectVec[param1].visible = true;
            this.FEffectVec[param1].gotoAndPlay(1);
            setTimeout(this.PlayStarEffect,CONST_HEROCOMPANION.Star_Delay,param1 + 1,param2);
         }
      }
      
      protected function UpgrateOnOver(param1:Object, param2:MouseEvent) : void
      {
         if(!this.FIsLast)
         {
            return;
         }
         SUtilityOverLayer.UIComponentsHintOnOver(this.FUICore,this.FLastHint);
      }
      
      protected function UpgrateOnOut(param1:Object, param2:MouseEvent) : void
      {
         if(!this.FIsLast)
         {
            return;
         }
         SUtilityOverLayer.UIComponentsHintOnOut(this.FUICore,this.FLastHint);
      }
      
      protected function HintOnOver(param1:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOver(this.FUICore,this.FHint);
      }
      
      protected function HintOnOut(param1:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOut(this.FUICore,this.FHint);
      }
      
      protected function OnItemClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FCardData == null)
         {
            return;
         }
         this.FOnClick(this.FCardData);
      }
      
      protected function OnOver(param1:Object, param2:MouseEvent) : void
      {
         if(this.FTipOnOver == null)
         {
            return;
         }
         this.FTipOnOver(this.FCurCard);
      }
      
      protected function OnOut(param1:Object, param2:MouseEvent) : void
      {
         if(this.FTipOnOut == null)
         {
            return;
         }
         this.FTipOnOut();
      }
      
      protected function OnEmploy(param1:Object, param2:MouseEvent) : void
      {
         this.FCardOnEmploy(this,this.FCurCard);
      }
      
      protected function OnUpgrate(param1:Object, param2:MouseEvent) : void
      {
         this.FCardOnUpgrade(this,this.FCurCard);
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
      
      public function get OnClick() : Function
      {
         return this.FOnClick;
      }
      
      public function set OnClick(param1:Function) : void
      {
         this.FOnClick = param1;
      }
      
      public function get UICore() : TUIComponent
      {
         return this.FUICore;
      }
      
      public function set UICore(param1:TUIComponent) : void
      {
         this.FUICore = param1;
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
         this.FEffectVec = param1;
      }
      
      public function set ItemType(param1:int) : void
      {
         this.FItemType = param1;
      }
      
      public function SetData(... rest) : void
      {
         var _loc2_:THeroCompanionChipData = null;
         var _loc3_:Boolean = false;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:String = null;
         if(rest[0] is THeroCompanionCardData)
         {
            this.FCardData = rest[0] as THeroCompanionCardData;
            this.FCurCard = this.FCardData.GetCurCard();
         }
         else if(rest[0] is TCompanionCard)
         {
            this.FCurCard = rest[0] as TCompanionCard;
         }
         _loc2_ = rest[1] as THeroCompanionChipData;
         _loc3_ = rest[2] as Boolean;
         this.FCardItem.SetData(this.FCurCard);
         this.FBtnEmploy.Visible = !_loc3_;
         this.FEffectEmploy.visible = !_loc3_;
         this.FBtnUpgrate.Visible = _loc3_;
         this.FEffectUpgrate.visible = _loc3_;
         _loc4_ = _loc2_.Amount;
         _loc5_ = this.FCurCard.ChipCount;
         this.FEffectEmploy.visible = false;
         this.FEffectUpgrate.visible = false;
         this.FBtnEmploy.Enabled = false;
         this.FBtnUpgrate.Enabled = false;
         this.FEffectEmploy.stop();
         this.FEffectUpgrate.stop();
         this.FIsLast = false;
         if(this.FCurCard.NextId == 0)
         {
            this.FIsLast = true;
            _loc5_ = 0;
         }
         else if(_loc4_ >= _loc5_)
         {
            _loc6_ = CONST_HEROCOMPANION.HTMLCOLOR_Green;
            this.FBtnEmploy.Enabled = true;
            this.FBtnUpgrate.Enabled = true;
            if(_loc3_)
            {
               this.FEffectUpgrate.play();
               this.FEffectUpgrate.visible = true;
            }
            else
            {
               this.FEffectEmploy.play();
               this.FEffectEmploy.visible = true;
            }
         }
         else
         {
            _loc6_ = CONST_HEROCOMPANION.HTMLCOLOR_Red;
         }
         this.FTFCount.htmlText = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_COMPANION_08),_loc6_,_loc4_ + "/" + _loc5_);
      }
      
      public function PlayEffects() : void
      {
         this.AddStarEffect();
         this.PlayStarEffect(0,this.FCardData.Level);
      }
   }
}

