package Processors.Game.Lobby.Activity.HDHalloween2016.Windows
{
   import Components.Slots.TUISlot;
   import Components.Standard.TUIButton;
   import Foundation.Resources.SResourcesCore;
   import Foundation.Resources.Textures.TAnimationSequence;
   import Foundation.Resources.Textures.TTexture;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Logics.DatebaseVO.VO.THDHalloweenShop;
   import Logics.DatebaseVO.VO.TPetLevelUp;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDHalloween2016.THalloweenShop;
   import Logics.Inventories.TInventories;
   import Processors.Game.Lobby.Activity.HDActivity.Common.THDScoreExchangeShop;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDSingleWindowBase;
   import Processors.Game.Lobby.Jade.TJadeCommon;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Processors.Game.Utilities.HyperLink.SUtilityHyperLink;
   import Processors.Game.Utilities.HyperLink.TUtilityHyperLink;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Resources.Constants.CONST_DATEBASEVO;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class TProcessorHalloweenShop extends TProcessorHDSingleWindowBase
   {
      
      protected var FBtn_Refresh:TUIButton;
      
      protected var FBtn_One:TUIButton;
      
      protected var FBtn_All:TUIButton;
      
      protected var FBtn_Exchange:TUIButton;
      
      protected var FBtn_Shop:TUIButton;
      
      protected var FExchangeShop:THDScoreExchangeShop;
      
      protected var FIsinit:Boolean;
      
      protected var FSlots:Vector.<TUISlot>;
      
      protected var FPetBmp:Bitmap;
      
      protected var FPetLevelUp:TPetLevelUp;
      
      protected var FPointPetMC:Sprite;
      
      protected var FSP_Pet:Sprite;
      
      protected var FConfig:THDHalloweenShop;
      
      protected var FData:THalloweenShop;
      
      public function TProcessorHalloweenShop(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function UpdateUIConfig() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:THDHalloweenShop = null;
         super.UpdateUIConfig();
         _loc3_ = FHDActivityConfig as THDHalloweenShop;
         this.FConfig = _loc3_;
         if(FActivityAtoms != null)
         {
            ProcessorFormatActivityTimeFromNowOn(FActivityAtoms.EndTime);
            ProcessorFormatActivityCountDown(FActivityAtoms.EndTime);
         }
      }
      
      override protected function UpdateDataBase(param1:TActivityOSBase) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         this.FData = param1 as THalloweenShop;
         FScene["TF_Score"].text = this.FData.Score + "";
         FScene["MC_BigAward"]["TF_Free"].text = this.FConfig.Bag.gold + "";
         if(!this.FIsinit)
         {
            this.SetupShop();
            this.FIsinit = true;
         }
         _loc3_ = 8;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FSlots[_loc2_].Context = this.FData.GetCurItemsInfo()[_loc2_].inv;
            FScene["MC_Round"]["MC_Already_" + _loc2_].visible = this.FData.CurItemsStatus[this.FData.CurItemsIndex[_loc2_] - 1] == 0 ? true : false;
            _loc2_++;
         }
         FScene["MC_Round"]["MC_Pos"].gotoAndStop(this.FData.CurItemsIndex.indexOf(this.FData.CurPos) + 2);
         this.FPetLevelUp = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_PetLevelUp,this.FData.Config.Bag.showId) as TPetLevelUp;
         if(this.FPetLevelUp != null)
         {
            SResourcesCore.TexturesLargeIcon.LoadAutoSecondary(this.FPetLevelUp.PetResourceID,this.AutoLoadCallBack);
         }
         this.FExchangeShop.Update(this.FData.Score,this.FData.ShopStatus);
      }
      
      override protected function LogicsPerform() : void
      {
         var _loc1_:TUISlot = null;
         super.LogicsPerform();
         if(!Visible)
         {
            return;
         }
         if(this.FSlots != null)
         {
            for each(_loc1_ in this.FSlots)
            {
               _loc1_.Update();
            }
         }
      }
      
      protected function SetupShop() : void
      {
         var _loc1_:Object = null;
         var _loc2_:Vector.<uint> = null;
         var _loc3_:Vector.<Boolean> = null;
         var _loc4_:TInventories = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         _loc2_ = new Vector.<uint>();
         _loc3_ = new Vector.<Boolean>();
         _loc4_ = new TInventories();
         _loc5_ = this.FData.Config.Mall.length;
         _loc6_ = 0;
         while(_loc6_ < _loc5_)
         {
            _loc2_.push(this.FData.Config.Mall[_loc6_].costScore);
            _loc3_.push(this.FData.Config.Mall[_loc6_].numLimit == 0);
            SToolReward.GetAwardsByAwardID(this.FData.Config.Mall[_loc6_].award,_loc4_);
            _loc6_++;
         }
         this.FExchangeShop.SetupBasicInfo(_loc4_,_loc2_,_loc3_);
      }
      
      protected function ExchangeCall(param1:uint) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:Object = null;
         _loc3_ = this.FData.Config.Mall[param1];
         _loc2_ = uint(_loc3_.score);
         if(this.FData.Score >= _loc2_)
         {
            Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,_loc3_.index);
         }
         else
         {
            SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_63));
         }
      }
      
      protected function ProcessorOpenShop(param1:Object, param2:MouseEvent) : void
      {
         this.FExchangeShop.Visible = true;
         this.FExchangeShop.Update(this.FData.Score,this.FData.ShopStatus);
      }
      
      protected function ProcessorRefreash(param1:Object, param2:MouseEvent) : void
      {
         GoldBuy(this.FConfig.RefreshCostGold,this.ProcessorGoldRefreash);
      }
      
      protected function ProcessorGoldRefreash(param1:Object) : void
      {
         FScene["MC_BigEffect"].play();
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FConfig.RefreshIndex);
      }
      
      protected function ProcessorOne(param1:Object, param2:MouseEvent) : void
      {
         GoldBuy(this.FConfig.BuyCostGold,this.ProcessorGoldOne);
      }
      
      protected function ProcessorGoldOne(param1:Object) : void
      {
         FScene["MC_Round"]["MC_Effect"].addFrameScript(FScene["MC_Round"]["MC_Effect"].totalFrames - 1,this.ProcessorOneToSever);
         FScene["MC_Round"]["MC_Effect"].visible = true;
         FScene["MC_Round"]["MC_Effect"].gotoAndPlay(1);
      }
      
      protected function ProcessorOneToSever() : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FConfig.BuyIndex);
         FScene["MC_Round"]["MC_Effect"].stop();
      }
      
      protected function ProcessorAll(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         _loc5_ = 0;
         _loc3_ = 8;
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            if(this.FData.CurItemsStatus[this.FData.CurItemsIndex[_loc4_] - 1] == 1)
            {
               _loc5_++;
            }
            _loc4_++;
         }
         GoldBuy(this.FConfig.BuyCostGold * _loc5_,this.ProcessorGoldAll);
      }
      
      protected function ProcessorGoldAll(param1:Object) : void
      {
         FScene["MC_BigEffect"].play();
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FConfig.AllBuyIndex);
      }
      
      protected function LinkPetOnClick(param1:MouseEvent) : void
      {
         SUtilityHyperLink.ShortcutHyperlink(TUtilityHyperLink.HyperLink_Pet);
      }
      
      protected function AutoLoadCallBack(param1:Object, param2:TTexture, param3:uint) : void
      {
         var _loc4_:TAnimationSequence = null;
         switch(param3)
         {
            case this.FPetLevelUp.PetResourceID:
               _loc4_ = param2.GetAnimationSequenceByIndex(0);
               this.FPetBmp.bitmapData = _loc4_.GetAnimationFrameByIndex(0).Surface;
         }
      }
      
      override public function InitWindow(param1:Sprite = null) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:MovieClip = null;
         super.InitWindow(param1);
         this.FBtn_Refresh = new TUIButton();
         this.FBtn_Refresh.Substrate = FScene["Btn_Refresh"];
         this.FBtn_Refresh.OnClick = this.ProcessorRefreash;
         this.FBtn_One = new TUIButton();
         this.FBtn_One.Substrate = FScene["Btn_One"];
         this.FBtn_One.OnClick = this.ProcessorOne;
         this.FBtn_All = new TUIButton();
         this.FBtn_All.Substrate = FScene["Btn_All"];
         this.FBtn_All.OnClick = this.ProcessorAll;
         this.FBtn_Shop = new TUIButton();
         this.FBtn_Shop.Substrate = FScene["MC_BigAward"]["Btn_Shop"];
         this.FBtn_Shop.OnClick = this.ProcessorOpenShop;
         _loc2_ = 8;
         this.FSlots = new Vector.<TUISlot>(_loc2_);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            this.FSlots[_loc3_] = new TUISlot(this);
            this.FSlots[_loc3_].Resource = FScene["MC_Round"]["MC_slot" + _loc3_];
            this.FSlots[_loc3_].OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
            this.FSlots[_loc3_].OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
            TJadeCommon.InitSlot(this.FSlots[_loc3_]);
            this.FSlots[_loc3_].Init();
            _loc3_++;
         }
         _loc4_ = TUtilityReflection.CreateDisplayObjectInstance("MC_Halloween2016Shop") as MovieClip;
         this.FExchangeShop = new THDScoreExchangeShop(this);
         this.FExchangeShop.ExchangeCall = this.ExchangeCall;
         this.FExchangeShop.UIDispatch(_loc4_);
         this.FExchangeShop.Visible = false;
         FScene["MC_Round"]["MC_Effect"].visible = false;
         (FScene["MC_Round"]["MC_Effect"] as MovieClip).mouseChildren = false;
         (FScene["MC_Round"]["MC_Effect"] as MovieClip).mouseEnabled = false;
         (FScene["MC_BigEffect"] as MovieClip).mouseChildren = false;
         (FScene["MC_BigEffect"] as MovieClip).mouseChildren = false;
         this.FSP_Pet = FScene["MC_BigAward"]["MC_MountPoint"];
         this.FPointPetMC = this.FSP_Pet;
         this.FPointPetMC.buttonMode = true;
         this.FPointPetMC.addEventListener(MouseEvent.CLICK,this.LinkPetOnClick);
         this.FPetBmp = new Bitmap();
         this.FPetBmp.x = -45;
         this.FPetBmp.y = -35;
         this.FPointPetMC.addChild(this.FPetBmp);
      }
   }
}

