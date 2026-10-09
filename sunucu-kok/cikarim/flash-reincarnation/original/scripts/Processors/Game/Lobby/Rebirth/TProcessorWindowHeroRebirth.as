package Processors.Game.Lobby.Rebirth
{
   import Components.Slots.TUISlot;
   import Components.Standard.TUIButton;
   import Foundation.Common.THint;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Foundation.Utilities.TUtilityString;
   import Foundation.Utilities.TUtilityTexture;
   import Logics.Characters.THero;
   import Logics.DatebaseVO.VO.TArticle;
   import Logics.Map.TMoudleInfor;
   import Logics.Rebirth.TRebirthData;
   import Logics.SLogicsCore;
   import Logics.Streamization.Rebirth.TUnstreamizerRebirth;
   import Processors.Game.Lobby.Common.Map.SceneSprite.TSceneSpriteMoudle;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import Processors.Game.Lobby.Jade.TJadeCommon;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Processors.Game.Windows.Information.TUIWindowConfirmation;
   import Resources.Constants.CONST_DATEBASEVO;
   import Resources.Constants.CONST_MAP;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class TProcessorWindowHeroRebirth extends TProcessorLobbyWindow
   {
      
      protected const PropPowerCount:uint = 5;
      
      protected const AttackEffectCount:uint = 5;
      
      protected var FMainUI:MovieClip;
      
      protected var FCurRebirthHeroCom:TCurRebirthHeroCom;
      
      protected var FPropPowers:Vector.<TPropPowerCom>;
      
      protected var FAttackEffects:Vector.<TAttackEffectCom>;
      
      protected var FSlot:TUISlot;
      
      protected var FRebirthBtn:TUIButton;
      
      protected var FResetBtn:TUIButton;
      
      protected var FGetBtn:TUIButton;
      
      protected var FNextView:MovieClip;
      
      protected var FData:TRebirthData;
      
      protected var FUnstreamizer:TUnstreamizerRebirth;
      
      protected var FHint:THint;
      
      protected var FSpriteMoudle:TSceneSpriteMoudle;
      
      protected var FQureyMoudleInfor:TMoudleInfor;
      
      protected var FHaveRebirthStone:uint;
      
      protected var FNeedRebirthStone:uint;
      
      protected var FRebirthStone:TArticle;
      
      protected var FUIWindowConfirmation:TUIWindowConfirmation;
      
      protected var FUIDispatchComplete:Function;
      
      protected var FOpenResetWin:Function;
      
      protected var FOpenSelectWin:Function;
      
      protected var FHero:THero;
      
      public function TProcessorWindowHeroRebirth(param1:TUIComponent)
      {
         super(param1);
         this.FData = SLogicsCore.RebirthData;
         this.FUnstreamizer = new TUnstreamizerRebirth(this.FData);
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:TPropPowerCom = null;
         var _loc3_:TAttackEffectCom = null;
         this.FMainUI = TUtilityReflection.CreateDisplayObjectInstance("MC_HeroRebirth") as MovieClip;
         addChild(this.FMainUI);
         this.FMainUI.BtnClose.addEventListener(MouseEvent.CLICK,this.OnWinClose);
         this.FCurRebirthHeroCom = new TCurRebirthHeroCom(this);
         this.FCurRebirthHeroCom.UIDispatch(this.FMainUI.MC_CurRebirthHeroView);
         this.FCurRebirthHeroCom.OpenSelectWin = this.FOpenSelectWin;
         this.FCurRebirthHeroCom.Hero = this.FHero;
         this.FNextView = this.FMainUI.MC_NextRebirthHeroView;
         this.FPropPowers = new Vector.<TPropPowerCom>(this.PropPowerCount);
         this.FAttackEffects = new Vector.<TAttackEffectCom>(this.AttackEffectCount);
         _loc1_ = 0;
         while(_loc1_ < this.PropPowerCount)
         {
            _loc2_ = new TPropPowerCom(this);
            _loc2_.UIDispatch(this.FNextView["MC_PropPower_" + _loc1_]);
            this.FPropPowers[_loc1_] = _loc2_;
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < this.AttackEffectCount)
         {
            _loc3_ = new TAttackEffectCom(this);
            _loc3_.UIDispatch(this.FNextView["MC_AttackEffect_" + _loc1_]);
            this.FAttackEffects[_loc1_] = _loc3_;
            _loc1_++;
         }
         this.FSlot = new TUISlot(this);
         this.FSlot.Resource = this.FMainUI.MC_ExpBookSlot;
         this.FSlot.OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FSlot.OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
         TJadeCommon.InitSlot(this.FSlot);
         this.FSlot.Init();
         this.FRebirthBtn = new TUIButton();
         this.FRebirthBtn.Substrate = this.FMainUI.Btn_Rebirth;
         this.FRebirthBtn.OnClick = this.OnRebirthBtnClick;
         this.FResetBtn = new TUIButton();
         this.FResetBtn.Substrate = this.FMainUI.Btn_ResetProp;
         this.FResetBtn.OnClick = this.OnResetBtnClick;
         this.FResetBtn.OnMove = this.OnResetBtnMove;
         this.FResetBtn.OnOut = this.OnResetBtnOut;
         this.FGetBtn = new TUIButton();
         this.FGetBtn.Substrate = this.FMainUI.Btn_GetExpBook;
         this.FGetBtn.OnClick = this.OnGetBtnClick;
         this.FGetBtn.OnMove = this.OnGetBtnMove;
         this.FGetBtn.OnOut = this.OnGetBtnOut;
         this.FNextView.Btn_Help.addEventListener(MouseEvent.MOUSE_MOVE,this.ShowHelp);
         this.FNextView.Btn_Help.addEventListener(MouseEvent.MOUSE_OUT,this.HideHelp);
         this.FHint = new THint();
         this.FQureyMoudleInfor = new TMoudleInfor();
         this.FSpriteMoudle = new TSceneSpriteMoudle();
         this.FNextView.MC_MountPoint.addChild(this.FSpriteMoudle);
         this.FUIWindowConfirmation = SUtilityOverLayer.UIWindowConfirmation;
         this.FUIDispatchComplete();
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UIFinalize() : void
      {
         this.FSlot.Context = this.FData.ConfigValueVO.ExpBook;
         this.FRebirthStone = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_Article,this.FData.ConfigValueVO.RebirthStoneID) as TArticle;
         super.ResourcesPerform_UIFinalize();
      }
      
      override protected function LogicsPerform() : void
      {
         if(Visible && this.FMainUI != null)
         {
            this.FSlot.Update();
            this.FSpriteMoudle.UpdateView();
            this.FCurRebirthHeroCom.LogicsPerform();
         }
      }
      
      protected function UpdateNextRebirth() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:String = null;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:TPropPowerCom = null;
         var _loc7_:TAttackEffectCom = null;
         var _loc8_:Array = null;
         var _loc9_:uint = 0;
         var _loc10_:uint = 0;
         _loc1_ = this.FData.GetAfterLevel(this.FHero);
         _loc2_ = Math.min(this.FData.ConfigValueVO.MaxRebirthNum,this.FHero.RebirthNum + 1);
         _loc3_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_Rebirth_05);
         _loc3_ = TUtilityString.Format(_loc3_,_loc1_,_loc2_);
         this.FNextView.TF_Level.text = _loc3_;
         TUtilityTexture.QueryTwoDirectionShowCase(CONST_MAP.DIRECTION_RIGHT,this.FHero.Identifier,this.FQureyMoudleInfor);
         this.FSpriteMoudle.ChangeRoleMoudle(this.FQureyMoudleInfor.TextureID,this.FQureyMoudleInfor.Scalx);
         this.FSpriteMoudle.OpenRebirthEffect(this.FHero.IsMain,_loc2_);
         _loc4_ = 0;
         while(_loc4_ < this.PropPowerCount)
         {
            _loc5_ = this.FData.ConfigValueVO.PropPowerZone[_loc4_];
            _loc6_ = this.FPropPowers[_loc4_];
            _loc6_.UpdateUI(_loc5_,_loc2_);
            _loc4_++;
         }
         _loc10_ = this.FData.ConfigValueVO.AttEffectOpenZone.length;
         _loc8_ = _loc2_ <= _loc10_ ? this.FData.ConfigValueVO.AttEffectOpenZone[_loc2_ - 1] : [];
         _loc10_ = _loc8_.length;
         _loc4_ = 0;
         while(_loc4_ < this.AttackEffectCount)
         {
            _loc7_ = this.FAttackEffects[_loc4_];
            _loc5_ = _loc4_ >= _loc10_ ? 0 : uint(_loc8_[_loc4_]);
            _loc7_.UpdateUI(_loc5_,_loc2_);
            _loc4_++;
         }
      }
      
      protected function OnWinClose(param1:MouseEvent) : void
      {
         ProcessorWindowClose();
         Visible = true;
      }
      
      protected function ShowHelp(param1:MouseEvent) : void
      {
         this.FHint.Caption = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_Rebirth_03);
         SUtilityOverLayer.UIComponentsHintOnOver(this,this.FHint);
      }
      
      protected function HideHelp(param1:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOut(this,this.FHint);
      }
      
      protected function OnRebirthBtnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FHero.RebirthNum == this.FData.ConfigValueVO.MaxRebirthNum)
         {
            SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_Rebirth_09));
         }
         else if(this.FHero.RebirthLevel < this.FData.ConfigValueVO.RebirthNeedLevel[this.FHero.RebirthNum])
         {
            SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_Rebirth_15));
         }
         else if(this.FHaveRebirthStone < this.FNeedRebirthStone)
         {
            SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_Rebirth_10));
         }
         else if(this.FHero != SLogicsCore.Character.MainHero && SLogicsCore.Character.MainHero.RebirthNum == 0)
         {
            SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_Rebirth_17));
         }
         else
         {
            this.FUIWindowConfirmation.Text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_Rebirth_16);
            this.FUIWindowConfirmation.OnOK = this.OnRebirthBtnClickOK;
            this.FUIWindowConfirmation.Visible = true;
         }
      }
      
      protected function OnResetBtnClick(param1:Object, param2:MouseEvent) : void
      {
         this.FOpenResetWin();
      }
      
      protected function OnGetBtnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FData.GetBook)
         {
            TUtilityLobby.GoldBuy(this.FData.ConfigValueVO.DailyBuyExpBookCost,this.OnGetBtnClickOK);
         }
         else
         {
            this.OnGetBtnClickOK(null);
         }
      }
      
      protected function OnResetBtnMove(param1:Object, param2:MouseEvent) : void
      {
         this.FHint.Caption = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_Rebirth_06);
         SUtilityOverLayer.UIComponentsHintOnOver(this,this.FHint);
      }
      
      protected function OnResetBtnOut(param1:Object, param2:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOut(this,this.FHint);
      }
      
      protected function OnGetBtnMove(param1:Object, param2:MouseEvent) : void
      {
         if(this.FData.GetBook)
         {
            this.FHint.Caption = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_Rebirth_08),this.FData.ConfigValueVO.DailyBuyExpBookCost,this.FData.ConfigValueVO.ExpBook.Quantity);
         }
         else
         {
            this.FHint.Caption = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_Rebirth_07);
         }
         SUtilityOverLayer.UIComponentsHintOnOver(this,this.FHint);
      }
      
      protected function OnGetBtnOut(param1:Object, param2:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOut(this,this.FHint);
      }
      
      protected function OnRebirthBtnClickOK(param1:Object) : void
      {
         this.FUnstreamizer.RebirthReq(this.FHero.Identifier);
      }
      
      protected function OnGetBtnClickOK(param1:Object) : void
      {
         var _loc2_:int = 0;
         _loc2_ = this.FData.GetBook ? 1 : 0;
         this.FUnstreamizer.GetExpBookReq(_loc2_);
      }
      
      public function set UIDispatchComplete(param1:Function) : void
      {
         this.FUIDispatchComplete = param1;
      }
      
      public function set OpenResetWin(param1:Function) : void
      {
         this.FOpenResetWin = param1;
      }
      
      public function set OpenSelectWin(param1:Function) : void
      {
         this.FOpenSelectWin = param1;
      }
      
      public function set Hero(param1:THero) : void
      {
         this.FHero = param1;
         if(this.FCurRebirthHeroCom != null)
         {
            this.FCurRebirthHeroCom.Hero = this.FHero;
         }
      }
      
      public function UpdateUI() : void
      {
         var _loc1_:String = null;
         var _loc2_:Number = NaN;
         var _loc3_:String = null;
         var _loc4_:uint = 0;
         _loc4_ = Math.min(this.FHero.RebirthNum,this.FData.ConfigValueVO.MaxRebirthNum - 1);
         this.FGetBtn.Enabled = SLogicsCore.Character.MainHero.RebirthNum != 0;
         if(this.FData.GetBook)
         {
            _loc1_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_Rebirth_02);
         }
         else
         {
            _loc1_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_Rebirth_01);
         }
         this.FGetBtn.Caption = _loc1_;
         this.FResetBtn.Enabled = this.FHero.RebirthNum > 0;
         this.FHaveRebirthStone = TUtilityLobby.GetArticleQuantity(this.FRebirthStone.Identifier,this.FRebirthStone.MajorType);
         this.FNeedRebirthStone = this.FData.ConfigValueVO.RebirthCostCount[_loc4_];
         this.FMainUI.TF_HaveRebirthStone.text = this.FHaveRebirthStone.toString();
         this.FMainUI.TF_NeedRebirthStone.text = this.FNeedRebirthStone.toString();
         this.FCurRebirthHeroCom.UpdateUI();
         this.UpdateNextRebirth();
         _loc2_ = Number(this.FData.ConfigValueVO.ReduceExp[_loc4_]);
         _loc2_ /= 100000000;
         if(_loc2_ > Math.floor(_loc2_))
         {
            _loc3_ = _loc2_.toFixed(1);
         }
         else
         {
            _loc3_ = _loc2_.toString();
         }
         this.FMainUI.TF_NeedLevel.text = this.FData.ConfigValueVO.RebirthNeedLevel[_loc4_].toString();
         this.FMainUI.TF_ReduceExp.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_Rebirth_23),_loc3_);
         this.FMainUI.TF_AfterLevel.text = this.FData.GetAfterLevel(this.FHero).toString();
      }
   }
}

