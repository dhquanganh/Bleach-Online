package Processors.Game.Lobby.Activity.HDHalloween.windows
{
   import Components.Slots.TUISlot;
   import Components.Standard.TUIButton;
   import Externals.SExternalCore;
   import Foundation.Common.THint;
   import Foundation.Resources.Bins.TBins;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityFilter;
   import Foundation.Utilities.TUtilityString;
   import Foundation.Utilities.TUtilityTexture;
   import Logics.Characters.THero;
   import Logics.DatebaseVO.VO.TBaseHero;
   import Logics.HDActivityHalloween.TActivityHalloweenExchangeData;
   import Logics.HDActivityHalloween.THalloweenExtractGiftVo;
   import Logics.Inventories.TInventories;
   import Logics.Map.TMoudleInfor;
   import Logics.SLogicsCore;
   import Processors.Game.Lobby.Common.Hero.TProcessorWindowHeroDescription;
   import Processors.Game.Lobby.Common.Map.SceneSprite.TSceneSpriteMoudle;
   import Processors.Game.Lobby.Jade.TJadeCommon;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Processors.Game.Windows.Information.TUIWindowConfirmation;
   import Resources.Constants.CONST_COMMON;
   import Resources.Constants.CONST_DATEBASEVO;
   import Resources.Constants.CONST_MAP;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class TprocessorWindowHDHalloweenExchange extends TUIComponent
   {
      
      protected static const Filters:Array = [TUtilityFilter.highLightFilters];
      
      protected const Good_Count:int = 5;
      
      protected const Extract_Count:int = 20;
      
      protected const Exchange_Count:int = 5;
      
      protected const Play_Anima_Open:int = 10;
      
      protected const Play_Anima_Reset:int = 20;
      
      protected var FMC_Scene:Sprite;
      
      protected var FGoodUISlot:Vector.<TUISlot>;
      
      protected var FExchangeTF:TextField;
      
      protected var FExtractList:Vector.<TUISlot>;
      
      protected var FExtractSmileList:Vector.<Sprite>;
      
      protected var FExtractAnimaList:Vector.<MovieClip>;
      
      protected var FResidueFreeTF:TextField;
      
      protected var FMC_OpenAllBtn:TUIButton;
      
      protected var FMC_ResetAllBtn:TUIButton;
      
      protected var FBtnFightReport:TUIButton;
      
      protected var FExchangeGiftList:Vector.<TUIButton>;
      
      protected var FExchangeTFList:Vector.<TextField>;
      
      protected var FMC_Hero:Sprite;
      
      protected var FMC_HeroNameTF:TextField;
      
      protected var FMC_MountPoint:Sprite;
      
      protected var FMC_AlreadyGet:Sprite;
      
      protected var FMC_OpenConditionTF:TextField;
      
      protected var FMC_RightNowExchangeBtn:TUIButton;
      
      protected var FRoleMoudles:Vector.<TSceneSpriteMoudle>;
      
      protected var FQueryModel:TMoudleInfor;
      
      protected var FBins:TBins;
      
      protected var FActivityHalloweenExchangeData:TActivityHalloweenExchangeData;
      
      protected var FWindowShowHero:TProcessorWindowHeroDescription;
      
      protected var FEffect:MovieClip;
      
      protected var FHint:THint;
      
      protected var WindowUIPopUp:TUIWindowConfirmation;
      
      protected var FExchangeMoveFun:Function;
      
      protected var FExchangeOutFun:Function;
      
      protected var FRequestFun:Function;
      
      public function TprocessorWindowHDHalloweenExchange(param1:TUIComponent, param2:Sprite)
      {
         super(param1);
         this.FBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_BaseHero);
         this.FMC_Scene = param2;
         this.FGoodUISlot = new Vector.<TUISlot>();
         this.FExtractList = new Vector.<TUISlot>();
         this.FExtractSmileList = new Vector.<Sprite>();
         this.FExtractAnimaList = new Vector.<MovieClip>();
         this.FExchangeGiftList = new Vector.<TUIButton>();
         this.FExchangeTFList = new Vector.<TextField>();
         this.InitWindow();
      }
      
      protected function InitWindow() : void
      {
         var _loc1_:TSceneSpriteMoudle = null;
         this.FRoleMoudles = new Vector.<TSceneSpriteMoudle>();
         this.FQueryModel = new TMoudleInfor();
         this.FExchangeTF = this.FMC_Scene["TF_ExchangeValue"];
         this.FResidueFreeTF = this.FMC_Scene["TF_FreeTimes"];
         this.FMC_OpenAllBtn = new TUIButton();
         this.FMC_OpenAllBtn.Substrate = this.FMC_Scene["MC_AllOpen"];
         this.FMC_OpenAllBtn.OnClick = this.OpenAllOnClick;
         this.FMC_OpenAllBtn.OnMove = this.OpenOverHandler;
         this.FMC_OpenAllBtn.OnOut = this.BtnOutHandler;
         this.FMC_ResetAllBtn = new TUIButton();
         this.FMC_ResetAllBtn.Substrate = this.FMC_Scene["MC_Reset"];
         this.FMC_ResetAllBtn.OnClick = this.ResetAllOnClick;
         this.FMC_ResetAllBtn.OnMove = this.ResetOverHandler;
         this.FMC_ResetAllBtn.OnOut = this.BtnOutHandler;
         this.FBtnFightReport = new TUIButton();
         this.FBtnFightReport.Substrate = this.FMC_Scene["BtnFightReport"];
         this.FBtnFightReport.OnClick = this.BtnFightReportOnClick;
         this.FMC_Hero = this.FMC_Scene["MC_Hero"];
         this.FMC_HeroNameTF = this.FMC_Hero["TF_HeroName"];
         this.FMC_MountPoint = this.FMC_Hero["MC_MountPoint"];
         this.FMC_AlreadyGet = this.FMC_Hero["MC_AlreadyGet"];
         this.FMC_OpenConditionTF = this.FMC_Hero["TF_OpenCondition"];
         this.FMC_RightNowExchangeBtn = new TUIButton();
         this.FMC_RightNowExchangeBtn.Substrate = this.FMC_Hero["Btn_RightNowExchange"];
         this.FMC_RightNowExchangeBtn.OnClick = this.ExchangeHeroOnClick;
         this.FEffect = this.FMC_Scene["MC_Anima"];
         this.FMC_MountPoint.addEventListener(MouseEvent.MOUSE_OVER,this.HeroOnMouseOver);
         this.FMC_MountPoint.addEventListener(MouseEvent.MOUSE_OUT,this.HeroOnMouseOut);
         this.FMC_MountPoint.addEventListener(MouseEvent.CLICK,this.HitHeroClickHandler);
         _loc1_ = new TSceneSpriteMoudle();
         this.FRoleMoudles.push(_loc1_);
         this.FMC_MountPoint.addChild(_loc1_);
         this.InitExchangeResource();
         this.InitExtractResource();
         this.InitGoodItemsResource();
         this.FWindowShowHero = new TProcessorWindowHeroDescription(this.Parent);
         this.FWindowShowHero.Perform_UIDispatch();
         this.FWindowShowHero.HintOnOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FWindowShowHero.HintOnOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FWindowShowHero.OnClose = this.BtnCloseLukiaWindowOnMouseClick;
         this.FHint = new THint();
         this.WindowUIPopUp = SUtilityOverLayer.UIWindowConfirmation;
      }
      
      protected function InitGoodItemsResource() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TUISlot = null;
         var _loc4_:Sprite = null;
         _loc2_ = this.Good_Count;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc4_ = this.FMC_Scene["MC_Good"];
            _loc3_ = new TUISlot(this);
            _loc3_.Resource = _loc4_["Item" + _loc1_];
            _loc3_.OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
            _loc3_.OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
            TJadeCommon.InitSlot(_loc3_);
            _loc3_.Init();
            this.FGoodUISlot.push(_loc3_);
            _loc1_++;
         }
      }
      
      protected function InitExtractResource() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TUIButton = null;
         var _loc4_:TUISlot = null;
         var _loc5_:Sprite = null;
         var _loc6_:Sprite = null;
         var _loc7_:MovieClip = null;
         _loc2_ = this.Extract_Count;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc5_ = this.FMC_Scene["MC_AllAward"]["Item" + _loc1_];
            _loc6_ = _loc5_["MC_Smile"];
            _loc6_.visible = false;
            this.FExtractSmileList.push(_loc6_);
            _loc7_ = _loc5_["MC_Anima"];
            _loc7_.gotoAndStop(1);
            _loc7_.buttonMode = true;
            _loc7_.addEventListener(MouseEvent.CLICK,this.ExtractOnClick);
            _loc7_.addEventListener(MouseEvent.MOUSE_MOVE,this.ExtractOverHandler);
            _loc7_.addEventListener(MouseEvent.MOUSE_OUT,this.ExtractOutHandler);
            this.FExtractAnimaList.push(_loc7_);
            _loc4_ = new TUISlot(this);
            _loc4_.Resource = _loc5_["Slot"];
            _loc4_.OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
            _loc4_.OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
            TJadeCommon.InitSlot(_loc4_);
            _loc4_.Init();
            this.FExtractList.push(_loc4_);
            _loc1_++;
         }
      }
      
      protected function InitExchangeResource() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TUIButton = null;
         var _loc4_:TextField = null;
         _loc2_ = this.Exchange_Count;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = new TUIButton();
            _loc3_.Substrate = this.FMC_Scene["MC_Gift" + _loc1_];
            _loc3_.OnMove = this.GiftBagOnMove;
            _loc3_.OnOut = this.GiftBagOnOut;
            _loc3_.OnClick = this.ExchangeGiftOnClick;
            _loc4_ = this.FMC_Scene["TF_ExchangeValue" + _loc1_];
            this.FExchangeGiftList.push(_loc3_);
            this.FExchangeTFList.push(_loc4_);
            _loc1_++;
         }
      }
      
      protected function UpdateBaseView() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:THalloweenExtractGiftVo = null;
         var _loc5_:Boolean = false;
         var _loc6_:Boolean = false;
         this.FExchangeTF.text = this.FActivityHalloweenExchangeData.TotalExchangeValue.toString();
         this.FResidueFreeTF.text = this.FActivityHalloweenExchangeData.ResidueDegree.toString();
         _loc3_ = int(this.FActivityHalloweenExchangeData.ExtractList.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = this.FActivityHalloweenExchangeData.ExtractList[_loc2_];
            _loc1_ ||= _loc4_.IsScanExtract;
            _loc2_++;
         }
         this.FMC_OpenAllBtn.Enabled = _loc1_;
         this.FMC_OpenConditionTF.text = this.FActivityHalloweenExchangeData.DataList[this.FActivityHalloweenExchangeData.DataList.length - 1].ExchangeValue.toString();
         this.FMC_AlreadyGet.visible = this.FActivityHalloweenExchangeData.IsHaveHero;
         _loc6_ = this.FActivityHalloweenExchangeData.IsHaveHero;
         _loc5_ = this.FActivityHalloweenExchangeData.DataList[this.FActivityHalloweenExchangeData.DataList.length - 1].ExchangeValue <= this.FActivityHalloweenExchangeData.TotalExchangeValue ? true : false;
         if(_loc6_)
         {
            this.FMC_RightNowExchangeBtn.Enabled = false;
         }
         else
         {
            this.FMC_RightNowExchangeBtn.Enabled = _loc5_;
         }
      }
      
      protected function RenderGoodPorpList() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TInventories = null;
         _loc2_ = int(this.FActivityHalloweenExchangeData.ShowInventories.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FActivityHalloweenExchangeData.ShowInventories[_loc1_];
            this.FGoodUISlot[_loc1_].Context = null;
            this.FGoodUISlot[_loc1_].Context = _loc3_.GetInventoryByIndex(0);
            _loc1_++;
         }
      }
      
      protected function UpdateExchangeState() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TextField = null;
         var _loc4_:TUIButton = null;
         _loc2_ = this.Exchange_Count;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FExchangeTFList[_loc1_];
            _loc4_ = this.FExchangeGiftList[_loc1_];
            _loc3_.text = this.FActivityHalloweenExchangeData.DataList[_loc1_].ExchangeValue.toString();
            _loc4_.Enabled = this.FActivityHalloweenExchangeData.DataList[_loc1_].IsScanGetAward;
            _loc1_++;
         }
      }
      
      protected function RenderHeroModel() : void
      {
         var _loc1_:int = 0;
         var _loc2_:TSceneSpriteMoudle = null;
         var _loc3_:TBaseHero = null;
         this.FMC_Hero = this.FMC_Scene["MC_Hero"];
         this.FMC_HeroNameTF = this.FMC_Hero["TF_HeroName"];
         this.FMC_MountPoint = this.FMC_Hero["MC_MountPoint"];
         this.FMC_AlreadyGet = this.FMC_Hero["MC_AlreadyGet"];
         this.FMC_OpenConditionTF = this.FMC_Hero["TF_OpenCondition"];
         _loc1_ = this.FActivityHalloweenExchangeData.HeroId;
         _loc3_ = this.FBins.GetDatebaseByIdentifier(_loc1_) as TBaseHero;
         this.FMC_HeroNameTF.text = _loc3_.Name;
         this.FMC_HeroNameTF.textColor = CONST_COMMON.QUALITYCOLOR_INDEX[_loc3_.Quality];
         this.FMC_AlreadyGet.visible = this.JudgeIsHeroHandler(_loc1_);
         TUtilityTexture.QueryTwoDirectionShowCase(CONST_MAP.DIRECTION_RIGHT,_loc1_,this.FQueryModel);
         this.FRoleMoudles[0].ChangeRoleMoudle(this.FQueryModel.TextureID,1);
      }
      
      protected function RenderExtractList() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:THalloweenExtractGiftVo = null;
         var _loc4_:TInventories = null;
         _loc2_ = this.Extract_Count;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FActivityHalloweenExchangeData.ExtractList[_loc1_];
            if(_loc3_.IsScanExtract)
            {
               this.FExtractSmileList[_loc1_].visible = false;
               this.FExtractAnimaList[_loc1_].visible = true;
               this.FExtractAnimaList[_loc1_].gotoAndStop(1);
            }
            else if(_loc3_.Inventories == null)
            {
               this.FExtractSmileList[_loc1_].visible = true;
               this.FExtractAnimaList[_loc1_].gotoAndStop(1);
            }
            else
            {
               this.FExtractSmileList[_loc1_].visible = false;
               this.FExtractAnimaList[_loc1_].visible = false;
               _loc4_ = _loc3_.Inventories;
               this.FExtractList[_loc1_].Context = null;
               this.FExtractList[_loc1_].Context = _loc4_.GetInventoryByIndex(0);
            }
            _loc1_++;
         }
      }
      
      protected function UpdateRoleModel() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc2_ = int(this.FRoleMoudles.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            if(this.FRoleMoudles[_loc1_].TextrueID != 0)
            {
               this.FRoleMoudles[_loc1_].UpdateView();
            }
            _loc1_++;
         }
      }
      
      private function JudgeIsHeroHandler(param1:int) : Boolean
      {
         var _loc3_:THero = null;
         var _loc2_:Boolean = false;
         _loc3_ = SLogicsCore.Character.Heros.GetHeroByIdentifier(param1);
         if(_loc3_ == null)
         {
            _loc2_ = false;
         }
         else
         {
            _loc2_ = true;
         }
         return _loc2_;
      }
      
      protected function UpdataUI() : void
      {
         this.RenderHeroModel();
         this.RenderGoodPorpList();
         this.UpdateExchangeState();
         this.RenderExtractList();
         this.UpdateBaseView();
      }
      
      protected function UpdatePropSlots() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _loc2_ = int(this.FGoodUISlot.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FGoodUISlot[_loc1_].Update();
            _loc1_++;
         }
         _loc4_ = int(this.FExtractList.length);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            this.FExtractList[_loc3_].Update();
            _loc3_++;
         }
      }
      
      private function SendData(param1:int) : void
      {
         if(this.FRequestFun != null)
         {
            this.FRequestFun(param1);
         }
      }
      
      protected function OpenAllOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         _loc4_ = this.Extract_Count;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            if(this.FActivityHalloweenExchangeData.ExtractList[_loc3_].IsScanExtract)
            {
               _loc5_++;
            }
            _loc3_++;
         }
         _loc5_ = _loc5_ - this.FActivityHalloweenExchangeData.ResidueDegree <= 0 ? 0 : int(_loc5_ - this.FActivityHalloweenExchangeData.ResidueDegree);
         _loc6_ = _loc5_ * this.FActivityHalloweenExchangeData.SingleSpendGold * this.FActivityHalloweenExchangeData.Discount / 100;
         _loc3_ = this.FActivityHalloweenExchangeData.OpenAllIndex;
         this.WindowUIPopUp.visible = true;
         this.WindowUIPopUp.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_06),_loc6_);
         this.WindowUIPopUp.OnOK = this.WindowOk;
         this.WindowUIPopUp.Tag = _loc3_;
      }
      
      private function WindowOk(param1:Object) : void
      {
         var _loc2_:int = 0;
         _loc2_ = this.WindowUIPopUp.Tag;
         this.SendData(_loc2_);
      }
      
      protected function ResetAllOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         _loc3_ = this.FActivityHalloweenExchangeData.ResetIndex;
         this.SendData(_loc3_);
      }
      
      protected function BtnFightReportOnClick(param1:Object, param2:MouseEvent) : void
      {
         SExternalCore.NavigateToLinkUrl(this.FActivityHalloweenExchangeData.FightReportAddr);
      }
      
      protected function ExchangeGiftOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _loc3_ = this.FExchangeGiftList.indexOf(param1);
         _loc4_ = this.FActivityHalloweenExchangeData.DataList[_loc3_].CurGiftIndex;
         this.SendData(_loc4_);
      }
      
      protected function ExtractOnClick(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         if(SLogicsCore.Character.CreditGold < this.FActivityHalloweenExchangeData.SingleSpendGold && this.FActivityHalloweenExchangeData.ResidueDegree <= 0)
         {
            SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.NOTENOUGH_Gold));
            return;
         }
         _loc2_ = this.FExtractAnimaList.indexOf(param1.currentTarget);
         if(!this.FActivityHalloweenExchangeData.ExtractList[_loc2_].IsScanExtract)
         {
            return;
         }
         this.FExtractAnimaList[_loc2_].play();
         _loc2_++;
         this.SendData(_loc2_);
      }
      
      protected function ExchangeHeroOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         _loc3_ = this.FActivityHalloweenExchangeData.DataList[this.FActivityHalloweenExchangeData.DataList.length - 1].CurGiftIndex;
         this.SendData(_loc3_);
      }
      
      protected function GiftBagOnMove(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         _loc3_ = this.FExchangeGiftList.indexOf(param1 as TUIButton);
         if(this.FExchangeMoveFun != null)
         {
            this.FExchangeMoveFun(this.FActivityHalloweenExchangeData.DataList[_loc3_].Inventories);
         }
      }
      
      protected function GiftBagOnOut(param1:Object, param2:MouseEvent) : void
      {
         if(this.FExchangeOutFun != null)
         {
            this.FExchangeOutFun();
         }
      }
      
      protected function HeroOnMouseOver(param1:MouseEvent) : void
      {
         this.FMC_MountPoint.filters = Filters;
      }
      
      protected function HeroOnMouseOut(param1:MouseEvent) : void
      {
         this.FMC_MountPoint.filters = null;
      }
      
      protected function OpenOverHandler(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:String = null;
         _loc4_ = this.Extract_Count;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            if(this.FActivityHalloweenExchangeData.ExtractList[_loc3_].IsScanExtract)
            {
               _loc5_++;
            }
            _loc3_++;
         }
         _loc5_ = _loc5_ - this.FActivityHalloweenExchangeData.ResidueDegree <= 0 ? 0 : int(_loc5_ - this.FActivityHalloweenExchangeData.ResidueDegree);
         _loc6_ = _loc5_ * this.FActivityHalloweenExchangeData.SingleSpendGold * this.FActivityHalloweenExchangeData.Discount / 100;
         _loc7_ = this.FActivityHalloweenExchangeData.TipsButtonStr;
         _loc7_ = TUtilityString.Format(_loc7_,_loc6_);
         this.FHint.Caption = _loc7_;
         SUtilityOverLayer.UIComponentsHintOnOver(this,this.FHint);
      }
      
      protected function ResetOverHandler(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:String = null;
         _loc3_ = this.FActivityHalloweenExchangeData.TipsButtonStr;
         _loc3_ = TUtilityString.Format(_loc3_,this.FActivityHalloweenExchangeData.ResetGold);
         this.FHint.Caption = _loc3_;
         SUtilityOverLayer.UIComponentsHintOnOver(this,this.FHint);
      }
      
      protected function BtnOutHandler(param1:Object, param2:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOut(this,this.FHint);
      }
      
      protected function HitHeroClickHandler(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         _loc3_ = this.FActivityHalloweenExchangeData.HeroId;
         this.FWindowShowHero.HeroID = _loc3_;
         this.FWindowShowHero.Show();
      }
      
      protected function BtnCloseLukiaWindowOnMouseClick(param1:Object) : void
      {
         this.FWindowShowHero.Hide();
      }
      
      protected function ExtractOverHandler(param1:MouseEvent) : void
      {
         var _loc2_:String = null;
         _loc2_ = this.FActivityHalloweenExchangeData.TipsExtractStr;
         _loc2_ = TUtilityString.Format(_loc2_,this.FActivityHalloweenExchangeData.SingleSpendGold);
         this.FHint.Caption = _loc2_;
         SUtilityOverLayer.UIComponentsHintOnOver(this,this.FHint);
      }
      
      protected function ExtractOutHandler(param1:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOut(this,this.FHint);
      }
      
      public function set ActivityHalloweenExchangeData(param1:TActivityHalloweenExchangeData) : void
      {
         this.FActivityHalloweenExchangeData = param1;
      }
      
      public function get RequestFun() : Function
      {
         return this.FRequestFun;
      }
      
      public function set RequestFun(param1:Function) : void
      {
         this.FRequestFun = param1;
      }
      
      public function get ExchangeMoveFun() : Function
      {
         return this.FExchangeMoveFun;
      }
      
      public function set ExchangeMoveFun(param1:Function) : void
      {
         this.FExchangeMoveFun = param1;
      }
      
      public function get ExchangeOutFun() : Function
      {
         return this.FExchangeOutFun;
      }
      
      public function set ExchangeOutFun(param1:Function) : void
      {
         this.FExchangeOutFun = param1;
      }
      
      public function ShowView() : void
      {
         this.UpdataUI();
         this.FWindowShowHero.Hide();
      }
      
      public function LogicsPerform() : void
      {
         if(this.visible)
         {
            this.UpdatePropSlots();
            this.UpdateRoleModel();
            this.FEffect.play();
         }
      }
   }
}

