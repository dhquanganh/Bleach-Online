package Processors.Game.Lobby.Activity.HDAstrology.windows
{
   import Components.Standard.TUIButton;
   import Foundation.Common.THint;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityString;
   import Logics.HDAstrology.TActivityAstrologyData;
   import Logics.HDAstrology.vo.TSCStarPicture;
   import Logics.SLogicsCore;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class TAstrologyPictureView extends TUIComponent
   {
      
      public static const Star_Num:int = 12;
      
      public static const GiftState_Unfinish:int = 0;
      
      public static const GiftState_Scan:int = 1;
      
      public static const GiftState_Already:int = -1;
      
      public static const OneKeyAstrology:int = 12;
      
      public static const AstrologyTimes:int = 10;
      
      private var FMC_Scene:Sprite;
      
      private var FStarTF:TextField;
      
      private var FStarShopBtn:TUIButton;
      
      private var FLoginGift:TUIButton;
      
      private var FLoginGiftReceive:Sprite;
      
      private var FGetLoginGiftBtn:TUIButton;
      
      private var FStarSpVec:Vector.<Sprite>;
      
      private var FStarEffectMcVec:Vector.<MovieClip>;
      
      private var FStarLightVec:Vector.<MovieClip>;
      
      private var FStarBlackVec:Vector.<MovieClip>;
      
      private var FStarBgVec:Vector.<MovieClip>;
      
      private var FAstrologySingleBtn:TUIButton;
      
      private var FAstrologySingleFreeTF:TextField;
      
      private var FAstrologySingleCostTF:TextField;
      
      private var FAstrologyMoreBtn:TUIButton;
      
      private var FAstrologyTimeMc:MovieClip;
      
      private var FRefreshBtn:TUIButton;
      
      private var FRefreshFreeTF:TextField;
      
      private var FRefreshCostTF:TextField;
      
      private var FHint:THint;
      
      private var FIsSelectMore:Boolean;
      
      private var FCurrentPlayAnimaMc:MovieClip;
      
      protected var FSendData:Function;
      
      protected var FData:TActivityAstrologyData;
      
      protected var FOnMoveGiftTips:Function;
      
      protected var FOnOutGiftTips:Function;
      
      protected var FOpenShopFun:Function;
      
      public function TAstrologyPictureView(param1:TUIComponent, param2:Sprite)
      {
         super(param1);
         this.FMC_Scene = param2;
         this.InitWindow();
      }
      
      protected function InitWindow() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Sprite = null;
         var _loc4_:MovieClip = null;
         this.FStarTF = this.FMC_Scene["TF_StarValue"];
         this.FStarShopBtn = new TUIButton();
         this.FStarShopBtn.Substrate = this.FMC_Scene["Btn_StarShop"];
         this.FStarShopBtn.OnClick = this.OnOpenStarShop;
         this.FLoginGift = new TUIButton();
         this.FLoginGift.Substrate = this.FMC_Scene["MC_LoginGift"]["MC_Gift"];
         this.FLoginGift.OnMove = this.OnGiftMove;
         this.FLoginGift.OnOut = this.OnGiftOut;
         this.FLoginGiftReceive = this.FMC_Scene["MC_LoginGift"]["MC_Receive"];
         this.FGetLoginGiftBtn = new TUIButton();
         this.FGetLoginGiftBtn.Substrate = this.FMC_Scene["MC_LoginGift"]["Btn_Exchange"];
         this.FGetLoginGiftBtn.OnClick = this.OnGetLoginGift;
         _loc2_ = Star_Num;
         this.FStarSpVec = new Vector.<Sprite>();
         this.FStarLightVec = new Vector.<MovieClip>();
         this.FStarBlackVec = new Vector.<MovieClip>();
         this.FStarBgVec = new Vector.<MovieClip>();
         this.FStarEffectMcVec = new Vector.<MovieClip>();
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FMC_Scene["MC_ExtractView"]["MC_Gift_" + _loc1_];
            this.FStarSpVec[_loc1_] = _loc3_;
            _loc4_ = this.FMC_Scene["MC_ExtractView"]["MC_Effect_" + _loc1_];
            _loc4_.visible = false;
            this.FStarEffectMcVec[_loc1_] = _loc4_;
            _loc4_ = _loc3_["MC_Light"];
            this.FStarLightVec[_loc1_] = _loc4_;
            _loc4_ = _loc3_["MC_Black"];
            this.FStarBlackVec[_loc1_] = _loc4_;
            _loc4_ = _loc3_["MC_Bg"];
            this.FStarBgVec[_loc1_] = _loc4_;
            _loc3_.addEventListener(MouseEvent.MOUSE_MOVE,this.OnResourceTipsMove);
            _loc3_.addEventListener(MouseEvent.MOUSE_OUT,this.OnResourceTipsOut);
            _loc1_++;
         }
         this.FAstrologySingleBtn = new TUIButton();
         this.FAstrologySingleBtn.Substrate = this.FMC_Scene["Btn_AstrologySingle"];
         this.FAstrologySingleBtn.OnClick = this.OnAstrologySingle;
         this.FAstrologySingleFreeTF = this.FMC_Scene["TF_AstrologyFree"];
         this.FAstrologySingleCostTF = this.FMC_Scene["TF_AstrologyCost"];
         this.FAstrologyMoreBtn = new TUIButton();
         this.FAstrologyMoreBtn.Substrate = this.FMC_Scene["Btn_AstrologyMore"];
         this.FAstrologyMoreBtn.OnClick = this.OnAstrologyMore;
         this.FAstrologyTimeMc = this.FMC_Scene["MC_AstrologyTen"]["MC_SelectBox"];
         this.FAstrologyTimeMc.gotoAndStop(2);
         this.FAstrologyTimeMc.addEventListener(MouseEvent.CLICK,this.OnSelectMCState);
         this.FRefreshBtn = new TUIButton();
         this.FRefreshBtn.Substrate = this.FMC_Scene["Btn_Refresh"];
         this.FRefreshBtn.OnClick = this.OnRefresh;
         this.FRefreshFreeTF = this.FMC_Scene["TF_RefreshFree"];
         this.FRefreshCostTF = this.FMC_Scene["TF_RefreshCost"];
         this.FHint = new THint();
      }
      
      protected function SendServiceData(param1:int, param2:int, param3:Vector.<int>) : void
      {
         if(this.FSendData != null)
         {
            this.FSendData(param1,param2,param3);
         }
      }
      
      protected function RefreshStarPictureInfo() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TSCStarPicture = null;
         if(this.FData.LoginGiftState == GiftState_Unfinish)
         {
            this.FLoginGiftReceive.visible = false;
            this.FGetLoginGiftBtn.Enabled = false;
         }
         else if(this.FData.LoginGiftState == GiftState_Scan)
         {
            this.FLoginGiftReceive.visible = false;
            this.FGetLoginGiftBtn.Enabled = true;
         }
         else
         {
            this.FLoginGiftReceive.visible = true;
            this.FGetLoginGiftBtn.Enabled = false;
         }
         this.FStarTF.text = this.FData.StarVal.toString();
         _loc2_ = int(this.FData.ExtractDataVec.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FData.ExtractDataVec[_loc1_];
            if(_loc3_.ExtractState == 1)
            {
               this.FStarBlackVec[_loc1_].visible = true;
               this.FStarBlackVec[_loc1_].gotoAndStop(_loc3_.StarType);
               this.FStarLightVec[_loc1_].visible = false;
               this.FStarBgVec[_loc1_].gotoAndStop(2);
            }
            else
            {
               this.FStarBlackVec[_loc1_].visible = false;
               this.FStarLightVec[_loc1_].gotoAndStop(_loc3_.StarType);
               this.FStarLightVec[_loc1_].visible = true;
               this.FStarBgVec[_loc1_].gotoAndStop(1);
            }
            _loc1_++;
         }
         this.FAstrologySingleFreeTF.text = this.FData.AstrologyFree.toString();
         this.FAstrologySingleCostTF.text = this.FData.ActivityConfig.ExtractCostGold.toString();
         this.FRefreshFreeTF.text = this.FData.RefreshFree.toString();
         this.FRefreshCostTF.text = this.FData.ActivityConfig.RefreshCostGold.toString();
      }
      
      private function UpdateUI() : void
      {
         this.RefreshStarPictureInfo();
      }
      
      protected function OnOpenStarShop(param1:Object, param2:MouseEvent) : void
      {
         if(this.FOpenShopFun != null)
         {
            this.FOpenShopFun(0);
         }
      }
      
      protected function OnRefresh(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         if(this.FCurrentPlayAnimaMc != null)
         {
            return;
         }
         _loc3_ = this.FData.ActivityConfig.RefreshIndex;
         _loc7_ = this.FData.RefreshFree * this.FData.ActivityConfig.RefreshCostGold;
         _loc4_ = SLogicsCore.Character.CreditGold + _loc7_;
         _loc5_ = this.FData.ActivityConfig.RefreshCostGold;
         _loc6_ = _loc5_ - _loc7_;
         if(_loc4_ < _loc5_)
         {
            SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.NOTENOUGH_Gold));
            return;
         }
         if(_loc6_ <= 0)
         {
            this.FSendData(_loc3_);
         }
         else
         {
            SUtilityOverLayer.UIWindowConfirmation.visible = true;
            SUtilityOverLayer.UIWindowConfirmation.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_06),_loc6_);
            SUtilityOverLayer.UIWindowConfirmation.OnOK = this.WindowSingleOk;
            SUtilityOverLayer.UIWindowConfirmation.Tag = _loc3_;
         }
      }
      
      protected function OnGiftMove(param1:Object, param2:MouseEvent) : void
      {
         if(this.FOnMoveGiftTips != null)
         {
            this.FOnMoveGiftTips(this.FData.LoginGiftInventories[this.FData.CurDay]);
         }
      }
      
      protected function OnGiftOut(param1:Object, param2:MouseEvent) : void
      {
         if(this.FOnOutGiftTips != null)
         {
            this.FOnOutGiftTips(this);
         }
      }
      
      protected function OnGetLoginGift(param1:Object, param2:MouseEvent) : void
      {
         if(this.FSendData != null)
         {
            this.FSendData(this.FData.ActivityConfig.LoginIndex);
         }
      }
      
      protected function OnAstrologySingle(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         if(this.FCurrentPlayAnimaMc != null)
         {
            return;
         }
         _loc3_ = this.FData.ActivityConfig.ExtractSingleIndex;
         _loc7_ = this.FData.AstrologyFree * this.FData.ActivityConfig.ExtractCostGold;
         _loc4_ = SLogicsCore.Character.CreditGold + _loc7_;
         _loc5_ = this.FData.ActivityConfig.ExtractCostGold;
         _loc6_ = _loc5_ - _loc7_;
         if(_loc4_ < _loc5_)
         {
            SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.NOTENOUGH_Gold));
            return;
         }
         if(_loc6_ <= 0)
         {
            this.FSendData(_loc3_);
         }
         else
         {
            SUtilityOverLayer.UIWindowConfirmation.visible = true;
            SUtilityOverLayer.UIWindowConfirmation.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_06),_loc6_);
            SUtilityOverLayer.UIWindowConfirmation.OnOK = this.WindowSingleOk;
            SUtilityOverLayer.UIWindowConfirmation.Tag = _loc3_;
         }
      }
      
      protected function OnAstrologyMore(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         if(this.FCurrentPlayAnimaMc != null)
         {
            return;
         }
         _loc3_ = this.FData.ActivityConfig.ExtractMoreIndex;
         _loc7_ = this.FData.AstrologyFree * this.FData.ActivityConfig.ExtractCostGold * this.FData.ActivityConfig.Discount / 100;
         _loc4_ = SLogicsCore.Character.CreditGold + _loc7_;
         _loc9_ = this.FData.GetAstrologyFinishTimes();
         if(this.FIsSelectMore)
         {
            if(_loc9_ > 0)
            {
               _loc5_ = this.FData.ActivityConfig.ExtractCostGold * OneKeyAstrology * (AstrologyTimes - 1) * this.FData.ActivityConfig.Discount / 100 + (OneKeyAstrology - _loc9_) * this.FData.ActivityConfig.ExtractCostGold * this.FData.ActivityConfig.Discount / 100;
            }
            else
            {
               _loc5_ = this.FData.ActivityConfig.ExtractCostGold * OneKeyAstrology * AstrologyTimes * this.FData.ActivityConfig.Discount / 100;
            }
         }
         else if(_loc9_ > 0)
         {
            _loc5_ = (OneKeyAstrology - _loc9_) * this.FData.ActivityConfig.ExtractCostGold * this.FData.ActivityConfig.Discount / 100;
         }
         else
         {
            _loc5_ = this.FData.ActivityConfig.ExtractCostGold * OneKeyAstrology * this.FData.ActivityConfig.Discount / 100;
         }
         _loc6_ = _loc5_ - _loc7_;
         if(_loc4_ < _loc5_)
         {
            SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.NOTENOUGH_Gold));
            return;
         }
         if(_loc6_ <= 0)
         {
            this.FSendData(_loc3_);
         }
         else
         {
            SUtilityOverLayer.UIWindowConfirmation.visible = true;
            SUtilityOverLayer.UIWindowConfirmation.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_06),_loc6_);
            SUtilityOverLayer.UIWindowConfirmation.OnOK = this.WindowMoreOk;
            SUtilityOverLayer.UIWindowConfirmation.Tag = _loc3_;
         }
      }
      
      private function OnSelectMCState(param1:MouseEvent) : void
      {
         if(this.FAstrologyTimeMc.currentFrame == 1)
         {
            this.FAstrologyTimeMc.gotoAndStop(2);
            this.FIsSelectMore = false;
         }
         else
         {
            this.FAstrologyTimeMc.gotoAndStop(1);
            this.FIsSelectMore = true;
         }
      }
      
      private function WindowSingleOk(param1:Object) : void
      {
         this.FSendData(SUtilityOverLayer.UIWindowConfirmation.Tag);
      }
      
      private function WindowMoreOk(param1:Object) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Vector.<int> = null;
         if(this.FIsSelectMore)
         {
            _loc2_ = AstrologyTimes;
         }
         else
         {
            _loc2_ = 1;
         }
         _loc3_ = new Vector.<int>();
         _loc3_.push(_loc2_);
         this.FSendData(SUtilityOverLayer.UIWindowConfirmation.Tag,0,_loc3_);
      }
      
      protected function OnResourceTipsMove(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         _loc2_ = int(param1.currentTarget.name.split("_")[2]);
         this.FHint.Caption = this.FData.ExtractDataVec[_loc2_].Desc;
         SUtilityOverLayer.UIComponentsHintOnOver(this,this.FHint);
      }
      
      protected function OnResourceTipsOut(param1:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOut(this,this.FHint);
      }
      
      public function set SendData(param1:Function) : void
      {
         this.FSendData = param1;
      }
      
      public function set Data(param1:TActivityAstrologyData) : void
      {
         this.FData = param1;
      }
      
      public function set OnMoveGiftTips(param1:Function) : void
      {
         this.FOnMoveGiftTips = param1;
      }
      
      public function get OnMoveGiftTips() : Function
      {
         return this.FOnMoveGiftTips;
      }
      
      public function set OnOutGiftTips(param1:Function) : void
      {
         this.FOnOutGiftTips = param1;
      }
      
      public function set OpenShopFun(param1:Function) : void
      {
         this.FOpenShopFun = param1;
      }
      
      public function ShowView() : void
      {
         this.UpdateUI();
      }
      
      public function LogicsPerform_EnterFrame() : void
      {
         if(this.FCurrentPlayAnimaMc != null)
         {
            if(this.FCurrentPlayAnimaMc.currentFrame >= this.FCurrentPlayAnimaMc.totalFrames)
            {
               this.FCurrentPlayAnimaMc.visible = false;
               this.FCurrentPlayAnimaMc.gotoAndStop(1);
               this.FCurrentPlayAnimaMc = null;
            }
         }
      }
      
      public function PlayEffect(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:MovieClip = null;
         this.FCurrentPlayAnimaMc = this.FStarEffectMcVec[param1];
         this.FCurrentPlayAnimaMc.visible = true;
         this.FCurrentPlayAnimaMc.play();
      }
   }
}

