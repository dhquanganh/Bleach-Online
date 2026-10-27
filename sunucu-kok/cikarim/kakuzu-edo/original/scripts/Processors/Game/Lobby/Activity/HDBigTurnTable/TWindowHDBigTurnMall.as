package Processors.Game.Lobby.Activity.HDBigTurnTable
{
   import Components.Pages.*;
   import Components.Slots.*;
   import Components.Standard.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Bins.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.HDActivityBigTurnTable.*;
   import Logics.Inventories.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Jade.*;
   import Processors.Game.Lobby.Utilities.*;
   import Processors.Game.Utilities.EffectTextReward.*;
   import Processors.Game.Utilities.OverLayer.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class TWindowHDBigTurnMall extends TProcessorLobbyWindow
   {
      
      protected static const SlotNum:int = 12;
      
      protected static const CATEGORYSECOND_KnifeBook:uint = CONST_INVENTORY.CATEGORYSECOND_KnifeBook;
      
      protected static const CATEGORYSECOND_Hero:uint = CONST_INVENTORY.CATEGORYSECOND_Hero;
      
      protected var FCurrentPage:int;
      
      protected var FResource:Sprite;
      
      protected var FUIPage:TUIPage;
      
      protected var FTFScore:TextField;
      
      protected var FSlotUI:Vector.<Sprite>;
      
      protected var FSlots:Vector.<TUISlot>;
      
      protected var FValues:Vector.<TextField>;
      
      protected var FBtnBuy:Vector.<TUIButton>;
      
      protected var FBtnClose:TUIButton;
      
      protected var FActivityBigTurnTableData:TActivityBigTurnTableData;
      
      protected var FOnBtnBuyOnClick:Function;
      
      protected var FOnShowHero:Function;
      
      protected var FOnShowKnifeOfKillSoul:Function;
      
      protected var FOnHideHeroAndKnifeOfKillSoul:Function;
      
      public function TWindowHDBigTurnMall(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(Visible)
         {
            this.UpdateSlot();
         }
      }
      
      public function UIDispatch() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Sprite = null;
         var _loc3_:TUISlot = null;
         var _loc4_:TUIButton = null;
         this.FResource = TUtilityReflection.CreateDisplayObjectInstance("BigTurnTableMall") as Sprite;
         addChild(this.FResource);
         this.FSlotUI = new Vector.<Sprite>();
         this.FSlots = new Vector.<TUISlot>();
         this.FValues = new Vector.<TextField>();
         this.FBtnBuy = new Vector.<TUIButton>();
         _loc1_ = 0;
         while(_loc1_ < SlotNum)
         {
            _loc2_ = this.FResource["Slot" + _loc1_];
            this.FSlotUI.push(_loc2_);
            _loc3_ = new TUISlot(this);
            _loc3_.Resource = _loc2_["UISlot"];
            TJadeCommon.InitSlot(_loc3_);
            _loc3_.OnOver = this.ProcessorSlotOnOver;
            _loc3_.OnOut = this.ProcessorSlotOnOut;
            _loc3_.Init();
            this.FSlots.push(_loc3_);
            this.FValues.push(_loc2_["Value"]);
            _loc4_ = new TUIButton();
            _loc4_.Substrate = _loc2_["Btn_OK"];
            _loc4_.OnClick = this.BtnBuyOnClick;
            this.FBtnBuy.push(_loc4_);
            _loc1_++;
         }
         this.FUIPage = new TUIPage(this);
         this.FUIPage.ButtonPrevious.Substrate = this.FResource["MC_PageLeft"];
         this.FUIPage.ButtonNext.Substrate = this.FResource["MC_PageRight"];
         this.FUIPage.LabelPage = this.FResource["TF_Page"];
         this.FUIPage.OnChangePage = this.OnChangePage;
         this.FUIPage.PageSize = SlotNum;
         this.FBtnClose = new TUIButton();
         this.FBtnClose.Substrate = this.FResource["btn_close"];
         this.FBtnClose.OnClick = this.BtnCloseOnClick;
         this.FTFScore = this.FResource["Score"];
      }
      
      protected function UpdateUI() : void
      {
         this.RenderSlots();
      }
      
      protected function RenderSlots() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _loc1_ = this.FCurrentPage * SlotNum;
         _loc2_ = _loc1_ + SlotNum;
         _loc2_ = _loc2_ > this.FActivityBigTurnTableData.BigTurnTableMall.Index.length ? int(this.FActivityBigTurnTableData.BigTurnTableMall.Index.length) : _loc2_;
         _loc4_ = 0;
         _loc3_ = _loc1_;
         while(_loc3_ < _loc2_)
         {
            this.FSlotUI[_loc4_].visible = true;
            this.FSlots[_loc4_].Context = this.FActivityBigTurnTableData.BigTurnTableMall.Inventories.GetInventoryByIndex(_loc3_);
            this.FValues[_loc4_].text = this.FActivityBigTurnTableData.BigTurnTableMall.CostChip[_loc3_].toString();
            _loc4_++;
            _loc3_++;
         }
         _loc3_ = _loc4_;
         while(_loc3_ < SlotNum)
         {
            this.FSlotUI[_loc3_].visible = false;
            _loc3_++;
         }
         this.FTFScore.text = this.FActivityBigTurnTableData.ScorePoint.Value.toString();
      }
      
      protected function UpdateSlot() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc2_ = int(this.FSlots.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FSlots[_loc1_].Update();
            _loc1_++;
         }
      }
      
      protected function SetupListPage(param1:int, param2:int) : void
      {
         this.FUIPage.TotalQuantity = param1;
         this.FUIPage.Update();
         this.FUIPage.PageIndex = param2;
      }
      
      protected function ProcessorSlotOnOver(param1:Object, param2:Object) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:TAppliance = null;
         var _loc6_:TKnife = null;
         var _loc7_:TBins = null;
         var _loc8_:TKnifeExpand = null;
         var _loc9_:TBins = null;
         var _loc10_:TArticle = null;
         if(param2 is TAppliance)
         {
            _loc5_ = param2 as TAppliance;
         }
         switch(_loc5_.CategorySecond)
         {
            case CATEGORYSECOND_KnifeBook:
               _loc7_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_Knife);
               _loc4_ = _loc7_.Count;
               _loc3_ = 0;
               while(_loc3_ < _loc4_)
               {
                  _loc6_ = _loc7_.GetDatebaseByIndex(_loc3_) as TKnife;
                  if(_loc6_.HandBookID == _loc5_.IDTemplate)
                  {
                     break;
                  }
                  _loc6_ = null;
                  _loc3_++;
               }
               if(_loc6_ != null)
               {
                  _loc9_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_KnifeExpand);
                  _loc4_ = _loc9_.Count;
                  _loc3_ = 0;
                  while(_loc3_ < _loc4_)
                  {
                     _loc8_ = _loc9_.GetDatebaseByIndex(_loc3_) as TKnifeExpand;
                     if(_loc8_.RelationID == _loc6_.Identifier)
                     {
                        break;
                     }
                     _loc8_ = null;
                     _loc3_++;
                  }
               }
               if(this.FOnShowKnifeOfKillSoul != null && _loc8_ != null)
               {
                  this.FOnShowKnifeOfKillSoul(this,_loc8_.Identifier);
               }
               this.FResource.mouseChildren = false;
               this.FResource.mouseEnabled = false;
               break;
            case CATEGORYSECOND_Hero:
               _loc10_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_Article,_loc5_.IDTemplate) as TArticle;
               if(this.FOnShowHero != null && _loc10_ != null)
               {
                  this.FOnShowHero(this,_loc10_.FunctionValue);
               }
               this.FResource.mouseChildren = false;
               this.FResource.mouseEnabled = false;
               break;
            default:
               SUtilityOverLayer.UIComponentsHintOnOver(param1,param2);
         }
      }
      
      protected function ProcessorSlotOnOut(param1:Object, param2:Object) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:TAppliance = null;
         var _loc6_:TKnife = null;
         var _loc7_:TBins = null;
         var _loc8_:TArticle = null;
         if(param2 is TAppliance)
         {
            _loc5_ = param2 as TAppliance;
         }
         if(_loc5_.CategorySecond != CATEGORYSECOND_KnifeBook && _loc5_.CategorySecond != CATEGORYSECOND_Hero)
         {
            SUtilityOverLayer.UIComponentsHintOnOut(param1,param2);
         }
      }
      
      protected function OnChangePage(param1:Object, param2:int) : void
      {
         this.FCurrentPage = param2;
         this.UpdateUI();
      }
      
      protected function BtnBuyOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         _loc3_ = this.FBtnBuy.indexOf(param1 as TUIButton);
         _loc3_ += this.FCurrentPage * SlotNum;
         if(this.FActivityBigTurnTableData.BigTurnTableMall.TimeLimit[_loc3_] <= this.FActivityBigTurnTableData.BigTurnTableMall.BuyedTime[_loc3_])
         {
            SToolReward.ShowMessage(TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_72),this.FActivityBigTurnTableData.BigTurnTableMall.TimeLimit[_loc3_]));
            return;
         }
         if(this.FActivityBigTurnTableData.ScorePoint.Value < this.FActivityBigTurnTableData.BigTurnTableMall.CostChip[_loc3_])
         {
            SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_73));
            return;
         }
         if(this.FOnBtnBuyOnClick != null)
         {
            this.FOnBtnBuyOnClick(this,this.FActivityBigTurnTableData.BigTurnTableMall.Index[_loc3_]);
         }
      }
      
      protected function BtnCloseOnClick(param1:Object, param2:MouseEvent) : void
      {
         this.Visible = false;
      }
      
      public function get Resource() : Sprite
      {
         return this.FResource;
      }
      
      public function set OnBtnBuyOnClick(param1:Function) : void
      {
         this.FOnBtnBuyOnClick = param1;
      }
      
      public function get OnShowHero() : Function
      {
         return this.FOnShowHero;
      }
      
      public function set OnShowHero(param1:Function) : void
      {
         this.FOnShowHero = param1;
      }
      
      public function get OnShowKnifeOfKillSoul() : Function
      {
         return this.FOnShowKnifeOfKillSoul;
      }
      
      public function set OnShowKnifeOfKillSoul(param1:Function) : void
      {
         this.FOnShowKnifeOfKillSoul = param1;
      }
      
      public function get OnHideHeroAndKnifeOfKillSoul() : Function
      {
         return this.FOnHideHeroAndKnifeOfKillSoul;
      }
      
      public function set OnHideHeroAndKnifeOfKillSoul(param1:Function) : void
      {
         this.FOnHideHeroAndKnifeOfKillSoul = param1;
      }
      
      public function Init(param1:TActivityBigTurnTableData) : void
      {
         this.FActivityBigTurnTableData = param1;
         this.UpdateUI();
         this.SetupListPage(this.FActivityBigTurnTableData.BigTurnTableMall.Index.length,0);
         this.FCurrentPage = 0;
      }
      
      public function Update() : void
      {
         this.UpdateUI();
      }
   }
}

