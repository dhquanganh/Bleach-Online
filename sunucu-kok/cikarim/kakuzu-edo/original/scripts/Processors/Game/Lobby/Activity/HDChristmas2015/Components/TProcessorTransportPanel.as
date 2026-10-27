package Processors.Game.Lobby.Activity.HDChristmas2015.Components
{
   import Components.ScrollBar.TScrollBar;
   import Components.Standard.TUIButton;
   import Externals.SExternalCore;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Foundation.Utilities.TUtilityString;
   import Logics.HDChristmas2015.TSledData;
   import Logics.KnifeOfKillSoul.TKnifeOfKillSoulData;
   import Logics.Log.TLog;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Rendering.Overlayers.HDGiftBox.TOverlayerGiftBox;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import ghostcat.util.data.Json;
   
   public class TProcessorTransportPanel extends TUIComponent
   {
      
      protected const SledTypeNum:uint = 4;
      
      protected const MinScrollDistance:Number = 110;
      
      protected const ItemStamp:Number = 0.55;
      
      protected const SingleItemStamp:Number = 17.7;
      
      protected var FData:TSledData;
      
      protected var FMainUI:MovieClip;
      
      protected var FStoreBtn:TUIButton;
      
      protected var FRefreshQualityBtn:TUIButton;
      
      protected var FAKeyRedBtn:TUIButton;
      
      protected var FStartTransportBtn:TUIButton;
      
      protected var FBattleReportBtn:TUIButton;
      
      protected var FKnifeData:TKnifeOfKillSoulData;
      
      protected var FGiftBtn:TUIButton;
      
      protected var FScrollBar:TScrollBar;
      
      protected var FCSFun:Function;
      
      protected var FOnStore:Function;
      
      protected var FCSID:uint;
      
      protected var FOnGiftShow:Function;
      
      protected var FOnGiftHide:Function;
      
      public function TProcessorTransportPanel(param1:TUIComponent)
      {
         super(param1);
      }
      
      protected function OnStoreBtnClick(param1:Object, param2:MouseEvent) : void
      {
         this.FOnStore();
      }
      
      protected function OnRefreshQualityBtnClick(param1:Object, param2:MouseEvent) : void
      {
         TUtilityLobby.GoldBuy(this.FData.Config.RefreshQuality.gold,this.RefreshQualityOK);
      }
      
      protected function OnAKeyRedBtnClick(param1:Object, param2:MouseEvent) : void
      {
         TUtilityLobby.GoldBuy(this.FData.Config.OneKeyRed.gold,this.AKeyRedOK);
      }
      
      protected function OnStartTransportBtnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FData.CurFreeTransport > 0)
         {
            this.BeginTransportOK(null);
         }
         else
         {
            TUtilityLobby.GoldBuy(this.FData.Config.BeginTransport.gold[this.FData.GetSledIndexByType(this.FData.CurTransportType)],this.BeginTransportOK);
         }
      }
      
      protected function OnBattleReportBtnClick(param1:Object, param2:MouseEvent) : void
      {
         SExternalCore.NavigateToLinkUrl(this.FData.Config.BigGift.fightReportAddr);
      }
      
      protected function OnBuyGiftBtnClick(param1:Object, param2:MouseEvent) : void
      {
         TUtilityLobby.GoldBuy(this.FData.Config.BigGift.gold,this.BuyGiftOK);
      }
      
      protected function OnGiftBtnClick(param1:Object, param2:MouseEvent) : void
      {
         switch(this.FData.Config.BigGift.showType)
         {
            case 0:
               SUtilityOverLayer.WindowShowHero.HeroID = this.FData.Config.BigGift.showID;
               SUtilityOverLayer.WindowShowHero.Show();
               break;
            case 1:
               this.FKnifeData = TUtilityLobby.CreateKnifeOfSkillSoulData(this.FData.Config.BigGift.showID);
               SUtilityOverLayer.KnifePop.KnifeData = this.FKnifeData;
               SUtilityOverLayer.KnifePop.Visible = true;
         }
      }
      
      protected function RefreshQualityOK(param1:Object) : void
      {
         this.FCSFun(this.FCSID,this.FData.Config.RefreshQuality.index);
      }
      
      protected function AKeyRedOK(param1:Object) : void
      {
         this.FCSFun(this.FCSID,this.FData.Config.OneKeyRed.index);
      }
      
      protected function BeginTransportOK(param1:Object) : void
      {
         this.FCSFun(this.FCSID,this.FData.Config.BeginTransport.index);
      }
      
      protected function BuyGiftOK(param1:Object) : void
      {
         this.FCSFun(this.FCSID,this.FData.Config.BigGift.index);
      }
      
      protected function ShowSledGift(param1:MouseEvent) : void
      {
         var _loc2_:uint = 0;
         _loc2_ = uint(param1.target.Tag);
         this.FOnGiftShow(this,this.FData.SledGifts[_loc2_],TOverlayerGiftBox.TYPE_ALL);
      }
      
      protected function HideSledGift(param1:MouseEvent) : void
      {
         this.FOnGiftHide(this);
      }
      
      public function set CSFun(param1:Function) : void
      {
         this.FCSFun = param1;
      }
      
      public function set CSID(param1:uint) : void
      {
         this.FCSID = param1;
      }
      
      public function set OnStore(param1:Function) : void
      {
         this.FOnStore = param1;
      }
      
      public function set OnGiftShow(param1:Function) : void
      {
         this.FOnGiftShow = param1;
      }
      
      public function set OnGiftHide(param1:Function) : void
      {
         this.FOnGiftHide = param1;
      }
      
      public function InitWindow(param1:MovieClip) : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:uint = 0;
         this.FMainUI = param1;
         addChild(this.FMainUI);
         this.FStoreBtn = new TUIButton();
         this.FStoreBtn.Substrate = this.FMainUI.Btn_Store;
         this.FStoreBtn.OnClick = this.OnStoreBtnClick;
         this.FRefreshQualityBtn = new TUIButton();
         this.FRefreshQualityBtn.Substrate = this.FMainUI.Btn_RefreshQuality;
         this.FRefreshQualityBtn.OnClick = this.OnRefreshQualityBtnClick;
         this.FAKeyRedBtn = new TUIButton();
         this.FAKeyRedBtn.Substrate = this.FMainUI.Btn_AKeyRed;
         this.FAKeyRedBtn.OnClick = this.OnAKeyRedBtnClick;
         this.FStartTransportBtn = new TUIButton();
         this.FStartTransportBtn.Substrate = this.FMainUI.Btn_StartTransport;
         this.FStartTransportBtn.OnClick = this.OnStartTransportBtnClick;
         _loc2_ = this.FMainUI.MC_Gift;
         this.FBattleReportBtn = new TUIButton();
         this.FBattleReportBtn.Substrate = _loc2_.Btn_BattleReport;
         this.FBattleReportBtn.OnClick = this.OnBattleReportBtnClick;
         this.FGiftBtn = new TUIButton();
         this.FGiftBtn.Substrate = _loc2_.Btn_Gift;
         this.FGiftBtn.OnClick = this.OnGiftBtnClick;
         this.FScrollBar = new TScrollBar(this.FMainUI.MC_ScroolBarUI,this.MinScrollDistance,false,this.ItemStamp,this.SingleItemStamp);
         this.FScrollBar.Visible = true;
         _loc3_ = 0;
         while(_loc3_ < this.SledTypeNum)
         {
            _loc2_ = this.FMainUI["MC_Sled_" + _loc3_];
            _loc2_.MC_Gift.Tag = _loc3_;
            _loc2_.MC_Gift.addEventListener(MouseEvent.MOUSE_MOVE,this.ShowSledGift);
            _loc2_.MC_Gift.addEventListener(MouseEvent.MOUSE_OUT,this.HideSledGift);
            _loc3_++;
         }
      }
      
      public function UpdateDataBase(param1:TSledData) : void
      {
         var _loc2_:int = 0;
         var _loc3_:MovieClip = null;
         this.FData = param1;
         this.FMainUI.TF_CurSled.text = this.FData.GetSledObjByType(this.FData.CurTransportType).name;
         _loc2_ = 0;
         while(_loc2_ < this.SledTypeNum)
         {
            _loc3_ = this.FMainUI["MC_Sled_" + _loc2_];
            _loc3_.MC_Selected.visible = false;
            _loc2_++;
         }
         _loc2_ = this.FData.GetSledIndexByType(this.FData.CurTransportType);
         _loc3_ = this.FMainUI["MC_Sled_" + _loc2_];
         _loc3_.MC_Selected.visible = true;
         this.FMainUI.TF_Spend.text = String(this.FData.Config.GoldCards[0]);
         this.FMainUI.TF_Cards.text = String(this.FData.Config.GoldCards[1]);
         this.FMainUI.TF_SnatchCount.text = this.FData.RemainSnatch.toString();
         this.FMainUI.TF_TransportCount.text = this.FData.CurFreeTransport.toString();
         this.FMainUI.TF_TotalCards.text = this.FData.CurHaveChristmasCards.toString();
         this.FRefreshQualityBtn.Enabled = !this.FData.CurTransporting && !this.FData.HaveTransportReward && this.FData.CurTransportType != 3;
         this.FAKeyRedBtn.Enabled = !this.FData.CurTransporting && !this.FData.HaveTransportReward && this.FData.CurTransportType != 3;
         this.FStartTransportBtn.Enabled = !this.FData.CurTransporting && !this.FData.HaveTransportReward;
         this.FMainUI.TF_RefreshQualityCost.text = String(this.FData.Config.RefreshQuality.gold);
         this.FMainUI.TF_AKeyRedCost.text = String(this.FData.Config.OneKeyRed.gold);
         this.FMainUI.TF_StartTransportCost.text = String(this.FData.Config.BeginTransport.gold[this.FData.GetSledIndexByType(this.FData.CurTransportType)]);
         this.FBattleReportBtn.Visible = this.FData.Config.BigGift.fightReportAddr != "";
         _loc3_ = this.FMainUI.MC_Gift;
      }
      
      public function LogArrive(param1:Vector.<TLog>) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Sprite = null;
         var _loc5_:TLog = null;
         var _loc6_:Object = null;
         if(this.FData == null)
         {
            return;
         }
         this.FScrollBar.Clear();
         _loc3_ = int(param1.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc5_ = param1[_loc2_];
            _loc6_ = Json.decode(_loc5_.Data);
            _loc4_ = TUtilityReflection.CreateDisplayObjectInstance("MC_ActSledLog") as Sprite;
            if(_loc6_.type == 0)
            {
               _loc4_["TF_Log"].text = TUtilityString.Format(this.FData.Config.Language.log2,_loc6_.name,_loc6_.amount);
            }
            else
            {
               _loc4_["TF_Log"].text = TUtilityString.Format(this.FData.Config.Language.log1,_loc6_.name,_loc6_.amount);
            }
            this.FScrollBar.AddItem(_loc4_);
            _loc2_++;
         }
      }
   }
}

