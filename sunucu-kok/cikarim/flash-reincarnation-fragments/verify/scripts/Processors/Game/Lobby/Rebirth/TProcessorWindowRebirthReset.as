package Processors.Game.Lobby.Rebirth
{
   import Components.SelectBox.TSelectBox;
   import Components.SelectBox.TSelectBoxMulti;
   import Components.Standard.TUIButton;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Logics.Characters.THero;
   import Logics.Rebirth.TRebirthData;
   import Logics.SLogicsCore;
   import Logics.Streamization.Rebirth.TUnstreamizerRebirth;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.Common.SUtilityResource;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class TProcessorWindowRebirthReset extends TProcessorLobbyWindow
   {
      
      protected const PropPowerCount:uint = 5;
      
      protected const AttackEffectCount:uint = 10;
      
      protected const SuperPropPowerIndexs:Vector.<int> = Vector.<int>([3,4]);
      
      protected var FMainUI:MovieClip;
      
      protected var FCurRebirthHeroCom:TCurRebirthHeroCom;
      
      protected var FSelectBoxMulti:TSelectBoxMulti;
      
      protected var FResetBtn:TUIButton;
      
      protected var FPropPowers:Vector.<TPropPowerCom>;
      
      protected var FAttackEffects:Vector.<TAttackEffectCom>;
      
      protected var FData:TRebirthData;
      
      protected var FUnstreamizer:TUnstreamizerRebirth;
      
      protected var FRefineSoulStoneTotal:uint;
      
      protected var FSoulStoneTotal:uint;
      
      protected var FRefineSoulStoneNeed:uint;
      
      protected var FSoulStoneNeed:uint;
      
      protected var FOpenSelectWin:Function;
      
      protected var FHero:THero;
      
      public function TProcessorWindowRebirthReset(param1:TUIComponent)
      {
         super(param1);
         this.FData = SLogicsCore.RebirthData;
         this.FUnstreamizer = new TUnstreamizerRebirth(this.FData);
      }
      
      override protected function LogicsPerform() : void
      {
         if(Visible && this.FMainUI != null && this.FHero != null)
         {
            if(this.FSoulStoneTotal != TUtilityLobby.GetArticleQuantity(this.FData.ConfigValueVO.SoulStoneCost.code,this.FData.ConfigValueVO.SoulStoneCost.type) || this.FRefineSoulStoneTotal != TUtilityLobby.GetArticleQuantity(this.FData.ConfigValueVO.RefineSoulStoneCost.code,this.FData.ConfigValueVO.RefineSoulStoneCost.type))
            {
               this.UpdateUI();
            }
            if(this.FData.Pending)
            {
               this.FResetBtn.Enabled = false;
            }
            else
            {
               this.UpdateUIByBox();
            }
         }
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:Bitmap = null;
         var _loc2_:uint = 0;
         var _loc3_:TPropPowerCom = null;
         var _loc4_:TAttackEffectCom = null;
         this.FMainUI = TUtilityReflection.CreateDisplayObjectInstance("MC_RebirthReset") as MovieClip;
         _loc1_ = new Bitmap(SUtilityResource.BtmDataFullScreen);
         addChild(_loc1_);
         addChild(this.FMainUI);
         this.FCurRebirthHeroCom = new TCurRebirthHeroCom(this);
         this.FCurRebirthHeroCom.UIDispatch(this.FMainUI.MC_CurRebirthHeroView);
         this.FCurRebirthHeroCom.OpenSelectWin = this.FOpenSelectWin;
         this.FCurRebirthHeroCom.Hero = this.FHero;
         this.FMainUI.x = (_loc1_.width - this.FMainUI.width) / 2;
         this.FMainUI.y = (_loc1_.height - this.FMainUI.height) / 2;
         this.FSelectBoxMulti = new TSelectBoxMulti();
         this.FSelectBoxMulti.SetTaskByIndex(0,this.FMainUI.MC_PropPowerBox);
         this.FSelectBoxMulti.SetTaskByIndex(1,this.FMainUI.MC_AttackEffectBox);
         this.FSelectBoxMulti.SetTaskByIndex(2,this.FMainUI.MC_SuperPropPowerBox);
         this.FSelectBoxMulti.CallBackOnSelect = this.CallBackOnSelect;
         this.FSelectBoxMulti.CallBackOnUnselect = this.CallBackOnUnselect;
         this.FSelectBoxMulti.Init();
         this.FResetBtn = new TUIButton();
         this.FResetBtn.Substrate = this.FMainUI.Btn_Reset;
         this.FResetBtn.OnClick = this.OnResetBtnClick;
         this.FPropPowers = new Vector.<TPropPowerCom>(this.PropPowerCount);
         this.FAttackEffects = new Vector.<TAttackEffectCom>(this.AttackEffectCount);
         _loc2_ = 0;
         while(_loc2_ < this.PropPowerCount)
         {
            _loc3_ = new TPropPowerCom(this);
            _loc3_.UIDispatch(this.FMainUI["MC_PropPower_" + _loc2_]);
            this.FPropPowers[_loc2_] = _loc3_;
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < this.AttackEffectCount)
         {
            _loc4_ = new TAttackEffectCom(this);
            _loc4_.UIDispatch(this.FMainUI["MC_AttackEffect_" + _loc2_]);
            this.FAttackEffects[_loc2_] = _loc4_;
            _loc2_++;
         }
         this.UpdateUIByBox();
         this.FMainUI.BtnClose.addEventListener(MouseEvent.CLICK,this.OnCloseBtnClick);
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UIFinalize() : void
      {
         super.ResourcesPerform_UIFinalize();
      }
      
      override protected function LogicsPerform() : void
      {
         if(Visible && this.FMainUI != null)
         {
            this.FCurRebirthHeroCom.LogicsPerform();
         }
      }
      
      protected function UpdateUIByBox() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:TPropPowerCom = null;
         this.FResetBtn.Enabled = false;
         if(this.FSelectBoxMulti.TasksState[0] == TSelectBox.State_Select)
         {
            this.FSoulStoneNeed = this.FData.ConfigValueVO.SoulStoneCost.amount;
            this.FResetBtn.Enabled = true;
         }
         else
         {
            this.FSoulStoneNeed = 0;
         }
         if(this.FSelectBoxMulti.TasksState[1] == TSelectBox.State_Select)
         {
            this.FRefineSoulStoneNeed = this.FData.ConfigValueVO.RefineSoulStoneCost.amount;
            this.FResetBtn.Enabled = true;
         }
         else
         {
            this.FRefineSoulStoneNeed = 0;
         }
         _loc2_ = this.SuperPropPowerIndexs.length;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FPropPowers[this.SuperPropPowerIndexs[_loc1_]];
            if(this.FSelectBoxMulti.TasksState[2] == TSelectBox.State_Select)
            {
               _loc3_.SetBlackFilters(false);
            }
            else
            {
               _loc3_.SetBlackFilters(true);
            }
            _loc1_++;
         }
         this.FMainUI.TF_RefineSoulStone.text = this.FRefineSoulStoneNeed + "/" + this.FRefineSoulStoneTotal;
         this.FMainUI.TF_SoulStone.text = this.FSoulStoneNeed + "/" + this.FSoulStoneTotal;
      }
      
      protected function UpdatePropAttack() : void
      {
         var _loc1_:TAttackEffectCom = null;
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:Array = null;
         var _loc5_:uint = 0;
         for each(_loc1_ in this.FAttackEffects)
         {
            _loc1_.SetBlackFilters(true);
         }
         _loc3_ = Math.min(this.FHero.RebirthNum,this.FData.ConfigValueVO.AttEffectOpenZone.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = this.FData.ConfigValueVO.AttEffectOpenZone[_loc2_];
            for each(_loc5_ in _loc4_)
            {
               _loc1_ = this.GetAttackEffectComByID(_loc5_);
               _loc1_.SetBlackFilters(false);
            }
            _loc2_++;
         }
      }
      
      protected function UpdateIcons() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:TPropPowerCom = null;
         var _loc6_:TAttackEffectCom = null;
         var _loc7_:Array = null;
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         _loc1_ = 0;
         while(_loc1_ < this.PropPowerCount)
         {
            _loc5_ = this.FPropPowers[_loc1_];
            _loc5_.UpdateUI(this.FData.ConfigValueVO.PropPowerZone[_loc1_],this.FHero.RebirthNum);
            _loc1_++;
         }
         _loc3_ = this.FData.ConfigValueVO.AttEffectOpenZone.length;
         _loc1_ = 0;
         while(_loc1_ < _loc3_)
         {
            _loc7_ = this.FData.ConfigValueVO.AttEffectOpenZone[_loc1_];
            _loc4_ = _loc7_.length;
            _loc2_ = 0;
            while(_loc2_ < _loc4_)
            {
               _loc9_ = uint(_loc7_[_loc2_]);
               _loc6_ = this.FAttackEffects[_loc8_];
               _loc6_.UpdateUI(_loc9_,this.FHero.RebirthNum);
               _loc8_++;
               _loc2_++;
            }
            _loc1_++;
         }
      }
      
      protected function GetAttackEffectComByID(param1:uint) : TAttackEffectCom
      {
         var _loc2_:TAttackEffectCom = null;
         for each(_loc2_ in this.FAttackEffects)
         {
            if(_loc2_.ID == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      protected function CallBackOnSelect(param1:int, param2:int) : void
      {
         this.UpdateUIByBox();
      }
      
      protected function CallBackOnUnselect(param1:int, param2:int) : void
      {
         this.UpdateUIByBox();
      }
      
      protected function OnResetBtnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FSelectBoxMulti.TasksState[0] == TSelectBox.State_Select)
         {
            if(this.FSoulStoneTotal < this.FSoulStoneNeed)
            {
               SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_Rebirth_10));
               return;
            }
         }
         if(this.FSelectBoxMulti.TasksState[1] == TSelectBox.State_Select)
         {
            if(this.FRefineSoulStoneTotal < this.FRefineSoulStoneNeed)
            {
               SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_Rebirth_10));
               return;
            }
         }
         if(this.FSelectBoxMulti.TasksState[2] == TSelectBox.State_Select && this.FSelectBoxMulti.TasksState[0] == TSelectBox.State_Select)
         {
            TUtilityLobby.GoldBuy(this.FData.ConfigValueVO.SuperPropCost,this.OnResetOK,TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.DAILYTASK_STRING_03),true);
            return;
         }
         this.OnResetOK(null);
      }
      
      protected function OnCloseBtnClick(param1:MouseEvent) : void
      {
         ProcessorWindowClose();
      }
      
      protected function OnResetOK(param1:Object) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _loc2_ = int(this.FSelectBoxMulti.TasksState[0] == TSelectBox.State_Select);
         _loc3_ = int(this.FSelectBoxMulti.TasksState[2] == TSelectBox.State_Select);
         _loc4_ = int(this.FSelectBoxMulti.TasksState[1] == TSelectBox.State_Select);
         if(_loc2_ == 0)
         {
            _loc3_ = 0;
         }
         this.FUnstreamizer.ResetReq(this.FHero.Identifier,_loc2_,_loc3_,_loc4_);
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
         this.FRefineSoulStoneTotal = TUtilityLobby.GetArticleQuantity(this.FData.ConfigValueVO.RefineSoulStoneCost.code,this.FData.ConfigValueVO.RefineSoulStoneCost.type);
         this.FSoulStoneTotal = TUtilityLobby.GetArticleQuantity(this.FData.ConfigValueVO.SoulStoneCost.code,this.FData.ConfigValueVO.SoulStoneCost.type);
         this.FCurRebirthHeroCom.UpdateUI();
         this.UpdateIcons();
         this.UpdatePropAttack();
         this.UpdateUIByBox();
      }
   }
}

